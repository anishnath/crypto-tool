
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free Doppler Effect Calculator - Calculate frequency shifts for sound and light waves. Analyze moving sources, observers, ambulance sirens, redshift, blueshift, and radar. Includes interactive wave animations.">
    <meta name="keywords" content="doppler effect, frequency shift, redshift, blueshift, sound waves, light waves, doppler calculator, ambulance siren, radar, astronomy">
    <meta name="author" content="8gwifi.org">

    <!-- Open Graph -->
    <meta property="og:title" content="Doppler Effect Calculator - Sound & Light Wave Frequency Shift">
    <meta property="og:description" content="Calculate Doppler frequency shifts for moving sources and observers. Interactive animations for sound and light waves.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/doppler-effect-calculator.jsp">

    <title>Doppler Effect Calculator - Sound & Light Frequency Shift | 8gwifi.org</title>

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Doppler Effect Calculator",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Web Browser",
      "description": "Calculate frequency shifts due to relative motion for sound and light waves with interactive visualization",
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
          "name": "What is the Doppler Effect?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The Doppler Effect is the change in frequency of a wave (sound, light, etc.) when the source or observer is moving relative to each other. When approaching, frequency increases (higher pitch/blueshift). When receding, frequency decreases (lower pitch/redshift). Formula: f' = f × (v ± v_obs) / (v ∓ v_src) for sound."
          }
        },
        {
          "@type": "Question",
          "name": "How does the Doppler Effect apply to sound waves?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "For sound, the observed frequency f' = f × (v ± v_observer) / (v ∓ v_source), where v is the speed of sound (343 m/s at 20°C). Use + when approaching, - when receding. This explains why ambulance sirens sound higher-pitched when approaching and lower when moving away."
          }
        },
        {
          "@type": "Question",
          "name": "What is redshift and blueshift in astronomy?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Redshift occurs when light from distant objects shifts to lower frequencies (longer wavelengths, toward red) as they move away. Blueshift is the opposite - higher frequencies (shorter wavelengths, toward blue) when approaching. This is how astronomers measure galaxy velocities and universe expansion using spectral line analysis."
          }
        },
        {
          "@type": "Question",
          "name": "How do you calculate Doppler shift for light waves?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "For light, use the relativistic formula: f' = f × √[(c - v)/(c + v)] when receding, where c is light speed (3×10⁸ m/s) and v is velocity. For small velocities (v << c), the approximation Δf/f ≈ v/c works. For astronomical redshift: z = (λ_observed - λ_emitted) / λ_emitted = v/c."
          }
        },
        {
          "@type": "Question",
          "name": "What are real-world applications of the Doppler Effect?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Applications include: 1) Radar speed guns (police, baseball), 2) Weather radar (storm tracking), 3) Medical ultrasound (blood flow), 4) Astronomy (galaxy velocities, exoplanets), 5) Aviation (collision avoidance), 6) Sonar (submarines), and 7) Traffic flow monitoring."
          }
        },
        {
          "@type": "Question",
          "name": "Does the Doppler Effect work when both source and observer are moving?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "Yes! When both move, use f' = f × (v + v_observer) / (v - v_source) for approaching, or f' = f × (v - v_observer) / (v + v_source) for receding. The effect depends on relative velocity. Our calculator handles all scenarios: stationary source, moving observer, moving source, or both moving."
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
        {"@type": "ListItem", "position": 3, "name": "Doppler Effect", "item": "https://8gwifi.org/doppler-effect-calculator.jsp"}
      ]
    }
    </script>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            border-color: #4facfe;
        }

        .slider-container {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 5px;
        }

        .slider-container input[type="range"] {
            flex: 1;
        }

        .slider-container span {
            min-width: 80px;
            font-weight: 600;
            color: #4facfe;
        }

        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
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
            box-shadow: 0 5px 15px rgba(79, 172, 254, 0.4);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
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
            border-left: 4px solid #4facfe;
        }

        .results h3 {
            color: #4facfe;
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
            color: #4facfe;
            font-weight: 700;
            font-family: 'Courier New', monospace;
        }

        .result-value.increase {
            color: #0088ff;
        }

        .result-value.decrease {
            color: #ff3860;
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
            grid-template-columns: repeat(2, 1fr);
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
            background: #4facfe;
            color: white;
            border-color: #4facfe;
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
            color: #4facfe;
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
            <h1>🌊 Doppler Effect Calculator</h1>
            <p>Calculate Frequency Shifts for Sound & Light Waves</p>
        </div>

        <div class="content">
            <div class="controls">
                <h3 style="margin-bottom: 15px; color: #4facfe;">Wave Type</h3>
                <div class="mode-selector">
                    <button class="mode-btn active" onclick="setWaveType('sound')" id="modeSound">Sound Waves</button>
                    <button class="mode-btn" onclick="setWaveType('light')" id="modeLight">Light Waves</button>
                </div>

                <div class="control-group">
                    <label>Scenario</label>
                    <select id="scenario" onchange="updateScenario()">
                        <option value="source-moving">Moving Source (Observer Stationary)</option>
                        <option value="observer-moving">Moving Observer (Source Stationary)</option>
                        <option value="both-moving">Both Moving</option>
                        <option value="head-on">Head-On Collision</option>
                    </select>
                </div>

                <div class="control-group">
                    <label>Source Frequency f (Hz)</label>
                    <input type="number" id="frequency" value="500" step="10" min="0" oninput="calculate()">
                    <div class="slider-container">
                        <input type="range" id="freqSlider" min="20" max="20000" value="500" oninput="syncFreq(this.value)">
                        <span id="freqValue">500 Hz</span>
                    </div>
                </div>

                <div class="control-group" id="tempGroup">
                    <label>Temperature (°C) - Affects Sound Speed</label>
                    <input type="number" id="temperature" value="20" step="1" min="-50" max="50" oninput="calculate()">
                </div>

                <div class="control-group" id="sourceSpeedGroup">
                    <label>Source Velocity (m/s)</label>
                    <input type="number" id="sourceSpeed" value="30" step="1" min="0" oninput="calculate()">
                    <div class="slider-container">
                        <input type="range" id="sourceSlider" min="0" max="100" value="30" oninput="syncSourceSpeed(this.value)">
                        <span id="sourceValue">30 m/s</span>
                    </div>
                </div>

                <div class="control-group" id="observerSpeedGroup">
                    <label>Observer Velocity (m/s)</label>
                    <input type="number" id="observerSpeed" value="0" step="1" min="0" oninput="calculate()">
                    <div class="slider-container">
                        <input type="range" id="observerSlider" min="0" max="100" value="0" oninput="syncObserverSpeed(this.value)">
                        <span id="observerValue">0 m/s</span>
                    </div>
                </div>

                <div class="control-group">
                    <label>Direction</label>
                    <select id="direction" onchange="calculate()">
                        <option value="approaching">Approaching (Coming Together)</option>
                        <option value="receding">Receding (Moving Apart)</option>
                    </select>
                </div>

                <button class="btn" onclick="calculate()">Calculate Doppler Shift</button>
                <button class="btn btn-secondary" onclick="exportToPNG()">Save as PNG</button>

                <div class="info-box">
                    <strong>Quick Tips:</strong><br>
                    • Approaching → Higher frequency<br>
                    • Receding → Lower frequency<br>
                    • Sound: v ≈ 343 m/s at 20°C<br>
                    • Light: c = 299,792,458 m/s
                </div>

                <h4 style="margin-top: 20px; color: #4facfe;">Preset Examples</h4>
                <div class="preset-examples">
                    <button class="preset-btn" onclick="loadPreset('ambulance')">Ambulance Siren</button>
                    <button class="preset-btn" onclick="loadPreset('train')">Train Horn</button>
                    <button class="preset-btn" onclick="loadPreset('radar')">Police Radar</button>
                    <button class="preset-btn" onclick="loadPreset('galaxy')">Galaxy Redshift</button>
                    <button class="preset-btn" onclick="loadPreset('bat')">Bat Echolocation</button>
                    <button class="preset-btn" onclick="loadPreset('star')">Star Blueshift</button>
                </div>
            </div>

            <div class="visualization">
                <h3 style="color: #4facfe; margin-bottom: 15px;">Wave Pattern Visualization</h3>
                <canvas id="canvas" width="700" height="500"></canvas>

                <div class="results" id="results" style="display: none;">
                    <h3>Doppler Shift Results</h3>
                    <div id="resultsContent"></div>
                </div>

                <div class="steps" id="steps" style="display: none;">
                    <h3>Step-by-Step Calculation</h3>
                    <div id="stepsContent"></div>
                </div>
            </div>
        </div>

        <div class="related-tools">
            <a href="free-fall-calculator.jsp" class="tool-card">
                <h3>Free Fall Calculator</h3>
                <p>Calculate motion under gravity</p>
            </a>
            <a href="centripetal-force-calculator.jsp" class="tool-card">
                <h3>Centripetal Force</h3>
                <p>Circular motion and acceleration</p>
            </a>
            <a href="momentum-collision-calculator.jsp" class="tool-card">
                <h3>Momentum & Collision</h3>
                <p>Analyze impacts and conservation</p>
            </a>
            <a href="torque-rotation-calculator.jsp" class="tool-card">
                <h3>Torque & Rotation</h3>
                <p>Rotational dynamics calculator</p>
            </a>
        </div>
    </div>

    <script>
        const canvas = document.getElementById('canvas');
        const ctx = canvas.getContext('2d');

        let currentWaveType = 'sound';
        let lastResult = null;
        let animationTime = 0;
        let animationId = null;

        const c = 299792458; // Speed of light (m/s)

        function $(id) { return document.getElementById(id); }

        function setWaveType(type) {
            currentWaveType = type;
            $('modeSound').classList.remove('active');
            $('modeLight').classList.remove('active');

            if (type === 'sound') {
                $('modeSound').classList.add('active');
                $('tempGroup').style.display = 'block';
                $('sourceSlider').max = 100;
                $('observerSlider').max = 100;
                $('frequency').value = 500;
                $('freqSlider').max = 20000;
            } else {
                $('modeLight').classList.add('active');
                $('tempGroup').style.display = 'none';
                $('sourceSlider').max = 100000000; // 10^8 m/s
                $('observerSlider').max = 100000000;
                $('frequency').value = 500000000000000; // 500 THz (green light)
                $('freqSlider').max = 1000000000000000;
            }

            calculate();
        }

        function updateScenario() {
            const scenario = $('scenario').value;

            if (scenario === 'source-moving') {
                $('sourceSpeedGroup').style.display = 'block';
                $('observerSpeedGroup').style.display = 'none';
                $('observerSpeed').value = 0;
            } else if (scenario === 'observer-moving') {
                $('sourceSpeedGroup').style.display = 'none';
                $('observerSpeedGroup').style.display = 'block';
                $('sourceSpeed').value = 0;
            } else if (scenario === 'both-moving') {
                $('sourceSpeedGroup').style.display = 'block';
                $('observerSpeedGroup').style.display = 'block';
            } else if (scenario === 'head-on') {
                $('sourceSpeedGroup').style.display = 'block';
                $('observerSpeedGroup').style.display = 'block';
                $('direction').value = 'approaching';
            }

            calculate();
        }

        function syncFreq(val) {
            $('frequency').value = val;
            $('freqValue').textContent = val + ' Hz';
            calculate();
        }

        function syncSourceSpeed(val) {
            $('sourceSpeed').value = val;
            $('sourceValue').textContent = val + ' m/s';
            calculate();
        }

        function syncObserverSpeed(val) {
            $('observerSpeed').value = val;
            $('observerValue').textContent = val + ' m/s';
            calculate();
        }

        function getSpeedOfSound(tempC) {
            // v = 331.3 + 0.606 * T (°C)
            return 331.3 + 0.606 * tempC;
        }

        function calculate() {
            const f = parseFloat($('frequency').value) || 500;
            const vSource = parseFloat($('sourceSpeed').value) || 0;
            const vObserver = parseFloat($('observerSpeed').value) || 0;
            const direction = $('direction').value;
            const temp = parseFloat($('temperature').value) || 20;

            let result = {
                frequency: f,
                vSource: vSource,
                vObserver: vObserver,
                direction: direction,
                waveType: currentWaveType
            };

            if (currentWaveType === 'sound') {
                const v = getSpeedOfSound(temp);
                result.waveSpeed = v;
                result.temperature = temp;

                // Doppler formula for sound
                // f' = f * (v ± v_observer) / (v ∓ v_source)
                // + observer approaching, - receding
                // - source approaching, + receding

                let numerator, denominator;

                if (direction === 'approaching') {
                    numerator = v + vObserver;
                    denominator = v - vSource;
                } else {
                    numerator = v - vObserver;
                    denominator = v + vSource;
                }

                result.observedFrequency = f * (numerator / denominator);
                result.frequencyChange = result.observedFrequency - f;
                result.percentChange = (result.frequencyChange / f) * 100;

            } else {
                // Light waves - relativistic Doppler
                result.waveSpeed = c;

                const beta = vSource / c; // Assuming source moving

                if (direction === 'approaching') {
                    // Blueshift
                    result.observedFrequency = f * Math.sqrt((1 + beta) / (1 - beta));
                } else {
                    // Redshift
                    result.observedFrequency = f * Math.sqrt((1 - beta) / (1 + beta));
                }

                result.frequencyChange = result.observedFrequency - f;
                result.percentChange = (result.frequencyChange / f) * 100;
                result.redshift = (result.observedFrequency - f) / f;
            }

            // Calculate wavelengths
            result.wavelength = result.waveSpeed / f;
            result.observedWavelength = result.waveSpeed / result.observedFrequency;

            lastResult = result;
            showResults(result);
            startAnimation();
            showSteps(result);
        }

        function showResults(result) {
            const resultsDiv = $('results');
            const content = $('resultsContent');
            resultsDiv.style.display = 'block';

            const increasing = result.frequencyChange > 0;
            const changeClass = increasing ? 'increase' : 'decrease';

            let html = '';

            html += `
                <div class="result-item">
                    <span class="result-label">Original Frequency (f)</span>
                    <span class="result-value">${result.frequency.toExponential(2)} Hz</span>
                </div>
                <div class="result-item">
                    <span class="result-label">Observed Frequency (f')</span>
                    <span class="result-value ${changeClass}">${result.observedFrequency.toExponential(2)} Hz</span>
                </div>
                <div class="result-item">
                    <span class="result-label">Frequency Change (Δf)</span>
                    <span class="result-value ${changeClass}">${result.frequencyChange > 0 ? '+' : ''}${result.frequencyChange.toExponential(2)} Hz</span>
                </div>
                <div class="result-item">
                    <span class="result-label">Percent Change</span>
                    <span class="result-value ${changeClass}">${result.percentChange > 0 ? '+' : ''}${result.percentChange.toFixed(2)}%</span>
                </div>
                <div class="result-item">
                    <span class="result-label">Original Wavelength (λ)</span>
                    <span class="result-value">${result.wavelength.toExponential(2)} m</span>
                </div>
                <div class="result-item">
                    <span class="result-label">Observed Wavelength (λ')</span>
                    <span class="result-value">${result.observedWavelength.toExponential(2)} m</span>
                </div>
                <div class="result-item">
                    <span class="result-label">Wave Speed</span>
                    <span class="result-value">${result.waveSpeed.toFixed(2)} m/s</span>
                </div>
            `;

            if (result.waveType === 'sound') {
                html += `
                    <div class="result-item">
                        <span class="result-label">Temperature</span>
                        <span class="result-value">${result.temperature}°C</span>
                    </div>
                `;
            } else {
                html += `
                    <div class="result-item">
                        <span class="result-label">Redshift (z)</span>
                        <span class="result-value">${result.redshift.toFixed(6)}</span>
                    </div>
                `;
            }

            html += `
                <div class="result-item">
                    <span class="result-label">Effect Type</span>
                    <span class="result-value ${changeClass}">${increasing ? (result.waveType === 'light' ? 'BLUESHIFT' : 'PITCH INCREASE') : (result.waveType === 'light' ? 'REDSHIFT' : 'PITCH DECREASE')}</span>
                </div>
            `;

            content.innerHTML = html;
        }

        function startAnimation() {
            if (animationId) cancelAnimationFrame(animationId);

            function animate() {
                animationTime += 0.05;
                drawVisualization(lastResult);
                animationId = requestAnimationFrame(animate);
            }

            animate();
        }

        function drawVisualization(result) {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            const centerY = canvas.height / 2;
            const sourceX = result.direction === 'approaching' ? 100 : 600;
            const observerX = result.direction === 'approaching' ? 600 : 100;

            // Draw source
            ctx.fillStyle = '#ff6b6b';
            ctx.beginPath();
            ctx.arc(sourceX, centerY, 20, 0, Math.PI * 2);
            ctx.fill();
            ctx.strokeStyle = '#333';
            ctx.lineWidth = 2;
            ctx.stroke();

            ctx.fillStyle = '#fff';
            ctx.font = 'bold 14px Arial';
            ctx.textAlign = 'center';
            ctx.fillText('S', sourceX, centerY + 5);

            // Draw observer
            ctx.fillStyle = '#4dabf7';
            ctx.beginPath();
            ctx.arc(observerX, centerY, 20, 0, Math.PI * 2);
            ctx.fill();
            ctx.strokeStyle = '#333';
            ctx.lineWidth = 2;
            ctx.stroke();

            ctx.fillStyle = '#fff';
            ctx.fillText('O', observerX, centerY + 5);

            // Draw wave fronts
            const numWaves = 8;
            const spacing = result.direction === 'approaching' ? 40 : 60;

            for (let i = 0; i < numWaves; i++) {
                const phase = animationTime + i * 0.8;
                let radius = (phase * 30) % (spacing * numWaves);

                // Doppler effect - compress/expand waves
                if (result.direction === 'approaching') {
                    radius *= 0.7; // Compress
                } else {
                    radius *= 1.3; // Expand
                }

                ctx.strokeStyle = `rgba(79, 172, 254, ${1 - (i / numWaves)})`;
                ctx.lineWidth = 2;
                ctx.beginPath();
                ctx.arc(sourceX, centerY, radius, 0, Math.PI * 2);
                ctx.stroke();
            }

            // Draw velocity arrows
            if (result.vSource > 0) {
                const arrowDir = result.direction === 'approaching' ? 1 : -1;
                drawVelocityArrow(ctx, sourceX, centerY - 50, arrowDir, result.vSource + ' m/s', '#ff6b6b');
            }

            if (result.vObserver > 0) {
                const arrowDir = result.direction === 'approaching' ? -1 : 1;
                drawVelocityArrow(ctx, observerX, centerY - 50, arrowDir, result.vObserver + ' m/s', '#4dabf7');
            }

            // Labels
            ctx.fillStyle = '#333';
            ctx.font = '14px Arial';
            ctx.textAlign = 'center';
            ctx.fillText('Source', sourceX, centerY + 50);
            ctx.fillText('f = ' + result.frequency.toFixed(0) + ' Hz', sourceX, centerY + 68);

            ctx.fillText('Observer', observerX, centerY + 50);
            ctx.fillText("f' = " + result.observedFrequency.toFixed(0) + ' Hz', observerX, centerY + 68);

            // Direction indicator
            ctx.font = 'bold 16px Arial';
            ctx.fillStyle = result.direction === 'approaching' ? '#0088ff' : '#ff3860';
            ctx.fillText(result.direction === 'approaching' ? '← APPROACHING →' : '→ RECEDING ←', canvas.width / 2, 50);

            // Frequency shift indicator
            const shift = result.frequencyChange > 0 ? '↑ HIGHER PITCH' : '↓ LOWER PITCH';
            if (result.waveType === 'light') {
                ctx.fillText(result.frequencyChange > 0 ? '↑ BLUESHIFT' : '↓ REDSHIFT', canvas.width / 2, canvas.height - 30);
            } else {
                ctx.fillText(shift, canvas.width / 2, canvas.height - 30);
            }
        }

        function drawVelocityArrow(ctx, x, y, direction, label, color) {
            const length = 60;
            const endX = x + direction * length;

            ctx.strokeStyle = color;
            ctx.fillStyle = color;
            ctx.lineWidth = 3;

            // Line
            ctx.beginPath();
            ctx.moveTo(x, y);
            ctx.lineTo(endX, y);
            ctx.stroke();

            // Arrowhead
            ctx.beginPath();
            ctx.moveTo(endX, y);
            ctx.lineTo(endX - direction * 10, y - 6);
            ctx.lineTo(endX - direction * 10, y + 6);
            ctx.closePath();
            ctx.fill();

            // Label
            ctx.font = '12px Arial';
            ctx.fillStyle = color;
            ctx.textAlign = 'center';
            ctx.fillText(label, x + direction * length / 2, y - 10);
        }

        function showSteps(result) {
            const stepsDiv = $('steps');
            const content = $('stepsContent');
            stepsDiv.style.display = 'block';

            let html = '';

            if (result.waveType === 'sound') {
                html += `<div class="step">Given: f = ${result.frequency} Hz, v_source = ${result.vSource} m/s, v_observer = ${result.vObserver} m/s</div>`;
                html += `<div class="step">Speed of sound: v = 331.3 + 0.606T = 331.3 + 0.606(${result.temperature}) = ${result.waveSpeed.toFixed(2)} m/s</div>`;

                if (result.direction === 'approaching') {
                    html += `<div class="step">Doppler Formula (approaching): f' = f × (v + v_obs) / (v - v_src)</div>`;
                    html += `<div class="step">f' = ${result.frequency} × (${result.waveSpeed.toFixed(2)} + ${result.vObserver}) / (${result.waveSpeed.toFixed(2)} - ${result.vSource})</div>`;
                } else {
                    html += `<div class="step">Doppler Formula (receding): f' = f × (v - v_obs) / (v + v_src)</div>`;
                    html += `<div class="step">f' = ${result.frequency} × (${result.waveSpeed.toFixed(2)} - ${result.vObserver}) / (${result.waveSpeed.toFixed(2)} + ${result.vSource})</div>`;
                }

                html += `<div class="step">Observed Frequency: f' = ${result.observedFrequency.toFixed(2)} Hz</div>`;
                html += `<div class="step">Frequency Change: Δf = f' - f = ${result.observedFrequency.toFixed(2)} - ${result.frequency} = ${result.frequencyChange.toFixed(2)} Hz</div>`;
                html += `<div class="step">Percent Change: (Δf / f) × 100% = ${result.percentChange.toFixed(2)}%</div>`;

            } else {
                html += `<div class="step">Given: f = ${result.frequency.toExponential(2)} Hz, v = ${result.vSource.toExponential(2)} m/s</div>`;
                html += `<div class="step">Speed of light: c = ${c.toExponential(2)} m/s</div>`;
                html += `<div class="step">Beta: β = v/c = ${result.vSource.toExponential(2)} / ${c.toExponential(2)} = ${(result.vSource / c).toExponential(2)}</div>`;

                if (result.direction === 'approaching') {
                    html += `<div class="step">Relativistic Doppler (blueshift): f' = f × √[(1 + β) / (1 - β)]</div>`;
                } else {
                    html += `<div class="step">Relativistic Doppler (redshift): f' = f × √[(1 - β) / (1 + β)]</div>`;
                }

                html += `<div class="step">Observed Frequency: f' = ${result.observedFrequency.toExponential(2)} Hz</div>`;
                html += `<div class="step">Redshift: z = (f' - f) / f = ${result.redshift.toFixed(6)}</div>`;
                html += `<div class="step">Wavelength: λ = c / f = ${result.wavelength.toExponential(2)} m</div>`;
            }

            content.innerHTML = html;
        }

        function loadPreset(type) {
            switch(type) {
                case 'ambulance':
                    setWaveType('sound');
                    $('scenario').value = 'source-moving';
                    updateScenario();
                    $('frequency').value = 800;
                    $('sourceSpeed').value = 35;
                    $('direction').value = 'approaching';
                    $('temperature').value = 20;
                    break;
                case 'train':
                    setWaveType('sound');
                    $('scenario').value = 'source-moving';
                    updateScenario();
                    $('frequency').value = 320;
                    $('sourceSpeed').value = 50;
                    $('direction').value = 'approaching';
                    $('temperature').value = 15;
                    break;
                case 'radar':
                    setWaveType('sound');
                    $('scenario').value = 'both-moving';
                    updateScenario();
                    $('frequency').value = 10000000000; // 10 GHz
                    $('sourceSpeed').value = 0;
                    $('observerSpeed').value = 30;
                    $('direction').value = 'approaching';
                    break;
                case 'galaxy':
                    setWaveType('light');
                    $('scenario').value = 'source-moving';
                    updateScenario();
                    $('frequency').value = 500000000000000; // 500 THz
                    $('sourceSpeed').value = 15000000; // 15,000 km/s
                    $('direction').value = 'receding';
                    break;
                case 'bat':
                    setWaveType('sound');
                    $('scenario').value = 'both-moving';
                    updateScenario();
                    $('frequency').value = 50000;
                    $('sourceSpeed').value = 10;
                    $('observerSpeed').value = 5;
                    $('direction').value = 'approaching';
                    $('temperature').value = 20;
                    break;
                case 'star':
                    setWaveType('light');
                    $('scenario').value = 'source-moving';
                    updateScenario();
                    $('frequency').value = 600000000000000; // 600 THz
                    $('sourceSpeed').value = 5000000; // 5,000 km/s
                    $('direction').value = 'approaching';
                    break;
            }
            calculate();
        }

        function exportToPNG() {
            if (!lastResult) {
                alert('Please calculate first!');
                return;
            }

            // Stop animation temporarily
            if (animationId) cancelAnimationFrame(animationId);

            // Create temporary canvas
            const tempCanvas = document.createElement('canvas');
            const tempCtx = tempCanvas.getContext('2d');

            const extraHeight = 280;
            tempCanvas.width = canvas.width;
            tempCanvas.height = canvas.height + extraHeight;

            // White background
            tempCtx.fillStyle = 'white';
            tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);

            // Draw title
            tempCtx.fillStyle = '#4facfe';
            tempCtx.font = 'bold 24px Arial';
            tempCtx.textAlign = 'center';
            tempCtx.fillText('Doppler Effect Calculator', tempCanvas.width / 2, 30);

            // Draw visualization
            tempCtx.drawImage(canvas, 0, 50);

            const bottomY = canvas.height + 70;
            const leftX = 50;
            const rightX = 400;

            // Border
            tempCtx.strokeStyle = '#4facfe';
            tempCtx.lineWidth = 2;
            tempCtx.strokeRect(20, bottomY, tempCanvas.width - 40, 180);

            // Left column - Inputs
            tempCtx.fillStyle = '#333';
            tempCtx.font = 'bold 16px Arial';
            tempCtx.textAlign = 'left';
            tempCtx.fillText('INPUTS:', leftX, bottomY + 25);

            tempCtx.font = '14px Arial';
            let yPos = bottomY + 25;
            tempCtx.fillText('Wave Type: ' + (lastResult.waveType === 'sound' ? 'Sound' : 'Light'), leftX, yPos += 20);
            tempCtx.fillText('Frequency: ' + lastResult.frequency.toExponential(2) + ' Hz', leftX, yPos += 18);
            tempCtx.fillText('Source Speed: ' + lastResult.vSource + ' m/s', leftX, yPos += 18);
            tempCtx.fillText('Observer Speed: ' + lastResult.vObserver + ' m/s', leftX, yPos += 18);
            tempCtx.fillText('Direction: ' + lastResult.direction, leftX, yPos += 18);

            // Right column - Results
            tempCtx.font = 'bold 16px Arial';
            tempCtx.fillText('RESULTS:', rightX, bottomY + 25);

            tempCtx.font = '14px Arial';
            yPos = bottomY + 25;
            tempCtx.fillText("f' = " + lastResult.observedFrequency.toExponential(2) + ' Hz', rightX, yPos += 20);
            tempCtx.fillText('Δf = ' + lastResult.frequencyChange.toExponential(2) + ' Hz', rightX, yPos += 18);
            tempCtx.fillText('Change: ' + lastResult.percentChange.toFixed(2) + '%', rightX, yPos += 18);
            tempCtx.fillText('λ = ' + lastResult.wavelength.toExponential(2) + ' m', rightX, yPos += 18);
            const effectType = lastResult.frequencyChange > 0 ? (lastResult.waveType === 'light' ? 'Blueshift' : 'Higher Pitch') : (lastResult.waveType === 'light' ? 'Redshift' : 'Lower Pitch');
            tempCtx.fillText('Effect: ' + effectType, rightX, yPos += 18);

            // Share URL
            tempCtx.fillStyle = '#4facfe';
            tempCtx.font = 'bold 14px Arial';
            tempCtx.textAlign = 'center';
            tempCtx.fillText('🔗 https://8gwifi.org/doppler-effect-calculator.jsp', tempCanvas.width / 2, bottomY + 165);

            // Watermark
            tempCtx.fillStyle = '#999';
            tempCtx.font = '12px Arial';
            tempCtx.fillText('Generated by 8gwifi.org Physics Tools', tempCanvas.width / 2, bottomY + 185);

            // Download
            const link = document.createElement('a');
            link.download = 'doppler-effect-calculation.png';
            link.href = tempCanvas.toDataURL('image/png');
            link.click();

            // Restart animation
            startAnimation();
        }

        // Initialize
        updateScenario();
        calculate();
    </script>
    <!-- E-E-A-T: About & Learning Outcomes (Physics) -->
    <section class="container my-4"><div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
      <h2 class="h6 mb-2">About This Tool & Methodology</h2>
      <p>Applies the Doppler effect equations (classical approximation) using SI units to relate observed frequency, source/observer speeds, and wave speed.</p>
      <h3 class="h6 mt-2">Learning Outcomes</h3>
      <ul class="mb-2"><li>Understand how relative motion shifts frequency.</li><li>Explore source vs observer motion cases.</li><li>Practice unit consistency and realistic ranges.</li></ul>
      <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
    </div></div></div></div></section>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"WebPage","name":"Doppler Effect Calculator","url":"https://8gwifi.org/doppler-effect-calculator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}</script>
    <script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Doppler Effect Calculator","item":"https://8gwifi.org/doppler-effect-calculator.jsp"}]}</script>
    <%@ include file="footer_adsense.jsp"%>
</body>
</html>
