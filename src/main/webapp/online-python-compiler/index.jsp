<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Python Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run Python online and visualize algorithms step by step—watch arrays, dicts, recursion, trees and graphs animate as your code runs. Free algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-python-compiler/");
request.setAttribute("preferredLanguage", "python");
request.setAttribute("h1Text", "Online Python Compiler & Algorithm Visualizer (3.9, 3.10, 3.11)");
request.setAttribute("seoIntroTitle", "Run & Visualize Python Online (3.9, 3.10, 3.11)");
request.setAttribute("seoIntroBody", "Write and execute Python in your browser. Supports Python 3.9, 3.10, and 3.11 with popular packages like requests, numpy, and pandas. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your code run line by line as lists, dicts, sets, heaps, trees, linked lists, and graphs animate step by step — ideal for learning sorting, binary search, recursion, and BFS/DFS. Share snippets, stdin, and multi‑file projects.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does it include a Python algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while lists, dicts, sets, heaps, trees, linked lists, and graphs animate — a built‑in algorithm visualizer that highlights each read and write and the current line.</p>" +
    "<p><strong>Which algorithms can I visualize?</strong> Sorting (bubble, selection, insertion, merge sort), binary search, two‑pointer techniques, recursion, tree and graph traversals (BFS/DFS), and linked‑list operations — watch the data structures update step by step.</p>" +
    "<p><strong>Which Python versions are available?</strong> Python 3.9, 3.10, and 3.11 are available.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to generate a URL that preserves your files, input, and Python version.</p>" +
    "<p><strong>Are packages supported?</strong> Common packages are available in examples. For portability, prefer self‑contained snippets.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online Python compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your code while lists, dicts, sets, heaps, trees, linked lists, and graphs animate — a built-in algorithm visualizer that highlights each read and write and the current line of code.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which algorithms can I visualize in Python?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Sorting (bubble, selection, insertion, merge sort), binary search, two-pointer techniques, recursion, tree and graph traversals (BFS/DFS), and linked-list operations. The data structures update step by step as the code runs.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Python versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Python 3.9, 3.10, and 3.11 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a URL that preserves your files, input, and Python version.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Are packages supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Common packages are available in examples. For portability, prefer self-contained snippets.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
