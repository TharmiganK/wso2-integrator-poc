import ballerinax/sap.jco;
import ballerinax/sap.s4hana.api_sales_order_srv as salesOrder;

final jco:Client sapEccClient = check new (<jco:DestinationConfig>{
    ashost: sapEccHost,
    sysnr: sapEccSysnr,
    jcoClient: sapEccClientNum,
    user: sapEccUser,
    passwd: sapEccPasswd
});

final salesOrder:Client sapSalesOrderClient = check new ({
    auth: {
        username: sapS4hanaUserName,
        password: sapS4hanaPassword
    }
}, sapS4hanaHostName);
