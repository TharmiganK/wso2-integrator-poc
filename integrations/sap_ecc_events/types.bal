type EDI_DC40 record {|
    string SNDPRT?;
    string SNDPRN?;
    string RCVPRT?;
    string RCVPRN?;
    string IDOCTYP?;
    string MESTYP?;
    string DOCNUM?;
|};

type E1EDK01 record {|
    string BELNR?; 
    string CURCY?;
    string BSART?;
|};

type E1EDP01 record {|
    string POSEX?;
    string MENGE?;
    string MATNR?;
    string PSTYP?;
|};

type IDOC record {|
    EDI_DC40 EDI_DC40;
    E1EDK01 E1EDK01;
    E1EDP01[] E1EDP01;
|};

type ORDERS05 record {|
    IDOC IDOC;
|};

