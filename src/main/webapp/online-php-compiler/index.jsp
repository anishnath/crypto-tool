<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI PHP Compiler - Run, Fix & Explain PHP Code Free");
request.setAttribute("pageDescription", "Run PHP online with a free compiler and IDE. Write, execute, and share PHP code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-php-compiler/");
request.setAttribute("preferredLanguage", "php");
request.setAttribute("h1Text", "Online PHP Compiler – Run PHP Online (8.1, 8.2, 8.3)");
request.setAttribute("seoIntroTitle", "Run PHP Online (8.1, 8.2, 8.3)");
request.setAttribute("seoIntroBody", "Execute PHP scripts online using PHP 8.1, 8.2, or 8.3. Great for learning and quick experiments.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which PHP versions are available?</strong> PHP 8.1, 8.2, and 8.3 are available.</p>" +
    "<p><strong>How do I share code?</strong> Use Share to generate a URL for your snippet.</p>" +
    "<p><strong>Are extensions supported?</strong> Prefer self‑contained examples; extension availability varies by template.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which PHP versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"PHP 8.1, 8.2, and 8.3 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a URL for your snippet.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Are extensions supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Prefer self‑contained examples; extension availability varies by template.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
