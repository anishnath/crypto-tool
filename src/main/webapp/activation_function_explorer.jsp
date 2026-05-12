<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Activation Functions Explorer — Sigmoid, ReLU, GELU, Swish, Mish" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive explorer for 10 activation functions used in deep learning. Plot Sigmoid, Tanh, ReLU, Leaky ReLU, ELU, GELU, Swish/SiLU, Softplus, Mish — with derivatives side-by-side. Tune parameters, change the domain. No signup." />
        <jsp:param name="toolUrl" value="activation_function_explorer.jsp" />
        <jsp:param name="toolImage" value="activation-functions-og.png" />
        <jsp:param name="toolKeywords" value="activation function visualizer, sigmoid tanh relu graph, gelu swish mish, leaky relu elu, deep learning activations, activation derivatives, vanishing gradient demo, neural network activation comparison, ml activations from scratch" />
        <jsp:param name="toolFeatures" value="10 activations: Identity/Sigmoid/Tanh/ReLU/Leaky/ELU/GELU/Swish/Softplus/Mish,Side-by-side f(x) and f'(x) panels,Chip-style toggles,Parameter sliders for Leaky α ELU α and GELU mode,KaTeX formulas + derivatives per function,Dark mode,No signup" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick activations|Tap chips to toggle which functions appear on the chart — colors match between the f(x) and f'(x) panels,Tune parameters|Slide Leaky α or ELU α and switch GELU between exact (erf) and tanh approximation to see how each shape responds,Compare derivatives|The right panel shows the slopes — that's what backprop multiplies — so watch where derivatives vanish or saturate" />
        <jsp:param name="faq1q" value="What is an activation function?" />
        <jsp:param name="faq1a" value="A nonlinear transformation applied to each neuron's output. Without it, stacking layers is mathematically equivalent to a single linear layer — no matter how deep your network is, it could only learn linear relationships. The activation is what lets neural networks model curves, decision boundaries, and everything else nonlinear." />
        <jsp:param name="faq2q" value="Why does ReLU dominate hidden layers?" />
        <jsp:param name="faq2a" value="Three reasons: (1) cheap — just max(0, x); (2) doesn't saturate on the positive side, so gradients flow freely; (3) produces sparse activations (≈half the neurons output 0 at any time), which acts as implicit regularization. Sigmoid and Tanh saturate at both ends, killing gradients in deep networks — that's the vanishing gradient problem." />
        <jsp:param name="faq3q" value="What's the dying ReLU problem?" />
        <jsp:param name="faq3a" value="If a neuron's input distribution shifts firmly negative (e.g., from a bad initialization or a large gradient step), ReLU outputs 0 for all inputs. Its derivative is also 0, so the neuron's weights never update — it's effectively dead forever. Leaky ReLU, ELU, GELU, and Swish all fix this by allowing some signal through on the negative side." />
        <jsp:param name="faq4q" value="Why do transformers use GELU instead of ReLU?" />
        <jsp:param name="faq4a" value="GELU is smooth (so optimization is gentler), self-gating (the magnitude of x decides how much of x to pass through, weighted by a probability), and slightly better-behaved empirically on language tasks. The Vaswani et al. transformer used ReLU, but BERT switched to GELU and every major LLM since has followed." />
        <jsp:param name="faq5q" value="When should I use Sigmoid?" />
        <jsp:param name="faq5a" value="As an output layer for binary classification — its (0, 1) range maps cleanly to probability. For hidden layers in modern networks, almost never. (LSTM gates are an exception, and even those are getting replaced.)" />
        <jsp:param name="faq6q" value="What's the difference between GELU exact and tanh approximation?" />
        <jsp:param name="faq6a" value="The exact GELU uses the Gaussian CDF (erf function). The tanh form 0.5x(1 + tanh(√(2/π)(x + 0.044715x³))) approximates it ~30% faster on GPUs that don't have hardware erf. The shapes differ by less than 1e-4 across the typical input range — both are interchangeable for training." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/activation-functions.css?v=<%=v%>">

    <%-- KaTeX for the formula card --%>
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

    <% request.setAttribute("activeService", "activation-functions"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Activation Functions, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Optimization &middot; Activation Functions
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Optimization</span>
            </div>
            <p style="margin:1rem 0 0;color:var(--ms-ink-soft);font:0.95rem/1.55 var(--ms-font-sans);max-width:70ch;">
                An activation function is the nonlinearity that turns stacked linear layers into a real neural network. <strong>Stack any number of linear layers without one and you still get a single linear layer.</strong> The activation is also what backprop multiplies through &mdash; so the shape of its derivative <em>is</em> the gradient that learning depends on. Toggle activations below to compare shapes <em>and</em> slopes side by side.
            </p>
        </div>

        <!-- Demo -->
        <div class="ms-card">
            <div class="af-demo">
                <div class="af-canvas-wrap">
                    <span class="af-canvas-label">f(x)</span>
                    <canvas id="afFn" aria-label="Activation function values"></canvas>
                    <div class="af-canvas-readout" id="afFnReadout"></div>
                </div>
                <div class="af-canvas-wrap">
                    <span class="af-canvas-label">f′(x) &middot; the gradient backprop multiplies</span>
                    <canvas id="afDfn" aria-label="Activation function derivatives"></canvas>
                    <div class="af-canvas-readout" id="afDfnReadout"></div>
                </div>
            </div>

            <!-- Activation chips — populated by JS so the colors match -->
            <div class="af-chips" id="afChips" role="group" aria-label="Toggle activation functions"></div>

            <!-- Parameter + domain controls -->
            <div class="af-controls">
                <div class="af-control is-hidden" id="afLeakyCtl">
                    <div class="af-control-label">
                        <span>Leaky ReLU &alpha;</span>
                        <span class="af-control-value" id="afLeakyValue">0.010</span>
                    </div>
                    <input type="range" id="afLeaky" min="0.001" max="0.3" step="0.001" value="0.01" />
                </div>

                <div class="af-control is-hidden" id="afEluCtl">
                    <div class="af-control-label">
                        <span>ELU &alpha;</span>
                        <span class="af-control-value" id="afEluValue">1.00</span>
                    </div>
                    <input type="range" id="afElu" min="0.1" max="5" step="0.1" value="1.0" />
                </div>

                <div class="af-control is-hidden" id="afGeluCtl">
                    <div class="af-control-label"><span>GELU approximation</span></div>
                    <select id="afGeluMode">
                        <option value="exact" selected>Exact (erf)</option>
                        <option value="tanh">Tanh approx.</option>
                    </select>
                </div>

                <div class="af-control">
                    <div class="af-control-label"><span>x min</span></div>
                    <input type="number" id="afXmin" step="0.5" value="-6" />
                </div>
                <div class="af-control">
                    <div class="af-control-label"><span>x max</span></div>
                    <input type="number" id="afXmax" step="0.5" value="6" />
                </div>
                <div class="af-control">
                    <div class="af-control-label"><span>y min</span></div>
                    <input type="number" id="afYmin" step="0.5" value="-2" />
                </div>
                <div class="af-control">
                    <div class="af-control-label"><span>y max</span></div>
                    <input type="number" id="afYmax" step="0.5" value="2" />
                </div>
            </div>

            <div class="af-actions">
                <button type="button" id="afReset" class="af-btn">Reset to defaults</button>
                <span style="font:0.78rem var(--ms-font-mono);color:var(--ms-muted);align-self:center;">
                    Tip: derivative panel uses dashed lines &mdash; same color as the activation in the left panel.
                </span>
            </div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Formula reference -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 0.5rem;letter-spacing:-0.015em;">
                Formula reference <small style="font:0.85rem var(--ms-font-sans);color:var(--ms-muted);margin-left:0.65rem;">function, derivative, range, when to use</small>
            </h2>
            <p style="font:0.86rem/1.55 var(--ms-font-sans);color:var(--ms-muted);margin:0 0 1rem;">
                Each card below is one activation. The function is what the forward pass computes; the derivative is what gets multiplied through during backpropagation. Where derivatives are zero or saturated, gradients vanish.
            </p>
            <div class="af-formula-grid">

                <div class="af-formula-card" style="--af-color:#64748b">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Identity</span>
                        <span class="af-formula-range">range: (−∞, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = x $$</div>
                    <div class="af-formula-row">$$ f'(x) = 1 $$</div>
                    <div class="af-formula-note">Output layer for regression. Never as a hidden activation &mdash; defeats the purpose.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#0ea5e9">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Sigmoid</span>
                        <span class="af-formula-range">range: (0, 1)</span>
                    </div>
                    <div class="af-formula-row">$$ \sigma(x) = \frac{1}{1 + e^{-x}} $$</div>
                    <div class="af-formula-row">$$ \sigma'(x) = \sigma(x)\,\bigl(1 - \sigma(x)\bigr) $$</div>
                    <div class="af-formula-note">Output for binary classification (probability). Avoid as hidden activation &mdash; saturates at ±∞ and kills gradients.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#22c55e">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Tanh</span>
                        <span class="af-formula-range">range: (−1, 1)</span>
                    </div>
                    <div class="af-formula-row">$$ \tanh(x) = \frac{e^x - e^{-x}}{e^x + e^{-x}} $$</div>
                    <div class="af-formula-row">$$ \tanh'(x) = 1 - \tanh^2(x) $$</div>
                    <div class="af-formula-note">Zero-centered alternative to sigmoid. Still saturates &mdash; mostly historical now; LSTM gates being the holdout.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#ef4444">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>ReLU</span>
                        <span class="af-formula-range">range: [0, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = \max(0,\,x) $$</div>
                    <div class="af-formula-row">$$ f'(x) = \begin{cases} 1 & x > 0 \\ 0 & x \le 0 \end{cases} $$</div>
                    <div class="af-formula-note">The default hidden activation since AlexNet (2012). Cheap, sparse, gradient-friendly for positives. Negative inputs go dark forever &mdash; the "dying ReLU" problem.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#f97316">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Leaky ReLU</span>
                        <span class="af-formula-range">range: (−∞, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = \begin{cases} x & x > 0 \\ \alpha x & x \le 0 \end{cases} $$</div>
                    <div class="af-formula-row">$$ f'(x) = \begin{cases} 1 & x > 0 \\ \alpha & x \le 0 \end{cases} $$</div>
                    <div class="af-formula-note">Fixes dying ReLU by leaking a small negative slope (typically $\alpha = 0.01$). Cheap and usually a safe ReLU upgrade.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#a855f7">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>ELU</span>
                        <span class="af-formula-range">range: (−α, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = \begin{cases} x & x \ge 0 \\ \alpha(e^x - 1) & x < 0 \end{cases} $$</div>
                    <div class="af-formula-row">$$ f'(x) = \begin{cases} 1 & x \ge 0 \\ \alpha e^x & x < 0 \end{cases} $$</div>
                    <div class="af-formula-note">Smooth negative tail; mean activations sit closer to zero, which helps deep nets train more stably. Slightly more expensive than Leaky ReLU.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#14b8a6">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>GELU</span>
                        <span class="af-formula-range">range: (−0.17, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ \mathrm{GELU}(x) = x \cdot \Phi(x) = \tfrac{1}{2} x \,\bigl(1 + \mathrm{erf}(x/\sqrt{2})\bigr) $$</div>
                    <div class="af-formula-row">$$ \text{tanh approx: } \tfrac{1}{2} x \bigl(1 + \tanh[\sqrt{2/\pi}\,(x + 0.044715\,x^3)]\bigr) $$</div>
                    <div class="af-formula-note">Smooth, probabilistic gating. BERT, GPT, ViT &mdash; modern transformers default to GELU. The tanh approximation is ~30% faster on hardware without efficient erf.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#ec4899">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Swish / SiLU</span>
                        <span class="af-formula-range">range: (−0.28, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = x \cdot \sigma(x) $$</div>
                    <div class="af-formula-row">$$ f'(x) = \sigma(x) + x\,\sigma(x)\,\bigl(1 - \sigma(x)\bigr) $$</div>
                    <div class="af-formula-note">Google's EfficientNet uses Swish (same family as GELU). Cheaper than GELU at near-identical quality on vision tasks.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#84cc16">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Softplus</span>
                        <span class="af-formula-range">range: (0, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = \log(1 + e^x) $$</div>
                    <div class="af-formula-row">$$ f'(x) = \sigma(x) $$</div>
                    <div class="af-formula-note">Smooth ReLU substitute. Cute fact: its derivative <em>is</em> the sigmoid. Mostly historical &mdash; the smoothness rarely pays for the extra compute.</div>
                </div>

                <div class="af-formula-card" style="--af-color:#06b6d4">
                    <div class="af-formula-head">
                        <span class="af-formula-title"><span class="af-formula-dot"></span>Mish</span>
                        <span class="af-formula-range">range: (−0.31, ∞)</span>
                    </div>
                    <div class="af-formula-row">$$ f(x) = x \cdot \tanh\bigl(\log(1 + e^x)\bigr) $$</div>
                    <div class="af-formula-row">$$ f'(x) \approx \tanh(\zeta) + x\,\sigma(x)\,\bigl(1 - \tanh^2(\zeta)\bigr),\;\; \zeta = \log(1+e^x) $$</div>
                    <div class="af-formula-note">YOLOv4 and successors. Self-regularizing &mdash; small gains over Swish on some vision benchmarks, slightly more compute.</div>
                </div>

            </div>
        </div>

        <!-- Try this -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
            <div class="af-try">
                <div class="af-try-item">
                    <h4>See the vanishing gradient</h4>
                    <p>Turn on <strong>Sigmoid</strong> only. Look at the derivative panel: the peak is <code>0.25</code>, and it&rsquo;s near zero everywhere else. Stack 5 sigmoids and the gradient gets multiplied by 0.25<sup>5</sup> &asymp; 0.001 even in the best case &mdash; gone before the first layer sees it.</p>
                </div>
                <div class="af-try-item">
                    <h4>Why Tanh beats Sigmoid in hidden layers</h4>
                    <p>Now switch to <strong>Tanh</strong>. Peak derivative is <code>1.0</code>, four times sigmoid&rsquo;s. And outputs are symmetric around zero, so gradients don&rsquo;t all share the same sign. This is why Tanh outlived Sigmoid for a decade in the hidden layers of MLPs.</p>
                </div>
                <div class="af-try-item">
                    <h4>The dying ReLU corridor</h4>
                    <p>ReLU on, set <code>x min = -10</code>. Look at the derivative for <code>x &lt; 0</code>: it&rsquo;s <em>flat zero</em>. If a neuron lands here and its input distribution stays negative, every gradient is zero &mdash; the weight never updates again. Now turn on <strong>Leaky ReLU</strong> &mdash; the derivative is <code>α</code>, not <code>0</code>. The neuron can come back.</p>
                </div>
                <div class="af-try-item">
                    <h4>GELU exact vs tanh approximation</h4>
                    <p>Enable <strong>GELU</strong>, then flip the dropdown between <code>Exact (erf)</code> and <code>Tanh approx</code>. Watch the curves: they overlap almost everywhere. The approximation is ~30% faster on GPUs without hardware erf, with quality loss too small to measure in training.</p>
                </div>
                <div class="af-try-item">
                    <h4>Self-gating: Swish vs ReLU</h4>
                    <p>Side by side, enable <strong>ReLU</strong> and <strong>Swish</strong>. Near <code>x = 0</code> Swish is smoother and slightly negative, which Google found made EfficientNet train faster &mdash; the smoothness alone gets you better optimization without changing anything else.</p>
                </div>
                <div class="af-try-item">
                    <h4>Why output range matters</h4>
                    <p>Look at <strong>Sigmoid</strong> vs <strong>Identity</strong>. Sigmoid clamps to (0, 1) &mdash; perfect for &ldquo;is this a cat? probability&rdquo;. Identity is unbounded &mdash; perfect for &ldquo;how much will this house sell for?&rdquo;. Same activation idea, opposite use cases. Output layer = pick the range that matches your target.</p>
                </div>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Activation functions FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is an activation function?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">A nonlinear transformation applied to each neuron&rsquo;s output. Without it, stacking layers is mathematically equivalent to a single linear layer &mdash; no matter how deep your network is, it could only learn linear relationships. The activation is what lets neural networks model curves, decision boundaries, and everything else nonlinear.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does ReLU dominate hidden layers?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Three reasons: (1) <strong>cheap</strong> &mdash; just <code>max(0, x)</code>; (2) <strong>doesn&rsquo;t saturate</strong> on the positive side, so gradients flow freely; (3) produces <strong>sparse activations</strong> (about half the neurons output 0 at any time), which acts as implicit regularization. Sigmoid and Tanh saturate at both ends, killing gradients in deep networks &mdash; that&rsquo;s the vanishing gradient problem.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What&rsquo;s the dying ReLU problem?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">If a neuron&rsquo;s input distribution shifts firmly negative (e.g., from a bad initialization or a large gradient step), ReLU outputs 0 for all inputs. Its derivative is also 0, so the neuron&rsquo;s weights never update &mdash; it&rsquo;s effectively dead forever. <strong>Leaky ReLU, ELU, GELU, and Swish</strong> all fix this by allowing some signal through on the negative side.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why do transformers use GELU instead of ReLU?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">GELU is <strong>smooth</strong> (so optimization is gentler), <strong>self-gating</strong> (the magnitude of $x$ decides how much of $x$ to pass through, weighted by a probability), and slightly better-behaved empirically on language tasks. The original Vaswani et al. transformer used ReLU, but BERT switched to GELU and every major LLM since has followed.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        When should I use Sigmoid?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">As an output layer for <strong>binary classification</strong> &mdash; its (0, 1) range maps cleanly to probability. For hidden layers in modern networks, almost never. (LSTM gates are an exception, and even those are getting replaced.)</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What&rsquo;s the difference between GELU exact and tanh approximation?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The exact GELU uses the Gaussian CDF (<code>erf</code> function). The tanh form $\tfrac{1}{2} x \bigl(1 + \tanh[\sqrt{2/\pi}\,(x + 0.044715\,x^3)]\bigr)$ approximates it ~30% faster on GPUs that don&rsquo;t have hardware erf. The shapes differ by less than $10^{-4}$ across the typical input range &mdash; both are interchangeable for training.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/activation-functions.js?v=<%=v%>" defer></script>
</body>
</html>
