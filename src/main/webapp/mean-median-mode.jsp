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
        <jsp:param name="toolName" value="Mean Median Mode Calculator Online - Instant Results Free" />
        <jsp:param name="toolDescription" value="Paste your data to instantly calculate mean, median, and mode with outlier detection, sorted values, interactive histogram, box plot, and Python export." />
        <jsp:param name="toolCategory" value="Math Tools" />
        <jsp:param name="toolUrl" value="mean-median-mode.jsp" />
        <jsp:param name="toolKeywords" value="mean median mode calculator, average calculator online, central tendency calculator, outlier detection, IQR calculator, histogram maker, descriptive statistics, mode finder, median calculator, free statistics tool" />
        <jsp:param name="toolImage" value="logo.png" />
        <jsp:param name="toolFeatures" value="Mean median and mode calculation,Step-by-step KaTeX formula display,Sorted values with color-coded highlights,IQR-based outlier detection,Interactive Plotly histogram and box plot,Python numpy and scipy code generation,LaTeX export and share URL,Handles bimodal and multimodal data" />
        <jsp:param name="teaches" value="Central tendency, mean vs median vs mode, outlier detection, IQR method, frequency distribution, data analysis basics" />
        <jsp:param name="educationalLevel" value="Middle School, High School, College" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Enter Data|Paste numbers separated by commas spaces or newlines,Click Calculate|Get instant mean median and mode results,Review Steps|See step-by-step formulas with KaTeX rendering,Check Outliers|View IQR-based outlier detection with fences,Explore Charts|See interactive histogram and box plot,Export Results|Copy LaTeX share URL or run Python code" />
        <jsp:param name="faq1q" value="When should I use the mean vs the median?" />
        <jsp:param name="faq1a" value="Use the mean for symmetric data without outliers since it uses all values efficiently. Use the median for skewed data or data with outliers since it is resistant to extreme values. For example, median household income is preferred over mean because a few billionaires skew the average upward." />
        <jsp:param name="faq2q" value="What if there are multiple modes?" />
        <jsp:param name="faq2a" value="Data can be bimodal (two modes) or multimodal (many modes). Our calculator reports all values that share the highest frequency. If every value appears equally often there is no mode. Bimodal data often suggests two distinct groups in your dataset." />
        <jsp:param name="faq3q" value="How do outliers affect mean median and mode?" />
        <jsp:param name="faq3a" value="Outliers strongly pull the mean toward extreme values but have limited impact on the median and no effect on the mode. This is why the median is preferred for skewed distributions. The IQR method flags values below Q1 minus 1.5 times IQR or above Q3 plus 1.5 times IQR as outliers." />
        <jsp:param name="faq4q" value="What is the difference between mean median and mode?" />
        <jsp:param name="faq4a" value="The mean is the arithmetic average (sum divided by count). The median is the middle value when data is sorted. The mode is the most frequently occurring value. For symmetric data all three are similar. For skewed data they diverge with the mean pulled toward the tail." />
        <jsp:param name="faq5q" value="Can a dataset have no mode?" />
        <jsp:param name="faq5a" value="Yes. If every value in the dataset appears exactly once or all values appear with equal frequency then there is no mode. This is common with continuous data or small samples where repeats are unlikely." />
        <jsp:param name="faq6q" value="How are quartiles calculated?" />
        <jsp:param name="faq6a" value="Sort the data then split into two halves. Q1 is the median of the lower half and Q3 is the median of the upper half. The IQR (interquartile range) is Q3 minus Q1 and represents the spread of the middle 50 percent of your data." />
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

    <% request.setAttribute("activeService", "mean-median-mode"); %>
    <jsp:include page="/math/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <header class="ms-title">
            <nav class="ms-crumbs">
                <a href="<%=request.getContextPath()%>/index.jsp">Home</a>
                <span>/</span>
                <a href="<%=request.getContextPath()%>/math/">Math</a>
                <span>/</span>
                <span aria-current="page">Mean / Median / Mode</span>
            </nav>
            <h1>Mean, Median & Mode Calculator</h1>
            <p class="ms-subtitle">Central tendency · frequency table · step-by-step</p>
        </header>

        <div class="ic-stack">

            <div class="ic-hero ic-hero--compact stat-hero" id="stat-hero">
                <div class="ic-hero-top">
                    <button type="button" class="math-ai-tab-btn" id="btnMathAI" title="Math AI — statistics tutor + full math router in chat (Ctrl+Shift+A)">&#10024; AI</button>
                </div>
                <div class="stat-hero-core">
                    <!-- Data Input -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label" for="mmm-data-input">Data Input</label>
                                            <textarea class="stat-input-text" id="mmm-data-input" rows="7" placeholder="12, 15, 15, 21, 28, 35, 35, 35, 42" spellcheck="false">72, 85, 90, 65, 78, 92, 88, 76, 95, 82, 87, 91, 68, 84, 79, 85, 90, 85</textarea>
                                            <div class="tool-form-hint">Enter numbers separated by commas, spaces, or newlines</div>
                                        </div>
                    
                                        <!-- Preview -->
                                        <div class="tool-form-group">
                                            <div class="stat-preview" id="mmm-preview"><span style="color:var(--text-muted);">Enter data above&hellip;</span></div>
                                        </div>
                    
                                        <!-- Buttons -->
                                        <button type="button" class="tool-action-btn" id="mmm-calc-btn">Calculate Mean, Median, Mode</button>
                                        <div style="display:flex;gap:0.5rem;margin-top:0.5rem;">
                                            <button type="button" class="tool-action-btn" id="mmm-random-btn" style="background:var(--bg-secondary);color:var(--tool-primary);border:1.5px solid var(--tool-primary);flex:1;">&#x1F3B2; Random</button>
                                            <button type="button" class="tool-action-btn" id="mmm-clear-btn" style="background:var(--bg-secondary);color:var(--text-secondary);border:1px solid var(--border);flex:1;">Clear</button>
                                        </div>
                    
                                        <hr class="stat-sep">
                    
                                        <!-- Quick Examples -->
                                        <div class="tool-form-group">
                                            <label class="tool-form-label">Quick Examples</label>
                                            <div class="stat-examples">
                                                <button type="button" class="stat-example-chip" data-example="test-scores">Test Scores</button>
                                                <button type="button" class="stat-example-chip" data-example="shoe-sizes">Shoe Sizes</button>
                                                <button type="button" class="stat-example-chip" data-example="temperatures">Temperatures</button>
                                                <button type="button" class="stat-example-chip" data-example="dice-rolls">Dice Rolls</button>
                                                <button type="button" class="stat-example-chip" data-example="with-outliers">With Outliers</button>
                                            </div>
                                        </div>
                                    </div>
                </div>
            </div>

            <div class="ic-result-card">
                <div class="stat-output-tabs">
                                <button type="button" class="stat-output-tab active" data-panel="result">Result</button>
                                <button type="button" class="stat-output-tab" data-panel="graph">Graph</button>
                                <button type="button" class="stat-output-tab" data-panel="python">Python Compiler</button>
                            </div>
                
                            <!-- Result Panel -->
                            <div class="stat-panel active" id="mmm-panel-result">
                                <div class="tool-card tool-result-card">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
                                        <h4>Result</h4>
                                    </div>
                                    <div class="tool-result-content" id="mmm-result-content">
                                        <div class="tool-empty-state">
                                            <div style="font-size:2.5rem;margin-bottom:0.75rem;opacity:0.5;">&#x1F4CA;</div>
                                            <h3>Enter data and click Calculate</h3>
                                            <p>Paste numbers to find mean, median, mode with step-by-step solution.</p>
                                        </div>
                                    </div>
                                    <div class="tool-result-actions" id="mmm-result-actions"></div>
                                </div>
                            </div>
                
                            <!-- Graph Panel -->
                            <div class="stat-panel" id="mmm-panel-graph">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
                                        <h4>Histogram &amp; Box Plot</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;padding:0.75rem;overflow-y:auto;" id="mmm-graph-content">
                                        <div class="tool-empty-state"><div style="font-size:2rem;opacity:0.5;">&#x1F4C8;</div><h3>No graph yet</h3><p>Calculate to see histogram and box plot.</p></div>
                                    </div>
                                </div>
                            </div>
                
                            <!-- Python Compiler Panel -->
                            <div class="stat-panel" id="mmm-panel-python">
                                <div class="tool-card" style="height:100%;display:flex;flex-direction:column;">
                                    <div class="tool-result-header">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:18px;height:18px;flex-shrink:0;color:var(--tool-primary);"><polygon points="5 3 19 12 5 21 5 3"/></svg>
                                        <h4>Python Compiler</h4>
                                    </div>
                                    <div style="flex:1;min-height:0;">
                                        <iframe id="mmm-compiler-iframe" loading="lazy" style="width:100%;height:100%;min-height:480px;border:none;display:block;"></iframe>
                                    </div>
                                </div>
                            </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

<jsp:include page="modern/components/related-tools.jsp">
<jsp:param name="currentToolUrl" value="mean-median-mode.jsp"/>
        <jsp:param name="keyword" value="statistics"/>
        <jsp:param name="limit" value="6"/>
</jsp:include>

        <section class="tool-expertise-section ms-below-fold" style="max-width:1200px;margin:2rem auto;padding:0 1rem;">
        
                <!-- 1. What Are Mean, Median, and Mode? -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">What Are Mean, Median, and Mode?</h2>
                    <p style="color:var(--text-secondary);margin-bottom:1rem;line-height:1.7;">Mean, median, and mode are the three <strong>measures of central tendency</strong> &mdash; they each describe the &ldquo;center&rdquo; of a dataset in different ways. Understanding when to use each one is a fundamental skill in statistics.</p>
        
                    <div class="stat-edu-grid">
                        <div class="stat-feature-card stat-anim stat-anim-d1">
                            <div style="font-size:1.5rem;">&#x2795;</div>
                            <h4>Mean (Average)</h4>
                            <p>Sum all values, divide by count. Uses every data point. Sensitive to outliers.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d2">
                            <div style="font-size:1.5rem;">&#x1F3AF;</div>
                            <h4>Median (Middle)</h4>
                            <p>Sort data, pick the middle value. Robust to outliers. Best for skewed data.</p>
                        </div>
                        <div class="stat-feature-card stat-anim stat-anim-d3">
                            <div style="font-size:1.5rem;">&#x1F4CA;</div>
                            <h4>Mode (Most Frequent)</h4>
                            <p>The value that appears most often. Works for categorical data too. May not be unique.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 2. Formulas & Definitions -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Formulas &amp; Definitions</h2>
        
                    <div class="stat-formula-box">
                        <strong>Mean:</strong>&nbsp; x&#772; = &Sigma;x<sub>i</sub> / n
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">The <strong>arithmetic mean</strong> sums all values and divides by the count. It is the balance point of the data and uses every value in the calculation.</p>
        
                    <div class="stat-formula-box">
                        <strong>Median:</strong>&nbsp; Middle value of sorted data; for even n, average of two middle values
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 0.75rem;line-height:1.7;">Sort the data from smallest to largest. If n is odd, the median is x<sub>((n+1)/2)</sub>. If n is even, it is the average of x<sub>(n/2)</sub> and x<sub>(n/2+1)</sub>.</p>
        
                    <div class="stat-formula-box">
                        <strong>Mode:</strong>&nbsp; Value(s) with the highest frequency
                    </div>
                    <p style="color:var(--text-secondary);margin:0.5rem 0 1rem;line-height:1.7;">Count how often each value appears. The mode is the one with the highest count. Data can be <strong>unimodal</strong> (one mode), <strong>bimodal</strong> (two), <strong>multimodal</strong> (many), or have <strong>no mode</strong> (all equally frequent).</p>
        
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">Worked Example</h3>
                    <div class="stat-worked-example">
                        <strong>Data:</strong> [3, 7, 7, 12, 15, 20, 25]<br>
                        <strong>Mean:</strong> (3+7+7+12+15+20+25)/7 = 89/7 = <span style="color:var(--stat-tool);font-weight:700;">12.714</span><br>
                        <strong>Median:</strong> 7 values &rarr; middle = x<sub>4</sub> = <span style="color:var(--stat-tool);font-weight:700;">12</span><br>
                        <strong>Mode:</strong> 7 appears twice (most frequent) &rarr; <span style="color:var(--stat-tool);font-weight:700;">7</span>
                    </div>
                </div>
        
                <!-- 3. When to Use Which -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">When to Use Which Measure</h2>
        
                    <table class="stat-ops-table">
                        <thead><tr><th>Measure</th><th>Best For</th><th>Weakness</th><th>Example</th></tr></thead>
                        <tbody>
                            <tr><td style="font-weight:600;">Mean</td><td>Symmetric data, no outliers</td><td>Pulled by extreme values</td><td>Average test score in a class</td></tr>
                            <tr><td style="font-weight:600;">Median</td><td>Skewed data, outliers present</td><td>Ignores actual extreme values</td><td>Median household income</td></tr>
                            <tr><td style="font-weight:600;">Mode</td><td>Categorical data, finding peaks</td><td>May not exist or be unique</td><td>Most popular shoe size</td></tr>
                        </tbody>
                    </table>
        
                    <!-- Visual: effect of outlier on mean vs median -->
                    <h3 style="font-size:1rem;margin:1.25rem 0 0.5rem;color:var(--text-primary);">How Outliers Affect the Mean</h3>
                    <svg viewBox="0 0 560 100" xmlns="http://www.w3.org/2000/svg" style="max-width:540px;width:100%;margin:0.5rem 0;">
                        <rect x="0" y="0" width="560" height="100" rx="8" fill="var(--bg-secondary,#f8fafc)"/>
                        <!-- Number line -->
                        <line x1="40" y1="50" x2="520" y2="50" stroke="var(--border-dark,#cbd5e1)" stroke-width="1.5"/>
                        <!-- Data points (clustered) -->
                        <circle cx="120" cy="50" r="5" fill="#e11d48"/><circle cx="145" cy="50" r="5" fill="#e11d48"/>
                        <circle cx="160" cy="50" r="5" fill="#e11d48"/><circle cx="180" cy="50" r="5" fill="#e11d48"/>
                        <circle cx="195" cy="50" r="5" fill="#e11d48"/><circle cx="210" cy="50" r="5" fill="#e11d48"/>
                        <!-- Outlier -->
                        <circle cx="480" cy="50" r="6" fill="none" stroke="#ef4444" stroke-width="2"/>
                        <text x="480" y="30" text-anchor="middle" font-size="9" fill="#ef4444" font-weight="600">Outlier</text>
                        <!-- Median marker -->
                        <line x1="170" y1="60" x2="170" y2="80" stroke="#10b981" stroke-width="2"/>
                        <text x="170" y="93" text-anchor="middle" font-size="9" fill="#10b981" font-weight="600">Median</text>
                        <!-- Mean marker (pulled right by outlier) -->
                        <line x1="250" y1="60" x2="250" y2="80" stroke="#f59e0b" stroke-width="2"/>
                        <text x="250" y="93" text-anchor="middle" font-size="9" fill="#f59e0b" font-weight="600">Mean &rarr;</text>
                    </svg>
                    <p style="color:var(--text-secondary);font-size:0.8125rem;line-height:1.6;">The outlier pulls the <span style="color:#f59e0b;font-weight:600;">mean</span> to the right, while the <span style="color:#10b981;font-weight:600;">median</span> stays near the cluster of data points.</p>
                </div>
        
                <!-- 4. Understanding Outliers -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;color:var(--text-primary);">Understanding Outlier Detection</h2>
        
                    <div class="stat-formula-box">
                        <strong>IQR Method:</strong>&nbsp; Outlier if value &lt; Q1 &minus; 1.5&times;IQR &nbsp;or&nbsp; value &gt; Q3 + 1.5&times;IQR
                    </div>
        
                    <p style="color:var(--text-secondary);margin:0.75rem 0;line-height:1.7;">The <strong>IQR (Interquartile Range)</strong> method is the most common approach for outlier detection. It uses the spread of the middle 50% of data (Q1 to Q3) to define &ldquo;fences&rdquo; beyond which values are considered unusually extreme.</p>
        
                    <div class="stat-edu-grid">
                        <div class="stat-edu-card stat-anim stat-anim-d1">
                            <h4>Don&rsquo;t Auto-Remove</h4>
                            <p>Outliers may be real data (e.g., a CEO&rsquo;s salary). Always investigate before removing them.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d2">
                            <h4>Report Both Measures</h4>
                            <p>When outliers exist, report both mean and median to give a complete picture of the data.</p>
                        </div>
                        <div class="stat-edu-card stat-anim stat-anim-d3">
                            <h4>Alternative Methods</h4>
                            <p>Z-score method (|z| &gt; 2 or 3), modified Z-score, Grubbs&rsquo; test, or visual inspection with box plots.</p>
                        </div>
                    </div>
                </div>
        
                <!-- 5. FAQ -->
                <div class="tool-card stat-anim" style="padding:2rem;margin-bottom:1.5rem;">
                    <h2 style="font-size:1.25rem;margin-bottom:1rem;" id="faqs">Frequently Asked Questions</h2>
                    <div class="faq-item">
                        <button class="faq-question">When should I use the mean vs the median?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Use the mean for symmetric data without outliers &mdash; it uses all values efficiently. Use the median for skewed data or data with outliers &mdash; it is resistant to extreme values. For example, median household income is preferred over mean income because a few billionaires skew the average upward.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What if there are multiple modes?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Data can be bimodal (two modes) or multimodal (many modes). Our calculator reports all values that share the highest frequency. If every value appears equally often, there is no mode. Bimodal data often suggests two distinct groups in your dataset.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How do outliers affect mean, median, and mode?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Outliers strongly pull the mean toward extreme values but have limited impact on the median and no effect on the mode. This is why the median is preferred for skewed distributions. The IQR method flags values below Q1 &minus; 1.5&times;IQR or above Q3 + 1.5&times;IQR as outliers.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">What is the difference between mean, median, and mode?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">The mean is the arithmetic average (sum divided by count). The median is the middle value when data is sorted. The mode is the most frequently occurring value. For symmetric data all three are similar. For skewed data they diverge, with the mean pulled toward the tail.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">Can a dataset have no mode?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Yes. If every value in the dataset appears exactly once, or all values appear with equal frequency, then there is no mode. This is common with continuous data or small samples where repeats are unlikely.</div>
                    </div>
                    <div class="faq-item">
                        <button class="faq-question">How are quartiles calculated?<svg class="faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="width:16px;height:16px;"><polyline points="6 9 12 15 18 9"/></svg></button>
                        <div class="faq-answer">Sort the data, then split into two halves. Q1 is the median of the lower half and Q3 is the median of the upper half. The IQR (interquartile range) is Q3 &minus; Q1 and represents the spread of the middle 50% of your data.</div>
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
    <script src="<%=request.getContextPath()%>/js/mean-median-mode-core.js?v=<%=v%>"></script>
    <script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/categories-menu.js" defer></script>
    <script src="<%=request.getContextPath()%>/modern/js/search.js?v=<%=v%>" defer></script>

<script>window.__MS_STAT_PAGE__ = { key: 'mean-median-mode', label: "Mean, Median & Mode Calculator" };</script>
<%
    request.setAttribute("mathAiButtonId", "btnMathAI");
    request.setAttribute("mathAiProfile", "/modern/js/ai/adapters/math-profiles/generic-calculus.js");
    request.setAttribute("mathAiProfileExport", "configureStatisticsMathShell");
%>
<%@ include file="modern/components/math-ai-boot.inc.jsp" %>
</body>
</html>

