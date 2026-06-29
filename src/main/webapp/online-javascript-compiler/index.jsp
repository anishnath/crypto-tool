<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online JavaScript Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run JavaScript (Node.js) online and visualize algorithms step by step—watch arrays, matrices, Maps, Sets, linked lists, and trees animate as your code runs. Free online JavaScript compiler with a built‑in algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-javascript-compiler/");
request.setAttribute("preferredLanguage", "javascript");
request.setAttribute("h1Text", "Online JavaScript Compiler & Algorithm Visualizer – Run JS Online (Node 18, 20, 21)");
request.setAttribute("seoIntroTitle", "Run & Visualize JavaScript (Node.js) Online (18, 20, 21)");
request.setAttribute("seoIntroBody", "Execute Node.js scripts in your browser using versions 18, 20, or 21. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your code run line by line as arrays, 2D matrices, <code>Map</code>, <code>Set</code>, linked lists, and binary trees animate step by step — with a call‑stack view for recursion. Ideal for learning sorting, binary search, recursion, BST/tree traversals, and frequency counting. Multi‑file, stdin, and shareable snippet URLs supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does the online JavaScript compiler include an algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while arrays, matrices, Maps, Sets, linked lists, and trees animate — a built‑in JavaScript visualizer that highlights each read and write, the current line, and the call stack for recursion.</p>" +
    "<p><strong>Which data structures and algorithms can I visualize?</strong> Arrays and 2D arrays, <code>Map</code> and <code>Set</code>, and object‑based linked lists and binary trees (<code>{ val, next }</code> / <code>{ val, left, right }</code>) — great for sorting, binary search, counting (<code>count[x]++</code>), recursion, and BST/tree traversals.</p>" +
    "<p><strong>Which Node.js versions are available?</strong> Node.js 18, 20, and 21 are available.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to generate a permalink for your snippet.</p>" +
    "<p><strong>Should I use TypeScript?</strong> For TS, use the TypeScript page which compiles TS 5.3 on Node 20.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online JavaScript compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your JavaScript code while arrays, matrices, Maps, Sets, linked lists, and trees animate — a built-in visualizer that highlights each read and write, the current line, and the call stack for recursion.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which data structures and algorithms can I visualize in JavaScript?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Arrays and 2D arrays, Map and Set, and object-based linked lists and binary trees ({ val, next } / { val, left, right }). Ideal for sorting, binary search, counting (count[x]++), recursion, and BST/tree traversals.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Node.js versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Node.js 18, 20, and 21 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a permalink for your snippet.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Should I use TypeScript?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"For TS, use the TypeScript page which compiles TS 5.3 on Node 20.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
