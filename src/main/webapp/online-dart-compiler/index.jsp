<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Dart Compiler & IDE - Run Dart Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run Dart online with a free compiler and IDE. Write, execute, and share Dart code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-dart-compiler/");
request.setAttribute("preferredLanguage", "dart");
request.setAttribute("h1Text", "Online Dart Compiler – Run Dart Online (3.2)");
request.setAttribute("seoIntroTitle", "Run Dart Online (3.2)");
request.setAttribute("seoIntroBody", "Write and run Dart 3.2 code online. Great for small demos and learning.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which version?</strong> Dart 3.2.</p>" +
    "<p><strong>Packages?</strong> Prefer self‑contained examples; pub packages aren't persisted.</p>" +
    "<p><strong>Share?</strong> Click Share to get a snippet link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Dart version is available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Dart 3.2.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Packages?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Prefer self‑contained examples; pub packages aren't persisted.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
