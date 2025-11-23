<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Free Fall & Gravity Drop Calculator – Time to Fall, Impact Velocity (Earth/Moon/Mars)</title>
  <meta name="description" content="Free fall and gravity drop calculator. Enter height and gravity to get time to fall and impact velocity. Optional air resistance with quadratic drag. Presets for Earth, Moon, and Mars. Live animation and y(t), v(t) graphs.">
  <meta name="keywords" content="free fall calculator, gravity calculator, drop time calculator, time to fall, impact velocity, moon gravity, mars gravity, physics free fall, fall time calculator, terminal velocity calculator">
  <link rel="canonical" href="https://8gwifi.org/free-fall-calculator.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Free Fall & Gravity Drop Calculator","url":"https://8gwifi.org/free-fall-calculator.jsp","applicationCategory":"EducationalApplication","operatingSystem":"Web","description":"Compute time to fall and impact velocity with optional air resistance. Presets for Earth, Moon, and Mars.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},"keywords":["free fall calculator","gravity calculator","drop time calculator","impact velocity","terminal velocity"]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I calculate drop time?","acceptedAnswer":{"@type":"Answer","text":"Without air resistance, time to fall from height h under gravity g is t = √(2h/g). With air resistance, this tool uses numerical simulation with quadratic drag."}},
    {"@type":"Question","name":"What about impact speed?","acceptedAnswer":{"@type":"Answer","text":"Without drag, v = √(2gh + v₀²). With drag, terminal velocity is vₜ = √(2mg/(ρ C_d A)); the tool simulates until ground to estimate impact speed."}},
    {"@type":"Question","name":"Can I use Moon or Mars gravity?","acceptedAnswer":{"@type":"Answer","text":"Yes. Use Preset to switch between Earth (9.81 m/s²), Moon (1.62 m/s²), and Mars (3.71 m/s²), or enter a custom value."}},
    {"@type":"Question","name":"How can teachers use the animation in class?","acceptedAnswer":{"@type":"Answer","text":"Use the play/pause controls to freeze the motion at key instants. Ask students to map the ball's height to the y(t) graph, or to compare Earth, Moon, and Mars overlays for cross-planet reasoning."}},
    {"@type":"Question","name":"What misconception should I address?","acceptedAnswer":{"@type":"Answer","text":"Students often think heavier objects fall faster in vacuum. Toggle drag off, keep mass constant, and let different heights show identical accelerations to emphasise g is independent of mass without resistance."}}
  ]}
  </script>

  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Free Fall & Gravity Drop Calculator">
  <meta property="og:description" content="Enter height and gravity to get time to fall and impact velocity. Air resistance and Earth/Moon/Mars presets.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/free-fall-calculator.jsp">

  <style>
    .ff .card-header{padding:.6rem .9rem;font-weight:600}
    .ff .card-body{padding:.7rem .9rem}
    .ff .form-group{margin-bottom:.6rem}
    .kv{display:grid;grid-template-columns:1fr auto;gap:.35rem .75rem}
    .kv .label{color:#64748b}
    .kv .value{font-weight:600}
    .ff-toolbar{display:flex;align-items:center;gap:.5rem;flex-wrap:wrap}
    .mini-track{border:1px solid #e5e7eb;border-radius:6px;padding:.25rem .5rem;background:#fff}
    .ff-edu-grid{display:grid;gap:.75rem;margin-bottom:.75rem}
    @media (min-width:768px){.ff-edu-grid{grid-template-columns:repeat(3,1fr)}}
    .ff-edu-card{border-radius:8px;border-left:4px solid;padding:.75rem .9rem;background:#fff;color:#0f172a;box-shadow:0 1px 3px rgba(15,23,42,0.08)}
    .ff-edu-card h6{font-size:.95rem;font-weight:600;margin-bottom:.35rem}
    .ff-edu-card p{margin-bottom:.35rem;font-size:.9rem}
    .ff-edu-card ul{padding-left:1rem;margin-bottom:0;font-size:.88rem}
    .ff-edu-card ul li{margin-bottom:.25rem}
    .ff-edu-card--concept{background:#ecfeff;border-left-color:#0ea5e9}
    .ff-edu-card--teach{background:#f0fdf4;border-left-color:#22c55e}
    .ff-edu-card--alert{background:#fef3c7;border-left-color:#f59e0b}
    .ff-faq-item + .ff-faq-item{margin-top:.75rem}
    .ff-faq-item strong{color:#0f172a}
    .ff-formula-card ul{padding-left:1rem;margin-bottom:.5rem;font-size:.9rem}
    .ff-formula-card ul li{margin-bottom:.25rem}
    .ff-formula-card .small{text-transform:uppercase;color:#64748b;font-weight:600;margin-bottom:.25rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 ff">
  <h1 class="mb-2">Free Fall & Gravity Drop</h1>
  <p class="text-muted mb-3">Compute time to fall and impact velocity from a given height. Toggle air resistance and switch between Earth, Moon, and Mars. Includes live animation plus y(t) and v(t) graphs.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Inputs</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="preset">Preset</label>
            <select id="preset" class="form-control">
              <option value="earth" selected>Earth (9.81 m/s²)</option>
              <option value="moon">Moon (1.62 m/s²)</option>
              <option value="mars">Mars (3.71 m/s²)</option>
              <option value="custom">Custom</option>
            </select>
          </div>
          <div class="form-group">
            <label for="h">Height h</label>
            <div class="input-group">
              <input id="h" type="number" step="0.01" class="form-control" value="100">
              <div class="input-group-append">
                <select id="unitH" class="form-control">
                  <option value="m" selected>m</option>
                  <option value="ft">ft</option>
                  <option value="km">km</option>
                  <option value="mi">mi</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="hPreset">Height Preset</label>
            <select id="hPreset" class="form-control">
              <option value="">Select...</option>
              <option value="10">10 m (~33 ft)</option>
              <option value="50">50 m</option>
              <option value="100">100 m</option>
              <option value="1000">1000 m</option>
            </select>
          </div>
          <div class="form-group">
            <label for="g">Gravity g (m/s²)</label>
            <input id="g" type="number" step="0.01" class="form-control" value="9.81">
          </div>
          <div class="form-group">
            <label for="v0">Initial speed v₀ downward</label>
            <div class="input-group">
              <input id="v0" type="number" step="0.01" class="form-control" value="0">
              <div class="input-group-append">
                <select id="unitV" class="form-control">
                  <option value="mps" selected>m/s</option>
                  <option value="kmph">km/h</option>
                  <option value="mph">mph</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group form-check">
            <input class="form-check-input" type="checkbox" id="dragOn">
            <label class="form-check-label" for="dragOn">Air Resistance (quadratic)</label>
          </div>
          <div id="dragCfg" style="display:none">
            <div class="form-group"><label for="rho">Air Density ρ (kg/m³)</label><input id="rho" type="number" step="0.01" class="form-control" value="1.225"></div>
            <div class="form-group"><label for="cd">Drag Coefficient C<sub>d</sub></label><input id="cd" type="number" step="0.01" class="form-control" value="0.47"></div>
            <div class="form-group"><label for="area">Cross-section A (m²)</label><input id="area" type="number" step="0.0001" class="form-control" value="0.04"></div>
            <div class="form-group"><label for="mass">Mass m (kg)</label><input id="mass" type="number" step="0.01" class="form-control" value="80"></div>
          </div>
          <div class="ff-toolbar mt-2">
            <button id="btnSolve" class="btn btn-primary btn-sm">Compute</button>
            <button id="btnSavePng" class="btn btn-outline-secondary btn-sm">Save PNG</button>
            <button id="btnShareLink" class="btn btn-outline-primary btn-sm">Share</button>
            <small id="shareMsg" class="text-success" style="display:none">Link copied</small>
            <button id="btnPlay" class="btn btn-outline-success btn-sm">Play</button>
            <select id="speed" class="form-control form-control-sm" style="width:auto">
              <option value="0.5">0.5×</option>
              <option value="1" selected>1×</option>
              <option value="2">2×</option>
              <option value="4">4×</option>
            </select>
          </div>
          <div id="err" class="text-danger mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Results</h5>
        <div class="card-body">
          <div class="kv">
            <div class="label">Time to impact</div><div class="value" id="out_t">–</div>
            <div class="label">Impact speed</div><div class="value" id="out_v">–</div>
            <div class="label">Terminal speed (est.)</div><div class="value" id="out_vt">–</div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related</h5>
        <div class="card-body">
          <ul class="mb-0">
            <li><a href="projectile-motion-simulator.jsp">Projectile Motion Simulator</a></li>
            <li><a href="kinematics-calculator.jsp">Kinematics Equation Solver</a></li>
            <li><a href="graphing-calculator.jsp">Graphing Calculator</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Animation</h5>
        <div class="card-body">
          <div class="mini-track"><canvas id="track" height="260" style="width:100%"></canvas></div>
          <div class="d-flex align-items-center mt-1">
            <small class="text-muted">Ball falls from height h to ground (y=0). With air resistance on, motion approaches terminal speed.</small>
            <div id="simTimer" class="small text-muted ml-auto">t = 0.00 s</div>
          </div>
          <div id="legendAnim" class="small mt-2"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Graphs
          <span>
            <div class="form-check form-check-inline">
              <input class="form-check-input" type="checkbox" id="toggleTeach">
              <label class="form-check-label small" for="toggleTeach">Teaching</label>
            </div>
            <button id="btnComparePlanets" class="btn btn-sm btn-outline-dark ml-2" title="Add Earth/Moon/Mars overlays">Compare Planets</button>
            <button id="btnCompareAllPlanets" class="btn btn-sm btn-outline-dark ml-1" title="Add all planets overlays">Compare All Planets</button>
            <button id="btnAddScenario" class="btn btn-sm btn-outline-dark ml-2">Add Scenario</button>
            <button id="btnClearScenarios" class="btn btn-sm btn-outline-secondary ml-1">Clear</button>
          </span>
        </h5>
        <div class="card-body">
          <div class="row">
            <div class="col-md-6 mb-2"><canvas id="chartY" height="220"></canvas></div>
            <div class="col-md-6 mb-2"><canvas id="chartV" height="220"></canvas></div>
          </div>
          <div id="teachBox" class="small text-muted" style="display:none">For free fall (downwards positive): y(t) = h − v₀ t − ½ g t², v(t) = v₀ + g t. With drag, v approaches terminal velocity vₜ and y(t) follows a non‑parabolic trajectory.</div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Comparisons</h5>
        <div class="card-body">
          <div class="table-responsive">
            <table class="table table-sm mb-0">
              <thead class="thead-light">
                <tr>
                  <th>Color</th>
                  <th>Label</th>
                  <th>h</th>
                  <th>g</th>
                  <th>v0</th>
                  <th>t<sub>impact</sub></th>
                  <th>v<sub>impact</sub></th>
                  <th></th>
                </tr>
              </thead>
              <tbody id="scenarioRows"></tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3 ff-formula-card">
    <h5 class="card-header">Formula Breakdown</h5>
    <div class="card-body">
      <div class="small">No Air Resistance</div>
      <ul>
        <li>Time to impact: <code>t = (-v₀ + √(v₀² + 2 g h)) / g</code></li>
        <li>Impact speed: <code>v = v₀ + g · t</code></li>
        <li>Height profile: <code>y(t) = h − v₀ t − ½ g t²</code></li>
      </ul>
      <div class="small">With Quadratic Drag</div>
      <ul>
        <li>Simulated from <code>m dv/dt = m g − ½ ρ C<sub>d</sub> A v |v|</code></li>
        <li>Position from <code>dy/dt = v</code> integrated numerically (time step 0.005 s)</li>
        <li>Terminal speed estimate: <code>v<sub>t</sub> = √(2 m g / (ρ C<sub>d</sub> A))</code></li>
      </ul>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">FAQ & Teaching Notes</h5>
    <div class="card-body">
      <div class="ff-edu-grid">
        <div class="ff-edu-card ff-edu-card--concept">
          <h6>Concept Focus</h6>
          <p>Highlight that in a vacuum, all objects share the same acceleration g regardless of mass.</p>
          <ul class="mb-0">
            <li>Use the presets to compare Earth, Moon, and Mars.</li>
            <li>Toggle air drag to contrast analytic vs. numeric motion.</li>
          </ul>
        </div>
        <div class="ff-edu-card ff-edu-card--teach">
          <h6>Classroom Moves</h6>
          <p>Freeze the animation at quarter intervals and ask students to match the position with points on y(t).</p>
          <ul class="mb-0">
            <li>Invite students to predict impact speed before revealing calculations.</li>
            <li>Assign planet overlays to different lab groups for mini-presentations.</li>
          </ul>
        </div>
        <div class="ff-edu-card ff-edu-card--alert">
          <h6>Misconception Alert</h6>
          <p>“Heavier falls faster” only holds with drag. Show how terminal speed depends on mass, area, and drag coefficient.</p>
          <ul class="mb-0">
            <li>Adjust mass while drag is on to see v<sub>t</sub> change.</li>
            <li>Discuss why skydivers change body posture to alter drag.</li>
          </ul>
        </div>
      </div>
      <div class="ff-faq-item">
        <strong>What assumptions are used?</strong><br>
        Constant gravity and either no drag (analytic), or quadratic drag with constant air density for the numerical simulation.
      </div>
      <div class="ff-faq-item">
        <strong>How can I connect to energy ideas?</strong><br>
        Ask students to compute potential energy (mgh) at release and kinetic energy (½mv²) at impact, then compare with and without drag to explain where the “missing energy” goes.
      </div>
      <div class="ff-faq-item mb-0">
        <strong>What is terminal velocity?</strong><br>
        The speed where drag balances weight: v<sub>t</sub> = √(2 m g / (ρ C<sub>d</sub> A)). For lighter or larger objects, v<sub>t</sub> is lower.
      </div>
    </div>
  </div>
</div>

<script>
  (function(){
    const $ = (id)=> document.getElementById(id);
    const preset = $('preset');
    const hEl = $('h'); const gEl = $('g'); const v0El = $('v0');
    const unitH = $('unitH'); const unitV = $('unitV'); const hPreset = $('hPreset');
    const dragOn = $('dragOn'); const dragCfg = $('dragCfg');
    const rhoEl = $('rho'); const cdEl = $('cd'); const areaEl = $('area'); const massEl = $('mass');
    const outT = $('out_t'); const outV = $('out_v'); const outVt = $('out_vt'); const err = $('err');
    const btnSolve = $('btnSolve'); const btnPlay = $('btnPlay'); const speedSel = $('speed');
    const btnSave = $('btnSavePng'); const btnShare = $('btnShareLink'); const shareMsg = $('shareMsg');
    const track = $('track'); const tctx = track.getContext('2d');
    const chartYEl = $('chartY'); const chartVEl = $('chartV');
    const toggleTeach = $('toggleTeach'); const teachBox = $('teachBox');
    let chartY, chartV;
    const colors = ['#0ea5e9','#22c55e','#f59e0b','#ef4444','#a78bfa','#14b8a6'];
    let scenarios = [];

  preset.addEventListener('change', ()=>{
    if(preset.value==='earth') gEl.value = '9.81'; else if(preset.value==='moon') gEl.value='1.62'; else if(preset.value==='mars') gEl.value='3.71';
  });
  dragOn.addEventListener('change', ()=>{ dragCfg.style.display = dragOn.checked? 'block':'none'; });

    function fmt(n, u){ if(n==null || !isFinite(n)) return '–'; const v=Math.round(n*1000)/1000; return u? (v+' '+u): (''+v); }
    const M_PER_FT = 0.3048, M_PER_KM=1000, M_PER_MI=1609.344;
    const MS_PER_KMPH = 1000/3600, MS_PER_MPH = 1609.344/3600;
    function toBaseH(val){ if(!isFinite(val)) return 0; const u=unitH.value; if(u==='m') return val; if(u==='ft') return val*M_PER_FT; if(u==='km') return val*M_PER_KM; if(u==='mi') return val*M_PER_MI; return val; }
    function fromBaseH(val){ const u=unitH.value; if(u==='m') return val; if(u==='ft') return val/M_PER_FT; if(u==='km') return val/M_PER_KM; if(u==='mi') return val/M_PER_MI; return val; }
    function toBaseV(val){ const u=unitV.value; if(u==='mps') return val; if(u==='kmph') return val*MS_PER_KMPH; if(u==='mph') return val*MS_PER_MPH; return val; }
    function fromBaseV(val){ const u=unitV.value; if(u==='mps') return val; if(u==='kmph') return val/MS_PER_KMPH; if(u==='mph') return val/MS_PER_MPH; return val; }
    function fmtHBase(val){ if(!isFinite(val)) return '–'; const v=fromBaseH(val); const suf=unitH.value; const f=Math.abs(v)<1?v.toFixed(3):v.toFixed(2); return f+' '+suf; }
    function fmtVBase(val){ if(!isFinite(val)) return '–'; const v=fromBaseV(val); const suf=(unitV.value==='kmph')?'km/h':(unitV.value==='mph')?'mph':'m/s'; const f=Math.abs(v)<1?v.toFixed(3):v.toFixed(2); return f+' '+suf; }

  let series = {t:[], y:[], v:[]};
  let anim = {running:false, last:0, idx:0, tNow:0};

    function compute(){
      err.style.display='none'; err.textContent='';
      const h = toBaseH(parseFloat(hEl.value)||0); const g = parseFloat(gEl.value)||9.81; const v0 = toBaseV(parseFloat(v0El.value)||0);
      if(h<=0 || g<=0){ err.style.display='block'; err.textContent='Height and gravity must be > 0.'; return null; }
      const useDrag = dragOn.checked;
      if(!useDrag){
      // Analytic free fall with initial downward v0; y(t) = h - v0 t - 1/2 g t^2; find t when y=0
      const A = 0.5*g, B = v0, C = -h; const D = B*B - 4*A*C;
      let tImpact = (D>=0)? ((-B + Math.sqrt(D))/(2*A)) : NaN; // positive root
      if(!(tImpact>0)){ err.style.display='block'; err.textContent='No valid impact time (check inputs).'; return null; }
      const vImpact = v0 + g*tImpact;
      // series
        const N=200; const ts=[], ys=[], vs=[];
        for(let i=0;i<=N;i++){ const t=tImpact*i/N; const y = Math.max(0, h - v0*t - 0.5*g*t*t); const v = v0 + g*t; ts.push(t); ys.push(fromBaseH(y)); vs.push(fromBaseV(v)); }
        outT.textContent = fmt(tImpact,'s'); outV.textContent = fmtVBase(vImpact); outVt.textContent = '–';
        return {t:ts, y:ys, v:vs, tEnd: tImpact, g:g, vt: null};
      } else {
      // Quadratic drag: m dv/dt = m g - 1/2 rho Cd A v^2 (downward positive)
      const rho = parseFloat(rhoEl.value)||1.225; const Cd = parseFloat(cdEl.value)||0.47; const A = parseFloat(areaEl.value)||0.04; const m = parseFloat(massEl.value)||80;
      const k = 0.5*rho*Cd*A/m; const vt = Math.sqrt((2*m*g)/(rho*Cd*A));
      let y=h, v=v0, t=0; const dt=0.005; const maxT=120; const ts=[], ys=[], vs=[];
      while(y>0 && t<maxT){ const a = g - k*v*Math.abs(v); v += a*dt; y -= v*dt; t += dt; if(y<0) y=0; ts.push(t); ys.push(fromBaseH(y)); vs.push(fromBaseV(v)); }
      const tImpact = ts.length? ts[ts.length-1]: NaN; const vImpact = vs.length? vs[vs.length-1]: NaN;
      outT.textContent = fmt(tImpact,'s'); outV.textContent = fmtVBase(vImpact); outVt.textContent = fmtVBase(vt);
      return {t:ts, y:ys, v:vs, tEnd: tImpact, g:g, vt: fromBaseV(vt)};
      }
    }

  function drawTrack(s){
    const w = track.width = track.getBoundingClientRect().width|0; const h = track.height;
    tctx.clearRect(0,0,w,h);
    tctx.strokeStyle = '#94a3b8'; tctx.lineWidth=2; tctx.beginPath(); tctx.moveTo(10, h-20); tctx.lineTo(w-10, h-20); tctx.stroke();
    if(!s) return;
    const tNow = anim.tNow || 0;
    const items = [{ yArr: s.y, tArr: s.t, color: '#ef4444', size: 8 }];
    for(let i=0;i<scenarios.length;i++){
      const sc = scenarios[i]; const ov = computeFromParams(sc.params); if(!ov) continue;
      items.push({ yArr: ov.y, tArr: ov.t, color: sc.color || colors[(i+2)%colors.length], size: 6 });
    }
    const maxH = Math.max(0.0001, ...items.flatMap(it=> it.yArr||[0]));
    const xCenter = w/2;
    items.forEach((it, k)=>{
      if(!(it.yArr && it.tArr && it.tArr.length)) return;
      let best = 0; let bestd = Infinity;
      for(let j=0;j<it.tArr.length;j++){ const d = Math.abs(it.tArr[j]-tNow); if(d<bestd){ bestd=d; best=j; } }
      const yVal = it.yArr[Math.max(0, Math.min(it.yArr.length-1, best))];
      const yPix = (h-20) - (yVal/maxH) * (h-40);
      const x = xCenter + (k===0? 0 : (k*14 - 14*items.length/2));
      tctx.fillStyle = it.color; tctx.beginPath(); tctx.arc(x, yPix, it.size, 0, Math.PI*2); tctx.fill();
    });
  }

function resampleTo(labels, seriesArr){
    const N = labels.length, M = seriesArr.length; const out=[];
    for(let i=0;i<N;i++){ const idx = Math.round(i*(M-1)/(N-1)); out.push(seriesArr[Math.max(0, Math.min(M-1, idx))]); }
    return out;
}
function plot(s){
    if(chartY) chartY.destroy(); if(chartV) chartV.destroy();
    
    const yUnitLabel = unitH.value;
    const vUnitLabel = (unitV.value==='kmph')?'km/h':(unitV.value==='mph')?'mph':'m/s';
    const datasetsY = [{label:`y (${yUnitLabel})`, data:s.y, borderColor:colors[0], pointRadius:0, tension:.12 }];
    const datasetsV = [{label:`v (${vUnitLabel})`, data:s.v, borderColor:colors[1], pointRadius:0, tension:.12 }];
    for(let i=0;i<scenarios.length;i++){
      const sc = scenarios[i];
      const ov = computeFromParams(sc.params); if(!ov) continue;
      datasetsY.push({ label:'', data: resampleTo(s.t, ov.y), borderColor: sc.color||colors[(i+2)%colors.length], pointRadius:0, tension:.12 });
      datasetsV.push({ label:'', data: resampleTo(s.t, ov.v), borderColor: sc.color||colors[(i+2)%colors.length], pointRadius:0, tension:.12 });
    }
    chartY = new Chart(chartYEl, { type:'line', data:{ labels:s.t, datasets:datasetsY }, options:{ responsive:true, scales:{ x:{ title:{display:true,text:'t (s)'} }, y:{ title:{display:true,text:`y (${yUnitLabel})`} } }, plugins:{legend:{display:false}} } });

    if(s.vt){ const vtLine = s.t.map(()=> s.vt); datasetsV.push({ label:'v_t', data: vtLine, borderColor:'#f59e0b', borderDash:[6,6], pointRadius:0, tension:0 }); }
    chartV = new Chart(chartVEl, { type:'line', data:{ labels:s.t, datasets:datasetsV }, options:{ responsive:true, scales:{ x:{ title:{display:true,text:'t (s)'} }, y:{ title:{display:true,text:`v (${vUnitLabel})`} } }, plugins:{legend:{display:false}} } });
    rebuildLegend();

  }

  
  function rebuildLegend(){
    const box = document.getElementById('legendAnim'); if(!box) return;
    let html = `<span style="display:inline-flex;align-items:center;margin-right:8px"><span style="display:inline-block;width:12px;height:12px;background:#ef4444;border-radius:50%;margin-right:6px"></span>Current</span>`;
    for(let i=0;i<scenarios.length;i++){
      const sc = scenarios[i]; const color = sc.color || colors[(i+2)%colors.length];
      const name = sc.name || `g=${fmt(sc.params.g,'m/s²')}`;
      html += `<span style="display:inline-flex;align-items:center;margin-right:8px"><span style="display:inline-block;width:12px;height:12px;background:${color};border-radius:50%;margin-right:6px"></span>${name}</span>`;
    }
    box.innerHTML = html;
  }
function solveAndRender(){ const s = compute(); if(!s) return; series=s; anim.idx=0; drawTrack(series); plot(series); }
  btnSolve.addEventListener('click', solveAndRender);
  preset.addEventListener('change', solveAndRender);
  ;['change','input'].forEach(ev=>{ [hEl,gEl,v0El,rhoEl,cdEl,areaEl,massEl].forEach(el=> el.addEventListener(ev, ()=>{ if(el===gEl && preset.value!=='custom') preset.value='custom'; })); });
  hPreset.addEventListener('change', ()=>{ if(hPreset.value){ hEl.value=hPreset.value; solveAndRender(); }});
  ;[unitH, unitV].forEach(sel=> sel.addEventListener('change', solveAndRender));
  if(toggleTeach) toggleTeach.addEventListener('change', ()=>{ if(teachBox) teachBox.style.display = toggleTeach.checked? '':'none'; });

  function step(ts){
    if(!anim.running) return;
    if(!anim.last) anim.last=ts;
    const dt=(ts-anim.last)/1000; anim.last=ts;
    if(!series||!series.t.length){ requestAnimationFrame(step); return; }
    let tMax = series.tEnd || (series.t[series.t.length-1]||1);
    for(let i=0;i<scenarios.length;i++){ const ov = computeFromParams(scenarios[i].params); if(ov && ov.tEnd && ov.tEnd>tMax) tMax = ov.tEnd; }
    const speed=parseFloat(speedSel.value)||1;
    anim.tNow += dt*speed;
    if(anim.tNow >= tMax){ anim.tNow = tMax; anim.running=false; btnPlay.textContent='Replay'; }
    var timerEl = document.getElementById('simTimer'); if(timerEl){ timerEl.textContent = 't = ' + (Math.round(anim.tNow*100)/100).toFixed(2) + ' s'; }
    drawTrack(series);
    if(anim.running) requestAnimationFrame(step);
  }
  
  function currentParams(){
    return { hBase: toBaseH(parseFloat(hEl.value)||0), g: parseFloat(gEl.value)||9.81, v0Base: toBaseV(parseFloat(v0El.value)||0), drag: !!dragOn.checked, rho: parseFloat(rhoEl.value)||1.225, cd: parseFloat(cdEl.value)||0.47, area: parseFloat(areaEl.value)||0.04, mass: parseFloat(massEl.value)||80 };
  }
  function computeFromParams(p){
    const h=p.hBase, g=p.g, v0=p.v0Base;
    if(!p.drag){
      const A=0.5*g, B=v0, C=-h, D=B*B - 4*A*C; if(!(D>=0)) return null; const tImpact=(-B + Math.sqrt(D))/(2*A); const N=200; const ts=[], ys=[], vs=[]; for(let i=0;i<=N;i++){ const t=tImpact*i/N; const y=Math.max(0, h - v0*t - 0.5*g*t*t); const v=v0 + g*t; ts.push(t); ys.push(fromBaseH(y)); vs.push(fromBaseV(v)); } return {t:ts, y:ys, v:vs, tEnd:tImpact, g:g, vt:null};
    } else {
      const k = 0.5*p.rho*p.cd*p.area/p.mass; const vt=Math.sqrt((2*p.mass*g)/(p.rho*p.cd*p.area)); let y=h, v=v0, t=0; const dt=0.005; const maxT=120; const ts=[], ys=[], vs=[]; while(y>0 && t<maxT){ const a=g - k*v*Math.abs(v); v+=a*dt; y-=v*dt; t+=dt; if(y<0) y=0; ts.push(t); ys.push(fromBaseH(y)); vs.push(fromBaseV(v)); } return {t:ts, y:ys, v:vs, tEnd:t, g:g, vt:fromBaseV(vt)};
    }
  }
  function rebuildTable(){
    const tbody = document.getElementById('scenarioRows'); if(!tbody) return;
    tbody.innerHTML = scenarios.map((sc,i)=>{
      const ov = computeFromParams(sc.params); if(!ov) return '';
      const tImp = ov.tEnd; const vImp = ov.v[ov.v.length-1];
      const label = sc.name || '';
      return `<tr>
        <td><input type="color" value="${sc.color}" data-i="${i}" class="sc-color"></td>
        <td><input type="text" value="${label}" data-i="${i}" class="sc-label form-control form-control-sm" style="width:120px"></td>
        <td>${fmtHBase(sc.params.hBase)}</td>
        <td>${fmt(sc.params.g,'m/s²')}</td>
        <td>${fmtVBase(sc.params.v0Base)}</td>
        <td>${fmt(tImp,'s')}</td>
        <td>${fmtVBase(vImp)}</td>
        <td><button class="btn btn-sm btn-outline-danger sc-remove" data-i="${i}">Remove</button></td>
      </tr>`;
    }).join('');
  }

  const btnAddScenario = document.getElementById('btnAddScenario'); if(btnAddScenario) btnAddScenario.addEventListener('click', ()=>{ const p=currentParams(); const color = colors[(scenarios.length)%colors.length]; scenarios.push({params:p, color, name:`Scenario ${scenarios.length+1}`}); rebuildTable(); plot(series||compute()); });
  const btnClearScenarios = document.getElementById('btnClearScenarios'); if(btnClearScenarios) btnClearScenarios.addEventListener('click', ()=>{ scenarios=[]; rebuildTable(); plot(series||compute()); });
  
const scenarioRowsEl = document.getElementById('scenarioRows');
if(scenarioRowsEl){
  scenarioRowsEl.addEventListener('input', (e)=>{
    if(e.target && e.target.classList.contains('sc-color')){
      const i=parseInt(e.target.getAttribute('data-i'),10);
      if(!isNaN(i)&&scenarios[i]){ scenarios[i].color=e.target.value; plot(series||compute()); }
    }
    if(e.target && e.target.classList.contains('sc-label')){
      const i=parseInt(e.target.getAttribute('data-i'),10);
      if(!isNaN(i)&&scenarios[i]){ scenarios[i].name = e.target.value; rebuildLegend(); }
    }
  });
  scenarioRowsEl.addEventListener('click', (e)=>{
    if(e.target && e.target.classList.contains('sc-remove')){
      const i=parseInt(e.target.getAttribute('data-i'),10);
      if(!isNaN(i)){ scenarios.splice(i,1); rebuildTable(); plot(series||compute()); }
    }
  });
}
btnPlay.addEventListener('click', ()=>{
  if(!series||!series.t.length){ const s=compute(); if(!s) return; series=s; plot(series); }
  let tMax = series.tEnd || (series.t[series.t.length-1]||1);
  for(let i=0;i<scenarios.length;i++){ const ov = computeFromParams(scenarios[i].params); if(ov && ov.tEnd && ov.tEnd>tMax) tMax = ov.tEnd; }
  if(anim.tNow >= tMax - 1e-6){ anim.tNow = 0; var te=document.getElementById('simTimer'); if(te){ te.textContent='t = 0.00 s'; } }
  anim.running=!anim.running; btnPlay.textContent = anim.running? 'Pause':'Play'; if(anim.running){ anim.last=0; requestAnimationFrame(step);} 
});

  // preset compare for planets
  const btnComparePlanets = document.getElementById('btnComparePlanets');
  if(btnComparePlanets){
    btnComparePlanets.addEventListener('click', ()=>{
      const base = currentParams();
      const planetGs = [ {name:'Earth', g:9.81, color:'#0ea5e9'}, {name:'Moon', g:1.62, color:'#a78bfa'}, {name:'Mars', g:3.71, color:'#f59e0b'} ];
      scenarios = planetGs.map(p=> ({ params: { ...base, g:p.g }, color: p.color, name: p.name }));
      rebuildTable(); plot(series||compute());
    });
  }
  const btnCompareAllPlanets = document.getElementById('btnCompareAllPlanets');
  if(btnCompareAllPlanets){
    btnCompareAllPlanets.addEventListener('click', ()=>{
      const base = currentParams();
      const list = [
        {name:'Mercury', g:3.70, color:'#ef4444'},
        {name:'Venus', g:8.87, color:'#eab308'},
        {name:'Earth', g:9.81, color:'#0ea5e9'},
        {name:'Mars', g:3.71, color:'#f59e0b'},
        {name:'Jupiter', g:24.79, color:'#22c55e'},
        {name:'Saturn', g:10.44, color:'#14b8a6'},
        {name:'Uranus', g:8.69, color:'#a78bfa'},
        {name:'Neptune', g:11.15, color:'#6366f1'}
      ];
      scenarios = list.map(p=> ({ params: { ...base, g:p.g }, color: p.color, name: p.name }));
      rebuildTable(); plot(series||compute());
    });
  }


  // save PNG
  btnSave.addEventListener('click', ()=>{
    try{
      const off = document.createElement('canvas');
      const w = Math.max(chartYEl.width, chartVEl.width);
      const pad = 64, gap = 8; const h = chartYEl.height + chartVEl.height + pad + gap;
      off.width = w; off.height = h;
      const ctx = off.getContext('2d'); ctx.fillStyle='#fff'; ctx.fillRect(0,0,w,h);
      ctx.drawImage(chartYEl, 0, 0);
      ctx.drawImage(chartVEl, 0, chartYEl.height + gap);
      const meta = [
        'Free Fall & Gravity Drop',
        'h: '+fmtHBase(toBaseH(parseFloat(hEl.value)||0))+'  g: '+fmt(parseFloat(gEl.value)||9.81,'m/s²')+'  v0: '+fmtVBase(toBaseV(parseFloat(v0El.value)||0)),
        'https://8gwifi.org/free-fall-calculator.jsp'
      ];
      ctx.fillStyle='#111827'; ctx.font='14px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';
      const baseY = h - pad + 24; for(let i=0;i<meta.length;i++){ ctx.fillText(meta[i], 12, baseY + i*18); }
      const a=document.createElement('a'); a.href=off.toDataURL('image/png'); a.download='free-fall.png'; document.body.appendChild(a); a.click(); document.body.removeChild(a);
    }catch(e){}
  });
  // share link
  btnShare.addEventListener('click', async ()=>{
    const url = new URL(window.location.href);
    url.searchParams.set('h', hEl.value||''); url.searchParams.set('uH', unitH.value);
    url.searchParams.set('g', gEl.value||'');
    url.searchParams.set('v0', v0El.value||''); url.searchParams.set('uV', unitV.value);
    url.searchParams.set('drag', dragOn.checked? '1':'0');
    if(dragOn.checked){ url.searchParams.set('rho', rhoEl.value||''); url.searchParams.set('cd', cdEl.value||''); url.searchParams.set('area', areaEl.value||''); url.searchParams.set('m', massEl.value||''); }
    const link = url.toString();
    try{ if(navigator.share){ await navigator.share({ title:'Free Fall Calculator', text:'Check this free fall setup', url: link }); return; } }catch(e){}
    try{ if(navigator.clipboard && navigator.clipboard.writeText){ await navigator.clipboard.writeText(link); } else { const ta=document.createElement('textarea'); ta.value=link; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta); } shareMsg.style.display='inline'; setTimeout(()=>shareMsg.style.display='none',1500); }catch(e){}
  });

  // apply params
  (function applyParams(){ try{
    const url = new URL(window.location.href);
    const hv = url.searchParams.get('h'); if(hv!==null) hEl.value=hv;
    const uH = url.searchParams.get('uH'); if(uH) unitH.value=uH;
    const gv = url.searchParams.get('g'); if(gv!==null) gEl.value=gv;
    const vv = url.searchParams.get('v0'); if(vv!==null) v0El.value=vv;
    const uVv = url.searchParams.get('uV'); if(uVv) unitV.value=uVv;
    const dragv = url.searchParams.get('drag'); if(dragv==='1'){ dragOn.checked=true; dragCfg.style.display='block'; }
    const rho = url.searchParams.get('rho'); if(rho!==null) rhoEl.value=rho;
    const cd = url.searchParams.get('cd'); if(cd!==null) cdEl.value=cd;
    const area = url.searchParams.get('area'); if(area!==null) areaEl.value=area;
    const m = url.searchParams.get('m'); if(m!==null) massEl.value=m;
  }catch(e){} })();

  // initial
  try{ const s = compute(); if(s){ series=s; drawTrack(series); plot(series); } }catch(e){}
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<!-- E-E-A-T: About & Learning Outcomes (Physics) -->
<section class="container my-4"><div class="row"><div class="col-lg-12"><div class="card"><div class="card-body">
  <h2 class="h6 mb-2">About This Tool & Methodology</h2>
  <p>Computes free‑fall distance, time, and velocity under uniform gravity (optionally with initial velocity). Uses SI units and the standard kinematics equations.</p>
  <h3 class="h6 mt-2">Learning Outcomes</h3>
  <ul class="mb-2"><li>Relate position, velocity, and acceleration due to gravity.</li><li>Explore initial velocity effects and time symmetry.</li><li>Practice unit consistency and typical g values.</li></ul>
  <div class="row mt-2"><div class="col-md-6"><h4 class="h6">Authorship</h4><ul><li><strong>Author:</strong> <a href="https://x.com/anish2good" target="_blank" rel="noopener">Anish Nath</a> — Follow on X</li><li><strong>Last updated:</strong> 2025-11-19</li></ul></div><div class="col-md-6"><h4 class="h6">Trust & Privacy</h4><ul><li>Runs locally in your browser.</li></ul></div></div>
</div></div></div></div></section>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"WebPage","name":"Free Fall Calculator","url":"https://8gwifi.org/free-fall-calculator.jsp","dateModified":"2025-11-19","author":{"@type":"Person","name":"Anish Nath","url":"https://x.com/anish2good"},"publisher":{"@type":"Organization","name":"8gwifi.org"}}</script>
<script type="application/ld+json">{"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},{"@type":"ListItem","position":2,"name":"Free Fall Calculator","item":"https://8gwifi.org/free-fall-calculator.jsp"}]}</script>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
