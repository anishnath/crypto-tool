<%-- Shared <head> part of the /gpu/* GridPup pages (gpu-training.jsp, gpu-model-benchmark.jsp,
     gpu-llm-services.jsp, gpu-models.jsp). Static include: put it after the SEO include. --%>
<%!
    // Live data comes from GridPup (gridpup.com) through GpuPricesFunctionality, cached server-side.
    static String esc(String s) {
        if (s == null) return "";
        StringBuilder b = new StringBuilder(s.length());
        for (char c : s.toCharArray()) {
            switch (c) {
                case '<': b.append("&lt;"); break;
                case '>': b.append("&gt;"); break;
                case '&': b.append("&amp;"); break;
                case '"': b.append("&quot;"); break;
                case '\'': b.append("&#39;"); break;
                default: b.append(c);
            }
        }
        return b.toString();
    }
    static String str(com.google.gson.JsonObject o, String k) {
        com.google.gson.JsonElement e = o == null ? null : o.get(k);
        return e == null || e.isJsonNull() ? null : e.getAsString();
    }
    static Double num(com.google.gson.JsonObject o, String k) {
        com.google.gson.JsonElement e = o == null ? null : o.get(k);
        return e == null || e.isJsonNull() ? null : e.getAsDouble();
    }
    static String usd(Double v) {
        if (v == null) return "&mdash;";
        return v < 1 ? String.format("$%.3f", v) : String.format("$%,.2f", v);
    }
    static String gb(Double v) {
        if (v == null) return "&mdash;";
        return (v >= 10 || v == Math.floor(v) ? String.valueOf(Math.round(v)) : String.format("%.1f", v)) + " GB";
    }
    /** A GridPup link tagged with the page it came from. */
    static String gp(String path, String campaign) {
        int hash = path.indexOf('#');
        String anchor = hash < 0 ? "" : path.substring(hash);
        String p = hash < 0 ? path : path.substring(0, hash);
        return "https://gridpup.com" + p + (p.contains("?") ? "&" : "?")
                + "utm_source=8gwifi&utm_medium=referral&utm_campaign=" + campaign + anchor;
    }

    /**
     * A table of open models from GridPup's catalog (GpuPricesFunctionality.models): name, size,
     * GPU memory needed and the cheapest machine that runs it now. Only the models in {@code only},
     * in its order, when given; otherwise the first {@code limit}.
     */
    static String modelTable(com.google.gson.JsonArray models, String[] only, int limit, String caption, String campaign) {
        java.util.List<com.google.gson.JsonObject> rows = new java.util.ArrayList<>();
        if (only != null) {
            for (String id : only) {
                for (com.google.gson.JsonElement e : models) {
                    if (id.equals(str(e.getAsJsonObject(), "id"))) { rows.add(e.getAsJsonObject()); break; }
                }
            }
        } else {
            for (com.google.gson.JsonElement e : models) {
                if (rows.size() >= limit) break;
                rows.add(e.getAsJsonObject());
            }
        }
        if (rows.isEmpty()) {
            return "<p class=\"gh-empty\">The model list is not available right now. See it on <a href=\""
                    + gp("/models", campaign) + "\" target=\"_blank\" rel=\"noopener\">GridPup</a>.</p>";
        }
        StringBuilder b = new StringBuilder("<div class=\"gh-table-wrap\"><table class=\"gh-table\"><caption class=\"sr-only\">")
                .append(esc(caption)).append("</caption><thead><tr><th scope=\"col\">Model</th>")
                .append("<th scope=\"col\" class=\"r gh-hide-sm\">Size</th><th scope=\"col\" class=\"r\">GPU memory needed</th>")
                .append("<th scope=\"col\" class=\"gh-hide-sm\">Cheapest machine now</th><th scope=\"col\" class=\"r\">From /h</th></tr></thead><tbody>");
        for (com.google.gson.JsonObject m : rows) {
            String id = str(m, "id");
            int slash = id.indexOf('/');
            com.google.gson.JsonObject c = m.has("cheapest") && m.get("cheapest").isJsonObject() ? m.getAsJsonObject("cheapest") : null;
            String size = str(m, "size_label");
            boolean gated = m.has("gated") && !m.get("gated").isJsonNull() && m.get("gated").getAsBoolean();
            b.append("<tr><td><a href=\"").append(gp("/models/" + id, campaign)).append("\" target=\"_blank\" rel=\"noopener\">")
             .append(esc(id.substring(slash + 1))).append("</a><br><span class=\"gh-muted\">")
             .append(esc(slash > 0 ? id.substring(0, slash) : "")).append(gated ? " &middot; licence approval needed" : "").append("</span></td>")
             .append("<td class=\"r num gh-hide-sm\">").append(size == null ? "&mdash;" : esc(size.replace("~", ""))).append("</td>")
             .append("<td class=\"r num\">").append(gb(num(m, "need_gpu_gb"))).append("</td>")
             .append("<td class=\"gh-hide-sm\">").append(c == null ? "&mdash;" : esc(str(c, "gpu"))).append("</td>")
             .append("<td class=\"r num\"><strong>").append(c == null ? "&mdash;" : usd(num(c, "usd_per_hour"))).append("</strong></td></tr>");
        }
        return b.append("</tbody></table></div>").toString();
    }
%>
    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>

    <!-- CSS -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="/modern/ads/ad-init.jsp" %>

    <style>
        :root{--tool-primary:#059669;--tool-primary-dark:#047857;--tool-gradient:linear-gradient(135deg,#059669 0%,#047857 100%);--tool-light:#ecfdf5}
        [data-theme="dark"]{--tool-gradient:linear-gradient(135deg,#10b981 0%,#059669 100%);--tool-light:rgba(5,150,105,0.15)}

        .tool-page-header{padding:0.5rem 1rem !important;min-height:0 !important;border-bottom:1px solid var(--border)}
        .tool-page-header-inner{display:flex !important;align-items:center !important;gap:0.75rem;flex-wrap:wrap;padding:0 !important;margin:0 auto !important;max-width:1200px}
        .tool-page-header-inner > div:first-child{display:flex;align-items:baseline;gap:0.75rem;flex-wrap:wrap;min-width:0}
        .tool-page-title{font-size:1.05rem !important;font-weight:700 !important;margin:0 !important;line-height:1.25 !important;letter-spacing:-0.01em}
        .tool-breadcrumbs{font-size:0.72rem !important;line-height:1.25 !important;margin:0 !important;color:var(--text-secondary)}
        .tool-breadcrumbs a{color:var(--tool-primary);text-decoration:none}
        .tool-breadcrumbs a:hover{text-decoration:underline}
        .tool-description-section{padding:0.4rem 1rem !important}
        @media (max-width:640px){.tool-page-title{font-size:0.95rem !important}}

        .gh-wrap{max-width:1200px;margin:0 auto;padding:1rem 1rem 2rem}
        .gh-lead{max-width:760px;font-size:1.0625rem;line-height:1.65;color:var(--text-secondary);margin:0.25rem 0 1rem}
        .gh-lead strong{color:var(--text-primary)}
        .gh-cta{display:flex;flex-wrap:wrap;gap:0.6rem;align-items:center;margin:0 0 1.75rem}
        .gh-btn{display:inline-block;padding:0.65rem 1.1rem;border-radius:0.5rem;background:var(--tool-gradient);color:#fff;font-weight:600;text-decoration:none;font-size:0.9375rem}
        .gh-btn:hover{filter:brightness(1.08)}
        .gh-btn:focus-visible,.gh-btn2:focus-visible{outline:2px solid var(--tool-primary);outline-offset:2px}
        .gh-btn2{display:inline-block;padding:0.6rem 1rem;border-radius:0.5rem;border:1.5px solid var(--border);color:var(--text-primary);font-weight:600;text-decoration:none;font-size:0.9375rem;background:var(--bg-primary)}
        .gh-btn2:hover{border-color:var(--tool-primary);color:var(--tool-primary)}
        .gh-note{font-size:0.8125rem;color:var(--text-secondary)}

        .gh-h2{font-size:1.2rem;font-weight:700;color:var(--text-primary);margin:2rem 0 0.35rem}
        .gh-sub{color:var(--text-secondary);font-size:0.9rem;margin:0 0 0.75rem;max-width:760px;line-height:1.6}

        .gh-table-wrap{overflow-x:auto;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-primary)}
        .gh-table{width:100%;border-collapse:collapse;font-size:0.875rem}
        .gh-table th{background:var(--bg-secondary);text-align:left;font-size:0.75rem;font-weight:600;color:var(--text-secondary);padding:0.6rem 0.75rem;border-bottom:1px solid var(--border);white-space:nowrap}
        .gh-table td{padding:0.55rem 0.75rem;border-bottom:1px solid var(--border);vertical-align:middle;color:var(--text-primary)}
        .gh-table tr:last-child td{border-bottom:none}
        .gh-table .r{text-align:right}
        .gh-table .num{font-family:'JetBrains Mono',ui-monospace,monospace;font-variant-numeric:tabular-nums;white-space:nowrap}
        .gh-table a{color:var(--tool-primary);font-weight:600;text-decoration:none}
        .gh-table a:hover{text-decoration:underline}
        .gh-muted{color:var(--text-secondary);font-size:0.78rem}
        .gh-source{margin-top:0.5rem;font-size:0.78rem;color:var(--text-secondary)}
        .gh-source a{color:var(--tool-primary);font-weight:600}
        .gh-empty{padding:1.5rem;text-align:center;color:var(--text-secondary)}
        @media (max-width:720px){.gh-hide-sm{display:none}}

        .gh-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:0.75rem}
        .gh-card{border:1px solid var(--border);border-radius:0.75rem;padding:1rem 1.1rem;background:var(--bg-primary)}
        .gh-card h3{font-size:1rem;margin:0 0 0.35rem;color:var(--text-primary)}
        .gh-card p{font-size:0.875rem;line-height:1.6;color:var(--text-secondary);margin:0}
        .gh-card a{color:var(--tool-primary);font-weight:600;text-decoration:none}
        .gh-card a:hover{text-decoration:underline}
        .gh-card .gh-price{display:block;margin-top:0.5rem;font-family:'JetBrains Mono',ui-monospace,monospace;font-size:0.8125rem;color:var(--text-primary)}

        .gh-steps{counter-reset:s;list-style:none;margin:0;padding:0;display:grid;gap:0.6rem;max-width:760px}
        .gh-steps li{counter-increment:s;position:relative;padding-left:2.25rem;color:var(--text-secondary);line-height:1.6;font-size:0.9375rem}
        .gh-steps li::before{content:counter(s);position:absolute;left:0;top:0.05rem;width:1.5rem;height:1.5rem;border-radius:50%;background:var(--tool-light);color:var(--tool-primary);font-weight:700;font-size:0.8rem;display:flex;align-items:center;justify-content:center}
        .gh-steps strong{color:var(--text-primary)}

        .gh-faq{max-width:820px}
        .gh-faq details{border-bottom:1px solid var(--border);padding:0.7rem 0}
        .gh-faq summary{cursor:pointer;font-weight:600;color:var(--text-primary);font-size:0.9375rem}
        .gh-faq summary:focus-visible{outline:2px solid var(--tool-primary);outline-offset:2px}
        .gh-faq p{margin:0.45rem 0 0;color:var(--text-secondary);line-height:1.65;font-size:0.9375rem}
    </style>
