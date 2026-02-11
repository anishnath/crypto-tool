<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Taylor Series Calculator & Visualizer - sin, cos, e^x Approximation (Free)";
    String seoDescription = "Free Taylor series visualizer. Watch polynomials approximate sin(x), cos(x), e^x step by step. Adjust terms from 1-15 with error shading and formula display.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/taylor-series.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Taylor Series Calculator - Polynomial Approximation Visualizer\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Taylor Series Calculator & Visualizer\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"taylor series calculator, taylor series, maclaurin series, taylor polynomial, taylor expansion sin x, taylor series cos x, taylor series e^x, polynomial approximation\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<style>
    .formula-box {
        background: var(--bg-secondary);
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-md);
        padding: 10px 14px;
        font-family: 'JetBrains Mono', monospace;
        font-size: var(--text-sm);
        color: var(--text-primary);
        word-break: break-all;
        line-height: 1.6;
        margin-top: var(--space-2);
    }
</style>

<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Taylor Series</span>
    </nav>

    <div class="viz-header">
        <h1>Taylor Series Builder</h1>
        <p class="viz-subtitle">Add polynomial terms one by one and watch the approximation get closer to the real function. The pink shading shows the error.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Controls</h3>

                <div class="control-group">
                    <label>Function</label>
                    <div class="viz-check-group" style="flex-direction:column;">
                        <label class="viz-check"><input type="radio" name="tfunc" value="sin" checked> sin(x)</label>
                        <label class="viz-check"><input type="radio" name="tfunc" value="cos"> cos(x)</label>
                        <label class="viz-check"><input type="radio" name="tfunc" value="exp"> e&#739;</label>
                        <label class="viz-check"><input type="radio" name="tfunc" value="ln1x"> ln(1+x)</label>
                        <label class="viz-check"><input type="radio" name="tfunc" value="1/(1-x)"> 1/(1-x)</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>Terms (<span id="val-terms">3</span>)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="terms-slider" min="1" max="15" value="3" step="1">
                        <span class="viz-slider-val" id="terms-display">3</span>
                    </div>
                </div>

                <div class="control-group">
                    <label class="viz-check">
                        <input type="checkbox" id="show-error" checked> Show error shading
                    </label>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Polynomial</h3>
                <div class="formula-box" id="val-formula">x - x&sup3;/6</div>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Taylor Series Formula</h3>
                <ul>
                    <li><span class="formula-highlight">f(x) = &Sigma; f&#8317;&#8319;&#8318;(a)/n! &middot; (x-a)&#8319;</span></li>
                    <li>Centered at a=0 (Maclaurin series)</li>
                    <li>Each term adds one more derivative's worth of information</li>
                    <li>More terms = better approximation near the center</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Common Series</h3>
                <ul>
                    <li><strong>sin(x)</strong> = x - x&sup3;/3! + x&#8309;/5! - ...</li>
                    <li><strong>cos(x)</strong> = 1 - x&sup2;/2! + x&#8308;/4! - ...</li>
                    <li><strong>e&#739;</strong> = 1 + x + x&sup2;/2! + x&sup3;/3! + ...</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Start with 1 term for sin(x) &mdash; it's just a straight line (y=x)</li>
                    <li>Add to 3 terms &mdash; suddenly it curves like sin!</li>
                    <li>At 7 terms, it's nearly perfect from -&pi; to &pi;</li>
                    <li>Try e&#739; &mdash; notice it converges everywhere, not just near 0</li>
                    <li>Try ln(1+x) &mdash; it only converges for |x| &lt; 1 (radius of convergence)</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Key Insight</h3>
                <p>Taylor series show that smooth functions are secretly polynomials in disguise &mdash; you just need infinitely many terms.</p>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/derivative.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8711;</div>
                <div><h4>Derivative Visualizer</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/limits-continuity.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8594;</div>
                <div><h4>Limits &amp; Continuity</h4><span>Calculus</span></div>
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
    "name": "Taylor Series Visualizer",
    "description": "Interactive Taylor polynomial approximation visualizer for sin, cos, e^x and more.",
    "url": "https://8gwifi.org/exams/visual-math/taylor-series.jsp",
    "educationalLevel": "High School",
    "teaches": "Taylor and Maclaurin series approximations",
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
        { "@type": "ListItem", "position": 4, "name": "Taylor Series" }
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
            "name": "What is a Taylor series?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A Taylor series represents a smooth function as an infinite sum of polynomial terms, each based on the function's derivatives at a single point. When centered at x=0, it is called a Maclaurin series."
            }
        },
        {
            "@type": "Question",
            "name": "What is the Taylor series for sin(x)?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The Taylor series for sin(x) centered at 0 is: x - x³/3! + x⁵/5! - x⁷/7! + ... Each term adds an odd power of x divided by its factorial, with alternating signs. Just 7 terms gives excellent accuracy from -π to π."
            }
        },
        {
            "@type": "Question",
            "name": "What is the radius of convergence?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The radius of convergence is the range of x values where the Taylor series converges to the actual function. For sin(x), cos(x), and e^x it is infinite. For ln(1+x) it is |x| < 1, and for 1/(1-x) it is also |x| < 1."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-taylor.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('taylor-series', 'viz-canvas', {
        func: 'sin', terms: 3, showError: true
    });

    // Function radio
    document.querySelectorAll('input[name="tfunc"]').forEach(function(r) {
        r.addEventListener('change', function() {
            VisualMath.getState().func = this.value;
            VisualMath.getState()._redraw();
        });
    });

    // Terms slider
    var slider = document.getElementById('terms-slider');
    slider.addEventListener('input', function() {
        var v = parseInt(this.value);
        VisualMath.getState().terms = v;
        document.getElementById('terms-display').textContent = v;
        VisualMath.getState()._redraw();
    });

    // Error checkbox
    document.getElementById('show-error').addEventListener('change', function() {
        VisualMath.getState().showError = this.checked;
        VisualMath.getState()._redraw();
    });

    // Animate
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function() {
        if (animInterval) {
            clearInterval(animInterval);
            animInterval = null;
            this.textContent = 'Animate';
            this.classList.remove('viz-btn-secondary');
            this.classList.add('viz-btn-primary');
            return;
        }
        this.textContent = 'Pause';
        this.classList.add('viz-btn-secondary');
        this.classList.remove('viz-btn-primary');
        slider.value = 1;
        VisualMath.getState().terms = 1;
        document.getElementById('terms-display').textContent = '1';
        VisualMath.getState()._redraw();

        animInterval = setInterval(function() {
            var cur = parseInt(slider.value);
            if (cur >= 15) { clearInterval(animInterval); animInterval = null;
                document.getElementById('animate-btn').textContent = 'Animate';
                document.getElementById('animate-btn').classList.remove('viz-btn-secondary');
                document.getElementById('animate-btn').classList.add('viz-btn-primary');
                return;
            }
            slider.value = cur + 1;
            VisualMath.getState().terms = cur + 1;
            document.getElementById('terms-display').textContent = cur + 1;
            VisualMath.getState()._redraw();
        }, 600);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function() {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        slider.value = 3;
        document.getElementById('terms-display').textContent = '3';
        document.querySelector('input[name="tfunc"][value="sin"]').checked = true;
        document.getElementById('show-error').checked = true;
        var s = VisualMath.getState();
        s.func = 'sin'; s.terms = 3; s.showError = true;
        s._redraw();
        document.getElementById('animate-btn').textContent = 'Animate';
        document.getElementById('animate-btn').classList.remove('viz-btn-secondary');
        document.getElementById('animate-btn').classList.add('viz-btn-primary');
    });
});
</script>
