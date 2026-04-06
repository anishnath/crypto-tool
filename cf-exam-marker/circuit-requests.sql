-- Circuit AI generation requests logging schema
-- Apply: wrangler d1 execute exam-marker-db --file=circuit-requests.sql --local
-- Apply: wrangler d1 execute exam-marker-db --file=circuit-requests.sql --remote

CREATE TABLE IF NOT EXISTS circuit_requests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    response_json TEXT,
    element_count INTEGER,
    success INTEGER NOT NULL DEFAULT 1,
    error_message TEXT,
    model TEXT DEFAULT 'gpt-5-mini',
    response_time_ms INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_circuit_requests_created ON circuit_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_circuit_requests_success ON circuit_requests(success);
