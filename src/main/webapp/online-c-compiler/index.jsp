<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online C Compiler & IDE - Run C Code Online | Free");
request.setAttribute("pageDescription", "Run C online with a fast, free compiler and IDE. Write, execute, and share C code with stdin and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-c-compiler/");
request.setAttribute("preferredLanguage", "c");
request.setAttribute("h1Text", "Online C Compiler – Run C Online (GCC 12, 13)");
request.setAttribute("seoIntroTitle", "Run C Online (GCC 12, 13)");
request.setAttribute("seoIntroBody", "Compile and run C online with GCC 12 or 13. Supports stdin, compiler flags, and multi‑file projects.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> GCC 12, GCC 13.</p>" +
    "<p><strong>Flags?</strong> Add flags in Compiler Args (e.g., <code>-O2</code>).</p>" +
    "<p><strong>Share?</strong> Click Share to get a snippet link.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online C Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"C\",\n" +
    "  \"url\": \"https://8gwifi.org/online-c-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run C online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which GCC versions are available?","acceptedAnswer":{"@type":"Answer","text":"GCC 12 and GCC 13 are available."}},
    {"@type":"Question","name":"How to pass flags?","acceptedAnswer":{"@type":"Answer","text":"Add flags in Compiler Args, e.g., -O2."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Click Share to copy a snippet URL."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
