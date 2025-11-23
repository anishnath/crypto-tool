<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="SHAP Explorer — Global and local model explanations with SHAP-like feature attributions. Train a small Random Forest, view summary and per-instance waterfall plots.">
<meta name="keywords" content="shap visualization, shapley additive explanations, tree shap, model interpretability, beeswarm plot, waterfall plot, feature importance">
<title>SHAP Explorer Online – Free | 8gwifi.org</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context":"http://schema.org",
  "@type":"WebPage",
  "name":"SHAP Explorer — Global & Local Explanations",
  "description":"Interactive SHAP-style visualizations: global summary and local waterfall explanations for a small Random Forest on synthetic datasets.",
  "url":"https://8gwifi.org/shap_explorer.jsp",
  "keywords":"shap visualization, shapley additive explanations, tree shap, model interpretability, beeswarm plot, waterfall plot, feature attribution"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .shap { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:260px; }
  .metric-card { background:linear-gradient(135deg,#4facfe 0%,#00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.green { background:linear-gradient(135deg,#43e97b 0%,#38f9d7 100%); }
  .metric-label { font-size:12px; opacity:.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }
  .small-note { font-size:12px; color:#6c757d; }
  .table-sm td,.table-sm th { padding:.25rem .5rem; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">SHAP Explorer — Explain Your Model</h1>
<p>Train a small Random Forest and explore <strong>global</strong> and <strong>local</strong> SHAP-style explanations. See which features matter overall and why a specific prediction happened.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group">
    <a href="#viz" class="btn btn-outline-primary">Global</a>
    <a href="#local" class="btn btn-outline-primary">Local</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<!-- Beginner Quick Start -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">Beginner Quick Start</h5>
  </div>
  <div class="card-body">
    <ol class="mb-2">
      <li><strong>Select a dataset</strong> (regression/classification) and click <strong>Generate</strong>.</li>
      <li><strong>Train</strong> the Random Forest (defaults work well).</li>
      <li>Open <strong>Global</strong> to see which features matter; open <strong>Local</strong> to explain a specific row.</li>
    </ol>
    <div class="small-note">Tip: In Local, try the what‑if sliders to see how changing a feature affects the prediction and attributions.</div>
  </div>
</div>

<div class="shap">
  <div class="row">
    <!-- Left column -->
    <div class="col-lg-8 mb-4">
      <!-- Global -->
      <div class="card mb-4" id="viz">
        <div class="card-header">
          <h5 class="mb-0">Global Explanations</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <div class="chart-container-sm">
                <canvas id="barGlobal"></canvas>
              </div>
              <small class="small-note d-block mt-2">Global importance = mean |SHAP| per feature (top‑k).</small>
            </div>
            <div class="col-md-6">
              <div class="chart-container-sm">
                <canvas id="stripGlobal"></canvas>
              </div>
              <small class="small-note d-block mt-2">Per‑feature SHAP “strip” (beeswarm‑style): x=SHAP value, y=feature; color = normalized feature value.</small>
            </div>
          </div>
        </div>
      </div>

      <!-- Local -->
      <div class="card" id="local">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Local Explanation (Waterfall)</h5>
          <div class="small">Base value + contributions → prediction</div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="waterfall"></canvas>
          </div>
          <div class="row mt-3">
            <div class="col-md-6">
              <table class="table table-sm table-bordered">
                <thead><tr><th>Feature</th><th>Value</th><th>SHAP</th></tr></thead>
                <tbody id="tblLocal"></tbody>
              </table>
            </div>
            <div class="col-md-6">
              <div class="small-note">Edit selected row (numeric features)</div>
              <div id="whatIf"></div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="col-lg-4 mb-4">
      <!-- Dataset -->
      <div class="control-section">
        <h6>Dataset</h6>
        <div class="mb-2">
          <select id="dsType" class="form-select form-select-sm">
            <option value="reg" selected>Synthetic Regression (6 features)</option>
            <option value="clf">Synthetic Classification (6 features)</option>
          </select>
        </div>
        <div class="slider-label"><span>Rows</span><strong id="rowsLbl">600</strong></div>
        <input type="range" id="rows" min="200" max="2000" step="100" value="600" class="form-range">
        <div class="slider-label"><span>Train %</span><strong id="splitLbl">80%</strong></div>
        <input type="range" id="split" min="50" max="90" step="5" value="80" class="form-range">
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnGen">Generate</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnSeed">Randomize Seed</button></div>
        </div>
      </div>

      <!-- Model -->
      <div class="control-section">
        <h6>Model (Random Forest)</h6>
        <div class="slider-label"><span>Trees</span><strong id="treesLbl">100</strong></div>
        <input type="range" id="trees" min="10" max="300" step="10" value="100" class="form-range">
        <div class="slider-label"><span>Max depth</span><strong id="depthLbl">5</strong></div>
        <input type="range" id="maxDepth" min="2" max="12" step="1" value="5" class="form-range">
        <div class="slider-label"><span>Min leaf</span><strong id="leafLbl">3</strong></div>
        <input type="range" id="minLeaf" min="1" max="20" step="1" value="3" class="form-range">
        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-success btn-sm w-100" id="btnTrain">Train</button></div>
          <div class="col"><button class="btn btn-outline-primary btn-sm w-100" id="btnExplain">Explain</button></div>
        </div>
        <div class="mt-2 small">
          <div>Metric: <strong id="metricName">—</strong> <span id="metricVal">—</span></div>
        </div>
      </div>

      <!-- SHAP & Instance -->
      <div class="control-section">
        <h6>SHAP & Instance</h6>
        <div class="slider-label"><span>Top‑k (global/local)</span><strong id="topkLbl">10</strong></div>
        <input type="range" id="topk" min="3" max="12" step="1" value="10" class="form-range">
        <div class="mb-2">
          <label class="form-label small">Select instance (row)</label>
          <select id="rowSel" class="form-select form-select-sm"></select>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function(){
  // DOM helpers
  function $(id){ return document.getElementById(id); }

  // State
  var seed=42, rng=null;
  var dataX=[], dataY=[], Xtr=[], Ytr=[], Xva=[], Yva=[];
  var featureNames = ['f0','f1','f2','f3','f4','f5'];
  var isClf=false;
  var forest=[]; // list of trees
  var baseline=0; // expected value
  var shapAll=null; // [N rows][nFeat] SHAP-like contributions (val split)
  var predAll=null; // predictions for val

  // RNG
  function mulberry32(a){ return function(){ var t=a+=0x6D2B79F5; t=Math.imul(t^t>>>15,t|1); t^=t+Math.imul(t^t>>>7,t|61); return ((t^t>>>14)>>>0)/4294967296; }; }
  function randn(r){ var u=0,v=0; while(u===0)u=r(); while(v===0)v=r(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }

  // Dataset generators (6 features)
  function genRegression(n){
    var X=[], Y=[];
    for(var i=0;i<n;i++){
      var row=new Array(6);
      for(var j=0;j<6;j++){ row[j]=rng()*2-1; }
      // nonlinear target with interactions
      var y = 2*Math.sin(3*row[0]) + 1.5*row[1]*row[2] - 2*row[3] + 1.0*row[4]*row[4] + 0.5*row[5] + randn(rng)*0.3;
      X.push(row); Y.push(y);
    }
    return {X:X, Y:Y};
  }
  function genClassification(n){
    var X=[], Y=[];
    for(var i=0;i<n;i++){
      var row=new Array(6);
      for(var j=0;j<6;j++){ row[j]=rng()*2-1; }
      var z = 2.2*row[0] - 1.8*row[1] + 1.2*row[2]*row[3] - 2.5*Math.sin(2*row[4]) + 0.8*row[5] + randn(rng)*0.5;
      var y = (z>0 ? 1 : 0);
      X.push(row); Y.push(y);
    }
    return {X:X, Y:Y};
  }

  // Train/Val split
  function splitData(X,Y, pct){
    var idx = X.map(function(_,i){return i;});
    // shuffle
    for(var i=idx.length-1;i>0;i--){ var j=Math.floor(rng()*(i+1)); var t=idx[i]; idx[i]=idx[j]; idx[j]=t; }
    var cut=Math.floor(idx.length*pct);
    var trI=idx.slice(0,cut), vaI=idx.slice(cut);
    var Xtr=trI.map(i=>X[i]), Ytr=trI.map(i=>Y[i]);
    var Xva=vaI.map(i=>X[i]), Yva=vaI.map(i=>Y[i]);
    return {Xtr:Xtr, Ytr:Ytr, Xva:Xva, Yva:Yva, vaIdx:vaI};
  }

  // Impurity & leaf value
  function mean(arr){ var s=0; for(var i=0;i<arr.length;i++) s+=arr[i]; return arr.length?s/arr.length:0; }
  function gini(y){ var n=y.length; if(n===0) return 0; var p=0; for(var i=0;i<n;i++) p+=y[i]; p/=n; return 2*p*(1-p); }
  function mse(y){ var m=mean(y), s=0; for(var i=0;i<y.length;i++){ var d=y[i]-m; s+=d*d; } return y.length? s/y.length : 0; }
  function scoreImpurity(y){ return isClf ? gini(y) : mse(y); }
  function leafValue(y){ return isClf ? mean(y) : mean(y); } // prob for clf, mean for reg

  // Train a small tree
  function bestSplit(X, y, idxs, minLeaf){
    var nFeat=X[0].length;
    var base=scoreImpurity(idxs.map(i=>y[i]));
    var best={gain:0};
    for(var f=0; f<nFeat; f++){
      // sort by feature
      var sidx=idxs.slice().sort(function(a,b){ return X[a][f]-X[b][f]; });
      var leftY=[], rightY=idxs.map(i=>y[i]);
      var left=[], right=sidx.slice();
      for(var k=1; k<sidx.length; k++){
        var i=sidx[k-1];
        left.push(i); leftY.push(y[i]);
        right.shift(); rightY.shift();
        if(left.length<minLeaf || right.length<minLeaf) continue;
        var thr=(X[sidx[k-1]][f]+X[sidx[k]][f])/2;
        var imp = (left.length/idxs.length)*scoreImpurity(leftY) + (right.length/idxs.length)*scoreImpurity(rightY);
        var gain=base-imp;
        if(gain>best.gain){ best={gain:gain, f:f, thr:thr}; }
      }
    }
    return best.gain>0 ? best : null;
  }

  function buildTree(X, y, idxs, depth, maxDepth, minLeaf){
    var node={leaf:false, f:null, thr:null, left:null, right:null, value:leafValue(idxs.map(i=>y[i]))};
    if(depth>=maxDepth || idxs.length<2*minLeaf){
      node.leaf=true; return node;
    }
    var sp = bestSplit(X, y, idxs, minLeaf);
    if(!sp){ node.leaf=true; return node; }
    node.f=sp.f; node.thr=sp.thr;
    var L=[], R=[];
    for(var i=0;i<idxs.length;i++){
      var j=idxs[i];
      if(X[j][node.f]<=node.thr) L.push(j); else R.push(j);
    }
    node.left = buildTree(X, y, L, depth+1, maxDepth, minLeaf);
    node.right= buildTree(X, y, R, depth+1, maxDepth, minLeaf);
    return node;
  }

  function trainForest(X, y, nTrees, maxDepth, minLeaf){
    var trees=[];
    for(var t=0; t<nTrees; t++){
      // bootstrap
      var idxs=[]; for(var i=0;i<X.length;i++){ idxs.push( Math.floor(rng()*X.length) ); }
      trees.push( buildTree(X, y, idxs, 0, maxDepth, minLeaf) );
    }
    return trees;
  }

  function predictTree(x, node){
    var n=node;
    while(!n.leaf){
      n = (x[n.f]<=n.thr) ? n.left : n.right;
    }
    return n.value;
  }
  function predictForest(x, trees){
    var s=0;
    for(var i=0;i<trees.length;i++) s+=predictTree(x, trees[i]);
    var p = s/trees.length;
    if(isClf){ return p; } else { return p; }
  }

  // SHAP-style path contributions (TreeInterpreter-like)
  function shapTree(x, node, base){
    var contrib=new Array(x.length).fill(0);
    var n=node, parentVal=base;
    while(!n.leaf){
      var child = (x[n.f]<=n.thr) ? n.left : n.right;
      var delta = child.value - parentVal;
      contrib[n.f] += delta;
      parentVal = child.value;
      n = child;
    }
    return contrib;
  }
  function shapForest(x, trees, base){
    var s = new Array(x.length).fill(0);
    for(var i=0;i<trees.length;i++){
      var c = shapTree(x, trees[i], base);
      for(var j=0;j<s.length;j++) s[j] += c[j];
    }
    for(var j2=0;j2<s.length;j2++) s[j2] /= trees.length;
    return s;
  }

  // Global visuals
  var barGlobal = new Chart(document.getElementById('barGlobal'), {
    type:'bar',
    data:{ labels:[], datasets:[{ label:'mean |SHAP|', data:[], backgroundColor:'#0d6efd' }]},
    options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true, title:{display:true,text:'mean |SHAP|'} } } }
  });
  // strip/beeswarm-like: x=shap, y=feature index (with jitter)
  var stripGlobal = new Chart(document.getElementById('stripGlobal'), {
    type:'scatter',
    data:{ datasets:[] },
    options:{ responsive:true, maintainAspectRatio:false, parsing:false,
      scales:{ x:{ title:{display:true,text:'SHAP value'} }, y:{ title:{display:true,text:'Feature (index)'}, min:-0.5, max:5.5 } },
      plugins:{ legend:{ display:false } }
    }
  });

  // Local waterfall (horizontal bar: contributions sorted)
  var waterfall = new Chart(document.getElementById('waterfall'), {
    type:'bar',
    data:{ labels:[], datasets:[{ label:'Contribution', data:[], backgroundColor:[], borderColor:[], borderWidth:1 }]},
    options:{ indexAxis:'y', responsive:true, maintainAspectRatio:false,
      scales:{ x:{ title:{display:true,text:'Contribution'} } },
      plugins:{ legend:{ display:false } }
    }
  });

  // Generate & Train
  function regenerate(){
    rng = mulberry32(seed);
    var n=parseInt($('rows').value);
    isClf = ($('dsType').value==='clf');
    var ds = isClf ? genClassification(n) : genRegression(n);
    dataX=ds.X; dataY=ds.Y;
    var pct=parseInt($('split').value)/100;
    var sp = splitData(dataX, dataY, pct);
    Xtr=sp.Xtr; Ytr=sp.Ytr; Xva=sp.Xva; Yva=sp.Yva;
    // fill row selector with val indices
    var rowSel=$('rowSel'); rowSel.innerHTML='';
    for(var i=0;i<Xva.length;i++){ var opt=document.createElement('option'); opt.value=i; opt.textContent='Row '+i; rowSel.appendChild(opt); }
  }

  function train(){
    var nTrees=parseInt($('trees').value), maxDepth=parseInt($('maxDepth').value), minLeaf=parseInt($('minLeaf').value);
    forest = trainForest(Xtr, Ytr, nTrees, maxDepth, minLeaf);
    baseline = mean(Ytr);
    // metrics
    if(isClf){
      var correct=0;
      for(var i=0;i<Xva.length;i++){ var p=predictForest(Xva[i], forest); var y=(p>0.5?1:0); if(y===Yva[i]) correct++; }
      $('metricName').textContent='Accuracy'; $('metricVal').textContent=((100*correct/Xva.length).toFixed(1)+'%');
    } else {
      var s=0;
      for(var i=0;i<Xva.length;i++){ var p=predictForest(Xva[i], forest); var d=p-Yva[i]; s+=d*d; }
      var rmse=Math.sqrt(s/Math.max(1,Xva.length));
      $('metricName').textContent='RMSE'; $('metricVal').textContent=rmse.toFixed(3);
    }
  }

  function explainAll(){
    // compute SHAP-style for all val rows
    shapAll = new Array(Xva.length);
    predAll = new Array(Xva.length);
    for(var i=0;i<Xva.length;i++){
      var s = shapForest(Xva[i], forest, baseline);
      shapAll[i]=s; predAll[i]=predictForest(Xva[i], forest);
    }
    // Global bar
    var topk=parseInt($('topk').value);
    var meanAbs=new Array(featureNames.length).fill(0);
    for(var f=0; f<featureNames.length; f++){
      var m=0; for(var i=0;i<shapAll.length;i++) m+=Math.abs(shapAll[i][f]); meanAbs[f]=m/Math.max(1,shapAll.length);
    }
    var idx=meanAbs.map(function(v,i){return i;}).sort(function(a,b){ return meanAbs[b]-meanAbs[a]; }).slice(0,topk);
    barGlobal.data.labels = idx.map(i=>featureNames[i]);
    barGlobal.data.datasets[0].data = idx.map(i=>meanAbs[i]);
    barGlobal.update('none');

    // Strip plot (beeswarm-like)
    var datasets=[];
    for(var f2=0; f2<featureNames.length; f2++){
      var dots=[];
      for(var i2=0;i2<Math.min(shapAll.length, 1200); i2++){
        var jitter=(Math.random()*0.8-0.4); // jitter around integer y
        dots.push({ x:shapAll[i2][f2], y:f2+jitter });
      }
      datasets.push({ label:featureNames[f2], data:dots, parsing:false, showLine:false, pointRadius:2, backgroundColor:'rgba(13,110,253,0.6)' });
    }
    stripGlobal.data.datasets=datasets;
    stripGlobal.update('none');

    // Fill local by default first row
    $('rowSel').value='0';
    renderLocal(0);
  }

  // Local explanation UI
  function renderLocal(i){
    if(!shapAll || !shapAll[i]) return;
    var shap=shapAll[i].slice(); // copy
    var x=Xva[i];
    var idx=shap.map((v,fi)=>fi).sort(function(a,b){ return Math.abs(shap[b])-Math.abs(shap[a]); }).slice(0, parseInt($('topk').value));
    var labels=idx.map(j=>featureNames[j]);
    var values=idx.map(j=>shap[j]);
    var colors=values.map(v=> v>=0? 'rgba(25,135,84,0.7)' : 'rgba(220,53,69,0.7)');
    var borders=values.map(v=> v>=0? '#198754' : '#dc3545');
    waterfall.data.labels = labels;
    waterfall.data.datasets[0].data = values;
    waterfall.data.datasets[0].backgroundColor = colors;
    waterfall.data.datasets[0].borderColor = borders;
    waterfall.update('none');

    // table
    var tb=$('tblLocal'); tb.innerHTML='';
    for(var k=0;k<labels.length;k++){
      var tr=document.createElement('tr');
      var td1=document.createElement('td'); td1.textContent=labels[k];
      var td2=document.createElement('td'); td2.textContent=x[idx[k]].toFixed(3);
      var td3=document.createElement('td'); td3.textContent=values[k].toFixed(4);
      tr.appendChild(td1); tr.appendChild(td2); tr.appendChild(td3); tb.appendChild(tr);
    }

    // what-if sliders for numeric features (top-k only)
    var wi=$('whatIf'); wi.innerHTML='';
    idx.forEach(function(f, pos){
      var div=document.createElement('div'); div.className='mb-2';
      var id='wi_'+f;
      div.innerHTML='<label class="form-label small">'+featureNames[f]+' <span id="'+id+'Lbl">'+x[f].toFixed(2)+'</span></label>'+
        '<input type="range" min="-1.5" max="1.5" step="0.01" value="'+x[f].toFixed(2)+'" class="form-range" id="'+id+'">';
      wi.appendChild(div);
      (function(feat){
        $('wi_'+feat).addEventListener('input', function(){
          $('wi_'+feat+'Lbl').textContent=parseFloat(this.value).toFixed(2);
          var x2=x.slice(); x2[feat]=parseFloat(this.value);
          var s = shapForest(x2, forest, baseline);
          var p = predictForest(x2, forest);
          // update plot with new shap
          var order = s.map((v,fi)=>fi).sort(function(a,b){ return Math.abs(s[b])-Math.abs(s[a]); }).slice(0, parseInt($('topk').value));
          waterfall.data.labels = order.map(j=>featureNames[j]);
          var vals = order.map(j=>s[j]);
          waterfall.data.datasets[0].data = vals;
          waterfall.data.datasets[0].backgroundColor = vals.map(v=> v>=0? 'rgba(25,135,84,0.7)' : 'rgba(220,53,69,0.7)');
          waterfall.data.datasets[0].borderColor = vals.map(v=> v>=0? '#198754' : '#dc3545');
          waterfall.update('none');
          // update table values
          var tb=$('tblLocal'); tb.innerHTML='';
          for(var k=0;k<order.length;k++){
            var tr=document.createElement('tr');
            var td1=document.createElement('td'); td1.textContent=featureNames[order[k]];
            var td2=document.createElement('td'); td2.textContent=(order[k]===feat? x2[order[k]] : x[order[k]]).toFixed(3);
            var td3=document.createElement('td'); td3.textContent=vals[k].toFixed(4);
            tr.appendChild(td1); tr.appendChild(td2); tr.appendChild(td3); tb.appendChild(tr);
          }
        });
      })(f);
    });
  }

  // Events
  $('rows').addEventListener('input', function(){ $('rowsLbl').textContent=this.value; });
  $('split').addEventListener('input', function(){ $('splitLbl').textContent=this.value+'%'; });
  $('trees').addEventListener('input', function(){ $('treesLbl').textContent=this.value; });
  $('maxDepth').addEventListener('input', function(){ $('depthLbl').textContent=this.value; });
  $('minLeaf').addEventListener('input', function(){ $('leafLbl').textContent=this.value; });
  $('topk').addEventListener('input', function(){ $('topkLbl').textContent=this.value; if(shapAll){ explainAll(); } });

  $('btnGen').addEventListener('click', function(){ regenerate(); });
  $('btnSeed').addEventListener('click', function(){ seed=Math.floor(Math.random()*100000); regenerate(); });
  $('btnTrain').addEventListener('click', function(){ train(); });
  $('btnExplain').addEventListener('click', function(){ if(!forest.length){ train(); } explainAll(); });
  $('rowSel').addEventListener('change', function(){ var i=parseInt(this.value); renderLocal(i); });

  // Init
  rng=mulberry32(seed);
  regenerate();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">What is SHAP — and how to read these plots</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>SHAP in one minute</h6>
        <ul class="mb-2">
          <li>SHAP (Shapley Additive Explanations) attributes a model prediction to features fairly, inspired by Shapley values from game theory.</li>
          <li><strong>Local:</strong> Explain one prediction (waterfall shows how each feature pushes it ↑/↓ from the base value).</li>
          <li><strong>Global:</strong> Summarize which features matter overall (mean |SHAP|) and distribution by feature (strip/beeswarm).</li>
        </ul>
        <h6>Reading the plots</h6>
        <ul class="mb-0">
          <li><strong>Global bar:</strong> Taller = more important on average. </li>
          <li><strong>Strip:</strong> Spread shows variability; sign shows direction; color hints at feature value trends.</li>
          <li><strong>Waterfall:</strong> Positive bar pushes prediction up; negative down. Sum + base value = prediction.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Good to know</h6>
        <ul class="mb-2">
          <li>These attributions are <em>explanations</em>, not causality.</li>
          <li>Correlated features can share credit; examine dependence trends.</li>
          <li>Faster method used here: path-based contributions on trees (TreeSHAP‑inspired) for snappy interaction.</li>
        </ul>
        <div class="small-note">Next steps: KernelSHAP option, real datasets, multiclass views, and richer dependence plots.</div>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

<!-- E-E-A-T: About & Learning Outcomes (SHAP) -->
<section class="container my-4">
  <div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
    <h2 class="h6 mb-2">About This Tool & Methodology</h2>
    <p>SHAP (SHapley Additive exPlanations) attributes a model’s prediction to each feature using game‑theoretic Shapley values. This explorer visualizes local (per‑sample) and global (aggregate) attributions and supports dependence/summary plots. For performance, simplified background distributions may be used.</p>
    <h3 class="h6 mt-2">Learning Outcomes</h3>
    <ul class="mb-2">
      <li>Interpret SHAP values as feature contributions to individual predictions.</li>
      <li>Distinguish global importance vs local explanations.</li>
      <li>Recognize interactions and correlated features caveats.</li>
    </ul>
    <div class="row mt-2">
      <div class="col-md-6"><h4 class="h6">Authorship & Review</h4><ul>
        <li><strong>Author:</strong> 8gwifi.org engineering team</li>
        <li><strong>Reviewed by:</strong> Anish Nath</li>
        <li><strong>Last updated:</strong> 2025-11-19</li>
      </ul></div>
      <div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul>
        <li>Runs locally with sample or provided data; no uploads are stored.</li>
      </ul></div>
    </div>
  </div></div></div></div>
</section>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "SHAP Explorer",
  "url": "https://8gwifi.org/shap_explorer.jsp",
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
    {"@type":"ListItem","position":2,"name":"SHAP Explorer","item":"https://8gwifi.org/shap_explorer.jsp"}
  ]
}
</script>

</div> <!-- end shap -->
<%@ include file="body-close.jsp"%>
