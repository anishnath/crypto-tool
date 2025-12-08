<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Lua Compiler & IDE - Run Lua Code Online | Free");
request.setAttribute("pageDescription", "Run Lua online with a free compiler and IDE. Write, execute, and share Lua code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-lua-compiler/");
request.setAttribute("preferredLanguage", "lua");
request.setAttribute("h1Text", "Online Lua Compiler – Run Lua Online (5.4)");
request.setAttribute("seoIntroTitle", "Run Lua Online (5.4)");
request.setAttribute("seoIntroBody", "Write and run Lua 5.4 code online. Simple, fast, and great for learning.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which version?</strong> Lua 5.4.</p>" +
    "<p><strong>Multi‑file?</strong> Yes, add additional .lua files.</p>" +
    "<p><strong>Share?</strong> Use Share for a permalink.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Lua Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Lua\",\n" +
    "  \"url\": \"https://8gwifi.org/online-lua-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Lua online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Lua version is available?","acceptedAnswer":{"@type":"Answer","text":"Lua 5.4."}},
    {"@type":"Question","name":"Multi‑file?","acceptedAnswer":{"@type":"Answer","text":"Yes, add additional .lua files."}},
    {"@type":"Question","name":"How do I share?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a URL."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
