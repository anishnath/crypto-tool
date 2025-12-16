<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online Python Compiler & IDE - Run Python Code Online Free | 8gwifi.org");
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
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Python versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Python 3.9, 3.10, and 3.11 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to generate a URL that preserves your files, input, and Python version.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Are packages supported?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Common packages are available in examples. For portability, prefer self‑contained snippets.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
