<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  Shared SymPy-via-OneCompiler backend for the trig calculator family
  (function / equation / identity).  Implementation: js/trig-backend.js
  (bundled in math-ai-cores-engine.js for Math AI pages).

  Public API: window.TrigBackend.compute({ latex, mode, ... }, callback)
--%><% String tcsV = String.valueOf(System.currentTimeMillis()); %>
<script src="<%=request.getContextPath()%>/js/trig-backend.js?v=<%=tcsV%>"></script>
