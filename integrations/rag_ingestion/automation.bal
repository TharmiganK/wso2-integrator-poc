import ballerina/ai;
import ballerina/log;

public function main() returns error? {
    do {
        ai:Document[]|ai:Document aiDocumentAiDocument = check sharepointTextdataloader.load();
        log:printInfo("data loaded successfully");
        check azureAisearchknowledgebase.ingest(aiDocumentAiDocument);
        log:printInfo("data ingested successfully");
    } on fail error e {
        return e;
    }
}
