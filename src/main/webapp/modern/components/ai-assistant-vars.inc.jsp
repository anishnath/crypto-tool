<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  AI assistant — server-side vars (gateway flags, OAuth user id, context path).
  Include once near the top of any tool JSP that uses the AI assistant.

  Optional page/request attributes (set before this include):
    aiToolId            — billing + localStorage key (default "")
    aiBillingEnabled    — "true" | "false" (default true)

  Usage:
    <% request.setAttribute("aiToolId", "my-tool"); %>
    <%@ include file="../modern/components/ai-assistant-vars.inc.jsp" %>
--%><%@ page import="z.y.x.ai.AiAssistantPageSupport" %><%
AiAssistantPageSupport.ensurePageVars(pageContext);
%>
