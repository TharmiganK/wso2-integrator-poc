import ballerina/data.xmldata;
import ballerina/http;
import ballerina/log;
import ballerina/random;
import ballerinax/metrics.logs as _;
import ballerinax/sap.s4hana.api_sales_order_srv as salesOrder;

import wso2/icp.runtime.bridge as _;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /sap on httpDefaultListener {

    resource function get ecc/employees/[string employeeId]/leaves(string dateFrom = "18000101", string dateTo = "99991231", string absenceType = "0100")
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

    resource function post ecc/cutomers(@http:Payload CustomerCreateReq req) returns http:Accepted|http:InternalServerError {
        do {
            DEBMAS06 idoc = toDEBMAS(req);
            xml idocXml = check xmldata:toXml(idoc);
            check sapEccClient->sendIDoc(idocXml);
            return http:ACCEPTED;
        } on fail error err {
            log:printError("Error occurred while processing the request", err);
            return <http:InternalServerError>{
                body: {
                    "message": "An error occurred while processing the request. Please try again later.",
                    "reason": err.message()
                }
            };
        }
    }

    resource function post ecc/orders(@http:Payload OrderCreateReq req) returns http:Accepted|http:InternalServerError {
        do {
            E1EDP01[] orderItems = toE1EDP01(req.items);
            ORDERS05 idoc = toORDERS05(req, orderItems);
            xml idocXml = check xmldata:toXml(idoc);
            check sapEccClient->sendIDoc(idocXml);
            return http:ACCEPTED;
        } on fail error err {
            log:printError("Error occurred while processing the request", err);
            return <http:InternalServerError>{
                body: {
                    "message": "An error occurred while processing the request. Please try again later.",
                    "reason": err.message()
                }
            };
        }
    }

    resource function post s4hana/sales\-orders(@http:Payload SalesOrderRequest payload) returns SalesOrderResponse|http:InternalServerError {
        do {
            salesOrder:CreateA_SalesOrderItem[] items = toSapLineItem(payload.items);
            int salesOrderId = check random:createIntInRange(5000000, 5999999);
            salesOrder:CreateA_SalesOrder salesOrderReq = toSapCreateRequest(payload, items, salesOrderId.toString());
            salesOrder:A_SalesOrderWrapper result = check sapSalesOrderClient->createA_SalesOrder(salesOrderReq);
            salesOrder:A_SalesOrder? salesOrderRes = result.d;
            if salesOrderRes is () {
                return {
                    body: {
                        "message": "Error occurred while creating the sales order",
                        "reason": "empty response received from server"
                    }
                };
            }
            SalesOrderResponse salesOrderResponse = {
                salesOrderId: salesOrderRes.SalesOrder ?: "",
                totalNetAmount: salesOrderRes?.TotalNetAmount,
                currency: salesOrderRes?.TransactionCurrency
            };
            return salesOrderResponse;
        } on fail error err {
            log:printError("error occurred while creating the sales order", err);
            return {
                body: {
                    "message": "Error occurred while creating the sales order",
                    "reason": err.message()
                }
            };
        }
    }
}
