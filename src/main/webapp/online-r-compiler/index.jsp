<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online R Compiler & IDE - Run R Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run R online with a free compiler and IDE. Write, execute, and share R code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-r-compiler/");
request.setAttribute("preferredLanguage", "r");
request.setAttribute("h1Text", "Online R Compiler – Run R Online (4.2, 4.3)");
request.setAttribute("seoIntroTitle", "Run R Online (4.2, 4.3)");
request.setAttribute("seoIntroBody", "Execute R code online targeting R 4.2 or 4.3. Great for stats snippets and quick visualizations.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> R 4.2, 4.3.</p>" +
    "<p><strong>Packages?</strong> Prefer examples without external packages; availability varies.</p>" +
    "<p><strong>Share?</strong> Click Share to grab a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which R versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"R 4.2 and 4.3.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Packages?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Prefer examples without external packages; availability varies.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to get a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
