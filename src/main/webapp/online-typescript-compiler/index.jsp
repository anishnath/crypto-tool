<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online TypeScript Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run TypeScript (Node.js) online and visualize algorithms step by step—watch arrays, matrices, Maps, Sets, linked lists, and trees animate as your code runs. Free online TypeScript compiler with a built‑in algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-typescript-compiler/");
request.setAttribute("preferredLanguage", "typescript");
request.setAttribute("h1Text", "Online TypeScript Compiler & Algorithm Visualizer – Run TS Online (TS 5.3 on Node 20)");
request.setAttribute("seoIntroTitle", "Run & Visualize TypeScript Online (TS 5.3 on Node 20)");
request.setAttribute("seoIntroBody", "Write TypeScript and run it online — compiled as TS 5.3 and executed on Node.js 20. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your code run line by line as arrays (<code>number[]</code>), 2D matrices, <code>Map</code>, <code>Set</code>, linked lists, and binary trees animate step by step — with a call‑stack view for recursion. Ideal for learning sorting, binary search, recursion, BST/tree traversals, and frequency counting. Share snippets and run quick demos with no setup.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does the online TypeScript compiler include an algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while arrays, matrices, Maps, Sets, linked lists, and trees animate — a built‑in TypeScript/JavaScript visualizer that highlights each read and write, the current line, and the call stack for recursion.</p>" +
    "<p><strong>Which data structures and algorithms can I visualize?</strong> <code>number[]</code> and <code>number[][]</code> arrays, <code>Map</code> and <code>Set</code>, and object‑based linked lists and binary trees (<code>{ val, next }</code> / <code>{ val, left, right }</code>) — great for sorting, binary search, counting (<code>count[x]++</code>), recursion, and BST/tree traversals.</p>" +
    "<p><strong>Which versions are used?</strong> TypeScript 5.3 compiled and executed on Node.js 20.</p>" +
    "<p><strong>How do I share code?</strong> Use the Share button to generate a URL.</p>" +
    "<p><strong>Can I import packages?</strong> Prefer self‑contained examples; external packages vary by template.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online TypeScript compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your TypeScript code while arrays, matrices, Maps, Sets, linked lists, and trees animate — a built-in visualizer that highlights each read and write, the current line, and the call stack for recursion.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which data structures and algorithms can I visualize in TypeScript?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"number[] and number[][] arrays, Map and Set, and object-based linked lists and binary trees ({ val, next } / { val, left, right }). Ideal for sorting, binary search, counting (count[x]++), recursion, and BST/tree traversals.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which versions are used?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"TypeScript 5.3 compiled and executed on Node.js 20.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use the Share button to generate a URL.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Can I import packages?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Prefer self-contained examples; external packages vary by template.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
