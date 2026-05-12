<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Cyclical Encoding Visualizer — sin/cos on the Unit Circle" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="See why hour, month, and day-of-week features need sin/cos encoding. Drag the value around the unit circle and watch raw-numeric vs cyclical encoding compete on regression and classification — live R², MAE, accuracy, and F1." />
        <jsp:param name="toolUrl" value="cyclical_encoding_visualizer.jsp" />
        <jsp:param name="toolImage" value="cyclical-encoding-og.png" />
        <jsp:param name="toolKeywords" value="cyclical encoding, sin cos feature, hour feature engineering, day of week encoding, periodic features, unit circle features, feature engineering, time features sklearn, one hot vs sin cos" />
        <jsp:param name="toolFeatures" value="Drag value on unit circle (cos θ, sin θ),Four feature presets: hour / month / day-of-week / angle,Compare raw numeric vs sin/cos vs one-hot vs both,Three models: linear / tree-binning / kNN with cyclic distance,Live R², MAE, accuracy, F1,Sin/cos feature importance bars,Adjustable period and noise,Model size vs performance bar chart" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a feature|hour, month, day-of-week, or angle — each has its own natural period,Drag the value|Watch the dot wrap around the circle. Notice 23 and 0 are neighbours on the hour circle but far apart as integers,Switch model and task|Compare linear / tree / kNN on regression or classification — sin/cos wins almost everywhere except trees,Read the importance bars|Sin- and cos-weight magnitudes show which axis the model leans on for the current period" />
        <jsp:param name="faq1q" value="Why encode cyclical features with sin and cos?" />
        <jsp:param name="faq1a" value="A raw integer treats 23 and 0 as 23 apart, but on the hour clock they're neighbours. Mapping the value to (cos θ, sin θ) with θ = 2π·x/period preserves cyclic geometry — close points on the cycle stay close in the encoded space. Linear models and distance-based learners (kNN, k-means, SVMs with RBF) benefit immediately." />
        <jsp:param name="faq2q" value="When can I skip sin/cos encoding?" />
        <jsp:param name="faq2a" value="Tree-based models (decision trees, random forests, gradient boosting) handle splits on raw integers fine — they don't care about smoothness. If you only ever feed the feature into trees, sin/cos doesn't help much. For everything else (linear regression, logistic regression, neural nets, kNN, k-means), encode it." />
        <jsp:param name="faq3q" value="Is one-hot encoding a good alternative?" />
        <jsp:param name="faq3a" value="One-hot works but explodes the feature count for high-period values (one-hot of hour = 24 features, day-of-year = 365). It also throws away ordering — model can't tell 0 and 1 are adjacent. Sin/cos compresses the same information into 2 features while keeping the cyclic structure. Use one-hot only when the period is very small (e.g., 7 weekdays) AND ordering really doesn't matter." />
        <jsp:param name="faq4q" value="Do I always need just sin and cos, or sometimes higher harmonics?" />
        <jsp:param name="faq4a" value="For most use cases, sin and cos at the base frequency are enough. For richer periodic targets (multiple peaks per cycle), add second-harmonic features: sin(2θ), cos(2θ). This is exactly what Fourier features do. In practice though, if your target needs many harmonics, you probably want a smoother model (GAM, GP, NN) rather than more hand-crafted features." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/cyclical-encoding.css?v=<%=v%>">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

    <%@ include file="modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="modern/components/nav-header.jsp" />
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open ML demos menu">
        &#9776; ML demos
    </button>

    <% request.setAttribute("activeService", "cyclical-encoding"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Hero -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Cyclical features, <em style="font-style:italic;color:#d97706;">on the circle</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Feature Engineering &middot; Cyclical Encoding
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#d97706;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(245,158,11,0.10);">Feature Engineering</span>
            </div>
            <p style="margin:0.85rem 0 0;color:var(--ms-ink-soft);font:0.92rem/1.55 var(--ms-font-sans);max-width:72ch;">
                Raw integers treat <code>hour=23</code> and <code>hour=0</code> as 23 apart &mdash; even though on a clock they&rsquo;re neighbours. Map the value to <code>(cos θ, sin θ)</code> with <code>θ = 2π·x/period</code> and the wraparound is preserved. Drag the value below and watch raw-numeric and sin/cos encodings race on the same task. Linear and distance-based models almost always win with sin/cos; trees mostly don&rsquo;t care.
            </p>
        </div>

        <!-- Two-column working area -->
        <div class="ce-layout">

            <div>
                <!-- Unit circle card -->
                <div class="ms-card">
                    <div class="ce-canvas-wrap">
                        <div class="ce-canvas-label">
                            <span>Unit circle</span>
                            <span class="ce-canvas-sub">point = (cos θ, sin θ) &middot; θ = 2π·value/period</span>
                        </div>
                        <div class="ce-canvas-area is-circle">
                            <canvas id="ceUnitCircle" aria-label="Unit circle with current point and trail"></canvas>
                        </div>
                        <div class="ce-legend">
                            <span><span class="ce-legend-dot ce-pt"></span>current value</span>
                            <span><span class="ce-legend-dot ce-trail"></span>trail</span>
                            <span style="color:var(--ms-muted);">23 ↔ 0 are neighbours on the circle &mdash; 23 apart as integers.</span>
                        </div>
                    </div>
                </div>

                <!-- Model demo card -->
                <div class="ms-card">
                    <div class="ce-canvas-wrap ce-linear-only" id="cePerfWrap">
                        <div class="ce-canvas-label">
                            <span>Raw numeric vs sin/cos</span>
                            <span class="ce-canvas-sub">predicted curve across one period</span>
                        </div>
                        <div class="ce-metric-row">
                            <span class="ce-metric is-sc" id="ceMetricR2">R<sup>2</sup>: <strong>—</strong></span>
                            <span class="ce-metric" id="ceMetricMAE">MAE: <strong>—</strong></span>
                            <span class="ce-metric is-sc" id="ceMetricAcc">Accuracy: <strong>—</strong></span>
                            <span class="ce-metric" id="ceMetricF1">F1: <strong>—</strong></span>
                        </div>
                        <div class="ce-canvas-area is-perf">
                            <canvas id="cePerfChart" aria-label="Performance curves"></canvas>
                        </div>
                        <div class="ce-canvas-footer">Amber = sin/cos encoding &middot; red = raw numeric &middot; sin/cos curves bend smoothly around the period; raw breaks at the wrap.</div>
                        <div class="ce-disabled-banner">
                            <div class="ce-disabled-banner-inner">
                                <strong>Encoding doesn&rsquo;t matter here</strong>
                                <span id="ceDisabledMsg">Switch model to <em>Linear</em> to see the seam-break.</span>
                            </div>
                        </div>
                    </div>

                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1rem;margin-top:0.85rem;">
                        <div class="ce-linear-only" id="ceImpWrap" style="position:relative;">
                            <div class="ce-canvas-label" style="margin-bottom:0.5rem;">
                                <span>sin / cos importance</span>
                            </div>
                            <div class="ce-importance">
                                <span class="ce-importance-label">sin</span>
                                <div class="ce-importance-bar"><div id="ceImpSin" class="ce-importance-fill" style="width:50%;"></div></div>
                                <span class="ce-importance-value" id="ceImpSinLbl">0.50</span>
                            </div>
                            <div class="ce-importance">
                                <span class="ce-importance-label">cos</span>
                                <div class="ce-importance-bar"><div id="ceImpCos" class="ce-importance-fill is-cos" style="width:50%;"></div></div>
                                <span class="ce-importance-value" id="ceImpCosLbl">0.50</span>
                            </div>
                            <div class="ce-canvas-footer" style="margin-top:0.55rem;">For linear regression on sin/cos features only: $|w_{\sin}|/(|w_{\sin}|+|w_{\cos}|)$. Skewed bars mean the target is aligned with one axis.</div>
                            <div class="ce-disabled-banner">
                                <div class="ce-disabled-banner-inner">
                                    <strong>Linear-only</strong>
                                    <span>Switch model to <em>Linear</em> to see the regression weights.</span>
                                </div>
                            </div>
                        </div>
                        <div>
                            <div class="ce-canvas-label" style="margin-bottom:0.5rem;">
                                <span>model size vs performance</span>
                            </div>
                            <div class="ce-canvas-area is-size">
                                <canvas id="ceSizeChart" aria-label="Model size vs performance"></canvas>
                            </div>
                            <div class="ce-canvas-footer" style="margin-top:0.55rem;">Gray = #features used. Amber = score with sin/cos. Sin/cos gets you most of one-hot&rsquo;s gain with 2 features instead of <code>period</code>.</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Controls -->
            <div>
                <div class="ms-card">
                    <!-- Feature + value -->
                    <div class="ce-control-group">
                        <div class="ce-control-group-head">
                            <span class="ce-cgh-label">Feature &amp; value</span>
                            <span class="ce-cgh-desc">drag the slider, watch the dot move</span>
                        </div>
                        <div class="ce-control">
                            <div class="ce-control-label"><span>feature</span></div>
                            <select id="ceFeature">
                                <option value="hour">hour (0&ndash;23)</option>
                                <option value="month">month (1&ndash;12)</option>
                                <option value="dow">day-of-week (0&ndash;6)</option>
                                <option value="angle">angle (0&ndash;360°)</option>
                            </select>
                        </div>
                        <div class="ce-control">
                            <div class="ce-control-label"><span>value</span><span class="ce-control-value" id="ceValueLabel">0</span></div>
                            <input type="range" id="ceValue" min="0" max="23" step="1" value="0">
                        </div>
                    </div>

                    <!-- Encoding params -->
                    <div class="ce-control-group">
                        <div class="ce-control-group-head">
                            <span class="ce-cgh-label">Encoding</span>
                            <span class="ce-cgh-desc">period defines the wrap, noise = target σ</span>
                        </div>
                        <div class="ce-control">
                            <div class="ce-control-label"><span>period</span><span class="ce-control-value" id="cePeriodLabel">24</span></div>
                            <input type="range" id="cePeriod" min="3" max="360" step="1" value="24">
                        </div>
                        <div class="ce-control">
                            <div class="ce-control-label"><span>noise σ</span><span class="ce-control-value" id="ceNoiseLabel">0.10</span></div>
                            <input type="range" id="ceNoise" min="0" max="1" step="0.01" value="0.10">
                        </div>
                    </div>

                    <!-- Task + model -->
                    <div class="ce-control-group">
                        <div class="ce-control-group-head">
                            <span class="ce-cgh-label">Task &amp; model</span>
                            <span class="ce-cgh-desc">how to evaluate the encoding</span>
                        </div>
                        <div class="ce-control">
                            <div class="ce-control-label"><span>task</span></div>
                            <select id="ceMode">
                                <option value="reg" selected>Regression</option>
                                <option value="clf">Classification</option>
                            </select>
                        </div>
                        <div class="ce-control">
                            <div class="ce-control-label"><span>model</span></div>
                            <select id="ceModel">
                                <option value="linear" selected>Linear</option>
                                <option value="tree">Tree (binning)</option>
                                <option value="knn">kNN (k=5, cyclic distance)</option>
                            </select>
                        </div>
                        <label class="ce-control-checkbox" style="margin-top:0.5rem;">
                            <input type="checkbox" id="ceCompareOneHot" checked>
                            <span>show one-hot &amp; both in size chart</span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Theory & exercises -->
        <details class="ce-collapse">
            <summary>Theory &amp; exercises &middot; the unit-circle map, when to skip it, harmonics</summary>
            <div class="ce-collapse-body">

                <!-- Math card -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, in three moves</h2>
                    <div class="ce-math">
                        <div class="ce-math-step">
                            <h4>1. Map the scalar to an angle.</h4>
                            $$ \theta = 2\pi \cdot \frac{x}{P} \qquad (x \in [0, P)) $$
                            <p style="margin-top:0.4rem;">$P$ is the period &mdash; 24 for hour, 12 for month, 7 for day-of-week, 360 for angle. The map is bijective on one period and identifies $P$ with $0$.</p>
                        </div>
                        <div class="ce-math-step">
                            <h4>2. Encode as a point on the unit circle.</h4>
                            $$ \phi(x) = \big(\cos\theta,\; \sin\theta\big) $$
                            <p style="margin-top:0.4rem;">Two features replace one. The Euclidean distance between $\phi(x_1)$ and $\phi(x_2)$ is monotone in the <em>arc</em> distance &mdash; close on the cycle ⇒ close in feature space.</p>
                        </div>
                        <div class="ce-math-step">
                            <h4>3. (Optional) Add harmonics.</h4>
                            $$ \phi_k(x) = \big(\cos(k\theta),\; \sin(k\theta)\big),\quad k=1,2,\dots,K $$
                            <p style="margin-top:0.4rem;">Two features per harmonic. With enough $K$, you reproduce a Fourier basis &mdash; linear models on these features can approximate any periodic target.</p>
                        </div>
                    </div>
                </div>

                <!-- Try this -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
                    <div class="ce-try">
                        <div class="ce-try-item">
                            <h4>The seam test</h4>
                            <p>Pick <code>hour</code>, model = <code>Linear</code>, task = <code>Regression</code>. Look at the prediction curves at the seam (x near 23 → 0). Raw breaks; sin/cos sweeps through smoothly. That single fact is the whole pitch for cyclical encoding.</p>
                        </div>
                        <div class="ce-try-item">
                            <h4>Trees don&rsquo;t need it</h4>
                            <p>Switch to <code>Tree (binning)</code>. The raw and sin/cos curves match exactly. Trees split on thresholds; they don&rsquo;t care if your feature is cyclic. Stick with raw integers for tree-only pipelines.</p>
                        </div>
                        <div class="ce-try-item">
                            <h4>kNN benefits from cyclic distance</h4>
                            <p>kNN here uses an <em>arc</em> distance, not Euclidean. That alone fixes the wraparound problem. If your kNN library only does Euclidean (most do), encode with sin/cos first.</p>
                        </div>
                        <div class="ce-try-item">
                            <h4>One-hot vs sin/cos size</h4>
                            <p>For <code>angle (period=360)</code>, one-hot would mean 360 features. Sin/cos = 2. Same cyclic info, 99% fewer parameters. The size chart on the right shows the same lesson at a glance.</p>
                        </div>
                        <div class="ce-try-item">
                            <h4>Noise drowns small periods</h4>
                            <p>Push <code>noise σ</code> to 0.9 on <code>day-of-week</code> (period=7). The R² for both encodings collapses. Encoding can&rsquo;t rescue a target that&rsquo;s mostly noise.</p>
                        </div>
                        <div class="ce-try-item">
                            <h4>Importance bars hint at phase</h4>
                            <p>The target here is <code>sin(θ)</code>. The sin importance should dominate. Now imagine a target $\cos(\theta)$ &mdash; the cos bar would lead. Skewed bars hint at the dominant phase in your data.</p>
                        </div>
                    </div>
                </div>

                <!-- Chip strips -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
                    <div class="ce-strip is-watchout">
                        <span class="ce-strip-label">&#9888;&#65039; Watch out</span>
                        <span class="ce-tag">Linear+raw integer seam break</span>
                        <span class="ce-tag">One-hot for high period</span>
                        <span class="ce-tag">Multiple harmonics? maybe drop hand-features</span>
                        <span class="ce-tag">Distance learners with raw cyclic ints</span>
                    </div>
                    <div class="ce-strip is-practice">
                        <span class="ce-strip-label">&#128295; In practice</span>
                        <span class="ce-tag">np.sin(2*np.pi*x/P)</span>
                        <span class="ce-tag">np.cos(2*np.pi*x/P)</span>
                        <span class="ce-tag">ColumnTransformer</span>
                        <span class="ce-tag">FunctionTransformer</span>
                        <span class="ce-tag">sklearn.preprocessing</span>
                        <span class="ce-tag">Fourier features</span>
                    </div>
                </div>

            </div>
        </details>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Cyclical Encoding FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why encode cyclical features with sin and cos?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">A raw integer treats <code>23</code> and <code>0</code> as 23 apart, but on the hour clock they&rsquo;re neighbours. Mapping the value to <code>(cos θ, sin θ)</code> with <code>θ = 2π·x/period</code> preserves cyclic geometry &mdash; close points on the cycle stay close in the encoded space. Linear models and distance-based learners (kNN, k-means, SVMs with RBF) benefit immediately.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        When can I skip sin/cos encoding?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a"><strong>Tree-based models</strong> (decision trees, random forests, gradient boosting) handle splits on raw integers fine &mdash; they don&rsquo;t care about smoothness. If you only ever feed the feature into trees, sin/cos doesn&rsquo;t help much. For everything else (linear regression, logistic regression, neural nets, kNN, k-means), encode it.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Is one-hot encoding a good alternative?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">One-hot works but explodes the feature count for high-period values (one-hot of hour = 24 features, day-of-year = 365). It also throws away ordering &mdash; the model can&rsquo;t tell <code>0</code> and <code>1</code> are adjacent. Sin/cos compresses the same information into 2 features while keeping the cyclic structure. Use one-hot only when the period is very small (e.g., 7 weekdays) AND ordering really doesn&rsquo;t matter.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Do I always need just sin and cos, or higher harmonics?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">For most use cases, sin and cos at the base frequency are enough. For richer periodic targets (multiple peaks per cycle), add second-harmonic features: <code>sin(2θ)</code>, <code>cos(2θ)</code>. This is exactly what <strong>Fourier features</strong> do. In practice though, if your target needs many harmonics, you probably want a smoother model (GAM, GP, NN) rather than more hand-crafted features.</div>
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

<script>
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
</script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/ml/js/cyclical-encoding.js?v=<%=v%>" defer></script>
</body>
</html>
