<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"
    import="java.io.*, java.nio.charset.StandardCharsets, java.nio.file.*, java.util.*, com.google.gson.*" %>
<%!
    private JsonArray loadShifts(javax.servlet.ServletContext sc) {
        String real = sc.getRealPath("/math/iit/data/meta.json");
        if (real == null) return null;
        Path p = Paths.get(real);
        if (!Files.exists(p)) return null;
        try {
            String body = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
            JsonObject root = new JsonParser().parse(body).getAsJsonObject();
            return root.getAsJsonObject("buckets")
                       .getAsJsonObject("jee-2025-paper")
                       .getAsJsonArray("shifts");
        } catch (Exception e) {
            return null;
        }
    }
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;");
    }
%>
<%
    String v = String.valueOf(System.currentTimeMillis());
    JsonArray shifts = loadShifts(application);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free IIT JEE Mains Practice &amp; Mock Tests — Real 2025 Papers with Solutions" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Free JEE Mains practice and timed mock tests. Real past papers from JEE Main 2025 (all 10 shifts), thousands of historical problems, smart answer-matching, step-by-step solutions, official +4/-1 scoring. No signup." />
        <jsp:param name="toolUrl" value="math/iit/" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="JEE Mains mock test, JEE Main 2025 mock test, JEE Main 2025 papers, JEE Mains 22 Jan 2025, JEE Mains 23 Jan 2025, JEE Mains 24 Jan 2025, JEE Mains 28 Jan 2025, JEE Mains 29 Jan 2025, JEE Mains shift 1, JEE Mains shift 2, JEE Mains question paper with solutions, JEE Mains practice problems, IIT JEE math practice, JEE preparation online, JEE Mains free mock, JEE Mains answer key, JEE Mains official scoring +4 -1, JEE PYQ, JEE Mains previous year questions, NEET math practice, JEE Advanced prep" />
        <jsp:param name="toolImage" value="jee-practice-og.png" />
        <jsp:param name="faq1q" value="What's on this page?" />
        <jsp:param name="faq1a" value="Two ways to practice for JEE Mains: a live timed mock for each shift of the real JEE Main 2025 paper (10 shifts) with official +4/-1 scoring, plus an untimed practice mode drawing from thousands of historical JEE Mains math problems with stepwise solutions." />
        <jsp:param name="faq2q" value="Which JEE Main 2025 shifts are covered?" />
        <jsp:param name="faq2a" value="All 10 shifts of the January 2025 session: 22 Jan Shift 1 &amp; 2, 23 Jan Shift 1 &amp; 2, 24 Jan Shift 1 &amp; 2, 28 Jan Shift 1 &amp; 2, 29 Jan Shift 1 &amp; 2. Each is a real 25-question paper served in original order." />
        <jsp:param name="faq3q" value="How is the scoring calculated?" />
        <jsp:param name="faq3a" value="Official JEE Main scoring: +4 for each correct answer, -1 for each wrong MCQ (no penalty on numerical-type), 0 for blank. Max score: 100." />
        <jsp:param name="faq4q" value="Can I take the same shift multiple times?" />
        <jsp:param name="faq4a" value="Yes — a 5-minute cooldown between attempts on the same shift nudges you to review your last attempt's solutions first. You can switch to a different shift immediately." />
        <jsp:param name="faq5q" value="Do you have NEET or JEE Advanced versions?" />
        <jsp:param name="faq5a" value="The historical practice pool includes a lot of NEET-overlapping math. JEE Advanced isn't a separate mock yet, but the techniques in the untimed practice cover the foundation." />
    </jsp:include>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/amc/css/exam.css">

    <%@ include file="../../modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="../../modern/components/nav-header.jsp" />
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="../../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">
    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
        &#9776; Math tools
    </button>

    <% request.setAttribute("activeService", "jee-hub"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">
        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">IIT JEE</span>
            </nav>
            <h1>Free IIT JEE Mains Practice &amp; Mock Tests &mdash; Real 2025 Papers</h1>
            <p class="xm-hero-sub">
                Two ways to prep: timed mocks of every shift of the real
                <strong>JEE Main 2025</strong> paper with official scoring,
                or untimed practice across thousands of historical problems
                with step-by-step solutions. No signup.
            </p>
            <div class="xm-hero-chips">
                <span class="xm-hero-chip">Real 2025 papers</span>
                <span class="xm-hero-chip">All 10 shifts</span>
                <span class="xm-hero-chip">Official +4 / −1 / 0 scoring</span>
                <span class="xm-hero-chip">Stepwise solutions</span>
            </div>
        </header>

        <%-- Two-mode picker --%>
        <div class="ms-card">
            <h2 class="ms-section-title">Pick a mode</h2>
            <div class="ms-tool-grid">
                <a href="<%=request.getContextPath()%>/math/iit/mock.jsp?shift=22-jan-shift-1" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#9201;</span>
                    <span><span class="ms-tool-card-title">JEE Mains 2025 Mock</span><span class="ms-tool-card-sub">Real paper · 3-hour timer · official scoring</span></span>
                </a>
                <a href="<%=request.getContextPath()%>/math/iit/practice.jsp" class="ms-tool-card">
                    <span class="ms-tool-card-icon">&#128214;</span>
                    <span><span class="ms-tool-card-title">JEE Practice (untimed)</span><span class="ms-tool-card-sub">Single problem · reveal stepwise solution</span></span>
                </a>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <%-- All 10 shifts as their own indexable cards --%>
        <% if (shifts != null) { %>
        <div class="ms-card">
            <h2 class="ms-section-title">JEE Main 2025 — all shifts</h2>
            <p style="color:var(--ms-muted); margin:0 0 0.85rem; font-size:0.9rem;">
                10 real papers from January 2025. Each is a timed 25-question
                mock with the official scoring rule.
            </p>
            <div class="xm-related-grid">
                <% for (JsonElement e : shifts) {
                       JsonObject obj = e.getAsJsonObject();
                       String slug = obj.get("slug").getAsString();
                       String name = obj.get("name").getAsString();
                       String pretty = name.replace("JEE Main 2025 ","").replace("(","").replace(")","");
                       int n = obj.get("n").getAsInt();
                %>
                <a class="xm-related-card"
                   href="<%=request.getContextPath()%>/math/iit/mock.jsp?shift=<%= slug %>">
                    <div class="xm-related-card-title"><%= esc(pretty) %></div>
                    <div class="xm-related-card-desc"><%= n %> questions · 3-hour timer · official +4 / −1</div>
                </a>
                <% } %>
            </div>
        </div>
        <% } %>

        <%-- SEO body --%>
        <section class="xm-seo-section" id="about">
            <h2>About JEE Mains practice on 8gwifi</h2>
            <p>
                <strong>JEE Mains</strong> is India's gateway to the IITs,
                NITs, IIITs, and most engineering institutions. Math accounts
                for 25 of the 75 questions on each paper and rewards <em>fast,
                accurate problem solving more than depth</em> — exactly what
                untimed worked-solution practice (followed by timed mocks)
                trains best.
            </p>
            <p>
                This hub gives you both: a deep pool of historical problems
                with stepwise walkthroughs for untimed learning, plus the
                actual <a href="<%=request.getContextPath()%>/math/iit/mock.jsp?shift=22-jan-shift-1"><strong>JEE Main 2025</strong></a> papers shift by shift for live mock practice
                with official <strong>+4 / −1</strong> scoring.
            </p>
        </section>

        <section class="xm-seo-section" id="how">
            <h2>How to prep with this</h2>
            <ol class="xm-info-list xm-info-list-ol">
                <li><strong>Warm up untimed.</strong> Use the <a href="<%=request.getContextPath()%>/math/iit/practice.jsp">practice page</a> to drill techniques. Read every walkthrough — the technique vocabulary is what makes you faster later.</li>
                <li><strong>Then mock a shift.</strong> Pick one of the 10 JEE Main 2025 shifts and run it live. 3-hour timer; submit when ready or let it expire.</li>
                <li><strong>Review the misses.</strong> Every question expands to its stepwise solution post-submit. Time spent here is the highest-leverage part of mock prep.</li>
                <li><strong>Wait 5 minutes, try another shift.</strong> Same exam mode, different paper. Comparing your performance across shifts is a strong signal of where the gaps are.</li>
                <li><strong>Print and review offline.</strong> The print button on the practice page outputs a clean PDF worksheet with the 8gwifi.org source line.</li>
            </ol>
        </section>

        <section class="xm-seo-section" id="related">
            <h2>Looking for more?</h2>
            <div class="xm-related-grid">
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/olympiad/">
                    <div class="xm-related-card-title">Olympiad Practice</div>
                    <div class="xm-related-card-desc">RMO · INMO · USAMO · IMO problems with stepwise solutions.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/amc/">
                    <div class="xm-related-card-title">AMC 10 / 12 Mock</div>
                    <div class="xm-related-card-desc">US contest emulator — 25 MCQ, 75 min, modern scoring.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/amc/aime.jsp">
                    <div class="xm-related-card-title">AIME Mock</div>
                    <div class="xm-related-card-desc">15 problems · 3 hr · integer 0–999.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/">
                    <div class="xm-related-card-title">All math tools</div>
                    <div class="xm-related-card-desc">48+ free calculators and solvers.</div>
                </a>
            </div>
        </section>

        <section class="xm-seo-section" id="faq">
            <h2>Frequently asked</h2>
            <details class="xm-faq-item" open>
                <summary>Which JEE Main 2025 shifts are covered?</summary>
                <p>All 10 shifts of the January 2025 session: 22 Jan Shift 1 &amp; 2, 23 Jan Shift 1 &amp; 2, 24 Jan Shift 1 &amp; 2, 28 Jan Shift 1 &amp; 2, 29 Jan Shift 1 &amp; 2. Each is a real 25-question paper served in original order.</p>
            </details>
            <details class="xm-faq-item">
                <summary>How is the scoring calculated?</summary>
                <p>Official JEE Main scoring: <strong>+4</strong> correct, <strong>−1</strong> wrong (MCQ negative marking), <strong>0</strong> blank. No penalty on numerical-type. Max score 100.</p>
            </details>
            <details class="xm-faq-item">
                <summary>Can I retake the same shift?</summary>
                <p>Yes — a 5-minute cooldown nudges you to review your last attempt's solutions first. You can switch to a different shift immediately.</p>
            </details>
            <details class="xm-faq-item">
                <summary>Is this useful for NEET or JEE Advanced?</summary>
                <p>The historical practice pool overlaps significantly with NEET math. For JEE Advanced, treat this as a foundation — the technique vocabulary transfers, but Advanced needs additional depth.</p>
            </details>
        </section>
    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="../../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="../../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../../modern/components/analytics.jsp" %>

</body>
</html>
