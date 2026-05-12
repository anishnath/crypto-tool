<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Neural Network Playground — Build, Train, Watch It Learn" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive neural network builder + trainer. Add layers, pick activations, hit Play and watch backprop carve a decision boundary in your browser. Four datasets including XOR and spirals. No signup." />
        <jsp:param name="toolUrl" value="neural_network_playground.jsp" />
        <jsp:param name="toolImage" value="nn-playground-og.png" />
        <jsp:param name="toolKeywords" value="neural network playground, mlp trainer, backpropagation visualizer, decision boundary, hidden layers, activation functions, gradient descent, deep learning demo, xor neural net, spiral classifier" />
        <jsp:param name="toolFeatures" value="Build network architecture interactively,4 datasets: spiral/XOR/circle/moons,4 activations: ReLU/Sigmoid/Tanh/Leaky-ReLU,Live decision boundary overlay,Loss curve updates per epoch,Click-to-add custom data points,Hyperparameter sliders (learning rate / batch size / speed),Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a dataset|Spiral and XOR force the network to learn non-linear boundaries — start there if you want to see backprop earn its keep,Build your architecture|Add or remove hidden layers and pick neurons per layer. Choose an activation function — try ReLU vs sigmoid on deep nets,Train|Hit Play and watch the loss curve fall while the decision boundary carves out the right regions live" />
        <jsp:param name="faq1q" value="What is a neural network?" />
        <jsp:param name="faq1a" value="A stack of layers — input, one or more hidden, output. Each layer takes a weighted sum of its inputs, adds a bias, and runs the result through an activation function (ReLU, sigmoid, tanh). Training adjusts every weight and bias by gradient descent on a loss function — usually cross-entropy for classification. The network can learn non-linear boundaries that single linear classifiers (logistic regression, perceptron) provably cannot." />
        <jsp:param name="faq2q" value="What does Backpropagation actually do?" />
        <jsp:param name="faq2a" value="It computes the gradient of the loss with respect to every weight and bias in the network, layer by layer, working backward from the output. Once you have those gradients, gradient descent just nudges each parameter in the direction that reduces loss. Backprop is the chain rule applied carefully — and it's what makes deep learning practical." />
        <jsp:param name="faq3q" value="Why does my network not learn XOR?" />
        <jsp:param name="faq3a" value="If you have zero hidden layers, you're effectively running logistic regression — and logistic regression can't separate XOR. Add at least one hidden layer with 4+ neurons and the network will learn the non-linear boundary. Try removing all hidden layers and watch the model fail; then add one and watch it succeed." />
        <jsp:param name="faq4q" value="What activation should I use?" />
        <jsp:param name="faq4a" value="ReLU is the default in modern hidden layers — fast, doesn't saturate, sparse activations. Sigmoid and Tanh saturate at the ends, which causes vanishing gradients in deep networks. For binary output layers, sigmoid still wins (it gives a clean probability). For deeper hidden layers, ReLU or one of its variants (Leaky ReLU, GELU) is almost always the right pick." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/neural-network-playground.css?v=<%=v%>">

    <%-- KaTeX for the backprop derivation card --%>
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

    <% request.setAttribute("activeService", "neural-network-playground"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Hero -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Neural Network <em style="font-style:italic;color:#4f46e5;">Playground</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Neural Networks &middot; Playground
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Neural Networks</span>
            </div>
            <p style="margin:0.85rem 0 0;color:var(--ms-ink-soft);font:0.92rem/1.55 var(--ms-font-sans);max-width:72ch;">
                Build a small neural network, pick a dataset, hit <strong>Play</strong> &mdash; watch backpropagation carve a decision boundary in real time. The 2D point classifiers that <a href="<%=request.getContextPath()%>/Logistic_Regression.jsp" style="color:#4f46e5;">logistic regression</a> and the <a href="<%=request.getContextPath()%>/ml/perceptron.jsp" style="color:#4f46e5;">perceptron</a> couldn&rsquo;t solve (XOR, spirals) become trivial once you stack a hidden layer.
            </p>
        </div>

        <!-- Demo: network canvas + loss + KPIs -->
        <div class="ms-card">
            <div class="nnp-canvas-wrap">
                <div class="nnp-canvas-label">
                    <span>Decision boundary &middot; click anywhere to add a training point</span>
                </div>
                <div class="nnp-canvas-area">
                    <canvas id="nnpCanvas" aria-label="2D scatter and decision boundary"></canvas>
                </div>
                <div class="nnp-canvas-footer">
                    <div class="nnp-legend">
                        <span><span class="nnp-legend-dot nnp-c0"></span>Class 0</span>
                        <span><span class="nnp-legend-dot nnp-c1"></span>Class 1</span>
                    </div>
                    <button type="button" class="nnp-class-indicator" id="nnpClassIndicator" data-class="1">
                        <span class="nnp-class-indicator-dot"></span>
                        <span>Adding to <strong id="nnpClassIndicatorText">Class 1</strong></span>
                        <span class="nnp-class-indicator-hint">click to switch</span>
                    </button>
                </div>
            </div>

            <div class="nnp-loss-wrap">
                <div class="nnp-canvas-label"><span>Training loss per epoch</span></div>
                <div class="nnp-loss-area">
                    <canvas id="nnpLossChart" aria-label="Training loss over epochs"></canvas>
                </div>
            </div>

            <div class="nnp-kpi-grid">
                <div class="nnp-kpi"><div class="nnp-kpi-label">Epoch</div><div class="nnp-kpi-value" id="nnpEpoch">0</div></div>
                <div class="nnp-kpi"><div class="nnp-kpi-label">Loss</div><div class="nnp-kpi-value" id="nnpLossVal">—</div></div>
                <div class="nnp-kpi"><div class="nnp-kpi-label">Accuracy</div><div class="nnp-kpi-value" id="nnpAcc">—</div></div>
            </div>
        </div>

        <!-- Controls: architecture + activation + hyperparameters -->
        <div class="ms-card">
            <h2 style="font:500 1.15rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                Build &amp; train
            </h2>

            <div class="nnp-controls-grid">
                <div>
                    <div class="nnp-control-section" style="margin-bottom:1.5rem;">
                        <h3>Architecture</h3>
                        <div class="nnp-layers" id="nnpLayers"></div>
                        <button type="button" class="nnp-add-layer" id="nnpBtnAddLayer">+ Add hidden layer</button>
                    </div>

                    <div class="nnp-control-section">
                        <h3>Activation</h3>
                        <div class="nnp-activations">
                            <button type="button" class="nnp-activation-btn is-active" data-activation="relu">ReLU</button>
                            <button type="button" class="nnp-activation-btn" data-activation="sigmoid">Sigmoid</button>
                            <button type="button" class="nnp-activation-btn" data-activation="tanh">Tanh</button>
                            <button type="button" class="nnp-activation-btn" data-activation="leaky_relu">Leaky ReLU</button>
                        </div>
                        <canvas id="nnpActivationGraph" class="nnp-activation-graph" aria-label="Activation function graph"></canvas>
                    </div>
                </div>

                <div>
                    <div class="nnp-control-section" style="margin-bottom:1.25rem;">
                        <h3>Hyperparameters</h3>
                        <div class="nnp-control">
                            <div class="nnp-control-label"><span>Learning rate &eta;</span><span class="nnp-control-value" id="nnpLrValue">0.010</span></div>
                            <input type="range" id="nnpLr" min="0.001" max="0.5" step="0.001" value="0.01">
                        </div>
                        <div class="nnp-control">
                            <div class="nnp-control-label"><span>Batch size</span><span class="nnp-control-value" id="nnpBatchValue">32</span></div>
                            <input type="range" id="nnpBatch" min="1" max="64" step="1" value="32">
                        </div>
                        <div class="nnp-control">
                            <div class="nnp-control-label"><span>Training speed</span><span class="nnp-control-value" id="nnpSpeedValue">Normal</span></div>
                            <input type="range" id="nnpSpeed" min="1" max="10" step="1" value="5">
                        </div>
                        <label class="nnp-control-checkbox" style="margin-top:0.85rem;">
                            <input type="checkbox" id="nnpShowBoundary" checked>
                            <span>Show decision boundary overlay</span>
                        </label>
                    </div>

                    <div class="nnp-control-section">
                        <h3>Run</h3>
                        <div class="nnp-actions" style="margin-top:0;">
                            <button type="button" class="nnp-btn is-play" id="nnpBtnPlay">&#9656; Train Network</button>
                            <button type="button" class="nnp-btn is-warn" id="nnpBtnReset">Reset</button>
                            <button type="button" class="nnp-btn" id="nnpBtnClear">Clear points</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dataset preset cards -->
        <div class="ms-card">
            <h2 style="font:500 1.15rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">
                Dataset presets
            </h2>
            <div class="nnp-datasets">
                <div class="nnp-dataset is-active" data-dataset="spiral">
                    <canvas id="nnpPreviewSpiral" aria-hidden="true"></canvas>
                    <div class="nnp-dataset-label">Spiral</div>
                </div>
                <div class="nnp-dataset" data-dataset="xor">
                    <canvas id="nnpPreviewXor" aria-hidden="true"></canvas>
                    <div class="nnp-dataset-label">XOR</div>
                </div>
                <div class="nnp-dataset" data-dataset="circle">
                    <canvas id="nnpPreviewCircle" aria-hidden="true"></canvas>
                    <div class="nnp-dataset-label">Circle</div>
                </div>
                <div class="nnp-dataset" data-dataset="moons">
                    <canvas id="nnpPreviewMoons" aria-hidden="true"></canvas>
                    <div class="nnp-dataset-label">Moons</div>
                </div>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Theory & exercises (collapsed) -->
        <details class="nnp-collapse">
            <summary>Theory &amp; exercises &middot; backprop derivation, watch-outs, ideas to try</summary>
            <div class="nnp-collapse-body">

                <!-- Math card -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, in four passes</h2>
                    <div class="nnp-math">
                        <div class="nnp-math-step">
                            <h4>1. Forward pass.</h4>
                            <p>Each layer transforms its input by a weighted sum + bias + activation:</p>
                            $$ z^{(l)} = W^{(l)} a^{(l-1)} + b^{(l)} \qquad a^{(l)} = \phi(z^{(l)}) $$
                            <p style="margin-top:0.4rem;">The final layer&rsquo;s $a$ is the prediction $\hat{y}$.</p>
                        </div>
                        <div class="nnp-math-step">
                            <h4>2. Loss &mdash; cross-entropy.</h4>
                            $$ L = -\sum_i t_i \log \hat{y}_i $$
                            <p style="margin-top:0.4rem;">For two-class problems, $t \in \{(1,0),(0,1)\}$ is a one-hot vector; cross-entropy measures how wrong the predicted probability distribution is.</p>
                        </div>
                        <div class="nnp-math-step">
                            <h4>3. Backward pass (chain rule).</h4>
                            <p>Start at the output, compute $\delta^{(L)} = \hat{y} - t$, then propagate <em>back</em> through layers:</p>
                            $$ \delta^{(l)} = \big(W^{(l+1)}\big)^\top\,\delta^{(l+1)} \,\odot\, \phi'(z^{(l)}) $$
                            <p style="margin-top:0.4rem;">$\odot$ is the elementwise product. Each $\delta$ is "how much this layer&rsquo;s activations were off by".</p>
                        </div>
                        <div class="nnp-math-step">
                            <h4>4. Weight update.</h4>
                            <p>Once you have all $\delta$s, the gradient is mechanical:</p>
                            $$ \frac{\partial L}{\partial W^{(l)}} = \delta^{(l)}\,\big(a^{(l-1)}\big)^\top \qquad
                               \frac{\partial L}{\partial b^{(l)}} = \delta^{(l)} $$
                            <p style="margin-top:0.4rem;">Step opposite each gradient scaled by $\eta$: $W \leftarrow W - \eta \cdot \partial L / \partial W$. Repeat for many epochs.</p>
                        </div>
                    </div>
                </div>

                <!-- Try this -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
                    <div class="nnp-try">
                        <div class="nnp-try-item">
                            <h4>The XOR upgrade</h4>
                            <p>Pick <code>XOR</code>. Remove all hidden layers (just input → output) and train &mdash; loss never falls. Add one hidden layer with 4 neurons. Now it works. That&rsquo;s the multi-layer unlock in one experiment.</p>
                        </div>
                        <div class="nnp-try-item">
                            <h4>Vanishing gradients</h4>
                            <p>On the <code>spiral</code> dataset, add 4 hidden layers with sigmoid activation. Watch the loss barely budge. Switch all activations to ReLU. Loss drops fast. This is why ReLU dominates modern deep nets.</p>
                        </div>
                        <div class="nnp-try-item">
                            <h4>Lr too high → divergence</h4>
                            <p>Push <code>&eta;</code> to <code>0.4</code>. The loss spikes erratically; the boundary thrashes. Halve it and watch convergence smooth out.</p>
                        </div>
                        <div class="nnp-try-item">
                            <h4>Capacity vs data</h4>
                            <p>Add 3 hidden layers of 16 neurons each. Place just 8 data points by hand. Train. The network memorizes those 8 points perfectly but the decision boundary looks insane &mdash; classic overfitting on tiny data.</p>
                        </div>
                        <div class="nnp-try-item">
                            <h4>Batch size = 1 vs 32</h4>
                            <p>Drop batch size to 1 (pure SGD). Loss curve gets jagged; boundary jitters. Push it to 64 — smoother loss but slower iteration. Mini-batch is the trade-off.</p>
                        </div>
                        <div class="nnp-try-item">
                            <h4>Spirals need depth</h4>
                            <p>With 1 hidden layer of 4 neurons, spiral barely separates. Try 2 layers × 8 neurons each. The boundary curls. That curl is what depth bought you.</p>
                        </div>
                    </div>
                </div>

                <!-- Chip strips -->
                <div>
                    <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
                    <div class="nnp-strip is-watchout">
                        <span class="nnp-strip-label">&#9888;&#65039; Watch out</span>
                        <span class="nnp-tag">Vanishing gradients</span>
                        <span class="nnp-tag">High lr → divergence</span>
                        <span class="nnp-tag">Overfit small data</span>
                        <span class="nnp-tag">Bad random init</span>
                        <span class="nnp-tag">Too many hidden layers</span>
                    </div>
                    <div class="nnp-strip is-practice">
                        <span class="nnp-strip-label">&#128295; In practice</span>
                        <span class="nnp-tag">torch.nn.Linear</span>
                        <span class="nnp-tag">F.relu</span>
                        <span class="nnp-tag">CrossEntropyLoss</span>
                        <span class="nnp-tag">torch.optim.Adam</span>
                        <span class="nnp-tag">batch_norm</span>
                        <span class="nnp-tag">dropout</span>
                    </div>
                </div>

            </div>
        </details>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="NN Playground FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is a neural network?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">A stack of layers &mdash; input, one or more hidden, output. Each layer takes a weighted sum of its inputs, adds a bias, and runs the result through an activation function (ReLU, sigmoid, tanh). Training adjusts every weight and bias by <strong>gradient descent</strong> on a loss function &mdash; usually cross-entropy for classification. The network can learn non-linear boundaries that single linear classifiers (logistic regression, perceptron) provably cannot.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What does backpropagation actually do?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">It computes the gradient of the loss with respect to every weight and bias in the network, layer by layer, working backward from the output. Once you have those gradients, gradient descent just nudges each parameter in the direction that reduces loss. <strong>Backprop is the chain rule applied carefully</strong> &mdash; and it&rsquo;s what makes deep learning practical.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does my network not learn XOR?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">If you have <strong>zero hidden layers</strong>, you&rsquo;re effectively running logistic regression &mdash; and logistic regression can&rsquo;t separate XOR. Add at least one hidden layer with 4+ neurons and the network will learn the non-linear boundary. Try removing all hidden layers and watch the model fail; then add one and watch it succeed.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What activation should I use?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a"><strong>ReLU</strong> is the default in modern hidden layers &mdash; fast, doesn&rsquo;t saturate, sparse activations. <strong>Sigmoid</strong> and <strong>Tanh</strong> saturate at the ends, which causes vanishing gradients in deep networks. For binary output layers, sigmoid still wins (it gives a clean probability). For deeper hidden layers, ReLU or one of its variants (Leaky ReLU, GELU) is almost always the right pick.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/neural-network-playground.js?v=<%=v%>" defer></script>
</body>
</html>
