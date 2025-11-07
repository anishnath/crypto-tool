<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kinematics Equation Solver (SUVAT) – Displacement, Velocity, Acceleration, Time</title>
  <meta name="description" content="Free kinematics (SUVAT) calculator. Enter any three of displacement (s), initial velocity (u), final velocity (v), acceleration (a), time (t) to solve the rest. Step-by-step derivations with velocity–position graph. Runs in your browser.">
  <meta name="keywords" content="kinematics calculator, suvat calculator, motion calculator, displacement calculator, velocity calculator, acceleration calculator, time of motion, physics kinematics equations, AP Physics kinematics, suvat equation solver">
  <link rel="canonical" href="https://8gwifi.org/kinematics-calculator.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/mathjs@11.8.2/lib/browser/math.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Kinematics Equation Solver (SUVAT)","url":"https://8gwifi.org/kinematics-calculator.jsp","applicationCategory":"EducationalApplication","operatingSystem":"Web","description":"Solve kinematics problems by entering any 3 of s, u, v, a, t. Step-by-step with velocity–position graph.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},"keywords":["kinematics calculator","suvat calculator","motion calculator","AP Physics kinematics"]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I use the kinematics (SUVAT) solver?","acceptedAnswer":{"@type":"Answer","text":"Enter any three of s, u, v, a, t and click Solve. The tool infers the missing variables using the standard SUVAT equations and shows a step-by-step derivation."}},
    {"@type":"Question","name":"Which equations are used?","acceptedAnswer":{"@type":"Answer","text":"v = u + a t; s = u t + 1/2 a t^2; s = v t − 1/2 a t^2; v^2 = u^2 + 2 a s; s = (u+v)/2 · t. The solver picks equations that have a single unknown with your inputs."}},
    {"@type":"Question","name":"Can I graph motion?","acceptedAnswer":{"@type":"Answer","text":"Yes. The velocity–position graph shows how speed changes with displacement. You can also toggle v–t and s–t charts for time-based views."}}
  ]}
  </script>

  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Kinematics Equation Solver (SUVAT)">
  <meta property="og:description" content="Enter any three of s, u, v, a, t to solve the rest. Step-by-step with velocity–position graph.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/kinematics-calculator.jsp">

  <style>
    .suvat .card-header{padding:.6rem .9rem;font-weight:600}
    .suvat .card-body{padding:.7rem .9rem}
    .suvat .form-group{margin-bottom:.6rem}
    .kv{display:grid;grid-template-columns:1fr auto;gap:.35rem .75rem}
    .kv .label{color:#64748b}
    .kv .value{font-weight:600}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .tab-content>div{display:none}
    .tab-content>div.active{display:block}
    .steps{max-height:220px; overflow:auto; background:#f8fafc; border:1px solid #e5e7eb; border-radius:8px; padding:.5rem .75rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 suvat">
  <h1 class="mb-2">Kinematics Equation Solver (SUVAT)</h1>
  <p class="text-muted mb-3">Enter any three known values to compute the remaining kinematics variables. Includes step-by-step derivations and a velocity–position graph.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Inputs (SI units)</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="s">Displacement s</label>
            <div class="input-group">
              <input id="s" type="number" step="0.0001" class="form-control" placeholder="e.g. 10">
              <div class="input-group-append">
                <select id="unitS" class="form-control">
                  <option value="m" selected>m</option>
                  <option value="km">km</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="u">Initial velocity u</label>
            <div class="input-group">
              <input id="u" type="number" step="0.0001" class="form-control" placeholder="e.g. 5">
              <div class="input-group-append">
                <select id="unitU" class="form-control">
                  <option value="mps" selected>m/s</option>
                  <option value="kmph">km/h</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="v">Final velocity v</label>
            <div class="input-group">
              <input id="v" type="number" step="0.0001" class="form-control" placeholder="e.g. 9">
              <div class="input-group-append">
                <select id="unitV" class="form-control">
                  <option value="mps" selected>m/s</option>
                  <option value="kmph">km/h</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="a">Acceleration a</label>
            <div class="input-group">
              <input id="a" type="number" step="0.0001" class="form-control" placeholder="e.g. 2">
              <div class="input-group-append">
                <select id="unitA" class="form-control">
                  <option value="mps2" selected>m/s²</option>
                  <option value="g">g</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="t">Time t (s)</label>
            <input id="t" type="number" step="0.0001" class="form-control" placeholder="e.g. 3">
          </div>
          <div class="d-flex gap-2">
            <button id="btnSolve" class="btn btn-primary btn-sm mr-2">Solve</button>
            <button id="btnClear" class="btn btn-outline-secondary btn-sm">Clear</button>
          </div>
          <div id="err" class="text-danger mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Results</h5>
        <div class="card-body">
          <div class="kv">
            <div class="label">s</div><div class="value" id="out_s">–</div>
            <div class="label">u</div><div class="value" id="out_u">–</div>
            <div class="label">v</div><div class="value" id="out_v">–</div>
            <div class="label">a</div><div class="value" id="out_a">–</div>
            <div class="label">t</div><div class="value" id="out_t">–</div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Steps (Derivation)</h5>
        <div class="card-body">
          <div id="steps" class="steps mono small"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related</h5>
        <div class="card-body">
          <ul class="mb-0">
            <li><a href="projectile-motion-simulator.jsp">Projectile Motion Simulator</a></li>
            <li><a href="ohms-law-calculator.jsp">Ohm's Law & Circuit Calculator</a></li>
            <li><a href="graphing-calculator.jsp">Graphing Calculator</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Graphs
          <span class="d-inline-flex align-items-center">
            <button id="tabVS" class="btn btn-sm btn-outline-primary mr-2">v–s</button>
            <button id="tabVT" class="btn btn-sm btn-outline-secondary mr-2">v–t</button>
            <button id="tabST" class="btn btn-sm btn-outline-secondary">s–t</button>
            <button id="btnSavePng" class="btn btn-sm btn-outline-secondary ml-2" title="Save graph as PNG">Save PNG</button>
            <button id="btnShareLink" class="btn btn-sm btn-outline-primary ml-2" title="Share a link to this setup">Share</button>
            <small id="shareMsg" class="text-success ml-2" style="display:none">Link copied</small>
            <button id="btnAddMotion" class="btn btn-sm btn-outline-dark ml-3" title="Freeze current motion">Add Motion</button>
            <button id="btnClearMotions" class="btn btn-sm btn-outline-secondary ml-2" title="Clear saved motions">Clear</button>
            <div class="form-check ml-3" style="margin:0 .5rem;">
              <input class="form-check-input" type="checkbox" id="toggleMarkers" checked>
              <label class="form-check-label small" for="toggleMarkers">Markers</label>
            </div>
            <div class="form-check" style="margin:0 .5rem;">
              <input class="form-check-input" type="checkbox" id="toggleShade">
              <label class="form-check-label small" for="toggleShade">Shade (v–t)</label>
            </div>
            <div class="form-check" style="margin:0 .5rem;">
              <input class="form-check-input" type="checkbox" id="toggleAvg">
              <label class="form-check-label small" for="toggleAvg">Avg v (v–t)</label>
            </div>
            <div class="form-check" style="margin:0 .5rem;">
              <input class="form-check-input" type="checkbox" id="toggleCrosshair" checked>
              <label class="form-check-label small" for="toggleCrosshair">Crosshair</label>
            </div>
            <div class="form-check ml-3" style="margin:0 .5rem;">
              <input class="form-check-input" type="checkbox" id="toggleStacked">
              <label class="form-check-label small" for="toggleStacked">Stacked</label>
            </div>
            <button id="btnPlay" class="btn btn-sm btn-outline-success ml-3">Play</button>
            <select id="speedSel" class="form-control form-control-sm ml-2" style="width:auto">
              <option value="0.25">0.25×</option>
              <option value="0.5">0.5×</option>
              <option value="1" selected>1×</option>
              <option value="2">2×</option>
              <option value="4">4×</option>
            </select>
            <div class="ml-3 d-flex align-items-center">
              <small class="text-muted mr-2">t</small>
              <input id="scrub" type="range" min="0" max="100" step="1" value="0">
            </div>
            <div class="form-check ml-3" style="margin:0 .5rem;">
              <input class="form-check-input" type="checkbox" id="toggleTeach">
              <label class="form-check-label small" for="toggleTeach">Teaching</label>
            </div>
          </span>
        </h5>
        <div class="card-body">
          <canvas id="chart" height="260"></canvas>
          <div id="stacked" style="display:none" class="mt-2">
            <div class="mt-2">
              <strong>v–t</strong>
              <canvas id="chart_vt" height="180"></canvas>
            </div>
            <div class="mt-2">
              <strong>s–t</strong>
              <canvas id="chart_st" height="180"></canvas>
            </div>
            <div class="mt-2">
              <strong>a–t</strong>
              <canvas id="chart_at" height="180"></canvas>
            </div>
          </div>
          <small class="text-muted">v–s shows velocity vs displacement. Use v–t and s–t for time-based views.</small>
          <div id="teachBox" class="small text-muted mt-2" style="display:none"></div>
          <div class="mt-2" style="border:1px solid #e5e7eb;border-radius:6px;padding:.25rem .5rem;background:#fff;">
            <canvas id="track" height="40" style="width:100%"></canvas>
          </div>
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
                  <th>u</th>
                  <th>a</th>
                  <th>t<sub>end</sub></th>
                  <th>s<sub>end</sub></th>
                </tr>
              </thead>
              <tbody id="motionRows"></tbody>
            </table>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Notes</h5>
        <div class="card-body">
          <ul class="mb-0">
            <li>Equations: v = u + a t; s = u t + ½ a t²; s = v t − ½ a t²; v² = u² + 2 a s; s = (u+v)/2 · t.</li>
            <li>Provide any 3 variables to solve remaining unknowns. Time is assumed non-negative; the solver selects physically meaningful roots where applicable.</li>
            <li>All calculations run locally in your browser.</li>
          </ul>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">FAQ</h5>
    <div class="card-body">
      <p><strong>Which variables can be negative?</strong><br>Velocities and acceleration can be positive or negative depending on direction; time is taken as ≥ 0.</p>
      <p><strong>Why are there two possible solutions?</strong><br>Quadratic equations (e.g., s = u t + ½ a t²) can produce two times. The tool reports the non-negative solution; if both are valid you’ll see a note in steps.</p>
      <p class="mb-0"><strong>What about variable acceleration?</strong><br>These equations assume constant acceleration. For variable a(t), use calculus or numerical integration.</p>
    </div>
  </div>
</div>

<script>
(function(){
  const el = (id)=> document.getElementById(id);
  const S = el('s'), U = el('u'), V = el('v'), A = el('a'), T = el('t');
  const out = {s:el('out_s'), u:el('out_u'), v:el('out_v'), a:el('out_a'), t:el('out_t')};
  const stepsEl = el('steps');
  const errEl = el('err');
  const btnSolve = el('btnSolve'), btnClear = el('btnClear');
  const chartEl = el('chart');
  const tabVS = el('tabVS'), tabVT = el('tabVT'), tabST = el('tabST');
  const btnSave = el('btnSavePng');
  const btnShare = el('btnShareLink');
  const shareMsg = el('shareMsg');
  const unitS = el('unitS');
  const unitU = el('unitU');
  const unitV = el('unitV');
  const unitA = el('unitA');
  const toggleMarkers = el('toggleMarkers');
  const toggleShade = el('toggleShade');
  const toggleAvg = el('toggleAvg');
  const toggleCrosshair = el('toggleCrosshair');
  const toggleTeach = el('toggleTeach');
  const scrub = el('scrub');
  const teachBox = el('teachBox');
  const toggleStacked = el('toggleStacked');
  const btnAddMotion = el('btnAddMotion');
  const btnClearMotions = el('btnClearMotions');
  const motionRows = document.getElementById('motionRows');
  const chartVT = document.getElementById('chart_vt');
  const chartST = document.getElementById('chart_st');
  const chartAT = document.getElementById('chart_at');
  const stackedWrap = document.getElementById('stacked');
  let chart;
  let currentSeries = null;
  let currentIndex = 0;
  let chartVti = null, chartSti = null, chartAti = null;
  const colors = ['#0ea5e9','#22c55e','#f59e0b','#ef4444','#a78bfa','#14b8a6'];
  let motions = [];

  function toNum(x){ const n = parseFloat(x); return Number.isFinite(n) ? n : null; }
  function fmt(n, unit){ if(n === null) return '–'; const v = Math.round(n*1000)/1000; return unit? (v+' '+unit): (''+v); }
  function addStep(s){ const div = document.createElement('div'); div.textContent = s; stepsEl.appendChild(div); }
  function resetSteps(){ stepsEl.innerHTML=''; }

  // Unit helpers
  const G_CONST = 9.80665; // m/s^2
  const UF = { S:{m:1, km:1000}, Vel:{mps:1, kmph:(1000/3600)}, Acc:{mps2:1, g:G_CONST} };
  function toBaseS(val){ return Number.isFinite(val)? val * (UF.S[unitS.value]||1) : null; }
  function toBaseVel(val, which){ const unit = which==='u'? unitU.value : unitV.value; return Number.isFinite(val)? val * (UF.Vel[unit]||1) : null; }
  function toBaseAcc(val){ return Number.isFinite(val)? val * (UF.Acc[unitA.value]||1) : null; }
  function fromBaseS(val){ if(val===null) return null; return val / (UF.S[unitS.value]||1); }
  function fromBaseVel(val, which){ if(val===null) return null; const unit = which==='u'? unitU.value : unitV.value; return val / (UF.Vel[unit]||1); }
  function fromBaseAcc(val){ if(val===null) return null; return val / (UF.Acc[unitA.value]||1); }
  function fmtUnitS(val){ if(val===null) return '–'; const v = fromBaseS(val); const sfx = unitS.value; const fixed = Math.abs(v)<1 ? v.toFixed(3) : v.toFixed(2); return fixed+' '+sfx; }
  function fmtUnitVel(val, which){ if(val===null) return '–'; const v = fromBaseVel(val, which); const sfx = (which==='u'? unitU.value : unitV.value) === 'kmph'? 'km/h':'m/s'; const fixed = Math.abs(v)<1 ? v.toFixed(3) : v.toFixed(2); return fixed+' '+sfx; }
  function fmtUnitAcc(val){ if(val===null) return '–'; const v = fromBaseAcc(val); const sfx = unitA.value==='g'? 'g':'m/s²'; const fixed = Math.abs(v)<1 ? v.toFixed(3) : v.toFixed(2); return fixed+' '+sfx; }

  function readKnowns(){
    return {
      s: toBaseS(toNum(S.value)),
      u: toBaseVel(toNum(U.value),'u'),
      v: toBaseVel(toNum(V.value),'v'),
      a: toBaseAcc(toNum(A.value)),
      t: toNum(T.value)
    };
  }

  const eq = {
    e1: { lhs:'v', rhs:(x)=> x.u + x.a * x.t, vars:['v','u','a','t'], text:'v = u + a t' },
    e2: { lhs:'s', rhs:(x)=> x.u * x.t + 0.5 * x.a * x.t * x.t, vars:['s','u','a','t'], text:'s = u t + ½ a t²' },
    e3: { lhs:'s', rhs:(x)=> x.v * x.t - 0.5 * x.a * x.t * x.t, vars:['s','v','a','t'], text:'s = v t − ½ a t²' },
    e4: { lhs:'v2', rhs:(x)=> x.u*x.u + 2 * x.a * x.s, vars:['v','u','a','s'], text:'v² = u² + 2 a s' },
    e5: { lhs:'s', rhs:(x)=> (x.u + x.v)/2 * x.t, vars:['s','u','v','t'], text:'s = (u+v)/2 · t' }
  };

  function solveSUVAT(){
    resetSteps(); errEl.style.display='none'; errEl.textContent='';
    const x = readKnowns();
    const known = (k)=> x[k] !== null;
    const unknowns = ()=> ['s','u','v','a','t'].filter(k=> x[k] === null);

    // Iteratively look for equations with a single unknown
    let changed = true; let safety=0; let ambiguousNotes=[];
    while(changed && safety < 20){
      safety++; changed=false;
      // e1: v = u + a t
      if(!known('v') && known('u') && known('a') && known('t')){ x.v = x.u + x.a*x.t; addStep(`From v = u + a t → v = ${fmt(x.v,'m/s')}`); changed=true; continue; }
      if(!known('u') && known('v') && known('a') && known('t')){ x.u = x.v - x.a*x.t; addStep(`From v = u + a t → u = v − a t = ${fmt(x.u,'m/s')}`); changed=true; continue; }
      if(!known('a') && known('v') && known('u') && known('t')){ x.a = (x.v - x.u)/x.t; addStep(`From v = u + a t → a = (v − u)/t = ${fmt(x.a,'m/s²')}`); changed=true; continue; }
      if(!known('t') && known('v') && known('u') && known('a') && x.a !== 0){ x.t = (x.v - x.u)/x.a; addStep(`From v = u + a t → t = (v − u)/a = ${fmt(x.t,'s')}`); changed=true; continue; }

      // e4: v^2 = u^2 + 2 a s
      if(!known('v') && known('u') && known('a') && known('s')){ const v2 = x.u*x.u + 2*x.a*x.s; if(v2>=0){ x.v = Math.sign(x.u)>=0 ? Math.sqrt(v2) : -Math.sqrt(v2); } else { x.v=null; } addStep(`From v² = u² + 2 a s → v = ±√(u² + 2 a s) = ${fmt(x.v,'m/s')}`); changed=true; continue; }
      if(!known('u') && known('v') && known('a') && known('s')){ const u2 = x.v*x.v - 2*x.a*x.s; if(u2>=0){ x.u = Math.sign(x.v)>=0 ? Math.sqrt(u2) : -Math.sqrt(u2); } else { x.u=null; } addStep(`From v² = u² + 2 a s → u = ±√(v² − 2 a s) = ${fmt(x.u,'m/s')}`); changed=true; continue; }
      if(!known('a') && known('v') && known('u') && known('s') && x.s !== 0){ x.a = (x.v*x.v - x.u*x.u)/(2*x.s); addStep(`From v² = u² + 2 a s → a = (v² − u²)/(2 s) = ${fmt(x.a,'m/s²')}`); changed=true; continue; }
      if(!known('s') && known('v') && known('u') && known('a') && x.a !== 0){ x.s = (x.v*x.v - x.u*x.u)/(2*x.a); addStep(`From v² = u² + 2 a s → s = (v² − u²)/(2 a) = ${fmt(x.s,'m')}`); changed=true; continue; }

      // e5: s = (u+v)/2 t
      if(!known('s') && known('u') && known('v') && known('t')){ x.s = (x.u + x.v)/2 * x.t; addStep(`From s = (u+v)/2 · t → s = ${fmt(x.s,'m')}`); changed=true; continue; }
      if(!known('t') && known('u') && known('v') && known('s') && (x.u+x.v) !== 0){ x.t = 2*x.s/(x.u + x.v); addStep(`From s = (u+v)/2 · t → t = 2 s / (u+v) = ${fmt(x.t,'s')}`); changed=true; continue; }

      // e2: s = u t + 1/2 a t^2 (quadratic in t if t unknown)
      if(!known('s') && known('u') && known('a') && known('t')){ x.s = x.u*x.t + 0.5*x.a*x.t*x.t; addStep(`From s = u t + ½ a t² → s = ${fmt(x.s,'m')}`); changed=true; continue; }
      if(!known('u') && known('s') && known('a') && known('t')){ x.u = (x.s - 0.5*x.a*x.t*x.t)/x.t; addStep(`From s = u t + ½ a t² → u = (s − ½ a t²)/t = ${fmt(x.u,'m/s')}`); changed=true; continue; }
      if(!known('a') && known('s') && known('u') && known('t')){ x.a = 2*(x.s - x.u*x.t)/(x.t*x.t); addStep(`From s = u t + ½ a t² → a = 2(s − u t)/t² = ${fmt(x.a,'m/s²')}`); changed=true; continue; }
      if(!known('t') && known('s') && known('u') && known('a')){
        // 0.5 a t^2 + u t - s = 0
        const A2 = 0.5*x.a, B2 = x.u, C2 = -x.s;
        if(Math.abs(A2) < 1e-12){ // linear: u t - s = 0
          if(Math.abs(B2) > 1e-12){ x.t = x.s / x.u; addStep(`From s = u t → t = s/u = ${fmt(x.t,'s')}`); changed=true; continue; }
        } else {
          const D = B2*B2 - 4*A2*C2;
          if(D >= 0){
            const t1 = (-B2 + Math.sqrt(D))/(2*A2);
            const t2 = (-B2 - Math.sqrt(D))/(2*A2);
            const candidates = [t1,t2].filter(z=> z>=0);
            if(candidates.length){ x.t = Math.min(...candidates); addStep(`Quadratic from s = u t + ½ a t² → t = ${fmt(x.t,'s')} (non-negative root)`); changed=true; continue; }
            else { ambiguousNotes.push('No non-negative root for t in s = u t + ½ a t²'); }
          }
        }
      }

      // e3: s = v t − 1/2 a t^2
      if(!known('s') && known('v') && known('a') && known('t')){ x.s = x.v*x.t - 0.5*x.a*x.t*x.t; addStep(`From s = v t − ½ a t² → s = ${fmt(x.s,'m')}`); changed=true; continue; }
      if(!known('v') && known('s') && known('a') && known('t')){ x.v = (x.s + 0.5*x.a*x.t*x.t)/x.t; addStep(`From s = v t − ½ a t² → v = (s + ½ a t²)/t = ${fmt(x.v,'m/s')}`); changed=true; continue; }
      if(!known('a') && known('s') && known('v') && known('t')){ x.a = 2*(x.v*x.t - x.s)/(x.t*x.t); addStep(`From s = v t − ½ a t² → a = 2(v t − s)/t² = ${fmt(x.a,'m/s²')}`); changed=true; continue; }
      if(!known('t') && known('s') && known('v') && known('a')){
        // -0.5 a t^2 + v t - s = 0
        const A3 = -0.5*x.a, B3 = x.v, C3 = -x.s;
        if(Math.abs(A3) < 1e-12){ if(Math.abs(B3) > 1e-12){ x.t = x.s / x.v; addStep(`From s = v t → t = s/v = ${fmt(x.t,'s')}`); changed=true; continue; } }
        else {
          const D3 = B3*B3 - 4*A3*C3;
          if(D3 >= 0){
            const t1 = (-B3 + Math.sqrt(D3))/(2*A3);
            const t2 = (-B3 - Math.sqrt(D3))/(2*A3);
            const candidates = [t1,t2].filter(z=> z>=0);
            if(candidates.length){ x.t = Math.min(...candidates); addStep(`Quadratic from s = v t − ½ a t² → t = ${fmt(x.t,'s')} (non-negative root)`); changed=true; continue; }
            else { ambiguousNotes.push('No non-negative root for t in s = v t − ½ a t²'); }
          }
        }
      }

      break; // no more progress
    }

    // Validate sufficient inputs
    const knownCount = ['s','u','v','a','t'].filter(k=> x[k] !== null).length;
    if(knownCount < 3){ errEl.style.display='block'; errEl.textContent='Enter any three of s, u, v, a, t.'; return null; }

    if(ambiguousNotes.length){ addStep('Note: ' + ambiguousNotes.join(' | ')); }
    // Write outputs
    out.s.textContent = fmtUnitS(x.s);
    out.u.textContent = fmtUnitVel(x.u,'u');
    out.v.textContent = fmtUnitVel(x.v,'v');
    out.a.textContent = fmtUnitAcc(x.a);
    out.t.textContent = fmt(x.t,'s');

    return x;
  }

  function buildSeries(x){
    // Build arrays for plotting based on solved variables (prefer using time extent if available)
    const u = x.u ?? 0, a = x.a ?? 0; let tmax = x.t ?? null; let sFinal = x.s ?? null;
    if(tmax === null){
      if(a !== 0 && sFinal !== null){
        // estimate tmax from s = u t + 0.5 a t^2 (non-negative)
        const A2 = 0.5*a, B2=u, C2=-sFinal; const D=B2*B2-4*A2*C2; if(D>=0){ const t1=(-B2+Math.sqrt(D))/(2*A2); const t2=(-B2-Math.sqrt(D))/(2*A2); const cand=[t1,t2].filter(z=>z>=0); if(cand.length) tmax=Math.min(...cand); }
      }
      if(tmax === null){ tmax =  (Math.abs(u) > 0 || Math.abs(a) > 0) ? 5 : 1; }
    }

    const N=200; const ts=[], ss=[], vs=[];
    for(let i=0;i<=N;i++){
      const t = tmax * i/N;
      const sB = (x.s!==null && x.t!==null) ? (x.s * (t/(x.t||1))) : (u*t + 0.5*a*t*t);
      const vB = u + a*t;
      ts.push(t); ss.push(fromBaseS(sB)); vs.push(fromBaseVel(vB,'v'));
    }
    return {ts, ss, vs, sEndBase: (x.s!==null? x.s : (u*tmax + 0.5*a*tmax*tmax)), tEnd: tmax, uBase:u, aBase:a};
  }

  function plot(type, series){
    if(chart) chart.destroy();
    if(chartVti){ chartVti.destroy(); chartVti=null; }
    if(chartSti){ chartSti.destroy(); chartSti=null; }
    if(chartAti){ chartAti.destroy(); chartAti=null; }
    if(toggleStacked && toggleStacked.checked){ chartEl.style.display='none'; if(stackedWrap) stackedWrap.style.display=''; } else { chartEl.style.display=''; if(stackedWrap) stackedWrap.style.display='none'; }
    let labels, data, xlab, ylab;
    const sUnit = unitS.value;
    const vUnit = (unitV.value==='kmph')? 'km/h' : 'm/s';
    if(type==='vs'){ labels = series.ss; data = series.vs; xlab=`s (${sUnit})`; ylab=`v (${vUnit})`; }
    else if(type==='vt'){ labels = series.ts; data = series.vs; xlab='t (s)'; ylab=`v (${vUnit})`; }
    else { labels = series.ts; data = series.ss; xlab='t (s)'; ylab=`s (${sUnit})`; }

    // Datasets
    const datasets = [];
    const seriesList = [ {series, color: colors[0]} ].concat(motions.map((m,i)=>({series:m.series, color: colors[(i+1)%colors.length]})));
    function dsFor(s, color, ydata){ return { label: '', data: ydata, borderColor: color, pointRadius:0, tension:.12, fill:false, backgroundColor:'transparent' }; }
    if(!toggleStacked || !toggleStacked.checked){
      const ydata = (type==='vs')? series.vs : (type==='vt')? series.vs : (type==='at')? series.aa : series.ss;
      datasets.push(dsFor(series, colors[0], ydata));
      for(let i=0;i<motions.length;i++){
        const ms = motions[i].series; const color = colors[(i+1)%colors.length];
        const yd = (type==='vs')? ms.vs : (type==='vt')? ms.vs : (type==='at')? ms.aa : ms.ss;
        datasets.push(dsFor(ms, color, yd));
      }
    }
    if(toggleShade.checked && type==='vt'){
      const idxC = Math.max(0, Math.min(data.length-1, Math.round(currentIndex)));
      const area = new Array(data.length).fill(null); for(let i=0;i<=idxC;i++){ area[i]=data[i]; }
      datasets.push({ label:'Area', data: area, borderColor:'rgba(14,165,233,0.0)', backgroundColor:'rgba(14,165,233,0.12)', pointRadius:0, fill:'origin' });
    }
    if(toggleMarkers.checked){
      // start and end markers
      const startVal = data[0]; const endVal = data[data.length-1];
      const markerData = new Array(data.length).fill(null); markerData[0] = startVal; markerData[data.length-1] = endVal;
      datasets.push({ label:'Markers', data: markerData, showLine:false, pointRadius:4, pointBackgroundColor:'#ef4444' });
    }
    // v=0 markers
    if(type==='vt'){
      const uB = series.uBase||0, aB = series.aBase||0;
      if(Math.abs(aB)>1e-12){
        const t0 = -uB/aB; if(t0>=0 && t0<=series.tEnd){ let idx=0; for(let i=1;i<series.ts.length;i++){ if(Math.abs(series.ts[i]-t0) < Math.abs(series.ts[idx]-t0)) idx=i; }
          const arr = new Array(data.length).fill(null); arr[idx]=data[idx]; datasets.push({ label:'v=0', data:arr, showLine:false, pointRadius:4, pointBackgroundColor:'#f59e0b' });
        }
      }
    }
    if(type==='vs'){
      const uB = series.uBase||0, aB = series.aBase||0;
      if(Math.abs(aB)>1e-12){ const t0=-uB/aB; if(t0>=0 && t0<=series.tEnd){ const s0B=uB*t0+0.5*aB*t0*t0; const s0=fromBaseS(s0B); let idx=0; for(let i=1;i<labels.length;i++){ if(Math.abs(labels[i]-s0) < Math.abs(labels[idx]-s0)) idx=i; } const arr=new Array(data.length).fill(null); arr[idx]=data[idx]; datasets.push({ label:'v=0 @ s*', data:arr, showLine:false, pointRadius:4, pointBackgroundColor:'#f59e0b' }); } }
    }
    // Cursor at scrub index
    const cursorArr = new Array(data.length).fill(null);
    const idxC = Math.max(0, Math.min(data.length-1, Math.round(currentIndex)));
    cursorArr[idxC] = data[idxC];
    datasets.push({ label:'Cursor', data: cursorArr, showLine:false, pointRadius:5, pointBackgroundColor:'#10b981' });
    if(toggleAvg.checked && type==='vt'){
      const vAvgBase = (series.tEnd>0) ? (series.sEndBase / series.tEnd) : NaN;
      const vAvgDisp = fromBaseVel(vAvgBase,'v');
      const avgData = series.ts.map(()=> vAvgDisp);
      datasets.push({ label:'Avg v', data: avgData, borderColor:'#10b981', borderDash:[6,6], pointRadius:0, tension:0 });
    }

    // Crosshair & zero lines plugin
    const crosshairPlugin = {
      id: 'crosshair',
      afterDatasetsDraw(chart, args, pluginOptions) {
        const {ctx, chartArea:{top,bottom,left,right}, scales} = chart;
        const xScale = scales.x, yScale = scales.y;
        // zero lines
        ctx.save(); ctx.strokeStyle = '#cbd5e1'; ctx.setLineDash([4,4]);
        if(yScale.min < 0 && yScale.max > 0){ const y0 = yScale.getPixelForValue(0); ctx.beginPath(); ctx.moveTo(left, y0); ctx.lineTo(right, y0); ctx.stroke(); }
        if(type!=='vt'){ // vs or st: draw x=0 if visible
          if(xScale.min < 0 && xScale.max > 0){ const x0 = xScale.getPixelForValue(0); ctx.beginPath(); ctx.moveTo(x0, top); ctx.lineTo(x0, bottom); ctx.stroke(); }
        } else {
          // vt starts at t>=0; draw t=0 line
          const x0 = xScale.getPixelForValue(0); ctx.beginPath(); ctx.moveTo(x0, top); ctx.lineTo(x0, bottom); ctx.stroke();
        }
        ctx.restore();
        // tangent and crosshair
        const idxC = Math.max(0, Math.min(chart.data.datasets[0].data.length-1, Math.round(currentIndex)));
        const xVal = labels[idxC]; const yVal = chart.data.datasets[0].data[idxC];
        if(xVal!==undefined && yVal!==undefined){
          // tangent line
          ctx.save(); ctx.strokeStyle='#f97316'; ctx.setLineDash([5,3]); ctx.lineWidth=1.2;
          const xPx = xScale.getPixelForValue(xVal); const yPx = yScale.getPixelForValue(yVal);
          if(type==='vt'){
            const slope = series.aBase||0; const dxUnits = (xScale.max - xScale.min) * 0.08; const dyUnits = slope * dxUnits;
            ctx.beginPath(); ctx.moveTo(xPx, yPx); ctx.lineTo(xScale.getPixelForValue(xVal+dxUnits), yScale.getPixelForValue(yVal+dyUnits)); ctx.stroke();
          } else if(type==='st'){
            const vDisp = series.vs[idxC]; const dxUnits = (xScale.max - xScale.min) * 0.08; const dyUnits = vDisp * dxUnits;
            ctx.beginPath(); ctx.moveTo(xPx, yPx); ctx.lineTo(xScale.getPixelForValue(xVal+dxUnits), yScale.getPixelForValue(yVal+dyUnits)); ctx.stroke();
          }
          ctx.restore();
        }
        if(!toggleCrosshair.checked) return;
        const tooltip = chart.tooltip;
        if(tooltip && tooltip.getActiveElements && tooltip.getActiveElements().length){
          const x = tooltip.getActiveElements()[0].element.x;
          ctx.save(); ctx.strokeStyle = '#94a3b8'; ctx.setLineDash([3,3]);
          ctx.beginPath(); ctx.moveTo(x, top); ctx.lineTo(x, bottom); ctx.stroke();
          ctx.restore();
        }
      }
    };

    // Tooltip formatting
    const tooltip = {
      callbacks: {
        label: (ctx) => {
          const xv = ctx.label; const yv = ctx.parsed.y;
          return `${ylab}: ${yv.toFixed(3)}, ${xlab}: ${xv.toString()}`;
        }
      }
    };

    if(!toggleStacked || !toggleStacked.checked){
      chart = new Chart(chartEl, { type:'line', data:{ labels, datasets }, options:{ responsive:true, scales:{ x:{ title:{display:true,text:xlab} }, y:{ title:{display:true,text:ylab} } }, plugins:{legend:{display:false}, tooltip } }, plugins: [crosshairPlugin] });
    } else {
      const labelsT = series.ts; const sUnitLoc = unitS.value; const vUnitLoc = (unitV.value==='kmph')? 'km/h' : 'm/s';
      const dsVT = seriesList.map(obj=> ({ label:'', data: obj.series.vs, borderColor: obj.color, pointRadius:0, tension:.12 }));
      const dsST = seriesList.map(obj=> ({ label:'', data: obj.series.ss, borderColor: obj.color, pointRadius:0, tension:.12 }));
      const dsAT = seriesList.map(obj=> ({ label:'', data: obj.series.aa, borderColor: obj.color, pointRadius:0, tension:.12 }));
      chartVti = new Chart(chartVT, { type:'line', data:{ labels: labelsT, datasets: dsVT }, options:{ responsive:true, scales:{ x:{ title:{display:true,text:'t (s)'} }, y:{ title:{display:true,text:`v (${vUnitLoc})`} } }, plugins:{legend:{display:false}} } });
      chartSti = new Chart(chartST, { type:'line', data:{ labels: labelsT, datasets: dsST }, options:{ responsive:true, scales:{ x:{ title:{display:true,text:'t (s)'} }, y:{ title:{display:true,text:`s (${sUnitLoc})`} } }, plugins:{legend:{display:false}} } });
      chartAti = new Chart(chartAT, { type:'line', data:{ labels: labelsT, datasets: dsAT }, options:{ responsive:true, scales:{ x:{ title:{display:true,text:'t (s)'} }, y:{ title:{display:true,text:'a (m/s²)'} } }, plugins:{legend:{display:false}} } });
    }

    // Teaching overlay
    if(toggleTeach && toggleTeach.checked){
      let msg='';
      if(type==='vt') msg='Equation: v = u + a t. Area under v–t equals displacement s. Slope = a (constant).';
      else if(type==='st') msg='Equation: s = u t + ½ a t². Slope ds/dt = v = u + a t.';
      else msg='Equation: v² = u² + 2 a s. When a < 0, turning point at v=0 marks peak displacement.';
      if(teachBox){ teachBox.textContent = msg; teachBox.style.display=''; }
    } else { if(teachBox) teachBox.style.display='none'; }
  }

  btnSolve.addEventListener('click', ()=>{
    const res = solveSUVAT(); if(!res) return; const series = buildSeries(res); currentSeries=series; scrub.value=0; currentIndex=0; plot(currentTab, series);
  });
  btnClear.addEventListener('click', ()=>{ [S,U,V,A,T].forEach(e=> e.value=''); Object.values(out).forEach(n=> n.textContent='–'); resetSteps(); if(chart) chart.destroy(); errEl.style.display='none'; if(teachBox){ teachBox.style.display='none'; } scrub.value=0; currentIndex=0; });
  ;[unitS, unitU, unitV, unitA].forEach(sel=> sel.addEventListener('change', ()=>{ const res=solveSUVAT(); if(!res) return; const series=buildSeries(res); plot(currentTab, series); }));
  if(document.getElementById('toggleStacked')) document.getElementById('toggleStacked').addEventListener('change', ()=>{ if(currentSeries) plot(currentTab, currentSeries); });

  function rebuildTable(){
    const motionRows = document.getElementById('motionRows'); if(!motionRows) return;
    motionRows.innerHTML = motions.map((m,i)=>{
      const color = m.color || colors[(i+1)%colors.length];
      const uTxt = fmtUnitVel(m.series.uBase,'u');
      const aTxt = fmtUnitAcc(m.series.aBase);
      const tTxt = fmt(m.series.tEnd,'s');
      const sTxt = fmtUnitS(m.series.sEndBase);
      return `<tr>
        <td><input type="color" value="${color}" data-i="${i}" class="motion-color"></td>
        <td>${uTxt}</td>
        <td>${aTxt}</td>
        <td>${tTxt}</td>
        <td>${sTxt}</td>
        <td><button class="btn btn-sm btn-outline-danger motion-remove" data-i="${i}">Remove</button></td>
      </tr>`;
    }).join('');
  }
  if(document.getElementById('btnAddMotion')) document.getElementById('btnAddMotion').addEventListener('click', ()=>{ const res = solveSUVAT(); if(!res) return; const ser = buildSeries(res); const color = colors[(motions.length+1)%colors.length]; motions.push({ series: ser, color }); rebuildTable(); if(currentSeries) plot(currentTab, currentSeries); });
  if(document.getElementById('btnClearMotions')) document.getElementById('btnClearMotions').addEventListener('click', ()=>{ motions=[]; rebuildTable(); if(currentSeries) plot(currentTab, currentSeries); });
  const motionRowsEl = document.getElementById('motionRows');
  if(motionRowsEl){
    motionRowsEl.addEventListener('input', (e)=>{
      if(e.target && e.target.classList.contains('motion-color')){
        const idx = parseInt(e.target.getAttribute('data-i'),10); if(!isNaN(idx) && motions[idx]){ motions[idx].color = e.target.value; if(currentSeries) plot(currentTab, currentSeries); }
      }
    });
    motionRowsEl.addEventListener('click', (e)=>{
      if(e.target && e.target.classList.contains('motion-remove')){
        const idx = parseInt(e.target.getAttribute('data-i'),10); if(!isNaN(idx)){ motions.splice(idx,1); rebuildTable(); if(currentSeries) plot(currentTab, currentSeries); }
      }
    });
  }
if(toggleTeach) toggleTeach.addEventListener('change', ()=>{ if(currentSeries) plot(currentTab, currentSeries); });
  if(toggleMarkers) toggleMarkers.addEventListener('change', ()=>{ if(currentSeries) plot(currentTab, currentSeries); });
  if(toggleShade) toggleShade.addEventListener('change', ()=>{ if(currentSeries) plot(currentTab, currentSeries); });
  if(toggleAvg) toggleAvg.addEventListener('change', ()=>{ if(currentSeries) plot(currentTab, currentSeries); });
  if(toggleCrosshair) toggleCrosshair.addEventListener('change', ()=>{ if(currentSeries) plot(currentTab, currentSeries); });
  if(scrub) scrub.addEventListener('input', ()=>{ if(!currentSeries) return; const n=(currentSeries.ts||currentSeries.ss).length||1; currentIndex=(parseInt(scrub.value,10)||0)/100*(n-1); plot(currentTab, currentSeries); });

  let currentTab = 'vs';
  function setTabs(sel){
    currentTab = sel; tabVS.classList.toggle('btn-outline-primary', sel!=='vs'); tabVS.classList.toggle('btn-primary', sel==='vs');
    tabVT.classList.toggle('btn-outline-primary', sel!=='vt'); tabVT.classList.toggle('btn-primary', sel==='vt');
    tabST.classList.toggle('btn-outline-primary', sel!=='st'); tabST.classList.toggle('btn-primary', sel==='st');
    const res = solveSUVAT(); if(!res) return; const series = buildSeries(res); currentSeries=series; plot(currentTab, series);
  }
  tabVS.addEventListener('click', ()=> setTabs('vs'));
  tabVT.addEventListener('click', ()=> setTabs('vt'));
  tabST.addEventListener('click', ()=> setTabs('st'));
  tabAT.addEventListener('click', ()=> setTabs('at'));

  // Save PNG with stats
  function savePng(){
    try{
      const off = document.createElement('canvas');
      const pad = 64;
      if(document.getElementById('toggleStacked') && document.getElementById('toggleStacked').checked){
        const c1 = document.getElementById('chart_vt');
        const c2 = document.getElementById('chart_st');
        const c3 = document.getElementById('chart_at');
        const w = Math.max(c1.width, c2.width, c3.width);
        const h = c1.height + c2.height + c3.height + pad + 16;
        off.width = w; off.height = h;
        var octx = off.getContext('2d');
        octx.fillStyle = '#ffffff'; octx.fillRect(0,0,off.width,off.height);
        let y=0; octx.drawImage(c1, 0, y); y+=c1.height+8; octx.drawImage(c2, 0, y); y+=c2.height+8; octx.drawImage(c3, 0, y);
      } else {
        off.width = chartEl.width; off.height = chartEl.height + pad;
        var octx = off.getContext('2d');
        octx.fillStyle = '#ffffff'; octx.fillRect(0,0,off.width,off.height);
        octx.drawImage(chartEl, 0, 0);
      }
      const xs = readKnowns();
      const meta = [
        'Kinematics (SUVAT)',
        's: '+fmtUnitS(xs.s)+'  u: '+fmtUnitVel(xs.u,'u')+'  v: '+fmtUnitVel(xs.v,'v')+'  a: '+fmtUnitAcc(xs.a)+'  t: '+fmt(xs.t,'s'),
        'https://8gwifi.org/kinematics-calculator.jsp'
      ];
      octx.fillStyle='#111827'; octx.font='14px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';
      const baseY = off.height - pad + 24;
      for(let k=0;k<meta.length;k++){ octx.fillText(meta[k], 12, baseY + k*18); }
      const a=document.createElement('a'); a.href=off.toDataURL('image/png'); a.download='kinematics-graph.png'; document.body.appendChild(a); a.click(); document.body.removeChild(a);
    }catch(e){}
  }
  btnSave.addEventListener('click', savePng);

  // Share link with params
  function buildShareUrl(){
    const url = new URL(window.location.href);
    const xs = readKnowns();
    if(S.value) url.searchParams.set('S', S.value); url.searchParams.set('uS', unitS.value);
    if(U.value) url.searchParams.set('U', U.value); url.searchParams.set('uU', unitU.value);
    if(V.value) url.searchParams.set('V', V.value); url.searchParams.set('uV', unitV.value);
    if(A.value) url.searchParams.set('A', A.value);
    if(T.value) url.searchParams.set('T', T.value);
    url.searchParams.set('tab', currentTab);
    return url.toString();
  }
  async function shareLink(){
    const link = buildShareUrl();
    try{ if(navigator.share){ await navigator.share({ title:'Kinematics (SUVAT)', text:'Check this setup', url: link }); return; } }catch(e){}
    try{ if(navigator.clipboard&&navigator.clipboard.writeText){ await navigator.clipboard.writeText(link); } else { const ta=document.createElement('textarea'); ta.value=link; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta); } shareMsg.style.display='inline'; setTimeout(()=>shareMsg.style.display='none',1500); }catch(e){}
  }
  btnShare.addEventListener('click', shareLink);

  // Apply params on load
  (function applyParams(){
    try{
      const url = new URL(window.location.href);
      const Sv = url.searchParams.get('S'); if(Sv!==null){ S.value=Sv; }
      const uSv = url.searchParams.get('uS'); if(uSv){ unitS.value=uSv; }
      const Uv = url.searchParams.get('U'); if(Uv!==null){ U.value=Uv; }
      const uUv = url.searchParams.get('uU'); if(uUv){ unitU.value=uUv; }
      const Vv = url.searchParams.get('V'); if(Vv!==null){ V.value=Vv; }
      const uVv = url.searchParams.get('uV'); if(uVv){ unitV.value=uVv; }
      const Av = url.searchParams.get('A'); if(Av!==null){ A.value=Av; }
      const Tv = url.searchParams.get('T'); if(Tv!==null){ T.value=Tv; }
      const tab = url.searchParams.get('tab'); if(tab){ currentTab=tab; }
    }catch(e){}
  })();

  // Animation
  let anim = { running:false, last:0 };
  function stepAnim(ts){
    if(!anim.running) return;
    if(!anim.last) anim.last = ts;
    const dt = (ts - anim.last)/1000; anim.last = ts;
    if(!currentSeries) { requestAnimationFrame(stepAnim); return; }
    const n = (currentSeries.ts||currentSeries.ss).length||1;
    const tEnd = currentSeries.tEnd || 1;
    const speed = parseFloat((document.getElementById('speedSel')||{value:'1'}).value)||1;
    const idxPerSec = (n-1)/tEnd;
    currentIndex += idxPerSec * dt * speed;
    if(currentIndex >= n-1){ currentIndex = n-1; anim.running=false; const btn=document.getElementById('btnPlay'); if(btn) btn.textContent='Replay'; }
    const scrubEl=document.getElementById('scrub'); if(scrubEl) scrubEl.value = Math.round((currentIndex/(n-1))*100);
    plot(currentTab, currentSeries);
    if(anim.running) requestAnimationFrame(stepAnim);
  }
  const btnPlayEl=document.getElementById('btnPlay'); if(btnPlayEl) btnPlayEl.addEventListener('click', ()=>{
    if(!currentSeries){ const res=solveSUVAT(); if(!res) return; currentSeries=buildSeries(res); }
    if(currentIndex >= (currentSeries.ts.length-1)) { currentIndex=0; const scrubEl=document.getElementById('scrub'); if(scrubEl) scrubEl.value=0; }
    anim.running = !anim.running; btnPlayEl.textContent = anim.running? 'Pause':'Play'; if(anim.running){ anim.last=0; requestAnimationFrame(stepAnim); }
  });
  const scrubEl=document.getElementById('scrub'); if(scrubEl) scrubEl.addEventListener('input', ()=>{ if(!currentSeries) return; const n=(currentSeries.ts||currentSeries.ss).length||1; currentIndex=(parseInt(scrubEl.value,10)||0)/100*(n-1); plot(currentTab, currentSeries); });

  // initial
  try{ const res = solveSUVAT(); if(res){ const series = buildSeries(res); currentSeries=series; plot(currentTab, series); } }catch(e){}
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
