# AI Tool Onboarding Guide

This folder contains the reusable AI assistant core and per-tool adapters.

Use this guide whenever you add AI support to a new tool page.

---

## Folder Structure

```text
modern/js/ai/
├── assistant-core.js                 # Stable entrypoint for generic assistant core
├── lazy-assistant.js                 # Lazy-load wiring (click / shortcut / checkout)
├── adapters/
│   ├── arduino-simulator-adapter.js  # Example tool adapter
│   ├── generic-tool-adapter.js       # Minimal adapter for new tools
│   ├── pgp-adapter.js
│   ├── ssh-adapter.js
│   ├── tikz-viewer-adapter.js
│   └── <new-tool>-adapter.js         # Your new tool adapter
└── README.md

modern/js/rsa/
└── rsa-ai.js                         # RSA-only bundled assistant (same lazy pattern)

modern/js/crypto/
└── crypto-tools-ai.js                  # Single bundled module (20 crypto JSP pages, RSA pattern)
```

`assistant-core.js` re-exports the generic implementation from `vibe-coding-assistant.js`:

- `ToolAiAssistant` / `VibeCodingAssistant`
- `applyExtractors`
- shared helpers

Tool pages should import adapters via **`wireLazyAssistant()`** (see **Lazy loading** below), not eager `import` + `mount()` on page load.

---

## JSP includes (server bootstrap)

Shared fragments under `modern/components/` wire gateway env flags, OAuth user id, CSS, and a JS `aiAssistantBoot` object. No duplicate scriptlets per page.

| Include | Where | Purpose |
|---------|-------|---------|
| `ai-assistant-vars.inc.jsp` | Top of JSP (once) | Server vars from `AiAssistantPageSupport` |
| `ai-assistant-head.inc.jsp` | `<head>` | Assistant stylesheet |
| `ai-assistant-boot.inc.jsp` | Inside `<script type="module">` | `const aiAssistantBoot = { … }` |
| `ai-crypto-assistant.inc.jsp` | Before `</body>` on crypto tool pages | FAB + lazy `crypto-tools-ai.js` (requires `aiCryptoToolKey`) |

Optional request attributes (set before `vars` include):

| Attribute | Default | Purpose |
|-----------|---------|---------|
| `aiToolId` | `""` | Billing + localStorage key |
| `aiBillingEnabled` | `true` | Enable billing bar / tier routing |
| `aiRequireSignIn` | `false` | Block AI send for guests (shows sign-in prompt) |

---

## Lazy loading (required for tool pages)

**Do not** eager-load adapters on page load (`import …` + `ai.mount()` at top level). That pulls in ~125KB of modules (`adapter` → `assistant-core` → `vibe-coding-assistant` → `llm-client`, and billing when needed) and slows LCP on every visit.

Use `wireLazyAssistant()` from `lazy-assistant.js` instead. It:

- **`import()`** the adapter module on first open (button click or **Ctrl+Shift+A**)
- **Prefetch** on first `pointerenter` over the AI button (warms cache before click)
- Handle **`?checkout=1`** return from Dodo (auto-open with welcome message)
- Set **`aria-busy`** on the trigger button while loading

### What loads when

| Phase | Network / JS |
|-------|----------------|
| Page load | `lazy-assistant.js` (~2KB), `aiAssistantBoot` inline, assistant CSS |
| First AI open | Adapter + `vibe-coding-assistant.js` + `llm-client.js` |
| Guest open | Sign-in bar shown immediately; `billing-client.js` loads async (non-blocking) |
| Logged-in open | `fetchBillingStatus` async; “Go Pro” bar when not premium |
| Plan picker | `GET /api/billing/plans` (cached 1h in `sessionStorage` + 1h on Go) |

### Pages using lazy load today

| Page | Module | Export | Button |
|------|--------|--------|--------|
| `rsafunctions.jsp` | `rsa/rsa-ai.js` | `createRsaAssistant` | `btnRsaAI` |
| `pgpencdec.jsp`, `pgpkeyfunction.jsp` | `adapters/pgp-adapter.js` | `createPgpAssistant` | `btnPgpAI` |
| `sshfunctions.jsp` | `adapters/ssh-adapter.js` | `createSshAssistant` | `btnSshAI` |
| `tikz-viewer.jsp` | `adapters/tikz-viewer-adapter.js` | `createTikzViewerAssistant` | `btnTikzAI` |
| `arduino-simulator.jsp` | `adapters/arduino-simulator-adapter.js` | `createArduinoSimulatorAssistant` | `btnAI` |
| **Unified crypto tools** (see below) | `crypto/crypto-tools-ai.js` | `createCryptoToolAssistant` | `btnCryptoAI` |

### Unified crypto tools AI (20 pages)

One servlet + one bundled JS module covers hash, HMAC, cipher, KDF, and asymmetric tool pages. Per-page behavior is keyed by `aiCryptoToolKey` inside `crypto-tools-ai.js`.

| JSP | Registry key (`aiCryptoToolKey`) |
|-----|----------------------------------|
| `MessageDigest.jsp` | `message-digest` |
| `hmacgen.jsp` | `hmac` |
| `CipherFunctions.jsp` | `cipher` |
| `pbkdf.jsp` | `pbkdf` |
| `pbe.jsp` | `pbe` |
| `bccrypt.jsp` | `bcrypt` |
| `scrypt.jsp` | `scrypt` |
| `argon2.jsp` | `argon2` (explain-only; hashing is client WASM) |
| `htpasswd.jsp` | `htpasswd` |
| `ecfunctions.jsp` | `ec` |
| `ecsignverify.jsp` | `ec-sign-verify` |
| `elgamalfunctions.jsp` | `elgamal` |
| `dsafunctions.jsp` | `dsa` |
| `ntrufunctions.jsp` | `ntru` |
| `jwsgen.jsp` | `jws-gen` |
| `jwssign.jsp` | `jws-sign` |
| `jwsparse.jsp` | `jws-parse` |
| `jwsverify.jsp` | `jws-verify` |
| `jwkfunctions.jsp` | `jwk` |
| `jwkconvertfunctions.jsp` | `jwk-convert` |

**JSP wiring** (three includes + floating FAB):

```jsp
<%
request.setAttribute("aiCryptoToolKey", "message-digest");
request.setAttribute("aiToolId", "cryptography/message-digest");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!-- head -->
<%@ include file="modern/components/ai-assistant-head.inc.jsp" %>
<!-- before </body> -->
<%@ include file="modern/components/ai-crypto-assistant.inc.jsp" %>
```

`ai-crypto-assistant.inc.jsp` calls `wireLazyAssistant` with `extraOpts: () => ({ toolKey: '…' })`.

**Backend API:** `POST /api/crypto/execute` (`CryptoApiServlet` → `CryptoBackendClient`) forwards to legacy form servlets (`/MDFunctionality`, `/CipherFunctionality`, etc.).

**Load chain on first AI open (crypto pages):**

```text
lazy-assistant.js → crypto-tools-ai.js → assistant-core.js → vibe-coding-assistant.js → llm-client.js
```

Previously this was 6+ crypto-specific modules plus the same core chain. The bundle keeps one HTTP fetch for crypto logic (same pattern as `rsa/rsa-ai.js`).

Request shape:

```json
{ "tool": "message-digest", "operation": "hash", "params": { "text": "hello", "algorithms": ["SHA-256"] } }
```

**Limits:** DSA file-upload flows stay on the page; Argon2 server ops are explain-only; ElGamal keygen may need the page form for some paths. JWS/JWK backends use `/JWSFunctionality` and `/JWKFunctionality` (JSON responses).

**UX / routing (end user):**
- Conceptual questions → generic chat (`explain` / `looksLikeExplainOnly` — no duplicate user bubble).
- Ambiguous requests → `clarify` with a plain-language question (not forced into explain).
- Action requests → intent router → `/api/crypto/execute` → form submit updates page output.
- Page-specific system prompt and placeholder (in `crypto-tools-ai.js`).

**Backend fixes in `CryptoBackendClient`:** PBE decrypt uses legacy param `decryprt`; PBE multi-algorithm via `cipherparameternew`; bcrypt/scrypt verify use `CALCULATE_*` + `hash` param; htpasswd verify uses `hash`; EC sign field name swap; JWS sign no longer maps PEM `key` as HMAC secret; `wrapLegacy` sets `ok:false` when `success` or `errorMessage` indicates failure.

**Tool keys (JWS/JWK):** `jws-gen`, `jws-sign`, `jws-parse`, `jws-verify`, `jwk`, `jwk-convert` — operations `generate`, `sign`, `parse`, `verify`, `convert`.

### Minimal new tool page

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
request.setAttribute("aiToolId", "my-tool");
%>
<%@ include file="../modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
  <%@ include file="../modern/components/ai-assistant-head.inc.jsp" %>
</head>
<body>
  <button type="button" id="btnAI" title="AI assistant (Ctrl+Shift+A)">AI</button>

  <script type="module">
  <%@ include file="../modern/components/ai-assistant-boot.inc.jsp" %>
  import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';

  wireLazyAssistant({
    moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/generic-tool-adapter.js',
    exportName: 'createGenericToolAssistant',
    buttonId: 'btnAI',
    boot: aiAssistantBoot,
    extraOpts: () => ({
      title: 'My Tool AI',
      systemPrompt: 'You help users with this tool.',
      seedContext: () => document.getElementById('input')?.value || '',
    }),
  });
  </script>
</body>
</html>
```

### `wireLazyAssistant` options

```javascript
wireLazyAssistant({
  moduleUrl: '…/adapters/my-tool-adapter.js',  // required — ES module URL
  exportName: 'createMyToolAssistant',          // required — factory export name
  buttonId: 'btnAI',                            // trigger button id
  boot: aiAssistantBoot,                        // from ai-assistant-boot.inc.jsp
  extraOpts: () => ({ /* deps */ }),            // merged into factory opts at first load
  onReady: (ai) => { /* after mount */ },       // optional
  checkoutMessage: '…',                         // optional — false to disable ?checkout=1 auto-open
  prefetchOnHover: true,                        // optional — default true
});
```

Returns `{ ensure, open, getInstance }` if the page needs programmatic access after first load.

### Tool-specific adapter (Arduino pattern)

```javascript
<%@ include file="../modern/components/ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '…/lazy-assistant.js';

wireLazyAssistant({
  moduleUrl: '…/arduino-simulator-adapter.js',
  exportName: 'createArduinoSimulatorAssistant',
  buttonId: 'btnAI',
  boot: aiAssistantBoot,
  extraOpts: () => ({
    fileManager,
    editor,
    componentPanel,
    // …tool deps (must exist before first open)
  }),
});
```

### RSA bundled module

RSA uses a single `rsa/rsa-ai.js` (api, session, router, executor, adapter) with the same lazy pattern — no separate `adapters/rsa-adapter.js`.

Env vars (`USE_AI_GATEWAY`, `FREE_USE_AI_GATEWAY`) are read server-side — no JSP edits to switch routes.

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
   - `wireLazyAssistant({ moduleUrl, exportName, buttonId, boot, extraOpts })`
   - do **not** call `mount()` on page load
4. Keep page wiring thin:
   - pass dependencies into adapter via `opts`
5. Add route mode if needed:
   - `aiRouteMode: 'auto' | 'gateway' | 'legacy' | 'tier'` (see **Route Mode**)
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

Complete reference for how AI requests are routed. Ops env vars are documented in [`docs/DODO_BILLING_ENV.md`](../../../../docs/DODO_BILLING_ENV.md).

### Endpoints

| Path | Servlet | Backend | When used |
|------|---------|---------|-----------|
| `POST /ai` | `AIProxyServlet` | Ollama (legacy) | Guests, free tier when `FREE_USE_AI_GATEWAY=false`, or everyone when `USE_AI_GATEWAY=false` |
| `POST /ai-gateway` | `AIGatewayProxyServlet` | Go gateway (`AI_GATEWAY` env) | Pro, free when `FREE_USE_AI_GATEWAY=true`; returns **503** if `USE_AI_GATEWAY=false` |

Tomcat env (restart required):

| Variable | Layer | Purpose |
|----------|-------|---------|
| `USE_AI_GATEWAY` | Tomcat + JSP boot | Master switch — enables `/ai-gateway` servlet and tier routing in JSP |
| `FREE_USE_AI_GATEWAY` | Tomcat + JSP boot | Free logged-in tier: gateway (`true`, default) or legacy `/ai` (`false`) |
| `AI_GATEWAY` | Tomcat servlet only | Internal Go base URL (e.g. `http://127.0.0.1:8084`) — not a frontend route flag |

### Full routing matrix

| `USE_AI_GATEWAY` | `FREE_USE_AI_GATEWAY` | `aiRouteMode` (JSP boot) | Guest | Free (logged in) | Pro |
|------------------|------------------------|--------------------------|-------|------------------|-----|
| `false` | *(ignored)* | `auto` | `/ai` | `/ai` | `/ai` |
| `true` | `true` (default) | `tier` | `/ai` | `/ai-gateway` | `/ai-gateway` |
| `true` | `false` | `tier` | `/ai` | `/ai` | `/ai-gateway` |

No JSP or JS edits needed to switch — set Tomcat env and restart.

### Layers (who decides what)

```text
Tomcat env (USE_AI_GATEWAY, FREE_USE_AI_GATEWAY)
    ↓
AiGatewayConfig / AiAssistantPageSupport  →  ai-assistant-boot.inc.jsp  →  aiAssistantBoot
    ↓
ToolAiAssistant (aiRouteMode, aiRouteByTier, aiUrl, useGateway)
    ↓  billing refresh → _setTier() → _applyAiRouteForTier()  [only when aiRouteMode === 'tier']
LlmClient (fetch + gateway identity headers)
    ↓
Tomcat /ai  or  /ai-gateway  →  Ollama  or  Go
```

**Server (JSP):** `ai-assistant-boot.inc.jsp` sets:

- `aiRouteMode`: `'tier'` when `USE_AI_GATEWAY=true`, else `'auto'`
- `aiRouteByTier`: guest → legacy, free → from `FREE_USE_AI_GATEWAY`, pro → gateway

**Client (JS):** `ToolAiAssistant` in `vibe-coding-assistant.js` applies routing:

| `aiRouteMode` | Behavior |
|---------------|----------|
| `auto` (default when gateway off) | Static — uses `aiUrl` / `useGateway` from page boot for the whole session. Billing tier does **not** change the route. |
| `gateway` | Always `/ai-gateway` + gateway headers. |
| `legacy` | Always `/ai` — no gateway headers. |
| `tier` | Dynamic — after billing status loads, `_applyAiRouteForTier(tier)` maps tier → `/ai` or `/ai-gateway`. Requires `billing.enabled`. |

**JS defaults** (`defaultAiRouteByTier` in core — overridden by JSP boot):

| Tier | Default route |
|------|---------------|
| `guest` | legacy (`/ai`) |
| `free` | gateway |
| `pro` | gateway |
| `unknown` | gateway if site prefers gateway, else legacy |

### Gateway request headers

When `useGateway` is true (route is `/ai-gateway`), `llm-client.js` sends:

| Header | When |
|--------|------|
| `X-User-Id` | Logged-in OAuth user |
| `X-Anonymous-Id` | Guest (stable UUID in `localStorage`) |
| `X-Tool-Id` | When `toolId` is set on the assistant |

Legacy `/ai` requests send no identity headers.

### Per-tool overrides

Override in adapter or page boot (wins over env defaults):

```javascript
new ToolAiAssistant({
  aiRouteMode: 'tier',       // or 'auto' | 'gateway' | 'legacy'
  useGateway: true,
  aiRouteByTier: {
    guest: 'legacy',
    free: 'gateway',         // or 'legacy'
    pro: 'gateway',
    unknown: 'legacy',       // optional fallback tier
  },
});
```

Use `gateway` or `legacy` for tools that must never switch (e.g. always Ollama even for Pro).

### Arduino simulator

Uses JSP includes + `wireLazyAssistant()` with `extraOpts` for `fileManager`, `editor`, etc. Adapter hardcodes `toolId: 'electronics/arduino-simulator'` for billing.

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
- **Move:** drag the header. **Resize:** drag any edge or the bottom-right corner (IDE-style); size is saved per tool.
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

5. **Eager AI load on page visit**
   - Never `import` adapter + `mount()` at module top level — use `wireLazyAssistant()`.
   - Verify DevTools Network: no `vibe-coding-assistant.js` until first AI open.

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

- [ ] Adapter file created under `modern/js/ai/adapters/` (or bundled module like `rsa/rsa-ai.js`)
- [ ] Tool page uses `wireLazyAssistant()` — no eager adapter import on load
- [ ] Network tab: AI script chain appears only after open (or hover prefetch)
- [ ] Context is accurate after major UI state changes
- [ ] Apply action(s) are safe and deterministic
- [ ] Route mode chosen correctly (`auto` / `gateway` / `legacy` / `tier`)
- [ ] Light and dark theme controls are readable
- [ ] Runtime tested on running Tomcat deployment

