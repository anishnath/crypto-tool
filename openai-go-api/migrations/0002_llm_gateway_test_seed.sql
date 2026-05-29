-- Migration 0002: Smoke-test seed row (safe to re-run via INSERT OR IGNORE pattern)
-- Used by `make d1-test` to verify read/write against D1.

INSERT INTO llm_gateway_requests (
    id,
    endpoint,
    modality,
    provider_id,
    model_requested,
    model_resolved,
    stream,
    request_json,
    message_count,
    input_char_count,
    status,
    http_status,
    prompt_tokens,
    completion_tokens,
    total_tokens,
    usage_json,
    output_char_count,
    latency_ms,
    started_at,
    completed_at,
    api_key_hash
)
SELECT
    '00000000-0000-4000-8000-000000000001',
    'chat_completions',
    'chat',
    'openai',
    'gpt-5.4-mini',
    'gpt-5.4-mini',
    0,
    '{"model":"gpt-5.4-mini","messages":[{"role":"user","content":"migration smoke test"}]}',
    1,
    22,
    'completed',
    200,
    10,
    5,
    15,
    '{"prompt_tokens":10,"completion_tokens":5,"total_tokens":15}',
    12,
    42,
    datetime('now'),
    datetime('now'),
    'test-migration-hash'
WHERE NOT EXISTS (
    SELECT 1 FROM llm_gateway_requests
    WHERE id = '00000000-0000-4000-8000-000000000001'
);
