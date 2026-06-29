<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online C++ Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run C++ online and visualize algorithms step by step—watch arrays, vectors, maps, sets, stacks, queues, heaps, linked lists, trees, and threads animate as your code runs. Free online C++ compiler with a built‑in algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-cpp-compiler/");
request.setAttribute("preferredLanguage", "cpp");
request.setAttribute("h1Text", "Online C++ Compiler & Algorithm Visualizer – Run C++ Online (GCC 12, 13)");
request.setAttribute("seoIntroTitle", "Run & Visualize C++ Online (GCC 12, 13)");
request.setAttribute("seoIntroBody", "Compile and run C++ online with GCC 12 or 13 (C++20 flags like <code>-O3</code> and <code>-std=c++20</code>). Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your C++ code run line by line as arrays, <code>std::vector</code>, <code>std::map</code>, <code>std::set</code>, <code>std::stack</code>/<code>queue</code>/<code>priority_queue</code>, linked lists, and binary trees animate step by step — with a call‑stack view for recursion and <code>std::thread</code> swim lanes (mutex hand‑off and deadlock detection) for concurrency. Ideal for learning sorting, binary search, recursion, BFS/DFS, and heaps. Supports shareable snippet URLs, stdin, and multi‑file projects.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does the online C++ compiler include an algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while vectors, maps, sets, stacks, queues, heaps, linked lists, and trees animate — a built‑in C++ visualizer that highlights each read and write, the current line, and the call stack for recursion.</p>" +
    "<p><strong>Which C++ data structures and algorithms can I visualize?</strong> Raw int arrays and <code>std::vector</code>, 2D matrices (<code>int[][]</code> and <code>vector&lt;vector&gt;</code>), <code>std::map</code>/<code>std::set</code>, <code>std::stack</code>/<code>queue</code>/<code>priority_queue</code>, singly linked lists, and binary trees — plus <code>std::thread</code> concurrency (mutex lock/unlock as swim lanes with deadlock detection). Great for sorting, binary search, recursion, BFS/DFS, and heaps.</p>" +
    "<p><strong>Which GCC versions are available?</strong> GCC 12 and GCC 13 are available.</p>" +
    "<p><strong>How to pass compiler flags?</strong> Use the Compiler Args field, e.g., <code>-std=c++20</code> or <code>-O3</code>.</p>" +
    "<p><strong>How do I share code?</strong> Use Share to generate a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online C++ compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your C++ code while vectors, maps, sets, stacks, queues, heaps, linked lists, and trees animate — a built-in C++ algorithm visualizer that highlights each read and write, the current line, and the call stack for recursion.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which C++ data structures and algorithms can I visualize?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Raw int arrays and std::vector, 2D matrices (int[][] and vector<vector>), std::map/std::set, std::stack/queue/priority_queue, singly linked lists, and binary trees, plus std::thread concurrency (mutex lock/unlock as swim lanes with deadlock detection). Ideal for sorting, binary search, recursion, BFS/DFS, and heaps.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which GCC versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"GCC 12 and GCC 13 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How to pass compiler flags?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use the Compiler Args field, e.g., -std=c++20 or -O3.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a link.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
