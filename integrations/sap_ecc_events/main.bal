import ballerina/data.xmldata;
import ballerina/log;
import ballerinax/metrics.logs as _;
import ballerinax/sap.jco;

import wso2/icp.runtime.bridge as _;

listener jco:Listener sapListener = new (sapConfig);

service jco:IDocService on sapListener {

    remote function onReceive(xml iDoc) returns error? {
        do {
            if iDoc.length() < 2 {
                log:printWarn("received empty IDoc, skipping");
                return;
            }
            xml iDocElement = iDoc.get(1);
            if iDocElement !is xml:Element {
                log:printWarn("received invalid IDoc format, skipping");
                return;
            }
            string idocType = iDocElement.getName();
            if idocType != "ORDERS05" {
                log:printWarn("received unsupported IDoc type, skipping", idocType = idocType);
                return;
            }
            ORDERS05 order05 = check xmldata:parseAsType(iDoc);
            string poNumber = order05.IDOC.E1EDK01.BELNR ?: "<unknown>";
            int lineCount = order05.IDOC.E1EDP01.length();
            log:printInfo("received purchase order", poNumber = poNumber, lineCount = lineCount, sender = order05.IDOC.EDI_DC40.SNDPRN);
            return;
        } on fail error e {
            log:printError("error occurred while processing the IDoc", 'error = e);
            return e;
        }
    }

    remote function onError(error err) returns error? {
        do {
            log:printError("Error occurred", 'error = err, errorType = (typeof err).toString());
            return;
        } on fail error e {
            log:printError("error occurred while processing the IDoc", 'error = e);
            return e;
        }
    }
}

service jco:RfcService on sapListener {

    remote function onCall(string functionName, jco:RfcParameters parameters) returns jco:RfcRecord|error? {
        do {
            log:printInfo("RFC call received", functionName = functionName, importParams = parameters.importParameters, tableParams = parameters.tableParameters);
            if functionName != "STFC_CONNECTION" {
                return error(string `Unsupported function module: ${functionName}`);
            }
            jco:RfcRecord imports = parameters.importParameters ?: {};
            string requestText = imports.get("REQUTEXT").toString();
            return {
                "ECHOTEXT": requestText,
                "RESPTEXT": "Responded by Integrator"
            };
        } on fail error e {
            log:printError("error occurred while executing RFC", 'error = e, functionName = functionName);
            return e;
        }
    }

    remote function onError(error err) returns error? {
        do {
            log:printError("Error occurred", 'error = err, errorType = (typeof err).toString());
            return;
        } on fail error e {
            log:printError("error occurred while executing RFC", 'error = e);
            return e;
        }
    }
}
