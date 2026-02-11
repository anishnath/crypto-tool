<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Conic Sections Explorer - Ellipse, Hyperbola, Parabola, Circle (Free)";
    String seoDescription = "Interactive conic sections grapher. Explore ellipses, hyperbolas, parabolas, and circles. See foci, vertices, eccentricity, asymptotes, and directrices.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/conic-sections.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Conic Sections Explorer - Ellipse, Hyperbola, Parabola, Circle\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Conic Sections Explorer - Interactive Grapher\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"conic sections, ellipse grapher, hyperbola grapher, parabola grapher, eccentricity calculator, foci calculator, conic equation, directrix, asymptotes, circle equation\">");

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
        <span class="breadcrumb-current">Conic Sections</span>
    </nav>

    <div class="viz-header">
        <h1>Conic Sections Explorer</h1>
        <p class="viz-subtitle">Pick a conic type and adjust the semi-axes. Watch foci, vertices, eccentricity, and directrices update in real-time.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Conic Type</h3>

                <div class="control-group">
                    <label>Presets</label>
                    <div style="display:flex;flex-wrap:wrap;gap:6px;">
                        <button class="vm-chip active" data-preset="ellipse">Ellipse</button>
                        <button class="vm-chip" data-preset="circle">Circle</button>
                        <button class="vm-chip" data-preset="hyperbola">Hyperbola</button>
                        <button class="vm-chip" data-preset="parabola">Parabola</button>
                        <button class="vm-chip" data-preset="wide">Wide Ellipse</button>
                    </div>
                </div>

                <div class="control-group">
                    <label>Semi-axis a = <span id="a-display">3.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="a-slider" min="0.5" max="6" value="3" step="0.1">
                        <span class="viz-slider-val" id="a-val">3.0</span>
                    </div>
                </div>

                <div class="control-group" id="b-group">
                    <label id="b-label">Semi-axis b = <span id="b-display">2.0</span></label>
                    <div class="viz-slider-row">
                        <input type="range" id="b-slider" min="0.5" max="6" value="2" step="0.1">
                        <span class="viz-slider-val" id="b-val">2.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <div class="viz-check-group">
                        <label class="viz-check">
                            <input type="checkbox" id="show-directrix">
                            Show directrices
                        </label>
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
                    <tr><td>Type</td><td id="val-type">&mdash;</td></tr>
                    <tr><td>Equation</td><td id="val-equation">&mdash;</td></tr>
                    <tr><td>Foci</td><td id="val-foci">&mdash;</td></tr>
                    <tr><td>Eccentricity</td><td id="val-eccentricity">&mdash;</td></tr>
                    <tr><td>Vertices</td><td id="val-vertices">&mdash;</td></tr>
                    <tr><td>Extra</td><td id="val-extra">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Math Behind It</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Conic Sections</h3>
                <ul>
                    <li>General second-degree equation: <span class="formula-highlight">Ax&sup2; + Bxy + Cy&sup2; + Dx + Ey + F = 0</span></li>
                    <li><strong>Circle (e = 0):</strong> <span class="formula-highlight">x&sup2; + y&sup2; = r&sup2;</span> &mdash; all points equidistant from center</li>
                    <li><strong>Ellipse (0 &lt; e &lt; 1):</strong> <span class="formula-highlight">x&sup2;/a&sup2; + y&sup2;/b&sup2; = 1</span></li>
                    <li>Foci of ellipse: <span class="formula-highlight">c = &radic;(a&sup2; - b&sup2;)</span> when a &gt; b</li>
                    <li>Eccentricity: <span class="formula-highlight">e = c/a</span></li>
                </ul>
            </div>
            <div class="viz-math-col">
                <h3>Hyperbola &amp; Parabola</h3>
                <ul>
                    <li><strong>Hyperbola (e &gt; 1):</strong> <span class="formula-highlight">x&sup2;/a&sup2; - y&sup2;/b&sup2; = 1</span></li>
                    <li>Foci of hyperbola: <span class="formula-highlight">c = &radic;(a&sup2; + b&sup2;)</span></li>
                    <li>Asymptotes: <span class="formula-highlight">y = &plusmn;(b/a)x</span></li>
                    <li><strong>Parabola (e = 1):</strong> <span class="formula-highlight">y&sup2; = 4px</span></li>
                    <li>Focus at (p, 0), directrix at x = -p</li>
                    <li>Relationship: <span class="formula-highlight">c&sup2; = a&sup2; &plusmn; b&sup2;</span> (+ for hyperbola, - for ellipse)</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/quadratic.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#8994;</div>
                <div><h4>Quadratic Explorer</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/polynomial-roots.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#119909;</div>
                <div><h4>Polynomial Roots</h4><span>Algebra</span></div>
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
    "name": "Conic Sections Explorer",
    "description": "Interactive conic sections grapher. Explore ellipses, hyperbolas, parabolas, and circles with foci, vertices, eccentricity, asymptotes, and directrices.",
    "url": "https://8gwifi.org/exams/visual-math/conic-sections.jsp",
    "educationalLevel": "High School",
    "teaches": "Conic sections, eccentricity, foci, vertices, directrices, and the relationship between ellipses, hyperbolas, parabolas, and circles",
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
        { "@type": "ListItem", "position": 4, "name": "Conic Sections" }
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
            "name": "What is eccentricity?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Eccentricity (e) is a number that describes how much a conic section deviates from being circular. A circle has e = 0, an ellipse has 0 < e < 1, a parabola has e = 1, and a hyperbola has e > 1. It is defined as e = c/a where c is the distance from the center to a focus and a is the semi-major axis."
            }
        },
        {
            "@type": "Question",
            "name": "How are foci related to the shape?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The foci are special fixed points that define each conic. For an ellipse, the sum of distances from any point on the curve to the two foci is constant (2a). For a hyperbola, the absolute difference of distances to the foci is constant (2a). For a parabola, every point is equidistant from the single focus and the directrix. Moving the foci closer together makes an ellipse more circular; moving them apart increases eccentricity."
            }
        },
        {
            "@type": "Question",
            "name": "What makes a conic section?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A conic section is the curve formed by intersecting a plane with a double cone. The angle of the plane relative to the cone determines the shape: a horizontal cut gives a circle, a tilted cut gives an ellipse, a cut parallel to the side gives a parabola, and a steep cut that intersects both halves of the cone gives a hyperbola."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-conics.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('conics', 'viz-canvas', { conicType: 'ellipse', a: 3, b: 2, showDirectrix: false });
    var state = VisualMath.getState();

    var presets = {
        'ellipse':    { type: 'ellipse',   a: 3,   b: 2 },
        'circle':     { type: 'circle',    a: 3,   b: 3 },
        'hyperbola':  { type: 'hyperbola', a: 2,   b: 1.5 },
        'parabola':   { type: 'parabola',  a: 1.5, b: 0 },
        'wide':       { type: 'ellipse',   a: 5,   b: 1.5 }
    };

    function applyPreset(key) {
        var p = presets[key];
        state.conicType = p.type;
        state.a = p.a;
        state.b = p.b;

        document.getElementById('a-slider').value = p.a;
        document.getElementById('a-display').textContent = p.a.toFixed(1);
        document.getElementById('a-val').textContent = p.a.toFixed(1);

        document.getElementById('b-slider').value = p.b;
        document.getElementById('b-display').textContent = p.b.toFixed(1);
        document.getElementById('b-val').textContent = p.b.toFixed(1);

        // Hide b slider for circle and parabola
        var bGroup = document.getElementById('b-group');
        var bLabel = document.getElementById('b-label');
        if (p.type === 'circle' || p.type === 'parabola') {
            bGroup.style.display = 'none';
        } else {
            bGroup.style.display = '';
        }
        if (p.type === 'parabola') {
            bLabel.innerHTML = 'Focus distance p = <span id="b-display">' + p.b.toFixed(1) + '</span>';
        } else {
            bLabel.innerHTML = 'Semi-axis b = <span id="b-display">' + p.b.toFixed(1) + '</span>';
        }

        document.querySelectorAll('[data-preset]').forEach(function (btn) {
            btn.classList.toggle('active', btn.getAttribute('data-preset') === key);
        });

        state._redraw();
    }

    document.querySelectorAll('[data-preset]').forEach(function (btn) {
        btn.addEventListener('click', function () { applyPreset(this.getAttribute('data-preset')); });
    });

    function bindSlider(id, prop) {
        document.getElementById(id).addEventListener('input', function () {
            var v = parseFloat(this.value);
            state[prop] = v;
            document.getElementById(prop + '-display').textContent = v.toFixed(1);
            document.getElementById(prop + '-val').textContent = v.toFixed(1);
            state._redraw();
        });
    }

    bindSlider('a-slider', 'a');
    bindSlider('b-slider', 'b');

    // Show directrix checkbox
    document.getElementById('show-directrix').addEventListener('change', function () {
        state.showDirectrix = this.checked;
        state._redraw();
    });

    // Animate — sweep 'a' from 0.5 to 6
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

        var aSlider = document.getElementById('a-slider');
        aSlider.value = 0.5;
        state.a = 0.5;
        document.getElementById('a-display').textContent = '0.5';
        document.getElementById('a-val').textContent = '0.5';
        state._redraw();

        animInterval = setInterval(function () {
            var cur = parseFloat(aSlider.value);
            if (cur >= 6) {
                clearInterval(animInterval); animInterval = null;
                animBtn.textContent = 'Animate';
                animBtn.classList.remove('viz-btn-secondary');
                animBtn.classList.add('viz-btn-primary');
                return;
            }
            cur = Math.min(6, cur + 0.05);
            aSlider.value = cur;
            state.a = cur;
            document.getElementById('a-display').textContent = cur.toFixed(1);
            document.getElementById('a-val').textContent = cur.toFixed(1);
            state._redraw();
        }, 50);
    });

    // Reset
    document.getElementById('reset-btn').addEventListener('click', function () {
        if (animInterval) { clearInterval(animInterval); animInterval = null; }
        animBtn.textContent = 'Animate';
        animBtn.classList.remove('viz-btn-secondary');
        animBtn.classList.add('viz-btn-primary');
        document.getElementById('show-directrix').checked = false;
        state.showDirectrix = false;
        applyPreset('ellipse');
    });
});
</script>
