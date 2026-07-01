<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    math-libs.jsp — shared math-tool scripts bundle.

    Loads every library that is byte-identical across all math pages:
      · KaTeX             — formula rendering
      · Nerdamer          — symbolic CAS (core + Algebra + Calculus)
      · tool-utils        — toast, clipboard, clipboard fallbacks
      · dark-mode         — theme toggle
      · search            — site search widget
      · Plotly loader     — on-demand Plotly CDN
      · image-to-math     — photo scanning modal

    Usage (from any math tool page, placed near end of <body>,
    BEFORE the tool-specific scripts partial):

        <jsp:include page="/math/partials/math-libs.jsp" />
        <jsp:include page="/math/partials/<tool>-calculator-scripts.jsp" />
        <jsp:include page="/math/partials/math-input-setup.jsp" />

    DO NOT inline any of these elsewhere — this file is the single source
    of truth for these dependency versions.

    When math-tool-engine-boot.inc.jsp is used, set mathLibsSkipNerdamer so
    nerdamer is not loaded twice (it lives in math-ai-cores-engine.js).
--%>
<% boolean _skipNerdamer = Boolean.TRUE.equals(request.getAttribute("mathLibsSkipNerdamer")); %>
<!-- ── Symbolic CAS + formula rendering ── -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<% if (!_skipNerdamer) { %>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
<% } %>

<!-- ── Plotly loader — lazy-loaded on demand when the Graph tab is first opened ── -->
<script>
    var __plotlyLoaded = false;
    function loadPlotly(cb) {
        if (__plotlyLoaded) { if (cb) cb(); return; }
        var s = document.createElement('script');
        s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
        s.onload = function() { __plotlyLoaded = true; if (cb) cb(); };
        document.head.appendChild(s);
    }
</script>

<!-- ── Shared site helpers ── -->
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

<!-- ── Image-to-math (photo → math) modal library ── -->
<script src="<%=request.getContextPath()%>/modern/js/image-to-math.js"></script>
