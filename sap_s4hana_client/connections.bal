import ballerinax/sap.s4hana.api_sales_order_srv as salesOrder;

final salesOrder:Client sapSalesOrderClient = check new ({
    auth: {
        username: sapUserName,
        password: sapPassword
    }
}, sapHostName);
