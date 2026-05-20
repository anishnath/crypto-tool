<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        AIME Live Mock-Test Emulator — 15 questions, 180 minutes, integer 0–999.
        Shares engine + CSS with the AMC page; differs only in config block at bottom.
    --%>
    <jsp:include page="../../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Free AIME Mock Test — Live 3-Hour Practice with Solutions" />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolDescription" value="Free AIME mock test: 15 real past problems, 3-hour timer, integer answers 0–999, full scoring + step-by-step solutions. Olympiad-prep practice in your browser." />
        <jsp:param name="toolUrl" value="math/amc/aime.jsp" />
        <jsp:param name="breadcrumbCategoryUrl" value="math/" />
        <jsp:param name="toolKeywords" value="AIME mock test, AIME practice, AIME simulator, free AIME test, AIME timed practice, AIME past problems, AIME solutions, AIME training, AIME 1 emulator, AIME 2 emulator, competition math" />
        <jsp:param name="toolImage" value="aime-emulator-og.png" />
        <jsp:param name="toolFeatures" value="15 randomly sampled past AIME problems per session,180-minute live countdown timer with warnings,Integer answer entry (0-999) with on-screen range hint,Flag-for-review and question navigator,Auto-submit on time expiry; manual submit any time,Score report (max 15) plus full per-question breakdown,Step-by-step solutions revealed in review mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="teaches" value="AIME problem patterns, time-pressured contest strategy, integer answer formats, advanced competition math" />
        <jsp:param name="educationalLevel" value="High School" />
        <jsp:param name="howToSteps" value="Start the mock|Click Start Test. The engine pulls 15 randomized real AIME problems from a 695-problem pool.,Solve and enter integers|Each AIME answer is an integer 0-999. Type it into the answer box; the navigator marks the question answered.,Manage the clock|180 minutes total. The timer turns amber at five minutes and red in the final minute.,Review|See your total score plus every question and the official solution after you submit." />
        <jsp:param name="faq1q" value="What is the AIME?" />
        <jsp:param name="faq1a" value="The AIME (American Invitational Mathematics Examination) is a 15-question, 3-hour free-response contest. Top scorers on the AMC 10/12 qualify. Each answer is an integer from 0 to 999. AIME is the second step on the US path toward USAMO, MOSP, and the International Math Olympiad (IMO)." />
        <jsp:param name="faq2q" value="How is the AIME mock score computed?" />
        <jsp:param name="faq2a" value="Each correct integer answer is worth 1 point; wrong or blank answers are 0. Max possible is 15. Unlike AMC, there is no penalty or bonus for blanks — guessing costs nothing." />
        <jsp:param name="faq3q" value="Where do the problems come from?" />
        <jsp:param name="faq3a" value="A pool of 695 past AIME problems with verified integer answers and solutions. Each session samples 15 at random. Take it again for a fresh set." />
        <jsp:param name="faq4q" value="What about AMC?" />
        <jsp:param name="faq4a" value="The AMC mock test is a separate page at /math/amc/. Format there: 25 MCQ problems in 75 minutes with the modern AMC scoring rule." />
    </jsp:include>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free AIME Live Mock Test",
      "url": "https://8gwifi.org/math/amc/aime.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any (browser)",
      "offers": { "@type": "Offer", "price": "0.00", "priceCurrency": "USD" },
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

    <% request.setAttribute("activeService", "aime"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">AIME Mock Test</span>
            </nav>
            <h1>Free AIME Mock Test &mdash; Live, 3 Hours, Solutions Included</h1>
            <p class="xm-hero-sub">
                A timed AIME emulator with real past problems and integer
                free-response answers. <strong>15 questions · 180 minutes · answers 0–999.</strong>
                Submit any time for a score out of 15 and full step-by-step
                solutions. Runs entirely in your browser, no signup.
            </p>
            <div class="xm-hero-chips">
                <span class="xm-hero-chip">Real past AIME problems</span>
                <span class="xm-hero-chip">Integer answers 0–999</span>
                <span class="xm-hero-chip">Olympiad-prep difficulty</span>
                <span class="xm-hero-chip">Full solutions</span>
            </div>
        </header>

        <div id="xm-root"></div>

        <div class="ms-inline-ad">
            <%@ include file="../../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <%-- ─────────────────────────── SEO body ─────────────────────────── --%>

        <nav class="xm-toc" aria-label="On this page">
            <span class="xm-toc-label">On this page:</span>
            <a href="#about-aime">About the AIME</a>
            <a href="#aime-scoring">Scoring</a>
            <a href="#qualifying">Qualifying for the AIME</a>
            <a href="#how-to-use">How to use this mock</a>
            <a href="#topics">Topics</a>
            <a href="#strategy">Strategy</a>
            <a href="#faq">FAQ</a>
        </nav>

        <section class="xm-seo-section" id="about-aime">
            <h2>About the AIME</h2>
            <p>
                The <strong>American Invitational Mathematics Examination</strong>
                (AIME) is the second stage on the US math olympiad path, run by the
                Mathematical Association of America (MAA). It's a
                <em>15-question, 3-hour, free-response contest</em>; every answer is
                an integer from <strong>0 to 999</strong>. No multiple choice, no
                partial credit — each correct integer is worth one point, max 15.
            </p>
            <p>
                AIME problems are substantially harder than
                <a href="<%=request.getContextPath()%>/math/amc/">AMC</a> problems.
                Where the AMC tests speed and pattern recognition, AIME tests
                depth: clean problem-solving, careful casework, and the kind of
                creative leaps that olympiad training is built around. Top AIME
                scorers advance to the USAMO and ultimately the IMO team.
            </p>
        </section>

        <section class="xm-seo-section" id="aime-scoring">
            <h2>How AIME scoring works</h2>
            <table class="xm-info-table">
                <thead>
                    <tr><th>Outcome</th><th>Points</th><th>Strategic implication</th></tr>
                </thead>
                <tbody>
                    <tr><td>Correct integer answer</td><td><strong>+1</strong></td><td>Pure accuracy game — every problem is worth exactly the same.</td></tr>
                    <tr><td>Wrong integer</td><td><strong>0</strong></td><td>No penalty. Always guess if you've narrowed the answer.</td></tr>
                    <tr><td>Blank</td><td><strong>0</strong></td><td>Same as wrong — there's no upside to leaving it empty.</td></tr>
                </tbody>
            </table>
            <p>
                Maximum score is <strong>15</strong>. Unlike the AMC, there is no
                bonus for unanswered questions, so guessing costs nothing. If you
                can narrow an answer to a reasonable integer range, write something.
            </p>
        </section>

        <section class="xm-seo-section" id="qualifying">
            <h2>Qualifying for the AIME (USAMO path)</h2>
            <p>
                You earn an AIME invitation by hitting the cutoff on either the
                AMC 10 (typically a 105–120 score) or AMC 12 (typically 85–100).
                AIME participation itself is the second step of the IMO selection
                process:
            </p>
            <ul class="xm-info-list">
                <li><strong>AMC 10/12</strong> → top ~5% qualifies for AIME</li>
                <li><strong>AIME</strong> → top scorers' AMC+AIME composite (USAMO Index) qualifies for the USAMO</li>
                <li><strong>USAMO</strong> → top ~6 advance to MOP and US IMO selection</li>
            </ul>
            <p>
                If you haven't qualified yet, build through the
                <a href="<%=request.getContextPath()%>/math/amc/"><strong>AMC mock test</strong></a>
                first — same emulator, MCQ format.
            </p>
        </section>

        <section class="xm-seo-section" id="how-to-use">
            <h2>How to use this AIME mock test emulator</h2>
            <ol class="xm-info-list xm-info-list-ol">
                <li><strong>Click <em>Start Test</em></strong> — the engine pulls a fresh random set of 15 problems from a deep pool of past AIME papers.</li>
                <li><strong>Pace for 12 minutes per problem.</strong> 3 hours total. The timer turns amber at 5:00 and red in the final minute. Use the early problems (1–5) for quick wins and bank time for the harder back half.</li>
                <li><strong>Type integer answers (0–999).</strong> The answer box accepts numeric input only. Hit Tab or click Next to move on; flag any problem to come back later.</li>
                <li><strong>Submit when ready</strong> or let the timer expire. You'll get a score out of 15 plus per-question breakdown and full solutions.</li>
                <li><strong>Review the misses carefully.</strong> AIME problems reward deep review — one technique often unlocks several future problems. Take another fresh test after the 5-minute cooldown.</li>
            </ol>
        </section>

        <section class="xm-seo-section" id="topics">
            <h2>Topics covered on the AIME</h2>
            <p>
                AIME problems span four major strands but go deeper than AMC. Build
                your toolkit with these free helpers:
            </p>
            <div class="xm-related-grid">
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/matrix-calculator.jsp">
                    <div class="xm-related-card-title">Algebra &amp; functions</div>
                    <div class="xm-related-card-desc">Vieta's, polynomial identities, functional equations. Matrix tools →</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/derivative-calculator.jsp">
                    <div class="xm-related-card-title">Calculus-adjacent</div>
                    <div class="xm-related-card-desc">Optimization, inequalities, series. Derivative + integral tools →</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/trigonometric-identity-calculator.jsp">
                    <div class="xm-related-card-title">Geometry &amp; trig</div>
                    <div class="xm-related-card-desc">Power of a point, mass-point, trig identities, coord-bashing.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/binomial-distribution-calculator.jsp">
                    <div class="xm-related-card-title">Number theory &amp; combinatorics</div>
                    <div class="xm-related-card-desc">Modular arithmetic, generating functions, bijection. Discrete tools →</div>
                </a>
            </div>
        </section>

        <section class="xm-seo-section" id="strategy">
            <h2>AIME strategy — earning your first AIME points</h2>
            <p>
                Even strong AMC scorers often blank on their first AIME — the format
                shock is real. A few patterns that move scores meaningfully:
            </p>
            <ul class="xm-info-list">
                <li><strong>Bank #1–5 with discipline.</strong> The first five problems are designed to be accessible. A clean 5/15 puts you in qualifying range for the JMO or higher contests.</li>
                <li><strong>Coordinate-bash geometry.</strong> AIME geometry is often unlocked faster with coords than with synthetic. Don't fight it.</li>
                <li><strong>Always write a guess.</strong> No penalty for wrong answers. If you've eliminated 80% of the 0–999 range, write the most likely integer.</li>
                <li><strong>Check parity and small cases.</strong> If your answer "should" be even and you got odd, you have an off-by-one. AIME tests this constantly.</li>
                <li><strong>Trust your training.</strong> AIME rewards recognizing problems you've seen before more than improvising from scratch.</li>
            </ul>
        </section>

        <section class="xm-seo-section" id="faq">
            <h2>Frequently asked questions</h2>
            <details class="xm-faq-item" open>
                <summary>What is the AIME?</summary>
                <p>The AIME (American Invitational Mathematics Examination) is the second stage on the US olympiad path. It's a 15-question, 3-hour free-response contest where each answer is an integer from 0 to 999. AIME participation requires qualifying through the AMC 10 or AMC 12.</p>
            </details>
            <details class="xm-faq-item">
                <summary>How is the AIME mock score computed?</summary>
                <p>Each correct integer answer is worth 1 point; wrong or blank answers are 0. Max possible is 15. Unlike AMC, there is no penalty or bonus for blanks — guessing costs nothing.</p>
            </details>
            <details class="xm-faq-item">
                <summary>Where do the problems come from?</summary>
                <p>Real past AIME problems with verified integer answers and full solutions. Each session samples a fresh random set; retake for a new set.</p>
            </details>
            <details class="xm-faq-item">
                <summary>What about AMC?</summary>
                <p>The <a href="<%=request.getContextPath()%>/math/amc/">AMC mock test</a> is a separate page with the same emulator. Format: 25 MCQ problems in 75 minutes with the modern AMC scoring rule (+6 correct / +1.5 blank / 0 wrong).</p>
            </details>
            <details class="xm-faq-item">
                <summary>Why is there a 5-minute cooldown between tests?</summary>
                <p>AIME problems reward deep review more than raw volume. The cooldown nudges you to actually study the misses before retaking. The cooldown is per-exam, so AMC and AIME don't gate each other.</p>
            </details>
        </section>

        <section class="xm-seo-section" id="more-tools">
            <h2>More free math tools</h2>
            <div class="xm-related-grid">
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/amc/">
                    <div class="xm-related-card-title">AMC mock test</div>
                    <div class="xm-related-card-desc">25 multiple-choice problems · 75-minute timer · modern AMC scoring.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/worksheet.jsp">
                    <div class="xm-related-card-title">Practice worksheets</div>
                    <div class="xm-related-card-desc">Printable worksheets across algebra, geometry, calculus and more.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/dashboard.jsp">
                    <div class="xm-related-card-title">Math editor</div>
                    <div class="xm-related-card-desc">Live LaTeX rendering with KaTeX — great for working solutions.</div>
                </a>
                <a class="xm-related-card" href="<%=request.getContextPath()%>/math/">
                    <div class="xm-related-card-title">All math tools</div>
                    <div class="xm-related-card-desc">Browse 48+ free calculators and solvers across math topics.</div>
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
    ExamEngine.init({
        rootId:      'xm-root',
        dataBase:    '<%=request.getContextPath()%>/math/amc/data',
        bucket:      'aime-real',
        questions:   15,
        durationMin: 180,
        format:      'free',
        freeRange:   [0, 999],
        title:       'AIME — Live Mock Test',
        subtitle:    '15 problems · 180 minutes · integer 0–999',
        scoring:     { correct: 1, wrong: 0, unanswered: 0, max: 15 }
    });
</script>

</body>
</html>
