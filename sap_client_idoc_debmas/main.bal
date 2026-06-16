import ballerina/data.xmldata;
import ballerina/http;
import ballerina/log;

listener http:Listener httpDefaultListener = http:getDefaultListener();

service /sap on httpDefaultListener {

    resource function post cutomers(@http:Payload CustomerCreateReq req) returns http:Accepted|http:InternalServerError {
        do {
            DEBMAS06 idoc = toDEBMAS(req);
            xml idocXml = check xmldata:toXml(idoc);
            check sapEccClient->sendIDoc(idocXml);
            return http:ACCEPTED;
        } on fail error err {
            log:printError("Error occurred while processing the request", err);
            return <http:InternalServerError>{
                body: {
                    "message": "An error occurred while processing the request. Please try again later.",
                    "reason": err.message()
                }
            };
        }
    }
}
