<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis());
   request.setAttribute("aiToolId", "math-ai");
   request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Prime Number Calculator &mdash; Check, Factorize, Nth Prime, Goldbach" />
        <jsp:param name="toolDescription" value="Is it prime? Check any number instantly (even huge ones). Factorize, find the Nth prime, nearest prime, twin primes, Goldbach partition, GCD. See prime gaps &amp; density charts. Math AI tutor + free, no signup, runs in your browser." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="prime-number.jsp" />
        <jsp:param name="toolKeywords" value="is it prime, prime number calculator, prime factorization calculator, nth prime calculator, prime number checker, list of prime numbers, prime number generator, gcd calculator, twin primes, goldbach conjecture, coprime calculator, nearest prime, prime factorization, sieve of eratosthenes, miller rabin, bigint prime, prime gaps, prime density, number theory calculator, factorize number online" />
        <jsp:param name="toolImage" value="math-studio-og.png" />
        <jsp:param name="toolFeatures" value="Primality check with Miller-Rabin (supports BigInt),Sieve of Eratosthenes up to 2 million,Segmented sieve for arbitrary ranges,Prime factorization with trial division,Nth prime finder (up to 1.3 million),Nearest prime above and below,Goldbach partition for even numbers,Coprimality and GCD calculator,Twin prime highlighting,Prime gap visualization chart,Prime density chart (PNT),Math AI tutor in chat,Dark mode support,No signup required" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter a number|Type any integer into the input field (supports very large numbers via BigInt),Check primality|Click Check to test if the number is prime using the deterministic Miller-Rabin algorithm,Factorize|Click Factorize to decompose the number into its prime factors,Generate primes|Enter a limit N to generate all primes up to N or specify a range A to B" />
        <jsp:param name="faq1q" value="How does the primality test work?" />
        <jsp:param name="faq1a" value="This tool uses the deterministic Miller-Rabin primality test with specific witness bases that are provably correct for all 64-bit integers. For numbers larger than 64 bits (BigInt), it uses a probabilistic Miller-Rabin test with high confidence." />
        <jsp:param name="faq2q" value="What is the Sieve of Eratosthenes?" />
        <jsp:param name="faq2a" value="The Sieve of Eratosthenes is an ancient algorithm for finding all primes up to a given limit. It works by iteratively marking the multiples of each prime starting from 2. For range queries (primes between A and B), this tool uses a segmented sieve variant." />
        <jsp:param name="faq3q" value="How large can the numbers be?" />
        <jsp:param name="faq3a" value="For primality checking and factorization, the tool supports arbitrarily large integers using JavaScript BigInt. For prime generation (sieve), the recommended limit is 2 million for best performance since the sieve runs entirely in your browser." />
        <jsp:param name="faq4q" value="How does factorization work?" />
        <jsp:param name="faq4a" value="The tool uses trial division with the 6k plus or minus 1 optimization. It divides by 2 and 3 first, then checks divisors of the form 6k-1 and 6k+1. This is efficient for numbers with small prime factors." />
    </jsp:include>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Instrument+Serif:ital@0;1&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&family=Instrument+Serif:ital@0;1&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/prime-number-calculator.css?v=<%=v%>">

    <%@ include file="modern/components/math-ai-head.inc.jsp" %>
    <%@ include file="modern/ads/ad-init.jsp" %>
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

    <% request.setAttribute("activeService", "prime-number"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Prime Numbers</span>
            </nav>
            <h1>Prime Number Checker &amp; Generator</h1>
            <p class="ms-subtitle">Miller-Rabin &middot; sieve &middot; factorization &middot; Goldbach &middot; twin primes &middot; BigInt</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact" id="pn-hero-card">
                <div class="ic-hero-top">
                    <div class="pn-hero-badges">
                        <span class="pn-badge">BigInt</span>
                        <span class="pn-badge">Miller-Rabin</span>
                        <span class="pn-badge">Sieve</span>
                        <span class="pn-badge">Goldbach</span>
                    </div>
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — number theory tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>

                <div class="pn-main-row">
                    <div>
                        <label class="pn-label" for="pn-check-input">Check / factorize</label>
                        <input type="text" class="pn-input" id="pn-check-input" placeholder="e.g. 104729 or 999999999999999989" autocomplete="off" spellcheck="false">
                    </div>
                    <div class="pn-btn-row">
                        <button type="button" class="pn-btn pn-btn-primary" id="pn-btn-check">Check</button>
                        <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-factor">Factorize</button>
                    </div>
                </div>
                <div class="pn-output" id="pn-check-output"></div>

                <div class="pn-tools-grid">
                    <div class="pn-tool-block">
                        <label class="pn-label" for="pn-limit-input">Primes &le; N</label>
                        <div class="pn-inline-row">
                            <input type="text" class="pn-input" id="pn-limit-input" placeholder="1000" autocomplete="off">
                            <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-upto">Go</button>
                        </div>
                    </div>
                    <div class="pn-tool-block">
                        <label class="pn-label">Range A &ndash; B</label>
                        <div class="pn-inline-row">
                            <input type="text" class="pn-input" id="pn-range-a" placeholder="A" autocomplete="off">
                            <span class="pn-range-sep">&ndash;</span>
                            <input type="text" class="pn-input" id="pn-range-b" placeholder="B" autocomplete="off">
                            <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-range">Go</button>
                        </div>
                    </div>
                    <div class="pn-tool-block">
                        <label class="pn-label" for="pn-nth-input">Nth prime</label>
                        <div class="pn-inline-row">
                            <input type="text" class="pn-input" id="pn-nth-input" placeholder="1000" autocomplete="off">
                            <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-nth">Find</button>
                        </div>
                        <div class="pn-output" id="pn-nth-output"></div>
                    </div>
                    <div class="pn-tool-block">
                        <label class="pn-label" for="pn-nearest-input">Nearest prime</label>
                        <div class="pn-inline-row">
                            <input type="text" class="pn-input" id="pn-nearest-input" placeholder="100" autocomplete="off">
                            <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-nearest">Find</button>
                        </div>
                        <div class="pn-output" id="pn-nearest-output"></div>
                    </div>
                    <div class="pn-tool-block">
                        <label class="pn-label" for="pn-goldbach-input">Goldbach (even N &gt; 2)</label>
                        <div class="pn-inline-row">
                            <input type="text" class="pn-input" id="pn-goldbach-input" placeholder="28" autocomplete="off">
                            <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-goldbach">Split</button>
                        </div>
                        <div class="pn-output" id="pn-goldbach-output"></div>
                    </div>
                    <div class="pn-tool-block">
                        <label class="pn-label">GCD / coprime</label>
                        <div class="pn-inline-row">
                            <input type="text" class="pn-input" id="pn-gcd-a" placeholder="A" autocomplete="off">
                            <span class="pn-range-sep">&amp;</span>
                            <input type="text" class="pn-input" id="pn-gcd-b" placeholder="B" autocomplete="off">
                            <button type="button" class="pn-btn pn-btn-secondary" id="pn-btn-gcd">GCD</button>
                        </div>
                        <div class="pn-output" id="pn-gcd-output"></div>
                    </div>
                </div>

                <details class="ic-hero-methods" style="margin-top:0.85rem;">
                    <summary class="ic-hero-methods-summary">
                        <span>Algorithms reference</span>
                        <svg class="ic-hero-methods-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>
                    </summary>
                    <div class="ic-hero-methods-body">
                        <ul class="pn-algo">
                            <li><strong>Primality:</strong> Deterministic <code>Miller-Rabin</code> for 64-bit; probabilistic for BigInt.</li>
                            <li><strong>Sieve:</strong> <code>Eratosthenes</code> up-to-N; segmented for ranges.</li>
                            <li><strong>Factorization:</strong> Trial division, <code>6k&plusmn;1</code> optimization.</li>
                            <li><strong>Nth prime:</strong> PNT bound <code>n(ln n + ln ln n)</code>.</li>
                            <li><strong>Goldbach:</strong> Sieve-based scan for even N.</li>
                            <li><strong>GCD:</strong> Euclidean algorithm (BigInt).</li>
                        </ul>
                    </div>
                </details>
            </div>

            <div class="ic-result-card">
                <div class="tool-card tool-result-card">
                    <div class="tool-result-header">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--pn-accent);">
                            <rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 3v18"/>
                        </svg>
                        <h4>Result</h4>
                    </div>
                    <div class="tool-result-content" style="padding:1rem;">
                        <div class="pn-hero" id="pn-hero">&mdash;</div>
                        <div id="pn-list-controls" class="pn-list-controls" style="display:none;">
                            <label>
                                <input type="checkbox" id="pn-twin-toggle"> Highlight twin primes
                            </label>
                        </div>
                        <div class="pn-chips" id="pn-primes-list" style="display:none;"></div>

                        <div class="pn-chart-card" id="pn-gap-card" style="display:none;">
                            <div class="pn-chart-head pn-chart-head--gap">Prime gaps</div>
                            <div class="pn-chart-body">
                                <canvas id="pn-gap-canvas" height="180" style="width:100%;border-radius:6px;"></canvas>
                                <p class="pn-chart-caption">Gap between consecutive primes (twin gaps = 2 highlighted)</p>
                            </div>
                        </div>

                        <div class="pn-chart-card" id="pn-density-card" style="display:none;">
                            <div class="pn-chart-head pn-chart-head--density">Prime density: &pi;(x)/x vs 1/ln(x)</div>
                            <div class="pn-chart-body">
                                <canvas id="pn-density-canvas" height="180" style="width:100%;border-radius:6px;"></canvas>
                                <p class="pn-chart-caption">Prime Number Theorem: &pi;(x)/x converges to 1/ln(x)</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <section class="ic-learn" aria-label="Prime number facts">
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Definition</span>
                    <code class="ic-learn-formula">p &gt; 1 with divisors 1 and p only</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">Fundamental theorem</span>
                    <code class="ic-learn-formula">Unique prime factorization</code>
                </article>
                <article class="ic-learn-card">
                    <span class="ic-learn-method">PNT (approx.)</span>
                    <code class="ic-learn-formula">&pi;(x) ~ x / ln(x)</code>
                </article>
            </section>

            <div class="ms-inline-ad">
                <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
            </div>

            <section class="ms-card" style="padding:1.5rem 1.75rem;">
                <h2 style="font:500 1.25rem var(--ms-font-serif);margin:0 0 0.75rem;">About this prime calculator</h2>
                <p style="font:0.95rem/1.65 var(--ms-font-sans);color:var(--ms-ink-soft);margin:0;">
                    Check if any integer is <strong>prime</strong> (Miller-Rabin with BigInt), <strong>generate</strong> primes via the Sieve of Eratosthenes,
                    <strong>factorize</strong> into prime factors, find the <strong>Nth prime</strong>, locate the <strong>nearest prime</strong>,
                    test <strong>Goldbach</strong> partitions, compute <strong>GCD</strong>, highlight <strong>twin primes</strong>, and visualize
                    <strong>gaps</strong> and <strong>density</strong>. Use <strong>Math AI</strong> for number-theory tutoring or to solve related
                    problems (∫, algebra, matrices) in chat with the same engines as other Math Studio tools.
                </p>
            </section>

            <section class="ms-card" style="padding:1.5rem 1.75rem;margin-top:1.25rem;">
                <h3 style="font:500 1.1rem var(--ms-font-serif);margin:0 0 1rem;">FAQ</h3>
                <div class="ms-faq">
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">How does the primality test work?</div>
                        <div class="ms-faq-a">Deterministic Miller-Rabin for 64-bit integers; probabilistic Miller-Rabin with strong witnesses for larger BigInt values.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">What is the Sieve of Eratosthenes?</div>
                        <div class="ms-faq-a">An algorithm that marks multiples of each prime starting from 2. Range queries use a segmented sieve for primes between A and B.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">How large can the numbers be?</div>
                        <div class="ms-faq-a">Primality and factorization support arbitrary BigInt. Sieve generation is capped at 2 million for browser performance.</div>
                    </div>
                    <div class="ms-faq-item">
                        <div class="ms-faq-q">How does factorization work?</div>
                        <div class="ms-faq-a">Trial division with 6k&plusmn;1 optimization after dividing out 2 and 3.</div>
                    </div>
                </div>
            </section>

        </div>
    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/categories-menu.js?v=<%=v%>" defer></script>
<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<script src="<%=request.getContextPath()%>/modern/js/prime-number-calculator.js?v=<%=v%>"></script>

<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configurePrimeMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>

<script>
(function(){
    document.querySelectorAll('.ms-faq-q').forEach(function(q){
        q.addEventListener('click', function(){ this.parentElement.classList.toggle('open'); });
    });
})();
</script>
</body>
</html>
