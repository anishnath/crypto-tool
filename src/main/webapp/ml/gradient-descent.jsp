<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="Gradient Descent for Linear Regression — Watch It Fit a Line" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive gradient descent demo. Watch the algorithm fit a regression line to a real dataset — slope and intercept update every epoch while the MSE surface shows the descent path. Edit the algorithm, change the learning rate, click anywhere on the (w, b) plane to re-seed. No signup." />
        <jsp:param name="toolUrl" value="ml/gradient-descent.jsp" />
        <jsp:param name="toolKeywords" value="gradient descent linear regression, gradient descent visualizer, mse gradient descent, fit a line gradient descent, slope intercept learning, learning rate demo, partial derivatives mse, ml regression from scratch, interactive optimizer, gradient descent from scratch, w b update rule" />
        <jsp:param name="toolFeatures" value="Linear regression on a real dataset,Live regression line + MSE surface,Editable algorithm source,Click-to-seed (w,b),Step-by-step derivation of ∂L/∂w and ∂L/∂b,Adjustable learning rate and epochs,Dark mode,100% free" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Watch the line fit|Click Run — the regression line on the left rotates and shifts to minimize squared error against the data points,Watch the (w b) marker descend|On the right the MSE surface shows the current slope/intercept; the marker walks downhill toward the optimum,Tune the algorithm|Adjust learning rate epochs and initial w/b — or edit the Python and run your own version" />
        <jsp:param name="faq1q" value="What is gradient descent in linear regression?" />
        <jsp:param name="faq1a" value="It's how the regression line learns its slope w and intercept b. We define an error metric (mean squared error) and step both parameters in the direction that reduces it: w ← w − η·∂L/∂w, b ← b − η·∂L/∂b. After enough epochs, (w, b) settles at the values that fit the data best." />
        <jsp:param name="faq2q" value="Why does my run blow up?" />
        <jsp:param name="faq2a" value="Almost always: learning rate too high. The step overshoots the bottom of the MSE bowl and lands further uphill than where it started — w and b oscillate then fly off. The dataset's x values reach 50, so even a modest learning rate gets multiplied by big gradients. Halve lr and try again." />
        <jsp:param name="faq3q" value="Why is the default learning rate so small (5e-5)?" />
        <jsp:param name="faq3a" value="Because the input feature is unnormalized — x ∈ [0, 50] means the gradient w.r.t. w can be hundreds. A larger lr would diverge. In real-world pipelines you'd normalize x (subtract mean, divide by std) first, then a much larger lr like 0.01 becomes safe. Try it: prepend DATA_X = (DATA_X - DATA_X.mean()) / DATA_X.std() to the code and crank lr up." />
        <jsp:param name="faq4q" value="Can I change the algorithm?" />
        <jsp:param name="faq4a" value="Yes — the algorithm source on this page is editable. Try adding momentum (keep a running average of past gradients), or switching MSE to MAE (absolute error), or adding an L2 regularizer. Click Run to see your version fit the data." />
    </jsp:include>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="ctx" content="<%=request.getContextPath()%>" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Instrument+Serif:ital@0;1&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">

    <%-- Reuse the math-studio shell + ML hub helper styles --%>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/navigation.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/dark-mode.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/footer.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/modern/css/ads.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/math/css/math-studio.css?v=<%=v%>">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/gradient-descent.css?v=<%=v%>">

    <%-- KaTeX for the math derivation card --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

    <%-- Plotly (3D-only build) for the MSE surface plot.  Loaded with
         defer so it parses before our gradient-descent.js boot. --%>
    <script defer src="https://cdn.plot.ly/plotly-gl3d-2.27.0.min.js" crossorigin></script>

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

    <% request.setAttribute("activeService", "gradient-descent"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Demo runtime status (updated by gradient-descent.js) -->
        <div class="ml-runtime-pill" id="mlRuntimePill" data-state="idle">
            <span class="ml-runtime-dot" aria-hidden="true"></span>
            <span id="mlRuntimeLabel">Demo runtime &middot; idle</span>
        </div>

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        Gradient Descent, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Ch 1 · Optimization &middot; Gradient Descent
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Ch 1 · Optimization</span>
            </div>
            <p style="margin:1rem 0 0;color:var(--ms-ink-soft);font:0.95rem/1.55 var(--ms-font-sans);max-width:70ch;">
                Linear regression learns its slope and intercept by gradient descent. Watch the regression line tilt and shift to fit the data on the left, while the <code>(w, b)</code> marker descends the MSE surface on the right &mdash; one epoch at a time. Pick a different dataset to see what gradient descent learns (and where it struggles): clean linear, heavy noise, outliers, a saturating curve, growing variance, or two mixed populations.
            </p>
        </div>

        <!-- Demo panel -->
        <div class="ms-card">
            <div class="gd-demo">
                <div class="gd-canvas-wrap">
                    <span class="gd-canvas-label">Regression line · spending → sales</span>
                    <canvas id="gdFit" aria-label="Data scatter and current regression line"></canvas>
                    <div class="gd-canvas-readout" id="gdFitReadout"></div>
                </div>
                <div class="gd-canvas-wrap">
                    <span class="gd-canvas-label">MSE surface over (w, b) &middot; drag to rotate</span>
                    <div id="gdSurface" class="gd-surface-3d" aria-label="3D MSE landscape over slope and intercept"></div>
                    <div class="gd-canvas-readout" id="gdSurfReadout"></div>
                </div>
            </div>

            <!-- Controls -->
            <div class="gd-controls">
                <div class="gd-control gd-control-wide">
                    <div class="gd-control-label">
                        <span>Dataset</span>
                    </div>
                    <select id="gdDataset">
                        <option value="ads" selected>Ad spend &rarr; Sales</option>
                        <option value="study">Hours studied &rarr; Exam score</option>
                        <option value="salary">Years experience &rarr; Salary (outliers)</option>
                        <option value="freethrows">Practice hours &rarr; Free throws (curve)</option>
                        <option value="income">Income &rarr; Spending (heteroscedastic)</option>
                        <option value="products">Two products mixed (bimodal)</option>
                    </select>
                    <div class="gd-dataset-story" id="gdDatasetStory">Clean linear: GD converges nicely (the baseline).</div>
                </div>

                <div class="gd-control">
                    <div class="gd-control-label">
                        <span>Learning rate &eta;</span>
                        <span class="gd-control-value" id="gdLrValue">5e-5</span>
                    </div>
                    <%-- Log-scale slider: position 0–100 maps to lr 1e-6 to 1e-2 in JS. --%>
                    <input type="range" id="gdLr" min="0" max="100" step="0.5" value="42.5" />
                </div>

                <div class="gd-control">
                    <div class="gd-control-label">
                        <span>Epochs</span>
                        <span class="gd-control-value" id="gdEpochsValue">200</span>
                    </div>
                    <input type="range" id="gdEpochs" min="20" max="4000" step="10" value="200" />
                </div>

                <div class="gd-control">
                    <div class="gd-control-label">
                        <span>Initial w (slope)</span>
                    </div>
                    <input type="number" id="gdInitW" step="0.01" value="0" />
                </div>

                <div class="gd-control">
                    <div class="gd-control-label">
                        <span>Initial b (intercept)</span>
                    </div>
                    <input type="number" id="gdInitB" step="0.1" value="0" />
                </div>

                <div class="gd-control">
                    <div class="gd-control-label">
                        <span>Anim speed</span>
                        <span class="gd-control-value" id="gdSpeedValue">30/s</span>
                    </div>
                    <input type="range" id="gdSpeed" min="2" max="120" step="1" value="30" />
                </div>
            </div>

            <div class="gd-actions">
                <button type="button" id="gdRun" class="gd-btn is-primary">
                    <span aria-hidden="true">&#9656;</span> Run
                </button>
                <button type="button" id="gdReset" class="gd-btn">Reset</button>
                <span style="font:0.78rem var(--ms-font-mono);color:var(--ms-muted);align-self:center;">
                    Tip: drag to rotate the surface, scroll to zoom, click any point to seed (w, b) and re-run.
                </span>
            </div>

            <div class="gd-console" id="gdConsole" aria-live="polite"></div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Editable Python source -->
        <div class="ms-card">
            <h2 class="ms-section-title">The algorithm <small style="font:0.85rem var(--ms-font-sans);color:var(--ms-muted);margin-left:0.65rem;">edit and re-run</small></h2>
            <div class="gd-code">
                <div class="gd-code-header">
                    <span class="gd-code-title">gradient_descent.py</span>
                    <div class="gd-code-actions">
                        <button type="button" id="gdResetCode" title="Revert to original">reset code</button>
                        <button type="button" id="gdCopy">copy</button>
                    </div>
                </div>
                <textarea id="gdCode" spellcheck="false">import numpy as np

# Fit a line y = w·x + b to the (DATA_X, DATA_Y) dataset by gradient
# descent on the mean squared error.  DATA_X and DATA_Y are numpy
# arrays of length 200, injected by the demo runner.

# ── The model ───────────────────────────────────────────
def predict(x, w, b):
    return w * x + b

# ── The loss: mean squared error ────────────────────────
def mse_loss(x, y, w, b):
    return np.mean((y - predict(x, w, b)) ** 2)

# ── Gradients (derived in the math card below) ──────────
def mse_loss_dw(x, y, w, b):
    return -2.0 * np.mean(x * (y - predict(x, w, b)))

def mse_loss_db(x, y, w, b):
    return -2.0 * np.mean(    (y - predict(x, w, b)))

# ── One gradient-descent step on (w, b) ─────────────────
def step(x, y, w, b, lr):
    w_new = w - lr * mse_loss_dw(x, y, w, b)
    b_new = b - lr * mse_loss_db(x, y, w, b)
    return w_new, b_new

# ── The training loop ───────────────────────────────────
def run(lr=0.00005, epochs=200, w0=0.0, b0=0.0):
    """Fit y = w·x + b by gradient descent. Returns parameter history."""
    w, b = float(w0), float(b0)
    history = {
        "w":    [w],
        "b":    [b],
        "loss": [float(mse_loss(DATA_X, DATA_Y, w, b))],
    }
    for _ in range(int(epochs)):
        w, b = step(DATA_X, DATA_Y, w, b, lr)
        history["w"].append(float(w))
        history["b"].append(float(b))
        history["loss"].append(float(mse_loss(DATA_X, DATA_Y, w, b)))
    return history

# Try this:
#   · Normalize first:  DATA_X = (DATA_X - DATA_X.mean()) / DATA_X.std()
#                       then crank lr up to 0.01 — converges in ~50 epochs
#   · Add momentum:     v_w = 0.9*v_w - lr*dw;  w = w + v_w  (same for b)
#   · Add L2 penalty:   include + lam*w in mse_loss_dw
#   · Switch to MAE:    use np.mean(np.abs(...)) and sign() in the gradient
</textarea>
            </div>
        </div>

        <!-- Math derivation -->
        <div class="ms-card">
            <h2 class="ms-section-title">The math, derived</h2>
            <div class="gd-math">
                <div class="gd-math-step">
                    <h4>1. The model.</h4>
                    <p>A linear regression predicts $\hat{y}$ from $x$ using two parameters &mdash; a slope $w$ and an intercept $b$:</p>
                    $$ \hat{y} \;=\; w \, x \,+\, b $$
                    <p style="margin-top:0.4rem;">Our job is to find the $w$ and $b$ that make $\hat{y}$ closest to the true $y$ across all $N$ data points.</p>
                </div>
                <div class="gd-math-step">
                    <h4>2. The loss: mean squared error.</h4>
                    <p>For each example $i$, the <em>residual</em> is $y_i - \hat{y}_i$. We square it (so positive and negative errors don&rsquo;t cancel) and average:</p>
                    $$ L(w, b) \;=\; \frac{1}{N} \sum_{i=1}^{N} \bigl(\,y_i - (w\,x_i + b)\,\bigr)^2 $$
                </div>
                <div class="gd-math-step">
                    <h4>3. Differentiate w.r.t. <em>w</em>.</h4>
                    <p>Treat $b$ as a constant. The inner residual depends on $w$ only through the $-w\,x_i$ term, so by the chain rule:</p>
                    $$ \frac{\partial L}{\partial w}
                       \;=\; \frac{1}{N} \sum_{i=1}^{N} 2\bigl(y_i - (w\,x_i + b)\bigr) \cdot \bigl(-x_i\bigr) $$
                    $$ \;=\; -\frac{2}{N} \sum_{i=1}^{N} x_i\,\bigl(y_i - (w\,x_i + b)\bigr) $$
                    <p style="margin-top:0.4rem;">That&rsquo;s exactly <code>mse_loss_dw</code> in the code above &mdash; <code>np.mean</code> handles the $\frac{1}{N}\sum$.</p>
                </div>
                <div class="gd-math-step">
                    <h4>4. Differentiate w.r.t. <em>b</em>.</h4>
                    <p>Same idea, but the inner term contributes $-1$ for $b$ instead of $-x_i$:</p>
                    $$ \frac{\partial L}{\partial b}
                       \;=\; -\frac{2}{N} \sum_{i=1}^{N} \bigl(y_i - (w\,x_i + b)\bigr) $$
                </div>
                <div class="gd-math-step">
                    <h4>5. The update rule.</h4>
                    <p>Take a small step opposite each partial derivative, scaled by the learning rate $\eta$:</p>
                    $$ w \;\leftarrow\; w \,-\, \eta\,\frac{\partial L}{\partial w}, \qquad
                       b \;\leftarrow\; b \,-\, \eta\,\frac{\partial L}{\partial b} $$
                    <p style="margin-top:0.4rem;">Repeat for many epochs. The MSE bowl is <em>convex</em>, so the parameters always converge to the unique optimum &mdash; if $\eta$ is small enough. Push $\eta$ past the divergence threshold and watch the marker fly off the canvas.</p>
                </div>
            </div>
        </div>

        <!-- Exercises -->
        <div class="ms-card">
            <h2 class="ms-section-title">Try this</h2>
            <div class="gd-try">
                <div class="gd-try-item">
                    <h4>Find the divergence threshold</h4>
                    <p>The default <code>lr = 5e-5</code> is conservative. Slowly increase it. Around <code>2e-4</code> the regression line starts swinging; past <code>3e-4</code> it diverges entirely. Why is the threshold so low? Because <code>x</code> reaches 50 &mdash; the gradient gets multiplied by big numbers.</p>
                </div>
                <div class="gd-try-item">
                    <h4>Normalize, then go fast</h4>
                    <p>Add <code>DATA_X = (DATA_X - DATA_X.mean()) / DATA_X.std()</code> at the top of the algorithm. Now the gradient stays bounded &mdash; crank <code>lr</code> to <code>0.01</code> and convergence drops to ~50 epochs.</p>
                </div>
                <div class="gd-try-item">
                    <h4>Add momentum</h4>
                    <p>Replace <code>step()</code> with momentum GD: <code>v_w = 0.9*v_w − lr*dw; w = w + v_w</code> (same for <code>b</code>). The marker takes a more direct path down the MSE bowl.</p>
                </div>
                <div class="gd-try-item">
                    <h4>Switch MSE to MAE</h4>
                    <p>Mean absolute error is more robust to outliers. Replace squared error with <code>np.mean(np.abs(...))</code>; the gradient becomes <code>-np.mean(x * np.sign(y - (w*x+b)))</code>. How does the fit change? (Hint: it pulls the line toward the median residual instead of the mean.)</p>
                </div>
                <div class="gd-try-item">
                    <h4>Add L2 regularization</h4>
                    <p>Append <code>+ lam*w</code> to <code>mse_loss_dw</code> with <code>lam = 0.001</code>. This is <em>ridge regression</em>. It pulls $w$ toward zero. Find a value of <code>lam</code> large enough to visibly shrink the slope.</p>
                </div>
                <div class="gd-try-item">
                    <h4>Bad initialization</h4>
                    <p>Click the top-right corner of the MSE surface to set <code>w ≈ 0.65</code>, <code>b ≈ 14</code>. The line starts wildly steep. Does default <code>lr</code> still converge? How many epochs?</p>
                </div>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="Gradient descent FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is gradient descent in linear regression?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">It&rsquo;s how the regression line learns its slope $w$ and intercept $b$. We define an error metric (mean squared error) and step both parameters in the direction that reduces it: $w \leftarrow w - \eta \cdot \partial L / \partial w$ and $b \leftarrow b - \eta \cdot \partial L / \partial b$. After enough epochs, $(w, b)$ settles at the values that fit the data best.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does my run blow up?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Almost always: <strong>learning rate too high</strong>. The step overshoots the bottom of the MSE bowl and lands further uphill than where it started &mdash; $w$ and $b$ oscillate then fly off. The dataset&rsquo;s $x$ values reach 50, so even a modest learning rate gets multiplied by big gradients. Halve <code>lr</code> and try again.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why is the default learning rate so small (5e-5)?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Because the input feature is unnormalized &mdash; $x \in [0, 50]$ means the gradient w.r.t. $w$ can be hundreds. A larger <code>lr</code> would diverge. In real-world pipelines you&rsquo;d <strong>normalize</strong> $x$ (subtract mean, divide by std) first, then a much larger <code>lr</code> like <code>0.01</code> becomes safe. Try it: prepend <code>DATA_X = (DATA_X - DATA_X.mean()) / DATA_X.std()</code> to the code and crank <code>lr</code> up.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Can I change the algorithm?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Yes &mdash; the algorithm source on this page is editable. Try adding momentum (keep a running average of past gradients), switching MSE to MAE (absolute error), or adding an L2 regularizer. Click <strong>Run</strong> to see your version fit the data.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/gradient-descent.js?v=<%=v%>" defer></script>
</body>
</html>
