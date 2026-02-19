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
    <meta name="resource-type" content="document">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">

    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Exponent Calculator with Steps - All 8 Laws of Exponents" />
        <jsp:param name="toolDescription" value="Free exponent calculator with step-by-step solutions for all 8 laws. Product, quotient, power, negative, zero, and fractional exponent rules. Simplify online." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="exponent-calculator.jsp" />
        <jsp:param name="toolKeywords" value="exponent calculator, power calculator, laws of exponents, exponent rules calculator, product rule exponents, quotient rule exponents, power rule exponents, negative exponent calculator, zero exponent, fractional exponents, simplify exponents, exponential expressions calculator, step by step exponents" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Calculate any base raised to any power,All 8 exponent laws with step-by-step solutions,Product quotient and power rule demonstrations,Negative zero and fractional exponent support,Multi-rule simplification with detailed steps,All Laws comparison mode with custom base,Built-in Python compiler with SymPy,LaTeX export and shareable URLs,8 quick example presets,Dark mode support" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="faq1q" value="What are the rules of exponents with examples?" />
        <jsp:param name="faq1a" value="The 8 rules are: (1) Product Rule a^m times a^n equals a^(m+n) e.g. 2^3 times 2^4 equals 2^7 equals 128, (2) Quotient Rule a^m divided by a^n equals a^(m-n), (3) Power Rule (a^m)^n equals a^(mn), (4) Power of Product (ab)^n equals a^n times b^n, (5) Power of Quotient (a/b)^n equals a^n/b^n, (6) Negative Exponent a^(-n) equals 1/a^n, (7) Zero Exponent a^0 equals 1, (8) Fractional Exponent a^(m/n) equals nth root of a^m. Enter any values to see each rule applied step by step." />
        <jsp:param name="faq2q" value="How do you solve negative exponents step by step?" />
        <jsp:param name="faq2a" value="Step 1 write the base with the positive exponent in the denominator. Step 2 calculate the positive power. Step 3 take the reciprocal. Example: 5^(-3) equals 1/5^3 equals 1/125 equals 0.008. The general rule is a^(-n) equals 1/a^n. This works because multiplying a^n times a^(-n) must equal a^0 which equals 1, so a^(-n) equals 1/a^n." />
        <jsp:param name="faq3q" value="How do you simplify expressions with exponents?" />
        <jsp:param name="faq3a" value="To simplify exponent expressions: first apply the power rule to nested powers like (a^2)^3 equals a^6, then use the product rule to combine same-base terms like a^6 times a^4 equals a^10, then use the quotient rule for division. For example (x^3)^2 times x^4 divided by x^5 simplifies to x^6 times x^4 divided by x^5 equals x^10 divided by x^5 equals x^5. This calculator shows every intermediate step." />
        <jsp:param name="faq4q" value="Why is anything to the power of 0 equal to 1?" />
        <jsp:param name="faq4a" value="By the quotient rule a^n divided by a^n equals a^(n minus n) equals a^0. But any number divided by itself is 1. Therefore a^0 must equal 1. Another way to see it: each time you decrease the exponent by 1 you divide by the base. Starting from 2^3 equals 8, 2^2 equals 4, 2^1 equals 2, so 2^0 equals 1. This holds for every non-zero base. Note 0^0 is undefined." />
        <jsp:param name="faq5q" value="What is a fractional or rational exponent?" />
        <jsp:param name="faq5a" value="A fractional exponent a^(m/n) means take the nth root of a raised to the m power. The denominator n is the root index and the numerator m is the power. Example: 27^(2/3) means cube root of 27 squared. Cube root of 27 is 3, then 3 squared is 9. You can also compute 27^2 first to get 729, then take the cube root of 729 which also gives 9. Both methods always yield the same answer." />
    </jsp:include>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" media="print" onload="this.media='all'">
    <noscript><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet"></noscript>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/design-system.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/three-column-tool.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/tool-page.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/search.css?v=<%=cacheVersion%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/exponent-calculator.css?v=<%=cacheVersion%>">

    <%@ include file="modern/ads/ad-init.jsp" %>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css">

    <style>
        .tool-action-btn { background: var(--ec-gradient) !important; }
        .tool-badge { background: var(--ec-light); color: var(--ec-tool); }
    </style>
</head>
<body>
<%@ include file="modern/components/nav-header.jsp" %>

<header class="tool-page-header">
    <div class="tool-page-header-inner">
        <div>
            <h1 class="tool-page-title">Exponent Calculator</h1>
            <nav class="tool-breadcrumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a> /
                <a href="<%=request.getContextPath()%>/math/">Math Tools</a> /
                Exponent Calculator
            </nav>
        </div>
        <div class="tool-page-badges">
            <span class="tool-badge">Free Online</span>
            <span class="tool-badge">All 8 Laws</span>
            <span class="tool-badge">Step-by-Step</span>
        </div>
    </div>
</header>

<section class="tool-description-section" style="background:var(--ec-light);">
    <div class="tool-description-inner">
        <div class="tool-description-content">
            <p>Free <strong>exponent calculator</strong> with <strong>step-by-step solutions</strong> for all <strong>8 laws of exponents</strong>. Calculate powers, apply product/quotient/power rules, handle negative, zero, and fractional exponents. Simplify complex expressions instantly.</p>
        </div>
    </div>
</section>

<main class="tool-page-container">
    <!-- ==================== INPUT COLUMN ==================== -->
    <div class="tool-input-column">
        <div class="tool-card">
            <div class="tool-card-header" style="background:var(--ec-gradient);">Exponent Calculator</div>
            <div class="tool-card-body">

                <!-- Mode Toggle -->
                <div class="tool-form-group" style="margin-bottom:0.75rem;">
                    <label class="tool-form-label">Mode</label>
                    <div class="ec-mode-toggle">
                        <button type="button" class="ec-mode-btn active" data-mode="basic">Basic Power</button>
                        <button type="button" class="ec-mode-btn" data-mode="rules">Apply Rules</button>
                        <button type="button" class="ec-mode-btn" data-mode="simplify">Simplify</button>
                        <button type="button" class="ec-mode-btn" data-mode="alllaws">All Laws</button>
                    </div>
                </div>

                <!-- ===== BASIC POWER FORM ===== -->
                <div class="ec-mode-form active" id="ec-form-basic">
                    <div class="tool-form-group">
                        <div class="ec-input-row">
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-basic-base">Base (a)</label>
                                <input type="number" class="ec-input" id="ec-basic-base" value="2" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-basic-exp">Exponent (n)</label>
                                <input type="number" class="ec-input" id="ec-basic-exp" value="5" step="any">
                            </div>
                        </div>
                        <div class="tool-form-hint">Calculate a<sup>n</sup> with step-by-step solution</div>
                    </div>
                </div>

                <!-- ===== APPLY RULES FORM ===== -->
                <div class="ec-mode-form" id="ec-form-rules">
                    <div class="tool-form-group" style="margin-bottom:0.5rem;">
                        <label class="ec-input-label" for="ec-rule-type">Exponent Rule</label>
                        <select class="ec-rule-select" id="ec-rule-type">
                            <option value="product">Product Rule: a^m &times; a^n = a^(m+n)</option>
                            <option value="quotient">Quotient Rule: a^m &divide; a^n = a^(m-n)</option>
                            <option value="power">Power Rule: (a^m)^n = a^(mn)</option>
                            <option value="product-power">Power of Product: (ab)^n = a^n b^n</option>
                            <option value="quotient-power">Power of Quotient: (a/b)^n = a^n/b^n</option>
                            <option value="negative">Negative Exponent: a^(-n) = 1/a^n</option>
                            <option value="zero">Zero Exponent: a^0 = 1</option>
                            <option value="fractional">Fractional Exponent: a^(m/n)</option>
                        </select>
                    </div>

                    <!-- Product / Quotient inputs: base, m, n -->
                    <div id="ec-rule-inputs-pq">
                        <div class="ec-input-row">
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-rule-base">Base (a)</label>
                                <input type="number" class="ec-input" id="ec-rule-base" value="3" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-rule-m">m</label>
                                <input type="number" class="ec-input" id="ec-rule-m" value="4" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-rule-n">n</label>
                                <input type="number" class="ec-input" id="ec-rule-n" value="3" step="any">
                            </div>
                        </div>
                    </div>

                    <!-- Power rule inputs: base, m, n -->
                    <div id="ec-rule-inputs-power" style="display:none;">
                        <div class="ec-input-row">
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-power-base">Base (a)</label>
                                <input type="number" class="ec-input" id="ec-power-base" value="2" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-power-m">m</label>
                                <input type="number" class="ec-input" id="ec-power-m" value="3" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-power-n">n</label>
                                <input type="number" class="ec-input" id="ec-power-n" value="2" step="any">
                            </div>
                        </div>
                    </div>

                    <!-- Product power / Quotient power inputs: a, b, n -->
                    <div id="ec-rule-inputs-prodpow" style="display:none;">
                        <div class="ec-input-row">
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-prod-a">a</label>
                                <input type="number" class="ec-input" id="ec-prod-a" value="2" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-prod-b">b</label>
                                <input type="number" class="ec-input" id="ec-prod-b" value="3" step="any">
                            </div>
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-prod-n">n</label>
                                <input type="number" class="ec-input" id="ec-prod-n" value="2" step="any">
                            </div>
                        </div>
                    </div>

                    <!-- Special rules: negative, zero, fractional -->
                    <div id="ec-rule-inputs-special" style="display:none;">
                        <div class="ec-input-row">
                            <div class="ec-input-group">
                                <label class="ec-input-label" for="ec-special-base">Base (a)</label>
                                <input type="number" class="ec-input" id="ec-special-base" value="5" step="any">
                            </div>
                            <div class="ec-input-group" id="ec-special-exp-group">
                                <label class="ec-input-label" for="ec-special-exp">Exponent</label>
                                <input type="number" class="ec-input" id="ec-special-exp" value="-3" step="any">
                            </div>
                        </div>
                        <!-- Fractional exponent inputs -->
                        <div id="ec-frac-inputs" style="display:none;">
                            <div class="ec-input-row" style="margin-top:0.5rem;">
                                <div class="ec-input-group">
                                    <label class="ec-input-label" for="ec-frac-num">Numerator (m)</label>
                                    <input type="number" class="ec-input" id="ec-frac-num" value="3" step="1">
                                </div>
                                <div class="ec-input-group">
                                    <label class="ec-input-label" for="ec-frac-denom">Denominator (n)</label>
                                    <input type="number" class="ec-input" id="ec-frac-denom" value="2" step="1">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== SIMPLIFY FORM ===== -->
                <div class="ec-mode-form" id="ec-form-simplify">
                    <div class="tool-form-group" style="margin-bottom:0.5rem;">
                        <label class="ec-input-label" for="ec-simplify-type">Expression</label>
                        <select class="ec-rule-select" id="ec-simplify-type">
                            <option value="combo1">(a&sup2;)&sup3; &times; a&sup4;</option>
                            <option value="combo2">a&sup8; &divide; (a&sup2;)&sup3;</option>
                            <option value="combo3">(a&sup3;b&sup2;)&sup4;</option>
                            <option value="combo4">a&minus;&sup2; &times; a&sup5;</option>
                        </select>
                    </div>
                    <div class="ec-input-row">
                        <div class="ec-input-group">
                            <label class="ec-input-label" for="ec-simplify-a">a</label>
                            <input type="number" class="ec-input" id="ec-simplify-a" value="2" step="any">
                        </div>
                        <div class="ec-input-group" id="ec-simplify-b-group" style="display:none;">
                            <label class="ec-input-label" for="ec-simplify-b">b</label>
                            <input type="number" class="ec-input" id="ec-simplify-b" value="3" step="any">
                        </div>
                    </div>
                </div>

                <!-- ===== ALL LAWS FORM ===== -->
                <div class="ec-mode-form" id="ec-form-alllaws">
                    <div class="tool-form-group">
                        <label class="ec-input-label" for="ec-compare-base">Base (a)</label>
                        <input type="number" class="ec-input" id="ec-compare-base" value="2" step="any">
                        <div class="tool-form-hint">See all 8 exponent laws demonstrated with your chosen base</div>
                    </div>
                </div>

                <!-- Live Preview -->
                <div class="tool-form-group" style="margin-top:0.75rem;">
                    <label class="tool-form-label">Preview</label>
                    <div class="ec-preview" id="ec-preview"></div>
                </div>

                <!-- Action Buttons -->
                <div style="display:flex;gap:0.5rem;">
                    <button type="button" class="tool-action-btn" id="ec-solve-btn" style="flex:1">Calculate</button>
                    <button type="button" class="tool-action-btn" id="ec-clear-btn" style="flex:0;min-width:60px;background:var(--bg-secondary)!important;color:var(--text-secondary);border:1px solid var(--border)">Clear</button>
                </div>

                <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">

                <!-- Quick Examples -->
                <div class="tool-form-group">
                    <label class="tool-form-label">Quick Examples</label>
                    <div class="ec-examples">
                        <button type="button" class="ec-example-chip" data-example="power-of-2">2<sup>10</sup></button>
                        <button type="button" class="ec-example-chip" data-example="negative">3<sup>&minus;2</sup></button>
                        <button type="button" class="ec-example-chip" data-example="fractional">16<sup>0.5</sup></button>
                        <button type="button" class="ec-example-chip" data-example="zero">7<sup>0</sup></button>
                        <button type="button" class="ec-example-chip" data-example="product">Product Rule</button>
                        <button type="button" class="ec-example-chip" data-example="quotient">Quotient Rule</button>
                        <button type="button" class="ec-example-chip" data-example="simplify1">Simplify</button>
                        <button type="button" class="ec-example-chip" data-example="all-laws">All Laws</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== OUTPUT COLUMN ==================== -->
    <div class="tool-output-column">
        <!-- Tab bar -->
        <div class="ec-output-tabs">
            <button type="button" class="ec-output-tab active" data-panel="result">Result</button>
            <button type="button" class="ec-output-tab" data-panel="python">Python Compiler</button>
        </div>

        <!-- Result Panel -->
        <div class="ec-panel active" id="ec-panel-result">
            <div class="tool-card tool-result-card">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ec-tool);">
                        <polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/>
                    </svg>
                    <h4>Result</h4>
                </div>
                <div class="tool-result-content" id="ec-result-content">
                    <div class="tool-empty-state" id="ec-empty-state">
                        <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">a<sup>n</sup></div>
                        <h3>Enter values to calculate</h3>
                        <p>Master all 8 laws of exponents with step-by-step solutions.</p>
                    </div>
                </div>
                <div class="tool-result-actions" id="ec-result-actions" style="display:none;gap:0.5rem;padding:1rem;border-top:1px solid var(--border);flex-wrap:wrap">
                    <button type="button" class="tool-action-btn" id="ec-copy-latex-btn">Copy LaTeX</button>
                    <button type="button" class="tool-action-btn" id="ec-share-btn">Share</button>
                </div>
            </div>
        </div>

        <!-- Python Compiler Panel -->
        <div class="ec-panel" id="ec-panel-python">
            <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                <div class="tool-result-header">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--ec-tool);">
                        <polygon points="5 3 19 12 5 21 5 3"/>
                    </svg>
                    <h4>Python Compiler</h4>
                    <select id="ec-compiler-template" style="margin-left:auto;padding:0.3rem 0.5rem;border:1px solid var(--border);border-radius:0.375rem;font-size:0.75rem;font-family:var(--font-sans);background:var(--bg-primary);color:var(--text-primary);cursor:pointer;">
                        <option value="basic-power">Basic Power</option>
                        <option value="all-laws">All 8 Laws</option>
                        <option value="sympy">SymPy (Symbolic)</option>
                    </select>
                </div>
                <div style="flex:1;min-height:0;">
                    <iframe id="ec-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                </div>
            </div>
        </div>
    </div>

    <!-- ==================== ADS COLUMN ==================== -->
    <div class="tool-ads-column">
        <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
    </div>
</main>

<!-- Mobile Ad Fallback -->
<div class="tool-mobile-ad-container">
    <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
</div>

<!-- Related Tools -->
<jsp:include page="modern/components/related-tools.jsp">
    <jsp:param name="currentToolUrl" value="exponent-calculator.jsp"/>
    <jsp:param name="keyword" value="mathematics"/>
    <jsp:param name="limit" value="6"/>
</jsp:include>

<!-- ========== BELOW-FOLD EDUCATIONAL CONTENT ========== -->
<section class="tool-expertise-section" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">

    <!-- ===== 1. WHAT ARE EXPONENTS? ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.75rem;color:var(--text-primary);">What are Exponents?</h2>
        <p class="ec-anim" style="color:var(--text-secondary);line-height:1.7;margin-bottom:1rem;">
            An <strong>exponent</strong> tells you how many times to multiply a number (the <strong>base</strong>) by itself. For example, 2<sup>5</sup> means 2 &times; 2 &times; 2 &times; 2 &times; 2 = 32. Exponents are fundamental in algebra, physics, computer science, and finance &mdash; appearing everywhere from compound interest to binary numbers.
        </p>

        <div class="ec-callout ec-callout-insight ec-anim ec-anim-d2">
            <span class="ec-callout-icon">&#128161;</span>
            <div class="ec-callout-text">
                <strong>Key Insight:</strong> The 8 laws of exponents let you simplify complex expressions by combining, splitting, and transforming powers &mdash; without ever computing the full result. This is essential for algebra and calculus.
            </div>
        </div>
    </div>

    <!-- ===== 2. THE 8 LAWS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">The 8 Laws of Exponents</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            These rules govern how exponents behave in multiplication, division, and nesting.
        </p>

        <div class="ec-laws-grid">
            <div class="ec-edu-card ec-anim ec-anim-d1" style="border-left:3px solid #d97706;">
                <h4>1. Product Rule</h4>
                <p>a<sup>m</sup> &times; a<sup>n</sup> = a<sup>m+n</sup></p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Same base? Add the exponents.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d1" style="border-left:3px solid #f59e0b;">
                <h4>2. Quotient Rule</h4>
                <p>a<sup>m</sup> &divide; a<sup>n</sup> = a<sup>m&minus;n</sup></p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Same base? Subtract the exponents.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d2" style="border-left:3px solid #dc2626;">
                <h4>3. Power Rule</h4>
                <p>(a<sup>m</sup>)<sup>n</sup> = a<sup>mn</sup></p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Power of a power? Multiply.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d2" style="border-left:3px solid #7c3aed;">
                <h4>4. Power of Product</h4>
                <p>(ab)<sup>n</sup> = a<sup>n</sup>b<sup>n</sup></p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Distribute across multiplication.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d3" style="border-left:3px solid #2563eb;">
                <h4>5. Power of Quotient</h4>
                <p>(a/b)<sup>n</sup> = a<sup>n</sup>/b<sup>n</sup></p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Distribute across division.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d3" style="border-left:3px solid #059669;">
                <h4>6. Negative Exponent</h4>
                <p>a<sup>&minus;n</sup> = 1/a<sup>n</sup></p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Flip to the denominator.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d4" style="border-left:3px solid #0891b2;">
                <h4>7. Zero Exponent</h4>
                <p>a<sup>0</sup> = 1</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Anything (non-zero) to the zero = 1.</p>
            </div>
            <div class="ec-edu-card ec-anim ec-anim-d4" style="border-left:3px solid #be185d;">
                <h4>8. Fractional Exponent</h4>
                <p>a<sup>m/n</sup> = <sup>n</sup>&radic;(a<sup>m</sup>)</p>
                <p style="color:var(--text-muted);font-size:0.6875rem;">Numerator = power, denominator = root.</p>
            </div>
        </div>
    </div>

    <!-- ===== 3. REAL-WORLD APPLICATIONS ===== -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:0.5rem;color:var(--text-primary);">Real-World Applications</h2>
        <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.7;margin-bottom:0.75rem;">
            Exponents appear throughout mathematics, science, and everyday life.
        </p>
        <div class="ec-laws-grid" style="grid-template-columns:repeat(auto-fit,minmax(260px,1fr));">
            <div class="ec-edu-card" style="border-left:3px solid #d97706;">
                <h4>Compound Interest</h4>
                <p>A = P(1 + r/n)<sup>nt</sup>. Your savings grow exponentially thanks to the power of compounding.</p>
            </div>
            <div class="ec-edu-card" style="border-left:3px solid #2563eb;">
                <h4>Computer Science</h4>
                <p>Binary uses powers of 2. A 32-bit integer stores values up to 2<sup>32</sup> &minus; 1 = 4,294,967,295.</p>
            </div>
            <div class="ec-edu-card" style="border-left:3px solid #059669;">
                <h4>Physics &amp; Engineering</h4>
                <p>Radioactive decay (N = N<sub>0</sub> &middot; 2<sup>&minus;t/h</sup>), sound intensity (decibels), and earthquake magnitudes all use exponents.</p>
            </div>
        </div>

        <div class="ec-callout ec-callout-tip ec-anim ec-anim-d3">
            <span class="ec-callout-icon">&#128073;</span>
            <div class="ec-callout-text">
                <strong>Try it!</strong> Enter base = 1.08, exponent = 30 to see how $1 grows to $10.06 at 8% annual compound interest over 30 years.
            </div>
        </div>
    </div>

    <!-- FAQ Section -->
    <div class="tool-card" style="padding:2rem;margin-bottom:1.5rem;">
        <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What are the 8 laws of exponents?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">The 8 laws are: (1) Product Rule: a<sup>m</sup> &times; a<sup>n</sup> = a<sup>m+n</sup>, (2) Quotient Rule: a<sup>m</sup> &divide; a<sup>n</sup> = a<sup>m&minus;n</sup>, (3) Power Rule: (a<sup>m</sup>)<sup>n</sup> = a<sup>mn</sup>, (4) Power of a Product: (ab)<sup>n</sup> = a<sup>n</sup>b<sup>n</sup>, (5) Power of a Quotient: (a/b)<sup>n</sup> = a<sup>n</sup>/b<sup>n</sup>, (6) Negative Exponent: a<sup>&minus;n</sup> = 1/a<sup>n</sup>, (7) Zero Exponent: a<sup>0</sup> = 1, (8) Fractional Exponent: a<sup>m/n</sup> = <sup>n</sup>&radic;(a<sup>m</sup>).</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                How do you calculate negative exponents?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A negative exponent means take the reciprocal: a<sup>&minus;n</sup> = 1/a<sup>n</sup>. For example, 2<sup>&minus;3</sup> = 1/2<sup>3</sup> = 1/8 = 0.125. First compute the positive power, then take the reciprocal.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                What is a fractional exponent?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">A fractional exponent combines a power and a root. The numerator is the power and the denominator is the root. For example, 8<sup>2/3</sup> means the cube root of 8 squared. Cube root of 8 is 2, then 2 squared is 4. So 8<sup>2/3</sup> = 4.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Why does anything to the zero power equal 1?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Using the quotient rule: a<sup>n</sup> &divide; a<sup>n</sup> = a<sup>n&minus;n</sup> = a<sup>0</sup>. But any number divided by itself equals 1, so a<sup>0</sup> = 1. This holds for any non-zero base. Note that 0<sup>0</sup> is typically considered undefined.</div>
        </div>

        <div class="faq-item">
            <button class="faq-question" onclick="toggleFaq(this)">
                Is this exponent calculator free?
                <svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg>
            </button>
            <div class="faq-answer">Yes, 100% free with no signup. Features include all 8 exponent laws with step-by-step solutions, multi-rule simplification, an All Laws comparison mode, a Python SymPy compiler, LaTeX export, and shareable URLs. All computation runs in your browser.</div>
        </div>
    </div>
</section>

<!-- Explore More Math -->
<section style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
    <div class="tool-card" style="padding:1.5rem 2rem;">
        <h3 style="font-size:1.15rem;font-weight:600;margin:0 0 1rem;display:flex;align-items:center;gap:0.5rem;color:var(--text-primary);">
            Explore More Math Tools
        </h3>
        <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:1rem;">
            <a href="<%=request.getContextPath()%>/logarithm-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#0d9488,#14b8a6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">log</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Logarithm Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Compute logs with step-by-step solutions</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/quadratic-solver.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#7c3aed,#a78bfa);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.1rem;color:#fff;font-weight:700;">x&sup2;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Quadratic Solver</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Solve quadratic equations with 3 methods and graphs</p>
                </div>
            </a>
            <a href="<%=request.getContextPath()%>/series-calculator.jsp" style="display:flex;align-items:center;gap:1rem;padding:1rem;background:var(--bg-secondary);border:1px solid var(--border);border-radius:0.75rem;text-decoration:none;transition:all 0.2s;" onmouseover="this.style.transform='translateY(-2px)'" onmouseout="this.style.transform=''">
                <div style="width:3rem;height:3rem;background:linear-gradient(135deg,#2563eb,#3b82f6);border-radius:0.625rem;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:1.4rem;color:#fff;">&Sigma;</div>
                <div>
                    <h4 style="font-size:0.9375rem;font-weight:600;color:var(--text-primary);margin:0 0 0.25rem;">Series Calculator</h4>
                    <p style="font-size:0.8125rem;color:var(--text-secondary);margin:0;line-height:1.4;">Taylor &amp; Maclaurin series with convergence graphs</p>
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
        <p class="footer-text">&copy; 2024 8gwifi.org - Free Online Tools</p>
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
    var els = document.querySelectorAll('.ec-anim');
    if (!els.length) return;
    if (!('IntersectionObserver' in window)) {
        for (var i = 0; i < els.length; i++) els[i].classList.add('ec-visible');
        return;
    }
    var obs = new IntersectionObserver(function(entries){
        for (var j = 0; j < entries.length; j++) {
            if (entries[j].isIntersecting) {
                entries[j].target.classList.add('ec-visible');
                obs.unobserve(entries[j].target);
            }
        }
    }, { threshold: 0.15 });
    for (var k = 0; k < els.length; k++) obs.observe(els[k]);
})();
</script>

<!-- Core Scripts -->
<script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
<script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/exponent-calculator-render.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/exponent-calculator-export.js?v=<%=cacheVersion%>"></script>
<script src="<%=request.getContextPath()%>/js/exponent-calculator-core.js?v=<%=cacheVersion%>"></script>

<%@ include file="modern/components/analytics.jsp" %>
</body>
</html>
