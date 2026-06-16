import ballerina/ai;
import ballerinax/ai.microsoft.sharepoint;
import ballerinax/ai.pinecone;

final sharepoint:TextDataLoader dataloader = check new ({
    auth: {
        clientId: sharepointClientId,
        clientSecret: sharepointClientSecret,
        tokenUrl: sharepointTokenUrl,
        scopes: sharepointClientScope
    }
}, [
    {
        siteId: sharepointSiteId,
        libraries: [
            {
                name: "Documents",
                paths: [
                    "ACME/HR/"
                ],
                includeExtensions: [
                    "pdf"
                ]
            }
        ]
    }
]);

final pinecone:VectorStore vectorStore = check new (string `${pineconeSvcUrl}`, string `${pineconeApiKey}`);
final ai:Wso2EmbeddingProvider embeddingProvider = check ai:getDefaultEmbeddingProvider();
final ai:VectorKnowledgeBase knowledgeBase = new (vectorStore, embeddingProvider, ai:AUTO);
