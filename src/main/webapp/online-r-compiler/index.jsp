<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online R Compiler & IDE - Run R Code Online | Free");
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
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online R Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"R\",\n" +
    "  \"url\": \"https://8gwifi.org/online-r-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run R online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which R versions are available?","acceptedAnswer":{"@type":"Answer","text":"R 4.2 and 4.3."}},
    {"@type":"Question","name":"Packages?","acceptedAnswer":{"@type":"Answer","text":"Prefer examples without external packages; availability varies."}},
    {"@type":"Question","name":"How do I share?","acceptedAnswer":{"@type":"Answer","text":"Use Share to get a snippet URL."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
