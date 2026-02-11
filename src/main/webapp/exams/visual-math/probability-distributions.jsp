<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Probability Distributions - Binomial, Poisson, Geometric, Uniform (Free)";
    String seoDescription = "Interactive probability distribution visualizer. Explore binomial, Poisson, geometric, and uniform distributions. Adjust parameters and see PMF, mean, variance, and standard deviation update in real time.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/probability-distributions.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Probability Distributions - Binomial, Poisson, Geometric, Uniform\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Probability Distributions Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"probability distribution, binomial distribution, poisson distribution, geometric distribution, PMF, mean variance, discrete probability\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Probability Distributions</span>
    </nav>

    <div class="viz-header">
        <h1>Probability Distributions Visualizer</h1>
        <p class="viz-subtitle">Explore binomial, Poisson, geometric, and uniform distributions. Adjust parameters and see the probability mass function, mean, and variance update instantly.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Distribution Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="binomial">Binomial</button>
                        <button class="vm-chip" data-preset="poisson">Poisson</button>
                        <button class="vm-chip" data-preset="geometric">Geometric</button>
                        <button class="vm-chip" data-preset="uniform">Uniform</button>
                        <button class="vm-chip" data-preset="rare">Rare Events</button>
                    </div>
                </div>

                <div class="control-group" id="n-group">
                    <label>Trials n = <span id="n-display">10</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="1" max="30" value="10" step="1">
                        <span class="viz-slider-val" id="n-val">10</span>
                    </div>
                </div>

                <div class="control-group" id="p-group">
                    <label>Probability p = <span id="p-display">0.50</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="p-slider" min="0.01" max="0.99" value="0.5" step="0.01">
                        <span class="viz-slider-val" id="p-val">0.50</span>
                    </div>
                </div>

                <div class="control-group" id="lambda-group" style="display:none;">
                    <label>Rate &lambda; = <span id="lambda-display">3.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="lambda-slider" min="0.1" max="15" value="3" step="0.1">
                        <span class="viz-slider-val" id="lambda-val">3.0</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Distribution</td><td id="val-dist">--</td></tr>
                    <tr><td>PMF</td><td id="val-pmf">--</td></tr>
                    <tr><td>Parameters</td><td id="val-params">--</td></tr>
                    <tr><td>Mean</td><td id="val-mean">--</td></tr>
                    <tr><td>Variance</td><td id="val-variance">--</td></tr>
                    <tr><td>Std Dev</td><td id="val-std">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Discrete Distributions</h3>
                <ul>
                    <li><strong>Binomial</strong>: <span class="formula-highlight">P(X=k) = C(n,k) p<sup>k</sup>(1-p)<sup>n-k</sup></span> &mdash; n trials, probability p of success</li>
                    <li><strong>Geometric</strong>: <span class="formula-highlight">P(X=k) = (1-p)<sup>k-1</sup> p</span> &mdash; trials until first success</li>
                    <li><strong>Uniform</strong>: <span class="formula-highlight">P(X=k) = 1/n</span> &mdash; equal probability for all outcomes</li>
                    <li>Each distribution has a <strong>probability mass function</strong> (PMF) that sums to 1</li>
                    <li>Mean and variance characterize the center and spread</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Poisson Distribution</h3>
                <ul>
                    <li>Models the count of <strong>rare events</strong> in a fixed interval</li>
                    <li><span class="formula-highlight">P(X=k) = &lambda;<sup>k</sup> e<sup>-&lambda;</sup> / k!</span></li>
                    <li>&lambda; is the <strong>expected rate</strong> (average count)</li>
                    <li>Key property: <span class="formula-highlight">mean = variance = &lambda;</span></li>
                    <li>For large &lambda;, the Poisson approaches a <strong>normal distribution</strong></li>
                    <li>Used for traffic arrivals, radioactive decay, server requests</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/normal-distribution.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#119977;</div>
                <div><h4>Normal Distribution</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/permutations-combinations.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(249,115,22,0.12);">&#8450;</div>
                <div><h4>Permutations &amp; Combinations</h4><span>Probability</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Probability Distributions Visualizer","description":"Interactive probability distribution visualizer. Explore binomial, Poisson, geometric, and uniform distributions with adjustable parameters, PMF charts, mean, variance, and standard deviation.","url":"https://8gwifi.org/exams/visual-math/probability-distributions.jsp","educationalLevel":"High School","teaches":"Binomial distribution, Poisson distribution, geometric distribution, uniform distribution, PMF, mean, variance, standard deviation","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Probability Distributions"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between binomial and Poisson distributions?","acceptedAnswer":{"@type":"Answer","text":"The binomial distribution models a fixed number of independent trials (n), each with probability p of success, and counts how many succeed. The Poisson distribution models the number of events in a fixed interval when events occur at a constant average rate \u03bb. When n is large and p is small, the binomial approximates a Poisson with \u03bb = np."}},{"@type":"Question","name":"When does a distribution converge to normal?","acceptedAnswer":{"@type":"Answer","text":"By the Central Limit Theorem, the sum (or average) of many independent random variables approaches a normal distribution regardless of the original distribution. Specifically, the binomial approaches normal when np and n(1-p) are both large (typically > 5). The Poisson approaches normal for large \u03bb (typically \u03bb > 20)."}},{"@type":"Question","name":"What is a probability mass function?","acceptedAnswer":{"@type":"Answer","text":"A probability mass function (PMF) gives the probability that a discrete random variable equals each possible value. For example, the binomial PMF is P(X=k) = C(n,k) p^k (1-p)^(n-k). The PMF must be non-negative for all values and sum to exactly 1 across all possible outcomes."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-distributions.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('distributions', 'viz-canvas', {
        distType: 'binomial',
        n: 10,
        p: 0.5,
        lambda: 3
    });
    var state = VisualMath.getState();

    var presets = {
        'binomial':   { distType: 'binomial',   n: 10, p: 0.5,  lambda: 3 },
        'poisson':    { distType: 'poisson',     n: 10, p: 0.5,  lambda: 3 },
        'geometric':  { distType: 'geometric',   n: 10, p: 0.3,  lambda: 3 },
        'uniform':    { distType: 'uniform',     n: 8,  p: 0.5,  lambda: 3 },
        'rare':       { distType: 'poisson',     n: 10, p: 0.5,  lambda: 0.5 }
    };

    function showSliderGroup(distType) {
        document.getElementById('n-group').style.display = (distType === 'binomial' || distType === 'uniform') ? '' : 'none';
        document.getElementById('p-group').style.display = (distType === 'binomial' || distType === 'geometric') ? '' : 'none';
        document.getElementById('lambda-group').style.display = (distType === 'poisson') ? '' : 'none';
    }

    function applyPreset(key) {
        var p = presets[key];
        state.distType = p.distType;
        state.n = p.n;
        state.p = p.p;
        state.lambda = p.lambda;

        document.getElementById('n-slider').value = p.n;
        document.getElementById('n-display').textContent = p.n;
        document.getElementById('n-val').textContent = p.n;

        document.getElementById('p-slider').value = p.p;
        document.getElementById('p-display').textContent = p.p.toFixed(2);
        document.getElementById('p-val').textContent = p.p.toFixed(2);

        document.getElementById('lambda-slider').value = p.lambda;
        document.getElementById('lambda-display').textContent = p.lambda.toFixed(1);
        document.getElementById('lambda-val').textContent = p.lambda.toFixed(1);

        showSliderGroup(p.distType);

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('n-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.n = v;
        document.getElementById('n-display').textContent = v;
        document.getElementById('n-val').textContent = v;
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('p-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.p = v;
        document.getElementById('p-display').textContent = v.toFixed(2);
        document.getElementById('p-val').textContent = v.toFixed(2);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('lambda-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.lambda = v;
        document.getElementById('lambda-display').textContent = v.toFixed(1);
        document.getElementById('lambda-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        applyPreset('binomial');
    });
});
</script>
