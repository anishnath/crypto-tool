<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Ruby Compiler & IDE - Run Ruby Code Online | Free");
request.setAttribute("pageDescription", "Run Ruby online with a free compiler and IDE. Write, execute, and share Ruby code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-ruby-compiler/");
request.setAttribute("preferredLanguage", "ruby");
request.setAttribute("h1Text", "Online Ruby Compiler – Run Ruby Online (3.1, 3.2, 3.3)");
request.setAttribute("seoIntroTitle", "Run Ruby Online (3.1, 3.2, 3.3)");
request.setAttribute("seoIntroBody", "Write and run Ruby online. Choose Ruby 3.1, 3.2, or 3.3. Great for kata practice, scripts, and teaching examples.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions are available?</strong> Ruby 3.1, 3.2, 3.3.</p>" +
    "<p><strong>Gems?</strong> Use self‑contained examples; external gems availability varies by template.</p>" +
    "<p><strong>Sharing?</strong> Use Share to generate a link for your snippet.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Ruby Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Ruby\",\n" +
    "  \"url\": \"https://8gwifi.org/online-ruby-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Ruby online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Ruby versions are available?","acceptedAnswer":{"@type":"Answer","text":"Ruby 3.1, 3.2, and 3.3 are available."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a snippet URL."}},
    {"@type":"Question","name":"Are gems supported?","acceptedAnswer":{"@type":"Answer","text":"Use self‑contained examples; gem availability varies by template."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
