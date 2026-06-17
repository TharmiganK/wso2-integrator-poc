import ballerina/mcp;
import ballerina/sql;
import ballerinax/metrics.logs as _;

import wso2/icp.runtime.bridge as _;

listener mcp:Listener mcpListener = new (listenTo = 9092);

@mcp:ServiceConfig {
    info: {
        name: "MCP Service",
        version: "1.0.0"
    }
}
service mcp:Service /mcp on mcpListener {

    # "Returns the employee's identity, job, and organisational context including grade, department, manager, service length, and employment status"
    #
    # + empId - The logged-in employee's ID
    # + return - EmployeeProfile
    remote function getMyProfile(int empId) returns EmployeeProfile|error {
        EmployeeProfile employeeProfile = check oracleDb->queryRow(`SELECT emp_id, full_name, TO_CHAR(join_date, 'YYYY-MM-DD') AS join_date, emp_status, TO_CHAR(confirmed_date, 'YYYY-MM-DD') AS confirmed_date, job_title, grade, employment_type, manager_name, dept_name, work_email, mobile, years_of_service, months_of_service FROM v_employee_context WHERE emp_id = ${empId}`);
        return employeeProfile;
    }

    # "Returns the employee's current-year leave balances, recent leave request history, and the most recent month's payslip including salary components and cumulative EPF/ETF totals"
    #
    # + empId - The logged-in employee's ID
    # + return - LeaveAndPayslip
    remote function getLeaveAndPayslip(int empId) returns LeaveAndPayslip|error {
        stream<LeaveBalancesItem, sql:Error?> leaveBalancesStream = oracleDb->query(`SELECT leave_type, entitled_days, used_days, pending_days, carry_forward, balance_days FROM leave_balance WHERE emp_id = ${empId} AND year = EXTRACT(YEAR FROM SYSDATE) ORDER BY leave_type`);
        LeaveBalances leaveBalances = check from LeaveBalancesItem item in leaveBalancesStream
            select item;
        stream<LeaveRequestsItem, sql:Error?> leaveRequestsStream = oracleDb->query(`SELECT request_id, leave_type, TO_CHAR(start_date, 'YYYY-MM-DD') AS start_date, TO_CHAR(end_date, 'YYYY-MM-DD') AS end_date, days_count, status, reason FROM leave_request WHERE emp_id = ${empId} ORDER BY submitted_at DESC FETCH FIRST 10 ROWS ONLY`);
        LeaveRequests leaveRequests = check from LeaveRequestsItem item in leaveRequestsStream
            select item;
        LatestPayslip latestPayslip = check oracleDb->queryRow(`SELECT pay_year, pay_month, basic_salary, gross_salary, net_salary, transport_allowance, meal_allowance, mobile_allowance, epf_employee, epf_employer, etf_employer, tax_deduction, cumulative_epf_employee, cumulative_epf_employer, cumulative_etf FROM payroll WHERE emp_id = ${empId} ORDER BY pay_year DESC, pay_month DESC FETCH FIRST 1 ROW ONLY`);
        LeaveAndPayslip leaveAndPayslip = {leave_balances: leaveBalances, leave_requests: leaveRequests, latest_payslip: latestPayslip};
        return leaveAndPayslip;
    }

    # "Returns the employee's performance reviews from the current and previous year, all training records and certifications, and total L&D spend in the current calendar year"
    #
    # + empId - The logged-in employee's ID
    # + return - PerformanceAndTraining
    remote function getPerformanceAndTraining(int empId) returns PerformanceAndTraining|error {
        stream<PerformanceReviewItem, sql:Error?> reviewsStream = oracleDb->query(`SELECT review_year, review_cycle, rating, goals_summary, pip_active_flag, TO_CHAR(pip_start_date, 'YYYY-MM-DD') AS pip_start_date, TO_CHAR(pip_end_date, 'YYYY-MM-DD') AS pip_end_date, pip_outcome FROM performance WHERE emp_id = ${empId} AND review_year >= EXTRACT(YEAR FROM SYSDATE) - 1 ORDER BY review_year DESC, review_cycle DESC`);
        PerformanceReviews performanceReviews = check from PerformanceReviewItem item in reviewsStream
            select item;
        stream<TrainingRecordItem, sql:Error?> trainingStream = oracleDb->query(`SELECT course_name, provider, TO_CHAR(completion_date, 'YYYY-MM-DD') AS completion_date, cert_name, TO_CHAR(cert_expiry, 'YYYY-MM-DD') AS cert_expiry, ld_spend, year, status FROM training WHERE emp_id = ${empId} ORDER BY completion_date DESC NULLS LAST`);
        TrainingRecords trainingRecords = check from TrainingRecordItem item in trainingStream
            select item;
        LDRow ldRow = check oracleDb->queryRow(`SELECT NVL(SUM(ld_spend), 0) AS ld_spent_this_year FROM training WHERE emp_id = ${empId} AND year = EXTRACT(YEAR FROM SYSDATE)`);
        PerformanceAndTraining performanceAndTraining = {performance_reviews: performanceReviews, training_records: trainingRecords, ld_spent_this_year: ldRow.ld_spent_this_year};
        return performanceAndTraining;
    }

    # "Submits a new leave request or cancels an existing pending request. Call only after explicit user confirmation"
    #
    # + empId - The logged-in employee's ID
    # + action - SUBMIT or CANCEL
    # + leave_type - Leave type e.g. ANNUAL, SICK (required for SUBMIT)
    # + start_date - Start date in YYYY-MM-DD format (required for SUBMIT)
    # + end_date - End date in YYYY-MM-DD format (required for SUBMIT)
    # + days_count - Number of days being requested (required for SUBMIT)
    # + reason - Reason for leave (required for SUBMIT)
    # + request_id - Existing request ID to cancel (required for CANCEL)
    # + return - LeaveActionResult
    remote function submitOrCancelLeave(int empId, string action, string? leave_type = (), string? start_date = (), string? end_date = (), decimal? days_count = (), string? reason = (), int? request_id = ()) returns LeaveActionResult|error {
        if action == "SUBMIT" {
            if leave_type is () || start_date is () || end_date is () || days_count is () {
                LeaveActionResult missingParams = {status: "MISSING_PARAMS", message: "leave_type, start_date, end_date, and days_count are required for SUBMIT", request_id: ()};
                return missingParams;
            }
            record {decimal balance_days;}|error balanceRow = oracleDb->queryRow(`SELECT balance_days FROM leave_balance WHERE emp_id = ${empId} AND leave_type = ${leave_type} AND year = EXTRACT(YEAR FROM TO_DATE(${start_date}, 'YYYY-MM-DD'))`);
            if balanceRow is error || balanceRow.balance_days < days_count {
                decimal available = balanceRow is error ? 0d : balanceRow.balance_days;
                LeaveActionResult insufficientBalance = {status: "INSUFFICIENT_BALANCE", message: string `You only have ${available} ${leave_type} leave days remaining but requested ${days_count}.`, request_id: ()};
                return insufficientBalance;
            }
            _ = check oracleDb->execute(`INSERT INTO leave_request (emp_id, leave_type, start_date, end_date, days_count, reason, status, submitted_at) VALUES (${empId}, ${leave_type}, TO_DATE(${start_date}, 'YYYY-MM-DD'), TO_DATE(${end_date}, 'YYYY-MM-DD'), ${days_count}, ${reason}, 'PENDING', SYSTIMESTAMP)`);
            _ = check oracleDb->execute(`UPDATE leave_balance SET pending_days = pending_days + ${days_count} WHERE emp_id = ${empId} AND leave_type = ${leave_type} AND year = EXTRACT(YEAR FROM TO_DATE(${start_date}, 'YYYY-MM-DD'))`);
            record {int request_id;} newReq = check oracleDb->queryRow(`SELECT request_id FROM leave_request WHERE emp_id = ${empId} ORDER BY request_id DESC FETCH FIRST 1 ROW ONLY`);
            return {status: "OK", message: "Leave request submitted successfully.", request_id: newReq.request_id};
        } else if action == "CANCEL" {
            if request_id is () {
                LeaveActionResult missingParams = {status: "MISSING_PARAMS", message: "request_id is required for CANCEL", request_id: ()};
                return missingParams;
            }
            record {string leave_type; decimal days_count; string start_date;}|error reqRow = oracleDb->queryRow(`SELECT leave_type, days_count, TO_CHAR(start_date, 'YYYY-MM-DD') AS start_date FROM leave_request WHERE request_id = ${request_id} AND emp_id = ${empId} AND status = 'PENDING'`);
            if reqRow is error {
                LeaveActionResult notFound = {status: "NOT_FOUND", message: "No pending leave request found with the given ID.", request_id: ()};
                return notFound;
            }
            _ = check oracleDb->execute(`UPDATE leave_request SET status = 'CANCELLED' WHERE request_id = ${request_id} AND emp_id = ${empId} AND status = 'PENDING'`);
            _ = check oracleDb->execute(`UPDATE leave_balance SET pending_days = pending_days - ${reqRow.days_count} WHERE emp_id = ${empId} AND leave_type = ${reqRow.leave_type} AND year = EXTRACT(YEAR FROM TO_DATE(${reqRow.start_date}, 'YYYY-MM-DD'))`);
            LeaveActionResult success = {status: "OK", message: string `Leave request ${request_id} has been cancelled.`, request_id: ()};
            return success;
        }
        LeaveActionResult invalidAction = {status: "INVALID_ACTION", message: "Action must be SUBMIT or CANCEL.", request_id: ()};
        return invalidAction;
    }

}
