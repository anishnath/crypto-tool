<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Kotlin Compiler & IDE - Run Kotlin Code Online | Free");
request.setAttribute("pageDescription", "Run Kotlin online with a free compiler and IDE. Write, execute, and share Kotlin code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-kotlin-compiler/");
request.setAttribute("preferredLanguage", "kotlin");
request.setAttribute("h1Text", "Online Kotlin Compiler – Run Kotlin Online (1.9, 2.0)");
request.setAttribute("seoIntroTitle", "Run Kotlin Online (1.9, 2.0)");
request.setAttribute("seoIntroBody", "Write and run Kotlin online targeting versions 1.9 or 2.0. Multi‑file projects supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> Kotlin 1.9, 2.0.</p>" +
    "<p><strong>How do I run?</strong> Ensure a file with a <code>main</code> function is present.</p>" +
    "<p><strong>Share?</strong> Use Share to generate a link.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Kotlin Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Kotlin\",\n" +
    "  \"url\": \"https://8gwifi.org/online-kotlin-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Kotlin online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Kotlin versions are available?","acceptedAnswer":{"@type":"Answer","text":"Kotlin 1.9 and 2.0."}},
    {"@type":"Question","name":"How to run the program?","acceptedAnswer":{"@type":"Answer","text":"Ensure a file has a main function."}},
    {"@type":"Question","name":"How do I share?","acceptedAnswer":{"@type":"Answer","text":"Use Share to copy a snippet URL."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
