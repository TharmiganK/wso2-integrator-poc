import ballerina/data.xmldata;

type EDI_DC40 record {
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

type IDOC record {
    EDI_DC40 EDI_DC40;
    E1KNA1M E1KNA1M;
    @xmldata:Attribute
    string BEGIN = "1";
};

type DEBMAS06 record {
    IDOC IDOC;
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
