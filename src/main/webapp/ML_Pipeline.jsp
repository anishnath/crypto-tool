<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<% String v = String.valueOf(System.currentTimeMillis()); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="modern/components/seo-tool-page.jsp">
        <jsp:param name="toolName" value="ML Pipeline Simulator — End-to-End Lifecycle Walkthrough" />
        <jsp:param name="toolCategory" value="Machine Learning" />
        <jsp:param name="toolDescription" value="Step through the full ML pipeline in one page: pick a dataset, explore it, preprocess it, train three models in real time, evaluate them, and deploy the best one for live predictions. Browser-only, no signup." />
        <jsp:param name="toolUrl" value="ML_Pipeline.jsp" />
        <jsp:param name="toolImage" value="ml-pipeline-og.png" />
        <jsp:param name="toolKeywords" value="ml pipeline simulator, machine learning lifecycle, end to end ml, data preprocessing, train test split, model evaluation, model deployment demo, ml from scratch, iris wine heart dataset, logistic regression knn decision tree" />
        <jsp:param name="toolFeatures" value="Six-step wizard from dataset to deployment,Three synthetic datasets: Iris/Wine/Heart,Live training animation across three models,Train/test split with stratification,Feature normalization,Model comparison + feature importance,Live prediction demo,Dark mode" />
        <jsp:param name="hasSteps" value="true" />
        <jsp:param name="howToSteps" value="Pick a dataset|Choose Iris Wine or Heart — each is a small synthetic classification problem with different feature counts and class balances,Preprocess|Normalize features and split into train/test with the slider — see how the split affects training and test sample counts,Train + evaluate|Click Start Training to watch logistic regression KNN and decision tree fit in real time then compare their test accuracies side by side" />
        <jsp:param name="faq1q" value="What does an ML pipeline include?" />
        <jsp:param name="faq1a" value="The canonical stages are: data acquisition, exploratory data analysis (EDA), preprocessing (cleaning, encoding, scaling, splitting), model training, model evaluation, and deployment. This page walks one synthetic example through all six in order — same shape as a real production ML workflow, just compressed and with toy data." />
        <jsp:param name="faq2q" value="Why split into train and test sets?" />
        <jsp:param name="faq2a" value="To estimate how the model will perform on unseen data. Evaluating on the same examples you trained on is meaningless — the model can just memorize them. A held-out test set gives an unbiased estimate of generalization. 80/20 is a common default; smaller datasets sometimes use cross-validation for more robust estimates." />
        <jsp:param name="faq3q" value="Why does normalization matter?" />
        <jsp:param name="faq3a" value="Many algorithms (logistic regression, KNN, neural networks) are sensitive to feature scale. If one feature ranges 0–10000 and another 0–1, the larger one will dominate the loss gradient or distance metric. Min-max scaling to [0, 1] (or z-score scaling to mean 0 / std 1) puts every feature on equal footing." />
        <jsp:param name="faq4q" value="What is feature importance?" />
        <jsp:param name="faq4a" value="A score showing how much each feature contributed to the model's predictions. For logistic regression we use the absolute value of the learned weight — features with bigger weights move the prediction more. Tree models compute it from information-gain reductions. Use it to spot which inputs actually matter and which you could drop." />
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
    <link rel="stylesheet" href="<%=request.getContextPath()%>/ml/css/ml-pipeline.css?v=<%=v%>">

    <%-- Chart.js for the five charts (bar, doughnut, line, bar, radar). --%>
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

    <% request.setAttribute("activeService", "ml-pipeline"); %>
    <jsp:include page="/ml/partials/sidebar.jsp" />

    <section class="ms-workspace">

        <!-- Header -->
        <div class="ms-card">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:1rem;flex-wrap:wrap;">
                <div>
                    <h1 style="font:400 2rem/1.1 var(--ms-font-serif);margin:0 0 0.25rem;letter-spacing:-0.02em;">
                        ML Pipeline, <em style="font-style:italic;color:#4f46e5;">end to end</em>
                    </h1>
                    <nav style="font:0.82rem var(--ms-font-mono);color:var(--ms-muted);">
                        <a href="<%=request.getContextPath()%>/" style="color:inherit;">Home</a>
                        &middot;
                        <a href="<%=request.getContextPath()%>/ml/" style="color:inherit;">ML</a>
                        &middot; ML Pipeline
                    </nav>
                </div>
                <span style="font:500 0.72rem var(--ms-font-mono);color:#4f46e5;padding:0.3rem 0.7rem;border-radius:var(--ms-radius-pill);background:rgba(79,70,229,0.10);">Lifecycle walkthrough</span>
            </div>
            <p style="margin:1rem 0 0;color:var(--ms-ink-soft);font:0.95rem/1.55 var(--ms-font-sans);max-width:70ch;">
                A real ML project moves through six stages: <strong>dataset &rarr; EDA &rarr; preprocess &rarr; train &rarr; evaluate &rarr; deploy</strong>. This page walks one synthetic example through all six. Pick a dataset on Step 1, click through, watch three models train head-to-head, and end up at a tiny live-prediction demo. Everything runs in your browser.
            </p>
        </div>

        <!-- The lifecycle — visual cycle diagram (intro lives here implicitly) -->
        <div class="ms-card mp-lifecycle">
            <h3 class="mp-lifecycle-title">The lifecycle is a <em>cycle</em>, not a line</h3>
            <p class="mp-lifecycle-desc">Deployment is not the end. In production, you monitor inputs and predictions, detect drift, and feed insights back into preprocessing or retraining. Models decay; pipelines loop.</p>
            <svg class="mp-lifecycle-svg" viewBox="0 0 880 200" xmlns="http://www.w3.org/2000/svg" aria-label="ML lifecycle diagram">
                <defs>
                    <marker id="mp-arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
                        <path d="M 0 0 L 10 5 L 0 10 z" fill="#78716c"></path>
                    </marker>
                </defs>
                <!-- 6 stage circles, evenly spaced -->
                <g font-family="JetBrains Mono, monospace" font-size="11" text-anchor="middle">
                    <g><circle cx="70"  cy="85" r="34" fill="rgba(79, 70, 229, 0.12)" stroke="#4f46e5" stroke-width="2"></circle><text x="70"  y="80" fill="#4f46e5">Dataset</text><text x="70"  y="96" fill="#78716c" font-size="9">step 1</text></g>
                    <g><circle cx="200" cy="85" r="34" fill="rgba(20, 184, 166, 0.12)" stroke="#14b8a6" stroke-width="2"></circle><text x="200" y="80" fill="#14b8a6">EDA</text><text x="200" y="96" fill="#78716c" font-size="9">step 2</text></g>
                    <g><circle cx="330" cy="85" r="34" fill="rgba(245, 158, 11, 0.12)" stroke="#f59e0b" stroke-width="2"></circle><text x="330" y="80" fill="#b45309">Prep</text><text x="330" y="96" fill="#78716c" font-size="9">step 3</text></g>
                    <g><circle cx="460" cy="85" r="34" fill="rgba(139, 92, 246, 0.12)" stroke="#8b5cf6" stroke-width="2"></circle><text x="460" y="80" fill="#8b5cf6">Train</text><text x="460" y="96" fill="#78716c" font-size="9">step 4</text></g>
                    <g><circle cx="590" cy="85" r="34" fill="rgba(236, 72, 153, 0.12)" stroke="#ec4899" stroke-width="2"></circle><text x="590" y="80" fill="#ec4899">Eval</text><text x="590" y="96" fill="#78716c" font-size="9">step 5</text></g>
                    <g><circle cx="720" cy="85" r="34" fill="rgba(34, 197, 94, 0.12)" stroke="#22c55e" stroke-width="2"></circle><text x="720" y="80" fill="#15803d">Deploy</text><text x="720" y="96" fill="#78716c" font-size="9">step 6</text></g>
                    <g><circle cx="820" cy="85" r="34" fill="rgba(120, 113, 108, 0.10)" stroke="#78716c" stroke-width="2" stroke-dasharray="3,3"></circle><text x="820" y="83" fill="#44403c">Monitor</text><text x="820" y="96" fill="#78716c" font-size="9">drift</text></g>
                </g>
                <!-- Forward arrows -->
                <g stroke="#78716c" stroke-width="1.5" fill="none" marker-end="url(#mp-arrow)">
                    <line x1="104" y1="85" x2="166" y2="85"></line>
                    <line x1="234" y1="85" x2="296" y2="85"></line>
                    <line x1="364" y1="85" x2="426" y2="85"></line>
                    <line x1="494" y1="85" x2="556" y2="85"></line>
                    <line x1="624" y1="85" x2="686" y2="85"></line>
                    <line x1="754" y1="85" x2="786" y2="85"></line>
                </g>
                <!-- Feedback loop: Monitor → Dataset (curve along the top) -->
                <g stroke="#f59e0b" stroke-width="1.5" stroke-dasharray="4,4" fill="none" marker-end="url(#mp-arrow)">
                    <path d="M 820 51 Q 820 10 445 10 Q 70 10 70 51"></path>
                </g>
                <text x="445" y="6" font-family="JetBrains Mono, monospace" font-size="10" fill="#b45309" text-anchor="middle">retrain on drift · new labels · new data</text>
                <!-- Annotations under steps -->
                <g font-family="Inter, system-ui, sans-serif" font-size="10" fill="#78716c" text-anchor="middle">
                    <text x="70"  y="145">source · label · version</text>
                    <text x="200" y="145">describe · plot · sanity-check</text>
                    <text x="330" y="145">clean · scale · split</text>
                    <text x="460" y="145">fit parameters · validate</text>
                    <text x="590" y="145">metric on test set</text>
                    <text x="720" y="145">serve predictions</text>
                </g>
            </svg>
        </div>

        <!-- Step indicator — bigger circles with stage icons -->
        <div class="ms-card">
            <ol class="mp-steps" id="mpSteps">
                <li class="mp-step is-active" data-step="1" data-color="indigo"><span class="mp-step-num"><span class="mp-step-icon">&#128202;</span></span><span class="mp-step-label">Dataset</span></li>
                <li class="mp-step"           data-step="2" data-color="teal"  ><span class="mp-step-num"><span class="mp-step-icon">&#128269;</span></span><span class="mp-step-label">EDA</span></li>
                <li class="mp-step"           data-step="3" data-color="amber" ><span class="mp-step-num"><span class="mp-step-icon">&#9881;&#65039;</span></span><span class="mp-step-label">Preprocess</span></li>
                <li class="mp-step"           data-step="4" data-color="violet"><span class="mp-step-num"><span class="mp-step-icon">&#127891;</span></span><span class="mp-step-label">Train</span></li>
                <li class="mp-step"           data-step="5" data-color="pink"  ><span class="mp-step-num"><span class="mp-step-icon">&#128200;</span></span><span class="mp-step-label">Evaluate</span></li>
                <li class="mp-step"           data-step="6" data-color="green" ><span class="mp-step-num"><span class="mp-step-icon">&#128640;</span></span><span class="mp-step-label">Deploy</span></li>
            </ol>
        </div>

        <!-- ── Step 1 · Dataset selection ────────────────────── -->
        <div class="ms-card mp-step-content is-visible" id="mpStepContent1" data-color="indigo">
            <div class="mp-hero">
                <span class="mp-eyebrow">Step 01 &middot; of 06</span>
                <h2>Pick a <em>dataset</em></h2>
                <p class="mp-tagline">Every pipeline starts with a question &mdash; and the dataset that might answer it.</p>
            </div>

            <p class="mp-def-line">
                A dataset is <strong>rows (samples) &times; columns (features + target)</strong>. It constrains every downstream choice &mdash; feature space, model family, evaluation metric, even feasibility.
            </p>

            <div class="mp-dataset-grid">
                <div class="mp-dataset-card" data-dataset="iris">
                    <div class="mp-dataset-emoji">&#127802;</div>
                    <h3 class="mp-dataset-title">Iris Flowers</h3>
                    <p class="mp-dataset-desc">150 samples &middot; 4 features &middot; 3 classes</p>
                </div>
                <div class="mp-dataset-card" data-dataset="wine">
                    <div class="mp-dataset-emoji">&#127863;</div>
                    <h3 class="mp-dataset-title">Wine Quality</h3>
                    <p class="mp-dataset-desc">200 samples &middot; 6 features &middot; binary</p>
                </div>
                <div class="mp-dataset-card" data-dataset="health">
                    <div class="mp-dataset-emoji">&#10084;&#65039;</div>
                    <h3 class="mp-dataset-title">Heart Disease</h3>
                    <p class="mp-dataset-desc">180 samples &middot; 5 features &middot; binary</p>
                </div>
            </div>

            <div class="mp-strip is-watchout">
                <span class="mp-strip-label">&#9888;&#65039; Watch out</span>
                <span class="mp-tag">Available &ne; appropriate</span>
                <span class="mp-tag">Too few samples / class</span>
                <span class="mp-tag">No data versioning</span>
                <span class="mp-tag">Benchmark &ne; production</span>
            </div>
            <div class="mp-strip is-practice">
                <span class="mp-strip-label">&#128295; In practice</span>
                <span class="mp-tag">DVC</span>
                <span class="mp-tag">Feast</span>
                <span class="mp-tag">Tecton</span>
                <span class="mp-tag">data registry</span>
            </div>

            <div class="mp-step-nav">
                <span></span>
                <button type="button" class="mp-btn is-primary" id="mpBtnLoadDataset" disabled>Load Dataset &rarr;</button>
            </div>
        </div>

        <!-- ── Step 2 · EDA ──────────────────────────────────── -->
        <div class="ms-card mp-step-content" id="mpStepContent2" data-color="teal">
            <div class="mp-hero">
                <span class="mp-eyebrow">Step 02 &middot; of 06</span>
                <h2>Explore the <em>data</em></h2>
                <p class="mp-tagline">Sense-make before you model. Tukey wrote a whole book on this in 1977 for a reason.</p>
            </div>

            <p class="mp-def-line">
                <strong>EDA</strong> = looking at the data before modeling &mdash; stats, distributions, class balance, missing values. Bad EDA &rarr; bad model, and you won&rsquo;t catch it from a test-accuracy number alone.
            </p>

            <div class="mp-stat-grid">
                <div class="mp-stat-card"><div class="mp-stat-label">Samples</div><div class="mp-stat-value" id="mpStatSamples">—</div><span class="mp-stat-suffix">rows in the table</span></div>
                <div class="mp-stat-card"><div class="mp-stat-label">Features</div><div class="mp-stat-value" id="mpStatFeatures">—</div><span class="mp-stat-suffix">input columns</span></div>
                <div class="mp-stat-card"><div class="mp-stat-label">Classes</div><div class="mp-stat-value" id="mpStatClasses">—</div><span class="mp-stat-suffix">target categories</span></div>
                <div class="mp-stat-card"><div class="mp-stat-label">Missing</div><div class="mp-stat-value">0</div><span class="mp-stat-suffix">synthetic &mdash; no gaps</span></div>
            </div>

            <div class="mp-chart-grid">
                <div>
                    <div class="mp-chart-label">Feature distributions (means)</div>
                    <div class="mp-chart-wrap"><canvas id="mpChartDist"></canvas></div>
                </div>
                <div>
                    <div class="mp-chart-label">Class distribution</div>
                    <div class="mp-chart-wrap"><canvas id="mpChartClass"></canvas></div>
                </div>
            </div>

            <div class="mp-strip is-watchout">
                <span class="mp-strip-label">&#9888;&#65039; Watch out</span>
                <span class="mp-tag">Skip EDA &rarr; fit()</span>
                <span class="mp-tag">Ignore class balance</span>
                <span class="mp-tag">Trust column names</span>
                <span class="mp-tag">Outliers = typos</span>
            </div>
            <div class="mp-strip is-practice">
                <span class="mp-strip-label">&#128295; In practice</span>
                <span class="mp-tag">pandas.describe()</span>
                <span class="mp-tag">seaborn.pairplot</span>
                <span class="mp-tag">pandas-profiling</span>
                <span class="mp-tag">plot target first</span>
            </div>

            <div class="mp-step-nav">
                <button type="button" class="mp-btn" data-go-step="1">&larr; Back</button>
                <button type="button" class="mp-btn is-primary" data-go-step="3">Next &rarr;</button>
            </div>
        </div>

        <!-- ── Step 3 · Preprocessing ────────────────────────── -->
        <div class="ms-card mp-step-content" id="mpStepContent3" data-color="amber">
            <div class="mp-hero">
                <span class="mp-eyebrow">Step 03 &middot; of 06</span>
                <h2>Prepare the <em>data</em></h2>
                <p class="mp-tagline">Scale, split, encode. Do it in the right order &mdash; or you&rsquo;ll leak the test set.</p>
            </div>

            <p class="mp-def-line">
                Scale numerics, encode categoricals, impute missing values, <strong>split before fitting transforms</strong> &mdash; otherwise you leak the test set into training. This is the single most common pipeline bug.
            </p>

            <div class="mp-pre-grid">
                <div>
                    <label class="mp-checkbox"><input type="checkbox" id="mpOptNormalize" checked> Normalize features (min-max to [0, 1])</label>
                    <label class="mp-checkbox"><input type="checkbox" id="mpOptStratify" checked> Stratified split (preserve class ratios)</label>

                    <div class="mp-range-label">
                        <span>Train / Test split</span>
                        <strong id="mpSplitLabel">80/20</strong>
                    </div>
                    <input type="range" id="mpSplitRatio" class="mp-range" min="60" max="90" value="80">
                </div>
                <div class="mp-summary">
                    <h4>Split summary</h4>
                    <p>Training samples: <strong id="mpTrainSamples">—</strong></p>
                    <p>Test samples: <strong id="mpTestSamples">—</strong></p>
                    <p style="margin-top:0.6rem;font:italic 0.8rem var(--ms-font-sans);color:var(--ms-muted);">
                        Rule of thumb: 80/20 for medium datasets. For small data, use k-fold cross-validation.
                    </p>
                </div>
            </div>

            <div class="mp-strip is-watchout">
                <span class="mp-strip-label">&#9888;&#65039; Watch out</span>
                <span class="mp-tag">Test-set leakage</span>
                <span class="mp-tag">Drop NaN blindly</span>
                <span class="mp-tag">High-card one-hot</span>
                <span class="mp-tag">No inference-time transforms</span>
                <span class="mp-tag">Unstratified imbalanced split</span>
            </div>
            <div class="mp-strip is-practice">
                <span class="mp-strip-label">&#128295; In practice</span>
                <span class="mp-tag">sklearn.Pipeline</span>
                <span class="mp-tag">ColumnTransformer</span>
                <span class="mp-tag">StratifiedKFold</span>
                <span class="mp-tag">SimpleImputer</span>
            </div>

            <div class="mp-step-nav">
                <button type="button" class="mp-btn" data-go-step="2">&larr; Back</button>
                <button type="button" class="mp-btn is-primary" id="mpBtnPreprocess">Apply &amp; Continue &rarr;</button>
            </div>
        </div>

        <!-- ── Step 4 · Training ─────────────────────────────── -->
        <div class="ms-card mp-step-content" id="mpStepContent4" data-color="violet">
            <div class="mp-hero">
                <span class="mp-eyebrow">Step 04 &middot; of 06</span>
                <h2>Train the <em>models</em></h2>
                <p class="mp-tagline">Fit parameters that minimize loss. Then check whether you&rsquo;ve overfit.</p>
            </div>

            <p class="mp-def-line">
                Training fits <strong>parameters</strong> (weights, splits) by minimizing a <strong>loss</strong>. You set <strong>hyperparameters</strong> (lr, depth, regularization); training finds the rest. We run three baselines &mdash; different model families, different assumptions.
            </p>

            <div class="mp-train-grid">
                <div>
                    <div class="mp-chart-label">Training progress</div>
                    <div class="mp-chart-wrap" style="height:320px;"><canvas id="mpChartTraining"></canvas></div>
                </div>
                <div class="mp-models">
                    <div class="mp-model-card" id="mpModelLog">
                        <div class="mp-model-head">
                            <span class="mp-model-name">Logistic Regression</span>
                            <span class="mp-model-acc" id="mpAccLog">—</span>
                        </div>
                        <div class="mp-progress"><div class="mp-progress-bar" id="mpProgLog"></div></div>
                    </div>
                    <div class="mp-model-card" id="mpModelKNN">
                        <div class="mp-model-head">
                            <span class="mp-model-name">K-Nearest Neighbors</span>
                            <span class="mp-model-acc" id="mpAccKNN">—</span>
                        </div>
                        <div class="mp-progress"><div class="mp-progress-bar" id="mpProgKNN"></div></div>
                    </div>
                    <div class="mp-model-card" id="mpModelTree">
                        <div class="mp-model-head">
                            <span class="mp-model-name">Decision Tree</span>
                            <span class="mp-model-acc" id="mpAccTree">—</span>
                        </div>
                        <div class="mp-progress"><div class="mp-progress-bar" id="mpProgTree"></div></div>
                    </div>
                    <button type="button" class="mp-btn is-success" id="mpBtnTrain" style="margin-top:0.5rem;">
                        <span aria-hidden="true">&#9656;</span> Start Training
                    </button>
                </div>
            </div>

            <div class="mp-strip is-watchout">
                <span class="mp-strip-label">&#9888;&#65039; Watch out</span>
                <span class="mp-tag">Mix params/hyperparams</span>
                <span class="mp-tag">No random_state</span>
                <span class="mp-tag">Skip baseline</span>
                <span class="mp-tag">Silent overfit</span>
                <span class="mp-tag">No learning curves</span>
            </div>
            <div class="mp-strip is-practice">
                <span class="mp-strip-label">&#128295; In practice</span>
                <span class="mp-tag">GridSearchCV</span>
                <span class="mp-tag">Optuna</span>
                <span class="mp-tag">early_stopping</span>
                <span class="mp-tag">class_weight</span>
                <span class="mp-tag">cross_val_score</span>
            </div>

            <div class="mp-step-nav">
                <button type="button" class="mp-btn" data-go-step="3">&larr; Back</button>
                <button type="button" class="mp-btn is-primary" id="mpBtnToEval" data-go-step="5" disabled>Evaluate &rarr;</button>
            </div>
        </div>

        <!-- ── Step 5 · Evaluation ───────────────────────────── -->
        <div class="ms-card mp-step-content" id="mpStepContent5" data-color="pink">
            <div class="mp-hero">
                <span class="mp-eyebrow">Step 05 &middot; of 06</span>
                <h2>Evaluate <em>honestly</em></h2>
                <p class="mp-tagline">Accuracy is the wrong metric most of the time. Pick one that matches your problem.</p>
            </div>

            <p class="mp-def-line">
                Pick metrics that <strong>match your problem</strong>: accuracy for balanced, F1 for imbalanced, AUC for ranking, RMSE for regression. Always against a baseline &mdash; 95% accuracy on a 95/5 split is the majority-class trivial model.
            </p>

            <div class="mp-chart-grid">
                <div>
                    <div class="mp-chart-label">Model comparison · test accuracy</div>
                    <div class="mp-chart-wrap"><canvas id="mpChartComp"></canvas></div>
                </div>
                <div>
                    <div class="mp-chart-label">Feature importance (logistic |w|)</div>
                    <div class="mp-chart-wrap" style="overflow:auto;height:280px;padding:1rem;"><div id="mpFeatImport"></div></div>
                </div>
            </div>
            <div class="mp-best-alert">
                <div class="mp-best-alert-body">
                    <span class="mp-best-alert-label">Winner</span>
                    <span class="mp-best-alert-model" id="mpBestModel">—</span>
                </div>
            </div>

            <div class="mp-strip is-watchout">
                <span class="mp-strip-label">&#9888;&#65039; Watch out</span>
                <span class="mp-tag">Accuracy on imbalanced</span>
                <span class="mp-tag">Single metric</span>
                <span class="mp-tag">No baseline</span>
                <span class="mp-tag">Cherry-pick seed</span>
                <span class="mp-tag">No CI</span>
            </div>
            <div class="mp-strip is-practice">
                <span class="mp-strip-label">&#128295; In practice</span>
                <span class="mp-tag">classification_report</span>
                <span class="mp-tag">confusion_matrix</span>
                <span class="mp-tag">roc_auc_score</span>
                <span class="mp-tag">cross_val_score</span>
            </div>

            <div class="mp-step-nav">
                <button type="button" class="mp-btn" data-go-step="4">&larr; Back</button>
                <button type="button" class="mp-btn is-primary" data-go-step="6">Deploy &rarr;</button>
            </div>
        </div>

        <!-- ── Step 6 · Deployment ───────────────────────────── -->
        <div class="ms-card mp-step-content" id="mpStepContent6" data-color="green">
            <div class="mp-hero">
                <span class="mp-eyebrow">Step 06 &middot; of 06</span>
                <h2>Deploy &mdash; and <em>keep watching</em></h2>
                <p class="mp-tagline">Shipping is when ML starts, not when it ends. Models drift; data shifts; performance decays.</p>
            </div>

            <p class="mp-def-line">
                Deployment is the start of the loop, not the end. Serve predictions, <strong>monitor inputs and outputs</strong>, detect drift, retrain. Models decay; pipelines loop.
            </p>

            <div class="mp-deploy-grid">
                <div>
                    <h4 style="font:600 0.95rem var(--ms-font-sans);margin:0 0 0.6rem;color:var(--ms-ink);">Make a prediction</h4>
                    <div id="mpPredInputs"></div>
                    <button type="button" class="mp-btn is-primary" id="mpBtnPredict" style="width:100%;margin-top:0.5rem;">Predict</button>
                    <div class="mp-pred-result" id="mpPredResult">
                        Predicted class: <strong id="mpPredClass">—</strong><br>
                        Confidence: <strong><span id="mpPredConf">—</span>%</strong>
                    </div>
                </div>
                <div>
                    <div class="mp-chart-label">Model summary metrics</div>
                    <div class="mp-chart-wrap"><canvas id="mpChartDeploy"></canvas></div>
                </div>
            </div>
            <div class="mp-strip is-watchout">
                <span class="mp-strip-label">&#9888;&#65039; Watch out</span>
                <span class="mp-tag">No monitoring</span>
                <span class="mp-tag">No shadow period</span>
                <span class="mp-tag">No rollback plan</span>
                <span class="mp-tag">Model as static artifact</span>
            </div>
            <div class="mp-strip is-practice">
                <span class="mp-strip-label">&#128295; In practice</span>
                <span class="mp-tag">MLflow</span>
                <span class="mp-tag">BentoML</span>
                <span class="mp-tag">SageMaker</span>
                <span class="mp-tag">Evidently</span>
                <span class="mp-tag">Arize</span>
            </div>

            <div class="mp-step-nav">
                <button type="button" class="mp-btn" data-go-step="5">&larr; Back</button>
                <button type="button" class="mp-btn is-primary" data-go-step="1">Start New Pipeline</button>
            </div>
        </div>

        <!-- Beyond this demo · reality check (compact) -->
        <div class="ms-card">
            <h2 style="font:500 1.15rem var(--ms-font-serif);color:var(--ms-ink);margin:0 0 0.85rem;letter-spacing:-0.015em;">
                Beyond this demo
            </h2>
            <div class="mp-reality-grid">
                <div class="mp-reality-card">
                    <h4>Toy &rarr; real data</h4>
                    <p>Real data is messy &mdash; missing values, label noise, leakage, multi-modal. Try Kaggle or <code>fetch_openml</code>.</p>
                </div>
                <div class="mp-reality-card">
                    <h4>Hand-rolled &rarr; sklearn</h4>
                    <p>Production uses <code>sklearn</code>, <code>xgboost</code>, <code>lightgbm</code>, <code>pytorch</code> &mdash; built for edge cases and scale.</p>
                </div>
                <div class="mp-reality-card">
                    <h4>One split &rarr; k-fold CV</h4>
                    <p>Real evaluation = k=5/10 folds + separate validation set for tuning + multiple seeds for variance.</p>
                </div>
                <div class="mp-reality-card">
                    <h4>Form &rarr; production</h4>
                    <p>Registries, CI/CD, A/B tests, shadow modes, drift detectors, retraining triggers, rollback playbooks.</p>
                </div>
            </div>
        </div>

        <!-- Glossary — collapsed by default, click to expand -->
        <details class="ms-card mp-collapse">
            <summary>ML Pipeline Glossary &mdash; 20 terms</summary>
            <div class="mp-collapse-body">
            <dl class="mp-glossary">
                <div class="mp-term"><dt>Feature</dt><dd>An input column. Numeric, categorical, or derived (engineered) from raw signals.</dd></div>
                <div class="mp-term"><dt>Target / label</dt><dd>The output column you&rsquo;re trying to predict. Sometimes called <em>y</em>.</dd></div>
                <div class="mp-term"><dt>Sample / example</dt><dd>One row of the dataset &mdash; a feature vector and (in supervised learning) its label.</dd></div>
                <div class="mp-term"><dt>Parameter</dt><dd>A value the model learns during training (e.g., a weight in linear regression).</dd></div>
                <div class="mp-term"><dt>Hyperparameter</dt><dd>A value <em>you</em> set before training (e.g., learning rate, k in KNN, tree depth).</dd></div>
                <div class="mp-term"><dt>Loss function</dt><dd>A scalar that measures how wrong the model is. Training minimizes it.</dd></div>
                <div class="mp-term"><dt>Gradient descent</dt><dd>Standard optimizer: take steps opposite to the gradient of the loss to lower it.</dd></div>
                <div class="mp-term"><dt>Overfitting</dt><dd>The model memorized the training set, so test accuracy is much worse than train.</dd></div>
                <div class="mp-term"><dt>Underfitting</dt><dd>The model is too simple to capture the pattern &mdash; high error everywhere.</dd></div>
                <div class="mp-term"><dt>Bias-variance tradeoff</dt><dd>Simple models have high bias / low variance; complex models, the opposite.</dd></div>
                <div class="mp-term"><dt>Regularization</dt><dd>A penalty added to the loss to keep parameters small (L1, L2, dropout).</dd></div>
                <div class="mp-term"><dt>Cross-validation (k-fold)</dt><dd>Split the data into k chunks; train on k-1, test on the rest; rotate; average.</dd></div>
                <div class="mp-term"><dt>Stratified sampling</dt><dd>Split that preserves class ratios &mdash; essential for imbalanced data.</dd></div>
                <div class="mp-term"><dt>Class imbalance</dt><dd>One class dominates (e.g., 95/5). Accuracy becomes a useless metric.</dd></div>
                <div class="mp-term"><dt>Data leakage</dt><dd>Test-set information bleeds into training. Inflates reported accuracy; ruins production.</dd></div>
                <div class="mp-term"><dt>Inference</dt><dd>Running the trained model on new data to produce predictions.</dd></div>
                <div class="mp-term"><dt>Pipeline (sklearn)</dt><dd>An object that chains preprocessing and a final estimator with safe fit/transform.</dd></div>
                <div class="mp-term"><dt>Feature engineering</dt><dd>Hand-crafting new features (ratios, log transforms, interactions) from existing ones.</dd></div>
                <div class="mp-term"><dt>Drift</dt><dd>Input distribution (data drift) or input&ndash;output relationship (concept drift) shifts after deployment.</dd></div>
                <div class="mp-term"><dt>Baseline</dt><dd>A trivially simple model (majority class, mean, linear). Beat it before claiming you have an ML model.</dd></div>
            </dl>
            </div>
        </details>

        <div class="ms-inline-ad">
            <%@ include file="modern/ads/ad-in-content-mid.jsp" %>
        </div>

        <!-- FAQ -->
        <section class="ms-faq-wrap" style="max-width:100%;margin-top:0;padding:0;">
            <h2 class="ms-faq-title" id="faqs">Frequently asked</h2>
            <div class="ms-faq" aria-label="ML Pipeline FAQ">
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What does an ML pipeline include?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">The canonical stages are: <strong>data acquisition</strong>, <strong>exploratory data analysis (EDA)</strong>, <strong>preprocessing</strong> (cleaning, encoding, scaling, splitting), <strong>model training</strong>, <strong>evaluation</strong>, and <strong>deployment</strong>. This page walks one synthetic example through all six in order &mdash; same shape as a real production ML workflow, just compressed and with toy data.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why split into train and test sets?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">To estimate how the model will perform on <em>unseen</em> data. Evaluating on the same examples you trained on is meaningless &mdash; the model can just memorize them. A held-out test set gives an unbiased estimate of generalization. 80/20 is a common default; smaller datasets sometimes use cross-validation for more robust estimates.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        Why does normalization matter?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">Many algorithms (logistic regression, KNN, neural networks) are sensitive to feature scale. If one feature ranges 0&ndash;10000 and another 0&ndash;1, the larger one will dominate the loss gradient or distance metric. Min-max scaling to <code>[0, 1]</code> (or z-score scaling to mean 0 / std 1) puts every feature on equal footing.</div>
                </div>
                <div class="ms-faq-item">
                    <button class="ms-faq-q" type="button">
                        What is feature importance?
                        <svg class="ms-faq-chevron" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"></polyline></svg>
                    </button>
                    <div class="ms-faq-a">A score showing how much each feature contributed to the model&rsquo;s predictions. For logistic regression we use the absolute value of the learned weight &mdash; features with bigger weights move the prediction more. Tree models compute it from information-gain reductions. Use it to spot which inputs actually matter and which you could drop.</div>
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
<script src="<%=request.getContextPath()%>/ml/js/ml-pipeline.js?v=<%=v%>" defer></script>
</body>
</html>
