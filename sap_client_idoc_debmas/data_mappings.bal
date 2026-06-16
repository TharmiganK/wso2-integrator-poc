
function toDEBMAS(CustomerCreateReq req) returns DEBMAS06 => {
    IDOC: {
        EDI_DC40: idocControlRecord,
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
