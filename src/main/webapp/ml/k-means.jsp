<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="K-Means Clustering Visualized — Watch Lloyd's Algorithm Converge" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive K-Means demo. Pick a dataset shape, set k, watch centroids drift to the means while points snap to their nearest cluster — one iteration at a time. See where K-means succeeds (blobs) and where it fails (moons, rings). Edit the algorithm. No signup." />
        <jsp:param name="toolUrl" value="ml/k-means.jsp" />
        <jsp:param name="toolImage" value="k-means-og.png" />
        <jsp:param name="toolKeywords" value="k-means clustering, k-means visualizer, lloyd's algorithm, k-means++ initialization, unsupervised clustering demo, wcss inertia, voronoi tessellation, k-means moons, k-means rings, ml clustering from scratch, kmeans python interactive" />
        <jsp:param name="toolFeatures" value="6 datasets: blobs/anisotropic/unequal-size/unequal-variance/moons/rings,Live centroid + label animation,Voronoi shading,k-means++ vs random init,Inertia (WCSS) line chart,Editable algorithm source,Cluster legend,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a dataset|Choose one of six shapes — well-separated blobs are easy K-means territory while moons and rings expose its limits,Set k and init|Slide the number of clusters and choose between random or k-means++ initialization,Click run|Watch points snap to clusters and centroids drift to the means each iteration with inertia monotonically decreasing" />
        <jsp:param name="faq1q" value="What is K-Means clustering?" />
        <jsp:param name="faq1a" value="An unsupervised algorithm that partitions data into k groups. It alternates two steps: assign each point to the nearest centroid, then move each centroid to the mean of its assigned points. Repeats until centroids stop moving. The total within-cluster squared distance (inertia) decreases monotonically — that's Lloyd's convergence guarantee." />
        <jsp:param name="faq2q" value="Why does it fail on moons and rings?" />
        <jsp:param name="faq2a" value="K-means assumes clusters are convex blobs around a center. Half-moons and concentric rings are non-convex — the 'center' of a ring is the same point as the center of the inner ring, so K-means can't see them as different groups. Density-based methods (DBSCAN) or spectral clustering can." />
        <jsp:param name="faq3q" value="What is k-means++?" />
        <jsp:param name="faq3a" value="A smarter way to pick initial centroids. Instead of choosing them uniformly at random, k-means++ picks the first one randomly, then weights subsequent picks by squared distance to existing centroids — pushing them apart. Result: fewer iterations to converge and better final inertia, especially on hard datasets." />
        <jsp:param name="faq4q" value="How do I know the right k?" />
        <jsp:param name="faq4a" value="There's no perfect rule, but two heuristics help: the elbow method (plot inertia vs k — pick the value where the curve bends) and the silhouette score (measures how well each point fits its cluster vs neighbors). For most real datasets, several values of k are defensible — the choice depends on what you're optimizing." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/k-means.css?v=<%=v%>">

    <%-- KaTeX for the math derivation card --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

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

    <% request.setAttribute("activeService", "k-means"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <div class="ml-runtime-pill" id="mlRuntimePill" data-state="idle">
            <span class="ml-runtime-dot" aria-hidden="true"></span>
            <span id="mlRuntimeLabel">Demo runtime &middot; idle</span>
        </div>

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        K-Means, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Clustering &middot; K-Means
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Clustering</span>
            </div>
            <p style="margin:1rem 0 0;color:var(--ms-ink-soft);font:0.95rem/1.55 var(--ms-font-sans);max-width:70ch;">
                K-Means partitions data into <em>k</em> clusters by alternating two steps: assign each point to its nearest centroid, then move each centroid to the mean of its members. Watch the points snap to clusters and the centroids drift on the left, while the inertia (sum of squared distances) ticks down on the right &mdash; one iteration at a time. Swap datasets to see where K-means shines and where it visibly fails.
            </p>
        </div>

        <!-- Demo -->
        <div class="ms-card">
            <div class="km-demo">
                <div class="km-canvas-wrap">
                    <span class="km-canvas-label">Clusters &amp; centroids</span>
                    <canvas id="kmScatter" aria-label="Cluster assignments and centroids"></canvas>
                    <div class="km-canvas-readout" id="kmScatterReadout"></div>
                </div>
                <div class="km-canvas-wrap">
                    <span class="km-canvas-label">Inertia (WCSS) per iteration</span>
                    <canvas id="kmInertia" aria-label="Inertia curve"></canvas>
                    <div class="km-canvas-readout" id="kmInertiaReadout"></div>
                </div>
            </div>

            <!-- Cluster legend chips -->
            <div class="km-legend" id="kmLegend"></div>

            <!-- Controls -->
            <div class="km-controls">
                <div class="km-control km-control-wide">
                    <div class="km-control-label">
                        <span>Dataset</span>
                    </div>
                    <select id="kmDataset">
                        <option value="blobs" selected>Three well-separated blobs</option>
                        <option value="anisotropic">Anisotropic blobs (stretched)</option>
                        <option value="unequalSize">Unequal cluster sizes</option>
                        <option value="unequalVariance">Unequal variance (tight + spread)</option>
                        <option value="moons">Two moons (non-convex)</option>
                        <option value="rings">Concentric rings</option>
                    </select>
                    <div class="km-dataset-story" id="kmDatasetStory">The baseline: K-means converges in 2&ndash;3 iterations and finds the truth.</div>
                </div>

                <div class="km-control">
                    <div class="km-control-label">
                        <span>k (clusters)</span>
                        <span class="km-control-value" id="kmKValue">3</span>
                    </div>
                    <input type="range" id="kmK" min="2" max="8" step="1" value="3" />
                </div>

                <div class="km-control">
                    <div class="km-control-label"><span>Initialization</span></div>
                    <select id="kmInit">
                        <option value="kmeans++" selected>k-means++</option>
                        <option value="random">random</option>
                    </select>
                </div>

                <div class="km-control">
                    <div class="km-control-label"><span>Max iterations</span></div>
                    <input type="number" id="kmMaxIter" min="1" max="200" step="1" value="20" />
                </div>

                <div class="km-control">
                    <div class="km-control-label"><span>Random seed</span></div>
                    <input type="number" id="kmSeed" min="0" max="9999" step="1" value="0" />
                </div>

                <div class="km-control">
                    <div class="km-control-label">
                        <span>Anim speed</span>
                        <span class="km-control-value" id="kmSpeedValue">2/s</span>
                    </div>
                    <input type="range" id="kmSpeed" min="0.5" max="8" step="0.5" value="2" />
                </div>
            </div>

            <div class="km-actions">
                <button type="button" id="kmRun" class="km-btn is-primary">
                    <span aria-hidden="true">&#9656;</span> Run
                </button>
                <button type="button" id="kmReset" class="km-btn">Reset</button>
                <span style="font:0.78rem var(--ms-font-mono);color:var(--ms-muted);align-self:center;">
                    Tip: change the seed to see how much the final clusters depend on initialization.
                </span>
            </div>

            <div class="km-console" id="kmConsole" aria-live="polite"></div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Code panel -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The algorithm <small style="font:0.85rem var(--ms-font-sans);color:var(--ms-muted);margin-left:0.65rem;">edit and re-run</small></h2>
            <div class="km-code">
                <div class="km-code-header">
                    <span class="km-code-title">k_means.py</span>
                    <div class="km-code-actions">
                        <button type="button" id="kmResetCode" title="Revert to original">reset code</button>
                        <button type="button" id="kmCopy">copy</button>
                    </div>
                </div>
                <textarea id="kmCode" spellcheck="false">import numpy as np

# Cluster a 2D dataset DATA_X (shape: N×2) into k groups by Lloyd's
# algorithm.  Each iteration: (1) assign each point to its nearest
# centroid (E-step), (2) move each centroid to the mean of its
# assigned points (M-step).  Inertia = sum of squared distances of
# each point to its assigned centroid.

# ── E-step: nearest-centroid assignment ─────────────────
def assign(X, centroids):
    # Pairwise squared distance via broadcasting.
    dists = ((X[:, None, :] - centroids[None, :, :]) ** 2).sum(-1)
    return np.argmin(dists, axis=1)

# ── M-step: centroid update ─────────────────────────────
def update_centroids(X, labels, k):
    new_c = np.zeros((k, X.shape[1]))
    for c in range(k):
        mask = (labels == c)
        if mask.any():
            new_c[c] = X[mask].mean(axis=0)
        else:
            # Empty cluster: reseed to a random data point so k stays fixed.
            new_c[c] = X[np.random.randint(len(X))]
    return new_c

def inertia(X, labels, centroids):
    return float(sum(((X[labels == c] - centroids[c]) ** 2).sum()
                     for c in range(len(centroids))))

# ── k-means++ initialization ────────────────────────────
def init_plus_plus(X, k, rng):
    n = len(X)
    centroids = [X[rng.integers(n)]]
    for _ in range(1, k):
        d2 = np.min(((X[:, None, :] -
                      np.array(centroids)[None, :, :]) ** 2).sum(-1), axis=1)
        probs = d2 / d2.sum()
        centroids.append(X[rng.choice(n, p=probs)])
    return np.array(centroids)

# ── Lloyd's training loop ───────────────────────────────
def run(k=3, max_iter=20, init="kmeans++", seed=0):
    """Cluster DATA_X into k groups.  Returns iteration history."""
    rng = np.random.default_rng(seed)
    if init == "kmeans++":
        centroids = init_plus_plus(DATA_X, k, rng)
    else:
        idx = rng.choice(len(DATA_X), size=k, replace=False)
        centroids = DATA_X[idx].copy()

    labels = assign(DATA_X, centroids)
    history = {
        "centroids": [centroids.tolist()],
        "labels":    [labels.tolist()],
        "inertia":   [inertia(DATA_X, labels, centroids)],
    }

    for _ in range(int(max_iter)):
        new_c = update_centroids(DATA_X, labels, k)
        if np.allclose(new_c, centroids, atol=1e-6):
            break
        centroids = new_c
        labels = assign(DATA_X, centroids)
        history["centroids"].append(centroids.tolist())
        history["labels"].append(labels.tolist())
        history["inertia"].append(inertia(DATA_X, labels, centroids))

    return history

# Try this:
#   · Switch init="random" on the moons dataset — see how sensitive convergence is to init
#   · Replace Euclidean distance with Manhattan (np.abs(...).sum(-1)) — different splits
#   · Add an early-stop tolerance: break when |inertia_new - inertia_old| / inertia_old &lt; 1e-4
#   · Add a "miniBatch" mode that samples 64 points per iteration (sklearn.MiniBatchKMeans)
</textarea>
            </div>
        </div>

        <!-- Math card -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, derived</h2>
            <div class="km-math">
                <div class="km-math-step">
                    <h4>1. The objective.</h4>
                    <p>Pick $k$ centroids $\mu_1, \ldots, \mu_k$ that minimize the total within-cluster squared distance &mdash; the <em>inertia</em>:</p>
                    $$ J(\mu_1, \ldots, \mu_k) \;=\; \sum_{c=1}^{k} \;\sum_{x \in C_c} \|x - \mu_c\|^2 $$
                    <p style="margin-top:0.4rem;">$C_c$ is the set of points assigned to cluster $c$. Lower $J$ &rArr; tighter clusters.</p>
                </div>
                <div class="km-math-step">
                    <h4>2. The combinatorial trap.</h4>
                    <p>Optimizing $J$ exactly is NP-hard &mdash; there are $\binom{N}{k}$ ways to assign $N$ points to $k$ groups. We need a heuristic, and the natural one is <strong>coordinate descent</strong>: alternate between the two unknowns (the assignments and the centroids), holding one fixed at a time.</p>
                </div>
                <div class="km-math-step">
                    <h4>3. E-step &mdash; assign points to nearest centroid.</h4>
                    <p>With $\mu_c$ fixed, the assignment that minimizes $J$ for each point is the obvious one: nearest centroid by squared distance.</p>
                    $$ C_c \;=\; \{\, x_i \;:\; c \,=\, \arg\min_j \|x_i - \mu_j\|^2 \,\} $$
                </div>
                <div class="km-math-step">
                    <h4>4. M-step &mdash; centroid = mean of cluster.</h4>
                    <p>With $C_c$ fixed, the centroid that minimizes the within-cluster term is the <em>mean</em> &mdash; from calculus, $\nabla_{\mu_c} J = -2 \sum_{x \in C_c} (x - \mu_c) = 0$.</p>
                    $$ \mu_c \;=\; \frac{1}{|C_c|} \sum_{x \in C_c} x $$
                </div>
                <div class="km-math-step">
                    <h4>5. Why it converges (and doesn&rsquo;t reach the optimum).</h4>
                    <p>Both steps strictly decrease $J$ unless $J$ is already at a local minimum &mdash; that&rsquo;s why the inertia curve on the right is monotonically falling. But local, not global: a bad initial centroid placement can trap K-means in a worse partition than the true optimum. That&rsquo;s what <strong>k-means++</strong> fixes &mdash; it spreads the initial centroids far apart so we usually start in the right basin.</p>
                </div>
            </div>
        </div>

        <!-- Exercises -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
            <div class="km-try">
                <div class="km-try-item">
                    <h4>The over-segmentation trap</h4>
                    <p>On the three-blobs dataset, crank <code>k</code> from 3 to 6. The algorithm <em>has</em> to split the existing blobs &mdash; the inertia keeps falling but the result is meaningless. This is why elbow plots matter.</p>
                </div>
                <div class="km-try-item">
                    <h4>Initialization matters</h4>
                    <p>Switch to <code>moons</code> and toggle init between <code>random</code> and <code>kmeans++</code>, varying the seed. Count iterations to convergence and compare final inertia. k-means++ usually wins by 30&ndash;60%.</p>
                </div>
                <div class="km-try-item">
                    <h4>The non-convex wall</h4>
                    <p>On <code>rings</code> with k=2, K-means can&rsquo;t separate them &mdash; both rings have the same mean. The result is a bad horizontal split. This is the canonical motivation for spectral clustering or DBSCAN.</p>
                </div>
                <div class="km-try-item">
                    <h4>The small-cluster problem</h4>
                    <p>On <code>unequalSize</code>, K-means absorbs the 15-point cluster into a neighbor (mean pull is too weak). Add <code>min_size</code> logic in the code: split the biggest cluster when a smaller one drops below threshold.</p>
                </div>
                <div class="km-try-item">
                    <h4>Manhattan instead of Euclidean</h4>
                    <p>Replace <code>((X-c)**2).sum(-1)</code> with <code>np.abs(X-c).sum(-1)</code> in <code>assign()</code>. That&rsquo;s now K-medians (sort of). How does the partition change on anisotropic blobs?</p>
                </div>
                <div class="km-try-item">
                    <h4>Multiple restarts</h4>
                    <p>Wrap <code>run()</code> in a loop that tries 10 random seeds and keeps the lowest-inertia result. This is what <code>sklearn.KMeans</code> does by default (<code>n_init=10</code>) and is one of the few times "just do it 10 times" is the right answer.</p>
                </div>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="K-Means FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is K-Means clustering?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">An unsupervised algorithm that partitions data into $k$ groups. It alternates two steps: <strong>assign</strong> each point to the nearest centroid, then <strong>move</strong> each centroid to the mean of its assigned points. Repeats until centroids stop moving. The total within-cluster squared distance (inertia) decreases monotonically &mdash; that&rsquo;s Lloyd&rsquo;s convergence guarantee.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does it fail on moons and rings?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">K-means assumes clusters are convex blobs around a center. Half-moons and concentric rings are non-convex &mdash; the "center" of a ring is the same point as the center of the inner ring, so K-means can&rsquo;t see them as different groups. Density-based methods (<strong>DBSCAN</strong>) or spectral clustering can.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is k-means++?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">A smarter way to pick initial centroids. Instead of choosing them uniformly at random, k-means++ picks the first one randomly, then weights subsequent picks by squared distance to existing centroids &mdash; pushing them apart. Result: fewer iterations to converge and better final inertia, especially on hard datasets.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        How do I know the right k?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">There&rsquo;s no perfect rule, but two heuristics help: the <strong>elbow method</strong> (plot inertia vs $k$ &mdash; pick the value where the curve bends) and the <strong>silhouette score</strong> (measures how well each point fits its cluster vs neighbors). For most real datasets, several values of $k$ are defensible &mdash; the choice depends on what you&rsquo;re optimizing.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/k-means.js?v=<%=v%>" defer></script>
</body>
</html>
