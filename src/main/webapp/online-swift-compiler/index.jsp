<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Swift Compiler & IDE - Run Swift Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run Swift online with a free compiler and IDE. Write, execute, and share Swift code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-swift-compiler/");
request.setAttribute("preferredLanguage", "swift");
request.setAttribute("h1Text", "Online Swift Compiler – Run Swift Online (5.9, 5.10)");
request.setAttribute("seoIntroTitle", "Run Swift Online (5.9, 5.10)");
request.setAttribute("seoIntroBody", "Run Swift 5.9 or 5.10 code online for learning and demos. Multi‑file projects supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> Swift 5.9, 5.10.</p>" +
    "<p><strong>SwiftPM?</strong> Use self‑contained examples; package dependencies aren't persisted.</p>" +
    "<p><strong>Share?</strong> Click Share to publish a snippet link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Swift versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Swift 5.9 and 5.10 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"SwiftPM?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use self‑contained examples; package dependencies aren't persisted.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
