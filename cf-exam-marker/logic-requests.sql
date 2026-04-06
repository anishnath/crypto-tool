-- Logic circuit AI generation requests logging schema
-- Apply: wrangler d1 execute exam-marker-db --file=logic-requests.sql --local
-- Apply: wrangler d1 execute exam-marker-db --file=logic-requests.sql --remote

CREATE TABLE IF NOT EXISTS logic_requests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    response_json TEXT,
    component_count INTEGER,
    wire_count INTEGER,
    success INTEGER NOT NULL DEFAULT 1,
    error_message TEXT,
    model TEXT DEFAULT 'gpt-5-mini',
    response_time_ms INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_logic_requests_created ON logic_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_logic_requests_success ON logic_requests(success);
