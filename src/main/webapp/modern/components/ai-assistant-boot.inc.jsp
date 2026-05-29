<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  AI assistant — JS boot object for ToolAiAssistant / adapters.
  Static-include inside <script type="module"> before constructing the assistant.

  Optional page/request attributes (set before ai-assistant-vars.inc.jsp):
    aiToolId            — default ""
    aiBillingEnabled    — default true

  Usage (minimal tool page):
    <% request.setAttribute("aiToolId", "seo-checker"); %>
    <%@ include file="../modern/components/ai-assistant-vars.inc.jsp" %>

    <script type="module">
    <%@ include file="../modern/components/ai-assistant-boot.inc.jsp" %>
    import { createGenericToolAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/generic-tool-adapter.js';

    const ai = createGenericToolAssistant({
      ...aiAssistantBoot,
      title: 'SEO AI',
      systemPrompt: 'You help with SEO analysis.',
      seedContext: () => document.getElementById('input').value,
    });
    ai.mount();
    document.getElementById('btnAI')?.addEventListener('click', () => ai.open());
    </script>
--%><%@ page import="z.y.x.ai.AiAssistantPageSupport" %><%
AiAssistantPageSupport.ensurePageVars(pageContext);
String aiBootCtx = (String) request.getAttribute("aiCtx");
boolean aiBootUseGateway = ((Boolean) request.getAttribute("aiUseGateway")).booleanValue();
String aiBootFreeRoute = (String) request.getAttribute("aiFreeRoute");
String aiBootUserIdJs = (String) request.getAttribute("aiUserIdJs");
String aiBootRouteModeJs = (String) request.getAttribute("aiRouteModeJs");
String aiBootUrlPath = (String) request.getAttribute("aiUrlPath");
String aiBootToolId = AiAssistantPageSupport.escapeJs(
    AiAssistantPageSupport.param(pageContext, "aiToolId", ""));
boolean aiBootBilling = AiAssistantPageSupport.paramBool(pageContext, "aiBillingEnabled", true);
%>
const aiAssistantBoot = {
  ctx: '<%= aiBootCtx %>',
  aiUrl: '<%= aiBootCtx %><%= aiBootUrlPath %>',
  useGateway: <%= aiBootUseGateway %>,
  aiRouteMode: <%= aiBootRouteModeJs %>,
  aiRouteByTier: {
    guest: 'legacy',
    free: '<%= aiBootFreeRoute %>',
    pro: 'gateway',
  },
  userId: '<%= aiBootUserIdJs %>',
  toolId: '<%= aiBootToolId %>',
  billing: {
    enabled: <%= aiBootBilling %>,
    ctx: '<%= aiBootCtx %>',
    userId: '<%= aiBootUserIdJs %>',
  },
};
