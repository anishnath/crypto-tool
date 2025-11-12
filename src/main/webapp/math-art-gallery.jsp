
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FREE Math Art Gallery - Fractal Generator, Parametric & Polar Curve Plotter | Graphing Calculator | 8gwifi.org</title>
    <meta name="description" content="Free online mathematical visualization tool: Generate Mandelbrot & Julia sets, plot parametric equations, create fractals (Sierpinski, Dragon Curve), design rose curves, Lissajous figures, Lorenz attractors. Interactive graphing calculator with animation, rainbow gradients & multi-curve overlay. 25+ preset shapes including hearts, butterflies, spirals.">
    <meta name="keywords" content="fractal generator, mandelbrot set, julia set, parametric equations, polar curves, graphing calculator, mathematical visualization, sierpinski triangle, dragon curve, lorenz attractor, rose curve, lissajous curves, butterfly curve, cardioid, heart equation, math art, curve plotter, equation grapher, online graphing tool, desmos alternative, mathematical art generator, chaos theory, parametric grapher, polar plotter, mathematical shapes, torus knot, harmonic curves, spiral generator, free math tools">
    <link rel="canonical" href="https://8gwifi.org/math-art-gallery.jsp">

    <!-- Open Graph -->
    <meta property="og:title" content="FREE Fractal Generator & Math Art Gallery - Mandelbrot, Parametric Curves, Graphing Calculator">
    <meta property="og:description" content="Create fractals, plot parametric & polar equations, generate mathematical art. Features: Mandelbrot/Julia sets, Sierpinski triangle, Dragon curve, Lorenz attractor, rose curves, Lissajous figures. Free online graphing calculator with animation & export.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/math-art-gallery.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/math-art-preview.png">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="FREE Fractal Generator & Parametric Curve Plotter - Math Art Gallery">
    <meta name="twitter:description" content="Generate Mandelbrot sets, plot parametric equations, create fractals & mathematical art. 25+ presets including Sierpinski, Dragon Curve, Lorenz attractor.">
    <meta name="twitter:image" content="https://8gwifi.org/images/math-art-preview.png">

    <%@ include file="header-script.jsp"%>

    <style>
        .plotter-container {
            display: grid;
            grid-template-columns: 400px 1fr;
            gap: 20px;
            margin-top: 20px;
        }

        @media (max-width: 992px) {
            .plotter-container {
                grid-template-columns: 1fr;
            }
        }

        .controls-panel {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .graph-panel {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            min-height: 700px;
        }

        #plotDiv {
            width: 100%;
            height: 650px;
            border-radius: 8px;
        }

        .mode-toggle {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
        }

        .mode-btn {
            flex: 1;
            padding: 12px;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            font-size: 0.9rem;
        }

        .mode-btn.active {
            background: #667eea;
            color: white;
        }

        .mode-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .preset-section {
            margin-bottom: 25px;
        }

        .preset-section h4 {
            font-size: 1rem;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 12px;
        }

        .preset-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 8px;
            margin-bottom: 15px;
        }

        .preset-btn {
            padding: 10px 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            font-size: 0.85rem;
            text-align: center;
        }

        .preset-btn:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .equation-section {
            margin-bottom: 20px;
        }

        .equation-section label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
            font-size: 0.95rem;
        }

        .equation-section input[type="text"],
        .equation-section input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            font-size: 0.9rem;
            transition: border-color 0.3s;
        }

        .equation-section input:focus {
            outline: none;
            border-color: #667eea;
        }

        .range-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-top: 15px;
        }

        .plot-button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 700;
            font-size: 1rem;
            transition: all 0.3s;
            margin-bottom: 20px;
        }

        .plot-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .control-group {
            margin-bottom: 15px;
        }

        .control-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 6px;
        }

        .control-group input[type="color"] {
            width: 100%;
            height: 40px;
            border: 2px solid #e2e8f0;
            border-radius: 6px;
            cursor: pointer;
        }

        .control-group input[type="range"] {
            width: 100%;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin-top: 15px;
        }

        .action-btn {
            padding: 10px;
            background: #4299e1;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 0.85rem;
            transition: all 0.3s;
        }

        .action-btn:hover {
            background: #3182ce;
        }

        .action-btn.secondary {
            background: #718096;
        }

        .action-btn.secondary:hover {
            background: #4a5568;
        }

        .info-note {
            background: #ebf8ff;
            border-left: 4px solid #4299e1;
            padding: 12px;
            border-radius: 6px;
            font-size: 0.85rem;
            color: #2c5282;
            margin-top: 15px;
        }

        /* Modal Styles */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.7);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.active {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 16px;
            padding: 30px;
            max-width: 600px;
            width: 90%;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: modalSlideIn 0.3s ease-out;
        }

        @keyframes modalSlideIn {
            from {
                transform: translateY(-50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 20px;
            color: #2d3748;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 2rem;
            cursor: pointer;
            color: #718096;
            padding: 0;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s;
        }

        .modal-close:hover {
            background: #f7fafc;
            color: #2d3748;
        }

        .challenge-target {
            background: #f7fafc;
            border: 2px dashed #cbd5e0;
            border-radius: 12px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
        }

        .challenge-hint {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 12px;
            border-radius: 6px;
            margin: 15px 0;
            font-size: 0.9rem;
        }

        .math-fact-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 20px;
            margin: 15px 0;
        }

        .math-fact-card h4 {
            margin-top: 0;
            font-size: 1.3rem;
        }

        #overlayList {
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
            max-height: 150px;
            overflow-y: auto;
        }

        .overlay-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px;
            margin: 5px 0;
            background: white;
            border-radius: 6px;
            font-size: 0.85rem;
        }

        .overlay-item button {
            background: #ef4444;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.75rem;
        }
    </style>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Math Art Gallery - Fractal Generator & Parametric Curve Plotter",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "browserRequirements": "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge.",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "description": "Free online mathematical visualization tool for generating fractals, plotting parametric and polar equations, creating mathematical art with interactive graphing calculator. Features Mandelbrot sets, Julia sets, Sierpinski triangle, Dragon curve, Lorenz attractor, and 25+ preset curves.",
      "url": "https://8gwifi.org/math-art-gallery.jsp",
      "screenshot": "https://8gwifi.org/images/math-art-preview.png",
      "softwareVersion": "2.0",
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "127",
        "bestRating": "5"
      },
      "featureList": [
        "Fractal Generator - Mandelbrot Set",
        "Julia Set Generator",
        "Sierpinski Triangle (Chaos Game Algorithm)",
        "Dragon Curve (12 iterations)",
        "Lorenz Attractor (Chaos Theory)",
        "Parametric Equation Plotter - x(t), y(t)",
        "Polar Equation Plotter - r(θ)",
        "Graphing Calculator with Real-time Animation",
        "Rainbow Gradient Color Mode",
        "Multi-Curve Overlay Mode",
        "4 Background Themes (Light, Dark, Grid, Artistic)",
        "25+ Preset Mathematical Shapes",
        "Rose Curves (5-petal, 8-petal)",
        "Lissajous Figures (Harmonic Curves)",
        "Butterfly Curve (Fay's Butterfly)",
        "Heart Curves & Cardioid",
        "Archimedean & Logarithmic Spirals",
        "Torus Knot (Trefoil)",
        "DNA Helix & Galaxy Spiral",
        "Export to PNG/Image",
        "Animated GIF Export",
        "Shareable URLs",
        "Interactive Challenge Mode",
        "Educational Math Facts",
        "Line Width & Resolution Control",
        "No Registration Required - 100% Free"
      ],
      "keywords": "fractal generator, mandelbrot set, julia set, parametric equations, polar curves, graphing calculator, mathematical visualization, sierpinski triangle, dragon curve, lorenz attractor, chaos theory, rose curve, lissajous curves, desmos alternative",
      "author": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
      },
      "provider": {
        "@type": "Organization",
        "name": "8gwifi.org",
        "url": "https://8gwifi.org"
      }
    }
    </script>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4">
    <div class="calc-card">
        <div class="calc-header">
            <h1>🎨 Math Art Gallery</h1>
            <p>Explore 30+ Beautiful Mathematical Shapes | Parametric & Polar Curves | Hearts, Fractals & More</p>
        </div>

        <div class="plotter-container">
            <!-- Left Panel: Controls & Presets -->
            <div class="controls-panel">




                <!-- Preset Shapes with Categories -->
                <div class="preset-section">
                    <h4 style="cursor: pointer; user-select: none;" onclick="toggleCategory('hearts')">
                        💕 Hearts & Symbols <span id="hearts-toggle">▼</span>
                    </h4>
                    <div id="hearts-presets" class="preset-grid">
                        <button class="preset-btn" onclick="loadShape('heart')">❤️ Heart</button>
                        <button class="preset-btn" onclick="loadShape('heartbeat')">💓 Heartbeat</button>
                        <button class="preset-btn" onclick="loadShape('smiley')">😊 Smiley</button>
                        <button class="preset-btn" onclick="loadShape('pacman')">👾 Pac-Man</button>
                        <button class="preset-btn" onclick="loadShape('rainbow')">🌈 Rainbow</button>
                    </div>
                </div>

                <div class="preset-section">
                    <h4 style="cursor: pointer; user-select: none;" onclick="toggleCategory('spirals')">
                        🌀 Spirals & Curves <span id="spirals-toggle">▼</span>
                    </h4>
                    <div id="spirals-presets" class="preset-grid">
                        <button class="preset-btn" onclick="loadShape('rose5')">🌹 5-Rose</button>
                        <button class="preset-btn" onclick="loadShape('rose8')">🌸 8-Rose</button>
                        <button class="preset-btn" onclick="loadShape('spiral_arch')">🌀 Arch Spiral</button>
                        <button class="preset-btn" onclick="loadShape('spiral_log')">📐 Log Spiral</button>
                        <button class="preset-btn" onclick="loadShape('butterfly')">🦋 Butterfly</button>
                        <button class="preset-btn" onclick="loadShape('lissajous')">〰️ Lissajous</button>
                        <button class="preset-btn" onclick="loadShape('clover')">🍀 Clover</button>
                        <button class="preset-btn" onclick="loadShape('sunflower')">🌻 Sunflower</button>
                        <button class="preset-btn" onclick="loadShape('ellipse')">⭕ Ellipse</button>
                        <button class="preset-btn" onclick="loadShape('harmonograph')">🎵 Harmono</button>
                        <button class="preset-btn" onclick="loadShape('star5')">⭐ 5-Star</button>
                        <button class="preset-btn" onclick="loadShape('cardioid')">💗 Cardioid</button>
                    </div>
                </div>

                <div class="preset-section">
                    <h4 style="cursor: pointer; user-select: none;" onclick="toggleCategory('fractals')">
                        ✨ Fractals & Chaos <span id="fractals-toggle">▼</span>
                    </h4>
                    <div id="fractals-presets" class="preset-grid">
                        <button class="preset-btn" onclick="loadShape('sierpinski')">🔺 Sierpinski</button>
                        <button class="preset-btn" onclick="loadShape('dragon')">🐉 Dragon</button>
                        <button class="preset-btn" onclick="loadShape('mandelbrot')">🌌 Mandelbrot</button>
                        <button class="preset-btn" onclick="loadShape('julia')">✨ Julia Set</button>
                    </div>
                </div>

                <div class="preset-section">
                    <h4 style="cursor: pointer; user-select: none;" onclick="toggleCategory('cosmic')">
                        🌌 3D & Cosmic <span id="cosmic-toggle">▼</span>
                    </h4>
                    <div id="cosmic-presets" class="preset-grid">
                        <button class="preset-btn" onclick="loadShape('torusknot')">🔗 Torus Knot</button>
                        <button class="preset-btn" onclick="loadShape('lorenz')">🌪️ Lorenz</button>
                        <button class="preset-btn" onclick="loadShape('dna')">🧬 DNA Helix</button>
                        <button class="preset-btn" onclick="loadShape('galaxy')">🌌 Galaxy</button>
                    </div>
                </div>

                <!-- Parametric Equations -->
                <div id="parametricMode" class="equation-section">
                    <label>x(t) =</label>
                    <input type="text" id="xFunction" value="16*sin(t)^3" placeholder="e.g., cos(t)">

                    <label style="margin-top: 15px;">y(t) =</label>
                    <input type="text" id="yFunction" value="13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)" placeholder="e.g., sin(t)">

                    <div class="range-inputs">
                        <div>
                            <label>t min</label>
                            <input type="number" id="tMin" value="0" step="0.1">
                        </div>
                        <div>
                            <label>t max</label>
                            <input type="number" id="tMax" value="6.28" step="0.1">
                        </div>
                    </div>

                </div>

                <!-- Polar Equations -->
                <div id="polarMode" class="equation-section" style="display: none;">
                    <label>r(θ) =</label>
                    <input type="text" id="rFunction" value="sin(5*theta)" placeholder="e.g., 1 + cos(theta)">

                    <div class="range-inputs">
                        <div>
                            <label>θ min</label>
                            <input type="number" id="thetaMin" value="0" step="0.1">
                        </div>
                        <div>
                            <label>θ max</label>
                            <input type="number" id="thetaMax" value="6.28" step="0.1">
                        </div>
                    </div>
                </div>

                <!-- Mode Toggle -->
                <div class="mode-toggle" style="margin-top: 20px;">
                    <button class="mode-btn active" onclick="switchMode('parametric')" id="parametricBtn">
                        📐 Parametric
                    </button>
                    <button class="mode-btn" onclick="switchMode('polar')" id="polarBtn">
                        🌀 Polar
                    </button>
                </div>

                <button class="plot-button" onclick="plotCurve()" style="margin-bottom: 20px;">
                    🎨 Plot Curve
                </button>

                <!-- Display Controls -->

            </div>

            <!-- Right Panel: Graph -->
            <div class="graph-panel">
                <div id="plotDiv"></div>

                <div class="control-group">
                    <label>Line Color</label>
                    <input type="color" id="lineColor" value="#667eea">
                </div>

                <div class="control-group">
                    <label>
                        <input type="checkbox" id="gradientMode" onchange="plotCurve()">
                        🌈 Rainbow Gradient
                    </label>
                </div>

                <div class="control-group">
                    <label>
                        <input type="checkbox" id="overlayMode">
                        📊 Multi-Curve Mode (overlay curves)
                    </label>
                </div>

                <div class="control-group">
                    <label>Background Theme</label>
                    <select id="bgTheme" onchange="changeTheme()">
                        <option value="light">☀️ Light</option>
                        <option value="dark">🌙 Dark</option>
                        <option value="grid">📐 Grid</option>
                        <option value="artistic">🎨 Artistic</option>
                    </select>
                </div>

                <div class="control-group">
                    <label>Line Width: <span id="lineWidthValue">2</span>px</label>
                    <input type="range" id="lineWidth" min="1" max="10" value="2" step="0.5"
                           oninput="document.getElementById('lineWidthValue').textContent=this.value; plotCurve();">
                </div>

                <div class="control-group">
                    <label>Resolution: <span id="pointsValue">1000</span> points</label>
                    <input type="range" id="numPoints" min="100" max="5000" value="1000" step="100"
                           oninput="document.getElementById('pointsValue').textContent=this.value;">
                </div>

                <div class="control-group">
                    <label>Animation Speed: <span id="speedValue">30</span> fps</label>
                    <input type="range" id="animSpeed" min="10" max="60" value="30" step="5"
                           oninput="document.getElementById('speedValue').textContent=this.value;">
                </div>

                <div class="action-buttons">
                    <button class="action-btn" onclick="toggleAnimation()" id="animateBtn">▶️ Animate</button>
                    <button class="action-btn" onclick="downloadPlot()">💾 Save PNG</button>
                </div>

                <div class="action-buttons">
                    <button class="action-btn" onclick="exportGIF()" style="background: #10b981;">📹 Export GIF</button>
                    <button class="action-btn secondary" onclick="shareURL()">🔗 Share</button>
                </div>

                <div class="action-buttons">
                    <button class="action-btn secondary" onclick="resetView()">🔄 Reset</button>
                    <button class="action-btn secondary" onclick="clearPlot()">🗑️ Clear</button>
                </div>

                <div class="action-buttons">
                    <button class="action-btn secondary" onclick="copyEquation()">📋 Copy Eq</button>
                </div>

                <div class="action-buttons">
                    <button class="action-btn" onclick="startChallenge()" style="background: #f59e0b;">🎯 Challenge</button>
                    <button class="action-btn" onclick="showMathFacts()" style="background: #8b5cf6;">📚 Math Facts</button>
                </div>

                <div class="info-note">
                    <strong>💡 Tip:</strong> Try preset shapes or enter custom equations. Supports sin, cos, tan, exp, log, abs, sqrt, and pi.
                </div>
            </div>
        </div>

        <!-- Educational Content -->
        <div class="container mt-4">
            <div class="result-section">
                <h3>📚 About Parametric & Polar Curves</h3>
                <p style="line-height: 1.8; color: #4a5568;">
                    <strong>Parametric Equations</strong> define curves using a parameter (usually t): x = f(t), y = g(t).
                    This allows creating complex shapes that aren't functions in the traditional y = f(x) sense.
                </p>
                <p style="line-height: 1.8; color: #4a5568; margin-top: 15px;">
                    <strong>Polar Equations</strong> use distance r and angle θ: r = f(θ).
                    Perfect for circular patterns, spirals, and symmetric designs like roses and cardioids.
                </p>

                <h4 style="margin-top: 25px; color: #2d3748; margin-bottom: 15px;">📐 Complete Famous Curves Reference:</h4>
                <div style="overflow-x: auto;">
                    <table style="width: 100%; border-collapse: collapse; font-size: 14px; background: white;">
                        <thead>
                            <tr style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                                <th style="padding: 12px 8px; text-align: left; border: 1px solid #ddd;">Curve Name</th>
                                <th style="padding: 12px 8px; text-align: left; border: 1px solid #ddd;">Type</th>
                                <th style="padding: 12px 8px; text-align: left; border: 1px solid #ddd;">Equations</th>
                                <th style="padding: 12px 8px; text-align: left; border: 1px solid #ddd;">Range</th>
                                <th style="padding: 12px 8px; text-align: left; border: 1px solid #ddd;">Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Hearts & Symbols -->
                            <tr style="background: #fff5f5;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #c53030; border: 1px solid #ddd;">
                                    ❤️ Hearts & Symbols
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Heart</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 16sin³(t)<br>
                                    y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Classic Valentine heart shape using trigonometric powers</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Heartbeat</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = t<br>
                                    y = sin(t) + 0.5sin(5t) + 0.3sin(10t)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 4π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">ECG-like waveform simulating heartbeat rhythm</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Smiley</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Multi-Trace</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    Head: x = 5cos(t), y = 5sin(t)<br>
                                    Eyes: circles at (-2,2) and (2,2)<br>
                                    Smile: y = -0.5x² - 2
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Happy face with parabolic smile</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Pac-Man</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 5cos(t)<br>
                                    y = 5sin(t)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0.5 ≤ t ≤ 5.78</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Iconic game character - partial circle with mouth</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Rainbow</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 10cos(t)<br>
                                    y = 10sin(t)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Semi-circular arc (upper half circle)</td>
                            </tr>

                            <!-- Roses & Flowers -->
                            <tr style="background: #fffaf0;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #c05621; border: 1px solid #ddd;">
                                    🌹 Roses & Flowers
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Rose (5 petals)</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 5sin(5θ)<br>
                                    <em>Alternative:</em> r = 5cos(5θ)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Pentagonal symmetry - odd n gives n petals</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Rose (8 petals)</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 5sin(4θ)<br>
                                    <em>Alternative:</em> r = 5cos(4θ)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Even n gives 2n petals</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Clover (4-leaf)</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 3|sin(2θ)|
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Four-lobed clover using absolute value</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Sunflower</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 0.5√θ<br>
                                    <em>Based on golden angle (137.5°)</em>
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 80</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Phyllotaxis pattern - Fibonacci spiral arrangement</td>
                            </tr>

                            <!-- Spirals -->
                            <tr style="background: #f0f9ff;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #1e40af; border: 1px solid #ddd;">
                                    🌀 Spirals
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Archimedean Spiral</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 0.5θ
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 20</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Linear growth - constant spacing between turns</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Logarithmic Spiral</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = e^(0.1θ)<br>
                                    <em>Also called:</em> Equiangular spiral
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 15</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Exponential growth - found in nautilus shells</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Galaxy Spiral</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = e^(0.15θ)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 12</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Models spiral galaxy arms</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Cardioid</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 4(1 + cos(θ))<br>
                                    <em>Alternative:</em> r = 4(1 - cos(θ))
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Heart-shaped curve - epicycloid with 1 cusp</td>
                            </tr>

                            <!-- Lissajous & Harmonics -->
                            <tr style="background: #faf5ff;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #6b21a8; border: 1px solid #ddd;">
                                    🎵 Lissajous & Harmonic Curves
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Lissajous (3:2)</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 5sin(3t)<br>
                                    y = 5sin(2t)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">3:2 frequency ratio creates figure-8 pattern</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Harmonograph</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 5sin(2t) + 3sin(3t)<br>
                                    y = 5cos(3t) + 2cos(5t)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Complex harmonic motion - pendulum-like drawing</td>
                            </tr>

                            <!-- Butterflies & Nature -->
                            <tr style="background: #ecfdf5;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #065f46; border: 1px solid #ddd;">
                                    🦋 Butterflies & Nature
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Butterfly</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = sin(t) · (e^cos(t) - 2cos(4t) - sin(t/12)⁵)<br>
                                    y = cos(t) · (e^cos(t) - 2cos(4t) - sin(t/12)⁵)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 12π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Fay's butterfly curve - transcendental function</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">DNA Helix</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric 3D</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 3cos(t)<br>
                                    y = 3sin(t)<br>
                                    <em>(z = 0.5t for 3D view)</em>
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 8π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Double helix structure (2D projection)</td>
                            </tr>

                            <!-- Geometric Shapes -->
                            <tr style="background: #fffbeb;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #92400e; border: 1px solid #ddd;">
                                    ⬡ Geometric Shapes
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Ellipse</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = 8cos(t)<br>
                                    y = 5sin(t)<br>
                                    <em>Standard form:</em> x²/a² + y²/b² = 1
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Elongated circle - conic section</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Star (5-pointed)</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Polar</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    r = 3 + 2cos(5θ)
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ θ ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Pentagram with rounded edges</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Torus Knot (3,2)</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Parametric 3D</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    x = (2 + cos(2t))cos(3t)<br>
                                    y = (2 + cos(2t))sin(3t)<br>
                                    <em>(z = sin(2t) for 3D)</em>
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">0 ≤ t ≤ 2π</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Trefoil knot - simplest non-trivial knot</td>
                            </tr>

                            <!-- Fractals & Chaos -->
                            <tr style="background: #fef2f2;">
                                <td colspan="5" style="padding: 8px; font-weight: bold; color: #991b1b; border: 1px solid #ddd;">
                                    🔲 Fractals & Chaotic Attractors
                                </td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Sierpinski Triangle</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Chaos Game</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    Vertices: (0,0), (1,0), (0.5,√3/2)<br>
                                    x<sub>n+1</sub> = (x<sub>n</sub> + v<sub>x</sub>)/2<br>
                                    y<sub>n+1</sub> = (y<sub>n</sub> + v<sub>y</sub>)/2
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">8000 iterations</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Self-similar fractal - dimension ≈ 1.585</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Dragon Curve</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Iterative L-System</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    Rules: R → R+L+, L → -R-L<br>
                                    Angle: 90°, 12 iterations
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">12 iterations</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Paper-folding fractal - tiles the plane</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Mandelbrot Set</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Complex Iteration</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    z<sub>n+1</sub> = z<sub>n</sub>² + c<br>
                                    z<sub>0</sub> = 0, c = x + yi<br>
                                    Plot if |z| < 2 after 100 iterations
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">-2≤x≤1, -1.5≤y≤1.5</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Most famous fractal - infinite complexity at boundary</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Julia Set</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Complex Iteration</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    z<sub>n+1</sub> = z<sub>n</sub>² + c<br>
                                    z<sub>0</sub> = x + yi, c = -0.7 + 0.27i<br>
                                    Plot if |z| < 2 after 100 iterations
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">-2≤x≤2, -2≤y≤2</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Mandelbrot's twin - each c value gives different set</td>
                            </tr>
                            <tr>
                                <td style="padding: 8px; border: 1px solid #ddd; font-weight: 600;">Lorenz Attractor</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Differential Equations</td>
                                <td style="padding: 8px; border: 1px solid #ddd; font-family: 'Courier New', monospace; font-size: 12px;">
                                    dx/dt = σ(y - x)<br>
                                    dy/dt = x(ρ - z) - y<br>
                                    dz/dt = xy - βz<br>
                                    σ=10, ρ=28, β=8/3
                                </td>
                                <td style="padding: 8px; border: 1px solid #ddd;">5000 steps</td>
                                <td style="padding: 8px; border: 1px solid #ddd;">Chaotic weather model - "butterfly effect"</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div style="margin-top: 20px; padding: 15px; background: #f7fafc; border-left: 4px solid #4299e1; border-radius: 4px;">
                    <h5 style="color: #2d3748; margin-bottom: 10px;">💡 Quick Tips:</h5>
                    <ul style="line-height: 2; color: #4a5568; margin-bottom: 0;">
                        <li><strong>Parametric:</strong> Both x and y depend on parameter t</li>
                        <li><strong>Polar:</strong> Distance r varies with angle θ</li>
                        <li><strong>Rose Curves:</strong> r = sin(nθ) - if n is odd → n petals, if n is even → 2n petals</li>
                        <li><strong>Fractals:</strong> Use special algorithms (not simple equations)</li>
                        <li><strong>Experiment:</strong> Try rainbow gradients and multi-curve overlay for stunning visuals!</li>
                    </ul>
                </div>
            </div>

            <div class="result-section" style="background: #f0f9ff; border-left-color: #3b82f6;">
                <h3 style="color: #1e40af;">Related Calculus Tools</h3>
                <div class="d-flex flex-wrap gap-2">
                    <a href="derivative-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Derivative Calculator</a>
                    <a href="integral-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Integral Calculator</a>
                    <a href="limit-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Limit Calculator</a>
                    <a href="series-calculator.jsp" class="btn btn-sm btn-outline-primary mr-2 mb-2">Taylor Series</a>
                    <a href="linear-equations-solver.jsp" class="btn btn-sm btn-outline-primary mb-2">Equation Solver</a>
                </div>
                <p class="text-muted small mb-0 mt-2">Explore more calculus tools for complete mathematical analysis.</p>
            </div>
        </div>
    </div>
</div>

<!-- Challenge Mode Modal -->
<div id="challengeModal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <span>🎯 Challenge Mode</span>
            <button class="modal-close" onclick="closeModal('challengeModal')">×</button>
        </div>
        <div id="challengeContent"></div>
    </div>
</div>

<!-- Math Facts Modal -->
<div id="mathFactsModal" class="modal-overlay">
    <div class="modal-content">
        <div class="modal-header">
            <span>📚 Math Facts</span>
            <button class="modal-close" onclick="closeModal('mathFactsModal')">×</button>
        </div>
        <div id="mathFactsContent"></div>
    </div>
</div>

<!-- Multi-Curve Overlay List -->
<div id="overlayList" style="display: none;"></div>

<script src="https://cdn.jsdelivr.net/npm/mathjs@11.11.0/lib/browser/math.min.js"></script>
<script src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.js"></script>
<script>
    let currentMode = 'parametric';
    let isAnimating = false;
    let animationFrameId = null;
    let fullXData = [];
    let fullYData = [];
    let currentFrame = 0;
    let overlayedCurves = [];
    let isExportingGIF = false;
    let currentChallenge = null;
    let currentTheme = 'light';

    // Calculate axis ranges to fit data with padding
    function calculateAxisRanges(xData, yData) {
        if (xData.length === 0 || yData.length === 0) {
            return {
                xRange: [-10, 10],
                yRange: [-10, 10]
            };
        }

        // Filter out any non-finite values
        const validX = xData.filter(x => isFinite(x));
        const validY = yData.filter(y => isFinite(y));

        if (validX.length === 0 || validY.length === 0) {
            return {
                xRange: [-10, 10],
                yRange: [-10, 10]
            };
        }

        const xMin = Math.min(...validX);
        const xMax = Math.max(...validX);
        const yMin = Math.min(...validY);
        const yMax = Math.max(...validY);

        // Add 15% padding on each side for better visibility
        const xPadding = Math.max((xMax - xMin) * 0.15, 0.5);
        const yPadding = Math.max((yMax - yMin) * 0.15, 0.5);

        // For equal aspect ratio, use the larger range
        const xRange = xMax - xMin + 2 * xPadding;
        const yRange = yMax - yMin + 2 * yPadding;
        const maxRange = Math.max(xRange, yRange);

        const xCenter = (xMin + xMax) / 2;
        const yCenter = (yMin + yMax) / 2;

        return {
            xRange: [xCenter - maxRange / 2, xCenter + maxRange / 2],
            yRange: [yCenter - maxRange / 2, yCenter + maxRange / 2]
        };
    }

    // Generate rainbow gradient colors
    function generateRainbowColors(numPoints) {
        const colors = [];
        for (let i = 0; i < numPoints; i++) {
            const hue = (i / numPoints) * 360;
            colors.push(`hsl(${hue}, 80%, 50%)`);
        }
        return colors;
    }

    // Change background theme
    function changeTheme() {
        const theme = document.getElementById('bgTheme').value;
        currentTheme = theme;
        plotCurve(); // Replot with new theme
    }

    // Get theme colors
    function getThemeColors() {
        const themes = {
            light: {
                plot_bgcolor: '#fafbfc',
                paper_bgcolor: 'white',
                gridcolor: '#e2e8f0',
                zerolinecolor: '#cbd5e0',
                textcolor: '#2d3748'
            },
            dark: {
                plot_bgcolor: '#1a202c',
                paper_bgcolor: '#2d3748',
                gridcolor: '#4a5568',
                zerolinecolor: '#718096',
                textcolor: '#e2e8f0'
            },
            grid: {
                plot_bgcolor: 'white',
                paper_bgcolor: '#f7fafc',
                gridcolor: '#667eea',
                zerolinecolor: '#4299e1',
                textcolor: '#2d3748'
            },
            artistic: {
                plot_bgcolor: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
                paper_bgcolor: '#f7fafc',
                gridcolor: 'rgba(255,255,255,0.3)',
                zerolinecolor: 'rgba(255,255,255,0.5)',
                textcolor: '#2d3748'
            }
        };
        return themes[currentTheme] || themes.light;
    }

    // Collapsible category state
    function toggleCategory(category) {
        const presetsDiv = document.getElementById(category + '-presets');
        const toggleSpan = document.getElementById(category + '-toggle');
        if (presetsDiv.style.display === 'none') {
            presetsDiv.style.display = 'grid';
            toggleSpan.textContent = '▼';
        } else {
            presetsDiv.style.display = 'none';
            toggleSpan.textContent = '▶';
        }
    }

    // Preset shapes organized by category
    const shapes = {
        // 💕 Hearts & Symbols
        'heart': {
            mode: 'parametric',
            x: '16*sin(t)^3',
            y: '13*cos(t) - 5*cos(2*t) - 2*cos(3*t) - cos(4*t)',
            tMin: 0,
            tMax: 6.28,
            color: '#e74c3c'
        },
        'heartbeat': {
            mode: 'parametric',
            x: 't*cos(t)',
            y: 't*sin(t) + 5*abs(sin(3*t))',
            tMin: 0,
            tMax: 12.56,
            color: '#e74c3c'
        },
        'smiley': {
            mode: 'special',
            type: 'smiley',
            color: '#f1c40f'
        },
        'pacman': {
            mode: 'polar',
            r: '1',
            tMin: 0.8,
            tMax: 5.48,
            description: 'Circle with angular gap (mouth facing right)',
            color: '#f1c40f'
        },
        'rainbow': {
            mode: 'parametric',
            x: 't',
            y: 'sin(t)',
            tMin: 0,
            tMax: 6.28,
            color: '#9b59b6'
        },

        // 🌀 Spirals & Curves
        'rose5': {
            mode: 'polar',
            r: 'sin(5*theta)',
            tMin: 0,
            tMax: 6.28,
            color: '#8e44ad'
        },
        'rose8': {
            mode: 'polar',
            r: 'cos(8*theta)',
            tMin: 0,
            tMax: 6.28,
            color: '#8e44ad'
        },
        'spiral_arch': {
            mode: 'polar',
            r: '0.5*theta',
            tMin: 0,
            tMax: 12.56,
            color: '#3498db'
        },
        'spiral_log': {
            mode: 'polar',
            r: 'exp(0.1*theta)',
            tMin: 0,
            tMax: 12.56,
            color: '#f39c12'
        },
        'butterfly': {
            mode: 'parametric',
            x: 'sin(t)*(exp(cos(t)) - 2*cos(4*t) - sin(t/12)^5)',
            y: 'cos(t)*(exp(cos(t)) - 2*cos(4*t) - sin(t/12)^5)',
            tMin: 0,
            tMax: 12.56,
            color: '#9b59b6'
        },
        'lissajous': {
            mode: 'parametric',
            x: 'sin(3*t)',
            y: 'sin(2*t)',
            tMin: 0,
            tMax: 6.28,
            color: '#34495e'
        },
        'clover': {
            mode: 'polar',
            r: 'sin(2*theta)',
            tMin: 0,
            tMax: 6.28,
            color: '#2ecc71'
        },
        'sunflower': {
            mode: 'parametric',
            x: 'sqrt(t)*cos(2.4*t)',
            y: 'sqrt(t)*sin(2.4*t)',
            tMin: 0,
            tMax: 50,
            color: '#f1c40f'
        },
        'ellipse': {
            mode: 'parametric',
            x: '3*cos(t)',
            y: '2*sin(t)',
            tMin: 0,
            tMax: 6.28,
            color: '#3498db'
        },
        'harmonograph': {
            mode: 'parametric',
            x: 'sin(t)*exp(-0.02*t)',
            y: 'sin(1.5*t)*exp(-0.02*t)',
            tMin: 0,
            tMax: 100,
            color: '#2ecc71'
        },
        'star5': {
            mode: 'parametric',
            x: 'cos(t) + 0.5*cos(5*t)',
            y: 'sin(t) + 0.5*sin(5*t)',
            tMin: 0,
            tMax: 6.28,
            color: '#f1c40f'
        },
        'cardioid': {
            mode: 'polar',
            r: '1 + cos(theta)',
            tMin: 0,
            tMax: 6.28,
            color: '#e74c3c'
        },

        // ✨ Fractals & Chaos (special algorithms)
        'sierpinski': {
            mode: 'special',
            type: 'sierpinski',
            color: '#2980b9'
        },
        'dragon': {
            mode: 'special',
            type: 'dragon',
            color: '#e67e22'
        },
        'mandelbrot': {
            mode: 'special',
            type: 'mandelbrot',
            color: '#000000'
        },
        'julia': {
            mode: 'special',
            type: 'julia',
            color: '#8e44ad'
        },

        // 🌌 3D & Cosmic (special algorithms)
        'torusknot': {
            mode: 'parametric',
            x: '(2 + cos(3*t))*cos(2*t)',
            y: '(2 + cos(3*t))*sin(2*t)',
            tMin: 0,
            tMax: 6.28,
            color: '#3498db'
        },
        'lorenz': {
            mode: 'special',
            type: 'lorenz',
            color: '#e74c3c'
        },
        'dna': {
            mode: 'parametric',
            x: 'cos(t)',
            y: 'sin(4*t)/4',
            tMin: 0,
            tMax: 12.56,
            color: '#27ae60'
        },
        'galaxy': {
            mode: 'polar',
            r: 'theta^0.5',
            tMin: 0,
            tMax: 25,
            color: '#9b59b6'
        }
    };

    function switchMode(mode) {
        currentMode = mode;
        if (mode === 'parametric') {
            document.getElementById('parametricMode').style.display = 'block';
            document.getElementById('polarMode').style.display = 'none';
            document.getElementById('parametricBtn').classList.add('active');
            document.getElementById('polarBtn').classList.remove('active');
        } else {
            document.getElementById('parametricMode').style.display = 'none';
            document.getElementById('polarMode').style.display = 'block';
            document.getElementById('parametricBtn').classList.remove('active');
            document.getElementById('polarBtn').classList.add('active');
        }
    }

    // Special shape generators
    function generateSierpinski(N = 8000) {
        const verts = [[0,0], [1,0], [0.5, Math.sqrt(3)/2]];
        let x = 0.1, y = 0.1;
        const xData = [], yData = [];
        for (let i = 0; i < N; i++) {
            const v = verts[Math.floor(Math.random()*3)];
            x = (x + v[0]) / 2;
            y = (y + v[1]) / 2;
            if (i > 50) {
                xData.push(x);
                yData.push(y);
            }
        }
        return {xData, yData};
    }

    function generateDragon(steps = 12) {
        let points = [[0,0], [1,0]];
        for (let i = 0; i < steps; i++) {
            const newPts = [];
            for (let j = 0; j < points.length - 1; j++) {
                const [x1, y1] = points[j];
                const [x2, y2] = points[j+1];
                const mx = (x1 + x2)/2, my = (y1 + y2)/2;
                const dx = x2 - x1, dy = y2 - y1;
                const nx = mx - dy/2, ny = my + dx/2;
                newPts.push([x1, y1], [nx, ny]);
            }
            newPts.push(points[points.length-1]);
            points = newPts;
        }
        return {xData: points.map(p=>p[0]), yData: points.map(p=>p[1])};
    }

    function generateMandelbrot(N = 120) {
        const xData = [], yData = [];
        for (let i = 0; i < N; i++) {
            for (let j = 0; j < N; j++) {
                const x = -2 + 3 * i / (N-1);
                const y = -1.5 + 3 * j / (N-1);
                let zx = 0, zy = 0, iter = 0;
                while (iter < 100 && zx*zx + zy*zy < 4) {
                    const tmp = zx*zx - zy*zy + x;
                    zy = 2*zx*zy + y;
                    zx = tmp;
                    iter++;
                }
                if (iter === 100) {
                    xData.push(x);
                    yData.push(y);
                }
            }
        }
        return {xData, yData};
    }

    function generateJulia(N = 150) {
        const cRe = -0.7, cIm = 0.27015;
        const xData = [], yData = [];
        for (let i = 0; i < N; i++) {
            for (let j = 0; j < N; j++) {
                let x = -1.5 + 3 * i / (N-1);
                let y = -1.5 + 3 * j / (N-1);
                let zx = x, zy = y, iter = 0;
                while (iter < 100 && zx*zx + zy*zy < 4) {
                    const tmp = zx*zx - zy*zy + cRe;
                    zy = 2*zx*zy + cIm;
                    zx = tmp;
                    iter++;
                }
                if (iter === 100) {
                    xData.push(x);
                    yData.push(y);
                }
            }
        }
        return {xData, yData};
    }

    function generateLorenz(steps = 10000) {
        let x = 0.1, y = 0, z = 0;
        const dt = 0.01;
        const xData = [], yData = [];
        for (let i = 0; i < steps; i++) {
            const dx = 10 * (y - x);
            const dy = x * (28 - z) - y;
            const dz = x * y - (8/3) * z;
            x += dx * dt;
            y += dy * dt;
            z += dz * dt;
            if (i > 1000) {
                xData.push(x);
                yData.push(y);
            }
        }
        return {xData, yData};
    }

    function generateSmiley() {
        // Head circle
        const ts = Array.from({length: 200}, (_, i) => i * 2 * Math.PI / 199);
        const headX = ts.map(t => 5 * Math.cos(t));
        const headY = ts.map(t => 5 * Math.sin(t));

        // Left eye
        const eyeX1 = Array.from({length: 50}, (_, i) => -2 + Math.cos(i * 2 * Math.PI / 49));
        const eyeY1 = Array.from({length: 50}, (_, i) => 2 + Math.sin(i * 2 * Math.PI / 49));

        // Right eye
        const eyeX2 = Array.from({length: 50}, (_, i) => 2 + Math.cos(i * 2 * Math.PI / 49));
        const eyeY2 = Array.from({length: 50}, (_, i) => 2 + Math.sin(i * 2 * Math.PI / 49));

        // Smile (parabola)
        const smileX = Array.from({length: 100}, (_, i) => -3 + i * 6/99);
        const smileY = smileX.map(x => -0.5 * x*x - 2);

        return {
            traces: [
                {x: headX, y: headY, color: '#f1c40f', mode: 'lines'},
                {x: eyeX1, y: eyeY1, color: '#34495e', mode: 'lines'},
                {x: eyeX2, y: eyeY2, color: '#34495e', mode: 'lines'},
                {x: smileX, y: smileY, color: '#e74c3c', mode: 'lines'}
            ]
        };
    }

    function loadShape(shapeName) {
        const shape = shapes[shapeName];
        if (!shape) return;

        // Handle special algorithm shapes
        if (shape.mode === 'special') {
            let data;
            switch (shape.type) {
                case 'smiley':
                    console.log('Loading smiley...');
                    data = generateSmiley();
                    console.log('Smiley data:', data);
                    if (data && data.traces) {
                        plotMultiTraceShape(data.traces, 'Smiley Face');
                        return;
                    }
                    break;
                case 'sierpinski':
                    data = generateSierpinski();
                    break;
                case 'dragon':
                    data = generateDragon();
                    break;
                case 'mandelbrot':
                    data = generateMandelbrot();
                    break;
                case 'julia':
                    data = generateJulia();
                    break;
                case 'lorenz':
                    data = generateLorenz();
                    break;
            }

            if (data && data.xData) {
                plotSpecialShape(data.xData, data.yData, shape.color, shapeName);
                return;
            }
        }

        if (shape.mode === 'parametric') {
            switchMode('parametric');
            document.getElementById('xFunction').value = shape.x;
            document.getElementById('yFunction').value = shape.y;
            document.getElementById('tMin').value = shape.tMin;
            document.getElementById('tMax').value = shape.tMax;
        } else {
            switchMode('polar');
            document.getElementById('rFunction').value = shape.r;
            document.getElementById('thetaMin').value = shape.tMin;
            document.getElementById('thetaMax').value = shape.tMax;
        }

        // Apply the shape's color if defined
        if (shape.color) {
            document.getElementById('lineColor').value = shape.color;
        }

        // Auto-start animation when preset is loaded
        setTimeout(() => {
            startAnimation();
        }, 100);
    }

    function plotMultiTraceShape(traces, title) {
        const themeColors = getThemeColors();

        // Collect all x and y data for range calculation
        let allX = [], allY = [];
        traces.forEach(t => {
            allX = allX.concat(t.x);
            allY = allY.concat(t.y);
        });
        const ranges = calculateAxisRanges(allX, allY);

        // Create Plotly traces
        const plotlyTraces = traces.map(t => {
            const trace = {
                x: t.x,
                y: t.y,
                mode: t.mode || 'lines',
                hovertemplate: '<b>x:</b> %{x:.3f}<br><b>y:</b> %{y:.3f}<extra></extra>'
            };

            if (t.mode === 'markers') {
                trace.marker = {color: t.color, size: 2};
            } else {
                trace.line = {color: t.color, width: 3};
            }

            return trace;
        });

        const layout = {
            title: {
                text: title,
                font: {size: 18, color: themeColors.textcolor, family: 'Arial, sans-serif'}
            },
            xaxis: {
                title: {text: 'x', font: {size: 14, color: themeColors.textcolor}},
                zeroline: true,
                zerolinecolor: themeColors.zerolinecolor,
                zerolinewidth: 2,
                gridcolor: themeColors.gridcolor,
                gridwidth: 1,
                scaleanchor: 'y',
                scaleratio: 1,
                range: ranges.xRange
            },
            yaxis: {
                title: {text: 'y', font: {size: 14, color: themeColors.textcolor}},
                zeroline: true,
                zerolinecolor: themeColors.zerolinecolor,
                zerolinewidth: 2,
                gridcolor: themeColors.gridcolor,
                gridwidth: 1,
                range: ranges.yRange
            },
            plot_bgcolor: themeColors.plot_bgcolor,
            paper_bgcolor: themeColors.paper_bgcolor,
            hovermode: 'closest',
            showlegend: false,
            margin: {l: 60, r: 40, t: 60, b: 60},
            annotations: [
                {
                    xref: 'paper',
                    yref: 'paper',
                    x: 0.98,
                    y: 0.02,
                    xanchor: 'right',
                    yanchor: 'bottom',
                    text: '8gwifi.org/math-art-gallery.jsp',
                    showarrow: false,
                    font: {family: 'Arial, sans-serif', size: 11, color: '#718096'},
                    bgcolor: 'rgba(255, 255, 255, 0.7)',
                    borderpad: 4
                }
            ]
        };

        const config = {
            responsive: true,
            displayModeBar: true,
            displaylogo: false,
            modeBarButtonsToRemove: ['lasso2d', 'select2d']
        };

        Plotly.newPlot('plotDiv', plotlyTraces, layout, config);
    }

    function plotSpecialShape(xData, yData, color, name) {
        const themeColors = getThemeColors();
        const ranges = calculateAxisRanges(xData, yData);

        const trace = {
            x: xData,
            y: yData,
            mode: 'markers',
            marker: {
                color: color,
                size: name === 'sierpinski' || name === 'mandelbrot' || name === 'julia' ? 1.5 : 2
            },
            hovertemplate: '<b>x:</b> %{x:.3f}<br><b>y:</b> %{y:.3f}<extra></extra>'
        };

        const layout = {
            title: {
                text: name.charAt(0).toUpperCase() + name.slice(1),
                font: {size: 18, color: themeColors.textcolor, family: 'Arial, sans-serif'}
            },
            xaxis: {
                title: {text: 'x', font: {size: 14, color: themeColors.textcolor}},
                zeroline: true,
                zerolinecolor: themeColors.zerolinecolor,
                zerolinewidth: 2,
                gridcolor: themeColors.gridcolor,
                gridwidth: 1,
                scaleanchor: 'y',
                scaleratio: 1,
                range: ranges.xRange
            },
            yaxis: {
                title: {text: 'y', font: {size: 14, color: themeColors.textcolor}},
                zeroline: true,
                zerolinecolor: themeColors.zerolinecolor,
                zerolinewidth: 2,
                gridcolor: themeColors.gridcolor,
                gridwidth: 1,
                range: ranges.yRange
            },
            plot_bgcolor: themeColors.plot_bgcolor,
            paper_bgcolor: themeColors.paper_bgcolor,
            hovermode: 'closest',
            showlegend: false,
            margin: {l: 60, r: 40, t: 60, b: 60},
            annotations: [
                {
                    xref: 'paper',
                    yref: 'paper',
                    x: 0.98,
                    y: 0.02,
                    xanchor: 'right',
                    yanchor: 'bottom',
                    text: '8gwifi.org/math-art-gallery.jsp',
                    showarrow: false,
                    font: {family: 'Arial, sans-serif', size: 11, color: '#718096'},
                    bgcolor: 'rgba(255, 255, 255, 0.7)',
                    borderpad: 4
                }
            ]
        };

        const config = {
            responsive: true,
            displayModeBar: true,
            displaylogo: false,
            modeBarButtonsToRemove: ['lasso2d', 'select2d']
        };

        Plotly.newPlot('plotDiv', [trace], layout, config);
    }

    function plotCurve() {
        try {
            const numPoints = parseInt(document.getElementById('numPoints').value);
            const color = document.getElementById('lineColor').value;
            const width = parseFloat(document.getElementById('lineWidth').value);

            let xData = [];
            let yData = [];

            if (currentMode === 'parametric') {
                const xFunc = document.getElementById('xFunction').value;
                const yFunc = document.getElementById('yFunction').value;
                const tMin = parseFloat(document.getElementById('tMin').value);
                const tMax = parseFloat(document.getElementById('tMax').value);

                // Preprocess functions: replace theta with t for consistency
                const processedX = xFunc.replace(/theta/g, 't');
                const processedY = yFunc.replace(/theta/g, 't');

                const xExpr = math.compile(processedX);
                const yExpr = math.compile(processedY);

                for (let i = 0; i <= numPoints; i++) {
                    const t = tMin + (tMax - tMin) * i / numPoints;
                    try {
                        const x = xExpr.evaluate({t: t, pi: Math.PI});
                        const y = yExpr.evaluate({t: t, pi: Math.PI});
                        xData.push(x);
                        yData.push(y);
                    } catch (e) {
                        // Skip invalid points
                    }
                }
            } else {
                // Polar mode
                const rFunc = document.getElementById('rFunction').value;
                const thetaMin = parseFloat(document.getElementById('thetaMin').value);
                const thetaMax = parseFloat(document.getElementById('thetaMax').value);

                const rExpr = math.compile(rFunc);

                for (let i = 0; i <= numPoints; i++) {
                    const theta = thetaMin + (thetaMax - thetaMin) * i / numPoints;
                    try {
                        const r = rExpr.evaluate({theta: theta, pi: Math.PI});
                        if (!isNaN(r) && isFinite(r) && r !== null) {
                            const x = r * Math.cos(theta);
                            const y = r * Math.sin(theta);
                            xData.push(x);
                            yData.push(y);
                        }
                    } catch (e) {
                        // Skip invalid points
                    }
                }
            }

            // Check if gradient mode is enabled
            const gradientMode = document.getElementById('gradientMode').checked;
            const overlayMode = document.getElementById('overlayMode').checked;

            let lineColor;
            if (gradientMode) {
                lineColor = generateRainbowColors(xData.length);
            } else {
                lineColor = color;
            }

            const trace = {
                x: xData,
                y: yData,
                mode: 'lines',
                line: {
                    color: lineColor,
                    width: width,
                    shape: 'spline',
                    smoothing: 1.3
                },
                fill: gradientMode ? 'none' : 'tozeroy',
                fillcolor: gradientMode ? 'none' : color.replace(')', ', 0.05)').replace('rgb', 'rgba'),
                hovertemplate: '<b>x:</b> %{x:.3f}<br><b>y:</b> %{y:.3f}<extra></extra>'
            };

            // Calculate axis ranges to fit the curve
            const ranges = calculateAxisRanges(xData, yData);

            // Build equation text for display
            let equationText = '';
            if (currentMode === 'parametric') {
                const xFunc = document.getElementById('xFunction').value;
                const yFunc = document.getElementById('yFunction').value;
                equationText = `x(t) = ${xFunc}<br>y(t) = ${yFunc}`;
            } else {
                const rFunc = document.getElementById('rFunction').value;
                equationText = `r(θ) = ${rFunc}`;
            }

            // Apply theme colors
            const themeColors = getThemeColors();

            // Handle overlay mode
            let traces = [trace];
            if (overlayMode && overlayedCurves.length > 0) {
                traces = [...overlayedCurves, trace];
            }

            const layout = {
                title: {
                    text: currentMode === 'parametric' ? 'Parametric Curve' : 'Polar Curve',
                    font: {size: 18, color: themeColors.textcolor, family: 'Arial, sans-serif'}
                },
                xaxis: {
                    title: {
                        text: 'x',
                        font: {size: 14, color: themeColors.textcolor}
                    },
                    zeroline: true,
                    zerolinecolor: themeColors.zerolinecolor,
                    zerolinewidth: 2,
                    gridcolor: themeColors.gridcolor,
                    gridwidth: 1,
                    scaleanchor: 'y',
                    scaleratio: 1,
                    range: ranges.xRange
                },
                yaxis: {
                    title: {
                        text: 'y',
                        font: {size: 14, color: themeColors.textcolor}
                    },
                    zeroline: true,
                    zerolinecolor: themeColors.zerolinecolor,
                    zerolinewidth: 2,
                    gridcolor: themeColors.gridcolor,
                    gridwidth: 1,
                    range: ranges.yRange
                },
                plot_bgcolor: themeColors.plot_bgcolor,
                paper_bgcolor: themeColors.paper_bgcolor,
                hovermode: 'closest',
                showlegend: overlayMode && overlayedCurves.length > 0,
                margin: {l: 60, r: 40, t: 60, b: 60},
                annotations: [
                    {
                        xref: 'paper',
                        yref: 'paper',
                        x: 0.02,
                        y: 0.98,
                        xanchor: 'left',
                        yanchor: 'top',
                        text: equationText,
                        showarrow: false,
                        font: {
                            family: 'Courier New, monospace',
                            size: 13,
                            color: '#2d3748'
                        },
                        bgcolor: 'rgba(255, 255, 255, 0.9)',
                        bordercolor: '#667eea',
                        borderwidth: 2,
                        borderpad: 8
                    },
                    {
                        xref: 'paper',
                        yref: 'paper',
                        x: 0.98,
                        y: 0.02,
                        xanchor: 'right',
                        yanchor: 'bottom',
                        text: '8gwifi.org/math-art-gallery.jsp',
                        showarrow: false,
                        font: {
                            family: 'Arial, sans-serif',
                            size: 11,
                            color: '#718096'
                        },
                        bgcolor: 'rgba(255, 255, 255, 0.7)',
                        borderpad: 4
                    }
                ]
            };

            const config = {
                responsive: true,
                displayModeBar: true,
                displaylogo: false,
                modeBarButtonsToRemove: ['lasso2d', 'select2d']
            };

            // Store full data for animation
            fullXData = xData;
            fullYData = yData;

            Plotly.newPlot('plotDiv', traces, layout, config);

            // If overlay mode, add current curve to overlay list
            if (overlayMode) {
                overlayedCurves.push(trace);
                updateOverlayList();
            }
        } catch (error) {
            alert('Error plotting curve: ' + error.message);
        }
    }

    function toggleAnimation() {
        if (isAnimating) {
            stopAnimation();
        } else {
            startAnimation();
        }
    }

    function startAnimation() {
        isAnimating = true;
        currentFrame = 0;
        document.getElementById('animateBtn').textContent = '⏸️ Pause';

        // Generate data first
        try {
            const numPoints = parseInt(document.getElementById('numPoints').value);
            const color = document.getElementById('lineColor').value;
            const width = parseFloat(document.getElementById('lineWidth').value);

            let xData = [];
            let yData = [];

            if (currentMode === 'parametric') {
                const xFunc = document.getElementById('xFunction').value;
                const yFunc = document.getElementById('yFunction').value;
                const tMin = parseFloat(document.getElementById('tMin').value);
                const tMax = parseFloat(document.getElementById('tMax').value);

                const processedX = xFunc.replace(/theta/g, 't');
                const processedY = yFunc.replace(/theta/g, 't');

                const xExpr = math.compile(processedX);
                const yExpr = math.compile(processedY);

                for (let i = 0; i <= numPoints; i++) {
                    const t = tMin + (tMax - tMin) * i / numPoints;
                    try {
                        const x = xExpr.evaluate({t: t, pi: Math.PI});
                        const y = yExpr.evaluate({t: t, pi: Math.PI});
                        xData.push(x);
                        yData.push(y);
                    } catch (e) {
                        // Skip invalid points
                    }
                }
            } else {
                const rFunc = document.getElementById('rFunction').value;
                const thetaMin = parseFloat(document.getElementById('thetaMin').value);
                const thetaMax = parseFloat(document.getElementById('thetaMax').value);

                const rExpr = math.compile(rFunc);

                for (let i = 0; i <= numPoints; i++) {
                    const theta = thetaMin + (thetaMax - thetaMin) * i / numPoints;
                    try {
                        const r = rExpr.evaluate({theta: theta, pi: Math.PI});
                        if (!isNaN(r) && isFinite(r) && r !== null) {
                            const x = r * Math.cos(theta);
                            const y = r * Math.sin(theta);
                            xData.push(x);
                            yData.push(y);
                        }
                    } catch (e) {
                        // Skip invalid points
                    }
                }
            }

            fullXData = xData;
            fullYData = yData;

            // Calculate axis ranges to fit the curve
            const ranges = calculateAxisRanges(xData, yData);

            // Build equation text for display
            let equationText = '';
            if (currentMode === 'parametric') {
                const xFunc = document.getElementById('xFunction').value;
                const yFunc = document.getElementById('yFunction').value;
                equationText = `x(t) = ${xFunc}<br>y(t) = ${yFunc}`;
            } else {
                const rFunc = document.getElementById('rFunction').value;
                equationText = `r(θ) = ${rFunc}`;
            }

            // Initialize plot with empty data but correct axis ranges
            const layout = {
                title: {
                    text: currentMode === 'parametric' ? 'Parametric Curve (Animating)' : 'Polar Curve (Animating)',
                    font: {size: 18, color: '#1a202c', family: 'Arial, sans-serif'}
                },
                xaxis: {
                    title: {
                        text: 'x',
                        font: {size: 14, color: '#2d3748'}
                    },
                    zeroline: true,
                    zerolinecolor: '#cbd5e0',
                    zerolinewidth: 2,
                    gridcolor: '#e2e8f0',
                    gridwidth: 1,
                    scaleanchor: 'y',
                    scaleratio: 1,
                    range: ranges.xRange
                },
                yaxis: {
                    title: {
                        text: 'y',
                        font: {size: 14, color: '#2d3748'}
                    },
                    zeroline: true,
                    zerolinecolor: '#cbd5e0',
                    zerolinewidth: 2,
                    gridcolor: '#e2e8f0',
                    gridwidth: 1,
                    range: ranges.yRange
                },
                plot_bgcolor: '#fafbfc',
                paper_bgcolor: 'white',
                hovermode: 'closest',
                showlegend: false,
                margin: {l: 60, r: 40, t: 60, b: 60},
                annotations: [
                    {
                        xref: 'paper',
                        yref: 'paper',
                        x: 0.02,
                        y: 0.98,
                        xanchor: 'left',
                        yanchor: 'top',
                        text: equationText,
                        showarrow: false,
                        font: {
                            family: 'Courier New, monospace',
                            size: 13,
                            color: '#2d3748'
                        },
                        bgcolor: 'rgba(255, 255, 255, 0.9)',
                        bordercolor: '#667eea',
                        borderwidth: 2,
                        borderpad: 8
                    },
                    {
                        xref: 'paper',
                        yref: 'paper',
                        x: 0.98,
                        y: 0.02,
                        xanchor: 'right',
                        yanchor: 'bottom',
                        text: '8gwifi.org/math-art-gallery.jsp',
                        showarrow: false,
                        font: {
                            family: 'Arial, sans-serif',
                            size: 11,
                            color: '#718096'
                        },
                        bgcolor: 'rgba(255, 255, 255, 0.7)',
                        borderpad: 4
                    }
                ]
            };

            const trace = {
                x: [],
                y: [],
                mode: 'lines',
                line: {
                    color: color,
                    width: width
                }
            };

            const config = {
                responsive: true,
                displayModeBar: true,
                displaylogo: false,
                modeBarButtonsToRemove: ['lasso2d', 'select2d']
            };

            Plotly.newPlot('plotDiv', [trace], layout, config);

            // Start animation loop
            animate();
        } catch (error) {
            alert('Error starting animation: ' + error.message);
            stopAnimation();
        }
    }

    function animate() {
        if (!isAnimating) return;

        const fps = parseInt(document.getElementById('animSpeed').value);
        const pointsPerFrame = Math.max(1, Math.floor(fullXData.length / (fps * 3))); // Complete in ~3 seconds

        currentFrame += pointsPerFrame;

        if (currentFrame >= fullXData.length) {
            currentFrame = fullXData.length;
            stopAnimation();
        }

        const xSlice = fullXData.slice(0, currentFrame);
        const ySlice = fullYData.slice(0, currentFrame);

        Plotly.animate('plotDiv', {
            data: [{x: xSlice, y: ySlice}]
        }, {
            transition: {duration: 0},
            frame: {duration: 0, redraw: false}
        });

        if (isAnimating) {
            animationFrameId = setTimeout(animate, 1000 / fps);
        }
    }

    function stopAnimation() {
        isAnimating = false;
        document.getElementById('animateBtn').textContent = '▶️ Animate';
        if (animationFrameId) {
            clearTimeout(animationFrameId);
            animationFrameId = null;
        }

        // Show complete curve
        if (fullXData.length > 0) {
            Plotly.animate('plotDiv', {
                data: [{x: fullXData, y: fullYData}]
            }, {
                transition: {duration: 300},
                frame: {duration: 300, redraw: true}
            });
        }
    }

    function clearPlot() {
        stopAnimation();
        Plotly.purge('plotDiv');
        const layout = {
            title: 'Ready to Plot',
            xaxis: {
                title: 'x',
                zeroline: true,
                gridcolor: '#e2e8f0',
                range: [-10, 10]
            },
            yaxis: {
                title: 'y',
                zeroline: true,
                gridcolor: '#e2e8f0',
                range: [-10, 10]
            },
            plot_bgcolor: '#f7fafc',
            paper_bgcolor: 'white'
        };
        Plotly.newPlot('plotDiv', [], layout);
    }

    function downloadPlot() {
        Plotly.downloadImage('plotDiv', {
            format: 'png',
            width: 1200,
            height: 800,
            filename: 'parametric_curve'
        });
    }

    async function exportGIF() {
        if (isExportingGIF) {
            alert('⏳ GIF export already in progress...');
            return;
        }

        if (!fullXData || fullXData.length === 0) {
            alert('❌ Please plot a curve first before exporting to GIF!');
            return;
        }

        // Confirm export
        const frames = parseInt(prompt('How many frames for the GIF? (20-100 recommended)', '50'));
        if (!frames || frames < 5 || frames > 200) {
            alert('❌ Please enter a valid frame count (5-200)');
            return;
        }

        isExportingGIF = true;
        const exportBtn = document.querySelector('button[onclick="exportGIF()"]');
        const originalText = exportBtn.innerHTML;
        exportBtn.innerHTML = '⏳ Exporting...';
        exportBtn.disabled = true;

        try {
            // Initialize GIF encoder
            const gif = new GIF({
                workers: 2,
                quality: 10,
                width: 800,
                height: 600,
                workerScript: 'https://cdn.jsdelivr.net/npm/gif.js@0.2.0/dist/gif.worker.js'
            });

            // Get current plot settings
            const themeColors = getThemeColors();
            const lineColor = document.getElementById('lineColor').value;
            const lineWidth = parseFloat(document.getElementById('lineWidth').value);
            const gradientMode = document.getElementById('gradientMode').checked;

            // Generate frames
            const totalPoints = fullXData.length;
            const pointsPerFrame = Math.ceil(totalPoints / frames);

            for (let i = 0; i < frames; i++) {
                const endIdx = Math.min((i + 1) * pointsPerFrame, totalPoints);
                const frameXData = fullXData.slice(0, endIdx);
                const frameYData = fullYData.slice(0, endIdx);

                // Calculate ranges
                const ranges = calculateAxisRanges(fullXData, fullYData);

                // Create trace
                let trace = {
                    x: frameXData,
                    y: frameYData,
                    mode: 'lines',
                    hovertemplate: '<b>x:</b> %{x:.3f}<br><b>y:</b> %{y:.3f}<extra></extra>'
                };

                if (gradientMode) {
                    const colors = generateRainbowColors(frameXData.length);
                    trace.line = {
                        color: colors,
                        width: lineWidth
                    };
                } else {
                    trace.line = {
                        color: lineColor,
                        width: lineWidth
                    };
                }

                // Layout
                const layout = {
                    showlegend: false,
                    autosize: true,
                    margin: { l: 50, r: 50, t: 30, b: 50 },
                    xaxis: {
                        range: ranges.xRange,
                        zeroline: true,
                        gridcolor: themeColors.gridcolor,
                        zerolinecolor: themeColors.zerolinecolor
                    },
                    yaxis: {
                        range: ranges.yRange,
                        zeroline: true,
                        gridcolor: themeColors.gridcolor,
                        zerolinecolor: themeColors.zerolinecolor
                    },
                    plot_bgcolor: themeColors.plot_bgcolor,
                    paper_bgcolor: themeColors.paper_bgcolor,
                    font: { color: themeColors.textcolor }
                };

                // Create temporary canvas for this frame
                const tempDiv = document.createElement('div');
                tempDiv.style.width = '800px';
                tempDiv.style.height = '600px';
                tempDiv.style.position = 'absolute';
                tempDiv.style.left = '-9999px';
                document.body.appendChild(tempDiv);

                await Plotly.newPlot(tempDiv, [trace], layout, { staticPlot: true });

                // Convert to canvas
                const canvas = await Plotly.toImage(tempDiv, {
                    format: 'png',
                    width: 800,
                    height: 600
                }).then(dataUrl => {
                    return new Promise((resolve) => {
                        const img = new Image();
                        img.onload = () => {
                            const canvas = document.createElement('canvas');
                            canvas.width = 800;
                            canvas.height = 600;
                            const ctx = canvas.getContext('2d');
                            ctx.drawImage(img, 0, 0);
                            resolve(canvas);
                        };
                        img.src = dataUrl;
                    });
                });

                // Add frame to GIF
                gif.addFrame(canvas, { delay: 50 }); // 50ms = 20fps

                // Cleanup
                Plotly.purge(tempDiv);
                document.body.removeChild(tempDiv);

                // Update progress
                exportBtn.innerHTML = `⏳ ${Math.round((i + 1) / frames * 100)}%`;
            }

            // Render GIF
            exportBtn.innerHTML = '⏳ Rendering...';
            gif.on('finished', function(blob) {
                // Download
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'math_art_animation.gif';
                document.body.appendChild(a);
                a.click();
                document.body.removeChild(a);
                URL.revokeObjectURL(url);

                // Reset button
                exportBtn.innerHTML = originalText;
                exportBtn.disabled = false;
                isExportingGIF = false;

                alert('✅ GIF exported successfully!');
            });

            gif.render();

        } catch (error) {
            console.error('GIF export error:', error);
            alert('❌ Error exporting GIF: ' + error.message);
            exportBtn.innerHTML = originalText;
            exportBtn.disabled = false;
            isExportingGIF = false;
        }
    }

    function resetView() {
        const plotDiv = document.getElementById('plotDiv');
        Plotly.relayout(plotDiv, {
            'xaxis.autorange': true,
            'yaxis.autorange': true
        });
    }

    function shareURL() {
        try {
            // Build URL with current parameters
            const params = new URLSearchParams();
            params.set('mode', currentMode);

            if (currentMode === 'parametric') {
                params.set('x', document.getElementById('xFunction').value);
                params.set('y', document.getElementById('yFunction').value);
                params.set('tmin', document.getElementById('tMin').value);
                params.set('tmax', document.getElementById('tMax').value);
            } else {
                params.set('r', document.getElementById('rFunction').value);
                params.set('tmin', document.getElementById('thetaMin').value);
                params.set('tmax', document.getElementById('thetaMax').value);
            }

            params.set('color', document.getElementById('lineColor').value);
            params.set('width', document.getElementById('lineWidth').value);

            const shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();

            // Copy to clipboard
            navigator.clipboard.writeText(shareUrl).then(() => {
                alert('✅ Share URL copied to clipboard!\n\n' + shareUrl);
            }).catch(() => {
                // Fallback if clipboard API fails
                prompt('Copy this URL to share:', shareUrl);
            });
        } catch (error) {
            alert('Error creating share URL: ' + error.message);
        }
    }

    function copyEquation() {
        try {
            let equationText = '';
            if (currentMode === 'parametric') {
                const xFunc = document.getElementById('xFunction').value;
                const yFunc = document.getElementById('yFunction').value;
                equationText = `x(t) = ${xFunc}\ny(t) = ${yFunc}`;
            } else {
                const rFunc = document.getElementById('rFunction').value;
                equationText = `r(θ) = ${rFunc}`;
            }

            navigator.clipboard.writeText(equationText).then(() => {
                alert('✅ Equation copied to clipboard!\n\n' + equationText);
            }).catch(() => {
                prompt('Copy this equation:', equationText);
            });
        } catch (error) {
            alert('Error copying equation: ' + error.message);
        }
    }

    // Load parameters from URL on page load
    function loadFromURL() {
        const params = new URLSearchParams(window.location.search);

        if (params.has('mode')) {
            const mode = params.get('mode');
            switchMode(mode);

            if (mode === 'parametric' && params.has('x') && params.has('y')) {
                document.getElementById('xFunction').value = params.get('x');
                document.getElementById('yFunction').value = params.get('y');
                if (params.has('tmin')) document.getElementById('tMin').value = params.get('tmin');
                if (params.has('tmax')) document.getElementById('tMax').value = params.get('tmax');
            } else if (mode === 'polar' && params.has('r')) {
                document.getElementById('rFunction').value = params.get('r');
                if (params.has('tmin')) document.getElementById('thetaMin').value = params.get('tmin');
                if (params.has('tmax')) document.getElementById('thetaMax').value = params.get('tmax');
            }

            if (params.has('color')) {
                document.getElementById('lineColor').value = params.get('color');
            }
            if (params.has('width')) {
                document.getElementById('lineWidth').value = params.get('width');
                document.getElementById('lineWidthValue').textContent = params.get('width');
            }

            // Plot after loading parameters
            setTimeout(() => {
                startAnimation();
            }, 500);
        } else {
            // Default: Load heart shape and plot it
            loadShape('heart');
        }
    }

    // Overlay management
    function updateOverlayList() {
        const listDiv = document.getElementById('overlayList');
        if (overlayedCurves.length > 0) {
            listDiv.style.display = 'block';
            listDiv.innerHTML = '<h5>Overlayed Curves:</h5>';
            overlayedCurves.forEach((curve, index) => {
                const item = document.createElement('div');
                item.className = 'overlay-item';
                item.innerHTML = `
                    <span>Curve ${index + 1}</span>
                    <button onclick="removeOverlay(${index})">Remove</button>
                `;
                listDiv.appendChild(item);
            });
        } else {
            listDiv.style.display = 'none';
        }
    }

    function removeOverlay(index) {
        overlayedCurves.splice(index, 1);
        updateOverlayList();
        plotCurve();
    }

    // Modal management
    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('active');
    }

    // Challenge Mode
    const challenges = [
        {
            name: 'Heart',
            shape: 'heart',
            hint: 'Use sin³(t) for x and a combination of cos functions for y',
            difficulty: 'Easy'
        },
        {
            name: 'Rose (5 petals)',
            shape: 'rose5',
            hint: 'Try r = sin(5θ) in polar mode',
            difficulty: 'Easy'
        },
        {
            name: 'Butterfly',
            shape: 'butterfly',
            hint: 'Use exponential and trigonometric functions',
            difficulty: 'Hard'
        },
        {
            name: 'Lissajous Figure',
            shape: 'lissajous',
            hint: 'x = sin(3t), y = sin(2t)',
            difficulty: 'Medium'
        }
    ];

    function startChallenge() {
        const challenge = challenges[Math.floor(Math.random() * challenges.length)];
        currentChallenge = challenge;

        const modal = document.getElementById('challengeModal');
        const content = document.getElementById('challengeContent');

        // Load the target shape for visual reference
        loadShape(challenge.shape);

        content.innerHTML = `
            <div class="challenge-target">
                <h3>🎯 Recreate: ${challenge.name}</h3>
                <p><strong>Difficulty:</strong> ${challenge.difficulty}</p>
                <p>Try to match the curve shown on the graph!</p>
            </div>
            <div class="challenge-hint">
                <strong>💡 Hint:</strong> ${challenge.hint}
            </div>
            <button class="action-btn" onclick="revealSolution()">Show Solution</button>
        `;

        modal.classList.add('active');
    }

    function revealSolution() {
        if (currentChallenge) {
            const shape = shapes[currentChallenge.shape];
            alert('Solution:\\n' +
                  (shape.mode === 'parametric'
                   ? `x(t) = ${shape.x}\\ny(t) = ${shape.y}`
                   : `r(θ) = ${shape.r}`));
        }
    }

    // Math Facts
    const mathFacts = [
        {
            title: 'The Heart Curve',
            content: 'The parametric heart curve uses sin³(t) which creates the characteristic dip at the top. The equation combines multiple cosine harmonics to create the rounded lobes.',
            equation: 'x = 16sin³(t), y = 13cos(t) - 5cos(2t) - 2cos(3t) - cos(4t)'
        },
        {
            title: 'Rose Curves',
            content: 'Rose curves follow the pattern r = sin(nθ) or r = cos(nθ). If n is odd, there are n petals. If n is even, there are 2n petals!',
            equation: 'r = sin(nθ)'
        },
        {
            title: 'Butterfly Curve',
            content: 'Discovered by Temple H. Fay, this curve resembles a butterfly. It uses the exponential function e^cos(t) which creates the expanding wings.',
            equation: 'x = sin(t)(e^cos(t) - 2cos(4t) - sin^5(t/12))'
        },
        {
            title: 'Archimedean Spiral',
            content: 'Named after Greek mathematician Archimedes, this spiral has the property that the distance between successive turns is constant.',
            equation: 'r = aθ'
        },
        {
            title: 'Cardioid',
            content: 'The name comes from the Greek word for "heart". A cardioid is the path traced by a point on a circle rolling around another circle of the same radius.',
            equation: 'r = 1 + cos(θ)'
        },
        {
            title: 'Lissajous Curves',
            content: 'Named after Jules Antoine Lissajous, these figures show the relationship between two harmonic motions. They are used in physics and engineering to study oscillations.',
            equation: 'x = Asin(at + δ), y = Bsin(bt)'
        }
    ];

    function showMathFacts() {
        const modal = document.getElementById('mathFactsModal');
        const content = document.getElementById('mathFactsContent');

        let html = '';
        mathFacts.forEach((fact, index) => {
            html += `
                <div class="math-fact-card">
                    <h4>${fact.title}</h4>
                    <p>${fact.content}</p>
                    <code style="display: block; margin-top: 10px; background: rgba(0,0,0,0.2); padding: 10px; border-radius: 6px;">
                        ${fact.equation}
                    </code>
                </div>
            `;
        });

        content.innerHTML = html;
        modal.classList.add('active');
    }

    // Close modal on outside click
    document.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal-overlay')) {
            event.target.classList.remove('active');
        }
    });

    // Load from URL or load default shape
    window.addEventListener('load', loadFromURL);
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
