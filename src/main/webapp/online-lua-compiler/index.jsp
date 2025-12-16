<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Lua Compiler & IDE - Run Lua Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run Lua online with a free compiler and IDE. Write, execute, and share Lua code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-lua-compiler/");
request.setAttribute("preferredLanguage", "lua");
request.setAttribute("h1Text", "Online Lua Compiler – Run Lua Online (5.4)");
request.setAttribute("seoIntroTitle", "Run Lua Online (5.4)");
request.setAttribute("seoIntroBody", "Write and run Lua 5.4 code online. Simple, fast, and great for learning.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which version?</strong> Lua 5.4.</p>" +
    "<p><strong>Multi‑file?</strong> Yes, add additional .lua files.</p>" +
    "<p><strong>Share?</strong> Use Share for a permalink.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Lua version is available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Lua 5.4.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Multi‑file?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes, add additional .lua files.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
