<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Algebra AI — headless router + context path for chat engines.
  Page-specific scripts (quadratic-core, systems-core, etc.) must load before this.
--%><% String acV = String.valueOf(System.currentTimeMillis()); %>
<script>window.ALGEBRA_CALC_CTX = "<%=request.getContextPath()%>"; window.MATH_CALC_CTX = window.MATH_CALC_CTX || window.ALGEBRA_CALC_CTX;</script>
<script src="<%=request.getContextPath()%>/modern/js/algebra-solver-core.js?v=<%=acV%>"></script>
