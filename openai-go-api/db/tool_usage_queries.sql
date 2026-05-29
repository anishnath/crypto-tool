-- Per-tool AI usage reporting queries
-- Note: this measures AI usage only (gateway calls), not overall page views.
-- Requires frontend to send `X-Tool-Id: <tool-slug>` on every AI call.

-- Top tools by AI requests (all time)
SELECT
  COALESCE(tool_id, '(not set)') AS tool_id,
  COUNT(*) AS ai_requests,
  SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_requests,
  SUM(CASE WHEN status = 'failed' THEN 1 ELSE 0 END) AS failed_requests,
  SUM(COALESCE(total_tokens, 0)) AS total_tokens,
  ROUND(AVG(COALESCE(latency_ms, 0)), 0) AS avg_latency_ms
FROM llm_gateway_requests
GROUP BY tool_id
ORDER BY ai_requests DESC
LIMIT 50;

-- Top tools by tokens (this month)
SELECT
  tool_id,
  COUNT(*) AS completed_requests,
  SUM(COALESCE(total_tokens, 0)) AS total_tokens
FROM llm_gateway_requests
WHERE tool_id IS NOT NULL
  AND status = 'completed'
  AND started_at >= date('now', 'start of month')
GROUP BY tool_id
ORDER BY total_tokens DESC
LIMIT 50;

-- Daily tokens for a single tool (edit tool_id value)
SELECT
  date(started_at) AS day,
  COUNT(*) AS completed_requests,
  SUM(COALESCE(total_tokens, 0)) AS total_tokens
FROM llm_gateway_requests
WHERE status = 'completed'
  AND tool_id = 'integral-calculator'
GROUP BY date(started_at)
ORDER BY day DESC
LIMIT 30;

