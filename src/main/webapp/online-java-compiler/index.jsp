<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI Java Compiler - Run, Fix & Explain Java Code Free");
request.setAttribute("pageDescription", "Run Java online with a fast, free compiler and IDE. Write, execute, and share Java code with versions, stdin, and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-java-compiler/");
request.setAttribute("preferredLanguage", "java");
request.setAttribute("h1Text", "Online Java Compiler – Run Java Online (11, 17, 21)");
request.setAttribute("seoIntroTitle", "Run Java Online (11, 17, 21)");
request.setAttribute("seoIntroBody", "Compile and run Java online using LTS versions 11 and 17, or the latest 21. Supports multi‑file projects.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which Java versions are available?</strong> Java 11, 17, and 21 are available.</p>" +
    "<p><strong>How do I set the main class?</strong> Use a file named <code>Main.java</code> with <code>public static void main</code>.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to get a snippet URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Java versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Java 11, 17, and 21 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I set the main class?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use a file named Main.java with public static void main.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to get a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
