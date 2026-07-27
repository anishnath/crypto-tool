-- Ops: wire Manic Dodo products + $9 Pro / $29 Ultra display + lower AI allotments.
-- Run after 0015 (or re-apply 0015).

INSERT INTO ai_plans (plan_id, display_name, monthly_token_limit, description, features_json, model_id, active)
VALUES
(
  'manic_pro', 'Manic Pro', 500000,
  'Manic Pro — Cartesia + Pro render, modest AI budget',
  '["500,000 AI tokens per month","Manic Pro render + Cartesia voice","Pro access on cheaper tools"]',
  'gpt-5.4', 1
),
(
  'ultra', 'Ultra', 1500000,
  'Manic Ultra — ElevenLabs + higher render/voice',
  '["1,500,000 AI tokens per month","Manic Ultra render + ElevenLabs voice","Pro access on cheaper tools","Priority model"]',
  'gpt-5.4', 1
)
ON CONFLICT(plan_id) DO UPDATE SET
  monthly_token_limit = excluded.monthly_token_limit,
  display_name = excluded.display_name,
  description = excluded.description,
  features_json = excluded.features_json,
  model_id = excluded.model_id,
  active = 1;

UPDATE billing_plans SET
  product_id = 'pdt_0Nk4fuArwE5DmcpU2bF7G',
  ai_plan_id = 'manic_pro',
  price_amount = 900,
  currency = 'USD',
  price_label = '$9/mo',
  name = 'Manic Pro',
  description = 'Cartesia narration, Pro render, Manic AI — includes Pro on cheaper tools',
  updated_at = datetime('now')
WHERE plan_key = 'monthly' AND tool_id = 'developer-tools/manic';

UPDATE billing_plans SET
  product_id = 'pdt_0Nk4gFJ4fIn0gbPOqxeeN',
  ai_plan_id = 'manic_pro',
  price_amount = 9000,
  currency = 'USD',
  price_label = '$90/yr',
  name = 'Manic Pro (yearly)',
  badge = 'Save 2 months',
  description = 'Cartesia narration, Pro render, Manic AI — billed yearly',
  updated_at = datetime('now')
WHERE plan_key = 'yearly' AND tool_id = 'developer-tools/manic';

UPDATE billing_plans SET
  product_id = 'pdt_0Nk4i8U92nyoPRLkfyvWN',
  ai_plan_id = 'ultra',
  price_amount = 2900,
  currency = 'USD',
  price_label = '$29/mo',
  name = 'Manic Ultra',
  description = 'ElevenLabs + Cartesia, 4K render, higher AI + voice budgets',
  updated_at = datetime('now')
WHERE plan_key = 'ultra_monthly' AND tool_id = 'developer-tools/manic';

UPDATE billing_plans SET
  product_id = 'pdt_0Nk4hpnw3U9dBNkxN7X9u',
  ai_plan_id = 'ultra',
  price_amount = 29000,
  currency = 'USD',
  price_label = '$290/yr',
  name = 'Manic Ultra (yearly)',
  description = 'ElevenLabs + Cartesia, 4K render — billed yearly',
  updated_at = datetime('now')
WHERE plan_key = 'ultra_yearly' AND tool_id = 'developer-tools/manic';
