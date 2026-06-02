<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Shared lazy AI assistant for crypto tool pages (hash, cipher, KDF, asymmetric).

  Set before include:
    request.setAttribute("aiCryptoToolKey", "message-digest");  // registry key
    request.setAttribute("aiToolId", "cryptography/message-digest");  // billing (optional, derived if omitted)

  Also requires ai-assistant-vars.inc.jsp at top of page and ai-assistant-head.inc.jsp in <head>.
--%><%@ page import="z.y.x.ai.AiAssistantPageSupport" %><%
AiAssistantPageSupport.ensurePageVars(pageContext);
String cryptoToolKey = AiAssistantPageSupport.param(pageContext, "aiCryptoToolKey", "");
if (request.getAttribute("aiToolId") == null || "".equals(String.valueOf(request.getAttribute("aiToolId")).trim())) {
  if (!cryptoToolKey.isEmpty()) {
    request.setAttribute("aiToolId", "cryptography/" + cryptoToolKey);
  }
}
%><style>
/* Bottom-left: avoids anchor + siderail ads (bottom-right on desktop). */
.crypto-ai-fab {
  position: fixed;
  left: max(1.25rem, env(safe-area-inset-left, 0px));
  right: auto;
  bottom: var(--crypto-ai-fab-bottom, max(1.25rem, env(safe-area-inset-bottom, 0px)));
  z-index: 10040;
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.65rem 1rem;
  border: none;
  border-radius: 999px;
  font-size: 0.875rem;
  font-weight: 600;
  color: #fff;
  cursor: pointer;
  background: linear-gradient(135deg, #10b981 0%, #0ea5a4 100%);
  box-shadow: 0 4px 14px rgba(16, 185, 129, 0.45), 0 0 0 2px rgba(255, 255, 255, 0.35);
}
.crypto-ai-fab:hover { filter: brightness(1.08); }
.crypto-ai-fab:focus-visible {
  outline: 2px solid #0ea5a4;
  outline-offset: 3px;
}
.crypto-ai-fab[aria-busy="true"] { opacity: 0.85; cursor: wait; }
/* GPT anchor slot (setupad.jsp) — keep FAB above ~90–100px footer ad */
@media (min-width: 1000px) {
  .crypto-ai-fab {
    --crypto-ai-fab-bottom: max(6.5rem, env(safe-area-inset-bottom, 0px));
  }
}
</style>
<script>
(function () {
  function syncCryptoAiFabOffset() {
    var anchor = document.getElementById('site_8gwifi_org_anchor_responsive');
    if (!anchor) return;
    var h = Math.ceil(anchor.getBoundingClientRect().height || 0);
    var base = window.innerWidth >= 1000 ? 104 : 20;
    var bottom = h > 48 ? h + 16 : base;
    document.documentElement.style.setProperty(
      '--crypto-ai-fab-bottom',
      'max(' + bottom + 'px, env(safe-area-inset-bottom, 0px))'
    );
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', syncCryptoAiFabOffset);
  } else {
    syncCryptoAiFabOffset();
  }
  window.addEventListener('resize', syncCryptoAiFabOffset, { passive: true });
  var anchor = document.getElementById('site_8gwifi_org_anchor_responsive');
  if (anchor && typeof ResizeObserver !== 'undefined') {
    new ResizeObserver(syncCryptoAiFabOffset).observe(anchor);
  }
})();
</script>
<button type="button" id="btnCryptoAI" class="crypto-ai-fab" title="AI assistant (Ctrl+Shift+A)" aria-label="Open AI assistant">
  <svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16" aria-hidden="true"><path d="M6 12.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 0 1h-3a.5.5 0 0 1-.5-.5ZM3 8.062C3 6.76 4.235 5.765 5.53 5.886a26.58 26.58 0 0 0 4.94 0C11.765 5.765 13 6.76 13 8.062v1.157a.933.933 0 0 1-.765.935c-.845.147-2.34.346-4.235.346-1.895 0-3.39-.2-4.235-.346A.933.933 0 0 1 3 9.219V8.062Z"/><path d="M8 1a7 7 0 1 0 0 14A7 7 0 0 0 8 1ZM0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8Z"/></svg>
  AI
</button>
<script type="module">
<%@ include file="ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';

window.cryptoToolAssistant = wireLazyAssistant({
  moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/crypto/crypto-tools-ai.js',
  exportName: 'createCryptoToolAssistant',
  buttonId: 'btnCryptoAI',
  boot: aiAssistantBoot,
  extraOpts: () => ({ toolKey: '<%= AiAssistantPageSupport.escapeJs(cryptoToolKey) %>' }),
});
</script>
