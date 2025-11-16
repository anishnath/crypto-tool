<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Molarity Calculator (M, mol/L) + Dilution (C1V1=C2V2) | Free Online | 8gwifi.org</title>
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/molarity-dilution-calculator.jsp">
  <meta name="description" content="Free molarity and dilution calculator. Compute molarity (M), mass, volume, or moles; plan C1V1=C2V2 dilutions; serial dilutions; unit support (g, mg, L, mL, M, mM). No sign‑up; runs in your browser.">

  <!-- Open Graph / Twitter -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="8gwifi.org">
  <meta property="og:title" content="Molarity Calculator + Dilution (C1V1=C2V2) | Free Online">
  <meta property="og:description" content="Compute molarity, mass, volume, or moles. Plan dilutions and serial dilutions. Unit-aware. Free and browser‑only.">
  <meta property="og:url" content="https://8gwifi.org/molarity-dilution-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/molarity-dilution.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@anish2good">
  <meta name="twitter:title" content="Molarity Calculator + Dilution (C1V1=C2V2) | Free Online">
  <meta name="twitter:description" content="Free molarity and dilution calculator with unit support and serial dilutions.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/molarity-dilution.png">

  <style>
    .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; }
    .min-h-result { min-height: 240px; }
    .monospace { font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
    .options-bar { display:flex; flex-wrap:wrap; gap:.75rem; align-items:center; }
    .section-title { font-weight:600; margin-top:.5rem; }
    .formula-badge { font-weight:600; }
    .result-badge { display:inline-block; padding:.35rem .6rem; background:#e6f4ea; color:#0f5132; border:1px solid #badbcc; border-radius:.35rem; font-weight:600; }
    .result-sub { color:#6c757d; font-size:.9rem; }
  </style>
  <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>
<div class="container mt-5">
  <h1 class="mb-3">Molarity + Dilution Calculator</h1>
  <p class="lead mb-4">Compute molarity (M), mass, volume, or moles and plan C<sub>1</sub>V<sub>1</sub>=C<sub>2</sub>V<sub>2</sub> dilutions. Unit-aware, fast, and free.</p>

  <!-- Tabs -->
  <ul class="nav nav-tabs mb-3" role="tablist">
    <li class="nav-item"><a class="nav-link active" id="tab-molarity" href="#" role="tab" onclick="switchMD('molarity');return false;">Molarity</a></li>
    <li class="nav-item"><a class="nav-link" id="tab-dilution" href="#" role="tab" onclick="switchMD('dilution');return false;">Dilution (C1V1=C2V2)</a></li>
    <li class="nav-item"><a class="nav-link" id="tab-conv" href="#" role="tab" onclick="switchMD('conversions');return false;">Conversions</a></li>
  </ul>

  <div id="sectionMolarity">
    <div class="row">
      <div class="col-lg-7 mb-4">
        <div class="card shadow-sm h-100">
          <div class="card-body">
            <h5 class="card-title">Molarity</h5>
            <p class="text-muted">Molarity M = moles / volume (L). moles = mass / molar mass.</p>
            <div class="form-row">
              <div class="form-group col-md-8">
                <label for="reagentPreset">Reagent Preset (optional)</label>
                <input id="presetInput" class="form-control" list="presetList" placeholder="Type or choose reagent (auto-fills molar mass)" onchange="applyPresetFromInput()">
                <datalist id="presetList">
                  <option value="Sodium chloride (NaCl) — 58.44|58.44"></option>
                  <option value="Potassium chloride (KCl) — 74.55|74.55"></option>
                  <option value="Sodium hydroxide (NaOH) — 40.00|40.00"></option>
                  <option value="Potassium hydroxide (KOH) — 56.11|56.11"></option>
                  <option value="Sodium bicarbonate (NaHCO3) — 84.01|84.01"></option>
                  <option value="Sodium carbonate (Na2CO3) — 105.99|105.99"></option>
                  <option value="Ammonium chloride (NH4Cl) — 53.49|53.49"></option>
                  <option value="Ammonium sulfate ((NH4)2SO4) — 132.14|132.14"></option>
                  <option value="Calcium chloride anhydrous (CaCl2) — 110.98|110.98"></option>
                  <option value="Calcium chloride dihydrate (CaCl2·2H2O) — 147.02|147.02"></option>
                  <option value="Magnesium chloride hexahydrate (MgCl2·6H2O) — 203.30|203.30"></option>
                  <option value="Hydrochloric acid (HCl) — 36.46|36.46"></option>
                  <option value="Nitric acid (HNO3) — 63.01|63.01"></option>
                  <option value="Sulfuric acid (H2SO4) — 98.08|98.08"></option>
                  <option value="Acetic acid (CH3COOH) — 60.05|60.05"></option>
                  <option value="Citric acid (anhydrous) — 192.12|192.12"></option>
                  <option value="Citric acid monohydrate — 210.14|210.14"></option>
                  <option value="Tris base — 121.14|121.14"></option>
                  <option value="Tris-HCl — 157.60|157.60"></option>
                  <option value="HEPES (free acid) — 238.30|238.30"></option>
                  <option value="MES (free acid) — 195.24|195.24"></option>
                  <option value="MOPS (free acid) — 209.26|209.26"></option>
                  <option value="Glycine — 75.07|75.07"></option>
                  <option value="Sodium acetate (anhydrous) — 82.03|82.03"></option>
                  <option value="Ammonium acetate — 77.08|77.08"></option>
                  <option value="Sodium dihydrogen phosphate (NaH2PO4) — 119.98|119.98"></option>
                  <option value="Sodium dihydrogen phosphate monohydrate — 137.99|137.99"></option>
                  <option value="Disodium hydrogen phosphate (Na2HPO4) — 141.96|141.96"></option>
                  <option value="Potassium dihydrogen phosphate (KH2PO4) — 136.09|136.09"></option>
                  <option value="Dipotassium hydrogen phosphate (K2HPO4) — 174.18|174.18"></option>
                  <option value="EDTA (free acid) — 292.24|292.24"></option>
                  <option value="EDTA disodium dihydrate — 372.24|372.24"></option>
                  <option value="SDS — 288.38|288.38"></option>
                  <option value="Urea — 60.06|60.06"></option>
                  <option value="Glucose — 180.16|180.16"></option>
                  <option value="Fructose — 180.16|180.16"></option>
                  <option value="Sucrose — 342.30|342.30"></option>
                  <option value="Sodium azide (NaN3) — 65.01|65.01"></option>
                  <option value="Sodium thiosulfate pentahydrate — 248.18|248.18"></option>
                  <option value="Trisodium citrate dihydrate — 294.10|294.10"></option>
                </datalist>
                <small class="text-muted">Type to search; pick an item to fill molar mass.</small>
              </div>
              <div class="form-group col-md-4 d-flex align-items-end">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="autoMol" checked>
                  <label class="form-check-label" for="autoMol">Auto-calculate</label>
                </div>
              </div>
            </div>
            <div class="form-row" id="rowTargetM" style="display:none;">
              <div class="form-group col-md-6">
                <label for="molTargetM">Target M (mol/L)
                  <button type="button" class="btn btn-link btn-sm p-0 ml-2" onclick="useLastM()" title="Use last calculated M">Use last M</button>
                </label>
                <input id="molTargetM" type="number" class="form-control" placeholder="e.g., 1" oninput="if(document.getElementById('autoMol').checked) calcMolarity();">
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="molSolve">Solve for</label>
                <select id="molSolve" class="form-control">
                  <option value="M">M (mol/L)</option>
                  <option value="mass">Mass</option>
                  <option value="vol">Volume</option>
                  <option value="moles">Moles</option>
                </select>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="molMass">Mass</label>
                <div class="input-group">
                  <input id="molMass" type="number" class="form-control" placeholder="e.g., 58.44">
                  <div class="input-group-append">
                    <select id="molMassUnit" class="form-control">
                      <option value="g">g</option>
                      <option value="mg">mg</option>
                      <option value="ug">µg</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="form-group col-md-6">
                <label for="molMM">Molar mass (g/mol)</label>
                <input id="molMM" type="number" class="form-control" placeholder="e.g., NaCl = 58.44">
                <small class="text-muted">Tip: Use Molar Mass Calculator to find this.</small>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="molVol">Volume</label>
                <div class="input-group">
                  <input id="molVol" type="number" class="form-control" placeholder="e.g., 1">
                  <div class="input-group-append">
                    <select id="molVolUnit" class="form-control">
                      <option value="L">L</option>
                      <option value="mL">mL</option>
                      <option value="uL">µL</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="form-group col-md-6">
                <label for="molMoles">Moles</label>
                <input id="molMoles" type="number" class="form-control" placeholder="optional">
              </div>
            </div>
            <div class="options-bar mb-2">
              <button class="btn btn-primary" onclick="calcMolarity()">Calculate</button>
              <button class="btn btn-outline-secondary" onclick="resetMolarity()">Reset</button>
              <button class="btn btn-outline-secondary" onclick="copyMolResult()">Copy</button>
              <button class="btn btn-outline-secondary" onclick="shareMol()">Share</button>
              <button class="btn btn-outline-secondary" onclick="copyMolLaTeX()">LaTeX</button>
              <button class="btn btn-outline-secondary" onclick="exportMolPNG()">PNG</button>
              <button class="btn btn-outline-primary" onclick="buildRecipe()">Recipe</button>
            </div>
            <div class="small text-muted">Formula: <span class="formula-badge">M = (mass / MM) / volume(L)</span></div>
            <hr>
            <h6 class="section-title">Conversions (moved to Conversions tab)</h6>
            <div class="text-muted small">Open the Conversions tab for ppm/ppb/% calculations.</div>
          </div>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="card shadow-sm sticky-side">
          <div class="card-body">
            <h5 class="card-title mb-3">Result</h5>
            <div id="molResult" class="min-h-result"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div id="sectionConversions" style="display:none;">
    <div class="row">
      <div class="col-lg-7 mb-4">
        <div class="card shadow-sm h-100">
          <div class="card-body">
            <h5 class="card-title">Conversions</h5>
            <p class="text-muted">Convert between M, mg/mL, mg/L (≈ppm), ppm, ppb, and % (w/v, w/w, v/v). Provide molar mass for M, densities for ppm/ppb and %w/w/%v/v where applicable.</p>
            <div class="form-row">
              <div class="form-group col-md-4">
                <label for="convType">Input type</label>
                <select id="convType" class="form-control">
                  <option value="M">M (mol/L)</option>
                  <option value="mgmL">mg/mL</option>
                  <option value="mgL">mg/L (≈ ppm)</option>
                  <option value="ppm">ppm (mg/kg)</option>
                  <option value="ppb">ppb (µg/kg)</option>
                  <option value="wv">% w/v</option>
                  <option value="ww">% w/w</option>
                  <option value="vv">% v/v</option>
                </select>
              </div>
              <div class="form-group col-md-4">
                <label for="convVal">Value</label>
                <input id="convVal" type="number" class="form-control" placeholder="e.g., 1">
              </div>
              <div class="form-group col-md-4">
                <label for="convMM">Molar mass (g/mol)</label>
                <input id="convMM" type="number" class="form-control" placeholder="e.g., 58.44">
                <small class="text-muted">If empty, uses molar mass on Molarity tab.</small>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-4">
                <label for="rho">Solution density (g/mL)</label>
                <input id="rho" type="number" class="form-control" value="1.0">
              </div>
              <div class="form-group col-md-4">
                <label for="rhoS">Solute density (g/mL)</label>
                <input id="rhoS" type="number" class="form-control" placeholder="for %v/v">
              </div>
              <div class="form-group col-md-4 d-flex align-items-end">
                <div>
                  <button class="btn btn-outline-primary" onclick="calcConversions()">Convert</button>
                  <div class="form-check mt-2">
                    <input class="form-check-input" type="checkbox" id="autoConv" checked>
                    <label class="form-check-label" for="autoConv">Auto-convert</label>
                  </div>
                </div>
              </div>
            </div>
            <div id="convResult"></div>
          </div>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="card shadow-sm sticky-side">
          <div class="card-body">
            <h5 class="card-title mb-3">Result</h5>
            <div id="convResultSticky" class="min-h-result"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div id="sectionDilution" style="display:none;">
    <div class="row">
      <div class="col-lg-7 mb-4">
        <div class="card shadow-sm h-100">
          <div class="card-body">
            <h5 class="card-title">Dilution (C1V1=C2V2)</h5>
            <div class="form-row">
              <div class="form-group col-md-6 d-flex align-items-end">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="autoDil" checked>
                  <label class="form-check-label" for="autoDil">Auto-calculate</label>
                </div>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="dilSolve">Solve for</label>
                <select id="dilSolve" class="form-control">
                  <option value="C1">C1</option>
                  <option value="V1">V1</option>
                  <option value="C2" selected>C2</option>
                  <option value="V2">V2</option>
                </select>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="C1">C1</label>
                <div class="input-group">
                  <input id="C1" type="number" class="form-control" placeholder="stock">
                  <div class="input-group-append">
                    <select id="C1u" class="form-control">
                      <option value="M">M</option>
                      <option value="mM">mM</option>
                      <option value="uM">µM</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="form-group col-md-6">
                <label for="V1">V1</label>
                <div class="input-group">
                  <input id="V1" type="number" class="form-control" placeholder="aliquot">
                  <div class="input-group-append">
                    <select id="V1u" class="form-control">
                      <option value="L">L</option>
                      <option value="mL" selected>mL</option>
                      <option value="uL">µL</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group col-md-6">
                <label for="C2">C2</label>
                <div class="input-group">
                  <input id="C2" type="number" class="form-control" placeholder="final">
                  <div class="input-group-append">
                    <select id="C2u" class="form-control">
                      <option value="M">M</option>
                      <option value="mM" selected>mM</option>
                      <option value="uM">µM</option>
                    </select>
                  </div>
                </div>
              </div>
              <div class="form-group col-md-6">
                <label for="V2">V2</label>
                <div class="input-group">
                  <input id="V2" type="number" class="form-control" placeholder="final volume">
                  <div class="input-group-append">
                    <select id="V2u" class="form-control">
                      <option value="L">L</option>
                      <option value="mL" selected>mL</option>
                      <option value="uL">µL</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
            <div class="options-bar mb-2">
              <button class="btn btn-primary" onclick="calcDilution()">Calculate</button>
              <button class="btn btn-outline-secondary" onclick="resetDilution()">Reset</button>
              <button class="btn btn-outline-secondary" onclick="copyDilResult()">Copy</button>
            </div>
            <div class="small text-muted">Formula: <span class="formula-badge">C1·V1 = C2·V2</span></div>
            <hr>
            <h6 class="section-title">Serial Dilution Planner</h6>
            <div class="form-row">
              <div class="form-group col-md-3">
                <label for="sdFold">Fold</label>
                <input id="sdFold" type="number" class="form-control" placeholder="e.g., 10">
              </div>
              <div class="form-group col-md-3">
                <label for="sdSteps">Steps</label>
                <input id="sdSteps" type="number" class="form-control" placeholder="e.g., 5">
              </div>
              <div class="form-group col-md-3">
                <label for="sdAliquot">Aliquot</label>
                <div class="input-group">
                  <input id="sdAliquot" type="number" class="form-control" placeholder="e.g., 1">
                  <div class="input-group-append"><span class="input-group-text">mL</span></div>
                </div>
              </div>
              <div class="form-group col-md-3 d-flex align-items-end">
                <button class="btn btn-outline-primary" onclick="planSerialDilution()">Plan</button>
              </div>
            </div>
            <div id="sdResult"></div>
          </div>
        </div>
      </div>
      <div class="col-lg-5">
        <div class="card shadow-sm sticky-side">
          <div class="card-body">
            <h5 class="card-title mb-3">Result</h5>
            <div id="dilResult" class="min-h-result"></div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Learn Section -->
<div class="container mt-4">
  <div class="card shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3">What Is Molarity and Dilution?</h5>
      <p><strong>Molarity (M)</strong> is moles of solute per liter of solution (mol/L). <strong>Dilution</strong> relates two concentrations and volumes by C<sub>1</sub>V<sub>1</sub>=C<sub>2</sub>V<sub>2</sub>.</p>
      <h6 class="mt-3">Common Tasks</h6>
      <ul>
        <li>Make 1 L of 1 M NaCl: mass = 1 mol × 58.44 g/mol = 58.44 g</li>
        <li>Dilute 10 mL of 1 M stock to 0.1 M: V2 = (C1·V1)/C2 = (1×10)/0.1 = 100 mL</li>
      </ul>
    </div>
  </div>
</div>

<script>
  function switchMD(which){
    const m=document.getElementById('sectionMolarity');
    const d=document.getElementById('sectionDilution');
    const c=document.getElementById('sectionConversions');
    const tm=document.getElementById('tab-molarity');
    const td=document.getElementById('tab-dilution');
    const tc=document.getElementById('tab-conv');
    if(which==='dilution'){
      m.style.display='none'; d.style.display='block'; c.style.display='none';
      tm.classList.remove('active'); td.classList.add('active'); tc.classList.remove('active');
    } else if(which==='conversions'){
      m.style.display='none'; d.style.display='none'; c.style.display='block';
      tm.classList.remove('active'); td.classList.remove('active'); tc.classList.add('active');
    } else {
      d.style.display='none'; c.style.display='none'; m.style.display='block';
      td.classList.remove('active'); tc.classList.remove('active'); tm.classList.add('active');
    }
    history.replaceState({},'',window.location.pathname+'?tab='+which);
  }

  // Unit helpers
  function massToG(val, unit){ if(!val) return 0; const f = unit==='mg'?1e-3 : unit==='ug'?1e-6 : 1; return val*f; }
  function gToUnits(g){ return { g: g, mg: g*1e3, ug: g*1e6 }; }
  function volToL(val, unit){ if(!val) return 0; const f = unit==='mL'?1e-3 : unit==='uL'?1e-6 : 1; return val*f; }
  function LToUnits(L){ return { L: L, mL: L*1e3, uL: L*1e6 }; }
  function concToM(val, unit){ if(!val) return 0; const f = unit==='mM'?1e-3 : unit==='uM'?1e-6 : 1; return val*f; }
  function MToUnits(M){ return { M: M, mM: M*1e3, uM: M*1e6 }; }

  // Molarity calc
function calcMolarity(){
  const solve = document.getElementById('molSolve').value;
  const mass = parseFloat(document.getElementById('molMass').value||'');
  const massU = document.getElementById('molMassUnit').value;
  const MM = parseFloat(document.getElementById('molMM').value||'');
  const vol = parseFloat(document.getElementById('molVol').value||'');
  const volU = document.getElementById('molVolUnit').value;
  const molesIn = parseFloat(document.getElementById('molMoles').value||'');
  const res = document.getElementById('molResult');
  const tEl=document.getElementById('molTargetM');
  const targetM = tEl && tEl.value!=='' ? parseFloat(tEl.value) : NaN;

  let g = massToG(mass, massU);
  let L = volToL(vol, volU);
  let n = isFinite(molesIn)? molesIn : NaN;
  if(!isFinite(n) || n<=0){ if(isFinite(g) && isFinite(MM) && MM>0){ n = g / MM; } }

  let M=null, out='';
  try{
    if(solve==='M'){
      if(!(n>0) || !(L>0)) throw new Error('Enter mass+MM or moles, and volume.');
      M = n / L;
      const u = MToUnits(M);
      out = `<div><span class="result-badge">M = ${M.toPrecision(6)} mol/L</span> <span class="result-sub">(${u.mM.toPrecision(6)} mM, ${u.uM.toPrecision(6)} µM)</span></div>`;
      try{ window._lastM = M; }catch(e){}
    } else if(solve==='mass'){
      if(!(MM>0)) throw new Error('Provide molar mass (g/mol).');
      // If moles provided, prefer direct mass = n * MM
      let grams = NaN;
      if(n>0){
        grams = n * MM;
      } else {
        // Otherwise need target M and volume
        if(!(L>0)) throw new Error('Provide volume.');
        if(!(targetM>0)) throw new Error('Provide target M.');
        grams = (targetM*L) * MM;
      }
      const u = gToUnits(grams);
      out = `<div><span class="result-badge">Mass = ${u.g.toPrecision(6)} g</span> <span class="result-sub">(${u.mg.toPrecision(6)} mg, ${u.ug.toPrecision(6)} µg)</span></div>`;
    } else if(solve==='vol'){
      if(!(targetM>0)) throw new Error('Provide target M (desired molarity). Tip: click "Use last M" if you calculated M earlier.');
      if(!(n>0)){
        if(!(g>0 && MM>0)) throw new Error('Provide mass+MM or moles.');
        n = g / MM;
      }
      const liters = n / targetM;
      const u = LToUnits(liters);
      out = `<div><span class="result-badge">Volume = ${u.L.toPrecision(6)} L</span> <span class="result-sub">(${u.mL.toPrecision(6)} mL, ${u.uL.toPrecision(6)} µL)</span></div>`;
    } else if(solve==='moles'){
      if(!(L>0)) throw new Error('Provide volume.');
      if(!(targetM>0)) throw new Error('Provide target M.');
      const moles = targetM * L;
      out = `<div><span class="result-badge">Moles = ${moles.toPrecision(6)} mol</span></div>`;
    }
  }catch(err){ out = `<div class="alert alert-warning">${err.message}</div>`; }
  res.innerHTML = out;
}
  function copyMolResult(){
    const el=document.getElementById('molResult'); if(!el) return;
    const text=el.innerText || el.textContent || '';
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(text); }
  }
  function resetMolarity(){
    ['molMass','molMM','molVol','molMoles'].forEach(id=>{ const el=document.getElementById(id); if(el) el.value=''; });
    document.getElementById('molResult').innerHTML='';
  }

  // Dilution calc
  function calcDilution(){
    const solve = document.getElementById('dilSolve').value;
    let C1 = concToM(parseFloat(document.getElementById('C1').value||''), document.getElementById('C1u').value);
    let V1 = volToL(parseFloat(document.getElementById('V1').value||''), document.getElementById('V1u').value);
    let C2 = concToM(parseFloat(document.getElementById('C2').value||''), document.getElementById('C2u').value);
    let V2 = volToL(parseFloat(document.getElementById('V2').value||''), document.getElementById('V2u').value);
    const res = document.getElementById('dilResult');
    let out='';
    try{
      if(solve==='C1'){
        if(!(V1>0 && C2>0 && V2>0)) throw new Error('Enter V1, C2, V2.');
        C1 = (C2*V2)/V1;
        const u = MToUnits(C1);
        out = `<div><b>C1</b> = ${u.M.toPrecision(6)} M (${u.mM.toPrecision(6)} mM, ${u.uM.toPrecision(6)} µM)</div>`;
      } else if(solve==='V1'){
        if(!(C1>0 && C2>0 && V2>0)) throw new Error('Enter C1, C2, V2.');
        V1 = (C2*V2)/C1;
        const u = LToUnits(V1);
        out = `<div><b>V1</b> = ${u.L.toPrecision(6)} L (${u.mL.toPrecision(6)} mL, ${u.uL.toPrecision(6)} µL)</div>`;
      } else if(solve==='C2'){
        if(!(C1>0 && V1>0 && V2>0)) throw new Error('Enter C1, V1, V2.');
        C2 = (C1*V1)/V2;
        const u = MToUnits(C2);
        out = `<div><b>C2</b> = ${u.M.toPrecision(6)} M (${u.mM.toPrecision(6)} mM, ${u.uM.toPrecision(6)} µM)</div>`;
      } else if(solve==='V2'){
        if(!(C1>0 && V1>0 && C2>0)) throw new Error('Enter C1, V1, C2.');
        V2 = (C1*V1)/C2;
        const u = LToUnits(V2);
        out = `<div><b>V2</b> = ${u.L.toPrecision(6)} L (${u.mL.toPrecision(6)} mL, ${u.uL.toPrecision(6)} µL)</div>`;
      }
    }catch(err){ out = `<div class="alert alert-warning">${err.message}</div>`; }
    res.innerHTML = out;
  }
  function copyDilResult(){
    const el=document.getElementById('dilResult'); if(!el) return;
    const text=el.innerText || el.textContent || '';
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(text); }
  }
  function resetDilution(){ ['C1','V1','C2','V2'].forEach(id=>{ const el=document.getElementById(id); if(el) el.value=''; }); document.getElementById('dilResult').innerHTML=''; }

  // Preset and auto-calc bindings
  function applyPresetFromInput(){
    const raw=(document.getElementById('presetInput').value||'');
    const parts=raw.split('|'); if(parts.length<2) return;
    const mm=parseFloat(parts[1]); if(!isFinite(mm)) return;
    document.getElementById('molMM').value=mm;
    if(document.getElementById('autoMol').checked) calcMolarity();
  }
  (function(){
    const ids=['molSolve','molMass','molMassUnit','molMM','molVol','molVolUnit','molMoles'];
    ids.forEach(id=>{ const el=document.getElementById(id); if(el){ el.addEventListener('input', ()=>{ if(document.getElementById('autoMol').checked) calcMolarity(); }); }});
    const sel=document.getElementById('molSolve');
    if(sel){ sel.addEventListener('change', ()=>updateMolUI(true)); }
  const dids=['dilSolve','C1','C1u','V1','V1u','C2','C2u','V2','V2u'];
  dids.forEach(id=>{ const el=document.getElementById(id); if(el){ el.addEventListener('input', ()=>{ if(document.getElementById('autoDil').checked) calcDilution(); }); }});
  })();

  // Serial dilution planner: fold, steps, aliquot
  function planSerialDilution(){
    const fold=parseFloat(document.getElementById('sdFold').value||'');
    const steps=parseInt(document.getElementById('sdSteps').value||'');
    const aliquot=parseFloat(document.getElementById('sdAliquot').value||'');
    const out=document.getElementById('sdResult');
    if(!(fold>1 && steps>0 && aliquot>0)){ out.innerHTML='<div class="alert alert-warning">Enter fold (>1), steps, and aliquot (mL).</div>'; return; }
    let html='<div class="table-responsive"><table class="table table-sm"><thead><tr><th>Step</th><th>Aliquot</th><th>Diluent</th><th>Total</th><th>Factor</th></tr></thead><tbody>';
    for(let i=1;i<=steps;i++){
      // For a simple fold f serial dilution: mix aliquot a with (f-1)*a diluent
      const diluent=(fold-1)*aliquot;
      const total=fold*aliquot;
      const factor=Math.pow(fold,i);
      html+=`<tr><td>${i}</td><td>${aliquot} mL</td><td>${diluent} mL</td><td>${total} mL</td><td>${factor}×</td></tr>`;
    }
    html+='</tbody></table></div>';
    out.innerHTML=html;
  }

  // Conversions: derive mg/mL baseline then compute all
  function calcConversions(){
    const type=document.getElementById('convType').value;
    const val=parseFloat(document.getElementById('convVal').value||'');
    const mmIn=parseFloat(document.getElementById('convMM').value||'');
    const mm = isFinite(mmIn) && mmIn>0 ? mmIn : parseFloat(document.getElementById('molMM').value||'');
    const rho=parseFloat(document.getElementById('rho').value||'1') || 1.0; // g/mL
    const rhos=parseFloat(document.getElementById('rhoS').value||''); // g/mL
    const res=document.getElementById('convResult');

    if(!isFinite(val) || val<=0){ res.innerHTML='<div class="alert alert-warning">Enter a positive value.</div>'; return; }
    let mgmL=null;
    try{
      if(type==='M'){
        if(!(mm>0)) throw new Error('Provide molar mass for M conversions.');
        mgmL = val * mm; // since 1 g/L = 1 mg/mL
      } else if(type==='mgmL'){
        mgmL = val;
      } else if(type==='mgL'){
        mgmL = val/1000;
      } else if(type==='ppm'){
        // ppm = mg/kg; mg/L = ppm * (kg/L) = ppm * rho (kg/L)
        mgmL = (val * rho)/1000;
      } else if(type==='ppb'){
        mgmL = (val * rho)/1e6;
      } else if(type==='wv'){
        // % w/v = g per 100 mL
        mgmL = val * 10;
      } else if(type==='ww'){
        // % w/w to mg/mL uses solution density
        mgmL = val * 10 * rho;
      } else if(type==='vv'){
        if(!(rhos>0)) throw new Error('Provide solute density for %v/v conversions.');
        mgmL = val * 10 * rhos; // see derivation: 1% v/v ~ 10 mg/mL if rho_s=1
      }
      // now derive outputs
      const gL = mgmL; // numeric identity
      const M = (mm>0) ? (gL/mm) : NaN;
      const mgL = mgmL*1000;
      const ppm = mgL / rho; // mg/kg
      const ppb = ppm * 1000;
      const wv = mgmL/10; // %
      const ww = mgmL/(10*rho); // %
      const vv = (rhos>0)? (mgmL/(10*rhos)) : NaN;

      let html='<div class="table-responsive"><table class="table table-sm"><tbody>';
      if(isFinite(M)) html+=`<tr><th style="width:220px;">M (mol/L)</th><td>${M.toPrecision(6)}</td></tr>`;
      html+=`<tr><th>g/L</th><td>${gL.toPrecision(6)}</td></tr>`;
      html+=`<tr><th>mg/mL</th><td>${mgmL.toPrecision(6)}</td></tr>`;
      html+=`<tr><th>mg/L</th><td>${mgL.toPrecision(6)}</td></tr>`;
      html+=`<tr><th>ppm (mg/kg)</th><td>${ppm.toPrecision(6)}</td></tr>`;
      html+=`<tr><th>ppb (µg/kg)</th><td>${ppb.toPrecision(6)}</td></tr>`;
      html+=`<tr><th>% w/v</th><td>${wv.toPrecision(6)}%</td></tr>`;
      html+=`<tr><th>% w/w</th><td>${ww.toPrecision(6)}%</td></tr>`;
      if(isFinite(vv)) html+=`<tr><th>% v/v</th><td>${vv.toPrecision(6)}%</td></tr>`;
      html+='</tbody></table></div>';
      res.innerHTML=html;
    }catch(err){ res.innerHTML = `<div class="alert alert-warning">${err.message}</div>`; }
  }

  // Auto conversion listeners
  (function(){
    ['convType','convVal','convMM','rho','rhoS'].forEach(id=>{
      const el=document.getElementById(id); if(el){ el.addEventListener('input', ()=>{ if(document.getElementById('autoConv').checked) calcConversions(); }); }
    });
  })();

  // Guided mode UI for molarity
  function updateMolUI(recalc){
    const solve=document.getElementById('molSolve').value;
    const rowTarget=document.getElementById('rowTargetM');
    rowTarget.style.display = (solve==='mass' || solve==='vol' || solve==='moles') ? 'block' : 'none';
    if(recalc && document.getElementById('autoMol').checked) calcMolarity();
  }

  function useLastM(){
    try{
      if(window._lastM){
        const t=document.getElementById('molTargetM');
        if(t){ t.value = window._lastM; if(document.getElementById('autoMol').checked) calcMolarity(); }
      }
    }catch(e){}
  }

  // Share/Export helpers (molarity)
  function shareMol(){
    const params=new URLSearchParams(); params.set('tab','molarity');
    ['molSolve','molMass','molMassUnit','molMM','molVol','molVolUnit','molMoles','molTargetM'].forEach(id=>{ const el=document.getElementById(id); if(el && el.value!=='') params.set(id, el.value); });
    const url = window.location.origin + window.location.pathname + '?' + params.toString();
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(url); }
    history.replaceState({},'',url);
  }
  function copyMolLaTeX(){
    const solve=document.getElementById('molSolve').value;
    const tM=document.getElementById('molTargetM')?document.getElementById('molTargetM').value:'';
    let tex='';
    if(solve==='M') tex = 'M=\\frac{n}{V}=\\frac{m/\\mathrm{MM}}{V}';
    if(solve==='mass') tex = `m=M\\cdot V\\cdot \\mathrm{MM},\\ \ M=${tM}`;
    if(solve==='vol') tex = `V=\\frac{n}{M}=\\frac{m/\\mathrm{MM}}{M},\\ \ M=${tM}`;
    if(solve==='moles') tex = `n=M\\cdot V,\\ \ M=${tM}`;
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(tex); }
  }
  function exportMolPNG(){
    const el=document.getElementById('molResult'); const text=el? (el.innerText||'') : '';
    if(!text) return; const pad=20; const font='18px Arial';
    const tmp=document.createElement('canvas').getContext('2d'); tmp.font=font; const w=tmp.measureText(text).width; const h=30;
    const c=document.createElement('canvas'); c.width=Math.ceil(w)+pad*2; c.height=h+pad*2; const ctx=c.getContext('2d');
    ctx.fillStyle='#fff'; ctx.fillRect(0,0,c.width,c.height); ctx.fillStyle='#000'; ctx.font=font; ctx.fillText(text, pad, pad+h*0.7);
    const a=document.createElement('a'); a.href=c.toDataURL('image/png'); a.download='molarity-result.png'; a.click();
  }
  function buildRecipe(){
    const MM=parseFloat(document.getElementById('molMM').value||'');
    const res=document.getElementById('molResult');
    let tM = parseFloat(document.getElementById('molTargetM')?document.getElementById('molTargetM').value:'');
    const mass = parseFloat(document.getElementById('molMass').value||'');
    const massU = document.getElementById('molMassUnit').value;
    const molesIn = parseFloat(document.getElementById('molMoles').value||'');
    const volIn = parseFloat(document.getElementById('molVol').value||'');
    const volU = document.getElementById('molVolUnit').value;
    let L = volToL(volIn, volU);
    let g = massToG(mass, massU);
    let n = isFinite(molesIn)? molesIn : NaN;
    if(!isFinite(n) || n<=0){ if(isFinite(g) && isFinite(MM) && MM>0){ n = g / MM; } }
    if(!(tM>0) && (n>0) && (L>0)) { tM = n / L; }
    if(!(L>0) && (tM>0) && (n>0)) { L = n / tM; }
    if(!(MM>0)) { res.innerHTML += '<div class="alert alert-warning mt-2">Provide molar mass (g/mol).</div>'; return; }
    if(!(tM>0)) { res.innerHTML += '<div class="alert alert-warning mt-2">Provide Target M (or supply mass/moles and volume so M can be derived).</div>'; return; }
    if(!(L>0)) { res.innerHTML += '<div class="alert alert-warning mt-2">Provide Volume (or supply Target M and moles/mass so volume can be derived).</div>'; return; }
    const grams=(tM*L)*MM;
    const html=`<div class="mt-2"><h6>Preparation Recipe</h6>
      <ol>
        <li>Weigh <b>${grams.toPrecision(6)} g</b> of reagent.</li>
        <li>Transfer to a clean volumetric flask.</li>
        <li>Add solvent to <b>${L.toPrecision(6)} L</b> total volume and mix.</li>
        <li>Label: <em>${tM} M solution</em>.</li>
      </ol>
    </div>`;
    res.innerHTML += html;
  }

  // Load from URL params
  (function(){
    const p=new URLSearchParams(window.location.search);
    const tab=p.get('tab'); if(tab) switchMD(tab);
    ['molSolve','molMass','molMassUnit','molMM','molVol','molVolUnit','molMoles','molTargetM','dilSolve','C1','C1u','V1','V1u','C2','C2u','V2','V2u','sdFold','sdSteps','sdAliquot'].forEach(id=>{
      const el=document.getElementById(id); if(el && p.get(id)!=null) el.value=p.get(id);
    });
    updateMolUI(false);
  })();
</script>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Molarity + Dilution Calculator",
  "alternateName": ["Molarity Calculator", "Dilution Calculator", "C1V1=C2V2 Calculator"],
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "inLanguage": "en",
  "isAccessibleForFree": true,
  "url": "https://8gwifi.org/molarity-dilution-calculator.jsp",
  "image": "https://8gwifi.org/images/site/molarity-dilution.png",
  "description": "Free molarity and dilution calculator. Compute M, mass, volume, or moles; plan C1V1=C2V2; serial dilution ready; unit support.",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Molarity + Dilution Calculator",
  "url": "https://8gwifi.org/molarity-dilution-calculator.jsp",
  "description": "Compute molarity (M) and plan dilutions (C1V1=C2V2) with unit support.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "Molarity + Dilution Calculator", "item": "https://8gwifi.org/molarity-dilution-calculator.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Make a 1 M NaCl solution",
  "description": "Compute mass needed for a 1 L 1 M NaCl solution.",
  "totalTime": "PT1M",
  "step": [
    {"@type": "HowToStep", "name": "Enter molar mass", "text": "58.44 g/mol for NaCl."},
    {"@type": "HowToStep", "name": "Choose Solve for Mass", "text": "Target M = 1 mol/L, Volume = 1 L."},
    {"@type": "HowToStep", "name": "Calculate", "text": "Mass = 58.44 g."}
  ]
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
<%@ include file="footer_adsense.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
