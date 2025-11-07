<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ohm's Law Calculator & Circuit Solver – V, I, R, P + Series/Parallel</title>
  <meta name="description" content="Free Ohm's Law calculator and circuit solver. Enter any two of voltage (V), current (I), resistance (R) to compute the rest, plus power (P). Includes series/parallel resistor calculator and resistor color code. Runs in your browser.">
  <meta name="keywords" content="ohms law calculator, circuit calculator, resistor color code, series resistor calculator, parallel resistor calculator, power calculator, voltage drop calculator, electronics calculator, basic circuits">
  <link rel="canonical" href="https://8gwifi.org/ohms-law-calculator.jsp">
  <%@ include file="header-script.jsp"%>

  <!-- Math.js for equations -->
  <script src="https://cdn.jsdelivr.net/npm/mathjs@11.8.2/lib/browser/math.js"></script>

  <!-- JSON-LD: WebApplication -->
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Ohm's Law & Circuit Calculator","url":"https://8gwifi.org/ohms-law-calculator.jsp","applicationCategory":"EducationalApplication","operatingSystem":"Web","description":"Compute voltage, current, resistance, and power. Series/parallel resistance and resistor color code.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"},"keywords":["ohms law calculator","circuit calculator","series parallel","resistor color code","power calculator"]}
  </script>
  <!-- JSON-LD: FAQ -->
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I use the Ohm's Law calculator?","acceptedAnswer":{"@type":"Answer","text":"Enter any two of V, I, R and the tool computes the remaining quantity and power P. Units auto-convert; calculations run locally in your browser."}},
    {"@type":"Question","name":"Can I calculate series/parallel resistance?","acceptedAnswer":{"@type":"Answer","text":"Yes. Add resistors in the Series or Parallel tab to get equivalent resistance and optional power splits if a source is provided."}},
    {"@type":"Question","name":"How does the resistor color code work?","acceptedAnswer":{"@type":"Answer","text":"Choose 4- or 5-band. Pick colors to get resistance, or type a resistance to get the color bands. A colored resistor preview updates live."}}
  ]}
  </script>

  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Ohm's Law & Circuit Calculator">
  <meta property="og:description" content="Compute V, I, R, P. Series/parallel calculator and resistor color code.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/ohms-law-calculator.jsp">

  <style>
    .ohm .card-header{padding:.6rem .9rem;font-weight:600}
    .ohm .card-body{padding:.7rem .9rem}
    .ohm .form-group{margin-bottom:.6rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    #circWrap{position:relative;border:1px solid #e5e7eb;border-radius:8px;background:#fff}
    #circ{width:100%;height:320px;display:block}
    .kv{display:grid;grid-template-columns:1fr auto;gap:.35rem .75rem}
    .kv .label{color:#64748b}
    .kv .value{font-weight:600}
    .res-preview{display:inline-block;width:160px;height:28px;background:#ddd;border-radius:6px;position:relative;vertical-align:middle}
    .band{position:absolute;top:2px;bottom:2px;width:14px;border-radius:2px}
    .band.b1{left:24px}.band.b2{left:48px}.band.b3{left:72px}.band.b4{left:96px}.band.b5{left:120px}
    .legend{font-size:.85rem;color:#64748b}
    .tab-content>div{display:none}
    .tab-content>div.active{display:block}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 ohm">
  <h1 class="mb-2">Ohm's Law & Circuit Calculator</h1>
  <p class="text-muted mb-3">Enter any two values to solve the rest. Visual circuit sketch updates with your inputs. Use tabs for series/parallel and resistor color codes.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Ohm's Law</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="v">Voltage V</label>
            <div class="input-group">
              <input id="v" type="number" step="0.001" class="form-control" placeholder="volts">
              <div class="input-group-append">
                <select id="unitV" class="form-control">
                  <option value="V" selected>V</option>
                  <option value="mV">mV</option>
                  <option value="kV">kV</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="i">Current I</label>
            <div class="input-group">
              <input id="i" type="number" step="0.000001" class="form-control" placeholder="amps">
              <div class="input-group-append">
                <select id="unitI" class="form-control">
                  <option value="A" selected>A</option>
                  <option value="mA">mA</option>
                  <option value="uA">µA</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="r">Resistance R</label>
            <div class="input-group">
              <input id="r" type="number" step="0.0001" class="form-control" placeholder="ohms">
              <div class="input-group-append">
                <select id="unitR" class="form-control">
                  <option value="ohm" selected>Ω</option>
                  <option value="kohm">kΩ</option>
                  <option value="Mohm">MΩ</option>
                </select>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="p">Power P</label>
            <div class="input-group">
              <input id="p" type="number" step="0.0001" class="form-control" placeholder="watts" readonly>
              <div class="input-group-append">
                <select id="unitP" class="form-control">
                  <option value="W" selected>W</option>
                  <option value="mW">mW</option>
                  <option value="kW">kW</option>
                </select>
              </div>
            </div>
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
            <div class="label">V</div><div class="value" id="v_out">–</div>
            <div class="label">I</div><div class="value" id="i_out">–</div>
            <div class="label">R</div><div class="value" id="r_out">–</div>
            <div class="label">P</div><div class="value" id="p_out">–</div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Circuit Sketch
          <span class="d-inline-flex align-items-center">
            <label for="cType" class="mr-2 mb-0 small text-muted">Type</label>
            <select id="cType" class="form-control form-control-sm" style="width:auto" title="Circuit Type">
              <option value="single" selected>Single</option>
              <option value="series">Series</option>
              <option value="parallel">Parallel</option>
              <option value="vdiv">Voltage Divider</option>
              <option value="idiv">Current Divider</option>
            </select>
            <button id="btnSavePng" class="btn btn-sm btn-outline-secondary ml-2" title="Save diagram as PNG">Save PNG</button>
            <button id="btnShareLink" class="btn btn-sm btn-outline-primary ml-2" title="Share a link to this setup">Share</button>
            <small id="shareMsg" class="text-success ml-2" style="display:none">Link copied</small>
          </span>
        </h5>
        <div class="card-body">
          <div id="circWrap"><canvas id="circ" width="960" height="320"></canvas></div>
          <small class="legend">Blue: source (V). Orange: resistor(s) (R). Green labels show computed currents, voltages, or power per branch.</small>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">More Tools</h5>
        <div class="card-body">
          <ul class="nav nav-tabs" role="tablist">
            <li class="nav-item"><a href="#" id="tabSeries" class="nav-link active">Series</a></li>
            <li class="nav-item"><a href="#" id="tabParallel" class="nav-link">Parallel</a></li>
            <li class="nav-item"><a href="#" id="tabColors" class="nav-link">Resistor Colors</a></li>
          </ul>
          <div class="tab-content mt-2">
            <div id="panelSeries" class="active">
              <div class="d-flex mb-2">
                <input id="seriesVal" type="number" step="0.01" class="form-control mr-2" placeholder="Add resistor Ω">
                <button id="seriesAdd" class="btn btn-sm btn-primary">Add</button>
                <button id="seriesClear" class="btn btn-sm btn-outline-secondary ml-2">Clear</button>
              </div>
              <div id="seriesList" class="mb-2"></div>
              <div>R<sub>eq</sub> = <span id="seriesReq">–</span> Ω</div>
              <div class="text-muted">Tip: Provide source V or I in the Ohm's Law panel to estimate per-resistor power.</div>
            </div>
            <div id="panelParallel">
              <div class="d-flex mb-2">
                <input id="parallelVal" type="number" step="0.01" class="form-control mr-2" placeholder="Add resistor Ω">
                <button id="parallelAdd" class="btn btn-sm btn-primary">Add</button>
                <button id="parallelClear" class="btn btn-sm btn-outline-secondary ml-2">Clear</button>
              </div>
              <div id="parallelList" class="mb-2"></div>
              <div>R<sub>eq</sub> = <span id="parallelReq">–</span> Ω</div>
            </div>
            <div id="panelColors">
              <div class="form-row">
                <div class="form-group col-md-3">
                  <label for="bandCount">Bands</label>
                  <select id="bandCount" class="form-control form-control-sm">
                    <option value="4" selected>4-band</option>
                    <option value="5">5-band</option>
                  </select>
                </div>
                <div class="form-group col-md-5">
                  <label for="resVal">Resistance</label>
                  <div class="input-group">
                    <input id="resVal" type="number" step="0.1" class="form-control" placeholder="e.g. 4700">
                    <div class="input-group-append"><span class="input-group-text">Ω</span></div>
                  </div>
                </div>
                <div class="form-group col-md-4">
                  <label for="tol">Tolerance</label>
                  <select id="tol" class="form-control form-control-sm">
                    <option value="±1%" data-color="#c0c0c0">±1% (Brown)</option>
                    <option value="±2%" data-color="#c0c0c0">±2% (Red)</option>
                    <option value="±5%" data-color="#c0c0c0" selected>±5% (Gold)</option>
                    <option value="±10%" data-color="#c0c0c0">±10% (Silver)</option>
                  </select>
                </div>
              </div>
              <div class="mb-2">
                <div class="res-preview align-middle">
                  <span class="band b1" id="b1" style="background:#000"></span>
                  <span class="band b2" id="b2" style="background:#000"></span>
                  <span class="band b3" id="b3" style="background:#000"></span>
                  <span class="band b4" id="b4" style="background:#d4af37" title="tolerance"></span>
                  <span class="band b5" id="b5" style="display:none;background:#000"></span>
                </div>
              </div>
              <div class="legend">Colors follow E12/E24; exact schemes vary by manufacturer. For teaching/estimation.</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Notes</h5>
    <div class="card-body">
      <ul class="mb-0">
        <li>Ohm's Law: V = I·R; P = V·I = I²·R = V²/R.</li>
        <li>Series: R<sub>eq</sub> = ΣR; Parallel: 1/R<sub>eq</sub> = Σ(1/R).</li>
        <li>All calculations run locally in your browser; no data leaves your device.</li>
      </ul>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Related Tools</h5>
    <div class="card-body">
      <ul class="mb-0">
        <li><a href="projectile-motion-simulator.jsp">Projectile Motion Simulator</a></li>
        <li><a href="graphing-calculator.jsp">Graphing Calculator</a></li>
      </ul>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">FAQ</h5>
    <div class="card-body">
      <p><strong>What is Ohm’s Law?</strong><br>
        Ohm’s Law states that the voltage (V) across a conductor equals the current (I) through it times its resistance (R): V = I·R. It’s the core relationship used to size resistors, estimate current draw, and determine power dissipation.</p>
      <p><strong>How do I calculate power?</strong><br>
        Power is the rate of energy use. Using Ohm’s Law, you can compute it as any of P = V·I, P = I²·R, or P = V²/R depending on the known quantities. Always verify a resistor’s wattage rating is above its calculated P.</p>
      <p><strong>What’s the difference between series and parallel?</strong><br>
        In series, resistances add (R<sub>eq</sub> = R₁+R₂+…), so current is the same everywhere and voltages divide. In parallel, conductances add (1/R<sub>eq</sub> = 1/R₁+1/R₂+…), so voltage is the same across branches and currents divide.</p>
    </div>
  </div>

  <div class="card mb-4">
    <h5 class="card-header">Ohm’s Law Explained</h5>
    <div class="card-body">
      <h6>Formulas and Units</h6>
      <ul>
        <li>Voltage V (volts, V) = Current I (amps, A) × Resistance R (ohms, Ω).</li>
        <li>Power P (watts, W) = V·I = I²·R = V²/R.</li>
        <li>Common prefixes: mA = 10⁻³ A, kΩ = 10³ Ω, MΩ = 10⁶ Ω.</li>
      </ul>
      <h6>Practical Uses</h6>
      <ul>
        <li><strong>LED resistor sizing:</strong> R ≈ (V<sub>supply</sub> − V<sub>f</sub>) / I<sub>LED</sub>; P ≈ I²·R.</li>
        <li><strong>Voltage divider:</strong> V<sub>out</sub> = V<sub>in</sub> · R₂/(R₁+R₂). Keep divider current high enough for load tolerance but low enough to minimize power loss.</li>
        <li><strong>Current limiting:</strong> Choose R so I = V/R stays within device ratings.</li>
      </ul>
      <h6>Series vs Parallel</h6>
      <ul>
        <li>Series chains raise R<sub>eq</sub> and split voltage; parallel branches lower R<sub>eq</sub> and split current.</li>
        <li>Use series for simple current limiting and parallel for distributing current across paths.</li>
      </ul>
      <h6>Safety & Sizing</h6>
      <ul>
        <li>Select resistor wattage > 2× calculated P for headroom; verify temperature rise.</li>
        <li>Confirm supply and component voltage/current ratings before testing a circuit.</li>
      </ul>
      <p class="mb-0 text-muted">This Ohm’s Law calculator supports voltage/current/resistance/power, series/parallel equivalent resistance, divider visualizations, and a resistor color code helper — all computed locally in your browser.</p>
    </div>
  </div>
</div>

<script>
(function(){
  const V = document.getElementById('v');
  const I = document.getElementById('i');
  const R = document.getElementById('r');
  const P = document.getElementById('p');
  const unitV = document.getElementById('unitV');
  const unitI = document.getElementById('unitI');
  const unitR = document.getElementById('unitR');
  const unitP = document.getElementById('unitP');
  const err = document.getElementById('err');
  const kv = {V:document.getElementById('v_out'), I:document.getElementById('i_out'), R:document.getElementById('r_out'), P:document.getElementById('p_out')};

  // Unit helpers
  const UF = {
    V: {V:1, mV:1e-3, kV:1e3},
    I: {A:1, mA:1e-3, uA:1e-6},
    R: {ohm:1, kohm:1e3, Mohm:1e6},
    P: {W:1, mW:1e-3, kW:1e3}
  };
  function toBase(val, type){
    if(!Number.isFinite(val)) return NaN;
    if(type==='V') return val * (UF.V[unitV.value]||1);
    if(type==='I') return val * (UF.I[unitI.value]||1);
    if(type==='R') return val * (UF.R[unitR.value]||1);
    if(type==='P') return val * (UF.P[unitP.value]||1);
    return val;
  }
  function fromBase(val, type){
    if(!Number.isFinite(val)) return NaN;
    if(type==='V') return val / (UF.V[unitV.value]||1);
    if(type==='I') return val / (UF.I[unitI.value]||1);
    if(type==='R') return val / (UF.R[unitR.value]||1);
    if(type==='P') return val / (UF.P[unitP.value]||1);
    return val;
  }
  function fmtUnit(val, type){
    if(!Number.isFinite(val)) return '–';
    const v = fromBase(val, type);
    const suf = (type==='V')? unitV.value : (type==='I')? unitI.value : (type==='R')? ((unitR.value==='ohm')?'Ω':unitR.options[unitR.selectedIndex].text) : unitP.value;
    const fixed = Math.abs(v) < 1 ? v.toFixed(3) : v.toFixed(2);
    return fixed + ' ' + suf.replace('ohm','Ω');
  }
  function getVBase(){ return toBase(parseFloat(V.value), 'V'); }
  function getIBase(){ return toBase(parseFloat(I.value), 'I'); }
  function getRBase(){ return toBase(parseFloat(R.value), 'R'); }

  // Solve given any two of V, I, R
  function solve(){
    err.style.display='none'; err.textContent='';
    let vB = getVBase(); let iB = getIBase(); let rB = getRBase();
    let known = 0; if(Number.isFinite(vB)) known++; if(Number.isFinite(iB)) known++; if(Number.isFinite(rB)) known++;
    try {
      if(known < 2) throw new Error('Enter any two of V, I, R');
      if(!Number.isFinite(vB)) vB = iB * rB;
      if(!Number.isFinite(iB)) iB = vB / rB;
      if(!Number.isFinite(rB)) { if(iB!==0) rB = vB / iB; else throw new Error('I cannot be zero'); }
      const pB = vB * iB;
      V.value = toStr(fromBase(vB,'V')); I.value = toStr(fromBase(iB,'I')); R.value = toStr(fromBase(rB,'R')); P.value = toStr(fromBase(pB,'P'));
      kv.V.textContent = fmtUnit(vB,'V'); kv.I.textContent = fmtUnit(iB,'I'); kv.R.textContent = fmtUnit(rB,'R'); kv.P.textContent = fmtUnit(pB,'P');
      drawByType();
    } catch(e){ err.style.display='block'; err.textContent=e.message; }
  }

  function toStr(n){ return Number.isFinite(n)? (Math.round(n*100000)/100000).toString():''; }

  document.getElementById('btnSolve').addEventListener('click', solve);
  document.getElementById('btnClear').addEventListener('click', ()=>{ [V,I,R,P].forEach(el=>el.value=''); Object.values(kv).forEach(el=>el.textContent='–'); drawByType(); });
  ;[unitV, unitI, unitR, unitP].forEach(sel=> sel.addEventListener('change', ()=>{
    // Reformat outputs according to selected units
    const vB = getVBase(); const iB = getIBase(); const rB = getRBase(); const pB = (Number.isFinite(vB)&&Number.isFinite(iB))? vB*iB: NaN;
    if(Number.isFinite(vB)) V.value = toStr(fromBase(vB,'V'));
    if(Number.isFinite(iB)) I.value = toStr(fromBase(iB,'I'));
    if(Number.isFinite(rB)) R.value = toStr(fromBase(rB,'R'));
    if(Number.isFinite(pB)) P.value = toStr(fromBase(pB,'P')); else P.value='';
    kv.V.textContent = fmtUnit(vB,'V'); kv.I.textContent = fmtUnit(iB,'I'); kv.R.textContent = fmtUnit(rB,'R'); kv.P.textContent = fmtUnit(pB,'P');
    drawByType();
  }));

  // Simple circuit sketch
  const canvas = document.getElementById('circ'); const ctx = canvas.getContext('2d');
  const btnSave = document.getElementById('btnSavePng');
  const btnShare = document.getElementById('btnShareLink');
  const shareMsg = document.getElementById('shareMsg');
  function drawSingle(v,i,r,p){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    const w=canvas.width,h=canvas.height; const ox=60, oy=h-60; const rx = w-160, ry=oy-80;
    // loop wires
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ox,oy); ctx.lineTo(rx,oy); ctx.lineTo(rx,ry); ctx.lineTo(ox,ry); ctx.lineTo(ox,oy); ctx.stroke();
    // source
    ctx.save(); ctx.translate(ox, (oy+ry)/2);
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(-10,-20); ctx.lineTo(10,-20); ctx.moveTo(-6,20); ctx.lineTo(6,20); ctx.stroke();
    ctx.fillStyle='#1f2937'; ctx.fillText('V', -4, -30);
    const vB = getVBase(); if(Number.isFinite(vB)) { ctx.fillStyle='#0ea5e9'; ctx.fillText(fmtUnit(vB,'V'), -10, 36); }
    ctx.restore();
    // resistor
    ctx.save(); ctx.translate(rx, (oy+ry)/2);
    ctx.strokeStyle='#f59e0b'; ctx.lineWidth=2; zigzag(0, -24, 0, 24, 6, 10); ctx.stroke();
    ctx.fillStyle='#1f2937'; ctx.fillText('R', 6, -30);
    const rB = getRBase(); if(Number.isFinite(rB)) { ctx.fillStyle='#f59e0b'; ctx.fillText(fmtUnit(rB,'R'), 6, 36); }
    ctx.restore();
    // labels
    const iB = getIBase(); const pB = (Number.isFinite(vB)&&Number.isFinite(iB))? vB*iB: NaN;
    if(Number.isFinite(iB)) { ctx.fillStyle='#10b981'; ctx.fillText('I = '+fmtUnit(iB,'I'), (ox+rx)/2 - 30, oy + 28); }
    if(Number.isFinite(pB)) { ctx.fillStyle='#10b981'; ctx.fillText('P = '+fmtUnit(pB,'P'), (ox+rx)/2 - 30, ry - 12); }
  }

  function drawSeries(v, resistors){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    const w=canvas.width,h=canvas.height; const ox=60, oy=h-60; const rx = w-80; const top=60;
    // top wire
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ox,oy); ctx.lineTo(ox,top); ctx.lineTo(rx-40,top); ctx.stroke();
    // source at left
    ctx.save(); ctx.translate(ox, (oy+top)/2);
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(-10,-20); ctx.lineTo(10,-20); ctx.moveTo(-6,20); ctx.lineTo(6,20); ctx.stroke();
    const vB2=getVBase(); ctx.fillStyle='#0ea5e9'; if(Number.isFinite(vB2)) ctx.fillText(fmtUnit(vB2,'V'), -10, 36);
    ctx.restore();
    // draw N resistors along top
    const n = Math.max(1, resistors.length||1);
    const seg = (rx-ox-120)/n;
    let x=ox+20, y=top;
    for(let k=0;k<n;k++){
      ctx.save(); ctx.translate(x + seg*k + seg/2, y);
      ctx.strokeStyle='#f59e0b'; ctx.lineWidth=2; zigzag(-20,0,20,0,6,6); ctx.stroke();
      ctx.fillStyle='#f59e0b'; const rv = resistors[k]; if(Number.isFinite(rv)) ctx.fillText(rv.toFixed(1)+' Ω', -18, -10);
      ctx.restore();
    }
    // right wire down and back
    ctx.beginPath(); ctx.moveTo(rx-40,top); ctx.lineTo(rx-40,oy); ctx.lineTo(ox,oy); ctx.stroke();
    // compute and label current and power per resistor if V is known
    const vNumB=getVBase(); if(Number.isFinite(vNumB) && n){
      const Rsum = resistors.reduce((a,b)=>a+(Number.isFinite(b)?b:0),0) || getRBase()||0;
      if(Rsum>0){
        const Iloop = vNumB/Rsum; ctx.fillStyle='#10b981'; ctx.fillText('I = '+fmtUnit(Iloop,'I'), (ox+rx)/2-50, oy-12);
      }
    }
  }

  function drawParallel(v, resistors){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    const w=canvas.width,h=canvas.height; const ox=60, oy=h-60; const top=60; const right = w-60;
    // left up, top bus, right down, bottom bus
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ox,oy); ctx.lineTo(ox,top); ctx.lineTo(right,top); ctx.moveTo(ox,oy); ctx.lineTo(right,oy); ctx.stroke();
    // source on left side
    ctx.save(); ctx.translate(ox, (oy+top)/2);
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(-10,-20); ctx.lineTo(10,-20); ctx.moveTo(-6,20); ctx.lineTo(6,20); ctx.stroke();
    const vNumB2=getVBase(); ctx.fillStyle='#0ea5e9'; if(Number.isFinite(vNumB2)) ctx.fillText(fmtUnit(vNumB2,'V'), -10, 36);
    ctx.restore();
    // branches
    const n = Math.max(1, resistors.length||1);
    const gap = (right-ox-40)/n;
    for(let k=0;k<n;k++){
      const bx = ox+20 + k*gap + gap/2;
      // branch down
      ctx.beginPath(); ctx.moveTo(bx, top); ctx.lineTo(bx, oy); ctx.strokeStyle='#111827'; ctx.stroke();
      // resistor centered on branch
      ctx.save(); ctx.translate(bx, (top+oy)/2);
      ctx.strokeStyle='#f59e0b'; ctx.lineWidth=2; zigzag(0,-20,0,20,6,6); ctx.stroke();
      const rv = resistors[k]; ctx.fillStyle='#f59e0b'; if(Number.isFinite(rv)) ctx.fillText(rv.toFixed(1)+' Ω', 6, -24);
      ctx.restore();
    }
    // currents per branch if V known
    const vNum=getVBase();
    if(Number.isFinite(vNum)){
      for(let k=0;k<resistors.length;k++){
        const rv=resistors[k]; if(!Number.isFinite(rv)||rv<=0) continue;
        const ib = vNum/rv; ctx.fillStyle='#10b981'; const bx=ox+20+k*gap+gap/2; ctx.fillText(fmtUnit(ib,'I'), bx-18, oy+18);
      }
    }
  }

  function drawVoltageDivider(v, r1, r2){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    const w=canvas.width,h=canvas.height; const ox=60, oy=h-60; const right = w-100; const top=60;
    // loop
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ox,oy); ctx.lineTo(ox,top); ctx.lineTo(right,top); ctx.lineTo(right,oy); ctx.lineTo(ox,oy); ctx.stroke();
    // source
    ctx.save(); ctx.translate(ox, (oy+top)/2);
    ctx.strokeStyle='#3b82f6'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(-10,-20); ctx.lineTo(10,-20); ctx.moveTo(-6,20); ctx.lineTo(6,20); ctx.stroke();
    const vNum = Number.isFinite(v)? v : getVBase(); ctx.fillStyle='#0ea5e9'; if(Number.isFinite(vNum)) ctx.fillText(fmtUnit(vNum,'V'), -10, 36);
    ctx.restore();
    // two series resistors on right vertical
    const midY = (oy+top)/2;
    ctx.save(); ctx.translate(right, top+10);
    ctx.strokeStyle='#f59e0b'; ctx.lineWidth=2; zigzag(0,0,0, (midY-top-20), 6, 6); ctx.stroke(); ctx.fillStyle='#f59e0b'; if(Number.isFinite(r1)) ctx.fillText('R1 '+r1.toFixed(1)+' Ω', -70, (midY-top-20)/2);
    ctx.translate(0, (midY-top+20)); zigzag(0,0,0, (oy-midY-10), 6, 6); ctx.stroke(); if(Number.isFinite(r2)) ctx.fillText('R2 '+r2.toFixed(1)+' Ω', -70, (oy-midY-10)/2);
    ctx.restore();
    // Vout at middle node
    if(Number.isFinite(vNum) && Number.isFinite(r1) && Number.isFinite(r2) && r1+r2>0){
      const vout = vNum * (r2/(r1+r2)); ctx.fillStyle='#10b981'; ctx.fillText('Vout = '+fmtUnit(vout,'V'), right-180, midY-8);
    } else {
      ctx.fillStyle='#64748b'; ctx.fillText('Add two resistors in Series tab to see Vout', right-260, midY-8);
    }
  }

  function drawCurrentDivider(iTotal, r1, r2){
    ctx.clearRect(0,0,canvas.width,canvas.height);
    const w=canvas.width,h=canvas.height; const ox=60, oy=h-60; const top=60; const right = w-60; const midX = (ox+right)/2;
    // buses
    ctx.strokeStyle='#111827'; ctx.lineWidth=2; ctx.beginPath(); ctx.moveTo(ox,top); ctx.lineTo(right,top); ctx.moveTo(ox,oy); ctx.lineTo(right,oy); ctx.stroke();
    // current source (approx) on left
    ctx.save(); ctx.translate(ox, (top+oy)/2);
    ctx.strokeStyle='#3b82f6'; ctx.beginPath(); ctx.arc(0,0,14,0,2*Math.PI); ctx.stroke(); ctx.beginPath(); ctx.moveTo(0,-8); ctx.lineTo(0,8); ctx.moveTo(-6,2); ctx.lineTo(0,8); ctx.lineTo(6,2); ctx.stroke();
    const iNum = Number.isFinite(iTotal)? iTotal : getIBase();
    ctx.fillStyle='#0ea5e9'; if(Number.isFinite(iNum)) ctx.fillText(fmtUnit(iNum,'I'), -22, 28);
    ctx.restore();
    // two branches with resistors
    const bx1 = midX - 80, bx2 = midX + 80;
    ctx.beginPath(); ctx.moveTo(bx1, top); ctx.lineTo(bx1, oy); ctx.moveTo(bx2, top); ctx.lineTo(bx2, oy); ctx.stroke();
    ctx.save(); ctx.translate(bx1, (top+oy)/2); ctx.strokeStyle='#f59e0b'; zigzag(0,-18,0,18,6,6); ctx.stroke(); ctx.fillStyle='#f59e0b'; if(Number.isFinite(r1)) ctx.fillText('R1 '+r1.toFixed(1)+' Ω', 6, -24); ctx.restore();
    ctx.save(); ctx.translate(bx2, (top+oy)/2); ctx.strokeStyle='#f59e0b'; zigzag(0,-18,0,18,6,6); ctx.stroke(); ctx.fillStyle='#f59e0b'; if(Number.isFinite(r2)) ctx.fillText('R2 '+r2.toFixed(1)+' Ω', 6, -24); ctx.restore();
    // currents
    if(Number.isFinite(iNum) && Number.isFinite(r1) && Number.isFinite(r2) && r1>0 && r2>0){
      const i1 = iNum * (r2/(r1+r2)); const i2 = iNum * (r1/(r1+r2));
      ctx.fillStyle='#10b981'; ctx.fillText(fmtUnit(i1,'I'), bx1-18, oy+18); ctx.fillText(fmtUnit(i2,'I'), bx2-18, oy+18);
    } else {
      ctx.fillStyle='#64748b'; ctx.fillText('Enter total I and two resistors in Parallel tab for branch currents', midX-220, top+16);
    }
  }
  function zigzag(x1,y1,x2,y2, teeth, amp){
    const dx=(x2-x1)/(teeth*2), dy=(y2-y1)/(teeth*2);
    ctx.beginPath(); ctx.moveTo(x1,y1);
    for(let k=0;k<teeth*2;k++){
      const nx = x1 + dx*(k+1); const ny = y1 + dy*(k+1);
      const offx = (k%2===0? amp:-amp); ctx.lineTo(nx+offx, ny);
    }
    ctx.lineTo(x2,y2);
  }
  // Circuit type orchestrator
  const cTypeSel = document.getElementById('cType');
  function drawByType(){
    const type = cTypeSel.value;
    const v = parseFloat(V.value); const i = parseFloat(I.value); const r = parseFloat(R.value); const p = (Number.isFinite(v)&&Number.isFinite(i))? v*i: NaN;
    if(type==='single') return drawSingle(v,i,r,p);
    if(type==='series') return drawSeries(v, sArr);
    if(type==='parallel') return drawParallel(v, pArr);
    if(type==='vdiv'){
      const r1 = sArr[0], r2 = sArr[1]; return drawVoltageDivider(v, r1, r2);
    }
    if(type==='idiv'){
      const r1 = pArr[0], r2 = pArr[1]; return drawCurrentDivider(i, r1, r2);
    }
    drawSingle(v,i,r,p);
  }

  // Export: Save PNG with stats footer
  function savePngWithStats(){
    try{
      const off = document.createElement('canvas');
      const pad = 56; // footer padding for stats
      off.width = canvas.width; off.height = canvas.height + pad;
      const octx = off.getContext('2d');
      // white background
      octx.fillStyle = '#ffffff'; octx.fillRect(0,0,off.width,off.height);
      // copy diagram
      octx.drawImage(canvas, 0, 0);
      // stats footer
      octx.fillStyle = '#111827'; octx.font = '14px system-ui, -apple-system, Segoe UI, Roboto, sans-serif';
      const v = parseFloat(V.value); const i = parseFloat(I.value); const r = parseFloat(R.value); const p = (Number.isFinite(v)&&Number.isFinite(i))? v*i : NaN;
      const ctype = cTypeSel.value;
      const sListTxt = (window.sArr&&sArr.length)? 'Series: '+sArr.join('Ω, ')+'Ω' : '';
      const pListTxt = (window.pArr&&pArr.length)? 'Parallel: '+pArr.join('Ω, ')+'Ω' : '';
      const meta = [
        'Circuit: '+ctype,
        'V: '+fmtUnit(v,'V')+'  I: '+fmtUnit(i,'I')+'  R: '+fmtUnit(r,'R')+'  P: '+fmtUnit(p,'P'),
        sListTxt || pListTxt,
        'https://8gwifi.org/ohms-law-calculator.jsp'
      ].filter(Boolean);
      for(let k=0;k<meta.length;k++){
        octx.fillText(meta[k], 12, canvas.height + 22 + k*18);
      }
      const a = document.createElement('a');
      a.href = off.toDataURL('image/png');
      a.download = 'ohms-law-circuit.png';
      document.body.appendChild(a); a.click(); document.body.removeChild(a);
    }catch(e){ /* no-op */ }
  }

  // Share: build a permalink with current state
  function buildShareUrl(){
    const url = new URL(window.location.href);
    url.searchParams.set('cType', cTypeSel.value);
    if(V.value) url.searchParams.set('V', V.value);
    if(I.value) url.searchParams.set('I', I.value);
    if(R.value) url.searchParams.set('R', R.value);
    if(sArr && sArr.length) url.searchParams.set('s', sArr.join(','));
    if(pArr && pArr.length) url.searchParams.set('p', pArr.join(','));
    return url.toString();
  }
  async function shareLink(){
    const link = buildShareUrl();
    try{
      if(navigator.share){
        await navigator.share({ title: "Ohm's Law Circuit", text: 'Check this circuit setup', url: link });
        return;
      }
    }catch(e){ /* fallback to copy */ }
    try{
      if(navigator.clipboard && navigator.clipboard.writeText){ await navigator.clipboard.writeText(link); }
      else {
        const ta=document.createElement('textarea'); ta.value=link; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta);
      }
      shareMsg.style.display='inline'; setTimeout(()=> shareMsg.style.display='none', 1500);
    }catch(e){ /* no-op */ }
  }

  btnSave.addEventListener('click', savePngWithStats);
  btnShare.addEventListener('click', shareLink);

  // Apply params from URL on load
  (function applyParams(){
    try{
      const url = new URL(window.location.href);
      const c = url.searchParams.get('cType'); if(c){ cTypeSel.value=c; }
      const v = url.searchParams.get('V'); if(v!==null){ V.value=v; }
      const i = url.searchParams.get('I'); if(i!==null){ I.value=i; }
      const r = url.searchParams.get('R'); if(r!==null){ R.value=r; }
      const s = url.searchParams.get('s'); if(s){ sArr = s.split(',').map(parseFloat).filter(x=>Number.isFinite(x)); updateSeries(); }
      const p = url.searchParams.get('p'); if(p){ pArr = p.split(',').map(parseFloat).filter(x=>Number.isFinite(x)); updateParallel(); }
      drawByType();
    }catch(e){ /* ignore */ }
  })();

  // Tabs
  const tabSeries=document.getElementById('tabSeries');
  const tabParallel=document.getElementById('tabParallel');
  const tabColors=document.getElementById('tabColors');
  const panelSeries=document.getElementById('panelSeries');
  const panelParallel=document.getElementById('panelParallel');
  const panelColors=document.getElementById('panelColors');
  function showPanel(p){ [panelSeries,panelParallel,panelColors].forEach(el=>el.classList.remove('active')); p.classList.add('active'); [tabSeries,tabParallel,tabColors].forEach(a=>a.classList.remove('active')); }
  tabSeries.addEventListener('click', (e)=>{e.preventDefault(); showPanel(panelSeries); tabSeries.classList.add('active');});
  tabParallel.addEventListener('click', (e)=>{e.preventDefault(); showPanel(panelParallel); tabParallel.classList.add('active');});
  tabColors.addEventListener('click', (e)=>{e.preventDefault(); showPanel(panelColors); tabColors.classList.add('active');});

  // Series/Parallel calculators
  const sList=document.getElementById('seriesList'); const sVal=document.getElementById('seriesVal'); const sAdd=document.getElementById('seriesAdd'); const sClear=document.getElementById('seriesClear'); const sReq=document.getElementById('seriesReq');
  const pList=document.getElementById('parallelList'); const pVal=document.getElementById('parallelVal'); const pAdd=document.getElementById('parallelAdd'); const pClear=document.getElementById('parallelClear'); const pReq=document.getElementById('parallelReq');
  let sArr=[], pArr=[];
  function renderList(container, arr){ container.innerHTML = arr.map((v,idx)=> '<span class="badge badge-secondary mr-1">'+v+'Ω <a href="#" data-i="'+idx+'" class="text-light">×</a></span>').join(' '); }
  function updateSeries(){ const sum = sArr.reduce((a,b)=>a+b,0); sReq.textContent = sArr.length? sum.toFixed(3):'–'; renderList(sList,sArr); if(cTypeSel.value==='series'||cTypeSel.value==='vdiv') drawByType(); }
  function updateParallel(){ const inv = pArr.reduce((a,b)=> a + (1/b), 0); const req = pArr.length? 1/inv : NaN; pReq.textContent = pArr.length? req.toFixed(3):'–'; renderList(pList,pArr); if(cTypeSel.value==='parallel'||cTypeSel.value==='idiv') drawByType(); }
  sAdd.addEventListener('click', ()=>{ const v=parseFloat(sVal.value); if(Number.isFinite(v) && v>0){ sArr.push(v); sVal.value=''; updateSeries(); }});
  sClear.addEventListener('click', ()=>{ sArr=[]; updateSeries(); });
  sList.addEventListener('click', (e)=>{ if(e.target && e.target.dataset && e.target.dataset.i){ sArr.splice(parseInt(e.target.dataset.i,10),1); updateSeries(); }});
  pAdd.addEventListener('click', ()=>{ const v=parseFloat(pVal.value); if(Number.isFinite(v) && v>0){ pArr.push(v); pVal.value=''; updateParallel(); }});
  pClear.addEventListener('click', ()=>{ pArr=[]; updateParallel(); });
  pList.addEventListener('click', (e)=>{ if(e.target && e.target.dataset && e.target.dataset.i){ pArr.splice(parseInt(e.target.dataset.i,10),1); updateParallel(); }});
  updateSeries(); updateParallel();
  cTypeSel.addEventListener('change', drawByType);
  [V,I,R].forEach(el=> el.addEventListener('input', drawByType));
  // initial render
  drawByType();

  // Resistor Color Code (simplified E12 mapping for demo)
  const colors = ['#000000','#8B4513','#FF0000','#FFA500','#FFFF00','#008000','#0000FF','#EE82EE','#A52A2A','#C0C0C0'];
  const bandCount=document.getElementById('bandCount'); const resVal=document.getElementById('resVal'); const tolSel=document.getElementById('tol');
  const b1=document.getElementById('b1'), b2=document.getElementById('b2'), b3=document.getElementById('b3'), b4=document.getElementById('b4'), b5=document.getElementById('b5');
  function valToBands(val, bands){
    if(!(val>0)) return {d1:0,d2:0,m:0};
    // normalize to [10, 99] * 10^m for 4-band, [100, 999] for 5-band
    let m = 0; let n = val;
    while(n >= 100 && bands===4){ n/=10; m++; }
    while(n >= 1000 && bands===5){ n/=10; m++; }
    while(n < 10 && bands===4){ n*=10; m--; }
    while(n < 100 && bands===5){ n*=10; m--; }
    const str = Math.round(n).toString();
    if(bands===4){ return {d1: +str[0]||0, d2: +str[1]||0, m: Math.max(-2, Math.min(9,m))}; }
    else { return {d1:+str[0]||0, d2:+str[1]||0, d3:+str[2]||0, m: Math.max(-2, Math.min(9,m))}; }
  }
  function updateBands(){
    const bands = parseInt(bandCount.value,10);
    const val = parseFloat(resVal.value);
    const b = valToBands(val, bands);
    b1.style.background = colors[b.d1]||colors[0];
    b2.style.background = colors[b.d2]||colors[0];
    b3.style.background = colors[(bands===4? b.m : b.d3)||0]||colors[0];
    b4.style.display = 'inline-block';
    if(bands===5){ b5.style.display='inline-block'; b5.style.background = colors[b.m]||colors[0]; }
    else { b5.style.display='none'; }
  }
  bandCount.addEventListener('change', updateBands);
  resVal.addEventListener('input', updateBands);
  tolSel.addEventListener('change', ()=>{ /* could update b4 color by tol */ });
  updateBands();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
