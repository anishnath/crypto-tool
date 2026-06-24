<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Go Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run Go online and visualize algorithms step by step—watch slices, maps, structs, trees and graphs animate as your code runs. Free Go algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-go-compiler/");
request.setAttribute("preferredLanguage", "go");
request.setAttribute("h1Text", "Online Go Compiler & Algorithm Visualizer (1.21–1.26)");
request.setAttribute("seoIntroTitle", "Run & Visualize Go Online (1.21–1.26)");
request.setAttribute("seoIntroBody", "Write and run Go code online with versions 1.21 through 1.26. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch your code run line by line as slices, 2‑D slices, maps, structs, binary trees, linked lists, and graphs (including <code>map[int][]int</code> adjacency) animate step by step — great for learning sorting, binary search, recursion, and BFS/DFS. Self‑contained snippets, no setup.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does it include a Go algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while slices, maps, structs, binary trees, linked lists, and graphs animate — a built‑in algorithm visualizer that highlights each read and write and the current line.</p>" +
    "<p><strong>Which algorithms can I visualize?</strong> Sorting (bubble, selection, insertion), binary search, two‑pointer techniques, recursion, tree/linked‑list traversal, and graph BFS/DFS — over slices, maps, structs, and <code>map[int][]int</code> adjacency lists.</p>" +
    "<p><strong>Which Go versions are available?</strong> Go 1.21, 1.22, 1.23, 1.24, 1.25, and 1.26 are available (1.26 is the default).</p>" +
    "<p><strong>How do I share code?</strong> Click Share to generate a permalink.</p>" +
    "<p><strong>Are modules supported?</strong> Prefer self‑contained examples; third‑party modules aren't persisted.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online Go compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your code while slices, maps, structs, binary trees, linked lists, and graphs animate — a built-in algorithm visualizer that highlights each read and write and the current line of code.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which algorithms can I visualize in Go?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Sorting (bubble, selection, insertion), binary search, two-pointer techniques, recursion, tree and linked-list traversal, and graph BFS/DFS over slices, maps, structs, and map[int][]int adjacency lists.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Go versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Go 1.21, 1.22, 1.23, 1.24, 1.25, and 1.26 are available (1.26 is the default).\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a permalink.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Are modules supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Prefer self-contained examples; third-party modules are not persisted.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
