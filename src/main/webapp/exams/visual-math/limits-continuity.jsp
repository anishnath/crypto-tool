<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Limits & Continuity Visualizer - Epsilon-Delta, Discontinuities (Free)";
    String seoDescription = "Interactive limits and continuity visualizer. Explore removable, jump, infinite, and oscillating discontinuities. See epsilon-delta bands animate as a point approaches the limit.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/limits-continuity.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Limits & Continuity Visualizer - Epsilon-Delta, Discontinuities\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Limits & Continuity Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"limits, continuity, epsilon delta, removable discontinuity, jump discontinuity, calculus limits, left hand limit, right hand limit\">");

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
        <span class="breadcrumb-current">Limits &amp; Continuity</span>
    </nav>

    <div class="viz-header">
        <h1>Limits &amp; Continuity Visualizer</h1>
        <p class="viz-subtitle">Explore removable, jump, infinite, and oscillating discontinuities. Watch two dots approach the limit point and see epsilon-delta bands in action.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Limit Explorer</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="removable">Removable</button>
                        <button class="vm-chip" data-preset="jump">Jump</button>
                        <button class="vm-chip" data-preset="infinite">Infinite</button>
                        <button class="vm-chip" data-preset="oscillating">Oscillating</button>
                        <button class="vm-chip" data-preset="continuous">Continuous</button>
                    </div>
                </div>

                <div class="control-group" id="approachx-group">
                    <label>Approach x = c = <span id="approachx-display">1.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="approachx-slider" min="-3" max="3" value="1" step="0.5">
                        <span class="viz-slider-val" id="approachx-val">1.0</span>
                    </div>
                </div>

                <div class="control-group" id="epsilon-group">
                    <label>Epsilon &epsilon; = <span id="epsilon-display">0.5</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="epsilon-slider" min="0.1" max="2" value="0.5" step="0.1">
                        <span class="viz-slider-val" id="epsilon-val">0.5</span>
                    </div>
                </div>

                <div class="control-group">
                    <div class="viz-check-group">
                        <label class="viz-check"><input type="checkbox" id="show-epsdelta" checked> Show &epsilon;-&delta; bands</label>
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
                    <tr><td>Function</td><td id="val-func">--</td></tr>
                    <tr><td>Left limit</td><td id="val-left-lim">--</td></tr>
                    <tr><td>Right limit</td><td id="val-right-lim">--</td></tr>
                    <tr><td>Limit</td><td id="val-limit">--</td></tr>
                    <tr><td>Continuous?</td><td id="val-continuous">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Limits</h3>
                <ul>
                    <li>Definition: <span class="formula-highlight">lim<sub>x&rarr;c</sub> f(x) = L</span> means f(x) gets arbitrarily close to L as x approaches c</li>
                    <li><strong>Left-hand limit</strong>: <span class="formula-highlight">lim<sub>x&rarr;c<sup>&minus;</sup></sub> f(x)</span> &mdash; approaching from the left</li>
                    <li><strong>Right-hand limit</strong>: <span class="formula-highlight">lim<sub>x&rarr;c<sup>+</sup></sub> f(x)</span> &mdash; approaching from the right</li>
                    <li>The limit exists if and only if <strong>left = right</strong></li>
                    <li><strong>&epsilon;-&delta; definition</strong>: for every &epsilon; &gt; 0, there exists &delta; &gt; 0 such that |x - c| &lt; &delta; implies |f(x) - L| &lt; &epsilon;</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Types of Discontinuity</h3>
                <ul>
                    <li><strong>Removable</strong>: a &ldquo;hole&rdquo; in the graph &mdash; limit exists but f(c) is undefined or &ne; L</li>
                    <li><strong>Jump</strong>: left-hand limit &ne; right-hand limit &mdash; the function &ldquo;jumps&rdquo;</li>
                    <li><strong>Infinite</strong>: f(x) &rarr; &pm;&infin; as x &rarr; c &mdash; vertical asymptote</li>
                    <li><strong>Oscillating</strong>: f(x) = sin(1/x) near 0 &mdash; oscillates too wildly for a limit to exist</li>
                    <li>A function is <strong>continuous</strong> at c if f(c) = lim<sub>x&rarr;c</sub> f(x)</li>
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
{"@context":"https://schema.org","@type":"LearningResource","name":"Limits & Continuity Visualizer","description":"Interactive limits and continuity visualizer. Explore removable, jump, infinite, and oscillating discontinuities with epsilon-delta bands and animated approach.","url":"https://8gwifi.org/exams/visual-math/limits-continuity.jsp","educationalLevel":"High School","teaches":"Limits, continuity, epsilon-delta definition, removable discontinuity, jump discontinuity, infinite discontinuity, oscillating discontinuity, left-hand and right-hand limits","learningResourceType":"Interactive visualization","publisher":{"@type":"Organization","name":"8gwifi.org"}}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Exams","item":"https://8gwifi.org/exams/"},{"@type":"ListItem","position":3,"name":"Visual Math Lab","item":"https://8gwifi.org/exams/visual-math/"},{"@type":"ListItem","position":4,"name":"Limits & Continuity"}]}
</script>
<script type="application/ld+json">
{"@context":"https://schema.org","@type":"FAQPage","mainEntity":[{"@type":"Question","name":"What is the epsilon-delta definition of a limit?","acceptedAnswer":{"@type":"Answer","text":"The epsilon-delta definition states that lim(x\u2192c) f(x) = L if for every \u03b5 > 0, there exists a \u03b4 > 0 such that whenever 0 < |x - c| < \u03b4, we have |f(x) - L| < \u03b5. In other words, we can make f(x) as close to L as we want (\u03b5-close) by making x sufficiently close to c (\u03b4-close). The visualization shows these bands graphically."}},{"@type":"Question","name":"What types of discontinuities exist?","acceptedAnswer":{"@type":"Answer","text":"There are four main types: (1) Removable \u2014 the limit exists but f(c) is either undefined or differs from the limit (a \u2018hole\u2019). (2) Jump \u2014 the left-hand and right-hand limits both exist but are not equal. (3) Infinite \u2014 the function approaches positive or negative infinity (a vertical asymptote). (4) Oscillating \u2014 the function oscillates too rapidly near c for any limit to exist, such as sin(1/x) near x = 0."}},{"@type":"Question","name":"When does a limit not exist?","acceptedAnswer":{"@type":"Answer","text":"A limit does not exist when: (1) the left-hand and right-hand limits are different (jump discontinuity), (2) the function approaches infinity (infinite discontinuity), (3) the function oscillates without settling on a value (oscillating discontinuity), or (4) the function behaves erratically near the point. For a limit to exist, both one-sided limits must exist and be equal."}}]}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-limits.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('limits', 'viz-canvas', {
        funcType: 'removable',
        approachX: 1,
        epsilon: 0.5,
        showEpsDelta: true,
        animating: false,
        animT: 0
    });
    var state = VisualMath.getState();

    var presets = {
        'removable':   { funcType: 'removable',   approachX: 1,  epsilon: 0.5, showEpsDelta: true },
        'jump':        { funcType: 'jump',         approachX: 0,  epsilon: 0.5, showEpsDelta: true },
        'infinite':    { funcType: 'infinite',     approachX: 0,  epsilon: 0.5, showEpsDelta: false },
        'oscillating': { funcType: 'oscillating',  approachX: 0,  epsilon: 0.5, showEpsDelta: false },
        'continuous':  { funcType: 'continuous',   approachX: 1,  epsilon: 0.5, showEpsDelta: true }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.funcType = p.funcType;
        state.approachX = p.approachX;
        state.epsilon = p.epsilon;
        state.showEpsDelta = p.showEpsDelta;
        state.animating = false;
        state.animT = 0;

        document.getElementById('approachx-slider').value = p.approachX;
        document.getElementById('approachx-display').textContent = p.approachX.toFixed(1);
        document.getElementById('approachx-val').textContent = p.approachX.toFixed(1);

        document.getElementById('epsilon-slider').value = p.epsilon;
        document.getElementById('epsilon-display').textContent = p.epsilon.toFixed(1);
        document.getElementById('epsilon-val').textContent = p.epsilon.toFixed(1);

        document.getElementById('show-epsdelta').checked = p.showEpsDelta;

        // Reset animate button
        var animBtn = document.getElementById('animate-btn');
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });
        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    document.getElementById('approachx-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.approachX = v;
        document.getElementById('approachx-display').textContent = v.toFixed(1);
        document.getElementById('approachx-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('epsilon-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.epsilon = v;
        document.getElementById('epsilon-display').textContent = v.toFixed(1);
        document.getElementById('epsilon-val').textContent = v.toFixed(1);
        document.querySelectorAll('[data-preset]').forEach(function (btn) { btn.classList.remove('active'); });
        state._redraw();
    });

    document.getElementById('show-epsdelta').addEventListener('change', function () {
        state.showEpsDelta = this.checked;
        state._redraw();
    });

    // Animate: sweep two dots from far away toward the approach point
    var animInterval = null;
    document.getElementById('animate-btn').addEventListener('click', function () {
        var btn = this;
        if (animInterval) {
            // Pause
            clearInterval(animInterval);
            animInterval = null;
            state.animating = false;
            btn.textContent = 'Animate';
            btn.classList.remove('viz-btn-secondary');
            btn.classList.add('viz-btn-primary');
            return;
        }
        // Start animation
        btn.textContent = 'Pause';
        btn.classList.add('viz-btn-secondary');
        btn.classList.remove('viz-btn-primary');
        state.animating = true;
        state.animT = 0;
        animInterval = setInterval(function () {
            state.animT += 0.02;
            if (state.animT > 1) {
                clearInterval(animInterval);
                animInterval = null;
                state.animating = false;
                btn.textContent = 'Animate';
                btn.classList.remove('viz-btn-secondary');
                btn.classList.add('viz-btn-primary');
                return;
            }
            state._redraw();
        }, 20);
    });

    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        state.animating = false;
        state.animT = 0;
        var btn = document.getElementById('animate-btn');
        btn.textContent = 'Animate'; btn.classList.remove('viz-btn-secondary'); btn.classList.add('viz-btn-primary');
        applyPreset('removable');
    });
});
</script>
