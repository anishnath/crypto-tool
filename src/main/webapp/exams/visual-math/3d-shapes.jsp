<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "3D Shape Calculator - Volume & Surface Area for 11 Shapes (Free)";
    String seoDescription = "Calculate volume and surface area of 11 3D shapes: cube, cuboid, sphere, hemisphere, cylinder, cone, torus, pyramid, tetrahedron, octahedron, triangular prism. Interactive 3D visualization.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-math/3d-shapes.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"3D Shape Volume & Surface Area Calculator\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"3D Shape Calculator - 11 Shapes\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"3d shape calculator, volume calculator, surface area calculator, cube, cuboid, sphere, hemisphere, cylinder, cone, torus, pyramid, tetrahedron, octahedron, triangular prism, platonic solids, geometry 3d\">");

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
        <span class="breadcrumb-current">3D Shapes</span>
    </nav>

    <div class="viz-header">
        <h1>3D Shape Volume & Surface Area Calculator</h1>
        <p class="viz-subtitle">Explore 11 shapes in interactive 3D. Drag to rotate, adjust dimensions, toggle wireframe.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Shape</h3>

                <div class="control-group">
                    <label>Select Shape</label>
                    <select id="shape-select"
                        style="width: 100%; padding: 8px; border-radius: 6px; border: 1px solid var(--border-primary); background: var(--bg-primary); color: var(--text-primary);">
                        <optgroup label="Basic">
                            <option value="cube">Cube</option>
                            <option value="cuboid">Cuboid (Rectangular Prism)</option>
                            <option value="sphere">Sphere</option>
                            <option value="hemisphere">Hemisphere</option>
                        </optgroup>
                        <optgroup label="Round Bodies">
                            <option value="cylinder">Cylinder</option>
                            <option value="cone">Cone</option>
                            <option value="torus">Torus (Donut)</option>
                        </optgroup>
                        <optgroup label="Pointed / Prisms">
                            <option value="pyramid">Square Pyramid</option>
                            <option value="triangular-prism">Triangular Prism</option>
                        </optgroup>
                        <optgroup label="Platonic Solids">
                            <option value="tetrahedron">Tetrahedron (4 faces)</option>
                            <option value="octahedron">Octahedron (8 faces)</option>
                        </optgroup>
                    </select>
                </div>

                <div class="control-group" id="param1-group">
                    <label id="param1-label">Side Length</label>
                    <div class="viz-slider-row">
                        <input type="range" id="param1-slider" min="1" max="10" value="5" step="0.1">
                        <span class="viz-slider-val" id="param1-display">5.0</span>
                    </div>
                </div>

                <div class="control-group" id="param2-group" style="display: none;">
                    <label id="param2-label">Height</label>
                    <div class="viz-slider-row">
                        <input type="range" id="param2-slider" min="1" max="10" value="5" step="0.1">
                        <span class="viz-slider-val" id="param2-display">5.0</span>
                    </div>
                </div>

                <div class="control-group" id="param3-group" style="display: none;">
                    <label id="param3-label">Depth</label>
                    <div class="viz-slider-row">
                        <input type="range" id="param3-slider" min="1" max="10" value="5" step="0.1">
                        <span class="viz-slider-val" id="param3-display">5.0</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Display</label>
                    <div class="viz-check-group">
                        <label class="viz-check">
                            <input type="checkbox" id="show-wireframe">
                            Wireframe
                        </label>
                        <label class="viz-check">
                            <input type="checkbox" id="auto-rotate" checked>
                            Auto-Rotate
                        </label>
                    </div>
                </div>
            </div>

            <div class="viz-values">
                <h3>Measurements</h3>
                <table>
                    <tr><td>Volume</td><td id="val-volume">--</td></tr>
                    <tr><td>Surface Area</td><td id="val-surface">--</td></tr>
                    <tr><td>Formula (V)</td><td id="val-formula-v">--</td></tr>
                    <tr><td>Formula (SA)</td><td id="val-formula-sa">--</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>3D Shape Formulas</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Basic & Round Shapes</h3>
                <ul>
                    <li><strong>Cube</strong>: V = <span class="formula-highlight">s&sup3;</span>, SA = <span class="formula-highlight">6s&sup2;</span></li>
                    <li><strong>Cuboid</strong>: V = <span class="formula-highlight">lwh</span>, SA = <span class="formula-highlight">2(lw+lh+wh)</span></li>
                    <li><strong>Sphere</strong>: V = <span class="formula-highlight">(4/3)&pi;r&sup3;</span>, SA = <span class="formula-highlight">4&pi;r&sup2;</span></li>
                    <li><strong>Hemisphere</strong>: V = <span class="formula-highlight">(2/3)&pi;r&sup3;</span>, SA = <span class="formula-highlight">3&pi;r&sup2;</span></li>
                    <li><strong>Cylinder</strong>: V = <span class="formula-highlight">&pi;r&sup2;h</span>, SA = <span class="formula-highlight">2&pi;r&sup2;+2&pi;rh</span></li>
                    <li><strong>Cone</strong>: V = <span class="formula-highlight">(1/3)&pi;r&sup2;h</span>, SA = <span class="formula-highlight">&pi;r&sup2;+&pi;rl</span></li>
                    <li><strong>Torus</strong>: V = <span class="formula-highlight">2&pi;&sup2;Rr&sup2;</span>, SA = <span class="formula-highlight">4&pi;&sup2;Rr</span></li>
                </ul>
            </div>

            <div class="viz-math-col">
                <h3>Pyramids, Prisms & Platonic Solids</h3>
                <ul>
                    <li><strong>Pyramid</strong>: V = <span class="formula-highlight">(1/3)b&sup2;h</span>, SA = <span class="formula-highlight">b&sup2;+2bl</span></li>
                    <li><strong>Triangular Prism</strong>: V = <span class="formula-highlight">(&radic;3/4)a&sup2;&times;l</span>, SA = <span class="formula-highlight">(&radic;3/2)a&sup2;+3al</span></li>
                    <li><strong>Tetrahedron</strong>: V = <span class="formula-highlight">(&radic;2/12)a&sup3;</span>, SA = <span class="formula-highlight">&radic;3&middot;a&sup2;</span></li>
                    <li><strong>Octahedron</strong>: V = <span class="formula-highlight">(&radic;2/3)a&sup3;</span>, SA = <span class="formula-highlight">2&radic;3&middot;a&sup2;</span></li>
                </ul>

                <h3 style="margin-top: var(--space-4);">Platonic Solids</h3>
                <ul>
                    <li><strong>Tetrahedron</strong>: 4 equilateral triangular faces</li>
                    <li><strong>Cube</strong>: 6 square faces</li>
                    <li><strong>Octahedron</strong>: 8 equilateral triangular faces</li>
                    <li>All edges equal, all faces congruent</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-math/conic-sections.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(168,85,247,0.12);">&#9676;</div>
                <div><h4>Conic Sections</h4><span>Algebra</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/transformations.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(236,72,153,0.12);">&#8634;</div>
                <div><h4>Transformations</h4><span>Geometry</span></div>
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
    "name": "3D Shape Volume & Surface Area Calculator",
    "description": "Calculate volume and surface area of 11 3D shapes with interactive 3D visualization. Covers cube, cuboid, sphere, hemisphere, cylinder, cone, torus, pyramid, tetrahedron, octahedron, triangular prism.",
    "url": "https://8gwifi.org/exams/visual-math/3d-shapes.jsp",
    "educationalLevel": "Middle School",
    "teaches": "3D geometry, volume, surface area, Platonic solids, spatial reasoning",
    "learningResourceType": "Interactive calculator",
    "interactivityType": "active",
    "publisher": {"@type": "Organization", "name": "8gwifi.org"}
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
        { "@type": "ListItem", "position": 4, "name": "3D Shapes" }
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
            "name": "What is a Platonic solid?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A Platonic solid is a 3D shape where every face is the same regular polygon and the same number of faces meet at each vertex. There are exactly five: tetrahedron (4 triangles), cube (6 squares), octahedron (8 triangles), dodecahedron (12 pentagons), and icosahedron (20 triangles)."
            }
        },
        {
            "@type": "Question",
            "name": "How do you calculate the volume of a torus?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The volume of a torus (donut shape) is V = 2pi²Rr², where R is the distance from the center of the tube to the center of the torus (major radius) and r is the radius of the tube (minor radius). The surface area is SA = 4pi²Rr."
            }
        },
        {
            "@type": "Question",
            "name": "What is the difference between a cube and a cuboid?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "A cube has all six faces as equal squares (all edges the same length s), so V = s³. A cuboid (rectangular prism) has six rectangular faces with three different edge lengths (l, w, h), so V = l×w×h. A cube is a special case of a cuboid where l = w = h."
            }
        }
    ]
}
</script>

<%@ include file="viz-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-3d-shapes.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
    VisualMath.init('3d-shapes', 'viz-canvas', {
        shape: 'cube',
        param1: 5,
        param2: 5,
        param3: 5,
        wireframe: false,
        autoRotate: true
    });

    var shapeConfigs = {
        'cube':             { p1: 'Side Length', p2: false, p3: false },
        'cuboid':           { p1: 'Length',      p2: 'Width',         p3: 'Height' },
        'sphere':           { p1: 'Radius',      p2: false,           p3: false },
        'hemisphere':       { p1: 'Radius',      p2: false,           p3: false },
        'cylinder':         { p1: 'Radius',      p2: 'Height',        p3: false },
        'cone':             { p1: 'Radius',      p2: 'Height',        p3: false },
        'torus':            { p1: 'Major Radius', p2: 'Tube Radius',  p3: false },
        'pyramid':          { p1: 'Base Side',   p2: 'Height',        p3: false },
        'triangular-prism': { p1: 'Triangle Side', p2: 'Prism Length', p3: false },
        'tetrahedron':      { p1: 'Edge Length', p2: false,           p3: false },
        'octahedron':       { p1: 'Edge Length', p2: false,           p3: false }
    };

    var torusDefaults = { param1: 4, param2: 1.5 };

    function applyShape(shape) {
        var cfg = shapeConfigs[shape];

        document.getElementById('param1-label').textContent = cfg.p1;
        document.getElementById('param2-group').style.display = cfg.p2 ? 'block' : 'none';
        document.getElementById('param3-group').style.display = cfg.p3 ? 'block' : 'none';
        if (cfg.p2) document.getElementById('param2-label').textContent = cfg.p2;
        if (cfg.p3) document.getElementById('param3-label').textContent = cfg.p3;

        VisualMath.setState('shape', shape);

        // Sensible defaults for torus so tube doesn't clip
        if (shape === 'torus') {
            setSlider('param1', torusDefaults.param1);
            setSlider('param2', torusDefaults.param2);
            VisualMath.setState('param1', torusDefaults.param1);
            VisualMath.setState('param2', torusDefaults.param2);
        }

        VisualMath.getState()._redraw();
    }

    function setSlider(id, val) {
        document.getElementById(id + '-slider').value = val;
        document.getElementById(id + '-display').textContent = val.toFixed(1);
    }

    document.getElementById('shape-select').addEventListener('change', function () {
        applyShape(this.value);
    });

    function bindSlider(id, prop) {
        document.getElementById(id + '-slider').addEventListener('input', function () {
            var val = parseFloat(this.value);
            document.getElementById(id + '-display').textContent = val.toFixed(1);
            VisualMath.setState(prop, val);
            VisualMath.getState()._redraw();
        });
    }

    bindSlider('param1', 'param1');
    bindSlider('param2', 'param2');
    bindSlider('param3', 'param3');

    document.getElementById('show-wireframe').addEventListener('change', function () {
        VisualMath.setState('wireframe', this.checked);
        VisualMath.getState()._redraw();
    });

    document.getElementById('auto-rotate').addEventListener('change', function () {
        VisualMath.setState('autoRotate', this.checked);
        if (this.checked) VisualMath.getState()._redraw();
    });
});
</script>
