<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Python Compiler & IDE - Run Python Code Online | Free");
request.setAttribute("pageDescription", "Run Python online with a fast, free compiler and IDE. Write, execute, and share Python code with examples, stdin, and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-python-compiler/");
request.setAttribute("preferredLanguage", "python");
request.setAttribute("h1Text", "Online Python Compiler – Run Python Code Online (3.9, 3.10, 3.11)");
request.setAttribute("seoIntroTitle", "Run Python Online (3.9, 3.10, 3.11)");
request.setAttribute("seoIntroBody", "Write and execute Python in your browser. Supports Python 3.9, 3.10, and 3.11 with popular packages for examples like requests, numpy, and pandas. Share snippets, stdin, and multi‑file projects.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions are available?</strong> Python 3.9, 3.10, 3.11.</p>" +
    "<p><strong>Are packages available?</strong> Common packages are available in templates for examples (e.g., requests, numpy). For full control, paste code inline or use snippets.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to get a unique link that preserves files, input and version.</p>");
request.setAttribute("softwareAppJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"SoftwareApplication\",\n" +
    "  \"name\": \"Online Python Compiler\",\n" +
    "  \"applicationCategory\": \"DeveloperApplication\",\n" +
    "  \"operatingSystem\": \"Web\",\n" +
    "  \"programmingLanguage\": \"Python\",\n" +
    "  \"url\": \"https://8gwifi.org/online-python-compiler/\",\n" +
    "  \"offers\": { \"@type\": \"Offer\", \"price\": \"0\", \"priceCurrency\": \"USD\" },\n" +
    "  \"featureList\": [\"Run Python online\", \"Multi-file support\", \"Shareable snippets\"]\n" +
    "}");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"Which Python versions are available?","acceptedAnswer":{"@type":"Answer","text":"Python 3.9, 3.10, and 3.11 are available."}},
    {"@type":"Question","name":"How do I share code?","acceptedAnswer":{"@type":"Answer","text":"Click Share to generate a URL that preserves your files, input, and Python version."}},
    {"@type":"Question","name":"Are packages supported?","acceptedAnswer":{"@type":"Answer","text":"Common packages are available in examples. For portability, prefer self‑contained snippets."}}
  ]
}
</script>
<%@ include file="../onecompiler.jsp" %>
