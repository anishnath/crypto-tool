<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Perceptron Visualized — Watch the Hyperplane Move in 3D" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive 3D perceptron demo. Drop a hyperplane between two classes, train it with the perceptron rule, and watch the normal vector rotate as misclassified points push it back into place. Six datasets — from textbook-separable to 3D XOR (where it provably fails). No signup." />
        <jsp:param name="toolUrl" value="ml/perceptron.jsp" />
        <jsp:param name="toolImage" value="perceptron-og.png" />
        <jsp:param name="toolKeywords" value="perceptron visualizer, 3d perceptron, rosenblatt perceptron, hinge loss, novikoff convergence theorem, linear classifier, hyperplane decision boundary, binary classification, ml from scratch, perceptron algorithm" />
        <jsp:param name="toolFeatures" value="3D scatter + decision hyperplane + normal vector arrow,Hinge loss curve updates per epoch,Six datasets covering separable and non-separable cases,Convergence banner with Novikoff theorem reference,Editable w_0/w_1/w_2/b/η sliders,Auto-train mode with convergence-aware stop,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a dataset|Start with two blobs in 3D — clearly separable. Then try XOR or concentric shells to see where perceptron fails,Train|Click Train 100 epochs and watch the decision plane rotate as misclassified points push it. The orange rings mark points the current plane gets wrong,Read the convergence banner|On separable data a green Converged banner appears with the epoch count. On XOR/shells it stays missing forever — the data isn't linearly separable" />
        <jsp:param name="faq1q" value="What is a perceptron?" />
        <jsp:param name="faq1a" value="The original neural network (Rosenblatt, 1958). A single neuron that takes a weighted sum of inputs plus a bias, and outputs +1 if the result is positive, -1 otherwise. Training adjusts the weights using the perceptron rule: w ← w + η·y·x for each misclassified point. It's the simplest learnable model — and the ancestor of every modern neural network." />
        <jsp:param name="faq2q" value="How is the perceptron different from logistic regression?" />
        <jsp:param name="faq2a" value="Same model class (a linear separator), but different output and loss. Perceptron predicts a hard ±1 class via sign(w·x + b); logistic regression predicts a probability via σ(w·x + b). Perceptron uses hinge loss (zero on correct, positive on wrong); logistic regression uses cross-entropy (smooth, differentiable everywhere). Logistic regression therefore gives calibrated probabilities and works under gradient methods; perceptron is faster but binary-only." />
        <jsp:param name="faq3q" value="What is Novikoff's convergence theorem?" />
        <jsp:param name="faq3a" value="If the training data is linearly separable with margin γ (the distance from the closest point to the optimal hyperplane), and all points satisfy ||x|| ≤ R, then the perceptron algorithm converges in at most (R/γ)² updates — regardless of dimension. This guarantee made the perceptron historically important: it was the first machine-learning algorithm with a proof that it works." />
        <jsp:param name="faq4q" value="When does the perceptron fail?" />
        <jsp:param name="faq4a" value="Whenever the data is not linearly separable. Classic examples: XOR (no plane separates the four / eight corners), concentric shells (both classes share the origin), and any noisy real-world classification problem. Minsky and Papert proved this in 1969, and the limitation killed perceptron research for a decade until multi-layer networks were figured out — exactly the failure mode the XOR preset demonstrates here." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link rel="preconnect" href="https://cdn.plot.ly" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/perceptron.css?v=<%=v%>">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

    <%-- Plotly 3D for the scene + Chart.js for the loss curve --%>
    <script defer src="https://cdn.plot.ly/plotly-gl3d-2.27.0.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

    <%@ include file="../modern/ads/ad-init.jsp" %>
</head>
<body class="ms-body">

<jsp:include page="../modern/components/nav-header.jsp" />
<jsp:include page="/math/partials/matter-bg.jsp" />

<div class="ms-hero">
    <%@ include file="../modern/ads/ad-hero-banner.jsp" %>
</div>

<main class="ms-main">

    <button type="button" id="msSidebarToggle" class="ms-sidebar-toggle" aria-label="Open ML demos menu">
        &#9776; ML demos
    </button>

    <% request.setAttribute("activeService", "perceptron"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Perceptron, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Linear Models &middot; Perceptron
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Linear Models</span>
            </div>
            <p style="margin:0.85rem 0 0;color:var(--ms-ink-soft);font:0.92rem/1.55 var(--ms-font-sans);max-width:72ch;">
                The <strong>perceptron</strong> (Rosenblatt, 1958) is the original neural network &mdash; one neuron that learns to separate two classes with a hyperplane. The plane below has normal vector <strong>w</strong>; train it and watch <strong>w</strong> rotate as each misclassified point pushes the boundary back into place. For probabilities and gradient descent, see <a href="<%=request.getContextPath()%>/Logistic_Regression.jsp" style="color:#4f46e5;">Logistic Regression &rarr;</a>.
            </p>
        </div>

        <!-- 3D scene + loss + KPIs + convergence -->
        <div class="ms-card">

            <div class="pn-3d-wrap">
                <div class="pn-3d-label">
                    <span>Decision hyperplane &middot; drag to rotate, scroll to zoom</span>
                    <span class="pn-readout" id="pn3dReadout"></span>
                </div>
                <div class="pn-3d-area">
                    <div id="pn3d" class="pn-3d" aria-label="3D scatter with decision hyperplane"></div>
                </div>
                <div class="pn-legend">
                    <span><span class="pn-legend-dot pn-pos"></span>class +1</span>
                    <span><span class="pn-legend-dot pn-neg"></span>class &minus;1</span>
                    <span><span class="pn-legend-dot pn-mis"></span>misclassified (currently wrong)</span>
                    <span><span class="pn-legend-dot pn-plane"></span>decision plane: w&middot;x + b = 0</span>
                    <span><span class="pn-legend-dot pn-norm"></span>normal vector w</span>
                </div>
            </div>

            <div class="pn-loss-wrap">
                <div class="pn-loss-label">
                    <span>Hinge loss per epoch</span>
                    <span id="pnLossReadout" style="color:var(--ms-ink-soft);font-weight:500;text-transform:none;letter-spacing:0;"></span>
                </div>
                <div class="pn-loss-area">
                    <canvas id="pnLoss" aria-label="Hinge loss over training epochs"></canvas>
                </div>
            </div>

            <!-- KPI row -->
            <div class="pn-kpi-grid">
                <div class="pn-kpi"><div class="pn-kpi-label">Epoch</div><div class="pn-kpi-value" id="pnKEpoch">0</div></div>
                <div class="pn-kpi"><div class="pn-kpi-label">Hinge loss</div><div class="pn-kpi-value" id="pnKLoss">—</div></div>
                <div class="pn-kpi"><div class="pn-kpi-label">Misclassified</div><div class="pn-kpi-value" id="pnKMis">—</div></div>
                <div class="pn-kpi"><div class="pn-kpi-label">N points</div><div class="pn-kpi-value" id="pnKN">0</div></div>
            </div>

            <!-- Convergence banner — appears when 0 misclassified or stuck -->
            <div class="pn-converge" id="pnConverge"></div>
        </div>

        <!-- Tune the model -->
        <div class="ms-card">
            <h2 style="font:500 1.15rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                Tune the model
            </h2>

            <div class="pn-control-group">
                <div class="pn-control-group-head">
                    <span class="pn-cgh-label">Parameters</span>
                    <span class="pn-cgh-desc">&mdash; the hyperplane is defined by these. Training learns them; you can also drag by hand.</span>
                </div>
                <div class="pn-control-group-body">
                    <div class="pn-control">
                        <div class="pn-control-label"><span>w&#8320;</span><input type="number" id="pnW0Num" step="0.01" value="1" style="width:80px;text-align:right;"></div>
                        <input type="range" id="pnW0" min="-2" max="2" step="0.01" value="1">
                        <div class="pn-control-sublabel">x-component of normal</div>
                    </div>
                    <div class="pn-control">
                        <div class="pn-control-label"><span>w&#8321;</span><input type="number" id="pnW1Num" step="0.01" value="-1" style="width:80px;text-align:right;"></div>
                        <input type="range" id="pnW1" min="-2" max="2" step="0.01" value="-1">
                        <div class="pn-control-sublabel">y-component of normal</div>
                    </div>
                    <div class="pn-control">
                        <div class="pn-control-label"><span>w&#8322;</span><input type="number" id="pnW2Num" step="0.01" value="1" style="width:80px;text-align:right;"></div>
                        <input type="range" id="pnW2" min="-2" max="2" step="0.01" value="1">
                        <div class="pn-control-sublabel">z-component of normal</div>
                    </div>
                    <div class="pn-control">
                        <div class="pn-control-label"><span>b</span><input type="number" id="pnBNum" step="0.01" value="0" style="width:80px;text-align:right;"></div>
                        <input type="range" id="pnB" min="-2" max="2" step="0.01" value="0">
                        <div class="pn-control-sublabel">bias / offset from origin</div>
                    </div>
                </div>
            </div>

            <div class="pn-control-group">
                <div class="pn-control-group-head">
                    <span class="pn-cgh-label">Hyperparameter</span>
                    <span class="pn-cgh-desc">&mdash; you set this. Controls how big each update step is.</span>
                </div>
                <div class="pn-control-group-body">
                    <div class="pn-control">
                        <div class="pn-control-label"><span>&eta;</span><input type="number" id="pnEtaNum" step="0.005" value="0.05" style="width:80px;text-align:right;"></div>
                        <input type="range" id="pnEta" min="0.005" max="0.3" step="0.005" value="0.05">
                        <div class="pn-control-sublabel">learning rate &mdash; size of each weight update</div>
                    </div>
                </div>
            </div>

            <div class="pn-actions">
                <button type="button" class="pn-btn is-primary" id="pnBtnStep">Train 1 epoch</button>
                <button type="button" class="pn-btn is-primary" id="pnBtnStep100">Train 100 epochs</button>
                <button type="button" class="pn-btn" id="pnBtnAuto">&#9656; Auto-train</button>
                <button type="button" class="pn-btn is-warn" id="pnBtnResetW">Reset weights</button>
                <button type="button" class="pn-btn" id="pnBtnRegen">Regenerate data</button>
            </div>

            <div class="pn-preset-row">
                <span class="pn-preset-label">Preset</span>
                <button class="pn-preset" id="pnPresetBlobs">two blobs</button>
                <button class="pn-preset" id="pnPresetHyper">hyperplane grid</button>
                <button class="pn-preset" id="pnPresetSlabs">two slabs</button>
                <button class="pn-preset" id="pnPresetOverlap">overlap</button>
                <button class="pn-preset" id="pnPresetXor">XOR (fails)</button>
                <button class="pn-preset" id="pnPresetShells">shells (fails)</button>
            </div>

            <%-- Hidden dataset selector for JS API parity; updated by preset buttons. --%>
            <select id="pnDataset" style="display:none;">
                <option value="blobs3d" selected>Two blobs in 3D</option>
                <option value="hyperplane">Hyperplane grid</option>
                <option value="slabs">Two parallel slabs</option>
                <option value="overlap">Overlapping blobs</option>
                <option value="xor3d">XOR (3D parity)</option>
                <option value="shells">Concentric shells</option>
            </select>
            <p id="pnDatasetStory" style="font:italic 0.84rem var(--ms-font-sans);color:var(--ms-muted);margin:0.6rem 0 0;">
                Linearly separable &mdash; perceptron converges in tens of epochs.
            </p>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Math card -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, derived</h2>
            <div class="pn-math">
                <div class="pn-math-step">
                    <h4>1. The model.</h4>
                    <p>The perceptron checks which side of a hyperplane the input lands on:</p>
                    $$ \hat{y} \;=\; \mathrm{sign}(w \cdot x + b) $$
                    <p style="margin-top:0.4rem;">$w \in \mathbb{R}^d$ is the hyperplane&rsquo;s normal vector, $b$ is the offset from origin, $\hat{y} \in \{-1, +1\}$ is the predicted class.</p>
                </div>
                <div class="pn-math-step">
                    <h4>2. The loss &mdash; hinge.</h4>
                    <p>Zero on correctly-classified points; positive on misclassified ones, scaled by how far inside the wrong region the point sits:</p>
                    $$ L_i \;=\; \max\big(0,\, -y_i\,(w \cdot x_i + b)\big) $$
                    <p style="margin-top:0.4rem;">A point is correctly classified when $y_i (w \cdot x_i + b) > 0$. Hinge loss only "cares" about points the current hyperplane gets wrong.</p>
                </div>
                <div class="pn-math-step">
                    <h4>3. The gradient.</h4>
                    <p>Subgradient is piecewise &mdash; non-zero only on the misclassified points:</p>
                    $$ \frac{\partial L_i}{\partial w} \;=\; \begin{cases} -\,y_i\,x_i & \text{if } y_i\,(w \cdot x_i + b) \le 0 \\ 0 & \text{otherwise} \end{cases} $$
                    <p style="margin-top:0.4rem;">Correct points contribute nothing &mdash; the perceptron has no error signal on them. That&rsquo;s the entire algorithm in one line.</p>
                </div>
                <div class="pn-math-step">
                    <h4>4. The update &mdash; the perceptron rule.</h4>
                    <p>Step opposite the gradient. After substitution:</p>
                    $$ w \;\leftarrow\; w \,+\, \eta\, y_i\, x_i \qquad b \;\leftarrow\; b \,+\, \eta\, y_i $$
                    <p style="margin-top:0.4rem;">(only when $x_i$ is misclassified.) "Nudge $w$ in the direction of misclassified positives and away from misclassified negatives." That&rsquo;s it.</p>
                </div>
                <div class="pn-math-step">
                    <h4>5. Novikoff&rsquo;s convergence theorem.</h4>
                    <p>If the data is linearly separable with margin $\gamma > 0$ and $\|x_i\| \le R$ for all $i$, then perceptron converges in at most</p>
                    $$ \left(\frac{R}{\gamma}\right)^2 \text{ updates} $$
                    <p style="margin-top:0.4rem;">&mdash; <em>regardless of dimension</em>. This guarantee made the perceptron historically important: it was the <strong>first ML algorithm with a proof that it works</strong> (Rosenblatt 1958; Novikoff 1962). On the <code>XOR</code> and <code>shells</code> presets, no such $\gamma$ exists &mdash; so the algorithm runs forever without converging.</p>
                </div>
            </div>
        </div>

        <!-- Try this -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
            <div class="pn-try">
                <div class="pn-try-item">
                    <h4>Watch Novikoff at work</h4>
                    <p>On <code>two blobs</code> click Train 100 epochs. Convergence usually hits in 10&ndash;40 epochs. The green banner&rsquo;s epoch count is bounded by $(R/\gamma)^2$ &mdash; smaller margin or larger data, more updates needed.</p>
                </div>
                <div class="pn-try-item">
                    <h4>The XOR wall</h4>
                    <p>Switch to <code>XOR</code> and Auto-train. Loss never reaches zero; the plane keeps rotating forever. This is what Minsky &amp; Papert (1969) used to kill perceptron research for a decade.</p>
                </div>
                <div class="pn-try-item">
                    <h4>Overlap = endless oscillation</h4>
                    <p>On <code>overlap</code>, perceptron oscillates forever &mdash; even though the data is <em>almost</em> separable, the few boundary points keep pushing the plane back and forth.</p>
                </div>
                <div class="pn-try-item">
                    <h4>Hand-set the plane</h4>
                    <p>Without training, slide <code>w&#8320;, w&#8321;, w&#8322;, b</code> until the plane visually separates the two blobs. Compare your manual fit to what training finds.</p>
                </div>
                <div class="pn-try-item">
                    <h4>Big &eta; → divergent jumps</h4>
                    <p>Crank <code>&eta;</code> to 0.3 and train. The plane flips wildly each update; loss spikes. The perceptron <em>does</em> still converge (Novikoff doesn&rsquo;t depend on &eta;), but the trajectory is ugly.</p>
                </div>
                <div class="pn-try-item">
                    <h4>What about LogReg?</h4>
                    <p>Logistic regression on the same data gives smooth, differentiable updates from probabilities. Same boundary class, gentler optimization. Both fail XOR.</p>
                </div>
            </div>
        </div>

        <!-- Chip strips -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
            <div class="pn-strip is-watchout">
                <span class="pn-strip-label">&#9888;&#65039; Watch out</span>
                <span class="pn-tag">Hard predictions only — no probabilities</span>
                <span class="pn-tag">Linear-only — XOR fails</span>
                <span class="pn-tag">No calibration</span>
                <span class="pn-tag">Oscillates on noise</span>
                <span class="pn-tag">No regularization</span>
            </div>
            <div class="pn-strip is-practice">
                <span class="pn-strip-label">&#128295; In practice</span>
                <span class="pn-tag">sklearn.linear_model.Perceptron</span>
                <span class="pn-tag">averaged Perceptron</span>
                <span class="pn-tag">kernel Perceptron</span>
                <span class="pn-tag">passive-aggressive variants</span>
                <span class="pn-tag">precursor to SVM</span>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Perceptron FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is a perceptron?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The original neural network (Rosenblatt, 1958). A single neuron that takes a weighted sum of inputs plus a bias, and outputs +1 if the result is positive, &minus;1 otherwise. Training adjusts the weights using the <strong>perceptron rule</strong>: $w \leftarrow w + \eta \cdot y \cdot x$ for each misclassified point. It&rsquo;s the simplest learnable model &mdash; and the ancestor of every modern neural network.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        How is the perceptron different from logistic regression?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Same <em>model class</em> (a linear separator), but different output and loss. <strong>Perceptron</strong> predicts a hard $\pm 1$ class via $\mathrm{sign}(w \cdot x + b)$; <strong>logistic regression</strong> predicts a probability via $\sigma(w \cdot x + b)$. Perceptron uses hinge loss (zero on correct, positive on wrong); LogReg uses cross-entropy (smooth, differentiable everywhere). LogReg therefore gives calibrated probabilities and works under gradient methods; perceptron is faster but binary-only.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is Novikoff&rsquo;s convergence theorem?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">If the training data is linearly separable with margin $\gamma$ (the distance from the closest point to the optimal hyperplane), and all points satisfy $\|x\| \le R$, then the perceptron algorithm converges in at most $(R/\gamma)^2$ updates &mdash; <strong>regardless of dimension</strong>. This guarantee made the perceptron historically important: it was the first machine-learning algorithm with a proof that it works.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        When does the perceptron fail?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Whenever the data is <strong>not linearly separable</strong>. Classic examples: <strong>XOR</strong> (no plane separates the four / eight corners), <strong>concentric shells</strong> (both classes share the origin), and any noisy real-world classification problem. Minsky and Papert proved this in 1969, and the limitation killed perceptron research for a decade until multi-layer networks were figured out &mdash; exactly the failure mode the XOR preset demonstrates here.</div>
                </div>
            </div>
        </section>

    </section>

    <aside class="ms-rail" aria-label="Advertisements">
        <%@ include file="../modern/ads/ad-ide-rail-top.jsp" %>
        <%@ include file="../modern/ads/ad-ide-rail-bottom.jsp" %>
    </aside>

</main>

<%@ include file="../modern/ads/ad-sticky-footer.jsp" %>
<%@ include file="../modern/components/analytics.jsp" %>

<script>
    document.querySelectorAll('.ms-faq-q').forEach(function (q) {
        q.addEventListener('click', function () {
            q.closest('.ms-faq-item').classList.toggle('open');
        });
    });
</script>
<script src="<%=request.getContextPath()%>/modern/js/dark-mode.js?v=<%=v%>" defer></script>
<script src="<%=request.getContextPath()%>/ml/js/perceptron.js?v=<%=v%>" defer></script>
</body>
</html>
