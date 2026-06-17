import ballerina/ai;
import ballerina/log;

public function main() returns error? {
    do {
        ai:Document[]|ai:Document aiDocument = check dataloader.load();
        check knowledgeBase.ingest(aiDocument);
        log:printInfo("data ingested successfully");
    } on fail error e {
        log:printError("Error occurred", 'error = e);
        return e;
    }
}
