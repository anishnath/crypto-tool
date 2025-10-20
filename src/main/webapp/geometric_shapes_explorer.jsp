
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Interactive Geometric Shapes Explorer - Visualize 2D and 3D shapes with formulas, properties, and real-time calculations">
    <meta name="keywords" content="geometry, shapes, 2D shapes, 3D shapes, polygons, polyhedrons, area, volume, surface area, perimeter">
    <title>Geometric Shapes Explorer - Interactive 2D & 3D Visualization</title>

    <%@ include file="header-script.jsp"%>

    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "WebPage",
            "name": "Geometric Shapes Explorer",
            "description": "Interactive tool for exploring geometric shapes with formulas and visualizations",
            "url": "https://8gwifi.org/geometric_shapes_explorer.jsp",
            "keywords": "geometry, shapes, mathematics, area, volume, 3D visualization"
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <style>
        .shapes-explorer { font-family: -apple-system, sans-serif; }
        
        /* Canvas Container */
        .shape-canvas-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%);
            border-radius: 16px;
            padding: 30px;
            min-height: 500px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
        }
        
        .shape-canvas-container::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: radial-gradient(circle at 30% 50%, rgba(255,255,255,0.15) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(240, 147, 251, 0.2) 0%, transparent 40%),
                        radial-gradient(circle at 20% 80%, rgba(118, 75, 162, 0.2) 0%, transparent 40%);
            pointer-events: none;
        }
        
        #shapeCanvas {
            border: 3px solid rgba(255,255,255,0.4);
            border-radius: 12px;
            background: linear-gradient(135deg, rgba(255,255,255,0.98) 0%, rgba(240,247,255,0.98) 100%);
            box-shadow: 0 10px 40px rgba(0,0,0,0.15), inset 0 1px 0 rgba(255,255,255,0.8);
            display: block;
            margin: 0 auto;
        }
        
        /* Shape Category Selector */
        .category-selector {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        
        .category-btn {
            flex: 1;
            min-width: 150px;
            padding: 15px;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            background: white;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            font-weight: 600;
        }
        
        .category-btn:hover {
            border-color: #0d6efd;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(13,110,253,0.2);
        }
        
        .category-btn.active {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            color: white;
            border-color: #0d6efd;
        }
        
        /* Shape Grid */
        .shape-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        
        .shape-card {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
        }
        
        .shape-card:hover {
            border-color: #0d6efd;
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(13,110,253,0.3);
        }
        
        .shape-card.active {
            border-color: #0d6efd;
            background: #e7f3ff;
            font-weight: 600;
        }
        
        .shape-icon {
            font-size: 36px;
            margin-bottom: 8px;
        }
        
        .shape-name {
            font-size: 13px;
            font-weight: 500;
            color: #495057;
        }
        
        /* Control Panel */
        .control-section {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
        }
        
        .control-section h6 {
            color: #495057;
            font-weight: 600;
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom: 2px solid #e9ecef;
        }
        
        /* Formula Display */
        .formula-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 15px;
        }
        
        .formula-title {
            font-size: 14px;
            opacity: 0.9;
            margin-bottom: 8px;
        }
        
        .formula-content {
            font-size: 18px;
            font-weight: bold;
            font-family: 'Courier New', monospace;
            background: rgba(255,255,255,0.2);
            padding: 10px;
            border-radius: 6px;
            margin-top: 8px;
        }
        
        /* Metrics Display */
        .metric-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 8px;
            padding: 15px;
            text-align: center;
            margin-bottom: 10px;
        }
        
        .metric-label {
            font-size: 12px;
            opacity: 0.9;
            margin-bottom: 5px;
        }
        
        .metric-value {
            font-size: 24px;
            font-weight: bold;
            font-family: 'Courier New', monospace;
        }
        
        /* Parameter Slider */
        .param-slider {
            margin: 15px 0;
        }
        
        .slider-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 500;
        }
        
        .custom-slider {
            -webkit-appearance: none;
            width: 100%;
            height: 6px;
            border-radius: 5px;
            background: #dee2e6;
            outline: none;
        }
        
        .custom-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: #0d6efd;
            cursor: pointer;
        }
        
        .custom-slider::-moz-range-thumb {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: #0d6efd;
            cursor: pointer;
            border: none;
        }
        
        /* Info Cards */
        .info-card {
            background: #e7f3ff;
            border-left: 4px solid #0d6efd;
            border-radius: 6px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .info-card h6 {
            color: #0d6efd;
            margin-bottom: 10px;
        }
        
        /* Properties List */
        .properties-list {
            background: #f8f9fa;
            border-radius: 6px;
            padding: 15px;
            margin: 15px 0;
        }
        
        .property-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .property-item:last-child {
            border-bottom: none;
        }
        
        .property-label {
            font-weight: 500;
            color: #495057;
        }
        
        .property-value {
            color: #0d6efd;
            font-family: 'Courier New', monospace;
        }
        
        /* Animation Toggle */
        .animation-controls {
            display: flex;
            gap: 10px;
            margin: 15px 0;
        }
        
        .anim-btn {
            flex: 1;
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .play-btn {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        
        .play-btn:hover {
            transform: scale(1.05);
        }
        
        .play-btn.playing {
            animation: pulse-glow 2s infinite;
        }
        
        @keyframes pulse-glow {
            0%, 100% { 
                transform: scale(1); 
                box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
            }
            50% { 
                transform: scale(1.05); 
                box-shadow: 0 6px 20px rgba(255, 193, 7, 0.6);
            }
        }
        
        .reset-btn {
            background: #6c757d;
            color: white;
        }
        
        .reset-btn:hover {
            background: #5a6268;
        }
        
        /* 3D View Toggle */
        .view-toggle {
            display: inline-flex;
            background: #e9ecef;
            border-radius: 6px;
            padding: 4px;
        }
        
        .view-btn {
            padding: 8px 16px;
            border: none;
            background: transparent;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .view-btn.active {
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        @media (max-width: 768px) {
            .shape-canvas-container { padding: 15px; min-height: 300px; }
            .category-selector { flex-direction: column; }
            .shape-grid { grid-template-columns: repeat(auto-fill, minmax(80px, 1fr)); }
        }
        
        /* Shape Legend Styles */
        .shape-legend {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            padding: 8px;
            background: white;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .legend-color {
            width: 20px;
            height: 3px;
            margin-right: 12px;
            border-radius: 2px;
        }
        
        .legend-text {
            font-weight: 500;
            color: #333;
        }
        
        .legend-title {
            font-size: 18px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 15px;
            text-align: center;
            border-bottom: 2px solid #3498db;
            padding-bottom: 8px;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🔷 Geometric Shapes Explorer</h1>
<p class="lead mb-3">Explore <strong>2D and 3D geometric shapes</strong> with interactive visualizations. See formulas, calculate properties, and watch shapes transform in real-time. Perfect for learning geometry!</p>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="shapes-explorer">
    <!-- Category Selection -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="category-selector">
                <div class="category-btn active" data-category="2d">
                    <div style="font-size: 32px;">📐</div>
                    <div>2D Shapes</div>
                    <small class="text-muted">Flat Figures</small>
                </div>
                <div class="category-btn" data-category="3d">
                    <div style="font-size: 32px;">🧊</div>
                    <div>3D Shapes</div>
                    <small class="text-muted">Solid Figures</small>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Left: Visualization -->
        <div class="col-lg-8 mb-4">
            <!-- Canvas -->
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">🎨 Shape Visualization</h5>
                    <div class="view-toggle">
                        <button class="view-btn active" id="btn2DView">2D View</button>
                        <button class="view-btn" id="btn3DView">3D View</button>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="shape-canvas-container">
                        <canvas id="shapeCanvas" width="700" height="500"></canvas>
                    </div>
                </div>
                <div class="card-footer">
                    <small class="text-muted">
                        Current Shape: <strong id="currentShapeName">Circle</strong>
                        • Dimension: <strong id="currentDimension">2D</strong>
                    </small>
                </div>
            </div>

            <!-- Calculated Properties -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">📊 Calculated Properties</h5>
                </div>
                <div class="card-body">
                    <div class="row" id="metricsContainer">
                        <!-- Dynamically populated -->
                    </div>
                </div>
            </div>

            <!-- Formula Chart -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">📈 Formula Visualization</h5>
                </div>
                <div class="card-body">
                    <div style="height: 300px;">
                        <canvas id="formulaChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Shape Components Legend -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">🔍 Shape Components</h5>
                </div>
                <div class="card-body">
                    <div id="shapeLegend" class="shape-legend">
                        <!-- Legend will be populated dynamically -->
                    </div>
                </div>
            </div>

            <!-- Info Card -->
            <div class="info-card">
                <h6>💡 How to Use</h6>
                <p>
                    <strong>1.</strong> Choose between 2D or 3D shapes<br>
                    <strong>2.</strong> Select a shape from the gallery (18 x 2D + 11 x 3D)<br>
                    <strong>3.</strong> Adjust dimensions using sliders<br>
                    <strong>4.</strong> Watch formulas and calculations update in real-time!<br>
                    <strong>5.</strong> Click "Play All" to see shapes being created progressively!<br>
                    <strong>✨ Features:</strong><br>
                    • Progressive drawing with color fill animation<br>
                    • Dimension lines with arrows showing measurements<br>
                    • Beautiful gradient backgrounds and shadows<br>
                    • Formula overlay (top-left) with formulas<br>
                    • <strong>NEW:</strong> Arrow pointers showing "Area (Fill)" and "Perimeter (Outline)"<br>
                    • Visual labels pointing directly to shape parts<br>
                    • Calculated values in chart below<br>
                    • Toggle labels and formulas on/off<br>
                    • All polygons from triangle to decagon!
                </p>
            </div>
        </div>

        <!-- Right: Controls & Info -->
        <div class="col-lg-4 mb-4">
            <!-- Shape Gallery -->
            <div class="control-section">
                <h6 id="shapeGalleryTitle">📦 2D Shapes Gallery</h6>
                <div class="shape-grid" id="shapeGallery">
                    <!-- Dynamically populated -->
                </div>
            </div>

            <!-- Formulas -->
            <div class="control-section">
                <h6>📐 Formulas</h6>
                <div id="formulasContainer">
                    <!-- Dynamically populated -->
                </div>
            </div>

            <!-- Parameters -->
            <div class="control-section">
                <h6>🎛️ Dimensions</h6>
                <div id="parametersContainer">
                    <!-- Dynamically populated -->
                </div>
            </div>

            <!-- Animation Controls -->
            <div class="control-section">
                <h6>🎮 Animation Controls</h6>
                <div class="animation-controls">
                    <button class="anim-btn play-btn" id="btnAnimate">▶ Rotate</button>
                    <button class="anim-btn reset-btn" id="btnReset">🔄 Reset</button>
                </div>
                <div class="form-check mt-3">
                    <input class="form-check-input" type="checkbox" id="showGrid" checked>
                    <label class="form-check-label" for="showGrid">
                        Show Grid
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="showLabels" checked>
                    <label class="form-check-label" for="showLabels">
                        Show Labels
                    </label>
                </div>
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" id="showFormulas" checked>
                    <label class="form-check-label" for="showFormulas">
                        Show Formulas on Canvas
                    </label>
                </div>
            </div>

            <!-- Auto-Play Controls -->
            <div class="control-section">
                <h6>🎬 Auto-Play Shapes</h6>
                <div class="animation-controls">
                    <button class="anim-btn play-btn" id="btnAutoPlay">▶ Play All</button>
                </div>
                <div class="param-slider mt-3">
                    <div class="slider-label">
                        <span>Speed</span>
                        <strong id="autoSpeedValue">2s</strong>
                    </div>
                    <input type="range" class="custom-slider" id="autoSpeedSlider" 
                           min="1" max="10" step="1" value="2">
                </div>
                <div class="form-check mt-2">
                    <input class="form-check-input" type="checkbox" id="autoRotate" checked>
                    <label class="form-check-label" for="autoRotate">
                        Auto-rotate 3D shapes
                    </label>
                </div>
            </div>

            <!-- Properties -->
            <div class="control-section">
                <h6>📋 Shape Properties</h6>
                <div class="properties-list" id="propertiesList">
                    <!-- Dynamically populated -->
                </div>
            </div>
        </div>
    </div>
</div>

<script>
//<![CDATA[
window.addEventListener('DOMContentLoaded', () => {
    // ============== CONFIGURATION ==============
    const canvas = document.getElementById('shapeCanvas');
    const ctx = canvas.getContext('2d');
    
    let currentCategory = '2d';
    let currentShape = 'circle';
    let isAnimating = false;
    let animationId = null;
    let rotation = { x: 0, y: 0, z: 0 };
    let view3D = false;
    let isAutoPlaying = false;
    let autoPlayInterval = null;
    let autoPlaySpeed = 2000; // milliseconds
    let formulaChart = null;
    let drawProgress = 1.0; // 0 to 1 for progressive drawing
    let isDrawingAnimated = false;
    let drawAnimationFrame = null;
    
    // Shape parameters
    let params = {
        radius: 100,
        width: 150,
        height: 100,
        side: 120,
        base: 150,
        depth: 100,
        sides: 6
    };
    
    // ============== COLOR PALETTE ==============
    const shapeColors = {
        '2d': {
            'circle': { fill: '#FF6B6B', stroke: '#E55353', gradient: ['#FF6B6B', '#FF8E8E'] },
            'square': { fill: '#4ECDC4', stroke: '#45B7B8', gradient: ['#4ECDC4', '#6ED5CD'] },
            'rectangle': { fill: '#45B7D1', stroke: '#3A9BC1', gradient: ['#45B7D1', '#6BC5D8'] },
            'triangle': { fill: '#96CEB4', stroke: '#85C1A3', gradient: ['#96CEB4', '#A8D5C1'] },
            'pentagon': { fill: '#FFEAA7', stroke: '#FDCB6E', gradient: ['#FFEAA7', '#FFF0C7'] },
            'hexagon': { fill: '#DDA0DD', stroke: '#D8BFD8', gradient: ['#DDA0DD', '#E6B3E6'] },
            'heptagon': { fill: '#98D8C8', stroke: '#7FCDCD', gradient: ['#98D8C8', '#B0E0E6'] },
            'octagon': { fill: '#F7DC6F', stroke: '#F4D03F', gradient: ['#F7DC6F', '#F9E79F'] },
            'nonagon': { fill: '#BB8FCE', stroke: '#A569BD', gradient: ['#BB8FCE', '#D2B4DE'] },
            'decagon': { fill: '#85C1E9', stroke: '#5DADE2', gradient: ['#85C1E9', '#AED6F1'] },
            'ellipse': { fill: '#F8C471', stroke: '#F39C12', gradient: ['#F8C471', '#FAD7A0'] },
            'semicircle': { fill: '#82E0AA', stroke: '#58D68D', gradient: ['#82E0AA', '#A9DFBF'] },
            'annulus': { fill: '#F1948A', stroke: '#EC7063', gradient: ['#F1948A', '#F5B7B1'] },
            'crescent': { fill: '#D7BDE2', stroke: '#C39BD3', gradient: ['#D7BDE2', '#E8DAEF'] },
            'rhombus': { fill: '#A9DFBF', stroke: '#7DCEA0', gradient: ['#A9DFBF', '#C8E6C9'] },
            'trapezoid': { fill: '#F9E79F', stroke: '#F7DC6F', gradient: ['#F9E79F', '#FCF3CF'] },
            'parallelogram': { fill: '#AED6F1', stroke: '#85C1E9', gradient: ['#AED6F1', '#D6EAF8'] },
            'kite': { fill: '#D5DBDB', stroke: '#BDC3C7', gradient: ['#D5DBDB', '#E8F8F5'] }
        },
        '3d': {
            'cube': { fill: '#FF6B6B', stroke: '#E55353', gradient: ['#FF6B6B', '#FF8E8E'] },
            'sphere': { fill: '#4ECDC4', stroke: '#45B7B8', gradient: ['#4ECDC4', '#6ED5CD'] },
            'cylinder': { fill: '#45B7D1', stroke: '#3A9BC1', gradient: ['#45B7D1', '#6BC5D8'] },
            'cone': { fill: '#96CEB4', stroke: '#85C1A3', gradient: ['#96CEB4', '#A8D5C1'] },
            'cuboid': { fill: '#FFEAA7', stroke: '#FDCB6E', gradient: ['#FFEAA7', '#FFF0C7'] },
            'pyramid': { fill: '#DDA0DD', stroke: '#D8BFD8', gradient: ['#DDA0DD', '#E6B3E6'] },
            'tetrahedron': { fill: '#98D8C8', stroke: '#7FCDCD', gradient: ['#98D8C8', '#B0E0E6'] },
            'prism': { fill: '#F7DC6F', stroke: '#F4D03F', gradient: ['#F7DC6F', '#F9E79F'] },
            'torus': { fill: '#BB8FCE', stroke: '#A569BD', gradient: ['#BB8FCE', '#D2B4DE'] },
            'hemisphere': { fill: '#85C1E9', stroke: '#5DADE2', gradient: ['#85C1E9', '#AED6F1'] },
            'ellipsoid': { fill: '#F8C471', stroke: '#F39C12', gradient: ['#F8C471', '#FAD7A0'] }
        }
    };

    // ============== SHAPE DEFINITIONS ==============
    const shapes = {
        '2d': {
            'circle': { name: 'Circle', icon: '⭕', params: ['radius'] },
            'square': { name: 'Square', icon: '⬜', params: ['side'] },
            'rectangle': { name: 'Rectangle', icon: '▭', params: ['width', 'height'] },
            'triangle': { name: 'Triangle', icon: '🔺', params: ['base', 'height'] },
            'pentagon': { name: 'Pentagon', icon: '⬠', params: ['side'] },
            'hexagon': { name: 'Hexagon', icon: '⬡', params: ['side'] },
            'heptagon': { name: 'Heptagon', icon: '⬢', params: ['side'] },
            'octagon': { name: 'Octagon', icon: '⯄', params: ['side'] },
            'nonagon': { name: 'Nonagon', icon: '⬣', params: ['side'] },
            'decagon': { name: 'Decagon', icon: '⬤', params: ['side'] },
            'ellipse': { name: 'Ellipse', icon: '⬭', params: ['width', 'height'] },
            'semicircle': { name: 'Semicircle', icon: '◐', params: ['radius'] },
            'annulus': { name: 'Annulus', icon: '⭕', params: ['radius', 'width'] },
            'crescent': { name: 'Crescent', icon: '🌙', params: ['radius', 'width'] },
            'rhombus': { name: 'Rhombus', icon: '◆', params: ['side', 'height'] },
            'trapezoid': { name: 'Trapezoid', icon: '⏢', params: ['base', 'height', 'width'] },
            'parallelogram': { name: 'Parallelogram', icon: '▱', params: ['base', 'height'] },
            'kite': { name: 'Kite', icon: '🪁', params: ['width', 'height'] }
        },
        '3d': {
            'cube': { name: 'Cube', icon: '🧊', params: ['side'] },
            'sphere': { name: 'Sphere', icon: '🔮', params: ['radius'] },
            'cylinder': { name: 'Cylinder', icon: '🥫', params: ['radius', 'height'] },
            'cone': { name: 'Cone', icon: '🔻', params: ['radius', 'height'] },
            'cuboid': { name: 'Cuboid', icon: '📦', params: ['width', 'height', 'depth'] },
            'pyramid': { name: 'Pyramid', icon: '🔺', params: ['base', 'height'] },
            'tetrahedron': { name: 'Tetrahedron', icon: '▲', params: ['side'] },
            'prism': { name: 'Prism', icon: '⬟', params: ['side', 'height', 'sides'] },
            'torus': { name: 'Torus', icon: '🍩', params: ['radius', 'width'] },
            'hemisphere': { name: 'Hemisphere', icon: '◗', params: ['radius'] },
            'ellipsoid': { name: 'Ellipsoid', icon: '🥚', params: ['width', 'height', 'depth'] }
        }
    };
    
    // ============== FORMULAS ==============
    const formulas = {
        '2d': {
            'circle': {
                'Area': 'πr²',
                'Circumference': '2πr',
                calculate: () => ({
                    'Area': Math.PI * params.radius * params.radius,
                    'Circumference': 2 * Math.PI * params.radius
                })
            },
            'square': {
                'Area': 's²',
                'Perimeter': '4s',
                'Diagonal': 's√2',
                calculate: () => ({
                    'Area': params.side * params.side,
                    'Perimeter': 4 * params.side,
                    'Diagonal': params.side * Math.sqrt(2)
                })
            },
            'rectangle': {
                'Area': 'w × h',
                'Perimeter': '2(w + h)',
                'Diagonal': '√(w² + h²)',
                calculate: () => ({
                    'Area': params.width * params.height,
                    'Perimeter': 2 * (params.width + params.height),
                    'Diagonal': Math.sqrt(params.width * params.width + params.height * params.height)
                })
            },
            'triangle': {
                'Area': '½bh',
                'Perimeter': 'a + b + c',
                calculate: () => ({
                    'Area': 0.5 * params.base * params.height,
                    'Perimeter': params.base * 3
                })
            },
            'pentagon': {
                'Area': '¼√(25+10√5)s²',
                'Perimeter': '5s',
                calculate: () => ({
                    'Area': 0.25 * Math.sqrt(25 + 10 * Math.sqrt(5)) * params.side * params.side,
                    'Perimeter': 5 * params.side
                })
            },
            'hexagon': {
                'Area': '(3√3/2)s²',
                'Perimeter': '6s',
                calculate: () => ({
                    'Area': (3 * Math.sqrt(3) / 2) * params.side * params.side,
                    'Perimeter': 6 * params.side
                })
            },
            'octagon': {
                'Area': '2(1+√2)s²',
                'Perimeter': '8s',
                calculate: () => ({
                    'Area': 2 * (1 + Math.sqrt(2)) * params.side * params.side,
                    'Perimeter': 8 * params.side
                })
            },
            'ellipse': {
                'Area': 'πab',
                'Perimeter': 'π(a+b)(1+3h/(10+√(4-3h)))',
                calculate: () => {
                    const a = params.width / 2;
                    const b = params.height / 2;
                    const h = Math.pow((a - b) / (a + b), 2);
                    return {
                        'Area': Math.PI * a * b,
                        'Perimeter': Math.PI * (a + b) * (1 + (3 * h) / (10 + Math.sqrt(4 - 3 * h)))
                    };
                }
            },
            'rhombus': {
                'Area': 'base × height',
                'Perimeter': '4s',
                calculate: () => ({
                    'Area': params.side * params.height,
                    'Perimeter': 4 * params.side
                })
            },
            'trapezoid': {
                'Area': '½(a+b)h',
                'Perimeter': 'a + b + 2c',
                calculate: () => ({
                    'Area': 0.5 * (params.base + params.width) * params.height,
                    'Perimeter': params.base + params.width + 2 * Math.sqrt(Math.pow((params.base - params.width) / 2, 2) + params.height * params.height)
                })
            },
            'parallelogram': {
                'Area': 'b × h',
                'Perimeter': '2(a + b)',
                calculate: () => ({
                    'Area': params.base * params.height,
                    'Perimeter': 2 * (params.base + params.height)
                })
            },
            'kite': {
                'Area': '½d₁d₂',
                'Perimeter': '2(a + b)',
                calculate: () => ({
                    'Area': 0.5 * params.width * params.height,
                    'Perimeter': 2 * (params.width + params.height)
                })
            },
            'heptagon': {
                'Area': '(7/4)s²cot(π/7)',
                'Perimeter': '7s',
                calculate: () => ({
                    'Area': (7/4) * params.side * params.side / Math.tan(Math.PI / 7),
                    'Perimeter': 7 * params.side
                })
            },
            'nonagon': {
                'Area': '(9/4)s²cot(π/9)',
                'Perimeter': '9s',
                calculate: () => ({
                    'Area': (9/4) * params.side * params.side / Math.tan(Math.PI / 9),
                    'Perimeter': 9 * params.side
                })
            },
            'decagon': {
                'Area': '(5/2)s²√(5+2√5)',
                'Perimeter': '10s',
                calculate: () => ({
                    'Area': 2.5 * params.side * params.side * Math.sqrt(5 + 2 * Math.sqrt(5)),
                    'Perimeter': 10 * params.side
                })
            },
            'semicircle': {
                'Area': '½πr²',
                'Perimeter': 'πr + 2r',
                calculate: () => ({
                    'Area': 0.5 * Math.PI * params.radius * params.radius,
                    'Perimeter': Math.PI * params.radius + 2 * params.radius
                })
            },
            'annulus': {
                'Area': 'π(R²-r²)',
                'Perimeter': '2π(R+r)',
                calculate: () => {
                    const R = params.radius;
                    const r = params.width;
                    return {
                        'Area': Math.PI * (R * R - r * r),
                        'Perimeter': 2 * Math.PI * (R + r)
                    };
                }
            },
            'crescent': {
                'Area': '½r₁²(θ-sin θ)',
                'Perimeter': 'Approx',
                calculate: () => {
                    const r1 = params.radius;
                    const r2 = params.width;
                    const area = 0.5 * Math.PI * r1 * r1 - 0.5 * Math.PI * r2 * r2;
                    return {
                        'Area': Math.abs(area),
                        'Perimeter': Math.PI * (r1 + r2)
                    };
                }
            }
        },
        '3d': {
            'cube': {
                'Volume': 's³',
                'Surface Area': '6s²',
                'Diagonal': 's√3',
                calculate: () => ({
                    'Volume': Math.pow(params.side, 3),
                    'Surface Area': 6 * params.side * params.side,
                    'Diagonal': params.side * Math.sqrt(3)
                })
            },
            'sphere': {
                'Volume': '(4/3)πr³',
                'Surface Area': '4πr²',
                calculate: () => ({
                    'Volume': (4/3) * Math.PI * Math.pow(params.radius, 3),
                    'Surface Area': 4 * Math.PI * params.radius * params.radius
                })
            },
            'cylinder': {
                'Volume': 'πr²h',
                'Surface Area': '2πr(r+h)',
                calculate: () => ({
                    'Volume': Math.PI * params.radius * params.radius * params.height,
                    'Surface Area': 2 * Math.PI * params.radius * (params.radius + params.height)
                })
            },
            'cone': {
                'Volume': '(1/3)πr²h',
                'Surface Area': 'πr(r+√(h²+r²))',
                calculate: () => ({
                    'Volume': (1/3) * Math.PI * params.radius * params.radius * params.height,
                    'Surface Area': Math.PI * params.radius * (params.radius + Math.sqrt(params.height * params.height + params.radius * params.radius))
                })
            },
            'cuboid': {
                'Volume': 'w × h × d',
                'Surface Area': '2(wh+hd+dw)',
                'Diagonal': '√(w²+h²+d²)',
                calculate: () => ({
                    'Volume': params.width * params.height * params.depth,
                    'Surface Area': 2 * (params.width * params.height + params.height * params.depth + params.depth * params.width),
                    'Diagonal': Math.sqrt(params.width * params.width + params.height * params.height + params.depth * params.depth)
                })
            },
            'pyramid': {
                'Volume': '(1/3)b²h',
                'Surface Area': 'b²+2b√((b/2)²+h²)',
                calculate: () => ({
                    'Volume': (1/3) * params.base * params.base * params.height,
                    'Surface Area': params.base * params.base + 2 * params.base * Math.sqrt(Math.pow(params.base / 2, 2) + params.height * params.height)
                })
            },
            'tetrahedron': {
                'Volume': 's³/(6√2)',
                'Surface Area': '√3s²',
                calculate: () => ({
                    'Volume': Math.pow(params.side, 3) / (6 * Math.sqrt(2)),
                    'Surface Area': Math.sqrt(3) * params.side * params.side
                })
            },
            'prism': {
                'Volume': 'Base Area × h',
                'Surface Area': '2×Base + Lateral',
                calculate: () => {
                    const baseArea = 0.5 * params.sides * params.side * params.side * (1 / Math.tan(Math.PI / params.sides));
                    return {
                        'Volume': baseArea * params.height,
                        'Surface Area': 2 * baseArea + params.sides * params.side * params.height
                    };
                }
            },
            'torus': {
                'Volume': '2π²Rr²',
                'Surface Area': '4π²Rr',
                calculate: () => ({
                    'Volume': 2 * Math.PI * Math.PI * params.radius * params.width * params.width,
                    'Surface Area': 4 * Math.PI * Math.PI * params.radius * params.width
                })
            },
            'hemisphere': {
                'Volume': '(2/3)πr³',
                'Surface Area': '3πr²',
                calculate: () => ({
                    'Volume': (2/3) * Math.PI * Math.pow(params.radius, 3),
                    'Surface Area': 3 * Math.PI * params.radius * params.radius
                })
            },
            'ellipsoid': {
                'Volume': '(4/3)πabc',
                'Surface Area': 'Approximation',
                calculate: () => ({
                    'Volume': (4/3) * Math.PI * (params.width/2) * (params.height/2) * (params.depth/2),
                    'Surface Area': 4 * Math.PI * Math.pow(((Math.pow(params.width/2 * params.height/2, 1.6) + Math.pow(params.width/2 * params.depth/2, 1.6) + Math.pow(params.height/2 * params.depth/2, 1.6)) / 3), 1/1.6)
                })
            }
        }
    };
    
    // ============== RENDERING FUNCTIONS ==============
    function drawShape() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);
        
        // Draw grid if enabled
        if (document.getElementById('showGrid').checked) {
            drawGrid();
        }
        
        ctx.save();
        ctx.translate(canvas.width / 2, canvas.height / 2);
        
        if (currentCategory === '2d') {
            draw2DShape();
        } else {
            draw3DShape();
        }
        
        ctx.restore();
        
        // Reset any shadows
        ctx.shadowColor = 'transparent';
        ctx.shadowBlur = 0;
        
        // Draw formulas on canvas
        drawFormulasOnCanvas();
        
        // Draw property labels on visualization
        drawPropertyLabels();
        
        updateCalculations();
    }
    
    function drawPropertyLabels() {
        if (!formulas[currentCategory][currentShape]) return;
        if (drawProgress < 0.9) return; // Only show when shape is almost complete
        
        const formula = formulas[currentCategory][currentShape];
        
        // Get property names (Area, Circumference, Volume, etc.)
        const properties = Object.keys(formula).filter(k => k !== 'calculate');
        
        // Draw property indicators on the shape
        ctx.save();
        ctx.shadowColor = 'transparent';
        
        // Position labels around the shape with arrows pointing to relevant parts
        if (currentCategory === '2d') {
            // Shape-specific property labeling with educational components
            if (currentShape === 'circle') {
                drawCircleComponents();
            } else if (currentShape === 'semicircle') {
                drawSemicircleComponents();
            } else if (currentShape === 'annulus') {
                drawAnnulusComponents();
            } else if (currentShape === 'square') {
                drawSquareComponents();
            } else if (currentShape === 'rectangle') {
                drawRectangleComponents();
            } else if (currentShape === 'triangle') {
                drawTriangleComponents();
            } else if (currentShape === 'ellipse') {
                drawEllipseComponents();
            } else {
                // Default for other shapes
                if (properties.includes('Area')) {
                    drawPropertyPointer('Area', 0, 20, -120, 90, '#28a745');
                }
                if (properties.includes('Perimeter')) {
                    drawPropertyPointer('Perimeter', 70, -40, 140, -90, '#0d6efd');
                }
            }
        } else {
            // For 3D shapes
            if (properties.includes('Volume')) {
                drawPropertyPointer('Volume', 0, 20, -130, 100, '#28a745');
            }
            if (properties.includes('Surface Area')) {
                drawPropertyPointer('Surface Area', 70, -50, 150, -110, '#0d6efd');
            }
        }
        
        ctx.restore();
    }
    
    function drawCircleComponents() {
        const radius = getCurrentParameters().radius;
        
        // Center point
        ctx.save();
        ctx.fillStyle = '#28a745';
        ctx.beginPath();
        ctx.arc(0, 0, 4, 0, 2 * Math.PI);
        ctx.fill();
        ctx.restore();
        
        // Center label
        drawComponentLabel('O', 0, -15, '#28a745', 'center');
        
        // Radius dimension line
        drawDimensionLine(0, 0, radius, 0, 'R');
        
        // Diameter dimension line
        drawDimensionLine(-radius, 0, radius, 0, 'D');
        
        // Circumference arrow around the circle
        ctx.save();
        ctx.strokeStyle = '#000000';
        ctx.lineWidth = 2;
        ctx.setLineDash([8, 4]);
        
        // Draw circumference path around the circle
        const offset = 30;
        ctx.beginPath();
        ctx.arc(0, 0, radius + offset, 0, 2 * Math.PI);
        ctx.stroke();
        ctx.restore();
        
        // Circumference label
        drawComponentLabel('C', radius + 50, -20, '#000000', 'center');
        
        // Area label
        drawPropertyPointer('Area', 0, 0, -120, 100, '#28a745');
    }
    
    function drawSemicircleComponents() {
        const radius = getCurrentParameters().radius;
        
        // Center point
        ctx.save();
        ctx.fillStyle = '#28a745';
        ctx.beginPath();
        ctx.arc(0, 0, 4, 0, 2 * Math.PI);
        ctx.fill();
        ctx.restore();
        
        // Center label
        drawComponentLabel('O', 0, -15, '#28a745', 'center');
        
        // Radius dimension line
        drawDimensionLine(0, 0, radius, 0, 'R');
        
        // Base dimension line
        drawDimensionLine(-radius, 0, radius, 0, 'Base');
        
        // Arc arrow around the semicircle
        ctx.save();
        ctx.strokeStyle = '#000000';
        ctx.lineWidth = 2;
        ctx.setLineDash([8, 4]);
        
        // Draw arc path around the semicircle
        const offset = 30;
        ctx.beginPath();
        ctx.arc(0, 0, radius + offset, 0, Math.PI);
        ctx.stroke();
        ctx.restore();
        
        // Arc label
        drawComponentLabel('Arc', 0, -radius - 50, '#000000', 'center');
    }
    
    function drawAnnulusComponents() {
        const params = getCurrentParameters();
        const outerRadius = params.radius;
        const innerRadius = params.radius - params.width;
        
        // Center point
        ctx.save();
        ctx.fillStyle = '#28a745';
        ctx.beginPath();
        ctx.arc(0, 0, 4, 0, 2 * Math.PI);
        ctx.fill();
        ctx.restore();
        
        // Center label
        drawComponentLabel('O', 0, -15, '#28a745', 'center');
        
        // Outer radius dimension line
        drawDimensionLine(0, 0, outerRadius, 0, 'R₁');
        
        // Inner radius dimension line
        drawDimensionLine(0, 0, innerRadius, 0, 'R₂');
        
        // Ring area label
        drawPropertyPointer('Ring Area', 0, 0, -140, 100, '#28a745');
    }
    
    function drawSquareComponents() {
        const side = getCurrentParameters().side;
        
        // Side length dimension line
        drawDimensionLine(-side/2, -side/2 - 20, side/2, -side/2 - 20, 's');
        
        // Perimeter arrow around the square
        ctx.save();
        ctx.strokeStyle = '#0d6efd';
        ctx.lineWidth = 2;
        ctx.setLineDash([8, 4]);
        
        // Draw perimeter path around the square
        const offset = 30;
        ctx.beginPath();
        ctx.moveTo(-side/2 - offset, -side/2 - offset);
        ctx.lineTo(side/2 + offset, -side/2 - offset);
        ctx.lineTo(side/2 + offset, side/2 + offset);
        ctx.lineTo(-side/2 - offset, side/2 + offset);
        ctx.closePath();
        ctx.stroke();
        ctx.restore();
        
        // Perimeter label
        drawComponentLabel('Perimeter', side/2 + 40, 0, '#0d6efd', 'center');
        
        // Area label
        drawPropertyPointer('Area', 0, 0, -140, 60, '#28a745');
    }
    
    function drawRectangleComponents() {
        const params = getCurrentParameters();
        const width = params.width;
        const height = params.height;
        
        // Width dimension line
        drawDimensionLine(-width/2, -height/2 - 20, width/2, -height/2 - 20, 'w');
        
        // Height dimension line
        drawDimensionLine(-width/2 - 20, -height/2, -width/2 - 20, height/2, 'h');
        
        // Perimeter arrow around the rectangle
        ctx.save();
        ctx.strokeStyle = '#0d6efd';
        ctx.lineWidth = 2;
        ctx.setLineDash([8, 4]);
        
        // Draw perimeter path around the rectangle
        const offset = 30;
        ctx.beginPath();
        ctx.moveTo(-width/2 - offset, -height/2 - offset);
        ctx.lineTo(width/2 + offset, -height/2 - offset);
        ctx.lineTo(width/2 + offset, height/2 + offset);
        ctx.lineTo(-width/2 - offset, height/2 + offset);
        ctx.closePath();
        ctx.stroke();
        ctx.restore();
        
        // Perimeter label
        drawComponentLabel('Perimeter', width/2 + 40, 0, '#0d6efd', 'center');
        
        // Area label
        drawPropertyPointer('Area', 0, 0, -140, 60, '#28a745');
    }
    
    function drawTriangleComponents() {
        const params = getCurrentParameters();
        const base = params.base;
        const height = params.height;
        
        // Base dimension line
        drawDimensionLine(-base/2, height/2 + 20, base/2, height/2 + 20, 'b');
        
        // Height dimension line
        drawDimensionLine(-base/2 - 20, height/2, -base/2 - 20, -height/2, 'h');
        
        // Perimeter arrow around the triangle
        ctx.save();
        ctx.strokeStyle = '#0d6efd';
        ctx.lineWidth = 2;
        ctx.setLineDash([8, 4]);
        
        // Draw perimeter path around the triangle
        const offset = 30;
        ctx.beginPath();
        ctx.moveTo(-base/2 - offset, height/2 + offset);
        ctx.lineTo(base/2 + offset, height/2 + offset);
        ctx.lineTo(0, -height/2 - offset);
        ctx.closePath();
        ctx.stroke();
        ctx.restore();
        
        // Perimeter label
        drawComponentLabel('Perimeter', 0, height/2 + 50, '#0d6efd', 'center');
        
        // Area label
        drawPropertyPointer('Area', 0, 0, -140, 60, '#28a745');
    }
    
    function drawEllipseComponents() {
        const params = getCurrentParameters();
        const a = params.width / 2; // semi-major axis
        const b = params.height / 2; // semi-minor axis
        
        // Semi-major axis dimension line
        drawDimensionLine(-a, 0, a, 0, 'a');
        
        // Semi-minor axis dimension line
        drawDimensionLine(0, -b, 0, b, 'b');
        
        // Center point
        ctx.save();
        ctx.fillStyle = '#28a745';
        ctx.beginPath();
        ctx.arc(0, 0, 4, 0, 2 * Math.PI);
        ctx.fill();
        ctx.restore();
        
        // Center label
        drawComponentLabel('O', 0, -25, '#28a745', 'center');
        
        // Perimeter arrow around the ellipse
        ctx.save();
        ctx.strokeStyle = '#0d6efd';
        ctx.lineWidth = 2;
        ctx.setLineDash([8, 4]);
        
        // Draw perimeter path around the ellipse
        const offset = 30;
        ctx.beginPath();
        ctx.ellipse(0, 0, a + offset, b + offset, 0, 0, 2 * Math.PI);
        ctx.stroke();
        ctx.restore();
        
        // Perimeter label
        drawComponentLabel('Perimeter', a + 50, 0, '#0d6efd', 'center');
        
        // Area label
        drawPropertyPointer('Area', 0, 0, -140, 100, '#28a745');
    }
    
    function drawComponentLabel(text, x, y, color, align = 'center') {
        ctx.save();
        ctx.fillStyle = color;
        ctx.font = 'bold 14px Arial';
        ctx.textAlign = align;
        ctx.textBaseline = 'middle';
        ctx.fillText(text, x, y);
        ctx.restore();
    }
    
    function drawPropertyPointer(text, fromX, fromY, toX, toY, color) {
        ctx.save();
        ctx.shadowColor = 'transparent';
        
        // Draw arrow line
        ctx.strokeStyle = color;
        ctx.lineWidth = 2;
        ctx.setLineDash([5, 3]);
        ctx.beginPath();
        ctx.moveTo(fromX, fromY);
        ctx.lineTo(toX, toY);
        ctx.stroke();
        ctx.setLineDash([]);
        
        // Draw arrowhead
        const angle = Math.atan2(fromY - toY, fromX - toX);
        const arrowSize = 8;
        ctx.fillStyle = color;
        ctx.beginPath();
        ctx.moveTo(fromX, fromY);
        ctx.lineTo(fromX - arrowSize * Math.cos(angle - Math.PI / 6), 
                   fromY - arrowSize * Math.sin(angle - Math.PI / 6));
        ctx.lineTo(fromX - arrowSize * Math.cos(angle + Math.PI / 6), 
                   fromY - arrowSize * Math.sin(angle + Math.PI / 6));
        ctx.closePath();
        ctx.fill();
        
        // Draw label badge at the end of arrow
        ctx.font = '12px Arial';
        const metrics = ctx.measureText(text);
        const padding = 8;
        const bgWidth = metrics.width + padding * 2;
        const bgHeight = 24;
        
        // Background with shadow
        ctx.shadowColor = 'rgba(0, 0, 0, 0.3)';
        ctx.shadowBlur = 8;
        ctx.shadowOffsetX = 2;
        ctx.shadowOffsetY = 2;
        
        ctx.fillStyle = color;
        ctx.globalAlpha = 0.95;
        ctx.beginPath();
        ctx.roundRect(toX - bgWidth/2, toY - bgHeight/2, bgWidth, bgHeight, 6);
        ctx.fill();
        
        // Text
        ctx.shadowColor = 'transparent';
        ctx.globalAlpha = 1.0;
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 12px Arial';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(text, toX, toY);
        
        ctx.restore();
    }
    
    function drawPropertyBadge(text, x, y, color) {
        ctx.save();
        ctx.shadowColor = 'transparent';
        
        // Create a small badge
        ctx.font = '12px Arial';
        const metrics = ctx.measureText(text);
        const padding = 6;
        const bgWidth = metrics.width + padding * 2;
        const bgHeight = 20;
        
        // Background
        ctx.fillStyle = color;
        ctx.globalAlpha = 0.9;
        ctx.beginPath();
        ctx.roundRect(x - bgWidth/2, y - bgHeight/2, bgWidth, bgHeight, 4);
        ctx.fill();
        
        // Text
        ctx.globalAlpha = 1.0;
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 11px Arial';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(text, x, y);
        
        ctx.restore();
    }
    
    function drawFormulasOnCanvas() {
        if (!document.getElementById('showFormulas').checked) return;
        if (!formulas[currentCategory][currentShape]) return;
        
        const formula = formulas[currentCategory][currentShape];
        
        // Draw gradient background box
        ctx.save();
        
        const boxX = 10;
        const boxY = 10;
        const boxWidth = 250;
        const lineHeight = 26;
        const formulaEntries = Object.entries(formula).filter(([k]) => k !== 'calculate');
        const boxHeight = formulaEntries.length * lineHeight + 60;
        
        // Gradient background
        const gradient = ctx.createLinearGradient(boxX, boxY, boxX, boxY + boxHeight);
        gradient.addColorStop(0, 'rgba(102, 126, 234, 0.95)');
        gradient.addColorStop(1, 'rgba(118, 75, 162, 0.95)');
        ctx.fillStyle = gradient;
        ctx.shadowColor = 'rgba(0, 0, 0, 0.3)';
        ctx.shadowBlur = 15;
        ctx.shadowOffsetX = 3;
        ctx.shadowOffsetY = 3;
        
        // Rounded rectangle
        ctx.beginPath();
        ctx.roundRect(boxX, boxY, boxWidth, boxHeight, 12);
        ctx.fill();
        
        ctx.shadowColor = 'transparent';
        
        // Draw title with icon
        ctx.fillStyle = '#ffffff';
        ctx.font = 'bold 18px Arial';
        ctx.fillText('📐 ' + shapes[currentCategory][currentShape].name, boxX + 15, boxY + 30);
        
        // Draw separator line
        ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(boxX + 15, boxY + 40);
        ctx.lineTo(boxX + boxWidth - 15, boxY + 40);
        ctx.stroke();
        
        let yPos = boxY + 60;
        
        // Draw formulas with better styling
        formulaEntries.forEach(([key, value]) => {
            ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
            ctx.font = '13px Arial';
            ctx.fillText(key + ':', boxX + 15, yPos);
            
            ctx.fillStyle = '#FFD700';
            ctx.font = 'bold 15px Courier New';
            ctx.fillText(value, boxX + 85, yPos);
            
            yPos += lineHeight;
        });
        
        ctx.restore();
    }
    
    function drawGrid() {
        ctx.strokeStyle = '#e9ecef';
        ctx.lineWidth = 1;
        
        for (let x = 0; x < canvas.width; x += 50) {
            ctx.beginPath();
            ctx.moveTo(x, 0);
            ctx.lineTo(x, canvas.height);
            ctx.stroke();
        }
        
        for (let y = 0; y < canvas.height; y += 50) {
            ctx.beginPath();
            ctx.moveTo(0, y);
            ctx.lineTo(canvas.width, y);
            ctx.stroke();
        }
        
        // Center axes
        ctx.strokeStyle = '#ced4da';
        ctx.lineWidth = 2;
        ctx.beginPath();
        ctx.moveTo(canvas.width / 2, 0);
        ctx.lineTo(canvas.width / 2, canvas.height);
        ctx.moveTo(0, canvas.height / 2);
        ctx.lineTo(canvas.width, canvas.height / 2);
        ctx.stroke();
    }
    
    function drawProgressiveRect(x, y, width, height) {
        if (drawProgress <= 0) return;
        
        // Always fill the completed portion
        if (drawProgress > 0.2) {
            ctx.save();
            ctx.globalAlpha = Math.min(0.6, drawProgress * 0.8);
            ctx.fillRect(x, y, width * drawProgress, height * drawProgress);
            ctx.restore();
        }
        
        ctx.beginPath();
        // Draw rectangle progressively (4 sides)
        const perimeter = 2 * (width + height);
        const progressLength = perimeter * drawProgress;
        
        ctx.moveTo(x, y);
        
        let drawn = 0;
        // Top side
        if (progressLength > drawn) {
            const len = Math.min(width, progressLength - drawn);
            ctx.lineTo(x + len, y);
            drawn += len;
        }
        
        // Right side
        if (progressLength > drawn) {
            const len = Math.min(height, progressLength - drawn);
            ctx.lineTo(x + width, y + len);
            drawn += len;
        }
        
        // Bottom side
        if (progressLength > drawn) {
            const len = Math.min(width, progressLength - drawn);
            ctx.lineTo(x + width - len, y + height);
            drawn += len;
        }
        
        // Left side
        if (progressLength > drawn) {
            const len = Math.min(height, progressLength - drawn);
            ctx.lineTo(x, y + height - len);
        }
        
        if (drawProgress >= 1.0) {
            ctx.closePath();
            ctx.fill();
        }
        ctx.stroke();
    }
    
    function drawProgressivePath(points, closed) {
        if (drawProgress <= 0 || points.length === 0) return;
        
        const totalSegments = closed ? points.length : points.length - 1;
        const segmentsToShow = drawProgress * totalSegments;
        
        // Fill progressively for closed paths
        if (closed && drawProgress > 0.3) {
            ctx.save();
            ctx.globalAlpha = Math.min(0.6, (drawProgress - 0.2) * 0.8);
            ctx.beginPath();
            ctx.moveTo(points[0][0], points[0][1]);
            for (let i = 1; i < points.length; i++) {
                if (i <= segmentsToShow) {
                    const progress = Math.min(1, segmentsToShow - (i - 1));
                    const x = points[i - 1][0] + (points[i][0] - points[i - 1][0]) * progress;
                    const y = points[i - 1][1] + (points[i][1] - points[i - 1][1]) * progress;
                    ctx.lineTo(x, y);
                }
            }
            if (drawProgress > 0.8) {
                ctx.closePath();
            }
            ctx.fill();
            ctx.restore();
        }
        
        // Draw outline
        ctx.beginPath();
        ctx.moveTo(points[0][0], points[0][1]);
        
        for (let i = 1; i < points.length; i++) {
            if (i <= segmentsToShow) {
                const progress = Math.min(1, segmentsToShow - (i - 1));
                const x = points[i - 1][0] + (points[i][0] - points[i - 1][0]) * progress;
                const y = points[i - 1][1] + (points[i][1] - points[i - 1][1]) * progress;
                ctx.lineTo(x, y);
            }
        }
        
        // Close path if needed
        if (closed && drawProgress >= 1.0) {
            ctx.closePath();
            ctx.fill();
        }
        ctx.stroke();
    }
    
    // ============== PARAMETER FUNCTIONS ==============
    function getCurrentParameters() {
        const shape = shapes[currentCategory][currentShape];
        if (!shape) return {};
        
        const currentParams = {};
        shape.params.forEach(param => {
            if (params[param] !== undefined) {
                currentParams[param] = params[param];
            }
        });
        return currentParams;
    }

    // ============== COLOR FUNCTIONS ==============
    function getShapeColors() {
        const colors = shapeColors[currentCategory] && shapeColors[currentCategory][currentShape] ? 
            shapeColors[currentCategory][currentShape] : {
                fill: '#667eea',
                stroke: '#5a6fd8',
                gradient: ['#667eea', '#764ba2']
            };
        
        // Ensure gradient array exists and has valid colors
        if (!colors.gradient || !Array.isArray(colors.gradient) || colors.gradient.length < 2) {
            colors.gradient = ['#667eea', '#764ba2'];
        }
        
        return colors;
    }
    
    function createGradient(ctx, x1, y1, x2, y2, colors) {
        const gradient = ctx.createLinearGradient(x1, y1, x2, y2);
        if (colors && colors[0] && colors[1]) {
            gradient.addColorStop(0, colors[0]);
            gradient.addColorStop(1, colors[1]);
        } else {
            gradient.addColorStop(0, '#667eea');
            gradient.addColorStop(1, '#764ba2');
        }
        return gradient;
    }
    
    function createRadialGradient(ctx, x, y, r, colors) {
        const gradient = ctx.createRadialGradient(x, y, 0, x, y, r);
        if (colors && colors[0] && colors[1]) {
            gradient.addColorStop(0, colors[0]);
            gradient.addColorStop(1, colors[1]);
        } else {
            gradient.addColorStop(0, '#667eea');
            gradient.addColorStop(1, '#764ba2');
        }
        return gradient;
    }
    
    function draw2DShape() {
        // Reset any composite operations
        ctx.globalCompositeOperation = 'source-over';
        
        // Get shape-specific colors
        const colors = getShapeColors();
        
        // Create gradient fill for more appealing look
        const gradient = createRadialGradient(ctx, 0, 0, 200, colors.gradient);
        gradient.addColorStop(0, colors.gradient[0] + 'CC');
        gradient.addColorStop(1, colors.gradient[1] + '99');
        ctx.fillStyle = gradient;
        ctx.strokeStyle = colors.stroke;
        ctx.lineWidth = 4;
        ctx.shadowColor = colors.stroke + '66';
        ctx.shadowBlur = 10;
        
        switch (currentShape) {
            case 'circle':
                // Fill the circle progressively
                if (drawProgress > 0.2) {
                    ctx.save();
                    ctx.globalAlpha = Math.min(0.6, drawProgress * 0.7);
                    ctx.beginPath();
                    ctx.arc(0, 0, params.radius * drawProgress, 0, 2 * Math.PI);
                    ctx.fill();
                    ctx.restore();
                }
                
                // Draw the arc
                ctx.beginPath();
                ctx.arc(0, 0, params.radius * drawProgress, 0, 2 * Math.PI * drawProgress);
                ctx.stroke();
                
                // Final fill when complete
                if (drawProgress >= 1.0) {
                    ctx.fill();
                }
                
                // Draw center point
                if (drawProgress > 0.1) {
                    ctx.save();
                    ctx.shadowColor = 'transparent';
                    ctx.fillStyle = '#ff6b6b';
                    ctx.beginPath();
                    ctx.arc(0, 0, 4, 0, 2 * Math.PI);
                    ctx.fill();
                    ctx.restore();
                }
                
                // Draw radius dimension line
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    const angle = Math.PI / 4; // 45 degrees
                    const x = params.radius * Math.cos(angle);
                    const y = params.radius * Math.sin(angle);
                    drawDimensionLine(0, 0, x, y, 'r = ' + params.radius);
                }
                break;
                
            case 'square':
                drawProgressiveRect(-params.side / 2, -params.side / 2, params.side, params.side);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Draw dimension line for width
                    drawDimensionLine(-params.side / 2, -params.side / 2 - 30, params.side / 2, -params.side / 2 - 30, 's = ' + params.side);
                }
                break;
                
            case 'rectangle':
                drawProgressiveRect(-params.width / 2, -params.height / 2, params.width, params.height);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Draw dimension line for width
                    drawDimensionLine(-params.width / 2, -params.height / 2 - 30, params.width / 2, -params.height / 2 - 30, 'w = ' + params.width);
                    // Draw dimension line for height
                    drawDimensionLine(-params.width / 2 - 40, -params.height / 2, -params.width / 2 - 40, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'triangle':
                ctx.beginPath();
                const triPoints = [
                    [0, -params.height / 2],
                    [-params.base / 2, params.height / 2],
                    [params.base / 2, params.height / 2]
                ];
                drawProgressivePath(triPoints, true);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Draw base dimension
                    drawDimensionLine(-params.base / 2, params.height / 2 + 20, params.base / 2, params.height / 2 + 20, 'b = ' + params.base);
                    // Draw height dimension
                    drawDimensionLine(params.base / 2 + 30, -params.height / 2, params.base / 2 + 30, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'pentagon':
            case 'hexagon':
            case 'heptagon':
            case 'octagon':
            case 'nonagon':
            case 'decagon':
                const sides = currentShape === 'pentagon' ? 5 : 
                             currentShape === 'hexagon' ? 6 : 
                             currentShape === 'heptagon' ? 7 :
                             currentShape === 'octagon' ? 8 :
                             currentShape === 'nonagon' ? 9 : 10;
                drawPolygon(sides, params.side);
                
                // Draw side dimension for polygons
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    const angle1 = -Math.PI / 2;
                    const angle2 = angle1 + (2 * Math.PI / sides);
                    const x1 = params.side * Math.cos(angle1);
                    const y1 = params.side * Math.sin(angle1);
                    const x2 = params.side * Math.cos(angle2);
                    const y2 = params.side * Math.sin(angle2);
                    drawDimensionLine(x1, y1, x2, y2, 's = ' + params.side);
                }
                break;
                
            case 'ellipse':
                // Fill progressively
                if (drawProgress > 0.2) {
                    ctx.save();
                    ctx.globalAlpha = Math.min(0.6, drawProgress * 0.7);
                    ctx.scale(params.width / 200, params.height / 200);
                    ctx.beginPath();
                    ctx.arc(0, 0, 100 * drawProgress, 0, 2 * Math.PI);
                    ctx.fill();
                    ctx.restore();
                }
                
                // Draw outline
                ctx.save();
                ctx.scale(params.width / 200, params.height / 200);
                ctx.beginPath();
                ctx.arc(0, 0, 100 * drawProgress, 0, 2 * Math.PI * drawProgress);
                ctx.restore();
                ctx.stroke();
                
                if (drawProgress >= 1.0) {
                    ctx.fill();
                }
                
                // Draw dimension lines
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Width dimension (horizontal axis)
                    drawDimensionLine(-params.width / 2, -params.height / 2 - 30, params.width / 2, -params.height / 2 - 30, 'w = ' + params.width);
                    // Height dimension (vertical axis)
                    drawDimensionLine(-params.width / 2 - 40, -params.height / 2, -params.width / 2 - 40, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'rhombus':
                const rhombusPoints = [
                    [0, -params.height / 2],
                    [params.side / 2, 0],
                    [0, params.height / 2],
                    [-params.side / 2, 0]
                ];
                drawProgressivePath(rhombusPoints, true);
                
                // Draw dimension lines
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Side dimension
                    drawDimensionLine(-params.side / 2, 0, 0, -params.height / 2, 's = ' + params.side);
                    // Height dimension
                    drawDimensionLine(params.side / 2 + 30, -params.height / 2, params.side / 2 + 30, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'trapezoid':
                const trapPoints = [
                    [-params.base / 2, params.height / 2],
                    [params.base / 2, params.height / 2],
                    [params.width / 2, -params.height / 2],
                    [-params.width / 2, -params.height / 2]
                ];
                drawProgressivePath(trapPoints, true);
                
                // Draw dimension lines
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Bottom base
                    drawDimensionLine(-params.base / 2, params.height / 2 + 20, params.base / 2, params.height / 2 + 20, 'base = ' + params.base);
                    // Top width
                    drawDimensionLine(-params.width / 2, -params.height / 2 - 20, params.width / 2, -params.height / 2 - 20, 'top = ' + params.width);
                    // Height
                    drawDimensionLine(params.base / 2 + 30, -params.height / 2, params.base / 2 + 30, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'parallelogram':
                const offset = params.base * 0.3;
                const paraPoints = [
                    [-params.base / 2 + offset, -params.height / 2],
                    [params.base / 2 + offset, -params.height / 2],
                    [params.base / 2 - offset, params.height / 2],
                    [-params.base / 2 - offset, params.height / 2]
                ];
                drawProgressivePath(paraPoints, true);
                
                // Draw dimension lines
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Base dimension
                    drawDimensionLine(-params.base / 2 + offset, -params.height / 2 - 20, params.base / 2 + offset, -params.height / 2 - 20, 'b = ' + params.base);
                    // Height dimension
                    drawDimensionLine(params.base / 2 + offset + 30, -params.height / 2, params.base / 2 + offset + 30, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'kite':
                const kitePoints = [
                    [0, -params.height / 2],
                    [params.width / 2, 0],
                    [0, params.height / 2],
                    [-params.width / 2, 0]
                ];
                drawProgressivePath(kitePoints, true);
                
                // Draw dimension lines
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    // Width dimension (horizontal diagonal)
                    drawDimensionLine(-params.width / 2, 0, params.width / 2, 0, 'w = ' + params.width);
                    // Height dimension (vertical diagonal)
                    drawDimensionLine(0, -params.height / 2, 0, params.height / 2, 'h = ' + params.height);
                }
                break;
                
            case 'semicircle':
                // Fill semicircle
                if (drawProgress > 0.2) {
                    ctx.save();
                    ctx.globalAlpha = Math.min(0.6, drawProgress * 0.7);
                    ctx.beginPath();
                    ctx.arc(0, 0, params.radius * drawProgress, 0, Math.PI);
                    ctx.lineTo(-params.radius * drawProgress, 0);
                    ctx.fill();
                    ctx.restore();
                }
                
                // Draw arc
                ctx.beginPath();
                ctx.arc(0, 0, params.radius * drawProgress, 0, Math.PI * drawProgress);
                ctx.stroke();
                
                // Draw base line
                if (drawProgress > 0.5) {
                    ctx.beginPath();
                    ctx.moveTo(-params.radius * drawProgress, 0);
                    ctx.lineTo(params.radius * drawProgress, 0);
                    ctx.stroke();
                }
                
                if (drawProgress >= 1.0) {
                    ctx.fill();
                }
                
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    drawDimensionLine(0, 0, params.radius * Math.cos(Math.PI / 4), -params.radius * Math.sin(Math.PI / 4), 'r = ' + params.radius);
                }
                break;
                
            case 'annulus':
                // Draw outer circle
                ctx.beginPath();
                ctx.arc(0, 0, params.radius * drawProgress, 0, 2 * Math.PI * drawProgress);
                ctx.stroke();
                
                // Draw inner circle
                if (drawProgress > 0.3) {
                    ctx.save();
                    ctx.globalAlpha = 0.8;
                    ctx.beginPath();
                    ctx.arc(0, 0, params.width * drawProgress, 0, 2 * Math.PI * drawProgress);
                    ctx.stroke();
                    ctx.restore();
                }
                
                // Fill the ring
                if (drawProgress > 0.5) {
                    ctx.save();
                    ctx.globalAlpha = Math.min(0.6, drawProgress * 0.7);
                    ctx.beginPath();
                    ctx.arc(0, 0, params.radius, 0, 2 * Math.PI);
                    ctx.arc(0, 0, params.width, 0, 2 * Math.PI, true);
                    ctx.fill();
                    ctx.restore();
                }
                
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    drawDimensionLine(0, 0, params.radius * Math.cos(Math.PI / 4), params.radius * Math.sin(Math.PI / 4), 'R = ' + params.radius);
                    drawDimensionLine(0, 0, params.width * Math.cos(-Math.PI / 4), params.width * Math.sin(-Math.PI / 4), 'r = ' + params.width);
                }
                break;
                
            case 'crescent':
                // Draw larger circle (outer)
                ctx.save();
                ctx.globalAlpha = Math.min(0.6, drawProgress * 0.7);
                ctx.beginPath();
                ctx.arc(-params.width * 0.3, 0, params.radius * drawProgress, 0, 2 * Math.PI);
                ctx.fill();
                ctx.restore();
                
                // Cut out smaller circle (inner) - create crescent
                if (drawProgress > 0.3) {
                    ctx.save();
                    ctx.globalCompositeOperation = 'destination-out';
                    ctx.beginPath();
                    ctx.arc(params.width * 0.3, 0, params.width * drawProgress, 0, 2 * Math.PI);
                    ctx.fill();
                    ctx.globalCompositeOperation = 'source-over'; // Reset
                    ctx.restore();
                }
                
                // Draw outlines
                ctx.save();
                ctx.globalCompositeOperation = 'source-over';
                ctx.beginPath();
                ctx.arc(-params.width * 0.3, 0, params.radius * drawProgress, 0, 2 * Math.PI * drawProgress);
                ctx.stroke();
                
                if (drawProgress > 0.3) {
                    ctx.beginPath();
                    ctx.arc(params.width * 0.3, 0, params.width * drawProgress, 0, 2 * Math.PI * drawProgress);
                    ctx.stroke();
                }
                ctx.restore();
                
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalCompositeOperation = 'source-over';
                    drawLabel('R = ' + params.radius, -params.radius * 0.7, -params.radius * 0.5);
                    drawLabel('r = ' + params.width, params.width * 0.7, params.width * 0.5);
                    ctx.restore();
                }
                break;
        }
        
        // Reset composite operation after drawing
        ctx.globalCompositeOperation = 'source-over';
    }
    
    function drawPolygon(sides, radius) {
        const points = [];
        for (let i = 0; i < sides; i++) {
            const angle = (i * 2 * Math.PI / sides) - Math.PI / 2;
            const x = radius * Math.cos(angle);
            const y = radius * Math.sin(angle);
            points.push([x, y]);
        }
        drawProgressivePath(points, true);
    }
    
    function draw3DShape() {
        const opacity = Math.min(1.0, drawProgress * 1.5); // Fade in faster than draw
        
        // Reset any gradient/composite operations from 2D shapes
        ctx.globalCompositeOperation = 'source-over';
        
        // Get shape-specific colors
        const colors = getShapeColors();
        
        ctx.fillStyle = colors.fill + '99';
        ctx.strokeStyle = colors.stroke;
        ctx.lineWidth = 2;
        
        const rx = view3D ? rotation.x : 0.5;
        const ry = view3D ? rotation.y : 0.5;
        
        ctx.globalAlpha = opacity;
        
        switch (currentShape) {
            case 'cube':
                drawCube(params.side, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('side = ' + params.side, 0, 150);
                    ctx.restore();
                }
                break;
            case 'sphere':
                drawSphere(params.radius, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('r = ' + params.radius, 0, 150);
                    ctx.restore();
                }
                break;
            case 'cylinder':
                drawCylinder(params.radius, params.height, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('r = ' + params.radius + ', h = ' + params.height, 0, 150);
                    ctx.restore();
                }
                break;
            case 'cone':
                drawCone(params.radius, params.height, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('r = ' + params.radius + ', h = ' + params.height, 0, 150);
                    ctx.restore();
                }
                break;
            case 'cuboid':
                drawCuboid(params.width, params.height, params.depth, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('w×h×d = ' + params.width + '×' + params.height + '×' + params.depth, 0, 150);
                    ctx.restore();
                }
                break;
            case 'pyramid':
                drawPyramid(params.base, params.height, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('base = ' + params.base + ', h = ' + params.height, 0, 150);
                    ctx.restore();
                }
                break;
            case 'tetrahedron':
                drawTetrahedron(params.side, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('side = ' + params.side, 0, 150);
                    ctx.restore();
                }
                break;
            case 'prism':
                drawPrism(params.side, params.height, params.sides, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel(params.sides + '-sided, s = ' + params.side + ', h = ' + params.height, 0, 150);
                    ctx.restore();
                }
                break;
            case 'torus':
                drawTorus(params.radius, params.width, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('R = ' + params.radius + ', r = ' + params.width, 0, 150);
                    ctx.restore();
                }
                break;
            case 'hemisphere':
                drawHemisphere(params.radius, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('r = ' + params.radius, 0, 150);
                    ctx.restore();
                }
                break;
            case 'ellipsoid':
                drawEllipsoid(params.width, params.height, params.depth, rx, ry);
                if (document.getElementById('showLabels').checked && drawProgress >= 0.8) {
                    ctx.save();
                    ctx.globalAlpha = 1.0;
                    drawLabel('w×h×d = ' + params.width + '×' + params.height + '×' + params.depth, 0, 150);
                    ctx.restore();
                }
                break;
        }
        
        ctx.globalAlpha = 1.0; // Restore opacity
    }
    
    function rotatePoint(x, y, z, rx, ry) {
        // Rotate around X axis
        let y1 = y * Math.cos(rx) - z * Math.sin(rx);
        let z1 = y * Math.sin(rx) + z * Math.cos(rx);
        
        // Rotate around Y axis
        let x2 = x * Math.cos(ry) + z1 * Math.sin(ry);
        let z2 = -x * Math.sin(ry) + z1 * Math.cos(ry);
        
        return { x: x2, y: y1, z: z2 };
    }
    
    function project(x, y, z) {
        const perspective = 600;
        const scale = perspective / (perspective + z);
        return { x: x * scale, y: y * scale };
    }
    
    function drawCube(size, rx, ry) {
        const s = (size / 2) * drawProgress; // Scale with progress
        const vertices = [
            [-s, -s, -s], [s, -s, -s], [s, s, -s], [-s, s, -s],
            [-s, -s, s], [s, -s, s], [s, s, s], [-s, s, s]
        ];
        
        const projected = vertices.map(v => {
            const rotated = rotatePoint(v[0], v[1], v[2], rx, ry);
            return project(rotated.x, rotated.y, rotated.z);
        });
        
        const faces = [
            [0, 1, 2, 3], [4, 5, 6, 7], [0, 1, 5, 4],
            [2, 3, 7, 6], [0, 3, 7, 4], [1, 2, 6, 5]
        ];
        
        // Draw faces progressively
        const facesToDraw = Math.ceil(faces.length * drawProgress);
        faces.slice(0, facesToDraw).forEach((face, faceIdx) => {
            const faceProgress = faceIdx < facesToDraw - 1 ? 1.0 : (faces.length * drawProgress) % 1;
            
            ctx.beginPath();
            face.forEach((idx, i) => {
                const p = projected[idx];
                if (i === 0) ctx.moveTo(p.x, p.y);
                else if (i <= face.length * faceProgress) ctx.lineTo(p.x, p.y);
            });
            if (faceProgress >= 1.0) {
                ctx.closePath();
                ctx.fill();
            }
            ctx.stroke();
        });
    }
    
    function drawSphere(radius, rx, ry) {
        const r = radius * drawProgress; // Scale radius with progress
        const maxLat = 90 * drawProgress; // Progressive latitude
        
        // Latitude lines
        for (let lat = -maxLat; lat <= maxLat; lat += 30) {
            if (lat / maxLat > drawProgress) continue;
            ctx.beginPath();
            for (let lon = 0; lon <= 360 * drawProgress; lon += 10) {
                const phi = lat * Math.PI / 180;
                const theta = lon * Math.PI / 180;
                const x = r * Math.cos(phi) * Math.cos(theta);
                const y = r * Math.cos(phi) * Math.sin(theta);
                const z = r * Math.sin(phi);
                const rotated = rotatePoint(x, y, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (lon === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
        
        // Longitude lines
        const maxLon = 360 * drawProgress;
        for (let lon = 0; lon < maxLon; lon += 30) {
            ctx.beginPath();
            for (let lat = -maxLat; lat <= maxLat; lat += 10) {
                const phi = lat * Math.PI / 180;
                const theta = lon * Math.PI / 180;
                const x = r * Math.cos(phi) * Math.cos(theta);
                const y = r * Math.cos(phi) * Math.sin(theta);
                const z = r * Math.sin(phi);
                const rotated = rotatePoint(x, y, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (lat === -maxLat) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
    }
    
    function drawCylinder(radius, height, rx, ry) {
        const segments = 32;
        const r = radius * drawProgress;
        const h = (height / 2) * drawProgress;
        
        // Top circle - draw progressively
        if (drawProgress > 0.2) {
            ctx.beginPath();
            for (let i = 0; i <= segments * drawProgress; i++) {
                const theta = i * 2 * Math.PI / segments;
                const x = r * Math.cos(theta);
                const z = r * Math.sin(theta);
                const rotated = rotatePoint(x, -h, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (i === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
        
        // Bottom circle - draw progressively
        if (drawProgress > 0.4) {
            ctx.beginPath();
            for (let i = 0; i <= segments * (drawProgress - 0.4) / 0.6; i++) {
                const theta = i * 2 * Math.PI / segments;
                const x = r * Math.cos(theta);
                const z = r * Math.sin(theta);
                const rotated = rotatePoint(x, h, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (i === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
        
        // Sides - draw progressively
        if (drawProgress > 0.6) {
            const sidesToDraw = Math.ceil(4 * (drawProgress - 0.6) / 0.4);
            for (let i = 0; i < sidesToDraw; i++) {
                const theta = i * Math.PI / 2;
                const x = r * Math.cos(theta);
                const z = r * Math.sin(theta);
                const top = rotatePoint(x, -h, z, rx, ry);
                const bottom = rotatePoint(x, h, z, rx, ry);
                const pTop = project(top.x, top.y, top.z);
                const pBottom = project(bottom.x, bottom.y, bottom.z);
                ctx.beginPath();
                ctx.moveTo(pTop.x, pTop.y);
                ctx.lineTo(pBottom.x, pBottom.y);
                ctx.stroke();
            }
        }
    }
    
    function drawCone(radius, height, rx, ry) {
        const segments = 32;
        const r = radius * drawProgress;
        const h = height * drawProgress;
        const apex = rotatePoint(0, -h / 2, 0, rx, ry);
        const pApex = project(apex.x, apex.y, apex.z);
        
        // Base circle - draw progressively
        if (drawProgress > 0.3) {
            ctx.beginPath();
            const circleProgress = (drawProgress - 0.3) / 0.7;
            for (let i = 0; i <= segments * circleProgress; i++) {
                const theta = i * 2 * Math.PI / segments;
                const x = r * Math.cos(theta);
                const z = r * Math.sin(theta);
                const rotated = rotatePoint(x, h / 2, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (i === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
        
        // Draw apex point first
        if (drawProgress > 0.1) {
            ctx.save();
            ctx.fillStyle = '#667eea';
            ctx.beginPath();
            ctx.arc(pApex.x, pApex.y, 4, 0, 2 * Math.PI);
            ctx.fill();
            ctx.restore();
        }
        
        // Sides - draw progressively
        if (drawProgress > 0.5) {
            const sidesToDraw = Math.ceil(4 * (drawProgress - 0.5) / 0.5);
            for (let i = 0; i < sidesToDraw; i++) {
                const theta = i * Math.PI / 2;
                const x = r * Math.cos(theta);
                const z = r * Math.sin(theta);
                const base = rotatePoint(x, h / 2, z, rx, ry);
                const pBase = project(base.x, base.y, base.z);
                ctx.beginPath();
                ctx.moveTo(pApex.x, pApex.y);
                ctx.lineTo(pBase.x, pBase.y);
                ctx.stroke();
            }
        }
    }
    
    function drawCuboid(w, h, d, rx, ry) {
        const ww = (w / 2) * drawProgress;
        const hh = (h / 2) * drawProgress;
        const dd = (d / 2) * drawProgress;
        
        const vertices = [
            [-ww, -hh, -dd], [ww, -hh, -dd], [ww, hh, -dd], [-ww, hh, -dd],
            [-ww, -hh, dd], [ww, -hh, dd], [ww, hh, dd], [-ww, hh, dd]
        ];
        
        const projected = vertices.map(v => {
            const rotated = rotatePoint(v[0], v[1], v[2], rx, ry);
            return project(rotated.x, rotated.y, rotated.z);
        });
        
        const edges = [
            [0,1],[1,2],[2,3],[3,0],[4,5],[5,6],[6,7],[7,4],[0,4],[1,5],[2,6],[3,7]
        ];
        
        // Draw edges progressively
        const edgesToDraw = Math.ceil(edges.length * drawProgress);
        edges.slice(0, edgesToDraw).forEach(edge => {
            ctx.beginPath();
            ctx.moveTo(projected[edge[0]].x, projected[edge[0]].y);
            ctx.lineTo(projected[edge[1]].x, projected[edge[1]].y);
            ctx.stroke();
        });
    }
    
    function drawPyramid(base, height, rx, ry) {
        const b = (base / 2) * drawProgress;
        const h = height * drawProgress;
        const vertices = [
            [0, -h / 2, 0],
            [-b, h / 2, -b], [b, h / 2, -b],
            [b, h / 2, b], [-b, h / 2, b]
        ];
        
        const projected = vertices.map(v => {
            const rotated = rotatePoint(v[0], v[1], v[2], rx, ry);
            return project(rotated.x, rotated.y, rotated.z);
        });
        
        // Draw apex first
        if (drawProgress > 0.1) {
            ctx.save();
            ctx.fillStyle = '#667eea';
            ctx.beginPath();
            ctx.arc(projected[0].x, projected[0].y, 4, 0, 2 * Math.PI);
            ctx.fill();
            ctx.restore();
        }
        
        // Base - draw progressively
        if (drawProgress > 0.3) {
            const baseProgress = (drawProgress - 0.3) / 0.4;
            const verticesToDraw = Math.ceil(4 * baseProgress);
            ctx.beginPath();
            for (let i = 1; i <= Math.min(4, verticesToDraw + 1); i++) {
                const p = projected[i];
                if (i === 1) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            if (baseProgress >= 1.0) ctx.closePath();
            ctx.stroke();
        }
        
        // Sides - draw progressively
        if (drawProgress > 0.6) {
            const sidesToDraw = Math.ceil(4 * (drawProgress - 0.6) / 0.4);
            for (let i = 1; i <= Math.min(4, sidesToDraw); i++) {
                ctx.beginPath();
                ctx.moveTo(projected[0].x, projected[0].y);
                ctx.lineTo(projected[i].x, projected[i].y);
                ctx.stroke();
            }
        }
    }
    
    function drawTetrahedron(side, rx, ry) {
        const s = side * drawProgress;
        const h = s * Math.sqrt(2/3);
        const r = s / Math.sqrt(3);
        const vertices = [
            [0, -h/2, 0],
            [-r, h/2, 0],
            [r/2, h/2, -r*Math.sqrt(3)/2],
            [r/2, h/2, r*Math.sqrt(3)/2]
        ];
        
        const projected = vertices.map(v => {
            const rotated = rotatePoint(v[0], v[1], v[2], rx, ry);
            return project(rotated.x, rotated.y, rotated.z);
        });
        
        const edges = [[0,1],[0,2],[0,3],[1,2],[2,3],[3,1]];
        
        // Draw edges progressively
        const edgesToDraw = Math.ceil(edges.length * drawProgress);
        edges.slice(0, edgesToDraw).forEach(edge => {
            ctx.beginPath();
            ctx.moveTo(projected[edge[0]].x, projected[edge[0]].y);
            ctx.lineTo(projected[edge[1]].x, projected[edge[1]].y);
            ctx.stroke();
        });
    }
    
    function drawPrism(side, height, sides, rx, ry) {
        const s = side * drawProgress;
        const h = (height / 2) * drawProgress;
        const vertices = [];
        
        for (let i = 0; i < sides; i++) {
            const angle = i * 2 * Math.PI / sides;
            const x = s * Math.cos(angle);
            const z = s * Math.sin(angle);
            vertices.push([x, -h, z]);
            vertices.push([x, h, z]);
        }
        
        const projected = vertices.map(v => {
            const rotated = rotatePoint(v[0], v[1], v[2], rx, ry);
            return project(rotated.x, rotated.y, rotated.z);
        });
        
        // Top polygon - draw progressively
        if (drawProgress > 0.2) {
            const topProgress = (drawProgress - 0.2) / 0.4;
            const verticesToDraw = Math.ceil(sides * topProgress);
            ctx.beginPath();
            for (let i = 0; i < Math.min(sides, verticesToDraw + 1); i++) {
                const p = projected[i * 2];
                if (i === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            if (topProgress >= 1.0) ctx.closePath();
            ctx.stroke();
        }
        
        // Bottom polygon
        if (drawProgress > 0.5) {
            const bottomProgress = (drawProgress - 0.5) / 0.3;
            const verticesToDraw = Math.ceil(sides * bottomProgress);
            ctx.beginPath();
            for (let i = 0; i < Math.min(sides, verticesToDraw + 1); i++) {
                const p = projected[i * 2 + 1];
                if (i === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            if (bottomProgress >= 1.0) ctx.closePath();
            ctx.stroke();
        }
        
        // Vertical edges
        if (drawProgress > 0.7) {
            const edgesToDraw = Math.ceil(sides * (drawProgress - 0.7) / 0.3);
            for (let i = 0; i < Math.min(sides, edgesToDraw); i++) {
                ctx.beginPath();
                ctx.moveTo(projected[i * 2].x, projected[i * 2].y);
                ctx.lineTo(projected[i * 2 + 1].x, projected[i * 2 + 1].y);
                ctx.stroke();
            }
        }
    }
    
    function drawTorus(majorRadius, minorRadius, rx, ry) {
        const majorSegments = 32;
        const minorSegments = 16;
        const R = majorRadius * drawProgress;
        const r = minorRadius * drawProgress;
        
        const segmentsToDraw = Math.ceil(majorSegments * drawProgress);
        for (let i = 0; i < segmentsToDraw; i++) {
            ctx.beginPath();
            const theta1 = i * 2 * Math.PI / majorSegments;
            const minorProgress = i < segmentsToDraw - 1 ? 1.0 : (majorSegments * drawProgress) % 1;
            const minorToDraw = Math.ceil(minorSegments * minorProgress);
            
            for (let j = 0; j <= minorToDraw; j++) {
                const phi = j * 2 * Math.PI / minorSegments;
                const x = (R + r * Math.cos(phi)) * Math.cos(theta1);
                const y = r * Math.sin(phi);
                const z = (R + r * Math.cos(phi)) * Math.sin(theta1);
                const rotated = rotatePoint(x, y, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (j === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
    }
    
    function drawHemisphere(radius, rx, ry) {
        const r = radius * drawProgress;
        const maxLat = 90 * drawProgress;
        
        // Latitude lines
        for (let lat = 0; lat <= maxLat; lat += 30) {
            ctx.beginPath();
            for (let lon = 0; lon <= 360 * drawProgress; lon += 10) {
                const phi = lat * Math.PI / 180;
                const theta = lon * Math.PI / 180;
                const x = r * Math.cos(phi) * Math.cos(theta);
                const y = r * Math.sin(phi);
                const z = r * Math.cos(phi) * Math.sin(theta);
                const rotated = rotatePoint(x, y, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (lon === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
        
        // Base circle
        if (drawProgress > 0.5) {
            ctx.beginPath();
            for (let lon = 0; lon <= 360 * (drawProgress - 0.5) / 0.5; lon += 10) {
                const theta = lon * Math.PI / 180;
                const x = r * Math.cos(theta);
                const z = r * Math.sin(theta);
                const rotated = rotatePoint(x, 0, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (lon === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
    }
    
    function drawEllipsoid(w, h, d, rx, ry) {
        const a = (w / 2) * drawProgress;
        const b = (h / 2) * drawProgress;
        const c = (d / 2) * drawProgress;
        const maxLat = 90 * drawProgress;
        
        for (let lat = -maxLat; lat <= maxLat; lat += 30) {
            ctx.beginPath();
            for (let lon = 0; lon <= 360 * drawProgress; lon += 10) {
                const phi = lat * Math.PI / 180;
                const theta = lon * Math.PI / 180;
                const x = a * Math.cos(phi) * Math.cos(theta);
                const y = b * Math.sin(phi);
                const z = c * Math.cos(phi) * Math.sin(theta);
                const rotated = rotatePoint(x, y, z, rx, ry);
                const p = project(rotated.x, rotated.y, rotated.z);
                if (lon === 0) ctx.moveTo(p.x, p.y);
                else ctx.lineTo(p.x, p.y);
            }
            ctx.stroke();
        }
    }
    
    function drawLabel(text, x, y) {
        ctx.save();
        ctx.shadowColor = 'transparent';
        
        // Background for label
        ctx.font = 'bold 14px Arial';
        const metrics = ctx.measureText(text);
        const padding = 6;
        const bgWidth = metrics.width + padding * 2;
        const bgHeight = 22;
        
        ctx.fillStyle = 'rgba(255, 255, 255, 0.95)';
        ctx.strokeStyle = '#667eea';
        ctx.lineWidth = 2;
        
        ctx.beginPath();
        ctx.roundRect(x - bgWidth/2, y - bgHeight/2 - 3, bgWidth, bgHeight, 4);
        ctx.fill();
        ctx.stroke();
        
        // Text
        ctx.fillStyle = '#667eea';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.fillText(text, x, y);
        ctx.restore();
    }
    
    function drawDimensionLine(x1, y1, x2, y2, label, value) {
        ctx.save();
        ctx.shadowColor = 'transparent';
        ctx.strokeStyle = '#ff6b6b';
        ctx.lineWidth = 2;
        ctx.setLineDash([5, 5]);
        
        // Draw line
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x2, y2);
        ctx.stroke();
        
        // Draw arrows
        ctx.setLineDash([]);
        const angle = Math.atan2(y2 - y1, x2 - x1);
        const arrowSize = 8;
        
        // Arrow at start
        ctx.beginPath();
        ctx.moveTo(x1, y1);
        ctx.lineTo(x1 + arrowSize * Math.cos(angle - Math.PI / 6), y1 + arrowSize * Math.sin(angle - Math.PI / 6));
        ctx.moveTo(x1, y1);
        ctx.lineTo(x1 + arrowSize * Math.cos(angle + Math.PI / 6), y1 + arrowSize * Math.sin(angle + Math.PI / 6));
        ctx.stroke();
        
        // Arrow at end
        ctx.beginPath();
        ctx.moveTo(x2, y2);
        ctx.lineTo(x2 - arrowSize * Math.cos(angle - Math.PI / 6), y2 - arrowSize * Math.sin(angle - Math.PI / 6));
        ctx.moveTo(x2, y2);
        ctx.lineTo(x2 - arrowSize * Math.cos(angle + Math.PI / 6), y2 - arrowSize * Math.sin(angle + Math.PI / 6));
        ctx.stroke();
        
        // Draw label without value
        const midX = (x1 + x2) / 2;
        const midY = (y1 + y2) / 2;
        drawLabel(label, midX, midY);
        
        ctx.restore();
    }
    
    // ============== UPDATE FUNCTIONS ==============
    function updateCalculations() {
        const formula = formulas[currentCategory][currentShape];
        if (!formula) return;
        
        const calculated = formula.calculate();
        
        // Update metrics
        const metricsHtml = Object.entries(calculated).map(([key, value]) => 
            '<div class="col-md-6 mb-3">' +
                '<div class="metric-card">' +
                    '<div class="metric-label">' + key + '</div>' +
                    '<div class="metric-value">' + value.toFixed(2) + '</div>' +
                '</div>' +
            '</div>'
        ).join('');
        document.getElementById('metricsContainer').innerHTML = metricsHtml;
        
        // Update formulas
        const formulasHtml = Object.entries(formula).filter(([k]) => k !== 'calculate').map(([key, value]) => 
            '<div class="formula-card">' +
                '<div class="formula-title">' + key + '</div>' +
                '<div class="formula-content">' + value + '</div>' +
            '</div>'
        ).join('');
        document.getElementById('formulasContainer').innerHTML = formulasHtml;
        
        // Update properties
        const propsHtml = Object.entries(calculated).map(([key, value]) => 
            '<div class="property-item">' +
                '<span class="property-label">' + key + ':</span>' +
                '<span class="property-value">' + value.toFixed(2) + '</span>' +
            '</div>'
        ).join('');
        document.getElementById('propertiesList').innerHTML = propsHtml;
        
        // Update formula chart
        updateFormulaChart(calculated);
        
        // Update shape legend
        updateShapeLegend();
    }
    
    function updateShapeLegend() {
        const legendContainer = document.getElementById('shapeLegend');
        if (!legendContainer) return;
        
        const shapeName = shapes[currentCategory][currentShape].name;
        let legendHTML = '<div class="legend-title">' + shapeName + ' Components</div>';
        
        if (currentCategory === '2d') {
            if (currentShape === 'circle') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #28a745;"></div>' +
                        '<div class="legend-text">Center (O)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #dc3545;"></div>' +
                        '<div class="legend-text">Radius (R)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Diameter (D)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #000000;"></div>' +
                        '<div class="legend-text">Circumference (C)</div>' +
                    '</div>';
            } else if (currentShape === 'semicircle') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #28a745;"></div>' +
                        '<div class="legend-text">Center (O)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #dc3545;"></div>' +
                        '<div class="legend-text">Radius (R)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Base</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #000000;"></div>' +
                        '<div class="legend-text">Arc</div>' +
                    '</div>';
            } else if (currentShape === 'annulus') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #28a745;"></div>' +
                        '<div class="legend-text">Center (O)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Outer Radius (R₁)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #dc3545;"></div>' +
                        '<div class="legend-text">Inner Radius (R₂)</div>' +
                    '</div>';
            } else if (currentShape === 'square') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Side Length (s)</div>' +
                    '</div>';
            } else if (currentShape === 'rectangle') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Width (w)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #dc3545;"></div>' +
                        '<div class="legend-text">Height (h)</div>' +
                    '</div>';
            } else if (currentShape === 'triangle') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Base (b)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #dc3545;"></div>' +
                        '<div class="legend-text">Height (h)</div>' +
                    '</div>';
            } else if (currentShape === 'ellipse') {
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #28a745;"></div>' +
                        '<div class="legend-text">Center (O)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Semi-major Axis (a)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #dc3545;"></div>' +
                        '<div class="legend-text">Semi-minor Axis (b)</div>' +
                    '</div>';
            } else {
                // Default for other shapes
                legendHTML += 
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #28a745;"></div>' +
                        '<div class="legend-text">Area (filled region)</div>' +
                    '</div>' +
                    '<div class="legend-item">' +
                        '<div class="legend-color" style="background: #0d6efd;"></div>' +
                        '<div class="legend-text">Perimeter (outline)</div>' +
                    '</div>';
            }
        } else {
            // For 3D shapes
            legendHTML += 
                '<div class="legend-item">' +
                    '<div class="legend-color" style="background: #28a745;"></div>' +
                    '<div class="legend-text">Volume (solid body)</div>' +
                '</div>' +
                '<div class="legend-item">' +
                    '<div class="legend-color" style="background: #0d6efd;"></div>' +
                    '<div class="legend-text">Surface Area (surfaces)</div>' +
                '</div>';
        }
        
        legendContainer.innerHTML = legendHTML;
    }
    
    function initFormulaChart() {
        const ctx = document.getElementById('formulaChart').getContext('2d');
        formulaChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: [],
                datasets: [{
                    label: 'Calculated Values',
                    data: [],
                    backgroundColor: [
                        'rgba(102, 126, 234, 0.8)',
                        'rgba(118, 75, 162, 0.8)',
                        'rgba(255, 99, 132, 0.8)',
                        'rgba(54, 162, 235, 0.8)',
                        'rgba(255, 206, 86, 0.8)',
                        'rgba(75, 192, 192, 0.8)'
                    ],
                    borderColor: [
                        'rgba(102, 126, 234, 1)',
                        'rgba(118, 75, 162, 1)',
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)'
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    title: {
                        display: true,
                        text: 'Shape Properties',
                        font: { size: 16, weight: 'bold' }
                    },
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.label + ': ' + context.parsed.y.toFixed(2);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Value'
                        }
                    }
                },
                animation: {
                    duration: 750,
                    easing: 'easeInOutQuart'
                }
            }
        });
    }
    
    function updateFormulaChart(calculated) {
        if (!formulaChart) return;
        
        const labels = Object.keys(calculated);
        const values = Object.values(calculated);
        
        formulaChart.data.labels = labels;
        formulaChart.data.datasets[0].data = values;
        formulaChart.data.datasets[0].label = shapes[currentCategory][currentShape].name + ' Properties';
        formulaChart.options.plugins.title.text = shapes[currentCategory][currentShape].name + ' - Calculated Values';
        formulaChart.update();
    }
    
    function animateDrawing() {
        if (!isDrawingAnimated) {
            drawProgress = 1.0;
            drawShape();
            return;
        }
        
        drawProgress += 0.02; // Increment progress
        
        if (drawProgress >= 1.0) {
            drawProgress = 1.0;
            isDrawingAnimated = false;
            if (drawAnimationFrame) {
                cancelAnimationFrame(drawAnimationFrame);
                drawAnimationFrame = null;
            }
        }
        
        drawShape();
        
        if (isDrawingAnimated) {
            drawAnimationFrame = requestAnimationFrame(animateDrawing);
        }
    }
    
    function startDrawAnimation() {
        drawProgress = 0;
        isDrawingAnimated = true;
        if (drawAnimationFrame) {
            cancelAnimationFrame(drawAnimationFrame);
        }
        animateDrawing();
    }
    
    function autoPlayShapes() {
        const categoryShapes = Object.keys(shapes[currentCategory]);
        let currentIndex = categoryShapes.indexOf(currentShape);
        
        currentIndex = (currentIndex + 1) % categoryShapes.length;
        
        // If we've looped back to the first shape, optionally switch category
        if (currentIndex === 0 && Math.random() > 0.7) {
            currentCategory = currentCategory === '2d' ? '3d' : '2d';
            selectCategory(currentCategory);
            return;
        }
        
        const nextShape = categoryShapes[currentIndex];
        selectShape(nextShape);
        
        // Start drawing animation
        startDrawAnimation();
        
        // Auto-rotate 3D shapes if enabled
        if (currentCategory === '3d' && document.getElementById('autoRotate').checked) {
            if (!isAnimating) {
                document.getElementById('btnAnimate').click();
            }
        }
    }
    
    function startAutoPlay() {
        if (isAutoPlaying) return;
        isAutoPlaying = true;
        
        // Animate the current shape first
        startDrawAnimation();
        
        autoPlayInterval = setInterval(autoPlayShapes, autoPlaySpeed);
        const btn = document.getElementById('btnAutoPlay');
        btn.textContent = '⏸ Pause';
        btn.style.background = 'linear-gradient(135deg, #ffc107, #ff9800)';
        btn.classList.add('playing');
    }
    
    function stopAutoPlay() {
        if (!isAutoPlaying) return;
        isAutoPlaying = false;
        if (autoPlayInterval) {
            clearInterval(autoPlayInterval);
            autoPlayInterval = null;
        }
        const btn = document.getElementById('btnAutoPlay');
        btn.textContent = '▶ Play All';
        btn.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
        btn.classList.remove('playing');
    }
    
    function updateShapeGallery() {
        const gallery = document.getElementById('shapeGallery');
        const categoryShapes = shapes[currentCategory];
        
        gallery.innerHTML = Object.entries(categoryShapes).map(([key, shape]) => {
            const colors = shapeColors[currentCategory][key] || { fill: '#667eea', stroke: '#5a6fd8' };
            return '<div class="shape-card ' + (key === currentShape ? 'active' : '') + '" data-shape="' + key + '" ' +
                'style="border-left: 4px solid ' + colors.fill + '; background: linear-gradient(135deg, ' + colors.fill + '15, ' + colors.stroke + '10);">' +
                '<div class="shape-icon" style="color: ' + colors.fill + ';">' + shape.icon + '</div>' +
                '<div class="shape-name">' + shape.name + '</div>' +
            '</div>';
        }).join('');
        
        // Add click handlers
        gallery.querySelectorAll('.shape-card').forEach(card => {
            card.addEventListener('click', () => selectShape(card.dataset.shape));
        });
    }
    
    function updateParameters() {
        const shape = shapes[currentCategory][currentShape];
        if (!shape) return;
        
        const paramsHtml = shape.params.map(param => {
            const max = param === 'sides' ? 12 : 200;
            const min = param === 'sides' ? 3 : 20;
            return '<div class="param-slider">' +
                    '<div class="slider-label">' +
                        '<span>' + param.charAt(0).toUpperCase() + param.slice(1) + '</span>' +
                        '<strong id="' + param + 'Value">' + params[param] + '</strong>' +
                    '</div>' +
                    '<input type="range" class="custom-slider" id="' + param + 'Slider" ' +
                           'min="' + min + '" max="' + max + '" step="1" value="' + params[param] + '">' +
                '</div>';
        }).join('');
        
        document.getElementById('parametersContainer').innerHTML = paramsHtml;
        
        // Add event listeners
        shape.params.forEach(param => {
            const slider = document.getElementById(param + 'Slider');
            if (slider) {
                slider.addEventListener('input', (e) => {
                    params[param] = parseInt(e.target.value);
                    document.getElementById(param + 'Value').textContent = params[param];
                    drawShape();
                });
            }
        });
    }
    
    function selectShape(shape) {
        currentShape = shape;
        document.getElementById('currentShapeName').textContent = shapes[currentCategory][shape].name;
        updateShapeGallery();
        updateParameters();
        drawShape();
    }
    
    function selectCategory(category) {
        currentCategory = category;
        currentShape = Object.keys(shapes[category])[0];
        document.getElementById('currentDimension').textContent = category.toUpperCase();
        document.getElementById('shapeGalleryTitle').textContent = 
            category === '2d' ? '📦 2D Shapes Gallery' : '🧊 3D Shapes Gallery';
        
        // Update category buttons
        document.querySelectorAll('.category-btn').forEach(btn => {
            btn.classList.toggle('active', btn.dataset.category === category);
        });
        
        updateShapeGallery();
        updateParameters();
        selectShape(currentShape);
    }
    
    // ============== ANIMATION ==============
    function animate() {
        if (!isAnimating) return;
        
        rotation.y += 0.02;
        rotation.x += 0.01;
        
        drawShape();
        animationId = requestAnimationFrame(animate);
    }
    
    // ============== EVENT LISTENERS ==============
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.addEventListener('click', () => selectCategory(btn.dataset.category));
    });
    
    document.getElementById('btnAnimate').addEventListener('click', function() {
        isAnimating = !isAnimating;
        this.textContent = isAnimating ? '⏸ Pause' : '▶ Rotate';
        if (isAnimating) animate();
    });
    
    document.getElementById('btnReset').addEventListener('click', () => {
        rotation = { x: 0.5, y: 0.5, z: 0 };
        drawShape();
    });
    
    document.getElementById('showGrid').addEventListener('change', drawShape);
    document.getElementById('showLabels').addEventListener('change', drawShape);
    document.getElementById('showFormulas').addEventListener('change', drawShape);
    
    document.getElementById('btn2DView').addEventListener('click', function() {
        view3D = false;
        this.classList.add('active');
        document.getElementById('btn3DView').classList.remove('active');
        drawShape();
    });
    
    document.getElementById('btn3DView').addEventListener('click', function() {
        view3D = true;
        this.classList.add('active');
        document.getElementById('btn2DView').classList.remove('active');
        drawShape();
    });
    
    // Auto-play controls
    document.getElementById('btnAutoPlay').addEventListener('click', function() {
        if (isAutoPlaying) {
            stopAutoPlay();
        } else {
            startAutoPlay();
        }
    });
    
    document.getElementById('autoSpeedSlider').addEventListener('input', (e) => {
        const speed = parseInt(e.target.value);
        autoPlaySpeed = speed * 1000; // Convert to milliseconds
        document.getElementById('autoSpeedValue').textContent = speed + 's';
        
        // Restart auto-play with new speed if currently playing
        if (isAutoPlaying) {
            stopAutoPlay();
            startAutoPlay();
        }
    });
    
    // ============== INITIALIZATION ==============
    initFormulaChart();
    selectCategory('2d');
    console.log('🔷 Geometric Shapes Explorer loaded successfully!');
});
//]]>
</script>

<hr>
<!-- Learning Guide -->
<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0">📚 Geometry Quick Reference</h5>
    </div>
    <div class="card-body">
        <div class="row">
            <div class="col-md-6">
                <h6>2D Shapes (Plane Figures)</h6>
                <ul>
                    <li><strong>Polygons:</strong> Closed figures with straight sides</li>
                    <li><strong>Regular Polygons:</strong> All sides and angles equal</li>
                    <li><strong>Area:</strong> Space inside the shape (square units)</li>
                    <li><strong>Perimeter:</strong> Total distance around the shape</li>
                </ul>
                <h6 class="mt-3">Common 2D Shapes</h6>
                <ul>
                    <li><strong>Triangle:</strong> 3 sides, sum of angles = 180°</li>
                    <li><strong>Quadrilaterals:</strong> 4 sides (square, rectangle, etc.)</li>
                    <li><strong>Pentagon:</strong> 5 sides</li>
                    <li><strong>Hexagon:</strong> 6 sides</li>
                    <li><strong>Circle:</strong> Curved shape, constant radius</li>
                </ul>
            </div>
            <div class="col-md-6">
                <h6>3D Shapes (Solid Figures)</h6>
                <ul>
                    <li><strong>Polyhedrons:</strong> All faces are flat polygons</li>
                    <li><strong>Curved Surfaces:</strong> Sphere, cylinder, cone, etc.</li>
                    <li><strong>Volume:</strong> Space inside the shape (cubic units)</li>
                    <li><strong>Surface Area:</strong> Total area of all faces</li>
                </ul>
                <h6 class="mt-3">Common 3D Shapes</h6>
                <ul>
                    <li><strong>Cube:</strong> 6 square faces, all edges equal</li>
                    <li><strong>Sphere:</strong> All points equidistant from center</li>
                    <li><strong>Cylinder:</strong> Two circular bases, curved surface</li>
                    <li><strong>Cone:</strong> Circular base, apex point</li>
                    <li><strong>Pyramid:</strong> Polygon base, triangular faces</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0">🎯 Understanding the Formulas</h5>
    </div>
    <div class="card-body">
        <h6>Key Symbols & Notation</h6>
        <div class="row">
            <div class="col-md-4">
                <ul>
                    <li><strong>π (pi):</strong> ≈ 3.14159...</li>
                    <li><strong>r:</strong> radius</li>
                    <li><strong>d:</strong> diameter (d = 2r)</li>
                    <li><strong>s:</strong> side length</li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul>
                    <li><strong>w:</strong> width</li>
                    <li><strong>h:</strong> height</li>
                    <li><strong>b:</strong> base</li>
                    <li><strong>l:</strong> length</li>
                </ul>
            </div>
            <div class="col-md-4">
                <ul>
                    <li><strong>√:</strong> square root</li>
                    <li><strong>²:</strong> squared (x²)</li>
                    <li><strong>³:</strong> cubed (x³)</li>
                </ul>
            </div>
        </div>
        
        <h6 class="mt-3">Tips for Learning Geometry</h6>
        <ul>
            <li>Start with simple shapes and build complexity</li>
            <li>Understand the relationship between 2D and 3D shapes</li>
            <li>Practice calculating with different dimensions</li>
            <li>Visualize cross-sections of 3D shapes to see 2D components</li>
            <li>Remember: Volume uses cubic units, area uses square units</li>
        </ul>
    </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>

