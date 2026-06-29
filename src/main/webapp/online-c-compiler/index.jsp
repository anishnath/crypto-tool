<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online C Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run C online and visualize algorithms step by step—watch arrays, strings, matrices, linked lists, trees, and threads animate as your code runs. Free online C compiler with a built‑in algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-c-compiler/");
request.setAttribute("preferredLanguage", "c");
request.setAttribute("h1Text", "Online C Compiler & Algorithm Visualizer – Run C Online (GCC 12, 13)");
request.setAttribute("seoIntroTitle", "Run & Visualize C Online (GCC 12, 13)");
request.setAttribute("seoIntroBody", "Compile and run C online with GCC 12 or 13. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your C code run line by line as arrays, dynamic <code>malloc</code> arrays, strings (char arrays), 2D matrices, linked lists, and binary trees animate step by step — with a call‑stack view for recursion and pthreads swim lanes (mutex hand‑off and deadlock detection) for concurrency. Ideal for learning sorting, binary search, recursion, and tree traversals. Supports stdin, compiler flags, shareable snippet URLs, and multi‑file projects.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does the online C compiler include an algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while arrays, strings, matrices, linked lists, and trees animate — a built‑in C visualizer that highlights each read and write, the current line, and the call stack for recursion.</p>" +
    "<p><strong>Which C data structures and algorithms can I visualize?</strong> Raw and dynamic (<code>malloc</code>/<code>calloc</code>) int arrays, strings (char arrays), 2D matrices, singly linked lists, and binary trees — plus pthreads concurrency (mutex lock/unlock as swim lanes with deadlock detection). Great for sorting, binary search, recursion, and tree traversals.</p>" +
    "<p><strong>Which GCC versions are available?</strong> GCC 12 and GCC 13 are available.</p>" +
    "<p><strong>How to pass flags?</strong> Add flags in Compiler Args, e.g., <code>-O2</code>.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to copy a snippet URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online C compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your C code while arrays, strings, matrices, linked lists, and trees animate — a built-in C algorithm visualizer that highlights each read and write, the current line, and the call stack for recursion.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which C data structures and algorithms can I visualize?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Raw and dynamic (malloc/calloc) int arrays, strings (char arrays), 2D matrices, singly linked lists, and binary trees, plus pthreads concurrency (mutex lock/unlock as swim lanes with deadlock detection). Ideal for sorting, binary search, recursion, and tree traversals.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which GCC versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"GCC 12 and GCC 13 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How to pass compiler flags?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Add flags in Compiler Args, e.g., -O2.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to copy a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
