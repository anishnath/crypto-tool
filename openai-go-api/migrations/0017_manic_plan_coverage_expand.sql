-- Migration 0017: Expand Manic plan_coverage to cheaper tools + sync notes.
-- Manic Pro/Ultra grant Pro on listed cheaper tools (explicit, not price heuristics).
-- Do NOT add reverse coverage (cheap tool → Manic).

INSERT INTO plan_coverage (purchased_tool_id, purchased_plan, covers_tool_id, grants_plan) VALUES
  -- already seeded in 0015; kept for idempotency
  ('developer-tools/manic', 'pro', 'electronics/arduino-simulator', 'pro'),
  ('developer-tools/manic', 'ultra', 'electronics/arduino-simulator', 'pro'),

  ('developer-tools/manic', 'pro', 'electronics/logic-simulator', 'pro'),
  ('developer-tools/manic', 'ultra', 'electronics/logic-simulator', 'pro'),

  ('developer-tools/manic', 'pro', 'developer-tools/mermaid', 'pro'),
  ('developer-tools/manic', 'ultra', 'developer-tools/mermaid', 'pro'),

  ('developer-tools/manic', 'pro', 'developer-tools/graph-easy', 'pro'),
  ('developer-tools/manic', 'ultra', 'developer-tools/graph-easy', 'pro'),

  ('developer-tools/manic', 'pro', 'developer-tools/online-compiler', 'pro'),
  ('developer-tools/manic', 'ultra', 'developer-tools/online-compiler', 'pro'),

  ('developer-tools/manic', 'pro', 'developer-tools/code-playground', 'pro'),
  ('developer-tools/manic', 'ultra', 'developer-tools/code-playground', 'pro'),

  ('developer-tools/manic', 'pro', 'latex/editor', 'pro'),
  ('developer-tools/manic', 'ultra', 'latex/editor', 'pro'),

  ('developer-tools/manic', 'pro', 'cryptography/pgp', 'pro'),
  ('developer-tools/manic', 'ultra', 'cryptography/pgp', 'pro'),

  ('developer-tools/manic', 'pro', 'cryptography/asn1-decoder', 'pro'),
  ('developer-tools/manic', 'ultra', 'cryptography/asn1-decoder', 'pro'),

  ('developer-tools/manic', 'pro', 'math/graphing-calculator', 'pro'),
  ('developer-tools/manic', 'ultra', 'math/graphing-calculator', 'pro'),

  ('developer-tools/manic', 'pro', 'math/lagrangian-calculator', 'pro'),
  ('developer-tools/manic', 'ultra', 'math/lagrangian-calculator', 'pro'),

  ('developer-tools/manic', 'pro', 'math/tikz-viewer', 'pro'),
  ('developer-tools/manic', 'ultra', 'math/tikz-viewer', 'pro'),

  ('developer-tools/manic', 'pro', 'physics/ray-optics-simulator', 'pro'),
  ('developer-tools/manic', 'ultra', 'physics/ray-optics-simulator', 'pro'),

  ('developer-tools/manic', 'pro', 'physics/optical-designer', 'pro'),
  ('developer-tools/manic', 'ultra', 'physics/optical-designer', 'pro')
ON CONFLICT(purchased_tool_id, purchased_plan, covers_tool_id) DO UPDATE SET
  grants_plan = excluded.grants_plan;
