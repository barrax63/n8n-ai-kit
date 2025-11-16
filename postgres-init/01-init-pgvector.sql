-- Enable pgvector extension for vector operations
-- This must be run as a superuser (postgres)

-- Create extension in the n8n database
\c n8n;
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify installation
SELECT extname, extversion FROM pg_extension WHERE extname = 'vector';