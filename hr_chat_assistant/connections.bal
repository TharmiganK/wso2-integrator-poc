import ballerina/ai;
import ballerinax/ai.pinecone;

final ai:Wso2ModelProvider wso2ModelProvider = check ai:getDefaultModelProvider();
final McpServerToolkit mcpServer = check new (string `${mcpServerURL}`);
final pinecone:VectorStore vectorStore = check new (string `${pineconeSvcURL}`, string `${pineconeAPIKey}`);
final ai:Wso2EmbeddingProvider embeddingProvider = check ai:getDefaultEmbeddingProvider();
final ai:VectorKnowledgeBase knowledgeBase = new (vectorStore, embeddingProvider, ai:AUTO);

