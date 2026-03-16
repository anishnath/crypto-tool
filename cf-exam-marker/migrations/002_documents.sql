-- Migration 002: Generic documents table (math, chemistry, etc.)
-- Stores metadata only; content lives in R2

CREATE TABLE IF NOT EXISTS documents (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    doc_type TEXT NOT NULL DEFAULT 'generic',
    title TEXT NOT NULL DEFAULT 'Untitled',
    visibility TEXT NOT NULL DEFAULT 'private',
    r2_key TEXT NOT NULL,
    content_type TEXT NOT NULL DEFAULT 'html',
    edit_token_hash TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_documents_user ON documents(user_id);
CREATE INDEX IF NOT EXISTS idx_documents_type ON documents(doc_type);
CREATE INDEX IF NOT EXISTS idx_documents_visibility ON documents(visibility);
CREATE INDEX IF NOT EXISTS idx_documents_updated ON documents(updated_at DESC);
