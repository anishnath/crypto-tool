<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Inline SEO AI Fix boot (not full VibeCodingAssistant).
  Set before include:
    request.setAttribute("aiToolId", "seo/lighthouse");
    request.setAttribute("aiRequireSignIn", "true");  // optional, default true

  Requires ai-assistant-vars.inc.jsp in page <head> or before this include.
--%><%@ page import="z.y.x.ai.AiAssistantPageSupport" %><%
AiAssistantPageSupport.ensurePageVars(pageContext);
if (request.getAttribute("aiRequireSignIn") == null) {
  request.setAttribute("aiRequireSignIn", "true");
}
String seoBootCtx = (String) request.getAttribute("aiCtx");
boolean seoBootUseGateway = ((Boolean) request.getAttribute("aiUseGateway")).booleanValue();
String seoBootUserIdJs = (String) request.getAttribute("aiUserIdJs");
String seoBootUrlPath = (String) request.getAttribute("aiUrlPath");
String seoBootToolId = AiAssistantPageSupport.escapeJs(
    AiAssistantPageSupport.param(pageContext, "aiToolId", ""));
boolean seoBootRequireSignIn = AiAssistantPageSupport.paramBool(pageContext, "aiRequireSignIn", true);
%>
<script>
window.seoAiBoot = {
  ctx: '<%= seoBootCtx %>',
  aiUrl: '<%= seoBootCtx %><%= seoBootUrlPath %>',
  useGateway: <%= seoBootUseGateway %>,
  userId: '<%= seoBootUserIdJs %>',
  toolId: '<%= seoBootToolId %>',
  requireSignIn: <%= seoBootRequireSignIn %>
};
</script>
