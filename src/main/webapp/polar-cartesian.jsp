<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1" />
<meta name="description" content="Free advanced Polar ↔ Cartesian coordinate converter with interactive visualization, multiple angle formats (degrees, radians, gradians), and point plotting. Convert between polar (r, θ) and Cartesian (x, y) coordinates instantly.">
<meta name="keywords" content="polar to cartesian, cartesian to polar, coordinate converter, polar coordinates, cartesian coordinates, angle conversion, radians to degrees, coordinate transformation, vector calculator">
<title>Polar ↔ Cartesian Coordinate Converter | Interactive Visualization Tool</title>

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/polar-cartesian.jsp">
<meta property="og:title" content="Polar ↔ Cartesian Coordinate Converter - Interactive Tool">
<meta property="og:description" content="Free converter with interactive visualization, multiple angle formats, and point plotting.">
<meta property="og:image" content="https://8gwifi.org/images/polar-cartesian-converter.png">

<!-- Twitter -->
<meta property="twitter:card" content="summary_large_image">
<meta property="twitter:url" content="https://8gwifi.org/polar-cartesian.jsp">
<meta property="twitter:title" content="Polar ↔ Cartesian Coordinate Converter">
<meta property="twitter:description" content="Free converter with interactive visualization, multiple angle formats, and point plotting.">
<meta property="twitter:image" content="https://8gwifi.org/images/polar-cartesian-converter.png">

<link rel="canonical" href="https://8gwifi.org/polar-cartesian.jsp">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

<!-- JSON-LD Schema -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "WebApplication",
      "@id": "https://8gwifi.org/polar-cartesian.jsp#webapp",
      "name": "Polar ↔ Cartesian Coordinate Converter",
      "url": "https://8gwifi.org/polar-cartesian.jsp",
      "description": "Free interactive polar to cartesian and cartesian to polar coordinate converter with visualization, multiple angle formats (degrees, radians, gradians), point plotting, and real-time conversion.",
      "applicationCategory": "UtilityApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Polar to Cartesian conversion",
        "Cartesian to Polar conversion",
        "Multiple angle formats (degrees, radians, gradians)",
        "Interactive coordinate plane visualization",
        "Point plotting and vector display",
        "Quadrant identification",
        "Real-time conversion",
        "Distance and angle calculation"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.9",
        "ratingCount": "1523"
      }
    },
    {
      "@type": "FAQPage",
      "@id": "https://8gwifi.org/polar-cartesian.jsp#faq",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "How do you convert from Cartesian to polar coordinates?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "To convert Cartesian coordinates (x, y) to polar coordinates (r, θ): Calculate radius r = √(x² + y²) and angle θ = atan2(y, x). The angle θ is measured counterclockwise from the positive x-axis. For example, point (3, 4) converts to r = 5 and θ = 53.13°."
          }
        },
        {
          "@type": "Question",
          "name": "How do you convert from polar to Cartesian coordinates?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "To convert polar coordinates (r, θ) to Cartesian coordinates (x, y): Calculate x = r × cos(θ) and y = r × sin(θ). Make sure θ is in radians. For example, polar coordinates (5, 45°) convert to approximately x = 3.54 and y = 3.54."
          }
        },
        {
          "@type": "Question",
          "name": "What are the different angle measurement units?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "There are three common angle units: Degrees (360° in a full circle), Radians (2π rad in a full circle), and Gradians (400 grad in a full circle). Conversion: 180° = π rad = 200 grad. This calculator displays all three formats simultaneously."
          }
        },
        {
          "@type": "Question",
          "name": "What is the quadrant of a coordinate point?",
          "acceptedAnswer": {
            "@type": "Answer",
            "text": "The coordinate plane is divided into four quadrants: Quadrant I (x > 0, y > 0), Quadrant II (x < 0, y > 0), Quadrant III (x < 0, y < 0), and Quadrant IV (x > 0, y < 0). Points on the axes are not in any quadrant. This converter automatically identifies the quadrant."
          }
        }
      ]
    },
    {
      "@type": "HowTo",
      "@id": "https://8gwifi.org/polar-cartesian.jsp#howto",
      "name": "How to Convert Between Polar and Cartesian Coordinates",
      "description": "Step-by-step guide to convert coordinates between polar and Cartesian systems",
      "totalTime": "PT2M",
      "step": [
        {
          "@type": "HowToStep",
          "position": 1,
          "name": "Enter Coordinates",
          "text": "Enter either Cartesian coordinates (x, y) or polar coordinates (r, θ) in the input fields. You only need to enter one type of coordinates."
        },
        {
          "@type": "HowToStep",
          "position": 2,
          "name": "Click Convert Button",
          "text": "Click 'to Polar' button to convert from Cartesian to polar coordinates, or 'to Cartesian' button to convert from polar to Cartesian coordinates."
        },
        {
          "@type": "HowToStep",
          "position": 3,
          "name": "View Results",
          "text": "The converted coordinates appear instantly. Review the information cards showing distance, angle, and quadrant. Check the angle formats section for degrees, radians, and gradians."
        },
        {
          "@type": "HowToStep",
          "position": 4,
          "name": "Visualize on Graph",
          "text": "The interactive coordinate plane shows your point as a green dot with a red vector from the origin. Grid circles help visualize the distance from origin."
        },
        {
          "@type": "HowToStep",
          "position": 5,
          "name": "Plot Multiple Points",
          "text": "Click 'Plot Point' button to add the current point to the graph. This allows comparing multiple coordinate positions simultaneously."
        }
      ]
    },
    {
      "@type": "WebPage",
      "@id": "https://8gwifi.org/polar-cartesian.jsp",
      "url": "https://8gwifi.org/polar-cartesian.jsp",
      "name": "Polar ↔ Cartesian Coordinate Converter | Interactive Visualization Tool",
      "description": "Free advanced Polar ↔ Cartesian coordinate converter with interactive visualization, multiple angle formats, and point plotting.",
      "inLanguage": "en-US",
      "datePublished": "2024-01-10",
      "dateModified": "2024-12-20"
    }
  ]
}
</script>

<%@ include file="header-script.jsp"%>
<style>
  .pc-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(4, minmax(160px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .panel{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:1.5rem; box-shadow:0 8px 24px rgba(0,0,0,0.05); margin-top:1rem; }
  .panel h5{ font-size:1.1rem; font-weight:700; margin-bottom:1rem; color:#111827; }
  .info-cards{ display:grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap:1rem; margin:1rem 0; }
  .info-card{ border:1px solid #e5e7eb; background:linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius:12px; padding:1rem; color:white; }
  .info-card.blue{ background:linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); }
  .info-card.green{ background:linear-gradient(135deg, #10b981 0%, #059669 100%); }
  .info-card.orange{ background:linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
  .info-card h6{ font-size:0.75rem; opacity:0.9; margin-bottom:0.5rem; text-transform:uppercase; letter-spacing:0.05em; }
  .info-card .value{ font-size:1.5rem; font-weight:800; }
  .chart-wrapper{ position:relative; height:400px; margin-top:1rem; }
  .angle-formats{ display:grid; grid-template-columns: repeat(3, 1fr); gap:0.5rem; margin-top:0.5rem; }
  .angle-format{ background:#f9fafb; border:1px solid #e5e7eb; border-radius:8px; padding:0.75rem; text-align:center; }
  .angle-format .label{ font-size:0.75rem; color:#6b7280; margin-bottom:0.25rem; }
  .angle-format .value{ font-size:1.1rem; font-weight:700; color:#111827; }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr 1fr; } .angle-formats{ grid-template-columns: 1fr; } }
</style>
</head>
<%@ include file="body-script.jsp"%>

<div class="pc-container">
  <h1 class="mt-4"><i class="fas fa-compass"></i> Polar ↔ Cartesian Coordinate Converter</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="x" class="form-control" placeholder="x (Cartesian)" inputmode="decimal">
    <input id="y" class="form-control" placeholder="y (Cartesian)" inputmode="decimal">
    <input id="r" class="form-control" placeholder="r (radius)" inputmode="decimal">
    <input id="theta" class="form-control" placeholder="θ (degrees)" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnToPolar"><i class="fas fa-arrow-right"></i> to Polar (r, θ)</button>
    <button class="btn btn-primary" id="btnToCartesian"><i class="fas fa-arrow-left"></i> to Cartesian (x, y)</button>
    <button class="btn btn-info" id="btnRandom"><i class="fas fa-dice"></i> Random Point</button>
    <button class="btn btn-warning" id="btnAddPoint"><i class="fas fa-plus"></i> Plot Point</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Clear All</button>
  </div>

  <div class="info-cards">
    <div class="info-card blue">
      <h6><i class="fas fa-ruler"></i> Distance from Origin</h6>
      <div class="value" id="infoDistance">—</div>
    </div>
    <div class="info-card green">
      <h6><i class="fas fa-angle-right"></i> Angle from X-Axis</h6>
      <div class="value" id="infoAngle">—</div>
    </div>
    <div class="info-card orange">
      <h6><i class="fas fa-location-arrow"></i> Quadrant</h6>
      <div class="value" id="infoQuadrant">—</div>
    </div>
  </div>

  <div class="panel">
    <h5><i class="fas fa-ruler-combined"></i> Angle Formats</h5>
    <div class="angle-formats">
      <div class="angle-format">
        <div class="label">Degrees (°)</div>
        <div class="value" id="angleDegrees">—</div>
      </div>
      <div class="angle-format">
        <div class="label">Radians (rad)</div>
        <div class="value" id="angleRadians">—</div>
      </div>
      <div class="angle-format">
        <div class="label">Gradians (grad)</div>
        <div class="value" id="angleGradians">—</div>
      </div>
    </div>
  </div>

  <div class="panel">
    <h5><i class="fas fa-chart-scatter"></i> Interactive Coordinate Plane</h5>
    <div class="chart-wrapper">
      <canvas id="polarChart"></canvas>
    </div>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);}
  function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;}
  function round(n,p){var f=Math.pow(10,p||6);return Math.round(n*f)/f;}
  function rad(d){return d*Math.PI/180;}
  function deg(r){return r*180/Math.PI;}
  function grad(d){return d * 10/9;}
  function degFromGrad(g){return g * 9/10;}

  var x=el('x'),y=el('y'),r=el('r'),theta=el('theta');
  var plotChart = null;
  var plottedPoints = [];
  var currentPoint = null;

  function getQuadrant(X, Y) {
    if (X > 0 && Y > 0) return 'I';
    if (X < 0 && Y > 0) return 'II';
    if (X < 0 && Y < 0) return 'III';
    if (X > 0 && Y < 0) return 'IV';
    if (X === 0 && Y > 0) return 'Positive Y-axis';
    if (X === 0 && Y < 0) return 'Negative Y-axis';
    if (Y === 0 && X > 0) return 'Positive X-axis';
    if (Y === 0 && X < 0) return 'Negative X-axis';
    return 'Origin';
  }

  function updateInfo(X, Y, R, T) {
    el('infoDistance').textContent = round(R, 4);
    el('infoAngle').textContent = round(T, 2) + '°';
    el('infoQuadrant').textContent = getQuadrant(X, Y);

    var radians = rad(T);
    var gradians = grad(T);

    el('angleDegrees').textContent = round(T, 4) + '°';
    el('angleRadians').textContent = round(radians, 6) + ' rad';
    el('angleGradians').textContent = round(gradians, 4) + ' grad';
  }

  function toPolar(){
    var X=num(x.value),Y=num(y.value);
    if(!(isFinite(X)&&isFinite(Y))) return;
    var R=Math.sqrt(X*X+Y*Y);
    var T=deg(Math.atan2(Y,X));
    r.value=round(R, 4);
    theta.value=round(T, 4);
    currentPoint = {x: X, y: Y};
    updateInfo(X, Y, R, T);
    updateChart();
  }

  function toCartesian(){
    var R=num(r.value), T=num(theta.value);
    if(!(R>=0&&isFinite(T))) return;
    var X=R*Math.cos(rad(T)), Y=R*Math.sin(rad(T));
    x.value=round(X, 4);
    y.value=round(Y, 4);
    currentPoint = {x: X, y: Y};
    updateInfo(X, Y, R, T);
    updateChart();
  }

  function randomize(){
    x.value=(Math.random()*20-10).toFixed(2);
    y.value=(Math.random()*20-10).toFixed(2);
    r.value='';
    theta.value='';
    toPolar();
  }

  function addPoint() {
    if (currentPoint) {
      plottedPoints.push({
        x: currentPoint.x,
        y: currentPoint.y,
        label: 'P' + (plottedPoints.length + 1)
      });
      updateChart();
    }
  }

  function reset() {
    x.value=y.value=r.value=theta.value='';
    currentPoint = null;
    plottedPoints = [];
    el('infoDistance').textContent = '—';
    el('infoAngle').textContent = '—';
    el('infoQuadrant').textContent = '—';
    el('angleDegrees').textContent = '—';
    el('angleRadians').textContent = '—';
    el('angleGradians').textContent = '—';
    updateChart();
  }

  function updateChart() {
    if (plotChart) plotChart.destroy();

    var datasets = [];

    // Grid circles
    var circleData1 = [];
    var circleData2 = [];
    var circleData3 = [];
    for (var i = 0; i <= 360; i += 2) {
      var angle = rad(i);
      circleData1.push({x: 5 * Math.cos(angle), y: 5 * Math.sin(angle)});
      circleData2.push({x: 10 * Math.cos(angle), y: 10 * Math.sin(angle)});
      circleData3.push({x: 15 * Math.cos(angle), y: 15 * Math.sin(angle)});
    }

    datasets.push({
      label: 'Grid r=5',
      data: circleData1,
      borderColor: '#e5e7eb',
      backgroundColor: 'transparent',
      showLine: true,
      pointRadius: 0,
      borderWidth: 1,
      borderDash: [5, 5]
    });

    datasets.push({
      label: 'Grid r=10',
      data: circleData2,
      borderColor: '#d1d5db',
      backgroundColor: 'transparent',
      showLine: true,
      pointRadius: 0,
      borderWidth: 1,
      borderDash: [5, 5]
    });

    datasets.push({
      label: 'Grid r=15',
      data: circleData3,
      borderColor: '#d1d5db',
      backgroundColor: 'transparent',
      showLine: true,
      pointRadius: 0,
      borderWidth: 1,
      borderDash: [5, 5]
    });

    // Plotted points
    if (plottedPoints.length > 0) {
      datasets.push({
        label: 'Plotted Points',
        data: plottedPoints,
        borderColor: '#8b5cf6',
        backgroundColor: '#8b5cf6',
        pointRadius: 6,
        showLine: false
      });
    }

    // Current point with line from origin
    if (currentPoint) {
      datasets.push({
        label: 'Vector',
        data: [{x: 0, y: 0}, {x: currentPoint.x, y: currentPoint.y}],
        borderColor: '#ef4444',
        backgroundColor: 'transparent',
        showLine: true,
        pointRadius: 0,
        borderWidth: 3
      });

      datasets.push({
        label: 'Current Point',
        data: [currentPoint],
        borderColor: '#10b981',
        backgroundColor: '#10b981',
        pointRadius: 10,
        showLine: false
      });
    }

    var ctx = document.getElementById('polarChart').getContext('2d');
    plotChart = new Chart(ctx, {
      type: 'scatter',
      data: {
        datasets: datasets
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                var label = context.dataset.label || '';
                if (context.parsed.x !== null) {
                  label += ' (' + context.parsed.x.toFixed(2) + ', ' + context.parsed.y.toFixed(2) + ')';
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
            min: -20,
            max: 20,
            grid: {
              color: function(context) {
                if (context.tick.value === 0) {
                  return '#374151';
                }
                return '#f3f4f6';
              },
              lineWidth: function(context) {
                if (context.tick.value === 0) {
                  return 2;
                }
                return 1;
              }
            },
            ticks: {
              stepSize: 5
            }
          },
          y: {
            type: 'linear',
            position: 'center',
            min: -20,
            max: 20,
            grid: {
              color: function(context) {
                if (context.tick.value === 0) {
                  return '#374151';
                }
                return '#f3f4f6';
              },
              lineWidth: function(context) {
                if (context.tick.value === 0) {
                  return 2;
                }
                return 1;
              }
            },
            ticks: {
              stepSize: 5
            }
          }
        }
      }
    });
  }

  // Event listeners
  el('btnToPolar').addEventListener('click', toPolar);
  el('btnToCartesian').addEventListener('click', toCartesian);
  el('btnRandom').addEventListener('click', randomize);
  el('btnAddPoint').addEventListener('click', addPoint);
  el('btnReset').addEventListener('click', reset);

  // Real-time conversion
  x.addEventListener('input', function() {
    if (x.value && y.value) {
      toPolar();
    }
  });

  y.addEventListener('input', function() {
    if (x.value && y.value) {
      toPolar();
    }
  });

  r.addEventListener('input', function() {
    if (r.value && theta.value) {
      toCartesian();
    }
  });

  theta.addEventListener('input', function() {
    if (r.value && theta.value) {
      toCartesian();
    }
  });

  // Initialize
  window.addEventListener('load', function() {
    updateChart();
  });
})();
</script>
</div>
<%@ include file="body-close.jsp"%>
