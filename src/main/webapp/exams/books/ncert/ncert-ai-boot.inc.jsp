<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  NCERT AI — shared boot for question/chapter pages (classes 9–12).
  Include once before footer on NCERT book pages.

  Optional request attribute before include:
    aiRequireSignIn — default true
--%><%
if (request.getAttribute("aiRequireSignIn") == null) {
    request.setAttribute("aiRequireSignIn", "true");
}
%>
<button type="button" id="btnNcertAI" class="ncert-ai-fab" title="NCERT AI (Ctrl+Shift+A)" aria-label="Open NCERT AI tutor">&#10024; AI</button>
<style>
.ncert-ai-fab {
    position: fixed;
    bottom: 1.25rem;
    right: 1.25rem;
    z-index: 9000;
    display: inline-flex;
    align-items: center;
    gap: 0.35rem;
    padding: 0.55rem 1rem;
    border: 1px solid rgba(99, 102, 241, 0.45);
    border-radius: 999px;
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.95), rgba(139, 92, 246, 0.95));
    color: #fff;
    font-size: 0.875rem;
    font-weight: 600;
    cursor: pointer;
    box-shadow: 0 4px 14px rgba(99, 102, 241, 0.35);
    transition: transform 0.15s ease, box-shadow 0.15s ease;
}
.ncert-ai-fab:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(99, 102, 241, 0.45); }
.ncert-ai-fab[aria-busy="true"] { opacity: 0.75; cursor: wait; }
.ncert-ai-nav-btn {
    border: 1px solid rgba(99, 102, 241, 0.35);
    background: rgba(99, 102, 241, 0.12);
    color: var(--primary, #6366f1);
    cursor: pointer;
    font: inherit;
}
.ncert-ai-nav-btn:hover { background: rgba(99, 102, 241, 0.2); }
.ncert-ai-q-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.25rem;
    padding: 0.3rem 0.7rem;
    border: 1px solid rgba(99, 102, 241, 0.45);
    border-radius: var(--radius-sm, 6px);
    background: rgba(99, 102, 241, 0.12);
    color: var(--primary, #6366f1);
    font-size: 0.8125rem;
    font-weight: 600;
    cursor: pointer;
    white-space: nowrap;
    line-height: 1.2;
}
.ncert-ai-q-btn:hover { background: rgba(99, 102, 241, 0.22); }
.toggle-btn.ncert-ai-q-btn { font: inherit; }
.section-label-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 0.75rem;
    flex-wrap: wrap;
}
/* KaTeX inside NCERT AI chat bubbles (page content still uses MathJax) */
.vca-msg-body .vca-md { overflow-x: auto; }
.vca-msg-body .katex-display { margin: 0.45rem 0; overflow-x: auto; overflow-y: hidden; }
.vca-msg-body .katex { font-size: 1.05em; }
</style>
<script>
window.ncertQuestionRegistry = window.ncertQuestionRegistry || {};
window.ncertChapterMeta = null;

window.ncertEmitContext = function (detail) {
    document.dispatchEvent(new CustomEvent('ncert:context-ready', { detail: detail || {} }));
};

/** Open AI for a specific question on chapter listing pages. */
window.ncertOpenQuestionAI = function (qId, prefill, autoSend) {
    var q = window.ncertQuestionRegistry[qId];
    var meta = window.ncertChapterMeta || {};
    if (q) {
        window.ncertEmitContext({
            pageType: 'question',
            bookClass: meta.bookClass || '',
            bookPart: meta.bookPart || '',
            subjectLabel: meta.subjectLabel || '',
            chapterNum: meta.chapterNum || '',
            chapterName: meta.chapterName || '',
            question: q
        });
    }
    if (typeof window.ncertOpenAI === 'function') {
        window.ncertOpenAI(prefill || '', autoSend === true);
    }
};
</script>
<script type="module">
<%@ include file="/modern/components/ai-assistant-vars.inc.jsp" %>
<%@ include file="/modern/components/ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';
import { installNcertOpenAI } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/ncert-ai.js';

(function () {
    function deriveNcertToolId() {
        var parts = location.pathname.split('/').filter(Boolean);
        var i = parts.indexOf('ncert');
        if (i < 0) return 'exams/ncert';
        var bookClass = parts[i + 1] || '';
        var bookPart = parts[i + 2] || '';
        if (/^class-\d+$/.test(bookClass) && bookPart && !/\.jsp$/i.test(bookPart)) {
            return 'exams/ncert/' + bookClass + '/' + bookPart;
        }
        if (/^class-\d+$/.test(bookClass)) return 'exams/ncert/' + bookClass;
        return 'exams/ncert';
    }

    function deriveSubjectLabel() {
        var toolId = deriveNcertToolId();
        if (toolId.indexOf('physics') >= 0) return 'Physics';
        if (toolId.indexOf('mathematics') >= 0) return 'Mathematics';
        return 'NCERT';
    }

    var boot = Object.assign({}, aiAssistantBoot, { toolId: deriveNcertToolId() });
    window.ncertAiBoot = boot;
    window.ncertAssistant = wireLazyAssistant({
        moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/ncert-ai.js',
        exportName: 'createNcertAssistant',
        buttonId: 'btnNcertAI',
        boot: boot,
        extraOpts: function () { return { subjectLabel: deriveSubjectLabel() }; },
        prefetchOnHover: true,
        checkoutMessage: false,
    });
    installNcertOpenAI(window.ncertAssistant, boot);
})();
</script>
