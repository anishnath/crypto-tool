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
        <jsp:param name="toolFeatures" value="Encode text to Base64,Decode Base64 to text,File encoding support" /> <!-- Optional: comma-separated list -->
    </jsp:include>

    Image parameter options:
    - "logo.png" (default) - Uses /images/site/logo.png
    - "custom-image.png" - Uses /images/site/custom-image.png
    - "/images/custom/path.png" - Uses absolute path from site root
    - "https://example.com/image.png" - Uses full URL

    Features parameter:
    - Comma-separated list of tool-specific features
    - If not provided, uses default generic features
    - Example: "Live YAML preview,8 resource types,Production-ready presets"
--%>

<%
    String toolName = request.getParameter("toolName") != null ? request.getParameter("toolName") : "Tool";
    String toolDescription = request.getParameter("toolDescription") != null ? request.getParameter("toolDescription") : "Free online tool";
    String toolCategory = request.getParameter("toolCategory") != null ? request.getParameter("toolCategory") : "Developer Tools";
    String toolUrl = request.getParameter("toolUrl") != null ? request.getParameter("toolUrl") : "";
    String toolKeywords = request.getParameter("toolKeywords") != null ? request.getParameter("toolKeywords") : toolName.toLowerCase();
    String toolImage = request.getParameter("toolImage") != null ? request.getParameter("toolImage") : "logo.png";
    String toolFeatures = request.getParameter("toolFeatures"); // Optional: comma-separated features
    
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
        // maxLength = 43 ensures total ≤ 60 chars (43 + "... | 8gwifi.org" = 60)
        int maxLength = 43;
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
    // Category-specific append text for better relevance and CTR
    String appendText;
    if (toolCategory != null) {
        String categoryLower = toolCategory.toLowerCase();
        if (categoryLower.contains("physics") || categoryLower.contains("education") || categoryLower.contains("math")) {
            appendText = " Free, instant results. Step-by-step solutions. No signup required.";
        } else if (categoryLower.contains("developer") || categoryLower.contains("code")) {
            appendText = " Free, secure, client-side processing. No registration required.";
        } else {
            appendText = " Free online tool. No registration required.";
        }
    } else {
        appendText = " Free online tool. No registration required.";
    }
    // Only append if description is short enough to keep total under 160 chars
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
<%
    // Category-specific keyword append for better relevance
    String keywordAppend;
    if (toolCategory != null) {
        String categoryLower = toolCategory.toLowerCase();
        if (categoryLower.contains("physics") || categoryLower.contains("education") || categoryLower.contains("math")) {
            keywordAppend = ", online calculator, free tool, homework help, step-by-step solutions";
        } else if (categoryLower.contains("developer") || categoryLower.contains("code")) {
            keywordAppend = ", online tool, free, developer tool, client-side, secure";
        } else {
            keywordAppend = ", online tool, free";
        }
    } else {
        keywordAppend = ", online tool, free";
    }
%>
<meta name="keywords" content="<%= escapeJson(toolKeywords + keywordAppend) %>">
<link rel="canonical" href="<%= fullUrl %>">

<!-- Open Graph -->
<meta property="og:type" content="website">
<meta property="og:url" content="<%= fullUrl %>">
<meta property="og:title" content="<%= escapeJson(pageTitle) %>">
<meta property="og:description" content="<%= escapeJson(toolDescription) %>">
<meta property="og:image" content="<%= imageUrl %>">
<meta property="og:site_name" content="8gwifi.org">
<meta property="og:locale" content="en_US">

<!-- Twitter -->
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@anish2good">
<meta name="twitter:creator" content="@anish2good">
<meta name="twitter:title" content="<%= escapeJson(pageTitle) %>">
<meta name="twitter:description" content="<%= escapeJson(toolDescription) %>">
<meta name="twitter:image" content="<%= imageUrl %>">

<!-- Additional Meta -->
<meta name="author" content="8gwifi.org">
<meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">

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
  "browserRequirements": "Requires JavaScript. Works on Chrome, Firefox, Safari, Edge.",
  "softwareVersion": "1.0",
  "author": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>",
    "logo": {
      "@type": "ImageObject",
      "url": "<%= baseUrl %>/images/site/logo.png"
    }
  },
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "priceValidUntil": "2026-12-31"
  },
  <%-- 
  REMOVED: Hardcoded AggregateRating violates Google guidelines
  Only include if you have actual user reviews stored in database
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1247",
    "bestRating": "5",
    "worstRating": "1"
  },
  --%>
  "featureList": [
<% if (toolFeatures != null && !toolFeatures.trim().isEmpty()) {
    String[] features = toolFeatures.split(",");
    for (int i = 0; i < features.length; i++) {
        out.print("    \"" + escapeJson(features[i].trim()) + "\"");
        if (i < features.length - 1) out.print(",");
        out.println();
    }
} else { %>
    "Free to use",
    "Client-side processing",
    "No registration required",
    "Secure and private",
    "Fast performance"
<% } %>  ],
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
      "item": "<%= baseUrl %>/<%= toolCategory.toLowerCase().contains("math") ? "math/" : "#" + toolCategory.toLowerCase().replace(" ", "-") %>"
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
  "datePublished": "2024-01-01",
  "dateModified": "<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>",
  "isPartOf": {
    "@type": "WebSite",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>",
    "potentialAction": {
      "@type": "SearchAction",
      "target": "<%= baseUrl %>/?q={search_term_string}",
      "query-input": "required name=search_term_string"
    }
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

<!-- LearningResource Schema (for Education/Science tools - boosts search) -->
<% if (toolCategory != null && (toolCategory.toLowerCase().contains("math") || toolCategory.toLowerCase().contains("mathematics") || toolCategory.toLowerCase().contains("chemistry") || toolCategory.toLowerCase().contains("physics") || toolCategory.toLowerCase().contains("science") || toolCategory.toLowerCase().contains("education"))) { %>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "LearningResource",
  "name": "<%= escapeJson(toolName) %>",
  "description": "<%= escapeJson(toolDescription) %>",
  "url": "<%= fullUrl %>",
  "learningResourceType": "Interactive Tool",
  "educationalLevel": "<%= request.getParameter("educationalLevel") != null ? escapeJson(request.getParameter("educationalLevel")) : "High School" %>",
  "teaches": "<%= request.getParameter("teaches") != null ? escapeJson(request.getParameter("teaches")) : "Linear algebra, matrix operations" %>",
  "inLanguage": "en-US",
  "isAccessibleForFree": true,
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "<%= baseUrl %>"
  }
}
</script>
<% } %>

<!-- HowTo Schema (for tools with steps) -->
<% if (request.getParameter("hasSteps") != null && "true".equals(request.getParameter("hasSteps"))) {
    // Accept custom steps as pipe-separated "name|text,name|text,name|text"
    String customSteps = request.getParameter("howToSteps");
%>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to use <%= escapeJson(toolName) %>",
  "description": "<%= escapeJson(toolDescription) %>",
  "step": [
<% if (customSteps != null && !customSteps.trim().isEmpty()) {
    String[] stepPairs = customSteps.split(",");
    for (int si = 0; si < stepPairs.length; si++) {
        String[] parts = stepPairs[si].split("\\|", 2);
        String stepName = parts.length > 0 ? parts[0].trim() : "Step " + (si + 1);
        String stepText = parts.length > 1 ? parts[1].trim() : stepName;
%>    {
      "@type": "HowToStep",
      "name": "<%= escapeJson(stepName) %>",
      "text": "<%= escapeJson(stepText) %>",
      "position": <%= si + 1 %>
    }<%= si < stepPairs.length - 1 ? "," : "" %>
<% }
} else { %>    {
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
<% } %>  ]
}
</script>
<% } %>

<!-- FAQ Schema (for rich snippets - high CTR) -->
<%
    String faq1q = request.getParameter("faq1q");
    String faq1a = request.getParameter("faq1a");
    String faq2q = request.getParameter("faq2q");
    String faq2a = request.getParameter("faq2a");
    String faq3q = request.getParameter("faq3q");
    String faq3a = request.getParameter("faq3a");
    String faq4q = request.getParameter("faq4q");
    String faq4a = request.getParameter("faq4a");
    String faq5q = request.getParameter("faq5q");
    String faq5a = request.getParameter("faq5a");
    String faq6q = request.getParameter("faq6q");
    String faq6a = request.getParameter("faq6a");
    boolean hasFaq = (faq1q != null && faq1a != null);
    boolean hasFaq4 = (faq4q != null && faq4a != null);
    boolean hasFaq5 = (faq5q != null && faq5a != null);
    boolean hasFaq6 = (faq6q != null && faq6a != null);
%>
<% if (hasFaq) { %>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    <% if (faq1q != null && faq1a != null) { %>
    {
      "@type": "Question",
      "name": "<%= escapeJson(faq1q) %>",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "<%= escapeJson(faq1a) %>"
      }
    }<% if (faq2q != null || faq3q != null || hasFaq4 || hasFaq5 || hasFaq6) { %>,<% } %>
    <% } %>
    <% if (faq2q != null && faq2a != null) { %>
    {
      "@type": "Question",
      "name": "<%= escapeJson(faq2q) %>",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "<%= escapeJson(faq2a) %>"
      }
    }<% if (faq3q != null || hasFaq4 || hasFaq5 || hasFaq6) { %>,<% } %>
    <% } %>
    <% if (faq3q != null && faq3a != null) { %>
    {
      "@type": "Question",
      "name": "<%= escapeJson(faq3q) %>",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "<%= escapeJson(faq3a) %>"
      }
    }<% if (hasFaq4 || hasFaq5 || hasFaq6) { %>,<% } %>
    <% } %>
    <% if (hasFaq4) { %>
    {
      "@type": "Question",
      "name": "<%= escapeJson(faq4q) %>",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "<%= escapeJson(faq4a) %>"
      }
    }<% if (hasFaq5 || hasFaq6) { %>,<% } %>
    <% } %>
    <% if (hasFaq5) { %>
    {
      "@type": "Question",
      "name": "<%= escapeJson(faq5q) %>",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "<%= escapeJson(faq5a) %>"
      }
    }<% if (hasFaq6) { %>,<% } %>
    <% } %>
    <% if (hasFaq6) { %>
    {
      "@type": "Question",
      "name": "<%= escapeJson(faq6q) %>",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "<%= escapeJson(faq6a) %>"
      }
    }
    <% } %>
  ]
}
</script>
<% } %>

