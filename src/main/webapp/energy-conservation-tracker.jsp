<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Energy Conservation Tracker – KE↔PE with Friction</title>
  <meta name="description" content="Track energy conversion between kinetic and potential energy with friction losses. Enter mass, height, velocity and visualize KE/PE over position. Adjustable friction/drag slider.">
  <meta name="keywords" content="energy calculator physics, kinetic energy calculator, potential energy calculator, energy conservation, friction losses, physics energy tool">
  <link rel="canonical" href="https://8gwifi.org/energy-conservation-tracker.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Energy Conservation Tracker","url":"https://8gwifi.org/energy-conservation-tracker.jsp","applicationCategory":"EducationalApplication","operatingSystem":"Web","description":"KE/PE conversion with friction losses and bar chart visualization.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},"keywords":["energy calculator physics","kinetic energy calculator","potential energy calculator"]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How can I model energy transfer with friction?","acceptedAnswer":{"@type":"Answer","text":"Set a non-zero friction slider to simulate a fraction of total mechanical energy dissipated over distance. The Loss column shows how much energy converts to heat or sound as the object moves."}},
    {"@type":"Question","name":"What classroom prompt reinforces KE and PE interplay?","acceptedAnswer":{"@type":"Answer","text":"Ask students to predict the KE and PE values halfway down the track before pressing Run. After checking, have them explain where the difference between their prediction and the chart arises."}},
    {"@type":"Question","name":"How do I connect this to conservation statements?","acceptedAnswer":{"@type":"Answer","text":"Use mu = 0 first to demonstrate KE + PE remaining constant. Then add friction to show how total mechanical energy decreases, prompting discussion of energy transfer to the environment."}}
  ]}
  </script>
  <style>
    .en .card-header{padding:.6rem .9rem;font-weight:600}
    .en .card-body{padding:.7rem .9rem}
    .en-edu-grid{display:grid;gap:.75rem;margin-bottom:.75rem}
    @media (min-width:768px){.en-edu-grid{grid-template-columns:repeat(3,1fr)}}
    .en-edu-card{border-radius:8px;border-left:4px solid;padding:.75rem .9rem;background:#fff;box-shadow:0 1px 3px rgba(15,23,42,0.08);color:#0f172a}
    .en-edu-card h6{font-size:.95rem;font-weight:600;margin-bottom:.35rem}
    .en-edu-card p{margin-bottom:.35rem;font-size:.9rem}
    .en-edu-card ul{padding-left:1rem;margin-bottom:0;font-size:.88rem}
    .en-edu-card ul li{margin-bottom:.25rem}
    .en-edu-card--concept{background:#ecfeff;border-left-color:#0ea5e9}
    .en-edu-card--investigate{background:#fef9c3;border-left-color:#facc15}
    .en-edu-card--alert{background:#fef3c7;border-left-color:#f97316}
    .en-faq-item + .en-faq-item{margin-top:.75rem}
    .en-faq-item strong{color:#0f172a}
    .en-formula-list{padding-left:1rem;margin-bottom:.75rem;font-size:.9rem}
    .en-formula-list li{margin-bottom:.25rem}
    .en-formula-heading{text-transform:uppercase;color:#475569;font-weight:600;font-size:.8rem;letter-spacing:.04em;margin-bottom:.25rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4 en">
  <h1 class="mb-2">Energy Conservation Tracker</h1>
  <p class="text-muted mb-3">See how mechanical energy splits between kinetic and potential energy as an object moves, and how friction reduces total energy.</p>
  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3"><h5 class="card-header">Inputs</h5><div class="card-body">
        <div class="form-group"><label for="m">Mass m (kg)</label><input id="m" type="number" step="0.01" class="form-control" value="1"></div>
        <div class="form-group"><label for="h">Height h (m)</label><input id="h" type="number" step="0.01" class="form-control" value="10"></div>
        <div class="form-group"><label for="v">Velocity v (m/s)</label><input id="v" type="number" step="0.01" class="form-control" value="0"></div>
        <div class="form-group"><label for="g">Gravity g (m/s²)</label><input id="g" type="number" step="0.01" class="form-control" value="9.81"></div>
        <div class="form-group"><label for="mu">Friction loss (0–1)</label><input id="mu" type="range" min="0" max="1" step="0.01" class="form-control-range" value="0.1"></div>
        <button id="btnRun" class="btn btn-primary btn-sm">Run</button>
      </div></div>
      <div class="card mb-3"><h5 class="card-header">Instant Values</h5><div class="card-body">
        <div>PE = <span id="pe">–</span> J, KE = <span id="ke">–</span> J, E<sub>total</sub> = <span id="etot">–</span> J</div>
      </div></div>
    </div>
    <div class="col-lg-8">
      <div class="card mb-3"><h5 class="card-header">Energy Over Position</h5><div class="card-body">
        <canvas id="energyChart" height="260"></canvas>
        <div class="mt-2">
          <button id="btnSaveImg" class="btn btn-outline-secondary btn-sm">Save Image</button>
          <button id="btnShare" class="btn btn-outline-secondary btn-sm">Share URL</button>
        </div>
        <small class="text-muted d-block mt-1">Bar chart shows KE (blue), PE (green), and lost energy (gray) along the path.</small>
      </div></div>
    </div>
  </div>
  <div class="card mb-3">
    <h5 class="card-header">FAQ & Teaching Notes</h5>
    <div class="card-body">
      <div class="en-edu-grid">
        <div class="en-edu-card en-edu-card--concept">
          <h6>Concept Focus</h6>
          <p>Highlight that mechanical energy splits into KE and PE, with losses representing energy transferred to the surroundings.</p>
          <ul class="mb-0">
            <li>Run once with friction off to show constant KE + PE.</li>
            <li>Re-run with friction to compare areas under the bar stacks.</li>
          </ul>
        </div>
        <div class="en-edu-card en-edu-card--investigate">
          <h6>Investigation Idea</h6>
          <p>Assign groups different friction values and ask them to infer a real-world scenario (ice rink, rough ramp, roller coaster).</p>
          <ul class="mb-0">
            <li>Have students sketch energy bar charts at the start, middle, and end.</li>
            <li>Challenge them to calculate the work done by friction using loss data.</li>
          </ul>
        </div>
        <div class="en-edu-card en-edu-card--alert">
          <h6>Misconception Alert</h6>
          <p>Students may think energy disappears with friction. Emphasize that it converts to thermal energy.</p>
          <ul class="mb-0">
            <li>Ask: “Where did the missing mechanical energy go?”</li>
            <li>Connect to the first law: total energy stays constant when including thermal.</li>
          </ul>
        </div>
      </div>
    <div class="en-formula-heading">Formula Breakdown</div>
    <ul class="en-formula-list">
      <li>Potential energy: <code>PE = m · g · h</code></li>
      <li>Kinetic energy: <code>KE = ½ m v²</code></li>
      <li>Total mechanical energy: <code>E<sub>0</sub> = PE + KE</code></li>
      <li>Friction loss at step i: <code>Loss = μ · E<sub>0</sub> · (distance / total distance)</code></li>
      <li>Remaining KE along the path: <code>KE = max(0, E<sub>0</sub> − Loss − PE)</code></li>
    </ul>
      <div class="en-faq-item">
        <strong>How can I model energy transfer with friction?</strong><br>
        Set a non-zero friction slider to simulate a fraction of total mechanical energy dissipated over distance. The Loss dataset shows how much energy converts to heat or sound as the object moves.
      </div>
      <div class="en-faq-item">
        <strong>What classroom prompt reinforces KE and PE interplay?</strong><br>
        Ask students to predict the KE and PE values halfway down the track before pressing Run. After checking, have them explain where any difference between their prediction and the chart arises.
      </div>
      <div class="en-faq-item mb-0">
        <strong>How do I connect this to conservation statements?</strong><br>
        Use μ = 0 first to demonstrate KE + PE remaining constant. Then add friction to show how total mechanical energy decreases while total energy (including thermal) remains conserved.
      </div>
    </div>
  </div>
</div>
<script>
(function(){
  const $=(id)=>document.getElementById(id);
  const mEl=$('m'), hEl=$('h'), vEl=$('v'), gEl=$('g'), muEl=$('mu');
  const pe=$('pe'), ke=$('ke'), et=$('etot');
  const ctx=document.getElementById('energyChart').getContext('2d'); let chart;
  // Apply query params if present
  (function applyQuery(){
    const p=new URLSearchParams(window.location.search);
    if(p.has('m')) mEl.value=p.get('m');
    if(p.has('h')) hEl.value=p.get('h');
    if(p.has('v')) vEl.value=p.get('v');
    if(p.has('g')) gEl.value=p.get('g');
    if(p.has('mu')) muEl.value=p.get('mu');
  })();
  function run(){
    const m=parseFloat(mEl.value)||0, h=parseFloat(hEl.value)||0, v=parseFloat(vEl.value)||0, g=parseFloat(gEl.value)||9.81, mu=parseFloat(muEl.value)||0;
    const PE0 = m*g*h, KE0 = 0.5*m*v*v; const E0 = PE0+KE0; pe.textContent=PE0.toFixed(2); ke.textContent=KE0.toFixed(2); et.textContent=E0.toFixed(2);
    // simulate N segments as object descends from h to 0 with linear friction loss fraction mu across the path
    const N=20, xs=[], peArr=[], keArr=[], lossArr=[];
    for(let i=0;i<=N;i++){
      const y = h*(1-i/N);
      const loss = mu*E0*(i/N); // proportional loss
      const PE = m*g*y;
      const KE = Math.max(0, E0 - loss - PE);
      xs.push((h - y).toFixed(2)); peArr.push(PE); keArr.push(KE); lossArr.push(loss);
    }
    if(chart) chart.destroy();
    chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: xs,
        datasets: [
          { label: 'PE', data: peArr, backgroundColor: '#10b981' },
          { label: 'KE', data: keArr, backgroundColor: '#0ea5e9' },
          { label: 'Loss', data: lossArr, backgroundColor: '#94a3b8' }
        ]
      },
      options: {
        responsive: true,
        scales: {
          x: { title: { display: true, text: 'Distance fallen (m)' } },
          y: { title: { display: true, text: 'Energy (J)' } }
        }
      }
    });
  }
  $('btnRun').addEventListener('click', run);
  ['input','change'].forEach(function(ev){
    [mEl, hEl, vEl, gEl, muEl].forEach(function(el){
      el.addEventListener(ev, run);
    });
  });
  // Save chart image
  $('btnSaveImg').addEventListener('click', ()=>{
    try{
      const canvas = document.getElementById('energyChart');
      const url = canvas.toDataURL('image/png');
      const a=document.createElement('a'); a.href=url; a.download='energy-conservation.png'; a.click();
    }catch(e){ alert('Unable to save image.'); }
  });
  // Share URL
  $('btnShare').addEventListener('click', async ()=>{
    const params=new URLSearchParams({
      m: mEl.value, h: hEl.value, v: vEl.value, g: gEl.value, mu: muEl.value
    });
    const shareUrl = `${location.origin}${location.pathname}?${params.toString()}`;
    try{
      await navigator.clipboard.writeText(shareUrl);
      alert('Share URL copied to clipboard');
    }catch(e){ prompt('Copy this URL', shareUrl); }
  });
  try{ run(); }catch(e){}
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>
