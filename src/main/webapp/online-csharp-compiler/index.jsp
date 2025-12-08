<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online C# Compiler & IDE - Run C# Code Online | Free");
request.setAttribute("pageDescription", "Run C# online with a free compiler and IDE. Write, execute, and share C# code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-csharp-compiler/");
request.setAttribute("preferredLanguage", "csharp");
request.setAttribute("h1Text", "Online C# Compiler – Run C# Online (6, 7, 8)");
request.setAttribute("seoIntroTitle", "Run C# Online (6, 7, 8)");
request.setAttribute("seoIntroBody", "Write and run C# online. Choose language levels 6, 7, or 8 for examples and interviews.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> C# 6, 7, 8 language features.</p>" +
    "<p><strong>Multi‑file?</strong> Yes, add additional .cs files as needed.</p>" +
    "<p><strong>Share?</strong> Use Share to create a public link.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online C# Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"C#\",\n" +
    "  \"url\": \"https://8gwifi.org/online-csharp-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run C# online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which C# versions are supported?","acceptedAnswer":{"@type":"Answer","text":"C# language levels 6, 7, and 8."}},
    {"@type":"Question","name":"Multi‑file projects?","acceptedAnswer":{"@type":"Answer","text":"Yes, add additional .cs files and a Main entry point."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Use Share to generate a link."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
