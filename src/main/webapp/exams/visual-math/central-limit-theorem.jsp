<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Central Limit Theorem Simulator - Interactive CLT Visualizer (Free)";
    String seoDescription = "Free CLT simulator. Draw samples from uniform, exponential, bimodal, or dice distributions. Watch the sampling distribution of means become normal as sample size grows.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/central-limit-theorem.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Central Limit Theorem Simulator - Interactive Visualizer\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Central Limit Theorem Simulator - CLT Visualizer\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"central limit theorem, CLT simulator, sampling distribution, normal distribution, sample mean, statistics visualization, probability simulator, law of large numbers\">");

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
        <span class="breadcrumb-current">Central Limit Theorem</span>
    </nav>

    <div class="viz-header">
        <h1>Central Limit Theorem</h1>
        <p class="viz-subtitle">Pick any distribution and draw samples. No matter what the population looks like, the distribution of sample means approaches a normal curve.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Controls</h3>

                <div class="control-group">
                    <label>Population</label>
                    <div class="viz-check-group" style="flex-direction:column;">
                        <label class="viz-check"><input type="radio" name="dist" value="uniform" checked> Uniform [0, 10]</label>
                        <label class="viz-check"><input type="radio" name="dist" value="exponential"> Exponential</label>
                        <label class="viz-check"><input type="radio" name="dist" value="bimodal"> Bimodal</label>
                        <label class="viz-check"><input type="radio" name="dist" value="dice"> Dice (1&ndash;6)</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>Sample size n = <span id="n-display">5</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="2" max="50" value="5" step="1">
                        <span class="viz-slider-val" id="n-val">5</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="draw-btn">Draw Samples</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Statistics</h3>
                <table>
                    <tr><td>Samples</td><td id="val-n-drawn">0</td></tr>
                    <tr><td>Mean of X&#772;</td><td id="val-mean">&mdash;</td></tr>
                    <tr><td>Std of X&#772;</td><td id="val-std">&mdash;</td></tr>
                    <tr><td>&sigma;/&radic;n</td><td id="val-theory">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>The Central Limit Theorem</h3>
                <ul>
                    <li>Given any population with mean <span class="formula-highlight">&mu;</span> and standard deviation <span class="formula-highlight">&sigma;</span></li>
                    <li>The distribution of sample means X&#772; approaches <span class="formula-highlight">N(&mu;, &sigma;&sup2;/n)</span> as n grows</li>
                    <li>This works regardless of the original distribution's shape</li>
                    <li>Standard error: <span class="formula-highlight">SE = &sigma;/&radic;n</span></li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Why It Matters</h3>
                <ul>
                    <li>Foundation of confidence intervals and hypothesis testing</li>
                    <li>Explains why the normal distribution appears everywhere in nature</li>
                    <li>Works for n &ge; 30 as a rule of thumb (less for symmetric distributions)</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Start with <strong>Uniform</strong> at n=2 &mdash; the mean distribution is already triangular, not flat</li>
                    <li>Increase to n=30 &mdash; it looks perfectly normal</li>
                    <li>Try <strong>Exponential</strong> &mdash; a skewed distribution. At n=5 the means are still skewed; at n=30 they're symmetric</li>
                    <li>Try <strong>Bimodal</strong> &mdash; two peaks merge into one bell curve</li>
                    <li>Watch how the <strong>Std of X&#772;</strong> matches <strong>&sigma;/&radic;n</strong></li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Key Insight</h3>
                <p>Averages are predictable even when individuals are not. The CLT is why polls, quality control, and scientific experiments work.</p>
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
            <a href="<%=request.getContextPath()%>/exams/visual-math/statistics-dashboard.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#9636;</div>
                <div><h4>Statistics Dashboard</h4><span>Statistics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Central Limit Theorem Simulator",
    "description": "Interactive CLT visualization showing how sample means converge to a normal distribution regardless of the population shape.",
    "url": "https://8gwifi.org/exams/visual-math/central-limit-theorem.jsp",
    "educationalLevel": "High School",
    "teaches": "Central Limit Theorem and sampling distributions",
    "learningResourceType": "Interactive visualization",
    "publisher": { "@type": "Organization", "name": "8gwifi.org" }
}
</script>
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/" },
        { "@type": "ListItem", "position": 3, "name": "Visual Math Lab", "item": "https://8gwifi.org/exams/visual-math/" },
        { "@type": "ListItem", "position": 4, "name": "Central Limit Theorem" }
    ]
}
</script>
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
        {
            "@type": "Question",
            "name": "What is the Central Limit Theorem?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The Central Limit Theorem states that the distribution of sample means approaches a normal distribution as sample size increases, regardless of the population's original shape. The mean equals the population mean and the standard deviation equals sigma divided by the square root of n."
            }
        },
        {
            "@type": "Question",
            "name": "How large does the sample size need to be for CLT to work?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A common rule of thumb is n >= 30, but it depends on how skewed the population is. For symmetric distributions like uniform or dice, the CLT kicks in much earlier (n=5-10). For highly skewed distributions like exponential, you may need n=30 or more."
            }
        },
        {
            "@type": "Question",
            "name": "What is the standard error?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The standard error (SE) is the standard deviation of the sampling distribution of the mean. It equals the population standard deviation divided by the square root of the sample size: SE = sigma / sqrt(n). It measures how much sample means vary from the true mean."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-clt.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('clt', 'viz-canvas', { dist: 'uniform', n: 5 });

    // Distribution radio
    document.querySelectorAll('input[name="dist"]').forEach(function(r) {
        r.addEventListener('change', function() {
            VisualMath.getState().dist = this.value;
            VisualMath.getState()._reset();
        });
    });

    // Sample size slider
    var nSlider = document.getElementById('n-slider');
    nSlider.addEventListener('input', function() {
        var v = parseInt(this.value);
        VisualMath.getState().n = v;
        document.getElementById('n-display').textContent = v;
        document.getElementById('n-val').textContent = v;
        VisualMath.getState()._reset();
    });

    // Draw/Pause button
    var drawBtn = document.getElementById('draw-btn');
    drawBtn.addEventListener('click', function() {
        var s = VisualMath.getState();
        if (s.running) {
            s._stop();
            drawBtn.textContent = 'Draw Samples';
            drawBtn.classList.remove('viz-btn-secondary');
            drawBtn.classList.add('viz-btn-primary');
        } else {
            s._start();
            drawBtn.textContent = 'Pause';
            drawBtn.classList.add('viz-btn-secondary');
            drawBtn.classList.remove('viz-btn-primary');
        }
    });

    // Reset button
    document.getElementById('reset-btn').addEventListener('click', function() {
        var s = VisualMath.getState();
        s._stop();
        s._reset();
        drawBtn.textContent = 'Draw Samples';
        drawBtn.classList.remove('viz-btn-secondary');
        drawBtn.classList.add('viz-btn-primary');
        document.getElementById('val-n-drawn').textContent = '0';
        document.getElementById('val-mean').textContent = '\u2014';
        document.getElementById('val-std').textContent = '\u2014';
        document.getElementById('val-theory').textContent = '\u2014';
    });
});
</script>
