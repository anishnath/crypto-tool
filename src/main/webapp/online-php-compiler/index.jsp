<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online PHP Compiler & IDE - Run PHP Code Online | Free");
request.setAttribute("pageDescription", "Run PHP online with a free compiler and IDE. Write, execute, and share PHP code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-php-compiler/");
request.setAttribute("preferredLanguage", "php");
request.setAttribute("h1Text", "Online PHP Compiler – Run PHP Online (8.1, 8.2, 8.3)");
request.setAttribute("seoIntroTitle", "Run PHP Online (8.1, 8.2, 8.3)");
request.setAttribute("seoIntroBody", "Execute PHP scripts online using PHP 8.1, 8.2, or 8.3. Great for learning and quick experiments.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> PHP 8.1, 8.2, 8.3.</p>" +
    "<p><strong>Extensions?</strong> Keep examples self‑contained; extension availability varies by template.</p>" +
    "<p><strong>Share?</strong> Click Share to get a snippet URL.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online PHP Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"PHP\",\n" +
    "  \"url\": \"https://8gwifi.org/online-php-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run PHP online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which PHP versions are available?","acceptedAnswer":{"@type":"Answer","text":"PHP 8.1, 8.2, and 8.3 are available."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Use Share to generate a URL for your snippet."}},
    {"@type":"Question","name":"Are extensions supported?","acceptedAnswer":{"@type":"Answer","text":"Prefer self‑contained examples; extension availability varies by template."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
