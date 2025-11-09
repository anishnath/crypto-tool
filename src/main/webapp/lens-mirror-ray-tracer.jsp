<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lens/Mirror Ray Tracer – Thin Lens Equation & Magnification</title>
  <meta name="description" content="Interactive ray diagram for lenses and mirrors. Enter focal length and object distance to visualize image formation and compute magnification using 1/f = 1/do + 1/di.">
  <meta name="keywords" content="lens formula calculator, optics simulator, ray tracing tool, mirror equation, magnification calculator">
  <link rel="canonical" href="https://8gwifi.org/lens-mirror-ray-tracer.jsp">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do sign conventions work in this simulator?","acceptedAnswer":{"@type":"Answer","text":"The tool follows the Cartesian sign convention: distances measured in the direction of incident light are positive for lenses and negative for mirrors. Selecting element types automatically applies ±f so students can focus on interpreting results rather than memorising sign rules."}},
    {"@type":"Question","name":"How can I show real vs virtual images?","acceptedAnswer":{"@type":"Answer","text":"Change the object distance so that it passes inside the focal length. The ray diagram will shift from a red upright virtual image to an inverted real image, making it easy to discuss projection vs. mirror perceptions."}},
    {"@type":"Question","name":"What teaching move reinforces magnification meaning?","acceptedAnswer":{"@type":"Answer","text":"Have learners compare the numerical magnification m to the drawn image height. If m is negative, point out the flipped orientation; if |m| > 1, the image arrow visibly grows, supporting the algebra with visuals."}}
  ]}
  </script>
  <style>
    #rayCanvas{width:100%;height:260px;border:1px solid #e5e7eb;border-radius:6px;background:#fff}
    .lx .card-header{padding:.6rem .9rem;font-weight:600}.lx .card-body{padding:.7rem .9rem}
    .lx-edu-grid{display:grid;gap:.75rem;margin-bottom:.75rem}
    @media (min-width:768px){.lx-edu-grid{grid-template-columns:repeat(3,1fr)}}
    .lx-edu-card{border-radius:8px;border-left:4px solid;padding:.75rem .9rem;background:#fff;box-shadow:0 1px 3px rgba(15,23,42,0.08);color:#0f172a}
    .lx-edu-card h6{font-size:.95rem;font-weight:600;margin-bottom:.35rem}
    .lx-edu-card p{margin-bottom:.35rem;font-size:.9rem}
    .lx-edu-card ul{padding-left:1rem;margin-bottom:0;font-size:.88rem}
    .lx-edu-card ul li{margin-bottom:.25rem}
    .lx-edu-card--concept{background:#f0f9ff;border-left-color:#0ea5e9}
    .lx-edu-card--demo{background:#f1f5f9;border-left-color:#22c55e}
    .lx-edu-card--alert{background:#fef2f2;border-left-color:#f87171}
    .lx-faq-item + .lx-faq-item{margin-top:.75rem}
    .lx-faq-item strong{color:#0f172a}
    .lx-formula-card ul{padding-left:1rem;margin-bottom:.5rem;font-size:.9rem}
    .lx-formula-card ul li{margin-bottom:.25rem}
    .lx-formula-card .small{color:#475569;text-transform:uppercase;font-weight:600;margin-bottom:.25rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 lx">
  <h1 class="mb-2">Lens/Mirror Ray Tracer</h1>
  <p class="text-muted mb-3">Ray diagram for thin lenses and spherical mirrors. Compute image distance and magnification using the thin lens/mirror equation.</p>
  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3"><h5 class="card-header d-flex justify-content-between align-items-center">Inputs
        <div class="dropdown"><button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="presetBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Presets</button>
          <div class="dropdown-menu" aria-labelledby="presetBtn">
            <a class="dropdown-item" href="#" data-preset="lens-2f">Converging lens: object beyond 2F</a>
            <a class="dropdown-item" href="#" data-preset="lens-between">Converging lens: object between F and 2F</a>
            <a class="dropdown-item" href="#" data-preset="lens-inside">Converging lens: object inside F (virtual)</a>
            <a class="dropdown-item" href="#" data-preset="div-lens">Diverging lens: typical</a>
            <a class="dropdown-item" href="#" data-preset="conc-mirror">Concave mirror: beyond C</a>
            <a class="dropdown-item" href="#" data-preset="conv-mirror">Convex mirror: typical</a>
          </div></div>
      </h5><div class="card-body">
        <div class="form-group form-inline"><label for="kind" class="mr-2 mb-0">Element</label>
          <select id="kind" class="form-control">
            <option value="conv_lens" selected>Converging Lens (+f)</option>
            <option value="div_lens">Diverging Lens (−f)</option>
            <option value="conc_mirror">Concave Mirror (+f)</option>
            <option value="conv_mirror">Convex Mirror (−f)</option>
          </select>
        </div>
        <div class="form-group form-inline"><label for="f" class="mr-2 mb-0">Focal length f</label><input id="f" type="number" step="0.1" class="form-control mr-2" style="max-width:160px" value="10"><select id="u" class="form-control" style="max-width:120px"><option value="cm" selected>cm</option><option value="mm">mm</option><option value="m">m</option><option value="in">in</option></select></div>
        <div class="form-group form-inline"><label for="do" class="mr-2 mb-0">Object distance d<sub>o</sub></label><input id="do" type="number" step="0.1" class="form-control mr-2" style="max-width:160px" value="20"><span class="text-muted" id="u_do">cm</span></div>
        <div class="form-group form-inline"><label for="ho" class="mr-2 mb-0">Object height h<sub>o</sub></label><input id="ho" type="number" step="0.1" class="form-control mr-2" style="max-width:160px" value="5"><span class="text-muted" id="u_ho">cm</span></div>
        <div class="d-flex align-items-center"><button id="btnTrace" class="btn btn-primary btn-sm mr-2">Trace</button><button id="btnSaveImg" class="btn btn-outline-secondary btn-sm mr-2">Save Image</button><button id="btnShare" class="btn btn-outline-secondary btn-sm">Share URL</button></div>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Results</h5><div class="card-body">
        <div class="mb-1">d<sub>i</sub> = <span id="di">–</span> <span id="u_di">cm</span>, m = <span id="mag">–</span>, h<sub>i</sub> = <span id="hi">–</span> <span id="u_hi">cm</span></div>
        <div class="small">Image: <span class="badge badge-light" id="imgType">–</span> • Orientation: <span class="badge badge-light" id="imgOrient">–</span> • Scale: <span class="badge badge-light" id="imgScale">–</span></div>
      </div></div>
      <div class="card mb-3 lx-formula-card"><h5 class="card-header">Formula Breakdown</h5><div class="card-body">
        <div class="small">Thin Lens / Mirror Equation</div>
        <ul>
          <li><code>1/f = 1/d<sub>o</sub> + 1/d<sub>i</sub></code> solved for the unknown distance based on inputs.</li>
          <li>Element selector applies the sign of <code>f</code> automatically (positive for converging/concave).</li>
        </ul>
        <div class="small">Magnification & Image Height</div>
        <ul class="mb-0">
          <li><code>m = -d<sub>i</sub> / d<sub>o</sub></code> determines orientation (negative ⇒ inverted).</li>
          <li><code>h<sub>i</sub> = m · h<sub>o</sub></code> produces the scaled image height used in the diagram.</li>
        </ul>
      </div></div>
    </div>
    <div class="col-lg-8">
      <div class="card mb-3"><h5 class="card-header">Ray Diagram</h5><div class="card-body"><canvas id="rayCanvas" height="260"></canvas></div></div>
    </div>
  </div>
  <div class="card mb-3">
    <h5 class="card-header">FAQ & Teaching Notes</h5>
    <div class="card-body">
      <div class="lx-edu-grid">
        <div class="lx-edu-card lx-edu-card--concept">
          <h6>Concept Focus</h6>
          <p>Connect the algebraic thin lens equation with the visual ray diagram.</p>
          <ul class="mb-0">
            <li>Ask students to predict d<sub>i</sub> before pressing “Trace”.</li>
            <li>Discuss why 1/f = 1/d<sub>o</sub> + 1/d<sub>i</sub> rearranges to solve for any variable.</li>
          </ul>
        </div>
        <div class="lx-edu-card lx-edu-card--demo">
          <h6>Demo Tip</h6>
          <p>Slide the object inside the focal length to create a virtual image.</p>
          <ul class="mb-0">
            <li>Challenge students to identify upright versus inverted arrows.</li>
            <li>Relate the virtual image to everyday applications (make-up mirrors, magnifiers).</li>
          </ul>
        </div>
        <div class="lx-edu-card lx-edu-card--alert">
          <h6>Misconception Alert</h6>
          <p>Sign errors are common; lean on the simulator’s automatic handling.</p>
          <ul class="mb-0">
            <li>Switch between element types to see how ±f is assigned.</li>
            <li>Note that a negative magnification indicates image inversion.</li>
          </ul>
        </div>
      </div>
      <div class="lx-faq-item">
        <strong>How do sign conventions work here?</strong><br>
        The tool follows the standard Cartesian sign convention. For converging lenses and concave mirrors, focal length is positive; for diverging lenses and convex mirrors it is negative. Input fields accept positive distances, and the element selector adjusts signs under the hood.
      </div>
      <div class="lx-faq-item">
        <strong>Real vs. virtual image cues?</strong><br>
        When d<sub>o</sub> &gt; f, the red image arrow appears on the right of the element, inverted—signalling a real image that could project onto a screen. When d<sub>o</sub> &lt; f, the image is drawn on the same side as the object and remains upright, showing a virtual image.
      </div>
      <div class="lx-faq-item mb-0">
        <strong>Link to magnification meaning</strong><br>
        Magnification m = −d<sub>i</sub>/d<sub>o</sub> = h<sub>i</sub>/h<sub>o</sub>. Invite students to compare the numerical m with the drawn image height. If m = −1.5, expect an inverted image 1.5× taller than the object.
      </div>
    </div>
  </div>
</div>
<script>
(function(){
  const $=(id)=>document.getElementById(id);
  const kind=$('kind'), fEl=$('f'), doEl=$('do'), hoEl=$('ho');
  const uSel=$('u');
  const diOut=$('di'), magOut=$('mag'), hiOut=$('hi');
  const imgType=$('imgType'), imgOrient=$('imgOrient'), imgScale=$('imgScale');
  const canvas=$('rayCanvas'); const ctx=canvas.getContext('2d');

  function trace(){
    const u=unitLabel();
    let f=parseFloat(fEl.value)||0, d0=parseFloat(doEl.value)||0, h0=parseFloat(hoEl.value)||0;
    // convert to cm for internal math
    f = toCm(f,u); d0 = toCm(d0,u); h0 = toCm(h0,u);
    if(kind.value==='div_lens' || kind.value==='conv_mirror') f = -Math.abs(f);
    else f = Math.abs(f);
    let di = (d0!==0 && f!==0)? 1/(1/f - 1/d0) : NaN;
    let m = (isFinite(di) && d0!==0)? (-di/d0) : NaN;
    let hi = isFinite(m)? (m*h0) : NaN;
    // display back in selected units
    diOut.textContent = isFinite(di)? fromCm(di,u).toFixed(2) : '–';
    magOut.textContent = isFinite(m)? m.toFixed(3) : '–';
    hiOut.textContent = isFinite(hi)? fromCm(hi,u).toFixed(2) : '–';
    // classification
    if(isFinite(di)){
      imgType.textContent = di>0? 'Real' : 'Virtual';
      imgOrient.textContent = (isFinite(m) && m<0)? 'Inverted' : 'Upright';
      imgScale.textContent = (!isFinite(m))? '–' : (Math.abs(m)>1? 'Magnified' : (Math.abs(m)<1? 'Reduced' : 'Same size'));
    } else { imgType.textContent=imgOrient.textContent=imgScale.textContent='–'; }
    draw(d0, h0, di, hi, f);
  }

  function draw(d0,h0,di,hi,f){
    const w = canvas.width = canvas.getBoundingClientRect().width|0, h = canvas.height;
    ctx.clearRect(0,0,w,h);
    ctx.strokeStyle='#94a3b8'; ctx.beginPath(); ctx.moveTo(10,h/2); ctx.lineTo(w-10,h/2); ctx.stroke();
    const cx = Math.floor(w/2);
    ctx.strokeStyle='#0ea5e9'; ctx.beginPath(); ctx.moveTo(cx, 20); ctx.lineTo(cx, h-20); ctx.stroke();
    const scale = 5; const F1 = cx + f*scale, F2 = cx - f*scale; ctx.fillStyle='#0ea5e9'; ctx.fillRect(F1-2,h/2-2,4,4); ctx.fillRect(F2-2,h/2-2,4,4); ctx.fillStyle='#475569'; ctx.font='12px sans-serif'; ctx.fillText('F', F1+6, h/2-4); ctx.fillText('F', F2-14, h/2-4);
    const objX = cx - d0*scale; const objY = h/2 - h0*scale; ctx.strokeStyle='#111827'; ctx.beginPath(); ctx.moveTo(objX, h/2); ctx.lineTo(objX, objY); ctx.lineTo(objX+8, objY); ctx.stroke();
    if(isFinite(di)){
      const imgX = cx + di*scale; const imgY = h/2 - (hi||0)*scale; ctx.strokeStyle='#ef4444';
      if(di<0){ ctx.setLineDash([5,4]); }
      ctx.beginPath(); ctx.moveTo(imgX, h/2); ctx.lineTo(imgX, imgY); ctx.lineTo(imgX-8, imgY); ctx.stroke(); ctx.setLineDash([]);
      ctx.strokeStyle='#22c55e'; ctx.lineWidth=1.5; // rays
      // Ray 1: parallel then through F (or appearing from F)
      ctx.beginPath(); ctx.moveTo(objX, objY); ctx.lineTo(cx, objY);
      const slope1 = (objY - (h/2)) / (F1 - cx + 1e-6);
      const yAtRight = objY + slope1*(w-10-cx);
      ctx.lineTo(w-10, yAtRight); ctx.stroke();
      if(di<0){ // back-projection dashed to virtual image
        ctx.setLineDash([5,4]); ctx.beginPath(); ctx.moveTo(cx, objY); ctx.lineTo(imgX, imgY); ctx.stroke(); ctx.setLineDash([]);
      }
      // Ray 2: through center (undeviated)
      ctx.beginPath(); ctx.moveTo(objX, objY); ctx.lineTo(w-10, objY + (w-10-objX)*((h/2-objY)/(cx-objX+1e-6))); ctx.stroke();
      if(di<0){ ctx.setLineDash([5,4]); ctx.beginPath(); ctx.moveTo(objX, objY); ctx.lineTo(imgX, imgY); ctx.stroke(); ctx.setLineDash([]); }
    }
  }
  function unitLabel(){ return uSel.value; }
  function toCm(val, u){ const map={ mm:0.1, cm:1, m:100, in:2.54 }; return val* (map[u]||1); }
  function fromCm(val, u){ const map={ mm:10, cm:1, m:0.01, in:1/2.54 }; return val* (map[u]||1); }
  function updateUnitLabels(){ const u=unitLabel(); ['u_do','u_ho','u_di','u_hi'].forEach(id=>{ const el=document.getElementById(id); if(el) el.textContent=u; }); }
  $('btnTrace').addEventListener('click', trace);
  ;['input','change'].forEach(ev=> [kind,fEl,doEl,hoEl, uSel].forEach(el=> el.addEventListener(ev, ()=>{ updateUnitLabels(); trace(); })));
  // Presets
  document.querySelectorAll('#presetBtn ~ .dropdown-menu a[data-preset]').forEach(item=> item.addEventListener('click', (e)=>{
    e.preventDefault(); const p=item.getAttribute('data-preset'); const u=unitLabel();
    if(p==='lens-2f'){ kind.value='conv_lens'; fEl.value='10'; doEl.value='40'; hoEl.value='5'; }
    if(p==='lens-between'){ kind.value='conv_lens'; fEl.value='10'; doEl.value='20'; hoEl.value='5'; }
    if(p==='lens-inside'){ kind.value='conv_lens'; fEl.value='10'; doEl.value='6'; hoEl.value='5'; }
    if(p==='div-lens'){ kind.value='div_lens'; fEl.value='10'; doEl.value='20'; hoEl.value='5'; }
    if(p==='conc-mirror'){ kind.value='conc_mirror'; fEl.value='10'; doEl.value='40'; hoEl.value='5'; }
    if(p==='conv-mirror'){ kind.value='conv_mirror'; fEl.value='10'; doEl.value='20'; hoEl.value='5'; }
    trace();
  }));
  // Save and Share
  $('btnSaveImg').addEventListener('click', ()=>{ try{ const url=canvas.toDataURL('image/png'); const a=document.createElement('a'); a.href=url; a.download='ray-trace.png'; a.click(); }catch(e){ alert('Unable to save image.'); } });
  $('btnShare').addEventListener('click', async ()=>{
    const params=new URLSearchParams({ kind: kind.value, f: fEl.value, d0: doEl.value, h0: hoEl.value, u: unitLabel() });
    const link=`${location.origin}${location.pathname}?${params.toString()}`;
    try{ await navigator.clipboard.writeText(link); alert('Share URL copied'); }catch(e){ prompt('Copy this URL', link); }
  });
  // Apply query
  (function(){ const p=new URLSearchParams(location.search); if(p.has('kind')) kind.value=p.get('kind'); if(p.has('f')) fEl.value=p.get('f'); if(p.has('d0')) doEl.value=p.get('d0'); if(p.has('h0')) hoEl.value=p.get('h0'); if(p.has('u')) uSel.value=p.get('u'); updateUnitLabels(); })();
  try{ trace(); }catch(e){}
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>
