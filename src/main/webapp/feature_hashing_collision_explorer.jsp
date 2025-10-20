<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Feature Hashing (Hashing Trick) Explained Visually — see bucket collisions, signed hashing, and downstream model impact with accuracy vs. bucket size.">
<meta name="keywords" content="feature hashing, hashing trick, collision rate, signed hashing, text features, ad logs, memory vs accuracy">
<title>Feature Hashing (Hashing Trick) Explained Visually</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Feature Hashing Collision Explorer",
  "description": "Visual explorer for the hashing trick: control number of categories, bucket size, signed hashing, and distribution (uniform vs Zipf). See collisions and model impact.",
  "url": "https://8gwifi.org/feature_hashing_collision_explorer.jsp",
  "keywords": "feature hashing, hashing trick, signed hashing, collisions, bucket size, memory footprint"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .fh { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-lg { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:380px; }
  .chart-container-sm { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:10px; height:240px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .metric-badge { margin-right:8px; }
  .small-note { font-size:12px; color:#6c757d; }
  .legend-chip { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
  .bucket-info { font-size:12px; max-height:110px; overflow:auto; border-top:1px dashed #e9ecef; margin-top:8px; padding-top:6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Feature Hashing Collision Explorer</h1>
<p>Explore the “hashing trick” for large, sparse categorical spaces (e.g., text tokens or ads logs). Adjust bucket size and distribution to see how collisions change and how signed hashing stabilizes downstream models.</p>

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

<div class="fh">
  <div class="row">
    <!-- Left: Visualizations -->
    <div class="col-lg-8 mb-4">
      <!-- Bucket Distribution -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Bucket Distribution & Collisions</h5>
          <div class="small">
            <span class="legend-chip" style="background:#0d6efd;"></span>Count per bucket
            <span class="legend-chip" style="background:#dc3545;"></span>Collision highlight
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-lg">
            <canvas id="bucketChart"></canvas>
          </div>
          <div class="d-flex flex-wrap align-items-center mt-2">
            <span class="badge badge-primary metric-badge" id="mCollisionRate">Collision rate: —</span>
            <span class="badge badge-info metric-badge" id="mAvgLoad">Avg load/bucket: —</span>
            <span class="badge badge-success metric-badge" id="mMem">Memory: —</span>
            <span class="badge badge-warning metric-badge" id="mAcc">Accuracy: —</span>
          </div>
          <div id="bucketInfo" class="bucket-info text-muted">Hover a bucket to list colliding categories.</div>
        </div>
      </div>

      <!-- Downstream model impact -->
      <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Downstream Model Impact</h5>
          <small class="text-muted">Synthetic linear classifier; signed hashing should center features (mean ≈ 0)</small>
        </div>
        <div class="card-body">
          <div class="chart-container-sm mb-3">
            <canvas id="accChart"></canvas>
          </div>
          <div class="chart-container-sm">
            <canvas id="memChart"></canvas>
          </div>
          <small class="small-note d-block mt-2">Drag “buckets” down to see collisions explode and accuracy drop; toggle “signed hashing” to reduce bias from collisions. Memory bars compare one-hot vs hashed vectors.</small>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <div class="control-section">
        <h6>Data scale</h6>
        <div class="form-group">
          <label class="control-label"># categories: <strong id="catLbl">10,000</strong></label>
          <input type="range" id="catExp" min="2" max="6" step="0.1" value="4" class="form-range">
          <small class="small-note">Exponent 10^x (100 → 1,000,000). Uses sampling to keep it fast.</small>
        </div>
        <div class="form-group">
          <label class="control-label">Samples drawn: <strong id="sampLbl">20000</strong></label>
          <input type="range" id="samples" min="2000" max="50000" step="1000" value="20000" class="form-range">
        </div>
      </div>

      <div class="control-section">
        <h6>Hashing</h6>
        <div class="form-group">
          <label class="control-label">Hash buckets (vector size): <strong id="bucketLbl">1024</strong></label>
          <input type="range" id="buckets" min="16" max="8192" step="1" value="1024" class="form-range">
          <small class="small-note">Use powers of two for faster modulo; lower buckets → more collisions.</small>
        </div>
        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="signedHash" checked>
          <label class="form-check-label" for="signedHash">Signed hashing (±1)</label>
        </div>
        <div class="form-group">
          <label class="control-label" for="distMode">Distribution</label>
          <select class="form-control" id="distMode">
            <option value="uniform">Uniform categories</option>
            <option value="zipf">Zipf/skewed</option>
          </select>
        </div>
        <div class="form-group form-check">
          <input type="checkbox" class="form-check-input" id="highlight" checked>
          <label class="form-check-label" for="highlight">Collision highlighting</label>
        </div>
        <div class="row g-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnUpdate">Update</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnReset">Reset</button></div>
        </div>
      </div>
    </div>
  </div>
</div>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">How to interpret</h5>
  </div>
  <div class="card-body">
    <p class="mb-2"><strong>What:</strong> Feature hashing maps a potentially huge set of categories (tokens, ids) into a fixed-size vector by hashing each category to a bucket. Optional signed hashing assigns ±1 so the expected contribution per feature is near zero.</p>
    <p class="mb-2"><strong>Why:</strong> It provides a memory- and speed-efficient alternative to one-hot encoding when the vocabulary is large or evolving (e.g., ad logs, search queries, URLs).</p>
    <p class="mb-3"><strong>How to read the plots:</strong> The bucket chart shows counts per bucket; red marks indicate buckets receiving multiple categories (collisions). The accuracy panel trains a tiny synthetic linear model; as buckets shrink, interference from collisions grows and accuracy degrades. Signed hashing reduces systematic bias by centering collisions.</p>
    <ul class="mb-0">
      <li>Collision rate rises roughly with (#categories / #buckets) and skewed (Zipf) traffic can overload a few buckets.</li>
      <li>Average load per bucket ≈ samples / buckets; memory footprint scales with vector size, not with vocabulary.</li>
      <li>Compare one-hot vs hashing memory in the lower chart; hashing keeps constant memory even as categories grow.</li>
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
  function fmtInt(n){ return n.toLocaleString(); }

  // Simple 32-bit hash (djb2-like) and a second for sign
  function hash32(str, seed){
    var h = 5381 ^ (seed||0);
    for (var i=0;i<str.length;i++){ h = ((h<<5)+h) + str.charCodeAt(i); h|=0; }
    return (h>>>0);
  }
  function signHash(str){ return (hash32(str, 1337) & 1) ? 1 : -1; }

  // Zipf sampler for 1..N with s≈1.0 using harmonic normalization (approx)
  function ZipfSampler(N){
    var s = 1.0;
    var HN = 0;
    for (var i=1;i<=Math.min(N,100000);i++){ HN += 1/i; }
    return function(){
      // inverse-CDF by rejection sampling (approx for demo)
      var u = Math.random() * HN;
      var acc = 0;
      for (var k=1;k<=N;k++){
        acc += 1/k;
        if (acc >= u) return k-1; // 0-based category id
        if (k>100000 && acc/HN > Math.random()) return k-1; // fast exit for large N
      }
      return Math.floor(Math.random()*N);
    };
  }

  // Charts
  var bucketChart, accChart, memChart;

  function buildCharts(){
    if (!bucketChart){
      bucketChart = new Chart($('bucketChart').getContext('2d'), {
        type:'bar',
        data:{ labels:[], datasets:[ {label:'Count', data:[], backgroundColor:[] } ] },
        options:{
          responsive:true, maintainAspectRatio:false,
          scales:{ x:{ ticks:{ display:false } }, y:{ beginAtZero:true } },
          plugins:{ legend:{ display:false }, tooltip:{ enabled:true,
            callbacks:{
              title:function(ctx){ return 'Bucket ' + ctx[0].dataIndex; },
              afterBody:function(ctx){
                var idx = ctx[0].dataIndex;
                return bucketHoverInfo(idx);
              }
            }}}
        }
      });
    }
    if (!accChart){
      accChart = new Chart($('accChart').getContext('2d'), {
        type:'line',
        data:{ labels:[], datasets:[ {label:'Accuracy', data:[], borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.15)', fill:true, pointRadius:2 } ] },
        options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ min:0, max:1 } }, plugins:{ legend:{ display:false } } }
      });
    }
    if (!memChart){
      memChart = new Chart($('memChart').getContext('2d'), {
        type:'bar',
        data:{ labels:['One-hot','Hashing'], datasets:[
          { label:'Memory (MB)', data:[0,0], backgroundColor:['#6c757d','#0d6efd'] }
        ]},
        options:{ responsive:true, maintainAspectRatio:false, scales:{ y:{ beginAtZero:true } }, plugins:{ legend:{ display:false } } }
      });
    }
  }

  // State and buffers
  var state = {
    categories: Math.round(Math.pow(10, parseFloat($('catExp').value))),
    buckets: parseInt($('buckets').value, 10),
    samples: parseInt($('samples').value, 10),
    signed: $('signedHash').checked,
    dist: $('distMode').value,
    highlight: $('highlight').checked
  };

  var bucketMap = []; // array of {count, cats: Set}
  var groupFactor = 1; // when aggregating for > 1024 buckets

  function bucketHoverInfo(displayIdx){
    // Map from display index back to raw bucket span
    var start = displayIdx * groupFactor;
    var end = Math.min(start + groupFactor, state.buckets);
    var cats = new Set();
    for (var b=start; b<end; b++){
      if (bucketMap[b] && bucketMap[b].cats){
        bucketMap[b].cats.forEach(function(c){ cats.add(c); });
      }
    }
    var arr = Array.from(cats);
    if (arr.length <= 1) return ['No collisions'];
    var preview = arr.slice(0, 12).map(function(x){ return '• ' + x; }).join('\n');
    if (arr.length > 12) preview += '\n… +' + (arr.length-12) + ' more';
    return ['Colliding categories:', preview];
  }

  function genSamples(){
    // Prepare samplers
    var N = state.categories;
    var sampler = state.dist === 'zipf' ? ZipfSampler(N) : function(){ return Math.floor(Math.random()*N); };

    // Reset buckets
    bucketMap = new Array(state.buckets);
    for (var i=0;i<state.buckets;i++){ bucketMap[i] = { count:0, cats:new Set() }; }

    // Draw samples and place into buckets
    for (var s=0;s<state.samples;s++){
      var cid = sampler();
      var cname = 'C' + cid;
      var h = hash32(cname, 0);
      var b = h % state.buckets;
      bucketMap[b].count++;
      bucketMap[b].cats.add(cname);
    }
  }

  // Synthetic downstream model:
  // Assign true weight per category; hashed model aggregates weights into buckets (with signs if enabled).
  function evaluateModel(){
    var N = state.categories;
    var sampler = state.dist === 'zipf' ? ZipfSampler(N) : function(){ return Math.floor(Math.random()*N); };
    var signed = state.signed;

    // training: build hashed weights from a smaller training sample (reduce cost)
    var trainN = Math.max(2000, Math.min(state.samples, 20000));
    var wHash = new Float32Array(state.buckets);
    var wCat = new Map(); // store only seen categories
    for (var i=0;i<trainN;i++){
      var cid = sampler();
      var cname = 'C' + cid;
      // true weight
      var w = wCat.has(cname) ? wCat.get(cname) : ((Math.random()*2-1) * 1.0);
      wCat.set(cname, w);
      var b = hash32(cname, 0) % state.buckets;
      var s = signed ? signHash(cname) : 1;
      wHash[b] += s * w;
    }

    // test
    var testN = Math.max(2000, Math.min(state.samples, 20000));
    var correct = 0;
    for (var j=0;j<testN;j++){
      var cid = sampler();
      var cname = 'C' + cid;
      var wtrue = wCat.has(cname) ? wCat.get(cname) : ((Math.random()*2-1) * 1.0);
      var b = hash32(cname, 0) % state.buckets;
      var s = signed ? signHash(cname) : 1;
      var y = (wtrue > 0) ? 1 : 0;               // label from true weight sign
      var yhat = ((s * wHash[b]) > 0) ? 1 : 0;   // predicted from hashed bucket weight
      if (y === yhat) correct++;
    }
    return correct / testN;
  }

  function updateMetrics(){
    // collision rate: fraction of samples that landed in buckets with size>1 categories (approx)
    var collSamples = 0, totalCatsInBuckets = 0;
    for (var b=0;b<state.buckets;b++){
      var cats = bucketMap[b].cats.size;
      if (cats > 1) collSamples += bucketMap[b].count;
      totalCatsInBuckets += cats;
    }
    var collisionRate = state.samples === 0 ? 0 : (collSamples / state.samples);
    var avgLoad = state.buckets === 0 ? 0 : (state.samples / state.buckets);

    // memory: 4 bytes per float
    var memOneHot = state.categories * 4 / (1024*1024);
    var memHash = state.buckets * 4 / (1024*1024);

    $('mCollisionRate').textContent = 'Collision rate: ' + (collisionRate*100).toFixed(1) + '%';
    $('mAvgLoad').textContent = 'Avg load/bucket: ' + avgLoad.toFixed(2);
    $('mMem').textContent = 'Memory: one-hot ' + memOneHot.toFixed(1) + ' MB vs hashing ' + memHash.toFixed(2) + ' MB';
  }

  function drawBucketChart(){
    // If many buckets, aggregate to at most 1024 bars
    var B = state.buckets;
    groupFactor = Math.ceil(B / 256); // show up to 256 bars for clarity
    var showBars = Math.ceil(B / groupFactor);

    var labels = new Array(showBars);
    var data = new Array(showBars);
    var colors = new Array(showBars);

    for (var i=0;i<showBars;i++){
      labels[i] = '' + i;
      var start = i*groupFactor, end = Math.min(start+groupFactor, B);
      var sum=0, coll=false;
      for (var b=start;b<end;b++){
        sum += bucketMap[b].count;
        if (state.highlight && bucketMap[b].cats.size>1) coll = true;
      }
      data[i] = sum;
      colors[i] = coll ? 'rgba(220,53,69,0.6)' : 'rgba(13,110,253,0.6)';
    }

    bucketChart.data.labels = labels;
    bucketChart.data.datasets[0].data = data;
    bucketChart.data.datasets[0].backgroundColor = colors;
    bucketChart.update('none');
  }

  function drawAccAndMemory(){
    // Accuracy across bucket sizes around current
    var base = state.buckets;
    var grid = [Math.max(16, Math.floor(base/4)), Math.max(16, Math.floor(base/2)), base, Math.min(8192, base*2), Math.min(8192, base*4)];
    var accs = [];
    var keep = { buckets: state.buckets, signed: state.signed, dist: state.dist, categories: state.categories, samples: state.samples };

    for (var i=0;i<grid.length;i++){
      state.buckets = grid[i];
      genSamples();
      accs.push(evaluateModel());
    }
    // restore
    state.buckets = keep.buckets;
    genSamples();

    accChart.data.labels = grid.map(function(x){ return x; });
    accChart.data.datasets[0].data = accs;
    accChart.update('none');

    // Memory bars
    var memOneHot = state.categories * 4 / (1024*1024);
    var memHash = state.buckets * 4 / (1024*1024);
    memChart.data.datasets[0].data = [memOneHot, memHash];
    memChart.update('none');

    // Accuracy badge
    var accNow = accs[2]; // current bucket size
    $('mAcc').textContent = 'Accuracy: ' + (accNow*100).toFixed(1) + '%';
  }

  function rebuild(){
    state.categories = Math.round(Math.pow(10, parseFloat($('catExp').value)));
    state.buckets = parseInt($('buckets').value,10);
    state.samples = parseInt($('samples').value,10);
    state.signed = $('signedHash').checked;
    state.dist = $('distMode').value;
    state.highlight = $('highlight').checked;

    $('catLbl').textContent = fmtInt(state.categories);
    $('bucketLbl').textContent = fmtInt(state.buckets);
    $('sampLbl').textContent = fmtInt(state.samples);

    genSamples();
    updateMetrics();
    drawBucketChart();
    drawAccAndMemory();
  }

  // Bindings
  ['catExp','buckets','samples','signedHash','distMode','highlight'].forEach(function(id){
    $(id).addEventListener('input', rebuild);
  });
  $('btnUpdate').addEventListener('click', rebuild);
  $('btnReset').addEventListener('click', function(){
    $('catExp').value = 4;
    $('buckets').value = 1024;
    $('samples').value = 20000;
    $('signedHash').checked = true;
    $('distMode').value = 'uniform';
    $('highlight').checked = true;
    rebuild();
  });

  // Initialize
  buildCharts();
  rebuild();
})();
</script>
</html>
