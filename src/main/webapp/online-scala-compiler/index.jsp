<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Scala Compiler & IDE - Run Scala Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run Scala online with a free compiler and IDE. Write, execute, and share Scala code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-scala-compiler/");
request.setAttribute("preferredLanguage", "scala");
request.setAttribute("h1Text", "Online Scala Compiler – Run Scala Online (2.13)");
request.setAttribute("seoIntroTitle", "Run Scala Online (2.13)");
request.setAttribute("seoIntroBody", "Write and run Scala 2.13 code online. Good for quick experiments and teaching.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which version?</strong> Scala 2.13.</p>" +
    "<p><strong>Multi‑file?</strong> Yes, add more .scala files as needed.</p>" +
    "<p><strong>Share?</strong> Use Share to get a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Scala version is available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Scala 2.13.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Multi‑file?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes, add additional .scala files as needed.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to get a link.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
