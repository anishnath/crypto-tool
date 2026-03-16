-- Migration 003: Remove FK on documents.user_id (user_id is opaque, may not exist in users)
-- SQLite: recreate table without FK

PRAGMA foreign_keys = OFF;

CREATE TABLE IF NOT EXISTS documents_new (
    id TEXT PRIMARY KEY,
    user_id TEXT,
    doc_type TEXT NOT NULL DEFAULT 'generic',
    title TEXT NOT NULL DEFAULT 'Untitled',
    visibility TEXT NOT NULL DEFAULT 'private',
    r2_key TEXT NOT NULL,
    content_type TEXT NOT NULL DEFAULT 'html',
    edit_token_hash TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

INSERT INTO documents_new SELECT id, user_id, doc_type, title, visibility, r2_key, content_type, edit_token_hash, created_at, updated_at FROM documents;
DROP TABLE documents;
ALTER TABLE documents_new RENAME TO documents;

CREATE INDEX IF NOT EXISTS idx_documents_user ON documents(user_id);
CREATE INDEX IF NOT EXISTS idx_documents_type ON documents(doc_type);
CREATE INDEX IF NOT EXISTS idx_documents_visibility ON documents(visibility);
CREATE INDEX IF NOT EXISTS idx_documents_updated ON documents(updated_at DESC);

PRAGMA foreign_keys = ON;
