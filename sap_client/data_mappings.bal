import ballerinax/sap.s4hana.api_sales_order_srv;

function toDEBMAS(CustomerCreateReq req) returns DEBMAS06 => {
    IDOC: {
        EDI_DC40: idocDebmasControlRecord,
        E1KNA1M: {
            KUNNR: req.customerNumber,
            NAME1: req.name,
            KTOKD: req.accountGroup,
            LAND1: req.country,
            ORT01: req.city,
            PSTLZ: req.postalCode,
            STRAS: req.street
        }
    }
};

function toE1EDP01(OrderLineItem[] items) returns E1EDP01[] => from var itemsItem in items
    select {POSEX: itemsItem.id, MENGE: itemsItem.quantity, E1EDP19: {IDTNR: itemsItem.materialNumber}, MENEE: itemsItem.unit};

function toORDERS05(OrderCreateReq req, E1EDP01[] items) returns ORDERS05 => {
    IDOC: {
        EDI_DC40: idocOrdersControlRecord,
        E1EDK01: {BSART: req.orderType, CURCY: req.currency},
        E1EDK14: [
            {QUALF: "001", ORGID: req.salesOrg},
            {QUALF: "002", ORGID: req.distributionChannel},
            {QUALF: "003", ORGID: req.division}
        ],
        E1EDKA1: [
            {PARVW: "AG", PARTN: req.soldToParty},
            {PARVW: "WE", PARTN: req.shipToParty}
        ],
        E1EDP01: items
    }
};

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
