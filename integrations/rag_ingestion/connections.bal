import ballerina/ai;
import ballerinax/ai.azure;
import ballerinax/ai.microsoft.sharepoint;
import ballerinax/azure.ai.search;

final search:SearchIndex hrAssistantIndex = {
    name: "hr-assistant",
    fields: [
        {
            name: "id",
            'type: "Edm.String",
            'key: true,
            filterable: true
        },
        {
            name: "content",
            'type: "Edm.String",
            searchable: true
        },
        {
            name: "contentVector",
            'type: "Collection(Edm.Single)",
            dimensions: 1536,
            searchable: true,
            retrievable: true,
            vectorSearchProfile: "hr-vector-profile"
        }
    ],
    vectorSearch: {
        algorithms: [
            {
                "name": "hr-hnsw-algo",
                "kind": "hnsw",
                "hnswParameters": {
                "m": 4,
                "efConstruction": 400,
                "efSearch": 500,
                "metric": "cosine"
                }
            }
            ],
            profiles: [
            {
                "name": "hr-vector-profile",
                "algorithm": "hr-hnsw-algo"
            }
        ]
    }
};

final azure:EmbeddingProvider azureEmbeddingprovider = check new (azureEmbeddingServiceUrl, azureEmbeddingApiKey, azureEmbeddingApiVersion, azureEmbeddingDeploymentId);
final azure:AiSearchKnowledgeBase azureAisearchknowledgebase = check new (azureAiSearchServiceUrl, azureAiSearchApiKey, hrAssistantIndex, azureEmbeddingprovider, ai:AUTO);

final sharepoint:TextDataLoader sharepointTextdataloader = check new ({
    auth: {
        tokenUrl: sharepointTokenUrl,
        clientId: sharepointClientId,
        clientSecret: sharepointClientSecret,
        scopes: [sharepointClientScope]
    }
}, [
    {
        siteId: sharepointSiteId,
        pages: ["HR-Page.aspx"]
    }
]);
