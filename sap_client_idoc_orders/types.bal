import ballerina/data.xmldata;

type EDI_DC40 record {
    string TABNAM = "EDI_DC40";
    string MANDT = "100";
    string DIRECT = "2";
    string IDOCTYP = "ORDERS05";
    string MESTYP = "ORDERS";
    string SNDPOR = "SAPDEV";
    string SNDPRT = "LS";
    string SNDPRN;
    string RCVPOR = "SAPDEV";
    string RCVPRT = "LS";
    string RCVPRN;
    @xmldata:Attribute
    string SEGMENT = "1";
};

// ── ORDERS05 IDoc types ──────────────────────────────────────────────────────

type E1EDK01 record {
    string BSART;           // Order type (e.g. "OR" for standard order)
    string CURCY = "USD";   // Currency
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDKA1 record {
    string PARVW;   // Partner role: AG=sold-to, WE=ship-to
    string PARTN;   // Partner number
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDK14 record {
    string QUALF;   // 001=VKORG, 002=VTWEG, 003=SPART
    string ORGID;   // Organizational unit value
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDP19 record {
    string QUALF = "002";   // 002 = SAP internal material number
    string IDTNR;           // Material number
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDP01 record {
    string POSEX;           // Item number (zero-padded, e.g. "000010")
    string MENGE;           // Quantity
    string MENEE = "EA";    // Unit of measure
    E1EDP19 E1EDP19;
    @xmldata:Attribute
    string SEGMENT = "1";
};

type ORDERS05_IDOC record {
    EDI_DC40 EDI_DC40;
    E1EDK01 E1EDK01;
    E1EDK14[] E1EDK14;
    E1EDKA1[] E1EDKA1;
    E1EDP01[] E1EDP01;
    @xmldata:Attribute
    string BEGIN = "1";
};

type ORDERS05 record {
    ORDERS05_IDOC IDOC;
};

// ── ORDERS05 HTTP request types ──────────────────────────────────────────────

public type OrderLineItem record {|
    string id;
    string materialNumber;
    string quantity;
    string unit = "EA";
|};

public type OrderCreateReq record {|
    string orderType;
    string salesOrg;
    string distributionChannel;
    string division;
    string soldToParty;
    string shipToParty;
    string currency = "USD";
    OrderLineItem[] items;
|};
