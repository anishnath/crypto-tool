<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Wave Speed & Frequency Tool – v = f·λ, Doppler, Standing Waves</title>
  <meta name="description" content="Wave speed calculator and frequency/wavelength converter. Enter any two to compute the third. Includes Doppler effect simulator and standing wave visualization. Presets for common media (air, water, steel).">
  <meta name="keywords" content="wave speed calculator, frequency calculator, wavelength calculator, doppler effect calculator, standing waves, physics waves tool, sound speed in air">
  <link rel="canonical" href="https://8gwifi.org/wave-speed-frequency.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Wave Speed & Frequency Tool","url":"https://8gwifi.org/wave-speed-frequency.jsp","applicationCategory":"EducationalApplication","operatingSystem":"Web","description":"Compute wave speed v=fλ, simulate Doppler shift, and visualize standing waves.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},"keywords":["wave speed calculator","frequency calculator","wavelength calculator","Doppler effect","standing waves"]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I teach the relationship v = f·λ?","acceptedAnswer":{"@type":"Answer","text":"Invite students to input two quantities and predict the third before pressing solve. Use different media presets to show that changing wave speed stretches wavelength when frequency is held constant."}},
    {"@type":"Question","name":"How can I visualise the Doppler effect for students?","acceptedAnswer":{"@type":"Answer","text":"Adjust the observer and source speeds while keeping sign conventions explicit. Discuss why the denominator (v − vₛ) shrinks as the source moves toward the observer and what happens near the sonic barrier."}},
    {"@type":"Question","name":"What should students notice in the standing wave plot?","acceptedAnswer":{"@type":"Answer","text":"Ask them to locate nodes (zero displacement) and antinodes (maximum displacement) and relate these positions to harmonics on strings or air columns. Encourage quick sketches of snapshots to reinforce spatial patterns."}}
  ]}
  </script>
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Wave Speed & Frequency Tool – v=fλ, Doppler, Standing Waves">
  <meta property="og:description" content="Enter any two of speed, frequency, wavelength. Simulate Doppler and visualize standing waves.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/wave-speed-frequency.jsp">
  <style>
    .wv .card-header{padding:.6rem .9rem;font-weight:600}
    .wv .card-body{padding:.7rem .9rem}
    .wv .form-group{margin-bottom:.6rem}
    #waveCanvas{width:100%;height:180px;border:1px solid #e5e7eb;border-radius:6px;background:#fff}
    .wv-edu-grid{display:grid;gap:.75rem;margin-bottom:.75rem}
    @media (min-width:768px){.wv-edu-grid{grid-template-columns:repeat(3,1fr)}}
    .wv-edu-card{border-radius:8px;border-left:4px solid;padding:.75rem .9rem;box-shadow:0 1px 3px rgba(30,41,59,0.08);background:#fff;color:#0f172a}
    .wv-edu-card h6{font-size:.95rem;font-weight:600;margin-bottom:.35rem}
    .wv-edu-card p{margin-bottom:.35rem;font-size:.9rem}
    .wv-edu-card ul{padding-left:1rem;margin-bottom:0;font-size:.88rem}
    .wv-edu-card ul li{margin-bottom:.25rem}
    .wv-edu-card--concept{background:#eff6ff;border-left-color:#3b82f6}
    .wv-edu-card--lab{background:#f5f3ff;border-left-color:#8b5cf6}
    .wv-edu-card--alert{background:#fef3c7;border-left-color:#f97316}
    .wv-faq-item + .wv-faq-item{margin-top:.75rem}
    .wv-faq-item strong{color:#0f172a}
    .wv-formula-card ul{padding-left:1rem;margin-bottom:.5rem;font-size:.9rem}
    .wv-formula-card ul li{margin-bottom:.25rem}
    .wv-formula-card .small{color:#475569;text-transform:uppercase;font-weight:600;margin-bottom:.25rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 wv">
  <h1 class="mb-2">Wave Speed & Frequency Tool</h1>
  <p class="text-muted mb-3">Compute wave speed (v = f·λ), simulate Doppler shift, and visualize standing waves. Choose a medium or enter your own wave speed.</p>
  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Inputs</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="medium">Medium</label>
            <select id="medium" class="form-control">
              <option value="air" selected>Air (~343 m/s)</option>
              <option value="water">Water (~1480 m/s)</option>
              <option value="steel">Steel (~5960 m/s)</option>
              <option value="custom">Custom</option>
            </select>
          </div>
          <div class="form-group"><label for="v">Speed v (m/s)</label><input id="v" type="number" step="0.01" class="form-control" placeholder="auto from medium"></div>
          <div class="form-group"><label for="f">Frequency f (Hz)</label><input id="f" type="number" step="0.01" class="form-control" placeholder="e.g. 440"></div>
          <div class="form-group"><label for="lam">Wavelength λ (m)</label><input id="lam" type="number" step="0.0001" class="form-control" placeholder="auto"></div>
          <div class="d-flex gap-2">
            <button id="btnSolve" class="btn btn-primary btn-sm mr-2">Solve</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm">Clear</button>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Doppler Effect (1D)</h5>
        <div class="card-body">
          <div class="form-group"><label for="vo">Observer speed v<sub>o</sub> (m/s, +toward source)</label><input id="vo" type="number" step="0.01" class="form-control" value="0"></div>
          <div class="form-group"><label for="vs">Source speed v<sub>s</sub> (m/s, +toward observer)</label><input id="vs" type="number" step="0.01" class="form-control" value="0"></div>
          <div class="form-group"><label>Observed frequency f'</label><div id="fprime" class="font-weight-bold">–</div></div>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Standing Wave</h5>
        <div class="card-body">
          <canvas id="waveCanvas" height="180"></canvas>
          <div class="mt-2">
            <button id="btnSaveWaveImg" class="btn btn-outline-secondary btn-sm">Save Image</button>
            <button id="btnShareWave" class="btn btn-outline-secondary btn-sm">Share URL</button>
          </div>
          <small class="text-muted d-block mt-1">Shows two counter-propagating waves forming a standing wave: y(x,t) = 2A cos(kx) sin(ωt). Adjust f or λ to change k and ω.</small>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Results</h5>
        <div class="card-body">
          <div>v = <span id="out_v">–</span> m/s, f = <span id="out_f">–</span> Hz, λ = <span id="out_l">–</span> m</div>
        </div>
      </div>
      <div class="card mb-3 wv-formula-card">
        <h5 class="card-header">Formula Breakdown</h5>
        <div class="card-body">
          <div class="small">Wave Relation</div>
          <ul>
            <li><code>v = f · λ</code> → any two quantities determine the third.</li>
            <li>When the medium preset is selected, <code>v</code> is populated from tabulated speeds.</li>
          </ul>
          <div class="small">Doppler Effect (1D)</div>
          <ul>
            <li><code>f' = (v + v<sub>o</sub>) / (v - v<sub>s</sub>) · f</code> with positive speeds moving toward each other.</li>
            <li>Results clamp only by arithmetic; extreme values signal supersonic motion discussion points.</li>
          </ul>
          <div class="small">Standing Wave Sketch</div>
          <ul class="mb-0">
            <li>Displacement uses <code>y(x,t) = 2A cos(kx) sin(ωt)</code> with <code>k = 2π/λ</code> and <code>ω = 2πf</code>.</li>
            <li>Node spacing is <code>λ/2</code>; antinodes align with integer multiples of <code>λ/2</code>.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">FAQ & Classroom Ideas</h5>
    <div class="card-body">
      <div class="wv-edu-grid">
        <div class="wv-edu-card wv-edu-card--concept">
          <h6>Concept Focus</h6>
          <p>Emphasize that holding frequency constant while changing medium alters wavelength.</p>
          <ul class="mb-0">
            <li>Compare air vs. water vs. steel to show compression/expansion of λ.</li>
            <li>Ask: “If f doubles, what must happen to λ for v to stay fixed?”</li>
          </ul>
        </div>
        <div class="wv-edu-card wv-edu-card--lab">
          <h6>Lab/Investigation</h6>
          <p>Use the standing wave canvas as a virtual ripple tank.</p>
          <ul class="mb-0">
            <li>Pause the animation and sketch nodes/antinodes.</li>
            <li>Assign groups to model harmonics on strings vs. pipes.</li>
          </ul>
        </div>
        <div class="wv-edu-card wv-edu-card--alert">
          <h6>Misconception Alert</h6>
          <p>Students may think the source speed changes wave speed in the medium.</p>
          <ul class="mb-0">
            <li>Highlight that medium properties set v; source motion shifts perceived f.</li>
            <li>Discuss sonic boom limitations when v<sub>s</sub> → v.</li>
          </ul>
        </div>
      </div>
      <div class="wv-faq-item">
        <strong>How do I use v = f·λ?</strong><br>
        Any two of speed (v), frequency (f), and wavelength (λ) determine the third via v = f·λ. If you choose a medium preset, v is populated automatically; otherwise, enter your own speed for custom contexts.
      </div>
      <div class="wv-faq-item">
        <strong>What speeds should I expect in common media?</strong><br>
        Approximate wave speeds (room temperature): Air ~343 m/s (sound), Water ~1480 m/s (sound), Steel ~5960 m/s (sound). Electromagnetic waves travel at ~3×10<sup>8</sup> m/s in vacuum and slower in media by n = c/v.
      </div>
      <div class="wv-faq-item">
        <strong>How does the Doppler simulator work?</strong><br>
        It uses the 1D acoustic Doppler shift f' = (v + v<sub>o</sub>) / (v − v<sub>s</sub>) · f with the sign convention that positive v<sub>o</sub> and v<sub>s</sub> move toward each other. If the source speed approaches v, the denominator shrinks and f' can grow very large (physically limited by shock effects, which this simple model ignores).
      </div>
      <div class="wv-faq-item">
        <strong>Why are standing waves drawn with cos(kx)·sin(ωt)?</strong><br>
        A standing wave is the superposition of two waves with the same frequency and amplitude traveling in opposite directions. The displacement becomes y(x,t) = 2A cos(kx) sin(ωt), with nodes at kx = (n+½)π and antinodes at kx = nπ.
      </div>
      <div class="wv-faq-item mb-0">
        <strong>How does wavelength relate to harmonics on a string or air column?</strong><br>
        For a string fixed at both ends, L contains an integer number of half-wavelengths (λ<sub>n</sub> = 2L/n). For air columns, boundary conditions differ (open/closed ends), but the same v = f·λ applies to each harmonic.
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  const $ = (id)=> document.getElementById(id);
  const medium = $('medium'); const vEl=$('v'), fEl=$('f'), lEl=$('lam');
  const outV=$('out_v'), outF=$('out_f'), outL=$('out_l');
  const vo=$('vo'), vs=$('vs'), fprime=$('fprime');
  const waveCanvas=$('waveCanvas'); const wctx=waveCanvas.getContext('2d');
  let t0 = 0; let raf;
  // Apply query params
  (function applyQuery(){
    const p=new URLSearchParams(window.location.search);
    if(p.has('medium')) medium.value=p.get('medium');
    if(p.has('v')) vEl.value=p.get('v');
    if(p.has('f')) fEl.value=p.get('f');
    if(p.has('lam')) lEl.value=p.get('lam');
    if(p.has('vo')) vo.value=p.get('vo');
    if(p.has('vs')) vs.value=p.get('vs');
  })();

  function setMedium(){
    const map={air:343, water:1480, steel:5960};
    if(medium.value==='custom') return;
    vEl.value = map[medium.value] || 343;
  }
  medium.addEventListener('change', ()=>{ setMedium(); solve(); });

  function solve(){
    const v = parseFloat(vEl.value)||NaN; const f = parseFloat(fEl.value)||NaN; const lam = parseFloat(lEl.value)||NaN;
    let vv=v, ff=f, ll=lam;
    // If medium chosen and v empty, fill v
    if(!isFinite(vv) && medium.value!=='custom'){ setMedium(); vv = parseFloat(vEl.value)||NaN; }
    // compute missing one
    const known = [isFinite(vv), isFinite(ff), isFinite(ll)].filter(Boolean).length;
    if(known>=2){
      if(!isFinite(vv)) vv = ff * ll;
      if(!isFinite(ff) && isFinite(ll) && ll!==0) ff = vv / ll;
      if(!isFinite(ll) && isFinite(ff) && ff!==0) ll = vv / ff;
    }
    outV.textContent = isFinite(vv)? (Math.round(vv*1000)/1000) : '–';
    outF.textContent = isFinite(ff)? (Math.round(ff*1000)/1000) : '–';
    outL.textContent = isFinite(ll)? (Math.round(ll*1000)/1000) : '–';
    // Doppler
    const voN = parseFloat(vo.value)||0; const vsN=parseFloat(vs.value)||0;
    if(isFinite(vv) && isFinite(ff)){
      const denom = (vv - vsN);
      const fpr = denom!==0 ? ((vv + voN)/denom)*ff : NaN;
      fprime.textContent = isFinite(fpr)? (Math.round(fpr*1000)/1000)+' Hz' : '–';
    } else { fprime.textContent='–'; }
    drawStanding(vv, ff, ll);
  }

  function drawStanding(v, f, lam){
    const w = waveCanvas.width = waveCanvas.getBoundingClientRect().width|0;
    const h = waveCanvas.height;
    wctx.clearRect(0,0,w,h);
    // axes baseline
    wctx.strokeStyle = '#cbd5e1'; wctx.beginPath(); wctx.moveTo(10,h/2); wctx.lineTo(w-10,h/2); wctx.stroke();
    if(!(isFinite(v) && isFinite(f))) return;
    const A = h*0.25; const omega = 2*Math.PI*f; const k = (isFinite(lam) && lam>0)? (2*Math.PI/lam) : (omega/(v||1));
    const t = t0;
    // standing wave: y = 2A cos(kx) sin(omega t)
    wctx.strokeStyle = '#0ea5e9'; wctx.lineWidth = 2; wctx.beginPath();
    for(let x=0;x<w;x++){
      const xPhys = (x/w)* (4*Math.PI/k); // scale to show several nodes
      const y = 2*A*Math.cos(k*xPhys)*Math.sin(omega*t);
      const yPix = h/2 - y;
      if(x===0) wctx.moveTo(10, yPix); else wctx.lineTo(10+x*(w-20)/w, yPix);
    }
    wctx.stroke();
  }

  function loop(ts){ t0 += 0.016; solve(); raf=requestAnimationFrame(loop); }
  $('btnSolve').addEventListener('click', solve);
  $('btnClear').addEventListener('click', ()=>{ vEl.value=''; fEl.value=''; lEl.value=''; fprime.textContent='–'; solve(); });
  ;['input','change'].forEach(ev=>{ [vEl,fEl,lEl,vo,vs].forEach(el=> el.addEventListener(ev, solve)); });
  // Save image
  $('btnSaveWaveImg').addEventListener('click', ()=>{
    try{
      const url = waveCanvas.toDataURL('image/png');
      const a=document.createElement('a'); a.href=url; a.download='wave-standing.png'; a.click();
    }catch(e){ alert('Unable to save image.'); }
  });
  // Share URL
  $('btnShareWave').addEventListener('click', async ()=>{
    const params=new URLSearchParams({
      medium: medium.value,
      v: vEl.value, f: fEl.value, lam: lEl.value,
      vo: vo.value, vs: vs.value
    });
    const shareUrl = `${location.origin}${location.pathname}?${params.toString()}`;
    try{ await navigator.clipboard.writeText(shareUrl); alert('Share URL copied to clipboard'); }
    catch(e){ prompt('Copy this URL', shareUrl); }
  });
  try{ setMedium(); solve(); raf=requestAnimationFrame(loop);}catch(e){}
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>
