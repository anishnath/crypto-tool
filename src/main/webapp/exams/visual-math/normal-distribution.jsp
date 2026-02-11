<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Normal Distribution Calculator - Z-Score, Probability & Bell Curve (Free)";
    String seoDescription = "Free normal distribution calculator with interactive bell curve. Find probabilities, z-scores, and shade areas under the curve. Supports P(X<x), P(X>x), and P(a<X<b) with adjustable mean and standard deviation.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/normal-distribution.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Normal Distribution Calculator - Interactive Bell Curve\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Normal Distribution Calculator - Z-Score & Bell Curve\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"normal distribution calculator, z-score calculator, bell curve calculator, standard normal distribution, probability calculator, area under curve, Gaussian distribution, statistics calculator, z-table, normal CDF\">");

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
        <span class="breadcrumb-current">Normal Distribution</span>
    </nav>

    <div class="viz-header">
        <h1>Normal Distribution Calculator</h1>
        <p class="viz-subtitle">Adjust the mean and standard deviation, choose a probability mode, and watch the shaded area change in real-time. Read off z-scores and exact probabilities instantly.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Controls</h3>

                <div class="control-group">
                    <label>&mu; (mean) = <span id="mu-display">0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="mu-slider" min="-10" max="10" value="0" step="0.5">
                        <span class="viz-slider-val" id="mu-val">0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>&sigma; (std dev) = <span id="sigma-display">1</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="sigma-slider" min="0.5" max="5" value="1" step="0.25">
                        <span class="viz-slider-val" id="sigma-val">1</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Mode</label>
                    <div class="viz-check-group" style="flex-direction:column;">
                        <label class="viz-check"><input type="radio" name="mode" value="less" checked> P(X &lt; x)</label>
                        <label class="viz-check"><input type="radio" name="mode" value="greater"> P(X &gt; x)</label>
                        <label class="viz-check"><input type="radio" name="mode" value="between"> P(a &lt; X &lt; b)</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>x = <span id="x-display">1.00</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="x-slider" min="-4" max="4" value="1" step="0.05">
                        <span class="viz-slider-val" id="x-val">1.00</span>
                    </div>
                </div>

                <div class="control-group" id="x2-group" style="display:none;">
                    <label>a = <span id="x2-display">-1.00</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="x2-slider" min="-4" max="4" value="-1" step="0.05">
                        <span class="viz-slider-val" id="x2-val">-1.00</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Results</h3>
                <table>
                    <tr><td>P</td><td id="val-prob">&mdash;</td></tr>
                    <tr><td>z-score</td><td id="val-z">&mdash;</td></tr>
                    <tr><td>Percent</td><td id="val-pct">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Normal Distribution</h3>
                <ul>
                    <li>PDF: <span class="formula-highlight">f(x) = (1/&sigma;&radic;2&pi;) e<sup>-(x-&mu;)&sup2;/2&sigma;&sup2;</sup></span></li>
                    <li>The bell curve is symmetric about the mean <span class="formula-highlight">&mu;</span></li>
                    <li>68% of data falls within <span class="formula-highlight">&mu; &plusmn; 1&sigma;</span></li>
                    <li>95% within <span class="formula-highlight">&mu; &plusmn; 2&sigma;</span>, 99.7% within <span class="formula-highlight">&mu; &plusmn; 3&sigma;</span></li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Z-Score</h3>
                <ul>
                    <li>The z-score converts any normal to the standard normal: <span class="formula-highlight">z = (x - &mu;) / &sigma;</span></li>
                    <li>A z-score of 1.96 corresponds to the 97.5th percentile</li>
                    <li>Used for hypothesis testing, confidence intervals, and comparing across distributions</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Set <strong>&mu;=0, &sigma;=1</strong> for the standard normal &mdash; check that P(X&lt;1.96) &asymp; 0.975</li>
                    <li>Try <strong>P(X &gt; 0)</strong> &mdash; always 0.5 regardless of &sigma;</li>
                    <li>Use <strong>Between</strong> mode to find P(-1 &lt; X &lt; 1) &asymp; 0.6827</li>
                    <li>Increase &sigma; &mdash; the bell flattens but total area stays 1</li>
                    <li>Shift &mu; &mdash; the entire curve moves left or right</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Common Values</h3>
                <ul>
                    <li><strong>z = 1.645</strong> &rarr; 90% one-tail confidence</li>
                    <li><strong>z = 1.960</strong> &rarr; 95% two-tail / 97.5% one-tail</li>
                    <li><strong>z = 2.576</strong> &rarr; 99% two-tail confidence</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/central-limit-theorem.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(147,51,234,0.12);">&#9636;</div>
                <div><h4>Central Limit Theorem</h4><span>Statistics</span></div>
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
    "name": "Normal Distribution Calculator",
    "description": "Interactive bell curve calculator with z-scores, probabilities, and area shading for the normal (Gaussian) distribution.",
    "url": "https://8gwifi.org/exams/visual-math/normal-distribution.jsp",
    "educationalLevel": "High School",
    "teaches": "Normal distribution, z-scores, and probability calculations",
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
        { "@type": "ListItem", "position": 4, "name": "Normal Distribution Calculator" }
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
            "name": "What is a z-score?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A z-score (standard score) measures how many standard deviations a value is from the mean. It is calculated as z = (x - mu) / sigma. A z-score of 0 means the value equals the mean, positive z-scores are above the mean, and negative z-scores are below. Z-scores let you compare values from different normal distributions on the same scale."
            }
        },
        {
            "@type": "Question",
            "name": "What is the 68-95-99.7 rule?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The 68-95-99.7 rule (empirical rule) states that for a normal distribution, approximately 68% of data falls within 1 standard deviation of the mean, 95% within 2 standard deviations, and 99.7% within 3 standard deviations. This makes it easy to estimate probabilities without a calculator."
            }
        },
        {
            "@type": "Question",
            "name": "How do you calculate the area under the normal curve?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The area under the normal curve is computed using the cumulative distribution function (CDF), which integrates the probability density function from negative infinity to x. There is no closed-form solution, so approximation methods like the Abramowitz & Stegun algorithm are used. This calculator computes exact CDF values for any mean and standard deviation."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-normal.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('normal-distribution', 'viz-canvas', { mu: 0, sigma: 1, mode: 'less', xVal: 1, xVal2: -1 });

    var state = VisualMath.getState();

    // Mu slider
    document.getElementById('mu-slider').addEventListener('input', function() {
        var v = parseFloat(this.value);
        state.mu = v;
        document.getElementById('mu-display').textContent = v;
        document.getElementById('mu-val').textContent = v;
        updateSliderRanges();
        state._redraw();
    });

    // Sigma slider
    document.getElementById('sigma-slider').addEventListener('input', function() {
        var v = parseFloat(this.value);
        state.sigma = v;
        document.getElementById('sigma-display').textContent = v;
        document.getElementById('sigma-val').textContent = v;
        updateSliderRanges();
        state._redraw();
    });

    // Mode radio
    document.querySelectorAll('input[name="mode"]').forEach(function(r) {
        r.addEventListener('change', function() {
            state.mode = this.value;
            document.getElementById('x2-group').style.display = this.value === 'between' ? '' : 'none';
            state._redraw();
        });
    });

    // X slider
    document.getElementById('x-slider').addEventListener('input', function() {
        var v = parseFloat(this.value);
        state.xVal = state.mu + v * state.sigma;
        document.getElementById('x-display').textContent = state.xVal.toFixed(2);
        document.getElementById('x-val').textContent = state.xVal.toFixed(2);
        state._redraw();
    });

    // X2 slider
    document.getElementById('x2-slider').addEventListener('input', function() {
        var v = parseFloat(this.value);
        state.xVal2 = state.mu + v * state.sigma;
        document.getElementById('x2-display').textContent = state.xVal2.toFixed(2);
        document.getElementById('x2-val').textContent = state.xVal2.toFixed(2);
        state._redraw();
    });

    function updateSliderRanges() {
        // Update displayed x values when mu/sigma change
        var xSlider = document.getElementById('x-slider');
        state.xVal = state.mu + parseFloat(xSlider.value) * state.sigma;
        document.getElementById('x-display').textContent = state.xVal.toFixed(2);
        document.getElementById('x-val').textContent = state.xVal.toFixed(2);
        var x2Slider = document.getElementById('x2-slider');
        state.xVal2 = state.mu + parseFloat(x2Slider.value) * state.sigma;
        document.getElementById('x2-display').textContent = state.xVal2.toFixed(2);
        document.getElementById('x2-val').textContent = state.xVal2.toFixed(2);
    }

    // Animate — sweep x from -3.5σ to +3.5σ
    var animInterval = null;
    var animBtn = document.getElementById('animate-btn');
    animBtn.addEventListener('click', function() {
        if (animInterval) {
            clearInterval(animInterval);
            animInterval = null;
            animBtn.textContent = 'Animate';
            animBtn.classList.remove('viz-btn-secondary');
            animBtn.classList.add('viz-btn-primary');
            return;
        }
        animBtn.textContent = 'Pause';
        animBtn.classList.add('viz-btn-secondary');
        animBtn.classList.remove('viz-btn-primary');

        var xSlider = document.getElementById('x-slider');
        xSlider.value = -3.5;

        animInterval = setInterval(function() {
            var cur = parseFloat(xSlider.value);
            if (cur >= 3.5) {
                clearInterval(animInterval); animInterval = null;
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
                return;
            }
            cur = Math.min(3.5, cur + 0.08);
            xSlider.value = cur;
            state.xVal = state.mu + cur * state.sigma;
            document.getElementById('x-display').textContent = state.xVal.toFixed(2);
            document.getElementById('x-val').textContent = state.xVal.toFixed(2);
            state._redraw();
        }, 50);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function() {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        state.mu = 0; state.sigma = 1; state.mode = 'less'; state.xVal = 1; state.xVal2 = -1;
        document.getElementById('mu-slider').value = 0;
        document.getElementById('mu-display').textContent = '0';
        document.getElementById('mu-val').textContent = '0';
        document.getElementById('sigma-slider').value = 1;
        document.getElementById('sigma-display').textContent = '1';
        document.getElementById('sigma-val').textContent = '1';
        document.getElementById('x-slider').value = 1;
        document.getElementById('x-display').textContent = '1.00';
        document.getElementById('x-val').textContent = '1.00';
        document.getElementById('x2-slider').value = -1;
        document.getElementById('x2-display').textContent = '-1.00';
        document.getElementById('x2-val').textContent = '-1.00';
        document.querySelector('input[name="mode"][value="less"]').checked = true;
        document.getElementById('x2-group').style.display = 'none';
        state._redraw();
    });
});
</script>
