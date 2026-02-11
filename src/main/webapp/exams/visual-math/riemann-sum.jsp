<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Riemann Sum Calculator - Left, Right, Midpoint Visualizer (Free)";
    String seoDescription = "Free Riemann sum calculator with interactive visualization. Choose left, right, or midpoint method. Adjust 1-100 rectangles and watch convergence to the exact integral.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/riemann-sum.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Riemann Sum Calculator - Interactive Integral Visualizer\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Riemann Sum Calculator - Visualize Integrals\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"riemann sum calculator, riemann sum, left riemann sum, right riemann sum, midpoint riemann sum, integral calculator, area under curve, definite integral visualization\">");

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
        <span class="breadcrumb-current">Riemann Sum</span>
    </nav>

    <div class="viz-header">
        <h1>Riemann Sum Explorer</h1>
        <p class="viz-subtitle">See how rectangles approximate the area under a curve. Increase the count and watch it converge to the exact integral.</p>
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
                    <div class="viz-check-group" id="func-btns" style="flex-direction:column;">
                        <label class="viz-check"><input type="radio" name="func" value="sin" checked> sin(x)</label>
                        <label class="viz-check"><input type="radio" name="func" value="x2"> x&sup2;</label>
                        <label class="viz-check"><input type="radio" name="func" value="x3"> x&sup3;</label>
                        <label class="viz-check"><input type="radio" name="func" value="sqrt"> &radic;x</label>
                        <label class="viz-check"><input type="radio" name="func" value="cos+1"> cos(x)+1</label>
                        <label class="viz-check"><input type="radio" name="func" value="1/x"> 1/x</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>Rectangles (n)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="1" max="100" value="10" step="1">
                        <span class="viz-slider-val" id="n-display">10</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Method</label>
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="radio" name="method" value="left" checked> Left</label>
                        <label class="viz-check"><input type="radio" name="method" value="right"> Right</label>
                        <label class="viz-check"><input type="radio" name="method" value="midpoint"> Midpoint</label>
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
                    <tr><td>n</td><td id="val-n">10</td></tr>
                    <tr><td>Approx</td><td id="val-approx">-</td></tr>
                    <tr><td>Exact</td><td id="val-exact">-</td></tr>
                    <tr><td>Error</td><td id="val-error">-</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Riemann Sum Formula</h3>
                <ul>
                    <li><strong>Left sum</strong>: <span class="formula-highlight">S = &Sigma; f(x&#7522;) &Delta;x</span> where x&#7522; = a + i&middot;&Delta;x</li>
                    <li><strong>Right sum</strong>: x&#7522; = a + (i+1)&middot;&Delta;x</li>
                    <li><strong>Midpoint</strong>: x&#7522; = a + (i+&frac12;)&middot;&Delta;x</li>
                    <li>&Delta;x = (b - a) / n</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Convergence</h3>
                <ul>
                    <li>As n &rarr; &infin;, all three methods converge to the definite integral</li>
                    <li>Midpoint typically converges fastest (error ~ 1/n&sup2;)</li>
                    <li>Left/Right have error ~ 1/n for monotonic functions</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Set n=1 and compare Left vs Right for sin(x) &mdash; which overestimates?</li>
                    <li>Increase n to 50 and see the error drop below 0.1%</li>
                    <li>Try x&sup2; with midpoint at n=4 &mdash; surprisingly accurate!</li>
                    <li>Watch the animation to see convergence in real-time</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Key Insight</h3>
                <p>The definite integral <span class="formula-highlight">&int;f(x)dx</span> is defined as the limit of Riemann sums as the partition gets infinitely fine.</p>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/integration-explorer.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8747;</div>
                <div><h4>Integration Explorer</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/derivative.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#8711;</div>
                <div><h4>Derivative Visualizer</h4><span>Calculus</span></div>
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
    "name": "Riemann Sum Calculator",
    "description": "Interactive Riemann sum visualization with left, right, and midpoint methods.",
    "url": "https://8gwifi.org/exams/visual-math/riemann-sum.jsp",
    "educationalLevel": "High School",
    "teaches": "Definite integrals via Riemann sums",
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
        { "@type": "ListItem", "position": 4, "name": "Riemann Sum" }
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
            "name": "What is a Riemann sum?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A Riemann sum approximates the area under a curve by dividing it into rectangles. The sum of the rectangle areas approaches the exact definite integral as the number of rectangles increases."
            }
        },
        {
            "@type": "Question",
            "name": "What is the difference between left, right, and midpoint Riemann sums?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Left Riemann sums use the function value at the left edge of each rectangle, right sums use the right edge, and midpoint sums use the center. Midpoint typically converges fastest with error proportional to 1/n²."
            }
        },
        {
            "@type": "Question",
            "name": "How many rectangles do you need for an accurate Riemann sum?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "It depends on the function and method. For smooth functions like sin(x), 50 rectangles with the midpoint method often gives less than 0.1% error. The definite integral is the limit as the number of rectangles approaches infinity."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-riemann.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    var st = { func: 'sin', n: 10, method: 'left' };
    VisualMath.init('riemann-sum', 'viz-canvas', st);

    // Function radio
    document.querySelectorAll('input[name="func"]').forEach(function(r) {
        r.addEventListener('change', function() {
            VisualMath.getState().func = this.value;
            VisualMath.getState()._redraw();
        });
    });

    // N slider
    var nSlider = document.getElementById('n-slider');
    nSlider.addEventListener('input', function() {
        VisualMath.getState().n = parseInt(this.value);
        document.getElementById('n-display').textContent = this.value;
        VisualMath.getState()._redraw();
    });

    // Method radio
    document.querySelectorAll('input[name="method"]').forEach(function(r) {
        r.addEventListener('change', function() {
            VisualMath.getState().method = this.value;
            VisualMath.getState()._redraw();
        });
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
        nSlider.value = 1;
        VisualMath.getState().n = 1;
        document.getElementById('n-display').textContent = '1';
        VisualMath.getState()._redraw();

        animInterval = setInterval(function() {
            var cur = parseInt(nSlider.value);
            if (cur >= 100) { clearInterval(animInterval); animInterval = null;
                document.getElementById('animate-btn').textContent = 'Animate';
                document.getElementById('animate-btn').classList.remove('viz-btn-secondary');
                document.getElementById('animate-btn').classList.add('viz-btn-primary');
                return;
            }
            cur = Math.min(100, cur + (cur < 10 ? 1 : cur < 30 ? 2 : 5));
            nSlider.value = cur;
            VisualMath.getState().n = cur;
            document.getElementById('n-display').textContent = cur;
            VisualMath.getState()._redraw();
        }, 200);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function() {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        nSlider.value = 10;
        document.getElementById('n-display').textContent = '10';
        document.querySelector('input[name="func"][value="sin"]').checked = true;
        document.querySelector('input[name="method"][value="left"]').checked = true;
        var s = VisualMath.getState();
        s.func = 'sin'; s.n = 10; s.method = 'left';
        s._redraw();
        document.getElementById('animate-btn').textContent = 'Animate';
        document.getElementById('animate-btn').classList.remove('viz-btn-secondary');
        document.getElementById('animate-btn').classList.add('viz-btn-primary');
    });
});
</script>
