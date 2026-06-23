<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Java Compiler & Algorithm Visualizer - Free Online");
request.setAttribute("pageDescription", "Run Java online and visualize algorithms step by step—watch arrays, lists, maps, recursion and binary trees animate as your code runs. Free algorithm visualizer.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-java-compiler/");
request.setAttribute("preferredLanguage", "java");
request.setAttribute("h1Text", "Online Java Compiler & Algorithm Visualizer (11, 17, 21)");
request.setAttribute("seoIntroTitle", "Run & Visualize Java Online (11, 17, 21)");
request.setAttribute("seoIntroBody", "Compile and run Java online using LTS versions 11 and 17, or the latest 21, with multi‑file support. Plus a built‑in algorithm visualizer: click <strong>Visualize</strong> to watch arrays, 2‑D matrices, lists, maps, sets, and binary trees animate line by line — great for learning sorting, binary search, recursion, and tree traversals.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Does it include a Java algorithm visualizer?</strong> Yes. Click <em>Visualize</em> to step through your code while arrays, 2‑D matrices, lists, maps, sets, and binary trees animate — a built‑in algorithm visualizer that highlights each read and write and the current line.</p>" +
    "<p><strong>Which algorithms can I visualize?</strong> Sorting (bubble, selection, insertion), binary search, two‑pointer techniques, recursion, and binary‑tree traversals. For trees, use the bundled <code>TreeNode</code> helper class.</p>" +
    "<p><strong>Which Java versions are available?</strong> Java 11, 17, and 21 are available.</p>" +
    "<p><strong>How do I set the main class?</strong> Use a file named <code>Main.java</code> with <code>public static void main</code>.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to get a snippet URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Does the online Java compiler include an algorithm visualizer?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Click Visualize to step through your code while arrays, 2-D matrices, lists, maps, sets, and binary trees animate — a built-in algorithm visualizer that highlights each read and write and the current line of code.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which algorithms can I visualize in Java?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Sorting (bubble, selection, insertion), binary search, two-pointer techniques, recursion, and binary-tree traversals. For trees, use the bundled TreeNode helper class.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Java versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Java 11, 17, and 21 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I set the main class?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use a file named Main.java with public static void main.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to get a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
