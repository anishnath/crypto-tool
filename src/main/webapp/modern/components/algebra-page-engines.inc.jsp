<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Headless algebra page engines for Generic Math AI chat on ANY tool page
  (Collatz, prime-number, trig, etc.). algebra-solver-core.js delegates here;
  without these scripts chat blocks like ```quadratic``` / ```inequality``` fail with
  "page engine not loaded."

  DOM wiring / image-scan partials stay on each algebra tool JSP only.
  Cores skip auto-init when their page marker element is absent.
--%><% String apeV = String.valueOf(System.currentTimeMillis()); %>
<script>window.__QS_BRIDGE_NO_AUTOSOLVE = true;</script>
<!-- Quadratic — QuadraticSolverCore.solveFromExpr -->
<script src="<%=request.getContextPath()%>/js/quadratic-solver-render.js?v=<%=apeV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/quadratic-solver-input-bridge.js?v=<%=apeV%>"></script>
<script src="<%=request.getContextPath()%>/js/quadratic-solver-core.js?v=<%=apeV%>"></script>
<!-- Systems — SystemsSolverCore.solveFromEquations (needs nerdamer Solve from math-calculus-cores.inc.jsp) -->
<script src="<%=request.getContextPath()%>/js/systems-solver-render.js?v=<%=apeV%>"></script>
<script src="<%=request.getContextPath()%>/js/systems-solver-core.js?v=<%=apeV%>"></script>
<!-- Polynomial — PolyCalcRender (factor/roots/expand used by AlgebraSolverCore) -->
<script src="<%=request.getContextPath()%>/js/polynomial-calculator-render.js?v=<%=apeV%>"></script>
<!-- Inequality — InequalitySolverCore.solveFromRaw (sign-chart engine) -->
<script src="<%=request.getContextPath()%>/js/inequality-solver-headless.js?v=<%=apeV%>"></script>
