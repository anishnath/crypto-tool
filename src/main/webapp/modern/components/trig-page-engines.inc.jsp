<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Trig page engines for Generic Math AI chat on ANY tool page.
  TrigChatCore delegates to TrigBackend (SymPy) + TrigGraph (Plotly).
  Production Math AI pages load math-ai-cores-engine.js instead of this include.
--%><% String tpeV = String.valueOf(System.currentTimeMillis()); %>
<script>window.TRIG_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/js/trig-common.js?v=<%=tpeV%>"></script>
<script src="<%=request.getContextPath()%>/js/trig-graph.js?v=<%=tpeV%>"></script>
<script src="<%=request.getContextPath()%>/js/trig-backend.js?v=<%=tpeV%>"></script>
