<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Decision Tree Model Selection — Cross-Validation, Pruning &amp; Grid Search" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive decision tree model-selection lab. Run k-fold CV, sweep validation curves, prune with ccp_alpha, search hyperparameter grids, and evaluate on a final hold-out — all in your browser, with live decision regions." />
        <jsp:param name="toolUrl" value="decision_tree_model_selection.jsp" />
        <jsp:param name="toolImage" value="decision-tree-og.png" />
        <jsp:param name="toolKeywords" value="decision tree model selection, cross validation, k-fold, validation curve, ccp_alpha pruning, grid search heatmap, gini, entropy, hyperparameter tuning, hold-out test, bias variance tradeoff" />
        <jsp:param name="toolFeatures" value="K-fold cross-validation (random or forward-chaining),Validation curve sweep (max_depth, min_samples_leaf, ccp_alpha),Grid search heatmap over depth × leaf,Cost-sensitive scoring (FP/FN penalties),Five metrics: accuracy, F1, balanced, PR AUC, cost,Five dataset presets (balanced, overlap, XOR, moons, circles),Click-to-add custom points,Final hold-out test,Live decision regions and split lines" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a dataset|Balanced or Overlap to start; XOR / Moons / Circles to see how trees handle non-linear shapes,Tune the sliders|Watch the decision boundary react to max_depth and min_samples_leaf in real time,Run CV and let it recommend|The lab does a small local search around your settings and prefers stable simpler models,Validate on a hold-out|Make a final test split and evaluate once — never tune on the test set" />
        <jsp:param name="faq1q" value="What is k-fold cross-validation?" />
        <jsp:param name="faq1a" value="The dataset is split into K equally-sized folds. The model trains on K−1 of them and validates on the held-out fold; this rotates so every fold serves as the validation set once. CV Mean and CV Std summarize how well your hyperparameter choice generalizes — high mean with low std is the sweet spot. Random K-fold assumes i.i.d. data; forward-chaining respects temporal order." />
        <jsp:param name="faq2q" value="What does ccp_alpha (cost-complexity pruning) do?" />
        <jsp:param name="faq2a" value="It penalizes tree complexity. After fitting, any split whose impurity reduction is below ccp_alpha gets pruned. Higher alpha → smaller tree → less variance, more bias. It's a clean way to fight overfitting without re-running the whole fit; sweep it on the validation curve to find the elbow where CV stops improving." />
        <jsp:param name="faq3q" value="Gini vs entropy — which criterion should I pick?" />
        <jsp:param name="faq3a" value="In practice they almost always agree on the chosen splits. Gini is slightly cheaper to compute (no log) and is the sklearn default. Entropy can prefer slightly more balanced splits. Pick one and don't worry about it — the depth and leaf settings matter far more for model quality." />
        <jsp:param name="faq4q" value="Why is my training score much higher than CV score?" />
        <jsp:param name="faq4a" value="Classic overfitting. The tree memorized the training data — every leaf is pure — but the regions don't generalize. Reduce max_depth, raise min_samples_leaf, or raise ccp_alpha. Use the validation curve to spot the gap: when train keeps climbing but CV plateaus or drops, you've crossed into overfitting territory." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/decision-tree-model-selection.css?v=<%=v%>">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

    <script defer src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

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

    <% request.setAttribute("activeService", "decision-tree"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Hero -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Decision Trees, <em style="font-style:italic;color:#4f46e5;">picked properly</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Trees &amp; Selection &middot; Decision Tree
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Model Selection</span>
            </div>
            <p style="margin:0.85rem 0 0;color:var(--ms-ink-soft);font:0.92rem/1.55 var(--ms-font-sans);max-width:72ch;">
                A decision tree can fit anything &mdash; including the noise. This lab teaches you to <strong>choose</strong> one. Run k-fold cross-validation, sweep validation curves to spot under/overfitting, prune with <code>ccp_alpha</code>, scan a grid-search heatmap, and finally evaluate once on a hold-out test. The decision regions update live so you can <em>see</em> what your hyperparameter choice does.
            </p>
        </div>

        <!-- Two-column working area: charts (L) + controls (R) -->
        <div class="dt-layout">
            <div>
                <!-- Decision regions card -->
                <div class="ms-card">
                    <div class="dt-canvas-wrap">
                        <div class="dt-canvas-label">
                            <span>Decision regions &middot; click to add a point</span>
                            <label class="dt-control-checkbox" style="text-transform:none;letter-spacing:0;font-size:0.78rem;">
                                <input type="checkbox" id="dtShowSplits" checked>
                                <span>show splits</span>
                            </label>
                        </div>
                        <div class="dt-canvas-area is-main">
                            <canvas id="dtCanvas" aria-label="Decision regions"></canvas>
                        </div>
                        <div class="dt-canvas-footer">Regions are coloured softly by predicted class; dashed lines mark tree split thresholds.</div>
                        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:0.6rem;margin-top:0.5rem;">
                            <div class="dt-legend">
                                <span><span class="dt-legend-dot dt-c1"></span>Class 1</span>
                                <span><span class="dt-legend-dot dt-c0"></span>Class 0</span>
                            </div>
                            <button type="button" class="dt-class-indicator" id="dtClassIndicator" data-class="1">
                                <span class="dt-class-indicator-dot"></span>
                                <span>Adding to <strong id="dtClassIndicatorText">Class 1</strong></span>
                                <span class="dt-class-indicator-hint">click to switch</span>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Validation curve -->
                <div class="ms-card">
                    <div class="dt-canvas-wrap">
                        <div class="dt-canvas-label">
                            <span>Validation curve</span>
                            <span>
                                <select id="dtSweep" style="padding:0.2rem 0.4rem;font:500 0.74rem var(--ms-font-mono);border:1px solid var(--ms-line);border-radius:var(--ms-radius-sm);background:var(--ms-panel-bg-soft);color:var(--ms-ink);">
                                    <option value="maxDepth" selected>sweep max_depth</option>
                                    <option value="minLeaf">sweep min_samples_leaf</option>
                                    <option value="alpha">sweep ccp_alpha</option>
                                </select>
                            </span>
                        </div>
                        <div class="dt-canvas-area is-medium">
                            <canvas id="dtValChart" aria-label="Train vs CV validation curve"></canvas>
                        </div>
                        <div class="dt-canvas-footer">Train vs CV score across the swept hyperparameter. Overfit = high train, low CV.</div>
                    </div>
                </div>

                <!-- Grid search heatmap -->
                <div class="ms-card">
                    <div class="dt-canvas-wrap">
                        <div class="dt-canvas-label">
                            <span>Grid search &middot; max_depth × min_samples_leaf</span>
                        </div>
                        <div class="dt-canvas-area is-medium">
                            <canvas id="dtHeatCanvas" aria-label="Grid search heatmap"></canvas>
                        </div>
                        <div class="dt-canvas-footer">Cells coloured by CV score &mdash; brighter green = better. Look for stable plateaus, not spiky maxima.</div>
                    </div>
                </div>
            </div>

            <!-- Controls column -->
            <div>
                <div class="ms-card">
                    <!-- Dataset presets -->
                    <div class="dt-control-group">
                        <div class="dt-control-group-head">
                            <span class="dt-cgh-label">Dataset</span>
                            <span class="dt-cgh-desc">pick a preset, or click the canvas to add points</span>
                        </div>
                        <div class="dt-preset-row">
                            <button type="button" class="dt-preset is-active" data-preset="balanced">Balanced</button>
                            <button type="button" class="dt-preset" data-preset="overlap">Overlap</button>
                            <button type="button" class="dt-preset" data-preset="xor">XOR</button>
                            <button type="button" class="dt-preset" data-preset="moons">Moons</button>
                            <button type="button" class="dt-preset" data-preset="circles">Circles</button>
                        </div>
                        <div class="dt-actions">
                            <button type="button" class="dt-btn is-warn" id="dtBtnClear">Clear points</button>
                        </div>
                    </div>

                    <!-- Tree hyperparameters -->
                    <div class="dt-control-group">
                        <div class="dt-control-group-head">
                            <span class="dt-cgh-label">Tree hyperparameters</span>
                            <span class="dt-cgh-desc">refits live</span>
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>criterion</span></div>
                            <select id="dtCriterion">
                                <option value="gini" selected>Gini</option>
                                <option value="entropy">Entropy</option>
                            </select>
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>max_depth</span><span class="dt-control-value" id="dtMaxDepthVal">5</span></div>
                            <input type="range" id="dtMaxDepth" min="1" max="12" step="1" value="5">
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>min_samples_split</span><span class="dt-control-value" id="dtMinSplitVal">4</span></div>
                            <input type="range" id="dtMinSplit" min="2" max="20" step="1" value="4">
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>min_samples_leaf</span><span class="dt-control-value" id="dtMinLeafVal">2</span></div>
                            <input type="range" id="dtMinLeaf" min="1" max="20" step="1" value="2">
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>max_features</span><span class="dt-control-value" id="dtMaxFeaturesVal">2</span></div>
                            <input type="range" id="dtMaxFeatures" min="1" max="2" step="1" value="2">
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>ccp_alpha (pruning)</span><span class="dt-control-value" id="dtAlphaVal">0.000</span></div>
                            <input type="range" id="dtAlpha" min="0" max="0.05" step="0.005" value="0">
                        </div>
                    </div>

                    <!-- Validation -->
                    <div class="dt-control-group">
                        <div class="dt-control-group-head">
                            <span class="dt-cgh-label">Validation</span>
                            <span class="dt-cgh-desc">how CV splits the data</span>
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>K-folds</span><span class="dt-control-value" id="dtKfoldsVal">5</span></div>
                            <input type="range" id="dtKfolds" min="3" max="10" step="1" value="5">
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>strategy</span></div>
                            <select id="dtValStrategy">
                                <option value="random" selected>Random K-Fold</option>
                                <option value="forward">Forward-Chaining</option>
                            </select>
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>scoring metric</span></div>
                            <select id="dtMetric">
                                <option value="accuracy" selected>Accuracy</option>
                                <option value="f1">F1</option>
                                <option value="balanced">Balanced Accuracy</option>
                                <option value="prauc">PR AUC</option>
                                <option value="cost">Cost-based</option>
                            </select>
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>cost FP</span><span class="dt-control-value" id="dtCostFPVal">1.0</span></div>
                            <input type="range" id="dtCostFP" min="0" max="10" step="0.5" value="1.0">
                        </div>
                        <div class="dt-control">
                            <div class="dt-control-label"><span>cost FN</span><span class="dt-control-value" id="dtCostFNVal">5.0</span></div>
                            <input type="range" id="dtCostFN" min="0" max="10" step="0.5" value="5.0">
                        </div>
                        <div class="dt-actions">
                            <button type="button" class="dt-btn is-primary" id="dtBtnRunCV">Run CV &amp; Recommend</button>
                            <button type="button" class="dt-btn" id="dtBtnValCurve">Compute Curve</button>
                        </div>
                        <div class="dt-metrics" style="margin-top:0.7rem;">
                            <div class="dt-metrics-row"><span>CV Mean</span><strong id="dtCvMean">—</strong></div>
                            <div class="dt-metrics-row"><span>CV Std</span><strong id="dtCvStd">—</strong></div>
                            <div class="dt-metrics-row" style="border-top:1px solid var(--ms-line);margin-top:0.3rem;padding-top:0.45rem;"><span style="color:#d97706;">Recommended</span><strong id="dtRecParams" style="font-size:0.82rem;color:#4f46e5;">—</strong></div>
                        </div>
                    </div>

                    <!-- Final hold-out test -->
                    <div class="dt-control-group">
                        <div class="dt-control-group-head">
                            <span class="dt-cgh-label">Final test</span>
                            <span class="dt-cgh-desc">hold-out, never tune on it</span>
                        </div>
                        <div class="dt-control" style="flex-direction:row;align-items:center;gap:0.5rem;">
                            <label style="font:500 0.78rem var(--ms-font-sans);color:var(--ms-ink-soft);">test %</label>
                            <input type="number" id="dtTestPct" value="20" min="5" max="50" step="5" style="width:80px;">
                            <button type="button" class="dt-btn" id="dtBtnMakeTest">Make split</button>
                        </div>
                        <div class="dt-actions">
                            <button type="button" class="dt-btn is-primary" id="dtBtnEvalTest">Evaluate</button>
                        </div>
                        <div class="dt-metrics" style="margin-top:0.6rem;">
                            <div class="dt-metrics-row"><span>Final Test Score</span><strong id="dtTestScore">—</strong></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Theory & exercises (collapsed) -->
        <details class="dt-collapse">
            <summary>Theory &amp; exercises &middot; CV math, bias-variance, ideas to try</summary>
            <div class="dt-collapse-body">

                <!-- Math card -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, in four moves</h2>
                    <div class="dt-math">
                        <div class="dt-math-step">
                            <h4>1. Impurity at a node.</h4>
                            <p>Gini measures the chance of misclassifying a random sample at a node:</p>
                            $$ \mathrm{Gini}(t) = 1 - \sum_{k} p_k^2 $$
                            <p style="margin-top:0.4rem;">Entropy uses information instead: $H(t) = -\sum_k p_k \log_2 p_k$. Both penalize mixed nodes; pure leaves get score 0.</p>
                        </div>
                        <div class="dt-math-step">
                            <h4>2. Best split = max impurity reduction.</h4>
                            $$ \Delta i = i(t) - \tfrac{n_L}{n}\,i(t_L) - \tfrac{n_R}{n}\,i(t_R) $$
                            <p style="margin-top:0.4rem;">Try every candidate threshold on every feature; pick the one with the largest $\Delta i$. Recurse on the children.</p>
                        </div>
                        <div class="dt-math-step">
                            <h4>3. K-fold cross-validation.</h4>
                            <p>Split the data into K folds. For each fold $f$, train on the other K-1 and score on $f$:</p>
                            $$ \mathrm{CV} = \frac{1}{K}\sum_{f=1}^{K} \mathrm{score}\!\left(\hat{m}_{-f},\; D_f\right) $$
                            <p style="margin-top:0.4rem;">CV Mean = honest generalization estimate; CV Std = how sensitive that estimate is to the random split.</p>
                        </div>
                        <div class="dt-math-step">
                            <h4>4. Cost-complexity pruning.</h4>
                            $$ R_\alpha(T) = R(T) + \alpha\,|\tilde{T}| $$
                            <p style="margin-top:0.4rem;">$R(T)$ is training error, $|\tilde{T}|$ is leaf count. Each $\alpha$ picks the smallest sub-tree with minimum penalized error. Larger $\alpha$ → smaller tree → less variance, more bias.</p>
                        </div>
                    </div>
                </div>

                <!-- Try this -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
                    <div class="dt-try">
                        <div class="dt-try-item">
                            <h4>Watch overfitting on XOR</h4>
                            <p>Pick <code>XOR</code>. Push <code>max_depth</code> to 12 and <code>min_samples_leaf</code> to 1. Hit <em>Compute Curve</em> with sweep=<code>max_depth</code>. Train climbs to 1.0; CV stops improving around depth 4. That gap is overfit.</p>
                        </div>
                        <div class="dt-try-item">
                            <h4>Prune your way out</h4>
                            <p>Set sweep=<code>ccp_alpha</code>. Watch CV rise, plateau, then fall as $\alpha$ over-prunes. The elbow is your model.</p>
                        </div>
                        <div class="dt-try-item">
                            <h4>Stable plateaus beat spiky maxima</h4>
                            <p>Run the grid heatmap. A single bright cell next to dark neighbours is suspicious — probably CV noise. Pick a depth/leaf in a wide green plateau instead.</p>
                        </div>
                        <div class="dt-try-item">
                            <h4>Cost-sensitive screening</h4>
                            <p>Set metric=<code>Cost-based</code>, push <code>cost FN</code> to 10. The recommended tree shifts to a higher-recall configuration. This is how you tune for screening problems (missed-fraud cost &gg; false alarm cost).</p>
                        </div>
                        <div class="dt-try-item">
                            <h4>Forward-chaining for time series</h4>
                            <p>Switch strategy to <code>Forward-Chaining</code>. If your data drifts, random K-fold gives optimistically inflated scores. Forward splits respect time order — closer to production.</p>
                        </div>
                        <div class="dt-try-item">
                            <h4>The final-test rule</h4>
                            <p>After picking hyperparameters, make a 20% hold-out and evaluate once. If the score drops a lot vs CV mean, you tuned too aggressively. Keep that test untouched while iterating.</p>
                        </div>
                    </div>
                </div>

                <!-- Chip strips -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
                    <div class="dt-strip is-watchout">
                        <span class="dt-strip-label">&#9888;&#65039; Watch out</span>
                        <span class="dt-tag">Tuning on the test set</span>
                        <span class="dt-tag">High train, low CV</span>
                        <span class="dt-tag">Single-cell heatmap peak</span>
                        <span class="dt-tag">Random K-fold on temporal data</span>
                        <span class="dt-tag">Tiny leaves on noisy data</span>
                    </div>
                    <div class="dt-strip is-practice">
                        <span class="dt-strip-label">&#128295; In practice</span>
                        <span class="dt-tag">DecisionTreeClassifier</span>
                        <span class="dt-tag">GridSearchCV</span>
                        <span class="dt-tag">cross_val_score</span>
                        <span class="dt-tag">cost_complexity_pruning_path</span>
                        <span class="dt-tag">TimeSeriesSplit</span>
                        <span class="dt-tag">make_scorer</span>
                    </div>
                </div>

            </div>
        </details>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Decision Tree Model Selection FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is k-fold cross-validation?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The dataset is split into K equally-sized folds. The model trains on K−1 of them and validates on the held-out fold; this rotates so every fold serves as the validation set once. <strong>CV Mean</strong> and <strong>CV Std</strong> summarize how well your hyperparameter choice generalizes &mdash; high mean with low std is the sweet spot. Random K-fold assumes i.i.d. data; forward-chaining respects temporal order.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What does ccp_alpha do?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">It penalizes tree complexity. After fitting, any split whose impurity reduction is below <code>ccp_alpha</code> gets pruned. Higher alpha &rarr; smaller tree &rarr; less variance, more bias. Sweep it on the validation curve to find the elbow where CV stops improving.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Gini vs entropy — which criterion?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">In practice they almost always agree on the chosen splits. <strong>Gini</strong> is slightly cheaper to compute (no log) and is the sklearn default. <strong>Entropy</strong> can prefer slightly more balanced splits. Pick one and don&rsquo;t worry &mdash; depth and leaf settings matter far more.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why is my training score much higher than CV?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Classic <strong>overfitting</strong>. The tree memorized the training data &mdash; every leaf is pure &mdash; but the regions don&rsquo;t generalize. Reduce <code>max_depth</code>, raise <code>min_samples_leaf</code>, or raise <code>ccp_alpha</code>. The validation curve shows the gap: when train keeps climbing but CV plateaus or drops, you&rsquo;ve crossed into overfit territory.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/decision-tree-model-selection.js?v=<%=v%>" defer></script>
</body>
</html>
