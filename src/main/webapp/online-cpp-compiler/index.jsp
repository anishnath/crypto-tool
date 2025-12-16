<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "Online C++ Compiler & IDE - Run C++ Code Online Free | 8gwifi.org");
request.setAttribute("pageDescription", "Run C++ online with a fast, free compiler and IDE. Write, execute, and share C++ code with C++20 flags, stdin, and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-cpp-compiler/");
request.setAttribute("preferredLanguage", "cpp");
request.setAttribute("h1Text", "Online C++ Compiler – Run C++ Online (GCC 12, 13)");
request.setAttribute("seoIntroTitle", "Run C++ Online (GCC 12, 13)");
request.setAttribute("seoIntroBody", "Compile and run C++ online with GCC 12 or 13. Supports common flags like -O3 and -std=c++20, multi‑file projects, and stdin.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which versions?</strong> GCC 12, GCC 13.</p>" +
    "<p><strong>Can I pass compiler flags?</strong> Yes, add flags in the Compiler Args field (e.g., <code>-std=c++20</code>).</p>" +
    "<p><strong>Share?</strong> Use Share to generate a link.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which GCC versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"GCC 12 and GCC 13 are available.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How to pass compiler flags?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use the Compiler Args field, e.g., -std=c++20 or -O3.\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use Share to generate a link.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
