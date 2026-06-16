import ballerinax/sap.jco;

final jco:Client sapEccClient = check new (<jco:DestinationConfig>{
    ashost: sapHost,
    sysnr: sapSysnr,
    jcoClient: sapClient,
    user: sapUser,
    passwd: sapPasswd
});
