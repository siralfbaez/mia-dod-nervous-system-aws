import pytest
from transforms.vector_engine import Vectorizer

def test_vector_dimension_match():
    v = Vectorizer()
    # Mock record
    sample_record = {"payload": "Anomaly detected in sector 7G"}

    # In a real test, we would mock the boto3 client
    result = v.generate_embeddings(sample_record)

    assert "embedding" in result
    assert len(result["embedding"]) == 1536  # Standard Titan/OpenAI length