<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Distance Formula Calculator Online – Free | 8gwifi.org</title>
    <meta name="description" content="Calculate distance between two points in 2D and 3D space. Free distance formula calculator with step-by-step solutions, midpoint finder, and visual coordinate plane display.">
    <meta name="keywords" content="distance formula calculator, distance between two points, 3d distance calculator, midpoint calculator, coordinate geometry, euclidean distance">

    <link rel="canonical" href="https://8gwifi.org/distance-formula-calculator.jsp">
    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/distance-formula-calculator.jsp">
    <meta property="og:title" content="Distance Formula Calculator Online – Free | 8gwifi.org">
    <meta property="og:description" content="Compute distance between two points in 2D or 3D. Includes step-by-step work, midpoint, and visualization.">
    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Distance Formula Calculator Online – Free | 8gwifi.org">
    <meta name="twitter:description" content="Calculate 2D/3D distance with steps, plus midpoint finder and charts.">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Distance Formula Calculator",
      "description": "Calculate distance between two points in 2D and 3D space with step-by-step solutions.",
      "url": "https://8gwifi.org/distance-formula-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        .coordinate-plane {
            background: #f8f9fa;
            border: 2px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }

        .point-input {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .point-input input {
            background: rgba(255,255,255,0.9);
            border: none;
            font-weight: bold;
        }

        .result-card {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
            margin: 20px 0;
        }

        .result-value {
            font-size: 2.5rem;
            font-weight: bold;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .coordinate-label {
            font-weight: bold;
            color: white;
            margin-right: 10px;
        }

        .formula-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
        }

        .step-box {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
        }

        .step-number {
            display: inline-block;
            background: #667eea;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            text-align: center;
            line-height: 30px;
            font-weight: bold;
            margin-right: 10px;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-ruler"></i> Distance Formula Calculator</h1>
    <p class="text-center text-muted mb-4">Calculate distance between two points in 2D and 3D space</p>

    <div class="row">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="2d-tab" data-toggle="tab" href="#tab2d" role="tab">
                                <i class="fas fa-square"></i> 2D Distance
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="3d-tab" data-toggle="tab" href="#tab3d" role="tab">
                                <i class="fas fa-cube"></i> 3D Distance
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="midpoint-tab" data-toggle="tab" href="#tabMidpoint" role="tab">
                                <i class="fas fa-dot-circle"></i> Midpoint
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- 2D Distance Tab -->
                        <div class="tab-pane fade show active" id="tab2d" role="tabpanel">
                            <form onsubmit="calculate2D(); return false;">
                                <div class="point-input">
                                    <h6 class="coordinate-label">Point 1 (x₁, y₁):</h6>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <input type="number" class="form-control" id="x1_2d" placeholder="x₁" step="any" value="0" required>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="number" class="form-control" id="y1_2d" placeholder="y₁" step="any" value="0" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="point-input">
                                    <h6 class="coordinate-label">Point 2 (x₂, y₂):</h6>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <input type="number" class="form-control" id="x2_2d" placeholder="x₂" step="any" value="3" required>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="number" class="form-control" id="y2_2d" placeholder="y₂" step="any" value="4" required>
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block btn-lg">
                                    <i class="fas fa-calculator"></i> Calculate 2D Distance
                                </button>
                            </form>

                            <div id="result2D"></div>

                            <!-- 2D Visualization -->
                            <div class="card mt-3" id="chart2DContainer" style="display:none;">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0"><i class="fas fa-chart-area"></i> Coordinate Plane Visualization</h6>
                                </div>
                                <div class="card-body p-2">
                                    <canvas id="chart2D" height="200"></canvas>
                                </div>
                            </div>
                        </div>

                        <!-- 3D Distance Tab -->
                        <div class="tab-pane fade" id="tab3d" role="tabpanel">
                            <form onsubmit="calculate3D(); return false;">
                                <div class="point-input">
                                    <h6 class="coordinate-label">Point 1 (x₁, y₁, z₁):</h6>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="x1_3d" placeholder="x₁" step="any" value="0" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="y1_3d" placeholder="y₁" step="any" value="0" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="z1_3d" placeholder="z₁" step="any" value="0" required>
                                        </div>
                                    </div>
                                </div>

                                <div class="point-input">
                                    <h6 class="coordinate-label">Point 2 (x₂, y₂, z₂):</h6>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="x2_3d" placeholder="x₂" step="any" value="3" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="y2_3d" placeholder="y₂" step="any" value="4" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="z2_3d" placeholder="z₂" step="any" value="5" required>
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block btn-lg">
                                    <i class="fas fa-calculator"></i> Calculate 3D Distance
                                </button>
                            </form>

                            <div id="result3D"></div>

                            <!-- 3D Visualization -->
                            <div class="card mt-3" id="chart3DContainer" style="display:none;">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0"><i class="fas fa-cube"></i> 3D Space Visualization</h6>
                                </div>
                                <div class="card-body p-2">
                                    <canvas id="chart3D" height="200"></canvas>
                                    <small class="text-muted">Note: 3D projection shown in 2D plane (XY view)</small>
                                </div>
                            </div>
                        </div>

                        <!-- Midpoint Tab -->
                        <div class="tab-pane fade" id="tabMidpoint" role="tabpanel">
                            <form onsubmit="calculateMidpoint(); return false;">
                                <div class="form-group">
                                    <label>Dimension:</label>
                                    <select class="form-control" id="midpointDim" onchange="toggleMidpointZ()">
                                        <option value="2d">2D (x, y)</option>
                                        <option value="3d">3D (x, y, z)</option>
                                    </select>
                                </div>

                                <div class="point-input">
                                    <h6 class="coordinate-label">Point 1:</h6>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="x1_mid" placeholder="x₁" step="any" value="2" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="y1_mid" placeholder="y₁" step="any" value="4" required>
                                        </div>
                                        <div class="col-md-4" id="z1_mid_container" style="display:none;">
                                            <input type="number" class="form-control" id="z1_mid" placeholder="z₁" step="any" value="6">
                                        </div>
                                    </div>
                                </div>

                                <div class="point-input">
                                    <h6 class="coordinate-label">Point 2:</h6>
                                    <div class="row">
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="x2_mid" placeholder="x₂" step="any" value="8" required>
                                        </div>
                                        <div class="col-md-4">
                                            <input type="number" class="form-control" id="y2_mid" placeholder="y₂" step="any" value="10" required>
                                        </div>
                                        <div class="col-md-4" id="z2_mid_container" style="display:none;">
                                            <input type="number" class="form-control" id="z2_mid" placeholder="z₂" step="any" value="12">
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-success btn-block btn-lg">
                                    <i class="fas fa-calculator"></i> Calculate Midpoint
                                </button>
                            </form>

                            <div id="resultMidpoint"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Formulas</h5>
                </div>
                <div class="card-body">
                    <h6>2D Distance Formula</h6>
                    <div class="formula-box">
                        d = √[(x₂ - x₁)² + (y₂ - y₁)²]
                    </div>

                    <h6>3D Distance Formula</h6>
                    <div class="formula-box">
                        d = √[(x₂ - x₁)² + (y₂ - y₁)² + (z₂ - z₁)²]
                    </div>

                    <h6>Midpoint Formula (2D)</h6>
                    <div class="formula-box">
                        M = ((x₁ + x₂)/2, (y₁ + y₂)/2)
                    </div>

                    <h6>Midpoint Formula (3D)</h6>
                    <div class="formula-box">
                        M = ((x₁ + x₂)/2, (y₁ + y₂)/2, (z₁ + z₂)/2)
                    </div>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-lightbulb"></i> Quick Examples</h5>
                </div>
                <div class="card-body">
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample2D(0, 0, 3, 4)">
                        2D: (0,0) to (3,4)
                    </button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample2D(-2, 3, 4, -1)">
                        2D: (-2,3) to (4,-1)
                    </button>
                    <button class="btn btn-sm btn-outline-info btn-block" onclick="loadExample3D(0, 0, 0, 1, 1, 1)">
                        3D: (0,0,0) to (1,1,1)
                    </button>
                    <button class="btn btn-sm btn-outline-info btn-block" onclick="loadExample3D(1, 2, 3, 4, 5, 6)">
                        3D: (1,2,3) to (4,5,6)
                    </button>
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
function calculate2D() {
    const x1 = parseFloat(document.getElementById('x1_2d').value);
    const y1 = parseFloat(document.getElementById('y1_2d').value);
    const x2 = parseFloat(document.getElementById('x2_2d').value);
    const y2 = parseFloat(document.getElementById('y2_2d').value);

    const dx = x2 - x1;
    const dy = y2 - y1;
    const distance = Math.sqrt(dx * dx + dy * dy);

    let resultHTML = `
        <div class="result-card mt-3">
            <h5 class="text-center">Distance</h5>
            <div class="text-center result-value">${distance.toFixed(6)}</div>
            <div class="text-center mt-2">
                <small>≈ ${distance.toFixed(2)} units</small>
            </div>
        </div>

        <div class="card mt-2">
            <div class="card-header bg-primary text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#steps2D">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Step-by-Step Solution
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="steps2D" class="collapse">
                <div class="card-body">
                    <div class="step-box">
                        <span class="step-number">1</span>
                        <strong>Identify the coordinates:</strong><br>
                        Point 1 (x₁, y₁) = (${x1}, ${y1})<br>
                        Point 2 (x₂, y₂) = (${x2}, ${y2})
                    </div>

                    <div class="step-box">
                        <span class="step-number">2</span>
                        <strong>Apply the distance formula:</strong><br>
                        d = √[(x₂ - x₁)² + (y₂ - y₁)²]
                    </div>

                    <div class="step-box">
                        <span class="step-number">3</span>
                        <strong>Calculate the differences:</strong><br>
                        Δx = x₂ - x₁ = ${x2} - (${x1}) = ${dx}<br>
                        Δy = y₂ - y₁ = ${y2} - (${y1}) = ${dy}
                    </div>

                    <div class="step-box">
                        <span class="step-number">4</span>
                        <strong>Square the differences:</strong><br>
                        (Δx)² = (${dx})² = ${(dx * dx).toFixed(6)}<br>
                        (Δy)² = (${dy})² = ${(dy * dy).toFixed(6)}
                    </div>

                    <div class="step-box">
                        <span class="step-number">5</span>
                        <strong>Sum and take square root:</strong><br>
                        d = √[${(dx * dx).toFixed(6)} + ${(dy * dy).toFixed(6)}]<br>
                        d = √${(dx * dx + dy * dy).toFixed(6)}<br>
                        <strong class="text-primary">d = ${distance.toFixed(6)}</strong>
                    </div>

                    <div class="alert alert-info mt-3 mb-0">
                        <strong><i class="fas fa-info-circle"></i> Additional Information:</strong><br>
                        • Horizontal distance (Δx): ${Math.abs(dx).toFixed(2)} units<br>
                        • Vertical distance (Δy): ${Math.abs(dy).toFixed(2)} units<br>
                        • Midpoint: ((${x1} + ${x2})/2, (${y1} + ${y2})/2) = (${((x1 + x2) / 2).toFixed(2)}, ${((y1 + y2) / 2).toFixed(2)})
                    </div>
                </div>
            </div>
        </div>
    `;

    document.getElementById('result2D').innerHTML = resultHTML;

    // Show and create 2D visualization
    document.getElementById('chart2DContainer').style.display = 'block';
    plot2DPoints(x1, y1, x2, y2, distance);
}

let chart2D = null;
let chart3D = null;

function plot2DPoints(x1, y1, x2, y2, distance) {
    const ctx = document.getElementById('chart2D').getContext('2d');

    // Calculate midpoint
    const mx = (x1 + x2) / 2;
    const my = (y1 + y2) / 2;

    // Calculate axis ranges with padding
    const minX = Math.min(x1, x2) - 2;
    const maxX = Math.max(x1, x2) + 2;
    const minY = Math.min(y1, y2) - 2;
    const maxY = Math.max(y1, y2) + 2;

    // Destroy previous chart if exists
    if (chart2D) {
        chart2D.destroy();
    }

    // Create new chart
    chart2D = new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: [
                {
                    label: `Point 1 (${x1}, ${y1})`,
                    data: [{x: x1, y: y1}],
                    backgroundColor: 'rgba(102, 126, 234, 1)',
                    borderColor: 'rgba(102, 126, 234, 1)',
                    pointRadius: 8,
                    pointHoverRadius: 10
                },
                {
                    label: `Point 2 (${x2}, ${y2})`,
                    data: [{x: x2, y: y2}],
                    backgroundColor: 'rgba(245, 87, 108, 1)',
                    borderColor: 'rgba(245, 87, 108, 1)',
                    pointRadius: 8,
                    pointHoverRadius: 10
                },
                {
                    label: `Midpoint (${mx.toFixed(2)}, ${my.toFixed(2)})`,
                    data: [{x: mx, y: my}],
                    backgroundColor: 'rgba(76, 175, 80, 1)',
                    borderColor: 'rgba(76, 175, 80, 1)',
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    pointStyle: 'star'
                },
                {
                    label: `Distance Line (d = ${distance.toFixed(2)})`,
                    data: [{x: x1, y: y1}, {x: x2, y: y2}],
                    type: 'line',
                    borderColor: 'rgba(255, 193, 7, 0.8)',
                    borderWidth: 3,
                    borderDash: [5, 5],
                    fill: false,
                    pointRadius: 0,
                    showLine: true
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                title: {
                    display: true,
                    text: `2D Coordinate Plane (Distance: ${distance.toFixed(2)} units)`,
                    font: {
                        size: 16,
                        weight: 'bold'
                    }
                },
                legend: {
                    display: true,
                    position: 'bottom'
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return `${context.dataset.label}: (${context.parsed.x}, ${context.parsed.y})`;
                        }
                    }
                }
            },
            scales: {
                x: {
                    type: 'linear',
                    position: 'center',
                    min: minX,
                    max: maxX,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)'
                    },
                    title: {
                        display: true,
                        text: 'X Axis',
                        font: {
                            weight: 'bold'
                        }
                    }
                },
                y: {
                    type: 'linear',
                    position: 'center',
                    min: minY,
                    max: maxY,
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)'
                    },
                    title: {
                        display: true,
                        text: 'Y Axis',
                        font: {
                            weight: 'bold'
                        }
                    }
                }
            }
        }
    });
}

function plot3DPoints(x1, y1, z1, x2, y2, z2, distance) {
    const ctx = document.getElementById('chart3D').getContext('2d');
    const mx = (x1 + x2) / 2;
    const my = (y1 + y2) / 2;
    const mz = (z1 + z2) / 2;

    // Calculate padding for chart ranges
    const minX = Math.min(x1, x2) - 2;
    const maxX = Math.max(x1, x2) + 2;
    const minY = Math.min(y1, y2) - 2;
    const maxY = Math.max(y1, y2) + 2;

    if (chart3D) {
        chart3D.destroy();
    }

    chart3D = new Chart(ctx, {
        type: 'scatter',
        data: {
            datasets: [
                {
                    label: `Point 1 (${x1}, ${y1}, ${z1})`,
                    data: [{x: x1, y: y1}],
                    backgroundColor: 'rgba(102, 126, 234, 1)',
                    pointRadius: 8,
                    pointStyle: 'circle'
                },
                {
                    label: `Point 2 (${x2}, ${y2}, ${z2})`,
                    data: [{x: x2, y: y2}],
                    backgroundColor: 'rgba(245, 87, 108, 1)',
                    pointRadius: 8,
                    pointStyle: 'circle'
                },
                {
                    label: `Midpoint (${mx.toFixed(2)}, ${my.toFixed(2)}, ${mz.toFixed(2)})`,
                    data: [{x: mx, y: my}],
                    backgroundColor: 'rgba(76, 175, 80, 1)',
                    pointRadius: 6,
                    pointStyle: 'star'
                },
                {
                    label: `Distance Line (d = ${distance.toFixed(2)})`,
                    data: [{x: x1, y: y1}, {x: x2, y: y2}],
                    type: 'line',
                    borderColor: 'rgba(255, 193, 7, 0.8)',
                    borderWidth: 3,
                    borderDash: [5, 5],
                    fill: false,
                    pointRadius: 0,
                    showLine: true
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                title: {
                    display: true,
                    text: `3D Points (XY Projection) - Distance: ${distance.toFixed(2)} units`,
                    font: {
                        size: 14,
                        weight: 'bold'
                    }
                },
                subtitle: {
                    display: true,
                    text: `Z-values: Point 1 (${z1}), Point 2 (${z2}), Midpoint (${mz.toFixed(2)})`,
                    font: {
                        size: 12
                    },
                    padding: {
                        bottom: 10
                    }
                },
                legend: {
                    display: true,
                    position: 'bottom'
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const label = context.dataset.label || '';
                            if (context.datasetIndex === 0) {
                                return `${label}: (${x1}, ${y1}, ${z1})`;
                            } else if (context.datasetIndex === 1) {
                                return `${label}: (${x2}, ${y2}, ${z2})`;
                            } else if (context.datasetIndex === 2) {
                                return `${label}: (${mx.toFixed(2)}, ${my.toFixed(2)}, ${mz.toFixed(2)})`;
                            }
                            return label;
                        }
                    }
                }
            },
            scales: {
                x: {
                    type: 'linear',
                    position: 'center',
                    min: minX,
                    max: maxX,
                    title: {
                        display: true,
                        text: 'X Axis',
                        font: {
                            weight: 'bold'
                        }
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)'
                    }
                },
                y: {
                    type: 'linear',
                    position: 'center',
                    min: minY,
                    max: maxY,
                    title: {
                        display: true,
                        text: 'Y Axis',
                        font: {
                            weight: 'bold'
                        }
                    },
                    grid: {
                        color: 'rgba(0, 0, 0, 0.1)'
                    }
                }
            }
        }
    });
}

function calculate3D() {
    const x1 = parseFloat(document.getElementById('x1_3d').value);
    const y1 = parseFloat(document.getElementById('y1_3d').value);
    const z1 = parseFloat(document.getElementById('z1_3d').value);
    const x2 = parseFloat(document.getElementById('x2_3d').value);
    const y2 = parseFloat(document.getElementById('y2_3d').value);
    const z2 = parseFloat(document.getElementById('z2_3d').value);

    const dx = x2 - x1;
    const dy = y2 - y1;
    const dz = z2 - z1;
    const distance = Math.sqrt(dx * dx + dy * dy + dz * dz);

    let resultHTML = `
        <div class="result-card mt-3">
            <h5 class="text-center">3D Distance</h5>
            <div class="text-center result-value">${distance.toFixed(6)}</div>
            <div class="text-center mt-2">
                <small>≈ ${distance.toFixed(2)} units</small>
            </div>
        </div>

        <div class="card mt-2">
            <div class="card-header bg-primary text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#steps3D">
                <h6 class="mb-0">
                    <i class="fas fa-list-ol"></i> Step-by-Step Solution
                    <i class="fas fa-chevron-down float-right"></i>
                </h6>
            </div>
            <div id="steps3D" class="collapse">
                <div class="card-body">
                    <div class="step-box">
                        <span class="step-number">1</span>
                        <strong>Identify the coordinates:</strong><br>
                        Point 1 (x₁, y₁, z₁) = (${x1}, ${y1}, ${z1})<br>
                        Point 2 (x₂, y₂, z₂) = (${x2}, ${y2}, ${z2})
                    </div>

                    <div class="step-box">
                        <span class="step-number">2</span>
                        <strong>Apply the 3D distance formula:</strong><br>
                        d = √[(x₂ - x₁)² + (y₂ - y₁)² + (z₂ - z₁)²]
                    </div>

                    <div class="step-box">
                        <span class="step-number">3</span>
                        <strong>Calculate the differences:</strong><br>
                        Δx = x₂ - x₁ = ${x2} - (${x1}) = ${dx}<br>
                        Δy = y₂ - y₁ = ${y2} - (${y1}) = ${dy}<br>
                        Δz = z₂ - z₁ = ${z2} - (${z1}) = ${dz}
                    </div>

                    <div class="step-box">
                        <span class="step-number">4</span>
                        <strong>Square the differences:</strong><br>
                        (Δx)² = (${dx})² = ${(dx * dx).toFixed(6)}<br>
                        (Δy)² = (${dy})² = ${(dy * dy).toFixed(6)}<br>
                        (Δz)² = (${dz})² = ${(dz * dz).toFixed(6)}
                    </div>

                    <div class="step-box">
                        <span class="step-number">5</span>
                        <strong>Sum and take square root:</strong><br>
                        d = √[${(dx * dx).toFixed(6)} + ${(dy * dy).toFixed(6)} + ${(dz * dz).toFixed(6)}]<br>
                        d = √${(dx * dx + dy * dy + dz * dz).toFixed(6)}<br>
                        <strong class="text-primary">d = ${distance.toFixed(6)}</strong>
                    </div>

                    <div class="alert alert-info mt-3 mb-0">
                        <strong><i class="fas fa-info-circle"></i> Additional Information:</strong><br>
                        • X-axis distance: ${Math.abs(dx).toFixed(2)} units<br>
                        • Y-axis distance: ${Math.abs(dy).toFixed(2)} units<br>
                        • Z-axis distance: ${Math.abs(dz).toFixed(2)} units<br>
                        • Midpoint: (${((x1 + x2) / 2).toFixed(2)}, ${((y1 + y2) / 2).toFixed(2)}, ${((z1 + z2) / 2).toFixed(2)})
                    </div>
                </div>
            </div>
        </div>
    `;

    document.getElementById('result3D').innerHTML = resultHTML;

    // Show and update the 3D visualization chart
    document.getElementById('chart3DContainer').style.display = 'block';
    plot3DPoints(x1, y1, z1, x2, y2, z2, distance);
}

function calculateMidpoint() {
    const dim = document.getElementById('midpointDim').value;
    const x1 = parseFloat(document.getElementById('x1_mid').value);
    const y1 = parseFloat(document.getElementById('y1_mid').value);
    const x2 = parseFloat(document.getElementById('x2_mid').value);
    const y2 = parseFloat(document.getElementById('y2_mid').value);

    const mx = (x1 + x2) / 2;
    const my = (y1 + y2) / 2;

    let resultHTML = '';

    if (dim === '2d') {
        resultHTML = `
            <div class="result-card mt-3">
                <h5 class="text-center">Midpoint</h5>
                <div class="text-center result-value">(${mx.toFixed(2)}, ${my.toFixed(2)})</div>
            </div>

            <div class="card mt-2">
                <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsMidpoint">
                    <h6 class="mb-0">
                        <i class="fas fa-list-ol"></i> Calculation
                        <i class="fas fa-chevron-down float-right"></i>
                    </h6>
                </div>
                <div id="stepsMidpoint" class="collapse">
                    <div class="card-body">
                        <div class="step-box">
                            <span class="step-number">1</span>
                            <strong>Midpoint Formula (2D):</strong><br>
                            M = ((x₁ + x₂)/2, (y₁ + y₂)/2)
                        </div>

                        <div class="step-box">
                            <span class="step-number">2</span>
                            <strong>Substitute values:</strong><br>
                            M = ((${x1} + ${x2})/2, (${y1} + ${y2})/2)
                        </div>

                        <div class="step-box">
                            <span class="step-number">3</span>
                            <strong>Calculate:</strong><br>
                            M<sub>x</sub> = (${x1} + ${x2})/2 = ${(x1 + x2).toFixed(2)}/2 = ${mx.toFixed(2)}<br>
                            M<sub>y</sub> = (${y1} + ${y2})/2 = ${(y1 + y2).toFixed(2)}/2 = ${my.toFixed(2)}<br>
                            <strong class="text-success">Midpoint = (${mx.toFixed(2)}, ${my.toFixed(2)})</strong>
                        </div>

                        <div class="alert alert-info mb-0">
                            <strong><i class="fas fa-ruler"></i> Distance from each point to midpoint:</strong><br>
                            ${(Math.sqrt(Math.pow(mx - x1, 2) + Math.pow(my - y1, 2))).toFixed(4)} units
                        </div>
                    </div>
                </div>
            </div>
        `;
    } else {
        const z1 = parseFloat(document.getElementById('z1_mid').value);
        const z2 = parseFloat(document.getElementById('z2_mid').value);
        const mz = (z1 + z2) / 2;

        resultHTML = `
            <div class="result-card mt-3">
                <h5 class="text-center">3D Midpoint</h5>
                <div class="text-center result-value">(${mx.toFixed(2)}, ${my.toFixed(2)}, ${mz.toFixed(2)})</div>
            </div>

            <div class="card mt-2">
                <div class="card-header bg-success text-white" style="cursor: pointer;" data-toggle="collapse" data-target="#stepsMidpoint">
                    <h6 class="mb-0">
                        <i class="fas fa-list-ol"></i> Calculation
                        <i class="fas fa-chevron-down float-right"></i>
                    </h6>
                </div>
                <div id="stepsMidpoint" class="collapse">
                    <div class="card-body">
                        <div class="step-box">
                            <span class="step-number">1</span>
                            <strong>Midpoint Formula (3D):</strong><br>
                            M = ((x₁ + x₂)/2, (y₁ + y₂)/2, (z₁ + z₂)/2)
                        </div>

                        <div class="step-box">
                            <span class="step-number">2</span>
                            <strong>Calculate each coordinate:</strong><br>
                            M<sub>x</sub> = (${x1} + ${x2})/2 = ${mx.toFixed(2)}<br>
                            M<sub>y</sub> = (${y1} + ${y2})/2 = ${my.toFixed(2)}<br>
                            M<sub>z</sub> = (${z1} + ${z2})/2 = ${mz.toFixed(2)}<br>
                            <strong class="text-success">Midpoint = (${mx.toFixed(2)}, ${my.toFixed(2)}, ${mz.toFixed(2)})</strong>
                        </div>

                        <div class="alert alert-info mb-0">
                            <strong><i class="fas fa-ruler"></i> Distance from each point to midpoint:</strong><br>
                            ${(Math.sqrt(Math.pow(mx - x1, 2) + Math.pow(my - y1, 2) + Math.pow(mz - z1, 2))).toFixed(4)} units
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    document.getElementById('resultMidpoint').innerHTML = resultHTML;
}

function toggleMidpointZ() {
    const dim = document.getElementById('midpointDim').value;
    const z1Container = document.getElementById('z1_mid_container');
    const z2Container = document.getElementById('z2_mid_container');

    if (dim === '3d') {
        z1Container.style.display = 'block';
        z2Container.style.display = 'block';
    } else {
        z1Container.style.display = 'none';
        z2Container.style.display = 'none';
    }
}

function loadExample2D(x1, y1, x2, y2) {
    document.getElementById('x1_2d').value = x1;
    document.getElementById('y1_2d').value = y1;
    document.getElementById('x2_2d').value = x2;
    document.getElementById('y2_2d').value = y2;
    $('#2d-tab').tab('show');
    calculate2D();
}

function loadExample3D(x1, y1, z1, x2, y2, z2) {
    document.getElementById('x1_3d').value = x1;
    document.getElementById('y1_3d').value = y1;
    document.getElementById('z1_3d').value = z1;
    document.getElementById('x2_3d').value = x2;
    document.getElementById('y2_3d').value = y2;
    document.getElementById('z2_3d').value = z2;
    $('#3d-tab').tab('show');
    calculate3D();
}

// Initialize with default calculation
document.addEventListener('DOMContentLoaded', function() {
    calculate2D();
});
</script>

<!-- Visible FAQ section (must match JSON-LD below) -->
<section id="faq" class="mt-5">
  <h2 class="h5">Distance Formula: FAQ</h2>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What formulas are used in 2D and 3D?</h3>
    <p class="mb-0">In 2D, distance = √[(x₂−x₁)² + (y₂−y₁)²]. In 3D, distance = √[(x₂−x₁)² + (y₂−y₁)² + (z₂−z₁)²]. The tool shows each step.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">How do I find the midpoint?</h3>
    <p class="mb-0">The midpoint in 2D is ((x₁+x₂)/2, (y₁+y₂)/2). In 3D it is ((x₁+x₂)/2, (y₁+y₂)/2, (z₁+z₂)/2). Use the Midpoint tab to compute it directly.</p>
  </div></div>
  <div class="card mb-3"><div class="card-body">
    <h3 class="h6">What units and precision are supported?</h3>
    <p class="mb-0">Enter coordinates in the same units. The result is in those units; you can input decimals for higher precision.</p>
  </div></div>
</section>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type":"Question","name":"What formulas are used in 2D and 3D?","acceptedAnswer":{"@type":"Answer","text":"In 2D, distance = √[(x2−x1)^2 + (y2−y1)^2]. In 3D, distance = √[(x2−x1)^2 + (y2−y1)^2 + (z2−z1)^2]. The tool shows each step."}},
    {"@type":"Question","name":"How do I find the midpoint?","acceptedAnswer":{"@type":"Answer","text":"The midpoint in 2D is ((x1+x2)/2, (y1+y2)/2). In 3D it is ((x1+x2)/2, (y1+y2)/2, (z1+z2)/2). Use the Midpoint tab to compute it directly."}},
    {"@type":"Question","name":"What units and precision are supported?","acceptedAnswer":{"@type":"Answer","text":"Enter coordinates in the same units. The result is in those units; you can input decimals for higher precision."}}
  ]
}
</script>

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Distance Formula Calculator","item":"https://8gwifi.org/distance-formula-calculator.jsp"}
  ]
}
</script>
</div>
<%@ include file="body-close.jsp"%>
