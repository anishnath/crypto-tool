<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Clustering Studio - Interactive K-Means, DBSCAN, and Hierarchical clustering on 2D datasets with elbow and silhouette visualizations.">
<meta name="keywords" content="clustering, k-means, dbscan, hierarchical, agglomerative, silhouette, elbow method, machine learning visualization">
<title>Clustering Studio - Unsupervised Learning Playground</title>

<%@ include file="header-script.jsp"%>

<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Clustering Studio",
  "description": "Interactive K-Means, DBSCAN, and Hierarchical clustering visualizer with elbow and silhouette plots.",
  "url": "https://8gwifi.org/clustering_studio.jsp",
  "keywords": "clustering, k-means, dbscan, hierarchical clustering, silhouette score, elbow method"
}
</script>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<style>
  .clust-viz { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .chart-container-md { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:360px; }
  .chart-container-sm { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:15px; height:240px; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  #clusterCanvas { width:100%; height:100%; background:#fff; border:2px solid #e9ecef; border-radius:6px; cursor:crosshair; }
  .metric-card { background:linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color:#fff; border-radius:8px; padding:14px; text-align:center; margin-bottom:10px; }
  .metric-card.green { background:linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }
  .metric-card.pink { background:linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
  .metric-label { font-size:12px; opacity:0.9; margin-bottom:5px; }
  .metric-value { font-size:22px; font-weight:bold; font-family:'Courier New', monospace; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">🧩 Clustering Studio</h1>
<p>Compare K-Means, DBSCAN, and Hierarchical clustering on 2D datasets. Adjust parameters, add noise, and understand when each method works best.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#charts" class="btn btn-outline-primary">Elbow/Silhouette</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="clust-viz">
  <div class="row">
    <!-- Left column -->
    <div class="col-lg-8 mb-4">
      <!-- Visualization -->
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Dataset & Clusters</h5>
          <div class="form-check form-switch">
            <input class="form-check-input" type="checkbox" id="chkRegions" checked>
            <label class="form-check-label small" for="chkRegions">Show cluster regions</label>
          </div>
        </div>
        <div class="card-body">
          <div class="chart-container-md">
            <canvas id="clusterCanvas"></canvas>
          </div>
          <small class="text-muted d-block mt-2">Tip: Click on the canvas to add a point to the selected class (used only for coloring reference; clustering ignores labels).</small>
          <div class="row mt-3">
            <div class="col-md-4"><div class="metric-card"><div class="metric-label"># Clusters</div><div class="metric-value" id="mClusters">—</div></div></div>
            <div class="col-md-4"><div class="metric-card green"><div class="metric-label">Silhouette</div><div class="metric-value" id="mSil">—</div></div></div>
            <div class="col-md-4"><div class="metric-card pink"><div class="metric-label">Noise</div><div class="metric-value" id="mNoise">—</div></div></div>
          </div>
        </div>
      </div>

      <!-- Charts -->
      <div class="card mb-4" id="charts">
        <div class="card-header">
          <h5 class="mb-0">Elbow & Silhouette</h5>
        </div>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6">
              <h6 class="small">Elbow (Within-Cluster Sum of Squares)</h6>
              <div class="chart-container-sm">
                <canvas id="elbowChart"></canvas>
              </div>
            </div>
            <div class="col-md-6">
              <h6 class="small">Silhouette by K (K-Means)</h6>
              <div class="chart-container-sm">
                <canvas id="silChart"></canvas>
              </div>
            </div>
          </div>
          <small class="text-muted d-block mt-2">Elbow suggests a good K when the curve bends; Silhouette closer to 1 is better separation.</small>
        </div>
      </div>
    </div>

    <!-- Right column -->
    <div class="col-lg-4 mb-4" id="controls">
      <!-- Dataset -->
      <div class="control-section">
        <h6>📦 Dataset</h6>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnBlobs">Blobs</button>
          <button class="btn btn-outline-secondary" id="btnOverlap">Overlap</button>
        </div>
        <div class="btn-group btn-group-sm w-100 mb-2" role="group">
          <button class="btn btn-outline-secondary" id="btnMoons">Moons</button>
          <button class="btn btn-outline-secondary" id="btnCircles">Circles</button>
        </div>
        <div class="row g-2">
          <div class="col">
            <label class="form-label small">Color by (for display)</label>
            <select id="colorBy" class="form-select form-select-sm">
              <option value="cluster" selected>Cluster</option>
              <option value="class">Class</option>
            </select>
          </div>
          <div class="col">
            <label class="form-label small">Noise</label>
            <input type="range" id="noise" min="0" max="0.5" step="0.01" value="0.10" class="form-range">
          </div>
        </div>
        <div class="row g-2 mt-2">
          <div class="col">
            <label class="form-label small">Class to add</label>
            <select id="addClass" class="form-select form-select-sm">
              <option value="1">Class 1 (Green)</option>
              <option value="0">Class 0 (Red)</option>
            </select>
          </div>
          <div class="col">
            <button class="btn btn-danger btn-sm w-100" id="btnClear">Clear Points</button>
          </div>
        </div>
      </div>

      <!-- Algorithm -->
      <div class="control-section">
        <h6>⚙️ Algorithm</h6>
        <div class="mb-2">
          <select id="algo" class="form-select form-select-sm">
            <option value="kmeans" selected>K-Means</option>
            <option value="dbscan">DBSCAN</option>
            <option value="hier">Hierarchical (Agglomerative)</option>
          </select>
        </div>

        <div id="rowK">
          <div class="slider-label"><span>K (clusters)</span><strong id="kVal">3</strong></div>
          <input type="range" id="k" min="2" max="10" step="1" value="3" class="form-range">
        </div>

        <div id="rowDB" style="display:none;">
          <div class="slider-label"><span>eps</span><strong id="epsVal">0.20</strong></div>
          <input type="range" id="eps" min="0.05" max="0.8" step="0.01" value="0.20" class="form-range">
          <div class="slider-label"><span>minPts</span><strong id="minPtsVal">5</strong></div>
          <input type="range" id="minPts" min="2" max="20" step="1" value="5" class="form-range">
        </div>

        <div id="rowHier" style="display:none;">
          <label class="form-label small">Linkage</label>
          <select id="linkage" class="form-select form-select-sm">
            <option value="single">Single</option>
            <option value="complete" selected>Complete</option>
            <option value="average">Average</option>
          </select>
        </div>

        <div class="row g-2 mt-2">
          <div class="col"><button class="btn btn-primary btn-sm w-100" id="btnRun">Run</button></div>
          <div class="col"><button class="btn btn-outline-secondary btn-sm w-100" id="btnElbow">Elbow K-Means</button></div>
        </div>
      </div>

      <!-- Metrics -->
      <div class="control-section">
        <h6>📊 Metrics</h6>
        <div class="small">
          <div>Clusters found: <strong id="mtClusters">—</strong></div>
          <div>Noise points: <strong id="mtNoise">—</strong></div>
          <div>Silhouette score: <strong id="mtSil">—</strong></div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function() {
  // Helpers
  function $(id){ return document.getElementById(id); }
  function randn(){ var u=0,v=0; while(u===0)u=Math.random(); while(v===0)v=Math.random(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v); }
  function shuffle(a){ for(var i=a.length-1;i>0;i--){ var j=Math.floor(Math.random()*(i+1)); var t=a[i]; a[i]=a[j]; a[j]=t; } return a; }
  function dist(a,b){ var dx=a.x-b.x, dy=a.y-b.y; return Math.sqrt(dx*dx+dy*dy); }

  // Canvas
  var canvas=$('clusterCanvas'), ctx=canvas.getContext('2d');
  function resizeCanvas(){ var p=canvas.parentElement; canvas.width=Math.max(320, p.clientWidth-4); canvas.height=Math.max(260, p.clientHeight-4); drawAll(); }
  window.addEventListener('resize', resizeCanvas);

  // Domain mapping [-2,2] for both axes
  function toCanvas(x,y){ var W=canvas.width,H=canvas.height; var nx=(x+2)/4, ny=(y+2)/4; return {cx:nx*W, cy:(1-ny)*H}; }
  function toDomain(cx,cy){ var W=canvas.width,H=canvas.height; var nx=cx/W, ny=1-(cy/H); return {x:nx*4-2, y:ny*4-2}; }

  // Data
  var points = []; // {x,y,c} c is optional class for display
  var labels = []; // clustering labels (kmeans/hier >=0, dbscan -1 noise)
  var clusterCount = 0, noiseCount = 0;
  var silScore = null;

  // Charts
  var elbowChart = new Chart($('elbowChart'), { type:'line', data:{ labels:[], datasets:[{ label:'WCSS', data:[], borderColor:'#0d6efd', backgroundColor:'rgba(13,110,253,0.1)', borderWidth:2, tension:0.25, fill:true }]}, options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{ display:false } }, scales:{ x:{ title:{display:true,text:'K'}}, y:{ title:{display:true,text:'WCSS'}, beginAtZero:true } } }});
  var silChart   = new Chart($('silChart'),   { type:'line', data:{ labels:[], datasets:[{ label:'Silhouette', data:[], borderColor:'#198754', backgroundColor:'rgba(25,135,84,0.1)', borderWidth:2, tension:0.25, fill:true }]}, options:{ responsive:true, maintainAspectRatio:false, plugins:{ legend:{ display:false } }, scales:{ x:{ title:{display:true,text:'K'}}, y:{ title:{display:true,text:'Score'}, min:-1, max:1 } } }});

  // Dataset generators
  function genBlobs(){
    points=[];
    var n=200, s=0.35;
    for(var i=0;i<n/2;i++) points.push({x:-1.2+randn()*s, y:-1.0+randn()*s, c:0});
    for(var j=0;j<n/2;j++) points.push({x: 1.2+randn()*s, y: 1.0+randn()*s, c:1});
    addNoise(parseFloat($('noise').value));
    runClustering();
  }
  function genOverlap(){
    points=[];
    var n=220, s=0.8;
    for(var i=0;i<n/2;i++) points.push({x:-0.5+randn()*s, y:-0.5+randn()*s, c:0});
    for(var j=0;j<n/2;j++) points.push({x: 0.5+randn()*s, y: 0.5+randn()*s, c:1});
    addNoise(parseFloat($('noise').value));
    runClustering();
  }
  function genMoons(){
    points=[];
    var n=200;
    for(var i=0;i<n/2;i++){ var t=Math.PI*i/(n/2); points.push({x:Math.cos(t)+randn()*0.08, y:Math.sin(t)+randn()*0.08, c:0}); }
    for(var j=0;j<n/2;j++){ var t2=Math.PI*j/(n/2); points.push({x:Math.cos(t2)+0.9+randn()*0.08, y:-Math.sin(t2)+0.3+randn()*0.08, c:1}); }
    addNoise(parseFloat($('noise').value));
    runClustering();
  }
  function genCircles(){
    points=[];
    var n=240;
    for(var i=0;i<n/2;i++){ var r=0.6+randn()*0.06; var t=2*Math.PI*Math.random(); points.push({x:r*Math.cos(t), y:r*Math.sin(t), c:0}); }
    for(var j=0;j<n/2;j++){ var r2=1.2+randn()*0.08; var t2=2*Math.PI*Math.random(); points.push({x:r2*Math.cos(t2), y:r2*Math.sin(t2), c:1}); }
    addNoise(parseFloat($('noise').value));
    runClustering();
  }
  function addNoise(level){
    var nNoise = Math.floor(points.length * level);
    for(var i=0;i<nNoise;i++){
      points.push({x:-2+Math.random()*4, y:-2+Math.random()*4, c: (Math.random()<0.5?0:1)});
    }
  }

  // KMeans (k-means++)
  function kmeansPlusPlusInit(K){
    var cents=[];
    var idx=Math.floor(Math.random()*points.length);
    cents.push({x:points[idx].x, y:points[idx].y});
    while(cents.length<K){
      var dists=[], sum=0;
      for(var i=0;i<points.length;i++){
        var minD=Infinity;
        for(var c=0;c<cents.length;c++){ var dc=dist(points[i], cents[c]); if(dc<minD) minD=dc; }
        var w=minD*minD; dists.push(w); sum+=w;
      }
      var r=Math.random()*sum, acc=0, pick=0;
      for(var j=0;j<dists.length;j++){ acc+=dists[j]; if(acc>=r){ pick=j; break; } }
      cents.push({x:points[pick].x, y:points[pick].y});
    }
    return cents;
  }
  function kmeansRun(K, maxIter){
    if(points.length===0) return {labels:[], cents:[], wcss:0};
    var cents=kmeansPlusPlusInit(K);
    var lbl=new Array(points.length), changed=true, iter=0;
    while(changed && iter<maxIter){
      changed=false; iter++;
      // assign
      for(var i=0;i<points.length;i++){
        var best=0, bd=Infinity;
        for(var c=0;c<K;c++){
          var d=dist(points[i], cents[c]);
          if(d<bd){ bd=d; best=c; }
        }
        if(lbl[i]!==best){ lbl[i]=best; changed=true; }
      }
      // update
      var sumx=new Array(K).fill(0), sumy=new Array(K).fill(0), cnt=new Array(K).fill(0);
      for(var j=0;j<points.length;j++){ var k=lbl[j]; sumx[k]+=points[j].x; sumy[k]+=points[j].y; cnt[k]+=1; }
      for(var c2=0;c2<K;c2++){ if(cnt[c2]>0){ cents[c2].x=sumx[c2]/cnt[c2]; cents[c2].y=sumy[c2]/cnt[c2]; } }
    }
    // wcss
    var wcss=0; for(var i2=0;i2<points.length;i2++){ var k2=lbl[i2]; var dx=points[i2].x-cents[k2].x, dy=points[i2].y-cents[k2].y; wcss+=dx*dx+dy*dy; }
    return {labels:lbl, cents:cents, wcss:wcss};
  }

  // Silhouette (exclude noise)
  function silhouetteScore(lbl){
    if(points.length===0 || lbl.length!==points.length) return null;
    var n=points.length;
    var byCluster={};
    for(var i=0;i<n;i++){
      var k=lbl[i];
      if(k<0) continue;
      if(!byCluster[k]) byCluster[k]=[];
      byCluster[k].push(i);
    }
    var keys=Object.keys(byCluster);
    if(keys.length<2) return null;
    var sSum=0, sCount=0;
    for(var i2=0;i2<n;i2++){
      var ci=lbl[i2]; if(ci<0) continue;
      var a=0, b=Infinity;
      // a: mean intra-cluster distance
      var arr=byCluster[ci], aSum=0;
      if(arr.length>1){
        for(var u=0;u<arr.length;u++){ if(arr[u]===i2) continue; aSum+=dist(points[i2], points[arr[u]]); }
        a=aSum/(arr.length-1);
      } else { a=0; }
      // b: min mean distance to other clusters
      for(var kk=0; kk<keys.length; kk++){
        var cl=parseInt(keys[kk]); if(cl===ci) continue;
        var list=byCluster[cl]; var s=0;
        for(var v=0; v<list.length; v++){ s+=dist(points[i2], points[list[v]]); }
        var mean = list.length>0 ? s/list.length : Infinity;
        if(mean<b) b=mean;
      }
      var sVal = (b - a) / Math.max(a, b);
      sSum+=sVal; sCount++;
    }
    return sCount>0 ? sSum/sCount : null;
  }

  // DBSCAN
  function dbscanRun(eps, minPts){
    var n=points.length, lbl=new Array(n).fill(undefined), C=0;
    function regionQuery(i){
      var res=[]; for(var j=0;j<n;j++){ if(dist(points[i],points[j])<=eps) res.push(j); } return res;
    }
    function expandCluster(i, neighbors, C){
      lbl[i]=C;
      var k=0;
      while(k<neighbors.length){
        var j=neighbors[k];
        if(lbl[j]===undefined){
          lbl[j]=C;
          var n2=regionQuery(j);
          if(n2.length>=minPts){ neighbors=neighbors.concat(n2); }
        }
        if(lbl[j]===-1){ lbl[j]=C; }
        k++;
      }
    }
    for(var i=0;i<n;i++){
      if(lbl[i]!==undefined) continue;
      var neighbors=regionQuery(i);
      if(neighbors.length<minPts){ lbl[i]=-1; } else { C++; expandCluster(i, neighbors, C); }
    }
    return {labels:lbl, clusters:C};
  }

  // Hierarchical (agglomerative)
  function hierRun(K, linkage){
    var n=points.length; if(n===0) return {labels:[], clusters:0};
    var clusters = []; for(var i=0;i<n;i++) clusters.push([i]);
    function linkageDist(a,b){
      var best, i, j, d;
      if(linkage==='single'){ best=Infinity; for(i=0;i<a.length;i++){ for(j=0;j<b.length;j++){ d=dist(points[a[i]],points[b[j]]); if(d<best) best=d; } } return best; }
      if(linkage==='complete'){ best=-Infinity; for(i=0;i<a.length;i++){ for(j=0;j<b.length;j++){ d=dist(points[a[i]],points[b[j]]); if(d>best) best=d; } } return best; }
      // average
      var sum=0, cnt=0; for(i=0;i<a.length;i++){ for(j=0;j<b.length;j++){ sum+=dist(points[a[i]],points[b[j]]); cnt++; } } return sum/cnt;
    }
    while(clusters.length>K){
      var bi=0,bj=1,bd=Infinity;
      for(var i1=0;i1<clusters.length;i1++){
        for(var j1=i1+1;j1<clusters.length;j1++){
          var d=linkageDist(clusters[i1], clusters[j1]);
          if(d<bd){ bd=d; bi=i1; bj=j1; }
        }
      }
      var merged = clusters[bi].concat(clusters[bj]);
      clusters.splice(bj,1); clusters.splice(bi,1); clusters.push(merged);
    }
    var lbl=new Array(n);
    for(var c=0;c<clusters.length;c++){ for(var ii=0;ii<clusters[c].length;ii++){ lbl[clusters[c][ii]]=c; } }
    return {labels:lbl, clusters:clusters.length};
  }

  function updateMetrics(){
    var cSet={}; noiseCount=0;
    for(var i=0;i<labels.length;i++){
      var k=labels[i];
      if(k===-1) noiseCount++; else cSet[k]=true;
    }
    var keys=Object.keys(cSet);
    clusterCount = keys.length;
    var sil = silhouetteScore(labels);
    silScore = sil;

    $('mClusters').textContent = clusterCount>0 ? clusterCount : '—';
    $('mNoise').textContent    = labels.length>0 ? noiseCount : '—';
    $('mSil').textContent      = (sil!==null) ? sil.toFixed(3) : '—';

    $('mtClusters').textContent = $('mClusters').textContent;
    $('mtNoise').textContent    = $('mNoise').textContent;
    $('mtSil').textContent      = $('mSil').textContent;
  }

  // Drawing
  function drawRegions(){
    if(!$('chkRegions').checked || points.length===0) return;
    var step=5;
    // For color consistency, predefine cluster palette
    function colorFor(k){
      var palette=['#0d6efd','#198754','#ffc107','#dc3545','#20c997','#6f42c1','#fd7e14','#0dcaf0','#6610f2','#6c757d'];
      return palette[Math.abs(k)%palette.length];
    }
    for(var y=0;y<canvas.height;y+=step){
      for(var x=0;x<canvas.width;x+=step){
        var d=toDomain(x,y);
        var k = predictRegion(d.x,d.y);
        var alpha=0.15;
        if(k===-1){ ctx.fillStyle='rgba(0,0,0,0.05)'; }
        else {
          // convert hex to rgba alpha
          // simple mapping
          ctx.fillStyle = k===-1 ? 'rgba(0,0,0,0.05)' : colorToRgba(colorFor(k), alpha);
        }
        ctx.fillRect(x,y,step,step);
      }
    }
  }
  function colorToRgba(hex, a){
    // expects #rrggbb
    var r=parseInt(hex.substr(1,2),16);
    var g=parseInt(hex.substr(3,2),16);
    var b=parseInt(hex.substr(5,2),16);
    return 'rgba(' + r + ',' + g + ',' + b + ',' + a + ')';
  }
  function drawPoints(){
    for(var i=0;i<points.length;i++){
      var p=points[i], c=toCanvas(p.x,p.y);
      var useCluster = $('colorBy').value==='cluster';
      var k = (labels[i]===undefined ? -2 : labels[i]);
      var col;
      if(useCluster){
        if(k===-1) col = '#6c757d';
        else {
          var palette=['#0d6efd','#198754','#ffc107','#dc3545','#20c997','#6f42c1','#fd7e14','#0dcaf0','#6610f2','#6c757d'];
          col=palette[Math.abs(k)%palette.length];
        }
      } else {
        col = (p.c===1 ? '#28a745' : '#dc3545');
      }
      ctx.beginPath(); ctx.arc(c.cx,c.cy,5,0,Math.PI*2);
      ctx.fillStyle=col; ctx.fill(); ctx.lineWidth=2; ctx.strokeStyle='#ffffff'; ctx.stroke();
      if(labels[i]===-1){ // noise marker
        ctx.beginPath(); ctx.moveTo(c.cx-5,c.cy-5); ctx.lineTo(c.cx+5,c.cy+5); ctx.moveTo(c.cx-5,c.cy+5); ctx.lineTo(c.cx+5,c.cy-5);
        ctx.strokeStyle='#343a40'; ctx.lineWidth=1.5; ctx.stroke();
      }
    }
  }
  function drawAll(){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    drawRegions();
    drawPoints();
  }

  function predictRegion(x,y){
    var algo = $('algo').value;
    if(algo==='kmeans' || algo==='hier'){
      if(labels.length===0) return -1;
      // find closest cluster centroid proxy (approximate by nearest labeled point)
      // More accurate would store centers; for K-Means we can recompute
      // Here, use nearest cluster among labeled assignments
      var best=-1, bd=Infinity;
      for(var i=0;i<points.length;i++){
        var k=labels[i]; if(k<0) continue;
        var d= (points[i].x-x)*(points[i].x-x) + (points[i].y-y)*(points[i].y-y);
        if(d<bd){ bd=d; best=k; }
      }
      return best;
    } else {
      // DBSCAN: region is cluster if close to any point in that cluster, else noise
      var best=-1, bd=Infinity;
      for(var i=0;i<points.length;i++){
        var k=labels[i];
        var d2=(points[i].x-x)*(points[i].x-x) + (points[i].y-y)*(points[i].y-y);
        if(d2<bd){ bd=d2; best=k; }
      }
      return best;
    }
  }

  // Actions
  function runClustering(){
    var algo=$('algo').value;
    if(points.length===0){ labels=[]; updateMetrics(); drawAll(); return; }
    if(algo==='kmeans'){
      var K=parseInt($('k').value);
      var res=kmeansRun(K, 50);
      labels=res.labels;
    } else if(algo==='dbscan'){
      var eps=parseFloat($('eps').value), minPts=parseInt($('minPts').value);
      var out=dbscanRun(eps, minPts);
      labels=out.labels;
    } else {
      var K2=parseInt($('k').value);
      var link=$('linkage').value;
      var res2=hierRun(K2, link);
      labels=res2.labels;
    }
    updateMetrics();
    drawAll();
  }

  function computeElbow(){
    if(points.length===0) return;
    var maxK=10;
    var vals=[], ks=[];
    for(var k=1;k<=maxK;k++){
      var r=kmeansRun(k, 40);
      ks.push(k); vals.push(r.wcss);
    }
    elbowChart.data.labels=ks; elbowChart.data.datasets[0].data=vals; elbowChart.update('none');

    var silVals=[], silKs=[];
    for(var k2=2;k2<=maxK;k2++){
      var r2=kmeansRun(k2, 40);
      var s=silhouetteScore(r2.labels);
      silKs.push(k2); silVals.push(s===null?null:s);
    }
    silChart.data.labels=silKs; silChart.data.datasets[0].data=silVals; silChart.update('none');
  }

  // Events
  $('btnBlobs').addEventListener('click', genBlobs);
  $('btnOverlap').addEventListener('click', genOverlap);
  $('btnMoons').addEventListener('click', genMoons);
  $('btnCircles').addEventListener('click', genCircles);
  $('btnClear').addEventListener('click', function(){ points=[]; labels=[]; updateMetrics(); drawAll(); elbowChart.data.labels=[]; elbowChart.data.datasets[0].data=[]; elbowChart.update('none'); silChart.data.labels=[]; silChart.data.datasets[0].data=[]; silChart.update('none'); });

  $('noise').addEventListener('input', function(){ var v=parseFloat(this.value); if(points.length>0){ // regenerate same pattern with new noise by re-clicking current generator
      // do nothing automatic to avoid changing distribution unexpectedly
    } });

  $('colorBy').addEventListener('change', function(){ drawAll(); });
  $('algo').addEventListener('change', function(){
    var a=this.value;
    $('rowK').style.display = (a==='kmeans' || a==='hier') ? 'block' : 'none';
    $('rowDB').style.display = (a==='dbscan') ? 'block' : 'none';
    $('rowHier').style.display = (a==='hier') ? 'block' : 'none';
  });

  $('k').addEventListener('input', function(){ $('kVal').textContent=this.value; });
  $('eps').addEventListener('input', function(){ $('epsVal').textContent=parseFloat(this.value).toFixed(2); });
  $('minPts').addEventListener('input', function(){ $('minPtsVal').textContent=this.value; });

  $('btnRun').addEventListener('click', function(){ runClustering(); });
  $('btnElbow').addEventListener('click', function(){ computeElbow(); });

  $('chkRegions').addEventListener('change', function(){ drawAll(); });

  // Add point
  canvas.addEventListener('click', function(evt){
    var br=canvas.getBoundingClientRect();
    var x=evt.clientX - br.left, y=evt.clientY - br.top;
    var d=toDomain(x,y);
    var cls=parseInt($('addClass').value);
    points.push({x:d.x, y:d.y, c:cls});
    runClustering();
  });

  // Init
  resizeCanvas();
  genBlobs();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">About Clustering & How to Read This</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>K-Means</h6>
        <ul class="mb-2">
          <li>Partitions data into K spherical clusters by minimizing within-cluster variance</li>
          <li>Works well for compact, similarly sized clusters</li>
          <li>Use the <strong>Elbow</strong> and <strong>Silhouette</strong> plots to pick K</li>
        </ul>
        <h6>DBSCAN</h6>
        <ul class="mb-0">
          <li>Density-based; finds arbitrarily shaped clusters and marks outliers as noise</li>
          <li>Parameters: <strong>eps</strong> (neighborhood radius), <strong>minPts</strong> (minimum neighbors)</li>
          <li>Great for clusters with noise; no need to set K</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Hierarchical (Agglomerative)</h6>
        <ul class="mb-2">
          <li>Builds a tree of merges using a <strong>linkage</strong> metric (single/complete/average)</li>
          <li>Cut into K clusters; interpretable merge process</li>
        </ul>
        <h6>Interpreting the visuals</h6>
        <ul class="mb-0">
          <li><strong>Regions:</strong> Background tint shows predicted cluster areas</li>
          <li><strong>Silhouette:</strong> Closer to 1 means better separation</li>
          <li><strong>Noise:</strong> Count of outliers (DBSCAN)</li>
        </ul>
      </div>
    </div>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>

</div> <!-- end col-lg-9 -->
<%@ include file="body-close.jsp"%>
