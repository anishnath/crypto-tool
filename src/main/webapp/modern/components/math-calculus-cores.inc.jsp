<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  CAS cores for the Generic Math AI (integral · derivative · limit · ODE · PDE).
  Safe to include on any math page: re-loading a core just re-assigns its window
  global (pure-function IIFE). Loading the integral core here guarantees the
  derivative/limit/ODE cores have normalizeExpr/latexBodyToExpr available even on
  pages whose own tool scripts don't pull it in (e.g. the ODE solver page).
--%><% String mccV = String.valueOf(System.currentTimeMillis()); %>
<script>window.MATH_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/derivative-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/limit-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/ode-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/pde-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/vc-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/matrix-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/matrix-calculator-viz.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/algebra-solver-core.js?v=<%=mccV%>"></script>
