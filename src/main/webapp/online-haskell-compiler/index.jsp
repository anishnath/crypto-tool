<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="false" %>
<%
request.setAttribute("pageTitle", "AI Haskell Compiler - Run, Fix & Explain Haskell Code Free");
request.setAttribute("pageDescription", "Run Haskell online with a fast, free compiler and IDE. Write, execute, and share Haskell (GHC) code with stdin and multi-file support. No setup required.");
request.setAttribute("pageUrl", "https://8gwifi.org/online-haskell-compiler/");
request.setAttribute("preferredLanguage", "haskell");
request.setAttribute("h1Text", "Online Haskell Compiler – Run Haskell Online (GHC 9.8, 9.10)");
request.setAttribute("seoIntroTitle", "Run Haskell Online (GHC 9.8 &amp; 9.10)");
request.setAttribute("seoIntroBody", "Compile and run Haskell online with GHC 9.8 or 9.10. Great for learning functional programming, testing snippets, and sharing runnable examples.");
request.setAttribute("languageFaqHtml",
    "<p><strong>Which Haskell versions are available?</strong> GHC 9.8 and 9.10 are available (9.10 is the default).</p>" +
    "<p><strong>How do I structure a program?</strong> Use a <code>main :: IO ()</code> entry point, e.g. <code>main = putStrLn \"Hello, World!\"</code>.</p>" +
    "<p><strong>How do I share code?</strong> Click Share to get a snippet URL.</p>");
request.setAttribute("languageFaqJsonLd",
    "{\n" +
    "  \"@context\": \"https://schema.org\",\n" +
    "  \"@type\": \"FAQPage\",\n" +
    "  \"mainEntity\": [\n" +
    "    {\"@type\":\"Question\",\"name\":\"Which Haskell versions are available?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"GHC 9.8 and 9.10 are available (9.10 is the default).\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I structure a Haskell program?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Use a main :: IO () entry point, e.g. main = putStrLn \\\"Hello, World!\\\".\"}},\n" +
    "    {\"@type\":\"Question\",\"name\":\"How do I share code?\",\"acceptedAnswer\":{\"@type\":\"Answer\",\"text\":\"Click Share to get a snippet URL.\"}}\n" +
    "  ]\n" +
    "}");
%>
<%@ include file="../onecompiler.jsp" %>
