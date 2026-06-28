<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Derivative + limit CAS cores for Generic Math AI.
  integral-calculator-core.js is usually loaded by the page tool scripts already.
--%><% String mccV = String.valueOf(System.currentTimeMillis()); %>
<script src="<%=request.getContextPath()%>/modern/js/derivative-calculator-core.js?v=<%=mccV%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/limit-calculator-core.js?v=<%=mccV%>"></script>
