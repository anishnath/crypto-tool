<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ideal Gas Law Calculator (PV=nRT) | Combined Gas Law + Dalton's Law | Free | 8gwifi.org</title>
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/ideal-gas-law-calculator.jsp">
  <meta name="description" content="Free ideal gas law calculator (PV=nRT). Calculate pressure, volume, moles, or temperature. Includes combined gas law, Dalton's law, gas density, and molar mass calculations. No sign-up; runs in your browser.">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="8gwifi.org">
  <meta property="og:title" content="Ideal Gas Law Calculator (PV=nRT) | Free Online">
  <meta property="og:description" content="Calculate P, V, n, or T using PV=nRT. Includes combined gas law, Dalton's law, and gas density calculations. Free and browser-only.">
  <meta property="og:url" content="https://8gwifi.org/ideal-gas-law-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/ideal-gas.png">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@anish2good">
  <meta name="twitter:title" content="Ideal Gas Law Calculator | Free Online Tool">
  <meta name="twitter:description" content="Calculate pressure, volume, moles, and temperature using PV=nRT.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/ideal-gas.png">

  <style>
    .min-h-result { min-height: 220px; max-height: 600px; overflow-y: auto; }
    @media (min-width: 992px) { .min-h-result { min-height: 280px; max-height: 70vh; } }
    .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; max-height: calc(100vh - 100px); }
    .sticky-side .card-body { overflow-y: auto; max-height: calc(100vh - 150px); }
    .options-bar { display:flex; flex-wrap: wrap; gap: .75rem; align-items:center; }
    .result-badge { display: inline-block; padding: .5rem .8rem; background: #e6f4ea; color: #0f5132; border: 1px solid #badbcc; border-radius: .35rem; font-weight: 600; font-size: 1.1rem; margin: .25rem; }
    .result-section { margin-bottom: 1rem; padding: .75rem; background: #f8f9fa; border-radius: .35rem; }
    .formula-badge { font-family: monospace; background: #fff3cd; padding: .25rem .5rem; border-radius: .25rem; font-size: 0.9rem; }
    .unit-selector { max-width: 120px; }
    .gas-constant-info { background: #e7f3ff; padding: .75rem; border-radius: .35rem; font-size: 0.9rem; margin: .5rem 0; }
  </style>
  <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>
<div class="container mt-5">
  <h1 class="mb-3">Ideal Gas Law Calculator</h1>
  <p class="lead mb-4">Calculate pressure (P), volume (V), moles (n), or temperature (T) using the ideal gas law PV = nRT. Includes combined gas law, Dalton's law, gas density, and molar mass calculations.</p>

  <!-- Tabs -->
  <ul class="nav nav-tabs mb-3" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" id="tab-ideal" href="#" role="tab" onclick="switchTab('ideal'); return false;">Ideal Gas Law (PV=nRT)</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-combined" href="#" role="tab" onclick="switchTab('combined'); return false;">Combined Gas Law</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-dalton" href="#" role="tab" onclick="switchTab('dalton'); return false;">Dalton's Law</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-density" href="#" role="tab" onclick="switchTab('density'); return false;">Gas Density & Molar Mass</a>
    </li>
  </ul>

  <div id="sectionIdeal">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Ideal Gas Law: PV = nRT</h5>

          <div class="form-group">
            <label for="solveFor">Solve for</label>
            <select id="solveFor" class="form-control" onchange="updateIdealUI()">
              <option value="P">Pressure (P)</option>
              <option value="V">Volume (V)</option>
              <option value="n">Moles (n)</option>
              <option value="T">Temperature (T)</option>
            </select>
          </div>

          <div class="form-row">
            <div class="form-group col-md-6" id="groupP">
              <label for="pressure">Pressure (P)</label>
              <div class="input-group">
                <input type="number" id="pressure" class="form-control" placeholder="e.g., 1" step="any" oninput="if(autoCalc.checked) calculateIdeal()">
                <div class="input-group-append">
                  <select id="pressureUnit" class="form-control unit-selector">
                    <option value="atm">atm</option>
                    <option value="kPa">kPa</option>
                    <option value="Pa">Pa</option>
                    <option value="mmHg">mmHg</option>
                    <option value="bar">bar</option>
                    <option value="psi">psi</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="form-group col-md-6" id="groupV">
              <label for="volume">Volume (V)</label>
              <div class="input-group">
                <input type="number" id="volume" class="form-control" placeholder="e.g., 22.4" step="any" oninput="if(autoCalc.checked) calculateIdeal()">
                <div class="input-group-append">
                  <select id="volumeUnit" class="form-control unit-selector">
                    <option value="L">L</option>
                    <option value="mL">mL</option>
                    <option value="m3">m³</option>
                    <option value="cm3">cm³</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <div class="form-row">
            <div class="form-group col-md-6" id="groupN">
              <label for="moles">Moles (n)</label>
              <input type="number" id="moles" class="form-control" placeholder="e.g., 1" step="any" oninput="if(autoCalc.checked) calculateIdeal()">
            </div>
            <div class="form-group col-md-6" id="groupT">
              <label for="temperature">Temperature (T)</label>
              <div class="input-group">
                <input type="number" id="temperature" class="form-control" placeholder="e.g., 273.15" step="any" oninput="if(autoCalc.checked) calculateIdeal()">
                <div class="input-group-append">
                  <select id="tempUnit" class="form-control unit-selector">
                    <option value="K">K</option>
                    <option value="C">°C</option>
                    <option value="F">°F</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <div class="gas-constant-info">
            <strong>Gas Constant (R):</strong> 0.08206 L·atm/(mol·K) = 8.314 J/(mol·K)
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="autoCalc" checked>
            <label class="form-check-label" for="autoCalc">Auto-calculate</label>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateIdeal()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetIdeal()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyResult()">📋 Copy</button>
            <button class="btn btn-outline-secondary" onclick="copyLaTeX()">𝛌 LaTeX</button>
            <button class="btn btn-outline-secondary" onclick="exportPNG()">🖼 PNG</button>
            <button class="btn btn-outline-secondary" onclick="shareLink()">🔗 Share</button>
          </div>

          <div class="small text-muted">
            <div class="formula-badge">PV = nRT</div>
            <div class="mt-2">STP: T = 273.15 K (0°C), P = 1 atm → V = 22.4 L/mol</div>
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

  <!-- Combined Gas Law Tab -->
  <div id="sectionCombined" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Combined Gas Law</h5>
          <p class="text-muted small">P₁V₁/T₁ = P₂V₂/T₂ (when moles are constant)</p>

          <h6 class="mt-3">Initial State</h6>
          <div class="form-row">
            <div class="form-group col-md-4">
              <label for="P1">P₁</label>
              <div class="input-group input-group-sm">
                <input type="number" id="P1" class="form-control" placeholder="e.g., 1" step="any">
                <div class="input-group-append">
                  <select id="P1Unit" class="form-control"><option>atm</option><option>kPa</option><option>mmHg</option></select>
                </div>
              </div>
            </div>
            <div class="form-group col-md-4">
              <label for="V1">V₁</label>
              <div class="input-group input-group-sm">
                <input type="number" id="V1" class="form-control" placeholder="e.g., 22.4" step="any">
                <div class="input-group-append">
                  <select id="V1Unit" class="form-control"><option>L</option><option>mL</option></select>
                </div>
              </div>
            </div>
            <div class="form-group col-md-4">
              <label for="T1">T₁</label>
              <div class="input-group input-group-sm">
                <input type="number" id="T1" class="form-control" placeholder="e.g., 273" step="any">
                <div class="input-group-append">
                  <select id="T1Unit" class="form-control"><option>K</option><option>C</option></select>
                </div>
              </div>
            </div>
          </div>

          <h6 class="mt-3">Final State</h6>
          <div class="form-row">
            <div class="form-group col-md-4">
              <label for="P2">P₂</label>
              <div class="input-group input-group-sm">
                <input type="number" id="P2" class="form-control" placeholder="Solve" step="any">
                <div class="input-group-append">
                  <select id="P2Unit" class="form-control"><option>atm</option><option>kPa</option><option>mmHg</option></select>
                </div>
              </div>
            </div>
            <div class="form-group col-md-4">
              <label for="V2">V₂</label>
              <div class="input-group input-group-sm">
                <input type="number" id="V2" class="form-control" placeholder="Solve" step="any">
                <div class="input-group-append">
                  <select id="V2Unit" class="form-control"><option>L</option><option>mL</option></select>
                </div>
              </div>
            </div>
            <div class="form-group col-md-4">
              <label for="T2">T₂</label>
              <div class="input-group input-group-sm">
                <input type="number" id="T2" class="form-control" placeholder="Solve" step="any">
                <div class="input-group-append">
                  <select id="T2Unit" class="form-control"><option>K</option><option>C</option></select>
                </div>
              </div>
            </div>
          </div>

          <div class="form-group">
            <label for="combinedSolve">Solve for</label>
            <select id="combinedSolve" class="form-control">
              <option value="P2">P₂</option>
              <option value="V2">V₂</option>
              <option value="T2">T₂</option>
            </select>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateCombined()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetCombined()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyCombinedResult()">📋 Copy</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="combinedResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- Dalton's Law Tab -->
  <div id="sectionDalton" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Dalton's Law of Partial Pressures</h5>
          <p class="text-muted small">P<sub>total</sub> = P₁ + P₂ + P₃ + ...</p>

          <div class="form-group">
            <label>Number of gases</label>
            <input type="number" id="numGases" class="form-control" min="2" max="10" value="2" onchange="generateGasInputs()">
          </div>

          <div id="gasInputs"></div>

          <div class="form-group">
            <label for="daltonUnit">Pressure Unit</label>
            <select id="daltonUnit" class="form-control unit-selector">
              <option value="atm">atm</option>
              <option value="kPa">kPa</option>
              <option value="mmHg">mmHg</option>
            </select>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateDalton()">Calculate Total Pressure</button>
            <button class="btn btn-outline-secondary" onclick="resetDalton()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyDaltonResult()">📋 Copy</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="daltonResult" class="min-h-result"></div>
        </div>
      </div>
    </div>
  </div>
  </div>

  <!-- Density Tab -->
  <div id="sectionDensity" style="display:none;">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Gas Density & Molar Mass</h5>
          <p class="text-muted small">d = PM/RT or M = dRT/P</p>

          <div class="form-group">
            <label for="densitySolve">Calculate</label>
            <select id="densitySolve" class="form-control" onchange="updateDensityUI()">
              <option value="density">Density (d)</option>
              <option value="molarMass">Molar Mass (M)</option>
            </select>
          </div>

          <div class="form-group" id="densityGroup">
            <label for="density">Density (g/L)</label>
            <input type="number" id="density" class="form-control" placeholder="e.g., 1.96" step="any">
          </div>

          <div class="form-group" id="molarMassGroup">
            <label for="molarMass">Molar Mass (g/mol)</label>
            <input type="number" id="molarMass" class="form-control" placeholder="e.g., 44" step="any">
          </div>

          <div class="form-row">
            <div class="form-group col-md-6">
              <label for="densityP">Pressure</label>
              <div class="input-group">
                <input type="number" id="densityP" class="form-control" placeholder="e.g., 1" step="any">
                <div class="input-group-append">
                  <select id="densityPUnit" class="form-control unit-selector">
                    <option value="atm">atm</option>
                    <option value="kPa">kPa</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="form-group col-md-6">
              <label for="densityT">Temperature</label>
              <div class="input-group">
                <input type="number" id="densityT" class="form-control" placeholder="e.g., 273.15" step="any">
                <div class="input-group-append">
                  <select id="densityTUnit" class="form-control unit-selector">
                    <option value="K">K</option>
                    <option value="C">°C</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateDensity()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetDensity()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyDensityResult()">📋 Copy</button>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="densityResult" class="min-h-result"></div>
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
      <h5 class="card-title mb-3">What Is the Ideal Gas Law?</h5>
      <p>The ideal gas law relates pressure (P), volume (V), moles (n), and temperature (T) of an ideal gas: <strong>PV = nRT</strong>, where R is the universal gas constant.</p>

      <h6 class="mt-4">Key Concepts</h6>
      <ul class="mb-3">
        <li><strong>R (gas constant):</strong> 0.08206 L·atm/(mol·K) or 8.314 J/(mol·K)</li>
        <li><strong>STP (Standard Temperature & Pressure):</strong> 273.15 K (0°C) and 1 atm</li>
        <li><strong>At STP:</strong> 1 mole of ideal gas = 22.4 L</li>
        <li><strong>Temperature must be in Kelvin</strong> for PV=nRT</li>
      </ul>

      <h6>Related Gas Laws</h6>
      <ul class="mb-3">
        <li><strong>Boyle's Law:</strong> P₁V₁ = P₂V₂ (constant T and n)</li>
        <li><strong>Charles's Law:</strong> V₁/T₁ = V₂/T₂ (constant P and n)</li>
        <li><strong>Gay-Lussac's Law:</strong> P₁/T₁ = P₂/T₂ (constant V and n)</li>
        <li><strong>Combined Gas Law:</strong> P₁V₁/T₁ = P₂V₂/T₂ (constant n)</li>
        <li><strong>Avogadro's Law:</strong> V₁/n₁ = V₂/n₂ (constant P and T)</li>
        <li><strong>Dalton's Law:</strong> P<sub>total</sub> = P₁ + P₂ + ... (partial pressures)</li>
      </ul>

      <h5 class="mt-3 mb-2">Worked Examples</h5>

      <div class="mb-3">
        <p class="mb-1"><strong>1) Calculate volume at STP</strong></p>
        <p class="mb-1">Given: n = 2 mol, T = 273.15 K, P = 1 atm</p>
        <p class="mb-1">V = nRT/P = (2)(0.08206)(273.15)/(1) = <strong>44.8 L</strong></p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>2) Combined Gas Law</strong></p>
        <p class="mb-1">Initial: P₁ = 2 atm, V₁ = 5 L, T₁ = 300 K</p>
        <p class="mb-1">Final: P₂ = 1 atm, T₂ = 273 K, V₂ = ?</p>
        <p class="mb-1">V₂ = P₁V₁T₂/(P₂T₁) = (2)(5)(273)/((1)(300)) = <strong>9.1 L</strong></p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>3) Dalton's Law</strong></p>
        <p class="mb-1">N₂ at 0.8 atm, O₂ at 0.2 atm</p>
        <p class="mb-1">P<sub>total</sub> = 0.8 + 0.2 = <strong>1.0 atm</strong></p>
      </div>

      <h6 class="mt-4">Unit Conversions</h6>
      <div class="table-responsive">
        <table class="table table-sm">
          <thead>
            <tr><th>Type</th><th>Conversions</th></tr>
          </thead>
          <tbody>
            <tr><td>Pressure</td><td>1 atm = 101.325 kPa = 760 mmHg = 1.01325 bar = 14.696 psi</td></tr>
            <tr><td>Volume</td><td>1 L = 1000 mL = 0.001 m³ = 1000 cm³</td></tr>
            <tr><td>Temperature</td><td>K = °C + 273.15; °F = (°C × 9/5) + 32</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
const R = 0.08206; // L·atm/(mol·K)

// Unit conversion functions
const pressureConversions = {
  'atm': 1,
  'kPa': 101.325,
  'Pa': 101325,
  'mmHg': 760,
  'bar': 1.01325,
  'psi': 14.696
};

const volumeConversions = {
  'L': 1,
  'mL': 1000,
  'm3': 0.001,
  'cm3': 1000
};

function toAtm(val, unit){ return val / pressureConversions[unit]; }
function fromAtm(val, unit){ return val * pressureConversions[unit]; }
function toLiters(val, unit){ return val / volumeConversions[unit]; }
function fromLiters(val, unit){ return val * volumeConversions[unit]; }
function toKelvin(val, unit){
  if(unit === 'K') return val;
  if(unit === 'C') return val + 273.15;
  if(unit === 'F') return (val - 32) * 5/9 + 273.15;
  return val;
}
function fromKelvin(val, unit){
  if(unit === 'K') return val;
  if(unit === 'C') return val - 273.15;
  if(unit === 'F') return (val - 273.15) * 9/5 + 32;
  return val;
}

function switchTab(which){
  const ideal=document.getElementById('sectionIdeal');
  const combined=document.getElementById('sectionCombined');
  const dalton=document.getElementById('sectionDalton');
  const density=document.getElementById('sectionDensity');
  const ti=document.getElementById('tab-ideal');
  const tc=document.getElementById('tab-combined');
  const td=document.getElementById('tab-dalton');
  const tden=document.getElementById('tab-density');

  [ideal, combined, dalton, density].forEach(el => el.style.display = 'none');
  [ti, tc, td, tden].forEach(el => el.classList.remove('active'));

  if(which==='combined'){ combined.style.display='block'; tc.classList.add('active'); }
  else if(which==='dalton'){ dalton.style.display='block'; td.classList.add('active'); generateGasInputs(); }
  else if(which==='density'){ density.style.display='block'; tden.classList.add('active'); }
  else { ideal.style.display='block'; ti.classList.add('active'); }
}

function updateIdealUI(){
  const solve = document.getElementById('solveFor').value;
  document.getElementById('groupP').style.display = (solve === 'P') ? 'none' : 'block';
  document.getElementById('groupV').style.display = (solve === 'V') ? 'none' : 'block';
  document.getElementById('groupN').style.display = (solve === 'n') ? 'none' : 'block';
  document.getElementById('groupT').style.display = (solve === 'T') ? 'none' : 'block';
}

function calculateIdeal(){
  const solve = document.getElementById('solveFor').value;
  const P = parseFloat(document.getElementById('pressure').value);
  const Punit = document.getElementById('pressureUnit').value;
  const V = parseFloat(document.getElementById('volume').value);
  const Vunit = document.getElementById('volumeUnit').value;
  const n = parseFloat(document.getElementById('moles').value);
  const T = parseFloat(document.getElementById('temperature').value);
  const Tunit = document.getElementById('tempUnit').value;
  const res = document.getElementById('result');

  try {
    let result, unit, steps = '';

    if(solve === 'P'){
      if(!n || !V || !T) throw new Error('Enter n, V, and T');
      const TK = toKelvin(T, Tunit);
      const VL = toLiters(V, Vunit);
      const Patm = (n * R * TK) / VL;
      result = fromAtm(Patm, Punit);
      unit = Punit;
      steps = `<div class="result-section">
        <strong>Calculation:</strong>
        <div class="mt-2">P = nRT/V</div>
        <div>P = (${n} mol)(${R} L·atm/mol·K)(${TK.toFixed(2)} K) / (${VL.toFixed(4)} L)</div>
        <div>P = ${Patm.toFixed(4)} atm = ${result.toFixed(4)} ${unit}</div>
      </div>`;
    } else if(solve === 'V'){
      if(!n || !P || !T) throw new Error('Enter n, P, and T');
      const TK = toKelvin(T, Tunit);
      const Patm = toAtm(P, Punit);
      const VL = (n * R * TK) / Patm;
      result = fromLiters(VL, Vunit);
      unit = Vunit;
      steps = `<div class="result-section">
        <strong>Calculation:</strong>
        <div class="mt-2">V = nRT/P</div>
        <div>V = (${n} mol)(${R} L·atm/mol·K)(${TK.toFixed(2)} K) / (${Patm.toFixed(4)} atm)</div>
        <div>V = ${VL.toFixed(4)} L = ${result.toFixed(4)} ${unit}</div>
      </div>`;
    } else if(solve === 'n'){
      if(!P || !V || !T) throw new Error('Enter P, V, and T');
      const TK = toKelvin(T, Tunit);
      const Patm = toAtm(P, Punit);
      const VL = toLiters(V, Vunit);
      result = (Patm * VL) / (R * TK);
      unit = 'mol';
      steps = `<div class="result-section">
        <strong>Calculation:</strong>
        <div class="mt-2">n = PV/RT</div>
        <div>n = (${Patm.toFixed(4)} atm)(${VL.toFixed(4)} L) / ((${R} L·atm/mol·K)(${TK.toFixed(2)} K))</div>
        <div>n = ${result.toFixed(6)} mol</div>
      </div>`;
    } else if(solve === 'T'){
      if(!P || !V || !n) throw new Error('Enter P, V, and n');
      const Patm = toAtm(P, Punit);
      const VL = toLiters(V, Vunit);
      const TK = (Patm * VL) / (n * R);
      result = fromKelvin(TK, Tunit);
      unit = Tunit;
      steps = `<div class="result-section">
        <strong>Calculation:</strong>
        <div class="mt-2">T = PV/nR</div>
        <div>T = (${Patm.toFixed(4)} atm)(${VL.toFixed(4)} L) / ((${n} mol)(${R} L·atm/mol·K))</div>
        <div>T = ${TK.toFixed(2)} K = ${result.toFixed(2)} ${unit}</div>
      </div>`;
    }

    const resultHTML = `
      ${steps}
      <div class="result-section">
        <span class="result-badge">${solve} = ${result.toFixed(4)} ${unit}</span>
      </div>
    `;

    res.innerHTML = resultHTML;
    res.dataset.result = `${solve} = ${result.toFixed(4)} ${unit}`;
    res.dataset.latex = `${solve} = ${result.toFixed(4)}\\text{ ${unit}}`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function calculateCombined(){
  const solve = document.getElementById('combinedSolve').value;
  let P1 = parseFloat(document.getElementById('P1').value);
  let V1 = parseFloat(document.getElementById('V1').value);
  let T1 = parseFloat(document.getElementById('T1').value);
  let P2 = parseFloat(document.getElementById('P2').value);
  let V2 = parseFloat(document.getElementById('V2').value);
  let T2 = parseFloat(document.getElementById('T2').value);

  const P1u = document.getElementById('P1Unit').value;
  const V1u = document.getElementById('V1Unit').value;
  const T1u = document.getElementById('T1Unit').value;
  const P2u = document.getElementById('P2Unit').value;
  const V2u = document.getElementById('V2Unit').value;
  const T2u = document.getElementById('T2Unit').value;

  const res = document.getElementById('combinedResult');

  try {
    // Convert to standard units
    P1 = toAtm(P1, P1u);
    V1 = toLiters(V1, V1u);
    T1 = toKelvin(T1, T1u);

    let result, unit;

    if(solve === 'P2'){
      if(!P1 || !V1 || !T1 || !V2 || !T2) throw new Error('Enter P1, V1, T1, V2, T2');
      V2 = toLiters(V2, V2u);
      T2 = toKelvin(T2, T2u);
      P2 = (P1 * V1 * T2) / (T1 * V2);
      result = fromAtm(P2, P2u);
      unit = P2u;
    } else if(solve === 'V2'){
      if(!P1 || !V1 || !T1 || !P2 || !T2) throw new Error('Enter P1, V1, T1, P2, T2');
      P2 = toAtm(P2, P2u);
      T2 = toKelvin(T2, T2u);
      V2 = (P1 * V1 * T2) / (P2 * T1);
      result = fromLiters(V2, V2u);
      unit = V2u;
    } else if(solve === 'T2'){
      if(!P1 || !V1 || !T1 || !P2 || !V2) throw new Error('Enter P1, V1, T1, P2, V2');
      P2 = toAtm(P2, P2u);
      V2 = toLiters(V2, V2u);
      T2 = (P2 * V2 * T1) / (P1 * V1);
      result = fromKelvin(T2, T2u);
      unit = T2u;
    }

    const resultHTML = `
      <div class="result-section">
        <strong>Combined Gas Law:</strong>
        <div class="mt-2">P₁V₁/T₁ = P₂V₂/T₂</div>
        <div class="mt-2"><span class="result-badge">${solve} = ${result.toFixed(4)} ${unit}</span></div>
      </div>
    `;

    res.innerHTML = resultHTML;
    res.dataset.result = `${solve} = ${result.toFixed(4)} ${unit}`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function generateGasInputs(){
  const num = parseInt(document.getElementById('numGases').value) || 2;
  const container = document.getElementById('gasInputs');
  let html = '';
  for(let i = 1; i <= num; i++){
    html += `<div class="form-group">
      <label for="gas${i}">Gas ${i} partial pressure</label>
      <input type="number" id="gas${i}" class="form-control" placeholder="e.g., 0.5" step="any">
    </div>`;
  }
  container.innerHTML = html;
}

function calculateDalton(){
  const num = parseInt(document.getElementById('numGases').value);
  const unit = document.getElementById('daltonUnit').value;
  const res = document.getElementById('daltonResult');

  try {
    let total = 0;
    let details = '';
    for(let i = 1; i <= num; i++){
      const val = parseFloat(document.getElementById(`gas${i}`).value);
      if(!val || val <= 0) throw new Error(`Enter pressure for Gas ${i}`);
      total += val;
      details += `<div>P${i} = ${val} ${unit}</div>`;
    }

    const resultHTML = `
      <div class="result-section">
        <strong>Dalton's Law:</strong>
        <div class="mt-2">${details}</div>
        <div class="mt-3"><span class="result-badge">P<sub>total</sub> = ${total.toFixed(4)} ${unit}</span></div>
      </div>
    `;

    res.innerHTML = resultHTML;
    res.dataset.result = `Total Pressure = ${total.toFixed(4)} ${unit}`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function updateDensityUI(){
  const solve = document.getElementById('densitySolve').value;
  document.getElementById('densityGroup').style.display = (solve === 'density') ? 'none' : 'block';
  document.getElementById('molarMassGroup').style.display = (solve === 'molarMass') ? 'none' : 'block';
}

function calculateDensity(){
  const solve = document.getElementById('densitySolve').value;
  const d = parseFloat(document.getElementById('density').value);
  const M = parseFloat(document.getElementById('molarMass').value);
  const P = parseFloat(document.getElementById('densityP').value);
  const Punit = document.getElementById('densityPUnit').value;
  const T = parseFloat(document.getElementById('densityT').value);
  const Tunit = document.getElementById('densityTUnit').value;
  const res = document.getElementById('densityResult');

  try {
    const Patm = toAtm(P, Punit);
    const TK = toKelvin(T, Tunit);

    let result, unit, steps;

    if(solve === 'density'){
      if(!M || !Patm || !TK) throw new Error('Enter M, P, and T');
      result = (Patm * M) / (R * TK);
      unit = 'g/L';
      steps = `<div class="result-section">
        <strong>Calculation:</strong>
        <div class="mt-2">d = PM/RT</div>
        <div>d = (${Patm.toFixed(4)} atm)(${M} g/mol) / ((${R})(${TK.toFixed(2)} K))</div>
        <div>d = ${result.toFixed(4)} g/L</div>
      </div>`;
    } else {
      if(!d || !Patm || !TK) throw new Error('Enter d, P, and T');
      result = (d * R * TK) / Patm;
      unit = 'g/mol';
      steps = `<div class="result-section">
        <strong>Calculation:</strong>
        <div class="mt-2">M = dRT/P</div>
        <div>M = (${d} g/L)(${R})(${TK.toFixed(2)} K) / (${Patm.toFixed(4)} atm)</div>
        <div>M = ${result.toFixed(4)} g/mol</div>
      </div>`;
    }

    const resultHTML = `
      ${steps}
      <div class="result-section">
        <span class="result-badge">${result.toFixed(4)} ${unit}</span>
      </div>
    `;

    res.innerHTML = resultHTML;
    res.dataset.result = `${result.toFixed(4)} ${unit}`;

  } catch(e){
    res.innerHTML = `<div class="alert alert-warning">${e.message}</div>`;
  }
}

function resetIdeal(){
  ['pressure','volume','moles','temperature'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('result').innerHTML = '';
}

function resetCombined(){
  ['P1','V1','T1','P2','V2','T2'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('combinedResult').innerHTML = '';
}

function resetDalton(){
  const num = parseInt(document.getElementById('numGases').value);
  for(let i = 1; i <= num; i++){
    const el = document.getElementById(`gas${i}`);
    if(el) el.value = '';
  }
  document.getElementById('daltonResult').innerHTML = '';
}

function resetDensity(){
  ['density','molarMass','densityP','densityT'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('densityResult').innerHTML = '';
}

function copyResult(){
  const el = document.getElementById('result');
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

function copyCombinedResult(){
  const el = document.getElementById('combinedResult');
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

function copyDaltonResult(){
  const el = document.getElementById('daltonResult');
  const text = el.dataset.result || el.innerText || '';
  if(navigator.clipboard) navigator.clipboard.writeText(text);
}

function copyDensityResult(){
  const el = document.getElementById('densityResult');
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
  const text = el.dataset.result || '';
  if(!text) return;

  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  ctx.font = '20px Arial';
  const w = ctx.measureText(text).width;
  const pad = 30;

  canvas.width = w + pad * 2;
  canvas.height = 100;

  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#000000';
  ctx.font = '20px Arial';
  ctx.fillText(text, pad, 50);

  const a = document.createElement('a');
  a.href = canvas.toDataURL('image/png');
  a.download = 'ideal-gas-result.png';
  a.click();
}

function shareLink(){
  const params = new URLSearchParams();
  const solve = document.getElementById('solveFor').value;
  params.set('solve', solve);
  ['pressure','volume','moles','temperature'].forEach(id => {
    const val = document.getElementById(id).value;
    if(val) params.set(id, val);
  });

  const url = window.location.origin + window.location.pathname + '?' + params.toString();
  if(navigator.clipboard) navigator.clipboard.writeText(url);
  window.history.replaceState({}, '', url);
}

// Initialize
(function(){
  updateIdealUI();
  updateDensityUI();
  generateGasInputs();

  const params = new URLSearchParams(window.location.search);
  const solve = params.get('solve');
  if(solve) document.getElementById('solveFor').value = solve;

  ['pressure','volume','moles','temperature'].forEach(id => {
    const val = params.get(id);
    if(val) document.getElementById(id).value = val;
  });

  updateIdealUI();
})();
</script>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Ideal Gas Law Calculator",
  "alternateName": ["PV=nRT Calculator", "Gas Law Calculator", "Combined Gas Law Calculator"],
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "inLanguage": "en",
  "isAccessibleForFree": true,
  "url": "https://8gwifi.org/ideal-gas-law-calculator.jsp",
  "image": "https://8gwifi.org/images/site/ideal-gas.png",
  "description": "Free ideal gas law calculator (PV=nRT). Calculate P, V, n, or T. Includes combined gas law, Dalton's law, and gas density calculations.",
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
  "name": "Ideal Gas Law Calculator",
  "url": "https://8gwifi.org/ideal-gas-law-calculator.jsp",
  "description": "Calculate pressure, volume, moles, and temperature using PV=nRT.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "Ideal Gas Law Calculator", "item": "https://8gwifi.org/ideal-gas-law-calculator.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "What is the ideal gas law?", "acceptedAnswer": {"@type": "Answer", "text": "The ideal gas law is PV=nRT, relating pressure (P), volume (V), moles (n), and temperature (T) of an ideal gas, where R is the gas constant."}},
    {"@type": "Question", "name": "What is STP in chemistry?", "acceptedAnswer": {"@type": "Answer", "text": "STP (Standard Temperature and Pressure) is 273.15 K (0°C) and 1 atm. At STP, 1 mole of ideal gas occupies 22.4 liters."}},
    {"@type": "Question", "name": "What is Dalton's law of partial pressures?", "acceptedAnswer": {"@type": "Answer", "text": "Dalton's law states that the total pressure of a gas mixture equals the sum of the partial pressures of individual gases: P_total = P1 + P2 + P3 + ..."}}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Calculate gas volume using ideal gas law",
  "description": "Step-by-step guide to calculate volume using PV=nRT",
  "totalTime": "PT2M",
  "step": [
    {"@type": "HowToStep", "name": "Identify known values", "text": "Identify pressure P, moles n, and temperature T (in Kelvin)."},
    {"@type": "HowToStep", "name": "Use formula", "text": "Apply V = nRT/P where R = 0.08206 L·atm/(mol·K)."},
    {"@type": "HowToStep", "name": "Calculate", "text": "Substitute values and calculate volume V in liters."}
  ]
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
