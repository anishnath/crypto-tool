<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Derivative Visualizer - Tangent Line & Slope Calculator (Free)";
    String seoDescription = "Free interactive derivative visualizer. See the tangent line move along any function. Understand slope, rate of change, and derivative curves visually with 8 preset functions.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/derivative.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Derivative Visualizer - Interactive Tangent Line Calculator\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Derivative Visualizer - Tangent Line & Slope\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"derivative calculator, tangent line calculator, slope visualizer, rate of change, differentiation, derivative graph, calculus visualizer, f prime x, instantaneous rate of change, derivative of sin cos\">");

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
        <span class="breadcrumb-current">Derivative Visualizer</span>
    </nav>

    <div class="viz-header">
        <h1>Derivative Visualizer</h1>
        <p class="viz-subtitle">Pick a function, drag the point along the curve, and watch the tangent line follow. Toggle the derivative curve to see f'(x) drawn alongside f(x).</p>
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
                        <label class="viz-check"><input type="radio" name="func" value="x2"> x&sup2;</label>
                        <label class="viz-check"><input type="radio" name="func" value="x3"> x&sup3;</label>
                        <label class="viz-check"><input type="radio" name="func" value="sin" checked> sin(x)</label>
                        <label class="viz-check"><input type="radio" name="func" value="cos"> cos(x)</label>
                        <label class="viz-check"><input type="radio" name="func" value="exp"> e&#x02E3;</label>
                        <label class="viz-check"><input type="radio" name="func" value="ln"> ln(x)</label>
                        <label class="viz-check"><input type="radio" name="func" value="sqrt"> &radic;x</label>
                        <label class="viz-check"><input type="radio" name="func" value="1/x"> 1/x</label>
                    </div>
                </div>

                <div class="control-group">
                    <label>x = <span id="x-display">1.00</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="x-slider" min="0" max="100" value="57" step="1">
                        <span class="viz-slider-val" id="x-val">1.00</span>
                    </div>
                </div>

                <div class="control-group">
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="checkbox" id="show-deriv"> Show f'(x) curve</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Values</h3>
                <table>
                    <tr><td>f(x)</td><td id="val-fx">&mdash;</td></tr>
                    <tr><td>Slope</td><td id="val-slope">&mdash;</td></tr>
                    <tr><td>f'(x)</td><td id="val-deriv-formula">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>What Is a Derivative?</h3>
                <ul>
                    <li>The derivative <span class="formula-highlight">f'(x)</span> is the slope of the tangent line at point x</li>
                    <li>It measures the <strong>instantaneous rate of change</strong></li>
                    <li>Formally: <span class="formula-highlight">f'(x) = lim<sub>h&rarr;0</sub> [f(x+h) - f(x)] / h</span></li>
                    <li>Positive slope = function increasing; negative = decreasing; zero = flat (potential extremum)</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Common Derivatives</h3>
                <ul>
                    <li><span class="formula-highlight">d/dx [x&sup2;] = 2x</span></li>
                    <li><span class="formula-highlight">d/dx [sin(x)] = cos(x)</span></li>
                    <li><span class="formula-highlight">d/dx [e&#x02E3;] = e&#x02E3;</span></li>
                    <li><span class="formula-highlight">d/dx [ln(x)] = 1/x</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Select <strong>sin(x)</strong> and toggle <strong>Show f'(x)</strong> &mdash; you'll see cos(x) appear</li>
                    <li>Move x to where sin(x) peaks &mdash; the slope is exactly 0</li>
                    <li>Try <strong>x&sup2;</strong> &mdash; the tangent slope increases linearly (f'(x) = 2x)</li>
                    <li>Try <strong>e&#x02E3;</strong> &mdash; uniquely, the function equals its own derivative</li>
                    <li>Try <strong>1/x</strong> &mdash; watch the tangent slope flip sign across the discontinuity at x=0</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Key Insight</h3>
                <p>The derivative transforms a position question (&ldquo;where am I?&rdquo;) into a velocity question (&ldquo;how fast am I changing?&rdquo;). Every time you look at a speedometer, you're reading a derivative.</p>
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
    "name": "Derivative Visualizer - Tangent Line Calculator",
    "description": "Interactive derivative visualization showing tangent lines, slopes, and derivative curves for common functions like sin, cos, x squared, e^x, and ln(x).",
    "url": "https://8gwifi.org/exams/visual-math/derivative.jsp",
    "educationalLevel": "High School",
    "teaches": "Derivatives, tangent lines, and instantaneous rate of change",
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
        { "@type": "ListItem", "position": 4, "name": "Derivative Visualizer" }
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
            "name": "What does the derivative tell you about a function?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The derivative f'(x) tells you the instantaneous rate of change of the function at any point x. Geometrically, it is the slope of the tangent line to the curve. When f'(x) > 0, the function is increasing; when f'(x) < 0, it is decreasing; and when f'(x) = 0, the function has a horizontal tangent (potential maximum, minimum, or inflection point)."
            }
        },
        {
            "@type": "Question",
            "name": "What is a tangent line?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A tangent line is a straight line that touches a curve at exactly one point and has the same slope as the curve at that point. The equation of the tangent line at x=a is y = f(a) + f'(a)(x - a). It represents the best linear approximation to the function near that point."
            }
        },
        {
            "@type": "Question",
            "name": "Why is e^x special in calculus?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The function e^x is the only function (up to constant multiples) that is its own derivative: d/dx[e^x] = e^x. This makes it fundamental to calculus and differential equations. It appears in compound interest, population growth, radioactive decay, and many natural processes."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-derivative.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('derivative', 'viz-canvas', { func: 'sin', xPos: 1, showDeriv: false });

    var state = VisualMath.getState();
    var FUNCS = VisualMath._derivFunctions;

    // Function radio
    document.querySelectorAll('input[name="func"]').forEach(function(r) {
        r.addEventListener('change', function() {
            state.func = this.value;
            var cfg = FUNCS[this.value];
            // Reset x slider to map to the new range
            var slider = document.getElementById('x-slider');
            var pct = parseInt(slider.value) / 100;
            state.xPos = cfg.range[0] + pct * (cfg.range[1] - cfg.range[0]);
            document.getElementById('x-display').textContent = state.xPos.toFixed(2);
            document.getElementById('x-val').textContent = state.xPos.toFixed(2);
            state._redraw();
        });
    });

    // X position slider (0-100 maps to function range)
    document.getElementById('x-slider').addEventListener('input', function() {
        var pct = parseInt(this.value) / 100;
        var cfg = FUNCS[state.func];
        state.xPos = cfg.range[0] + pct * (cfg.range[1] - cfg.range[0]);
        document.getElementById('x-display').textContent = state.xPos.toFixed(2);
        document.getElementById('x-val').textContent = state.xPos.toFixed(2);
        state._redraw();
    });

    // Show derivative curve
    document.getElementById('show-deriv').addEventListener('change', function() {
        state.showDeriv = this.checked;
        state._redraw();
    });

    // Animate — sweep point along the curve
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
        xSlider.value = 0;

        animInterval = setInterval(function() {
            var cur = parseInt(xSlider.value);
            if (cur >= 100) {
                clearInterval(animInterval); animInterval = null;
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
                return;
            }
            cur = Math.min(100, cur + 1);
            xSlider.value = cur;
            var pct = cur / 100;
            var cfg = FUNCS[state.func];
            state.xPos = cfg.range[0] + pct * (cfg.range[1] - cfg.range[0]);
            document.getElementById('x-display').textContent = state.xPos.toFixed(2);
            document.getElementById('x-val').textContent = state.xPos.toFixed(2);
            state._redraw();
        }, 60);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function() {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        state.func = 'sin'; state.xPos = 1; state.showDeriv = false;
        document.querySelector('input[name="func"][value="sin"]').checked = true;
        document.getElementById('show-deriv').checked = false;
        var xSlider = document.getElementById('x-slider');
        xSlider.value = 57; // maps to ~1.0 for sin range
        document.getElementById('x-display').textContent = '1.00';
        document.getElementById('x-val').textContent = '1.00';
        state._redraw();
    });
});
</script>
