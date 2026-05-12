<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="PCA Visualized — Principal Component Analysis in 3D" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Interactive PCA demo. Watch the principal components light up on a 3D point cloud, drop dimensions, and see how much variance you keep. Six datasets cover the cases where PCA shines and where it fails. Real numpy eigendecomposition in your browser. No signup." />
        <jsp:param name="toolUrl" value="ml/pca.jsp" />
        <jsp:param name="toolImage" value="pca-og.png" />
        <jsp:param name="toolKeywords" value="pca visualizer, principal component analysis demo, pca eigendecomposition, dimensionality reduction, variance explained, scree plot, pca vs t-sne, pca swiss roll, pca isotropic sphere, ml from scratch, sklearn pca" />
        <jsp:param name="toolFeatures" value="6 datasets: noisy line/plane/anisotropic/sphere/swiss-roll/two-clusters,Two 3D Plotly panels: original with PC arrows + projected data,Scree plot of explained variance,Editable algorithm source via Pyodide,Standardize toggle,Variable target dimensions (1, 2, or 3),Math card with full Lagrangian derivation,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a dataset|Choose between the canonical noisy-line case where PCA shines and harder cases like the isotropic sphere or swiss roll where it doesn't,Set target dimensions|Slide to 1, 2, or 3 components — watch how much variance you keep in the scree plot,Click run|Real numpy computes the eigendecomposition; PC arrows appear on the original data; the projected panel shows what you keep after dimensionality reduction" />
        <jsp:param name="faq1q" value="What is PCA used for?" />
        <jsp:param name="faq1a" value="Three things: (1) dimensionality reduction — compress N-feature data to k features that retain most variance; (2) visualization — projecting high-dimensional data to 2D or 3D for plotting; (3) decorrelation — the principal components are orthogonal, useful as inputs to downstream models that assume independent features." />
        <jsp:param name="faq2q" value="When does PCA fail?" />
        <jsp:param name="faq2a" value="When variance is isotropic (a sphere has no preferred direction) or when the structure is nonlinear (a swiss roll's underlying 2D manifold gets flattened by linear projection). Try the sphere and swiss-roll datasets — PCA flatlines on the first and loses the structure on the second." />
        <jsp:param name="faq3q" value="Should I standardize before PCA?" />
        <jsp:param name="faq3a" value="Almost always yes. PCA is sensitive to feature scale — a column ranging 0–10000 will dominate PC1 over a column ranging 0–1 even if both carry similar information. Subtract the mean and divide by the std (z-score) before fitting." />
        <jsp:param name="faq4q" value="PCA vs t-SNE vs UMAP?" />
        <jsp:param name="faq4a" value="PCA is linear, fast, interpretable, and good for global structure + decorrelation. t-SNE and UMAP are nonlinear, slower, and better at preserving local neighborhoods — but they distort global distances and shouldn't be used for downstream modeling. Use PCA when you want a meaningful feature space; use t-SNE/UMAP only for visualization." />
        <jsp:param name="faq5q" value="How do I pick the number of components?" />
        <jsp:param name="faq5a" value="Two heuristics: (1) plot the cumulative explained variance and pick the smallest k that gets you above your threshold (e.g., 95%); (2) look for an 'elbow' in the scree plot — a sharp drop in eigenvalues followed by a plateau. In sklearn, n_components=0.95 picks the smallest k retaining 95% variance for you." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/pca.css?v=<%=v%>">

    <%-- KaTeX for the math derivation card --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.css" crossorigin>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/katex.min.js" crossorigin></script>
    <script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.9/dist/contrib/auto-render.min.js" crossorigin
            onload="renderMathInElement(document.body,{delimiters:[{left:'$$',right:'$$',display:true},{left:'$',right:'$',display:false}]});"></script>

    <%-- Plotly 3D-only build for the two 3D panels --%>
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

    <% request.setAttribute("activeService", "pca"); %>
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
                        PCA, <em style="font-style:italic;color:#4f46e5;">visualized</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; Clustering &amp; Reduction &middot; PCA
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Reduction</span>
            </div>
            <p style="margin:1rem 0 0;color:var(--ms-ink-soft);font:0.95rem/1.55 var(--ms-font-sans);max-width:72ch;">
                <strong>Principal Component Analysis</strong> finds the directions along which your data varies the most &mdash; then lets you project onto a smaller subset of them, keeping signal and discarding redundancy. Watch the PC arrows appear on a 3D cloud on the left, and the projection (with the discarded dimensions collapsed to zero) on the right. Compare across six datasets to see where PCA shines and where it fails.
            </p>
        </div>

        <!-- Demo -->
        <div class="ms-card">
            <div class="pca-demo">
                <div class="pca-canvas-wrap">
                    <span class="pca-canvas-label">Original data &middot; PCs in red/green/blue</span>
                    <div id="pcaOriginal" class="pca-3d" aria-label="Original 3D data with principal components"></div>
                    <div class="pca-canvas-readout" id="pcaOrigReadout"></div>
                </div>
                <div class="pca-canvas-wrap">
                    <span class="pca-canvas-label">Projected data &middot; in PC coordinates</span>
                    <div id="pcaProjected" class="pca-3d" aria-label="Projected data in principal-component space"></div>
                    <div class="pca-canvas-readout" id="pcaProjReadout"></div>
                </div>
            </div>

            <!-- Scree plot -->
            <div class="pca-scree-wrap">
                <div class="pca-scree-label">Explained variance per principal component &middot; dashed = cumulative</div>
                <canvas id="pcaScree" class="pca-scree-canvas" aria-label="Scree plot of explained variance"></canvas>
            </div>

            <!-- Controls -->
            <div class="pca-controls">
                <div class="pca-control pca-control-wide">
                    <div class="pca-control-label"><span>Dataset</span></div>
                    <select id="pcaDataset">
                        <option value="hyperplane" selected>Noisy line in 3D</option>
                        <option value="plane">Points on a plane</option>
                        <option value="anisotropic">Anisotropic blob (rotated)</option>
                        <option value="sphere">Sphere shell (isotropic &mdash; PCA fails)</option>
                        <option value="swissRoll">Swiss roll (nonlinear &mdash; PCA flattens)</option>
                        <option value="twoClusters">Two clusters along diagonal</option>
                    </select>
                    <div class="pca-dataset-story" id="pcaDatasetStory">Points along a diagonal + noise. PC1 captures most variance &mdash; the canonical PCA case.</div>
                </div>

                <div class="pca-control">
                    <div class="pca-control-label">
                        <span>Target dimensions</span>
                        <span class="pca-control-value" id="pcaDimsValue">2</span>
                    </div>
                    <input type="range" id="pcaDims" min="1" max="3" step="1" value="2" />
                </div>

                <div class="pca-control">
                    <div class="pca-control-label"><span>Standardize</span></div>
                    <label class="pca-control-checkbox">
                        <input type="checkbox" id="pcaStandardize" checked>
                        <span>z-score features first (recommended)</span>
                    </label>
                </div>
            </div>

            <div class="pca-actions">
                <button type="button" id="pcaRun" class="pca-btn is-primary">
                    <span aria-hidden="true">&#9656;</span> Run
                </button>
                <button type="button" id="pcaReset" class="pca-btn">Reset</button>
                <span style="font:0.78rem var(--ms-font-mono);color:var(--ms-muted);align-self:center;">
                    Tip: drag to rotate either 3D panel &mdash; compare the variance directions to the data shape.
                </span>
            </div>

            <div class="pca-console" id="pcaConsole" aria-live="polite"></div>
        </div>

        <div class="ms-inline-ad">
            <%@ include file="../modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- Editable Python source -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The algorithm <small style="font:0.85rem var(--ms-font-sans);color:var(--ms-muted);margin-left:0.65rem;">edit and re-run</small></h2>
            <div class="pca-code">
                <div class="pca-code-header">
                    <span class="pca-code-title">pca.py</span>
                    <div class="pca-code-actions">
                        <button type="button" id="pcaResetCode" title="Revert to original">reset code</button>
                        <button type="button" id="pcaCopy">copy</button>
                    </div>
                </div>
                <textarea id="pcaCode" spellcheck="false">import numpy as np

# DATA_X is an (N, 3) numpy array of input points, injected by the runner.
# Goal: find the directions of maximum variance, then project onto them.

# ── Step 1 · Center (and optionally scale) ──────────────
# Always subtract the mean — PCA is defined on centered data.
# If standardize=True, also divide by std so no feature dominates by scale.
def standardize(X):
    return (X - X.mean(axis=0)) / X.std(axis=0)

def center_only(X):
    return X - X.mean(axis=0)

# ── Step 2 · Covariance matrix ──────────────────────────
# d × d matrix where C[i, j] = how features i and j co-vary.
def covariance(X):
    return np.cov(X.T)

# ── Step 3 · Eigendecomposition ─────────────────────────
# Covariance matrices are symmetric and positive semi-definite, so we
# use eigh (not eig) — eigh guarantees real eigenvalues and is more
# numerically stable. eigh returns ascending order; reverse for desc.
def eigendecompose(C):
    eig_vals, eig_vecs = np.linalg.eigh(C)
    idx = np.argsort(eig_vals)[::-1]
    return eig_vals[idx], eig_vecs[:, idx]

# ── Sign convention (sklearn-style) ─────────────────────
# Eigenvectors are defined up to sign — flip so the largest-magnitude
# component of each PC is positive.  Keeps results stable across runs.
def apply_sign_convention(eig_vecs, projected):
    for j in range(eig_vecs.shape[1]):
        i = int(np.argmax(np.abs(eig_vecs[:, j])))
        if eig_vecs[i, j] < 0:
            eig_vecs[:, j] *= -1
            if j < projected.shape[1]:
                projected[:, j] *= -1
    return eig_vecs, projected

# ── Step 4 · Project onto the full PC basis ─────────────
# Multiply pre-processed data by ALL eigenvectors.  Dimensionality
# reduction is then a one-liner: keep the first k columns.
def project(X_pre, eig_vecs):
    return X_pre @ eig_vecs            # shape (N, d)

# ── Full PCA pipeline ───────────────────────────────────
def pca(X, standardize_first=True):
    X_pre = standardize(X) if standardize_first else center_only(X)
    C = covariance(X_pre)
    eig_vals, eig_vecs = eigendecompose(C)
    projected = project(X_pre, eig_vecs)
    eig_vecs, projected = apply_sign_convention(eig_vecs, projected)
    var_pct = eig_vals / eig_vals.sum()
    # When we skip standardization, PCs are already in original-data
    # scale — return std=1 so the JS arrow renderer doesn't re-scale.
    std_out = X.std(axis=0).tolist() if standardize_first else [1.0] * X.shape[1]
    return {
        "eig_vals":     eig_vals.tolist(),
        "eig_vecs":     eig_vecs.tolist(),
        "projected":    projected.tolist(),    # (N, d) — full basis
        "variance_pct": var_pct.tolist(),
        "mean":         X.mean(axis=0).tolist(),
        "std":          std_out,
    }

# Dimensionality reduction = take the first k columns:
#     X_reduced = projected[:, :k]
# That's what the "Target dimensions" slider in the UI does on the display side.

# Try this:
#   · Replace eigh() with SVD:  U, S, Vt = np.linalg.svd(X_pre, full_matrices=False)
#                              eig_vecs = Vt.T   (SVD avoids forming the covariance)
#   · Toggle Standardize off on the anisotropic dataset — PCs flip to follow raw scale
#   · Compute reconstruction error for k components:
#         X_recon = projected[:, :k] @ eig_vecs[:, :k].T
#         err = np.linalg.norm(X_pre - X_recon)
</textarea>
            </div>
        </div>

        <!-- Math card -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">The math, derived</h2>
            <div class="pca-math">
                <div class="pca-math-step">
                    <h4>1. The goal &mdash; max-variance directions.</h4>
                    <p>Given <strong>centered</strong> data $X \in \mathbb{R}^{N \times d}$ (each column zero-mean &mdash; this is why preprocessing always subtracts the mean), find a unit vector $u \in \mathbb{R}^d$ that maximizes the variance of the projections $X u$:</p>
                    $$ \mathrm{Var}(Xu) \;=\; \frac{1}{N - 1}\, u^{\top} X^{\top} X\, u \;=\; u^{\top} S\, u $$
                    <p style="margin-top:0.4rem;">where $S = \frac{1}{N-1} X^{\top} X$ is the <strong>covariance matrix</strong>. (If you also divide by std before this step, $S$ becomes the <em>correlation</em> matrix &mdash; what we compute when Standardize is on.)</p>
                </div>
                <div class="pca-math-step">
                    <h4>2. The constraint &mdash; unit length.</h4>
                    <p>Without a length constraint, you can make $u^{\top} S u$ arbitrarily large by scaling. We only care about <em>direction</em>, so we constrain $u^{\top} u = 1$:</p>
                    $$ \max_{u} \; u^{\top} S\, u \quad \text{subject to} \quad u^{\top} u = 1 $$
                </div>
                <div class="pca-math-step">
                    <h4>3. Lagrangian.</h4>
                    <p>Use a Lagrange multiplier $\lambda$ to fold the constraint into the objective:</p>
                    $$ \mathcal{L}(u, \lambda) \;=\; u^{\top} S\, u \,-\, \lambda \,(\, u^{\top} u - 1 \,) $$
                </div>
                <div class="pca-math-step">
                    <h4>4. Take the gradient, set to zero.</h4>
                    <p>Differentiate w.r.t. $u$ and equate to zero:</p>
                    $$ \nabla_{u} \mathcal{L} \;=\; 2 S u \,-\, 2 \lambda u \;=\; 0 $$
                    $$ S\, u \;=\; \lambda\, u $$
                    <p style="margin-top:0.4rem;">That is exactly the <strong>eigenvalue equation</strong> for $S$. Every critical point of the constrained problem is an eigenvector of the covariance matrix.</p>
                </div>
                <div class="pca-math-step">
                    <h4>5. Which eigenvector?</h4>
                    <p>Substitute $Su = \lambda u$ back into the objective: $u^{\top} S u = \lambda \, u^{\top} u = \lambda$. So the variance along eigenvector $u$ <em>equals its eigenvalue</em> $\lambda$. The principal components are the eigenvectors of $S$ <em>sorted by descending eigenvalue</em> &mdash; the eigenvalue tells you how much variance that direction carries.</p>
                </div>
            </div>
        </div>

        <!-- Try this -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">Try this</h2>
            <div class="pca-try">
                <div class="pca-try-item">
                    <h4>The 90% threshold</h4>
                    <p>On the <code>plane</code> dataset, look at the scree plot. PC1 + PC2 should hit ~95% explained variance &mdash; the third dimension is mostly noise. This is the visual intuition behind <code>n_components=0.95</code>.</p>
                </div>
                <div class="pca-try-item">
                    <h4>When PCA gives up</h4>
                    <p>Switch to the <code>sphere</code> dataset. All three eigenvalues should be roughly equal &mdash; there's no preferred direction. PCA produces something, but it's meaningless. This is what isotropic variance looks like.</p>
                </div>
                <div class="pca-try-item">
                    <h4>The nonlinearity wall</h4>
                    <p>The <code>swiss roll</code> is a 2D manifold embedded in 3D. Linear PCA flattens it &mdash; the projection loses the curved structure. This motivates <code>kernel PCA</code>, <code>t-SNE</code>, or <code>UMAP</code> for nonlinear data.</p>
                </div>
                <div class="pca-try-item">
                    <h4>SVD instead of eig</h4>
                    <p>Replace <code>np.linalg.eig(C)</code> with <code>np.linalg.svd(X_std, full_matrices=False)</code>. SVD is more numerically stable for nearly-singular covariance matrices &mdash; it&rsquo;s what <code>sklearn.decomposition.PCA</code> uses under the hood.</p>
                </div>
                <div class="pca-try-item">
                    <h4>Scale matters</h4>
                    <p>In <code>standardize()</code>, replace <code>/ X.std(axis=0)</code> with just centering (subtract mean only). On the anisotropic dataset, watch how the PCs change &mdash; PCA without scaling is at the mercy of feature units.</p>
                </div>
                <div class="pca-try-item">
                    <h4>Reconstruction error</h4>
                    <p>Add <code>reconstructed = projected @ eig_vecs[:, :dims].T</code> in your code and print <code>np.linalg.norm(X_std - reconstructed)</code>. That&rsquo;s the information you discarded. Compare at dims = 1, 2, 3 across datasets.</p>
                </div>
            </div>
        </div>

        <!-- Watch out / In practice chip strips -->
        <div class="ms-card">
            <h2 style="font:500 1.25rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 1rem;letter-spacing:-0.015em;">In one glance</h2>
            <div class="pca-strip is-watchout">
                <span class="pca-strip-label">&#9888;&#65039; Watch out</span>
                <span class="pca-tag">Skip standardization</span>
                <span class="pca-tag">Isotropic variance</span>
                <span class="pca-tag">Nonlinear structure</span>
                <span class="pca-tag">Use eigvecs for non-PCA model</span>
                <span class="pca-tag">No scree plot &rarr; arbitrary k</span>
            </div>
            <div class="pca-strip is-practice">
                <span class="pca-strip-label">&#128295; In practice</span>
                <span class="pca-tag">sklearn.decomposition.PCA</span>
                <span class="pca-tag">StandardScaler</span>
                <span class="pca-tag">np.linalg.svd</span>
                <span class="pca-tag">explained_variance_ratio_</span>
                <span class="pca-tag">n_components=0.95</span>
            </div>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="PCA FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is PCA used for?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Three things: (1) <strong>dimensionality reduction</strong> &mdash; compress N-feature data to $k$ features that retain most variance; (2) <strong>visualization</strong> &mdash; projecting high-dimensional data to 2D or 3D for plotting; (3) <strong>decorrelation</strong> &mdash; the principal components are orthogonal, useful as inputs to downstream models that assume independent features.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        When does PCA fail?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">When variance is <strong>isotropic</strong> (a sphere has no preferred direction) or when the structure is <strong>nonlinear</strong> (a swiss roll&rsquo;s underlying 2D manifold gets flattened by linear projection). Try the <code>sphere</code> and <code>swissRoll</code> datasets &mdash; PCA flatlines on the first and loses the structure on the second.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Should I standardize before PCA?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Almost always yes. PCA is sensitive to feature scale &mdash; a column ranging 0&ndash;10000 will dominate PC1 over a column ranging 0&ndash;1 even if both carry similar information. Subtract the mean and divide by the std (z-score) before fitting.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        PCA vs t-SNE vs UMAP?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">PCA is <strong>linear, fast, interpretable</strong>, and good for global structure + decorrelation. <strong>t-SNE</strong> and <strong>UMAP</strong> are nonlinear, slower, and better at preserving local neighborhoods &mdash; but they distort global distances and shouldn&rsquo;t be used for downstream modeling. Use PCA when you want a meaningful feature space; use t-SNE/UMAP only for visualization.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        How do I pick the number of components?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Two heuristics: (1) plot the <strong>cumulative explained variance</strong> and pick the smallest $k$ that gets you above your threshold (e.g., 95%); (2) look for an <strong>elbow</strong> in the scree plot &mdash; a sharp drop in eigenvalues followed by a plateau. In sklearn, <code>PCA(n_components=0.95)</code> picks the smallest $k$ retaining 95% variance for you.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/pca.js?v=<%=v%>" defer></script>
</body>
</html>
