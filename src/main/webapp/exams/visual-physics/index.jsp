<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Visual Physics Lab - 19 Interactive Physics Simulations (Free)";
    String seoDescription = "19 free interactive physics simulations: projectile motion, collisions, pulleys, orbital mechanics, lens optics, electric & magnetic fields, circuits, waves, thermodynamics, and modern physics. Build physics intuition.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/";
    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Visual Physics Lab - 18 Free Interactive Simulations\">");
    extraHead.append("\n<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta property=\"og:type\" content=\"website\">");
    extraHead.append("\n<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("\n<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("\n<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("\n<meta name=\"twitter:title\" content=\"Visual Physics Lab - 18 Interactive Physics Simulations\">");
    extraHead.append("\n<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("\n<meta name=\"keywords\" content=\"projectile motion simulator, collisions momentum, inclined plane forces, orbital mechanics kepler, torque rotation, pendulum SHM, lens ray diagram, snells law refraction, diffraction grating, electric field simulator, magnetic field visualizer, circuit simulator, electromagnetic induction, wave interference, standing waves harmonics, doppler effect, ideal gas PV diagram, photoelectric effect, interactive physics, free physics tools\">");

    request.setAttribute("pageTitle", seoTitle);
    request.setAttribute("pageDescription", seoDescription);
    request.setAttribute("canonicalUrl", canonicalUrl);
    request.setAttribute("extraHeadContent", extraHead.toString());
    request.setAttribute("skipMathJax", "true");
%>
<%@ include file="../components/header.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/exams/visual-math/visual-math.css">

<div class="container">
    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <a href="<%=request.getContextPath()%>/exams/">Exams</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Visual Physics Lab</span>
    </nav>

    <!-- Hero -->
    <section class="vm-hero">
        <h1>Visual Physics Lab</h1>
        <p>Interactive physics simulations to build intuition. Drag, adjust, and explore fundamental physics concepts.</p>
    </section>

    <!-- Ad -->
    <%@ include file="../components/ad-leaderboard.jsp" %>

    <!-- Filters -->
    <div class="vm-filters">
        <button class="vm-chip active" data-filter="all">All (19)</button>
        <button class="vm-chip" data-filter="mechanics">Mechanics (7)</button>
        <button class="vm-chip" data-filter="optics">Optics (3)</button>
        <button class="vm-chip" data-filter="em">E&amp;M (4)</button>
        <button class="vm-chip" data-filter="waves">Waves (3)</button>
        <button class="vm-chip" data-filter="thermo">Thermo (1)</button>
        <button class="vm-chip" data-filter="modern">Modern (1)</button>
    </div>

    <!-- Card Grid -->
    <div class="vm-grid" id="viz-grid">

        <!-- 1. Projectile Motion -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/projectile-motion.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-projectile"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Projectile Motion</h3>
                <p class="vm-card-desc">Launch projectiles at any angle. See trajectory, velocity components, range, and max height with stroboscope markers.</p>
            </div>
        </a>

        <!-- 2. Pendulum & SHM -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/pendulum-shm.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-pendulum"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Pendulum & SHM</h3>
                <p class="vm-card-desc">Explore simple harmonic motion with pendulums and springs. See displacement graphs, energy bars, and damping effects.</p>
            </div>
        </a>

        <!-- 3. Collisions -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/collisions.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-collisions"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Collisions</h3>
                <p class="vm-card-desc">Simulate elastic and inelastic collisions. See momentum vectors, energy bars, and center of mass tracking.</p>
            </div>
        </a>

        <!-- 4. Inclined Plane -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/inclined-plane.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-inclined-plane"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Inclined Plane</h3>
                <p class="vm-card-desc">Explore forces on an inclined plane. See free body diagrams, friction, normal force, and sliding conditions.</p>
            </div>
        </a>

        <!-- 5. Torque & Rotation -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/torque-rotation.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-torque"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Torque & Rotation</h3>
                <p class="vm-card-desc">Apply forces to levers, spin disks, and observe rolling. See torque, moment of inertia, and angular momentum.</p>
            </div>
        </a>

        <!-- 6. Orbital Mechanics -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/orbital-mechanics.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-orbital"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Orbital Mechanics</h3>
                <p class="vm-card-desc">Explore Kepler's laws and elliptical orbits. Adjust eccentricity and see vis-viva speed, sweep areas, and escape velocity.</p>
            </div>
        </a>

        <!-- 7. Lens & Mirror Ray Diagram -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/lens-ray-diagram.jsp" class="vm-card" data-category="optics">
            <div class="vm-card-preview" id="preview-lens"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(249,115,22,0.12);color:#f97316;">Optics</span>
                <h3>Lens & Mirror Ray Diagram</h3>
                <p class="vm-card-desc">Draw ray diagrams for convex/concave lenses and mirrors. See real and virtual images with standard rays.</p>
            </div>
        </a>

        <!-- 8. Snell's Law -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/snells-law.jsp" class="vm-card" data-category="optics">
            <div class="vm-card-preview" id="preview-snells-law"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(249,115,22,0.12);color:#f97316;">Optics</span>
                <h3>Snell's Law</h3>
                <p class="vm-card-desc">Visualize refraction at material boundaries. See total internal reflection, critical angles, and Snell's law in action.</p>
            </div>
        </a>

        <!-- 9. Diffraction -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/diffraction.jsp" class="vm-card" data-category="optics">
            <div class="vm-card-preview" id="preview-diffraction"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(249,115,22,0.12);color:#f97316;">Optics</span>
                <h3>Diffraction Patterns</h3>
                <p class="vm-card-desc">Visualize single slit, double slit, and grating diffraction. Adjust wavelength and slit width to see intensity patterns.</p>
            </div>
        </a>

        <!-- 10. Electric Field -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/electric-field.jsp" class="vm-card" data-category="em">
            <div class="vm-card-preview" id="preview-electric-field"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(99,102,241,0.12);color:#6366f1;">E&amp;M</span>
                <h3>Electric Field Simulator</h3>
                <p class="vm-card-desc">Place charges and see field lines emerge. Drag charges to explore dipoles, quadrupoles, and parallel plates.</p>
            </div>
        </a>

        <!-- 11. Magnetic Field -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/magnetic-field.jsp" class="vm-card" data-category="em">
            <div class="vm-card-preview" id="preview-magnetic-field"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(99,102,241,0.12);color:#6366f1;">E&amp;M</span>
                <h3>Magnetic Field</h3>
                <p class="vm-card-desc">Visualize magnetic fields from bar magnets, wires, loops, and solenoids. See field lines, compass needles, and iron filings.</p>
            </div>
        </a>

        <!-- 12. Circuit Builder -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/circuit-builder.jsp" class="vm-card" data-category="em">
            <div class="vm-card-preview" id="preview-circuit"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(99,102,241,0.12);color:#6366f1;">E&amp;M</span>
                <h3>Circuit Simulator</h3>
                <p class="vm-card-desc">Build series, parallel, and combo circuits. See animated current flow, voltage drops, and Ohm's law in action.</p>
            </div>
        </a>

        <!-- 13. EM Induction -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/em-induction.jsp" class="vm-card" data-category="em">
            <div class="vm-card-preview" id="preview-em-induction"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(99,102,241,0.12);color:#6366f1;">E&amp;M</span>
                <h3>EM Induction</h3>
                <p class="vm-card-desc">Push a magnet through a coil or spin a generator. See Faraday's law, Lenz's law, and induced EMF in real time.</p>
            </div>
        </a>

        <!-- 14. Wave Interference -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/wave-interference.jsp" class="vm-card" data-category="waves">
            <div class="vm-card-preview" id="preview-wave"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(34,197,94,0.12);color:#22c55e;">Waves</span>
                <h3>Wave Interference</h3>
                <p class="vm-card-desc">See constructive and destructive interference patterns from two point sources. Pixel-level intensity rendering.</p>
            </div>
        </a>

        <!-- 15. Standing Waves -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/standing-waves.jsp" class="vm-card" data-category="waves">
            <div class="vm-card-preview" id="preview-standing-waves"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(34,197,94,0.12);color:#22c55e;">Waves</span>
                <h3>Standing Waves</h3>
                <p class="vm-card-desc">Explore harmonics on strings and in pipes. See nodes, antinodes, and the relationship between wavelength and frequency.</p>
            </div>
        </a>

        <!-- 16. Doppler Effect -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/doppler-effect.jsp" class="vm-card" data-category="waves">
            <div class="vm-card-preview" id="preview-doppler"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(34,197,94,0.12);color:#22c55e;">Waves</span>
                <h3>Doppler Effect</h3>
                <p class="vm-card-desc">Watch wavefronts compress and expand as sources move. See frequency shifts, Mach cones, and sonic booms.</p>
            </div>
        </a>

        <!-- 17. Pulley Systems -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/pulley-systems.jsp" class="vm-card" data-category="mechanics">
            <div class="vm-card-preview" id="preview-pulley"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(239,68,68,0.12);color:#ef4444;">Mechanics</span>
                <h3>Pulley Systems</h3>
                <p class="vm-card-desc">Explore fixed, movable, and block-and-tackle pulleys with 2<sup>n</sup> mechanical advantage. Simulate Atwood machines.</p>
            </div>
        </a>

        <!-- 18. Ideal Gas Law -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/ideal-gas.jsp" class="vm-card" data-category="thermo">
            <div class="vm-card-preview" id="preview-ideal-gas"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(234,179,8,0.12);color:#eab308;">Thermo</span>
                <h3>Ideal Gas Law</h3>
                <p class="vm-card-desc">Explore PV diagrams for isothermal, adiabatic, isobaric, and isochoric processes. See work, heat, and internal energy.</p>
            </div>
        </a>

        <!-- 18. Photoelectric Effect -->
        <a href="<%=request.getContextPath()%>/exams/visual-physics/photoelectric-effect.jsp" class="vm-card" data-category="modern">
            <div class="vm-card-preview" id="preview-photoelectric"></div>
            <div class="vm-card-body">
                <span class="vm-card-tag" style="background:rgba(168,85,247,0.12);color:#a855f7;">Modern</span>
                <h3>Photoelectric Effect</h3>
                <p class="vm-card-desc">Shine light on metals and observe electron emission. See how frequency, not intensity, determines if electrons escape.</p>
            </div>
        </a>

    </div>
</div>

<!-- JSON-LD: CollectionPage + ItemList -->
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "CollectionPage",
    "name": "Visual Physics Lab",
    "description": "19 interactive physics simulations covering mechanics, optics, electromagnetism, waves, thermodynamics, and modern physics.",
    "url": "https://8gwifi.org/exams/visual-physics/",
    "publisher": {
        "@type": "Organization",
        "name": "8gwifi.org"
    },
    "mainEntity": {
        "@type": "ItemList",
        "itemListElement": [
            { "@type": "ListItem", "position": 1, "name": "Projectile Motion Simulator", "url": "https://8gwifi.org/exams/visual-physics/projectile-motion.jsp" },
            { "@type": "ListItem", "position": 2, "name": "Pendulum & SHM Simulator", "url": "https://8gwifi.org/exams/visual-physics/pendulum-shm.jsp" },
            { "@type": "ListItem", "position": 3, "name": "Collisions Simulator", "url": "https://8gwifi.org/exams/visual-physics/collisions.jsp" },
            { "@type": "ListItem", "position": 4, "name": "Inclined Plane Simulator", "url": "https://8gwifi.org/exams/visual-physics/inclined-plane.jsp" },
            { "@type": "ListItem", "position": 5, "name": "Torque & Rotation Simulator", "url": "https://8gwifi.org/exams/visual-physics/torque-rotation.jsp" },
            { "@type": "ListItem", "position": 6, "name": "Orbital Mechanics Simulator", "url": "https://8gwifi.org/exams/visual-physics/orbital-mechanics.jsp" },
            { "@type": "ListItem", "position": 7, "name": "Lens & Mirror Ray Diagram", "url": "https://8gwifi.org/exams/visual-physics/lens-ray-diagram.jsp" },
            { "@type": "ListItem", "position": 8, "name": "Snell's Law Simulator", "url": "https://8gwifi.org/exams/visual-physics/snells-law.jsp" },
            { "@type": "ListItem", "position": 9, "name": "Diffraction Simulator", "url": "https://8gwifi.org/exams/visual-physics/diffraction.jsp" },
            { "@type": "ListItem", "position": 10, "name": "Electric Field Simulator", "url": "https://8gwifi.org/exams/visual-physics/electric-field.jsp" },
            { "@type": "ListItem", "position": 11, "name": "Magnetic Field Visualizer", "url": "https://8gwifi.org/exams/visual-physics/magnetic-field.jsp" },
            { "@type": "ListItem", "position": 12, "name": "Circuit Simulator", "url": "https://8gwifi.org/exams/visual-physics/circuit-builder.jsp" },
            { "@type": "ListItem", "position": 13, "name": "EM Induction Simulator", "url": "https://8gwifi.org/exams/visual-physics/em-induction.jsp" },
            { "@type": "ListItem", "position": 14, "name": "Wave Interference Simulator", "url": "https://8gwifi.org/exams/visual-physics/wave-interference.jsp" },
            { "@type": "ListItem", "position": 15, "name": "Standing Waves Simulator", "url": "https://8gwifi.org/exams/visual-physics/standing-waves.jsp" },
            { "@type": "ListItem", "position": 16, "name": "Doppler Effect Simulator", "url": "https://8gwifi.org/exams/visual-physics/doppler-effect.jsp" },
            { "@type": "ListItem", "position": 17, "name": "Pulley Systems Simulator", "url": "https://8gwifi.org/exams/visual-physics/pulley-systems.jsp" },
            { "@type": "ListItem", "position": 18, "name": "Ideal Gas Law Simulator", "url": "https://8gwifi.org/exams/visual-physics/ideal-gas.jsp" },
            { "@type": "ListItem", "position": 19, "name": "Photoelectric Effect Simulator", "url": "https://8gwifi.org/exams/visual-physics/photoelectric-effect.jsp" }
        ]
    }
}
</script>
<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
        { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org/" },
        { "@type": "ListItem", "position": 2, "name": "Exams", "item": "https://8gwifi.org/exams/" },
        { "@type": "ListItem", "position": 3, "name": "Visual Physics Lab" }
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
            "name": "What is the Visual Physics Lab?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The Visual Physics Lab is a collection of 19 free interactive physics simulations that help students build physics intuition. Topics span mechanics (projectile motion, collisions, inclined planes, torque, orbital mechanics), optics (lens ray diagrams, Snell's law, diffraction), electromagnetism (electric fields, magnetic fields, circuits, EM induction), waves (interference, standing waves, Doppler effect), thermodynamics (ideal gas PV diagrams), and modern physics (photoelectric effect)."
            }
        },
        {
            "@type": "Question",
            "name": "Are these physics simulations free to use?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Yes, all 19 simulations are completely free. No sign-up required. They work on desktop and mobile browsers with interactive sliders, drag controls, and animations."
            }
        },
        {
            "@type": "Question",
            "name": "What physics topics are covered?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Topics include mechanics (projectile motion, pendulum SHM, collisions, inclined planes, torque & rotation, orbital mechanics), optics (lens/mirror ray diagrams, Snell's law refraction, diffraction patterns), electromagnetism (electric fields, magnetic fields, circuit builder, electromagnetic induction), waves (wave interference, standing waves, Doppler effect), thermodynamics (ideal gas law with PV diagrams), and modern physics (photoelectric effect)."
            }
        }
    ]
}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<!-- p5.js + Visual Math Core + Physics Previews -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-previews.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Launch preview sketches
        VisualMath.preview('preview-projectile', 'projectile-preview');
        VisualMath.preview('preview-pendulum', 'pendulum-preview');
        VisualMath.preview('preview-collisions', 'collisions-preview');
        VisualMath.preview('preview-inclined-plane', 'inclined-plane-preview');
        VisualMath.preview('preview-torque', 'torque-preview');
        VisualMath.preview('preview-orbital', 'orbital-preview');
        VisualMath.preview('preview-lens', 'lens-preview');
        VisualMath.preview('preview-snells-law', 'snells-law-preview');
        VisualMath.preview('preview-diffraction', 'diffraction-preview');
        VisualMath.preview('preview-electric-field', 'electric-field-preview');
        VisualMath.preview('preview-magnetic-field', 'magnetic-field-preview');
        VisualMath.preview('preview-circuit', 'circuit-preview');
        VisualMath.preview('preview-em-induction', 'em-induction-preview');
        VisualMath.preview('preview-wave', 'wave-preview');
        VisualMath.preview('preview-standing-waves', 'standing-waves-preview');
        VisualMath.preview('preview-doppler', 'doppler-preview');
        VisualMath.preview('preview-pulley', 'pulley-preview');
        VisualMath.preview('preview-ideal-gas', 'ideal-gas-preview');
        VisualMath.preview('preview-photoelectric', 'photoelectric-preview');

        // Filter chips
        var chips = document.querySelectorAll('.vm-chip');
        var cards = document.querySelectorAll('.vm-card');

        chips.forEach(function (chip) {
            chip.addEventListener('click', function () {
                chips.forEach(function (c) { c.classList.remove('active'); });
                chip.classList.add('active');
                var filter = chip.getAttribute('data-filter');
                cards.forEach(function (card) {
                    if (filter === 'all' || card.getAttribute('data-category') === filter) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
    });
</script>
