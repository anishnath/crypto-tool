<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ROC, AUC & Precision–Recall Curves Visualized" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive ROC and PR curve demo. Drag the threshold slider to see the operating point move across the ROC, the confusion matrix shift, and precision/recall/F1 update live. Five preset datasets cover balanced, overlap, imbalanced, and near-perfect cases. No signup." />
        <jsp:param name="toolUrl" value="ROC_AUC.jsp" />
        <jsp:param name="toolImage" value="roc-auc-og.png" />
        <jsp:param name="toolKeywords" value="roc curve, auc score, precision recall curve, threshold tuning, true positive rate, false positive rate, f1 score, confusion matrix, ml evaluation metrics, classification threshold" />
        <jsp:param name="toolFeatures" value="Live operating-point marker on ROC curve tied to threshold slider,Precision-Recall curve with same marker,Confusion matrix updates as threshold moves,F1/precision/recall/accuracy KPIs,5 preset datasets including perfect-separation case,Same training mechanic as the Logistic Regression page,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Train a model|Click Auto-train (or use the preset datasets) — the ROC and PR curves grow as the model learns to discriminate,Slide the threshold|Drag τ from 0.1 to 0.9 — the magenta operating-point marker moves along the ROC curve while the confusion matrix and precision/recall update,Read the AUC|The number doesn't change with τ — AUC summarizes ranking quality across all thresholds. AUC = 0.5 is random; AUC = 1.0 is perfect" />
        <jsp:param name="faq1q" value="What does AUC actually measure?" />
        <jsp:param name="faq1a" value="The probability that a random positive example is ranked higher than a random negative example. AUC = 1.0 means perfect ranking; AUC = 0.5 is random; below 0.5 means the model is anti-correlated (you'd do better flipping the predictions). Crucially, AUC is threshold-independent — it measures the model's ability to rank, not its accuracy at any single τ." />
        <jsp:param name="faq2q" value="ROC AUC vs PR AUC?" />
        <jsp:param name="faq2a" value="ROC AUC treats true negatives equally with true positives. On imbalanced data (e.g., 99/1 split), a model that predicts mostly the majority class can have a deceptively high ROC AUC — the FPR denominator is huge so even many false positives barely move the curve. PR AUC ignores true negatives entirely, so it stays sensitive to performance on the minority class. Rule of thumb: imbalanced data → look at PR AUC, not ROC AUC." />
        <jsp:param name="faq3q" value="How do I pick the right threshold?" />
        <jsp:param name="faq3a" value="Depends on which error is more expensive. If false positives are costly (e.g., flagging legit transactions as fraud), raise τ to suppress them. If false negatives are costly (e.g., missing cancer screenings), lower τ. F1 score balances both. For probability-calibrated outputs, τ = 0.5 is a starting point — but for many real problems, the optimal τ is found by maximizing F1 or by a cost-benefit analysis." />
        <jsp:param name="faq4q" value="Why does the ROC curve look stepped?" />
        <jsp:param name="faq4a" value="Each step corresponds to one training example changing its predicted class as the threshold sweeps past its predicted probability. With more data points, the curve becomes smoother. With fewer points it's blocky — useful for seeing the discrete nature of the sweep but cosmetically rougher." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/roc-auc.css?v=<%=v%>">

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

    <% request.setAttribute("activeService", "roc-auc"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        ROC, AUC &amp; PR, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Linear Models &middot; ROC &amp; AUC
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Evaluation</span>
            </div>
            <p style="margin:0.85rem 0 0;color:var(--ms-ink-soft);font:0.92rem/1.55 var(--ms-font-sans);max-width:70ch;">
                A trained classifier outputs probabilities; <strong>threshold</strong> turns those into class labels. ROC plots <strong>TPR vs FPR</strong> as &tau; sweeps from 0 to 1; PR plots <strong>precision vs recall</strong>. Drag the threshold slider below to move the magenta point on both curves. For training internals see <a href="<%=request.getContextPath()%>/Logistic_Regression.jsp" style="color:#4f46e5;">Logistic Regression &rarr;</a>.
            </p>
        </div>

        <!-- ── Mega Evaluate card: AUC + curves + threshold + CM + KPIs ─ -->
        <div class="ms-card">
            <div class="ra-eval">

                <!-- AUC headlines (compact) -->
                <div class="ra-summary is-tight">
                    <div class="ra-auc-card">
                        <div class="ra-auc-card-label">ROC AUC</div>
                        <div class="ra-auc-card-value" id="raKAUC">—</div>
                        <div class="ra-auc-band is-random" id="raAUCBand"><span class="ra-auc-band-dot"></span><span id="raAUCBandText">awaiting data</span></div>
                    </div>
                    <div class="ra-auc-card is-pr">
                        <div class="ra-auc-card-label">PR AUC (avg precision)</div>
                        <div class="ra-auc-card-value" id="raKAP">—</div>
                        <div class="ra-auc-band is-random" id="raAPBand"><span class="ra-auc-band-dot"></span><span id="raAPBandText">awaiting data</span></div>
                    </div>
                </div>

                <!-- Curves side by side -->
                <div class="ra-curves">
                    <div class="ra-canvas-wrap">
                        <div class="ra-canvas-label">
                            <span>ROC curve &middot; TPR vs FPR</span>
                            <span class="ra-canvas-readout" id="raOpLabel"></span>
                        </div>
                        <div class="ra-canvas-area">
                            <canvas id="raChartROC" aria-label="ROC curve"></canvas>
                        </div>
                    </div>
                    <div class="ra-canvas-wrap">
                        <div class="ra-canvas-label">
                            <span>Precision-Recall curve</span>
                            <span class="ra-canvas-readout" id="raPrOpLabel"></span>
                        </div>
                        <div class="ra-canvas-area">
                            <canvas id="raChartPR" aria-label="Precision-Recall curve"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Threshold control row (full width) -->
                <div class="ra-eval-threshold">
                    <div class="ra-control-group-head" style="margin-bottom:0.5rem;">
                        <span class="ra-cgh-label">Threshold &tau;</span>
                        <span class="ra-cgh-desc">&mdash; drag to move the magenta point on both curves &middot; the matrix below shifts with it</span>
                    </div>
                    <div class="ra-eval-threshold-row">
                        <input type="range" id="raTh" min="0" max="1" step="0.005" value="0.5">
                        <input type="number" id="raThNum" step="0.01" min="0" max="1" value="0.5">
                    </div>
                </div>

                <!-- Results: CM + KPIs side by side -->
                <div class="ra-eval-results">
                    <div>
                        <div class="ra-cm-label">Confusion matrix at &tau;</div>
                        <div class="ra-cm">
                            <div></div>
                            <div class="ra-cm-header">Pred 0</div>
                            <div class="ra-cm-header">Pred 1</div>
                            <div class="ra-cm-row-label">Actual 0</div>
                            <div class="ra-cm-cell is-correct" id="raCmTN">—</div>
                            <div class="ra-cm-cell is-error"   id="raCmFP">—</div>
                            <div class="ra-cm-row-label">Actual 1</div>
                            <div class="ra-cm-cell is-error"   id="raCmFN">—</div>
                            <div class="ra-cm-cell is-correct" id="raCmTP">—</div>
                        </div>
                    </div>
                    <div>
                        <div class="ra-cm-label">Metrics at &tau;</div>
                        <div class="ra-kpi-grid">
                            <div class="ra-kpi"><div class="ra-kpi-label">Accuracy</div><div class="ra-kpi-value" id="raKAcc">—</div></div>
                            <div class="ra-kpi"><div class="ra-kpi-label">Precision</div><div class="ra-kpi-value" id="raKPrec">—</div></div>
                            <div class="ra-kpi"><div class="ra-kpi-label">Recall</div><div class="ra-kpi-value" id="raKRec">—</div></div>
                            <div class="ra-kpi"><div class="ra-kpi-label">F1</div><div class="ra-kpi-value" id="raKF1">—</div></div>
                            <div class="ra-kpi"><div class="ra-kpi-label">N points</div><div class="ra-kpi-value" id="raKN">0</div></div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Secondary: dataset + boundary -->
        <div class="ms-card">
            <div class="ra-data">
                <div class="ra-canvas-wrap">
                    <div class="ra-canvas-label"><span>Dataset &amp; decision boundary</span></div>
                    <div class="ra-canvas-area">
                        <canvas id="raChartXY" aria-label="Dataset scatter with logistic boundary"></canvas>
                    </div>
                    <div class="ra-legend">
                        <span><span class="ra-legend-dot ra-c0"></span>Class 0</span>
                        <span><span class="ra-legend-dot ra-c1"></span>Class 1</span>
                        <span><span class="ra-legend-dot ra-op"></span>Operating point</span>
                    </div>
                    <%-- Class indicator + cursor-hint --%>
                    <div style="margin-top:0.6rem;">
                        <button type="button" class="ra-class-indicator" id="raClassIndicator" data-class="1" aria-label="Click to switch class to add">
                            <span class="ra-class-indicator-dot"></span>
                            <span>Adding to <strong id="raClassIndicatorText">Class 1</strong></span>
                            <span class="ra-class-indicator-hint">click to switch &middot; then click the chart to drop points</span>
                        </button>
                    </div>
                </div>
                <div>
                    <%-- Hidden state — replaced by the click-to-toggle class indicator. --%>
                    <select id="raClassSel" style="display:none;"><option value="1" selected>Class 1</option><option value="0">Class 0</option></select>

                    <div class="ra-control-group">
                        <div class="ra-control-group-head">
                            <span class="ra-cgh-label">Parameters</span>
                            <span class="ra-cgh-desc">&mdash; what training learns</span>
                        </div>
                        <div class="ra-control-group-body">
                            <div class="ra-control">
                                <div class="ra-control-label"><span>w&#8320;</span><input type="number" id="raW0Num" step="0.1" value="1" style="width:70px;text-align:right;"></div>
                                <input type="range" id="raW0" min="-5" max="5" step="0.01" value="1">
                                <div class="ra-control-sublabel">slope along x</div>
                            </div>
                            <div class="ra-control">
                                <div class="ra-control-label"><span>w&#8321;</span><input type="number" id="raW1Num" step="0.1" value="-1" style="width:70px;text-align:right;"></div>
                                <input type="range" id="raW1" min="-5" max="5" step="0.01" value="-1">
                                <div class="ra-control-sublabel">slope along y</div>
                            </div>
                            <div class="ra-control">
                                <div class="ra-control-label"><span>b</span><input type="number" id="raBNum" step="0.1" value="0" style="width:70px;text-align:right;"></div>
                                <input type="range" id="raB" min="-5" max="5" step="0.01" value="0">
                                <div class="ra-control-sublabel">offset / intercept</div>
                            </div>
                        </div>
                    </div>

                    <div class="ra-control-group">
                        <div class="ra-control-group-head">
                            <span class="ra-cgh-label">Hyperparameter</span>
                            <span class="ra-cgh-desc">&mdash; you set it</span>
                        </div>
                        <div class="ra-control-group-body">
                            <div class="ra-control">
                                <div class="ra-control-label"><span>&eta;</span><input type="number" id="raLrNum" step="0.001" value="0.1" style="width:70px;text-align:right;"></div>
                                <input type="range" id="raLr" min="0.001" max="1" step="0.001" value="0.1">
                                <div class="ra-control-sublabel">learning rate</div>
                            </div>
                        </div>
                    </div>

                    <div class="ra-actions">
                        <button type="button" class="ra-btn is-primary" id="raBtnStep">Train 1 step</button>
                        <button type="button" class="ra-btn is-primary" id="raBtnStep100">Train 100 steps</button>
                        <button type="button" class="ra-btn" id="raBtnAuto">&#9656; Auto-train</button>
                        <button type="button" class="ra-btn" id="raBtnResetW">Reset weights</button>
                        <button type="button" class="ra-btn" id="raBtnClear">Clear points</button>
                    </div>
                    <div class="ra-preset-row">
                        <span class="ra-preset-label">Preset</span>
                        <button class="ra-preset" id="raPresetBlobs">two blobs</button>
                        <button class="ra-preset" id="raPresetBalanced">balanced</button>
                        <button class="ra-preset" id="raPresetOverlap">overlap</button>
                        <button class="ra-preset" id="raPresetImbalanced">imbalanced</button>
                        <button class="ra-preset" id="raPresetPerfect">near-perfect</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- ── Theory & exercises — collapsed by default ─────── -->
        <details class="ra-collapse">
            <summary>Theory &amp; exercises &middot; math derivation, watch-outs, and ideas to try</summary>
            <div class="ra-collapse-body">

        <!-- Math card -->
        <div>
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, derived</h2>
            <div class="ra-math">
                <div class="ra-math-step">
                    <h4>1. The four counts.</h4>
                    <p>Pick a threshold $\tau$. For each example with probability $\hat{p}_i$ and label $t_i$, the predicted class is $\hat{y}_i = \mathbf{1}[\hat{p}_i \ge \tau]$. Tally:</p>
                    $$ \text{TP, FP, FN, TN} \;=\; \text{counts of } (\hat{y},\, t) \in \{(1,1),(1,0),(0,1),(0,0)\} $$
                </div>
                <div class="ra-math-step">
                    <h4>2. The two rates.</h4>
                    <p>$$ \text{TPR (recall)} \;=\; \frac{TP}{TP + FN} \qquad \text{FPR} \;=\; \frac{FP}{FP + TN} \qquad \text{Precision} \;=\; \frac{TP}{TP + FP} $$</p>
                    <p style="margin-top:0.4rem;">As $\tau$ falls, more examples are predicted positive &mdash; TPR rises (good!), FPR rises (bad), precision usually falls. The whole game is in the trade-off.</p>
                </div>
                <div class="ra-math-step">
                    <h4>3. ROC AUC &mdash; sweep all thresholds.</h4>
                    <p>Plot $(\text{FPR}(\tau),\, \text{TPR}(\tau))$ for every $\tau \in [0, 1]$. The area under the curve is</p>
                    $$ \text{AUC} \;=\; \int_0^1 \text{TPR}(\text{FPR}^{-1}(u))\, du \;=\; \Pr\big[\,\hat{p}_{+} > \hat{p}_{-}\,\big] $$
                    <p style="margin-top:0.4rem;">The last equality is the key intuition: AUC is the probability that a randomly chosen positive example is ranked higher than a randomly chosen negative one. <strong>Threshold-independent.</strong></p>
                </div>
                <div class="ra-math-step">
                    <h4>4. PR AUC &mdash; the imbalance-aware sibling.</h4>
                    <p>Plot precision vs recall as $\tau$ sweeps. PR AUC (a.k.a. <em>average precision</em>):</p>
                    $$ \text{AP} \;=\; \sum_{i} \big(\text{recall}_i - \text{recall}_{i-1}\big)\,\text{precision}_i $$
                    <p style="margin-top:0.4rem;">On a 99/1 imbalanced dataset, ROC AUC can be near 1.0 even when the classifier is barely better than majority-class. PR AUC stays sensitive because true negatives don&rsquo;t enter the formulas at all.</p>
                </div>
                <div class="ra-math-step">
                    <h4>5. F1 &mdash; the harmonic mean.</h4>
                    <p>If you have to pick one $\tau$, F1 combines precision and recall into a single score (penalizing extreme imbalances between the two):</p>
                    $$ F_1 \;=\; \frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}} $$
                    <p style="margin-top:0.4rem;">Pick $\tau$ to maximize F1 when you don&rsquo;t have a domain-specific cost matrix for FP vs FN.</p>
                </div>
            </div>
        </div>

        <!-- Try this -->
        <div>
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
            <div class="ra-try">
                <div class="ra-try-item">
                    <h4>Operating-point sweep</h4>
                    <p>Slide <code>&tau;</code> from <code>0.05</code> to <code>0.95</code>. Watch the magenta dot trace the entire ROC curve. At <code>τ → 1</code>, FPR=0 and TPR=0 (predict nothing positive). At <code>τ → 0</code>, both are 1.</p>
                </div>
                <div class="ra-try-item">
                    <h4>Imbalanced data → use PR</h4>
                    <p>Hit <code>imbalanced</code>. Auto-train a bit. Notice ROC AUC stays high (~0.9+) while PR AUC dips. The PR view tells the truth about minority-class performance.</p>
                </div>
                <div class="ra-try-item">
                    <h4>Find the F1-optimal threshold</h4>
                    <p>On the <code>overlap</code> dataset after training, slide <code>&tau;</code> until F1 peaks. It&rsquo;s usually <em>not</em> 0.5 — depends on class balance and the cost of each error type.</p>
                </div>
                <div class="ra-try-item">
                    <h4>Perfect separability</h4>
                    <p>Hit <code>near-perfect</code> and Auto-train. ROC curve hugs the top-left, AUC ≈ 1.0. Confusion matrix shows zero (or near-zero) off-diagonals at <code>τ = 0.5</code>.</p>
                </div>
                <div class="ra-try-item">
                    <h4>An "anti-classifier"</h4>
                    <p>Hit <code>blobs</code>, then manually set <code>w&#8320; = -1, w&#8321; = -1, b = 0</code> (without training). ROC AUC drops below 0.5 — the model is anti-correlated with the truth. Inverting predictions would beat it.</p>
                </div>
                <div class="ra-try-item">
                    <h4>Confusion-matrix sweep</h4>
                    <p>At each <code>&tau;</code>, the four cells trade off. Lower τ: TP and FP up, TN and FN down. The four metrics in the KPI row each respond differently — F1 most stably, accuracy least.</p>
                </div>
            </div>
        </div>

        <!-- Chip strips -->
        <div>
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
            <div class="ra-strip is-watchout">
                <span class="ra-strip-label">&#9888;&#65039; Watch out</span>
                <span class="ra-tag">ROC AUC on imbalanced data</span>
                <span class="ra-tag">τ = 0.5 by default</span>
                <span class="ra-tag">Single metric reporting</span>
                <span class="ra-tag">No baseline</span>
                <span class="ra-tag">Cherry-picked τ</span>
            </div>
            <div class="ra-strip is-practice">
                <span class="ra-strip-label">&#128295; In practice</span>
                <span class="ra-tag">roc_auc_score</span>
                <span class="ra-tag">average_precision_score</span>
                <span class="ra-tag">classification_report</span>
                <span class="ra-tag">precision_recall_curve</span>
                <span class="ra-tag">f1_score</span>
            </div>
        </div>

            </div>
        </details>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="ROC/AUC FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What does AUC actually measure?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The probability that a randomly chosen positive example is ranked higher than a randomly chosen negative example. <strong>AUC = 1.0</strong> means perfect ranking; <strong>AUC = 0.5</strong> is random; below 0.5 means the model is anti-correlated (you&rsquo;d do better flipping the predictions). Crucially, AUC is <strong>threshold-independent</strong> &mdash; it measures the model&rsquo;s ability to rank, not its accuracy at any single τ.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        ROC AUC vs PR AUC &mdash; when do they disagree?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">ROC AUC treats true negatives equally with true positives. On imbalanced data (e.g., 99/1 split), a model that predicts mostly the majority class can have a deceptively high ROC AUC &mdash; the FPR denominator is huge so even many false positives barely move the curve. <strong>PR AUC ignores true negatives entirely</strong>, so it stays sensitive to performance on the minority class. Rule of thumb: imbalanced data → look at PR AUC, not ROC AUC.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        How do I pick the right threshold?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Depends on which error is more expensive. If false positives are costly (flagging legit transactions as fraud), <strong>raise τ</strong>. If false negatives are costly (missing a cancer diagnosis), <strong>lower τ</strong>. F1 balances both. For calibrated probabilities, τ = 0.5 is a starting point &mdash; but for most real problems, the optimal τ is found by maximizing F1 or by a cost-benefit analysis.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does the ROC curve look stepped?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Each step corresponds to one training example changing its predicted class as the threshold sweeps past its predicted probability. With <strong>more data points</strong>, the curve becomes smoother. With fewer points it&rsquo;s blocky &mdash; useful for seeing the discrete nature of the sweep but cosmetically rougher.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/roc-auc.js?v=<%=v%>" defer></script>
</body>
</html>
