<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Dart Compiler & IDE - Run Dart Code Online | Free");
request.setAttribute("pageDescription", "Run Dart online with a free compiler and IDE. Write, execute, and share Dart code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-dart-compiler/");
request.setAttribute("preferredLanguage", "dart");
request.setAttribute("h1Text", "Online Dart Compiler – Run Dart Online (3.2)");
request.setAttribute("seoIntroTitle", "Run Dart Online (3.2)");
request.setAttribute("seoIntroBody", "Write and run Dart 3.2 code online. Great for small demos and learning.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which version?</strong> Dart 3.2.</p>" +
    "<p><strong>Packages?</strong> Prefer self‑contained examples; pub packages aren’t persisted.</p>" +
    "<p><strong>Share?</strong> Click Share to get a snippet link.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Dart Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Dart\",\n" +
    "  \"url\": \"https://8gwifi.org/online-dart-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Dart online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Dart version is available?","acceptedAnswer":{"@type":"Answer","text":"Dart 3.2."}},
    {"@type":"Question","name":"Packages?","acceptedAnswer":{"@type":"Answer","text":"Prefer self‑contained examples; pub packages aren’t persisted."}},
    {"@type":"Question","name":"How do I share?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a snippet URL."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
