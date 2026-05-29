-- Per-user usage reporting queries

SELECT 'user_totals' AS report, user_id, user_email, user_name, request_count, total_tokens, last_request_at
FROM llm_user_usage_totals
ORDER BY total_tokens DESC;

SELECT 'anonymous_totals' AS report, anonymous_id, request_count, total_tokens, last_request_at
FROM llm_anonymous_usage_totals
ORDER BY total_tokens DESC
LIMIT 20;

SELECT 'daily_by_user' AS report, usage_date, user_email, auth_mode, request_count, total_tokens
FROM llm_user_usage
WHERE user_id IS NOT NULL
ORDER BY usage_date DESC, total_tokens DESC
LIMIT 20;
