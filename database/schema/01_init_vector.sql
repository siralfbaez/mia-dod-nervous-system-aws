-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create schema for the Nervous System
CREATE SCHEMA IF NOT EXISTS nervous_system;

-- Table for vectorized telemetry
CREATE TABLE IF NOT EXISTS nervous_system.telemetry_vectors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_id VARCHAR(255),
    payload JSONB,
    embedding vector(1536), -- Dimension for OpenAI/Titan
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- HNSW Index for sub-second retrieval
CREATE INDEX ON nervous_system.telemetry_vectors
USING hnsw (embedding vector_l2_ops);