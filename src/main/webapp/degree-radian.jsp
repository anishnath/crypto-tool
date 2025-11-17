<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<title>Degrees ↔ Radians Converter + Arc Length</title>
<meta name="description" content="Convert between degrees and radians instantly, plus compute arc length from radius and angle.">
<link rel="canonical" href="https://8gwifi.org/degree-radian.jsp">
<%@ include file="header-script.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<style>
  .dr-container{ margin-top:1rem; }
  .grid{ display:grid; grid-template-columns: repeat(3, minmax(160px,1fr)); gap:.5rem; }
  .controls{ display:flex; gap:.5rem; align-items:center; margin:1rem 0; flex-wrap:wrap; }
  .cards{ display:grid; grid-template-columns: repeat(3, minmax(0,1fr)); gap:12px; }
  .cardx{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:10px 12px; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .big{ font-size:1.2rem; font-weight:800; color:#111827; }
  .chart-section{ margin-top:2rem; }
  .chart-grid{ display:grid; grid-template-columns: repeat(2, 1fr); gap:1.5rem; margin-top:1rem; }
  .chart-card{ border:1px solid #e5e7eb; background:#fff; border-radius:12px; padding:1.5rem; box-shadow:0 8px 24px rgba(0,0,0,0.05); }
  .chart-card h3{ font-size:1.1rem; font-weight:700; margin-bottom:1rem; color:#111827; }
  .chart-wrapper{ position:relative; height:300px; }
  @media (max-width:576px){ .grid{ grid-template-columns: 1fr;} .cards{ grid-template-columns: 1fr;} .chart-grid{ grid-template-columns: 1fr;} }
</style>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="dr-container">
  <h1 class="mt-4">Degrees ↔ Radians + Arc Length</h1>

  <%@ include file="footer_adsense.jsp"%>

  <div class="grid">
    <input id="deg" class="form-control" placeholder="Degrees" inputmode="decimal">
    <input id="rad" class="form-control" placeholder="Radians" inputmode="decimal">
    <input id="radius" class="form-control" placeholder="Radius (for arc length)" inputmode="decimal">
  </div>

  <div class="controls">
    <button class="btn btn-success" id="btnConvert"><i class="fas fa-arrows-rotate"></i> Convert</button>
    <button class="btn btn-secondary" id="btnRandom"><i class="fas fa-dice"></i> Random</button>
    <button class="btn btn-outline-danger" id="btnReset"><i class="fas fa-eraser"></i> Reset</button>
  </div>

  <div class="cards">
    <div class="cardx"><div class="big">Radians: <span id="oRad">—</span></div></div>
    <div class="cardx"><div class="big">Degrees: <span id="oDeg">—</span></div></div>
    <div class="cardx"><div class="big">Arc length s: <span id="oArc">—</span></div><div class="tiny">s = rθ (θ in radians)</div></div>
  </div>

  <div class="chart-section">
    <h2>Visualizations</h2>
    <div class="chart-grid">
      <div class="chart-card">
        <h3><i class="fas fa-circle-notch"></i> Unit Circle</h3>
        <div class="chart-wrapper">
          <canvas id="unitCircleChart"></canvas>
        </div>
      </div>
      <div class="chart-card">
        <h3><i class="fas fa-chart-pie"></i> Angle Distribution</h3>
        <div class="chart-wrapper">
          <canvas id="angleChart"></canvas>
        </div>
      </div>
      <div class="chart-card">
        <h3><i class="fas fa-wave-square"></i> Trigonometric Values</h3>
        <div class="chart-wrapper">
          <canvas id="trigChart"></canvas>
        </div>
      </div>
      <div class="chart-card">
        <h3><i class="fas fa-ruler"></i> Arc Length Visualization</h3>
        <div class="chart-wrapper">
          <canvas id="arcChart"></canvas>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  function el(id){return document.getElementById(id);}
  function num(v){var n=parseFloat(String(v).replace(/[^0-9.\\-]/g,''));return isFinite(n)?n:NaN;}
  function round(n,p){var f=Math.pow(10,p||6);return Math.round(n*f)/f;}

  var deg=el('deg'),rad=el('rad'),radius=el('radius');
  var oRad=el('oRad'),oDeg=el('oDeg'),oArc=el('oArc');

  // Chart instances
  var unitCircleChart, angleChart, trigChart, arcChart;

  // Initialize all charts
  function initCharts() {
    // Unit Circle Chart
    var ctx1 = el('unitCircleChart').getContext('2d');
    unitCircleChart = new Chart(ctx1, {
      type: 'scatter',
      data: {
        datasets: [{
          label: 'Unit Circle',
          data: generateCirclePoints(),
          borderColor: '#3b82f6',
          backgroundColor: 'transparent',
          showLine: true,
          pointRadius: 0,
          borderWidth: 2
        }, {
          label: 'Angle Line',
          data: [{x: 0, y: 0}, {x: 1, y: 0}],
          borderColor: '#ef4444',
          backgroundColor: '#ef4444',
          showLine: true,
          pointRadius: 5,
          borderWidth: 3
        }, {
          label: 'Point',
          data: [{x: 1, y: 0}],
          borderColor: '#10b981',
          backgroundColor: '#10b981',
          pointRadius: 8,
          showLine: false
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1,
        plugins: {
          legend: { display: false },
          tooltip: { enabled: true }
        },
        scales: {
          x: { min: -1.5, max: 1.5, grid: { color: '#e5e7eb' } },
          y: { min: -1.5, max: 1.5, grid: { color: '#e5e7eb' } }
        }
      }
    });

    // Angle Distribution (Pie/Doughnut Chart)
    var ctx2 = el('angleChart').getContext('2d');
    angleChart = new Chart(ctx2, {
      type: 'doughnut',
      data: {
        labels: ['Current Angle', 'Remaining'],
        datasets: [{
          data: [45, 315],
          backgroundColor: ['#8b5cf6', '#e5e7eb'],
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: { position: 'bottom' },
          tooltip: {
            callbacks: {
              label: function(context) {
                return context.label + ': ' + context.parsed + '°';
              }
            }
          }
        }
      }
    });

    // Trigonometric Values Bar Chart
    var ctx3 = el('trigChart').getContext('2d');
    trigChart = new Chart(ctx3, {
      type: 'bar',
      data: {
        labels: ['sin(θ)', 'cos(θ)', 'tan(θ)'],
        datasets: [{
          label: 'Value',
          data: [0.707, 0.707, 1],
          backgroundColor: ['#f59e0b', '#10b981', '#ef4444'],
          borderWidth: 2,
          borderColor: ['#d97706', '#059669', '#dc2626']
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: { display: false }
        },
        scales: {
          y: {
            min: -2,
            max: 2,
            grid: { color: '#e5e7eb' }
          }
        }
      }
    });

    // Arc Length Visualization
    var ctx4 = el('arcChart').getContext('2d');
    arcChart = new Chart(ctx4, {
      type: 'line',
      data: {
        labels: ['0°', '30°', '60°', '90°', '120°', '150°', '180°'],
        datasets: [{
          label: 'Arc Length',
          data: [0, 2.62, 5.24, 7.85, 10.47, 13.09, 15.71],
          borderColor: '#3b82f6',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          fill: true,
          tension: 0.4,
          borderWidth: 3,
          pointRadius: 5,
          pointBackgroundColor: '#3b82f6'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        plugins: {
          legend: { position: 'top' }
        },
        scales: {
          y: {
            beginAtZero: true,
            grid: { color: '#e5e7eb' },
            title: { display: true, text: 'Arc Length (units)' }
          },
          x: {
            grid: { color: '#e5e7eb' },
            title: { display: true, text: 'Angle' }
          }
        }
      }
    });
  }

  function generateCirclePoints() {
    var points = [];
    for (var i = 0; i <= 360; i += 2) {
      var rad = i * Math.PI / 180;
      points.push({x: Math.cos(rad), y: Math.sin(rad)});
    }
    return points;
  }

  function updateCharts(degrees, radians, radiusVal) {
    if (!isFinite(degrees)) return;

    var normalizedDeg = ((degrees % 360) + 360) % 360;
    var rad = radians;
    var cosVal = Math.cos(rad);
    var sinVal = Math.sin(rad);
    var tanVal = Math.tan(rad);

    // Update Unit Circle
    unitCircleChart.data.datasets[1].data = [
      {x: 0, y: 0},
      {x: cosVal, y: sinVal}
    ];
    unitCircleChart.data.datasets[2].data = [{x: cosVal, y: sinVal}];
    unitCircleChart.update('none');

    // Update Angle Distribution
    var remaining = 360 - normalizedDeg;
    angleChart.data.datasets[0].data = [normalizedDeg, remaining];
    angleChart.update('none');

    // Update Trigonometric Values
    trigChart.data.datasets[0].data = [
      round(sinVal, 3),
      round(cosVal, 3),
      Math.abs(tanVal) > 10 ? (tanVal > 0 ? 10 : -10) : round(tanVal, 3)
    ];
    trigChart.update('none');

    // Update Arc Length Chart
    if (isFinite(radiusVal) && radiusVal > 0) {
      var arcData = [];
      var arcLabels = [];
      for (var i = 0; i <= normalizedDeg; i += Math.max(1, Math.floor(normalizedDeg / 7))) {
        arcLabels.push(i + '°');
        arcData.push(round(radiusVal * (i * Math.PI / 180), 2));
      }
      if (arcLabels[arcLabels.length - 1] !== normalizedDeg + '°') {
        arcLabels.push(normalizedDeg + '°');
        arcData.push(round(radiusVal * rad, 2));
      }
      arcChart.data.labels = arcLabels;
      arcChart.data.datasets[0].data = arcData;
      arcChart.update('none');
    }
  }

  function convert(){
    var d=num(deg.value), r=num(rad.value), R=num(radius.value);
    if(isFinite(d)){ r=d*Math.PI/180; }
    if(isFinite(rad.value) && !isFinite(d)) { d=r*180/Math.PI; }
    oRad.textContent=isFinite(r)?round(r):'—';
    oDeg.textContent=isFinite(d)?round(d):'—';
    oArc.textContent=(isFinite(R)&&isFinite(r))?round(R*r):'—';

    if(isFinite(d) && isFinite(r)) {
      updateCharts(d, r, R);
    }
  }

  function randomize(){
    deg.value=String(Math.floor(Math.random()*360));
    rad.value='';
    radius.value=String(Math.floor(Math.random()*20)+5);
    convert();
  }

  function reset() {
    deg.value=rad.value=radius.value='';
    oRad.textContent=oDeg.textContent=oArc.textContent='—';
    // Reset charts to default
    updateCharts(45, Math.PI/4, 5);
  }

  document.getElementById('btnConvert').addEventListener('click', convert);
  document.getElementById('btnReset').addEventListener('click', reset);
  document.getElementById('btnRandom').addEventListener('click', randomize);

  // Initialize charts on page load
  window.addEventListener('load', function() {
    initCharts();
    // Set default values
    deg.value = '45';
    radius.value = '5';
    convert();
  });
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
