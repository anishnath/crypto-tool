# AI Tool Onboarding Guide

This folder contains the reusable AI assistant core and per-tool adapters.

Use this guide whenever you add AI support to a new tool page.

---

## Folder Structure

```text
modern/js/ai/
├── assistant-core.js                 # Stable entrypoint for generic assistant core
├── adapters/
│   ├── arduino-simulator-adapter.js  # Example tool adapter
│   └── <new-tool>-adapter.js         # Your new tool adapter
└── README.md
```

`assistant-core.js` re-exports the generic implementation from `vibe-coding-assistant.js`:

- `ToolAiAssistant` / `VibeCodingAssistant`
- `applyExtractors`
- shared helpers

Tool pages should import from `modern/js/ai/*` instead of importing `vibe-coding-assistant.js` directly.

---

## Architecture Principles

### Keep Core Generic

The core assistant (`vibe-coding-assistant.js`) should only contain:

- chat UI + streaming behavior
- generic context/history/policy controls
- generic apply-action plumbing
- route selection (`aiRouteMode`)

It must **not** contain tool-specific domain logic.

### Keep Adapters Tool-Specific

Each adapter should contain:

- tool-specific `systemPrompt`
- `seedContext()` shape for that tool
- `getQuickActions()`
- tool-specific `applyActions`
- tool-specific output logging/messages

---

## New Tool Onboarding Checklist

When adding AI support to a new tool:

1. Create adapter file:
   - `modern/js/ai/adapters/<tool>-adapter.js`
2. Export factory function:
   - `create<ToolName>Assistant(opts)`
3. In tool JSP/JS page:
   - import adapter
   - instantiate assistant via adapter factory
   - mount + bind open shortcut/button
4. Keep page wiring thin:
   - pass dependencies into adapter via `opts`
5. Add route mode if needed:
   - `aiRouteMode: 'auto' | 'gateway' | 'legacy'`
6. Verify:
   - send/stream works
   - apply actions work
   - context is correct after state changes
   - light/dark UI visibility

---

## Adapter Contract (Recommended)

Each adapter factory should accept an options object like:

```js
{
  ctx,
  aiUrl,
  useGateway,
  aiRouteMode,     // optional override
  userId,
  // tool dependencies
  ...deps
}
```

And return:

```js
return new VibeCodingAssistant({ ...configuredOptions });
```

### Required in most adapters

- `toolId` (stable, unique)
- `systemPrompt`
- `seedContext`
- `applyActions` (if tool supports apply)

### Recommended

- `getQuickActions`
- `onError`
- `historyTurns` tuned for tool complexity

---

## Route Mode (Gateway vs Legacy)

The core supports per-tool route override:

- `aiRouteMode: 'auto'` (default) -> infer from `aiUrl` / `useGateway`
- `aiRouteMode: 'gateway'` -> force `/ai-gateway`
- `aiRouteMode: 'legacy'` -> force `/ai`

Use this for legacy tools that must stay on old `/ai` even when `USE_AI_GATEWAY=true`.

---

## Apply Actions: Best Practices

### Do

- Keep extractors deterministic and strict.
- Validate payload shape before applying.
- Log clear success/failure messages.
- Keep single-file fallback if multi-file parsing fails.
- Preserve user work (save active editor state before mass updates).

### Don't

- Assume the model always returns valid fenced blocks.
- Overwrite unrelated files silently.
- Delete files automatically without explicit user intent.
- Mix tool-specific apply code into core assistant.

---

## Multi-file Apply Pattern (Optional)

If your tool supports multiple files:

- Define deterministic output format in prompt, e.g.:
  - ```` ```cpp title=main.ext ````
- Parse fences by:
  - fence metadata (`title=`, `file=`, etc.)
  - optional first line marker (`// file: name.ext`)
- Upsert files case-insensitively.
- Enforce tool/file limits before apply.

Keep a fallback path for single-file responses.

---

## Prompting Guidelines for Adapters

### Good system prompt traits

- Explicit output contracts (format + fences)
- Explicit behavior for incomplete context
- Strong instruction to use `[CURRENT CONTEXT]` as source of truth
- Clear explain/fix expectations

### Avoid

- Vague formatting instructions
- Contradictory output requirements
- Overly long prompts with redundant policy text

---

## UI/UX Guidelines

- Keep assistant floating/non-blocking for tools with active canvases/editors.
- Ensure header controls remain clickable when drag is enabled.
- In light theme, verify toolbar and dropdown contrast.
- Use concise quick-action labels with high-value prompts.

---

## Common Pitfalls

1. **JSP EL collision with JS template literals**
   - If JSP contains JS template literals like `${var}`, JSP EL may evaluate them.
   - For pages using JS template literals inline, consider:
     - `isELIgnored="true"` on that JSP, or
     - escaping `${...}` usage.

2. **Stale context in history**
   - Strip old `[CURRENT CONTEXT]` envelopes from prior turns.
   - Use reset-on-context-change when tool state changes quickly.

3. **Draggable header blocks controls**
   - Exclude `select`, `input`, `label`, buttons from drag start.

4. **Adapter grows too large**
   - Split adapter internals into helper modules if logic exceeds manageable size.

---

## Minimal Adapter Template

```js
import { VibeCodingAssistant, applyExtractors } from '../assistant-core.js';

export function createMyToolAssistant(opts) {
  const { ctx, aiUrl, useGateway, aiRouteMode, userId } = opts;

  return new VibeCodingAssistant({
    ctx,
    aiUrl,
    useGateway,
    aiRouteMode,
    userId,
    toolId: 'category/my-tool',
    title: 'My Tool AI',
    systemPrompt: '...',
    seedContext: () => '...',
    getQuickActions: () => [{ label: 'Explain', prompt: 'Explain current state', sendImmediately: true }],
    applyActions: [
      {
        id: 'main',
        label: 'Apply',
        extract: applyExtractors.fencedCode(['js']),
        apply: (code) => { /* tool-specific apply */ },
      },
    ],
  });
}
```

---

## Final Review Before Shipping

- [ ] Adapter file created under `modern/js/ai/adapters/`
- [ ] Tool page imports adapter (not core directly)
- [ ] Context is accurate after major UI state changes
- [ ] Apply action(s) are safe and deterministic
- [ ] Route mode chosen correctly (`auto/gateway/legacy`)
- [ ] Light and dark theme controls are readable
- [ ] Runtime tested on running Tomcat deployment

