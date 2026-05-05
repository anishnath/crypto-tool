<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"
    import="java.io.*, java.nio.charset.StandardCharsets, java.nio.file.*,
            java.util.*, com.google.gson.*" %>
<%!
    /* Cached parsed index — re-read whenever the underlying file's mtime changes
       so that running generate_worksheet_metadata.py without a redeploy still
       refreshes the page. */
    private static volatile JsonObject CACHED_INDEX = null;
    private static volatile long CACHED_MTIME = -1L;
    private static final Object CACHE_LOCK = new Object();

    private JsonObject loadIndex(javax.servlet.ServletContext sc) {
        // Resolve the index path against the deployed webapp root.
        String real = sc.getRealPath("/worksheet/math/worksheet-index.json");
        if (real == null) return null;
        Path p = Paths.get(real);
        if (!Files.exists(p)) return null;
        try {
            long m = Files.getLastModifiedTime(p).toMillis();
            if (CACHED_INDEX != null && m == CACHED_MTIME) return CACHED_INDEX;
            synchronized (CACHE_LOCK) {
                if (CACHED_INDEX != null && m == CACHED_MTIME) return CACHED_INDEX;
                String body = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
                // Gson 2.2.4 lacks the static `JsonParser.parseString` — use the
                // instance `.parse(String)` API which has been stable since 1.x.
                JsonObject obj = new JsonParser().parse(body).getAsJsonObject();
                CACHED_INDEX = obj;
                CACHED_MTIME = m;
                return obj;
            }
        } catch (IOException e) {
            return CACHED_INDEX; // best-effort fallback to whatever we had
        }
    }

    /* Pretty-title slugs / file names for SSR labels. */
    private String prettyTitle(String slug) {
        if (slug == null) return "";
        String s = slug.replace('_', ' ').replace('-', ' ');
        if (s.endsWith(".json")) s = s.substring(0, s.length() - 5);
        StringBuilder out = new StringBuilder(s.length());
        boolean cap = true;
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (Character.isWhitespace(c)) { cap = true; out.append(c); continue; }
            out.append(cap ? Character.toUpperCase(c) : c);
            cap = false;
        }
        return out.toString();
    }

    private String escHtml(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&#39;");
    }

    private String escJsonInline(String s) {
        if (s == null) return "";
        // For embedding inside <script type="application/json"> we still need to
        // escape `</` to prevent script-tag confusion.
        return s.replace("</", "<\\/");
    }
%>
<%
    String v = String.valueOf(System.currentTimeMillis());

    // ── Load the worksheet index server-side so the tree is in the
    //    initial HTML (crawlable + first-paint without JS round-trip).
    JsonObject INDEX = loadIndex(application);
    int totalQuestions  = 0;
    int totalWorksheets = 0;
    int totalCategories = 0;
    String generatedAt = "";
    String baseUrl = "https://8gwifi.org";
    StringBuilder itemListItems = new StringBuilder();
    int itemPos = 0;
    if (INDEX != null) {
        if (INDEX.has("total_questions"))  totalQuestions  = INDEX.get("total_questions").getAsInt();
        if (INDEX.has("total_worksheets")) totalWorksheets = INDEX.get("total_worksheets").getAsInt();
        if (INDEX.has("total_categories")) totalCategories = INDEX.get("total_categories").getAsInt();
        if (INDEX.has("generated_at"))     generatedAt     = INDEX.get("generated_at").getAsString();
        // Build ItemList JSON-LD entries — every worksheet gets a position.
        JsonObject cats = INDEX.getAsJsonObject("categories");
        if (cats != null) {
            List<String> catKeys = new ArrayList<String>();
            for (Map.Entry<String, JsonElement> e : cats.entrySet()) catKeys.add(e.getKey());
            Collections.sort(catKeys);
            for (String catSlug : catKeys) {
                JsonObject cat = cats.getAsJsonObject(catSlug);
                if (cat == null || !cat.has("worksheets")) continue;
                for (JsonElement wEl : cat.getAsJsonArray("worksheets")) {
                    JsonObject w = wEl.getAsJsonObject();
                    String topic = w.has("topic") ? w.get("topic").getAsString() : "";
                    String url   = w.has("url")   ? w.get("url").getAsString()   : "";
                    if (itemListItems.length() > 0) itemListItems.append(",\n");
                    itemPos++;
                    itemListItems
                        .append("    {\"@type\":\"ListItem\",\"position\":").append(itemPos)
                        .append(",\"name\":\"").append(topic.replace("\"", "\\\"")).append("\"")
                        .append(",\"url\":\"").append(baseUrl).append(url).append("\"}");
                }
            }
        }
    }

    // CTR-optimised title/description (drives SERP click-through).
    String pageTitle = "Free Math Practice Worksheets &mdash; "
                     + (totalQuestions > 0 ? String.format("%,d", totalQuestions) : "33,000+")
                     + "+ NCERT &amp; JEE Problems";
    String pageDesc  = (totalQuestions > 0 ? String.format("%,d", totalQuestions) : "33,000+")
                     + "+ free math practice problems across "
                     + (totalWorksheets > 0 ? totalWorksheets : 18)
                     + " topics — algebra, calculus, trig, NCERT, JEE. "
                     + "Filter by difficulty, print or save as PDF. No signup.";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="<%=pageTitle%>" />
        <jsp:param name="toolCategory" value="Math Worksheets" />
        <jsp:param name="toolDescription" value="<%=pageDesc%>" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolUrl" value="math/worksheet.jsp" />
        <jsp:param name="toolKeywords" value="math worksheet, practice problems, printable math, algebra worksheet, calculus worksheet, NCERT worksheet, JEE practice, sig fig worksheet, free practice, answer key, math pdf, math homework" />
        <jsp:param name="toolFeatures" value="33000+ problems,18 topics,Printable PDF,Filterable by type and difficulty,Full answer keys,Free no signup,SymPy verified" />
        <jsp:param name="teaches" value="Algebra, calculus, trigonometry, linear algebra, numerics, significant figures, scientific notation" />
        <jsp:param name="educationalLevel" value="Middle School, High School, Undergraduate" />
        <jsp:param name="faq1q" value="How do I generate a practice worksheet?" />
        <jsp:param name="faq1a" value="Pick a topic from the tree on this page (algebra, calculus, etc.), then choose a specific worksheet bank. The worksheet engine opens with filters for question type, difficulty, and count — adjust to taste, then print or save as PDF. Each problem includes a step-by-step answer key." />
        <jsp:param name="faq2q" value="Are these worksheets free?" />
        <jsp:param name="faq2a" value="Yes, every worksheet is completely free — no registration, no paywall, no watermark. Print as many as you need for your class, study group, or self-paced practice." />
        <jsp:param name="faq3q" value="What topics are covered?" />
        <jsp:param name="faq3a" value="Algebra (quadratic, polynomial, inequalities, logarithms, exponents, percentages, systems of equations), calculus (limits, derivatives, integrals, ODEs, PDEs, series, Taylor series, vector calculus), trigonometry, linear algebra (matrices), and numerics (significant figures, scientific notation)." />
        <jsp:param name="faq4q" value="Are problems aligned with NCERT or JEE?" />
        <jsp:param name="faq4a" value="Yes — each generator targets a curriculum: NCERT Class 7-12 for school topics (commercial math, exponents, quadratic, trigonometry), and JEE Mains/Advanced + IIT-level scholar problems for the harder difficulty bands. The descriptions on each worksheet card list the specific chapters covered." />
        <jsp:param name="faq5q" value="How is the math verified?" />
        <jsp:param name="faq5a" value="Every problem is generated and verified server-side using SymPy (symbolic computation), SciPy (numerical), or matplotlib for figures. There is no AI in the loop for the math itself — the answer keys are deterministic and reproducible." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <!-- CollectionPage + ItemList schema — every worksheet enumerated by topic
         and direct URL.  Built from worksheet-index.json at render time so it
         stays in sync as new banks ship. -->
    <% if (itemListItems.length() > 0) { %>
    <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "CollectionPage",
  "name": "<%=pageTitle.replace("&mdash;", "—").replace("&amp;", "&").replace("\"", "\\\"")%>",
  "description": "<%=pageDesc.replace("\"", "\\\"")%>",
  "url": "<%=baseUrl%>/math/worksheet.jsp",
  "inLanguage": "en",
  "isPartOf": {"@type": "WebSite", "name": "8gwifi.org", "url": "<%=baseUrl%>/"},
  "mainEntity": {
    "@type": "ItemList",
    "numberOfItems": <%=itemPos%>,
    "itemListElement": [
<%=itemListItems.toString()%>
    ]
  }
}
    </script>
    <% } %>

    <!-- Inline the parsed index so JS hydration doesn't re-fetch (saves a
         round-trip).  Kept as JSON, not JS, so a stray `</script>` in any
         description can't break the page (we sanitize on read). -->
    <% if (INDEX != null) { %>
    <script type="application/json" id="wsh-index-data"><%=escJsonInline(INDEX.toString())%></script>
    <% } %>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">

    <style>
        /* ── Worksheet hub: tree picker + meta panel ─────────────────────── */
        .wsh-shell {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 360px;
            gap: 1.25rem;
            align-items: start;
        }
        @media (max-width: 980px) {
            .wsh-shell { grid-template-columns: 1fr; }
        }

        .wsh-tree {
            font-family: var(--ms-font-sans);
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
            padding: 0.5rem 0.5rem;
            color: var(--ms-ink);
        }
        .wsh-tree-root {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.55rem 0.5rem 0.6rem;
            font: 500 0.95rem var(--ms-font-sans);
            color: var(--ms-muted);
            border-bottom: 1px solid var(--ms-line);
        }
        .wsh-tree-root strong { color: var(--ms-ink); font-weight: 700; }

        .wsh-cat {
            display: block;
            padding: 0.35rem 0;
        }
        .wsh-cat-head {
            display: flex; align-items: center; gap: 0.55rem;
            padding: 0.45rem 0.55rem;
            cursor: pointer;
            border-radius: var(--ms-radius-sm);
            user-select: none;
            transition: background var(--ms-transition);
        }
        .wsh-cat-head:hover { background: var(--ms-accent-softer); }
        .wsh-cat.open .wsh-cat-head { background: var(--ms-accent-soft); }
        .wsh-caret {
            display: inline-block;
            width: 0.85rem; height: 0.85rem;
            transition: transform 0.15s var(--ms-ease);
            color: var(--ms-muted);
            flex-shrink: 0;
        }
        .wsh-cat.open .wsh-caret { transform: rotate(90deg); }
        .wsh-cat-name { font: 600 0.95rem var(--ms-font-sans); flex: 1; }
        .wsh-cat-stats {
            font: 0.78rem var(--ms-font-mono);
            color: var(--ms-muted);
            white-space: nowrap;
        }

        .wsh-leaves {
            display: none;
            padding: 0.35rem 0 0.35rem 1.55rem;
            margin-left: 0.5rem;
            border-left: 1.5px solid var(--ms-line);
        }
        .wsh-cat.open .wsh-leaves { display: block; }

        .wsh-leaf {
            display: flex; align-items: center; gap: 0.55rem;
            padding: 0.45rem 0.6rem;
            cursor: pointer;
            border-radius: var(--ms-radius-sm);
            background: transparent;
            border: 1.5px solid transparent;
            margin-bottom: 0.25rem;
            transition: background var(--ms-transition),
                        border-color var(--ms-transition);
        }
        .wsh-leaf:hover {
            background: var(--ms-accent-softer);
            border-color: var(--ms-line);
        }
        .wsh-leaf.selected {
            background: var(--ms-accent-soft);
            border-color: var(--ms-accent);
            box-shadow: 0 0 0 3px var(--ms-accent-ring);
        }
        .wsh-leaf-radio {
            width: 0.95rem; height: 0.95rem; border-radius: 50%;
            border: 1.6px solid var(--ms-muted);
            flex-shrink: 0;
            position: relative;
            transition: border-color var(--ms-transition);
        }
        .wsh-leaf.selected .wsh-leaf-radio { border-color: var(--ms-accent); }
        .wsh-leaf.selected .wsh-leaf-radio::after {
            content: ""; position: absolute;
            inset: 2.2px; border-radius: 50%;
            background: var(--ms-accent);
        }
        .wsh-leaf-name { font: 500 0.9rem var(--ms-font-sans); flex: 1; color: var(--ms-ink); }
        .wsh-leaf-stats {
            font: 0.72rem var(--ms-font-mono);
            color: var(--ms-muted);
            white-space: nowrap;
        }

        /* ── Right-side meta panel ──────────────────────────────────────── */
        .wsh-meta {
            position: sticky;
            top: 96px;
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius);
            padding: 1.25rem;
            font-family: var(--ms-font-sans);
            color: var(--ms-ink);
            min-height: 320px;
        }
        @media (max-width: 980px) {
            .wsh-meta { position: static; }
        }

        .wsh-meta-empty {
            color: var(--ms-muted);
            font: italic 0.92rem var(--ms-font-sans);
            text-align: center;
            padding: 2rem 0.5rem;
        }
        .wsh-meta-empty .wsh-meta-empty-icon {
            font-size: 2rem; opacity: 0.45;
            display: block; margin: 0 auto 0.65rem;
        }

        .wsh-meta-title {
            font: 500 1.15rem var(--ms-font-serif);
            color: var(--ms-ink);
            margin: 0 0 0.25rem;
            letter-spacing: -0.015em;
        }
        .wsh-meta-cat {
            font: 0.75rem var(--ms-font-sans);
            color: var(--ms-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.85rem;
        }
        .wsh-meta-desc {
            font: 0.86rem/1.55 var(--ms-font-sans);
            color: var(--ms-ink-soft);
            margin: 0 0 1rem;
        }

        .wsh-meta-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.5rem;
            margin-bottom: 0.85rem;
        }
        .wsh-meta-stat {
            background: var(--ms-panel-bg-soft);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius-sm);
            padding: 0.5rem 0.7rem;
        }
        .wsh-meta-stat-label {
            font: 0.65rem var(--ms-font-mono);
            color: var(--ms-muted);
            text-transform: uppercase; letter-spacing: 0.06em;
            display: block; margin-bottom: 0.2rem;
        }
        .wsh-meta-stat-value {
            font: 600 1rem var(--ms-font-sans);
            color: var(--ms-ink);
        }

        .wsh-diff-bar {
            display: flex;
            height: 0.55rem;
            border-radius: 1rem;
            overflow: hidden;
            background: var(--ms-line);
            margin-bottom: 0.4rem;
        }
        .wsh-diff-bar > span { display: block; height: 100%; }
        .wsh-diff-bar .d-basic   { background: #22c55e; }
        .wsh-diff-bar .d-medium  { background: #3b82f6; }
        .wsh-diff-bar .d-hard    { background: #f59e0b; }
        .wsh-diff-bar .d-scholar { background: #a855f7; }
        .wsh-diff-legend {
            display: flex; flex-wrap: wrap; gap: 0.6rem;
            font: 0.7rem var(--ms-font-sans);
            color: var(--ms-muted);
            margin-bottom: 1rem;
        }
        .wsh-diff-legend i {
            display: inline-block; width: 0.55rem; height: 0.55rem;
            border-radius: 50%; margin-right: 0.3rem; vertical-align: 1px;
        }

        .wsh-cta {
            display: block; width: 100%;
            padding: 0.75rem 1rem;
            font: 600 0.95rem var(--ms-font-sans);
            border: none;
            background: linear-gradient(135deg, var(--ms-cta-start), var(--ms-cta-end));
            color: #fff;
            border-radius: var(--ms-radius-sm);
            cursor: pointer;
            box-shadow: 0 4px 16px var(--ms-cta-shadow);
            transition: transform var(--ms-transition);
        }
        .wsh-cta:hover { transform: translateY(-1px); }
        .wsh-cta:disabled {
            background: var(--ms-line);
            color: var(--ms-muted);
            cursor: not-allowed;
            box-shadow: none;
            transform: none;
        }

        .wsh-types {
            font: 0.78rem var(--ms-font-mono);
            color: var(--ms-ink-soft);
            background: var(--ms-panel-bg-soft);
            border: 1px solid var(--ms-line);
            border-radius: var(--ms-radius-sm);
            padding: 0.55rem 0.7rem;
            max-height: 9rem;
            overflow-y: auto;
            margin-bottom: 1rem;
        }
        .wsh-types-label {
            font: 0.65rem var(--ms-font-mono);
            color: var(--ms-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.3rem;
            display: block;
        }
        .wsh-types-list {
            display: flex; flex-wrap: wrap; gap: 0.3rem;
        }
        .wsh-types-list span {
            font: 0.75rem var(--ms-font-sans);
            background: var(--ms-panel-bg);
            border: 1px solid var(--ms-line);
            border-radius: 999px;
            padding: 0.1rem 0.55rem;
            color: var(--ms-ink-soft);
        }

        .wsh-loading, .wsh-error {
            text-align: center;
            padding: 2rem 1rem;
            color: var(--ms-muted);
            font: 0.92rem var(--ms-font-sans);
        }
        .wsh-error { color: #b91c1c; }
    </style>
    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="../modern/components/nav-header.jsp" />
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "worksheet"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Visible breadcrumb — reinforces site structure for users and helps
             Google build the "Home › Math › Worksheets" path beyond schema. -->
        <nav class="wsh-breadcrumbs" aria-label="Breadcrumb"
             style="font:0.82rem var(--ms-font-sans); color:var(--ms-muted); margin-bottom:0.85rem;">
            <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
            <span aria-hidden="true">&nbsp;&rsaquo;&nbsp;</span>
            <a href="<%=request.getContextPath()%>/math/" style="color:inherit;">Math</a>
            <span aria-hidden="true">&nbsp;&rsaquo;&nbsp;</span>
            <span style="color:var(--ms-ink-soft); font-weight:600;">Practice Worksheets</span>
        </nav>

        <div class="ms-hero-banner" style="background:radial-gradient(circle at 90% 0%, rgba(168,85,247,0.18), transparent 50%), radial-gradient(circle at 0% 100%, rgba(21,128,61,0.14), transparent 55%), var(--ms-panel-bg); padding:2rem 2.25rem 1.85rem;">
            <h1 style="font:400 2.1rem/1.05 var(--ms-font-serif); margin:0 0 0.4rem; letter-spacing:-0.02em; color:var(--ms-ink);">
                Free Math Practice <em style="font-style:italic; color:var(--ms-accent);">Worksheets</em>
                <span style="display:block; font-size:1.15rem; color:var(--ms-ink-soft); font-style:normal; margin-top:0.2rem;">
                    Printable, with full answer keys
                </span>
            </h1>
            <p style="font:1rem var(--ms-font-sans); color:var(--ms-ink-soft); margin:0 0 1.25rem; max-width:62ch;">
                <strong><%= totalQuestions > 0 ? String.format("%,d", totalQuestions) : "33,000+" %>+
                free practice problems</strong> across
                <%= totalWorksheets > 0 ? totalWorksheets : 18 %> topics — algebra,
                calculus, trigonometry, NCERT &amp; JEE chapters. Pick a topic below,
                filter by difficulty, then print or save as PDF. No signup, no paywall.
            </p>
            <div class="ms-hero-stats" id="wsh-hero-stats">
                <div class="ms-hero-stat"><strong id="wsh-total-q"><%= totalQuestions > 0 ? String.format("%,d", totalQuestions) : "—" %></strong>questions</div>
                <div class="ms-hero-stat"><strong id="wsh-total-w"><%= totalWorksheets > 0 ? totalWorksheets : "—" %></strong>worksheets</div>
                <div class="ms-hero-stat"><strong id="wsh-total-c"><%= totalCategories > 0 ? totalCategories : "—" %></strong>topics</div>
                <% if (!generatedAt.isEmpty()) {
                    String fresh = generatedAt.length() >= 10 ? generatedAt.substring(0, 10) : generatedAt;
                %>
                <div class="ms-hero-stat" title="Index regenerated on every build">
                    <strong><%= fresh %></strong>last updated
                </div>
                <% } %>
            </div>
        </div>

        <div class="wsh-shell" style="margin-top:1.25rem;">
            <!-- ── Tree: SSR'd from worksheet-index.json so crawlers see every
                   topic + anchor text on the first byte.  JS attaches click
                   handlers without re-rendering the DOM. ── -->
            <div class="ms-card" style="padding:0.85rem 1rem;">
                <h2 class="ms-section-title" style="margin-bottom:0.65rem;">Browse all worksheets</h2>
                <div class="wsh-tree" id="wshTree" role="tree" aria-label="Worksheet topics">
                    <% if (INDEX != null && INDEX.has("categories")) {
                        JsonObject cats = INDEX.getAsJsonObject("categories");
                        List<String> catKeys = new ArrayList<String>();
                        for (Map.Entry<String, JsonElement> e : cats.entrySet()) catKeys.add(e.getKey());
                        Collections.sort(catKeys);
                    %>
                    <div class="wsh-tree-root">
                        <strong>&#128218; All math worksheets</strong> &middot;
                        <%= totalCategories %> topics &middot;
                        <%= String.format("%,d", totalQuestions) %> questions
                    </div>
                    <% for (String catSlug : catKeys) {
                        JsonObject cat = cats.getAsJsonObject(catSlug);
                        if (cat == null) continue;
                        int catCount = cat.has("worksheet_count") ? cat.get("worksheet_count").getAsInt() : 0;
                        int catQs    = cat.has("total_questions") ? cat.get("total_questions").getAsInt() : 0;
                        // Open the first category by default so the page has visible
                        // links above the fold without requiring a click.
                        String openClass = catSlug.equals(catKeys.get(0)) ? " open" : "";
                    %>
                    <div class="wsh-cat<%=openClass%>" data-cat-slug="<%=escHtml(catSlug)%>">
                        <div class="wsh-cat-head" role="treeitem"
                             aria-expanded="<%= !openClass.isEmpty() ? "true" : "false" %>" tabindex="0">
                            <svg class="wsh-caret" viewBox="0 0 16 16" fill="none"
                                 stroke="currentColor" stroke-width="2.2"
                                 stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="6 4 10 8 6 12"/>
                            </svg>
                            <span class="wsh-cat-name"><%=escHtml(prettyTitle(catSlug))%></span>
                            <span class="wsh-cat-stats">
                                <%=catCount%> sheet<%=catCount == 1 ? "" : "s"%> &middot;
                                <%=String.format("%,d", catQs)%> Qs
                            </span>
                        </div>
                        <div class="wsh-leaves">
                        <% if (cat.has("worksheets")) {
                            for (JsonElement wEl : cat.getAsJsonArray("worksheets")) {
                                JsonObject w = wEl.getAsJsonObject();
                                String wTopic = w.has("topic") ? w.get("topic").getAsString() : "";
                                String wFile  = w.has("file")  ? w.get("file").getAsString()  : "";
                                String wUrl   = w.has("url")   ? w.get("url").getAsString()   : "";
                                int wTotal = w.has("total") ? w.get("total").getAsInt() : 0;
                                int wTypes = w.has("type_count") ? w.get("type_count").getAsInt() : 0;
                        %>
                            <a class="wsh-leaf"
                               href="#<%=escHtml(catSlug)%>/<%=escHtml(wFile.replace(".json", ""))%>"
                               role="treeitem"
                               data-cat-slug="<%=escHtml(catSlug)%>"
                               data-sheet-file="<%=escHtml(wFile)%>"
                               data-sheet-url="<%=escHtml(wUrl)%>"
                               data-sheet-topic="<%=escHtml(wTopic)%>"
                               style="text-decoration:none; color:inherit;">
                                <span class="wsh-leaf-radio"></span>
                                <span class="wsh-leaf-name"><%=escHtml(wTopic)%></span>
                                <span class="wsh-leaf-stats">
                                    <%=String.format("%,d", wTotal)%>q &middot; <%=wTypes%>t
                                </span>
                            </a>
                        <% } } %>
                        </div>
                    </div>
                    <% } %>
                    <% } else { %>
                    <div class="wsh-error">
                        Worksheet index unavailable. Run
                        <code>python3 generate_worksheet_metadata.py</code> to rebuild it.
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- ── Meta panel: shows selected worksheet's stats + CTA ── -->
            <div class="wsh-meta" id="wshMeta" aria-live="polite">
                <div class="wsh-meta-empty">
                    <span class="wsh-meta-empty-icon">&#128218;</span>
                    Pick a worksheet from the tree to see its question types,
                    difficulty mix, and start practising.
                </div>
            </div>
        </div>

        <div class="ms-card" style="margin-top:1.25rem;">
            <h2 class="ms-section-title">FAQ</h2>
            <div class="ms-faq">
                <details class="ms-faq-item">
                    <summary class="ms-faq-q">How are worksheets generated?</summary>
                    <div class="ms-faq-a">
                        Each topic has a Python generator (e.g. <code>generate_quadratic.py</code>)
                        that builds 1,500+ problems using SymPy / SciPy / matplotlib for
                        symbolic math, numeric verification, and figures. A metadata script
                        scans every bank and produces the index this page reads at runtime.
                    </div>
                </details>
                <details class="ms-faq-item">
                    <summary class="ms-faq-q">Can I print or save as PDF?</summary>
                    <div class="ms-faq-a">
                        Yes &mdash; the worksheet engine has a Print button that opens the
                        browser print dialog with optimised styling (no ads, no chrome,
                        crisp borders, repeating footer). From there, &ldquo;Save as PDF&rdquo;
                        captures everything including the answer key.
                    </div>
                </details>
                <details class="ms-faq-item">
                    <summary class="ms-faq-q">Why some worksheets show "low-variety" warning?</summary>
                    <div class="ms-faq-a">
                        It just means a couple of question types have a small fixed pool
                        (typically the scholar-tier curated word problems). The bulk of
                        each bank is fully parametric &mdash; you can refresh and get a
                        different set every time.
                    </div>
                </details>
            </div>
        </div>
    </section>

</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>

<!-- ── Worksheet engine (modal + render) ── -->
<script src="<%=request.getContextPath()%>/js/worksheet-engine.js?v=<%=v%>"></script>
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>

<script>
(function () {
    'use strict';

    var ctx = document.querySelector('meta[name="ctx"]').getAttribute('content') || '';
    var INDEX_URL = ctx + '/worksheet/math/worksheet-index.json';

    /* Read the inline JSON the server embedded.  Falling back to fetch keeps
       the page working if the inline element was stripped (e.g. by a CSP). */
    function readInlineIndex() {
        var el = document.getElementById('wsh-index-data');
        if (!el) return null;
        try { return JSON.parse(el.textContent); }
        catch (_) { return null; }
    }

    /* Pretty title from a category folder name or worksheet filename. */
    function prettyTitle(slug) {
        return slug.replace(/_/g, ' ')
                   .replace(/-/g, ' ')
                   .replace(/\.json$/, '')
                   .replace(/\b([a-z])/g, function (_, c) { return c.toUpperCase(); });
    }

    /* Pick an accent colour deterministically per category so each
       opens the WorksheetEngine in a slightly different palette. */
    var CAT_ACCENTS = {
        'algebra':        '#15803d',
        'calculus':       '#2563eb',
        'trigonometry':   '#a855f7',
        'linear-algebra': '#ea580c',
        'numerics':       '#0e7490',
        'statistics':     '#be185d'
    };
    function accentFor(catSlug) {
        return CAT_ACCENTS[catSlug] || '#15803d';
    }

    /* Format byte count to KB. */
    function fmtKb(bytes) {
        if (!bytes && bytes !== 0) return '—';
        return Math.round(bytes / 1024) + ' KB';
    }

    /* Render the difficulty bar from a {basic, medium, hard, scholar} object. */
    function renderDiffBar(diff) {
        var total = (diff.basic||0) + (diff.medium||0) + (diff.hard||0) + (diff.scholar||0);
        if (total === 0) total = 1;
        function pct(k) { return ((diff[k]||0) / total * 100).toFixed(1) + '%'; }
        return (
            '<div class="wsh-diff-bar">'
            + '<span class="d-basic"   style="width:' + pct('basic')   + '"></span>'
            + '<span class="d-medium"  style="width:' + pct('medium')  + '"></span>'
            + '<span class="d-hard"    style="width:' + pct('hard')    + '"></span>'
            + '<span class="d-scholar" style="width:' + pct('scholar') + '"></span>'
            + '</div>'
            + '<div class="wsh-diff-legend">'
            + '<span><i style="background:#22c55e"></i>basic ' + (diff.basic||0) + '</span>'
            + '<span><i style="background:#3b82f6"></i>medium ' + (diff.medium||0) + '</span>'
            + '<span><i style="background:#f59e0b"></i>hard ' + (diff.hard||0) + '</span>'
            + '<span><i style="background:#a855f7"></i>scholar ' + (diff.scholar||0) + '</span>'
            + '</div>'
        );
    }

    /* Render the full meta-panel content for a single worksheet. */
    function renderMeta(catSlug, sheet) {
        var meta = document.getElementById('wshMeta');
        var typeNames = sheet.types ? Object.keys(sheet.types) : [];
        var typeChips = typeNames
            .map(function (t) {
                return '<span title="' + (sheet.types[t] || 0)
                    + ' question' + ((sheet.types[t] || 0) === 1 ? '' : 's') + '">'
                    + prettyTitle(t) + '</span>';
            })
            .join('');
        var total = sheet.total || 0;
        var typeCount = sheet.type_count || typeNames.length;
        var avgPerType = typeCount ? Math.round(total / typeCount) : 0;
        meta.innerHTML = (
            '<div class="wsh-meta-cat">' + prettyTitle(catSlug) + ' &middot; '
                + sheet.file + '</div>'
            + '<h3 class="wsh-meta-title">' + (sheet.topic || prettyTitle(sheet.file)) + '</h3>'
            + (sheet.description
                ? '<p class="wsh-meta-desc">' + sheet.description + '</p>'
                : '')
            + '<div class="wsh-meta-stats">'
                + '<div class="wsh-meta-stat">'
                    + '<span class="wsh-meta-stat-label">Questions</span>'
                    + '<span class="wsh-meta-stat-value">'
                        + total.toLocaleString() + '</span>'
                + '</div>'
                + '<div class="wsh-meta-stat">'
                    + '<span class="wsh-meta-stat-label">Question types</span>'
                    + '<span class="wsh-meta-stat-value">' + typeCount + '</span>'
                + '</div>'
                + '<div class="wsh-meta-stat">'
                    + '<span class="wsh-meta-stat-label">File size</span>'
                    + '<span class="wsh-meta-stat-value">'
                        + fmtKb(sheet.size_bytes) + '</span>'
                + '</div>'
                + '<div class="wsh-meta-stat">'
                    + '<span class="wsh-meta-stat-label">Avg per type</span>'
                    + '<span class="wsh-meta-stat-value">' + avgPerType + '</span>'
                + '</div>'
            + '</div>'
            + '<span class="wsh-types-label">Difficulty mix</span>'
            + renderDiffBar(sheet.difficulty || {})
            + (typeChips
                ? '<span class="wsh-types-label">Question types</span>'
                  + '<div class="wsh-types"><div class="wsh-types-list">'
                  + typeChips + '</div></div>'
                : '')
            + '<button type="button" class="wsh-cta" id="wshOpen">'
                + 'Start ' + (sheet.topic || prettyTitle(sheet.file)).split('—')[0].trim()
                + ' worksheet &nbsp;&rarr;</button>'
        );
        document.getElementById('wshOpen').addEventListener('click', function () {
            openSheet(catSlug, sheet);
        });
    }

    /* Hand off to the worksheet engine. */
    function openSheet(catSlug, sheet) {
        if (!window.WorksheetEngine || typeof WorksheetEngine.open !== 'function') {
            alert('Worksheet engine failed to load. Please refresh the page.');
            return;
        }
        // Index records sheet.url as "/worksheet/math/<cat>/<file>.json"; prepend ctx.
        var jsonUrl = sheet.url
            ? ctx + sheet.url
            : ctx + '/worksheet/math/' + catSlug + '/' + sheet.file;
        WorksheetEngine.open({
            jsonUrl: jsonUrl,
            title: sheet.topic || prettyTitle(sheet.file),
            accentColor: accentFor(catSlug),
            branding: '8gwifi.org',
            defaultCount: 20
        });
    }

    /* Build a lookup map: "cat/file" → sheet object — used by click handlers
       and deep-link resolution.  Cheaper than re-traversing the index every
       click. */
    function buildSheetMap(index) {
        var map = {};
        var cats = (index && index.categories) || {};
        Object.keys(cats).forEach(function (catSlug) {
            var sheets = (cats[catSlug] && cats[catSlug].worksheets) || [];
            sheets.forEach(function (sheet) {
                map[catSlug + '/' + sheet.file] = {cat: catSlug, sheet: sheet};
            });
        });
        return map;
    }

    /* Single-selection: clear any previously selected leaf, then mark. */
    function selectLeaf(catSlug, sheet, leafEl) {
        var prior = document.querySelector('.wsh-leaf.selected');
        if (prior && prior !== leafEl) prior.classList.remove('selected');
        leafEl.classList.add('selected');
        renderMeta(catSlug, sheet);
    }

    /* Attach interaction handlers to the SSR'd tree.  No DOM rebuild — the
       server already emitted every category and worksheet; we just wire
       toggle + select behaviour. */
    function hydrateTree(sheetMap) {
        // Category headers — toggle expand/collapse.
        document.querySelectorAll('.wsh-cat-head').forEach(function (head) {
            var node = head.parentElement;
            head.addEventListener('click', function () {
                node.classList.toggle('open');
                head.setAttribute('aria-expanded',
                    node.classList.contains('open') ? 'true' : 'false');
            });
            head.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    head.click();
                }
            });
        });

        // Leaves — select + render meta panel + open via WorksheetEngine.
        document.querySelectorAll('.wsh-leaf').forEach(function (leaf) {
            var catSlug = leaf.getAttribute('data-cat-slug');
            var fileKey = catSlug + '/' + leaf.getAttribute('data-sheet-file');
            var entry = sheetMap[fileKey];
            if (!entry) return; // index drift; SSR has more than JSON saw
            leaf.addEventListener('click', function (e) {
                // Allow the URL hash to update so the selection is shareable;
                // suppress the default jump scroll.
                e.preventDefault();
                history.replaceState(null, '', leaf.getAttribute('href'));
                selectLeaf(entry.cat, entry.sheet, leaf);
            });
            leaf.addEventListener('keydown', function (e) {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    leaf.click();
                }
            });
        });
    }

    /* Resolve `#cat/file` deep-link to the matching SSR'd leaf and select it. */
    function applyDeepLink(sheetMap) {
        var hash = (location.hash || '').replace(/^#/, '');
        if (!hash) return;
        var leaf = document.querySelector(
            '.wsh-leaf[href="#' + CSS.escape(hash) + '"]');
        if (!leaf) return;
        var entry = sheetMap[
            leaf.getAttribute('data-cat-slug') + '/'
            + leaf.getAttribute('data-sheet-file')];
        if (!entry) return;
        leaf.closest('.wsh-cat').classList.add('open');
        var head = leaf.closest('.wsh-cat').querySelector('.wsh-cat-head');
        if (head) head.setAttribute('aria-expanded', 'true');
        selectLeaf(entry.cat, entry.sheet, leaf);
        leaf.scrollIntoView({behavior: 'smooth', block: 'center'});
    }

    /* ── Bootstrap ─────────────────────────────────────────────────
       Prefer the inline index (no round-trip).  Fall back to fetch only if
       the inline element is missing — e.g. when running outside the JSP. */
    function bootstrap(index) {
        if (!index) {
            document.getElementById('wshTree').insertAdjacentHTML('afterbegin',
                '<div class="wsh-error">Could not load the worksheet index.</div>');
            return;
        }
        var sheetMap = buildSheetMap(index);
        hydrateTree(sheetMap);
        applyDeepLink(sheetMap);
    }

    var inline = readInlineIndex();
    if (inline) {
        bootstrap(inline);
    } else {
        fetch(INDEX_URL, {cache: 'no-cache'})
            .then(function (r) {
                if (!r.ok) throw new Error('HTTP ' + r.status);
                return r.json();
            })
            .then(bootstrap)
            .catch(function (err) {
                console.error('worksheet index load failed:', err);
                bootstrap(null);
            });
    }
})();
</script>

</body>
</html>
