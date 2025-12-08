<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Rust Compiler & IDE - Run Rust Code Online | Free");
request.setAttribute("pageDescription", "Run Rust online with a free compiler and IDE. Write, execute, and share Rust code with multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-rust-compiler/");
request.setAttribute("preferredLanguage", "rust");
request.setAttribute("h1Text", "Online Rust Compiler – Run Rust Online (1.74, 1.75)");
request.setAttribute("seoIntroTitle", "Run Rust Online (1.74, 1.75)");
request.setAttribute("seoIntroBody", "Write and execute Rust code online. Try features targeting Rust 1.74 or 1.75, with stdin and multi‑file support.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> Rust 1.74, 1.75.</p>" +
    "<p><strong>Crates?</strong> Prefer self‑contained examples; external crates aren’t persisted.</p>" +
    "<p><strong>Share?</strong> Use Share for a permalink.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Rust Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Rust\",\n" +
    "  \"url\": \"https://8gwifi.org/online-rust-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Rust online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Rust versions are available?","acceptedAnswer":{"@type":"Answer","text":"Rust 1.74 and 1.75 are available."}},
    {"@type":"Question","name":"Crates?","acceptedAnswer":{"@type":"Answer","text":"Prefer self‑contained examples; external crates aren’t persisted."}},
    {"@type":"Question","name":"How do I share?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a snippet URL."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
