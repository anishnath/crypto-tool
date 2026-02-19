<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.nio.file.*, org.json.*" %>
<%!
    /**
     * SEO Helper for Math Memory Games
     * Reads from seo-data.json (key-based structure)
     */

    // Cache the SEO JSON data
    private static org.json.JSONObject seoDataCache = null;
    private static long cacheTime = 0;
    private static final long CACHE_TTL_MS = 3600000; // 1 hour

    /**
     * Load and cache SEO data from JSON file
     */
    public void loadSEOData(ServletContext context) {
        long currentTime = System.currentTimeMillis();

        // Return if cache is still valid
        if (seoDataCache != null && (currentTime - cacheTime) < CACHE_TTL_MS) {
            return;
        }

        try {
            String jsonPath = context.getRealPath("/exams/math-memory/seo-data.json");
            File file = new File(jsonPath);
            if (file.exists()) {
                String jsonContent = new String(Files.readAllBytes(Paths.get(jsonPath)), "UTF-8");
                org.json.JSONObject root = new org.json.JSONObject(jsonContent);
                seoDataCache = root.optJSONObject("pages");
                if (seoDataCache == null) {
                    seoDataCache = new org.json.JSONObject();
                }
            } else {
                seoDataCache = new org.json.JSONObject();
            }
            cacheTime = currentTime;
        } catch (Exception e) {
            e.printStackTrace();
            seoDataCache = new org.json.JSONObject();
        }
    }

    /**
     * Get SEO metadata for a specific page key
     */
    public org.json.JSONObject getPageSEO(String pageKey, ServletContext context) {
        loadSEOData(context);
        if (seoDataCache != null && seoDataCache.has(pageKey)) {
            return seoDataCache.getJSONObject(pageKey);
        }
        return null;
    }

    /**
     * Get SEO title for a page
     */
    public String getSEOTitle(String pageKey, ServletContext context) {
        org.json.JSONObject pageData = getPageSEO(pageKey, context);
        if (pageData != null) {
            return pageData.optString("title", "Math Memory Games");
        }
        return "Math Memory Games";
    }

    /**
     * Get meta description for a page
     */
    public String getMetaDescription(String pageKey, ServletContext context) {
        org.json.JSONObject pageData = getPageSEO(pageKey, context);
        if (pageData != null) {
            return pageData.optString("description", "Train your brain with math memory games.");
        }
        return "Train your brain with math memory games.";
    }

    /**
     * Get canonical URL
     */
    public String getCanonicalUrl(String pageKey, ServletContext context) {
        org.json.JSONObject pageData = getPageSEO(pageKey, context);
        if (pageData != null) {
            return pageData.optString("canonical", "https://8gwifi.org/exams/math-memory/");
        }
        return "https://8gwifi.org/exams/math-memory/";
    }

    /**
     * Generate extra head content (Social tags, Keywords)
     */
    public String generateHeadContent(String pageKey, ServletContext context) {
        org.json.JSONObject pageData = getPageSEO(pageKey, context);
        if (pageData == null) return "";

        StringBuilder html = new StringBuilder();
        String defaultOgImage = "https://8gwifi.org/exams/images/exams-practice-og.svg";
        String defaultSiteName = "8gwifi.org";
        String defaultAuthor = "8gwifi.org";

        // Keywords
        String keywords = pageData.optString("keywords", "");
        if (!keywords.isEmpty()) {
            html.append("<meta name=\"keywords\" content=\"").append(escapeHtml(keywords)).append("\">\n");
        }

        // Author / Publisher
        html.append("<meta name=\"author\" content=\"").append(escapeHtml(defaultAuthor)).append("\">\n");
        html.append("<meta name=\"publisher\" content=\"").append(escapeHtml(defaultSiteName)).append("\">\n");

        // Open Graph tags
        if (pageData.has("openGraph")) {
            org.json.JSONObject og = pageData.getJSONObject("openGraph");
            for (String key : og.keySet()) {
                String value = og.optString(key, "");
                if (!value.isEmpty()) {
                    html.append("<meta property=\"").append(escapeHtml(key)).append("\" content=\"").append(escapeHtml(value)).append("\">\n");
                }
            }
            if (!og.has("og:image")) {
                html.append("<meta property=\"og:image\" content=\"").append(escapeHtml(defaultOgImage)).append("\">\n");
            }
            if (!og.has("og:site_name")) {
                html.append("<meta property=\"og:site_name\" content=\"").append(escapeHtml(defaultSiteName)).append("\">\n");
            }
            if (!og.has("og:type")) {
                html.append("<meta property=\"og:type\" content=\"website\">\n");
            }
        }

        // Twitter Card tags
        if (pageData.has("twitterCard")) {
            org.json.JSONObject tc = pageData.getJSONObject("twitterCard");
            for (String key : tc.keySet()) {
                String value = tc.optString(key, "");
                if (!value.isEmpty()) {
                    html.append("<meta name=\"").append(escapeHtml(key)).append("\" content=\"").append(escapeHtml(value)).append("\">\n");
                }
            }
            if (!tc.has("twitter:card")) {
                html.append("<meta name=\"twitter:card\" content=\"summary_large_image\">\n");
            }
            if (!tc.has("twitter:image")) {
                html.append("<meta name=\"twitter:image\" content=\"").append(escapeHtml(defaultOgImage)).append("\">\n");
            }
        }

        return html.toString();
    }

    /**
     * Escape HTML special characters
     */
    private String escapeHtml(String text) {
        if (text == null) return "";
        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }

    /**
     * Escape JSON string characters
     */
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }

    /**
     * Get game name from page key (for display purposes)
     */
    private String getGameDisplayName(String pageKey) {
        java.util.Map<String, String> names = new java.util.HashMap<>();
        names.put("match", "Match Master");
        names.put("sequence", "Sequence Solver");
        names.put("flash", "Flash Math");
        names.put("grid", "Grid Genius");
        names.put("speed-round", "Speed Round");
        names.put("hidden-order", "Hidden Order");
        names.put("recall", "Rapid Recall");
        names.put("mental-trail", "Mental Trail");
        names.put("equation-echo", "Equation Echo");
        names.put("symbol-sums", "Symbol Sums");
        names.put("matrix-memory", "Matrix Memory");
        names.put("binary-blitz", "Binary Blitz");
        names.put("color-code", "Color Code");
        names.put("spin-logic", "Spin Logic");
        names.put("path-finder", "Path Finder");
        names.put("shape-count", "Shape Count");
        return names.getOrDefault(pageKey, "Math Memory Game");
    }

    /**
     * Generate JSON-LD structured data for game pages
     * Includes: WebApplication schema, BreadcrumbList, FAQPage
     */
    public String generateJsonLd(String pageKey, ServletContext context) {
        org.json.JSONObject pageData = getPageSEO(pageKey, context);
        if (pageData == null) return "";

        if ("index".equals(pageKey)) {
            StringBuilder indexJson = new StringBuilder();
            appendOrganizationJsonLd(indexJson);
            appendWebSiteJsonLd(indexJson);
            appendBreadcrumbJsonLd(indexJson, "Math Memory Games", "https://8gwifi.org/exams/math-memory/");
            return indexJson.toString();
        }

        String title = pageData.optString("title", "Math Memory Game");
        String description = pageData.optString("description", "Train your brain with math memory games.");
        String canonical = pageData.optString("canonical", "https://8gwifi.org/exams/math-memory/" + pageKey + ".jsp");
        String gameName = getGameDisplayName(pageKey);

        StringBuilder json = new StringBuilder();

        appendOrganizationJsonLd(json);
        appendWebSiteJsonLd(json);

        // WebApplication/VideoGame Schema
        json.append("<script type=\"application/ld+json\">\n");
        json.append("{\n");
        json.append("  \"@context\": \"https://schema.org\",\n");
        json.append("  \"@type\": \"WebApplication\",\n");
        json.append("  \"name\": \"").append(escapeJson(gameName)).append("\",\n");
        json.append("  \"url\": \"").append(escapeJson(canonical)).append("\",\n");
        json.append("  \"description\": \"").append(escapeJson(description)).append("\",\n");
        json.append("  \"applicationCategory\": \"GameApplication\",\n");
        json.append("  \"operatingSystem\": \"Any\",\n");
        json.append("  \"browserRequirements\": \"Requires JavaScript\",\n");
        json.append("  \"offers\": {\n");
        json.append("    \"@type\": \"Offer\",\n");
        json.append("    \"price\": \"0\",\n");
        json.append("    \"priceCurrency\": \"USD\"\n");
        json.append("  },\n");
        json.append("  \"author\": {\n");
        json.append("    \"@type\": \"Organization\",\n");
        json.append("    \"name\": \"8gwifi.org\",\n");
        json.append("    \"url\": \"https://8gwifi.org\"\n");
        json.append("  },\n");
        json.append("  \"publisher\": {\n");
        json.append("    \"@type\": \"Organization\",\n");
        json.append("    \"name\": \"8gwifi.org\",\n");
        json.append("    \"url\": \"https://8gwifi.org\"\n");
        json.append("  },\n");
        json.append("  \"isPartOf\": {\n");
        json.append("    \"@type\": \"WebSite\",\n");
        json.append("    \"name\": \"Math Memory Games\",\n");
        json.append("    \"url\": \"https://8gwifi.org/exams/math-memory/\"\n");
        json.append("  }\n");
        json.append("}\n");
        json.append("</script>\n");

        // BreadcrumbList Schema
        appendBreadcrumbJsonLd(json, gameName, canonical);

        return json.toString();
    }

    private void appendOrganizationJsonLd(StringBuilder json) {
        json.append("<script type=\"application/ld+json\">\n");
        json.append("{\n");
        json.append("  \"@context\": \"https://schema.org\",\n");
        json.append("  \"@type\": \"Organization\",\n");
        json.append("  \"name\": \"8gwifi.org\",\n");
        json.append("  \"url\": \"https://8gwifi.org\"\n");
        json.append("}\n");
        json.append("</script>\n");
    }

    private void appendWebSiteJsonLd(StringBuilder json) {
        json.append("<script type=\"application/ld+json\">\n");
        json.append("{\n");
        json.append("  \"@context\": \"https://schema.org\",\n");
        json.append("  \"@type\": \"WebSite\",\n");
        json.append("  \"name\": \"Math Memory Games\",\n");
        json.append("  \"url\": \"https://8gwifi.org/exams/math-memory/\",\n");
        json.append("  \"publisher\": {\n");
        json.append("    \"@type\": \"Organization\",\n");
        json.append("    \"name\": \"8gwifi.org\",\n");
        json.append("    \"url\": \"https://8gwifi.org\"\n");
        json.append("  }\n");
        json.append("}\n");
        json.append("</script>\n");
    }

    private void appendBreadcrumbJsonLd(StringBuilder json, String leafName, String leafUrl) {
        json.append("<script type=\"application/ld+json\">\n");
        json.append("{\n");
        json.append("  \"@context\": \"https://schema.org\",\n");
        json.append("  \"@type\": \"BreadcrumbList\",\n");
        json.append("  \"itemListElement\": [\n");
        json.append("    {\n");
        json.append("      \"@type\": \"ListItem\",\n");
        json.append("      \"position\": 1,\n");
        json.append("      \"name\": \"Home\",\n");
        json.append("      \"item\": \"https://8gwifi.org\"\n");
        json.append("    },\n");
        json.append("    {\n");
        json.append("      \"@type\": \"ListItem\",\n");
        json.append("      \"position\": 2,\n");
        json.append("      \"name\": \"Math Memory Games\",\n");
        json.append("      \"item\": \"https://8gwifi.org/exams/math-memory/\"\n");
        json.append("    },\n");
        json.append("    {\n");
        json.append("      \"@type\": \"ListItem\",\n");
        json.append("      \"position\": 3,\n");
        json.append("      \"name\": \"").append(escapeJson(leafName)).append("\",\n");
        json.append("      \"item\": \"").append(escapeJson(leafUrl)).append("\"\n");
        json.append("    }\n");
        json.append("  ]\n");
        json.append("}\n");
        json.append("</script>\n");
    }
%>
