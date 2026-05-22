<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"
    import="java.io.*, java.nio.charset.StandardCharsets, java.nio.file.*, java.util.*, com.google.gson.*" %>
<%!
    /* Resolves the requested shift slug against the bucket meta so the
       page can pre-render the right title / canonical / OG even before
       the JS engine loads. Falls back to the first shift if the slug is
       missing or unknown — so the page is always renderable. */
    private static class ShiftInfo {
        String slug;
        String name;        // "JEE Main 2025 (22 Jan Shift 1)"
        String qShard;
        String prettyDate;  // "22 Jan 2025"
        String prettyShift; // "Shift 1"
        int n;
    }

    private JsonArray loadShiftsArray(javax.servlet.ServletContext sc) {
        String real = sc.getRealPath("/math/iit/data/meta.json");
        if (real == null) return null;
        Path p = Paths.get(real);
        if (!Files.exists(p)) return null;
        try {
            String body = new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
            JsonObject root    = new JsonParser().parse(body).getAsJsonObject();
            JsonObject buckets = root.getAsJsonObject("buckets");
            JsonObject bk      = buckets.getAsJsonObject("jee-2025-paper");
            if (bk == null) return null;
            return bk.getAsJsonArray("shifts");
        } catch (Exception e) {
            return null;
        }
    }

    private ShiftInfo lookupShift(JsonArray shifts, String requestedSlug) {
        if (shifts == null || shifts.size() == 0) return null;
        JsonObject pick = null;
        for (JsonElement e : shifts) {
            JsonObject obj = e.getAsJsonObject();
            String slug = obj.get("slug").getAsString();
            if (slug.equals(requestedSlug)) { pick = obj; break; }
        }
        if (pick == null) pick = shifts.get(0).getAsJsonObject();   // fallback
        ShiftInfo si = new ShiftInfo();
        si.slug   = pick.get("slug").getAsString();
        si.name   = pick.get("name").getAsString();
        si.qShard = pick.get("q").getAsString();
        si.n      = pick.get("n").getAsInt();

        // Parse "JEE Main 2025 (22 Jan Shift 1)" → "22 Jan 2025" + "Shift 1"
        // for human-friendly title rendering.
        java.util.regex.Matcher m = java.util.regex.Pattern
            .compile("\\(([\\d]+ \\w+) Shift (\\d)\\)")
            .matcher(si.name);
        if (m.find()) {
            si.prettyDate  = m.group(1) + " 2025";
            si.prettyShift = "Shift " + m.group(2);
        } else {
            si.prettyDate  = si.name;
            si.prettyShift = "";
        }
        return si;
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
                .replace("\"","&quot;").replace("'","&#39;");
    }
%>
<%
    String v = String.valueOf(System.currentTimeMillis());
    String reqSlug = request.getParameter("shift");
    if (reqSlug == null || reqSlug.isEmpty()) reqSlug = "22-jan-shift-1";

    JsonArray shifts = loadShiftsArray(application);
    ShiftInfo si = lookupShift(shifts, reqSlug);

    String pageTitle, pageDesc, canonicalPath;
    if (si != null) {
        pageTitle = "JEE Main 2025 " + si.prettyDate + " " + si.prettyShift + " — Free Mock Test with Solutions";
        pageDesc  = "Free live timed mock of the JEE Main 2025 paper (" + si.prettyDate + ", " + si.prettyShift +
                    "). 25 questions, official +4 / -1 scoring, stepwise solutions on submit. No signup.";
        canonicalPath = "math/iit/mock.jsp?shift=" + si.slug;
    } else {
        pageTitle = "JEE Main 2025 Mock Tests — Free, Timed, with Solutions";
        pageDesc  = "Free live timed mocks of JEE Main 2025 papers — every shift, official scoring, step-by-step solutions.";
        canonicalPath = "math/iit/mock.jsp";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="<%= pageTitle %>" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="<%= pageDesc %>" />
        <jsp:param name="toolUrl" value="<%= canonicalPath %>" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="JEE Main 2025 mock test, JEE Main 2025 paper, JEE Mains 2025 question paper, JEE Mains 22 Jan 2025, JEE Mains 23 Jan 2025, JEE Mains 24 Jan 2025, JEE Mains 28 Jan 2025, JEE Mains 29 Jan 2025, JEE Mains shift 1 paper, JEE Mains shift 2 paper, JEE Mains answer key, JEE Mains math solution, JEE Mains live mock, JEE Main 2025 questions with answers, JEE Main 2025 official scoring, +4 -1 JEE scoring" />
        <jsp:param name="toolImage" value="jee-practice-og.png" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Start the mock|Click Start Test. The engine loads the real 25 questions from this shift in their original order.,Work through the paper|Each question is MCQ (pick A/B/C/D) or numerical (type integer). Use Flag to mark for review. Navigate with arrow keys or click any pill in the navigator.,Watch the clock|The timer counts down in real time. Submit any time or let it expire.,Review with solutions|Get a score using official JEE scoring (+4 correct / -1 wrong / 0 blank for MCQ). Every question expands to its stepwise walkthrough." />
        <jsp:param name="faq1q" value="What is this JEE Mains 2025 mock test?" />
        <jsp:param name="faq1a" value="A live timed emulator of one shift of the real JEE Main 2025 math paper. 25 questions (mix of MCQ and numerical), original question order, official +4 / -1 scoring." />
        <jsp:param name="faq2q" value="How is the score calculated?" />
        <jsp:param name="faq2a" value="JEE official scoring: +4 for each correct answer, -1 for each wrong answer (MCQ negative marking), 0 for blank. Numerical-type questions also use +4 correct / 0 wrong by convention. Max score: 100." />
        <jsp:param name="faq3q" value="Can I see the solutions?" />
        <jsp:param name="faq3a" value="After submit every question expands in the review section to show your answer, the correct answer, and (when available) a step-by-step walkthrough." />
        <jsp:param name="faq4q" value="Are these the actual past JEE Mains 2025 questions?" />
        <jsp:param name="faq4a" value="Yes — questions are sourced from the published JEE Main 2025 math papers, shift by shift, with answer keys verified." />
        <jsp:param name="faq5q" value="Why is there a 5-minute cooldown between mocks?" />
        <jsp:param name="faq5a" value="Score reports and solutions matter more than raw volume. The cooldown nudges you to review what you got wrong before retaking. Cooldown is per exam — try a different shift, or switch to the untimed practice page." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Quiz",
      "name": "<%= esc(pageTitle) %>",
      "url": "https://8gwifi.org/<%= canonicalPath %>",
      "about": "JEE Main 2025 mathematics — <%= si != null ? esc(si.prettyDate) + " " + si.prettyShift : "all shifts" %>",
      "educationalLevel": "12th Grade, Pre-University",
      "learningResourceType": "Quiz",
      "isAccessibleForFree": true
    }
    </script>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/amc/css/exam.css?v=<%=v%>">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

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

    <% request.setAttribute("activeService", "jee-mock"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">
        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/iit/">IIT JEE</a>
                <span>/</span>
                <span aria-current="page"><%= si != null ? esc(si.prettyDate) + " " + esc(si.prettyShift) : "Mock" %></span>
            </nav>
            <h1><%= esc(pageTitle) %></h1>
            <p class="xm-hero-sub">
                Live timed mock of the real JEE Main 2025 math paper.
                <strong>25 questions · 3 hours · official +4 / −1 scoring</strong>
                (no negative marking on numerical type). Stepwise solutions
                on submit. No signup, runs in your browser.
            </p>
            <div class="xm-hero-chips">
                <span class="xm-hero-chip">Real 2025 paper</span>
                <span class="xm-hero-chip">Official +4 / −1 / 0 scoring</span>
                <span class="xm-hero-chip">MCQ + numerical mix</span>
                <span class="xm-hero-chip">Solutions on submit</span>
            </div>
        </header>

        <div id="xm-root"></div>

        <div class="ms-inline-ad">
            <%@ include file="../../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <%-- Shift picker — every shift gets its own link for SEO and easy nav --%>
        <% if (shifts != null) { %>
        <section class="xm-seo-section" id="other-shifts">
            <h2>Try a different shift</h2>
            <p>Each shift is its own real 25-question paper:</p>
            <div class="xm-related-grid">
                <% for (JsonElement e : shifts) {
                       JsonObject obj = e.getAsJsonObject();
                       String slug = obj.get("slug").getAsString();
                       String name = obj.get("name").getAsString();
                       String pretty = name.replace("JEE Main 2025 ","").replace("(","").replace(")","");
                       boolean isActive = si != null && si.slug.equals(slug);
                %>
                <a class="xm-related-card<%= isActive ? " op-shift-active" : "" %>"
                   href="<%=request.getContextPath()%>/math/iit/mock.jsp?shift=<%= slug %>">
                    <div class="xm-related-card-title"><%= esc(pretty) %></div>
                    <div class="xm-related-card-desc"><%= isActive ? "Currently selected" : "25 questions · official scoring" %></div>
                </a>
                <% } %>
            </div>
        </section>
        <% } %>

        <section class="xm-seo-section" id="related">
            <h2>Looking for untimed JEE practice?</h2>
            <div class="xm-related-grid">
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/iit/practice.jsp">
                    <div class="xm-related-card-title">JEE Mains Practice (untimed)</div>
                    <div class="xm-related-card-desc">Single problem at a time · stepwise solutions · 4,500+ pool.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/iit/">
                    <div class="xm-related-card-title">IIT JEE hub</div>
                    <div class="xm-related-card-desc">All modes, all shifts, FAQs.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/olympiad/">
                    <div class="xm-related-card-title">Olympiad Practice</div>
                    <div class="xm-related-card-desc">RMO, INMO, USAMO problems for harder prep.</div>
                </a>
            </div>
        </section>
    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="../../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="../../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../../modern/components/analytics.jsp" %>

<jsp:include page="/math/partials/math-libs.jsp" />

<script src="<%=request.getContextPath()%>/math/amc/js/exam-engine.js?v=<%=v%>"></script>
<script>
    <% if (si != null) { %>
    ExamEngine.init({
        rootId:      'xm-root',
        dataBase:    '<%=request.getContextPath()%>/math/iit/data',
        bucket:      'jee-2025-paper',
        shiftSlug:   '<%= si.slug %>',
        shiftFilter: '<%= si.name.replace("'", "\\'") %>',
        questions:   <%= si.n %>,
        durationMin: 180,                 /* JEE Mains math paper: 3 hours */
        format:      'mcq',               /* default — mixed records have q.fmt per-record */
        title:       '<%= esc(pageTitle) %>',
        subtitle:    'Real JEE Main 2025 paper · <%= esc(si.prettyDate) %> · <%= esc(si.prettyShift) %>',
        scoring:     { correct: 4, wrong: -1, unanswered: 0, max: 100 },
        practiceUrl: '<%=request.getContextPath()%>/math/iit/practice.jsp'
    });
    <% } %>
</script>

</body>
</html>
