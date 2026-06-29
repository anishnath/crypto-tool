<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  NCERT AI — stylesheet for VibeCodingAssistant panel. Include in <head> on NCERT AI pages.
--%><%@ include file="/modern/components/ai-assistant-vars.inc.jsp" %>
<%@ include file="/modern/components/ai-assistant-head.inc.jsp" %>
<%@ include file="/modern/components/katex-head.inc.jsp" %>
<script>
/** Early NCERT context bridge — must exist before async question JSON loaders run. */
window.ncertQuestionRegistry = window.ncertQuestionRegistry || {};
window.ncertChapterMeta = window.ncertChapterMeta || null;
window.ncertPageContext = window.ncertPageContext || null;
window.ncertEmitContext = window.ncertEmitContext || function (detail) {
    window.ncertPageContext = detail || {};
    document.dispatchEvent(new CustomEvent('ncert:context-ready', { detail: window.ncertPageContext }));
};
</script>
