<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Math AI — shared module boot for math tools.

  Set before include (optional):
    mathAiButtonId — trigger button element id (default btnMathAI)
    mathAiProfile  — ES module URL for tool profile
    mathAiProfileExport — profile factory export name
--%><%
String mathAiButtonId = (String) request.getAttribute("mathAiButtonId");
if (mathAiButtonId == null || mathAiButtonId.isEmpty()) {
    mathAiButtonId = "btnMathAI";
}
String mathAiProfile = (String) request.getAttribute("mathAiProfile");
String mathAiProfileExport = (String) request.getAttribute("mathAiProfileExport");
%>
<script type="module">
<%@ include file="ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';
import { installMathOpenAI } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/math-ai.js';
<% if (mathAiProfile != null && !mathAiProfile.isEmpty()) { %>
import { <%= mathAiProfileExport != null && !mathAiProfileExport.isEmpty() ? mathAiProfileExport : "configureMathProfile" %> } from '<%= request.getAttribute("aiCtx") %><%= mathAiProfile %>';
<% } %>

(function () {
    // Context root for the SymPy backend fetch (nerdamer/SymPy cores read this).
    // Server-rendered so it never depends on a meta tag being present.
    window.MATH_CALC_CTX = '<%= request.getAttribute("aiCtx") %>';
    <% if (mathAiProfile != null && !mathAiProfile.isEmpty()) { %>
    <%= mathAiProfileExport != null && !mathAiProfileExport.isEmpty() ? mathAiProfileExport : "configureMathProfile" %>();
    <% } %>
    var boot = Object.assign({}, aiAssistantBoot, {
        toolId: 'math-ai',
        // Image scan on by default for math tool pages; a page can opt out with
        // request.setAttribute("aiImageUpload", "false").
        imageUpload: <%= !"false".equals(String.valueOf(request.getAttribute("aiImageUpload"))) %>,
    });
    window.mathAssistant = wireLazyAssistant({
        moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/math-ai.js',
        exportName: 'createMathAssistant',
        buttonId: '<%= mathAiButtonId %>',
        boot: boot,
        prefetchOnHover: true,
        checkoutMessage: false,
    });
    installMathOpenAI(window.mathAssistant, boot);
})();
</script>
