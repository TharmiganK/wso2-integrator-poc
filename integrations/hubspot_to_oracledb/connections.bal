import ballerinax/hubspot.crm.obj.contacts as contacts;
import ballerinax/oracledb;
import ballerinax/oracledb.driver as _;

final oracledb:Client oracleDb = check new (string `${oracleDbHost}`, string `${oracleDbUser}`, string `${oracleDbPassword}`, string `${oracleDbName}`, oracleDbPort);

final contacts:Client hubspotContacts = check new ({auth: {token: hubspotToken}});

