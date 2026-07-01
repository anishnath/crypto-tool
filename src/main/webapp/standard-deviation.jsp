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
        <jsp:param name="toolName" value="Standard Deviation Calculator Online - Sample &amp; Population SD Free" />
        <jsp:param name="toolDescription" value="Paste your data to instantly calculate standard deviation, variance, and mean with sample or population toggle. Interactive bell curve, step-by-step formulas, and Python export included." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="standard-deviation.jsp" />
        <jsp:param name="toolKeywords" value="standard deviation calculator, sd calculator online, variance calculator, population standard deviation, sample standard deviation, bell curve calculator, normal distribution, standard deviation formula, 68-95-99.7 rule, free statistics calculator" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Sample and population standard deviation,Variance calculation with Bessel correction,Step-by-step formula breakdown with KaTeX,Interactive Plotly bell curve with sigma markers,68-95-99.7 empirical rule display,Python numpy and scipy code generation,LaTeX export and share URL,Coefficient of variation and SEM" />
        <jsp:param name="teaches" value="Standard deviation, variance, sample vs population statistics, normal distribution, empirical rule, measures of dispersion" />
        <jsp:param name="educationalLevel" value="High School, College, University" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Choose Mode|Toggle between sample (n-1) and population (n),Click Calculate|Get instant standard deviation and variance,Review Steps|See step-by-step formula with KaTeX rendering,View Bell Curve|Explore the interactive normal distribution graph,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="What is standard deviation?" />
        <jsp:param name="faq1a" value="Standard deviation measures how spread out data values are from the mean. A low SD means data points cluster near the mean while a high SD means they are spread over a wider range. It is the square root of variance and is expressed in the same units as the original data." />
        <jsp:param name="faq2q" value="What is the difference between sample and population standard deviation?" />
        <jsp:param name="faq2a" value="Sample standard deviation (s) divides by n-1 using Bessel correction because a sample underestimates the true variability. Population standard deviation (sigma) divides by n because you have every data point. Use sample SD when analyzing a subset and population SD when you have the complete dataset." />
        <jsp:param name="faq3q" value="What does the 68-95-99.7 rule mean?" />
        <jsp:param name="faq3a" value="For normally distributed data about 68.3 percent falls within one standard deviation of the mean, 95.4 percent within two, and 99.7 percent within three. This empirical rule helps you quickly assess how unusual a value is based on how many standard deviations it is from the mean." />
        <jsp:param name="faq4q" value="How do I interpret a high or low standard deviation?" />
        <jsp:param name="faq4a" value="Standard deviation is relative to your data. Compare it using the coefficient of variation (CV = SD/mean x 100). A CV below 15 percent indicates low variability. A CV above 30 percent indicates high variability. Always consider the context and units of your data when interpreting SD." />
        <jsp:param name="faq5q" value="Why divide by n-1 instead of n for sample standard deviation?" />
        <jsp:param name="faq5a" value="Dividing by n-1 is called Bessel correction. When computing from a sample the mean is estimated from the same data which constrains one degree of freedom. Dividing by n-1 corrects this bias giving an unbiased estimate of the population variance. With large samples the difference is negligible." />
        <jsp:param name="faq6q" value="What is the relationship between variance and standard deviation?" />
        <jsp:param name="faq6a" value="Variance is the average of squared deviations from the mean. Standard deviation is the square root of variance. SD is preferred for interpretation because it has the same units as the data while variance is in squared units. Both measure data spread but SD is more intuitive for most applications." />
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

    <% request.setAttribute("activeService", "stddev"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Standard Deviation</span>
            </nav>
            <h1>Standard Deviation Calculator</h1>
            <p class="ms-subtitle">Sample & population σ · bell curve · deviation table</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Mode Toggle -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Mode</label>
                                            <div class="stat-mode-toggle">
                                                <button type="button" class="stat-mode-btn active" id="sd-mode-sample">Sample (s)</button>
                                                <button type="button" class="stat-mode-btn" id="sd-mode-population">Population (&sigma;)</button>
                                            </div>
                                            <div class="tool-form-hint">Sample divides by n&minus;1 (Bessel correction); population divides by n</div>
                                        </div>
                    
                                        <!-- Data Input -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="sd-data-input">Data Input</label>
                                            <textarea class="stat-input-text" id="sd-data-input" rows="7" placeholder="72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79" spellcheck="false">72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79</textarea>
                                            <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                                        </div>
                    
                                        <!-- Preview -->
                                        <div class="tool-form-group">
                                            <div class="stat-preview" id="sd-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="sd-calc-btn">Calculate Standard Deviation</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="sd-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                                            <button type="button" class="tool-action-btn" id="sd-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="exam-scores">Exam Scores</button>
                                                <button type="button" class="stat-example-chip" data-example="measurements">Measurements</button>
                                                <button type="button" class="stat-example-chip" data-example="daily-temps">Daily Temps</button>
                                                <button type="button" class="stat-example-chip" data-example="reaction-times">Reaction Times</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-panel="result">Result</button>
                                <button type="button" class="stat-output-tab" data-panel="graph">Bell Curve</button>
                                <button type="button" class="stat-output-tab" data-panel="python">Python Compiler</button>
                            </div>
                
                            <!-- Result Panel -->
                            <div class="stat-panel active" id="sd-panel-result">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="sd-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4C9;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Paste numbers to compute standard deviation with step-by-step solution.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="sd-result-actions"></div>
                                </div>
                            </div>
                
                            <!-- Graph Panel -->
                            <div class="stat-panel" id="sd-panel-graph">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><path d="M2 20h20"/><path d="M5 20V10l4-7 3 4 3-4 4 7v10"/></svg>
                                        <h4>Bell Curve (Normal Distribution)</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="sd-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see the bell curve.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <!-- Python Compiler Panel -->
                            <div class="stat-panel" id="sd-panel-python">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="sd-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="standard-deviation.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Is Standard Deviation? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Is Standard Deviation?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;"><strong>Standard deviation</strong> is a measure of how spread out data values are from their mean. A <em>low</em> standard deviation means data points cluster close to the mean, while a <em>high</em> standard deviation means they are spread over a wider range. It is the most commonly used measure of dispersion in statistics.</p>
        
                    <div class="stat-edu-grid">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x1F4CF;</div>
                            <h4>Same Units as Data</h4>
                            <p>Unlike variance (squared units), SD is in the same units as your data, making it directly interpretable.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F514;</div>
                            <h4>Bell Curve Foundation</h4>
                            <p>SD defines the shape of the normal distribution &mdash; wider curves have larger SD values.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x2696;&#xFE0F;</div>
                            <h4>Sample vs Population</h4>
                            <p>Use s (n&minus;1) for samples from a larger group; use &sigma; (n) when you have the complete dataset.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. The Standard Deviation Formula -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The Standard Deviation Formula</h2>
        
                    <div class="stat-formula-box">
                        <strong>Sample SD:</strong>&nbsp; s = &radic;[ &Sigma;(x<sub>i</sub> &minus; x&#772;)&sup2; / (n &minus; 1) ]
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">Divides by <strong>n &minus; 1</strong> (Bessel&rsquo;s correction) to give an unbiased estimate of the population variance from a sample.</p>
        
                    <div class="stat-formula-box">
                        <strong>Population SD:</strong>&nbsp; &sigma; = &radic;[ &Sigma;(x<sub>i</sub> &minus; &mu;)&sup2; / n ]
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 1rem;line-height:1.7;">Divides by <strong>n</strong> because when you have the entire population, there is no need for correction.</p>
        
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Step-by-Step Worked Example</h3>
                    <div class="stat-worked-example">
                        <strong>Data:</strong> [4, 8, 6, 5, 3, 7, 8, 1]<br>
                        <strong>Step 1:</strong> Mean = (4+8+6+5+3+7+8+1)/8 = 42/8 = <span style="color:var(--stat-tool);font-weight:700;">5.25</span><br>
                        <strong>Step 2:</strong> Deviations: &minus;1.25, 2.75, 0.75, &minus;0.25, &minus;2.25, 1.75, 2.75, &minus;3.75<br>
                        <strong>Step 3:</strong> Squared: 1.5625, 7.5625, 0.5625, 0.0625, 5.0625, 3.0625, 7.5625, 14.0625<br>
                        <strong>Step 4:</strong> Sum of squares = 39.5<br>
                        <strong>Step 5 (sample):</strong> s&sup2; = 39.5 / 7 = <span style="color:var(--stat-tool);font-weight:700;">5.6429</span><br>
                        <strong>Step 6:</strong> s = &radic;5.6429 = <span style="color:var(--stat-tool);font-weight:700;">2.3755</span>
                    </div>
                </div>
        
                <!-- 3. The 68-95-99.7 Rule -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">The 68&ndash;95&ndash;99.7 Rule (Empirical Rule)</h2>
                    <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">For <strong>normally distributed</strong> data, the standard deviation determines how much data falls within specific ranges around the mean:</p>
        
                    <svg viewBox="0 0 560 180" xmlns="http://www.w3.org/2000/svg" class="stat-bell-animated" style="max-width:540px;width:100%;margin:0.5rem 0 1rem;">
                        <rect x="0" y="0" width="560" height="180" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                        <path class="bell-path" d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150" fill="none" stroke="#e11d48" stroke-width="2.5"/>
                        <path d="M 40,150 C 40,150 80,148 120,140 C 160,130 190,100 220,65 C 240,42 260,22 280,15 C 300,22 320,42 340,65 C 370,100 400,130 440,140 C 480,148 520,150 520,150 Z" fill="rgba(225,29,72,0.08)"/>
                        <line x1="280" y1="15" x2="280" y2="155" stroke="#94a3b8" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="180" y1="80" x2="180" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="380" y1="80" x2="380" y2="155" stroke="#10b981" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="100" y1="142" x2="100" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="460" y1="142" x2="460" y2="155" stroke="#f59e0b" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="50" y1="149" x2="50" y2="155" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3"/>
                        <line x1="510" y1="149" x2="510" y2="155" stroke="#ef4444" stroke-width="1" stroke-dasharray="4,3"/>
                        <text x="280" y="172" text-anchor="middle" font-size="9" fill="var(--text-muted,#94a3b8)">&mu;</text>
                        <text x="180" y="172" text-anchor="middle" font-size="9" fill="#10b981">&minus;1&sigma;</text>
                        <text x="380" y="172" text-anchor="middle" font-size="9" fill="#10b981">+1&sigma;</text>
                        <text x="100" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">&minus;2&sigma;</text>
                        <text x="460" y="172" text-anchor="middle" font-size="9" fill="#f59e0b">+2&sigma;</text>
                        <text x="50" y="172" text-anchor="middle" font-size="9" fill="#ef4444">&minus;3&sigma;</text>
                        <text x="510" y="172" text-anchor="middle" font-size="9" fill="#ef4444">+3&sigma;</text>
                        <text x="280" y="98" text-anchor="middle" font-size="11" fill="#10b981" font-weight="600">68.3%</text>
                        <text x="280" y="130" text-anchor="middle" font-size="10" fill="#f59e0b" font-weight="500">95.4%</text>
                        <text x="280" y="148" text-anchor="middle" font-size="9" fill="#ef4444" font-weight="500">99.7%</text>
                    </svg>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Range</th><th>Coverage</th><th>Meaning</th></tr></thead>
                        <tbody>
                            <tr><td>&mu; &plusmn; 1&sigma;</td><td style="font-family:var(--font-sans);font-weight:600;color:var(--stat-tool);">68.3%</td><td>About two-thirds of all values</td></tr>
                            <tr><td>&mu; &plusmn; 2&sigma;</td><td style="font-family:var(--font-sans);font-weight:600;color:var(--stat-tool);">95.4%</td><td>Nearly all values &mdash; outliers are rare</td></tr>
                            <tr><td>&mu; &plusmn; 3&sigma;</td><td style="font-family:var(--font-sans);font-weight:600;color:var(--stat-tool);">99.7%</td><td>Virtually all values &mdash; beyond is extremely rare</td></tr>
                        </tbody>
                    </table>
                </div>
        
                <!-- 4. Sample vs Population -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Sample vs Population: When to Use Which</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th></th><th>Sample</th><th>Population</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Symbol</td><td>s</td><td>&sigma;</td></tr>
                            <tr><td style="font-weight:600;">Divisor</td><td>n &minus; 1</td><td>n</td></tr>
                            <tr><td style="font-weight:600;">Use when</td><td>Analyzing a subset of a larger group</td><td>You have every data point in the group</td></tr>
                            <tr><td style="font-weight:600;">Example</td><td>Survey of 500 voters from millions</td><td>Final grades of all 30 students in a class</td></tr>
                            <tr><td style="font-weight:600;">Bias</td><td>Corrected (unbiased estimate)</td><td>Exact (no estimation needed)</td></tr>
                        </tbody>
                    </table>
        
                    <p style="color:var(--text-secondary);margin:1rem 0 0;line-height:1.7;"><strong>Bessel&rsquo;s correction</strong> (n&minus;1) exists because the sample mean is calculated from the same data, reducing degrees of freedom by one. This causes the sample variance to underestimate the true variance if you divide by n. Dividing by n&minus;1 corrects this bias. For large samples (n &gt; 30), the difference becomes negligible.</p>
                </div>
        
                <!-- 5. Interpreting Standard Deviation -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Interpreting Standard Deviation</h2>
                    <p style="color:var(--text-secondary);margin-bottom:0.75rem;line-height:1.7;">Standard deviation alone doesn&rsquo;t tell you if variability is &ldquo;high&rdquo; or &ldquo;low&rdquo; &mdash; it depends on context. Use the <strong>Coefficient of Variation (CV)</strong> to compare relative spread:</p>
        
                    <div class="stat-formula-box">
                        <strong>CV:</strong>&nbsp; CV = (s / x&#772;) &times; 100%
                    </div>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Low Variability (CV &lt; 15%)</h4>
                            <p>Data points are tightly clustered around the mean. Common in precise measurements and controlled experiments.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Moderate (15% &le; CV &le; 30%)</h4>
                            <p>Typical spread seen in many natural and social science datasets. Generally acceptable variability.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>High Variability (CV &gt; 30%)</h4>
                            <p>Data is widely spread. Common in financial returns, biological variation, and heterogeneous populations.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 6. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">What is standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Standard deviation measures how spread out data values are from the mean. A low SD means data points cluster near the mean while a high SD means they are spread over a wider range. It is the square root of variance and is expressed in the same units as the original data.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between sample and population standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Sample standard deviation (s) divides by n&minus;1 using Bessel&rsquo;s correction because a sample underestimates the true variability. Population standard deviation (&sigma;) divides by n because you have every data point. Use sample SD when analyzing a subset and population SD when you have the complete dataset.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What does the 68-95-99.7 rule mean?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">For normally distributed data, about 68.3% falls within one standard deviation of the mean, 95.4% within two, and 99.7% within three. This empirical rule helps you quickly assess how unusual a value is based on how many standard deviations it is from the mean.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do I interpret a high or low standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Standard deviation is relative to your data. Compare it using the coefficient of variation (CV = SD/mean &times; 100%). A CV below 15% indicates low variability. A CV above 30% indicates high variability. Always consider the context and units of your data when interpreting SD.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Why divide by n&minus;1 instead of n for sample standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Dividing by n&minus;1 is called Bessel&rsquo;s correction. When computing from a sample, the mean is estimated from the same data, which constrains one degree of freedom. Dividing by n&minus;1 corrects this bias, giving an unbiased estimate of the population variance. With large samples (n &gt; 30), the difference is negligible.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the relationship between variance and standard deviation?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Variance is the average of squared deviations from the mean. Standard deviation is the square root of variance. SD is preferred for interpretation because it has the same units as the data, while variance is in squared units. Both measure data spread, but SD is more intuitive for most applications.</div>
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
    <script src="<%=request.getContextPath()%>/js/standard-deviation-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'stddev', label: "Standard Deviation Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

