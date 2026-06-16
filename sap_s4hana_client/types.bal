
public type SalesOrderLineItem record {|
    string itemNumber;
    string materialCode;
    string quantity?;
    string quantityUnit?;
    string description?;
    string itemCategory?;
    string plant?;
|};

public type SalesOrderRequest record {|
    string orderType;
    string salesOrganization;
    string distributionChannel?;
    string division?;
    string soldToParty;
    string customerPurchaseOrder?;
    string requestedDeliveryDate?;
    string currency?;
    string paymentTerms?;
    SalesOrderLineItem[] items;
|};

public type SalesOrderResponse record {|
    string salesOrderId?;
    string totalNetAmount?;
    string currency?;
|};
