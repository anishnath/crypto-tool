<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index, follow, max-image-preview:large, max-snippet:-1, max-video-preview:-1">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Collatz Conjecture Calculator - 3n+1 Sequence" />
        <jsp:param name="toolDescription" value="Free Collatz Conjecture calculator with live animated sequences and real-time graphs. Enter any number to explore the 3n+1 problem, track stopping times, peak values, and famous hailstone sequences." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="collatz-conjecture.jsp" />
        <jsp:param name="toolKeywords" value="collatz conjecture calculator, 3n+1 problem, hailstone sequence, collatz sequence generator, collatz visualizer, collatz graph, unsolved math problem, number theory, stopping time calculator, collatz peak value, collatz conjecture explorer, 3n+1 sequence, collatz animation, hailstone numbers, syracuse problem, collatz orbit" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Live animated sequence visualization with step-by-step display,Real-time interactive graph that draws as each number appears,Stopping time and peak value calculation,Quick-example buttons for famous Collatz numbers (27 63 97 871 6171),Configurable animation speed with slider control,Shareable URLs for any starting number,Dark mode support,Automatic log-scale graph for large sequences,Color-coded numbers showing even odd peak and endpoint" />
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

    <!-- Supplementary Schema: Mathematical concept entity (E-E-A-T) -->
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
      "dateModified": "2025-02-28",
      "inLanguage": "en-US",
      "keywords": "collatz conjecture, 3n+1 problem, hailstone sequence, number theory, unsolved math problems, stopping time, mathematical visualization"
    }
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.plot.ly">

    <!-- Critical inline CSS -->
    <style>
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
        html{scroll-behavior:smooth;-webkit-text-size-adjust:100%;-webkit-font-smoothing:antialiased}
        body{font-family:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;font-size:1rem;line-height:1.5;color:#0f172a;background:#fff}
        :root{
            --cc-tool:#ea580c;--cc-tool-dark:#c2410c;--cc-gradient:linear-gradient(135deg,#ea580c 0%,#f97316 100%);--cc-light:#fff7ed;
            --bg-primary:#fff;--bg-secondary:#f8fafc;--bg-tertiary:#f1f5f9;
            --text-primary:#0f172a;--text-secondary:#475569;--text-muted:#94a3b8;
            --border:#e2e8f0;--font-sans:'Inter',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;
            --font-mono:'JetBrains Mono','Fira Code',Consolas,monospace;
            --shadow-sm:0 1px 2px rgba(0,0,0,0.05);--shadow-lg:0 10px 15px -3px rgba(0,0,0,0.1);
            --radius-md:0.5rem;--radius-lg:0.75rem;
            --z-dropdown:1000;--z-fixed:1030;--z-modal:1050;
            --header-height-desktop:72px;--header-height-mobile:64px
        }
        [data-theme="dark"]{--cc-light:rgba(234,88,12,0.15);--bg-primary:#0f172a;--bg-secondary:#1e293b;--bg-tertiary:#334155;--text-primary:#f1f5f9;--text-secondary:#cbd5e1;--text-muted:#94a3b8;--border:#334155}
        [data-theme="dark"] body{background:var(--bg-primary);color:var(--text-primary)}
        .modern-nav{position:fixed;top:0;left:0;right:0;z-index:var(--z-fixed);background:var(--bg-primary);border-bottom:1px solid var(--border);height:var(--header-height-desktop)}
        .tool-page-header{background:var(--bg-primary);border-bottom:1px solid var(--border);padding:1.25rem 1.5rem;margin-top:72px}
        .tool-page-header-inner{max-width:1600px;margin:0 auto;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem}
        .tool-page-title{font-size:1.5rem;font-weight:700;color:var(--text-primary);margin:0}
        .tool-page-badges{display:flex;gap:0.5rem;flex-wrap:wrap}
        .tool-badge{display:inline-flex;align-items:center;padding:0.25rem 0.625rem;font-size:0.6875rem;font-weight:500;border-radius:9999px;background:var(--cc-light);color:var(--cc-tool)}
        .tool-description-section{border-bottom:1px solid var(--border);padding:1.25rem 1.5rem}
        .tool-description-inner{max-width:1600px;margin:0 auto}
        .tool-description-content p{margin:0;font-size:0.9375rem;line-height:1.6;color:var(--text-secondary)}
        .tool-page-container{display:grid;grid-template-columns:minmax(320px,400px) minmax(0,1fr) 300px;gap:1.5rem;max-width:1600px;margin:0 auto;padding:1.5rem;min-height:calc(100vh - 180px)}
        @media(max-width:1024px){.tool-page-container{grid-template-columns:minmax(300px,380px) minmax(0,1fr)}.tool-ads-column{display:none}}
        @media(max-width:900px){.tool-page-container{grid-template-columns:1fr;display:flex;flex-direction:column}.tool-input-column{order:1}.tool-output-column{order:2;min-height:350px}}
        .tool-input-column{position:sticky;top:90px;height:fit-content;max-height:calc(100vh - 110px);overflow-y:auto}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card{background:var(--bg-primary);border:1px solid var(--border);border-radius:0.75rem;overflow:hidden;box-shadow:0 1px 3px rgba(0,0,0,0.05)}
        .tool-card-header{background:var(--cc-gradient);color:#fff;padding:0.875rem 1rem;font-weight:600;font-size:0.9375rem}
        .tool-card-body{padding:1rem}
        .tool-form-label{display:block;font-weight:500;margin-bottom:0.375rem;color:var(--text-primary);font-size:0.8125rem}
        .tool-form-group{margin-bottom:0.875rem}
        .tool-form-input{width:100%;padding:0.5rem 0.75rem;font-family:var(--font-mono);font-size:0.8125rem;border:1.5px solid var(--border);border-radius:0.5rem;background:var(--bg-primary);color:var(--text-primary);transition:border-color 0.15s}
        .tool-form-input:focus{outline:none;border-color:var(--cc-tool);box-shadow:0 0 0 3px rgba(234,88,12,0.1)}
        .tool-action-btn{width:100%;padding:0.75rem;font-weight:600;font-size:0.875rem;border:none;border-radius:0.5rem;cursor:pointer;background:var(--cc-gradient)!important;color:#fff;transition:opacity .15s;font-family:var(--font-sans)}
        .tool-action-btn:hover{opacity:0.9}
        .tool-result-header{display:flex;align-items:center;gap:0.5rem;padding:1rem 1.25rem;background:var(--bg-secondary);border-bottom:1px solid var(--border);border-radius:0.75rem 0.75rem 0 0}
        .tool-result-header h4{margin:0;font-size:0.95rem;font-weight:600;color:var(--text-primary);flex:1}
        .tool-result-content{padding:1.25rem;min-height:300px;overflow-y:auto}
        .tool-empty-state{display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:3rem 1.5rem;color:var(--text-muted)}
        .tool-empty-state h3{font-size:1rem;font-weight:600;margin-bottom:0.5rem;color:var(--text-secondary)}
        .tool-empty-state p{font-size:0.875rem;max-width:280px}
        [data-theme="dark"] .tool-card{background:var(--bg-secondary);border-color:var(--border)}
        [data-theme="dark"] .tool-result-header{background:var(--bg-tertiary)}
    </style>

    <!-- Non-blocking CSS -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap"></noscript>
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/css/collatz-conjecture.css?v=<%=cacheVersion%>" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/css/collatz-conjecture.css?v=<%=cacheVersion%>">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Collatz Conjecture Explorer</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Collatz Conjecture
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">Animated</span>
            <span class="tool-badge">Interactive Graph</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--cc-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free interactive <strong>Collatz Conjecture calculator</strong> and <strong>3n+1 sequence explorer</strong>. Watch hailstone sequences animate step-by-step, track peak values and stopping times, and visualize trajectories with interactive graphs. One of the most famous <strong>unsolved problems in mathematics</strong>.</p>
        </div>
    </div>
</section>

<main class="tool-page-container cc-layout">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--cc-gradient);">Collatz Sequence</div>
            <div class="tool-card-body">

                <!-- Starting Number -->
                <div class="tool-form-group">
                    <label class="tool-form-label" for="cc-start-number">Starting Number</label>
                    <input type="number" class="tool-form-input" id="cc-start-number" min="1" max="100000" value="27" placeholder="Enter a number (1 - 100,000)">
                </div>

                <!-- Animation Speed -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Animation Speed</label>
                    <div class="cc-speed-group">
                        <span class="cc-speed-label">Fast</span>
                        <input type="range" class="cc-speed-slider" id="cc-speed-slider" min="50" max="1000" value="300" step="50">
                        <span class="cc-speed-label">Slow</span>
                        <span class="cc-speed-value" id="cc-speed-display">300ms</span>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="tool-form-group">
                    <div class="cc-action-row">
                        <button type="button" class="tool-action-btn" id="cc-start-btn">Start</button>
                        <button type="button" class="tool-action-btn cc-btn-stop" id="cc-stop-btn">Stop</button>
                        <button type="button" class="tool-action-btn cc-btn-reset" id="cc-reset-btn">Reset</button>
                    </div>
                </div>

                <!-- Quick Examples -->
                <div class="tool-form-group" style="margin-bottom:0;">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="cc-record-numbers">
                        <button type="button" class="cc-record-btn" data-number="27">27 (Classic)</button>
                        <button type="button" class="cc-record-btn" data-number="63">63 (108 steps)</button>
                        <button type="button" class="cc-record-btn" data-number="97">97 (Long)</button>
                        <button type="button" class="cc-record-btn" data-number="871">871 (High peak)</button>
                        <button type="button" class="cc-record-btn" data-number="6171">6171 (261 steps)</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <div class="tool-card">
            <div class="tool-result-header">
                <h4>Sequence Result</h4>
            </div>
            <div class="tool-result-content">
                <!-- Status -->
                <div id="cc-status-area"></div>

                <!-- Live graph (top — draws in real-time as each number appears) -->
                <div class="cc-graph-container" id="cc-graph-area"></div>

                <!-- Live stats (updates every step) -->
                <div id="cc-stats-area"></div>

                <!-- Animated sequence numbers (scrollable trail below) -->
                <div id="cc-sequence-area"></div>
            </div>
            <div class="cc-result-toolbar">
                <button type="button" class="cc-toolbar-btn" id="cc-share-btn">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>
                    Share
                </button>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- ==================== BELOW-FOLD EDUCATIONAL CONTENT ==================== -->

<!-- What is the Collatz Conjecture? -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="cc-anim">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h2 style="font-size:1.25rem;font-weight:700;margin:0 0 1rem;color:var(--text-primary);">What is the Collatz Conjecture?</h2>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            The <strong>Collatz Conjecture</strong> (also called the <strong>3n+1 problem</strong>, hailstone sequence, or Syracuse problem) is one of the most famous unsolved problems in mathematics. Proposed by Lothar Collatz in 1937, it states that for any positive integer, repeatedly applying a simple rule will always eventually reach 1.
        </p>
        <div class="cc-rule-box">
            If n is even: n &rarr; n / 2<br>
            If n is odd: n &rarr; 3n + 1<br>
            Repeat until you reach 1
        </div>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:1rem 0 0;">
            Despite its simple formulation, no one has been able to prove this is true for all positive integers. It has been computationally verified for all numbers up to 2<sup>68</sup> (approximately 295 quintillion), yet a general proof remains elusive.
        </p>
    </div>
</section>

<!-- Famous Collatz Sequences -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="cc-anim cc-anim-d1">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Famous Collatz Sequences</h3>
        <div class="cc-famous-grid">
            <div class="cc-famous-card">
                <h4>27 - The Classic</h4>
                <p>111 steps, peaks at 9,232. A small number with a surprisingly long and dramatic trajectory.</p>
            </div>
            <div class="cc-famous-card">
                <h4>871 - High Peak</h4>
                <p>178 steps, peaks at 190,996. Reaches extreme heights before descending to 1.</p>
            </div>
            <div class="cc-famous-card">
                <h4>6,171 - Long Journey</h4>
                <p>261 steps to reach 1. One of the longest sequences for numbers under 10,000.</p>
            </div>
            <div class="cc-famous-card">
                <h4>63 - Deceptively Long</h4>
                <p>108 steps from a two-digit number. Shows how small inputs produce long sequences.</p>
            </div>
        </div>
    </div>
</section>

<!-- Why Is It Unsolved? -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="cc-anim cc-anim-d2">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Why Is It Unsolved?</h3>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            The Collatz Conjecture resists proof because the sequence behavior appears chaotic and unpredictable. The interplay between multiplication (3n+1) and division (n/2) creates orbits that seem random, making it extremely difficult to establish any general pattern that would apply to all integers.
        </p>
        <p style="font-size:0.9375rem;line-height:1.7;color:var(--text-secondary);margin:0 0 1rem;">
            In 2019, Fields Medalist <strong>Terence Tao</strong> proved that almost all Collatz orbits attain almost bounded values, which is the strongest partial result to date. However, a complete proof covering every positive integer remains out of reach.
        </p>
        <div class="cc-rule-box" style="border-left-color:#6366f1;background:var(--bg-secondary);">
            "Mathematics is not yet ready for such problems." &mdash; Paul Erdos
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="cc-anim cc-anim-d3">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;color:var(--text-primary);">Frequently Asked Questions</h3>
        <div class="faq-container">
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is the Collatz Conjecture?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The Collatz Conjecture (also called the 3n+1 problem or hailstone sequence) states that for any positive integer, if you repeatedly apply the rule divide by 2 if even or multiply by 3 and add 1 if odd, you will always eventually reach 1. Despite being verified for all numbers up to 2^68 (about 295 quintillion), no general proof exists. It remains one of the most famous unsolved problems in mathematics, proposed by Lothar Collatz in 1937.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Why is the number 27 famous in the Collatz Conjecture?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The number 27 is a classic example because its sequence is surprisingly long and dramatic. Despite being a small starting number, it takes 111 steps to reach 1 and climbs to a peak value of 9,232 before descending. This illustrates the unpredictable nature of Collatz sequences, where small inputs can produce unexpectedly complex trajectories. Try it in the calculator above to see the full animated sequence.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What is a stopping time in the Collatz Conjecture?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">The stopping time (or total stopping time) is the number of steps it takes for a Collatz sequence to reach 1 from a given starting number. For example, starting from 6 the sequence 6, 3, 10, 5, 16, 8, 4, 2, 1 has a stopping time of 8 steps. Some numbers have very long stopping times relative to their size. The number 6,171 takes 261 steps, making it one of the longest sequences under 10,000.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    Has the Collatz Conjecture been proven?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">No. As of 2025, the Collatz Conjecture remains unproven despite decades of effort. It has been verified computationally for all starting numbers up to approximately 2^68. In 2019, Fields Medalist Terence Tao proved that almost all Collatz orbits attain almost bounded values, which is the strongest partial result to date. Paul Erdos famously said mathematics is not yet ready for such problems.</div>
            </div>
            <div class="faq-item">
                <button class="faq-question" onclick="toggleFaq(this)">
                    What are hailstone numbers?
                    <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
                </button>
                <div class="faq-answer">Hailstone numbers refer to the values in a Collatz sequence because, like hailstones in a cloud, they go up and down unpredictably before eventually falling to the ground (reaching 1). The sequence rises when odd numbers are transformed via 3n+1 and falls when even numbers are halved. This turbulent behavior is what makes the conjecture so fascinating and difficult to prove.</div>
            </div>
        </div>
    </div>
</section>

<!-- Explore More Math Tools -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;" class="cc-anim cc-anim-d4">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Math Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/series-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#2563eb,#60a5fa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.2rem;color:#fff;font-weight:700;">&Sigma;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Series Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Taylor and Maclaurin series with step-by-step solutions</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">x&sup2;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quadratic Solver</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve quadratic equations with 3 methods and graphs</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/exponent-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#059669,#34d399);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">x<sup>n</sup></div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Exponent Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Power and exponent calculations with step-by-step</p>
                </div>
            </a>
        </div>
    </div>
</section>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2025 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
            <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="footer-link">Twitter</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=cacheVersion%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=cacheVersion%>" defer></script>

<!-- Scroll-triggered animations -->
<script>
(function(){
    var els = document.querySelectorAll('.cc-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('cc-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('cc-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

<!-- Core Scripts -->
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/collatz-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/collatz-graph.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/collatz-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/collatz-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
