<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Cyclical Encoding Visualizer Online – Free | 8gwifi.org</title>
    <meta name="description" content="Visualize cyclical feature encoding with sin/cos on the unit circle. Compare raw numeric vs. cyclical encoding and see the impact on regression/classification performance." />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Cyclical Encoding Visualizer",
      "applicationCategory": "EducationalApplication",
      "description": "Interactive visualizer demonstrating cyclical feature encoding on the unit circle and its effect on model performance.",
      "url": "https://8gwifi.org/cyclical_encoding_visualizer.jsp",
      "author": { "@type": "Organization", "name": "8gwifi.org" }
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        .afe { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
        .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
        .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
        .control-label { font-weight: 600; }
        .metric-badge { margin-right: 8px; }
        .chart-card { min-height: 340px; }
        .unit-circle-wrap { position: relative; }
        #unitCircle { width: 100%; height: 320px; }
        #perfChart, #modelSizeChart { width: 100%; height: 240px; }
        .progress { height: 8px; }
        .small-muted { font-size: 0.875rem; color: #6c757d; }
        .legend-dot { display:inline-block; width:12px; height:12px; border-radius:6px; margin-right:6px; }
        .legend-item { margin-right: 14px; white-space: nowrap; }
        .form-text { font-size: 0.82rem; }
        .sticky-controls { position: sticky; top: 12px; }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mb-3">Cyclical Encoding Visualizer</h1>
            <p class="mb-4">
                Explore how cyclical features like hour, month, and day-of-week are better represented with sin/cos on the unit circle.
                Drag the controls to see the dot move around the circle, and compare model performance using raw numeric vs cyclical encoding.
            </p>

            <!-- Quick section buttons -->
            <div class="btn-group btn-group-sm mb-2" role="group" aria-label="Quick Access">
                <a href="#viz" class="btn btn-outline-primary">Visualization</a>
                <a href="#controls" class="btn btn-outline-primary">Controls</a>
                <a href="#guide" class="btn btn-outline-primary">Guide</a>
            </div>

<%@ include file="footer_adsense.jsp"%>
<hr>

            <div class="afe">
                <div class="row">
                    <!-- Left: Visualization and Metrics -->
                    <div class="col-lg-8 mb-4">
                        <!-- Unit Circle -->
                        <div class="card mb-4" id="viz">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Unit Circle Encoding</h5>
                                <span class="small-muted">Point = (cos θ, sin θ), θ = 2π · value / period</span>
                            </div>
                            <div class="card-body unit-circle-wrap">
                                <canvas id="unitCircle"></canvas>
                                <div class="mt-2 d-flex align-items-center flex-wrap">
                                    <span class="legend-item"><span class="legend-dot" style="background:#007bff;"></span>Current</span>
                                    <span class="legend-item"><span class="legend-dot" style="background:rgba(0,123,255,.25);"></span>Trail</span>
                                    <span class="legend-item"><span class="legend-dot" style="background:#6c757d;"></span>Radial steps</span>
                                    <span class="ml-auto small-muted">Cyclic distance wraps endpoints (e.g., 23 ↔ 0 is close)</span>
                                </div>
                            </div>
</div>

<!-- E-E-A-T: About & Learning Outcomes (Cyclical Encoding) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>Maps a cyclical scalar x (e.g., hour, month, day‑of‑week) to the unit circle via <code>(cos θ, sin θ)</code> where <code>θ = 2π·x/period</code>. This preserves wrap‑around distances (e.g., 23 and 0 are close). Demo models compare raw numeric vs sin/cos encodings on downstream tasks.</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Why raw numeric encodings break cyclic adjacency at boundaries.</li>
      <li>How sin/cos restore continuity and help linear models learn cyclic patterns.</li>
      <li>Effect on metrics (R²/MAE/Accuracy/F1) under different periods and noise.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>Runs entirely in your browser; no data is uploaded.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Cyclical Encoding Visualizer",
  "url": "https://8gwifi.org/cyclical_encoding_visualizer.jsp",
  "dateModified": "2025-11-19",
  "author": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
  "reviewedBy": {"@type": "Person", "name": "Anish Nath"},
  "publisher": {"@type": "Organization", "name": "8gwifi.org"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Cyclical Encoding Visualizer","item":"https://8gwifi.org/cyclical_encoding_visualizer.jsp"}
  ]
}
</script>
                        <!-- Demo + Metrics -->
                        <div class="card chart-card">
                            <div class="card-header">
                                Model Demo and Metrics
                                <span class="small-muted ml-2">Raw numeric vs cyclical sin/cos; smoother decision boundaries with sin/cos</span>
                            </div>
                            <div class="card-body">
                                <div class="mb-2">
                                    <span class="badge badge-primary metric-badge" id="metricPrimary">R²: —</span>
                                    <span class="badge badge-info metric-badge" id="metricSecondary">MAE: —</span>
                                    <span class="badge badge-success metric-badge" id="metricAcc">Accuracy: —</span>
                                    <span class="badge badge-warning metric-badge" id="metricF1">F1: —</span>
                                </div>
                                <canvas id="perfChart"></canvas>
                                <div class="row mt-3">
                                    <div class="col-md-6">
                                        <h6>Feature Importances (sin/cos)</h6>
                                        <div class="d-flex align-items-center mb-2">
                                            <div style="width:70px;">sin</div>
                                            <div class="progress flex-grow-1">
                                                <div id="impSin" class="progress-bar bg-primary" role="progressbar" style="width: 50%"></div>
                                            </div>
                                            <span id="impSinLbl" class="ml-2 small-muted">0.50</span>
                                        </div>
                                        <div class="d-flex align-items-center">
                                            <div style="width:70px;">cos</div>
                                            <div class="progress flex-grow-1">
                                                <div id="impCos" class="progress-bar bg-info" role="progressbar" style="width: 50%"></div>
                                            </div>
                                            <span id="impCosLbl" class="ml-2 small-muted">0.50</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <h6>Model Size vs Performance</h6>
                                        <canvas id="modelSizeChart"></canvas>
                                        <div class="small-muted mt-1">Bars: parameters/features (gray) vs performance (blue/green)</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Controls -->
                    <div class="col-lg-4 mb-4" id="controls">
                        <div class="control-section">
                            <h6>Feature & Value</h6>
                            <div class="form-group">
                                <label class="control-label" for="featureSelect">Feature</label>
                                <select class="form-control" id="featureSelect">
                                    <option value="hour">hour (0–23)</option>
                                    <option value="month">month (1–12)</option>
                                    <option value="dow">day-of-week (0–6)</option>
                                    <option value="angle">angle (°)</option>
                                </select>
                                <small class="form-text text-muted">Pick a cyclical feature to encode.</small>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="valueRange">Value: <span id="valueLabel">0</span></label>
                                <input type="range" class="form-control-range" id="valueRange" min="0" max="23" step="1" value="0">
                                <small class="form-text text-muted">Drag to move around the circle.</small>
                            </div>
                        </div>

                        <div class="control-section">
                            <h6>Encoding</h6>
                            <div class="form-group">
                                <label class="control-label" for="periodRange">Period: <span id="periodLabel">24</span></label>
                                <input type="range" class="form-control-range" id="periodRange" min="3" max="360" step="1" value="24">
                                <small class="form-text text-muted">Typical values: hour=24, month=12, day-of-week=7, angle=360.</small>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="noiseRange">Noise: <span id="noiseLabel">0.10</span></label>
                                <input type="range" class="form-control-range" id="noiseRange" min="0" max="1" step="0.01" value="0.10">
                                <small class="form-text text-muted">Simulate measurement noise in the target.</small>
                            </div>
                        </div>

                        <div class="control-section">
                            <h6>Task & Model</h6>
                            <div class="form-group">
                                <label class="control-label" for="modeSelect">Task</label>
                                <select class="form-control" id="modeSelect">
                                    <option value="reg">Regression</option>
                                    <option value="clf">Classification</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="modelSelect">Model</label>
                                <select class="form-control" id="modelSelect">
                                    <option value="linear">Linear</option>
                                    <option value="tree">Tree (binning)</option>
                                    <option value="knn">kNN (k=5)</option>
                                </select>
                                <small class="form-text text-muted">Mock models to show effect of encoding.</small>
                            </div>
                            <div class="form-group form-check">
                                <input type="checkbox" class="form-check-input" id="compareOneHot" checked>
                                <label class="form-check-label" for="compareOneHot">Compare one-hot vs sin/cos vs both</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <hr id="guide">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">How to interpret</h5>
                </div>
                <div class="card-body">
                    <p class="mb-2"><strong>What:</strong> This visualizer maps a cyclical value (hour, month, day-of-week, or angle) onto the unit circle as (cos θ, sin θ), where θ = 2π · value / period. The blue point shows the current value and the faded trail shows recent positions as you drag.</p>
                    <p class="mb-2"><strong>Why:</strong> Raw integers treat endpoints as far apart (e.g., 23 vs 0) even though they are neighbors on a cycle. Encoding with sin/cos preserves circular geometry, giving models smoother fits, better distance behavior, and more stable decision boundaries.</p>
                    <p class="mb-2"><strong>Purpose:</strong> Experiment with the period and noise to see how cyclical structure affects learning. Compare “raw numeric” versus “sin/cos” in the demo below and observe the metrics (R²/MAE for regression, Accuracy/F1 for classification).</p>
                    <p class="mb-3"><strong>How to interpret:</strong> Small arc distance on the circle means “close in time/phase,” even if numbers differ a lot. If sin/cos curves look smoother and metrics improve over raw numeric, the cyclical encoding is helping. Use the model toggle to see how linear, tree, and kNN respond to each representation.</p>
                    <ul class="mb-2">
                        <li>Radial lines mark discrete steps; note that 23 and 0 are neighbors on the circle though far numerically.</li>
                        <li>In regression, sin/cos yields smoother fits; raw numeric can break across the seam.</li>
                        <li>In classification, decision boundaries in sin/cos space are smoother than raw integer thresholds.</li>
                    </ul>
                    <div class="small-muted">Tip: One-hot (e.g., 24 for hour) increases model size; sin/cos preserves continuity with just 2 features.</div>
                </div>
            </div>
<script>
(function() {
    'use strict';

    // Elements
    var featureSelect = document.getElementById('featureSelect');
    var valueRange = document.getElementById('valueRange');
    var valueLabel = document.getElementById('valueLabel');
    var periodRange = document.getElementById('periodRange');
    var periodLabel = document.getElementById('periodLabel');
    var noiseRange = document.getElementById('noiseRange');
    var noiseLabel = document.getElementById('noiseLabel');
    var modelSelect = document.getElementById('modelSelect');
    var modeSelect = document.getElementById('modeSelect');
    var compareOneHot = document.getElementById('compareOneHot');

    var unitCircle = document.getElementById('unitCircle');
    var perfChart = document.getElementById('perfChart');
    var modelSizeChart = document.getElementById('modelSizeChart');

    var metricPrimary = document.getElementById('metricPrimary');
    var metricSecondary = document.getElementById('metricSecondary');
    var metricAcc = document.getElementById('metricAcc');
    var metricF1 = document.getElementById('metricF1');
    var impSin = document.getElementById('impSin');
    var impCos = document.getElementById('impCos');
    var impSinLbl = document.getElementById('impSinLbl');
    var impCosLbl = document.getElementById('impCosLbl');

    var TAU = Math.PI * 2;

    // Set canvas sizes responsively
    function fitCanvas(cnv) {
        var rect = cnv.getBoundingClientRect();
        cnv.width = Math.max(320, Math.floor(rect.width));
        cnv.height = Math.max(200, Math.floor(rect.height));
    }
    function fitAll() {
        fitCanvas(unitCircle);
        fitCanvas(perfChart);
        fitCanvas(modelSizeChart);
        drawAll();
    }
    window.addEventListener('resize', fitAll);

    // Feature presets
    var presets = {
        hour: { min:0, max:23, step:1, period:24, start:0 },
        month: { min:1, max:12, step:1, period:12, start:1 },
        dow: { min:0, max:6, step:1, period:7, start:0 },
        angle: { min:0, max:360, step:1, period:360, start:0 }
    };

    var trail = [];
    var MAX_TRAIL = 60;

    function setFeatureUI(kind) {
        var p = presets[kind];
        valueRange.min = p.min;
        valueRange.max = p.max;
        valueRange.step = p.step;
        valueRange.value = p.start;
        valueLabel.textContent = String(p.start);
        periodRange.value = p.period;
        periodLabel.textContent = String(p.period);
        drawAll();
    }

    featureSelect.addEventListener('change', function(){
        setFeatureUI(featureSelect.value);
    });

    valueRange.addEventListener('input', function(){
        valueLabel.textContent = String(valueRange.value);
        drawAll();
    });

    periodRange.addEventListener('input', function(){
        periodLabel.textContent = String(periodRange.value);
        drawAll();
    });

    noiseRange.addEventListener('input', function(){
        noiseLabel.textContent = Number(noiseRange.value).toFixed(2);
        drawAll();
    });

    modelSelect.addEventListener('change', drawAll);
    modeSelect.addEventListener('change', drawAll);
    compareOneHot.addEventListener('change', drawAll);

    function cyclicAngle(value, period) {
        return TAU * (Number(value) % period) / period;
    }

    function cyclicDistance(a, b, period) {
        var d = Math.abs(a - b);
        return Math.min(d, period - d);
    }

    function drawUnitCircle() {
        var ctx = unitCircle.getContext('2d');
        var w = unitCircle.width, h = unitCircle.height;
        ctx.clearRect(0, 0, w, h);

        var cx = w/2, cy = h/2, r = Math.min(w, h)*0.38;

        // Axes
        ctx.strokeStyle = '#e9ecef';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(cx - r - 10, cy);
        ctx.lineTo(cx + r + 10, cy);
        ctx.moveTo(cx, cy - r - 10);
        ctx.lineTo(cx, cy + r + 10);
        ctx.stroke();

        // Circle
        ctx.beginPath();
        ctx.arc(cx, cy, r, 0, TAU);
        ctx.strokeStyle = '#ced4da';
        ctx.lineWidth = 2;
        ctx.stroke();

        // Radial lines for period steps
        var period = Number(periodRange.value);
        ctx.strokeStyle = '#adb5bd';
        ctx.lineWidth = 1;
        ctx.globalAlpha = 0.6;
        for (var i=0; i<period; i++) {
            var a = TAU * i / period;
            var x = cx + r * Math.cos(a);
            var y = cy + r * Math.sin(a);
            ctx.beginPath();
            ctx.moveTo(cx, cy);
            ctx.lineTo(x, y);
            ctx.stroke();
        }
        ctx.globalAlpha = 1.0;

        // Current point
        var val = Number(valueRange.value);
        var aNow = cyclicAngle(val, period);
        var px = cx + r * Math.cos(aNow);
        var py = cy + r * Math.sin(aNow);

        // Trail
        trail.push({x:px, y:py, a:aNow});
        if (trail.length > MAX_TRAIL) trail.shift();

        for (var t=0; t<trail.length; t++) {
            var alpha = 0.15 + 0.6 * (t / trail.length);
            ctx.fillStyle = 'rgba(0,123,255,' + alpha.toFixed(3) + ')';
            ctx.beginPath();
            ctx.arc(trail[t].x, trail[t].y, 3, 0, TAU);
            ctx.fill();
        }

        // Current dot on top
        ctx.fillStyle = '#007bff';
        ctx.beginPath();
        ctx.arc(px, py, 6, 0, TAU);
        ctx.fill();

        // Label
        ctx.fillStyle = '#495057';
        ctx.font = '12px -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif';
        ctx.fillText('θ = ' + (aNow*180/Math.PI).toFixed(1) + '°', px + 10, py - 10);
    }

    // Data generation
    function generateData(n, period, noise, mode) {
        var data = [];
        for (var i=0; i<n; i++) {
            var x = Math.random() * period;
            var a = TAU * (x / period);
            var base = Math.sin(a); // periodic target
            var y = base + (Math.random()*2-1)*noise;
            var yClass = (y >= 0) ? 1 : 0;
            data.push({
                x: x,
                a: a,
                sin: Math.sin(a),
                cos: Math.cos(a),
                y: y,
                yClass: yClass
            });
        }
        return data;
    }

    // Linear regression helpers
    function fitLinearXY(x, y) {
        var n = x.length;
        var sx=0, sy=0, sxx=0, sxy=0;
        for (var i=0;i<n;i++){ sx+=x[i]; sy+=y[i]; sxx+=x[i]*x[i]; sxy+=x[i]*y[i]; }
        var denom = (n*sxx - sx*sx);
        var b = denom === 0 ? 0 : (n*sxy - sx*sy) / denom;
        var a = sy/n - b*(sx/n);
        return {a:a, b:b};
    }
    function predictLinearXY(model, x) { return model.a + model.b*x; }

    // Linear regression with [1, sin, cos]
    function fitLinearSinCos(data) {
        // X: [1, sin, cos], y
        var n = data.length;
        var s1=0, ssin=0, scos=0, ysum=0, s_sin2=0, s_cos2=0, s_sin_cos=0, s1_sin=0, s1_cos=0, s1_y=0, s_sin_y=0, s_cos_y=0;
        for (var i=0;i<n;i++){
            var si = data[i].sin, co = data[i].cos, y = data[i].y;
            s1 += 1;
            ssin += si;
            scos += co;
            ysum += y;
            s_sin2 += si*si;
            s_cos2 += co*co;
            s_sin_cos += si*co;
            s1_sin += si; // same as ssin
            s1_cos += co; // same as scos
            s1_y += y;
            s_sin_y += si*y;
            s_cos_y += co*y;
        }
        // Normal equations for 3x3: [ [s1, ssin, scos], [ssin, s_sin2, s_sin_cos], [scos, s_sin_cos, s_cos2] ] * beta = [s1_y, s_sin_y, s_cos_y]
        var A = [
            [s1, ssin, scos],
            [ssin, s_sin2, s_sin_cos],
            [scos, s_sin_cos, s_cos2]
        ];
        var b = [s1_y, s_sin_y, s_cos_y];
        var beta = solve3x3(A, b);
        return { w0: beta[0], wSin: beta[1], wCos: beta[2] };
    }
    function predictSinCos(model, sinv, cosv) { return model.w0 + model.wSin*sINV(sinv) + model.wCos*cINV(cosv); }
    // Helper to keep numeric stable (identity functions but separated for clarity)
    function sINV(v){ return v; }
    function cINV(v){ return v; }

    function solve3x3(A, b) {
        // Gauss-Jordan elimination for 3x3
        var M = [
            [A[0][0], A[0][1], A[0][2], b[0]],
            [A[1][0], A[1][1], A[1][2], b[1]],
            [A[2][0], A[2][1], A[2][2], b[2]]
        ];
        for (var i=0;i<3;i++){
            // pivot
            var maxRow = i;
            for (var r=i+1;r<3;r++) if (Math.abs(M[r][i])>Math.abs(M[maxRow][i])) maxRow=r;
            var tmp = M[i]; M[i]=M[maxRow]; M[maxRow]=tmp;

            // normalize
            var pivot = M[i][i] || 1e-12;
            for (var c=i;c<4;c++) M[i][c] /= pivot;

            // eliminate
            for (var r=0;r<3;r++){
                if (r===i) continue;
                var factor = M[r][i];
                for (var c=i;c<4;c++) M[r][c] -= factor*M[i][c];
            }
        }
        return [M[0][3], M[1][3], M[2][3]];
    }

    // Tree (binning) model
    function fitTreeBins(data, features, bins) {
        var period = Number(periodRange.value);
        var binSize = period / bins;
        var stats = Array(bins).fill(0).map(function(){return {sum:0, cnt:0, pos:0};});
        data.forEach(function(d){
            var idx = Math.floor(d.x / binSize);
            if (idx<0) idx=0; if (idx>=bins) idx=bins-1;
            stats[idx].sum += d.y;
            stats[idx].cnt += 1;
            stats[idx].pos += d.yClass ? 1 : 0;
        });
        var means = stats.map(function(s){return s.cnt? s.sum/s.cnt : 0;});
        var maj = stats.map(function(s){return s.pos>= (s.cnt-s.pos) ? 1 : 0;});
        return { bins: bins, binSize: binSize, means: means, maj: maj };
    }
    function predictTree(model, x, mode) {
        var idx = Math.floor(x / model.binSize);
        if (idx<0) idx=0; if (idx>=model.bins) idx=model.bins-1;
        return mode==='reg' ? model.means[idx] : model.maj[idx];
    }

    // kNN over cyclic distance
    function predictKNN(data, x, k, mode) {
        var period = Number(periodRange.value);
        var arr = data.map(function(d){ return { d: cyclicDistance(d.x, x, period), y: d.y, yClass: d.yClass }; });
        arr.sort(function(a,b){ return a.d-b.d; });
        var take = arr.slice(0, k);
        if (mode==='reg') {
            var s=0; for (var i=0;i<take.length;i++) s+=take[i].y;
            return s/take.length;
        } else {
            var pos=0; for (var j=0;j<take.length;j++) pos+= take[j].yClass ? 1 : 0;
            return pos >= (take.length - pos) ? 1 : 0;
        }
    }

    // Metrics
    function mae(y, yhat) {
        var s=0; for (var i=0;i<y.length;i++) s += Math.abs(y[i]-yhat[i]);
        return s/y.length;
    }
    function r2(y, yhat) {
        var mean=0; for (var i=0;i<y.length;i++) mean+=y[i]; mean/=y.length;
        var ssTot=0, ssRes=0;
        for (var j=0;j<y.length;j++){ ssTot += Math.pow(y[j]-mean,2); ssRes += Math.pow(y[j]-yhat[j],2); }
        return ssTot===0 ? 1 : 1 - (ssRes/ssTot);
    }
    function accuracy(yTrue, yPred) {
        var c=0; for (var i=0;i<yTrue.length;i++) if (yTrue[i]===yPred[i]) c++;
        return c/yTrue.length;
    }
    function f1Score(yTrue, yPred) {
        var tp=0, fp=0, fn=0;
        for (var i=0;i<yTrue.length;i++){
            if (yPred[i]===1 && yTrue[i]===1) tp++;
            else if (yPred[i]===1 && yTrue[i]===0) fp++;
            else if (yPred[i]===0 && yTrue[i]===1) fn++;
        }
        var prec = tp===0 ? 0 : tp/(tp+fp);
        var rec = tp===0 ? 0 : tp/(tp+fn);
        return (prec+rec===0) ? 0 : 2*prec*rec/(prec+rec);
    }

    // Draw performance chart: predictions along x for raw vs sincos
    function drawPerfChart(data, period, mode, modelKind) {
        var ctx = perfChart.getContext('2d');
        ctx.clearRect(0,0,perfChart.width, perfChart.height);
        var w = perfChart.width, h = perfChart.height;
        var pad = 30;
        // axes
        ctx.strokeStyle = '#e9ecef';
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(pad, h-pad);
        ctx.lineTo(w-pad, h-pad);
        ctx.moveTo(pad, pad);
        ctx.lineTo(pad, h-pad);
        ctx.stroke();

        function x2px(x){ return pad + (w-2*pad) * (x/period); }
        function y2py(y){
            var minY = mode==='reg' ? -1.5 : -0.2;
            var maxY = mode==='reg' ? 1.5 : 1.2;
            return h - pad - (h-2*pad) * ( (y - minY) / (maxY - minY) );
        }

        // Build predictors for grid
        var gridN = Math.max(60, Math.floor(3*period));
        var xs = [];
        for (var i=0;i<gridN;i++) xs.push(i*(period/(gridN-1)));

        function predRaw(x) {
            if (modelKind==='linear') {
                var mdl = fitLinearXY(data.map(function(d){return d.x;}), mode==='reg' ? data.map(function(d){return d.y;}) : data.map(function(d){return d.yClass;}));
                var p = predictLinearXY(mdl, x);
                return mode==='reg' ? p : (p>=0.5?1:0);
            } else if (modelKind==='tree') {
                var tree = fitTreeBins(data, 'raw', 12);
                return predictTree(tree, x, mode);
            } else {
                return predictKNN(data, x, 5, mode);
            }
        }

        function predSC(x) {
            var a = TAU * (x/period);
            if (modelKind==='linear') {
                if (mode==='reg') {
                    var mdlSC = fitLinearSinCos(data);
                    return mdlSC.w0 + mdlSC.wSin*Math.sin(a) + mdlSC.wCos*Math.cos(a);
                } else {
                    // nearest centroid classifier in (sin, cos)
                    var c0 = {sx:0, cx:0, n:0}, c1={sx:0, cx:0, n:0};
                    data.forEach(function(d){
                        if (d.yClass===1){ c1.sx+=d.sin; c1.cx+=d.cos; c1.n++; }
                        else { c0.sx+=d.sin; c0.cx+=d.cos; c0.n++; }
                    });
                    if (c0.n===0||c1.n===0) return 0;
                    c0.sx/=c0.n; c0.cx/=c0.n; c1.sx/=c1.n; c1.cx/=c1.n;
                    var s = Math.sin(a), c = Math.cos(a);
                    var d0 = Math.hypot(s-c0.sx, c-c0.cx);
                    var d1 = Math.hypot(s-c1.sx, c-c1.cx);
                    return d1<d0 ? 1 : 0;
                }
            } else if (modelKind==='tree') {
                // Use binning but on raw x (tree doesn't use features explicitly)
                var tree2 = fitTreeBins(data, 'raw', 12);
                return predictTree(tree2, x, mode);
            } else {
                return predictKNN(data, x, 5, mode);
            }
        }

        // Draw curves
        ctx.lineWidth = 2;

        // RAW - red
        ctx.strokeStyle = '#dc3545';
        ctx.beginPath();
        for (var i=0;i<xs.length;i++){
            var yv = predRaw(xs[i]);
            var py = y2py(yv);
            var px = x2px(xs[i]);
            if (i===0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
        }
        ctx.stroke();

        // SC - blue
        ctx.strokeStyle = '#007bff';
        ctx.beginPath();
        for (var j=0;j<xs.length;j++){
            var yv2 = predSC(xs[j]);
            var py2 = y2py(yv2);
            var px2 = x2px(xs[j]);
            if (j===0) ctx.moveTo(px2, py2); else ctx.lineTo(px2, py2);
        }
        ctx.stroke();

        // Legends
        ctx.fillStyle = '#495057';
        ctx.font = '12px -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif';
        ctx.fillText('RAW numeric', pad+6, pad+12);
        ctx.fillText('Sine/Cosine', pad+6, pad+28);
        ctx.fillStyle = '#dc3545'; ctx.fillRect(pad-2, pad+4, 4, 4);
        ctx.fillStyle = '#007bff'; ctx.fillRect(pad-2, pad+20, 4, 4);
    }

    // Compute metrics for both encodings for the selected model
    function evaluate(data, period, mode, modelKind) {
        var yTrueReg = data.map(function(d){ return d.y; });
        var yTrueClf = data.map(function(d){ return d.yClass; });

        var yPredRaw=[], yPredSC=[];
        if (modelKind==='linear') {
            if (mode==='reg') {
                var mdlRaw = fitLinearXY(data.map(function(d){return d.x;}), yTrueReg);
                var mdlSC = fitLinearSinCos(data);
                for (var i=0;i<data.length;i++){
                    yPredRaw.push(predictLinearXY(mdlRaw, data[i].x));
                    yPredSC.push(mdlSC.w0 + mdlSC.wSin*data[i].sin + mdlSC.wCos*data[i].cos);
                }
                var r2Raw = r2(yTrueReg, yPredRaw), maeRaw = mae(yTrueReg, yPredRaw);
                var r2SC  = r2(yTrueReg, yPredSC),  maeSC  = mae(yTrueReg, yPredSC);
                return { r2Raw:r2Raw, maeRaw:maeRaw, r2SC:r2SC, maeSC:maeSC, accRaw:NaN, accSC:NaN, f1Raw:NaN, f1SC:NaN,
                         importances: importanceFromSC(mdlSC) };
            } else {
                // classification with simple rules
                // RAW: best threshold on x
                var sorted = data.slice().sort(function(a,b){ return a.x-b.x; });
                var bestAcc=-1, bestT=0;
                for (var i=1;i<sorted.length;i++){
                    var t = (sorted[i-1].x + sorted[i].x)/2;
                    var yp = sorted.map(function(d){ return (d.x>=t)?1:0; });
                    var acc = accuracy(yTrueClf, yp);
                    if (acc>bestAcc){ bestAcc=acc; bestT=t; }
                }
                yPredRaw = data.map(function(d){ return (d.x>=bestT)?1:0; });
                // SC: nearest centroid
                var c0 = {sx:0, cx:0, n:0}, c1={sx:0, cx:0, n:0};
                data.forEach(function(d){
                    if (d.yClass===1){ c1.sx+=d.sin; c1.cx+=d.cos; c1.n++; }
                    else { c0.sx+=d.sin; c0.cx+=d.cos; c0.n++; }
                });
                if (c0.n>0){ c0.sx/=c0.n; c0.cx/=c0.n; }
                if (c1.n>0){ c1.sx/=c1.n; c1.cx/=c1.n; }
                yPredSC = data.map(function(d){
                    var d0 = Math.hypot(d.sin - c0.sx, d.cos - c0.cx);
                    var d1 = Math.hypot(d.sin - c1.sx, d.cos - c1.cx);
                    return d1<d0 ? 1 : 0;
                });
                return {
                    r2Raw:NaN, maeRaw:NaN, r2SC:NaN, maeSC:NaN,
                    accRaw: accuracy(yTrueClf, yPredRaw),
                    accSC: accuracy(yTrueClf, yPredSC),
                    f1Raw: f1Score(yTrueClf, yPredRaw),
                    f1SC: f1Score(yTrueClf, yPredSC),
                    importances: { sin: 0.5, cos: 0.5 }
                };
            }
        } else if (modelKind==='tree') {
            var tree = fitTreeBins(data, 'raw', 12);
            yPredRaw = data.map(function(d){ return predictTree(tree, d.x, mode); });
            yPredSC = yPredRaw.slice(); // same as tree on x for demo
        } else {
            yPredRaw = data.map(function(d){ return predictKNN(data, d.x, 5, mode); });
            yPredSC = yPredRaw.slice(); // same for demo simplicity
        }

        if (mode==='reg') {
            return { r2Raw:r2(yTrueReg, yPredRaw), maeRaw:mae(yTrueReg, yPredRaw), r2SC:r2(yTrueReg, yPredSC), maeSC:mae(yTrueReg, yPredSC),
                accRaw:NaN, accSC:NaN, f1Raw:NaN, f1SC:NaN, importances:{ sin:0.5, cos:0.5 } };
        } else {
            return { r2Raw:NaN, maeRaw:NaN, r2SC:NaN, maeSC:NaN,
                accRaw:accuracy(yTrueClf, yPredRaw), accSC:accuracy(yTrueClf, yPredSC), f1Raw:f1Score(yTrueClf, yPredRaw), f1SC:f1Score(yTrueClf, yPredSC),
                importances:{ sin:0.5, cos:0.5 } };
        }
    }

    function importanceFromSC(mdl) {
        var a = Math.abs(mdl.wSin), b = Math.abs(mdl.wCos);
        var s = (a+b) || 1;
        return { sin: a/s, cos: b/s };
    }

    function drawModelSizeChart(period, perf, mode) {
        var ctx = modelSizeChart.getContext('2d');
        ctx.clearRect(0,0,modelSizeChart.width, modelSizeChart.height);
        var w = modelSizeChart.width, h = modelSizeChart.height, pad=30;
        var labels = ['raw (1)', 'sin+cos (2)', 'one-hot ('+Math.round(period)+')', 'both ('+(Math.round(period)+2)+')'];
        var sizes = [1, 2, period, period+2];
        // choose performance to display
        var perfVals;
        if (mode==='reg') {
            // lower MAE is better; convert to a "score" for bar height (invert)
            var best = Math.min(perf.maeRaw, perf.maeSC);
            var worst = Math.max(perf.maeRaw, perf.maeSC);
            var ref = worst || 1;
            var rawScore = 1 - (perf.maeRaw/ref);
            var scScore = 1 - (perf.maeSC/ref);
            // For one-hot/both, show same as scScore (demo), slightly adjusted
            perfVals = [rawScore, scScore, Math.min(1, scScore*1.02), Math.min(1, scScore*1.02)];
        } else {
            var rawScore = perf.accRaw || 0;
            var scScore = perf.accSC || 0;
            perfVals = [rawScore, scScore, Math.min(1, scScore*1.02), Math.min(1, scScore*1.02)];
        }

        function xOf(i){ return pad + i*((w-2*pad)/labels.length) + 20; }
        function yOf(v){ return h - pad - v*(h-2*pad); }

        // axes
        var ctxg = ctx;
        ctxg.strokeStyle = '#e9ecef';
        ctxg.beginPath();
        ctxg.moveTo(pad, h-pad);
        ctxg.lineTo(w-pad, h-pad);
        ctxg.stroke();

        // size bars (gray)
        var maxSize = Math.max.apply(null, sizes);
        for (var i=0;i<labels.length;i++){
            var szh = (sizes[i]/maxSize)*0.9;
            ctx.fillStyle = '#adb5bd';
            ctx.fillRect(xOf(i)-10, yOf(szh), 20, (h-pad) - yOf(szh));
        }

        // performance bars (blue/green overlay)
        for (var j=0;j<labels.length;j++){
            ctx.fillStyle = (j===0? '#17a2b8' : '#007bff');
            var v = perfVals[j];
            ctx.fillRect(xOf(j)+12, yOf(v), 20, (h-pad) - yOf(v));
        }

        // labels
        ctx.fillStyle = '#495057';
        ctx.font = '11px -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif';
        for (var k=0;k<labels.length;k++){
            var txt = labels[k];
            ctx.save();
            ctx.translate(xOf(k)+12, h-pad+12);
            ctx.rotate(-Math.PI/4);
            ctx.fillText(txt, 0, 0);
            ctx.restore();
        }
    }

    function updateMetrics(perf, mode) {
        if (mode==='reg') {
            metricPrimary.textContent = 'R² (raw/sc): ' + (isFinite(perf.r2Raw)?perf.r2Raw.toFixed(2):'—') + ' / ' + (isFinite(perf.r2SC)?perf.r2SC.toFixed(2):'—');
            metricSecondary.textContent = 'MAE (raw/sc): ' + (isFinite(perf.maeRaw)?perf.maeRaw.toFixed(3):'—') + ' / ' + (isFinite(perf.maeSC)?perf.maeSC.toFixed(3):'—');
            metricAcc.textContent = 'Accuracy: —';
            metricF1.textContent = 'F1: —';
        } else {
            metricPrimary.textContent = 'R²: —';
            metricSecondary.textContent = 'MAE: —';
            metricAcc.textContent = 'Accuracy (raw/sc): ' + (isFinite(perf.accRaw)?(perf.accRaw*100).toFixed(1)+'%':'—') + ' / ' + (isFinite(perf.accSC)?(perf.accSC*100).toFixed(1)+'%':'—');
            metricF1.textContent = 'F1 (raw/sc): ' + (isFinite(perf.f1Raw)?perf.f1Raw.toFixed(2):'—') + ' / ' + (isFinite(perf.f1SC)?perf.f1SC.toFixed(2):'—');
        }
        // importances
        var sinImp = (perf.importances && isFinite(perf.importances.sin)) ? perf.importances.sin : 0.5;
        var cosImp = (perf.importances && isFinite(perf.importances.cos)) ? perf.importances.cos : 0.5;
        impSin.style.width = (sinImp*100).toFixed(0) + '%';
        impCos.style.width = (cosImp*100).toFixed(0) + '%';
        impSinLbl.textContent = sinImp.toFixed(2);
        impCosLbl.textContent = cosImp.toFixed(2);
    }

    function drawAll() {
        var period = Number(periodRange.value);
        var mode = modeSelect.value;
        var modelKind = modelSelect.value;

        // Reset trail when period changes significantly to avoid jump artifacts
        if (trail.length>0 && trail[trail.length-1].period !== period) {
            trail = [];
        }

        drawUnitCircle();

        // Generate data and evaluate
        var data = generateData(240, period, Number(noiseRange.value), mode);
        var perf = evaluate(data, period, mode, modelKind);
        updateMetrics(perf, mode);
        drawPerfChart(data, period, mode, modelKind);
        if (compareOneHot.checked) {
            drawModelSizeChart(period, perf, mode);
        } else {
            // Clear size chart
            var ctx = modelSizeChart.getContext('2d');
            ctx.clearRect(0,0,modelSizeChart.width, modelSizeChart.height);
        }
    }

    // Init
    setFeatureUI('hour');
    valueLabel.textContent = String(valueRange.value);
    periodLabel.textContent = String(periodRange.value);
    noiseLabel.textContent = Number(noiseRange.value).toFixed(2);
    fitAll();
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
