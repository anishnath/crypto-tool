-- Verification queries for D1 billing schema (run via make d1-test)

SELECT 'tables' AS check_type, name AS result
FROM sqlite_master
WHERE type = 'table' AND name LIKE 'llm_%'
ORDER BY name;

SELECT 'views' AS check_type, name AS result
FROM sqlite_master
WHERE type = 'view' AND name LIKE 'llm_%'
ORDER BY name;

SELECT
    'seed_row' AS check_type,
    id,
    status,
    model_resolved,
    total_tokens,
    latency_ms
FROM llm_gateway_requests
WHERE id = '00000000-0000-4000-8000-000000000001';

SELECT
    'daily_usage' AS check_type,
    usage_date,
    provider_id,
    model,
    request_count,
    total_tokens
FROM llm_daily_usage
WHERE model = 'gpt-5.4-mini'
ORDER BY usage_date DESC
LIMIT 5;

SELECT
    'pricing_rows' AS check_type,
    COUNT(*) AS pricing_count
FROM llm_model_pricing;
