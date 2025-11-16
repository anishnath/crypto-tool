<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Stoichiometry Calculator | Limiting Reactant + Percent Yield + Mole Conversions | Free | 8gwifi.org</title>
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/stoichiometry-calculator.jsp">
  <meta name="description" content="Free stoichiometry calculator. Convert grams ↔ moles ↔ molecules/atoms, find limiting reactant, calculate theoretical/actual/percent yield. Supports balanced equations. No sign-up; runs in your browser.">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="8gwifi.org">
  <meta property="og:title" content="Stoichiometry Calculator | Limiting Reactant + Yield (Free)">
  <meta property="og:description" content="Calculate moles, mass, molecules. Find limiting reactant and percent yield. Free and browser-only.">
  <meta property="og:url" content="https://8gwifi.org/stoichiometry-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/stoichiometry.png">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@anish2good">
  <meta name="twitter:title" content="Stoichiometry Calculator | Free Online Tool">
  <meta name="twitter:description" content="Convert grams, moles, and molecules. Find limiting reactant and calculate yield.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/stoichiometry.png">

  <style>
    .min-h-result { min-height: 220px; max-height: 600px; overflow-y: auto; }
    @media (min-width: 992px) { .min-h-result { min-height: 280px; max-height: 70vh; } }
    .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; max-height: calc(100vh - 100px); }
    .sticky-side .card-body { overflow-y: auto; max-height: calc(100vh - 150px); }
    .options-bar { display:flex; flex-wrap: wrap; gap: .75rem; align-items:center; }
    .result-badge { display: inline-block; padding: .5rem .8rem; background: #e6f4ea; color: #0f5132; border: 1px solid #badbcc; border-radius: .35rem; font-weight: 600; font-size: 1.1rem; margin: .25rem; }
    .result-section { margin-bottom: 1rem; padding: .75rem; background: #f8f9fa; border-radius: .35rem; }
    .formula-badge { font-family: monospace; background: #fff3cd; padding: .25rem .5rem; border-radius: .25rem; font-size: 0.9rem; }
    .limiting-reactant { background: #fee; border-left: 4px solid #dc3545; }
    .excess-reactant { background: #efe; border-left: 4px solid #28a745; }
    .conversion-flow { display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap; margin: 0.5rem 0; }
    .conversion-arrow { font-size: 1.2rem; color: #6c757d; }
    .preset-reaction { display: inline-block; padding: .35rem .6rem; margin: .25rem; background: #e7f3ff; border: 1px solid #b3d9ff; border-radius: .35rem; cursor: pointer; font-size: 0.85rem; }
    .preset-reaction:hover { background: #cce5ff; }
  </style>
  <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>
<div class="container mt-5">
  <h1 class="mb-3">Stoichiometry Calculator</h1>
  <p class="lead mb-4">Convert between grams, moles, and molecules/atoms. Find limiting reactants, calculate theoretical and percent yield using balanced chemical equations.</p>

  <!-- Tabs -->
  <ul class="nav nav-tabs mb-3" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" id="tab-convert" href="#" role="tab" onclick="switchTab('convert'); return false;">Mole Conversions</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-limiting" href="#" role="tab" onclick="switchTab('limiting'); return false;">Limiting Reactant</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-yield" href="#" role="tab" onclick="switchTab('yield'); return false;">Percent Yield</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-equation" href="#" role="tab" onclick="switchTab('equation'); return false;">From Equation</a>
    </li>
  </ul>

  <div id="sectionConvert">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Mole Conversions</h5>
          <p class="text-muted small">Convert: Grams ↔ Moles ↔ Molecules/Atoms/Formula Units</p>

          <div class="form-group">
            <label for="conversionType">Conversion Type</label>
            <select id="conversionType" class="form-control" onchange="updateConversionUI()">
              <option value="gram-to-mole">Grams → Moles</option>
              <option value="mole-to-gram">Moles → Grams</option>
              <option value="mole-to-molecules">Moles → Molecules/Atoms</option>
              <option value="molecules-to-mole">Molecules/Atoms → Moles</option>
              <option value="gram-to-molecules">Grams → Molecules/Atoms</option>
              <option value="molecules-to-gram">Molecules/Atoms → Grams</option>
            </select>
          </div>

          <div class="form-group" id="gramGroup">
            <label for="grams">Mass (grams)</label>
            <input type="number" id="grams" class="form-control" placeholder="e.g., 18" step="any">
          </div>

          <div class="form-group" id="moleGroup" style="display:none;">
            <label for="moles">Moles (mol)</label>
            <input type="number" id="moles" class="form-control" placeholder="e.g., 1" step="any">
          </div>

          <div class="form-group" id="moleculeGroup" style="display:none;">
            <label for="molecules">Molecules/Atoms/Formula Units</label>
            <input type="number" id="molecules" class="form-control" placeholder="e.g., 6.022e23" step="any">
          </div>

          <div class="form-group">
            <label for="molarMass">Molar Mass (g/mol)</label>
            <input type="number" id="molarMass" class="form-control" placeholder="e.g., 18.015 (H₂O)" step="any">
            <small class="form-text text-muted">Use <a href="molar-mass-calculator.jsp" target="_blank">Molar Mass Calculator</a> if needed</small>
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="autoConvert" checked>
            <label class="form-check-label" for="autoConvert">Auto-calculate</label>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateConversion()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetConversion()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyConversionResult()">📋 Copy</button>
          </div>

          <div class="small text-muted mt-3">
            <strong>Key Constants:</strong>
            <div>Avogadro's Number: 6.022 × 10²³ particles/mol</div>
            <div class="formula-badge mt-1">moles = grams / molar mass</div>
            <div class="formula-badge mt-1">particles = moles × 6.022×10²³</div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="conversionResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- Limiting Reactant Tab -->
  <div id="sectionLimiting" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Limiting Reactant Finder</h5>
          <p class="text-muted small">Determine which reactant runs out first and limits product formation</p>

          <div class="mb-3">
            <small class="text-muted d-block mb-2">Quick examples:</small>
            <span class="preset-reaction" onclick="loadLimitingExample('2H2+O2')">2H₂ + O₂ → 2H₂O</span>
            <span class="preset-reaction" onclick="loadLimitingExample('N2+3H2')">N₂ + 3H₂ → 2NH₃</span>
            <span class="preset-reaction" onclick="loadLimitingExample('CH4+2O2')">CH₄ + 2O₂ → CO₂ + 2H₂O</span>
          </div>

          <h6 class="mt-3">Reactant 1</h6>
          <div class="form-row">
            <div class="form-group col-md-4">
              <label for="r1Coef">Coefficient</label>
              <input type="number" id="r1Coef" class="form-control" placeholder="e.g., 2" value="2" min="1">
            </div>
            <div class="form-group col-md-4">
              <label for="r1Mass">Mass (g)</label>
              <input type="number" id="r1Mass" class="form-control" placeholder="e.g., 4" step="any">
            </div>
            <div class="form-group col-md-4">
              <label for="r1MM">Molar Mass</label>
              <input type="number" id="r1MM" class="form-control" placeholder="e.g., 2" step="any">
            </div>
          </div>

          <h6 class="mt-3">Reactant 2</h6>
          <div class="form-row">
            <div class="form-group col-md-4">
              <label for="r2Coef">Coefficient</label>
              <input type="number" id="r2Coef" class="form-control" placeholder="e.g., 1" value="1" min="1">
            </div>
            <div class="form-group col-md-4">
              <label for="r2Mass">Mass (g)</label>
              <input type="number" id="r2Mass" class="form-control" placeholder="e.g., 32" step="any">
            </div>
            <div class="form-group col-md-4">
              <label for="r2MM">Molar Mass</label>
              <input type="number" id="r2MM" class="form-control" placeholder="e.g., 32" step="any">
            </div>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateLimiting()">Find Limiting Reactant</button>
            <button class="btn btn-outline-secondary" onclick="resetLimiting()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyLimitingResult()">📋 Copy</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="limitingResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- Percent Yield Tab -->
  <div id="sectionYield" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Percent Yield Calculator</h5>
          <p class="text-muted small">% Yield = (Actual / Theoretical) × 100</p>

          <div class="form-group">
            <label for="yieldCalcType">Calculate</label>
            <select id="yieldCalcType" class="form-control" onchange="updateYieldUI()">
              <option value="percent">Percent Yield (%)</option>
              <option value="actual">Actual Yield</option>
              <option value="theoretical">Theoretical Yield</option>
            </select>
          </div>

          <div class="form-group" id="actualGroup">
            <label for="actualYield">Actual Yield (g)</label>
            <input type="number" id="actualYield" class="form-control" placeholder="e.g., 45" step="any">
          </div>

          <div class="form-group" id="theoreticalGroup">
            <label for="theoreticalYield">Theoretical Yield (g)</label>
            <input type="number" id="theoreticalYield" class="form-control" placeholder="e.g., 50" step="any">
          </div>

          <div class="form-group" id="percentGroup" style="display:none;">
            <label for="percentYield">Percent Yield (%)</label>
            <input type="number" id="percentYield" class="form-control" placeholder="e.g., 90" step="any" min="0" max="100">
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateYield()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetYield()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyYieldResult()">📋 Copy</button>
          </div>

          <div class="mt-3 small text-muted">
            <strong>Typical Yields:</strong>
            <ul class="mb-0">
              <li>Lab reactions: 50-90% typical</li>
              <li>Industrial: 80-95% optimized</li>
              <li>100%: Perfect (rare in practice)</li>
              <li>&gt;100%: Error/impurities</li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="yieldResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- From Equation Tab -->
  <div id="sectionEquation" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Stoichiometry from Equation</h5>
          <p class="text-muted small">Calculate products from reactants using balanced equation</p>

          <div class="form-group">
            <label for="equation">Balanced Equation</label>
            <input type="text" id="equation" class="form-control" placeholder="e.g., 2H2 + O2 -> 2H2O">
            <small class="form-text text-muted">Use format: 2H2 + O2 -> 2H2O</small>
          </div>

          <div class="form-group">
            <label for="knownSubstance">Known Substance</label>
            <input type="text" id="knownSubstance" class="form-control" placeholder="e.g., H2">
          </div>

          <div class="form-row">
            <div class="form-group col-md-6">
              <label for="knownAmount">Known Amount</label>
              <input type="number" id="knownAmount" class="form-control" placeholder="e.g., 4" step="any">
            </div>
            <div class="form-group col-md-6">
              <label for="knownUnit">Unit</label>
              <select id="knownUnit" class="form-control">
                <option value="g">grams</option>
                <option value="mol">moles</option>
                <option value="L">liters (gas at STP)</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="unknownSubstance">Find Amount of</label>
            <input type="text" id="unknownSubstance" class="form-control" placeholder="e.g., H2O">
          </div>

          <div class="form-group">
            <label for="unknownUnit">Desired Unit</label>
            <select id="unknownUnit" class="form-control">
              <option value="g">grams</option>
              <option value="mol">moles</option>
              <option value="L">liters (gas at STP)</option>
            </select>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateFromEquation()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetEquation()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyEquationResult()">📋 Copy</button>
          </div>

          <div class="alert alert-info mt-3">
            <strong>Note:</strong> For accurate results, use the <a href="molar-mass-calculator.jsp">Molar Mass Calculator</a> to get precise molar masses.
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="equationResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>
</div>

<!-- Learn Section -->
<div class="container mt-5 pt-4">
  <div id="learn" class="card shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3">What Is Stoichiometry?</h5>
      <p>Stoichiometry is the calculation of reactants and products in chemical reactions. It uses balanced equations and molar relationships to predict amounts.</p>

      <h6 class="mt-4">Key Concepts</h6>
      <ul class="mb-3">
        <li><strong>Mole:</strong> 6.022 × 10²³ particles (Avogadro's number)</li>
        <li><strong>Molar Mass:</strong> Mass of 1 mole (g/mol)</li>
        <li><strong>Stoichiometric Ratio:</strong> Coefficient ratios from balanced equation</li>
        <li><strong>Limiting Reactant:</strong> Reactant that runs out first</li>
        <li><strong>Excess Reactant:</strong> Reactant left over</li>
        <li><strong>Theoretical Yield:</strong> Maximum product from limiting reactant</li>
        <li><strong>Actual Yield:</strong> What you actually get in the lab</li>
        <li><strong>Percent Yield:</strong> (Actual / Theoretical) × 100</li>
      </ul>

      <h6>Conversion Steps</h6>
      <div class="conversion-flow">
        <span class="result-badge">Grams A</span>
        <span class="conversion-arrow">→</span>
        <span class="result-badge">Moles A</span>
        <span class="conversion-arrow">→</span>
        <span class="result-badge">Moles B</span>
        <span class="conversion-arrow">→</span>
        <span class="result-badge">Grams B</span>
      </div>

      <h5 class="mt-3 mb-2">Worked Examples</h5>

      <div class="mb-3">
        <p class="mb-1"><strong>1) Grams to Moles</strong></p>
        <p class="mb-1">How many moles in 18 g of H₂O? (MM = 18.015 g/mol)</p>
        <p class="mb-1">moles = 18 g / 18.015 g/mol = <strong>0.999 mol ≈ 1 mol</strong></p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>2) Limiting Reactant</strong></p>
        <p class="mb-1">Reaction: 2H₂ + O₂ → 2H₂O</p>
        <p class="mb-1">Given: 4 g H₂ (MM=2) and 32 g O₂ (MM=32)</p>
        <p class="mb-1">Moles H₂: 4/2 = 2 mol → needs 1 mol O₂ (ratio 2:1)</p>
        <p class="mb-1">Moles O₂: 32/32 = 1 mol → needs 2 mol H₂</p>
        <p class="mb-1">Both exactly match → <strong>No limiting reactant!</strong></p>
        <p class="mb-1">If we had only 0.5 mol O₂, it would be limiting.</p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>3) Percent Yield</strong></p>
        <p class="mb-1">Theoretical yield: 50 g, Actual yield: 45 g</p>
        <p class="mb-1">% Yield = (45 / 50) × 100 = <strong>90%</strong></p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>4) Gas at STP</strong></p>
        <p class="mb-1">At STP (0°C, 1 atm): 1 mole gas = 22.4 L</p>
        <p class="mb-1">2 moles H₂ = 2 × 22.4 = <strong>44.8 L</strong></p>
      </div>

      <h6 class="mt-4">Common Mistakes</h6>
      <ul class="mb-3">
        <li>❌ Forgetting to balance equation first</li>
        <li>❌ Using grams instead of moles in ratios</li>
        <li>❌ Not identifying limiting reactant</li>
        <li>❌ Confusing theoretical and actual yield</li>
        <li>✅ Always: Balance → Moles → Ratio → Convert</li>
      </ul>
    </div>
  </div>
</div>

<script>
const AVOGADRO = 6.022e23;
const STP_VOLUME = 22.4; // L/mol at STP

function switchTab(which){
  const convert=document.getElementById('sectionConvert');
  const limiting=document.getElementById('sectionLimiting');
  const yieldTab=document.getElementById('sectionYield');
  const equation=document.getElementById('sectionEquation');
  const tc=document.getElementById('tab-convert');
  const tl=document.getElementById('tab-limiting');
  const ty=document.getElementById('tab-yield');
  const te=document.getElementById('tab-equation');

  [convert, limiting, yieldTab, equation].forEach(el => el.style.display = 'none');
  [tc, tl, ty, te].forEach(el => el.classList.remove('active'));

  if(which==='limiting'){ limiting.style.display='block'; tl.classList.add('active'); }
  else if(which==='yield'){ yieldTab.style.display='block'; ty.classList.add('active'); }
  else if(which==='equation'){ equation.style.display='block'; te.classList.add('active'); }
  else { convert.style.display='block'; tc.classList.add('active'); }
}

function updateConversionUI(){
  const type = document.getElementById('conversionType').value;
  const gramGroup = document.getElementById('gramGroup');
  const moleGroup = document.getElementById('moleGroup');
  const moleculeGroup = document.getElementById('moleculeGroup');

  gramGroup.style.display = 'none';
  moleGroup.style.display = 'none';
  moleculeGroup.style.display = 'none';

  if(type.includes('gram-to')) gramGroup.style.display = 'block';
  if(type.includes('mole-to-gram') || type.includes('molecules-to-mole')) moleGroup.style.display = 'block';
  if(type.includes('mole-to-molecules')) moleGroup.style.display = 'block';
  if(type.includes('molecules-to')) moleculeGroup.style.display = 'block';
  if(type.includes('to-mole') && !type.includes('gram')) moleculeGroup.style.display = 'block';
}

function calculateConversion(){
  const type = document.getElementById('conversionType').value;
  const grams = parseFloat(document.getElementById('grams').value);
  const moles = parseFloat(document.getElementById('moles').value);
  const molecules = parseFloat(document.getElementById('molecules').value);
  const MM = parseFloat(document.getElementById('molarMass').value);
  const res = document.getElementById('conversionResult');

  try {
    let result, steps = '';

    if(type === 'gram-to-mole'){
      if(!grams || !MM) throw new Error('Enter grams and molar mass');
      result = grams / MM;
      steps = `<div class="result-section">
        <strong>Grams → Moles</strong>
        <div class="conversion-flow">
          <span class="result-badge">${grams} g</span>
          <span class="conversion-arrow">÷ ${MM} g/mol</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${result.toFixed(6)} mol</span>
        </div>
        <div class="mt-2">Formula: moles = grams / molar mass</div>
        <div>moles = ${grams} / ${MM} = <strong>${result.toFixed(6)} mol</strong></div>
      </div>`;
    } else if(type === 'mole-to-gram'){
      if(!moles || !MM) throw new Error('Enter moles and molar mass');
      result = moles * MM;
      steps = `<div class="result-section">
        <strong>Moles → Grams</strong>
        <div class="conversion-flow">
          <span class="result-badge">${moles} mol</span>
          <span class="conversion-arrow">× ${MM} g/mol</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${result.toFixed(6)} g</span>
        </div>
        <div class="mt-2">Formula: grams = moles × molar mass</div>
        <div>grams = ${moles} × ${MM} = <strong>${result.toFixed(6)} g</strong></div>
      </div>`;
    } else if(type === 'mole-to-molecules'){
      if(!moles) throw new Error('Enter moles');
      result = moles * AVOGADRO;
      steps = `<div class="result-section">
        <strong>Moles → Molecules/Atoms</strong>
        <div class="conversion-flow">
          <span class="result-badge">${moles} mol</span>
          <span class="conversion-arrow">× 6.022×10²³</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${result.toExponential(4)} particles</span>
        </div>
        <div class="mt-2">Formula: particles = moles × Avogadro's number</div>
        <div>particles = ${moles} × ${AVOGADRO.toExponential(3)} = <strong>${result.toExponential(4)}</strong></div>
      </div>`;
    } else if(type === 'molecules-to-mole'){
      if(!molecules) throw new Error('Enter molecules');
      result = molecules / AVOGADRO;
      steps = `<div class="result-section">
        <strong>Molecules/Atoms → Moles</strong>
        <div class="conversion-flow">
          <span class="result-badge">${molecules.toExponential(3)} particles</span>
          <span class="conversion-arrow">÷ 6.022×10²³</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${result.toFixed(6)} mol</span>
        </div>
        <div class="mt-2">Formula: moles = particles / Avogadro's number</div>
        <div>moles = ${molecules.toExponential(3)} / ${AVOGADRO.toExponential(3)} = <strong>${result.toFixed(6)} mol</strong></div>
      </div>`;
    } else if(type === 'gram-to-molecules'){
      if(!grams || !MM) throw new Error('Enter grams and molar mass');
      const mol = grams / MM;
      result = mol * AVOGADRO;
      steps = `<div class="result-section">
        <strong>Grams → Molecules/Atoms</strong>
        <div class="conversion-flow">
          <span class="result-badge">${grams} g</span>
          <span class="conversion-arrow">÷ ${MM}</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${mol.toFixed(4)} mol</span>
          <span class="conversion-arrow">× 6.022×10²³</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${result.toExponential(4)} particles</span>
        </div>
        <div class="mt-2">Step 1: grams → moles = ${grams} / ${MM} = ${mol.toFixed(6)} mol</div>
        <div>Step 2: moles → particles = ${mol.toFixed(6)} × ${AVOGADRO.toExponential(3)} = <strong>${result.toExponential(4)}</strong></div>
      </div>`;
    } else if(type === 'molecules-to-gram'){
      if(!molecules || !MM) throw new Error('Enter molecules and molar mass');
      const mol = molecules / AVOGADRO;
      result = mol * MM;
      steps = `<div class="result-section">
        <strong>Molecules/Atoms → Grams</strong>
        <div class="conversion-flow">
          <span class="result-badge">${molecules.toExponential(3)} particles</span>
          <span class="conversion-arrow">÷ 6.022×10²³</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${mol.toFixed(6)} mol</span>
          <span class="conversion-arrow">× ${MM}</span>
          <span class="conversion-arrow">→</span>
          <span class="result-badge">${result.toFixed(6)} g</span>
        </div>
        <div class="mt-2">Step 1: particles → moles = ${molecules.toExponential(3)} / ${AVOGADRO.toExponential(3)} = ${mol.toFixed(6)} mol</div>
        <div>Step 2: moles → grams = ${mol.toFixed(6)} × ${MM} = <strong>${result.toFixed(6)} g</strong></div>
      </div>`;
    }

    res.innerHTML = steps;
    res.dataset.result = `Result: ${result}`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function calculateLimiting(){
  const c1 = parseFloat(document.getElementById('r1Coef').value);
  const m1 = parseFloat(document.getElementById('r1Mass').value);
  const mm1 = parseFloat(document.getElementById('r1MM').value);
  const c2 = parseFloat(document.getElementById('r2Coef').value);
  const m2 = parseFloat(document.getElementById('r2Mass').value);
  const mm2 = parseFloat(document.getElementById('r2MM').value);
  const res = document.getElementById('limitingResult');

  try {
    if(!c1 || !m1 || !mm1 || !c2 || !m2 || !mm2) throw new Error('Enter all values');

    const mol1 = m1 / mm1;
    const mol2 = m2 / mm2;

    // Divide by coefficient to normalize
    const ratio1 = mol1 / c1;
    const ratio2 = mol2 / c2;

    let limiting, excess, limitingMol, excessMol, limitingRatio, excessRatio;

    if(ratio1 < ratio2){
      limiting = 1; excess = 2;
      limitingMol = mol1; excessMol = mol2;
      limitingRatio = ratio1; excessRatio = ratio2;
    } else {
      limiting = 2; excess = 1;
      limitingMol = mol2; excessMol = mol1;
      limitingRatio = ratio2; excessRatio = ratio1;
    }

    const excessUsed = limitingRatio * (limiting === 1 ? c2 : c1);
    const excessLeft = (limiting === 1 ? mol2 : mol1) - excessUsed;
    const excessLeftGrams = excessLeft * (limiting === 1 ? mm2 : mm1);

    const resultHTML = `
      <div class="result-section limiting-reactant">
        <strong>🔴 Limiting Reactant: Reactant ${limiting}</strong>
        <div class="mt-2">Moles available: ${limitingMol.toFixed(4)} mol</div>
        <div>Normalized ratio: ${limitingRatio.toFixed(4)} mol (per coefficient unit)</div>
        <div class="mt-2"><strong>This reactant runs out first!</strong></div>
      </div>

      <div class="result-section excess-reactant">
        <strong>🟢 Excess Reactant: Reactant ${excess}</strong>
        <div class="mt-2">Moles available: ${excessMol.toFixed(4)} mol</div>
        <div>Moles used: ${excessUsed.toFixed(4)} mol</div>
        <div>Moles left over: ${excessLeft.toFixed(4)} mol</div>
        <div>Mass left over: <strong>${excessLeftGrams.toFixed(4)} g</strong></div>
      </div>

      <div class="result-section">
        <strong>Analysis:</strong>
        <div class="mt-2">Reactant 1: ${mol1.toFixed(4)} mol / ${c1} = ${ratio1.toFixed(4)}</div>
        <div>Reactant 2: ${mol2.toFixed(4)} mol / ${c2} = ${ratio2.toFixed(4)}</div>
        <div class="mt-2">Lower ratio → <strong>Limiting Reactant</strong></div>
      </div>
    `;

    res.innerHTML = resultHTML;
    res.dataset.result = `Limiting: Reactant ${limiting}, Excess: ${excessLeftGrams.toFixed(2)} g left`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function updateYieldUI(){
  const type = document.getElementById('yieldCalcType').value;
  document.getElementById('actualGroup').style.display = (type === 'actual') ? 'none' : 'block';
  document.getElementById('theoreticalGroup').style.display = (type === 'theoretical') ? 'none' : 'block';
  document.getElementById('percentGroup').style.display = (type === 'percent') ? 'none' : 'block';
}

function calculateYield(){
  const type = document.getElementById('yieldCalcType').value;
  const actual = parseFloat(document.getElementById('actualYield').value);
  const theoretical = parseFloat(document.getElementById('theoreticalYield').value);
  const percent = parseFloat(document.getElementById('percentYield').value);
  const res = document.getElementById('yieldResult');

  try {
    let result, steps = '';

    if(type === 'percent'){
      if(!actual || !theoretical) throw new Error('Enter actual and theoretical yield');
      result = (actual / theoretical) * 100;
      steps = `<div class="result-section">
        <strong>Percent Yield</strong>
        <div class="mt-2">% Yield = (Actual / Theoretical) × 100</div>
        <div>% Yield = (${actual} / ${theoretical}) × 100</div>
        <div class="mt-2"><span class="result-badge">${result.toFixed(2)}%</span></div>
        ${result > 100 ? '<div class="alert alert-warning mt-2">⚠️ Yield > 100% suggests impurities or measurement error</div>' : ''}
        ${result < 50 ? '<div class="alert alert-info mt-2">Low yield - check reaction conditions</div>' : ''}
      </div>`;
    } else if(type === 'actual'){
      if(!percent || !theoretical) throw new Error('Enter percent yield and theoretical yield');
      result = (percent / 100) * theoretical;
      steps = `<div class="result-section">
        <strong>Actual Yield</strong>
        <div class="mt-2">Actual = (% Yield / 100) × Theoretical</div>
        <div>Actual = (${percent} / 100) × ${theoretical}</div>
        <div class="mt-2"><span class="result-badge">${result.toFixed(4)} g</span></div>
      </div>`;
    } else if(type === 'theoretical'){
      if(!percent || !actual) throw new Error('Enter percent yield and actual yield');
      result = (actual / percent) * 100;
      steps = `<div class="result-section">
        <strong>Theoretical Yield</strong>
        <div class="mt-2">Theoretical = (Actual / % Yield) × 100</div>
        <div>Theoretical = (${actual} / ${percent}) × 100</div>
        <div class="mt-2"><span class="result-badge">${result.toFixed(4)} g</span></div>
      </div>`;
    }

    res.innerHTML = steps;
    res.dataset.result = `Result: ${result}`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function calculateFromEquation(){
  const res = document.getElementById('equationResult');
  res.innerHTML = '<div class="alert alert-info">This feature requires parsing balanced equations. Use the other tabs for conversions, or manually extract coefficients.</div>';
}

function loadLimitingExample(type){
  if(type === '2H2+O2'){
    document.getElementById('r1Coef').value = 2;
    document.getElementById('r1Mass').value = 4;
    document.getElementById('r1MM').value = 2.016;
    document.getElementById('r2Coef').value = 1;
    document.getElementById('r2Mass').value = 32;
    document.getElementById('r2MM').value = 32;
  } else if(type === 'N2+3H2'){
    document.getElementById('r1Coef').value = 1;
    document.getElementById('r1Mass').value = 28;
    document.getElementById('r1MM').value = 28;
    document.getElementById('r2Coef').value = 3;
    document.getElementById('r2Mass').value = 6;
    document.getElementById('r2MM').value = 2.016;
  } else if(type === 'CH4+2O2'){
    document.getElementById('r1Coef').value = 1;
    document.getElementById('r1Mass').value = 16;
    document.getElementById('r1MM').value = 16;
    document.getElementById('r2Coef').value = 2;
    document.getElementById('r2Mass').value = 64;
    document.getElementById('r2MM').value = 32;
  }
}

function resetConversion(){
  ['grams','moles','molecules','molarMass'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('conversionResult').innerHTML = '';
}

function resetLimiting(){
  ['r1Coef','r1Mass','r1MM','r2Coef','r2Mass','r2MM'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('r1Coef').value = 2;
  document.getElementById('r2Coef').value = 1;
  document.getElementById('limitingResult').innerHTML = '';
}

function resetYield(){
  ['actualYield','theoreticalYield','percentYield'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('yieldResult').innerHTML = '';
}

function resetEquation(){
  ['equation','knownSubstance','knownAmount','unknownSubstance'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('equationResult').innerHTML = '';
}

function copyConversionResult(){ copyToClipboard('conversionResult'); }
function copyLimitingResult(){ copyToClipboard('limitingResult'); }
function copyYieldResult(){ copyToClipboard('yieldResult'); }
function copyEquationResult(){ copyToClipboard('equationResult'); }

function copyToClipboard(id){
  const el = document.getElementById(id);
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

// Initialize
(function(){
  updateConversionUI();
  updateYieldUI();
})();
</script>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Stoichiometry Calculator",
  "alternateName": ["Mole Calculator", "Limiting Reactant Calculator", "Percent Yield Calculator"],
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "inLanguage": "en",
  "isAccessibleForFree": true,
  "url": "https://8gwifi.org/stoichiometry-calculator.jsp",
  "image": "https://8gwifi.org/images/site/stoichiometry.png",
  "description": "Free stoichiometry calculator. Convert grams, moles, molecules. Find limiting reactant and calculate percent yield.",
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
  "name": "Stoichiometry Calculator",
  "url": "https://8gwifi.org/stoichiometry-calculator.jsp",
  "description": "Calculate moles, mass, molecules, limiting reactant, and percent yield.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "Stoichiometry Calculator", "item": "https://8gwifi.org/stoichiometry-calculator.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "What is stoichiometry?", "acceptedAnswer": {"@type": "Answer", "text": "Stoichiometry is the calculation of reactants and products in chemical reactions using balanced equations and molar relationships."}},
    {"@type": "Question", "name": "What is a limiting reactant?", "acceptedAnswer": {"@type": "Answer", "text": "The limiting reactant is the reactant that runs out first in a chemical reaction, limiting the amount of product that can be formed."}},
    {"@type": "Question", "name": "How do you calculate percent yield?", "acceptedAnswer": {"@type": "Answer", "text": "Percent yield = (Actual yield / Theoretical yield) × 100. It measures the efficiency of a chemical reaction."}}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Convert grams to moles",
  "description": "Step-by-step guide to convert mass to moles",
  "totalTime": "PT1M",
  "step": [
    {"@type": "HowToStep", "name": "Find molar mass", "text": "Look up or calculate the molar mass (g/mol) of the substance."},
    {"@type": "HowToStep", "name": "Divide", "text": "Divide the mass in grams by the molar mass."},
    {"@type": "HowToStep", "name": "Result", "text": "The result is the number of moles: moles = grams / molar mass."}
  ]
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
