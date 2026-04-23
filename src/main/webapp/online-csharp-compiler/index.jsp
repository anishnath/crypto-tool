<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI C# Compiler - Run, Fix & Explain C# Code Free");
request.setAttribute("pageDescription", "Run C# online with a free compiler and IDE. Write, execute, and share C# code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-csharp-compiler/");
request.setAttribute("preferredLanguage", "csharp");
request.setAttribute("h1Text", "Online C# Compiler – Run C# Online (6, 7, 8)");
request.setAttribute("seoIntroTitle", "Run C# Online (6, 7, 8)");
request.setAttribute("seoIntroBody", "Write and run C# online. Choose language levels 6, 7, or 8 for examples and interviews.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which C# versions are supported?</strong> C# language levels 6, 7, and 8.</p>" +
    "<p><strong>Multi‑file projects?</strong> Yes, add additional .cs files and a Main entry point.</p>" +
    "<p><strong>How do I share code?</strong> Use Share to generate a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which C# versions are supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"C# language levels 6, 7, and 8.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Multi‑file projects?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes, add additional .cs files and a Main entry point.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a link.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
