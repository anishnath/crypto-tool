<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String seoTitle = "Pendulum & SHM Simulator - Period, Frequency, Energy (Free)";
    String seoDescription = "Free interactive pendulum and simple harmonic motion simulator. Explore period, frequency, kinetic and potential energy for pendulums and spring-mass systems. Adjust length, mass, damping, and gravity.";
    String canonicalUrl = "https://8gwifi.org/exams/visual-physics/pendulum-shm.jsp";

    StringBuilder extraHead = new StringBuilder();
    extraHead.append("<meta property=\"og:title\" content=\"Pendulum & SHM Simulator - Period, Frequency, Energy\">");
    extraHead.append("<meta property=\"og:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta property=\"og:type\" content=\"website\">");
    extraHead.append("<meta property=\"og:url\" content=\"" + canonicalUrl + "\">");
    extraHead.append("<meta property=\"og:site_name\" content=\"8gwifi.org\">");
    extraHead.append("<meta name=\"twitter:card\" content=\"summary_large_image\">");
    extraHead.append("<meta name=\"twitter:title\" content=\"Pendulum & SHM Simulator\">");
    extraHead.append("<meta name=\"twitter:description\" content=\"" + seoDescription + "\">");
    extraHead.append("<meta name=\"keywords\" content=\"pendulum simulator, simple harmonic motion, SHM, period calculator, frequency, spring mass system, damped oscillation, pendulum energy, kinetic energy, potential energy, physics simulator, oscillation\">");

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
        <a href="<%=request.getContextPath()%>/exams/visual-physics/">Visual Physics</a>
        <span class="breadcrumb-separator">/</span>
        <span class="breadcrumb-current">Pendulum &amp; SHM</span>
    </nav>

    <div class="viz-header">
        <h1>Pendulum &amp; SHM Simulator</h1>
        <p class="viz-subtitle">Explore simple harmonic motion with an interactive pendulum and spring-mass system. Observe how length, mass, damping, and gravity affect period, frequency, and energy in real time.</p>
    </div>

    <div class="viz-interactive">
        <div class="viz-canvas-wrap">
            <div id="viz-canvas"></div>
        </div>

        <div class="viz-panel">
            <div class="viz-controls">
                <h3>Controls</h3>

                <!-- Mode Chips -->
                <div class="control-group">
                    <label>Mode</label>
                    <div class="viz-chip-group">
                        <button class="viz-chip active" data-mode="pendulum">Pendulum</button>
                        <button class="viz-chip" data-mode="spring">Spring-Mass</button>
                    </div>
                </div>

                <!-- Length Slider (pendulum mode) -->
                <div class="control-group" id="length-group">
                    <label>Length (m)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="length-slider" min="0.3" max="3" value="1" step="0.1">
                        <span class="viz-slider-val" id="length-display">1.0</span>
                    </div>
                </div>

                <!-- Spring Constant Slider (spring mode) -->
                <div class="control-group" id="k-group" style="display:none;">
                    <label>Spring Constant k (N/m)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="k-slider" min="1" max="50" value="10" step="1">
                        <span class="viz-slider-val" id="k-display">10</span>
                    </div>
                </div>

                <!-- Mass Slider -->
                <div class="control-group">
                    <label>Mass (kg)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="mass-slider" min="0.1" max="5" value="1" step="0.1">
                        <span class="viz-slider-val" id="mass-display">1.0</span>
                    </div>
                </div>

                <!-- Amplitude Slider -->
                <div class="control-group">
                    <label>Amplitude (<span id="amp-unit">&deg;</span>)</label>
                    <div class="viz-slider-row">
                        <input type="range" id="amp-slider" min="5" max="80" value="30" step="1">
                        <span class="viz-slider-val" id="amp-display">30</span>
                    </div>
                </div>

                <!-- Damping Slider -->
                <div class="control-group">
                    <label>Damping</label>
                    <div class="viz-slider-row">
                        <input type="range" id="damping-slider" min="0" max="2" value="0" step="0.1">
                        <span class="viz-slider-val" id="damping-display">0.0</span>
                    </div>
                </div>

                <!-- Gravity Dropdown -->
                <div class="control-group">
                    <label>Gravity</label>
                    <select id="gravity-select" style="width:100%;padding:8px;border-radius:6px;border:1px solid var(--border-primary);background:var(--bg-primary);color:var(--text-primary);font-size:var(--text-sm);">
                        <option value="9.8">Earth (9.8 m/s&sup2;)</option>
                        <option value="1.6">Moon (1.6 m/s&sup2;)</option>
                        <option value="3.7">Mars (3.7 m/s&sup2;)</option>
                    </select>
                </div>

                <!-- Preset Chips -->
                <div class="control-group">
                    <label>Presets</label>
                    <div class="viz-chip-group">
                        <button class="viz-chip" data-preset="small">Small Angle SHM</button>
                        <button class="viz-chip" data-preset="large">Large Angle</button>
                        <button class="viz-chip" data-preset="damped">Critically Damped</button>
                        <button class="viz-chip" data-preset="resonance">Spring Resonance</button>
                    </div>
                </div>

                <!-- Buttons -->
                <div class="viz-btn-row">
                    <button class="viz-btn viz-btn-primary" id="play-btn">Play</button>
                    <button class="viz-btn viz-btn-secondary" id="reset-btn">Reset</button>
                </div>
            </div>

            <div class="viz-values">
                <h3>Values</h3>
                <table>
                    <tr><td>Mode</td><td id="val-mode">Pendulum</td></tr>
                    <tr><td>Parameter</td><td id="val-param">L = 1.0 m</td></tr>
                    <tr><td>Period (T)</td><td id="val-period">&mdash;</td></tr>
                    <tr><td>Frequency (f)</td><td id="val-frequency">&mdash;</td></tr>
                    <tr><td>Amplitude</td><td id="val-amplitude">30&deg;</td></tr>
                    <tr><td>Current &theta;/x</td><td id="val-theta">&mdash;</td></tr>
                    <tr><td>Current &omega;/v</td><td id="val-omega">&mdash;</td></tr>
                    <tr><td>KE</td><td id="val-ke">&mdash;</td></tr>
                    <tr><td>PE</td><td id="val-pe">&mdash;</td></tr>
                </table>
            </div>
        </div>
    </div>

    <%@ include file="../components/ad-leaderboard.jsp" %>

    <section class="viz-math">
        <h2>The Physics of Simple Harmonic Motion</h2>
        <div class="viz-math-grid">
            <div class="viz-math-col">
                <h3>Pendulum Equations</h3>
                <ul>
                    <li>Period: <span class="formula-highlight">T = 2&pi;&radic;(L/g)</span> (small angle approximation)</li>
                    <li>Angular displacement: <span class="formula-highlight">&theta;(t) = &theta;<sub>0</sub> cos(&omega;t + &phi;)</span></li>
                    <li>Angular frequency: <span class="formula-highlight">&omega; = &radic;(g/L)</span></li>
                    <li>For large angles, the period increases beyond the small-angle approximation</li>
                </ul>

                <h3 style="margin-top:var(--space-4);">Spring-Mass Equations</h3>
                <ul>
                    <li>Period: <span class="formula-highlight">T = 2&pi;&radic;(m/k)</span></li>
                    <li>Displacement: <span class="formula-highlight">x(t) = A cos(&omega;t + &phi;)</span></li>
                    <li>Angular frequency: <span class="formula-highlight">&omega; = &radic;(k/m)</span></li>
                </ul>
            </div>

            <div class="viz-math-col">
                <h3>Energy in SHM</h3>
                <ul>
                    <li>Total energy: <span class="formula-highlight">E = &frac12;kA&sup2;</span> (constant if undamped)</li>
                    <li>Kinetic energy: <span class="formula-highlight">KE = &frac12;mv&sup2;</span></li>
                    <li>Potential energy (spring): <span class="formula-highlight">PE = &frac12;kx&sup2;</span></li>
                    <li>Potential energy (pendulum): <span class="formula-highlight">PE = mgL(1 - cos&theta;)</span></li>
                    <li>Energy oscillates between KE and PE while total E stays constant</li>
                </ul>

                <h3 style="margin-top:var(--space-4);">Try This</h3>
                <ul>
                    <li>Set a <strong>small angle</strong> and compare the period to T = 2&pi;&radic;(L/g)</li>
                    <li>Switch to <strong>Large Angle</strong> preset and observe the period increase</li>
                    <li>Add <strong>damping</strong> and watch the amplitude decay exponentially</li>
                    <li>Switch to <strong>Moon gravity</strong> and see the pendulum slow down</li>
                </ul>
            </div>
        </div>
    </section>

    <section class="viz-related">
        <h2>Related Visualizations</h2>
        <div class="viz-related-grid">
            <a href="<%=request.getContextPath()%>/exams/visual-physics/projectile-motion.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(239,68,68,0.12);">&#10148;</div>
                <div><h4>Projectile Motion</h4><span>Mechanics</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-physics/circuit-builder.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(234,179,8,0.12);">&#9889;</div>
                <div><h4>Circuit Builder</h4><span>Electricity</span></div>
            </a>
            <a href="<%=request.getContextPath()%>/exams/visual-math/trig-graphs.jsp" class="viz-related-card">
                <div class="viz-related-icon" style="background:rgba(99,102,241,0.12);">&#8767;</div>
                <div><h4>Trig Graphs</h4><span>Visual Math</span></div>
            </a>
        </div>
    </section>
</div>

<script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@type": "LearningResource",
    "name": "Pendulum & SHM Simulator",
    "description": "Interactive pendulum and spring-mass simple harmonic motion simulator. Explore period, frequency, kinetic energy, and potential energy with adjustable parameters.",
    "url": "https://8gwifi.org/exams/visual-physics/pendulum-shm.jsp",
    "educationalLevel": "High School",
    "teaches": "Simple harmonic motion, pendulum period, spring-mass oscillation, energy conservation",
    "learningResourceType": "Interactive visualization",
    "interactivityType": "active",
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
        { "@type": "ListItem", "position": 3, "name": "Visual Physics Lab", "item": "https://8gwifi.org/exams/visual-physics/" },
        { "@type": "ListItem", "position": 4, "name": "Pendulum & SHM Simulator" }
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
            "name": "What is simple harmonic motion (SHM)?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "Simple harmonic motion is a type of periodic oscillation where the restoring force is directly proportional to the displacement from equilibrium. Examples include a mass on a spring and a pendulum swinging at small angles. The motion follows a sinusoidal pattern: x(t) = A cos(wt + phi)."
            }
        },
        {
            "@type": "Question",
            "name": "How does pendulum length affect its period?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "The period of a simple pendulum is T = 2*pi*sqrt(L/g), where L is the length and g is gravitational acceleration. Longer pendulums swing more slowly (larger period), while shorter pendulums swing faster. Notably, the period does not depend on the mass of the bob for small angles."
            }
        },
        {
            "@type": "Question",
            "name": "What happens to energy during simple harmonic motion?",
            "acceptedAnswer": {
                "@type": "Answer",
                "text": "In undamped SHM, total mechanical energy is conserved. Energy continuously converts between kinetic energy (KE = 1/2 mv^2, maximum at equilibrium) and potential energy (PE = 1/2 kx^2 for springs, maximum at extremes). The total energy E = 1/2 kA^2 remains constant. With damping, total energy gradually decreases over time."
            }
        }
    ]
}
</script>

<%@ include file="vp-ads.jsp" %>
<%@ include file="../components/footer.jsp" %>

<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-math/js/vm-core.js"></script>
<script src="<%=request.getContextPath()%>/exams/visual-physics/js/vp-pendulum.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    VisualMath.init('pendulum-shm', 'viz-canvas', {
        mode: 'pendulum',
        length: 1.0,
        springK: 10,
        mass: 1.0,
        amplitude: 30,
        damping: 0,
        gravity: 9.8
    });

    var state = VisualMath.getState();

    // Mode chips
    var modeChips = document.querySelectorAll('[data-mode]');
    modeChips.forEach(function(chip) {
        chip.addEventListener('click', function() {
            modeChips.forEach(function(c) { c.classList.remove('active'); });
            this.classList.add('active');
            var mode = this.getAttribute('data-mode');
            state.mode = mode;
            if (mode === 'pendulum') {
                document.getElementById('length-group').style.display = '';
                document.getElementById('k-group').style.display = 'none';
                document.getElementById('amp-unit').innerHTML = '&deg;';
            } else {
                document.getElementById('length-group').style.display = 'none';
                document.getElementById('k-group').style.display = '';
                document.getElementById('amp-unit').innerHTML = '%';
            }
            state._reset();
        });
    });

    // Length slider
    var lengthSlider = document.getElementById('length-slider');
    lengthSlider.addEventListener('input', function() {
        var val = parseFloat(this.value);
        document.getElementById('length-display').textContent = val.toFixed(1);
        state.length = val;
        state._redraw();
    });

    // Spring constant slider
    var kSlider = document.getElementById('k-slider');
    kSlider.addEventListener('input', function() {
        var val = parseFloat(this.value);
        document.getElementById('k-display').textContent = val;
        state.springK = val;
        state._redraw();
    });

    // Mass slider
    var massSlider = document.getElementById('mass-slider');
    massSlider.addEventListener('input', function() {
        var val = parseFloat(this.value);
        document.getElementById('mass-display').textContent = val.toFixed(1);
        state.mass = val;
        state._redraw();
    });

    // Amplitude slider
    var ampSlider = document.getElementById('amp-slider');
    ampSlider.addEventListener('input', function() {
        var val = parseFloat(this.value);
        document.getElementById('amp-display').textContent = val;
        state.amplitude = val;
        state._redraw();
    });

    // Damping slider
    var dampingSlider = document.getElementById('damping-slider');
    dampingSlider.addEventListener('input', function() {
        var val = parseFloat(this.value);
        document.getElementById('damping-display').textContent = val.toFixed(1);
        state.damping = val;
        state._redraw();
    });

    // Gravity dropdown
    document.getElementById('gravity-select').addEventListener('change', function() {
        state.gravity = parseFloat(this.value);
        state._redraw();
    });

    // Preset chips
    var presets = {
        small:     { mode: 'pendulum', length: 1, amplitude: 10, damping: 0 },
        large:     { mode: 'pendulum', length: 1, amplitude: 70, damping: 0 },
        damped:    { mode: 'pendulum', length: 1, amplitude: 30, damping: 1.5 },
        resonance: { mode: 'spring', springK: 10, mass: 1, amplitude: 40, damping: 0 }
    };

    document.querySelectorAll('[data-preset]').forEach(function(chip) {
        chip.addEventListener('click', function() {
            var preset = presets[this.getAttribute('data-preset')];
            if (!preset) return;

            // Apply mode
            if (preset.mode) {
                state.mode = preset.mode;
                modeChips.forEach(function(c) {
                    c.classList.toggle('active', c.getAttribute('data-mode') === preset.mode);
                });
                if (preset.mode === 'pendulum') {
                    document.getElementById('length-group').style.display = '';
                    document.getElementById('k-group').style.display = 'none';
                    document.getElementById('amp-unit').innerHTML = '&deg;';
                } else {
                    document.getElementById('length-group').style.display = 'none';
                    document.getElementById('k-group').style.display = '';
                    document.getElementById('amp-unit').innerHTML = '%';
                }
            }

            // Apply values
            if (preset.length !== undefined) {
                state.length = preset.length;
                lengthSlider.value = preset.length;
                document.getElementById('length-display').textContent = preset.length.toFixed(1);
            }
            if (preset.springK !== undefined) {
                state.springK = preset.springK;
                kSlider.value = preset.springK;
                document.getElementById('k-display').textContent = preset.springK;
            }
            if (preset.mass !== undefined) {
                state.mass = preset.mass;
                massSlider.value = preset.mass;
                document.getElementById('mass-display').textContent = preset.mass.toFixed(1);
            }
            if (preset.amplitude !== undefined) {
                state.amplitude = preset.amplitude;
                ampSlider.value = preset.amplitude;
                document.getElementById('amp-display').textContent = preset.amplitude;
            }
            if (preset.damping !== undefined) {
                state.damping = preset.damping;
                dampingSlider.value = preset.damping;
                document.getElementById('damping-display').textContent = preset.damping.toFixed(1);
            }

            state._reset();
        });
    });

    // Play / Pause button
    var playBtn = document.getElementById('play-btn');
    playBtn.addEventListener('click', function() {
        if (state._isRunning && state._isRunning()) {
            state._pause();
            playBtn.textContent = 'Play';
        } else {
            state._start();
            playBtn.textContent = 'Pause';
        }
    });

    // Reset button
    document.getElementById('reset-btn').addEventListener('click', function() {
        state._reset();
        playBtn.textContent = 'Play';
    });
});
</script>
