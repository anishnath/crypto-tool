<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Kotlin Compiler & IDE - Run Kotlin Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run Kotlin online with a free compiler and IDE. Write, execute, and share Kotlin code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-kotlin-compiler/");
request.setAttribute("preferredLanguage", "kotlin");
request.setAttribute("h1Text", "Online Kotlin Compiler – Run Kotlin Online (1.9, 2.0)");
request.setAttribute("seoIntroTitle", "Run Kotlin Online (1.9, 2.0)");
request.setAttribute("seoIntroBody", "Write and run Kotlin online targeting versions 1.9 or 2.0. Multi‑file projects supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> Kotlin 1.9, 2.0.</p>" +
    "<p><strong>How do I run?</strong> Ensure a file with a <code>main</code> function is present.</p>" +
    "<p><strong>Share?</strong> Use Share to generate a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Kotlin versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Kotlin 1.9 and 2.0.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How to run the program?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Ensure a file has a main function.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to copy a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
