
function toE1EDP01(OrderLineItem[] items) returns E1EDP01[] => from var itemsItem in items
    select {POSEX: itemsItem.id, MENGE: itemsItem.quantity, E1EDP19: {IDTNR: itemsItem.materialNumber}, MENEE: itemsItem.unit};


function toORDERS05(OrderCreateReq req, E1EDP01[] items) returns ORDERS05 => {
    IDOC: {
        EDI_DC40: idocControlRecord,
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
