import ballerina/time;

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
