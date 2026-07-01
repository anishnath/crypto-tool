<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Shared math page bootstrap: site libs (KaTeX, Plotly loader, tool-utils, …)
  WITHOUT duplicate nerdamer, plus the unified math-ai-cores-engine.js.

  Use on calculator pages instead of:
    <jsp:include page="/math/partials/math-libs.jsp" />
    … tool scripts …
    <%@ include file="…/math-calculus-cores.inc.jsp" %>

  Load BEFORE any tool partial that depends on *CalculatorCore globals.
--%>
<% request.setAttribute("mathLibsSkipNerdamer", Boolean.TRUE); %>
<jsp:include page="/math/partials/math-libs.jsp" />
<%@ include file="/modern/components/math-calculus-cores.inc.jsp" %>
