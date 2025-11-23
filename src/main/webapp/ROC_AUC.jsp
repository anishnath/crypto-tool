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
<meta name="description" content="Interactive ROC Curve, AUC, and Precision-Recall curve visualization tool. Learn about ROC-AUC metrics and PR curves with hands-on logistic regression demo.">
<meta name="keywords" content="ROC curve, AUC, precision recall curve, PR curve, logistic regression, machine learning visualization, binary classification">
<title>ROC, AUC & PR Curve Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Interactive ROC, AUC & PR Curve",
  "description": "Interactive tool for visualizing ROC curves, AUC metrics, and Precision-Recall curves with logistic regression",
  "url": "https://8gwifi.org/ROC_AUC.jsp",
  "keywords": "ROC curve, AUC, precision recall, PR curve, machine learning, binary classification, logistic regression"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<style>
    /* Scoped styles for ROC/AUC demo - doesn't override site Bootstrap */
    .roc-demo .chart-container {
        background: #f8f9fa;
        border: 2px solid #dee2e6;
        border-radius: 8px;
        padding: 20px;
        margin: 15px 0;
    }
    .roc-demo .control-group {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        padding: 15px;
        margin: 10px 0;
    }
    .roc-demo .control-group label {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 8px;
        font-weight: 500;
    }
    .roc-demo input[type=range] {
        width: 100%;
    }
    .roc-demo input[type=number] {
        width: 110px;
    }
    .roc-demo .kpi-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
        gap: 10px;
        margin: 15px 0;
    }
    .roc-demo .kpi-card {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        padding: 12px;
        text-align: center;
    }
    .roc-demo .kpi-label {
        color: #6c757d;
        font-size: 12px;
        font-weight: 500;
        margin-bottom: 5px;
    }
    .roc-demo .kpi-value {
        font-family: 'Courier New', monospace;
        font-size: 18px;
        font-weight: bold;
        color: #212529;
    }
    .roc-demo .legend {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
        font-size: 13px;
        margin: 10px 0;
    }
    .roc-demo .dot {
        display: inline-block;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        margin-right: 5px;
    }
    .roc-demo .dot.pos { background: #28a745; }
    .roc-demo .dot.neg { background: #dc3545; }
    .roc-demo .pill {
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

<h1 class="mt-4">Interactive ROC, AUC & Precision–Recall</h1>
<p>Click the scatter plot to add points (toggle class with dropdown). Train a simple logistic model, then inspect ROC/AUC and PR curves. AUC summarizes ranking quality independent of a fixed threshold.</p>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="roc-demo">
  <!-- All Charts on Left, All Controls on Right -->
  <div class="row">
    <!-- Left: All Charts Stacked -->
    <div class="col-lg-8 mb-4">
      <!-- Dataset & Model Chart -->
      <div class="card mb-4">
        <div class="card-header">
          <h5 class="mb-0">Dataset & Model</h5>
        </div>
        <div class="card-body">
          <div class="chart-container">
            <div style="height: 400px;">
              <canvas id="chartXY"></canvas>
            </div>
          </div>
          <div class="d-flex justify-content-between align-items-center flex-wrap mt-3">
            <div class="legend">
              <span><span class="dot pos"></span> Class 1</span>
              <span><span class="dot neg"></span> Class 0</span>
              <span>Decision boundary <span class="pill">w₀x + w₁y + b = 0</span></span>
            </div>
            <div>
              <button id="btnExportXY" class="btn btn-secondary btn-sm">Download PNG</button>
              <button id="btnClear" class="btn btn-danger btn-sm">Clear points</button>
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
      <div class="card">
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
            <label><span>Learning rate η</span><input type="number" id="lrNum" step="0.001" value="0.1" class="form-control form-control-sm"></label>
            <input type="range" id="lr" min="0.001" max="1" step="0.001" value="0.1" class="form-range">
          </div>
          <div class="control-group mb-3">
            <label><span>Threshold τ</span><input type="number" id="thNum" step="0.01" value="0.5" class="form-control form-control-sm"></label>
            <input type="range" id="th" min="0" max="1" step="0.01" value="0.5" class="form-range">
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
          </div>
        </div>
      </div>
      
      <!-- Metrics Card -->
      <div class="card">
        <div class="card-header">
          <h6 class="mb-0">Metrics</h6>
        </div>
        <div class="card-body p-2">
          <div class="kpi-grid">
            <div class="kpi-card"><div class="kpi-label">Log loss</div><div class="kpi-value" id="kLoss">—</div></div>
            <div class="kpi-card"><div class="kpi-label">Accuracy</div><div class="kpi-value" id="kAcc">—</div></div>
            <div class="kpi-card"><div class="kpi-label">ROC AUC</div><div class="kpi-value" id="kAUC">—</div></div>
            <div class="kpi-card"><div class="kpi-label">PR AUC</div><div class="kpi-value" id="kAP">—</div></div>
            <div class="kpi-card"><div class="kpi-label">N points</div><div class="kpi-value" id="kN">0</div></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

  <script>
  window.addEventListener('DOMContentLoaded', () => {
    // helpers
    const $ = s => document.querySelector(s);
    const link = (a,b, on)=>{ a.addEventListener('input',()=>{ b.value=a.value; on&&on();}); b.addEventListener('input',()=>{ a.value=b.value; on&&on();}); };
    const randn = ()=>{ let u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); };
    const sigmoid = z => 1/(1+Math.exp(-z));

    // model params
    const w0=$('#w0'), w1=$('#w1'), b=$('#b');
    const w0Num=$('#w0Num'), w1Num=$('#w1Num'), bNum=$('#bNum');
    const th=$('#th'), thNum=$('#thNum');
    const lr=$('#lr'), lrNum=$('#lrNum');

    link(w0,w0Num, updateAll); link(w1,w1Num, updateAll); link(b,bNum, updateAll); link(th,thNum, updateAll); link(lr,lrNum);

    const classSel=$('#classSel');
    const kLoss=$('#kLoss'), kAcc=$('#kAcc'), kN=$('#kN'), kAUC=$('#kAUC'), kAP=$('#kAP');

    // charts
    const ctxXY = document.getElementById('chartXY');
    const ctxROC = document.getElementById('chartROC');
    const ctxPR  = document.getElementById('chartPR');

    let points = []; // {x,y,t}

    const chartXY = new Chart(ctxXY, {
      type: 'scatter',
      data: { datasets:[
        {label:'Class 0', data:[], pointRadius:5, backgroundColor:'#dc3545'},
        {label:'Class 1', data:[], pointRadius:5, backgroundColor:'#28a745'},
        {label:'Decision boundary', type:'line', data:[], pointRadius:0, borderWidth:2, borderDash:[6,6], parsing:false, borderColor:'#0d6efd'}
      ]},
      options:{
        responsive:true, maintainAspectRatio:false,
        scales:{ x:{ min:-5,max:5, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}},
                 y:{ min:-5,max:5, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}}},
        plugins:{ legend:{ labels:{ color:'#212529'} }, tooltip:{ callbacks:{ label:(c)=>`(${c.raw.x.toFixed(2)}, ${c.raw.y.toFixed(2)})` }}}
      }
    });

    const chartROC = new Chart(ctxROC, {
      type: 'line',
      data: { datasets:[
        {label:'ROC', data:[], pointRadius:2, borderWidth:2, fill:false, borderColor:'#0d6efd', backgroundColor:'#0d6efd'},
        {label:'Random', data:[{x:0,y:0},{x:1,y:1}], pointRadius:0, borderDash:[6,6], borderWidth:1, borderColor:'#6c757d'}
      ]},
      options:{ responsive:true, maintainAspectRatio:false,
        parsing:false,
        scales:{ x:{ min:0,max:1, title:{display:true, text:'FPR', color:'#495057'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}},
                 y:{ min:0,max:1, title:{display:true, text:'TPR', color:'#495057'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}}},
        plugins:{ legend:{ labels:{ color:'#212529'} } }
      }
    });

    const chartPR = new Chart(ctxPR, {
      type: 'line',
      data: { datasets:[ {label:'PR', data:[], pointRadius:2, borderWidth:2, fill:false, borderColor:'#198754', backgroundColor:'#198754'} ]},
      options:{ responsive:true, maintainAspectRatio:false,
        parsing:false,
        scales:{ x:{ min:0,max:1, title:{display:true, text:'Recall', color:'#495057'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}},
                 y:{ min:0,max:1, title:{display:true, text:'Precision', color:'#495057'}, ticks:{color:'#495057'}, grid:{color:'rgba(0,0,0,.1)'}}},
        plugins:{ legend:{ labels:{ color:'#212529'} } }
      }
    });

    // events: add point by clicking XY
    ctxXY.addEventListener('click', (evt)=>{
      const pos = Chart.helpers.getRelativePosition(evt, chartXY);
      const x = chartXY.scales.x.getValueForPixel( chartXY.scales.x.left + pos.x * chartXY.width / chartXY.chartArea.width );
      const y = chartXY.scales.y.getValueForPixel( chartXY.scales.y.top + pos.y * chartXY.height / chartXY.chartArea.height );
      const t = Number(classSel.value);
      points.push({x,y,t});
      renderPoints(); updateAll();
    });

    // toolbar events
    $('#btnClear').addEventListener('click', ()=>{ points=[]; renderPoints(); updateAll(); });
    $('#btnExportXY').addEventListener('click', ()=>{ const a=document.createElement('a'); a.href=chartXY.toBase64Image('image/png',1); a.download='xy.png'; a.click(); });
    $('#btnExportROC').addEventListener('click', ()=>{ const a=document.createElement('a'); a.href=chartROC.toBase64Image('image/png',1); a.download='roc.png'; a.click(); });
    $('#btnExportPR').addEventListener('click', ()=>{ const a=document.createElement('a'); a.href=chartPR.toBase64Image('image/png',1); a.download='pr.png'; a.click(); });

    $('#btnResetW').addEventListener('click', ()=>{ w0.value=1; w1.value=-1; b.value=0; w0Num.value=1; w1Num.value=-1; bNum.value=0; updateAll(); });
    $('#btnStep').addEventListener('click', ()=> stepGD(1));
    $('#btnStep100').addEventListener('click', ()=> stepGD(100));

    let auto=null;
    $('#btnAuto').addEventListener('click', (e)=>{
      if(auto){ clearInterval(auto); auto=null; e.target.textContent='Auto-train ▶︎'; return; }
      e.target.textContent='Auto-train ⏸';
      auto=setInterval(()=> stepGD(10), 120);
    });

    // original sample
    $('#btnSeeds').addEventListener('click', ()=>{
      generateBalanced();
    });

    // NEW dataset mode handlers
    $('#btnBalanced').addEventListener('click', generateBalanced);
    $('#btnOverlap').addEventListener('click', generateOverlap);
    $('#btnImbalance').addEventListener('click', generateImbalance);
    $('#btnXOR').addEventListener('click', generateXOR);

    // ----- dataset generators -----
    function generateBalanced(){
      points=[];
      for(let i=0;i<80;i++){ points.push({x: -1.8 + randn()*0.55, y: -1.2 + randn()*0.55, t:0}); }
      for(let i=0;i<80;i++){ points.push({x:  1.6 + randn()*0.55, y:  1.1 + randn()*0.55, t:1}); }
      renderPoints(); updateAll();
    }

    function generateOverlap(){
      points=[];
      for(let i=0;i<80;i++){ points.push({x: -0.8 + randn()*1.2, y: -0.8 + randn()*1.2, t:0}); }
      for(let i=0;i<80;i++){ points.push({x:  0.8 + randn()*1.2, y:  0.8 + randn()*1.2, t:1}); }
      renderPoints(); updateAll();
    }

    function generateImbalance(){
      points=[];
      for(let i=0;i<140;i++){ points.push({x: -1.2 + randn()*0.9, y: -1.0 + randn()*0.9, t:0}); }
      for(let i=0;i<20;i++){  points.push({x:  1.4 + randn()*0.7, y:  1.2 + randn()*0.7, t:1}); }
      renderPoints(); updateAll();
    }

    function generateXOR(){
      points=[];
      const n=50, s=0.45;
      // negatives in (+,+) and (-,-)
      for(let i=0;i<n;i++){ points.push({x:  1.3 + randn()*s, y:  1.3 + randn()*s, t:0}); }
      for(let i=0;i<n;i++){ points.push({x: -1.3 + randn()*s, y: -1.3 + randn()*s, t:0}); }
      // positives in (+,-) and (-,+)
      for(let i=0;i<n;i++){ points.push({x:  1.3 + randn()*s, y: -1.3 + randn()*s, t:1}); }
      for(let i=0;i<n;i++){ points.push({x: -1.3 + randn()*s, y:  1.3 + randn()*s, t:1}); }
      renderPoints(); updateAll();
    }

    // ----- render & metrics -----
    function renderPoints(){
      const c0=points.filter(p=>p.t===0).map(p=>({x:p.x,y:p.y}));
      const c1=points.filter(p=>p.t===1).map(p=>({x:p.x,y:p.y}));
      chartXY.data.datasets[0].data=c0;
      chartXY.data.datasets[1].data=c1;
      kN.textContent=String(points.length);
    }

    function predict(p){ return sigmoid(Number(w0.value)*p.x + Number(w1.value)*p.y + Number(b.value)); }

    function decisionLine(){
      const w0v=Number(w0.value), w1v=Number(w1.value), bv=Number(b.value);
      const xs=[-5,5];
      let pts=[];
      if(Math.abs(w1v) < 1e-9){ const x=-bv/(w0v||1e-9); pts=[{x, y:-5},{x, y:5}]; }
      else { const y = x=>-(w0v/w1v)*x - bv/w1v; pts=[{x:xs[0], y:y(xs[0])},{x:xs[1], y:y(xs[1])}]; }
      chartXY.data.datasets[2].data=pts;
    }

    function computeLossAcc(){
      if(points.length===0){ kLoss.textContent='—'; kAcc.textContent='—'; return; }
      let loss=0, correct=0; const tau=Number(th.value); const eps=1e-9;
      for(const p of points){ const pr=predict(p); const t=p.t; loss += -(t*Math.log(pr+eps)+(1-t)*Math.log(1-pr+eps)); correct += ((pr>=tau)?1:0)===t; }
      kLoss.textContent=loss.toFixed(4);
      kAcc.textContent=(correct/points.length*100).toFixed(1)+'%';
    }

    function rocAndPR(){
      if(points.length===0){ chartROC.data.datasets[0].data=[]; chartPR.data.datasets[0].data=[]; kAUC.textContent=kAP.textContent='—'; chartROC.update(); chartPR.update(); return; }
      // collect scores
      const arr = points.map(p=>({s:predict(p), y:p.t})).sort((a,b)=>b.s-a.s);
      const P = arr.reduce((a,r)=>a+(r.y===1),0), N=arr.length-P;
      // ROC sweep
      let tp=0, fp=0, roc=[{x:0,y:0}];
      for(const r of arr){ if(r.y===1) tp++; else fp++; roc.push({x:fp/N, y:tp/P}); }
      // add (1,1) and integrate
      roc.push({x:1,y:1});
      roc.sort((a,b)=>a.x-b.x);
      let auc=0; for(let i=1;i<roc.length;i++){ const dx=roc[i].x-roc[i-1].x; const avgY=(roc[i].y+roc[i-1].y)/2; auc += dx*avgY; }
      chartROC.data.datasets[0].data=roc; kAUC.textContent=auc.toFixed(3);

      // PR sweep (precision vs recall)
      tp=0; fp=0; let pr=[];
      for(let i=0;i<arr.length;i++){ if(arr[i].y===1) tp++; else fp++; const rec=tp/(P||1); const prec=tp/(tp+fp||1); pr.push({x:rec, y:prec}); }
      pr.sort((a,b)=>a.x-b.x);
      let ap=0; for(let i=1;i<pr.length;i++){ const dx=pr[i].x-pr[i-1].x; const avgY=(pr[i].y+pr[i-1].y)/2; ap += dx*avgY; }
      chartPR.data.datasets[0].data=pr; kAP.textContent=ap.toFixed(3);

      chartROC.update(); chartPR.update();
    }

    function updateAll(){ decisionLine(); computeLossAcc(); rocAndPR(); chartXY.update(); }

    function stepGD(steps=1){
      const eta=Number(lr.value);
      for(let s=0;s<steps;s++){
        if(points.length===0) break;
        let g0=0,g1=0,gb=0;
        for(const p of points){ const z=Number(w0.value)*p.x+Number(w1.value)*p.y+Number(b.value); const pr=sigmoid(z); const diff=pr-p.t; g0+=diff*p.x; g1+=diff*p.y; gb+=diff; }
        g0/=points.length; g1/=points.length; gb/=points.length;
        w0.value=Number(w0.value)-eta*g0; w1.value=Number(w1.value)-eta*g1; b.value=Number(b.value)-eta*gb;
        w0Num.value=w0.value; w1Num.value=w1.value; bNum.value=b.value;
      }
      updateAll();
    }

    // initial render & tiny tests
    renderPoints(); updateAll();
    (function tests(){
      try{
        console.group('%cSelf-tests','color:#9fb3ff');
        // Test 1: ROC monotonicity on seeded toy data
        const toy=[{x:0,y:0,t:0},{x:1,y:1,t:1},{x:2,y:2,t:1},{x:-1,y:-1,t:0}];
        const old=points.slice(); points=toy; const rocBefore=[]; const arr=points.map(p=>({s:predict(p),y:p.t})).sort((a,b)=>b.s-a.s); let P=arr.reduce((a,r)=>a+(r.y===1),0), N=arr.length-P; let tp=0,fp=0; rocBefore.push({x:0,y:0}); for(const r of arr){ if(r.y===1) tp++; else fp++; rocBefore.push({x:fp/N,y:tp/P}); } rocBefore.push({x:1,y:1}); let ok=true; for(let i=1;i<rocBefore.length;i++){ if(rocBefore[i].x<rocBefore[i-1].x) ok=false; } console.assert(ok,'ROC FPR non-decreasing');
        // Test 2: AUC bounds
        let auc=0; rocBefore.sort((a,b)=>a.x-b.x); for(let i=1;i<rocBefore.length;i++){ const dx=rocBefore[i].x-rocBefore[i-1].x; const avgY=(rocBefore[i].y+rocBefore[i-1].y)/2; auc+=dx*avgY; } console.assert(auc>=0 && auc<=1,'AUC within [0,1]');
        // Test 3: PR values in [0,1]
        tp=0; fp=0; const pr=[]; for(const r of arr){ if(r.y===1) tp++; else fp++; const rec=tp/(P||1); const prec=tp/(tp+fp||1); pr.push({x:rec,y:prec}); } const inRange=pr.every(p=>p.x>=0&&p.x<=1&&p.y>=0&&p.y<=1); console.assert(inRange,'PR in [0,1]');
        points=old; updateAll();
        console.groupEnd();
      }catch(e){ console.error('Self-tests failed',e); }
    })();

    // default: balanced
    generateBalanced();
  });
  </script>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (ROC AUC) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>This module computes ROC curves by sweeping probability thresholds over predicted scores and true labels. It calculates TPR/FPR pairs, area under the curve (AUC) via trapezoidal rule, and can display class‑imbalance aware views (e.g., PR curve where available).</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Interpret ROC curves and AUC across different thresholds.</li>
      <li>Understand when ROC vs PR curves are appropriate (imbalance).</li>
      <li>See how calibration and score distributions affect metrics.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>All calculations happen in your browser; datasets are not uploaded.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "ROC AUC",
  "url": "https://8gwifi.org/ROC_AUC.jsp",
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
    {"@type":"ListItem","position":2,"name":"ROC AUC","item":"https://8gwifi.org/ROC_AUC.jsp"}
  ]
}
</script>

</div>
<%@ include file="body-close.jsp"%>
