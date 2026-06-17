import ballerinax/oracledb;
import ballerinax/oracledb.driver as _;

final oracledb:Client oracleDb = check new (string `${oracleDbHost}`, string `${oracleDbUser}`, string `${oracleDbPassword}`, string `${oracleDbName}`, oracleDbPort);
