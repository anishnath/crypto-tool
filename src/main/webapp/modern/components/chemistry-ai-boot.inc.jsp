<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %><%--
  Chemistry AI — shared module boot for chemistry tools.

  Set before include (optional):
    chemistryAiButtonId — trigger button element id (default btnChemistryAI)
    chemistryAiProfile  — ES module URL for tool profile (e.g. lewis-structure.js)
    chemistryAiProfileExport — profile factory export name (default configure* from filename)
--%><%
String chemistryAiButtonId = (String) request.getAttribute("chemistryAiButtonId");
if (chemistryAiButtonId == null || chemistryAiButtonId.isEmpty()) {
    chemistryAiButtonId = "btnChemistryAI";
}
String chemistryAiProfile = (String) request.getAttribute("chemistryAiProfile");
String chemistryAiProfileExport = (String) request.getAttribute("chemistryAiProfileExport");
%>
<script type="module">
<%@ include file="ai-assistant-boot.inc.jsp" %>
import { wireLazyAssistant } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/lazy-assistant.js';
import { installChemistryOpenAI } from '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/chemistry-ai.js';
<% if (chemistryAiProfile != null && !chemistryAiProfile.isEmpty()) { %>
import { <%= chemistryAiProfileExport != null && !chemistryAiProfileExport.isEmpty() ? chemistryAiProfileExport : "configureChemistryProfile" %> } from '<%= request.getAttribute("aiCtx") %><%= chemistryAiProfile %>';
<% } %>

(function () {
    <% if (chemistryAiProfile != null && !chemistryAiProfile.isEmpty()) { %>
    <%= chemistryAiProfileExport != null && !chemistryAiProfileExport.isEmpty() ? chemistryAiProfileExport : "configureChemistryProfile" %>();
    <% } %>
    var boot = Object.assign({}, aiAssistantBoot, { toolId: 'chemistry-ai' });
    window.chemistryAssistant = wireLazyAssistant({
        moduleUrl: '<%= request.getAttribute("aiCtx") %>/modern/js/ai/adapters/chemistry-ai.js',
        exportName: 'createChemistryAssistant',
        buttonId: '<%= chemistryAiButtonId %>',
        boot: boot,
        prefetchOnHover: true,
        checkoutMessage: false,
    });
    installChemistryOpenAI(window.chemistryAssistant, boot);
})();
</script>
