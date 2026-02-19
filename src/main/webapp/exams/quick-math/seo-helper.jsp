<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.nio.file.*, org.json.*" %>
<%!
    /**
     * SEO Helper for Quick Math Topics
     * Reads from topics-seo.json (array-based structure)
     */

    // Cache the SEO JSON data (indexed by topic ID for fast lookup)
    private static java.util.Map<String, org.json.JSONObject> topicCache = null;
    private static org.json.JSONObject fullData = null;
    private static long cacheTime = 0;
    private static final long CACHE_TTL_MS = 3600000; // 1 hour

    /**
     * Load and index SEO data from JSON file
     */
    public void loadSEOData(ServletContext context) {
        long currentTime = System.currentTimeMillis();

        // Return if cache is still valid
        if (topicCache != null && (currentTime - cacheTime) < CACHE_TTL_MS) {
            return;
        }

        try {
            String jsonPath = context.getRealPath("/exams/quick-math/topics-seo.json");
            String jsonContent = new String(Files.readAllBytes(Paths.get(jsonPath)), "UTF-8");
            fullData = new org.json.JSONObject(jsonContent);

            // Build index from topics array
            topicCache = new java.util.HashMap<>();
            if (fullData.has("topics")) {
                org.json.JSONArray topics = fullData.getJSONArray("topics");
                for (int i = 0; i < topics.length(); i++) {
                    org.json.JSONObject topic = topics.getJSONObject(i);
                    String id = topic.optString("id", "");
                    if (!id.isEmpty()) {
                        topicCache.put(id, topic);
                    }
                }
            }
            cacheTime = currentTime;
        } catch (Exception e) {
            e.printStackTrace();
            topicCache = new java.util.HashMap<>();
            fullData = new org.json.JSONObject();
        }
    }

    /**
     * Get SEO metadata for a specific topic by ID
     */
    public org.json.JSONObject getTopicSEO(String topicId, ServletContext context) {
        loadSEOData(context);

        if (topicId != null && topicCache != null && topicCache.containsKey(topicId)) {
            return topicCache.get(topicId);
        }

        return null;
    }

    /**
     * Get SEO title for a topic
     */
    public String getSEOTitle(String topicId, ServletContext context) {
        org.json.JSONObject topic = getTopicSEO(topicId, context);
        if (topic != null) {
            return topic.optString("seoTitle", "Mental Math Tricks | Quick Math");
        }
        return "Mental Math Tricks | Quick Math";
    }

    /**
     * Get meta description for a topic
     */
    public String getMetaDescription(String topicId, ServletContext context) {
        org.json.JSONObject topic = getTopicSEO(topicId, context);
        if (topic != null) {
            return topic.optString("metaDescription", "Practice mental math tricks and speed calculation techniques.");
        }
        return "Practice mental math tricks and speed calculation techniques.";
    }

    /**
     * Get H1 headline for a topic (from jsonLD.name or seoTitle)
     */
    public String getH1(String topicId, ServletContext context) {
        org.json.JSONObject topic = getTopicSEO(topicId, context);
        if (topic != null) {
            // Try to get from jsonLD.name first
            if (topic.has("jsonLD")) {
                org.json.JSONObject jsonLD = topic.getJSONObject("jsonLD");
                String name = jsonLD.optString("name", "");
                if (!name.isEmpty()) {
                    return name;
                }
            }
            // Fallback to seoTitle without the " | Quick Math Tricks" suffix
            String seoTitle = topic.optString("seoTitle", "");
            if (seoTitle.contains("|")) {
                return seoTitle.split("\\|")[0].trim();
            }
            return seoTitle;
        }
        return "Mental Math Practice";
    }

    /**
     * Generate Open Graph meta tags
     */
    public String generateSocialTags(String topicId, ServletContext context) {
        org.json.JSONObject topic = getTopicSEO(topicId, context);
        if (topic == null) return "";

        StringBuilder html = new StringBuilder();

        // Open Graph tags
        if (topic.has("openGraph")) {
            org.json.JSONObject og = topic.getJSONObject("openGraph");
            for (String key : og.keySet()) {
                String value = og.optString(key, "");
                if (!value.isEmpty()) {
                    html.append("<meta property=\"").append(escapeHtml(key))
                        .append("\" content=\"").append(escapeHtml(value)).append("\">\n");
                }
            }
        }

        // Twitter Card tags
        if (topic.has("twitterCard")) {
            org.json.JSONObject tc = topic.getJSONObject("twitterCard");
            for (String key : tc.keySet()) {
                String value = tc.optString(key, "");
                if (!value.isEmpty()) {
                    html.append("<meta name=\"").append(escapeHtml(key))
                        .append("\" content=\"").append(escapeHtml(value)).append("\">\n");
                }
            }
        }

        return html.toString();
    }

    /**
     * Generate JSON-LD structured data
     */
    public String generateJSONLD(String topicId, ServletContext context) {
        org.json.JSONObject topic = getTopicSEO(topicId, context);
        if (topic == null || !topic.has("jsonLD")) return "";

        org.json.JSONObject jsonLD = topic.getJSONObject("jsonLD");

        StringBuilder html = new StringBuilder();
        html.append("<script type=\"application/ld+json\">\n");
        html.append(jsonLD.toString(2));
        html.append("\n</script>");

        return html.toString();
    }

    /**
     * Generate BreadcrumbList JSON-LD
     */
    public String generateBreadcrumbJSONLD(String topicId, String topicTitle, String category) {
        org.json.JSONObject breadcrumb = new org.json.JSONObject();
        breadcrumb.put("@context", "https://schema.org");
        breadcrumb.put("@type", "BreadcrumbList");

        org.json.JSONArray items = new org.json.JSONArray();

        // Home
        org.json.JSONObject home = new org.json.JSONObject();
        home.put("@type", "ListItem");
        home.put("position", 1);
        home.put("name", "Exams");
        home.put("item", "https://8gwifi.org/exams/");
        items.put(home);

        // Quick Math
        org.json.JSONObject quickMath = new org.json.JSONObject();
        quickMath.put("@type", "ListItem");
        quickMath.put("position", 2);
        quickMath.put("name", "Quick Math");
        quickMath.put("item", "https://8gwifi.org/exams/quick-math/");
        items.put(quickMath);

        // Current Topic
        org.json.JSONObject current = new org.json.JSONObject();
        current.put("@type", "ListItem");
        current.put("position", 3);
        current.put("name", topicTitle);
        items.put(current);

        breadcrumb.put("itemListElement", items);

        StringBuilder html = new StringBuilder();
        html.append("<script type=\"application/ld+json\">\n");
        html.append(breadcrumb.toString(2));
        html.append("\n</script>");

        return html.toString();
    }

    /**
     * Get canonical URL for a topic
     */
    public String getCanonicalUrl(String topicId, ServletContext context) {
        org.json.JSONObject topic = getTopicSEO(topicId, context);
        if (topic != null) {
            return topic.optString("canonical", "https://8gwifi.org/exams/quick-math/practice.jsp?topic=" + topicId);
        }
        return "https://8gwifi.org/exams/quick-math/practice.jsp?topic=" + topicId;
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
%>
