<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  AI assistant — stylesheet. Include in <head>.

  Usage:
    <%@ include file="../modern/components/ai-assistant-vars.inc.jsp" %>
    <%@ include file="../modern/components/ai-assistant-head.inc.jsp" %>
--%><%@ page import="z.y.x.ai.AiAssistantPageSupport" %><%
AiAssistantPageSupport.ensurePageVars(pageContext);
String aiHeadCtx = (String) request.getAttribute("aiCtx");
%><link rel="stylesheet" href="<%= aiHeadCtx %>/modern/css/vibe-coding-assistant.css">
