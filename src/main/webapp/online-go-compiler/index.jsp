<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Go Compiler & IDE - Run Go Code Online | Free");
request.setAttribute("pageDescription", "Run Go online with a free compiler and IDE. Write, execute, and share Go code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-go-compiler/");
request.setAttribute("preferredLanguage", "go");
request.setAttribute("h1Text", "Online Go Compiler – Run Go Online (1.21, 1.22)");
request.setAttribute("seoIntroTitle", "Run Go Online (1.21, 1.22)");
request.setAttribute("seoIntroBody", "Write and run Go code online with versions 1.21 and 1.22. Ideal for snippets, learning, and demos.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> Go 1.21, 1.22.</p>" +
    "<p><strong>Modules?</strong> Prefer self‑contained examples; third‑party modules aren’t persisted.</p>" +
    "<p><strong>Share?</strong> Use Share to copy a snippet URL.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Go Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Go\",\n" +
    "  \"url\": \"https://8gwifi.org/online-go-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Go online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Go versions are available?","acceptedAnswer":{"@type":"Answer","text":"Go 1.21 and 1.22 are available."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a permalink."}},
    {"@type":"Question","name":"Are modules supported?","acceptedAnswer":{"@type":"Answer","text":"Prefer self‑contained examples; third‑party modules aren’t persisted."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
