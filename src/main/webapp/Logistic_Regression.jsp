<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Logistic Regression Visualized — Watch a Binary Classifier Learn" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive logistic regression demo. Click to add points, watch gradient descent fit a decision boundary, see the loss curve fall iteration by iteration. Five preset datasets cover the cases where logistic regression shines and where it fails (XOR). No signup." />
        <jsp:param name="toolUrl" value="Logistic_Regression.jsp" />
        <jsp:param name="toolImage" value="logistic-regression-og.png" />
        <jsp:param name="toolKeywords" value="logistic regression visualizer, binary classification, sigmoid decision boundary, gradient descent demo, cross entropy loss, l2 regularization, xor logistic regression, ml from scratch, interactive classifier" />
        <jsp:param name="toolFeatures" value="Click-to-add training points,5 preset datasets: blobs/balanced/overlap/imbalanced/XOR,Live decision boundary + probability field,Training loss curve updates per step,L2 regularization slider,Auto-train mode,Confusion matrix at any threshold,Editable sliders for w_0/w_1/b/lr/lambda/threshold,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Add data|Click anywhere on the chart to drop points then toggle the class dropdown to switch which class you're adding,Train|Hit Train 1 step Train 100 steps or Auto-train — watch the decision boundary rotate and the loss curve fall on the right,Tune|Slide the learning rate L2 lambda and threshold to see how each affects convergence accuracy and confusion-matrix balance" />
        <jsp:param name="faq1q" value="What is logistic regression?" />
        <jsp:param name="faq1a" value="A linear classifier for binary outcomes. It computes z = w_0·x + w_1·y + b, then squashes z through the sigmoid to get a probability p = σ(z) = 1 / (1 + e^{-z}). Predict class 1 if p > τ (typically 0.5). Training fits w_0, w_1, b by minimizing cross-entropy loss via gradient descent — the same idea as linear regression but with a probability output." />
        <jsp:param name="faq2q" value="Why XOR fails?" />
        <jsp:param name="faq2a" value="XOR has four clusters at the corners — class 1 at (top-left, bottom-right) and class 0 at (top-right, bottom-left). No single straight line can separate them; linear classifiers can't fit non-linearly separable data. This is the canonical motivation for neural networks (multiple stacked linear+activation layers) or kernel methods." />
        <jsp:param name="faq3q" value="What does L2 regularization do?" />
        <jsp:param name="faq3a" value="It adds a λ·(w_0² + w_1²) term to the loss, which penalizes large weights. The effect: the decision boundary stays gentler (closer to flat), the model resists overfitting noisy data, and gradients shrink the weights every step. On the overlap dataset, try λ = 0.05 — the boundary becomes smoother and accuracy is more stable." />
        <jsp:param name="faq4q" value="Why does logistic regression use cross-entropy and not MSE?" />
        <jsp:param name="faq4a" value="MSE on probabilities gives a non-convex loss surface and slow training. Cross-entropy is convex for logistic regression and pairs naturally with the sigmoid — the gradient simplifies to (p - y)·x, which is what we use in the algorithm. Cross-entropy also penalizes confident wrong predictions much harder than MSE would." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/logistic-regression.css?v=<%=v%>">

    <%-- KaTeX for the math card --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

    <%-- Chart.js for the boundary + loss-curve charts --%>
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

    <% request.setAttribute("activeService", "logistic-regression"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Logistic Regression, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Linear Models &middot; Logistic Regression
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Linear Models</span>
            </div>
            <p style="margin:1rem 0 0;color:var(--ms-ink-soft);font:0.95rem/1.55 var(--ms-font-sans);max-width:72ch;">
                <strong>Logistic regression</strong> learns a straight line that separates two classes, then squashes the signed distance through a sigmoid to produce a probability. Click the chart to drop points, hit <strong>Train</strong>, and watch the boundary rotate while the loss curve falls on the right. For threshold/AUC/precision-recall exploration, head to <a href="<%=request.getContextPath()%>/ROC_AUC.jsp" style="color:#4f46e5;">ROC &amp; AUC</a>.
            </p>
        </div>

        <!-- Demo: boundary chart + loss curve -->
        <div class="ms-card">
            <div class="lr-demo">
                <div class="lr-canvas-wrap is-main">
                    <span class="lr-canvas-label">Data &middot; decision boundary &middot; probability field (toggle)</span>
                    <div class="lr-canvas-area">
                        <canvas id="lrChart" aria-label="Scatter plot with logistic regression boundary"></canvas>
                    </div>
                    <div class="lr-canvas-footer">
                        <div class="lr-legend">
                            <span><span class="lr-legend-dot lr-c0"></span>Class 0</span>
                            <span><span class="lr-legend-dot lr-c1"></span>Class 1</span>
                            <span style="color:var(--ms-muted);">&middot; line: w&#8320;&middot;x + w&#8321;&middot;y + b = 0</span>
                        </div>
                        <span class="lr-probe" id="lrProbe">hover the chart to probe &sigma;(w&middot;x + b)</span>
                    </div>
                    <%-- Class indicator + cursor-hint for click-to-add --%>
                    <div style="margin-top:0.65rem;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:0.5rem;">
                        <button type="button" class="lr-class-indicator" id="lrClassIndicator" data-class="1" aria-label="Click to switch class to add">
                            <span class="lr-class-indicator-dot"></span>
                            <span>Adding to <strong id="lrClassIndicatorText">Class 1</strong></span>
                            <span class="lr-class-indicator-hint">click to switch &middot; then click the chart to drop points</span>
                        </button>
                    </div>
                </div>
                <div class="lr-canvas-wrap is-side">
                    <span class="lr-canvas-label">Loss curve &middot; cross-entropy + L2</span>
                    <div class="lr-canvas-area">
                        <canvas id="lrLossChart" aria-label="Training loss over steps"></canvas>
                    </div>
                    <div class="lr-canvas-footer">
                        <span style="font:italic 0.78rem var(--ms-font-sans);color:var(--ms-muted);">
                            Monotonically falling on convex data &mdash; a flat curve means the model has converged (or stalled).
                        </span>
                    </div>
                </div>
            </div>

            <!-- KPI row -->
            <div class="lr-kpi-grid">
                <div class="lr-kpi"><div class="lr-kpi-label">Log loss</div><div class="lr-kpi-value" id="lrKLoss">—</div></div>
                <div class="lr-kpi"><div class="lr-kpi-label">&Delta;Loss</div><div class="lr-kpi-value" id="lrKDelta">—</div></div>
                <div class="lr-kpi"><div class="lr-kpi-label">Accuracy</div><div class="lr-kpi-value" id="lrKAcc">—</div></div>
                <div class="lr-kpi"><div class="lr-kpi-label">Steps</div><div class="lr-kpi-value" id="lrKSteps">0</div></div>
                <div class="lr-kpi"><div class="lr-kpi-label">N points</div><div class="lr-kpi-value" id="lrKN">0</div></div>
            </div>

            <%-- Hidden state — replaced by the click-to-toggle class indicator above. --%>
            <select id="lrClassSel" style="display:none;"><option value="1" selected>Class 1</option><option value="0">Class 0</option></select>

            <div class="lr-actions">
                <button type="button" class="lr-btn is-primary" id="lrBtnStep">Train 1 step</button>
                <button type="button" class="lr-btn is-primary" id="lrBtnStep100">Train 100 steps</button>
                <button type="button" class="lr-btn" id="lrBtnAuto">&#9656; Auto-train</button>
                <button type="button" class="lr-btn is-warn" id="lrBtnResetW">Reset weights</button>
                <button type="button" class="lr-btn" id="lrBtnClear">Clear points</button>
            </div>

            <div class="lr-preset-row">
                <span class="lr-preset-label">Preset</span>
                <button class="lr-preset" id="lrPresetBlobs">two blobs</button>
                <button class="lr-preset" id="lrPresetBalanced">balanced</button>
                <button class="lr-preset" id="lrPresetOverlap">overlap</button>
                <button class="lr-preset" id="lrPresetImbalanced">imbalanced</button>
                <button class="lr-preset" id="lrPresetXOR">XOR (fails)</button>
            </div>
        </div>

        <!-- Tune the model — controls grouped by what they actually are -->
        <div class="ms-card">
            <h2 style="font:500 1.15rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                Tune the model
            </h2>

            <div class="lr-control-group">
                <div class="lr-control-group-head">
                    <span class="lr-cgh-label">Parameters</span>
                    <span class="lr-cgh-desc">&mdash; what gradient descent learns. You can also drag these by hand to draw a boundary.</span>
                </div>
                <div class="lr-control-group-body">
                    <div class="lr-control">
                        <div class="lr-control-label"><span>w&#8320;</span><input type="number" id="lrW0Num" step="0.1" value="1" style="width:80px;text-align:right;"></div>
                        <input type="range" id="lrW0" min="-5" max="5" step="0.01" value="1">
                        <div class="lr-control-sublabel">slope along x</div>
                    </div>
                    <div class="lr-control">
                        <div class="lr-control-label"><span>w&#8321;</span><input type="number" id="lrW1Num" step="0.1" value="-1" style="width:80px;text-align:right;"></div>
                        <input type="range" id="lrW1" min="-5" max="5" step="0.01" value="-1">
                        <div class="lr-control-sublabel">slope along y</div>
                    </div>
                    <div class="lr-control">
                        <div class="lr-control-label"><span>b</span><input type="number" id="lrBNum" step="0.1" value="0" style="width:80px;text-align:right;"></div>
                        <input type="range" id="lrB" min="-5" max="5" step="0.01" value="0">
                        <div class="lr-control-sublabel">offset / intercept</div>
                    </div>
                </div>
            </div>

            <div class="lr-control-group">
                <div class="lr-control-group-head">
                    <span class="lr-cgh-label">Hyperparameters</span>
                    <span class="lr-cgh-desc">&mdash; you set these. They control <em>how</em> training behaves.</span>
                </div>
                <div class="lr-control-group-body">
                    <div class="lr-control">
                        <div class="lr-control-label"><span>&eta;</span><input type="number" id="lrLrNum" step="0.001" value="0.1" style="width:80px;text-align:right;"></div>
                        <input type="range" id="lrLr" min="0.001" max="1" step="0.001" value="0.1">
                        <div class="lr-control-sublabel">learning rate &mdash; gradient-descent step size</div>
                    </div>
                    <div class="lr-control">
                        <div class="lr-control-label"><span>&lambda;</span><input type="number" id="lrLamNum" step="0.001" value="0" style="width:80px;text-align:right;"></div>
                        <input type="range" id="lrLam" min="0" max="0.2" step="0.001" value="0">
                        <div class="lr-control-sublabel">L2 strength &mdash; penalty on big weights</div>
                    </div>
                    <div class="lr-control">
                        <div class="lr-control-label"><span>Probability field</span></div>
                        <label class="lr-control-checkbox"><input type="checkbox" id="lrShowField" checked><span>shade by &sigma;(w&middot;x + b)</span></label>
                        <div class="lr-control-sublabel">what the model thinks <em>everywhere</em>, not just along the line</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Evaluate — threshold and its consequences, together in ONE card -->
        <div class="ms-card">
            <h2 style="font:500 1.15rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                Evaluate
            </h2>

            <div class="lr-control-group">
                <div class="lr-control-group-head">
                    <span class="lr-cgh-label">Threshold &tau;</span>
                    <span class="lr-cgh-desc">&mdash; turn the probability into a hard prediction. <em>Drag the slider &mdash; the confusion matrix below moves with it.</em></span>
                </div>
                <div class="lr-control-group-body" style="grid-template-columns:1fr;">
                    <div class="lr-control">
                        <div class="lr-control-label"><span>&tau;</span><input type="number" id="lrThNum" step="0.01" value="0.5" style="width:80px;text-align:right;"></div>
                        <input type="range" id="lrTh" min="0.05" max="0.95" step="0.01" value="0.5">
                        <div class="lr-control-sublabel">predict Class 1 when &sigma;(w&middot;x + b) &ge; &tau;</div>
                    </div>
                </div>
            </div>

            <div class="lr-cm-wrap" style="padding:0;border:none;background:transparent;margin-top:0.85rem;">
                <div class="lr-cm-label">Confusion matrix at threshold &tau;</div>
                <div class="lr-cm">
                    <div></div>
                    <div class="lr-cm-header">Predicted 0</div>
                    <div class="lr-cm-header">Predicted 1</div>
                    <div class="lr-cm-row-label">Actual 0</div>
                    <div class="lr-cm-cell is-correct" id="lrCmTN">—<span class="lr-cm-cell-subtitle">TN</span></div>
                    <div class="lr-cm-cell is-error"   id="lrCmFP">—<span class="lr-cm-cell-subtitle">FP &middot; type I</span></div>
                    <div class="lr-cm-row-label">Actual 1</div>
                    <div class="lr-cm-cell is-error"   id="lrCmFN">—<span class="lr-cm-cell-subtitle">FN &middot; type II</span></div>
                    <div class="lr-cm-cell is-correct" id="lrCmTP">—<span class="lr-cm-cell-subtitle">TP</span></div>
                </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Math card -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, derived</h2>
            <div class="lr-math">
                <div class="lr-math-step">
                    <h4>1. The model.</h4>
                    <p>Combine the inputs linearly, then squash through a sigmoid to get a probability:</p>
                    $$ z \;=\; w_0\,x + w_1\,y + b \qquad \hat{p} \;=\; \sigma(z) \;=\; \frac{1}{1 + e^{-z}} $$
                    <p style="margin-top:0.4rem;">$\hat{p} \in (0, 1)$ is interpreted as <em>probability of class 1</em>. Predict class 1 when $\hat{p} > \tau$.</p>
                </div>
                <div class="lr-math-step">
                    <h4>2. The loss &mdash; binary cross-entropy.</h4>
                    <p>For each example $(x_i, y_i)$ with label $t_i \in \{0, 1\}$:</p>
                    $$ L \;=\; -\frac{1}{N} \sum_{i=1}^{N} \Big[\, t_i \log \hat{p}_i + (1 - t_i)\log(1 - \hat{p}_i) \,\Big] $$
                    <p style="margin-top:0.4rem;">Cross-entropy is <strong>convex</strong> in $(w_0, w_1, b)$ &mdash; gradient descent finds the global optimum (if you give it enough steps).</p>
                </div>
                <div class="lr-math-step">
                    <h4>3. The gradient.</h4>
                    <p>The chain rule makes the gradient surprisingly clean &mdash; the sigmoid&rsquo;s derivative cancels nicely against the log:</p>
                    $$ \frac{\partial L}{\partial w_0} \;=\; \frac{1}{N}\sum_i (\hat{p}_i - t_i)\,x_i \qquad
                       \frac{\partial L}{\partial b}  \;=\; \frac{1}{N}\sum_i (\hat{p}_i - t_i) $$
                    <p style="margin-top:0.4rem;">Same shape as linear regression. Add $+\,2\lambda w_0$ to the $w_0$ gradient (and similarly for $w_1$) if you want L2 regularization.</p>
                </div>
                <div class="lr-math-step">
                    <h4>4. The update.</h4>
                    <p>Step opposite the gradient, scaled by the learning rate:</p>
                    $$ w_0 \leftarrow w_0 - \eta\,\frac{\partial L}{\partial w_0} \qquad
                       w_1 \leftarrow w_1 - \eta\,\frac{\partial L}{\partial w_1} \qquad
                       b   \leftarrow b   - \eta\,\frac{\partial L}{\partial b} $$
                    <p style="margin-top:0.4rem;">Repeat until the loss curve flattens. If it overshoots and bounces, lower $\eta$. If it crawls, raise $\eta$ (carefully).</p>
                </div>
            </div>
        </div>

        <!-- Try this -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
            <div class="lr-try">
                <div class="lr-try-item">
                    <h4>The XOR wall</h4>
                    <p>Hit <code>XOR</code> and Auto-train. Watch the boundary thrash &mdash; no single line separates four corners. This is what motivated multi-layer perceptrons in the 1980s.</p>
                </div>
                <div class="lr-try-item">
                    <h4>Learning rate explosion</h4>
                    <p>On <code>blobs</code>, crank <code>&eta;</code> to <code>0.8+</code> and train. Loss spikes, weights swing wildly. The boundary may flip back and forth across runs. Halve and retry.</p>
                </div>
                <div class="lr-try-item">
                    <h4>Regularization tightens the line</h4>
                    <p>On <code>overlap</code>, train without L2, then with <code>&lambda; = 0.05</code>. The regularized boundary is straighter &mdash; weights are smaller, the model is humbler.</p>
                </div>
                <div class="lr-try-item">
                    <h4>Threshold-induced trade-off</h4>
                    <p>Slide <code>&tau;</code> from <code>0.3</code> to <code>0.7</code>. The confusion matrix shifts: lower &tau; catches more positives (TP up, FN down) but also more false alarms (FP up). For threshold sweeping with ROC/AUC, see the <a href="<%=request.getContextPath()%>/ROC_AUC.jsp">metrics page</a>.</p>
                </div>
                <div class="lr-try-item">
                    <h4>Imbalanced reality</h4>
                    <p><code>imbalanced</code> has 20 negatives, 100 positives. Notice 95% accuracy from the start &mdash; that&rsquo;s near the trivial majority-class baseline. Accuracy lies on imbalanced data; use F1 or AUC instead.</p>
                </div>
                <div class="lr-try-item">
                    <h4>Hand-set the boundary</h4>
                    <p>Without training, slide <code>w&#8320;, w&#8321;, b</code> to draw a line that separates the data by eye. Compare your accuracy to gradient descent&rsquo;s &mdash; humans can match it on easy data.</p>
                </div>
            </div>
        </div>

        <!-- Chip strips -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
            <div class="lr-strip is-watchout">
                <span class="lr-strip-label">&#9888;&#65039; Watch out</span>
                <span class="lr-tag">Linear-only — can&rsquo;t do XOR</span>
                <span class="lr-tag">No feature scaling</span>
                <span class="lr-tag">Ignore class imbalance</span>
                <span class="lr-tag">Accuracy on 95/5 split</span>
                <span class="lr-tag">High &eta; diverges</span>
            </div>
            <div class="lr-strip is-practice">
                <span class="lr-strip-label">&#128295; In practice</span>
                <span class="lr-tag">sklearn.linear_model.LogisticRegression</span>
                <span class="lr-tag">class_weight='balanced'</span>
                <span class="lr-tag">StandardScaler first</span>
                <span class="lr-tag">L2 by default (C=1.0)</span>
                <span class="lr-tag">cross_val_score</span>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Logistic regression FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is logistic regression?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">A linear classifier for binary outcomes. It computes $z = w_0 x + w_1 y + b$, then squashes $z$ through the sigmoid to get a probability $\hat{p} = \sigma(z) = 1/(1 + e^{-z})$. Predict class 1 if $\hat{p} > \tau$ (typically 0.5). Training fits $w_0, w_1, b$ by minimizing cross-entropy loss via gradient descent &mdash; the same idea as linear regression but with a probability output.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does XOR fail?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">XOR has four clusters at the corners &mdash; class 1 at top-left + bottom-right, class 0 at top-right + bottom-left. No single straight line can separate them; linear classifiers can&rsquo;t fit non-linearly separable data. This is the canonical motivation for <strong>neural networks</strong> (multiple stacked linear+activation layers) or <strong>kernel methods</strong>.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What does L2 regularization do?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">It adds a $\lambda(w_0^2 + w_1^2)$ term to the loss, which penalizes large weights. The effect: the decision boundary stays gentler, the model resists overfitting noisy data, and gradients shrink the weights every step. On the <code>overlap</code> dataset, try $\lambda = 0.05$ &mdash; the boundary becomes smoother and accuracy is more stable.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why cross-entropy and not MSE?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">MSE on probabilities gives a non-convex loss surface and slow training. Cross-entropy is <strong>convex</strong> for logistic regression and pairs naturally with the sigmoid &mdash; the gradient simplifies to $(p - y) \cdot x$, which is what we use in the algorithm. Cross-entropy also penalizes confident-wrong predictions much harder than MSE would.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/logistic-regression.js?v=<%=v%>" defer></script>
</body>
</html>
