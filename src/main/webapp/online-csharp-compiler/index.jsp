<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online C# Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run C# online and visualize algorithms step by step—watch arrays, lists, dictionaries, sets, stacks, queues, linked lists, trees, and threads animate as your code runs. Free online C# compiler with a built‑in algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-csharp-compiler/");
request.setAttribute("preferredLanguage", "csharp");
request.setAttribute("h1Text", "Online C# Compiler & Algorithm Visualizer – Run C# Online (6, 7, 8)");
request.setAttribute("seoIntroTitle", "Run & Visualize C# Online (6, 7, 8)");
request.setAttribute("seoIntroBody", "Write and run C# online (language levels 6, 7, 8). Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your code run line by line as <code>int[]</code>, <code>List</code>, <code>Dictionary</code>, <code>HashSet</code>, <code>Stack</code>/<code>Queue</code>, 2D matrices, linked lists, and binary trees animate step by step — with a call‑stack view for recursion and thread swim lanes (<code>lock</code> hand‑off and deadlock detection) for concurrency. Ideal for learning sorting, binary search, recursion, BFS/DFS, hashing, and tree traversals. Multi‑file and shareable snippet URLs supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does the online C# compiler include an algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while arrays, lists, dictionaries, sets, stacks, queues, linked lists, and trees animate — a built‑in C# visualizer that highlights each read and write, the current line, and the call stack for recursion.</p>" +
    "<p><strong>Which data structures and algorithms can I visualize?</strong> <code>int[]</code> and <code>List&lt;int&gt;</code>, 2D matrices (<code>int[,]</code> / <code>int[][]</code>), <code>Dictionary</code>, <code>HashSet</code>, <code>Stack</code>/<code>Queue</code>, and class‑based linked lists and binary trees — plus thread &amp; <code>lock</code> concurrency shown as swim lanes with deadlock detection. Great for sorting, binary search, recursion, BFS/DFS, frequency counting, and BST traversals.</p>" +
    "<p><strong>Which C# versions are supported?</strong> C# language levels 6, 7, and 8.</p>" +
    "<p><strong>Multi‑file projects?</strong> Yes, add additional .cs files and a Main entry point.</p>" +
    "<p><strong>How do I share code?</strong> Use Share to generate a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online C# compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your C# code while arrays, lists, dictionaries, sets, stacks, queues, linked lists, and trees animate — a built-in C# algorithm visualizer that highlights each read and write, the current line, and the call stack for recursion.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which data structures and algorithms can I visualize in C#?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"int[] and List<int>, 2D matrices (int[,] / int[][]), Dictionary, HashSet, Stack/Queue, and class-based linked lists and binary trees, plus thread and lock concurrency shown as swim lanes with deadlock detection. Ideal for sorting, binary search, recursion, BFS/DFS, frequency counting, and BST traversals.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which C# versions are supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"C# language levels 6, 7, and 8.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Are multi-file projects supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes, add additional .cs files and a Main entry point.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a link.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
