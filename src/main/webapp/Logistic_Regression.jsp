<%--
  Created by IntelliJ IDEA.
  User: anish
  Date: 18/10/25
  Time: 12:00 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Meta Tags for SEO -->
<meta name="description" content="Interactive Logistic Regression visualization tool. Learn binary classification with hands-on gradient descent, decision boundaries, and confusion matrix analysis.">
<meta name="keywords" content="logistic regression, binary classification, machine learning, gradient descent, decision boundary, confusion matrix, sigmoid function">
<title>Interactive Logistic Regression Demo - Machine Learning Tool</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Interactive Logistic Regression Demo",
  "description": "Interactive tool for learning and visualizing logistic regression with decision boundaries and gradient descent",
  "url": "https://8gwifi.org/Logistic_Regression.jsp",
  "keywords": "logistic regression, binary classification, machine learning, gradient descent, decision boundary, sigmoid"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<style>
    /* Scoped styles for Logistic Regression demo - doesn't override site Bootstrap */
    .logreg-demo .chart-container {
        background: #f8f9fa;
        border: 2px solid #dee2e6;
        border-radius: 8px;
        padding: 20px;
        margin: 15px 0;
    }
    .logreg-demo .control-group {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        padding: 15px;
        margin: 10px 0;
    }
    .logreg-demo .control-group label {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        font-weight: 500;
    }
    .logreg-demo input[type=range] {
        width: 100%;
    }
    .logreg-demo input[type=number] {
        width: 110px;
    }
    .logreg-demo .kpi-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 10px;
        margin: 15px 0;
    }
    .logreg-demo .kpi-card {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        padding: 12px;
        text-align: center;
    }
    .logreg-demo .kpi-label {
        color: #6c757d;
        font-size: 12px;
        font-weight: 500;
        margin-bottom: 5px;
    }
    .logreg-demo .kpi-value {
        font-family: 'Courier New', monospace;
        font-size: 18px;
        font-weight: bold;
        color: #212529;
    }
    .logreg-demo .legend {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
        font-size: 13px;
        margin: 10px 0;
    }
    .logreg-demo .dot {
        display: inline-block;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        margin-right: 5px;
    }
    .logreg-demo .dot.pos { background: #28a745; }
    .logreg-demo .dot.neg { background: #dc3545; }
    .logreg-demo .pill {
        background: #e7f3ff;
        border: 1px solid #b3d9ff;
        padding: 2px 8px;
        border-radius: 4px;
        font-family: 'Courier New', monospace;
        font-size: 13px;
    }
  </style>
</head>
<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Interactive Logistic Regression</h1>
<p>Binary classifier with decision boundary σ(w·x + b), where σ is the sigmoid. Click the chart to add points; toggle class with the switch.</p>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="logreg-demo">
  <!-- All Charts on Left, All Controls on Right -->
  <div class="row">
    <!-- Left: All Charts Stacked -->
    <div class="col-lg-8 mb-4">
      <!-- Dataset & Decision Boundary Chart -->
      <div class="card mb-4">
        <div class="card-header">
          <h5 class="mb-0">Dataset & Decision Boundary</h5>
        </div>
        <div class="card-body">
          <div class="chart-container">
            <div style="height: 400px;">
              <canvas id="chart"></canvas>
            </div>
          </div>
          <div class="d-flex justify-content-between align-items-center flex-wrap mt-3">
            <div class="legend">
              <span><span class="dot pos"></span> Class 1</span>
              <span><span class="dot neg"></span> Class 0</span>
              <span>Decision boundary: w₀·x + w₁·y + b = 0</span>
            </div>
            <div>
              <button id="btnExport" class="btn btn-secondary btn-sm">Download PNG</button>
              <button id="btnClear" class="btn btn-danger btn-sm">Clear points</button>
            </div>
          </div>
          <div class="row mt-3">
            <div class="col-md-6">
              <div class="form-check">
                <input type="checkbox" id="showField" class="form-check-input">
                <label class="form-check-label small" for="showField">Show probability field</label>
              </div>
            </div>
            <div class="col-md-6">
              <small><span class="pill" id="probeReadout">x=—, y=—, z=—, p=—</span></small>
            </div>
          </div>
        </div>
      </div>

      <!-- ROC Curve Chart -->
      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">ROC Curve</h5>
          <button id="btnExportROC" class="btn btn-secondary btn-sm">Download PNG</button>
        </div>
        <div class="card-body">
          <div class="chart-container">
            <div style="height: 300px;">
              <canvas id="chartROC"></canvas>
            </div>
          </div>
          <div class="d-flex justify-content-between align-items-center mt-2">
            <small class="text-muted">Each point = threshold. Diagonal = random (AUC 0.5)</small>
          </div>
        </div>
      </div>

      <!-- PR Curve Chart -->
      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Precision–Recall Curve</h5>
          <button id="btnExportPR" class="btn btn-secondary btn-sm">Download PNG</button>
        </div>
        <div class="card-body">
          <div class="chart-container">
            <div style="height: 300px;">
              <canvas id="chartPR"></canvas>
            </div>
          </div>
          <div class="d-flex justify-content-between align-items-center mt-2">
            <small class="text-muted">PR is more informative on imbalanced data</small>
          </div>
        </div>
      </div>

      <!-- Info Card -->
      <div class="card">
        <div class="card-header">
          <h6 class="mb-0">What's happening in this demo?</h6>
        </div>
        <div class="card-body">
          <p class="mb-2">This demo shows <strong>logistic regression</strong> learning a decision boundary to separate two classes. The model learns weights <code>w₀, w₁</code> and bias <code>b</code> such that the decision boundary is the line <code>w₀·x + w₁·y + b = 0</code>.</p>
          <p class="mb-2">Click the plot to add training points. Use the sliders to manually adjust the boundary, or click "Train" to let gradient descent find the optimal weights automatically.</p>
          <p class="mb-0">The <strong>sigmoid function</strong> converts the linear combination to a probability: <code>p = 1/(1 + e^(-(w₀·x + w₁·y + b)))</code>. Points are classified as class 1 if <code>p > τ</code> (threshold).</p>
        </div>
      </div>
    </div>

    <!-- Right: All Controls and Metrics -->
    <div class="col-lg-4 mb-4">
      <!-- Controls Card -->
      <div class="card mb-3">
        <div class="card-header">
          <h5 class="mb-0">Controls</h5>
        </div>
        <div class="card-body">
          <div class="control-group mb-2">
            <label><span>w₀ (x weight)</span><input type="number" id="w0Num" step="0.1" value="1" class="form-control form-control-sm"></label>
            <input type="range" id="w0" min="-5" max="5" step="0.01" value="1" class="form-range">
          </div>
          <div class="control-group mb-2">
            <label><span>w₁ (y weight)</span><input type="number" id="w1Num" step="0.1" value="-1" class="form-control form-control-sm"></label>
            <input type="range" id="w1" min="-5" max="5" step="0.01" value="-1" class="form-range">
          </div>
          <div class="control-group mb-2">
            <label><span>b (bias)</span><input type="number" id="bNum" step="0.1" value="0" class="form-control form-control-sm"></label>
            <input type="range" id="b" min="-5" max="5" step="0.01" value="0" class="form-range">
          </div>
          <div class="control-group mb-2">
            <label><span>Threshold τ</span><input type="number" id="thNum" step="0.01" value="0.5" class="form-control form-control-sm"></label>
            <input type="range" id="th" min="0.05" max="0.95" step="0.01" value="0.5" class="form-range">
          </div>
          <div class="control-group mb-2">
            <label><span>Learning rate η</span><input type="number" id="lrNum" step="0.001" value="0.1" class="form-control form-control-sm"></label>
            <input type="range" id="lr" min="0.001" max="1" step="0.001" value="0.1" class="form-range">
          </div>
          <div class="control-group mb-3">
            <label><span>L2 λ</span><input type="number" id="lamNum" step="0.001" value="0.0" class="form-control form-control-sm"></label>
            <input type="range" id="lam" min="0" max="0.2" step="0.001" value="0.0" class="form-range">
          </div>
          
          <div class="d-grid gap-2 mb-3">
            <button id="btnStep" class="btn btn-primary btn-sm">Train 1 step</button>
            <button id="btnStep100" class="btn btn-primary btn-sm">Train 100 steps</button>
            <button id="btnAuto" class="btn btn-success btn-sm">Auto-train ▶︎</button>
            <button id="btnResetW" class="btn btn-warning btn-sm">Reset weights</button>
          </div>
          
          <div class="mb-2">
            <label for="classSel" class="form-label small">Add class:</label>
            <select id="classSel" class="form-select form-select-sm">
              <option value="1">Class 1 (green)</option>
              <option value="0">Class 0 (red)</option>
            </select>
          </div>
          
          <div class="form-check mb-2">
            <input type="checkbox" id="recordTraces" class="form-check-input">
            <label class="form-check-label small" for="recordTraces">Record boundary steps</label>
          </div>
          
          <div class="d-grid gap-2">
            <button id="btnSeeds" class="btn btn-outline-primary btn-sm">Sample dataset</button>
            <div class="btn-group" role="group">
              <button id="btnBalanced" class="btn btn-outline-secondary btn-sm">Balanced</button>
              <button id="btnOverlap" class="btn btn-outline-secondary btn-sm">Overlap</button>
            </div>
            <div class="btn-group" role="group">
              <button id="btnImbalance" class="btn btn-outline-secondary btn-sm">Imbalanced</button>
              <button id="btnXOR" class="btn btn-outline-secondary btn-sm">XOR</button>
            </div>
            <button id="btnClearTraces" class="btn btn-outline-danger btn-sm">Clear traces</button>
          </div>
        </div>
      </div>
      
      <!-- Metrics Card -->
      <div class="card mb-3">
        <div class="card-header">
          <h6 class="mb-0">Metrics</h6>
        </div>
        <div class="card-body p-2">
          <div class="kpi-grid">
            <div class="kpi-card"><div class="kpi-label">Log loss</div><div class="kpi-value" id="kLoss">—</div></div>
            <div class="kpi-card"><div class="kpi-label">ΔLoss</div><div class="kpi-value" id="kDelta">—</div></div>
            <div class="kpi-card"><div class="kpi-label">Accuracy</div><div class="kpi-value" id="kAcc">—</div></div>
            <div class="kpi-card"><div class="kpi-label">Steps</div><div class="kpi-value" id="kSteps">0</div></div>
            <div class="kpi-card"><div class="kpi-label">N points</div><div class="kpi-value" id="kN">0</div></div>
          </div>
        </div>
      </div>
      
      <!-- Confusion Matrix Card -->
      <div class="card">
        <div class="card-header">
          <h6 class="mb-0">Confusion Matrix (@ τ)</h6>
        </div>
        <div class="card-body p-2">
          <table class="table table-bordered table-sm text-center mb-0">
            <thead>
              <tr><th></th><th>Pred 0</th><th>Pred 1</th></tr>
            </thead>
            <tbody>
              <tr><th style="text-align:left;">Actual 0</th><td id="cmTN">—</td><td id="cmFP">—</td></tr>
              <tr><th style="text-align:left;">Actual 1</th><td id="cmFN">—</td><td id="cmTP">—</td></tr>
            </tbody>
          </table>
          <small class="text-muted d-block mt-2">TN=True Neg, FP=False Pos, FN=False Neg, TP=True Pos</small>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  window.addEventListener('DOMContentLoaded', () => {
    // --- tiny toast for feedback ---
    const toast = document.createElement('div');
    Object.assign(toast.style,{position:'fixed',right:'16px',bottom:'16px',padding:'8px 10px',background:'rgba(0,0,0,.6)',color:'#fff',border:'1px solid rgba(255,255,255,.2)',borderRadius:'10px',fontSize:'12px',opacity:'0',transition:'opacity .2s'});
    document.body.appendChild(toast);
    const ping = (msg)=>{ toast.textContent = msg; toast.style.opacity='1'; setTimeout(()=>toast.style.opacity='0', 1000); };

    // helpers
    const $ = s => document.querySelector(s);
    const link = (a,b, on)=>{ a.addEventListener('input',()=>{ b.value=a.value; on&&on();}); b.addEventListener('input',()=>{ a.value=b.value; on&&on();}); };
    const randn = ()=>{ let u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); };

    // model params
    const w0=$('#w0'), w1=$('#w1'), b=$('#b');
    const w0Num=$('#w0Num'), w1Num=$('#w1Num'), bNum=$('#bNum');
    const th=$('#th'), thNum=$('#thNum');
    const lr=$('#lr'), lrNum=$('#lrNum'), lam=$('#lam'), lamNum=$('#lamNum');

    function updateAll(){ decisionLine(); metrics(); renderPoints(); updateROC(); updatePR(); if (showField.checked) updateField(); chart.update(); }
    link(w0,w0Num, updateAll); link(w1,w1Num, updateAll); link(b,bNum, updateAll); link(th,thNum, updateAll); link(lr,lrNum); link(lam,lamNum);

    const classSel=$('#classSel');
    const kLoss=$('#kLoss'), kAcc=$('#kAcc'), kN=$('#kN');
    const kDelta=$('#kDelta'), kSteps=$('#kSteps');
    const cmTN=$('#cmTN'), cmFP=$('#cmFP'), cmFN=$('#cmFN'), cmTP=$('#cmTP');
    const probe = document.getElementById('probeReadout');
    const showField = document.getElementById('showField');

    // step trace state
    let stepCount = 0;           // total gradient steps taken
    const traceStride = 5;       // record every N steps in multi-step training
    const recordTraces = document.querySelector('#recordTraces');
    const btnClearTraces = document.querySelector('#btnClearTraces');

    // auto-train state
    const btnAuto = document.getElementById('btnAuto');
    let autoTimer = null;

    // chart
    const ctx = document.getElementById('chart');
    console.log('Chart context:', ctx);
    let points = []; // {x,y,t}

    const chart = new Chart(ctx, {
      type: 'scatter',
      data: { datasets:[
        {label:'Class 0', data:[], pointRadius:5, backgroundColor:'#dc3545', order:1},
        {label:'Class 1', data:[], pointRadius:5, backgroundColor:'#28a745', order:1},
        {label:'Decision boundary', type:'line', data:[], borderWidth:2, pointRadius:0, borderDash:[6,6], parsing:false, borderColor:'#0d6efd', order:2},
        // NEW: probability field dataset (kept AFTER boundary so tests keep index 2)
        {label:'Prob field', data:[], type:'scatter', pointRadius:2, order:0,
         backgroundColor:(ctx)=>{
           const p = ctx.raw && ctx.raw.p !== undefined ? ctx.raw.p : 0; // 0..1
           return 'rgba(13,110,253,' + (p*0.25).toFixed(3) + ')';
         }, hidden:true },
      ]},
      options:{
        responsive:true, maintainAspectRatio:false,
        scales:{ x:{ min:-5,max:5, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}},
                 y:{ min:-5,max:5, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}}},
        plugins:{ legend:{ labels:{ color:'#212529'} }, tooltip:{ callbacks:{ label:(c)=> (c.raw && c.raw.x!==undefined) ? '(' + c.raw.x.toFixed(2) + ', ' + c.raw.y.toFixed(2) + ')' : '' }}}
      }
    });

    // ROC and PR charts
    const ctxROC = document.getElementById('chartROC');
    const ctxPR = document.getElementById('chartPR');
    
    const chartROC = new Chart(ctxROC, {
      type: 'line',
      data: { datasets:[
        {label:'ROC', data:[], borderWidth:2, pointRadius:0, borderColor:'#0d6efd', order:1},
        {label:'Random', data:[{x:0,y:0},{x:1,y:1}], borderWidth:1, pointRadius:0, borderDash:[5,5], borderColor:'#6c757d', order:2}
      ]},
      options:{
        responsive:true, maintainAspectRatio:false,
        scales:{ x:{ min:0,max:1, title:{display:true,text:'FPR'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}},
                 y:{ min:0,max:1, title:{display:true,text:'TPR'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}}},
        plugins:{ legend:{ labels:{ color:'#212529'} }}
      }
    });

    const chartPR = new Chart(ctxPR, {
      type: 'line',
      data: { datasets:[
        {label:'PR', data:[], borderWidth:2, pointRadius:0, borderColor:'#28a745', order:1}
      ]},
      options:{
        responsive:true, maintainAspectRatio:false,
        scales:{ x:{ min:0,max:1, title:{display:true,text:'Recall'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}},
                 y:{ min:0,max:1, title:{display:true,text:'Precision'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}}},
        plugins:{ legend:{ labels:{ color:'#212529'} }}
      }
    });

    // add point on click
    ctx.addEventListener('click', (evt)=>{
      const pos = Chart.helpers.getRelativePosition(evt, chart);
      const x = chart.scales.x.getValueForPixel( chart.scales.x.left + pos.x * chart.width / chart.chartArea.width );
      const y = chart.scales.y.getValueForPixel( chart.scales.y.top + pos.y * chart.height / chart.chartArea.height );
      const t = Number(classSel.value);
      points.push({x,y,t});
      renderPoints(); updateAll();
      ping('Added point to class ' + t);
    });

    // hover probe
    if (probe) {
      ctx.addEventListener('mousemove', (evt)=>{
        const pos = Chart.helpers.getRelativePosition(evt, chart);
        const x = chart.scales.x.getValueForPixel( chart.scales.x.left + pos.x * chart.width / chart.chartArea.width );
        const y = chart.scales.y.getValueForPixel( chart.scales.y.top + pos.y * chart.height / chart.chartArea.height );
        const z = Number(w0.value)*x + Number(w1.value)*y + Number(b.value);
        const p = 1/(1+Math.exp(-z));
        probe.textContent = 'x=' + x.toFixed(2) + ', y=' + y.toFixed(2) + ', z=' + z.toFixed(2) + ', p=' + p.toFixed(3);
      });
    }

    function renderPoints(){
      console.log('Rendering points:', points.length);
      const c0 = points.filter(p=>p.t===0).map(p=>({x:p.x,y:p.y}));
      const c1 = points.filter(p=>p.t===1).map(p=>({x:p.x,y:p.y}));
      console.log('Class 0 points:', c0.length, 'Class 1 points:', c1.length);
      chart.data.datasets[0].data = c0;
      chart.data.datasets[1].data = c1;
      kN.textContent = String(points.length);
    }

    const sigmoid = (z)=> 1/(1+Math.exp(-z));
    const predict = (p)=> sigmoid(Number(w0.value)*p.x + Number(w1.value)*p.y + Number(b.value));

    // boundary computation (no misplaced else)
    function currentBoundaryPts(){
      const w0v=Number(w0.value), w1v=Number(w1.value), bv=Number(b.value);
      const xmin = chart.scales.x.min, xmax = chart.scales.x.max;
      const ymin = chart.scales.y.min, ymax = chart.scales.y.max;
      if (Math.abs(w1v) < 1e-9) {
        const x = -bv / (w0v || 1e-9);
        return [{x, y: ymin}, {x, y: ymax}];
      }
      const y = x => -(w0v/w1v)*x - bv/w1v;
      return [{x:xmin, y:y(xmin)}, {x:xmax, y:y(xmax)}];
    }

    function decisionLine(){
      chart.data.datasets[2].data = currentBoundaryPts();
    }

    function addBoundaryTrace(){
      const pts = currentBoundaryPts();
      chart.data.datasets.push({
        label:'Trace ' + stepCount,
        type:'line', data:pts, pointRadius:0, borderWidth:1,
        borderDash:[2,4], borderColor:'rgba(110,168,254,0.35)', parsing:false,
        trace:true, order:1
      });
      // keep at most 25 traces
      let traces = chart.data.datasets.filter(d=>d.trace);
      while (traces.length > 25) {
        const idx = chart.data.datasets.findIndex(d=>d.trace);
        if (idx>-1) chart.data.datasets.splice(idx,1);
        traces = chart.data.datasets.filter(d=>d.trace);
      }
    }

    let lastLoss = null; // for ΔLoss
    let stepBatches = 0; // number of times stepGD called

    function metrics(){
      if(points.length===0){ kLoss.textContent='—'; kAcc.textContent='—'; kDelta.textContent='—'; cmTN.textContent=cmFP.textContent=cmFN.textContent=cmTP.textContent='—'; return; }
      const lambda = Number(lam.value), tau=Number(th.value);
      let loss=0, correct=0, TN=0, FP=0, FN=0, TP=0;
      for(const p of points){
        const pr = predict(p); const t=p.t; const eps=1e-9;
        loss += -(t*Math.log(pr+eps) + (1-t)*Math.log(1-pr+eps));
        const pred = pr >= tau ? 1 : 0;
        correct += (pred===t);
        if (t===0 && pred===0) TN++; else if (t===0 && pred===1) FP++; else if (t===1 && pred===0) FN++; else TP++;
      }
      const reg = lambda*(Number(w0.value)**2 + Number(w1.value)**2);
      const totalLoss = loss + reg;
      kDelta.textContent = (lastLoss!==null? (totalLoss - lastLoss).toFixed(4) : '—');
      lastLoss = totalLoss;
      kLoss.textContent = totalLoss.toFixed(4);
      kAcc.textContent = (correct/points.length*100).toFixed(1) + '%';
      cmTN.textContent = TN; cmFP.textContent = FP; cmFN.textContent = FN; cmTP.textContent = TP;
      kSteps.textContent = String(stepBatches);
    }

    // probability field (grid with opacity ~ p)
    function updateField(){
      const ds = chart.data.datasets[3]; // field dataset (index kept >2 to not break tests)
      ds.data.length = 0;
      const xs = 35, ys = 35; // grid resolution
      const xmin = chart.scales.x.min, xmax = chart.scales.x.max;
      const ymin = chart.scales.y.min, ymax = chart.scales.y.max;
      for (let i=0; i<xs; i++){
        const x = xmin + (xmax-xmin)*(i/(xs-1));
        for (let j=0; j<ys; j++){
          const y = ymin + (ymax-ymin)*(j/(ys-1));
          const z = Number(w0.value)*x + Number(w1.value)*y + Number(b.value);
          const p = sigmoid(z);
          ds.data.push({x,y,p});
        }
      }
    }

    function updateROC(){
      if (points.length === 0) return;
      const roc = [];
      const probs = points.map(p => ({prob: predict(p), actual: p.t}));
      probs.sort((a,b) => b.prob - a.prob);
      
      let tp = 0, fp = 0;
      const totalP = probs.filter(p => p.actual === 1).length;
      const totalN = probs.filter(p => p.actual === 0).length;
      
      roc.push({x: 0, y: 0});
      for(const p of probs){
        if(p.actual === 1) tp++; else fp++;
        roc.push({x: fp/totalN, y: tp/totalP});
      }
      
      chartROC.data.datasets[0].data = roc;
      chartROC.update();
    }

    function updatePR(){
      if (points.length === 0) return;
      const pr = [];
      const probs = points.map(p => ({prob: predict(p), actual: p.t}));
      probs.sort((a,b) => b.prob - a.prob);
      
      let tp = 0, fp = 0;
      const totalP = probs.filter(p => p.actual === 1).length;
      
      for(const p of probs){
        if(p.actual === 1) tp++; else fp++;
        const precision = tp / (tp + fp);
        const recall = tp / totalP;
        pr.push({x: recall, y: precision});
      }
      
      chartPR.data.datasets[0].data = pr;
      chartPR.update();
    }

    // training (batch gradient descent)
    function stepGD(steps=1){
      const eta = Number(lr.value), lambda=Number(lam.value);
      for(let s=0; s<steps; s++){
        if(points.length===0) break;
        let g0=0,g1=0,gb=0;
        for(const p of points){
          const z = Number(w0.value)*p.x + Number(w1.value)*p.y + Number(b.value);
          const pr = sigmoid(z); const diff = pr - p.t; // derivative of CE
          g0 += diff * p.x; g1 += diff * p.y; gb += diff;
        }
        g0 = g0/points.length + 2*lambda*Number(w0.value);
        g1 = g1/points.length + 2*lambda*Number(w1.value);
        gb = gb/points.length;
        w0.value = Number(w0.value) - eta*g0;
        w1.value = Number(w1.value) - eta*g1;
        b.value  = Number(b.value)  - eta*gb;
        w0Num.value=w0.value; w1Num.value=w1.value; bNum.value=b.value;
        // step count + optional trace
        stepCount++;
        if (recordTraces && recordTraces.checked && (steps===1 || (s % traceStride) === traceStride-1)) {
          addBoundaryTrace();
        }
      }
      stepBatches++;
      updateAll();
    }

    document.getElementById('btnStep').addEventListener('click', ()=>{ stepGD(1); ping('Trained 1 step'); });
    document.getElementById('btnStep100').addEventListener('click', ()=>{ stepGD(100); ping('Trained 100 steps'); });
    document.getElementById('btnResetW').addEventListener('click', ()=>{ w0.value=1; w1.value=-1; b.value=0; w0Num.value=1; w1Num.value=-1; bNum.value=0; updateAll(); ping('Weights reset'); });
    document.getElementById('btnClear').addEventListener('click', ()=>{ points=[]; renderPoints(); updateAll(); ping('Cleared points'); });

    // clear boundary step traces
    btnClearTraces.addEventListener('click', ()=>{
      chart.data.datasets = chart.data.datasets.filter(d=>!d.trace);
      chart.update();
      ping('Cleared step traces');
    });

    // toggle probability field
    showField.addEventListener('change', ()=>{
      chart.data.datasets[3].hidden = !showField.checked;
      if (showField.checked) updateField();
      chart.update();
    });

    // auto-train play/pause
    btnAuto.addEventListener('click', ()=>{
      if (autoTimer){
        clearInterval(autoTimer); autoTimer=null; btnAuto.textContent='Auto-train ▶︎'; ping('Auto-train paused'); return;
      }
      btnAuto.textContent='Auto-train ⏸';
      autoTimer = setInterval(()=> stepGD(10), 120); // batches of 10 steps
      ping('Auto-train running');
    });

    // sample dataset (two blobs)
    document.getElementById('btnSeeds').addEventListener('click', ()=>{
      points=[];
      for(let i=0;i<60;i++){ points.push({x: -1.5 + randn()*0.7, y: -1 + randn()*0.7, t:0}); }
      for(let i=0;i<60;i++){ points.push({x: 1.3 + randn()*0.7, y: 1 + randn()*0.7, t:1}); }
      renderPoints(); updateAll(); ping('Sample dataset loaded');
    });

    // balanced dataset
    document.getElementById('btnBalanced').addEventListener('click', ()=>{
      points=[];
      for(let i=0;i<60;i++){ points.push({x: -2 + randn()*0.8, y: -1.5 + randn()*0.8, t:0}); }
      for(let i=0;i<60;i++){ points.push({x: 2 + randn()*0.8, y: 1.5 + randn()*0.8, t:1}); }
      renderPoints(); updateAll(); ping('Balanced dataset loaded');
    });

    // overlap dataset
    document.getElementById('btnOverlap').addEventListener('click', ()=>{
      points=[];
      for(let i=0;i<60;i++){ points.push({x: -1 + randn()*1.2, y: -0.5 + randn()*1.2, t:0}); }
      for(let i=0;i<60;i++){ points.push({x: 1 + randn()*1.2, y: 0.5 + randn()*1.2, t:1}); }
      renderPoints(); updateAll(); ping('Overlap dataset loaded');
    });

    // imbalanced dataset
    document.getElementById('btnImbalance').addEventListener('click', ()=>{
      points=[];
      for(let i=0;i<20;i++){ points.push({x: -1.5 + randn()*0.7, y: -1 + randn()*0.7, t:0}); }
      for(let i=0;i<100;i++){ points.push({x: 1.3 + randn()*0.7, y: 1 + randn()*0.7, t:1}); }
      renderPoints(); updateAll(); ping('Imbalanced dataset loaded');
    });

    // XOR dataset
    document.getElementById('btnXOR').addEventListener('click', ()=>{
      points=[];
      for(let i=0;i<30;i++){ points.push({x: -1.5 + randn()*0.5, y: -1.5 + randn()*0.5, t:0}); }
      for(let i=0;i<30;i++){ points.push({x: 1.5 + randn()*0.5, y: 1.5 + randn()*0.5, t:0}); }
      for(let i=0;i<30;i++){ points.push({x: -1.5 + randn()*0.5, y: 1.5 + randn()*0.5, t:1}); }
      for(let i=0;i<30;i++){ points.push({x: 1.5 + randn()*0.5, y: -1.5 + randn()*0.5, t:1}); }
      renderPoints(); updateAll(); ping('XOR dataset loaded');
    });

    // export image
    document.getElementById('btnExport').addEventListener('click', ()=>{ const url = chart.toBase64Image('image/png',1); const a=document.createElement('a'); a.href=url; a.download='logreg_demo.png'; a.click(); ping('Downloaded PNG'); });
    document.getElementById('btnExportROC').addEventListener('click', ()=>{ const url = chartROC.toBase64Image('image/png',1); const a=document.createElement('a'); a.href=url; a.download='logreg_roc.png'; a.click(); ping('Downloaded ROC PNG'); });
    document.getElementById('btnExportPR').addEventListener('click', ()=>{ const url = chartPR.toBase64Image('image/png',1); const a=document.createElement('a'); a.href=url; a.download='logreg_pr.png'; a.click(); ping('Downloaded PR PNG'); });

    // first render
    renderPoints();
    decisionLine(); // show initial boundary
    if (showField.checked) updateField();
    chart.update();

    // --- BASIC SELF-TESTS (console) ---
    (function runTests(){
      try {
        console.group('%cSelf-tests','color:#9fb3ff');
        // 1) Boundary computation should return two points
        const pts = currentBoundaryPts();
        console.assert(Array.isArray(pts) && pts.length===2 && 'x' in pts[0] && 'y' in pts[0], 'Boundary points format');
        // 2) Training should modify parameters when data present
        const backup = {w0:w0.value, w1:w1.value, b:b.value};
        let tmp = [ {x:-1,y:-1,t:0}, {x:-1.2,y:-0.8,t:0}, {x:1.1,y:1.0,t:1}, {x:1.3,y:0.9,t:1} ];
        const oldPoints = points.slice(); points = tmp; // swap in
        const w0Before = Number(w0.value); stepGD(1); const w0After = Number(w0.value);
        console.assert(w0Before !== w0After, 'Weights update after one step');
        // 3) decisionLine places exactly 2 points into dataset without throwing
        decisionLine();
        console.assert(chart.data.datasets[2].data.length === 2, 'Decision boundary has two points');
        // 4) confusion matrix sums to N
        points = tmp; updateAll();
        const sumCM = Number(cmTN.textContent) + Number(cmFP.textContent) + Number(cmFN.textContent) + Number(cmTP.textContent);
        console.assert(sumCM === points.length, 'Confusion matrix totals match N');
        // restore
        w0.value=backup.w0; w1.value=backup.w1; b.value=backup.b; points = oldPoints; updateAll();
        console.groupEnd();
      } catch (e) { console.error('Self-tests failed:', e); }
    })();

    // auto-seed so you see it working immediately
    setTimeout(() => {
      console.log('Auto-seeding dataset...');
      document.getElementById('btnSeeds').click();
    }, 500);
  });
  </script>

<hr>
<%--<div class="sharethis-inline-share-buttons"></div>--%>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>