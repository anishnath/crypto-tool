<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>pH Calculator | Strong/Weak Acid/Base + Buffer (Henderson-Hasselbalch) | Free | 8gwifi.org</title>
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/ph-calculator.jsp">
  <meta name="description" content="Free pH calculator for strong acids, weak acids, strong bases, weak bases, and buffers. Calculate pH, pOH, [H+], [OH-] using Henderson-Hasselbalch equation. No sign-up; runs in your browser.">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="8gwifi.org">
  <meta property="og:title" content="pH Calculator | Strong/Weak Acid/Base + Buffer (Free)">
  <meta property="og:description" content="Calculate pH for strong acids, weak acids, bases, and buffers. Henderson-Hasselbalch equation support. Free and browser-only.">
  <meta property="og:url" content="https://8gwifi.org/ph-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/ph-calculator.png">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@anish2good">
  <meta name="twitter:title" content="pH Calculator | Free Online Tool">
  <meta name="twitter:description" content="Calculate pH for acids, bases, and buffers. Henderson-Hasselbalch equation included.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/ph-calculator.png">

  <style>
    .min-h-result { min-height: 220px; max-height: 600px; overflow-y: auto; }
    @media (min-width: 992px) { .min-h-result { min-height: 280px; max-height: 70vh; } }
    .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; max-height: calc(100vh - 100px); }
    .sticky-side .card-body { overflow-y: auto; max-height: calc(100vh - 150px); }
    .monospace { font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
    .options-bar { display:flex; flex-wrap: wrap; gap: .75rem; align-items:center; }
    .ph-scale { height: 40px; background: linear-gradient(to right, #e74c3c 0%, #e67e22 14%, #f39c12 28%, #f1c40f 42%, #2ecc71 56%, #3498db 70%, #9b59b6 84%, #8e44ad 100%); border-radius: 8px; position: relative; margin: 1rem 0; }
    .ph-indicator { position: absolute; top: -10px; width: 4px; height: 60px; background: #2c3e50; transition: left 0.3s ease; }
    .ph-value { position: absolute; top: 45px; transform: translateX(-50%); font-weight: 600; font-size: 0.9rem; color: #2c3e50; }
    .result-badge { display: inline-block; padding: .5rem .8rem; background: #e6f4ea; color: #0f5132; border: 1px solid #badbcc; border-radius: .35rem; font-weight: 600; font-size: 1.1rem; margin: .25rem; }
    .result-section { margin-bottom: 1rem; padding: .75rem; background: #f8f9fa; border-radius: .35rem; }
    .formula-badge { font-family: monospace; background: #fff3cd; padding: .25rem .5rem; border-radius: .25rem; font-size: 0.9rem; }
    .preset-chip { display: inline-block; padding: .25rem .5rem; margin: .25rem; background: #e7f3ff; border: 1px solid #b3d9ff; border-radius: 16px; cursor: pointer; font-size: 0.85rem; }
    .preset-chip:hover { background: #cce5ff; }
    .info-table td { padding: .35rem .5rem; }
    .info-table th { padding: .35rem .5rem; font-weight: 600; }
  </style>
  <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>
<div class="container mt-5">
  <h1 class="mb-3">pH Calculator</h1>
  <p class="lead mb-4">Calculate pH, pOH, [H<sup>+</sup>], and [OH<sup>−</sup>] for strong acids, weak acids, strong bases, weak bases, and buffers using the Henderson-Hasselbalch equation.</p>

  <!-- Tabs -->
  <ul class="nav nav-tabs mb-3" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" id="tab-calc" href="#" role="tab" onclick="switchTab('calc'); return false;">Calculator</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-convert" href="#" role="tab" onclick="switchTab('convert'); return false;">pH ↔ Concentration</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-buffer" href="#" role="tab" onclick="switchTab('buffer'); return false;">Buffer (Henderson-Hasselbalch)</a>
    </li>
  </ul>

  <div id="sectionCalc">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Input</h5>

          <div class="form-group">
            <label for="calcType">Type</label>
            <select id="calcType" class="form-control" onchange="updateCalcUI()">
              <option value="strong-acid">Strong Acid</option>
              <option value="weak-acid">Weak Acid</option>
              <option value="strong-base">Strong Base</option>
              <option value="weak-base">Weak Base</option>
            </select>
          </div>

          <div class="form-group">
            <label for="concentration">Concentration (M)</label>
            <input type="number" id="concentration" class="form-control" placeholder="e.g., 0.1" step="any" oninput="if(autoCalc.checked) calculatePH()">
          </div>

          <div class="form-group" id="kaGroup" style="display:none;">
            <label for="ka">K<sub>a</sub> (Acid Dissociation Constant)</label>
            <input type="number" id="ka" class="form-control" placeholder="e.g., 1.8e-5" step="any" oninput="if(autoCalc.checked) calculatePH()">
            <small class="form-text text-muted">Use scientific notation (e.g., 1.8e-5)</small>
          </div>

          <div class="form-group" id="kbGroup" style="display:none;">
            <label for="kb">K<sub>b</sub> (Base Dissociation Constant)</label>
            <input type="number" id="kb" class="form-control" placeholder="e.g., 1.8e-5" step="any" oninput="if(autoCalc.checked) calculatePH()">
            <small class="form-text text-muted">Use scientific notation (e.g., 1.8e-5)</small>
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="autoCalc" checked>
            <label class="form-check-label" for="autoCalc">Auto-calculate</label>
          </div>

          <div class="mb-3">
            <small class="text-muted d-block mb-2">Common Weak Acids (click to load):</small>
            <div id="acidPresets">
              <span class="preset-chip" onclick="loadPreset('acetic', 1.8e-5)">Acetic acid (CH₃COOH, Ka=1.8×10⁻⁵)</span>
              <span class="preset-chip" onclick="loadPreset('formic', 1.8e-4)">Formic acid (HCOOH, Ka=1.8×10⁻⁴)</span>
              <span class="preset-chip" onclick="loadPreset('hf', 6.8e-4)">Hydrofluoric acid (HF, Ka=6.8×10⁻⁴)</span>
              <span class="preset-chip" onclick="loadPreset('hypochlorous', 3.5e-8)">Hypochlorous acid (HOCl, Ka=3.5×10⁻⁸)</span>
              <span class="preset-chip" onclick="loadPreset('benzoic', 6.3e-5)">Benzoic acid (C₆H₅COOH, Ka=6.3×10⁻⁵)</span>
            </div>
            <small class="text-muted d-block mt-2 mb-2">Common Weak Bases (click to load):</small>
            <div id="basePresets">
              <span class="preset-chip" onclick="loadPreset('ammonia', 1.8e-5, true)">Ammonia (NH₃, Kb=1.8×10⁻⁵)</span>
              <span class="preset-chip" onclick="loadPreset('methylamine', 4.4e-4, true)">Methylamine (CH₃NH₂, Kb=4.4×10⁻⁴)</span>
              <span class="preset-chip" onclick="loadPreset('pyridine', 1.7e-9, true)">Pyridine (C₅H₅N, Kb=1.7×10⁻⁹)</span>
              <span class="preset-chip" onclick="loadPreset('aniline', 7.4e-10, true)">Aniline (C₆H₅NH₂, Kb=7.4×10⁻¹⁰)</span>
            </div>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculatePH()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetCalc()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyResult()">📋 Copy</button>
            <button class="btn btn-outline-secondary" onclick="copyLaTeX()">𝛌 LaTeX</button>
            <button class="btn btn-outline-secondary" onclick="exportPNG()">🖼 PNG</button>
            <button class="btn btn-outline-secondary" onclick="shareLink()">🔗 Share</button>
          </div>

          <div class="small text-muted">
            <div>pH = -log[H<sup>+</sup>] &nbsp;|&nbsp; pOH = -log[OH<sup>−</sup>] &nbsp;|&nbsp; pH + pOH = 14</div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="result" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- Convert Tab -->
  <div id="sectionConvert" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">pH ↔ Concentration Converter</h5>

          <div class="form-group">
            <label for="convertType">Convert from</label>
            <select id="convertType" class="form-control">
              <option value="ph">pH to [H+] and [OH-]</option>
              <option value="poh">pOH to [H+] and [OH-]</option>
              <option value="h">[H+] to pH and pOH</option>
              <option value="oh">[OH-] to pH and pOH</option>
            </select>
          </div>

          <div class="form-group">
            <label for="convertValue">Value</label>
            <input type="number" id="convertValue" class="form-control" placeholder="e.g., 7" step="any" oninput="if(autoConvert.checked) convertPH()">
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="autoConvert" checked>
            <label class="form-check-label" for="autoConvert">Auto-convert</label>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="convertPH()">Convert</button>
            <button class="btn btn-outline-secondary" onclick="resetConvert()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyConvertResult()">📋 Copy</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="convertResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- Buffer Tab -->
  <div id="sectionBuffer" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Buffer pH (Henderson-Hasselbalch)</h5>
          <p class="text-muted small">pH = pKa + log([A<sup>−</sup>]/[HA]) &nbsp;or&nbsp; pOH = pKb + log([BH<sup>+</sup>]/[B])</p>

          <div class="form-group">
            <label for="bufferType">Buffer Type</label>
            <select id="bufferType" class="form-control" onchange="updateBufferUI()">
              <option value="acid">Weak Acid + Conjugate Base</option>
              <option value="base">Weak Base + Conjugate Acid</option>
            </select>
          </div>

          <div class="form-group" id="pkaGroup">
            <label for="pka">pKa</label>
            <input type="number" id="pka" class="form-control" placeholder="e.g., 4.76" step="any" oninput="if(autoBuffer.checked) calculateBuffer()">
          </div>

          <div class="form-group" id="pkbGroup" style="display:none;">
            <label for="pkb">pKb</label>
            <input type="number" id="pkb" class="form-control" placeholder="e.g., 4.76" step="any" oninput="if(autoBuffer.checked) calculateBuffer()">
          </div>

          <div class="form-row">
            <div class="form-group col-md-6" id="acidGroup">
              <label for="acidConc">[HA] Acid (M)</label>
              <input type="number" id="acidConc" class="form-control" placeholder="e.g., 0.1" step="any" oninput="if(autoBuffer.checked) calculateBuffer()">
            </div>
            <div class="form-group col-md-6" id="baseGroup">
              <label for="baseConc">[A<sup>−</sup>] Base (M)</label>
              <input type="number" id="baseConc" class="form-control" placeholder="e.g., 0.1" step="any" oninput="if(autoBuffer.checked) calculateBuffer()">
            </div>
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="autoBuffer" checked>
            <label class="form-check-label" for="autoBuffer">Auto-calculate</label>
          </div>

          <div class="mb-3">
            <small class="text-muted d-block mb-2">Common Buffer Systems:</small>
            <span class="preset-chip" onclick="loadBufferPreset('acetate', 4.76)">Acetate (pKa=4.76)</span>
            <span class="preset-chip" onclick="loadBufferPreset('phosphate', 7.21)">Phosphate (pKa=7.21)</span>
            <span class="preset-chip" onclick="loadBufferPreset('carbonate', 10.33)">Carbonate (pKa=10.33)</span>
            <span class="preset-chip" onclick="loadBufferPreset('ammonia', 9.25)">Ammonia (pKa=9.25)</span>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateBuffer()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetBuffer()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyBufferResult()">📋 Copy</button>
          </div>

          <div class="small text-muted">
            <div class="formula-badge">Henderson-Hasselbalch: pH = pKa + log([A<sup>−</sup>]/[HA])</div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="bufferResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>
</div>

<!-- Learn Section -->
<div class="container mt-4">
  <div id="learn" class="card shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3">What Is pH?</h5>
      <p>pH is a measure of the acidity or basicity of a solution, defined as <strong>pH = -log[H<sup>+</sup>]</strong>. The pH scale ranges from 0 (very acidic) to 14 (very basic), with 7 being neutral at 25°C.</p>

      <h6 class="mt-4">Key Relationships</h6>
      <ul class="mb-3">
        <li><strong>pH + pOH = 14</strong> (at 25°C)</li>
        <li><strong>[H<sup>+</sup>][OH<sup>−</sup>] = 1.0 × 10<sup>−14</sup></strong> (K<sub>w</sub>, water ionization constant)</li>
        <li><strong>pH = -log[H<sup>+</sup>]</strong></li>
        <li><strong>pOH = -log[OH<sup>−</sup>]</strong></li>
        <li><strong>pKa = -log(Ka)</strong></li>
      </ul>

      <h6>Strong vs. Weak Acids/Bases</h6>
      <ul class="mb-3">
        <li><strong>Strong acids</strong> (HCl, HNO₃, H₂SO₄) completely dissociate: pH ≈ -log[HA]</li>
        <li><strong>Weak acids</strong> partially dissociate: pH = ½(pKa - log[HA])</li>
        <li><strong>Strong bases</strong> (NaOH, KOH) completely dissociate: pOH ≈ -log[Base]</li>
        <li><strong>Weak bases</strong> partially dissociate: pOH = ½(pKb - log[B])</li>
      </ul>

      <h5 class="mt-3 mb-2">Worked Examples</h5>

      <div class="mb-3">
        <p class="mb-1"><strong>1) Strong Acid: 0.01 M HCl</strong></p>
        <p class="mb-1">HCl completely dissociates → [H<sup>+</sup>] = 0.01 M</p>
        <p class="mb-1">pH = -log(0.01) = <strong>2.0</strong></p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>2) Weak Acid: 0.1 M Acetic Acid (Ka = 1.8×10<sup>−5</sup>)</strong></p>
        <p class="mb-1">Using approximation: [H<sup>+</sup>] ≈ √(Ka × C) = √(1.8×10<sup>−5</sup> × 0.1) = 1.34×10<sup>−3</sup> M</p>
        <p class="mb-1">pH = -log(1.34×10<sup>−3</sup>) = <strong>2.87</strong></p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>3) Buffer: 0.1 M CH₃COOH + 0.1 M CH₃COO<sup>−</sup> (pKa = 4.76)</strong></p>
        <p class="mb-1">Henderson-Hasselbalch: pH = 4.76 + log(0.1/0.1) = 4.76 + 0 = <strong>4.76</strong></p>
        <p class="mb-1">When [acid] = [base], pH = pKa</p>
      </div>

      <h6 class="mt-4">pH Scale Reference</h6>
      <div class="table-responsive">
        <table class="table table-sm info-table">
          <thead>
            <tr><th>pH Range</th><th>Classification</th><th>Examples</th></tr>
          </thead>
          <tbody>
            <tr><td>0-3</td><td>Strongly acidic</td><td>Stomach acid (1-2), Lemon juice (2)</td></tr>
            <tr><td>3-6</td><td>Weakly acidic</td><td>Coffee (5), Rainwater (5.5)</td></tr>
            <tr><td>6-8</td><td>Neutral</td><td>Pure water (7), Blood (7.4)</td></tr>
            <tr><td>8-11</td><td>Weakly basic</td><td>Baking soda (9), Milk of magnesia (10)</td></tr>
            <tr><td>11-14</td><td>Strongly basic</td><td>Ammonia (11), Bleach (13)</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
const Kw = 1e-14; // Water ionization constant at 25°C

function switchTab(which){
  const calc=document.getElementById('sectionCalc');
  const convert=document.getElementById('sectionConvert');
  const buffer=document.getElementById('sectionBuffer');
  const tc=document.getElementById('tab-calc');
  const tcv=document.getElementById('tab-convert');
  const tb=document.getElementById('tab-buffer');

  if(which==='convert'){
    calc.style.display='none'; convert.style.display='block'; buffer.style.display='none';
    tc.classList.remove('active'); tcv.classList.add('active'); tb.classList.remove('active');
  } else if(which==='buffer'){
    calc.style.display='none'; convert.style.display='none'; buffer.style.display='block';
    tc.classList.remove('active'); tcv.classList.remove('active'); tb.classList.add('active');
  } else {
    convert.style.display='none'; buffer.style.display='none'; calc.style.display='block';
    tcv.classList.remove('active'); tb.classList.remove('active'); tc.classList.add('active');
  }
}

function updateCalcUI(){
  const type = document.getElementById('calcType').value;
  const kaGroup = document.getElementById('kaGroup');
  const kbGroup = document.getElementById('kbGroup');

  kaGroup.style.display = (type === 'weak-acid') ? 'block' : 'none';
  kbGroup.style.display = (type === 'weak-base') ? 'block' : 'none';

  if(document.getElementById('autoCalc').checked) calculatePH();
}

function updateBufferUI(){
  const type = document.getElementById('bufferType').value;
  const pkaGroup = document.getElementById('pkaGroup');
  const pkbGroup = document.getElementById('pkbGroup');

  pkaGroup.style.display = (type === 'acid') ? 'block' : 'none';
  pkbGroup.style.display = (type === 'base') ? 'block' : 'none';

  const acidLabel = document.querySelector('#acidGroup label');
  const baseLabel = document.querySelector('#baseGroup label');

  if(type === 'acid'){
    acidLabel.innerHTML = '[HA] Acid (M)';
    baseLabel.innerHTML = '[A<sup>−</sup>] Base (M)';
  } else {
    acidLabel.innerHTML = '[B] Base (M)';
    baseLabel.innerHTML = '[BH<sup>+</sup>] Acid (M)';
  }
}

function loadPreset(name, k, isBase = false){
  if(isBase){
    document.getElementById('calcType').value = 'weak-base';
    document.getElementById('kb').value = k;
  } else {
    document.getElementById('calcType').value = 'weak-acid';
    document.getElementById('ka').value = k;
  }
  updateCalcUI();
}

function loadBufferPreset(name, pka){
  document.getElementById('pka').value = pka;
  if(document.getElementById('autoBuffer').checked) calculateBuffer();
}

function calculatePH(){
  const type = document.getElementById('calcType').value;
  const C = parseFloat(document.getElementById('concentration').value);
  const Ka = parseFloat(document.getElementById('ka').value);
  const Kb = parseFloat(document.getElementById('kb').value);
  const res = document.getElementById('result');

  if(!C || C <= 0){
    res.innerHTML = '<div class="alert alert-warning">Enter a valid concentration</div>';
    return;
  }

  let pH, pOH, H, OH;
  let steps = '';

  try {
    if(type === 'strong-acid'){
      H = C;
      pH = -Math.log10(H);
      pOH = 14 - pH;
      OH = Math.pow(10, -pOH);
      steps = `<div class="result-section">
        <strong>Strong Acid:</strong> Complete dissociation
        <div class="mt-2">[H<sup>+</sup>] = ${C} M</div>
        <div>pH = -log(${C}) = ${pH.toFixed(4)}</div>
      </div>`;
    } else if(type === 'weak-acid'){
      if(!Ka || Ka <= 0){
        res.innerHTML = '<div class="alert alert-warning">Enter a valid Ka value</div>';
        return;
      }
      // Approximation: [H+] ≈ sqrt(Ka * C) when Ka << C and C/Ka > 100
      H = Math.sqrt(Ka * C);
      // More accurate if needed: solve quadratic
      if(H/C > 0.05){ // Use quadratic if approximation not valid
        H = (-Ka + Math.sqrt(Ka*Ka + 4*Ka*C)) / 2;
      }
      pH = -Math.log10(H);
      pOH = 14 - pH;
      OH = Kw / H;
      const pKa = -Math.log10(Ka);
      steps = `<div class="result-section">
        <strong>Weak Acid:</strong> Partial dissociation
        <div class="mt-2">Ka = ${Ka.toExponential(2)}, pKa = ${pKa.toFixed(2)}</div>
        <div>[H<sup>+</sup>] ≈ √(Ka × C) = ${H.toExponential(3)} M</div>
        <div>pH = -log(${H.toExponential(3)}) = ${pH.toFixed(4)}</div>
      </div>`;
    } else if(type === 'strong-base'){
      OH = C;
      pOH = -Math.log10(OH);
      pH = 14 - pOH;
      H = Math.pow(10, -pH);
      steps = `<div class="result-section">
        <strong>Strong Base:</strong> Complete dissociation
        <div class="mt-2">[OH<sup>−</sup>] = ${C} M</div>
        <div>pOH = -log(${C}) = ${pOH.toFixed(4)}</div>
        <div>pH = 14 - pOH = ${pH.toFixed(4)}</div>
      </div>`;
    } else if(type === 'weak-base'){
      if(!Kb || Kb <= 0){
        res.innerHTML = '<div class="alert alert-warning">Enter a valid Kb value</div>';
        return;
      }
      OH = Math.sqrt(Kb * C);
      if(OH/C > 0.05){
        OH = (-Kb + Math.sqrt(Kb*Kb + 4*Kb*C)) / 2;
      }
      pOH = -Math.log10(OH);
      pH = 14 - pOH;
      H = Kw / OH;
      const pKb = -Math.log10(Kb);
      steps = `<div class="result-section">
        <strong>Weak Base:</strong> Partial dissociation
        <div class="mt-2">Kb = ${Kb.toExponential(2)}, pKb = ${pKb.toFixed(2)}</div>
        <div>[OH<sup>−</sup>] ≈ √(Kb × C) = ${OH.toExponential(3)} M</div>
        <div>pOH = -log(${OH.toExponential(3)}) = ${pOH.toFixed(4)}</div>
        <div>pH = 14 - pOH = ${pH.toFixed(4)}</div>
      </div>`;
    }

    const scaleHTML = renderPHScale(pH);
    const resultHTML = `
      ${steps}
      <div class="result-section">
        <strong>Results:</strong>
        <div class="mt-2">
          <span class="result-badge">pH = ${pH.toFixed(4)}</span>
          <span class="result-badge">pOH = ${pOH.toFixed(4)}</span>
        </div>
        <div class="mt-2">
          <div>[H<sup>+</sup>] = ${H.toExponential(4)} M</div>
          <div>[OH<sup>−</sup>] = ${OH.toExponential(4)} M</div>
        </div>
      </div>
      ${scaleHTML}
    `;

    res.innerHTML = resultHTML;
    res.dataset.result = `pH = ${pH.toFixed(4)}, pOH = ${pOH.toFixed(4)}, [H+] = ${H.toExponential(4)} M, [OH-] = ${OH.toExponential(4)} M`;
    res.dataset.latex = generateLaTeX(type, pH, pOH, H, OH, C, Ka, Kb);

  } catch(e){
    res.innerHTML = '<div class="alert alert-danger">Error calculating pH</div>';
  }
}

function convertPH(){
  const type = document.getElementById('convertType').value;
  const val = parseFloat(document.getElementById('convertValue').value);
  const res = document.getElementById('convertResult');

  if(!isFinite(val) || val < 0){
    res.innerHTML = '<div class="alert alert-warning">Enter a valid value</div>';
    return;
  }

  let pH, pOH, H, OH;

  if(type === 'ph'){
    pH = val;
    pOH = 14 - pH;
    H = Math.pow(10, -pH);
    OH = Math.pow(10, -pOH);
  } else if(type === 'poh'){
    pOH = val;
    pH = 14 - pOH;
    H = Math.pow(10, -pH);
    OH = Math.pow(10, -pOH);
  } else if(type === 'h'){
    H = val;
    pH = -Math.log10(H);
    pOH = 14 - pH;
    OH = Kw / H;
  } else if(type === 'oh'){
    OH = val;
    pOH = -Math.log10(OH);
    pH = 14 - pOH;
    H = Kw / OH;
  }

  const scaleHTML = renderPHScale(pH);
  const resultHTML = `
    <div class="result-section">
      <strong>Results:</strong>
      <div class="mt-2">
        <span class="result-badge">pH = ${pH.toFixed(4)}</span>
        <span class="result-badge">pOH = ${pOH.toFixed(4)}</span>
      </div>
      <div class="mt-2">
        <div>[H<sup>+</sup>] = ${H.toExponential(4)} M</div>
        <div>[OH<sup>−</sup>] = ${OH.toExponential(4)} M</div>
      </div>
    </div>
    ${scaleHTML}
  `;

  res.innerHTML = resultHTML;
  res.dataset.result = `pH = ${pH.toFixed(4)}, pOH = ${pOH.toFixed(4)}`;
}

function calculateBuffer(){
  const type = document.getElementById('bufferType').value;
  const pKa = parseFloat(document.getElementById('pka').value);
  const pKb = parseFloat(document.getElementById('pkb').value);
  const acid = parseFloat(document.getElementById('acidConc').value);
  const base = parseFloat(document.getElementById('baseConc').value);
  const res = document.getElementById('bufferResult');

  if(!acid || !base || acid <= 0 || base <= 0){
    res.innerHTML = '<div class="alert alert-warning">Enter valid concentrations</div>';
    return;
  }

  let pH, pOH;
  let steps = '';

  if(type === 'acid'){
    if(!pKa || !isFinite(pKa)){
      res.innerHTML = '<div class="alert alert-warning">Enter a valid pKa</div>';
      return;
    }
    pH = pKa + Math.log10(base / acid);
    pOH = 14 - pH;
    steps = `<div class="result-section">
      <strong>Henderson-Hasselbalch (Acidic Buffer):</strong>
      <div class="mt-2">pH = pKa + log([A<sup>−</sup>]/[HA])</div>
      <div>pH = ${pKa} + log(${base}/${acid})</div>
      <div>pH = ${pKa} + ${Math.log10(base/acid).toFixed(4)}</div>
      <div>pH = ${pH.toFixed(4)}</div>
    </div>`;
  } else {
    if(!pKb || !isFinite(pKb)){
      res.innerHTML = '<div class="alert alert-warning">Enter a valid pKb</div>';
      return;
    }
    pOH = pKb + Math.log10(base / acid);
    pH = 14 - pOH;
    steps = `<div class="result-section">
      <strong>Henderson-Hasselbalch (Basic Buffer):</strong>
      <div class="mt-2">pOH = pKb + log([BH<sup>+</sup>]/[B])</div>
      <div>pOH = ${pKb} + log(${base}/${acid})</div>
      <div>pOH = ${pKb} + ${Math.log10(base/acid).toFixed(4)}</div>
      <div>pOH = ${pOH.toFixed(4)}</div>
      <div>pH = 14 - ${pOH.toFixed(4)} = ${pH.toFixed(4)}</div>
    </div>`;
  }

  const H = Math.pow(10, -pH);
  const OH = Math.pow(10, -pOH);
  const scaleHTML = renderPHScale(pH);

  const resultHTML = `
    ${steps}
    <div class="result-section">
      <strong>Results:</strong>
      <div class="mt-2">
        <span class="result-badge">pH = ${pH.toFixed(4)}</span>
        <span class="result-badge">pOH = ${pOH.toFixed(4)}</span>
      </div>
      <div class="mt-2">
        <div>[H<sup>+</sup>] = ${H.toExponential(4)} M</div>
        <div>[OH<sup>−</sup>] = ${OH.toExponential(4)} M</div>
      </div>
    </div>
    ${scaleHTML}
  `;

  res.innerHTML = resultHTML;
  res.dataset.result = `Buffer pH = ${pH.toFixed(4)}`;
}

function renderPHScale(pH){
  const percent = Math.max(0, Math.min(100, (pH / 14) * 100));
  return `
    <div class="mt-3">
      <strong>pH Scale:</strong>
      <div class="ph-scale">
        <div class="ph-indicator" style="left: ${percent}%"></div>
        <div class="ph-value" style="left: ${percent}%">${pH.toFixed(2)}</div>
      </div>
      <div class="d-flex justify-content-between small text-muted">
        <span>0 (Acidic)</span>
        <span>7 (Neutral)</span>
        <span>14 (Basic)</span>
      </div>
    </div>
  `;
}

function generateLaTeX(type, pH, pOH, H, OH, C, Ka, Kb){
  let tex = '';
  if(type === 'strong-acid'){
    tex = `\\text{pH} = -\\log[\\text{H}^+] = -\\log(${C}) = ${pH.toFixed(2)}`;
  } else if(type === 'weak-acid'){
    tex = `\\text{pH} = \\frac{1}{2}(\\text{pKa} - \\log C),\\quad \\text{pKa} = ${(-Math.log10(Ka)).toFixed(2)}`;
  } else if(type === 'strong-base'){
    tex = `\\text{pOH} = -\\log[\\text{OH}^-] = ${pOH.toFixed(2)},\\quad \\text{pH} = 14 - \\text{pOH} = ${pH.toFixed(2)}`;
  } else if(type === 'weak-base'){
    tex = `\\text{pOH} = \\frac{1}{2}(\\text{pKb} - \\log C),\\quad \\text{pKb} = ${(-Math.log10(Kb)).toFixed(2)}`;
  }
  return tex;
}

function resetCalc(){
  document.getElementById('concentration').value = '';
  document.getElementById('ka').value = '';
  document.getElementById('kb').value = '';
  document.getElementById('result').innerHTML = '';
}

function resetConvert(){
  document.getElementById('convertValue').value = '';
  document.getElementById('convertResult').innerHTML = '';
}

function resetBuffer(){
  document.getElementById('pka').value = '';
  document.getElementById('pkb').value = '';
  document.getElementById('acidConc').value = '';
  document.getElementById('baseConc').value = '';
  document.getElementById('bufferResult').innerHTML = '';
}

function copyResult(){
  const el = document.getElementById('result');
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

function copyConvertResult(){
  const el = document.getElementById('convertResult');
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

function copyBufferResult(){
  const el = document.getElementById('bufferResult');
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

function copyLaTeX(){
  const el = document.getElementById('result');
  const tex = el.dataset.latex || '';
  if(tex && navigator.clipboard) navigator.clipboard.writeText(tex);
}

function exportPNG(){
  const el = document.getElementById('result');
  const text = el.dataset.result || el.innerText || '';
  if(!text) return;

  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  const baseFont = 20;
  const superFont = 14;
  ctx.font = `${baseFont}px Arial`;

  const lines = text.split(',').map(s => s.trim()).filter(l => l);

  // Calculate max width
  let maxWidth = 0;
  lines.forEach(line => {
    const w = ctx.measureText(line).width;
    maxWidth = Math.max(maxWidth, w);
  });

  const lineHeight = 30;
  const pad = 30;
  canvas.width = maxWidth + pad * 2;
  canvas.height = lines.length * lineHeight + pad * 2;

  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#000000';
  ctx.font = `${baseFont}px Arial`;

  lines.forEach((line, i) => {
    ctx.fillText(line, pad, pad + (i + 1) * lineHeight);
  });

  const a = document.createElement('a');
  a.href = canvas.toDataURL('image/png');
  a.download = 'ph-result.png';
  a.click();
}

function shareLink(){
  const params = new URLSearchParams();
  const type = document.getElementById('calcType').value;
  const conc = document.getElementById('concentration').value;
  const ka = document.getElementById('ka').value;
  const kb = document.getElementById('kb').value;

  params.set('type', type);
  if(conc) params.set('c', conc);
  if(ka) params.set('ka', ka);
  if(kb) params.set('kb', kb);

  const url = window.location.origin + window.location.pathname + '?' + params.toString();
  if(navigator.clipboard) navigator.clipboard.writeText(url);
  window.history.replaceState({}, '', url);
}

// Load from URL
(function(){
  const params = new URLSearchParams(window.location.search);
  const type = params.get('type');
  const c = params.get('c');
  const ka = params.get('ka');
  const kb = params.get('kb');

  if(type) document.getElementById('calcType').value = type;
  if(c) document.getElementById('concentration').value = c;
  if(ka) document.getElementById('ka').value = ka;
  if(kb) document.getElementById('kb').value = kb;

  updateCalcUI();
  if(c && (type === 'strong-acid' || type === 'strong-base' || (type === 'weak-acid' && ka) || (type === 'weak-base' && kb))){
    calculatePH();
  }
})();
</script>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "pH Calculator",
  "alternateName": ["pH Calculator Online", "Acid Base Calculator", "Henderson-Hasselbalch Calculator"],
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "inLanguage": "en",
  "isAccessibleForFree": true,
  "url": "https://8gwifi.org/ph-calculator.jsp",
  "image": "https://8gwifi.org/images/site/ph-calculator.png",
  "description": "Free pH calculator for strong acids, weak acids, bases, and buffers. Calculate pH, pOH, [H+], [OH-] with Henderson-Hasselbalch equation support.",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org"
  }
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "pH Calculator",
  "url": "https://8gwifi.org/ph-calculator.jsp",
  "description": "Calculate pH, pOH, and concentrations for acids, bases, and buffers.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "pH Calculator", "item": "https://8gwifi.org/ph-calculator.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "What is pH?", "acceptedAnswer": {"@type": "Answer", "text": "pH is a measure of acidity or basicity, defined as pH = -log[H+]. The scale ranges from 0 (acidic) to 14 (basic)."}},
    {"@type": "Question", "name": "How do you calculate pH of a strong acid?", "acceptedAnswer": {"@type": "Answer", "text": "For strong acids that completely dissociate, pH = -log[H+] where [H+] equals the acid concentration."}},
    {"@type": "Question", "name": "What is the Henderson-Hasselbalch equation?", "acceptedAnswer": {"@type": "Answer", "text": "The Henderson-Hasselbalch equation is pH = pKa + log([A-]/[HA]), used to calculate the pH of buffer solutions."}}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Calculate pH of a weak acid",
  "description": "Step-by-step guide to calculate pH of weak acids",
  "totalTime": "PT2M",
  "step": [
    {"@type": "HowToStep", "name": "Enter concentration", "text": "Input the molarity of the weak acid solution."},
    {"@type": "HowToStep", "name": "Enter Ka", "text": "Input the acid dissociation constant (Ka) for the weak acid."},
    {"@type": "HowToStep", "name": "Calculate", "text": "Click Calculate to get pH using the approximation [H+] = sqrt(Ka × C)."}
  ]
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>