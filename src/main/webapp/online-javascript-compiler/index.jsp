<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online JavaScript Compiler & IDE - Run JS Code Online | Free");
request.setAttribute("pageDescription", "Run JavaScript (Node.js) online with a free compiler and IDE. Write, execute, and share JS code with examples and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-javascript-compiler/");
request.setAttribute("preferredLanguage", "javascript");
request.setAttribute("h1Text", "Online JavaScript Compiler – Run JS Online (Node 18, 20, 21)");
request.setAttribute("seoIntroTitle", "Run JavaScript (Node.js) Online (18, 20, 21)");
request.setAttribute("seoIntroBody", "Execute Node.js scripts in your browser using versions 18, 20, or 21. Great for quick JS experiments, utilities, and interview tasks. Multi‑file and stdin supported.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions are available?</strong> Node.js 18, 20, and 21.</p>" +
    "<p><strong>TypeScript?</strong> Use the <a href=\"/online-typescript-compiler/\">TypeScript page</a> for TS, compiled and run on Node 20.</p>" +
    "<p><strong>How do I share?</strong> Click Share to generate a public snippet URL.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online JavaScript Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"JavaScript\",\n" +
    "  \"url\": \"https://8gwifi.org/online-javascript-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run JavaScript online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Node.js versions are available?","acceptedAnswer":{"@type":"Answer","text":"Node.js 18, 20, and 21 are available."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a permalink for your snippet."}},
    {"@type":"Question","name":"Should I use TypeScript?","acceptedAnswer":{"@type":"Answer","text":"For TS, use the TypeScript page which compiles TS 5.3 on Node 20."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
