<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Geometric Transformations - Translate, Rotate, Reflect, Dilate (Free)";
    String seoDescription = "Interactive geometry transformation tool. Apply translations, rotations, reflections, and dilations to shapes. See original and transformed figures with mapping rules.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/transformations.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Geometric Transformations - Translate, Rotate, Reflect, Dilate\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Geometric Transformations Visualizer\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"geometric transformations, translation geometry, rotation geometry, reflection geometry, dilation geometry, isometry, transformation rules, coordinate geometry, rigid motions, similarity transformations\">");

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
        <span class="breadcrumb-current">Transformations</span>
    </nav>

    <div class="viz-header">
        <h1>Geometric Transformations</h1>
        <p class="viz-subtitle">Pick a transformation type and adjust the parameters. See the original shape (blue) and its image (orange) with the mapping rule displayed live.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Transform</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="translateR">Translate Right</button>
                        <button class="vm-chip" data-preset="rotate90">Rotate 90&deg;</button>
                        <button class="vm-chip" data-preset="reflectX">Reflect x-axis</button>
                        <button class="vm-chip" data-preset="dilate2">Dilate &times;2</button>
                        <button class="vm-chip" data-preset="rotate45">Rotate 45&deg;</button>
                    </div>
                </div>

                <!-- Translate controls -->
                <div class="control-group param-group" id="params-translate">
                    <label>tx = <span id="tx-display">3.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="tx-slider" min="-6" max="6" value="3" step="0.1">
                        <span class="viz-slider-val" id="tx-val">3.0</span>
                    </div>
                    <label style="margin-top:8px;">ty = <span id="ty-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="ty-slider" min="-6" max="6" value="2" step="0.1">
                        <span class="viz-slider-val" id="ty-val">2.0</span>
                    </div>
                </div>

                <!-- Rotate controls -->
                <div class="control-group param-group" id="params-rotate" style="display:none;">
                    <label>Angle = <span id="angle-display">90</span>&deg;</label>
                    <div class="viz-slider-row">
                        <input type="range" id="angle-slider" min="0" max="360" value="90" step="1">
                        <span class="viz-slider-val" id="angle-val">90</span>
                    </div>
                </div>

                <!-- Reflect controls -->
                <div class="control-group param-group" id="params-reflect" style="display:none;">
                    <label>Reflect across</label>
                    <div class="viz-check-group" style="flex-direction:column;">
                        <label class="viz-check"><input type="radio" name="reflect-axis" value="x" checked> x-axis</label>
                        <label class="viz-check"><input type="radio" name="reflect-axis" value="y"> y-axis</label>
                        <label class="viz-check"><input type="radio" name="reflect-axis" value="yx"> y = x</label>
                    </div>
                </div>

                <!-- Dilate controls -->
                <div class="control-group param-group" id="params-dilate" style="display:none;">
                    <label>Scale factor = <span id="scale-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="scale-slider" min="0.2" max="3" value="2" step="0.1">
                        <span class="viz-slider-val" id="scale-val">2.0</span>
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
                    <tr><td>Transform</td><td id="val-transform">&mdash;</td></tr>
                    <tr><td>Rule</td><td id="val-rule">&mdash;</td></tr>
                    <tr><td>Parameters</td><td id="val-params">&mdash;</td></tr>
                    <tr><td>Preserves</td><td id="val-preserves">&mdash;</td></tr>
                    <tr><td>Isometry</td><td id="val-isometry">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Translation &amp; Rotation</h3>
                <ul>
                    <li><strong>Translation:</strong> <span class="formula-highlight">(x, y) &rarr; (x + tx, y + ty)</span></li>
                    <li>Every point shifts by the same vector (tx, ty)</li>
                    <li>Preserves shape, size, and orientation</li>
                    <li><strong>Rotation by &theta;:</strong> <span class="formula-highlight">(x, y) &rarr; (x cos&theta; - y sin&theta;, x sin&theta; + y cos&theta;)</span></li>
                    <li>Center of rotation is the origin</li>
                    <li>Preserves shape, size, and distances</li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Reflection &amp; Dilation</h3>
                <ul>
                    <li><strong>Reflect across x-axis:</strong> <span class="formula-highlight">(x, y) &rarr; (x, -y)</span></li>
                    <li><strong>Reflect across y-axis:</strong> <span class="formula-highlight">(x, y) &rarr; (-x, y)</span></li>
                    <li><strong>Reflect across y = x:</strong> <span class="formula-highlight">(x, y) &rarr; (y, x)</span></li>
                    <li>Reflections preserve size but reverse orientation</li>
                    <li><strong>Dilation by factor k:</strong> <span class="formula-highlight">(x, y) &rarr; (kx, ky)</span></li>
                    <li>Preserves shape and angles but scales distances by |k|</li>
                    <li><strong>Isometries</strong> (distance-preserving): translation, rotation, reflection. <strong>Not</strong> dilation.</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/matrix-transform.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(59,130,246,0.12);">&#9638;</div>
                <div><h4>Matrix Transforms</h4><span>Linear Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/3d-shapes.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(236,72,153,0.12);">&#9724;</div>
                <div><h4>3D Shapes</h4><span>Geometry</span></div>
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
    "name": "Geometric Transformations Visualizer",
    "description": "Interactive geometry transformation tool. Apply translations, rotations, reflections, and dilations to shapes and see mapping rules in real time.",
    "url": "https://8gwifi.org/exams/visual-math/transformations.jsp",
    "educationalLevel": "High School",
    "teaches": "Geometric transformations: translation, rotation, reflection, and dilation with coordinate mapping rules",
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
        { "@type": "ListItem", "position": 4, "name": "Transformations" }
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
            "name": "What is a geometric transformation?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A geometric transformation is a function that maps every point of a shape to a new location in the plane. The four main types are translation (sliding), rotation (turning), reflection (flipping), and dilation (scaling). Transformations that preserve distances are called isometries."
            }
        },
        {
            "@type": "Question",
            "name": "What is an isometry?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "An isometry is a transformation that preserves distances between points. Translations, rotations, and reflections are all isometries — the image is always congruent to the original. Dilation is NOT an isometry because it changes the size of the figure, though it preserves the shape (angles and proportions)."
            }
        },
        {
            "@type": "Question",
            "name": "How does dilation differ from other transformations?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Dilation scales every point away from (or toward) a center by a constant factor k. Unlike translations, rotations, and reflections, dilation changes the size of the figure. If k > 1 the figure enlarges, if 0 < k < 1 it shrinks, and if k < 0 it also flips. Dilation preserves angles and shape (similarity) but not distances (congruence)."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-transform-geo.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('transform-geo', 'viz-canvas', {
        transformType: 'translate', tx: 3, ty: 2, angle: 0, scaleFactor: 1, reflectAxis: 'x'
    });
    var state = VisualMath.getState();

    var presets = {
        'translateR': { type: 'translate',  tx: 3,  ty: 2 },
        'rotate90':   { type: 'rotate',     angle: 90 },
        'reflectX':   { type: 'reflect',    reflectAxis: 'x' },
        'dilate2':    { type: 'dilate',     scaleFactor: 2 },
        'rotate45':   { type: 'rotate',     angle: 45 }
    };

    function showParamGroup(type) {
        document.querySelectorAll('.param-group').forEach(function (el) { el.style.display = 'none'; });
        var target = document.getElementById('params-' + type);
        if (target) target.style.display = '';
    }

    function applyPreset(key) {
        var p = presets[key];
        state.transformType = p.type;

        if (p.type === 'translate') {
            state.tx = p.tx; state.ty = p.ty;
            document.getElementById('tx-slider').value = p.tx;
            document.getElementById('tx-display').textContent = p.tx.toFixed(1);
            document.getElementById('tx-val').textContent = p.tx.toFixed(1);
            document.getElementById('ty-slider').value = p.ty;
            document.getElementById('ty-display').textContent = p.ty.toFixed(1);
            document.getElementById('ty-val').textContent = p.ty.toFixed(1);
        } else if (p.type === 'rotate') {
            state.angle = p.angle;
            document.getElementById('angle-slider').value = p.angle;
            document.getElementById('angle-display').textContent = p.angle;
            document.getElementById('angle-val').textContent = p.angle;
        } else if (p.type === 'reflect') {
            state.reflectAxis = p.reflectAxis;
            document.querySelectorAll('[name="reflect-axis"]').forEach(function (r) {
                r.checked = (r.value === p.reflectAxis);
            });
        } else if (p.type === 'dilate') {
            state.scaleFactor = p.scaleFactor;
            document.getElementById('scale-slider').value = p.scaleFactor;
            document.getElementById('scale-display').textContent = p.scaleFactor.toFixed(1);
            document.getElementById('scale-val').textContent = p.scaleFactor.toFixed(1);
        }

        showParamGroup(p.type);

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });

        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    // Translate sliders
    document.getElementById('tx-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.tx = v;
        document.getElementById('tx-display').textContent = v.toFixed(1);
        document.getElementById('tx-val').textContent = v.toFixed(1);
        state._redraw();
    });
    document.getElementById('ty-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.ty = v;
        document.getElementById('ty-display').textContent = v.toFixed(1);
        document.getElementById('ty-val').textContent = v.toFixed(1);
        state._redraw();
    });

    // Rotate slider
    document.getElementById('angle-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.angle = v;
        document.getElementById('angle-display').textContent = Math.round(v);
        document.getElementById('angle-val').textContent = Math.round(v);
        state._redraw();
    });

    // Reflect radios
    document.querySelectorAll('[name="reflect-axis"]').forEach(function (r) {
        r.addEventListener('change', function () {
            state.reflectAxis = this.value;
            state._redraw();
        });
    });

    // Dilate slider
    document.getElementById('scale-slider').addEventListener('input', function () {
        var v = parseFloat(this.value);
        state.scaleFactor = v;
        document.getElementById('scale-display').textContent = v.toFixed(1);
        document.getElementById('scale-val').textContent = v.toFixed(1);
        state._redraw();
    });

    // Animate — sweeps the main parameter depending on type
    var animInterval = null;
    var animBtn = document.getElementById('animate-btn');
    animBtn.addEventListener('click', function () {
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

        var type = state.transformType;

        if (type === 'rotate') {
            state.angle = 0;
            document.getElementById('angle-slider').value = 0;
            document.getElementById('angle-display').textContent = '0';
            document.getElementById('angle-val').textContent = '0';
            animInterval = setInterval(function () {
                var cur = state.angle + 2;
                if (cur > 360) {
                    clearInterval(animInterval); animInterval = null;
                    animBtn.textContent = 'Animate'; animBtn.classList.remove('viz-btn-secondary'); animBtn.classList.add('viz-btn-primary');
                    return;
                }
                state.angle = cur;
                document.getElementById('angle-slider').value = cur;
                document.getElementById('angle-display').textContent = Math.round(cur);
                document.getElementById('angle-val').textContent = Math.round(cur);
                state._redraw();
            }, 50);
        } else if (type === 'translate') {
            state.tx = -6;
            document.getElementById('tx-slider').value = -6;
            document.getElementById('tx-display').textContent = '-6.0';
            document.getElementById('tx-val').textContent = '-6.0';
            animInterval = setInterval(function () {
                var cur = state.tx + 0.15;
                if (cur > 6) {
                    clearInterval(animInterval); animInterval = null;
                    animBtn.textContent = 'Animate'; animBtn.classList.remove('viz-btn-secondary'); animBtn.classList.add('viz-btn-primary');
                    return;
                }
                state.tx = cur;
                document.getElementById('tx-slider').value = cur;
                document.getElementById('tx-display').textContent = cur.toFixed(1);
                document.getElementById('tx-val').textContent = cur.toFixed(1);
                state._redraw();
            }, 50);
        } else if (type === 'dilate') {
            state.scaleFactor = 0.2;
            document.getElementById('scale-slider').value = 0.2;
            document.getElementById('scale-display').textContent = '0.2';
            document.getElementById('scale-val').textContent = '0.2';
            animInterval = setInterval(function () {
                var cur = state.scaleFactor + 0.03;
                if (cur > 3) {
                    clearInterval(animInterval); animInterval = null;
                    animBtn.textContent = 'Animate'; animBtn.classList.remove('viz-btn-secondary'); animBtn.classList.add('viz-btn-primary');
                    return;
                }
                state.scaleFactor = cur;
                document.getElementById('scale-slider').value = cur;
                document.getElementById('scale-display').textContent = cur.toFixed(1);
                document.getElementById('scale-val').textContent = cur.toFixed(1);
                state._redraw();
            }, 50);
        } else {
            // reflect — cycle through axes
            var axes = ['x', 'y', 'yx'];
            var idx = 0;
            animInterval = setInterval(function () {
                idx = (idx + 1) % axes.length;
                state.reflectAxis = axes[idx];
                document.querySelectorAll('[name="reflect-axis"]').forEach(function (r) {
                    r.checked = (r.value === axes[idx]);
                });
                state._redraw();
            }, 1000);
        }
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');
        applyPreset('translateR');
    });
});
</script>
