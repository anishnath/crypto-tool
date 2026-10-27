<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@ page import="com.google.gson.JsonArray, com.google.gson.JsonElement, com.google.gson.JsonObject, z.y.x.Network.GpuPricesFunctionality" %>
<%!
    // Live prices come from GridPup (gridpup.com) through GpuPricesFunctionality, cached server-side.
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
    static String str(JsonObject o, String k) {
        JsonElement e = o.get(k);
        return e == null || e.isJsonNull() ? null : e.getAsString();
    }
    static Double num(JsonObject o, String k) {
        JsonElement e = o.get(k);
        return e == null || e.isJsonNull() ? null : e.getAsDouble();
    }
    static String usd(Double v) {
        if (v == null) return "&mdash;";
        return v < 1 ? String.format("$%.3f", v) : String.format("$%.2f", v);
    }
    static String gb(Double v) {
        if (v == null) return "&mdash;";
        return (v == Math.floor(v) ? String.valueOf(v.intValue()) : String.format("%.1f", v)) + " GB";
    }
    static String cloud(JsonObject names, String id) {
        if (id == null) return "&mdash;";
        JsonElement n = names == null ? null : names.get(id);
        return esc(n == null || n.isJsonNull() ? id : n.getAsString());
    }
    static final String UTM = "utm_source=8gwifi&utm_medium=referral&utm_campaign=gpu-prices";
    static String gridpup(String path) {
        return "https://gridpup.com" + path + (path.contains("?") ? "&" : "?") + UTM;
    }
%>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
    String hubPage = "prices";
    JsonObject data = GpuPricesFunctionality.snapshot();
    JsonArray items = data == null ? new JsonArray() : data.getAsJsonArray("items");
    JsonObject clouds = data == null ? null : data.getAsJsonObject("clouds");
    String updated = data == null ? null : str(data, "last_collected_at");
    String updatedHuman = updated == null ? "" : updated.replace("T", " ").replace("Z", " UTC");
    int cloudCount = clouds == null ? 0 : clouds.entrySet().size();
    int offerCount = 0;
    for (JsonElement e : items) {
        Double n = num(e.getAsJsonObject(), "offers");
        if (n != null) offerCount += n.intValue();
    }
    // A few headline prices for the description (H100, A100, RTX 4090) when present.
    String h100 = null, a100 = null, r4090 = null;
    for (JsonElement e : items) {
        JsonObject o = e.getAsJsonObject();
        String id = str(o, "model_id");
        if ("nvidia-h100".equals(id)) h100 = usd(num(o, "cheapest_usd_per_gpu_hour"));
        if ("nvidia-a100".equals(id)) a100 = usd(num(o, "cheapest_usd_per_gpu_hour"));
        if ("nvidia-rtx-4090".equals(id)) r4090 = usd(num(o, "cheapest_usd_per_gpu_hour"));
    }
    String headline = (h100 != null ? "H100 from " + h100 + "/h" : "")
            + (a100 != null ? (h100 != null ? ", " : "") + "A100 from " + a100 + "/h" : "")
            + (r4090 != null ? ", RTX 4090 from " + r4090 + "/h" : "");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">

    <!-- Resource Hints -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdnjs.cloudflare.com">

    <!-- Critical CSS -->
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#f8fafc;margin:0}
        :root,:root[data-theme="light"]{--primary:#6366f1;--primary-dark:#4f46e5;--bg-primary:#fff;--bg-secondary:#f8fafc;--text-primary:#0f172a;--text-secondary:#475569;--border:#e2e8f0}
    </style>

    <!-- SEO -->
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Cloud GPU Prices Today: H100, A100, RTX 4090 Cost per Hour (Live)" />
        <jsp:param name="toolDescription" value="Live cloud GPU rental prices per GPU-hour across Vast.ai, RunPod, Lambda-style GPU clouds and more. Compare H100, H200, B200, A100, L40S and RTX 4090 prices, updated every few minutes." />
        <jsp:param name="toolCategory" value="DevOps &amp; Infrastructure" />
        <jsp:param name="toolUrl" value="gpu" />
        <jsp:param name="toolKeywords" value="gpu prices, cloud gpu prices, gpu cloud pricing, h100 price per hour, h100 rental price, a100 price per hour, h200 price per hour, b200 price per hour, rtx 4090 cloud price, rtx 5090 cloud rental, l40s price per hour, cheapest cloud gpu, gpu rental comparison, rent gpu by the hour, vast.ai prices, runpod prices, gpu cost per hour, ai training gpu cost, llm inference gpu price, cloud gpu comparison 2026" />
        <jsp:param name="toolImage" value="gpu-prices.png" />
        <jsp:param name="toolFeatures" value="Live per-GPU-hour prices for 70+ GPU models,Cheapest price and median price for each GPU,Price for every cloud that rents the GPU,24-hour price change for each GPU,Filter data center consumer and workstation GPUs,Search by GPU name such as H100 A100 or 4090,Sort by price memory or popularity,Prices collected every few minutes by GridPup,Free with no signup" />
        <jsp:param name="faq1q" value="How much does an H100 cost per hour in the cloud?" />
        <jsp:param name="faq1a" value="H100 rental prices change through the day. The table on this page shows the cheapest live H100 price per GPU-hour and the median across all clouds that list it, refreshed every few minutes. Marketplace clouds such as Vast.ai are usually cheapest; managed clouds cost more but include support and fixed capacity." />
        <jsp:param name="faq2q" value="Why are prices shown per GPU-hour?" />
        <jsp:param name="faq2a" value="Clouds rent machines with 1, 2, 4 or 8 GPUs. Dividing the machine price by its GPU count gives a per-GPU-hour price, so an 8x H100 server and a single H100 can be compared directly." />
        <jsp:param name="faq3q" value="What is the difference between the cheapest and the median price?" />
        <jsp:param name="faq3a" value="The cheapest price is the lowest on-demand listing right now, often a single machine. The median is the middle price across all listings for that GPU, a better guide to what you will typically pay." />
        <jsp:param name="faq4q" value="Where do these GPU prices come from?" />
        <jsp:param name="faq4a" value="Prices come from GridPup (gridpup.com), which reads each cloud's public price and availability data every few minutes. Open any GPU on GridPup to see every individual offer, price history and where to rent it." />
    </jsp:include>
<%
    // Product list for search engines: each GPU with its live price range across clouds.
    if (items.size() > 0) {
        StringBuilder ld = new StringBuilder();
        ld.append("{\"@context\":\"https://schema.org\",\"@type\":\"ItemList\",\"name\":\"Cloud GPU prices per GPU-hour\",\"itemListElement\":[");
        int pos = 0;
        for (JsonElement e : items) {
            JsonObject o = e.getAsJsonObject();
            Double low = num(o, "cheapest_usd_per_gpu_hour");
            if (low == null || pos >= 30) continue;
            Double mid = num(o, "median_usd_per_gpu_hour");
            String name = str(o, "display_name").replace("\\", "").replace("\"", "");
            if (pos > 0) ld.append(',');
            pos++;
            ld.append("{\"@type\":\"ListItem\",\"position\":").append(pos)
              .append(",\"item\":{\"@type\":\"Product\",\"name\":\"").append(name).append(" cloud GPU rental (per GPU-hour)\"")
              .append(",\"url\":\"https://gridpup.com/gpus/").append(str(o, "model_id")).append("\"")
              .append(",\"offers\":{\"@type\":\"AggregateOffer\",\"priceCurrency\":\"USD\",\"lowPrice\":").append(String.format("%.4f", low));
            if (mid != null) ld.append(",\"highPrice\":").append(String.format("%.4f", Math.max(mid, low)));
            Double n = num(o, "offers");
            if (n != null) ld.append(",\"offerCount\":").append(n.intValue());
            ld.append("}}}");
        }
        ld.append("]}");
%>
    <script type="application/ld+json"><%= ld.toString() %></script>
<%  } %>

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

    <%@ include file="modern/ads/ad-init.jsp" %>

    <!-- Tool-specific styles -->
    <style>
        :root{--tool-primary:#059669;--tool-primary-dark:#047857;--tool-gradient:linear-gradient(135deg,#059669 0%,#047857 100%);--tool-light:#ecfdf5;--up:#b42323;--down:#047857}
        [data-theme="dark"]{--tool-gradient:linear-gradient(135deg,#10b981 0%,#059669 100%);--tool-light:rgba(5,150,105,0.15);--up:#f87171;--down:#34d399}

        .gp-wrap{max-width:1200px;margin:0 auto;padding:1rem 1rem 2rem}
        .gp-stats{display:flex;flex-wrap:wrap;gap:0.5rem 1.5rem;align-items:baseline;margin:0.25rem 0 1rem;color:var(--text-secondary);font-size:0.875rem}
        .gp-stats strong{color:var(--text-primary);font-size:1.05rem}
        .gp-stats a{color:var(--tool-primary);font-weight:600;text-decoration:none}
        .gp-stats a:hover{text-decoration:underline}

        .gp-controls{display:flex;flex-wrap:wrap;gap:0.5rem;align-items:center;margin-bottom:0.75rem}
        .gp-search{flex:1 1 220px;min-width:0;padding:0.55rem 0.75rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);font:inherit;font-size:0.9rem}
        .gp-search:focus,.gp-sort:focus{outline:2px solid var(--tool-primary);outline-offset:1px;border-color:transparent}
        .gp-classes{display:flex;border:1.5px solid var(--border);border-radius:0.5rem;overflow:hidden}
        .gp-class{padding:0.5rem 0.8rem;border:none;background:var(--bg-primary);color:var(--text-secondary);font:inherit;font-size:0.8125rem;font-weight:600;cursor:pointer}
        .gp-class + .gp-class{border-left:1.5px solid var(--border)}
        .gp-class[aria-pressed="true"]{background:var(--tool-gradient);color:#fff}
        .gp-sort{padding:0.5rem 0.6rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);font:inherit;font-size:0.8125rem}

        .gp-table-wrap{overflow-x:auto;border:1px solid var(--border);border-radius:0.75rem;background:var(--bg-primary)}
        .gp-table{width:100%;border-collapse:collapse;font-size:0.875rem}
        .gp-table th{position:sticky;top:0;background:var(--bg-secondary);text-align:left;font-size:0.75rem;font-weight:600;color:var(--text-secondary);padding:0.6rem 0.75rem;border-bottom:1px solid var(--border);white-space:nowrap}
        .gp-table td{padding:0.6rem 0.75rem;border-bottom:1px solid var(--border);vertical-align:middle}
        .gp-table .r{text-align:right}
        .gp-table .num{font-family:'JetBrains Mono',ui-monospace,monospace;font-variant-numeric:tabular-nums;white-space:nowrap}
        .gp-row:hover td{background:var(--tool-light)}
        .gp-name{font-weight:600;color:var(--text-primary)}
        .gp-sub{display:block;font-size:0.72rem;color:var(--text-secondary);font-weight:400}
        .gp-price{font-weight:700;color:var(--text-primary)}
        .gp-up{color:var(--up)}.gp-down{color:var(--down)}
        .gp-toggle{border:1px solid var(--border);background:var(--bg-primary);color:var(--text-secondary);border-radius:0.375rem;padding:0.2rem 0.5rem;font:inherit;font-size:0.75rem;cursor:pointer;white-space:nowrap}
        .gp-toggle:hover{border-color:var(--tool-primary);color:var(--tool-primary)}
        .gp-link{color:var(--tool-primary);font-weight:600;text-decoration:none;white-space:nowrap;font-size:0.8125rem}
        .gp-link:hover{text-decoration:underline}
        .gp-detail td{background:var(--bg-secondary);padding:0.5rem 0.75rem 0.85rem}
        .gp-clouds{display:grid;grid-template-columns:repeat(auto-fill,minmax(210px,1fr));gap:0.4rem}
        .gp-cloud{display:flex;justify-content:space-between;gap:0.5rem;padding:0.4rem 0.6rem;border:1px solid var(--border);border-radius:0.4rem;background:var(--bg-primary);font-size:0.8125rem}
        .gp-cloud span:last-child{color:var(--text-secondary)}
        .gp-empty{padding:2rem;text-align:center;color:var(--text-secondary)}
        .gp-source{margin-top:0.6rem;font-size:0.78rem;color:var(--text-secondary)}
        .gp-source a{color:var(--tool-primary);font-weight:600}
        @media (max-width:720px){.gp-hide-sm{display:none}}

        .gp-doc{max-width:900px;margin:0 auto;padding:1rem 1rem 2rem}
        .gp-doc-inner{border:1px solid var(--border);border-radius:0.75rem;padding:1.5rem;background:var(--bg-secondary)}
        .gp-doc h2{font-size:1.2rem;margin:0 0 0.75rem;color:var(--text-primary)}
        .gp-doc h3{font-size:1rem;margin:1.25rem 0 0.4rem;color:var(--text-primary)}
        .gp-doc p,.gp-doc li{color:var(--text-secondary);line-height:1.7;font-size:0.9375rem}
        .gp-doc ul{margin:0.25rem 0 0 1.25rem}
        .gp-doc a{color:var(--tool-primary);font-weight:600}
    </style>
</head>
<body>
    <%@ include file="modern/components/nav-header.jsp" %>

    <!-- Page Header (compact) -->
    <style>
        .tool-page-header{padding:0.5rem 1rem !important;min-height:0 !important;border-bottom:1px solid var(--border)}
        .tool-page-header-inner{display:flex !important;align-items:center !important;gap:0.75rem;flex-wrap:wrap;padding:0 !important;margin:0 auto !important;max-width:1400px}
        .tool-page-header-inner > div:first-child{display:flex;align-items:baseline;gap:0.75rem;flex-wrap:wrap;min-width:0}
        .tool-page-title{font-size:1.05rem !important;font-weight:700 !important;margin:0 !important;line-height:1.25 !important;letter-spacing:-0.01em}
        .tool-breadcrumbs{font-size:0.72rem !important;line-height:1.25 !important;margin:0 !important;color:var(--text-secondary)}
        .tool-breadcrumbs a{color:var(--tool-primary,#667eea);text-decoration:none}
        .tool-breadcrumbs a:hover{text-decoration:underline}
        .gp-header-pitch{font-size:0.72rem;line-height:1.25;color:var(--text-secondary);padding-left:0.6rem;margin-left:0.6rem;border-left:1px solid var(--border);white-space:nowrap}
        .gp-header-pitch strong{color:var(--text-primary);font-weight:600}
        .gp-header-pitch a{color:var(--tool-primary,#667eea);font-weight:600;text-decoration:none;margin-left:0.25rem}
        .gp-header-pitch a:hover{text-decoration:underline}
        .tool-page-badges{display:flex;gap:0.3rem;margin-left:auto;flex-wrap:wrap}
        .tool-page-badges .tool-badge{padding:0.12rem 0.45rem !important;font-size:0.66rem !important;line-height:1.3 !important;border-radius:9999px !important;font-weight:600;background:rgba(102,126,234,0.10);color:var(--tool-primary,#667eea);border:1px solid rgba(102,126,234,0.25)}
        [data-theme="dark"] .tool-page-badges .tool-badge{background:rgba(102,126,234,0.18);color:#a5b4fc;border-color:rgba(102,126,234,0.35)}
        .tool-description-section{padding:0.4rem 1rem !important}
        .tool-description-content p{font-size:0.78rem !important;line-height:1.5 !important;margin:0 !important;color:var(--text-secondary)}
        @media (max-width:640px){
            .tool-page-title{font-size:0.95rem !important}
            .gp-header-pitch{display:block;padding-left:0;margin-left:0;border-left:none;white-space:normal;margin-top:0.15rem}
            .tool-page-badges{margin-left:0}
        }
    </style>
    <header class="tool-page-header">
        <div class="tool-page-header-inner">
            <div>
                <h1 class="tool-page-title">Cloud GPU Prices per Hour</h1>
                <nav class="tool-breadcrumbs" aria-label="Breadcrumb">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                    <a href="<%=request.getContextPath()%>/index.jsp#tools">DevOps &amp; Infrastructure</a> /
                    <span>GPU Prices</span>
                </nav>
                <span class="gp-header-pitch"><strong>Live prices from <%= cloudCount > 0 ? cloudCount : "many" %> GPU clouds</strong> &mdash; <a href="#gpu-price-guide">How to read this &rarr;</a></span>
            </div>
            <div class="tool-page-badges">
                <span class="tool-badge">H100</span>
                <span class="tool-badge">H200</span>
                <span class="tool-badge">A100</span>
                <span class="tool-badge">RTX 4090</span>
                <span class="tool-badge">Updated every few minutes</span>
            </div>
        </div>
    </header>
    <%@ include file="/WEB-INF/gpu/gpu-hub-nav.inc.jsp" %>

    <!-- Top Ad Slot -->
    <section class="tool-description-section">
        <div class="tool-description-inner">
            <div class="tool-description-ad" style="width:100%;">
                <%@ include file="modern/ads/ad-in-content-top.jsp" %>
            </div>
        </div>
    </section>

    <main class="gp-wrap">
        <p class="gp-stats">
            <% if (items.size() > 0) { %>
            <span><strong><%= items.size() %></strong> GPU models</span>
            <span><strong><%= String.format("%,d", offerCount) %></strong> listings</span>
            <span><strong><%= cloudCount %></strong> clouds</span>
            <span>Prices as of <time datetime="<%= esc(updated) %>"><%= esc(updatedHuman) %></time></span>
            <% if (!headline.isEmpty()) { %><span><%= headline %></span><% } %>
            <% } %>
            <span>Data: <a href="<%= gridpup("/") %>" target="_blank" rel="noopener">GridPup</a></span>
        </p>

        <div class="gp-controls" role="search">
            <label class="sr-only" for="gpSearch">Search GPUs</label>
            <input id="gpSearch" class="gp-search" type="search" placeholder="Search a GPU: H100, A100, 4090, L40S…" autocomplete="off">
            <div class="gp-classes" role="group" aria-label="GPU type">
                <button type="button" class="gp-class" data-class="" aria-pressed="true">All</button>
                <button type="button" class="gp-class" data-class="datacenter" aria-pressed="false">Data center</button>
                <button type="button" class="gp-class" data-class="workstation" aria-pressed="false">Workstation</button>
                <button type="button" class="gp-class" data-class="consumer" aria-pressed="false">Consumer</button>
            </div>
            <label class="sr-only" for="gpSort">Sort</label>
            <select id="gpSort" class="gp-sort">
                <option value="popular">Most listed</option>
                <option value="price">Cheapest first</option>
                <option value="price-desc">Most expensive first</option>
                <option value="memory">Most memory</option>
                <option value="move">Biggest 24h drop</option>
            </select>
        </div>

        <div class="gp-table-wrap">
            <% if (items.size() == 0) { %>
            <p class="gp-empty">GPU prices are not available right now. Try again in a minute, or see them on <a href="<%= gridpup("/") %>" target="_blank" rel="noopener">GridPup</a>.</p>
            <% } else { %>
            <table class="gp-table" id="gpTable">
                <caption class="sr-only">Cloud GPU rental prices in US dollars per GPU-hour</caption>
                <thead>
                    <tr>
                        <th scope="col">GPU</th>
                        <th scope="col" class="r">Memory</th>
                        <th scope="col" class="r">From /GPU/h</th>
                        <th scope="col" class="gp-hide-sm">Cheapest at</th>
                        <th scope="col" class="r gp-hide-sm">Median</th>
                        <th scope="col" class="r gp-hide-sm">24h</th>
                        <th scope="col" class="r">Clouds</th>
                        <th scope="col"><span class="sr-only">Details</span></th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int idx = 0;
                    for (JsonElement e : items) {
                        JsonObject o = e.getAsJsonObject();
                        String id = str(o, "model_id");
                        String name = str(o, "display_name");
                        Double mem = num(o, "memory_gb");
                        Double low = num(o, "cheapest_usd_per_gpu_hour");
                        Double med = num(o, "median_usd_per_gpu_hour");
                        Double move = num(o, "move_24h_pct");
                        JsonArray by = o.getAsJsonArray("by_provider");
                        int nClouds = by == null ? 0 : by.size();
                        String cls = str(o, "gpu_class");
                        String arch = str(o, "architecture");
                %>
                    <tr class="gp-row" data-i="<%= idx %>" data-name="<%= esc(name == null ? "" : name.toLowerCase()) %> <%= esc(id) %>"
                        data-class="<%= esc(cls) %>" data-price="<%= low %>" data-mem="<%= mem == null ? 0 : mem %>"
                        data-move="<%= move == null ? 0 : move %>">
                        <td>
                            <a class="gp-name" href="<%= gridpup("/gpus/" + id) %>" target="_blank" rel="noopener"><%= esc(name) %></a>
                            <span class="gp-sub"><%= esc(arch == null ? "" : arch) %><%= arch != null && cls != null ? " &middot; " : "" %><%= esc(cls == null ? "" : ("datacenter".equals(cls) ? "Data center" : cls.substring(0, 1).toUpperCase() + cls.substring(1))) %></span>
                        </td>
                        <td class="r num"><%= gb(mem) %></td>
                        <td class="r num gp-price"><%= usd(low) %></td>
                        <td class="gp-hide-sm"><%= cloud(clouds, str(o, "cheapest_provider")) %></td>
                        <td class="r num gp-hide-sm"><%= usd(med) %></td>
                        <td class="r num gp-hide-sm <%= move == null || Math.abs(move) < 0.05 ? "" : (move > 0 ? "gp-up" : "gp-down") %>"><%= move == null ? "&mdash;" : String.format("%+.1f%%", move) %></td>
                        <td class="r num"><%= nClouds %></td>
                        <td class="r">
                            <% if (nClouds > 0) { %>
                            <button type="button" class="gp-toggle" aria-expanded="false" aria-controls="gpd-<%= idx %>">Prices by cloud</button>
                            <% } %>
                        </td>
                    </tr>
                    <tr class="gp-detail" id="gpd-<%= idx %>" hidden>
                        <td colspan="8">
                            <div class="gp-clouds">
                            <% if (by != null) for (JsonElement b : by) {
                                   JsonObject bo = b.getAsJsonObject();
                                   Double bn = num(bo, "offers"); %>
                                <div class="gp-cloud"><span><%= cloud(clouds, str(bo, "provider")) %></span><span class="num">from <%= usd(num(bo, "from")) %> &middot; <%= bn == null ? 0 : bn.intValue() %> listing<%= bn != null && bn.intValue() == 1 ? "" : "s" %></span></div>
                            <% } %>
                            </div>
                            <p class="gp-source"><a href="<%= gridpup("/gpus/" + id + "#offers") %>" target="_blank" rel="noopener">See every <%= esc(name) %> offer and its price history on GridPup &rarr;</a></p>
                        </td>
                    </tr>
                <%      idx++;
                    } %>
                </tbody>
            </table>
            <p class="gp-empty" id="gpNone" hidden>No GPU matches. Try another name or type.</p>
            <% } %>
        </div>
        <p class="gp-source">On-demand prices in US dollars per GPU-hour, before tax. Machines with several GPUs are divided by their GPU count. Prices and availability by <a href="<%= gridpup("/") %>" target="_blank" rel="noopener">GridPup, the cloud GPU price comparison</a>.</p>
    </main>

    <div class="tool-mobile-ad-container">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

    <section class="gp-doc" id="gpu-price-guide">
        <div class="gp-doc-inner">
            <h2>How to read cloud GPU prices</h2>
            <p>Each row is one GPU model. <strong>From</strong> is the lowest on-demand price listed right now; <strong>Median</strong> is the middle price across every listing, which is closer to what you will usually pay. <strong>24h</strong> shows how the cheapest price moved over the last day.</p>
            <h3>Choosing a GPU</h3>
            <ul>
                <li><strong>Training large models:</strong> H100, H200, B200 or A100 80 GB. Memory and fast GPU-to-GPU links matter most.</li>
                <li><strong>Fine-tuning and inference:</strong> L40S, RTX 6000 Ada, A6000 or RTX 4090/5090 give the most memory per dollar.</li>
                <li><strong>Experiments and small models:</strong> RTX 3090, 4090 or L4 are the cheapest way to get a capable GPU.</li>
            </ul>
            <h3>Why prices differ between clouds</h3>
            <p>Marketplace clouds rent spare machines from many hosts, so prices are low but vary by host and reliability. Managed clouds run their own data centers and charge more for fixed capacity and support. Storage and data transfer are billed separately on most clouds.</p>
            <h3>Training, benchmarking and deploying</h3>
            <p>Once you know the GPU, you can <a href="<%=request.getContextPath()%>/gpu/training">train or fine-tune a model on it from your browser</a>, <a href="<%=request.getContextPath()%>/gpu/model-benchmark">benchmark an LLM's tokens per second on real GPUs</a>, <a href="<%=request.getContextPath()%>/gpu/models">check how much GPU memory an open model needs</a>, <a href="<%=request.getContextPath()%>/gpu/llm-services">deploy it as an API and test its latency</a>, or <a href="<%=request.getContextPath()%>/gpu/ai-playground">compare LLMs side by side in the AI Playground</a>.</p>
            <h3>Where the data comes from</h3>
            <p>Prices are collected every few minutes by <a href="<%= gridpup("/") %>" target="_blank" rel="noopener">GridPup</a>, which compares GPU clouds and lets you rent from them in one place. Open a GPU to see each listing, its location and price history, or <a href="<%= gridpup("/compare") %>" target="_blank" rel="noopener">compare GPUs side by side</a>.</p>
        </div>
    </section>

    <!-- Related Tools -->
    <jsp:include page="modern/components/related-tools.jsp">
        <jsp:param name="currentToolUrl" value="gpu"/>
        <jsp:param name="category" value="DevOps & Infrastructure"/>
        <jsp:param name="limit" value="6"/>
    </jsp:include>

    <!-- Support Section -->
    <%@ include file="modern/components/support-section.jsp" %>
    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

    <script>
(function () {
    var table = document.getElementById('gpTable');
    if (!table) return;
    var body = table.tBodies[0];
    var rows = Array.prototype.slice.call(body.querySelectorAll('tr.gp-row'));
    var search = document.getElementById('gpSearch');
    var sort = document.getElementById('gpSort');
    var none = document.getElementById('gpNone');
    var cls = '';

    function detailOf(row) { return document.getElementById('gpd-' + row.getAttribute('data-i')); }

    function apply() {
        var q = search.value.trim().toLowerCase().replace(/\s+/g, ' ');
        var shown = 0;
        rows.forEach(function (r) {
            var ok = (!cls || r.getAttribute('data-class') === cls) && (!q || r.getAttribute('data-name').indexOf(q) !== -1);
            r.hidden = !ok;
            var d = detailOf(r);
            if (!ok) d.hidden = true;
            else d.hidden = r.querySelector('.gp-toggle') ? r.querySelector('.gp-toggle').getAttribute('aria-expanded') !== 'true' : true;
            if (ok) shown++;
        });
        none.hidden = shown > 0;
    }

    function order() {
        var by = sort.value;
        var num = function (r, k) { return parseFloat(r.getAttribute(k)) || 0; };
        var sorted = rows.slice().sort(function (a, b) {
            if (by === 'price') return num(a, 'data-price') - num(b, 'data-price');
            if (by === 'price-desc') return num(b, 'data-price') - num(a, 'data-price');
            if (by === 'memory') return num(b, 'data-mem') - num(a, 'data-mem');
            if (by === 'move') return num(a, 'data-move') - num(b, 'data-move');
            return num(a, 'data-i') - num(b, 'data-i');   // GridPup's own order: most listed first
        });
        sorted.forEach(function (r) { body.appendChild(r); body.appendChild(detailOf(r)); });
    }

    search.addEventListener('input', apply);
    sort.addEventListener('change', order);
    Array.prototype.forEach.call(document.querySelectorAll('.gp-class'), function (b) {
        b.addEventListener('click', function () {
            cls = b.getAttribute('data-class');
            Array.prototype.forEach.call(document.querySelectorAll('.gp-class'), function (x) {
                x.setAttribute('aria-pressed', x === b ? 'true' : 'false');
            });
            apply();
        });
    });
    body.addEventListener('click', function (e) {
        var t = e.target.closest ? e.target.closest('.gp-toggle') : null;
        if (!t) return;
        var open = t.getAttribute('aria-expanded') !== 'true';
        t.setAttribute('aria-expanded', open ? 'true' : 'false');
        t.textContent = open ? 'Hide' : 'Prices by cloud';
        document.getElementById(t.getAttribute('aria-controls')).hidden = !open;
    });
})();
    </script>
</body>
</html>
