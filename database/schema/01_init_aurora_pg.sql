-- 1. Enable the Vector Extension (The "Brain" Upgrade)
CREATE EXTENSION IF NOT EXISTS vector;

-- 2. Create the Telemetry Schema
CREATE SCHEMA IF NOT EXISTS nervous_system;

-- 3. The Core Recall Table (Agentic Memory)
CREATE TABLE IF NOT EXISTS nervous_system.telemetry_vectors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    source_id VARCHAR(255) NOT NULL,          -- e.g., 'sensor-alpha'
    payload JSONB NOT NULL,                   -- The raw telemetry data
    embedding VECTOR(1536),                   -- 1536 for OpenAI / Titan embeddings
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB                            -- Tags, compliance levels, etc.
);

-- 4. HNSW Index for Sub-second Search (The "ScaNN" equivalent)
-- m=16, ef_construction=64 provides a balance of speed and precision
CREATE INDEX ON nervous_system.telemetry_vectors
USING hnsw (embedding vector_l2_ops)
WITH (m = 16, ef_construction = 64);

-- 5. Audit Trigger (Treasury Requirement)
-- Ensures we track when memory is accessed or modified
COMMENT ON TABLE nervous_system.telemetry_vectors IS 'Stores vectorized telemetry for agentic reasoning and recall.';