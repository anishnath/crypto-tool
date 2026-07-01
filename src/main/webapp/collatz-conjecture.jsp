<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis());
   request.setAttribute("aiToolId", "math-ai");
   request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <%--
        Collatz Conjecture Calculator — migrated to math-studio shell.

        No MathLive, no photo scan — pure visualisation tool with live animated
        sequence + plotly graph. Math AI tutor + full generic math router in chat.
        Legacy collatz-render.js / collatz-graph.js / collatz-export.js / collatz-core.js
        are reused unchanged; the JSP preserves every DOM ID the core looks up:
          · cc-start-number, cc-speed-slider, cc-speed-display
          · cc-start-btn, cc-stop-btn, cc-reset-btn
          · .cc-record-btn[data-number]
          · cc-status-area, cc-graph-area, cc-stats-area, cc-sequence-area
          · cc-share-btn

        The legacy CSS at /css/collatz-conjecture.css still ships — most of
        its rules target .cc-* classes which work in any shell.  The shell
        layout override (.cc-layout.tool-page-container) no longer applies
        because we now use the standard math-studio shell, which is fine.
    --%>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Collatz Conjecture Calculator - 3n+1 Sequence" />
        <jsp:param name="toolDescription" value="Free Collatz Conjecture calculator with live animated sequences and real-time graphs. Enter any number to explore the 3n+1 problem, track stopping times, peak values, and famous hailstone sequences." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="collatz-conjecture.jsp" />
        <jsp:param name="toolKeywords" value="collatz conjecture calculator, 3n+1 problem, hailstone sequence, collatz sequence generator, collatz visualizer, collatz graph, unsolved math problem, number theory, stopping time calculator, collatz peak value, collatz conjecture explorer, 3n+1 sequence, collatz animation, hailstone numbers, syracuse problem, collatz orbit" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Live animated sequence visualization with step-by-step display,Real-time interactive graph that draws as each number appears,Stopping time and peak value calculation,Quick-example buttons for famous Collatz numbers (27 63 97 871 6171),Configurable animation speed with slider control,Shareable URLs for any starting number,Math AI tutor + full math router in chat,Dark mode support,Automatic log-scale graph for large sequences,Color-coded numbers showing even odd peak and endpoint" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="educationalLevel" value="Middle School, High School, College" />
        <jsp:param name="teaches" value="Number theory, Collatz conjecture, iterative sequences, mathematical conjectures, computational exploration" />
        <jsp:param name="howToSteps" value="Enter a starting number|Type any positive integer between 1 and 100000 into the input field or click a quick-example button,Set animation speed|Use the slider to control how fast the sequence animates from 50ms to 1000ms per step,Click Start|Press the Start button or hit Enter to begin the live animated visualization,Watch the live graph and sequence|The graph draws in real-time as each number appears with color-coded even odd peak and endpoint values,Review the results|When the sequence reaches 1 the stats panel shows total steps peak value and sequence length,Share or explore more|Click Share to copy a link to your sequence or try other famous numbers like 27 871 or 6171" />
        <jsp:param name="faq1q" value="What is the Collatz Conjecture?" />
        <jsp:param name="faq1a" value="The Collatz Conjecture (also called the 3n+1 problem or hailstone sequence) states that for any positive integer, if you repeatedly apply the rule divide by 2 if even or multiply by 3 and add 1 if odd, you will always eventually reach 1. Despite being verified for all numbers up to 2^68 (about 295 quintillion), no general proof exists. It remains one of the most famous unsolved problems in mathematics, proposed by Lothar Collatz in 1937." />
        <jsp:param name="faq2q" value="Why is the number 27 famous in the Collatz Conjecture?" />
        <jsp:param name="faq2a" value="The number 27 is a classic example because its sequence is surprisingly long and dramatic. Despite being a small starting number, it takes 111 steps to reach 1 and climbs to a peak value of 9232 before descending. This illustrates the unpredictable nature of Collatz sequences, where small inputs can produce unexpectedly complex trajectories. Try it in the calculator above to see the full animated sequence." />
        <jsp:param name="faq3q" value="What is a stopping time in the Collatz Conjecture?" />
        <jsp:param name="faq3a" value="The stopping time (or total stopping time) is the number of steps it takes for a Collatz sequence to reach 1 from a given starting number. For example, starting from 6 the sequence 6, 3, 10, 5, 16, 8, 4, 2, 1 has a stopping time of 8 steps. Some numbers have very long stopping times relative to their size. The number 6171 takes 261 steps, making it one of the longest sequences under 10000." />
        <jsp:param name="faq4q" value="Has the Collatz Conjecture been proven?" />
        <jsp:param name="faq4a" value="No. As of 2025, the Collatz Conjecture remains unproven despite decades of effort. It has been verified computationally for all starting numbers up to approximately 2^68. In 2019, Fields Medalist Terence Tao proved that almost all Collatz orbits attain almost bounded values, which is the strongest partial result to date. Paul Erdos famously said mathematics is not yet ready for such problems." />
        <jsp:param name="faq5q" value="What are hailstone numbers?" />
        <jsp:param name="faq5a" value="Hailstone numbers refer to the values in a Collatz sequence because, like hailstones in a cloud, they go up and down unpredictably before eventually falling to the ground (reaching 1). The sequence rises when odd numbers are transformed via 3n+1 and falls when even numbers are halved. This turbulent behavior is what makes the conjecture so fascinating and difficult to prove." />
    </jsp:include>

    <!-- Article schema (E-E-A-T): same as legacy page, kept verbatim. -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": "https://8gwifi.org/collatz-conjecture.jsp"
      },
      "headline": "Collatz Conjecture Calculator - Explore the 3n+1 Problem",
      "description": "Interactive Collatz Conjecture calculator with live animated sequences, real-time graphs, and famous number examples. Explore one of mathematics' greatest unsolved mysteries.",
      "about": {
        "@type": "Thing",
        "name": "Collatz conjecture",
        "alternateName": ["3n+1 problem", "hailstone sequence", "Syracuse problem", "Ulam conjecture"],
        "description": "An unsolved conjecture in mathematics that concerns sequences defined by: if a number is even, divide by 2; if odd, multiply by 3 and add 1. The conjecture states every such sequence eventually reaches 1.",
        "sameAs": [
          "https://en.wikipedia.org/wiki/Collatz_conjecture",
          "https://mathworld.wolfram.com/CollatzProblem.html"
        ]
      },
      "author": {
        "@type": "Person",
        "name": "Anish Nath",
        "url": "https://8gwifi.org",
        "jobTitle": "Software Engineer",
        "sameAs": ["https://twitter.com/anish2good"]
      },
      "publisher": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org",
        "logo": {
          "@type": "ImageObject",
          "url": "https://8gwifi.org/images/site/logo.png"
        }
      },
      "datePublished": "2025-01-15",
      "dateModified": "2026-05-05",
      "inLanguage": "en-US",
      "keywords": "collatz conjecture, 3n+1 problem, hailstone sequence, number theory, unsolved math problems, stopping time, mathematical visualization"
    }
    </script>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/collatz-conjecture.css?v=<%=v%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>

    <style>
        .ic-hero .math-ai-tab-btn {
            display: inline-flex; align-items: center; gap: 0.35rem;
            padding: 0.35rem 0.75rem; border-radius: 999px; border: 1px solid rgba(234, 88, 12, 0.35);
            background: rgba(234, 88, 12, 0.08); color: var(--ms-text, #1e1b4b); font-size: 0.8125rem;
            font-weight: 600; cursor: pointer; transition: background 0.15s, transform 0.15s, box-shadow 0.15s;
            white-space: nowrap;
        }
        .ic-hero .math-ai-tab-btn:hover {
            background: rgba(234, 88, 12, 0.18); transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(234, 88, 12, 0.15);
        }
        .ic-hero .math-ai-tab-btn[aria-busy="true"] { opacity: 0.75; cursor: wait; }
        .cc-hero-top {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            margin-bottom: 0.65rem;
        }
    </style>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* ───── Collatz-specific tokens (palette + small overrides for the
                math-studio shell).  The legacy CSS at /css/collatz-conjecture.css
                covers the bulk; this block just retunes a few rules so the
                input controls fit the .ic-hero card. ───── */
        :root {
            --cc-tool: #ea580c;
            --cc-tool-dark: #c2410c;
            --cc-gradient: linear-gradient(135deg, #ea580c 0%, #f97316 100%);
            --cc-light: #fff7ed;
        }
        [data-theme="dark"] { --cc-light: rgba(234, 88, 12, 0.15); }

        /* Input row inside .ic-hero: number + speed + actions in a flex row
           that wraps on narrow viewports. */
        .cc-controls {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1.5fr);
            gap: 1rem 1.25rem;
            margin-bottom: 0.85rem;
        }
        @media (max-width: 720px) {
            .cc-controls { grid-template-columns: 1fr; }
        }

        .cc-field-label {
            display: block;
            font: 600 0.7rem var(--ms-font-sans);
            color: var(--ms-muted, #78716c);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.35rem;
        }
        .cc-number-input {
            width: 100%;
            padding: 0.55rem 0.75rem;
            font: 500 1rem var(--ms-font-mono);
            border: 1.5px solid var(--ms-line, rgba(0,0,0,0.12));
            border-radius: var(--ms-radius-sm, 8px);
            background: var(--ms-panel-bg, #fefdfb);
            color: var(--ms-ink, #1c1917);
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        .cc-number-input:focus {
            outline: none;
            border-color: var(--cc-tool);
            box-shadow: 0 0 0 3px rgba(234,88,12,0.15);
        }

        .cc-speed-row {
            display: flex; align-items: center; gap: 0.5rem;
        }
        .cc-speed-row input[type="range"] {
            flex: 1; min-width: 0;
            accent-color: var(--cc-tool);
        }
        .cc-speed-row .cc-speed-mini {
            font: 0.7rem var(--ms-font-mono);
            color: var(--ms-muted);
        }
        .cc-speed-display {
            font: 500 0.78rem var(--ms-font-mono);
            color: var(--cc-tool);
            min-width: 4rem; text-align: right;
        }

        /* Action button row — Start is primary CTA, Stop/Reset are secondary. */
        .cc-actions {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 0.5rem;
            margin-bottom: 0.85rem;
        }
        .cc-btn-primary {
            padding: 0.65rem 1rem;
            font: 600 0.875rem var(--ms-font-sans);
            border: none;
            border-radius: var(--ms-radius-sm, 8px);
            background: var(--cc-gradient);
            color: #fff;
            cursor: pointer;
            transition: transform 0.12s, box-shadow 0.12s;
            box-shadow: 0 2px 8px rgba(234, 88, 12, 0.22);
        }
        .cc-btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 14px rgba(234, 88, 12, 0.32); }
        .cc-btn-secondary {
            padding: 0.65rem 0.8rem;
            font: 500 0.85rem var(--ms-font-sans);
            background: var(--ms-panel-bg-soft, #faf8f4);
            color: var(--ms-ink-soft, #44403c);
            border: 1.5px solid var(--ms-line, rgba(0,0,0,0.12));
            border-radius: var(--ms-radius-sm, 8px);
            cursor: pointer;
            transition: border-color 0.12s, background 0.12s;
        }
        .cc-btn-secondary:hover {
            border-color: var(--cc-tool);
            color: var(--cc-tool);
        }

        /* Quick-example chip strip. */
        .cc-examples-strip {
            display: flex; flex-wrap: wrap; gap: 0.4rem;
        }
        .cc-record-btn {
            padding: 0.35rem 0.75rem;
            font: 500 0.78rem var(--ms-font-sans);
            background: var(--cc-light);
            color: var(--cc-tool);
            border: 1.5px solid transparent;
            border-radius: var(--ms-radius-pill, 999px);
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
        }
        .cc-record-btn:hover {
            border-color: var(--cc-tool);
            background: var(--ms-panel-bg);
        }

        /* The result card — graph at top, stats mid, animated sequence trail. */
        #cc-graph-area {
            min-height: 340px;
            margin: 0.5rem 0 1rem;
        }
        #cc-stats-area:empty,
        #cc-sequence-area:empty,
        #cc-graph-area:empty,
        #cc-status-area:empty { display: none; }

        /* Methods strip — show the rule + examples as small reference cards. */
        .ic-learn .ic-learn-formula { font-size: 0.95rem; }

        /* Dark-mode tweaks for the controls. */
        [data-theme="dark"] .cc-number-input {
            background: var(--ms-panel-bg);
        }
    </style>
</head>
<body class="ms-body">

    <%@ include file="modern/components/nav-header.jsp" %>

    <jsp:include page="/math/partials/matter-bg.jsp" />

    <div class="ms-hero">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>

    <main class="ms-main">

        <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open math tools menu">
            &#9776; Math tools
        </button>

        <% request.setAttribute("activeService", "collatz"); %>
        <jsp:include page="/math/partials/sidebar.jsp" />

        <section class="ms-workspace">

            <header class="ms-title">
                <nav class="ms-crumbs">
                    <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                    <span>/</span>
                    <a href="<%=request.getContextPath()%>/math/">Math</a>
                    <span>/</span>
                    <span aria-current="page">Collatz Conjecture</span>
                </nav>
                <h1>Collatz Conjecture Explorer &mdash; The 3n + 1 Problem</h1>
                <p class="ms-subtitle">Live hailstone animation &middot; stopping time &middot; peak value &middot; famous orbits</p>
            </header>

            <div class="ic-stack">

                <!-- ═══ INPUT HERO ═══ -->
                <div class="ic-hero" id="ic-hero">
                    <div class="cc-hero-top">
                        <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — Collatz tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                    </div>

                    <!-- Top row: starting number + animation speed -->
                    <div class="cc-controls">
                        <div>
                            <label class="cc-field-label" for="cc-start-number">Starting number</label>
                            <input type="number"
                                   class="cc-number-input"
                                   id="cc-start-number"
                                   min="1" max="100000" value="27"
                                   inputmode="numeric"
                                   placeholder="1 - 100,000">
                        </div>
                        <div>
                            <label class="cc-field-label" for="cc-speed-slider">Animation speed</label>
                            <div class="cc-speed-row">
                                <span class="cc-speed-mini">Fast</span>
                                <input type="range" id="cc-speed-slider"
                                       min="50" max="1000" value="300" step="50"
                                       aria-label="Animation speed in milliseconds">
                                <span class="cc-speed-mini">Slow</span>
                                <span class="cc-speed-display" id="cc-speed-display">300ms</span>
                            </div>
                        </div>
                    </div>

                    <!-- Action row -->
                    <div class="cc-actions">
                        <button type="button" class="cc-btn-primary" id="cc-start-btn">Start sequence</button>
                        <button type="button" class="cc-btn-secondary" id="cc-stop-btn">Stop</button>
                        <button type="button" class="cc-btn-secondary" id="cc-reset-btn">Reset</button>
                    </div>

                    <!-- Quick examples — famous Collatz starting numbers -->
                    <div>
                        <span class="cc-field-label">Famous starting numbers</span>
                        <div class="cc-examples-strip">
                            <button type="button" class="cc-record-btn" data-number="27">27 &middot; classic (111 steps)</button>
                            <button type="button" class="cc-record-btn" data-number="63">63 &middot; 108 steps</button>
                            <button type="button" class="cc-record-btn" data-number="97">97 &middot; long</button>
                            <button type="button" class="cc-record-btn" data-number="871">871 &middot; high peak (190,996)</button>
                            <button type="button" class="cc-record-btn" data-number="6171">6171 &middot; 261 steps</button>
                        </div>
                    </div>
                </div>

                <!-- ═══ RESULT CARD ═══ -->
                <div class="ic-result-card">
                    <div class="tool-card tool-result-card">
                        <div class="tool-result-header">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                 style="width:18px;height:18px;flex-shrink:0;color:var(--cc-tool);">
                                <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                            </svg>
                            <h4>Live sequence &amp; trajectory</h4>
                        </div>
                        <div class="tool-result-content" id="cc-result-content">

                            <!-- Status -->
                            <div id="cc-status-area"></div>

                            <!-- Live graph (top — draws in real-time as each number appears) -->
                            <div class="cc-graph-container" id="cc-graph-area"></div>

                            <!-- Live stats (updates every step) -->
                            <div id="cc-stats-area"></div>

                            <!-- Animated sequence numbers (scrollable trail below) -->
                            <div id="cc-sequence-area"></div>

                            <!-- Empty state — shown until JS runs the first sequence -->
                            <div class="tool-empty-state ic-empty-state" id="cc-empty-state">
                                <div class="ic-empty-illustration"
                                     style="font-size:2.5rem;opacity:0.55;color:var(--cc-tool);">
                                    3n+1
                                </div>
                                <h3>Type a number and hit Start</h3>
                                <p>Watch the hailstone sequence climb and crash to 1. Try
                                <strong>27</strong> for a 111-step ride to 9,232.</p>
                            </div>
                        </div>
                        <div class="tool-result-actions" id="cc-result-actions"
                             style="display:flex;gap:0.5rem;padding:1rem;border-top:1px solid var(--ms-line);flex-wrap:wrap;">
                            <button type="button" class="tool-action-btn" id="cc-share-btn">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none"
                                     stroke="currentColor" stroke-width="2"
                                     style="vertical-align:-2px;margin-right:0.3rem;">
                                    <circle cx="18" cy="5" r="3"/>
                                    <circle cx="6" cy="12" r="3"/>
                                    <circle cx="18" cy="19" r="3"/>
                                    <line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/>
                                    <line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/>
                                </svg>
                                Share this sequence
                            </button>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ═══ METHODS / RULE STRIP ═══ -->
            <section class="ic-learn" aria-label="The Collatz rule">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Even step</span>
                    <code class="ic-learn-formula">n &rarr; n / 2</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Odd step</span>
                    <code class="ic-learn-formula">n &rarr; 3n + 1</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Stop</span>
                    <code class="ic-learn-formula">when n = 1</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Verified to</span>
                    <code class="ic-learn-formula">2<sup>68</sup> &asymp; 2.95 &times; 10<sup>20</sup></code>
                </article>
            </section>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <!-- ═══ BELOW-FOLD: explainer + famous sequences + FAQ ═══ -->
            <section class="ms-card" style="padding:1.5rem 1.75rem;">
                <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 0.75rem;letter-spacing:-0.015em;">
                    What is the Collatz Conjecture?
                </h2>
                <p style="font:0.95rem/1.65 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0 0 1rem;">
                    The <strong>Collatz Conjecture</strong> &mdash; also called the
                    <strong>3n + 1 problem</strong>, hailstone sequence, or Syracuse
                    problem &mdash; is one of the most famous unsolved problems in
                    mathematics. Proposed by Lothar Collatz in 1937, it states that
                    for any positive integer, repeatedly applying a simple rule will
                    always eventually reach 1.
                </p>
                <div class="cc-rule-box" style="margin:1rem 0;padding:1rem 1.25rem;background:var(--cc-light);border-left:4px solid var(--cc-tool);border-radius:0.5rem;font:0.95rem/1.65 var(--ms-font-mono);color:var(--ms-ink);">
                    If <var>n</var> is even: <var>n</var> &rarr; <var>n</var> / 2<br>
                    If <var>n</var> is odd: <var>n</var> &rarr; 3<var>n</var> + 1<br>
                    Repeat until you reach 1.
                </div>
                <p style="font:0.95rem/1.65 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0;">
                    Despite its simple formulation, no one has been able to prove this
                    is true for all positive integers. It has been computationally
                    verified for all numbers up to 2<sup>68</sup> (approximately 295
                    quintillion), yet a general proof remains elusive.
                </p>
            </section>

            <section class="ms-card" style="padding:1.5rem 1.75rem;margin-top:1.25rem;">
                <h3 style="font:500 1.1rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                    Famous Collatz sequences
                </h3>
                <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:1rem;">
                    <div class="cc-famous-card" style="padding:0.85rem 1rem;background:var(--ms-panel-bg-soft);border:1px solid var(--ms-line);border-radius:0.65rem;">
                        <h4 style="font:600 0.95rem var(--ms-font-sans);margin:0 0 0.35rem;color:var(--cc-tool);">27 &mdash; the classic</h4>
                        <p style="font:0.85rem/1.55 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0;">111 steps, peaks at 9,232. A small number with a surprisingly long and dramatic trajectory.</p>
                    </div>
                    <div class="cc-famous-card" style="padding:0.85rem 1rem;background:var(--ms-panel-bg-soft);border:1px solid var(--ms-line);border-radius:0.65rem;">
                        <h4 style="font:600 0.95rem var(--ms-font-sans);margin:0 0 0.35rem;color:var(--cc-tool);">871 &mdash; high peak</h4>
                        <p style="font:0.85rem/1.55 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0;">178 steps, peaks at 190,996. Reaches extreme heights before descending to 1.</p>
                    </div>
                    <div class="cc-famous-card" style="padding:0.85rem 1rem;background:var(--ms-panel-bg-soft);border:1px solid var(--ms-line);border-radius:0.65rem;">
                        <h4 style="font:600 0.95rem var(--ms-font-sans);margin:0 0 0.35rem;color:var(--cc-tool);">6,171 &mdash; long journey</h4>
                        <p style="font:0.85rem/1.55 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0;">261 steps to reach 1. One of the longest sequences for numbers under 10,000.</p>
                    </div>
                    <div class="cc-famous-card" style="padding:0.85rem 1rem;background:var(--ms-panel-bg-soft);border:1px solid var(--ms-line);border-radius:0.65rem;">
                        <h4 style="font:600 0.95rem var(--ms-font-sans);margin:0 0 0.35rem;color:var(--cc-tool);">63 &mdash; deceptively long</h4>
                        <p style="font:0.85rem/1.55 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0;">108 steps from a two-digit number. Shows how small inputs produce long sequences.</p>
                    </div>
                </div>
            </section>

            <section class="ms-card" style="padding:1.5rem 1.75rem;margin-top:1.25rem;">
                <h3 style="font:500 1.1rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 0.85rem;letter-spacing:-0.015em;">
                    Why is it unsolved?
                </h3>
                <p style="font:0.95rem/1.65 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0 0 1rem;">
                    The Collatz Conjecture resists proof because the sequence behaviour appears chaotic and unpredictable. The interplay between multiplication (3n + 1) and division (n / 2) creates orbits that seem random, making it extremely difficult to establish any general pattern that would apply to all integers.
                </p>
                <p style="font:0.95rem/1.65 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0 0 1rem;">
                    In 2019, Fields Medalist <strong>Terence Tao</strong> proved that almost all Collatz orbits attain almost bounded values &mdash; the strongest partial result to date. A complete proof covering every positive integer remains out of reach.
                </p>
                <div style="margin:1rem 0 0;padding:0.85rem 1.1rem;background:var(--ms-panel-bg-soft);border-left:4px solid #6366f1;border-radius:0.5rem;font:italic 0.9rem/1.55 var(--ms-font-serif);color:var(--ms-ink-soft);">
                    "Mathematics is not yet ready for such problems." &mdash; Paul Erd&#337;s
                </div>
            </section>

            <!-- FAQ — math-studio standard accordion -->
            <section class="ms-card" style="padding:1.5rem 1.75rem;margin-top:1.25rem;">
                <h3 style="font:500 1.1rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                    Frequently asked questions
                </h3>
                <div class="ms-faq">
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">What is the Collatz Conjecture?</div>
                        <div class="ms-faq-a">The Collatz Conjecture (also called the 3n+1 problem or hailstone sequence) states that for any positive integer, if you repeatedly apply the rule divide by 2 if even or multiply by 3 and add 1 if odd, you will always eventually reach 1. Despite being verified for all numbers up to 2<sup>68</sup> (about 295 quintillion), no general proof exists. It remains one of the most famous unsolved problems in mathematics, proposed by Lothar Collatz in 1937.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">Why is the number 27 famous in the Collatz Conjecture?</div>
                        <div class="ms-faq-a">The number 27 is a classic example because its sequence is surprisingly long and dramatic. Despite being a small starting number, it takes 111 steps to reach 1 and climbs to a peak value of 9,232 before descending. This illustrates the unpredictable nature of Collatz sequences, where small inputs can produce unexpectedly complex trajectories. Try it in the calculator above to see the full animated sequence.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">What is a stopping time in the Collatz Conjecture?</div>
                        <div class="ms-faq-a">The stopping time (or total stopping time) is the number of steps it takes for a Collatz sequence to reach 1 from a given starting number. For example, starting from 6 the sequence 6, 3, 10, 5, 16, 8, 4, 2, 1 has a stopping time of 8 steps. Some numbers have very long stopping times relative to their size. The number 6,171 takes 261 steps, making it one of the longest sequences under 10,000.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">Has the Collatz Conjecture been proven?</div>
                        <div class="ms-faq-a">No. As of 2025, the Collatz Conjecture remains unproven despite decades of effort. It has been verified computationally for all starting numbers up to approximately 2<sup>68</sup>. In 2019, Fields Medalist Terence Tao proved that almost all Collatz orbits attain almost bounded values, which is the strongest partial result to date. Paul Erd&#337;s famously said mathematics is not yet ready for such problems.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">What are hailstone numbers?</div>
                        <div class="ms-faq-a">Hailstone numbers refer to the values in a Collatz sequence because, like hailstones in a cloud, they go up and down unpredictably before eventually falling to the ground (reaching 1). The sequence rises when odd numbers are transformed via 3n+1 and falls when even numbers are halved. This turbulent behaviour is what makes the conjecture so fascinating and difficult to prove.</div>
                    </div>
                </div>
            </section>

        </section>

        <aside class="ms-rail" aria-label="Advertisements">
            <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
            <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
        </aside>
    </main>

    <%@ include file="modern/ads/ad-sticky-footer.jsp" %>
    <%@ include file="modern/components/analytics.jsp" %>

    <!-- ─── Core scripts (legacy IIFEs unchanged — DOM IDs preserved) ─── -->
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/js/collatz-render.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/js/collatz-graph.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/js/collatz-export.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/js/collatz-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js?v=<%=v%>" defer></script>

    <%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
    <%
        request.setAttribute("mathAiButtonId", "btnMathAI");
        request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
        request.setAttribute("mathAiProfileExport", "configureCollatzMathShell");
    %>
    <%@ include file="modern/components/math-ai-boot.inc.jsp" %>

    <!-- FAQ accordion + empty-state hide on first run -->
    <script>
    (function(){
        // FAQ open/close (math-studio standard pattern)
        var qs = document.querySelectorAll('.ms-faq-q');
        for (var i = 0; i < qs.length; i++) {
            qs[i].addEventListener('click', function(){
                var item = this.parentElement;
                if (item) item.classList.toggle('open');
            });
        }

        // Hide the empty state once the legacy renderer writes anything into
        // the live areas.  We watch the four output containers; first write
        // hides the placeholder.
        var empty = document.getElementById('cc-empty-state');
        if (!empty) return;
        var watch = ['cc-status-area','cc-graph-area','cc-stats-area','cc-sequence-area']
            .map(function(id){ return document.getElementById(id); })
            .filter(Boolean);
        if (!watch.length) return;
        var hideOnce = function(){
            for (var j = 0; j < watch.length; j++) {
                if (watch[j].childNodes.length > 0) {
                    empty.style.display = 'none';
                    return true;
                }
            }
            return false;
        };
        if (hideOnce()) return;
        var mo = new MutationObserver(function(){
            if (hideOnce()) mo.disconnect();
        });
        for (var k = 0; k < watch.length; k++) {
            mo.observe(watch[k], {childList: true, subtree: true});
        }
    })();
    </script>

</body>
</html>
