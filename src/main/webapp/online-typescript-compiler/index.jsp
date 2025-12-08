<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online TypeScript Compiler & IDE - Run TS Code Online | Free");
request.setAttribute("pageDescription", "Run TypeScript (Node.js) online with a free compiler and IDE. Write, execute, and share TypeScript code with examples and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-typescript-compiler/");
request.setAttribute("preferredLanguage", "typescript");
request.setAttribute("h1Text", "Online TypeScript Compiler – Run TS Online (TS 5.3 on Node 20)");
request.setAttribute("seoIntroTitle", "Run TypeScript Online (TS 5.3 on Node 20)");
request.setAttribute("seoIntroBody", "Write TypeScript and run it online. The environment compiles TS 5.3 and runs it on Node.js 20. Perfect for quick demos and teaching.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions are available?</strong> TypeScript 5.3 on Node 20.</p>" +
    "<p><strong>How do I import packages?</strong> Use pure TS/JS examples; external packages vary by template. Prefer self‑contained snippets.</p>" +
    "<p><strong>Can I share?</strong> Yes, click Share to copy a snippet URL.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online TypeScript Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"TypeScript\",\n" +
    "  \"url\": \"https://8gwifi.org/online-typescript-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run TypeScript online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which versions are used?","acceptedAnswer":{"@type":"Answer","text":"TypeScript 5.3 compiled and executed on Node.js 20."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Use the Share button to generate a URL."}},
    {"@type":"Question","name":"Can I import packages?","acceptedAnswer":{"@type":"Answer","text":"Prefer self‑contained examples; external packages vary by template."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
