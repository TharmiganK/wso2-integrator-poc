import ballerina/http;
import ballerina/log;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /sap on httpDefaultListener {

    resource function get employees/[string employeeId]/leaves(string dateFrom = "18000101", string dateTo = "99991231", string absenceType = "0100")
            returns Result|http:InternalServerError {
        do {
            log:printInfo("getting leave details", employeeId = employeeId, dateFrom = dateFrom, dateTo = dateTo, absenceType = absenceType);
            Result result = check sapEccClient->execute("BAPI_ABSENCE_GETDETAILEDLIST", {
                importParameters: {
                    "EMPLOYEENUMBER": employeeId,
                    "SUBTYPE": absenceType,
                    "TIMEINTERVALLOW": dateFrom,
                    "TIMEINTERVALHIGH": dateTo
                }
            });
            return result;
        } on fail error err {
            log:printError("RFC connection failure on BAPI_ABSENCE_GETDETAILEDLIST", err);
            return {
                body: {
                    "msg": "RFC connection failure",
                    "reason": err.message()
                }
            };
        }
    }
}
