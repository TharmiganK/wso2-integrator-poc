
public type EmployeeProfile record {|
    int emp_id;
    string full_name;
    string join_date;
    string emp_status;
    string confirmed_date?;
    string job_title;
    string grade;
    string employment_type;
    string manager_name?;
    string dept_name;
    string work_email;
    string mobile?;
    int years_of_service;
    int months_of_service;
|};

public type LeaveBalancesItem record {|
    string leave_type;
    int entitled_days;
    int used_days;
    int pending_days;
    int carry_forward;
    int balance_days;
|};

public type LeaveBalances LeaveBalancesItem[];

public type LeaveRequestsItem record {|
    int request_id;
    string leave_type;
    string start_date;
    string end_date;
    int days_count;
    string status;
    string? reason;
|};

public type LeaveRequests LeaveRequestsItem[];

public type LatestPayslip record {|
    int pay_year;
    int pay_month;
    int basic_salary;
    int gross_salary;
    int net_salary;
    int transport_allowance;
    int meal_allowance;
    int mobile_allowance;
    int epf_employee;
    int epf_employer;
    int etf_employer;
    int tax_deduction;
    int cumulative_epf_employee;
    int cumulative_epf_employer;
    int cumulative_etf;
|};

public type LeaveAndPayslip record {|
    LeaveBalances leave_balances;
    LeaveRequests leave_requests;
    LatestPayslip latest_payslip;
|};

public type LDRow record {|
    decimal ld_spent_this_year;
|};

public type PerformanceReviewItem record {|
    int review_year;
    string review_cycle;
    decimal? rating;
    string? goals_summary;
    string pip_active_flag;
    string? pip_start_date;
    string? pip_end_date;
    string? pip_outcome;
|};

public type PerformanceReviews PerformanceReviewItem[];

public type TrainingRecordItem record {|
    string course_name;
    string? provider;
    string? completion_date;
    string? cert_name;
    string? cert_expiry;
    decimal ld_spend;
    int year;
    string status;
|};

public type TrainingRecords TrainingRecordItem[];

public type PerformanceAndTraining record {|
    PerformanceReviews performance_reviews;
    TrainingRecords training_records;
    decimal ld_spent_this_year;
|};

public type LeaveActionResult record {|
    string status;
    string message;
    int? request_id;
|};
