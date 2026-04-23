<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI JavaScript Compiler - Run, Fix & Explain JS Code Free");
request.setAttribute("pageDescription", "Run JavaScript (Node.js) online with a free compiler and IDE. Write, execute, and share JS code with examples and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-javascript-compiler/");
request.setAttribute("preferredLanguage", "javascript");
request.setAttribute("h1Text", "Online JavaScript Compiler – Run JS Online (Node 18, 20, 21)");
request.setAttribute("seoIntroTitle", "Run JavaScript (Node.js) Online (18, 20, 21)");
request.setAttribute("seoIntroBody", "Execute Node.js scripts in your browser using versions 18, 20, or 21. Great for quick JS experiments, utilities, and interview tasks. Multi‑file and stdin supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which Node.js versions are available?</strong> Node.js 18, 20, and 21 are available.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to generate a permalink for your snippet.</p>" +
    "<p><strong>Should I use TypeScript?</strong> For TS, use the TypeScript page which compiles TS 5.3 on Node 20.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Node.js versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Node.js 18, 20, and 21 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a permalink for your snippet.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Should I use TypeScript?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"For TS, use the TypeScript page which compiles TS 5.3 on Node 20.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
