<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI Perl Compiler - Run, Fix & Explain Perl Code Free");
request.setAttribute("pageDescription", "Run Perl online with a fast, free compiler and IDE. Write, execute, and share Perl code with Perl 5.42.0 and 5.40.3, stdin, and core modules. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-perl-compiler/");
request.setAttribute("preferredLanguage", "perl");
request.setAttribute("h1Text", "Online Perl Compiler – Run Perl Online (5.42.0, 5.40.3)");
request.setAttribute("seoIntroTitle", "Run Perl Online (Perl 5.42.0, 5.40.3)");
request.setAttribute("seoIntroBody", "Compile and run Perl online with Perl 5.42.0 or 5.40.3. Supports stdin, command-line arguments, and core modules. Write, run, and share Perl scripts with no setup.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which Perl versions are available?</strong> Perl 5.42.0 and 5.40.3 are available &mdash; pick one from the version selector.</p>" +
    "<p><strong>Can I read input from stdin?</strong> Yes. Put your input in the Stdin field and read it with the <code>&lt;STDIN&gt;</code> filehandle or the diamond operator <code>&lt;&gt;</code>.</p>" +
    "<p><strong>Which modules can I use?</strong> Core modules that ship with Perl (e.g. <code>strict</code>, <code>warnings</code>, <code>List::Util</code>, <code>Data::Dumper</code>) are available.</p>" +
    "<p><strong>How do I share code?</strong> Use Share to generate a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Perl versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Perl 5.42.0 and 5.40.3 are available. Pick one from the version selector.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Can I read input from stdin in Perl?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Yes. Put your input in the Stdin field and read it with the STDIN filehandle or the diamond operator.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Perl modules can I use?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Core modules that ship with Perl such as strict, warnings, List::Util and Data::Dumper are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a link.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
