import ballerina/http;
import ballerina/log;
import ballerina/random;
import ballerinax/sap.s4hana.api_sales_order_srv as salesOrder;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /sap on httpDefaultListener {
    resource function post sales\-orders(@http:Payload SalesOrderRequest payload) returns SalesOrderResponse|http:InternalServerError {
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
