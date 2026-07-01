import ballerina/ai;
import ballerinax/ai.azure;

final azure:OpenAiModelProvider azureOpenaimodelprovider = check new (azureOpenAiServiceUrl, azureOpenAiApiKey, azureOpenAiDeploymentId, azureOpenAiApiVersion);
final azure:EmbeddingProvider azureEmbeddingprovider = check new (azureEmbeddingServiceUrl, azureEmbeddingApiKey, azureEmbeddingApiVersion, azureEmbeddingDeploymentId);
final azure:AiSearchKnowledgeBase azureAisearchknowledgebase = check new (azureAiSearchServiceUrl, azureAiSearchApiKey, azureAiSearchIndexName, azureEmbeddingprovider, ai:AUTO, true);
