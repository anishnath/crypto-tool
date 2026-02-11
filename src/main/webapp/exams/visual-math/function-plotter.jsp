<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Function Plotter - Graph Any Equation Online Free | f(x) Grapher";
    String seoDescription = "Free online function plotter. Type any equation like sin(x), x^2, or 1/x and see it graphed instantly. Plot up to 3 functions with color coding and crosshair values.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/function-plotter.jsp";

    StringBuilder extraHead=new StringBuilder();
        extraHead.append("<meta property=\"og:title\" content=\"Function Plotter - Graph Any Equation Instantly\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Function Plotter - Free Online Equation Grapher\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"function plotter, graph equation online, function grapher, plot f(x), graphing calculator, plot sin cos, polynomial grapher, math graphing tool, equation visualizer\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>
<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<style>
    .func-row {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 6px;
    }
    .func-dot {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        flex-shrink: 0;
    }
    .func-input {
        flex: 1;
        padding: 6px 8px;
        border: 1px solid var(--border-primary);
        border-radius: var(--radius-sm);
        background: var(--bg-primary);
        color: var(--text-primary);
        font-family: 'JetBrains Mono', monospace;
        font-size: var(--text-sm);
    }
    .func-input:focus {
        border-color: var(--accent-primary, #6366f1);
        outline: none;
    }
    .preset-pills {
        display: flex;
        flex-wrap: wrap;
        gap: 4px;
    }
    .preset-pill {
        padding: 4px 10px;
        border: 1px solid var(--border-primary);
        border-radius: 999px;
        background: var(--bg-secondary);
        color: var(--text-primary);
        font-size: var(--text-xs);
        font-family: 'JetBrains Mono', monospace;
        cursor: pointer;
        transition: all 0.2s;
    }
    .preset-pill:hover {
        border-color: var(--accent-primary, #6366f1);
        background: rgba(99,102,241,0.1);
    }
</style>

<div class="container">
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <a href="<%=request.getContextPath()%>/exams/visual-math/">Visual Math</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Function Plotter</span>
    </nav>

    <div class="viz-header">
        <h1>Function Plotter</h1>
        <p class="viz-subtitle">Type any expression and see it graphed live. Plot up to 3 functions and hover to read values.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Functions</h3>

                <div class="control-group">
                    <div class="func-row">
                        <span class="func-dot" style="background:#ef4444;"></span>
                        <input type="text" class="func-input" id="func-1" value="sin(x)" placeholder="e.g. sin(x)">
                    </div>
                    <div class="func-row">
                        <span class="func-dot" style="background:#3b82f6;"></span>
                        <input type="text" class="func-input" id="func-2" value="" placeholder="e.g. x^2">
                    </div>
                    <div class="func-row">
                        <span class="func-dot" style="background:#22c55e;"></span>
                        <input type="text" class="func-input" id="func-3" value="" placeholder="e.g. 1/x">
                    </div>
                </div>

                <div class="control-group">
                    <label>Presets</label>
                    <div class="preset-pills">
                        <button class="preset-pill" data-expr="sin(x)">sin(x)</button>
                        <button class="preset-pill" data-expr="cos(x)">cos(x)</button>
                        <button class="preset-pill" data-expr="tan(x)">tan(x)</button>
                        <button class="preset-pill" data-expr="x^2">x&sup2;</button>
                        <button class="preset-pill" data-expr="x^3">x&sup3;</button>
                        <button class="preset-pill" data-expr="1/x">1/x</button>
                        <button class="preset-pill" data-expr="sqrt(x)">&radic;x</button>
                        <button class="preset-pill" data-expr="e^x">e&#739;</button>
                        <button class="preset-pill" data-expr="ln(x)">ln(x)</button>
                        <button class="preset-pill" data-expr="|x|">|x|</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>X Range (&plusmn;<span id="range-display">6.28</span>)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="range-slider" min="1" max="20" value="6.28" step="0.01">
                        <span class="viz-slider-val" id="range-val">2&pi;</span>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Syntax</h3>
                <table>
                    <tr><td>Ops</td><td>+ - * / ^</td></tr>
                    <tr><td>Trig</td><td>sin cos tan</td></tr>
                    <tr><td>Other</td><td>sqrt ln exp abs</td></tr>
                    <tr><td>Const</td><td>pi e</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Supported Functions</h3>
                <ul>
                    <li><strong>Trig:</strong> sin, cos, tan, asin, acos, atan</li>
                    <li><strong>Hyperbolic:</strong> sinh, cosh, tanh</li>
                    <li><strong>Logarithmic:</strong> ln (natural log), log10, log2</li>
                    <li><strong>Other:</strong> sqrt, abs, exp, floor, ceil, sign</li>
                    <li><strong>Constants:</strong> pi (&pi; = 3.14159...), e (2.71828...)</li>
                    <li>Implicit multiplication: <strong>2x</strong> means 2&middot;x, <strong>2sin(x)</strong> means 2&middot;sin(x)</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Try This</h3>
                <ul>
                    <li>Plot <strong>sin(x)</strong> and <strong>cos(x)</strong> together &mdash; notice they're shifted by &pi;/2</li>
                    <li>Plot <strong>x^2</strong> and <strong>x^3</strong> &mdash; see how they differ for |x| &lt; 1 vs |x| &gt; 1</li>
                    <li>Plot <strong>1/x</strong> &mdash; notice the vertical asymptote at x=0</li>
                    <li>Plot <strong>sin(x)/x</strong> &mdash; the famous sinc function</li>
                    <li>Hover over the graph to read exact function values at any point</li>
                </ul>
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
            <a href="<%=request.getContextPath()%>/exams/visual-math/quadratic.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#8994;</div>
                <div><h4>Quadratic Explorer</h4><span>Algebra</span></div>
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
    "name": "Function Plotter",
    "description": "Interactive function grapher supporting trig, exponential, logarithmic, and polynomial functions with crosshair readout.",
    "url": "https://8gwifi.org/exams/visual-math/function-plotter.jsp",
    "educationalLevel": "High School",
    "teaches": "Function graphing and analysis",
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
        { "@type": "ListItem", "position": 4, "name": "Function Plotter" }
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
            "name": "What functions can I plot?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "You can plot any combination of standard math functions: sin, cos, tan, arcsin, arccos, arctan, sinh, cosh, tanh, ln, log10, log2, sqrt, abs, exp, floor, ceil. Constants pi and e are supported. Use ^ for exponents."
            }
        },
        {
            "@type": "Question",
            "name": "How do I plot multiple functions at once?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Enter expressions in up to three function fields (f1, f2, f3). Each is plotted in a different color: red, blue, and green. Leave a field empty to hide it."
            }
        },
        {
            "@type": "Question",
            "name": "Does this support implicit multiplication?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes. You can write 2x instead of 2*x, and 2sin(x) instead of 2*sin(x). The parser handles implicit multiplication between numbers and variables or functions."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-function.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('function-plotter', 'viz-canvas', {
        exprs: ['sin(x)', '', ''], xMin: -6.28, xMax: 6.28
    });

    // Function inputs
    var ids = ['func-1', 'func-2', 'func-3'];
    ids.forEach(function(id, idx) {
        document.getElementById(id).addEventListener('input', function() {
            VisualMath.getState().exprs[idx] = this.value.trim();
            VisualMath.getState()._redraw();
        });
    });

    // Preset pills fill the first empty slot (or f1)
    document.querySelectorAll('.preset-pill').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var expr = this.getAttribute('data-expr');
            var target = 0;
            for (var i = 0; i < 3; i++) {
                if (!document.getElementById(ids[i]).value.trim()) { target = i; break; }
            }
            document.getElementById(ids[target]).value = expr;
            VisualMath.getState().exprs[target] = expr;
            VisualMath.getState()._redraw();
        });
    });

    // Range slider
    var rangeSlider = document.getElementById('range-slider');
    rangeSlider.addEventListener('input', function() {
        var v = parseFloat(this.value);
        updateRangeDisplay(v);
        VisualMath.getState().xMin = -v;
        VisualMath.getState().xMax = v;
        VisualMath.getState()._redraw();
    });

    function updateRangeDisplay(v) {
        document.getElementById('range-display').textContent = v.toFixed(2);
        document.getElementById('range-val').textContent = v < 3.2 ? v.toFixed(1) : (v < 6.5 ? '2\u03C0' : v.toFixed(0));
    }

    // Animate — zoom x-range from 1 to 20
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

        rangeSlider.value = 1;
        var state = VisualMath.getState();

        animInterval = setInterval(function() {
            var cur = parseFloat(rangeSlider.value);
            if (cur >= 20) {
                clearInterval(animInterval); animInterval = null;
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
                return;
            }
            cur = Math.min(20, cur + 0.15);
            rangeSlider.value = cur;
            updateRangeDisplay(cur);
            state.xMin = -cur;
            state.xMax = cur;
            state._redraw();
        }, 50);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function() {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        var state = VisualMath.getState();
        state.exprs = ['sin(x)', '', ''];
        state.xMin = -6.28; state.xMax = 6.28;
        document.getElementById('func-1').value = 'sin(x)';
        document.getElementById('func-2').value = '';
        document.getElementById('func-3').value = '';
        rangeSlider.value = 6.28;
        updateRangeDisplay(6.28);
        state._redraw();
    });
});
</script>
