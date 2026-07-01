<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Math Studio shell — shared head assets for statistics and similar tool pages.
  Requires request attribute "v" (cache-bust version string).
--%><% String msshV = (String) request.getAttribute("v");
if (msshV == null || msshV.isEmpty()) {
    msshV = String.valueOf(System.currentTimeMillis());
}
%>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
<noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=msshV%>">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/statistics-calculator.css?v=<%=msshV%>">

<%@ include file="modern/components/math-ai-head.inc.jsp" %>

<style>
    .ic-hero .math-ai-tab-btn {
        display: inline-flex; align-items: center; gap: 0.35rem;
        padding: 0.35rem 0.75rem; border-radius: 999px; border: 1px solid rgba(225,29,72,0.35);
        background: rgba(225,29,72,0.08); color: var(--ms-text, #1e1b4b); font-size: 0.8125rem;
        font-weight: 600; cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
        white-space: nowrap;
    }
    .ic-hero .math-ai-tab-btn:hover {
        background: rgba(225,29,72,0.18); transform: translateY(-1px);
        box-shadow: 0 2px 8px rgba(225,29,72,0.15);
    }
    .ic-hero .math-ai-tab-btn[aria-busy="true"] { opacity: 0.75; cursor: wait; }
</style>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">
<%@ include file="modern/ads/ad-init.jsp" %>
