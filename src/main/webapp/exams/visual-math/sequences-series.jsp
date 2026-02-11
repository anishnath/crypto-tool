<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Sequences & Series Visualizer - Arithmetic & Geometric (Free)";
    String seoDescription = "Interactive sequences and series visualizer. Compare arithmetic and geometric sequences. See terms as bars, partial sums, convergence behavior, and nth term formulas.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/sequences-series.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Sequences & Series Visualizer\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Sequences & Series Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"arithmetic sequence, geometric sequence, series sum, partial sum, convergence, divergence, nth term formula, common difference, common ratio, algebra 2\">");

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
        <span class="breadcrumb-current">Sequences &amp; Series</span>
    </nav>

    <div class="viz-header">
        <h1>Sequences &amp; Series Visualizer</h1>
        <p class="viz-subtitle">Compare arithmetic and geometric sequences. Watch terms grow as bars and track partial sums and convergence behavior.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Sequence Parameters</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="arithmetic">Arithmetic</button>
                        <button class="vm-chip" data-preset="growth">Geometric Growth</button>
                        <button class="vm-chip" data-preset="decay">Geometric Decay</button>
                        <button class="vm-chip" data-preset="alternating">Alternating</button>
                        <button class="vm-chip" data-preset="constant">Constant</button>
                    </div>
                </div>

                <div class="control-group" id="a1-group">
                    <label>First term a&#8321; = <span id="a1-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="a1-slider" min="-5" max="10" value="2" step="0.5">
                        <span class="viz-slider-val" id="a1-val">2.0</span>
                    </div>
                </div>

                <div class="control-group" id="d-group">
                    <label>Common difference d = <span id="d-display">3.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="d-slider" min="-5" max="5" value="3" step="0.5">
                        <span class="viz-slider-val" id="d-val">3.0</span>
                    </div>
                </div>

                <div class="control-group" id="r-group" style="display:none;">
                    <label>Common ratio r = <span id="r-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="r-slider" min="-3" max="3" value="2" step="0.1">
                        <span class="viz-slider-val" id="r-val">2.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Number of terms n = <span id="n-display">10</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="n-slider" min="3" max="20" value="10" step="1">
                        <span class="viz-slider-val" id="n-val">10</span>
                    </div>
                </div>

                <div class="control-group">
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="checkbox" id="show-sum" checked> Show partial sum</label>
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
                    <tr><td>Type</td><td id="val-type">--</td></tr>
                    <tr><td>Formula</td><td id="val-formula">--</td></tr>
                    <tr><td>nth term</td><td id="val-nth">--</td></tr>
                    <tr><td>Sum S&#8345;</td><td id="val-sum">--</td></tr>
                    <tr><td>Convergence</td><td id="val-convergence">--</td></tr>
                    <tr><td>First terms</td><td id="val-terms">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Arithmetic Sequences</h3>
                <ul>
                    <li>nth term: <span class="formula-highlight">a&#8345; = a&#8321; + (n-1)d</span></li>
                    <li>Sum: <span class="formula-highlight">S&#8345; = n(a&#8321; + a&#8345;) / 2</span></li>
                    <li>Constant <strong>common difference</strong> d between terms</li>
                    <li>Always <strong>diverges</strong> unless d = 0</li>
                    <li>Graph of terms is a <strong>straight line</strong></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Geometric Sequences</h3>
                <ul>
                    <li>nth term: <span class="formula-highlight">a&#8345; = a&#8321; &middot; r<sup>n-1</sup></span></li>
                    <li>Sum: <span class="formula-highlight">S&#8345; = a&#8321;(1 - r<sup>n</sup>) / (1 - r)</span>, r &ne; 1</li>
                    <li>Constant <strong>common ratio</strong> r between terms</li>
                    <li><strong>Converges</strong> if |r| &lt; 1: S&#8734; = a&#8321; / (1 - r)</li>
                    <li><strong>Diverges</strong> if |r| &ge; 1</li>
                    <li>|r| &lt; 1: terms shrink toward zero</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/exp-log.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#8495;</div>
                <div><h4>Exponential &amp; Log</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/taylor-series.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(34,197,94,0.12);">&Sigma;</div>
                <div><h4>Taylor Series</h4><span>Calculus</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8943;</div>
                <div><h4>All Visualizations</h4><span>Browse</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{"@context":"https://schema.org","@type":"LearningResource","name":"Sequences & Series Visualizer","description":"Interactive sequences and series visualizer. Compare arithmetic and geometric sequences with bar graphs, partial sums, and convergence behavior.","url":"https://8gwifi.org/exams/visual-math/sequences-series.jsp","educationalLevel":"High School","teaches":"Arithmetic sequences, geometric sequences, partial sums, convergence, nth term formula, common difference, common ratio","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Sequences & Series"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What's the difference between arithmetic and geometric sequences?","acceptedAnswer":{"@type":"Answer","text":"An arithmetic sequence has a constant difference between consecutive terms (e.g., 2, 5, 8, 11 with d=3). A geometric sequence has a constant ratio between consecutive terms (e.g., 2, 6, 18, 54 with r=3). Arithmetic sequences grow linearly while geometric sequences grow exponentially."}},{"@type":"Question","name":"When does a geometric series converge?","acceptedAnswer":{"@type":"Answer","text":"A geometric series converges (has a finite sum) when the absolute value of the common ratio is less than 1, i.e., |r| < 1. The infinite sum is S = a1 / (1 - r). For example, 1 + 1/2 + 1/4 + 1/8 + ... converges to 2. When |r| >= 1, the series diverges."}},{"@type":"Question","name":"How do you find the sum of an arithmetic series?","acceptedAnswer":{"@type":"Answer","text":"The sum of the first n terms of an arithmetic series is Sn = n(a1 + an)/2, where a1 is the first term and an is the nth term. Equivalently, Sn = n(2a1 + (n-1)d)/2 where d is the common difference. This formula works because you can pair the first and last terms, second and second-to-last, etc."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-sequences.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('sequences', 'viz-canvas', {
        seqType: 'arithmetic',
        a1: 2,
        d: 3,
        r: 2,
        n: 10,
        showSum: true
    });
    var state = VisualMath.getState();

    var presets = {
        'arithmetic':   { type: 'arithmetic', a1: 2, d: 3, r: 2, n: 10 },
        'growth':       { type: 'geometric', a1: 1, d: 3, r: 2, n: 10 },
        'decay':        { type: 'geometric', a1: 10, d: 3, r: 0.5, n: 10 },
        'alternating':  { type: 'geometric', a1: 3, d: 3, r: -0.7, n: 10 },
        'constant':     { type: 'arithmetic', a1: 5, d: 0, r: 1, n: 10 }
    };

    function showSliderGroup(seqType) {
        document.getElementById('d-group').style.display = (seqType === 'arithmetic') ? '' : 'none';
        document.getElementById('r-group').style.display = (seqType === 'geometric') ? '' : 'none';
    }

    function applyPreset(key) {
        var p = presets[key];
        state.seqType = p.type;
        state.a1 = p.a1;
        state.d = p.d;
        state.r = p.r;
        state.n = p.n;

        document.getElementById('a1-slider').value = p.a1;
        document.getElementById('a1-display').textContent = p.a1.toFixed(1);
        document.getElementById('a1-val').textContent = p.a1.toFixed(1);

        document.getElementById('d-slider').value = p.d;
        document.getElementById('d-display').textContent = p.d.toFixed(1);
        document.getElementById('d-val').textContent = p.d.toFixed(1);

        document.getElementById('r-slider').value = p.r;
        document.getElementById('r-display').textContent = p.r.toFixed(1);
        document.getElementById('r-val').textContent = p.r.toFixed(1);

        document.getElementById('n-slider').value = p.n;
        document.getElementById('n-display').textContent = p.n;
        document.getElementById('n-val').textContent = p.n;

        showSliderGroup(p.type);

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('a1-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.a1 = v;
        document.getElementById('a1-display').textContent = v.toFixed(1);
        document.getElementById('a1-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('d-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.d = v;
        document.getElementById('d-display').textContent = v.toFixed(1);
        document.getElementById('d-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('r-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.r = v;
        document.getElementById('r-display').textContent = v.toFixed(1);
        document.getElementById('r-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('n-slider').addEventListener('input', function () {
        var v = parseInt(this.value);
        state.n = v;
        document.getElementById('n-display').textContent = v;
        document.getElementById('n-val').textContent = v;
        state._redraw();
    });

    document.getElementById('show-sum').addEventListener('change', function () {
        state.showSum = this.checked;
        state._redraw();
    });

    // Animate: sweep d (arithmetic) or r (geometric)
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
        btn.textContent = 'Pause'; btn.classList.add('viz-btn-secondary'); btn.classList.remove('viz-btn-primary');

        if (state.seqType === 'arithmetic') {
            state.d = -5;
            document.getElementById('d-slider').value = -5;
            document.getElementById('d-display').textContent = '-5.0';
            document.getElementById('d-val').textContent = '-5.0';
            animInterval = setInterval(function () {
                var cur = state.d + 0.1;
                if (cur > 5) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
                state.d = cur;
                document.getElementById('d-slider').value = cur;
                document.getElementById('d-display').textContent = cur.toFixed(1);
                document.getElementById('d-val').textContent = cur.toFixed(1);
                document.querySelectorAll('[data-preset]').forEach(function (btn2) { btn2.classList.remove('active'); });
                state._redraw();
            }, 50);
        } else {
            state.r = -3;
            document.getElementById('r-slider').value = -3;
            document.getElementById('r-display').textContent = '-3.0';
            document.getElementById('r-val').textContent = '-3.0';
            animInterval = setInterval(function () {
                var cur = state.r + 0.05;
                if (Math.abs(cur - 1) < 0.05) cur = 1.05; // skip r=1
                if (cur > 3) { clearInterval(animInterval); animInterval = null; btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary'); return; }
                state.r = cur;
                document.getElementById('r-slider').value = cur;
                document.getElementById('r-display').textContent = cur.toFixed(1);
                document.getElementById('r-val').textContent = cur.toFixed(1);
                document.querySelectorAll('[data-preset]').forEach(function (btn2) { btn2.classList.remove('active'); });
                state._redraw();
            }, 50);
        }
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        document.getElementById('show-sum').checked = true;
        state.showSum = true;
        applyPreset('arithmetic');
    });
});
</script>
