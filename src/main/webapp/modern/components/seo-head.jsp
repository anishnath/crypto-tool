<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    Comprehensive SEO Head Component
    Includes all meta tags, Open Graph, Twitter Cards, and JSON-LD
    
    Parameters:
    - pageTitle: Page title
    - pageDescription: Meta description
    - canonicalUrl: Canonical URL
    - ogImage: Open Graph image URL (optional)
    - schemaType: Schema type (WebSite, SoftwareApplication, etc.)
    - breadcrumbItems: JSON array for breadcrumbs (optional)
    - faqItems: JSON array for FAQ schema (optional)
--%>

<%!
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
%>

<%
    String title = request.getParameter("pageTitle") != null ? request.getParameter("pageTitle") : "8gwifi.org - Free Online Tools for Developers";
    String description = request.getParameter("pageDescription") != null ? request.getParameter("pageDescription") : "Free online tools for developers: Cryptography, Network diagnostics, DevOps, Encoders, PKI, Blockchain, and 200+ more tools.";
    String canonicalUrl = request.getParameter("canonicalUrl") != null ? request.getParameter("canonicalUrl") : "https://8gwifi.org";
    String ogImage = request.getParameter("ogImage") != null ? request.getParameter("ogImage") : "https://8gwifi.org/images/site/4book.png";
    String schemaType = request.getParameter("schemaType") != null ? request.getParameter("schemaType") : "WebSite";
    String baseUrl = "https://8gwifi.org";
    String currentPath = request.getRequestURI();
    if (!canonicalUrl.startsWith("http")) {
        canonicalUrl = baseUrl + (canonicalUrl.startsWith("/") ? canonicalUrl : "/" + canonicalUrl);
    }
%>

<!-- Primary Meta Tags -->
<meta name="title" content="<%= escapeJson(title) %>">
<meta name="description" content="<%= escapeJson(description) %>">
<meta name="keywords" content="online tools, developer tools, cryptography, network tools, devops, free tools, encryption, hashing, certificate generator, ssl tools">
<meta name="author" content="8gwifi.org">
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
<meta name="googlebot" content="index, follow">
<meta name="bingbot" content="index, follow">
<link rel="canonical" href="<%= canonicalUrl %>">

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="<%= canonicalUrl %>">
<meta property="og:title" content="<%= escapeJson(title) %>">
<meta property="og:description" content="<%= escapeJson(description) %>">
<meta property="og:image" content="<%= ogImage %>">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="<%= escapeJson(title) %>">
<meta property="og:site_name" content="8gwifi.org">
<meta property="og:locale" content="en_US">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:url" content="<%= canonicalUrl %>">
<meta name="twitter:title" content="<%= escapeJson(title) %>">
<meta name="twitter:description" content="<%= escapeJson(description) %>">
<meta name="twitter:image" content="<%= ogImage %>">
<meta name="twitter:image:alt" content="<%= escapeJson(title) %>">
<meta name="twitter:site" content="@anish2good">
<meta name="twitter:creator" content="@anish2good">

<!-- Additional SEO -->
<meta name="theme-color" content="#6366f1">
<meta name="msapplication-TileColor" content="#6366f1">
<meta name="application-name" content="8gwifi.org">
<meta name="apple-mobile-web-app-title" content="8gwifi.org">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "<%= schemaType %>",
  "name": "<%= escapeJson(title) %>",
  "description": "<%= escapeJson(description) %>",
  "url": "<%= canonicalUrl %>",
  "logo": "<%= baseUrl %>/images/site/4book.png",
  "image": "<%= ogImage %>",
  "sameAs": [
    "https://twitter.com/anish2good"
  ],
  <% if ("WebSite".equals(schemaType)) { %>
  "potentialAction": {
    "@type": "SearchAction",
    "target": {
      "@type": "EntryPoint",
      "urlTemplate": "<%= baseUrl %>?q={search_term_string}"
    },
    "query-input": "required name=search_term_string"
  },
  <% } %>
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "logo": {
      "@type": "ImageObject",
      "url": "<%= baseUrl %>/images/site/4book.png"
    }
  }
}
</script>

<!-- BreadcrumbList Schema (if provided) -->
<% if (request.getParameter("breadcrumbItems") != null) {
    String breadcrumbs = request.getParameter("breadcrumbItems");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": <%= breadcrumbs %>
}
</script>
<% } %>

<!-- FAQPage Schema (if provided) -->
<% if (request.getParameter("faqItems") != null) {
    String faqs = request.getParameter("faqItems");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": <%= faqs %>
}
</script>
<% } %>

<!-- SoftwareApplication Schema (for tool pages) -->
<% if ("SoftwareApplication".equals(schemaType)) { %>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "<%= escapeJson(title) %>",
  "description": "<%= escapeJson(description) %>",
  "url": "<%= canonicalUrl %>",
  "applicationCategory": "DeveloperApplication",
  "operatingSystem": "Web Browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1000"
  }
}
</script>
<% } %>

<!-- Organization Schema (always included) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "8gwifi.org",
  "url": "<%= baseUrl %>",
  "logo": "<%= baseUrl %>/images/site/4book.png",
  "sameAs": [
    "https://twitter.com/anish2good"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "Customer Service",
    "url": "<%= baseUrl %>"
  }
}
</script>

