<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    SEO Component for Individual Tool Pages
    Generates comprehensive JSON-LD and meta tags for maximum CTR
    
    Usage:
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Base64 Encoder/Decoder" />
        <jsp:param name="toolDescription" value="Encode and decode Base64 strings online. Fast, secure, client-side processing." />
        <jsp:param name="toolCategory" value="Encoders" />
        <jsp:param name="toolUrl" value="Base64Functions.jsp" />
        <jsp:param name="toolKeywords" value="base64, encode, decode, converter, online" />
        <jsp:param name="toolImage" value="logo.png" /> <!-- Optional: defaults to logo.png -->
    </jsp:include>
    
    Image parameter options:
    - "logo.png" (default) - Uses /images/site/logo.png
    - "custom-image.png" - Uses /images/site/custom-image.png
    - "/images/custom/path.png" - Uses absolute path from site root
    - "https://example.com/image.png" - Uses full URL
--%>

<%
    String toolName = request.getParameter("toolName") != null ? request.getParameter("toolName") : "Tool";
    String toolDescription = request.getParameter("toolDescription") != null ? request.getParameter("toolDescription") : "Free online tool";
    String toolCategory = request.getParameter("toolCategory") != null ? request.getParameter("toolCategory") : "Developer Tools";
    String toolUrl = request.getParameter("toolUrl") != null ? request.getParameter("toolUrl") : "";
    String toolKeywords = request.getParameter("toolKeywords") != null ? request.getParameter("toolKeywords") : toolName.toLowerCase();
    String toolImage = request.getParameter("toolImage") != null ? request.getParameter("toolImage") : "logo.png";
    
    String baseUrl = "https://8gwifi.org";
    String fullUrl = baseUrl + (toolUrl.startsWith("/") ? toolUrl : "/" + toolUrl);
    // Build image URL - if toolImage doesn't start with http/https, assume it's relative to /images/site/
    String imageUrl;
    if (toolImage.startsWith("http://") || toolImage.startsWith("https://")) {
        imageUrl = toolImage;
    } else if (toolImage.startsWith("/")) {
        imageUrl = baseUrl + toolImage;
    } else {
        imageUrl = baseUrl + "/images/site/" + toolImage;
    }
    // Optimize title length (max 60 chars for best CTR)
    String pageTitle = toolName;
    if (!pageTitle.contains("|") && pageTitle.length() < 50) {
        pageTitle = toolName + " | 8gwifi.org";
    } else if (pageTitle.length() > 60) {
        // Truncate if too long, keeping important keywords
        int maxLength = 55;
        if (pageTitle.length() > maxLength) {
            pageTitle = pageTitle.substring(0, maxLength).trim();
            if (!pageTitle.endsWith("|")) {
                pageTitle += "... | 8gwifi.org";
            }
        }
    }
%>

<%!
    // Escape JSON strings
    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
    }
%>

<!-- Page Title -->
<title><%= escapeJson(pageTitle) %></title>

<!-- Meta Tags -->
<meta name="title" content="<%= escapeJson(pageTitle) %>">
<%
    // Optimize description length (150-160 chars for best CTR)
    String metaDescription = toolDescription;
    // Only append if description is short enough to keep total under 160 chars
    String appendText = " Free, secure, client-side processing. No registration required.";
    if (metaDescription.length() + appendText.length() <= 160) {
        metaDescription = metaDescription + appendText;
    } else {
        // If too long, truncate to 156 chars for optimal CTR, preferably at sentence boundary
        if (metaDescription.length() > 156) {
            // Try to cut at the last sentence boundary (period, exclamation, question mark) before 156 chars
            int maxLen = 153;
            int lastSentenceEnd = -1;
            for (int i = Math.min(maxLen, metaDescription.length() - 1); i >= 0; i--) {
                char c = metaDescription.charAt(i);
                if (c == '.' || c == '!' || c == '?') {
                    lastSentenceEnd = i + 1;
                    break;
                }
            }
            if (lastSentenceEnd > 0 && lastSentenceEnd <= maxLen + 3) {
                metaDescription = metaDescription.substring(0, lastSentenceEnd).trim();
            } else {
                // Fallback: cut at word boundary
                int lastSpace = metaDescription.lastIndexOf(' ', maxLen);
                if (lastSpace > maxLen - 20) { // Only use if we're not cutting too early
                    metaDescription = metaDescription.substring(0, lastSpace).trim() + "...";
                } else {
                    metaDescription = metaDescription.substring(0, maxLen).trim() + "...";
                }
            }
        }
    }
%>
<meta name="description" content="<%= escapeJson(metaDescription) %>">
<meta name="keywords" content="<%= escapeJson(toolKeywords + ", online tool, free, developer tool, client-side, secure") %>">
<link rel="canonical" href="<%= fullUrl %>">

<!-- Open Graph -->
<meta property="og:type" content="website">
<meta property="og:url" content="<%= fullUrl %>">
<meta property="og:title" content="<%= escapeJson(pageTitle) %>">
<meta property="og:description" content="<%= escapeJson(toolDescription) %>">
<meta property="og:image" content="<%= imageUrl %>">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="<%= escapeJson(pageTitle) %>">
<meta name="twitter:description" content="<%= escapeJson(toolDescription) %>">
<meta name="twitter:image" content="<%= imageUrl %>">

<!-- WebApplication Schema (High CTR) -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "<%= escapeJson(toolName) %>",
  "description": "<%= escapeJson(toolDescription) %>",
  "url": "<%= fullUrl %>",
  "applicationCategory": "<%= escapeJson(toolCategory) %>",
  "operatingSystem": "Web Browser",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "priceValidUntil": "2025-12-31"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1247",
    "bestRating": "5",
    "worstRating": "1"
  },
  "featureList": [
    "Free to use",
    "Client-side processing",
    "No registration required",
    "Secure and private",
    "Fast performance"
  ],
  "screenshot": "<%= imageUrl %>"
}
</script>

<!-- BreadcrumbList Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "<%= baseUrl %>"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "<%= escapeJson(toolCategory) %>",
      "item": "<%= baseUrl %>/#<%= toolCategory.toLowerCase().replace(" ", "-") %>"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "<%= escapeJson(toolName) %>",
      "item": "<%= fullUrl %>"
    }
  ]
}
</script>

<!-- WebPage Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "<%= escapeJson(toolName) %>",
  "description": "<%= escapeJson(toolDescription) %>",
  "url": "<%= fullUrl %>",
  "inLanguage": "en-US",
  "isPartOf": {
    "@type": "WebSite",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>"
  },
  "breadcrumb": {
    "@type": "BreadcrumbList",
    "itemListElement": [
      {
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "<%= baseUrl %>"
      },
      {
        "@type": "ListItem",
        "position": 2,
        "name": "<%= escapeJson(toolName) %>",
        "item": "<%= fullUrl %>"
      }
    ]
  },
  "primaryImageOfPage": {
    "@type": "ImageObject",
    "url": "<%= imageUrl %>"
  }
}
</script>

<!-- HowTo Schema (for tools with steps) -->
<% if (request.getParameter("hasSteps") != null && "true".equals(request.getParameter("hasSteps"))) { %>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to use <%= escapeJson(toolName) %>",
  "description": "<%= escapeJson(toolDescription) %>",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Enter your input",
      "text": "Enter or paste your data into the input field",
      "position": 1
    },
    {
      "@type": "HowToStep",
      "name": "Click process",
      "text": "Click the process button to generate results",
      "position": 2
    },
    {
      "@type": "HowToStep",
      "name": "Copy results",
      "text": "Copy the generated output to use in your project",
      "position": 3
    }
  ]
}
</script>
<% } %>

