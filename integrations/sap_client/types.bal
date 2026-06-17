import ballerina/data.xmldata;
import ballerina/time;

// ── BAPI types ───────────────────────────────────────────────────────────────

public type RETURN record {|
    string TYPE;
    string ID;
    string NUMBER;
    string MESSAGE;
    string LOG_NO;
    string LOG_MSG_NO;
    string MESSAGE_V1;
    string MESSAGE_V2;
    string MESSAGE_V3;
    string MESSAGE_V4;
|};

public type Absense record {|
    string EMPLOYEENO;
    string SUBTYPE;
    time:Date VALIDEND;
    time:Date VALIDBEGIN;
    string ABSENCETYPE;
    string NAMEOFABSENCETYPE;
    decimal ABSENCEDAYS;
    decimal ABSENCEHOURS;
|};

public type Result record {|
    RETURN RETURN;
    Absense[] ABSENCE;
|};

// ── DEBMAS06 IDoc types ──────────────────────────────────────────────────────

type DEBMAS_EDI_DC40 record {
    string TABNAM = "EDI_DC40";
    string MANDT = "100";
    string DIRECT = "2";
    string IDOCTYP = "DEBMAS06";
    string MESTYP = "DEBMAS";
    string SNDPOR = "SAPDEV";
    string SNDPRT = "LS";
    string SNDPRN;
    string RCVPOR = "SAPDEV";
    string RCVPRT = "LS";
    string RCVPRN;
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1KNA1M record {
    string MSGFN = "001";
    string KUNNR;
    string KTOKD;
    string NAME1;
    string LAND1;
    string ORT01;
    string PSTLZ;
    string STRAS;
    string SPRAS = "E";
    @xmldata:Attribute
    string SEGMENT = "1";
};

type DEBMAS06_IDOC record {
    DEBMAS_EDI_DC40 EDI_DC40;
    E1KNA1M E1KNA1M;
    @xmldata:Attribute
    string BEGIN = "1";
};

type DEBMAS06 record {
    DEBMAS06_IDOC IDOC;
};

public type CustomerCreateReq record {|
    string customerNumber;
    string name;
    string accountGroup;
    string country;
    string city;
    string postalCode;
    string street;
|};

// ── ORDERS05 IDoc types ──────────────────────────────────────────────────────

type ORDERS_EDI_DC40 record {
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

type E1EDK01 record {
    string BSART;
    string CURCY = "USD";
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDKA1 record {
    string PARVW;
    string PARTN;
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDK14 record {
    string QUALF;
    string ORGID;
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDP19 record {
    string QUALF = "002";
    string IDTNR;
    @xmldata:Attribute
    string SEGMENT = "1";
};

type E1EDP01 record {
    string POSEX;
    string MENGE;
    string MENEE = "EA";
    E1EDP19 E1EDP19;
    @xmldata:Attribute
    string SEGMENT = "1";
};

type ORDERS05_IDOC record {
    ORDERS_EDI_DC40 EDI_DC40;
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

// ── S/4HANA types ────────────────────────────────────────────────────────────

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
