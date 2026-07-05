<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Math AI — embedded VCA chat for hub pages (math/index.jsp).
  Same interface as calculator ✨ AI popups; Math Studio provides the page shell only.

  Set before include (required):
    mathAiEmbedMountId — element id for the chat mount point

  Optional:
    mathAiProfile        — ES module URL for tool profile
    mathAiProfileExport  — profile factory export name
--%><%
String mathAiEmbedMountId = (String) request.getAttribute("mathAiEmbedMountId");
if (mathAiEmbedMountId == null || mathAiEmbedMountId.isEmpty()) {
    mathAiEmbedMountId = "mathAiEmbed";
}
String mathAiProfile = (String) request.getAttribute("mathAiProfile");
String mathAiProfileExport = (String) request.getAttribute("mathAiProfileExport");
%>
<script type="module">
<%@ include file="ai-assistant-boot.inc.jsp" %>
import { wireEmbeddedAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';
import { installMathOpenAI } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/math-ai.js';
<% if (mathAiProfile != null && !mathAiProfile.isEmpty()) { %>
import { <%= mathAiProfileExport != null && !mathAiProfileExport.isEmpty() ? mathAiProfileExport : "configureMathProfile" %> } from '<%= request.getAttribute("aiCtx") %><%= mathAiProfile %>';
<% } %>

(function () {
    <% if (mathAiProfile != null && !mathAiProfile.isEmpty()) { %>
    <%= mathAiProfileExport != null && !mathAiProfileExport.isEmpty() ? mathAiProfileExport : "configureMathProfile" %>();
    <% } %>
    var boot = Object.assign({}, aiAssistantBoot, {
        toolId: 'math-ai-hub',
    });
    window.mathAssistant = wireEmbeddedAssistant({
        moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/math-ai.js',
        exportName: 'createMathAssistant',
        mountTarget: '#<%= mathAiEmbedMountId %>',
        boot: boot,
        onReady: function () {
            if (new URLSearchParams(window.location.search).get('checkout') === '1') {
                var u = new URL(window.location.href);
                u.searchParams.delete('checkout');
                window.history.replaceState({}, '', u.pathname + u.search + u.hash);
                window.mathAssistant.open('Payment received — Pro activates shortly after Dodo confirms.', false);
            }
        },
    });
    installMathOpenAI(window.mathAssistant, boot);
})();
</script>
