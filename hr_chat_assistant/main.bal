import ballerina/ai;
import ballerina/http;
import ballerinax/metrics.logs as _;

import wso2/icp.runtime.bridge as _;

listener http:Listener chatAgentListener = http:getDefaultListener();

service /chatAssistant on chatAgentListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request, @http:Header int user) returns ai:ChatRespMessage|error {
        ai:Context ctx = new;
        ctx.set("User", user);
        string stringResult = check chatAssistantAgent.run(request.message, request.sessionId, ctx);
        return {message: stringResult};
    }
}
