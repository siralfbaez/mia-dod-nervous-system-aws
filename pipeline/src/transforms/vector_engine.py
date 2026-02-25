import boto3
import json

class Vectorizer:
    def __init__(self):
        self.bedrock = boto3.client(service_name='bedrock-runtime')

    def generate_embeddings(self, record):
        """
        Converts telemetry text into a 1536-dimension vector
        using Amazon Titan or OpenAI.
        """
        # Extract content to vectorize
        content = record.get("payload", "empty_telemetry")

        # Call Bedrock (AWS Native) for embeddings
        body = json.dumps({"inputText": content})
        response = self.bedrock.invoke_model(
            body=body,
            modelId="amazon.titan-embed-text-v1"
        )

        response_body = json.loads(response.get('body').read())
        record["embedding"] = response_body.get('embedding')

        return record