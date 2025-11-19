<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Area & Volume Calculator Online – Free | 8gwifi.org</title>
    <meta name="description" content="Calculate area and volume for all geometric shapes. Free calculator for 2D shapes (circle, square, triangle, rectangle) and 3D solids (sphere, cube, cylinder, cone, pyramid). Step-by-step solutions with formulas.">
    <meta name="keywords" content="area calculator, volume calculator, geometry calculator, circle area, triangle area, sphere volume, cylinder volume, cone volume">

    <link rel="canonical" href="https://8gwifi.org/area-volume-calculator.jsp">
    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/area-volume-calculator.jsp">
    <meta property="og:title" content="Area & Volume Calculator Online – Free | 8gwifi.org">
    <meta property="og:description" content="Calculate area and volume for common 2D shapes and 3D solids with clear formulas, diagrams, and step-by-step results.">
    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Area & Volume Calculator Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Compute areas and volumes for circles, triangles, rectangles, spheres, cylinders, cones, and more.">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Area and Volume Calculator",
      "description": "Calculate area and volume for all geometric shapes and 3D solids with step-by-step solutions.",
      "url": "https://8gwifi.org/area-volume-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        .shape-selector {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .shape-btn {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 8px 12px;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .shape-btn:hover {
            border-color: #667eea;
            background: #f8f9ff;
            transform: translateX(3px);
        }

        .shape-btn.active {
            border-color: #667eea;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .shape-btn i {
            font-size: 1.2rem;
            min-width: 20px;
            text-align: center;
        }

        .shape-btn.active i {
            color: white;
        }

        .shape-btn div {
            font-size: 0.9rem;
            font-weight: 500;
        }

        .formula-display {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
            text-align: center;
        }

        .formula-display h5 {
            color: white;
            margin-bottom: 15px;
        }

        .formula-text {
            font-size: 1.3rem;
            font-weight: bold;
            background: rgba(255,255,255,0.2);
            padding: 15px;
            border-radius: 10px;
        }

        .result-display {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            text-align: center;
            margin: 10px 0;
        }

        .result-display h5 {
            font-size: 1rem;
            margin-bottom: 5px;
        }

        .result-value {
            font-size: 1.8rem;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .result-unit {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .result-display hr {
            margin: 10px 0;
        }

        .shape-diagram {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin: 15px 0;
            text-align: center;
        }

        .shape-diagram svg {
            max-width: 100%;
            height: auto;
        }

        .diagram-label {
            font-size: 0.85rem;
            fill: #495057;
            font-weight: 600;
        }

        .diagram-value {
            font-size: 0.9rem;
            fill: #667eea;
            font-weight: bold;
        }

        .property-box {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .property-label {
            font-weight: 600;
            color: #495057;
        }

        .property-value {
            color: #667eea;
            font-weight: bold;
        }

        .input-group-custom {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }

        .input-group-custom label {
            font-weight: bold;
            color: #495057;
            margin-bottom: 5px;
        }

        .visualization {
            background: #f8f9fa;
            border: 2px dashed #dee2e6;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            margin: 20px 0;
            min-height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .dimension-badge {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            margin-bottom: 15px;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-shapes"></i> Area & Volume Calculator</h1>
    <p class="text-center text-muted mb-4">
        Calculate area and volume for all geometric shapes<br>
        <span class="badge badge-primary">15+ Shapes</span>
        <span class="badge badge-success">Step-by-Step Solutions</span>
    </p>

    <div class="row">
        <div class="col-lg-3">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h6 class="mb-0"><i class="fas fa-square"></i> 2D Shapes</h6>
                </div>
                <div class="card-body">
                    <div class="shape-selector">
                        <div class="shape-btn" onclick="selectShape('circle')">
                            <i class="fas fa-circle"></i>
                            <div>Circle</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('square')">
                            <i class="fas fa-square"></i>
                            <div>Square</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('rectangle')">
                            <i class="far fa-square"></i>
                            <div>Rectangle</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('triangle')">
                            <i class="fas fa-play" style="transform: rotate(-30deg);"></i>
                            <div>Triangle</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('ellipse')">
                            <i class="fas fa-circle" style="transform: scaleX(1.5);"></i>
                            <div>Ellipse</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('trapezoid')">
                            <i class="fas fa-square" style="transform: perspective(50px) rotateX(20deg);"></i>
                            <div>Trapezoid</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-header bg-success text-white">
                    <h6 class="mb-0"><i class="fas fa-cube"></i> 3D Solids</h6>
                </div>
                <div class="card-body">
                    <div class="shape-selector">
                        <div class="shape-btn" onclick="selectShape('sphere')">
                            <i class="fas fa-circle"></i>
                            <div>Sphere</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('cube')">
                            <i class="fas fa-cube"></i>
                            <div>Cube</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('cylinder')">
                            <i class="fas fa-database"></i>
                            <div>Cylinder</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('cone')">
                            <i class="fas fa-sort-up"></i>
                            <div>Cone</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('pyramid')">
                            <i class="fas fa-caret-up"></i>
                            <div>Pyramid</div>
                        </div>
                        <div class="shape-btn" onclick="selectShape('prism')">
                            <i class="fas fa-box"></i>
                            <div>Rect. Prism</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="card">
                <div class="card-body">
                    <div id="calculatorContent">
                        <div class="text-center p-5">
                            <i class="fas fa-hand-pointer text-muted" style="font-size: 4rem;"></i>
                            <h4 class="text-muted mt-3">Select a shape to begin</h4>
                            <p class="text-muted">Choose from 2D shapes or 3D solids on the left</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="thanks.jsp"%>
    <hr>
    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let currentShape = null;

function selectShape(shape) {
    currentShape = shape;

    // Update active button
    document.querySelectorAll('.shape-btn').forEach(btn => btn.classList.remove('active'));
    event.currentTarget.classList.add('active');

    // Display calculator for selected shape
    displayCalculator(shape);
}

function displayCalculator(shape) {
    const content = document.getElementById('calculatorContent');
    let html = '';

    switch(shape) {
        case 'circle':
            html = getCircleCalculator();
            break;
        case 'square':
            html = getSquareCalculator();
            break;
        case 'rectangle':
            html = getRectangleCalculator();
            break;
        case 'triangle':
            html = getTriangleCalculator();
            break;
        case 'ellipse':
            html = getEllipseCalculator();
            break;
        case 'trapezoid':
            html = getTrapezoidCalculator();
            break;
        case 'sphere':
            html = getSphereCalculator();
            break;
        case 'cube':
            html = getCubeCalculator();
            break;
        case 'cylinder':
            html = getCylinderCalculator();
            break;
        case 'cone':
            html = getConeCalculator();
            break;
        case 'pyramid':
            html = getPyramidCalculator();
            break;
        case 'prism':
            html = getPrismCalculator();
            break;
    }

    content.innerHTML = html;
}

function getCircleCalculator() {
    return `
        <span class="dimension-badge">2D Shape</span>
        <h3><i class="fas fa-circle"></i> Circle</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Area = πr²<br>
                Circumference = 2πr
            </div>
        </div>

        <form onsubmit="calculateCircle(); return false;">
            <div class="input-group-custom">
                <label>Radius (r):</label>
                <input type="number" class="form-control form-control-lg" id="radius" step="any" value="5" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateCircle() {
    const r = parseFloat(document.getElementById('radius').value);
    const area = Math.PI * r * r;
    const circumference = 2 * Math.PI * r;

    const svgSize = 200;
    const centerX = svgSize / 2;
    const centerY = svgSize / 2;
    const radius = Math.min(60, svgSize / 3);

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Circle Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Circle -->
                <circle cx="${centerX}" cy="${centerY}" r="${radius}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>

                <!-- Radius line -->
                <line x1="${centerX}" y1="${centerY}" x2="${centerX + radius}" y2="${centerY}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>

                <!-- Center point -->
                <circle cx="${centerX}" cy="${centerY}" r="3" fill="#495057"/>

                <!-- Radius label -->
                <text x="${centerX + radius/2}" y="${centerY - 5}" class="diagram-value" text-anchor="middle">
                    r = ${r}
                </text>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Area (A)</span>
                    <span class="property-value">${area.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-circle-notch"></i> Circumference (C)</span>
                    <span class="property-value">${circumference.toFixed(2)} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Radius (r)</span>
                    <span class="property-value">${r} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-info text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsCircle">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsCircle" class="collapse">
                <div class="card-body">
                    <strong>Area:</strong><br>
                    A = πr²<br>
                    A = π × ${r}²<br>
                    A = π × ${(r * r).toFixed(2)}<br>
                    <strong class="text-primary">A = ${area.toFixed(2)} square units</strong>
                    <hr>
                    <strong>Circumference:</strong><br>
                    C = 2πr<br>
                    C = 2 × π × ${r}<br>
                    <strong class="text-primary">C = ${circumference.toFixed(2)} units</strong>
                </div>
            </div>
        </div>
    `;
}

function getSquareCalculator() {
    return `
        <span class="dimension-badge">2D Shape</span>
        <h3><i class="fas fa-square"></i> Square</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Area = s²<br>
                Perimeter = 4s
            </div>
        </div>

        <form onsubmit="calculateSquare(); return false;">
            <div class="input-group-custom">
                <label>Side Length (s):</label>
                <input type="number" class="form-control form-control-lg" id="side" step="any" value="4" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateSquare() {
    const s = parseFloat(document.getElementById('side').value);
    const area = s * s;
    const perimeter = 4 * s;

    const svgSize = 200;
    const squareSize = 80;
    const x = (svgSize - squareSize) / 2;
    const y = (svgSize - squareSize) / 2;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Square Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Square -->
                <rect x="${x}" y="${y}" width="${squareSize}" height="${squareSize}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>

                <!-- Side length labels -->
                <line x1="${x}" y1="${y - 10}" x2="${x + squareSize}" y2="${y - 10}"
                    stroke="#f5576c" stroke-width="2" marker-end="url(#arrowhead)"/>
                <text x="${x + squareSize/2}" y="${y - 15}" class="diagram-value" text-anchor="middle">
                    s = ${s}
                </text>

                <!-- Vertical side label -->
                <text x="${x + squareSize + 10}" y="${y + squareSize/2}" class="diagram-value">
                    s = ${s}
                </text>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Area (A)</span>
                    <span class="property-value">${area.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-border-style"></i> Perimeter (P)</span>
                    <span class="property-value">${perimeter.toFixed(2)} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Side (s)</span>
                    <span class="property-value">${s} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-info text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsSquare">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsSquare" class="collapse">
                <div class="card-body">
                    <strong>Area:</strong><br>
                    A = s²<br>
                    A = ${s}²<br>
                    <strong class="text-primary">A = ${area.toFixed(2)} square units</strong>
                    <hr>
                    <strong>Perimeter:</strong><br>
                    P = 4s<br>
                    P = 4 × ${s}<br>
                    <strong class="text-primary">P = ${perimeter.toFixed(2)} units</strong>
                </div>
            </div>
        </div>
    `;
}

function getRectangleCalculator() {
    return `
        <span class="dimension-badge">2D Shape</span>
        <h3><i class="far fa-square"></i> Rectangle</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Area = l × w<br>
                Perimeter = 2(l + w)
            </div>
        </div>

        <form onsubmit="calculateRectangle(); return false;">
            <div class="input-group-custom">
                <label>Length (l):</label>
                <input type="number" class="form-control form-control-lg" id="length" step="any" value="6" required>
            </div>
            <div class="input-group-custom">
                <label>Width (w):</label>
                <input type="number" class="form-control form-control-lg" id="width" step="any" value="4" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateRectangle() {
    const l = parseFloat(document.getElementById('length').value);
    const w = parseFloat(document.getElementById('width').value);
    const area = l * w;
    const perimeter = 2 * (l + w);

    const svgSize = 200;
    const rectW = 100;
    const rectH = 60;
    const x = (svgSize - rectW) / 2;
    const y = (svgSize - rectH) / 2;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Rectangle Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <rect x="${x}" y="${y}" width="${rectW}" height="${rectH}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>
                <text x="${x + rectW/2}" y="${y - 10}" class="diagram-value" text-anchor="middle">l = ${l}</text>
                <text x="${x + rectW + 15}" y="${y + rectH/2}" class="diagram-value">w = ${w}</text>
            </svg>
            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Area (A)</span>
                    <span class="property-value">${area.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-border-style"></i> Perimeter (P)</span>
                    <span class="property-value">${perimeter.toFixed(2)} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-horizontal"></i> Length (l)</span>
                    <span class="property-value">${l} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Width (w)</span>
                    <span class="property-value">${w} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-info text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsRect">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsRect" class="collapse">
                <div class="card-body">
                    <strong>Area:</strong><br>
                    A = l × w<br>
                    A = ${l} × ${w}<br>
                    <strong class="text-primary">A = ${area.toFixed(2)} square units</strong>
                    <hr>
                    <strong>Perimeter:</strong><br>
                    P = 2(l + w)<br>
                    P = 2(${l} + ${w})<br>
                    P = 2 × ${(l + w).toFixed(2)}<br>
                    <strong class="text-primary">P = ${perimeter.toFixed(2)} units</strong>
                </div>
            </div>
        </div>
    `;
}

function getTriangleCalculator() {
    return `
        <span class="dimension-badge">2D Shape</span>
        <h3><i class="fas fa-play" style="transform: rotate(-30deg);"></i> Triangle</h3>

        <div class="formula-display">
            <h5>Formula</h5>
            <div class="formula-text">
                Area = ½ × base × height
            </div>
        </div>

        <form onsubmit="calculateTriangle(); return false;">
            <div class="input-group-custom">
                <label>Base (b):</label>
                <input type="number" class="form-control form-control-lg" id="base" step="any" value="8" required>
            </div>
            <div class="input-group-custom">
                <label>Height (h):</label>
                <input type="number" class="form-control form-control-lg" id="height" step="any" value="5" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateTriangle() {
    const b = parseFloat(document.getElementById('base').value);
    const h = parseFloat(document.getElementById('height').value);
    const area = 0.5 * b * h;

    const svgSize = 200;
    const triBase = 100;
    const triHeight = 80;
    const x1 = (svgSize - triBase) / 2;
    const y1 = (svgSize + triHeight) / 2;
    const x2 = x1 + triBase;
    const y2 = y1;
    const x3 = (svgSize) / 2;
    const y3 = y1 - triHeight;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Triangle Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <polygon points="${x1},${y1} ${x2},${y2} ${x3},${y3}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>
                <line x1="${x3}" y1="${y3}" x2="${x3}" y2="${y1}" stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${(x1 + x2)/2}" y="${y1 + 20}" class="diagram-value" text-anchor="middle">b = ${b}</text>
                <text x="${x3 + 20}" y="${(y1 + y3)/2}" class="diagram-value">h = ${h}</text>
            </svg>
            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Area (A)</span>
                    <span class="property-value">${area.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-horizontal"></i> Base (b)</span>
                    <span class="property-value">${b} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Height (h)</span>
                    <span class="property-value">${h} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-info text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsTri">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsTri" class="collapse">
                <div class="card-body">
                    <strong>Area:</strong><br>
                    A = ½ × b × h<br>
                    A = ½ × ${b} × ${h}<br>
                    A = 0.5 × ${(b * h).toFixed(2)}<br>
                    <strong class="text-primary">A = ${area.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getEllipseCalculator() {
    return `
        <span class="dimension-badge">2D Shape</span>
        <h3><i class="fas fa-circle" style="transform: scaleX(1.5);"></i> Ellipse</h3>

        <div class="formula-display">
            <h5>Formula</h5>
            <div class="formula-text">
                Area = π × a × b
            </div>
        </div>

        <form onsubmit="calculateEllipse(); return false;">
            <div class="input-group-custom">
                <label>Semi-major axis (a):</label>
                <input type="number" class="form-control form-control-lg" id="semiMajor" step="any" value="6" required>
            </div>
            <div class="input-group-custom">
                <label>Semi-minor axis (b):</label>
                <input type="number" class="form-control form-control-lg" id="semiMinor" step="any" value="4" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateEllipse() {
    const a = parseFloat(document.getElementById('semiMajor').value);
    const b = parseFloat(document.getElementById('semiMinor').value);
    const area = Math.PI * a * b;

    const svgSize = 200;
    const cx = svgSize / 2;
    const cy = svgSize / 2;
    const rx = 70;
    const ry = 45;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Ellipse Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>
                <line x1="${cx}" y1="${cy}" x2="${cx + rx}" y2="${cy}" stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <line x1="${cx}" y1="${cy}" x2="${cx}" y2="${cy - ry}" stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx + rx/2}" y="${cy - 5}" class="diagram-value" text-anchor="middle">a = ${a}</text>
                <text x="${cx + 10}" y="${cy - ry/2}" class="diagram-value">b = ${b}</text>
            </svg>
            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Area (A)</span>
                    <span class="property-value">${area.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-arrows-alt-h"></i> Semi-major axis (a)</span>
                    <span class="property-value">${a} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-arrows-alt-v"></i> Semi-minor axis (b)</span>
                    <span class="property-value">${b} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-info text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsEllipse">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsEllipse" class="collapse">
                <div class="card-body">
                    <strong>Area:</strong><br>
                    A = π × a × b<br>
                    A = π × ${a} × ${b}<br>
                    A = π × ${(a * b).toFixed(2)}<br>
                    <strong class="text-primary">A = ${area.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getTrapezoidCalculator() {
    return `
        <span class="dimension-badge">2D Shape</span>
        <h3><i class="fas fa-square"></i> Trapezoid</h3>

        <div class="formula-display">
            <h5>Formula</h5>
            <div class="formula-text">
                Area = ½(a + b) × h
            </div>
        </div>

        <form onsubmit="calculateTrapezoid(); return false;">
            <div class="input-group-custom">
                <label>Base 1 (a):</label>
                <input type="number" class="form-control form-control-lg" id="base1" step="any" value="8" required>
            </div>
            <div class="input-group-custom">
                <label>Base 2 (b):</label>
                <input type="number" class="form-control form-control-lg" id="base2" step="any" value="6" required>
            </div>
            <div class="input-group-custom">
                <label>Height (h):</label>
                <input type="number" class="form-control form-control-lg" id="trapHeight" step="any" value="4" required>
            </div>
            <button type="submit" class="btn btn-primary btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateTrapezoid() {
    const a = parseFloat(document.getElementById('base1').value);
    const b = parseFloat(document.getElementById('base2').value);
    const h = parseFloat(document.getElementById('trapHeight').value);
    const area = 0.5 * (a + b) * h;

    const svgSize = 200;
    const trapH = 70;
    const base1W = 90;
    const base2W = 60;
    const x1 = (svgSize - base1W) / 2;
    const y1 = (svgSize + trapH) / 2 - 10;
    const x2 = x1 + base1W;
    const x3 = (svgSize + base2W) / 2;
    const x4 = (svgSize - base2W) / 2;
    const y2 = y1 - trapH;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Trapezoid Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <polygon points="${x1},${y1} ${x2},${y1} ${x3},${y2} ${x4},${y2}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>
                <text x="${(x1 + x2)/2}" y="${y1 + 20}" class="diagram-value" text-anchor="middle">a = ${a}</text>
                <text x="${svgSize/2}" y="${y2 - 10}" class="diagram-value" text-anchor="middle">b = ${b}</text>
                <text x="${x1 - 25}" y="${(y1 + y2)/2}" class="diagram-value">h = ${h}</text>
            </svg>
            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Area (A)</span>
                    <span class="property-value">${area.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-horizontal"></i> Base 1 (a)</span>
                    <span class="property-value">${a} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-horizontal"></i> Base 2 (b)</span>
                    <span class="property-value">${b} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Height (h)</span>
                    <span class="property-value">${h} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-info text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsTrap">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsTrap" class="collapse">
                <div class="card-body">
                    <strong>Area:</strong><br>
                    A = ½(a + b) × h<br>
                    A = ½(${a} + ${b}) × ${h}<br>
                    A = ½ × ${(a + b).toFixed(2)} × ${h}<br>
                    A = ${(0.5 * (a + b)).toFixed(2)} × ${h}<br>
                    <strong class="text-primary">A = ${area.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

// 3D Shape Calculators
function getSphereCalculator() {
    return `
        <span class="dimension-badge">3D Solid</span>
        <h3><i class="fas fa-circle"></i> Sphere</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Volume = (4/3)πr³<br>
                Surface Area = 4πr²
            </div>
        </div>

        <form onsubmit="calculateSphere(); return false;">
            <div class="input-group-custom">
                <label>Radius (r):</label>
                <input type="number" class="form-control form-control-lg" id="sphereRadius" step="any" value="5" required>
            </div>
            <button type="submit" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateSphere() {
    const r = parseFloat(document.getElementById('sphereRadius').value);
    const volume = (4/3) * Math.PI * r * r * r;
    const surfaceArea = 4 * Math.PI * r * r;

    const svgSize = 200;
    const cx = svgSize / 2;
    const cy = svgSize / 2;
    const radius = 60;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Sphere Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <circle cx="${cx}" cy="${cy}" r="${radius}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>
                <ellipse cx="${cx}" cy="${cy}" rx="${radius}" ry="${radius * 0.3}"
                    fill="none" stroke="#667eea" stroke-width="1" stroke-dasharray="3,3"/>
                <line x1="${cx}" y1="${cy}" x2="${cx + radius}" y2="${cy}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx + radius/2}" y="${cy - 5}" class="diagram-value" text-anchor="middle">r = ${r}</text>
            </svg>
            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-cube"></i> Volume (V)</span>
                    <span class="property-value">${volume.toFixed(2)} units³</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Surface Area (SA)</span>
                    <span class="property-value">${surfaceArea.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Radius (r)</span>
                    <span class="property-value">${r} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsSphere">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsSphere" class="collapse">
                <div class="card-body">
                    <strong>Volume:</strong><br>
                    V = (4/3)πr³<br>
                    V = (4/3) × π × ${r}³<br>
                    V = (4/3) × π × ${(r * r * r).toFixed(2)}<br>
                    <strong class="text-success">V = ${volume.toFixed(2)} cubic units</strong>
                    <hr>
                    <strong>Surface Area:</strong><br>
                    SA = 4πr²<br>
                    SA = 4 × π × ${r}²<br>
                    SA = 4 × π × ${(r * r).toFixed(2)}<br>
                    <strong class="text-success">SA = ${surfaceArea.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getCubeCalculator() {
    return `
        <span class="dimension-badge">3D Solid</span>
        <h3><i class="fas fa-cube"></i> Cube</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Volume = s³<br>
                Surface Area = 6s²
            </div>
        </div>

        <form onsubmit="calculateCube(); return false;">
            <div class="input-group-custom">
                <label>Side Length (s):</label>
                <input type="number" class="form-control form-control-lg" id="cubeSide" step="any" value="4" required>
            </div>
            <button type="submit" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateCube() {
    const s = parseFloat(document.getElementById('cubeSide').value);
    const volume = s * s * s;
    const surfaceArea = 6 * s * s;

    const svgSize = 200;
    const cubeSize = 70;
    const offset = 20;
    const x1 = (svgSize - cubeSize - offset) / 2;
    const y1 = (svgSize - cubeSize + offset) / 2;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Cube Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Back face -->
                <rect x="${x1 + offset}" y="${y1 - offset}" width="${cubeSize}" height="${cubeSize}"
                    fill="rgba(102, 126, 234, 0.1)" stroke="#667eea" stroke-width="1.5"/>

                <!-- Front face -->
                <rect x="${x1}" y="${y1}" width="${cubeSize}" height="${cubeSize}"
                    fill="rgba(102, 126, 234, 0.3)" stroke="#667eea" stroke-width="2"/>

                <!-- Connecting lines for 3D effect -->
                <line x1="${x1}" y1="${y1}" x2="${x1 + offset}" y2="${y1 - offset}"
                    stroke="#667eea" stroke-width="1.5"/>
                <line x1="${x1 + cubeSize}" y1="${y1}" x2="${x1 + cubeSize + offset}" y2="${y1 - offset}"
                    stroke="#667eea" stroke-width="1.5"/>
                <line x1="${x1}" y1="${y1 + cubeSize}" x2="${x1 + offset}" y2="${y1 + cubeSize - offset}"
                    stroke="#667eea" stroke-width="1.5"/>
                <line x1="${x1 + cubeSize}" y1="${y1 + cubeSize}" x2="${x1 + cubeSize + offset}" y2="${y1 + cubeSize - offset}"
                    stroke="#667eea" stroke-width="1.5"/>

                <!-- Side label -->
                <text x="${x1 + cubeSize/2}" y="${y1 + cubeSize + 20}" class="diagram-value" text-anchor="middle">
                    s = ${s}
                </text>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-cube"></i> Volume (V)</span>
                    <span class="property-value">${volume.toFixed(2)} units³</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Surface Area (SA)</span>
                    <span class="property-value">${surfaceArea.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Side (s)</span>
                    <span class="property-value">${s} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsCube">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsCube" class="collapse">
                <div class="card-body">
                    <strong>Volume:</strong><br>
                    V = s³<br>
                    V = ${s}³<br>
                    <strong class="text-success">V = ${volume.toFixed(2)} cubic units</strong>
                    <hr>
                    <strong>Surface Area:</strong><br>
                    SA = 6s²<br>
                    SA = 6 × ${s}²<br>
                    SA = 6 × ${(s * s).toFixed(2)}<br>
                    <strong class="text-success">SA = ${surfaceArea.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getCylinderCalculator() {
    return `
        <span class="dimension-badge">3D Solid</span>
        <h3><i class="fas fa-database"></i> Cylinder</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Volume = πr²h<br>
                Surface Area = 2πr(r + h)
            </div>
        </div>

        <form onsubmit="calculateCylinder(); return false;">
            <div class="input-group-custom">
                <label>Radius (r):</label>
                <input type="number" class="form-control form-control-lg" id="cylRadius" step="any" value="3" required>
            </div>
            <div class="input-group-custom">
                <label>Height (h):</label>
                <input type="number" class="form-control form-control-lg" id="cylHeight" step="any" value="7" required>
            </div>
            <button type="submit" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateCylinder() {
    const r = parseFloat(document.getElementById('cylRadius').value);
    const h = parseFloat(document.getElementById('cylHeight').value);
    const volume = Math.PI * r * r * h;
    const surfaceArea = 2 * Math.PI * r * (r + h);

    const svgSize = 200;
    const cx = svgSize / 2;
    const cylWidth = 50;
    const cylHeight = 90;
    const ellipseRy = 12;
    const topY = (svgSize - cylHeight) / 2;
    const bottomY = topY + cylHeight;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Cylinder Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Cylinder body -->
                <rect x="${cx - cylWidth}" y="${topY}" width="${cylWidth * 2}" height="${cylHeight}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="none"/>

                <!-- Side lines -->
                <line x1="${cx - cylWidth}" y1="${topY}" x2="${cx - cylWidth}" y2="${bottomY}"
                    stroke="#667eea" stroke-width="2"/>
                <line x1="${cx + cylWidth}" y1="${topY}" x2="${cx + cylWidth}" y2="${bottomY}"
                    stroke="#667eea" stroke-width="2"/>

                <!-- Bottom ellipse -->
                <ellipse cx="${cx}" cy="${bottomY}" rx="${cylWidth}" ry="${ellipseRy}"
                    fill="rgba(102, 126, 234, 0.3)" stroke="#667eea" stroke-width="2"/>

                <!-- Top ellipse -->
                <ellipse cx="${cx}" cy="${topY}" rx="${cylWidth}" ry="${ellipseRy}"
                    fill="rgba(102, 126, 234, 0.3)" stroke="#667eea" stroke-width="2"/>

                <!-- Radius line -->
                <line x1="${cx}" y1="${topY}" x2="${cx + cylWidth}" y2="${topY}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx + cylWidth/2}" y="${topY - 5}" class="diagram-value" text-anchor="middle">
                    r = ${r}
                </text>

                <!-- Height line -->
                <line x1="${cx + cylWidth + 15}" y1="${topY}" x2="${cx + cylWidth + 15}" y2="${bottomY}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx + cylWidth + 25}" y="${topY + cylHeight/2}" class="diagram-value">
                    h = ${h}
                </text>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-cube"></i> Volume (V)</span>
                    <span class="property-value">${volume.toFixed(2)} units³</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Surface Area (SA)</span>
                    <span class="property-value">${surfaceArea.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Radius (r)</span>
                    <span class="property-value">${r} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Height (h)</span>
                    <span class="property-value">${h} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsCyl">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsCyl" class="collapse">
                <div class="card-body">
                    <strong>Volume:</strong><br>
                    V = πr²h<br>
                    V = π × ${r}² × ${h}<br>
                    V = π × ${(r * r).toFixed(2)} × ${h}<br>
                    <strong class="text-success">V = ${volume.toFixed(2)} cubic units</strong>
                    <hr>
                    <strong>Surface Area:</strong><br>
                    SA = 2πr(r + h)<br>
                    SA = 2 × π × ${r} × (${r} + ${h})<br>
                    SA = 2 × π × ${r} × ${(r + h).toFixed(2)}<br>
                    <strong class="text-success">SA = ${surfaceArea.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getConeCalculator() {
    return `
        <span class="dimension-badge">3D Solid</span>
        <h3><i class="fas fa-sort-up"></i> Cone</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Volume = (1/3)πr²h<br>
                Surface Area = πr(r + √(h² + r²))
            </div>
        </div>

        <form onsubmit="calculateCone(); return false;">
            <div class="input-group-custom">
                <label>Radius (r):</label>
                <input type="number" class="form-control form-control-lg" id="coneRadius" step="any" value="3" required>
            </div>
            <div class="input-group-custom">
                <label>Height (h):</label>
                <input type="number" class="form-control form-control-lg" id="coneHeight" step="any" value="5" required>
            </div>
            <button type="submit" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculateCone() {
    const r = parseFloat(document.getElementById('coneRadius').value);
    const h = parseFloat(document.getElementById('coneHeight').value);
    const volume = (1/3) * Math.PI * r * r * h;
    const slantHeight = Math.sqrt(h * h + r * r);
    const surfaceArea = Math.PI * r * (r + slantHeight);

    const svgSize = 200;
    const cx = svgSize / 2;
    const coneWidth = 60;
    const coneHeight = 85;
    const baseY = (svgSize + coneHeight) / 2 - 10;
    const apexY = baseY - coneHeight;
    const ellipseRy = 12;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Cone Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Cone base ellipse -->
                <ellipse cx="${cx}" cy="${baseY}" rx="${coneWidth}" ry="${ellipseRy}"
                    fill="rgba(102, 126, 234, 0.3)" stroke="#667eea" stroke-width="2"/>

                <!-- Cone sides -->
                <line x1="${cx - coneWidth}" y1="${baseY}" x2="${cx}" y2="${apexY}"
                    stroke="#667eea" stroke-width="2"/>
                <line x1="${cx + coneWidth}" y1="${baseY}" x2="${cx}" y2="${apexY}"
                    stroke="#667eea" stroke-width="2"/>

                <!-- Fill triangle for cone body -->
                <polygon points="${cx - coneWidth},${baseY} ${cx + coneWidth},${baseY} ${cx},${apexY}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="none"/>

                <!-- Radius line -->
                <line x1="${cx}" y1="${baseY}" x2="${cx + coneWidth}" y2="${baseY}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx + coneWidth/2}" y="${baseY + 15}" class="diagram-value" text-anchor="middle">
                    r = ${r}
                </text>

                <!-- Height line -->
                <line x1="${cx}" y1="${apexY}" x2="${cx}" y2="${baseY}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx - 20}" y="${apexY + coneHeight/2}" class="diagram-value">
                    h = ${h}
                </text>

                <!-- Apex point -->
                <circle cx="${cx}" cy="${apexY}" r="3" fill="#495057"/>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-cube"></i> Volume (V)</span>
                    <span class="property-value">${volume.toFixed(2)} units³</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Surface Area (SA)</span>
                    <span class="property-value">${surfaceArea.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Radius (r)</span>
                    <span class="property-value">${r} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Height (h)</span>
                    <span class="property-value">${h} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsCone">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsCone" class="collapse">
                <div class="card-body">
                    <strong>Volume:</strong><br>
                    V = (1/3)πr²h<br>
                    V = (1/3) × π × ${r}² × ${h}<br>
                    V = (1/3) × π × ${(r * r).toFixed(2)} × ${h}<br>
                    <strong class="text-success">V = ${volume.toFixed(2)} cubic units</strong>
                    <hr>
                    <strong>Surface Area:</strong><br>
                    First find slant height: l = √(h² + r²) = √(${h}² + ${r}²) = ${slantHeight.toFixed(2)}<br>
                    SA = πr(r + l)<br>
                    SA = π × ${r} × (${r} + ${slantHeight.toFixed(2)})<br>
                    <strong class="text-success">SA = ${surfaceArea.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getPyramidCalculator() {
    return `
        <span class="dimension-badge">3D Solid</span>
        <h3><i class="fas fa-caret-up"></i> Square Pyramid</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Volume = (1/3) × base² × h<br>
                Surface Area = base² + 2 × base × √((base/2)² + h²)
            </div>
        </div>

        <form onsubmit="calculatePyramid(); return false;">
            <div class="input-group-custom">
                <label>Base Side Length:</label>
                <input type="number" class="form-control form-control-lg" id="pyrBase" step="any" value="4" required>
            </div>
            <div class="input-group-custom">
                <label>Height (h):</label>
                <input type="number" class="form-control form-control-lg" id="pyrHeight" step="any" value="6" required>
            </div>
            <button type="submit" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculatePyramid() {
    const base = parseFloat(document.getElementById('pyrBase').value);
    const h = parseFloat(document.getElementById('pyrHeight').value);
    const volume = (1/3) * base * base * h;
    const slantHeight = Math.sqrt((base/2) * (base/2) + h * h);
    const surfaceArea = base * base + 2 * base * slantHeight;

    const svgSize = 200;
    const cx = svgSize / 2;
    const pyrBase = 70;
    const pyrHeight = 80;
    const baseY = (svgSize + pyrHeight) / 2 - 5;
    const apexY = baseY - pyrHeight;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Pyramid Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Base square (back edges shown as dashed) -->
                <line x1="${cx - pyrBase/2}" y1="${baseY + pyrBase/4}" x2="${cx + pyrBase/2}" y2="${baseY + pyrBase/4}"
                    stroke="#667eea" stroke-width="1.5" stroke-dasharray="3,3"/>
                <line x1="${cx + pyrBase/2}" y1="${baseY + pyrBase/4}" x2="${cx + pyrBase/2}" y2="${baseY - pyrBase/4}"
                    stroke="#667eea" stroke-width="1.5" stroke-dasharray="3,3"/>

                <!-- Base square (front edges) -->
                <rect x="${cx - pyrBase/2}" y="${baseY - pyrBase/4}" width="${pyrBase}" height="${pyrBase/2}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="2"/>

                <!-- Pyramid edges to apex -->
                <line x1="${cx - pyrBase/2}" y1="${baseY - pyrBase/4}" x2="${cx}" y2="${apexY}"
                    stroke="#667eea" stroke-width="2"/>
                <line x1="${cx + pyrBase/2}" y1="${baseY - pyrBase/4}" x2="${cx}" y2="${apexY}"
                    stroke="#667eea" stroke-width="2"/>
                <line x1="${cx - pyrBase/2}" y1="${baseY + pyrBase/4}" x2="${cx}" y2="${apexY}"
                    stroke="#667eea" stroke-width="2"/>
                <line x1="${cx + pyrBase/2}" y1="${baseY + pyrBase/4}" x2="${cx}" y2="${apexY}"
                    stroke="#667eea" stroke-width="2"/>

                <!-- Faces fill -->
                <polygon points="${cx - pyrBase/2},${baseY + pyrBase/4} ${cx + pyrBase/2},${baseY + pyrBase/4} ${cx},${apexY}"
                    fill="rgba(102, 126, 234, 0.25)" stroke="none"/>
                <polygon points="${cx - pyrBase/2},${baseY - pyrBase/4} ${cx + pyrBase/2},${baseY - pyrBase/4} ${cx},${apexY}"
                    fill="rgba(102, 126, 234, 0.15)" stroke="none"/>

                <!-- Base label -->
                <text x="${cx}" y="${baseY + pyrBase/4 + 20}" class="diagram-value" text-anchor="middle">
                    b = ${base}
                </text>

                <!-- Height line -->
                <line x1="${cx}" y1="${apexY}" x2="${cx}" y2="${baseY}"
                    stroke="#f5576c" stroke-width="2" stroke-dasharray="3,3"/>
                <text x="${cx - 25}" y="${apexY + pyrHeight/2}" class="diagram-value">
                    h = ${h}
                </text>

                <!-- Apex point -->
                <circle cx="${cx}" cy="${apexY}" r="3" fill="#495057"/>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-cube"></i> Volume (V)</span>
                    <span class="property-value">${volume.toFixed(2)} units³</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Surface Area (SA)</span>
                    <span class="property-value">${surfaceArea.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler"></i> Base (b)</span>
                    <span class="property-value">${base} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Height (h)</span>
                    <span class="property-value">${h} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsPyr">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsPyr" class="collapse">
                <div class="card-body">
                    <strong>Volume:</strong><br>
                    V = (1/3) × base² × h<br>
                    V = (1/3) × ${base}² × ${h}<br>
                    V = (1/3) × ${(base * base).toFixed(2)} × ${h}<br>
                    <strong class="text-success">V = ${volume.toFixed(2)} cubic units</strong>
                    <hr>
                    <strong>Surface Area:</strong><br>
                    Slant height: l = √((base/2)² + h²) = ${slantHeight.toFixed(2)}<br>
                    SA = base² + 2 × base × l<br>
                    SA = ${(base * base).toFixed(2)} + 2 × ${base} × ${slantHeight.toFixed(2)}<br>
                    <strong class="text-success">SA = ${surfaceArea.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}

function getPrismCalculator() {
    return `
        <span class="dimension-badge">3D Solid</span>
        <h3><i class="fas fa-box"></i> Rectangular Prism</h3>

        <div class="formula-display">
            <h5>Formulas</h5>
            <div class="formula-text">
                Volume = l × w × h<br>
                Surface Area = 2(lw + lh + wh)
            </div>
        </div>

        <form onsubmit="calculatePrism(); return false;">
            <div class="input-group-custom">
                <label>Length (l):</label>
                <input type="number" class="form-control form-control-lg" id="prismLength" step="any" value="5" required>
            </div>
            <div class="input-group-custom">
                <label>Width (w):</label>
                <input type="number" class="form-control form-control-lg" id="prismWidth" step="any" value="3" required>
            </div>
            <div class="input-group-custom">
                <label>Height (h):</label>
                <input type="number" class="form-control form-control-lg" id="prismHeight" step="any" value="4" required>
            </div>
            <button type="submit" class="btn btn-success btn-block btn-lg">
                <i class="fas fa-calculator"></i> Calculate
            </button>
        </form>

        <div id="result"></div>
    `;
}

function calculatePrism() {
    const l = parseFloat(document.getElementById('prismLength').value);
    const w = parseFloat(document.getElementById('prismWidth').value);
    const h = parseFloat(document.getElementById('prismHeight').value);
    const volume = l * w * h;
    const surfaceArea = 2 * (l * w + l * h + w * h);

    const svgSize = 200;
    const prismL = 80;
    const prismW = 50;
    const prismH = 60;
    const offset = 20;
    const x1 = (svgSize - prismL - offset) / 2;
    const y1 = (svgSize - prismH + offset) / 2;

    document.getElementById('result').innerHTML = `
        <div class="shape-diagram">
            <h6 class="mb-3"><i class="fas fa-eye"></i> Rectangular Prism Visualization</h6>
            <svg width="${svgSize}" height="${svgSize}" viewBox="0 0 ${svgSize} ${svgSize}">
                <!-- Back face -->
                <rect x="${x1 + offset}" y="${y1 - offset}" width="${prismL}" height="${prismH}"
                    fill="rgba(102, 126, 234, 0.1)" stroke="#667eea" stroke-width="1.5"/>

                <!-- Front face -->
                <rect x="${x1}" y="${y1}" width="${prismL}" height="${prismH}"
                    fill="rgba(102, 126, 234, 0.3)" stroke="#667eea" stroke-width="2"/>

                <!-- Connecting lines for 3D effect -->
                <line x1="${x1}" y1="${y1}" x2="${x1 + offset}" y2="${y1 - offset}"
                    stroke="#667eea" stroke-width="1.5"/>
                <line x1="${x1 + prismL}" y1="${y1}" x2="${x1 + prismL + offset}" y2="${y1 - offset}"
                    stroke="#667eea" stroke-width="1.5"/>
                <line x1="${x1}" y1="${y1 + prismH}" x2="${x1 + offset}" y2="${y1 + prismH - offset}"
                    stroke="#667eea" stroke-width="1.5"/>
                <line x1="${x1 + prismL}" y1="${y1 + prismH}" x2="${x1 + prismL + offset}" y2="${y1 + prismH - offset}"
                    stroke="#667eea" stroke-width="1.5"/>

                <!-- Top face -->
                <polygon points="${x1},${y1} ${x1 + prismL},${y1} ${x1 + prismL + offset},${y1 - offset} ${x1 + offset},${y1 - offset}"
                    fill="rgba(102, 126, 234, 0.2)" stroke="#667eea" stroke-width="1.5"/>

                <!-- Labels -->
                <text x="${x1 + prismL/2}" y="${y1 + prismH + 20}" class="diagram-value" text-anchor="middle">
                    l = ${l}
                </text>
                <text x="${x1 + prismL + offset + 15}" y="${y1 + prismH/2}" class="diagram-value">
                    h = ${h}
                </text>
                <text x="${x1 + prismL + offset/2}" y="${y1 - offset - 5}" class="diagram-value" text-anchor="middle">
                    w = ${w}
                </text>
            </svg>

            <div class="mt-3">
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-cube"></i> Volume (V)</span>
                    <span class="property-value">${volume.toFixed(2)} units³</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-square"></i> Surface Area (SA)</span>
                    <span class="property-value">${surfaceArea.toFixed(2)} units²</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-horizontal"></i> Length (l)</span>
                    <span class="property-value">${l} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-horizontal"></i> Width (w)</span>
                    <span class="property-value">${w} units</span>
                </div>
                <div class="property-box">
                    <span class="property-label"><i class="fas fa-ruler-vertical"></i> Height (h)</span>
                    <span class="property-value">${h} units</span>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsPrism">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Calculation Steps
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="stepsPrism" class="collapse">
                <div class="card-body">
                    <strong>Volume:</strong><br>
                    V = l × w × h<br>
                    V = ${l} × ${w} × ${h}<br>
                    <strong class="text-success">V = ${volume.toFixed(2)} cubic units</strong>
                    <hr>
                    <strong>Surface Area:</strong><br>
                    SA = 2(lw + lh + wh)<br>
                    SA = 2(${l}×${w} + ${l}×${h} + ${w}×${h})<br>
                    SA = 2(${(l * w).toFixed(2)} + ${(l * h).toFixed(2)} + ${(w * h).toFixed(2)})<br>
                    SA = 2 × ${(l * w + l * h + w * h).toFixed(2)}<br>
                    <strong class="text-success">SA = ${surfaceArea.toFixed(2)} square units</strong>
                </div>
            </div>
        </div>
    `;
}
</script>


<!-- Visible FAQ section (must match JSON-LD below) -->
<section id="faq" class="mt-5">
  <h2 class="h5">Area & Volume: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do I choose a shape and enter units?</h3>
    <p class="mb-0">Select a 2D shape or 3D solid from the list, then enter dimensions in the same units (e.g., cm or m). Results display area or volume with squared or cubed units accordingly.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">Which formulas are used?</h3>
    <p class="mb-0">The tool uses standard geometry formulas, shown above the result (for example: circle A = πr², sphere V = 4⁄3 πr³, cylinder V = πr²h). Visual diagrams indicate each dimension.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">Can I adjust precision?</h3>
    <p class="mb-0">Yes. Use the precision or rounding controls where available, or round manually as needed. Keep consistent units to avoid conversion errors.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"How do I choose a shape and enter units?","acceptedAnswer":{"@type":"Answer","text":"Select a 2D shape or 3D solid from the list, then enter dimensions in the same units (e.g., cm or m). Results display area or volume with squared or cubed units accordingly."}},
    {"@type":"Question","name":"Which formulas are used?","acceptedAnswer":{"@type":"Answer","text":"The tool uses standard geometry formulas, shown above the result (for example: circle A = πr², sphere V = 4/3 πr³, cylinder V = πr²h). Visual diagrams indicate each dimension."}},
    {"@type":"Question","name":"Can I adjust precision?","acceptedAnswer":{"@type":"Answer","text":"Yes. Use the precision or rounding controls where available, or round manually as needed. Keep consistent units to avoid conversion errors."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Area & Volume Calculator","item":"https://8gwifi.org/area-volume-calculator.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
