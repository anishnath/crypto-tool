<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  CAS cores for the Generic Math AI (integral · derivative · limit · ODE · PDE · matrix · bode · algebra).
  Safe to include on any math page: re-loading a core just re-assigns its window
  global (pure-function IIFE). Loading the integral core here guarantees the
  derivative/limit/ODE cores have normalizeExpr/latexBodyToExpr available even on
  pages whose own tool scripts don't pull it in (e.g. the ODE solver page).

  Nerdamer (core + Algebra + Calculus) is included here when a page uses Math AI
  chat engines but does not also include math-libs.jsp (e.g. vector-calculator,
  prime-number, laplace, bode). Pages that already load math-libs.jsp get the
  same scripts twice; re-execution is harmless.

  Include this on every page that uses math-ai-boot.inc.jsp + generic-calculus
  profile so the full chat router (∫, d/dx, lim, ODE, PDE, matrix, bode,
  laplace, vector, algebra) has its engines. Algebra-only pages previously
  shipped algebra-cores.inc.jsp alone and failed cross-domain Solve chips.
--%><% String mccV = String.valueOf(System.currentTimeMillis()); %>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/nerdamer.core.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Algebra.js"></script>
<script src="https://cdn.jsdelivr.net/npm/nerdamer@1.1.13/Calculus.js"></script>
<script>
(function () {
  if (typeof window.loadPlotly === 'function') return;
  var __mccPlotlyLoaded = false;
  window.loadPlotly = function loadPlotly(cb) {
    if (__mccPlotlyLoaded || window.Plotly) {
      __mccPlotlyLoaded = true;
      if (cb) cb();
      return;
    }
    var s = document.createElement('script');
    s.src = 'https://cdn.plot.ly/plotly-2.27.0.min.js';
    s.onload = function () {
      __mccPlotlyLoaded = true;
      if (cb) cb();
    };
    document.head.appendChild(s);
  };
})();
</script>
<script>window.MATH_CALC_CTX = "<%=request.getContextPath()%>";</script>
<script src="<%=request.getContextPath()%>/modern/js/integral-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/derivative-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/limit-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/ode-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/pde-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/vc-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/matrix-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/matrix-calculator-viz.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/bode-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/laplace-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/algebra-solver-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/js/vector-calculator-render.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/vector-discrete-core.js?v=<%=mccV%>"></script>
