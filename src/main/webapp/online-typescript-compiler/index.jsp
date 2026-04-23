<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI TypeScript Compiler - Run, Fix & Explain TS Code Free");
request.setAttribute("pageDescription", "Run TypeScript (Node.js) online with a free compiler and IDE. Write, execute, and share TypeScript code with examples and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-typescript-compiler/");
request.setAttribute("preferredLanguage", "typescript");
request.setAttribute("h1Text", "Online TypeScript Compiler – Run TS Online (TS 5.3 on Node 20)");
request.setAttribute("seoIntroTitle", "Run TypeScript Online (TS 5.3 on Node 20)");
request.setAttribute("seoIntroBody", "Write TypeScript and run it online. The environment compiles TS 5.3 and runs it on Node.js 20. Perfect for quick demos and teaching.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions are used?</strong> TypeScript 5.3 compiled and executed on Node.js 20.</p>" +
    "<p><strong>How do I share code?</strong> Use the Share button to generate a URL.</p>" +
    "<p><strong>Can I import packages?</strong> Prefer self‑contained examples; external packages vary by template.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which versions are used?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"TypeScript 5.3 compiled and executed on Node.js 20.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use the Share button to generate a URL.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Can I import packages?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Prefer self‑contained examples; external packages vary by template.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
