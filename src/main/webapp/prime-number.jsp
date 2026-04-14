<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String cacheVersion = String.valueOf(System.currentTimeMillis());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="author" content="Anish Nath">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Prime Number Checker &amp; Generator &mdash; Primality, Sieve, Factorize | Free" />
        <jsp:param name="toolDescription" value="Free prime number calculator. Check if any integer is prime (BigInt Miller-Rabin), generate primes up to N or within a range using the Sieve of Eratosthenes, and factorize numbers into prime factors. All computation runs in your browser. No signup." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="prime-number.jsp" />
        <jsp:param name="toolKeywords" value="prime number checker, is it prime, prime number calculator, sieve of eratosthenes, prime generator, prime factorization, miller rabin, bigint prime, prime numbers list, number theory tools, nth prime, nearest prime, goldbach conjecture, twin primes, prime gaps, coprime calculator, gcd calculator, prime density" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Primality check with Miller-Rabin (supports BigInt),Sieve of Eratosthenes up to 2 million,Segmented sieve for arbitrary ranges,Prime factorization with trial division,Nth prime finder (up to 1.3 million),Nearest prime above and below,Goldbach partition for even numbers,Coprimality and GCD calculator,Twin prime highlighting,Prime gap visualization chart,Prime density chart (PNT),Dark mode support,No signup required" />
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

    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" media="print" onload="this.media='all'">
    <noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css">

    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/ads.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/dark-mode.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/footer.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <link rel="preload" href="<%=request.getContextPath()%>/modern/css/search.css" as="style" onload="this.onload=null;this.rel='stylesheet'">
    <noscript>
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css">
        <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css">
    </noscript>

    <%@ include file="modern/ads/ad-init.jsp" %>

    <style>
        /* Prime Number Tool — emerald accent */
        :root {
            --pn-accent: #10b981;
            --pn-accent-dark: #059669;
            --pn-gradient: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --pn-light: #ecfdf5;
            --pn-red: #ef4444;
            --pn-radius: 12px;
            --pn-radius-sm: 8px;
            --pn-transition: 200ms cubic-bezier(0.16, 1, 0.3, 1);
            --tool-primary: #10b981;
            --tool-primary-dark: #059669;
            --tool-gradient: var(--pn-gradient);
            --tool-light: #ecfdf5;
        }
        [data-theme="dark"] {
            --pn-light: rgba(16, 185, 129, 0.1);
            --tool-light: rgba(16, 185, 129, 0.1);
        }

        /* Two-column override: input left, output right */
        .pn-page.tool-page-container {
            grid-template-columns: minmax(280px, 380px) 1fr;
            gap: 1.25rem;
            max-width: 1400px;
        }
        @media (max-width: 900px) {
            .pn-page.tool-page-container {
                grid-template-columns: 1fr;
                display: flex;
                flex-direction: column;
            }
            .pn-page .tool-input-column { max-height: none; overflow-y: visible; position: relative; top: auto; }
        }

        /* Hero result display */
        .pn-hero {
            padding: 1rem 1.25rem;
            border-radius: var(--pn-radius);
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.5rem;
            font-weight: 700;
            color: #6b7280;
            text-align: center;
            letter-spacing: 0.02em;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 1rem;
            transition: color var(--pn-transition), text-shadow var(--pn-transition);
            min-height: 3.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .pn-hero.prime {
            color: #22c55e;
            text-shadow: 0 2px 16px rgba(34, 197, 94, 0.4);
        }
        .pn-hero.composite {
            color: #f87171;
            text-shadow: 0 2px 16px rgba(248, 113, 113, 0.3);
        }
        .pn-hero.info {
            color: #60a5fa;
            text-shadow: 0 2px 12px rgba(96, 165, 250, 0.3);
            font-size: 1.125rem;
        }

        /* Input fields */
        .pn-input {
            width: 100%;
            padding: 0.4rem 0.625rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8125rem;
            border: 1.5px solid var(--border, #e2e8f0);
            border-radius: var(--pn-radius-sm);
            background: var(--bg-primary, #fff);
            color: var(--text-primary, #0f172a);
            transition: border-color var(--pn-transition), box-shadow var(--pn-transition);
        }
        .pn-input:focus {
            outline: none;
            border-color: var(--pn-accent);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.12);
        }
        .pn-input::placeholder { color: var(--text-muted, #94a3b8); font-weight: 400; }
        [data-theme="dark"] .pn-input {
            background: #0f172a;
            border-color: rgba(16, 185, 129, 0.2);
            color: #f1f5f9;
        }
        [data-theme="dark"] .pn-input:focus {
            border-color: #34d399;
            box-shadow: 0 0 0 3px rgba(52, 211, 153, 0.15);
        }

        /* Buttons */
        .pn-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.25rem;
            padding: 0.375rem 0.75rem;
            font-size: 0.75rem;
            font-weight: 600;
            border: none;
            border-radius: var(--pn-radius-sm);
            cursor: pointer;
            transition: all var(--pn-transition);
            white-space: nowrap;
        }
        .pn-btn svg { width: 15px; height: 15px; flex-shrink: 0; }
        .pn-btn-primary {
            background: var(--pn-gradient);
            color: #fff;
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.25);
        }
        .pn-btn-primary:hover {
            box-shadow: 0 4px 16px rgba(16, 185, 129, 0.35);
            transform: translateY(-1px);
        }
        .pn-btn-primary:active { transform: translateY(0) scale(0.97); }
        .pn-btn-secondary {
            background: var(--bg-secondary, #f8fafc);
            color: var(--text-primary, #0f172a);
            border: 1px solid var(--border, #e2e8f0);
        }
        .pn-btn-secondary:hover {
            background: var(--pn-light);
            border-color: var(--pn-accent);
            color: var(--pn-accent-dark);
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(16, 185, 129, 0.12);
        }
        .pn-btn-secondary:active { transform: translateY(0) scale(0.97); }
        [data-theme="dark"] .pn-btn-secondary {
            background: rgba(255,255,255,0.04);
            border-color: rgba(255,255,255,0.08);
            color: #e2e8f0;
        }
        [data-theme="dark"] .pn-btn-secondary:hover {
            background: rgba(16, 185, 129, 0.12);
            border-color: rgba(52, 211, 153, 0.4);
            color: #34d399;
        }
        .pn-btn-row {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-top: 0.5rem;
        }
        .pn-btn-row .pn-btn { flex: 1; min-width: 0; }

        /* Output text */
        .pn-output {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8125rem;
            color: var(--text-secondary, #64748b);
            margin-top: 0.5rem;
            line-height: 1.5;
            min-height: 1.25rem;
        }

        /* Primes chip grid */
        .pn-chips {
            display: flex;
            flex-wrap: wrap;
            gap: 0.375rem;
            margin-top: 0.75rem;
            max-height: 400px;
            overflow-y: auto;
            padding: 0.25rem 0;
        }
        .pn-chip {
            display: inline-block;
            padding: 0.2rem 0.5rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.75rem;
            font-weight: 600;
            background: var(--pn-light);
            color: var(--pn-accent-dark);
            border: 1px solid rgba(16, 185, 129, 0.2);
            border-radius: 2rem;
            transition: all var(--pn-transition);
            cursor: default;
        }
        .pn-chip:hover {
            background: rgba(16, 185, 129, 0.15);
            border-color: rgba(16, 185, 129, 0.4);
            transform: translateY(-1px);
        }
        [data-theme="dark"] .pn-chip {
            background: rgba(16, 185, 129, 0.08);
            color: #34d399;
            border-color: rgba(52, 211, 153, 0.2);
        }
        .pn-overflow { font-size: 0.75rem; color: var(--text-muted, #94a3b8); padding: 0.25rem 0; }
        .pn-chip.twin {
            background: rgba(245, 158, 11, 0.15);
            color: #b45309;
            border-color: rgba(245, 158, 11, 0.35);
        }
        [data-theme="dark"] .pn-chip.twin {
            background: rgba(245, 158, 11, 0.12);
            color: #fbbf24;
            border-color: rgba(251, 191, 36, 0.3);
        }
        .pn-chip.twin-dim { opacity: 0.3; }

        /* Form group spacing */
        .pn-group { margin-bottom: 0.875rem; }
        .pn-group:last-child { margin-bottom: 0; }
        .pn-label {
            display: block;
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-primary, #0f172a);
            margin-bottom: 0.25rem;
        }
        .pn-hint {
            font-size: 0.6875rem;
            color: var(--text-muted, #94a3b8);
            margin-top: 0.25rem;
            line-height: 1.3;
        }
        .pn-range-row {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 0.5rem;
            align-items: center;
        }
        .pn-range-sep {
            font-size: 0.875rem;
            color: var(--text-muted, #94a3b8);
            font-weight: 500;
        }

        /* Algorithm section */
        .pn-algo {
            font-size: 0.8125rem;
            color: var(--text-secondary, #64748b);
            line-height: 1.6;
        }
        .pn-algo li { margin-bottom: 0.375rem; }
        .pn-algo code {
            background: rgba(16, 185, 129, 0.08);
            padding: 1px 5px;
            border-radius: 3px;
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.8em;
            color: var(--pn-accent-dark);
        }
        [data-theme="dark"] .pn-algo code {
            background: rgba(52, 211, 153, 0.1);
            color: #34d399;
        }

        /* Focus visible for a11y */
        .pn-btn:focus-visible, .pn-input:focus-visible {
            outline: 2px solid var(--pn-accent);
            outline-offset: 2px;
        }
        @media (prefers-reduced-motion: reduce) {
            * { transition-duration: 0.01ms !important; animation-duration: 0.01ms !important; }
        }
    </style>
</head>
<body>

<%@ include file="modern/components/nav-header.jsp" %>

<!-- Page Header -->
<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Prime Number Checker &amp; Generator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math-menu-nav.jsp">Math Tools</a> /
                Prime Number Checker
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">BigInt Support</span>
            <span class="tool-badge">Miller-Rabin</span>
            <span class="tool-badge">Sieve of Eratosthenes</span>
            <span class="tool-badge">Goldbach</span>
            <span class="tool-badge">Twin Primes</span>
            <span class="tool-badge">Free</span>
        </div>
    </div>
</header>

<!-- Description + Ad -->
<section class="tool-description-section" style="background: var(--pn-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p style="margin:0;">Check if any number is <strong>prime</strong> (BigInt Miller-Rabin), <strong>generate primes</strong> via Sieve of Eratosthenes, <strong>factorize</strong> into prime factors, find the <strong>Nth prime</strong>, locate the <strong>nearest prime</strong>, test <strong>Goldbach&rsquo;s conjecture</strong>, check <strong>coprimality</strong>, highlight <strong>twin primes</strong>, and visualize <strong>prime gaps</strong> and <strong>density</strong>. All runs in your browser.</p>
        </div>
    </div>
    <div style="max-width:1400px;margin:0.375rem auto 0;padding:0 0.5rem;">
        <%@ include file="modern/ads/ad-hero-banner.jsp" %>
    </div>
</section>

<!-- Main Layout -->
<main class="tool-page-container pn-page">

    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background: var(--pn-gradient);">Prime Number Tools</div>
            <div class="tool-card-body" style="padding:0.75rem;">

                <!-- Check / Factorize -->
                <label class="pn-label" for="pn-check-input">Check / Factorize</label>
                <input type="text" class="pn-input" id="pn-check-input" placeholder="e.g. 104729 or 999999999999999989" autocomplete="off" spellcheck="false" style="margin-bottom:0.375rem;">
                <div class="pn-btn-row" style="margin-top:0;">
                    <button class="pn-btn pn-btn-primary" id="pn-btn-check">Check</button>
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-factor">Factorize</button>
                </div>
                <div class="pn-output" id="pn-check-output"></div>

                <hr style="border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.625rem 0;">

                <!-- Generate up to N -->
                <label class="pn-label" for="pn-limit-input">Generate primes &le; N</label>
                <div style="display:flex;gap:0.375rem;">
                    <input type="text" class="pn-input" id="pn-limit-input" placeholder="e.g. 1000" autocomplete="off" style="flex:1;">
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-upto">Go</button>
                </div>

                <!-- Range A-B -->
                <label class="pn-label" style="margin-top:0.5rem;">Range A &ndash; B</label>
                <div style="display:flex;gap:0.375rem;align-items:center;">
                    <input type="text" class="pn-input" id="pn-range-a" placeholder="A" autocomplete="off" style="flex:1;">
                    <span style="color:var(--text-muted,#94a3b8);font-size:0.75rem;">&ndash;</span>
                    <input type="text" class="pn-input" id="pn-range-b" placeholder="B" autocomplete="off" style="flex:1;">
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-range">Go</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.625rem 0;">

                <!-- Nth prime -->
                <label class="pn-label" for="pn-nth-input">Nth prime</label>
                <div style="display:flex;gap:0.375rem;">
                    <input type="text" class="pn-input" id="pn-nth-input" placeholder="e.g. 1000" autocomplete="off" style="flex:1;">
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-nth">Find</button>
                </div>
                <div class="pn-output" id="pn-nth-output"></div>

                <!-- Nearest prime -->
                <label class="pn-label" style="margin-top:0.5rem;" for="pn-nearest-input">Nearest prime</label>
                <div style="display:flex;gap:0.375rem;">
                    <input type="text" class="pn-input" id="pn-nearest-input" placeholder="e.g. 100" autocomplete="off" style="flex:1;">
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-nearest">Find</button>
                </div>
                <div class="pn-output" id="pn-nearest-output"></div>

                <hr style="border:none;border-top:1px solid var(--border,#e2e8f0);margin:0.625rem 0;">

                <!-- Goldbach -->
                <label class="pn-label" for="pn-goldbach-input">Goldbach (even N &gt; 2)</label>
                <div style="display:flex;gap:0.375rem;">
                    <input type="text" class="pn-input" id="pn-goldbach-input" placeholder="e.g. 28" autocomplete="off" style="flex:1;">
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-goldbach">Split</button>
                </div>
                <div class="pn-output" id="pn-goldbach-output"></div>

                <!-- GCD -->
                <label class="pn-label" style="margin-top:0.5rem;">GCD / Coprime</label>
                <div style="display:flex;gap:0.375rem;align-items:center;">
                    <input type="text" class="pn-input" id="pn-gcd-a" placeholder="A" autocomplete="off" style="flex:1;">
                    <span style="color:var(--text-muted,#94a3b8);font-size:0.75rem;">&amp;</span>
                    <input type="text" class="pn-input" id="pn-gcd-b" placeholder="B" autocomplete="off" style="flex:1;">
                    <button class="pn-btn pn-btn-secondary" id="pn-btn-gcd">GCD</button>
                </div>
                <div class="pn-output" id="pn-gcd-output"></div>

            </div>
        </div>

        <!-- Algorithms (collapsible, closed by default) -->
        <details style="margin-top:0.5rem;" class="tool-card">
            <summary class="tool-card-header" style="background:linear-gradient(135deg,#64748b 0%,#475569 100%);cursor:pointer;list-style:none;">
                Algorithms &#9660;
            </summary>
            <div class="tool-card-body" style="padding:0.625rem 0.75rem;">
                <ul class="pn-algo" style="margin:0;padding-left:1.25rem;">
                    <li><strong>Primality:</strong> Deterministic <code>Miller-Rabin</code> for 64-bit; probabilistic for BigInt.</li>
                    <li><strong>Sieve:</strong> <code>Eratosthenes</code> up-to-N; segmented for ranges.</li>
                    <li><strong>Factorization:</strong> Trial division, <code>6k&plusmn;1</code> optimization.</li>
                    <li><strong>Nth prime:</strong> PNT upper bound <code>n(ln n + ln ln n)</code>.</li>
                    <li><strong>Goldbach:</strong> Sieve-based scan.</li>
                    <li><strong>GCD:</strong> Euclidean algorithm (BigInt).</li>
                </ul>
            </div>
        </details>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%); color: #94a3b8;">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><rect x="3" y="3" width="18" height="18" rx="2"/><path d="M3 9h18M9 3v18"/></svg>
                Result
            </div>
            <div class="tool-card-body" style="padding:0;">
                <!-- Hero -->
                <div class="pn-hero" id="pn-hero">&mdash;</div>
                <!-- Controls bar (toggle twin primes) -->
                <div id="pn-list-controls" style="display:none;padding:0.5rem 1rem 0;">
                    <label style="display:inline-flex;align-items:center;gap:0.375rem;font-size:0.75rem;color:var(--text-secondary,#64748b);cursor:pointer;">
                        <input type="checkbox" id="pn-twin-toggle" style="accent-color:var(--pn-accent);"> Highlight twin primes
                    </label>
                </div>
                <!-- Prime list output -->
                <div style="padding: 0 1rem 1rem;">
                    <div class="pn-chips" id="pn-primes-list" style="display:none;"></div>
                </div>
            </div>
        </div>

        <!-- Prime Gap Chart -->
        <div class="tool-card" id="pn-gap-card" style="margin-top:0.75rem;display:none;">
            <div class="tool-card-header" style="background:linear-gradient(135deg,#0ea5e9 0%,#0284c7 100%);">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><rect x="3" y="12" width="4" height="9"/><rect x="10" y="7" width="4" height="14"/><rect x="17" y="3" width="4" height="18"/></svg>
                Prime Gaps
            </div>
            <div class="tool-card-body" style="padding:0.5rem;">
                <canvas id="pn-gap-canvas" height="180" style="width:100%;border-radius:6px;"></canvas>
                <p style="font-size:0.6875rem;color:var(--text-muted,#94a3b8);margin:0.375rem 0 0;text-align:center;">Gap between consecutive primes (hover for values)</p>
            </div>
        </div>

        <!-- Prime Density Chart -->
        <div class="tool-card" id="pn-density-card" style="margin-top:0.75rem;display:none;">
            <div class="tool-card-header" style="background:linear-gradient(135deg,#8b5cf6 0%,#7c3aed 100%);">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;flex-shrink:0;"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                Prime Density: &pi;(x)/x vs 1/ln(x)
            </div>
            <div class="tool-card-body" style="padding:0.5rem;">
                <canvas id="pn-density-canvas" height="180" style="width:100%;border-radius:6px;"></canvas>
                <p style="font-size:0.6875rem;color:var(--text-muted,#94a3b8);margin:0.375rem 0 0;text-align:center;">Prime Number Theorem: &pi;(x)/x converges to 1/ln(x)</p>
            </div>
        </div>

        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>

</main>

<!-- Support Section -->
<%@ include file="modern/components/support-section.jsp" %>

<!-- Footer -->
<footer class="page-footer">
    <div class="footer-content">
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
        <div class="footer-links">
            <a href="<%=request.getContextPath()%>/index.jsp" class="footer-link">Home</a>
            <a href="<%=request.getContextPath()%>/tutorials/" class="footer-link">Tutorials</a>
        </div>
    </div>
</footer>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js" defer></script>
<script src="<%=request.getContextPath()%>/modern/js/search.js" defer></script>

<script>
(function(){
    'use strict';

    // ========== BigInt / Math Algorithms (unchanged) ==========
    function toBigInt(s){ try{ return BigInt(s.trim()); } catch(e){ return null; } }

    function modPow(base, exp, mod){
        base %= mod; var res = 1n;
        while (exp > 0n){
            if (exp & 1n) res = (res * base) % mod;
            base = (base * base) % mod; exp >>= 1n;
        }
        return res;
    }

    function isProbablePrime(n){
        if (n === null) return false;
        if (n < 2n) return false;
        var small = [2n,3n,5n,7n,11n,13n,17n,19n,23n,29n,31n,37n];
        for (var i=0;i<small.length;i++){ if (n === small[i]) return true; if (n % small[i] === 0n) return false; }
        var d = n - 1n, s = 0n;
        while ((d & 1n) === 0n){ d >>= 1n; s++; }
        var bases = [2n, 325n, 9375n, 28178n, 450775n, 9780504n, 1795265022n];
        for (var b=0;b<bases.length;b++){
            var a = bases[b];
            if (a % n === 0n) continue;
            var x = modPow(a, d, n);
            if (x === 1n || x === n - 1n) continue;
            var cont = false;
            for (var r = 1n; r < s; r++){
                x = (x * x) % n;
                if (x === n - 1n){ cont = true; break; }
            }
            if (!cont) return false;
        }
        return true;
    }

    function sieve(limit){
        limit = Math.max(2, limit|0);
        var mark = new Uint8Array(limit + 1);
        var primes = [];
        for (var i=2;i*i<=limit;i++){
            if (!mark[i]) for (var j=i*i;j<=limit;j+=i) mark[j]=1;
        }
        for (var k=2;k<=limit;k++) if (!mark[k]) primes.push(k);
        return primes;
    }

    function segmentedSieve(low, high){
        if (high < 2) return [];
        low = Math.max(low|0, 2);
        high = high|0;
        var size = high - low + 1;
        var mark = new Uint8Array(size);
        var base = sieve(Math.floor(Math.sqrt(high)) + 1);
        for (var i=0;i<base.length;i++){
            var p = base[i];
            var start = Math.max(p*p, Math.ceil(low/p)*p);
            for (var x=start; x<=high; x+=p) mark[x-low]=1;
        }
        var res = [];
        for (var k=0;k<size;k++) if(!mark[k]) res.push(low+k);
        return res;
    }

    function factorizeBig(n){
        if (n < 2n) return [];
        var f = [];
        while (n % 2n === 0n){ f.push(2n); n/=2n; }
        while (n % 3n === 0n){ f.push(3n); n/=3n; }
        var i=5n, step=2n;
        while (i*i <= n){
            while (n % i === 0n){ f.push(i); n/=i; }
            i += step; step = 6n - step;
        }
        if (n > 1n) f.push(n);
        return f;
    }

    // ========== DOM ==========
    var hero = document.getElementById('pn-hero');
    var checkInput = document.getElementById('pn-check-input');
    var checkOutput = document.getElementById('pn-check-output');
    var limitInput = document.getElementById('pn-limit-input');
    var rangeA = document.getElementById('pn-range-a');
    var rangeB = document.getElementById('pn-range-b');
    var primesList = document.getElementById('pn-primes-list');
    var twinToggle = document.getElementById('pn-twin-toggle');
    var listControls = document.getElementById('pn-list-controls');
    var lastPrimeSet = null;

    function setHero(text, cls) {
        hero.textContent = text;
        hero.className = 'pn-hero' + (cls ? ' ' + cls : '');
    }

    // Clear ALL stale output from every section
    var allOutputIds = ['pn-check-output', 'pn-nth-output', 'pn-nearest-output', 'pn-goldbach-output', 'pn-gcd-output'];
    function clearAllOutputs() {
        for (var i = 0; i < allOutputIds.length; i++) {
            var el = document.getElementById(allOutputIds[i]);
            if (el) el.textContent = '';
        }
        primesList.style.display = 'none';
        primesList.innerHTML = '';
        listControls.style.display = 'none';
        document.getElementById('pn-gap-card').style.display = 'none';
        document.getElementById('pn-density-card').style.display = 'none';
    }

    // ========== Check ==========
    document.getElementById('pn-btn-check').addEventListener('click', function(){
        var bi = toBigInt(checkInput.value);
        if (bi === null){ setHero('\u2014'); checkOutput.textContent='Enter a valid integer.'; clearAllOutputs(); return; }
        var prime = isProbablePrime(bi);
        setHero((prime ? 'Prime' : 'Composite') + ' \u2014 ' + checkInput.value.trim(), prime ? 'prime' : 'composite');
        checkOutput.textContent = prime
            ? 'Passes deterministic Miller-Rabin for 64-bit (probable prime for BigInt).'
            : 'Failed Miller-Rabin witness test \u2014 number is composite.';
        clearAllOutputs();
    });

    // ========== Factorize ==========
    document.getElementById('pn-btn-factor').addEventListener('click', function(){
        var bi = toBigInt(checkInput.value);
        if (bi === null){ checkOutput.textContent='Enter a valid integer.'; return; }
        var fac = factorizeBig(bi).map(String);
        checkOutput.textContent = fac.length ? ('Factorization: ' + fac.join(' \u00d7 ')) : 'No factors (n < 2).';
        if (fac.length) setHero(checkInput.value.trim() + ' = ' + fac.join(' \u00d7 '), 'info');
        clearAllOutputs();
    });

    // ========== Generate up to N ==========
    document.getElementById('pn-btn-upto').addEventListener('click', function(){
        clearAllOutputs();
        var n = parseInt(limitInput.value, 10);
        if (!(n > 1)) return;
        if (n > 2000000){ setHero('Limit too large', 'composite'); renderPrimes([]); return; }
        var ps = sieve(n);
        renderPrimes(ps);
        setHero('Found ' + ps.length.toLocaleString() + ' primes \u2264 ' + n.toLocaleString(), 'info');
        checkOutput.textContent = '';
    });

    // ========== Generate range ==========
    document.getElementById('pn-btn-range').addEventListener('click', function(){
        clearAllOutputs();
        var a = parseInt(rangeA.value, 10), b = parseInt(rangeB.value, 10);
        if (!isFinite(a) || !isFinite(b)) return;
        var low = Math.min(a,b), high = Math.max(a,b);
        if (high - low > 2000000){ setHero('Range too wide', 'composite'); renderPrimes([]); return; }
        var ps = segmentedSieve(low, high);
        renderPrimes(ps);
        setHero('Found ' + ps.length.toLocaleString() + ' primes in [' + low.toLocaleString() + ', ' + high.toLocaleString() + ']', 'info');
        checkOutput.textContent = '';
    });

    // ========== NEW: Nth Prime ==========
    // Upper bound estimate: n * (ln(n) + ln(ln(n))) for n >= 6
    function nthPrime(n) {
        if (n < 1) return null;
        if (n <= 6) return [2,3,5,7,11,13][n-1];
        var ln = Math.log(n), lnln = Math.log(ln);
        var upper = Math.ceil(n * (ln + lnln + 2));
        upper = Math.min(upper, 20000000); // safety cap
        var ps = sieve(upper);
        return ps.length >= n ? ps[n-1] : null;
    }

    document.getElementById('pn-btn-nth').addEventListener('click', function(){
        clearAllOutputs();
        var n = parseInt(document.getElementById('pn-nth-input').value, 10);
        var out = document.getElementById('pn-nth-output');
        if (!(n > 0) || n > 1300000) { out.textContent = n > 1300000 ? 'Max supported: 1,300,000' : 'Enter a positive integer.'; return; }
        var p = nthPrime(n);
        if (p !== null) {
            out.textContent = 'The ' + n.toLocaleString() + ordSuffix(n) + ' prime is ' + p.toLocaleString();
            setHero('P(' + n.toLocaleString() + ') = ' + p.toLocaleString(), 'prime');
        } else {
            out.textContent = 'Could not compute.';
        }
    });

    function ordSuffix(n) {
        var s = ['th','st','nd','rd'], v = n % 100;
        return (s[(v-20)%10]||s[v]||s[0]);
    }

    // ========== NEW: Nearest Prime ==========
    function nearestPrime(n) {
        var bi = toBigInt(String(n));
        if (bi === null || bi < 2n) return { below: null, above: '2' };
        var below = null, above = null;
        for (var d = 0n; d < 1000n; d++) {
            if (below === null && bi - d >= 2n && isProbablePrime(bi - d)) below = String(bi - d);
            if (above === null && isProbablePrime(bi + d)) above = String(bi + d);
            if (below !== null && above !== null) break;
        }
        return { below: below, above: above };
    }

    document.getElementById('pn-btn-nearest').addEventListener('click', function(){
        clearAllOutputs();
        var val = document.getElementById('pn-nearest-input').value.trim();
        var out = document.getElementById('pn-nearest-output');
        if (!val) { out.textContent = 'Enter a non-negative integer.'; return; }
        var r = nearestPrime(val);
        if (r.below === val) {
            // N itself is prime
            out.textContent = val + ' is prime!';
            setHero(val + ' is prime!', 'prime');
        } else {
            var belowStr = r.below !== null ? r.below : 'none';
            var aboveStr = r.above !== null ? r.above : 'none';
            out.textContent = 'Below: ' + belowStr + '  |  Above: ' + aboveStr;
            setHero(belowStr + ' \u2190 ' + val + ' \u2192 ' + aboveStr, 'info');
        }
    });

    // ========== NEW: Goldbach Partition ==========
    // Uses sieve for fast lookup instead of per-candidate Miller-Rabin
    function goldbach(n) {
        if (n <= 2 || n % 2 !== 0) return null;
        var ps = sieve(n);
        var primeSet = new Uint8Array(n + 1);
        for (var i = 0; i < ps.length; i++) primeSet[ps[i]] = 1;
        for (var j = 0; j < ps.length; j++) {
            var p = ps[j];
            if (p > n / 2) break;
            if (primeSet[n - p]) return [p, n - p];
        }
        return null;
    }

    document.getElementById('pn-btn-goldbach').addEventListener('click', function(){
        clearAllOutputs();
        var n = parseInt(document.getElementById('pn-goldbach-input').value, 10);
        var out = document.getElementById('pn-goldbach-output');
        if (!isFinite(n) || n <= 2 || n % 2 !== 0) { out.textContent = 'Enter an even integer greater than 2.'; return; }
        if (n > 10000000) { out.textContent = 'Max supported: 10,000,000'; return; }
        var pair = goldbach(n);
        if (pair) {
            out.textContent = n.toLocaleString() + ' = ' + pair[0].toLocaleString() + ' + ' + pair[1].toLocaleString();
            setHero(n.toLocaleString() + ' = ' + pair[0].toLocaleString() + ' + ' + pair[1].toLocaleString(), 'info');
        } else {
            out.textContent = 'No partition found (should not happen for even n > 2).';
        }
    });

    // ========== NEW: Coprimality & GCD ==========
    function gcdBig(a, b) {
        a = a < 0n ? -a : a;
        b = b < 0n ? -b : b;
        while (b > 0n) { var t = b; b = a % b; a = t; }
        return a;
    }

    document.getElementById('pn-btn-gcd').addEventListener('click', function(){
        clearAllOutputs();
        var aVal = toBigInt(document.getElementById('pn-gcd-a').value);
        var bVal = toBigInt(document.getElementById('pn-gcd-b').value);
        var out = document.getElementById('pn-gcd-output');
        if (aVal === null || bVal === null) { out.textContent = 'Enter two integers.'; return; }
        var g = gcdBig(aVal, bVal);
        var coprime = (g === 1n);
        out.textContent = 'GCD(' + aVal + ', ' + bVal + ') = ' + g + (coprime ? ' \u2014 Coprime!' : '');
        setHero('GCD = ' + g + (coprime ? ' (coprime)' : ''), coprime ? 'prime' : 'info');
    });

    // ========== Twin Prime Toggle ==========
    function renderPrimesWithTwin(ps, highlight) {
        if (!ps.length) { primesList.style.display='none'; primesList.innerHTML=''; listControls.style.display='none'; return; }
        primesList.style.display = '';
        listControls.style.display = '';
        var twinSet = {};
        if (highlight && ps.length > 1) {
            for (var t = 0; t < ps.length - 1; t++) {
                if (ps[t+1] - ps[t] === 2) { twinSet[ps[t]] = 1; twinSet[ps[t+1]] = 1; }
            }
        }
        var html = '';
        var lim = Math.min(ps.length, 500);
        for (var i = 0; i < lim; i++) {
            var cls = 'pn-chip';
            if (highlight && twinSet[ps[i]]) cls += ' twin';
            else if (highlight) cls += ' twin-dim';
            html += '<span class="' + cls + '">' + ps[i] + '</span>';
        }
        if (ps.length > 500) html += '<span class="pn-overflow">... +' + (ps.length - 500) + ' more</span>';
        primesList.innerHTML = html;
    }

    twinToggle.addEventListener('change', function(){
        if (lastPrimeSet) renderPrimesWithTwin(lastPrimeSet, this.checked);
    });

    // Override renderPrimes to store + respect twin toggle
    function renderPrimes(ps){
        lastPrimeSet = ps;
        renderPrimesWithTwin(ps, twinToggle.checked);
        if (ps.length > 1) drawGapChart(ps);
        if (ps.length > 10) drawDensityChart(ps);
    }

    // ========== Prime Gap Chart (Canvas) ==========
    function drawGapChart(primes) {
        var card = document.getElementById('pn-gap-card');
        var canvas = document.getElementById('pn-gap-canvas');
        if (!card || !canvas || primes.length < 2) { if (card) card.style.display='none'; return; }
        card.style.display = '';
        var ctx = canvas.getContext('2d');
        var dpr = window.devicePixelRatio || 1;
        var w = canvas.clientWidth;
        var h = 180;
        canvas.width = w * dpr;
        canvas.height = h * dpr;
        ctx.scale(dpr, dpr);

        var gaps = [];
        var maxG = 0;
        var limit = Math.min(primes.length - 1, 300); // cap bars for readability
        for (var i = 0; i < limit; i++) {
            var g = primes[i+1] - primes[i];
            gaps.push(g);
            if (g > maxG) maxG = g;
        }
        if (maxG === 0) maxG = 1;

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        ctx.clearRect(0, 0, w, h);
        var barW = Math.max(1, (w - 20) / gaps.length);
        var pad = 10;

        for (var j = 0; j < gaps.length; j++) {
            var barH = (gaps[j] / maxG) * (h - 20);
            var x = pad + j * barW;
            var y = h - 10 - barH;
            ctx.fillStyle = gaps[j] === 2 ? (isDark ? '#fbbf24' : '#f59e0b') : (isDark ? '#34d399' : '#10b981');
            ctx.fillRect(x, y, Math.max(1, barW - 1), barH);
        }
        // Axis label
        ctx.fillStyle = isDark ? '#94a3b8' : '#64748b';
        ctx.font = '10px Inter, sans-serif';
        ctx.fillText('max gap: ' + maxG, pad, 12);
        ctx.fillText('twin gaps (2) highlighted', w - 130, 12);
    }

    // ========== Prime Density Chart (Canvas) ==========
    function drawDensityChart(primes) {
        var card = document.getElementById('pn-density-card');
        var canvas = document.getElementById('pn-density-canvas');
        if (!card || !canvas || primes.length < 10) { if (card) card.style.display='none'; return; }
        card.style.display = '';
        var ctx = canvas.getContext('2d');
        var dpr = window.devicePixelRatio || 1;
        var w = canvas.clientWidth;
        var h = 180;
        canvas.width = w * dpr;
        canvas.height = h * dpr;
        ctx.scale(dpr, dpr);

        var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        ctx.clearRect(0, 0, w, h);

        // Sample points: for each prime, compute pi(x)/x and 1/ln(x)
        var maxX = primes[primes.length - 1];
        var samples = 200;
        var step = Math.max(1, Math.floor(primes.length / samples));
        var pts_actual = []; // pi(x)/x
        var pts_theory = []; // 1/ln(x)
        var pad = 30;
        var plotW = w - pad - 10;
        var plotH = h - 30;

        for (var i = step; i < primes.length; i += step) {
            var x = primes[i];
            if (x < 3) continue;
            var piX = i + 1; // number of primes up to primes[i]
            pts_actual.push({ x: x, y: piX / x });
            pts_theory.push({ x: x, y: 1 / Math.log(x) });
        }

        if (!pts_actual.length) { card.style.display='none'; return; }

        var maxY = 0;
        for (var k = 0; k < pts_actual.length; k++) {
            if (pts_actual[k].y > maxY) maxY = pts_actual[k].y;
            if (pts_theory[k].y > maxY) maxY = pts_theory[k].y;
        }
        if (maxY === 0) maxY = 1;

        function mapX(v) { return pad + (v / maxX) * plotW; }
        function mapY(v) { return h - 15 - (v / maxY) * plotH; }

        // Draw theory line (1/ln(x))
        ctx.beginPath();
        ctx.strokeStyle = isDark ? '#a78bfa' : '#8b5cf6';
        ctx.lineWidth = 2;
        for (var t = 0; t < pts_theory.length; t++) {
            var tx = mapX(pts_theory[t].x), ty = mapY(pts_theory[t].y);
            t === 0 ? ctx.moveTo(tx, ty) : ctx.lineTo(tx, ty);
        }
        ctx.stroke();

        // Draw actual line (pi(x)/x)
        ctx.beginPath();
        ctx.strokeStyle = isDark ? '#34d399' : '#10b981';
        ctx.lineWidth = 2;
        for (var a = 0; a < pts_actual.length; a++) {
            var ax = mapX(pts_actual[a].x), ay = mapY(pts_actual[a].y);
            a === 0 ? ctx.moveTo(ax, ay) : ctx.lineTo(ax, ay);
        }
        ctx.stroke();

        // Legend
        ctx.font = '10px Inter, sans-serif';
        ctx.fillStyle = isDark ? '#34d399' : '#10b981';
        ctx.fillText('\u03C0(x)/x (actual)', pad + 4, 14);
        ctx.fillStyle = isDark ? '#a78bfa' : '#8b5cf6';
        ctx.fillText('1/ln(x) (PNT)', pad + 100, 14);

        // Axes
        ctx.strokeStyle = isDark ? 'rgba(255,255,255,0.1)' : 'rgba(0,0,0,0.08)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad, h - 15);
        ctx.lineTo(w - 10, h - 15);
        ctx.stroke();
    }

    // Enter key handlers
    checkInput.addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-check').click();
    });
    limitInput.addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-upto').click();
    });
    rangeB.addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-range').click();
    });
    document.getElementById('pn-nth-input').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-nth').click();
    });
    document.getElementById('pn-nearest-input').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-nearest').click();
    });
    document.getElementById('pn-goldbach-input').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-goldbach').click();
    });
    document.getElementById('pn-gcd-b').addEventListener('keydown', function(e){
        if (e.key === 'Enter') document.getElementById('pn-btn-gcd').click();
    });
})();
</script>

</body>
</html>
