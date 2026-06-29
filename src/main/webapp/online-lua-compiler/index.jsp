<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Lua Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run Lua online and visualize algorithms step by step—watch tables (arrays, matrices, maps) animate and the call stack grow as your code runs. Free online Lua 5.4 compiler with a built‑in algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-lua-compiler/");
request.setAttribute("preferredLanguage", "lua");
request.setAttribute("h1Text", "Online Lua Compiler & Algorithm Visualizer – Run Lua Online (5.4)");
request.setAttribute("seoIntroTitle", "Run & Visualize Lua Online (5.4)");
request.setAttribute("seoIntroBody", "Write and run Lua 5.4 code online. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your code run line by line as tables animate — arrays, 2D matrices, and hash maps update step by step, with a call‑stack view for recursion. Your script runs unchanged; the visualizer observes it through Lua's debug hooks. Ideal for learning sorting, binary search, recursion, and frequency counting. Multi‑file and shareable snippet URLs supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does the online Lua compiler include an algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while tables animate — arrays, 2D matrices, and maps update, the current line is highlighted, and the call stack tracks recursion. Your code runs unchanged; nothing to import.</p>" +
    "<p><strong>Which data structures can I visualize?</strong> Lua tables: dense integer‑keyed tables render as arrays (1‑based), nested tables as 2D matrices, and string/sparse‑keyed tables as hash maps. Great for sorting, binary search, recursion, and frequency counts.</p>" +
    "<p><strong>Which Lua version is available?</strong> Lua 5.4.</p>" +
    "<p><strong>Multi‑file?</strong> Yes, add additional .lua files.</p>" +
    "<p><strong>How do I share?</strong> Click Share to generate a URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online Lua compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your Lua code while tables animate — arrays, 2D matrices, and maps update, the current line is highlighted, and the call stack tracks recursion. Your code runs unchanged.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which data structures can I visualize in Lua?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Lua tables: dense integer-keyed tables render as arrays (1-based), nested tables as 2D matrices, and string or sparse-keyed tables as hash maps. Ideal for sorting, binary search, recursion, and frequency counts.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Lua version is available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Lua 5.4.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Multi-file?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes, add additional .lua files.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
