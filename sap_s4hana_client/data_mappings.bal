import ballerinax/sap.s4hana.api_sales_order_srv;

function toSapLineItem(SalesOrderLineItem[] items) returns api_sales_order_srv:CreateA_SalesOrderItem[] => from var item in items
    select {
        SalesOrderItem: item.itemNumber,
        Material: item.materialCode,
        SalesOrderItemText: item.description,
        RequestedQuantity: item.quantity,
        RequestedQuantityUnit: item.quantityUnit,
        SalesOrderItemCategory: item.itemCategory,
        ProductionPlant: item.plant
    };

function toSapCreateRequest(SalesOrderRequest req, api_sales_order_srv:CreateA_SalesOrderItem[] items, string salesOrderId) returns api_sales_order_srv:CreateA_SalesOrder => {
    SalesOrder: salesOrderId,
    SalesOrderType: req.orderType,
    SalesOrganization: req.salesOrganization,
    DistributionChannel: req.distributionChannel,
    OrganizationDivision: req.division,
    SoldToParty: req.soldToParty,
    PurchaseOrderByCustomer: req.customerPurchaseOrder,
    RequestedDeliveryDate: req.requestedDeliveryDate,
    TransactionCurrency: req.currency,
    CustomerPaymentTerms: req.paymentTerms,
    to_Item: {
        results: items
    }
};

