<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Exponential & Logarithm Grapher - Interactive a^x and log_a(x) (Free)";
    String seoDescription = "Visualize exponential y=a^x and logarithmic y=log_a(x) functions side by side. Adjust the base, see key points, asymptotes, and the reflection relationship.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/exp-log.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Exponential & Logarithm Explorer\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Exponential & Logarithm Grapher\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"exponential function, logarithm graph, a^x graph, log base a, natural log ln, inverse functions, exponential growth, exponential decay, asymptote, algebra 2\">");

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
        <span class="breadcrumb-current">Exponential & Log</span>
    </nav>

    <div class="viz-header">
        <h1>Exponential & Logarithm Explorer</h1>
        <p class="viz-subtitle">Adjust the base and watch exponential growth/decay and its inverse logarithm. They reflect across y = x.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>y = a<sup>x</sup> & y = log<sub>a</sub>(x)</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="e">Base e</button>
                        <button class="vm-chip" data-preset="2">Base 2</button>
                        <button class="vm-chip" data-preset="10">Base 10</button>
                        <button class="vm-chip" data-preset="half">Base &frac12;</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Base a = <span id="base-display">2.72</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="base-slider" min="0.1" max="10" value="2.72" step="0.01">
                        <span class="viz-slider-val" id="base-val">e</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Show</label>
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="checkbox" id="show-exp" checked> y = a<sup>x</sup></label>
                        <label class="viz-check"><input type="checkbox" id="show-log" checked> y = log<sub>a</sub>(x)</label>
                        <label class="viz-check"><input type="checkbox" id="show-reflection" checked> y = x line</label>
                    </div>
                </div>

                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="animate-btn">Animate</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Properties</h3>
                <table>
                    <tr><td>Base</td><td id="val-base">--</td></tr>
                    <tr><td>Exp equation</td><td id="val-exp-eq">--</td></tr>
                    <tr><td>Log equation</td><td id="val-log-eq">--</td></tr>
                    <tr><td>Exp key pts</td><td id="val-exp-key">--</td></tr>
                    <tr><td>Log key pts</td><td id="val-log-key">--</td></tr>
                    <tr><td>Growth/Decay</td><td id="val-growth">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Exponential Functions</h3>
                <ul>
                    <li>Form: <span class="formula-highlight">y = a<sup>x</sup></span> where a &gt; 0, a &ne; 1</li>
                    <li>Always passes through <strong>(0, 1)</strong></li>
                    <li>Horizontal asymptote: <strong>y = 0</strong></li>
                    <li>a &gt; 1: exponential <strong>growth</strong></li>
                    <li>0 &lt; a &lt; 1: exponential <strong>decay</strong></li>
                    <li>Special base: <span class="formula-highlight">e &asymp; 2.718</span> (natural exponential)</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Logarithmic Functions</h3>
                <ul>
                    <li>Form: <span class="formula-highlight">y = log<sub>a</sub>(x)</span> &mdash; inverse of a<sup>x</sup></li>
                    <li>Always passes through <strong>(1, 0)</strong></li>
                    <li>Vertical asymptote: <strong>x = 0</strong></li>
                    <li>Domain: x &gt; 0 only</li>
                    <li>log<sub>a</sub>(a) = 1, log<sub>a</sub>(1) = 0</li>
                    <li>ln(x) = log<sub>e</sub>(x) &mdash; natural logarithm</li>
                </ul>
                <h3 style="margin-top:var(--space-4);">Inverse Relationship</h3>
                <ul>
                    <li>a<sup>x</sup> and log<sub>a</sub>(x) are <strong>reflections across y = x</strong></li>
                    <li>If (p, q) is on a<sup>x</sup>, then (q, p) is on log<sub>a</sub>(x)</li>
                    <li>a<sup>log<sub>a</sub>(x)</sup> = x and log<sub>a</sub>(a<sup>x</sup>) = x</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/sequences-series.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&Sigma;</div>
                <div><h4>Sequences &amp; Series</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/function-plotter.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&#119891;</div>
                <div><h4>Function Plotter</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Exponential & Logarithm Explorer","description":"Interactive grapher showing y=a^x and y=log_a(x) with adjustable base, key points, asymptotes, and reflection line.","url":"https://8gwifi.org/exams/visual-math/exp-log.jsp","educationalLevel":"High School","teaches":"Exponential functions, logarithmic functions, inverse functions, growth and decay, asymptotes","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Exponential & Log"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the difference between exponential growth and decay?","acceptedAnswer":{"@type":"Answer","text":"Exponential growth occurs when the base a > 1 — the function y = a^x increases rapidly as x increases. Exponential decay occurs when 0 < a < 1 — the function decreases toward zero. For example, 2^x grows (doubles), while (1/2)^x decays (halves)."}},{"@type":"Question","name":"Why are exponential and logarithmic functions inverses?","acceptedAnswer":{"@type":"Answer","text":"They undo each other: if y = a^x, then x = log_a(y). Graphically, they are reflections of each other across the line y = x. Every point (p, q) on the exponential becomes (q, p) on the logarithm."}},{"@type":"Question","name":"What is special about base e?","acceptedAnswer":{"@type":"Answer","text":"The number e ≈ 2.71828 is special because the derivative of e^x is itself: d/dx(e^x) = e^x. This makes it the natural base for calculus. The natural logarithm ln(x) = log_e(x) appears throughout mathematics, physics, and engineering."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-exp-log.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('exp-log', 'viz-canvas', {
        base: Math.E,
        showExp: true,
        showLog: true,
        showReflection: true
    });
    var state = VisualMath.getState();

    var presets = {
        'e':    Math.E,
        '2':    2,
        '10':   10,
        'half': 0.5
    };

    function fmtBase(b) {
        if (Math.abs(b - Math.E) < 0.01) return 'e';
        if (Math.abs(b - Math.round(b)) < 0.01) return Math.round(b).toString();
        return b.toFixed(2);
    }

    function applyPreset(key) {
        var b = presets[key];
        state.base = b;
        document.getElementById('base-slider').value = b;
        document.getElementById('base-display').textContent = b.toFixed(2);
        document.getElementById('base-val').textContent = fmtBase(b);
        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('base-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.base = v;
        document.getElementById('base-display').textContent = v.toFixed(2);
        document.getElementById('base-val').textContent = fmtBase(v);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('show-exp').addEventListener('change', function () { state.showExp = this.checked; state._redraw(); });
    document.getElementById('show-log').addEventListener('change', function () { state.showLog = this.checked; state._redraw(); });
    document.getElementById('show-reflection').addEventListener('change', function () { state.showReflection = this.checked; state._redraw(); });

    // Animate: sweep base from 0.2 to 8
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
        btn.textContent = 'Pause'; btn.classList.add('viz-btn-secondary'); btn.classList.remove('viz-btn-primary');
        state.base = 0.2;
        document.getElementById('base-slider').value = 0.2;
        animInterval = setInterval(function () {
            var cur = state.base + 0.05;
            if (Math.abs(cur - 1) < 0.05) cur = 1.05; // skip a=1
            if (cur > 8) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
            state.base = cur;
            document.getElementById('base-slider').value = cur;
            document.getElementById('base-display').textContent = cur.toFixed(2);
            document.getElementById('base-val').textContent = fmtBase(cur);
            document.querySelectorAll('[data-preset]').forEach(function (btn2) { btn2.classList.remove('active'); });
            state._redraw();
        }, 50);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        document.getElementById('show-exp').checked = true;
        document.getElementById('show-log').checked = true;
        document.getElementById('show-reflection').checked = true;
        state.showExp = true; state.showLog = true; state.showReflection = true;
        applyPreset('e');
    });
});
</script>
