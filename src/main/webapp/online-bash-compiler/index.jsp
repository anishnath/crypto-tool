<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Bash Shell & IDE - Run Bash Scripts Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run Bash scripts online with a free shell environment. Write, execute, and share Bash code with stdin support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-bash-compiler/");
request.setAttribute("preferredLanguage", "test");
request.setAttribute("h1Text", "Online Bash Shell – Run Bash Scripts Online (Test Environment)");
request.setAttribute("seoIntroTitle", "Run Bash Online (Test Environment)");
request.setAttribute("seoIntroBody", "Execute simple Bash scripts in a sandboxed environment. Great for shell snippets and small demonstrations.");
request.setAttribute("languageFaqHtml",
    "<p><strong>What is this?</strong> A test environment for lightweight Bash scripts.</p>" +
    "<p><strong>Stdin?</strong> Yes, provide input in the Stdin panel.</p>" +
    "<p><strong>Share?</strong> Click Share to get a URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"What environment is this?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"A test environment for lightweight Bash scripts.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Stdin supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes, provide input in the Stdin panel.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to get a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
