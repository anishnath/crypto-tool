<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
    String v = String.valueOf(System.currentTimeMillis());
    request.setAttribute("v", v);
    request.setAttribute("aiToolId", "math-ai");
    request.setAttribute("aiRequireSignIn", "true");
%>
<%@ include file="modern/components/ai-assistant-vars.inc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow">
    <meta name="googlebot" content="index,follow">
    <meta name="resource-type" content="document">
    <meta name="classification" content="tools">
    <meta name="language" content="en">
    <meta name="author" content="Anish Nath">
    <meta name="context-path" content="<%=request.getContextPath()%>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="dns-prefetch" href="https://cdn.jsdelivr.net">
    <link rel="dns-prefetch" href="https://cdn.plot.ly">
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Binomial Distribution Calculator Online - PMF, CDF &amp; Visualization Free" />
        <jsp:param name="toolDescription" value="Calculate binomial probabilities P(X=k), cumulative P(X le k), and range probabilities. Interactive PMF bar chart, step-by-step formulas, and Python scipy export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="binomial-distribution-calculator.jsp" />
        <jsp:param name="toolKeywords" value="binomial distribution calculator, binomial probability calculator, PMF calculator, CDF calculator, binomial coefficient, bernoulli trials, success probability, number of trials, discrete probability, binomial theorem" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Exact probability P(X equals k),Cumulative probability P(X le k),Range probability P(a le X le b),Interactive Plotly PMF bar chart,Step-by-step KaTeX formulas,Mean variance and standard deviation,Python scipy code generation,Quick example presets" />
        <jsp:param name="teaches" value="Binomial distribution, Bernoulli trials, probability mass function, cumulative distribution, binomial coefficient, discrete probability" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Set Parameters|Enter number of trials n and success probability p,Choose Mode|Select Exact or Cumulative or Range probability,Enter k Values|Input the number of successes to evaluate,Click Calculate|Get instant probability with step-by-step formulas,View PMF Chart|Explore the interactive probability mass function,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is a binomial distribution?" />
        <jsp:param name="faq1a" value="A binomial distribution models the number of successes in n independent Bernoulli trials each with success probability p. It is a discrete probability distribution where outcomes are counted as whole numbers from 0 to n." />
        <jsp:param name="faq2q" value="How do I calculate binomial probability P(X equals k)?" />
        <jsp:param name="faq2a" value="Use the formula P(X equals k) equals C(n k) times p to the k times (1 minus p) to the (n minus k). C(n k) is the binomial coefficient n factorial divided by k factorial times (n minus k) factorial. This calculator computes it automatically." />
        <jsp:param name="faq3q" value="What is the difference between PMF and CDF?" />
        <jsp:param name="faq3a" value="PMF gives the probability of exactly k successes P(X equals k). CDF gives the cumulative probability of at most k successes P(X less than or equal to k) which is the sum of PMF values from 0 to k. Use CDF for at most or at least questions." />
        <jsp:param name="faq4q" value="When can I use the normal approximation to binomial?" />
        <jsp:param name="faq4a" value="When np is at least 5 and n(1 minus p) is at least 5 the binomial distribution can be approximated by a normal distribution with mean np and variance np(1 minus p). Apply continuity correction by adding or subtracting 0.5 for better accuracy." />
        <jsp:param name="faq5q" value="What are the mean and variance of a binomial distribution?" />
        <jsp:param name="faq5a" value="Mean equals n times p. Variance equals n times p times (1 minus p). Standard deviation equals the square root of variance. Skewness equals (1 minus 2p) divided by the square root of n times p times (1 minus p)." />
        <jsp:param name="faq6q" value="What are real-world examples of binomial distributions?" />
        <jsp:param name="faq6a" value="Common examples include coin flips, quality control defect counts, survey yes or no responses, clinical trial outcomes, free throw success rates in basketball, and genetics where offspring inherit traits with fixed probability." />
    </jsp:include>

    <%@ include file="modern/components/math-studio-shell-head.inc.jsp" %>
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

    <% request.setAttribute("activeService", "binomial-dist"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Binomial Distribution</span>
            </nav>
            <h1>Binomial Distribution Calculator</h1>
            <p class="ms-subtitle">PMF · CDF · exact & cumulative · PMF chart</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Distribution Parameters (always visible) -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="bd-n">Number of Trials (n)</label>
                                            <input type="number" class="stat-input-text bd-input" id="bd-n" value="10" min="1" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                            <div class="tool-form-hint">Number of independent Bernoulli trials</div>
                                        </div>
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="bd-p">Probability of Success (p)</label>
                                            <input type="number" class="stat-input-text bd-input" id="bd-p" value="0.5" min="0" max="1" step="0.01" style="height:auto;padding:0.5rem 0.75rem;">
                                            <div class="tool-form-hint">Probability on each trial (0 to 1)</div>
                                        </div>
                    
                                        <hr style="border:none;border-top:1px solid var(--border);margin:0.75rem 0;">
                    
                                        <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Calculation Mode</label>
                                            <div class="stat-mode-toggle">
                                                <button type="button" class="stat-mode-btn active" id="bd-mode-exact">P(X=k)</button>
                                                <button type="button" class="stat-mode-btn" id="bd-mode-cumulative">P(X&le;k)</button>
                                                <button type="button" class="stat-mode-btn" id="bd-mode-range">Range</button>
                                            </div>
                                        </div>
                    
                                        <!-- Exact P(X = k) inputs -->
                                        <div id="bd-input-exact">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="bd-k-exact">Number of Successes (k)</label>
                                                <input type="number" class="stat-input-text bd-input" id="bd-k-exact" value="5" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">Exactly k successes out of n trials</div>
                                            </div>
                                        </div>
                    
                                        <!-- Cumulative P(X ≤ k) inputs -->
                                        <div id="bd-input-cumulative" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="bd-k-cumulative">At Most Successes (k)</label>
                                                <input type="number" class="stat-input-text bd-input" id="bd-k-cumulative" value="5" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">P(X &le; k) = sum of P(X = 0) to P(X = k)</div>
                                            </div>
                                        </div>
                    
                                        <!-- Range inputs -->
                                        <div id="bd-input-range" style="display:none;">
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="bd-range-a">Minimum Successes (a)</label>
                                                <input type="number" class="stat-input-text bd-input" id="bd-range-a" value="3" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                            </div>
                                            <div class="tool-form-group">
                                                <label class="tool-form-label" for="bd-range-b">Maximum Successes (b)</label>
                                                <input type="number" class="stat-input-text bd-input" id="bd-range-b" value="7" min="0" step="1" style="height:auto;padding:0.5rem 0.75rem;">
                                                <div class="tool-form-hint">P(a &le; X &le; b)</div>
                                            </div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="bd-calc-btn">Calculate</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="bd-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-bd-example="coin">Coin Flip</button>
                                                <button type="button" class="stat-example-chip" data-bd-example="defect">Quality Control</button>
                                                <button type="button" class="stat-example-chip" data-bd-example="survey">Survey</button>
                                                <button type="button" class="stat-example-chip" data-bd-example="medical">Clinical Trial</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-tab="bd-result-panel">Result</button>
                                <button type="button" class="stat-output-tab" data-tab="bd-graph-panel">PMF Chart</button>
                                <button type="button" class="stat-output-tab" data-tab="bd-compiler-panel">Python Compiler</button>
                            </div>
                
                            <div class="stat-panel active" id="bd-result-panel">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="bd-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F3B2;</div>
                                            <h3>Enter values and click Calculate</h3>
                                            <p>Find binomial probabilities for your parameters.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="bd-result-actions"></div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="bd-graph-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><rect x="3" y="12" width="4" height="9" rx="1"/><rect x="10" y="6" width="4" height="15" rx="1"/><rect x="17" y="2" width="4" height="19" rx="1"/></svg>
                                        <h4>Probability Mass Function</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="bd-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4CA;</div><h3>No chart yet</h3><p>Calculate to see the PMF bar chart.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <div class="stat-panel" id="bd-compiler-panel">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="bd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="binomial-distribution-calculator.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Binomial Distribution? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is the Binomial Distribution?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">The <strong>binomial distribution</strong> models the number of successes in <em>n</em> independent Bernoulli trials, each with the same success probability <em>p</em>. It answers questions like &ldquo;If I flip a coin 10 times, what&rsquo;s the probability of getting exactly 6 heads?&rdquo;</p>
        
                    <div class="stat-formula-box">
                        <strong>PMF:</strong>&nbsp; P(X = k) = C(n, k) &times; p<sup>k</sup> &times; (1 &minus; p)<sup>n&minus;k</sup>
                    </div>
        
                    <div class="stat-edu-grid" style="margin-top:1rem;">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Fixed Trials</h4>
                            <p>The number of trials <em>n</em> is fixed in advance. Each trial is independent of the others.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                            <h4>Two Outcomes</h4>
                            <p>Each trial has exactly two outcomes: success (probability <em>p</em>) or failure (probability 1 &minus; <em>p</em>).</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4CF;</div>
                            <h4>Constant Probability</h4>
                            <p>The probability of success <em>p</em> remains the same for every trial.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Key Formulas -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Key Formulas &amp; Statistics</h2>
        
                    <div class="stat-formula-box" style="margin-bottom:0.75rem;">
                        <strong>Binomial Coefficient:</strong>&nbsp; C(n, k) = n! / (k! &times; (n &minus; k)!)
                    </div>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Statistic</th><th>Formula</th><th>Example (n=10, p=0.5)</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Mean (&mu;)</td><td>n &times; p</td><td>5.0</td></tr>
                            <tr><td style="font-weight:600;">Variance (&sigma;&sup2;)</td><td>n &times; p &times; (1 &minus; p)</td><td>2.5</td></tr>
                            <tr><td style="font-weight:600;">Std Dev (&sigma;)</td><td>&radic;(n &times; p &times; (1 &minus; p))</td><td>1.5811</td></tr>
                            <tr><td style="font-weight:600;">Skewness</td><td>(1 &minus; 2p) / &sigma;</td><td>0.0 (symmetric)</td></tr>
                        </tbody>
                    </table>
        
                    <div class="stat-worked-example" style="margin-top:1rem;">
                        <strong>Worked Example:</strong> Flip a fair coin 10 times. What is P(X = 6)?
                        <div style="margin-top:0.5rem;padding-left:1rem;border-left:3px solid var(--tool-primary);color:var(--text-secondary);font-size:0.875rem;">
                            C(10, 6) = 210<br>
                            P(X = 6) = 210 &times; 0.5<sup>6</sup> &times; 0.5<sup>4</sup> = 210 &times; 0.015625 &times; 0.0625 = <strong>0.2051</strong>
                        </div>
                    </div>
                </div>
        
                <!-- 3. Normal Approximation -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Normal Approximation to Binomial</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">When <em>n</em> is large enough, the binomial distribution can be approximated by a normal distribution. This is useful for quick calculations without summing many PMF values.</p>
        
                    <div class="stat-formula-box">
                        <strong>Approximation:</strong>&nbsp; X ~ N(np, np(1 &minus; p)) &nbsp; when np &ge; 5 and n(1 &minus; p) &ge; 5
                    </div>
        
                    <p style="color:var(--text-secondary);margin-top:0.75rem;font-size:0.875rem;line-height:1.7;">Apply a <strong>continuity correction</strong> of &plusmn;0.5 for better accuracy. For example, P(X &le; k) &asymp; &Phi;((k + 0.5 &minus; np) / &radic;(np(1 &minus; p))).</p>
        
                    <!-- Animated SVG: PMF approaching normal curve -->
                    <div style="text-align:center;margin-top:1rem;" class="stat-anim stat-anim-d1">
                        <svg viewBox="0 0 400 140" style="max-width:400px;width:100%;" xmlns="http://www.w3.org/2000/svg">
                            <!-- Bars representing binomial PMF -->
                            <rect x="40" y="120" width="15" height="5" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="60" y="108" width="15" height="17" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="80" y="88" width="15" height="37" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="100" y="62" width="15" height="63" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="120" y="38" width="15" height="87" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="140" y="20" width="15" height="105" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="160" y="12" width="15" height="113" fill="rgba(225,29,72,0.6)" rx="1"/>
                            <rect x="180" y="8" width="15" height="117" fill="rgba(225,29,72,0.6)" rx="1"/>
                            <rect x="200" y="12" width="15" height="113" fill="rgba(225,29,72,0.6)" rx="1"/>
                            <rect x="220" y="20" width="15" height="105" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="240" y="38" width="15" height="87" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="260" y="62" width="15" height="63" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="280" y="88" width="15" height="37" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="300" y="108" width="15" height="17" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <rect x="320" y="120" width="15" height="5" fill="rgba(225,29,72,0.4)" rx="1"/>
                            <!-- Normal curve overlay -->
                            <path d="M 40,122 C 70,118 100,95 130,55 C 150,30 165,15 190,8 C 215,15 230,30 250,55 C 280,95 310,118 340,122" fill="none" stroke="#e11d48" stroke-width="2" stroke-dasharray="4,3" class="stat-bell-animated"/>
                            <text x="190" y="138" text-anchor="middle" fill="currentColor" font-size="10" font-family="Inter,sans-serif">n = 30, p = 0.5</text>
                        </svg>
                    </div>
                </div>
        
                <!-- 4. Real-World Applications -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Real-World Applications</h2>
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Quality Control</h4>
                            <p>Number of defective items in a batch. If defect rate is 5%, what is the probability of finding 0&ndash;2 defects in 100 items?</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Medicine &amp; Clinical Trials</h4>
                            <p>Number of patients responding to treatment. If a drug has 70% efficacy, what is P(at least 15 of 20 respond)?</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Survey &amp; Polling</h4>
                            <p>Number of &ldquo;yes&rdquo; responses in a sample. If 30% of voters support a policy, how many in a sample of 50?</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d4">
                            <h4>Sports &amp; Games</h4>
                            <p>Free throw success rates, coin tosses, dice outcomes. Classic probability scenarios modeled by binomial.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is a binomial distribution?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">A binomial distribution models the number of successes in <em>n</em> independent Bernoulli trials, each with the same success probability <em>p</em>. It is a discrete probability distribution where outcomes are counted as whole numbers from 0 to n.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I calculate P(X = k)?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use the formula P(X = k) = C(n, k) &times; p<sup>k</sup> &times; (1 &minus; p)<sup>n&minus;k</sup>, where C(n, k) is the binomial coefficient &ldquo;n choose k&rdquo;. This calculator computes it automatically with step-by-step formulas.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between PMF and CDF?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">PMF (probability mass function) gives the probability of <em>exactly</em> k successes: P(X = k). CDF (cumulative distribution function) gives the probability of <em>at most</em> k successes: P(X &le; k), which is the sum of PMF values from 0 to k.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">When can I use the normal approximation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">When np &ge; 5 and n(1 &minus; p) &ge; 5, the binomial can be approximated by N(np, np(1&minus;p)). Apply a continuity correction of &plusmn;0.5 for better accuracy.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are the mean and variance?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Mean = n &times; p. Variance = n &times; p &times; (1 &minus; p). Standard deviation = &radic;(variance). Skewness = (1 &minus; 2p) / &radic;(np(1&minus;p)). When p = 0.5, the distribution is symmetric.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What are real-world examples of binomial distributions?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Common examples include coin flips, quality control defect counts, survey yes/no responses, clinical trial outcomes, free throw success rates in basketball, and genetics where offspring inherit traits with fixed probability.</div>
                    </div>
                </div>
            </section>

        <%@ include file="modern/components/support-section.jsp" %>

    </section><!-- /.ms-workspace -->

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>
</main>

<%@ include file="modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="modern/components/analytics.jsp" %>

<%@ include file="modern/components/math-calculus-cores.inc.jsp" %>
<!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js"></script>
    <script src="<%=request.getContextPath()%>/modern/js/tool-utils.js?v=<%=v%>"></script>
            <script src="<%=request.getContextPath()%>/js/stats-export.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/js/binomial-distribution-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'binomial-dist', label: "Binomial Distribution Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

