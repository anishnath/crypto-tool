<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Unified Math AI CAS engine — ONE script load for all chat compute cores
  (integral · derivative · limit · ODE · PDE · matrix · bode · algebra · trig · statistics).

  Source modules live as individual *-core.js files; rebuild the engine after edits:
    cd scripts && npm install   # first time only (terser)
    node scripts/build-math-ai-cores-bundle.mjs

  Include on every page that uses math-ai-boot.inc.jsp + generic-calculus profile.
  Calculator pages should use math-tool-engine-boot.inc.jsp (libs + engine, one CAS load).
  Pages with math-libs.jsp alone still get nerdamer from math-libs when skip flag is unset.
--%><% String mccV = String.valueOf(System.currentTimeMillis()); %>
<script src="<%=request.getContextPath()%>/modern/js/math-ai-cores-engine.js?v=<%=mccV%>"></script>
