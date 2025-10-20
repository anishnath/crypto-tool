<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Transformers & Attention Visualizer - Interactive attention heatmaps for self- and cross-attention. Explore multi-head attention, layers, and live token focus.">
<meta name="keywords" content="transformer visualization, attention mechanism, how BERT works, attention heads explained, attention heatmap, multi-head attention">
<title>Transformers & Attention Visualizer</title>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD for SEO -->
<script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Transformers & Attention Visualizer",
  "description": "Interactive attention heatmaps showing how transformers focus on context. Toggle self/cross attention, multi-head view, layers, and hover tokens to explore weights.",
  "url": "https://8gwifi.org/transformers_attention_visualizer.jsp",
  "keywords": "transformer visualization, attention mechanism, attention heatmap, how BERT works, attention heads explained"
}
</script>

<style>
  .att { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif; }
  .control-section { background:#fff; border:1px solid #dee2e6; border-radius:8px; padding:15px; margin-bottom:15px; }
  .control-section h6 { color:#495057; font-weight:600; margin-bottom:12px; padding-bottom:8px; border-bottom:2px solid #e9ecef; }
  .quick-access .btn { margin-right:6px; margin-bottom:6px; }
  .slider-label { display:flex; justify-content:space-between; margin-bottom:8px; font-size:13px; font-weight:500; }
  .token-bar { display:flex; flex-wrap:wrap; gap:6px; margin:6px 0; }
  .tok { padding:2px 6px; border-radius:4px; background:#f1f3f5; border:1px solid #dee2e6; cursor:pointer; }
  .tok.q { background:#e7f5ff; border-color:#a5d8ff; }
  .tok.k { background:#fff3bf; border-color:#ffd43b; }
  .tok.active { outline:2px solid #0d6efd; }
  #heatWrap { background:#f8f9fa; border:1px solid #dee2e6; border-radius:8px; padding:10px; }
  #heat { border:1px solid #ccc; border-radius:4px; background:#fff; width:100%; height:auto; display:block; }
  .small-note { font-size:12px; color:#6c757d; }
  .legend-chip { display:inline-block; width:10px; height:10px; border-radius:50%; margin-right:6px; }
</style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Transformers & Attention Visualizer</h1>
<p>Type a sentence and explore how attention focuses on context. Toggle heads/layers, hover tokens to see attention weights, and switch between self- and cross-attention.</p>

<!-- Quick Access -->
<div class="mb-2 quick-access">
  <div class="btn-group btn-group-sm" role="group" aria-label="Quick Access">
    <a href="#viz" class="btn btn-outline-primary">Visualization</a>
    <a href="#controls" class="btn btn-outline-primary">Controls</a>
    <a href="#guide" class="btn btn-outline-primary">Guide</a>
  </div>
</div>

<%@ include file="footer_adsense.jsp"%>
<hr>

<div class="att">
  <div class="row">
    <!-- Left: Visualization -->
    <div class="col-lg-8 mb-4">
      <div class="card mb-4" id="viz">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Attention Heatmap</h5>
          <div class="small">
            <span class="legend-chip" style="background:#e7f5ff;border:1px solid #a5d8ff;"></span>Query tokens
            <span class="legend-chip" style="background:#fff3bf;border:1px solid #ffd43b;margin-left:10px;"></span>Key tokens
          </div>
        </div>
        <div class="card-body">
          <!-- Input(s) -->
          <div class="mb-2">
            <label class="form-label small">Input (self-attention)</label>
            <input type="text" id="txtSelf" class="form-control form-control-sm" value="the cat sat on the mat">
          </div>
          <div class="mb-2" id="boxCross" style="display:none;">
            <label class="form-label small">Source (encoder) → Target (decoder)</label>
            <div class="row g-2">
              <div class="col">
                <input type="text" id="txtSrc" class="form-control form-control-sm" value="the cat sat">
              </div>
              <div class="col">
                <input type="text" id="txtTgt" class="form-control form-control-sm" value="on the mat">
              </div>
            </div>
          </div>

          <!-- Tokens -->
          <div class="token-bar" id="tokQ"></div>
          <div class="token-bar" id="tokK"></div>

          <!-- Heatmap -->
          <div id="heatWrap" class="mt-2">
            <canvas id="heat" width="720" height="360"></canvas>
          </div>

          <small class="text-muted d-block mt-2">
            Hover tokens to highlight rows/columns. Each cell shows attention from a query token (row) to a key token (column).
          </small>
        </div>
      </div>
    </div>

    <!-- Right: Controls -->
    <div class="col-lg-4 mb-4" id="controls">
      <div class="control-section">
        <h6>Mode</h6>
        <div class="mb-2">
          <select id="mode" class="form-select form-select-sm">
            <option value="self" selected>Self-Attention</option>
            <option value="cross">Cross-Attention</option>
          </select>
        </div>
        <div class="slider-label"><span>Heads</span><strong id="headsLbl">4</strong></div>
        <input type="range" id="heads" min="1" max="8" step="1" value="4" class="form-range">

        <div class="slider-label"><span>Layers</span><strong id="layersLbl">2</strong></div>
        <input type="range" id="layers" min="1" max="6" step="1" value="2" class="form-range">

        <div class="slider-label"><span>Temperature</span><strong id="tempLbl">1.0</strong></div>
        <input type="range" id="temp" min="0.3" max="3" step="0.1" value="1.0" class="form-range">

        <div class="row g-2 mt-2">
          <div class="col-6">
            <label class="form-label small">Head</label>
            <select id="selHead" class="form-select form-select-sm"></select>
          </div>
          <div class="col-6">
            <label class="form-label small">Layer</label>
            <select id="selLayer" class="form-select form-select-sm"></select>
          </div>
        </div>

        <div class="row g-2 mt-2">
          <div class="col"><button id="btnUpdate" class="btn btn-primary btn-sm w-100">Update</button></div>
          <div class="col"><button id="btnSeed" class="btn btn-outline-secondary btn-sm w-100">Randomize Seed</button></div>
        </div>

        <div class="form-check form-switch mt-2">
          <input class="form-check-input" type="checkbox" id="autoPlay">
          <label class="form-check-label small" for="autoPlay">Auto-play heads/layers</label>
        </div>
      </div>

      <div class="control-section">
        <h6>Tokenization</h6>
        <div class="small-note">Whitespace-based tokens (punctuation split). Limit ~30 tokens per sequence for clarity.</div>
      </div>
    </div>
  </div>
</div>

<script>
window.addEventListener('DOMContentLoaded', function(){
  function $(id){ return document.getElementById(id); }

  // Seeded RNG (mulberry32)
  function mulberry32(a){ return function(){ var t=a+=0x6D2B79F5; t=Math.imul(t^t>>>15, t|1); t^=t+Math.imul(t^t>>>7, t|61); return ((t^t>>>14)>>>0)/4294967296; }; }
  function randn(seedFn){
    // Box-Muller using seeded uniform
    var u=0,v=0; while(u===0)u=seedFn(); while(v===0)v=seedFn(); return Math.sqrt(-2*Math.log(u))*Math.cos(2*Math.PI*v);
  }

  // State
  var seedBase = 12345;
  var heat = $('heat'), hctx = heat.getContext('2d');
  var tokQ = $('tokQ'), tokK = $('tokK');
  var hoverRow = -1, hoverCol = -1, selRow = -1, selCol = -1;
  var cache = { weights:[], Q:[], K:[], qTokens:[], kTokens:[], nHeads:4, nLayers:2 };

  // Make heatmap responsive: set drawing buffer size to container
  function resizeHeatCanvas(){
    var wrap = document.getElementById('heatWrap');
    if(!wrap || !heat) return;
    var w = Math.max(300, wrap.clientWidth - 20);
    var h = Math.max(180, Math.floor(w * 0.55)); // keep aspect
    heat.width = w;
    heat.height = h;
  }
  window.addEventListener('resize', function(){ resizeHeatCanvas(); drawHeat(); });

  // Tokenization
  function tokenize(str){
    return (str || '').trim().split(/[\s,.!?;:()]+/).filter(function(t){ return t.length>0; }).slice(0,30);
  }

  // Embeddings: simple hashed vector (d=32)
  var dModel=32;
  function embedTokens(tokens, seed){
    var rng = mulberry32(seed);
    var E=[];
    for(var i=0;i<tokens.length;i++){
      // token-level seeded rng using simple hash
      var h=0; for(var c=0;c<tokens[i].length;c++){ h = ((h<<5)-h) + tokens[i].charCodeAt(c); h|=0; }
      var r = mulberry32(seed + (h>>>0));
      var v=new Array(dModel);
      for(var k=0;k<dModel;k++){ v[k]=randn(r); }
      // L2 normalize
      var s=0; for(var k2=0;k2<dModel;k2++){ s+=v[k2]*v[k2]; }
      s=Math.sqrt(Math.max(1e-12,s));
      for(var k3=0;k3<dModel;k3++){ v[k3]/=s; }
      E.push(v);
    }
    return E; // [nTok][d]
  }

  // Projections per head/layer
  function projMats(nLayers, nHeads, seed){
    var mats=[];
    var headDim = dModel; // keep same for simplicity (toy)
    var rng = mulberry32(seed+777);
    for(var L=0; L<nLayers; L++){
      var layer=[];
      for(var H=0; H<nHeads; H++){
        // Wq, Wk: d x d
        var Wq=new Array(dModel), Wk=new Array(dModel);
        for(var r=0;r<dModel;r++){
          Wq[r]=new Array(dModel); Wk[r]=new Array(dModel);
          for(var c=0;c<dModel;c++){ Wq[r][c]=randn(rng)*0.3; Wk[r][c]=randn(rng)*0.3; }
        }
        layer.push({Wq:Wq, Wk:Wk});
      }
      mats.push(layer);
    }
    return mats;
  }

  // Matrix helpers
  function matVec(M, v){
    var n=M.length, m=M[0].length, out=new Array(n);
    for(var i=0;i<n;i++){
      var s=0; for(var j=0;j<m;j++){ s+=M[i][j]*v[j]; }
      out[i]=s;
    }
    return out;
  }
  function dot(a,b){ var s=0; for(var i=0;i<a.length;i++){ s+=a[i]*b[i]; } return s; }

  function softmaxRow(arr, temp){
    var t = 1/Math.max(1e-6, temp);
    var m=-1e30; for(var i=0;i<arr.length;i++){ var v=arr[i]*t; if(v>m) m=v; }
    var ex=new Array(arr.length), s=0;
    for(var j=0;j<arr.length;j++){ ex[j]=Math.exp(arr[j]*t - m); s+=ex[j]; }
    for(var k=0;k<arr.length;k++){ ex[k]=ex[k]/Math.max(1e-12,s); }
    return ex;
  }

  // Compute attention for given layer/head
  function computeAttention(qTokens, kTokens, nLayers, nHeads, headSel, layerSel, temp, seed){
    var mats = projMats(nLayers, nHeads, seed);
    var EQ = embedTokens(qTokens, seed+101);
    var EK = embedTokens(kTokens, seed+202);
    var proj = mats[layerSel][headSel];
    var Qp=[], Kp=[];
    for(var i=0;i<EQ.length;i++){ Qp.push(matVec(proj.Wq, EQ[i])); }
    for(var j=0;j<EK.length;j++){ Kp.push(matVec(proj.Wk, EK[j])); }
    // normalize
    for(var i2=0;i2<Qp.length;i2++){
      var s=0; for(var k=0;k<Qp[i2].length;k++){ s+=Qp[i2][k]*Qp[i2][k]; } s=Math.sqrt(Math.max(1e-12,s));
      for(var k2=0;k2<Qp[i2].length;k2++){ Qp[i2][k2]/=s; }
    }
    for(var j2=0;j2<Kp.length;j2++){
      var s2=0; for(var k3=0;k3<Kp[j2].length;k3++){ s2+=Kp[j2][k3]*Kp[j2][k3]; } s2=Math.sqrt(Math.max(1e-12,s2));
      for(var k4=0;k4<Kp[j2].length;k4++){ Kp[j2][k4]/=s2; }
    }
    var weights=new Array(Qp.length);
    for(var qi=0; qi<Qp.length; qi++){
      var row=new Array(Kp.length);
      for(var kj=0; kj<Kp.length; kj++){
        row[kj] = dot(Qp[qi], Kp[kj]); // cosine similarity (toy)
      }
      weights[qi] = softmaxRow(row, temp);
    }
    cache.weights = weights;
    cache.qTokens = qTokens.slice(0);
    cache.kTokens = kTokens.slice(0);
  }

  // Draw heatmap
  function drawHeat(){
    var W = heat.width, H = heat.height;
    hctx.clearRect(0,0,W,H);
    var nR = cache.weights.length;
    var nC = nR>0 ? cache.weights[0].length : 0;
    if(nR===0 || nC===0){ // empty
      hctx.fillStyle='#6c757d';
      hctx.fillText('No tokens to display', 10, 20);
      return;
    }
    var cw = Math.max(6, Math.floor((W-80)/nC));
    var ch = Math.max(6, Math.floor((H-60)/nR));
    var ox = 60, oy = 20;

    // labels (K)
    hctx.font='12px sans-serif';
    hctx.textAlign='center'; hctx.textBaseline='top';
    for(var j=0;j<nC;j++){
      var x = ox + j*cw + cw/2;
      hctx.fillStyle = '#212529';
      hctx.fillText(cache.kTokens[j], x, 4);
    }
    // labels (Q)
    hctx.textAlign='right'; hctx.textBaseline='middle';
    for(var i=0;i<nR;i++){
      var y = oy + i*ch + ch/2;
      hctx.fillStyle = '#212529';
      hctx.fillText(cache.qTokens[i], ox-6, y);
    }

    // cells
    for(var r=0;r<nR;r++){
      for(var c=0;c<nC;c++){
        var v = cache.weights[r][c]; // 0..1
        var col = 'rgba(13,110,253,' + (0.15 + 0.75*v).toFixed(3) + ')';
        hctx.fillStyle = col;
        hctx.fillRect(ox + c*cw, oy + r*ch, cw-1, ch-1);
        // highlight
        if(r===hoverRow || c===hoverCol){
          hctx.strokeStyle = 'rgba(0,0,0,0.5)';
          hctx.lineWidth = 2;
          hctx.strokeRect(ox + c*cw+1, oy + r*ch+1, cw-3, ch-3);
        }
      }
    }
  }

  // Build tokens UI
  function renderTokens(){
    tokQ.innerHTML=''; tokK.innerHTML='';
    for(var i=0;i<cache.qTokens.length;i++){
      var sp=document.createElement('span'); sp.className='tok q'; sp.textContent=cache.qTokens[i];
      (function(idx){ sp.addEventListener('mouseenter', function(){ hoverRow=idx; drawHeat(); }); sp.addEventListener('mouseleave', function(){ hoverRow=-1; drawHeat(); }); })(i);
      tokQ.appendChild(sp);
    }
    for(var j=0;j<cache.kTokens.length;j++){
      var sp2=document.createElement('span'); sp2.className='tok k'; sp2.textContent=cache.kTokens[j];
      (function(idx){ sp2.addEventListener('mouseenter', function(){ hoverCol=idx; drawHeat(); }); sp2.addEventListener('mouseleave', function(){ hoverCol=-1; drawHeat(); }); })(j);
      tokK.appendChild(sp2);
    }
  }

  // Orchestrate update
  function updateAll(){
    var mode = $('mode').value;
    var nHeads = parseInt($('heads').value), nLayers=parseInt($('layers').value), temp=parseFloat($('temp').value);
    var headSel = parseInt($('selHead').value), layerSel=parseInt($('selLayer').value);
    var s = seedBase;

    var qTokens=[], kTokens=[];
    if(mode==='self'){
      $('boxCross').style.display='none';
      var toks = tokenize($('txtSelf').value);
      qTokens=toks; kTokens=toks;
    } else {
      $('boxCross').style.display='block';
      qTokens = tokenize($('txtTgt').value);
      kTokens = tokenize($('txtSrc').value);
    }
    computeAttention(qTokens, kTokens, nLayers, nHeads, Math.min(headSel, nHeads-1), Math.min(layerSel, nLayers-1), temp, s);
    renderTokens();
    resizeHeatCanvas();
    drawHeat();
  }

  // Populate head/layer selects
  function fillSelectors(){
    var nHeads=parseInt($('heads').value), nLayers=parseInt($('layers').value);
    var sh=$('selHead'), sl=$('selLayer');
    var curH=parseInt(sh.value||'0'), curL=parseInt(sl.value||'0');
    sh.innerHTML=''; sl.innerHTML='';
    for(var h=0;h<nHeads;h++){ var opt=document.createElement('option'); opt.value=h; opt.textContent='Head '+(h+1); sh.appendChild(opt); }
    for(var l=0;l<nLayers;l++){ var opt2=document.createElement('option'); opt2.value=l; opt2.textContent='Layer '+(l+1); sl.appendChild(opt2); }
    if(curH<nHeads) sh.value=curH; if(curL<nLayers) sl.value=curL;
    $('headsLbl').textContent=nHeads; $('layersLbl').textContent=nLayers;
  }

  // Events
  $('mode').addEventListener('change', updateAll);
  $('heads').addEventListener('input', function(){ fillSelectors(); updateAll(); });
  $('layers').addEventListener('input', function(){ fillSelectors(); updateAll(); });
  $('temp').addEventListener('input', function(){ $('tempLbl').textContent=parseFloat(this.value).toFixed(1); updateAll(); });
  $('btnUpdate').addEventListener('click', updateAll);
  $('btnSeed').addEventListener('click', function(){ seedBase = Math.floor(Math.random()*100000); updateAll(); });

  $('txtSelf').addEventListener('input', updateAll);
  $('txtSrc').addEventListener('input', updateAll);
  $('txtTgt').addEventListener('input', updateAll);
  $('selHead').addEventListener('change', updateAll);
  $('selLayer').addEventListener('change', updateAll);

  // Auto-play
  var timer=null;
  $('autoPlay').addEventListener('change', function(){
    if(this.checked){
      var step=0;
      timer=setInterval(function(){
        var sh=$('selHead'), sl=$('selLayer');
        var h=(parseInt(sh.value||'0')+1) % parseInt($('heads').value);
        var l=(parseInt(sl.value||'0')+ (h===0?1:0)) % parseInt($('layers').value);
        sh.value=h; sl.value=l; updateAll();
      }, 1200);
    } else { if(timer){ clearInterval(timer); timer=null; } }
  });

  // Init
  fillSelectors();
  updateAll();
});
</script>

<hr id="guide">
<!-- Learning Guide -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">How to read attention</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>Self vs Cross attention</h6>
        <ul class="mb-2">
          <li><strong>Self‑attention:</strong> Each token attends to all tokens in the same sequence.</li>
          <li><strong>Cross‑attention:</strong> Decoder tokens attend to encoder tokens (target queries source).</li>
        </ul>
        <h6>Heads & Layers</h6>
        <ul class="mb-0">
          <li><strong>Heads:</strong> Multiple views of context; different heads can focus on different relations (syntax, position).</li>
          <li><strong>Layers:</strong> Deeper layers refine context; earlier layers capture local patterns, deeper layers capture long‑range relations.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Pro tips</h6>
        <ul class="mb-2">
          <li>Hover a token to highlight where it sends attention (rows) or receives attention (columns).</li>
          <li>Use Temperature: higher → sharpened attention, lower → flatter weights.</li>
          <li>Auto‑play to cycle through heads/layers and notice complementary patterns.</li>
        </ul>
        <div class="small-note">SEO: transformer visualization • attention mechanism • how BERT works • attention heads explained</div>
      </div>
    </div>
  </div>
</div>

<!-- What’s happening & Why it matters -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="mb-0">What’s happening under the hood — and why it matters</h5>
  </div>
  <div class="card-body">
    <div class="row">
      <div class="col-md-6">
        <h6>What’s happening</h6>
        <ul class="mb-2">
          <li><strong>Query/Key similarity:</strong> Each head projects tokens into <em>query</em> and <em>key</em> vectors and measures similarity. The heatmap cell is the softmax‑normalized similarity.</li>
          <li><strong>Softmax weighting:</strong> Rows sum to 1. Temperature sharpens (high) or smooths (low) these weights.</li>
          <li><strong>Heads focus differently:</strong> One head may track word identity (“the→the”), another syntax (“cat→sat”), another positions (“on→the”).</li>
          <li><strong>Layers compose:</strong> Earlier layers learn local links; later layers aggregate longer‑range dependencies.</li>
        </ul>
        <h6>Interacting with the view</h6>
        <ul class="mb-0">
          <li>Switch <em>Self</em> vs <em>Cross</em> to see intra‑sentence vs encoder→decoder patterns.</li>
          <li>Move across heads/layers to observe complementary attention behaviors.</li>
          <li>Hover tokens to highlight the row/column and read off weight distribution.</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h6>Why this is important</h6>
        <ul class="mb-2">
          <li><strong>Interpretability:</strong> Attention offers an intuitive window into what a model “looks at” when forming context.</li>
          <li><strong>Debugging:</strong> Mismatches (e.g., attention stuck on punctuation) can reveal tokenization or context issues.</li>
          <li><strong>Quality signals:</strong> Healthy heads often show consistent, meaningful patterns (e.g., determiners attending nouns, verbs attending subjects/objects).</li>
          <li><strong>Education:</strong> Seeing heads and layers evolve turns the math of attention into actionable intuition.</li>
        </ul>
        <h6>Where you’ll see this</h6>
        <ul class="mb-0">
          <li>Language models (GPT/BERT family) attending to entities, coreferences, and syntax.</li>
          <li>Translation: decoder <em>cross‑attention</em> aligning target words with source phrases.</li>
          <li>Vision and audio transformers: attention over patches or time frames.</li>
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
