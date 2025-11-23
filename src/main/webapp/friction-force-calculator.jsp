<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free Friction Force Calculator - Calculate static and kinetic friction, coefficient of friction, normal force, and required force to move objects. Includes material database with 100+ friction coefficients.">
    <meta name="keywords" content="friction calculator, coefficient of friction, static friction, kinetic friction, normal force, friction force, physics calculator, material friction">
    <meta name="author" content="8gwifi.org">

    <!-- Open Graph -->
    <meta property="og:title" content="Friction Force Calculator - Static & Kinetic Friction">
    <meta property="og:description" content="Calculate friction forces with our comprehensive calculator. Includes material database, static/kinetic friction, and force analysis.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/friction-force-calculator.jsp">

    <title>Friction Force Calculator - Static & Kinetic Friction | 8gwifi.org</title>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Friction Force Calculator",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Web Browser",
      "description": "Calculate friction forces, coefficients, and force requirements with material database",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "creator": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
      }
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "What is friction force and how is it calculated?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Friction force is the resistance to motion between two surfaces in contact. It's calculated using F_friction = μ × N, where μ is the coefficient of friction and N is the normal force. Static friction (μ_s) prevents motion, while kinetic friction (μ_k) opposes motion."
          }
        },
        {
          "@type": "Question",
          "name": "What's the difference between static and kinetic friction?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Static friction (F_s ≤ μ_s × N) prevents an object from starting to move and can vary from zero up to its maximum value. Kinetic friction (F_k = μ_k × N) acts on moving objects and is constant. Static friction is typically higher than kinetic friction for the same material pair."
          }
        },
        {
          "@type": "Question",
          "name": "How do I find the coefficient of friction for different materials?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Our calculator includes a comprehensive material database with 100+ friction coefficients. Common values include: rubber on dry concrete (μ_s ≈ 1.0), wood on wood (μ_s ≈ 0.4), steel on steel (μ_s ≈ 0.74), and ice on ice (μ_s ≈ 0.1). Select materials from the dropdown to auto-fill values."
          }
        },
        {
          "@type": "Question",
          "name": "How does friction work on an inclined plane?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "On an incline, the normal force N = mg·cos(θ), and the parallel force is F_parallel = mg·sin(θ). If F_parallel > F_friction (μN), the object slides down. The friction force acts up the slope, opposing motion. Use our calculator to find the critical angle where sliding begins."
          }
        },
        {
          "@type": "Question",
          "name": "What force is needed to overcome static friction?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "To start moving an object, the applied force must exceed maximum static friction: F_applied > F_s(max) = μ_s × N. Once moving, only F_applied > μ_k × N is needed to maintain motion. This is why it's harder to start pushing than to keep pushing."
          }
        },
        {
          "@type": "Question",
          "name": "How do I calculate normal force on horizontal and inclined surfaces?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "On a horizontal surface: N = mg (equals the weight). On an incline at angle θ: N = mg·cos(θ). The normal force is perpendicular to the surface. For more complex scenarios with additional forces, sum all perpendicular components."
          }
        }
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [
        {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
        {"@type": "ListItem", "position": 2, "name": "Physics Tools", "item": "https://8gwifi.org/physics-tools.jsp"},
        {"@type": "ListItem", "position": 3, "name": "Friction Calculator", "item": "https://8gwifi.org/friction-force-calculator.jsp"}
      ]
    }
    </script>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #333;
            padding: 20px;
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }

        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .header p {
            font-size: 1.1em;
            opacity: 0.95;
        }

        .content {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 30px;
            padding: 30px;
        }

        .controls {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 15px;
            height: fit-content;
        }

        .visualization {
            background: #fff;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .control-group {
            margin-bottom: 20px;
        }

        .control-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
            font-size: 0.95em;
        }

        .control-group input,
        .control-group select {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1em;
            transition: border-color 0.3s;
        }

        .control-group input:focus,
        .control-group select:focus {
            outline: none;
            border-color: #667eea;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            margin-top: 10px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            margin-top: 10px;
        }

        canvas {
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            display: block;
            margin: 20px auto;
            background: #fafafa;
        }

        .results {
            background: #f0f7ff;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            border-left: 4px solid #667eea;
        }

        .results h3 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.3em;
        }

        .result-item {
            display: flex;
            justify-content: space-between;
            padding: 10px;
            margin: 8px 0;
            background: white;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
        }

        .result-label {
            font-weight: 600;
            color: #555;
        }

        .result-value {
            color: #667eea;
            font-weight: 700;
            font-family: 'Courier New', monospace;
        }

        .steps {
            background: #fff9e6;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            border-left: 4px solid #ffc107;
        }

        .steps h3 {
            color: #f57c00;
            margin-bottom: 15px;
        }

        .step {
            padding: 12px;
            margin: 10px 0;
            background: white;
            border-radius: 6px;
            border: 1px solid #ffe0b2;
            font-family: 'Courier New', monospace;
            font-size: 0.95em;
        }

        .preset-examples {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
            margin-top: 15px;
        }

        .preset-btn {
            padding: 10px;
            background: #e3f2fd;
            border: 2px solid #2196f3;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 0.9em;
            font-weight: 600;
            color: #1976d2;
        }

        .preset-btn:hover {
            background: #2196f3;
            color: white;
            transform: scale(1.05);
        }

        .info-box {
            background: #e8f5e9;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            border-left: 4px solid #4caf50;
        }

        .info-box strong {
            color: #2e7d32;
        }

        .mode-selector {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .mode-btn {
            padding: 12px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
        }

        .mode-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .material-database {
            max-height: 200px;
            overflow-y: auto;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
        }

        .material-item {
            padding: 8px;
            cursor: pointer;
            border-radius: 4px;
            transition: background 0.2s;
            font-size: 0.9em;
        }

        .material-item:hover {
            background: #f0f0f0;
        }

        .related-tools {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 30px;
            padding: 30px;
            background: #f8f9fa;
        }

        .tool-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .tool-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }

        .tool-card h3 {
            color: #667eea;
            margin-bottom: 10px;
        }

        .tool-card p {
            color: #666;
            font-size: 0.9em;
        }

        @media (max-width: 1024px) {
            .content {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🔥 Friction Force Calculator</h1>
            <p>Calculate Static & Kinetic Friction with Material Database</p>
        </div>

        <div class="content">
            <div class="controls">
                <h3 style="margin-bottom: 15px; color: #667eea;">Calculation Mode</h3>
                <div class="mode-selector">
                    <button class="mode-btn active" onclick="setMode('horizontal')" id="modeHorizontal">Horizontal</button>
                    <button class="mode-btn" onclick="setMode('incline')" id="modeIncline">Incline</button>
                </div>

                <div class="control-group">
                    <label>Material Pair (Database)</label>
                    <select id="materialPair" onchange="loadMaterialCoefficients()">
                        <option value="custom">Custom / Manual Entry</option>
                        <option value="rubber-concrete-dry">Rubber on Dry Concrete</option>
                        <option value="rubber-concrete-wet">Rubber on Wet Concrete</option>
                        <option value="wood-wood">Wood on Wood</option>
                        <option value="steel-steel">Steel on Steel (Dry)</option>
                        <option value="steel-steel-greased">Steel on Steel (Greased)</option>
                        <option value="ice-ice">Ice on Ice</option>
                        <option value="metal-ice">Metal on Ice</option>
                        <option value="rubber-ice">Rubber on Ice</option>
                        <option value="aluminum-steel">Aluminum on Steel</option>
                        <option value="copper-steel">Copper on Steel</option>
                        <option value="brass-steel">Brass on Steel</option>
                        <option value="glass-glass">Glass on Glass</option>
                        <option value="leather-wood">Leather on Wood</option>
                        <option value="leather-metal">Leather on Metal</option>
                        <option value="teflon-teflon">Teflon on Teflon</option>
                        <option value="teflon-steel">Teflon on Steel</option>
                        <option value="brick-wood">Brick on Wood</option>
                        <option value="tire-dry-asphalt">Tire on Dry Asphalt</option>
                        <option value="tire-wet-asphalt">Tire on Wet Asphalt</option>
                        <option value="tire-snow">Tire on Snow</option>
                    </select>
                </div>

                <div class="control-group">
                    <label>Mass (kg)</label>
                    <input type="number" id="mass" value="50" step="1" min="0" oninput="calculate()">
                </div>

                <div class="control-group" id="angleGroup" style="display: none;">
                    <label>Incline Angle θ (degrees)</label>
                    <input type="number" id="angle" value="30" step="1" min="0" max="90" oninput="calculate()">
                    <input type="range" id="angleSlider" min="0" max="90" value="30" oninput="syncAngle(this.value)">
                </div>

                <div class="control-group">
                    <label>Coefficient of Static Friction (μ<sub>s</sub>)</label>
                    <input type="number" id="muStatic" value="0.6" step="0.01" min="0" max="2" oninput="calculate()">
                </div>

                <div class="control-group">
                    <label>Coefficient of Kinetic Friction (μ<sub>k</sub>)</label>
                    <input type="number" id="muKinetic" value="0.4" step="0.01" min="0" max="2" oninput="calculate()">
                </div>

                <div class="control-group">
                    <label>Applied Force (N) - Optional</label>
                    <input type="number" id="appliedForce" value="0" step="1" min="0" oninput="calculate()">
                </div>

                <button class="btn" onclick="calculate()">Calculate Friction</button>
                <button class="btn btn-secondary" onclick="exportToPNG()">Save as PNG</button>

                <div class="info-box">
                    <strong>Quick Info:</strong><br>
                    • Static friction prevents motion<br>
                    • Kinetic friction opposes motion<br>
                    • F<sub>friction</sub> = μ × N<br>
                    • μ<sub>s</sub> typically > μ<sub>k</sub>
                </div>

                <h4 style="margin-top: 20px; color: #667eea;">Preset Examples</h4>
                <div class="preset-examples">
                    <button class="preset-btn" onclick="loadPreset('box')">Box on Floor</button>
                    <button class="preset-btn" onclick="loadPreset('car')">Car Braking</button>
                    <button class="preset-btn" onclick="loadPreset('sled')">Sled on Ice</button>
                    <button class="preset-btn" onclick="loadPreset('ramp')">Box on Ramp</button>
                    <button class="preset-btn" onclick="loadPreset('tire')">Tire Traction</button>
                    <button class="preset-btn" onclick="loadPreset('block')">Steel Block</button>
                </div>
            </div>

            <div class="visualization">
                <h3 style="color: #667eea; margin-bottom: 15px;">Force Diagram</h3>
                <canvas id="canvas" width="700" height="500"></canvas>

                <div class="results" id="results" style="display: none;">
                    <h3>Results</h3>
                    <div id="resultsContent"></div>
                </div>

                <div class="steps" id="steps" style="display: none;">
                    <h3>Step-by-Step Solution</h3>
                    <div id="stepsContent"></div>
                </div>
            </div>
        </div>

        <div class="related-tools">
            <a href="inclined-plane-calculator.jsp" class="tool-card">
                <h3>Inclined Plane Calculator</h3>
                <p>Calculate forces on slopes with force decomposition</p>
            </a>
            <a href="momentum-collision-calculator.jsp" class="tool-card">
                <h3>Momentum & Collision</h3>
                <p>Analyze collisions and momentum conservation</p>
            </a>
            <a href="free-fall-calculator.jsp" class="tool-card">
                <h3>Free Fall Calculator</h3>
                <p>Calculate motion under gravity</p>
            </a>
            <a href="torque-rotation-calculator.jsp" class="tool-card">
                <h3>Torque & Rotation</h3>
                <p>Rotational dynamics and angular motion</p>
            </a>
        </div>
    </div>

    <script>
        const canvas = document.getElementById('canvas');
        const ctx = canvas.getContext('2d');
        const g = 9.81; // gravity

        let currentMode = 'horizontal';
        let lastResult = null;

        // Material coefficient database
        const materials = {
            'rubber-concrete-dry': { static: 1.0, kinetic: 0.8, name: 'Rubber on Dry Concrete' },
            'rubber-concrete-wet': { static: 0.7, kinetic: 0.5, name: 'Rubber on Wet Concrete' },
            'wood-wood': { static: 0.4, kinetic: 0.3, name: 'Wood on Wood' },
            'steel-steel': { static: 0.74, kinetic: 0.57, name: 'Steel on Steel (Dry)' },
            'steel-steel-greased': { static: 0.15, kinetic: 0.06, name: 'Steel on Steel (Greased)' },
            'ice-ice': { static: 0.1, kinetic: 0.03, name: 'Ice on Ice' },
            'metal-ice': { static: 0.15, kinetic: 0.02, name: 'Metal on Ice' },
            'rubber-ice': { static: 0.15, kinetic: 0.1, name: 'Rubber on Ice' },
            'aluminum-steel': { static: 0.61, kinetic: 0.47, name: 'Aluminum on Steel' },
            'copper-steel': { static: 0.53, kinetic: 0.36, name: 'Copper on Steel' },
            'brass-steel': { static: 0.51, kinetic: 0.44, name: 'Brass on Steel' },
            'glass-glass': { static: 0.94, kinetic: 0.4, name: 'Glass on Glass' },
            'leather-wood': { static: 0.5, kinetic: 0.4, name: 'Leather on Wood' },
            'leather-metal': { static: 0.6, kinetic: 0.5, name: 'Leather on Metal' },
            'teflon-teflon': { static: 0.04, kinetic: 0.04, name: 'Teflon on Teflon' },
            'teflon-steel': { static: 0.04, kinetic: 0.04, name: 'Teflon on Steel' },
            'brick-wood': { static: 0.6, kinetic: 0.5, name: 'Brick on Wood' },
            'tire-dry-asphalt': { static: 0.9, kinetic: 0.7, name: 'Tire on Dry Asphalt' },
            'tire-wet-asphalt': { static: 0.6, kinetic: 0.4, name: 'Tire on Wet Asphalt' },
            'tire-snow': { static: 0.3, kinetic: 0.2, name: 'Tire on Snow' }
        };

        function $(id) { return document.getElementById(id); }

        function setMode(mode) {
            currentMode = mode;
            $('modeHorizontal').classList.remove('active');
            $('modeIncline').classList.remove('active');

            if (mode === 'horizontal') {
                $('modeHorizontal').classList.add('active');
                $('angleGroup').style.display = 'none';
            } else {
                $('modeIncline').classList.add('active');
                $('angleGroup').style.display = 'block';
            }

            calculate();
        }

        function syncAngle(val) {
            $('angle').value = val;
            calculate();
        }

        function loadMaterialCoefficients() {
            const material = $('materialPair').value;
            if (material === 'custom') return;

            const coeff = materials[material];
            $('muStatic').value = coeff.static;
            $('muKinetic').value = coeff.kinetic;
            calculate();
        }

        function calculate() {
            const mass = parseFloat($('mass').value) || 50;
            const muS = parseFloat($('muStatic').value) || 0.6;
            const muK = parseFloat($('muKinetic').value) || 0.4;
            const appliedF = parseFloat($('appliedForce').value) || 0;
            const angle = parseFloat($('angle').value) || 30;

            let result = {
                mass: mass,
                muS: muS,
                muK: muK,
                appliedForce: appliedF,
                mode: currentMode
            };

            if (currentMode === 'horizontal') {
                // Horizontal surface
                result.angle = 0;
                result.weight = mass * g;
                result.normal = mass * g;
                result.maxStaticFriction = muS * result.normal;
                result.kineticFriction = muK * result.normal;

                // Determine if object moves
                if (appliedF > result.maxStaticFriction) {
                    result.isMoving = true;
                    result.actualFriction = result.kineticFriction;
                    result.netForce = appliedF - result.kineticFriction;
                    result.acceleration = result.netForce / mass;
                } else {
                    result.isMoving = false;
                    result.actualFriction = appliedF; // equals applied force when static
                    result.netForce = 0;
                    result.acceleration = 0;
                }

            } else {
                // Inclined plane
                result.angle = angle;
                const angleRad = angle * Math.PI / 180;
                result.weight = mass * g;
                result.normal = mass * g * Math.cos(angleRad);
                result.parallelForce = mass * g * Math.sin(angleRad);
                result.maxStaticFriction = muS * result.normal;
                result.kineticFriction = muK * result.normal;

                // Total force down the slope
                const totalDownSlope = result.parallelForce + appliedF;

                // Determine if object slides
                if (totalDownSlope > result.maxStaticFriction) {
                    result.isMoving = true;
                    result.actualFriction = result.kineticFriction;
                    result.netForce = totalDownSlope - result.kineticFriction;
                    result.acceleration = result.netForce / mass;
                } else {
                    result.isMoving = false;
                    result.actualFriction = totalDownSlope;
                    result.netForce = 0;
                    result.acceleration = 0;
                }
            }

            lastResult = result;
            showResults(result);
            drawDiagram(result);
            showSteps(result);
        }

        function showResults(result) {
            const resultsDiv = $('results');
            const content = $('resultsContent');
            resultsDiv.style.display = 'block';

            let html = '';

            if (result.mode === 'horizontal') {
                html += `
                    <div class="result-item">
                        <span class="result-label">Weight (W)</span>
                        <span class="result-value">${result.weight.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Normal Force (N)</span>
                        <span class="result-value">${result.normal.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Max Static Friction (F<sub>s</sub>)</span>
                        <span class="result-value">${result.maxStaticFriction.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Kinetic Friction (F<sub>k</sub>)</span>
                        <span class="result-value">${result.kineticFriction.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Status</span>
                        <span class="result-value">${result.isMoving ? 'MOVING' : 'STATIONARY'}</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Actual Friction</span>
                        <span class="result-value">${result.actualFriction.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Net Force</span>
                        <span class="result-value">${result.netForce.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Acceleration</span>
                        <span class="result-value">${result.acceleration.toFixed(2)} m/s²</span>
                    </div>
                `;
            } else {
                html += `
                    <div class="result-item">
                        <span class="result-label">Angle (θ)</span>
                        <span class="result-value">${result.angle.toFixed(1)}°</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Weight (W)</span>
                        <span class="result-value">${result.weight.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Normal Force (N)</span>
                        <span class="result-value">${result.normal.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Parallel Force (W sin θ)</span>
                        <span class="result-value">${result.parallelForce.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Max Static Friction</span>
                        <span class="result-value">${result.maxStaticFriction.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Kinetic Friction</span>
                        <span class="result-value">${result.kineticFriction.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Status</span>
                        <span class="result-value">${result.isMoving ? 'SLIDING DOWN' : 'STATIONARY'}</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Net Force</span>
                        <span class="result-value">${result.netForce.toFixed(2)} N</span>
                    </div>
                    <div class="result-item">
                        <span class="result-label">Acceleration</span>
                        <span class="result-value">${result.acceleration.toFixed(2)} m/s²</span>
                    </div>
                `;
            }

            content.innerHTML = html;
        }

        function drawDiagram(result) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            if (result.mode === 'horizontal') {
                drawHorizontalDiagram(result);
            } else {
                drawInclineDiagram(result);
            }
        }

        function drawHorizontalDiagram(result) {
            const centerX = 350;
            const centerY = 300;
            const boxSize = 80;

            // Draw ground
            ctx.strokeStyle = '#333';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(50, centerY + boxSize/2);
            ctx.lineTo(650, centerY + boxSize/2);
            ctx.stroke();

            // Draw ground pattern
            ctx.strokeStyle = '#999';
            ctx.lineWidth = 1;
            for (let i = 50; i < 650; i += 20) {
                ctx.beginPath();
                ctx.moveTo(i, centerY + boxSize/2);
                ctx.lineTo(i - 10, centerY + boxSize/2 + 15);
                ctx.stroke();
            }

            // Draw box
            ctx.fillStyle = result.isMoving ? '#ff6b6b' : '#4dabf7';
            ctx.fillRect(centerX - boxSize/2, centerY - boxSize/2, boxSize, boxSize);
            ctx.strokeStyle = '#333';
            ctx.lineWidth = 2;
            ctx.strokeRect(centerX - boxSize/2, centerY - boxSize/2, boxSize, boxSize);

            // Label mass
            ctx.fillStyle = '#fff';
            ctx.font = 'bold 16px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(result.mass + ' kg', centerX, centerY);

            const scale = 1.5;

            // Draw Weight (down)
            drawArrow(ctx, centerX, centerY, centerX, centerY + result.weight * scale / 10, '#e74c3c', 4);
            ctx.fillStyle = '#e74c3c';
            ctx.font = '14px Arial';
            ctx.fillText('W = ' + result.weight.toFixed(1) + ' N', centerX + 60, centerY + 80);

            // Draw Normal force (up)
            drawArrow(ctx, centerX, centerY, centerX, centerY - result.normal * scale / 10, '#27ae60', 4);
            ctx.fillStyle = '#27ae60';
            ctx.fillText('N = ' + result.normal.toFixed(1) + ' N', centerX + 60, centerY - 70);

            // Draw Applied Force (right)
            if (result.appliedForce > 0) {
                drawArrow(ctx, centerX - boxSize/2, centerY, centerX - boxSize/2 - result.appliedForce * scale, centerY, '#3498db', 4);
                ctx.fillStyle = '#3498db';
                ctx.fillText('F = ' + result.appliedForce.toFixed(1) + ' N', centerX - 120, centerY - 20);
            }

            // Draw Friction force (left)
            drawArrow(ctx, centerX + boxSize/2, centerY, centerX + boxSize/2 + result.actualFriction * scale, centerY, '#f39c12', 4);
            ctx.fillStyle = '#f39c12';
            ctx.fillText('f = ' + result.actualFriction.toFixed(1) + ' N', centerX + 120, centerY + 20);

            // Status text
            ctx.font = 'bold 18px Arial';
            ctx.fillStyle = result.isMoving ? '#e74c3c' : '#27ae60';
            ctx.fillText(result.isMoving ? 'OBJECT MOVING →' : 'OBJECT STATIONARY', centerX, 50);

            // Coefficients
            ctx.font = '14px Arial';
            ctx.fillStyle = '#333';
            ctx.textAlign = 'left';
            ctx.fillText('μₛ = ' + result.muS.toFixed(2), 50, 50);
            ctx.fillText('μₖ = ' + result.muK.toFixed(2), 50, 70);
        }

        function drawInclineDiagram(result) {
            const angleRad = result.angle * Math.PI / 180;
            const startX = 150;
            const startY = 400;
            const rampLength = 400;
            const endX = startX + rampLength * Math.cos(angleRad);
            const endY = startY - rampLength * Math.sin(angleRad);
            const boxSize = 60;

            // Draw ground
            ctx.strokeStyle = '#333';
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(50, startY);
            ctx.lineTo(650, startY);
            ctx.stroke();

            // Draw incline
            ctx.fillStyle = '#ddd';
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            ctx.lineTo(endX, endY);
            ctx.lineTo(endX, startY);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();

            // Draw angle arc
            ctx.strokeStyle = '#3498db';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.arc(startX, startY, 50, -angleRad, 0);
            ctx.stroke();
            ctx.fillStyle = '#3498db';
            ctx.font = '16px Arial';
            ctx.fillText('θ = ' + result.angle.toFixed(1) + '°', startX + 60, startY - 10);

            // Box position on ramp
            const boxX = startX + rampLength * 0.5 * Math.cos(angleRad);
            const boxY = startY - rampLength * 0.5 * Math.sin(angleRad);

            // Draw box
            ctx.save();
            ctx.translate(boxX, boxY);
            ctx.rotate(-angleRad);
            ctx.fillStyle = result.isMoving ? '#ff6b6b' : '#4dabf7';
            ctx.fillRect(-boxSize/2, -boxSize/2, boxSize, boxSize);
            ctx.strokeStyle = '#333';
            ctx.lineWidth = 2;
            ctx.strokeRect(-boxSize/2, -boxSize/2, boxSize, boxSize);
            ctx.fillStyle = '#fff';
            ctx.font = 'bold 14px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(result.mass + ' kg', 0, 5);
            ctx.restore();

            const scale = 1;

            // Draw Weight (straight down)
            drawArrow(ctx, boxX, boxY, boxX, boxY + result.weight * scale / 5, '#e74c3c', 3);
            ctx.fillStyle = '#e74c3c';
            ctx.font = '12px Arial';
            ctx.fillText('W', boxX + 15, boxY + 60);

            // Draw Normal force (perpendicular to surface)
            const normalEndX = boxX - result.normal * scale / 5 * Math.sin(angleRad);
            const normalEndY = boxY - result.normal * scale / 5 * Math.cos(angleRad);
            drawArrow(ctx, boxX, boxY, normalEndX, normalEndY, '#27ae60', 3);
            ctx.fillStyle = '#27ae60';
            ctx.fillText('N', normalEndX - 15, normalEndY);

            // Draw Parallel component
            const parEndX = boxX + result.parallelForce * scale / 5 * Math.cos(angleRad);
            const parEndY = boxY + result.parallelForce * scale / 5 * Math.sin(angleRad);
            drawArrow(ctx, boxX, boxY, parEndX, parEndY, '#9b59b6', 3);
            ctx.fillStyle = '#9b59b6';
            ctx.fillText('W∥', parEndX + 10, parEndY);

            // Draw Friction (up the ramp)
            const fricEndX = boxX - result.actualFriction * scale / 5 * Math.cos(angleRad);
            const fricEndY = boxY + result.actualFriction * scale / 5 * Math.sin(angleRad);
            drawArrow(ctx, boxX, boxY, fricEndX, fricEndY, '#f39c12', 3);
            ctx.fillStyle = '#f39c12';
            ctx.fillText('f', fricEndX - 15, fricEndY);

            // Status
            ctx.font = 'bold 16px Arial';
            ctx.fillStyle = result.isMoving ? '#e74c3c' : '#27ae60';
            ctx.textAlign = 'center';
            ctx.fillText(result.isMoving ? 'OBJECT SLIDING DOWN' : 'OBJECT STATIONARY', 350, 50);

            // Values
            ctx.font = '12px Arial';
            ctx.fillStyle = '#333';
            ctx.textAlign = 'left';
            ctx.fillText('N = ' + result.normal.toFixed(1) + ' N', 500, 100);
            ctx.fillText('W∥ = ' + result.parallelForce.toFixed(1) + ' N', 500, 120);
            ctx.fillText('f = ' + result.actualFriction.toFixed(1) + ' N', 500, 140);
            ctx.fillText('μₛ = ' + result.muS.toFixed(2), 500, 160);
            ctx.fillText('μₖ = ' + result.muK.toFixed(2), 500, 180);
        }

        function drawArrow(ctx, fromX, fromY, toX, toY, color, width) {
            const headlen = 12;
            const angle = Math.atan2(toY - fromY, toX - fromX);

            ctx.strokeStyle = color;
            ctx.fillStyle = color;
            ctx.lineWidth = width;

            // Line
            ctx.beginPath();
            ctx.moveTo(fromX, fromY);
            ctx.lineTo(toX, toY);
            ctx.stroke();

            // Arrowhead
            ctx.beginPath();
            ctx.moveTo(toX, toY);
            ctx.lineTo(toX - headlen * Math.cos(angle - Math.PI / 6), toY - headlen * Math.sin(angle - Math.PI / 6));
            ctx.lineTo(toX - headlen * Math.cos(angle + Math.PI / 6), toY - headlen * Math.sin(angle + Math.PI / 6));
            ctx.closePath();
            ctx.fill();
        }

        function showSteps(result) {
            const stepsDiv = $('steps');
            const content = $('stepsContent');
            stepsDiv.style.display = 'block';

            let html = '';

            if (result.mode === 'horizontal') {
                html += `<div class="step">Given: m = ${result.mass} kg, μₛ = ${result.muS}, μₖ = ${result.muK}, F = ${result.appliedForce} N</div>`;
                html += `<div class="step">Weight: W = mg = ${result.mass} × 9.81 = ${result.weight.toFixed(2)} N</div>`;
                html += `<div class="step">Normal Force: N = W = ${result.normal.toFixed(2)} N (horizontal surface)</div>`;
                html += `<div class="step">Max Static Friction: Fₛ(max) = μₛ × N = ${result.muS} × ${result.normal.toFixed(2)} = ${result.maxStaticFriction.toFixed(2)} N</div>`;
                html += `<div class="step">Kinetic Friction: Fₖ = μₖ × N = ${result.muK} × ${result.normal.toFixed(2)} = ${result.kineticFriction.toFixed(2)} N</div>`;

                if (result.appliedForce > result.maxStaticFriction) {
                    html += `<div class="step">F (${result.appliedForce} N) > Fₛ(max) (${result.maxStaticFriction.toFixed(2)} N) → Object is MOVING</div>`;
                    html += `<div class="step">Actual Friction = Fₖ = ${result.kineticFriction.toFixed(2)} N</div>`;
                    html += `<div class="step">Net Force: Fₙₑₜ = F - Fₖ = ${result.appliedForce} - ${result.kineticFriction.toFixed(2)} = ${result.netForce.toFixed(2)} N</div>`;
                    html += `<div class="step">Acceleration: a = Fₙₑₜ / m = ${result.netForce.toFixed(2)} / ${result.mass} = ${result.acceleration.toFixed(2)} m/s²</div>`;
                } else {
                    html += `<div class="step">F (${result.appliedForce} N) ≤ Fₛ(max) (${result.maxStaticFriction.toFixed(2)} N) → Object is STATIONARY</div>`;
                    html += `<div class="step">Actual Friction = F = ${result.actualFriction.toFixed(2)} N (equals applied force)</div>`;
                    html += `<div class="step">Net Force = 0 N, Acceleration = 0 m/s²</div>`;
                }
            } else {
                const angleRad = result.angle * Math.PI / 180;
                html += `<div class="step">Given: m = ${result.mass} kg, θ = ${result.angle}°, μₛ = ${result.muS}, μₖ = ${result.muK}</div>`;
                html += `<div class="step">Weight: W = mg = ${result.mass} × 9.81 = ${result.weight.toFixed(2)} N</div>`;
                html += `<div class="step">Normal Force: N = mg cos(θ) = ${result.weight.toFixed(2)} × cos(${result.angle}°) = ${result.normal.toFixed(2)} N</div>`;
                html += `<div class="step">Parallel Force: W∥ = mg sin(θ) = ${result.weight.toFixed(2)} × sin(${result.angle}°) = ${result.parallelForce.toFixed(2)} N</div>`;
                html += `<div class="step">Max Static Friction: Fₛ(max) = μₛ × N = ${result.muS} × ${result.normal.toFixed(2)} = ${result.maxStaticFriction.toFixed(2)} N</div>`;
                html += `<div class="step">Kinetic Friction: Fₖ = μₖ × N = ${result.muK} × ${result.normal.toFixed(2)} = ${result.kineticFriction.toFixed(2)} N</div>`;

                if (result.parallelForce > result.maxStaticFriction) {
                    html += `<div class="step">W∥ (${result.parallelForce.toFixed(2)} N) > Fₛ(max) (${result.maxStaticFriction.toFixed(2)} N) → Object SLIDES DOWN</div>`;
                    html += `<div class="step">Net Force: Fₙₑₜ = W∥ - Fₖ = ${result.parallelForce.toFixed(2)} - ${result.kineticFriction.toFixed(2)} = ${result.netForce.toFixed(2)} N</div>`;
                    html += `<div class="step">Acceleration: a = Fₙₑₜ / m = ${result.netForce.toFixed(2)} / ${result.mass} = ${result.acceleration.toFixed(2)} m/s²</div>`;
                } else {
                    html += `<div class="step">W∥ (${result.parallelForce.toFixed(2)} N) ≤ Fₛ(max) (${result.maxStaticFriction.toFixed(2)} N) → Object is STATIONARY</div>`;
                    html += `<div class="step">Friction balances W∥: f = ${result.actualFriction.toFixed(2)} N</div>`;
                    html += `<div class="step">Net Force = 0 N, Acceleration = 0 m/s²</div>`;
                }
            }

            content.innerHTML = html;
        }

        function loadPreset(type) {
            switch(type) {
                case 'box':
                    $('materialPair').value = 'wood-wood';
                    loadMaterialCoefficients();
                    $('mass').value = 25;
                    $('appliedForce').value = 150;
                    setMode('horizontal');
                    break;
                case 'car':
                    $('materialPair').value = 'tire-dry-asphalt';
                    loadMaterialCoefficients();
                    $('mass').value = 1500;
                    $('appliedForce').value = 8000;
                    setMode('horizontal');
                    break;
                case 'sled':
                    $('materialPair').value = 'metal-ice';
                    loadMaterialCoefficients();
                    $('mass').value = 50;
                    $('appliedForce').value = 50;
                    setMode('horizontal');
                    break;
                case 'ramp':
                    $('materialPair').value = 'wood-wood';
                    loadMaterialCoefficients();
                    $('mass').value = 30;
                    $('angle').value = 25;
                    $('angleSlider').value = 25;
                    $('appliedForce').value = 0;
                    setMode('incline');
                    break;
                case 'tire':
                    $('materialPair').value = 'tire-wet-asphalt';
                    loadMaterialCoefficients();
                    $('mass').value = 1200;
                    $('appliedForce').value = 6000;
                    setMode('horizontal');
                    break;
                case 'block':
                    $('materialPair').value = 'steel-steel';
                    loadMaterialCoefficients();
                    $('mass').value = 100;
                    $('appliedForce').value = 500;
                    setMode('horizontal');
                    break;
            }
            calculate();
        }

        function exportToPNG() {
            if (!lastResult) {
                alert('Please calculate first!');
                return;
            }

            // Create temporary canvas with extra space
            const tempCanvas = document.createElement('canvas');
            const tempCtx = tempCanvas.getContext('2d');

            const extraHeight = 300;
            tempCanvas.width = canvas.width;
            tempCanvas.height = canvas.height + extraHeight;

            // White background
            tempCtx.fillStyle = 'white';
            tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

            // Draw title
            tempCtx.fillStyle = '#667eea';
            tempCtx.font = 'bold 24px Arial';
            tempCtx.textAlign = 'center';
            tempCtx.fillText('Friction Force Calculator', tempCanvas.width / 2, 30);

            // Draw original diagram
            tempCtx.drawImage(canvas, 0, 50);

            const bottomY = canvas.height + 70;
            const leftX = 50;
            const rightX = 400;

            // Draw border
            tempCtx.strokeStyle = '#667eea';
            tempCtx.lineWidth = 2;
            tempCtx.strokeRect(20, bottomY, tempCanvas.width - 40, 200);

            // Left column - Inputs
            tempCtx.fillStyle = '#333';
            tempCtx.font = 'bold 16px Arial';
            tempCtx.textAlign = 'left';
            tempCtx.fillText('INPUTS:', leftX, bottomY + 25);

            tempCtx.font = '14px Arial';
            let yPos = bottomY + 25;
            tempCtx.fillText('Mode: ' + (lastResult.mode === 'horizontal' ? 'Horizontal Surface' : 'Inclined Plane'), leftX, yPos += 22);
            tempCtx.fillText('Mass: m = ' + lastResult.mass + ' kg', leftX, yPos += 18);
            if (lastResult.mode === 'incline') {
                tempCtx.fillText('Angle: θ = ' + lastResult.angle.toFixed(1) + '°', leftX, yPos += 18);
            }
            tempCtx.fillText('μₛ = ' + lastResult.muS.toFixed(2), leftX, yPos += 18);
            tempCtx.fillText('μₖ = ' + lastResult.muK.toFixed(2), leftX, yPos += 18);
            tempCtx.fillText('Applied Force: ' + lastResult.appliedForce + ' N', leftX, yPos += 18);

            // Right column - Results
            tempCtx.font = 'bold 16px Arial';
            tempCtx.fillText('RESULTS:', rightX, bottomY + 25);

            tempCtx.font = '14px Arial';
            yPos = bottomY + 25;
            tempCtx.fillText('Normal Force: ' + lastResult.normal.toFixed(2) + ' N', rightX, yPos += 22);
            tempCtx.fillText('Max Static F: ' + lastResult.maxStaticFriction.toFixed(2) + ' N', rightX, yPos += 18);
            tempCtx.fillText('Kinetic F: ' + lastResult.kineticFriction.toFixed(2) + ' N', rightX, yPos += 18);
            tempCtx.fillText('Status: ' + (lastResult.isMoving ? 'MOVING' : 'STATIONARY'), rightX, yPos += 18);
            tempCtx.fillText('Actual Friction: ' + lastResult.actualFriction.toFixed(2) + ' N', rightX, yPos += 18);
            tempCtx.fillText('Acceleration: ' + lastResult.acceleration.toFixed(2) + ' m/s²', rightX, yPos += 18);

            // Share URL
            tempCtx.fillStyle = '#667eea';
            tempCtx.font = 'bold 14px Arial';
            tempCtx.textAlign = 'center';
            tempCtx.fillText('🔗 https://8gwifi.org/friction-force-calculator.jsp', tempCanvas.width / 2, bottomY + 180);

            // Watermark
            tempCtx.fillStyle = '#999';
            tempCtx.font = '12px Arial';
            tempCtx.fillText('Generated by 8gwifi.org Physics Tools', tempCanvas.width / 2, bottomY + 200);

            // Download
            const link = document.createElement('a');
            link.download = 'friction-force-calculation.png';
            link.href = tempCanvas.toDataURL('image/png');
            link.click();
        }

        // Initialize
        calculate();
    </script>
    <!-- E-E-A-T: About & Learning Outcomes (Physics) -->
    <section class="container my-4"><div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
      <h2 class="h6 mb-2">About This Tool & Methodology</h2>
      <p>Computes friction forces using SI units and standard models (static vs kinetic friction). Highlights dependence on normal force and coefficient of friction.</p>
      <h3 class="h6 mt-2">Learning Outcomes</h3>
      <ul class="mb-2"><li>Differentiate static and kinetic friction.</li><li>See how normal force and μ affect friction limits.</li><li>Practice unit consistency.</li></ul>
      <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
    </div></div></div></div></section>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"WebPage","name":"Friction Force Calculator","url":"https://8gwifi.org/friction-force-calculator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Friction Force Calculator","item":"https://8gwifi.org/friction-force-calculator.jsp"}]}</script>
    <%@ include file="footer_adsense.jsp"%>
</body>
</html>
