<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Categorical Encoding: One-Hot vs Target vs Binary vs WOE (Interactive). Explore encoders, leakage, class imbalance, and model performance with accuracy/ROC-AUC/PR-AUC.">
<meta name="keywords" content="categorical encoding, one-hot, target encoding, mean encoding, weight of evidence, WOE, binary encoding, leakage, k-fold, calibration curve">
<title>Categorical Encoding: One-Hot vs Target vs Binary vs WOE (Interactive)</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Categorical Encoding Lab",
  "description": "Interactive lab comparing one-hot, ordinal, target (with K-fold CV), mean, WOE, and binary encoders. See leakage effects, memory usage, and model performance.",
  "url": "https://8gwifi.org/categorical_encoding_lab.jsp",
  "keywords": "categorical encoding, one-hot vs target encoding, WOE, binary encoding, leakage, cross-validation, calibration"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .celab { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .metric-badge { margin-right:8px; }
  .small-note { font-size:12px; color:#6c757d; }
  .schema-box { background:#f8f9fa; border:1px dashed #ced4da; border-radius:8px; padding:12px; min-height:110px; }
  .formula { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace; background:#fff; border:1px solid #e9ecef; border-radius:6px; padding:8px; display:inline-block; }
  .warn { background:#fff3cd; border:1px solid #ffe69c; color:#664d03; border-radius:6px; padding:8px 10px; }
  .chart-container-lg { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:10px; height:240px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Categorical Encoding Lab</h1>
<p>Compare classic encoders for categorical features. Adjust cardinality, class imbalance, and cross-validation to see how encoders affect memory, leakage, and model performance.</p>

<!-- Quick Access -->
<div class="mb-2">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="celab">
  <div class="row">
    <!-- Left: Encoders + Performance -->
    <div class="col-lg-8 mb-4">
      <!-- Encoder selector & schema -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex align-items-center justify-content-between">
          <h5 class="mb-0">Encoders</h5>
          <div class="small text-muted">One-Hot | Ordinal | Target (CV) | Mean | WOE | Binary</div>
        </div>
        <div class="card-body">
          <ul class="nav nav-pills mb-3" id="encTabs" role="tablist">
            <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#onehot" role="tab">One-Hot</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#ordinal" role="tab">Ordinal</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#target" role="tab">Target (K-fold CV)</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#meanenc" role="tab">Mean</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#woe" role="tab">WOE</a></li>
            <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#binary" role="tab">Binary</a></li>
          </ul>
          <div class="tab-content">
            <div class="tab-pane fade show active" id="onehot" role="tabpanel">
              <div class="schema-box mb-2">
                <strong>Schema:</strong> Category id → sparse vector of length K with a single 1 at index id.<br>
                <span class="formula">x_onehot[i] = 1[i = cat_id]</span>
              </div>
              <div class="small-note">Explodes feature space with high cardinality; linear models like it, trees may not need it.</div>
            </div>
            <div class="tab-pane fade" id="ordinal" role="tabpanel">
              <div class="schema-box mb-2">
                <strong>Schema:</strong> Map category to integer index.<br>
                <span class="formula">x_ordinal = rank(cat)</span>
              </div>
              <div class="small-note">Imposes artificial order and distance; can mislead linear models.</div>
            </div>
            <div class="tab-pane fade" id="target" role="tabpanel">
              <div id="cvWarn" class="warn mb-2" style="display:none;">Warning: CV disabled — target leakage inflates metrics. Enable CV or use out-of-fold encoding.</div>
              <div class="schema-box mb-2">
                <strong>Schema:</strong> Replace category with mean target computed out-of-fold.<br>
                <span class="formula">x_target = E[y | cat] (K-fold, OOF)</span>
              </div>
              <div class="small-note">Powerful but must avoid leakage with K-fold CV or time-based splits; add smoothing for rare categories.</div>
            </div>
            <div class="tab-pane fade" id="meanenc" role="tabpanel">
              <div class="schema-box mb-2">
                <strong>Schema:</strong> Replace category with global mean target per category (no CV).<br>
                <span class="formula">x_mean = mean(y | cat)</span>
              </div>
              <div class="small-note">Convenient but leaky; use only for illustration or with strong regularization and careful validation.</div>
            </div>
            <div class="tab-pane fade" id="woe" role="tabpanel">
              <div class="schema-box mb-2">
                <strong>Schema:</strong> Weight of Evidence (binary): log odds by category with smoothing.<br>
                <span class="formula">woe(cat) = ln((P(y=1|cat)+ε)/(P(y=0|cat)+ε))</span>
              </div>
              <div class="small-note">Often yields well-calibrated scores for logistic models; common in risk scoring.</div>
            </div>
            <div class="tab-pane fade" id="binary" role="tabpanel">
              <div class="schema-box mb-2">
                <strong>Schema:</strong> Encode category index in base-2 using ⌈log2 K⌉ bits.<br>
                <span class="formula">x_bits = bin(cat_id)</span>
              </div>
              <div class="small-note">Very compact; may collide semantics but keeps dimensionality small.</div>
            </div>
          </div>

          <div class="chart-container-sm mt-3">
            <canvas id="featChart"></canvas>
          </div>
          <small class="small-note d-block mt-2">Bar shows feature count per encoder for current cardinality.</small>
        </div>
      </div>

      <!-- Performance -->
      <div class="card">
        <div class="card-header d-flex align-items-center justify-content-between">
          <h5 class="mb-0">Model Performance</h5>
          <div class="small text-muted">Logistic model on synthetic labels (train/test split)</div>
        </div>
        <div class="card-body">
          <div class="mb-2">
            <span class="badge badge-success metric-badge" id="mAcc">Accuracy: —</span>
            <span class="badge badge-primary metric-badge" id="mRoc">ROC-AUC: —</span>
            <span class="badge badge-info metric-badge" id="mPr">PR-AUC: —</span>
            <span class="badge badge-warning metric-badge" id="mTime">Time (sim): —</span>
            <span class="badge badge-secondary metric-badge" id="mMem">Memory: —</span>
          </div>
          <div class="chart-container-lg mb-3">
            <canvas id="perfChart"></canvas>
          </div>
          <div id="calibWrap" class="chart-container-sm" style="display:none;">
            <canvas id="calibChart"></canvas>
          </div>
          <small class="small-note d-block mt-2">Toggle calibration to see predicted probability vs observed rate. Target/WOE often calibrate better than ordinal.</small>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <div class="control-section">
        <h6>Dataset generator</h6>
        <div class="form-group">
          <label class="control-label">Cardinality (K): <strong id="kLbl">100</strong></label>
          <input type="range" id="card" min="5" max="5000" step="5" value="100" class="form-range">
        </div>
        <div class="form-group">
          <label class="control-label">Class imbalance (P[y=1]): <strong id="imbLbl">0.50</strong></label>
          <input type="range" id="imb" min="0.05" max="0.95" step="0.01" value="0.50" class="form-range">
        </div>
      </div>

      <div class="control-section">
        <h6>Validation & leakage</h6>
        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="useCV" checked>
          <label class="form-check-label" for="useCV">Use K-fold CV for Target encoding</label>
        </div>
        <div class="form-group">
          <label class="control-label">K-folds: <strong id="kfoldLbl">5</strong></label>
          <input type="range" id="kfold" min="2" max="10" step="1" value="5" class="form-range">
        </div>
        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="calibOn">
          <label class="form-check-label" for="calibOn">Show calibration curve</label>
        </div>
      </div>

      <div class="control-section">
        <h6>Training</h6>
        <div class="form-group">
          <label class="control-label">Train size: <strong id="trainLbl">70%</strong></label>
          <input type="range" id="trainSplit" min="50" max="90" step="1" value="70" class="form-range">
        </div>
        <div class="row g-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnUpdate">Update</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnReset">Reset</button></div>
        </div>
      </div>

      <div class="control-section">
        <h6>Encoder selection</h6>
        <select id="encSelect" class="form-control">
          <option value="onehot">One-Hot</option>
          <option value="ordinal">Ordinal</option>
          <option value="target">Target (K-fold CV)</option>
          <option value="mean">Mean</option>
          <option value="woe">WOE</option>
          <option value="binary">Binary</option>
        </select>
        <small class="small-note">Use the tabs or this dropdown to switch encoder for performance plots.</small>
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
    <p class="mb-2"><strong>What:</strong> Categorical encoders transform labels into numeric features. Some expand to many columns (one-hot), others compress to 1–few numbers (target, WOE, binary).</p>
    <p class="mb-2"><strong>Why:</strong> Different models react differently to encodings; the right encoder can improve accuracy, calibration, and speed while controlling memory.</p>
    <p class="mb-3"><strong>How to use:</strong> Increase cardinality to see the one-hot blow-up; disable CV to observe optimistic metrics from leakage with target encoding; enable calibration to compare probabilistic quality.</p>
    <ul class="mb-0">
      <li>Target encoding should be out-of-fold (K-fold CV) to avoid leakage.</li>
      <li>WOE uses smoothed log-odds; often well-behaved for logistic models.</li>
      <li>Binary encoding uses ⌈log2 K⌉ bits; very compact but mixes categories.</li>
    </ul>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>

<script>
(function(){
  'use strict';
  function $(id){ return document.getElementById(id); }
  function clamp(x,a,b){ return Math.max(a, Math.min(b, x)); }
  function sigmoid(z){ return 1/(1+Math.exp(-clamp(z,-60,60))); }
  function shuffle(a){ for (var i=a.length-1;i>0;i--){ var j=(Math.random()*(i+1))|0; var t=a[i]; a[i]=a[j]; a[j]=t; } return a; }

  // Charts
  var featChart = new Chart($('featChart').getContext('2d'), {
    type:'bar',
    data:{ labels:['One-Hot','Ordinal','Target','Mean','WOE','Binary'], datasets:[{label:'Features', data:[0,0,0,0,0,0], backgroundColor:'#0d6efd'}]},
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{display:false} }, scales:{ y:{ beginAtZero:true } } }
  });
  var perfChart = new Chart($('perfChart').getContext('2d'), {
    type:'bar',
    data:{ labels:['Accuracy','ROC-AUC','PR-AUC'], datasets:[{ label:'Score', data:[0,0,0], backgroundColor:['#198754','#0d6efd','#20c997'] }]},
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{display:false} }, scales:{ y:{ min:0, max:1 } } }
  });
  var calibChart = new Chart($('calibChart').getContext('2d'), {
    type:'line',
    data:{ labels:[], datasets:[ {label:'Pred vs Observed', data:[], borderColor:'#6f42c1', backgroundColor:'rgba(111,66,193,0.15)', fill:true, pointRadius:2 } ] },
    options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{display:false} }, scales:{ x:{ title:{display:true,text:'Predicted prob'}}, y:{ min:0, max:1, title:{display:true,text:'Observed rate'} } } }
  });

  var state = {
    K: parseInt($('card').value,10),
    p1: parseFloat($('imb').value),
    kfold: parseInt($('kfold').value,10),
    useCV: $('useCV').checked,
    calib: $('calibOn').checked,
    trainPct: parseInt($('trainSplit').value,10) / 100,
    encoder: 'onehot'
  };

  function setLabels(){
    $('kLbl').textContent = state.K;
    $('imbLbl').textContent = state.p1.toFixed(2);
    $('kfoldLbl').textContent = state.kfold;
    $('trainLbl').textContent = Math.round(state.trainPct*100) + '%';
  }

  // Dataset generator: a single categorical feature with per-category base rates around p1
  function makeDataset(N){
    var cats = new Array(N);
    var y = new Array(N);
    var probs = new Float32Array(state.K);
    for (var k=0;k<state.K;k++){
      var jitter = (Math.random()*0.4 - 0.2); // [-0.2, 0.2]
      probs[k] = clamp(state.p1 + jitter, 0.02, 0.98);
    }
    for (var i=0;i<N;i++){
      var c = (Math.random()*state.K)|0;
      cats[i] = c;
      y[i] = Math.random() < probs[c] ? 1 : 0;
    }
    return { cats: cats, y: y, probs: probs };
  }

  function splitTrainTest(data){
    var idx = new Array(data.cats.length); for (var i=0;i<idx.length;i++) idx[i]=i;
    shuffle(idx);
    var nTrain = Math.floor(idx.length * state.trainPct);
    var tr = idx.slice(0, nTrain), te = idx.slice(nTrain);
    function take(arr, ids){ return ids.map(function(i){ return arr[i]; }); }
    return {
      train: { cats: take(data.cats, tr), y: take(data.y, tr) },
      test:  { cats: take(data.cats, te), y: take(data.y, te) }
    };
  }

  // Encoders
  function featuresCountFor(encoder){
    if (encoder==='onehot') return state.K;
    if (encoder==='binary') return Math.ceil(Math.log(state.K)/Math.log(2));
    return 1;
  }

  function encodeOrdinal(cats){ return cats.map(function(c){ return [c]; }); }
  function encodeBinary(cats){
    var bits = Math.ceil(Math.log(state.K)/Math.log(2));
    return cats.map(function(c){
      var row = new Array(bits).fill(0);
      for (var b=0;b<bits;b++){ row[b] = ((c>>b)&1); }
      return row;
    });
  }
  function encodeOneHot(cats){
    var K = state.K;
    return cats.map(function(c){
      var row = new Array(K).fill(0);
      row[c] = 1;
      return row;
    });
  }
  function encodeMean(trainCats, trainY, cats){
    // per-category mean on training only
    var K = state.K, sum=new Float32Array(K), cnt=new Uint32Array(K);
    for (var i=0;i<trainCats.length;i++){ sum[trainCats[i]] += trainY[i]; cnt[trainCats[i]]++; }
    var mean = new Float32Array(K);
    for (var k=0;k<K;k++){ mean[k] = cnt[k] ? (sum[k]/cnt[k]) : 0.5; }
    return cats.map(function(c){ return [mean[c]]; });
  }
  function encodeTargetCV(train, cats){
    if (!state.useCV){
      return encodeMean(train.cats, train.y, cats);
    }
    var K = state.K;
    var n = train.cats.length;
    var idx = new Array(n); for (var i=0;i<n;i++) idx[i]=i;
    // simple round-robin folds
    var folds = state.kfold, foldId = idx.map(function(i){ return i % folds; });
    var sumAll=new Float32Array(K), cntAll=new Uint32Array(K);
    for (var i=0;i<n;i++){ sumAll[train.cats[i]] += train.y[i]; cntAll[train.cats[i]]++; }
    var enc = new Float32Array(n);
    for (var f=0; f<folds; f++){
      var sum=new Float32Array(K), cnt=new Uint32Array(K);
      for (var i=0;i<n;i++){ if (foldId[i]!==f){ sum[train.cats[i]] += train.y[i]; cnt[train.cats[i]]++; } }
      for (var i=0;i<n;i++){
        if (foldId[i]===f){
          var c = train.cats[i];
          var mu = cnt[c] ? (sum[c]/cnt[c]) : (sumAll[c]/Math.max(1,cntAll[c])); // fallback
          enc[i] = mu;
        }
      }
    }
    // map requested cats using full-data mean from train set (as in production transform)
    var muTrain = new Float32Array(K);
    for (var k=0;k<K;k++){ muTrain[k] = cntAll[k] ? (sumAll[k]/cntAll[k]) : 0.5; }
    return {
      trainEnc: enc.map(function(v){ return [v]; }),
      transform: function(catsNew){ return catsNew.map(function(c){ return [muTrain[c]]; }); }
    };
  }
  function encodeWOE(trainCats, trainY, cats){
    var K = state.K, pos=new Float32Array(K), neg=new Float32Array(K), cnt=new Uint32Array(K);
    for (var i=0;i<trainCats.length;i++){
      var c = trainCats[i]; cnt[c]++; if (trainY[i]===1) pos[c]++; else neg[c]++;
    }
    var eps = 0.5; // smoothing
    var w = new Float32Array(K);
    for (var k=0;k<K;k++){ w[k] = Math.log( ((pos[k]+eps)/(cnt[k]+2*eps)) / ((neg[k]+eps)/(cnt[k]+2*eps)) ); }
    return cats.map(function(c){ return [w[c]]; });
  }

  // Simple linear model fit by normal equations (ridge for stability)
  function fitLinear(X, y){
    // X: n x d
    var n = X.length, d = X[0].length;
    var XT = new Array(d); for (var j=0;j<d;j++) XT[j]=new Float64Array(n);
    for (var i=0;i<n;i++) for (var j=0;j<d;j++) XT[j][i]=X[i][j];
    // compute X^T X + λI and X^T y
    var lambda = 1e-3;
    var A = new Array(d); for (var i2=0;i2<d;i2++){ A[i2]=new Float64Array(d); }
    var b = new Float64Array(d);
    for (var i3=0;i3<d;i3++){
      for (var j3=0;j3<d;j3++){
        var s=0; for (var k=0;k<n;k++) s += XT[i3][k]*XT[j3][k];
        A[i3][j3] = s + (i3===j3?lambda:0);
      }
      var sy=0; for (var k2=0;k2<n;k2++) sy += XT[i3][k2]*y[k2];
      b[i3]=sy;
    }
    // solve via Gauss-Jordan
    var M = new Array(d);
    for (var i4=0;i4<d;i4++){ M[i4]=new Float64Array(d+1); for (var j4=0;j4<d;j4++) M[i4][j4]=A[i4][j4]; M[i4][d]=b[i4]; }
    for (var i5=0;i5<d;i5++){
      // pivot
      var maxRow=i5; for (var r=i5+1;r<d;r++) if (Math.abs(M[r][i5])>Math.abs(M[maxRow][i5])) maxRow=r;
      var tmp=M[i5]; M[i5]=M[maxRow]; M[maxRow]=tmp;
      var piv=M[i5][i5]||1e-9; for (var c=i5;c<d+1;c++) M[i5][c]/=piv;
      for (var r2=0;r2<d;r2++){ if (r2===i5) continue; var f=M[r2][i5]; for (var c2=i5;c2<d+1;c2++) M[r2][c2]-=f*M[i5][c2]; }
    }
    var w = new Float64Array(d); for (var i6=0;i6<d;i6++) w[i6]=M[i6][d];
    return w;
  }
  function predictLinear(w, X){
    var n=X.length, d=w.length, out=new Float64Array(n);
    for (var i=0;i<n;i++){ var s=0; for (var j=0;j<d;j++) s+= w[j]*X[i][j]; out[i]=sigmoid(s); }
    return out;
  }

  // Metrics
  function accuracy(y, p){ var c=0; for (var i=0;i<y.length;i++) c+=( (p[i]>=0.5?1:0)===y[i] ); return c/y.length; }
  function rocAuc(y, p){
    // rank by p, compute AUC via Wilcoxon
    var idx = y.map(function(_,i){return i;}).sort(function(a,b){ return p[a]-p[b]; });
    var rank = new Float64Array(y.length);
    for (var i=0;i<idx.length;i++) rank[idx[i]]=i+1;
    var pos=0, sumRank=0; for (var i2=0;i2<y.length;i2++){ if (y[i2]===1){ pos++; sumRank+=rank[i2]; } }
    var neg = y.length - pos; if (pos===0||neg===0) return 0.5;
    return (sumRank - pos*(pos+1)/2) / (pos*neg);
  }
  function prAuc(y, p){
    // simple interpolation PR AUC
    var pairs = y.map(function(v,i){ return {y:v, p:p[i]}; }).sort(function(a,b){ return b.p-a.p; });
    var tp=0, fp=0, fn = y.reduce(function(s,v){return s+(v===1?1:0);},0);
    var prevR=0, prevP=1, auc=0;
    for (var i=0;i<pairs.length;i++){
      if (pairs[i].y===1){ tp++; fn--; } else { fp++; }
      var prec = tp/(tp+fp);
      var rec = tp/(tp+fn+0.0000001);
      auc += (rec - prevR) * prec;
      prevR = rec; prevP = prec;
    }
    return clamp(auc, 0, 1);
  }

  function estimateTime(d, n){ return ((d*n)/1e6).toFixed(2) + ' MU'; } // simulated units
  function estimateMem(d){ return (d * 4 / (1024*1024)).toFixed(2) + ' MB'; }

  // Build features for a chosen encoder
  function makeFeatures(encoder, train, test){
    var d = 1, Xtr, Xte, leak=false;
    if (encoder==='onehot'){ d=state.K; Xtr=encodeOneHot(train.cats); Xte=encodeOneHot(test.cats); }
    else if (encoder==='ordinal'){ d=1; Xtr=encodeOrdinal(train.cats); Xte=encodeOrdinal(test.cats); }
    else if (encoder==='binary'){ d=Math.ceil(Math.log(state.K)/Math.log(2)); Xtr=encodeBinary(train.cats); Xte=encodeBinary(test.cats); }
    else if (encoder==='mean'){ d=1; Xtr=encodeMean(train.cats, train.y, train.cats); Xte=encodeMean(train.cats, train.y, test.cats); leak=true; }
    else if (encoder==='target'){
      var res = encodeTargetCV(train, test.cats);
      if (state.useCV){
        // res has trainEnc (OOF) and transform
        Xtr = res.trainEnc; Xte = res.transform(test.cats);
      } else {
        Xtr = encodeMean(train.cats, train.y, train.cats);
        Xte = encodeMean(train.cats, train.y, test.cats);
        leak = true;
      }
    }
    else if (encoder==='woe'){ d=1; Xtr=encodeWOE(train.cats, train.y, train.cats); Xte=encodeWOE(train.cats, train.y, test.cats); }
    return { d:d, Xtr:Xtr, Xte:Xte, leak:leak };
  }

  function updateFeatChart(){
    var counts = [
      featuresCountFor('onehot'),
      featuresCountFor('ordinal'),
      featuresCountFor('target'),
      featuresCountFor('mean'),
      featuresCountFor('woe'),
      featuresCountFor('binary')
    ];
    featChart.data.datasets[0].data = counts;
    featChart.update('none');
  }

  function run(){
    state.K = parseInt($('card').value,10);
    state.p1 = parseFloat($('imb').value);
    state.kfold = parseInt($('kfold').value,10);
    state.useCV = $('useCV').checked;
    state.calib = $('calibOn').checked;
    state.trainPct = parseInt($('trainSplit').value,10)/100;
    setLabels();
    updateFeatChart();

    var data = makeDataset(Math.max(3000, Math.min(20000, state.K*30)));
    var parts = splitTrainTest(data);
    var enc = state.encoder;
    var pack = makeFeatures(enc, parts.train, parts.test);
    $('cvWarn').style.display = (enc==='target' && !state.useCV) ? '' : 'none';

    // Fit model
    var w = fitLinear(pack.Xtr, parts.train.y);
    var p = predictLinear(w, pack.Xte);
    var acc = accuracy(parts.test.y, p);
    var auc = rocAuc(parts.test.y, p);
    var prc = prAuc(parts.test.y, p);

    // Metrics
    $('mAcc').textContent = 'Accuracy: ' + (acc*100).toFixed(1) + '%';
    $('mRoc').textContent = 'ROC-AUC: ' + auc.toFixed(3);
    $('mPr').textContent  = 'PR-AUC: ' + prc.toFixed(3);
    $('mTime').textContent = 'Time (sim): ' + estimateTime(pack.d, parts.train.y.length);
    $('mMem').textContent  = 'Memory: ' + estimateMem(pack.d);

    perfChart.data.datasets[0].data = [acc, auc, prc];
    perfChart.update('none');

    // Calibration
    $('calibWrap').style.display = state.calib ? '' : 'none';
    if (state.calib){
      // bin by predicted prob
      var bins = 10, cnt=new Array(bins).fill(0), sum=new Array(bins).fill(0);
      for (var i=0;i<p.length;i++){
        var b = Math.min(bins-1, Math.floor(p[i]*bins));
        cnt[b]++; sum[b]+=parts.test.y[i];
      }
      var xs=[], ys=[];
      for (var b2=0;b2<bins;b2++){ var mid=(b2+0.5)/bins; xs.push(mid); ys.push(cnt[b2]? (sum[b2]/cnt[b2]) : null); }
      calibChart.data.labels = xs;
      calibChart.data.datasets[0].data = ys;
      calibChart.update('none');
    }
  }

  // Sync tab clicks with dropdown
  Array.prototype.slice.call(document.querySelectorAll('#encTabs a')).forEach(function(a){
    a.addEventListener('click', function(e){
      var val = a.getAttribute('href').substring(1);
      var map = { onehot:'onehot', ordinal:'ordinal', target:'target', meanenc:'mean', woe:'woe', binary:'binary' };
      state.encoder = map[val] || 'onehot';
      $('encSelect').value = state.encoder;
      run();
    });
  });
  $('encSelect').addEventListener('change', function(){
    state.encoder = this.value;
    // activate corresponding tab visually
    var tabId = {onehot:'#onehot', ordinal:'#ordinal', target:'#target', mean:'#meanenc', woe:'#woe', binary:'#binary'}[state.encoder];
    if (tabId){
      var el = document.querySelector('#encTabs a[href="'+tabId+'"]');
      if (el && window.jQuery && jQuery.fn.tab){ jQuery(el).tab('show'); }
    }
    run();
  });

  // Bind controls
  ['card','imb','kfold','useCV','calibOn','trainSplit'].forEach(function(id){
    $(id).addEventListener('input', run);
  });
  $('btnUpdate').addEventListener('click', run);
  $('btnReset').addEventListener('click', function(){
    $('card').value = 100; $('imb').value = 0.50; $('kfold').value = 5; $('useCV').checked = true; $('calibOn').checked = false; $('trainSplit').value = 70;
    $('encSelect').value = 'onehot';
    var el = document.querySelector('#encTabs a[href="#onehot"]'); if (el && window.jQuery && jQuery.fn.tab){ jQuery(el).tab('show'); }
    run();
  });

  // Init
  setLabels();
  updateFeatChart();
  run();
})();
</script>
</html>
