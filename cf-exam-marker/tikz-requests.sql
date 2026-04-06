-- TikZ requests logging schema for CF Exam Marker
-- Apply: wrangler d1 execute exam-marker-db --file=tikz-requests.sql --local
-- Apply: wrangler d1 execute exam-marker-db --file=tikz-requests.sql --remote

CREATE TABLE IF NOT EXISTS tikz_requests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT NOT NULL,
    prompt TEXT,
    response_json TEXT,
    success INTEGER NOT NULL DEFAULT 1,
    error_message TEXT,
    model TEXT DEFAULT 'gpt-5-mini',
    response_time_ms INTEGER,
    created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tikz_requests_created ON tikz_requests(created_at);
CREATE INDEX IF NOT EXISTS idx_tikz_requests_success ON tikz_requests(success);
