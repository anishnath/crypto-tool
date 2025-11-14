<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Electron Configuration Calculator | Orbital Diagram + Noble Gas Notation | Free | 8gwifi.org</title>
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/electron-configuration-calculator.jsp">
  <meta name="description" content="Free electron configuration calculator. Generate full electron configurations, noble gas notation, orbital diagrams, and identify valence electrons for any element or ion. No sign-up; runs in your browser.">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="8gwifi.org">
  <meta property="og:title" content="Electron Configuration Calculator | Orbital Diagram (Free)">
  <meta property="og:description" content="Calculate electron configurations, orbital diagrams, and noble gas notation for elements and ions. Free and browser-only.">
  <meta property="og:url" content="https://8gwifi.org/electron-configuration-calculator.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/electron-config.png">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@anish2good">
  <meta name="twitter:title" content="Electron Configuration Calculator | Free Online Tool">
  <meta name="twitter:description" content="Generate electron configurations, orbital diagrams, and noble gas notation.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/electron-config.png">

  <style>
    .min-h-result { min-height: 220px; max-height: 600px; overflow-y: auto; }
    @media (min-width: 992px) { .min-h-result { min-height: 320px; max-height: 70vh; } }
    .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; max-height: calc(100vh - 100px); }
    .sticky-side .card-body { overflow-y: auto; max-height: calc(100vh - 150px); }
    .options-bar { display:flex; flex-wrap: wrap; gap: .75rem; align-items:center; }
    .config-display { font-family: SFMono-Regular, Menlo, Monaco, Consolas, monospace; font-size: 1.1rem; padding: .75rem; background: #f8f9fa; border-radius: .35rem; margin: .5rem 0; }
    .orbital-diagram { margin: 1rem 0; }
    .orbital-level { margin-bottom: .75rem; }
    .orbital-label { font-weight: 600; min-width: 50px; display: inline-block; }
    .orbital-box { display: inline-block; width: 40px; height: 40px; border: 2px solid #333; margin: 0 3px; position: relative; vertical-align: middle; }
    .electron-up { position: absolute; left: 50%; transform: translateX(-50%); bottom: 2px; }
    .electron-down { position: absolute; left: 50%; transform: translateX(-50%); top: 2px; }
    .arrow-up::before { content: '↑'; font-size: 24px; color: #2563eb; }
    .arrow-down::before { content: '↓'; font-size: 24px; color: #dc2626; }
    .result-badge { display: inline-block; padding: .5rem .8rem; background: #e6f4ea; color: #0f5132; border: 1px solid #badbcc; border-radius: .35rem; font-weight: 600; margin: .25rem; }
    .element-info { padding: .75rem; background: #f0f9ff; border-left: 4px solid #0284c7; border-radius: .35rem; margin: .5rem 0; }
    .preset-element { display: inline-block; padding: .35rem .6rem; margin: .25rem; background: #f3f4f6; border: 1px solid #d1d5db; border-radius: .35rem; cursor: pointer; font-size: 0.9rem; }
    .preset-element:hover { background: #e5e7eb; }
    sup { font-size: 0.75em; }
    #elementSelect { font-size: 0.95rem; }
    #elementSelect option { padding: 0.5rem; }
    .element-noble-gas { background: #e0f2fe; }
    .element-alkali { background: #fef3c7; }
    .element-alkaline { background: #fce7f3; }
    .element-transition { background: #ddd6fe; }
    .element-metal { background: #e0e7ff; }
    .element-metalloid { background: #d1fae5; }
    .element-nonmetal { background: #fef08a; }
    .element-halogen { background: #fecdd3; }
    .element-lanthanide { background: #fbcfe8; }
    .element-actinide { background: #fecaca; }
  </style>
  <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<div class="container mt-5">
  <h1 class="mb-3">Electron Configuration Calculator</h1>
  <p class="lead mb-4">Generate full electron configurations, noble gas notation, orbital diagrams, and identify valence electrons for any element (1-118) or ion.</p>

  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Input</h5>

          <div class="form-row">
            <div class="form-group col-md-8">
              <label for="elementSelect">Select Element</label>
              <select id="elementSelect" class="form-control" onchange="loadFromDropdown()">
                <option value="">-- Select an element --</option>
              </select>
            </div>
            <div class="form-group col-md-4">
              <label for="charge">Charge (optional)</label>
              <input type="number" id="charge" class="form-control" placeholder="e.g., +2 or -1" oninput="if(autoCalc.checked) calculateConfig()">
            </div>
          </div>

          <div class="form-row">
            <div class="form-group col-md-12">
              <label for="atomicNumber">Or Enter Atomic Number/Symbol</label>
              <input type="text" id="atomicNumber" class="form-control" placeholder="e.g., 26 or Fe" oninput="if(autoCalc.checked) calculateConfig()">
              <small class="form-text text-muted">You can also type directly here</small>
            </div>
          </div>

          <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="autoCalc" checked>
            <label class="form-check-label" for="autoCalc">Auto-calculate</label>
          </div>

          <div class="mb-3">
            <small class="text-muted d-block mb-2">Element categories in dropdown are color-coded:</small>
            <div class="d-flex flex-wrap" style="gap: 0.5rem; font-size: 0.8rem;">
              <span style="padding: 0.15rem 0.4rem; background: #fef3c7; border-radius: 0.25rem;">Alkali</span>
              <span style="padding: 0.15rem 0.4rem; background: #fce7f3; border-radius: 0.25rem;">Alkaline</span>
              <span style="padding: 0.15rem 0.4rem; background: #ddd6fe; border-radius: 0.25rem;">Transition</span>
              <span style="padding: 0.15rem 0.4rem; background: #e0e7ff; border-radius: 0.25rem;">Metal</span>
              <span style="padding: 0.15rem 0.4rem; background: #d1fae5; border-radius: 0.25rem;">Metalloid</span>
              <span style="padding: 0.15rem 0.4rem; background: #fef08a; border-radius: 0.25rem;">Nonmetal</span>
              <span style="padding: 0.15rem 0.4rem; background: #fecdd3; border-radius: 0.25rem;">Halogen</span>
              <span style="padding: 0.15rem 0.4rem; background: #e0f2fe; border-radius: 0.25rem;">Noble Gas</span>
              <span style="padding: 0.15rem 0.4rem; background: #fbcfe8; border-radius: 0.25rem;">Lanthanide</span>
              <span style="padding: 0.15rem 0.4rem; background: #fecaca; border-radius: 0.25rem;">Actinide</span>
            </div>
          </div>

          <div class="mb-3">
            <small class="text-muted d-block mb-2">Quick select common elements:</small>
            <div>
              <span class="preset-element" onclick="loadElement('1')">H (1)</span>
              <span class="preset-element" onclick="loadElement('6')">C (6)</span>
              <span class="preset-element" onclick="loadElement('7')">N (7)</span>
              <span class="preset-element" onclick="loadElement('8')">O (8)</span>
              <span class="preset-element" onclick="loadElement('11')">Na (11)</span>
              <span class="preset-element" onclick="loadElement('17')">Cl (17)</span>
              <span class="preset-element" onclick="loadElement('26')">Fe (26)</span>
              <span class="preset-element" onclick="loadElement('29')">Cu (29)</span>
              <span class="preset-element" onclick="loadElement('47')">Ag (47)</span>
              <span class="preset-element" onclick="loadElement('79')">Au (79)</span>
            </div>
          </div>

          <div class="options-bar mb-3">
            <button class="btn btn-primary" onclick="calculateConfig()">Calculate</button>
            <button class="btn btn-outline-secondary" onclick="resetCalc()">Reset</button>
            <button class="btn btn-outline-secondary" onclick="copyResult()">📋 Copy</button>
            <button class="btn btn-outline-secondary" onclick="copyLaTeX()">𝛌 LaTeX</button>
            <button class="btn btn-outline-secondary" onclick="exportPNG()">🖼 PNG</button>
            <button class="btn btn-outline-secondary" onclick="shareLink()">🔗 Share</button>
          </div>

          <div class="small text-muted">
            <div><strong>Aufbau Principle:</strong> Electrons fill orbitals in order of increasing energy</div>
            <div><strong>Order:</strong> 1s, 2s, 2p, 3s, 3p, 4s, 3d, 4p, 5s, 4d, 5p, 6s, 4f, 5d, 6p, 7s, 5f, 6d, 7p</div>
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

<!-- Learn Section -->
<div class="container mt-5 pt-4">
  <div id="learn" class="card shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3">What Is Electron Configuration?</h5>
      <p>Electron configuration describes the distribution of electrons in an atom's orbitals. It follows three key principles:</p>

      <h6 class="mt-4">Key Principles</h6>
      <ul class="mb-3">
        <li><strong>Aufbau Principle:</strong> Electrons fill orbitals from lowest to highest energy</li>
        <li><strong>Pauli Exclusion Principle:</strong> Each orbital holds max 2 electrons with opposite spins</li>
        <li><strong>Hund's Rule:</strong> Electrons fill degenerate orbitals singly before pairing</li>
      </ul>

      <h6>Orbital Capacity</h6>
      <ul class="mb-3">
        <li><strong>s orbitals:</strong> 1 orbital, max 2 electrons</li>
        <li><strong>p orbitals:</strong> 3 orbitals, max 6 electrons</li>
        <li><strong>d orbitals:</strong> 5 orbitals, max 10 electrons</li>
        <li><strong>f orbitals:</strong> 7 orbitals, max 14 electrons</li>
      </ul>

      <h6>Noble Gas Notation</h6>
      <p>A shorthand that uses the previous noble gas in brackets, followed by the remaining electron configuration. For example, Fe (26 electrons): [Ar] 4s² 3d⁶</p>

      <h5 class="mt-3 mb-2">Worked Examples</h5>

      <div class="mb-3">
        <p class="mb-1"><strong>1) Carbon (C, Z=6)</strong></p>
        <p class="mb-1">Full: 1s² 2s² 2p²</p>
        <p class="mb-1">Noble gas: [He] 2s² 2p²</p>
        <p class="mb-1">Valence: 4 electrons (2s² 2p²)</p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>2) Iron (Fe, Z=26)</strong></p>
        <p class="mb-1">Full: 1s² 2s² 2p⁶ 3s² 3p⁶ 4s² 3d⁶</p>
        <p class="mb-1">Noble gas: [Ar] 4s² 3d⁶</p>
        <p class="mb-1">Valence: 2 electrons in 4s (d electrons are not valence for transition metals)</p>
      </div>

      <div class="mb-3">
        <p class="mb-1"><strong>3) Iron(II) Ion (Fe²⁺, Z=26, charge=+2)</strong></p>
        <p class="mb-1">Remove 2 electrons from highest energy level (4s before 3d for ions)</p>
        <p class="mb-1">Full: 1s² 2s² 2p⁶ 3s² 3p⁶ 3d⁶</p>
        <p class="mb-1">Noble gas: [Ar] 3d⁶</p>
      </div>

      <h6 class="mt-4">Exceptions to Aufbau Principle</h6>
      <p>Some elements have unexpected configurations due to orbital stability:</p>
      <ul class="mb-3">
        <li><strong>Chromium (Cr, Z=24):</strong> [Ar] 4s¹ 3d⁵ (not 4s² 3d⁴) - half-filled d subshell is more stable</li>
        <li><strong>Copper (Cu, Z=29):</strong> [Ar] 4s¹ 3d¹⁰ (not 4s² 3d⁹) - filled d subshell is more stable</li>
        <li><strong>Silver (Ag, Z=47):</strong> [Kr] 5s¹ 4d¹⁰</li>
        <li><strong>Gold (Au, Z=79):</strong> [Xe] 6s¹ 4f¹⁴ 5d¹⁰</li>
      </ul>

      <h6 class="mt-4">Quantum Numbers</h6>
      <div class="table-responsive">
        <table class="table table-sm">
          <thead>
            <tr><th>Quantum Number</th><th>Symbol</th><th>Describes</th><th>Values</th></tr>
          </thead>
          <tbody>
            <tr><td>Principal</td><td>n</td><td>Energy level/shell</td><td>1, 2, 3, 4...</td></tr>
            <tr><td>Angular momentum</td><td>l</td><td>Subshell shape</td><td>0 to n-1 (s=0, p=1, d=2, f=3)</td></tr>
            <tr><td>Magnetic</td><td>m<sub>l</sub></td><td>Orbital orientation</td><td>-l to +l</td></tr>
            <tr><td>Spin</td><td>m<sub>s</sub></td><td>Electron spin</td><td>+½ or -½</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
const elements = {
  1: {symbol: 'H', name: 'Hydrogen'}, 2: {symbol: 'He', name: 'Helium'}, 3: {symbol: 'Li', name: 'Lithium'},
  4: {symbol: 'Be', name: 'Beryllium'}, 5: {symbol: 'B', name: 'Boron'}, 6: {symbol: 'C', name: 'Carbon'},
  7: {symbol: 'N', name: 'Nitrogen'}, 8: {symbol: 'O', name: 'Oxygen'}, 9: {symbol: 'F', name: 'Fluorine'},
  10: {symbol: 'Ne', name: 'Neon'}, 11: {symbol: 'Na', name: 'Sodium'}, 12: {symbol: 'Mg', name: 'Magnesium'},
  13: {symbol: 'Al', name: 'Aluminum'}, 14: {symbol: 'Si', name: 'Silicon'}, 15: {symbol: 'P', name: 'Phosphorus'},
  16: {symbol: 'S', name: 'Sulfur'}, 17: {symbol: 'Cl', name: 'Chlorine'}, 18: {symbol: 'Ar', name: 'Argon'},
  19: {symbol: 'K', name: 'Potassium'}, 20: {symbol: 'Ca', name: 'Calcium'}, 21: {symbol: 'Sc', name: 'Scandium'},
  22: {symbol: 'Ti', name: 'Titanium'}, 23: {symbol: 'V', name: 'Vanadium'}, 24: {symbol: 'Cr', name: 'Chromium'},
  25: {symbol: 'Mn', name: 'Manganese'}, 26: {symbol: 'Fe', name: 'Iron'}, 27: {symbol: 'Co', name: 'Cobalt'},
  28: {symbol: 'Ni', name: 'Nickel'}, 29: {symbol: 'Cu', name: 'Copper'}, 30: {symbol: 'Zn', name: 'Zinc'},
  31: {symbol: 'Ga', name: 'Gallium'}, 32: {symbol: 'Ge', name: 'Germanium'}, 33: {symbol: 'As', name: 'Arsenic'},
  34: {symbol: 'Se', name: 'Selenium'}, 35: {symbol: 'Br', name: 'Bromine'}, 36: {symbol: 'Kr', name: 'Krypton'},
  37: {symbol: 'Rb', name: 'Rubidium'}, 38: {symbol: 'Sr', name: 'Strontium'}, 39: {symbol: 'Y', name: 'Yttrium'},
  40: {symbol: 'Zr', name: 'Zirconium'}, 41: {symbol: 'Nb', name: 'Niobium'}, 42: {symbol: 'Mo', name: 'Molybdenum'},
  43: {symbol: 'Tc', name: 'Technetium'}, 44: {symbol: 'Ru', name: 'Ruthenium'}, 45: {symbol: 'Rh', name: 'Rhodium'},
  46: {symbol: 'Pd', name: 'Palladium'}, 47: {symbol: 'Ag', name: 'Silver'}, 48: {symbol: 'Cd', name: 'Cadmium'},
  49: {symbol: 'In', name: 'Indium'}, 50: {symbol: 'Sn', name: 'Tin'}, 51: {symbol: 'Sb', name: 'Antimony'},
  52: {symbol: 'Te', name: 'Tellurium'}, 53: {symbol: 'I', name: 'Iodine'}, 54: {symbol: 'Xe', name: 'Xenon'},
  55: {symbol: 'Cs', name: 'Cesium'}, 56: {symbol: 'Ba', name: 'Barium'}, 57: {symbol: 'La', name: 'Lanthanum'},
  58: {symbol: 'Ce', name: 'Cerium'}, 59: {symbol: 'Pr', name: 'Praseodymium'}, 60: {symbol: 'Nd', name: 'Neodymium'},
  61: {symbol: 'Pm', name: 'Promethium'}, 62: {symbol: 'Sm', name: 'Samarium'}, 63: {symbol: 'Eu', name: 'Europium'},
  64: {symbol: 'Gd', name: 'Gadolinium'}, 65: {symbol: 'Tb', name: 'Terbium'}, 66: {symbol: 'Dy', name: 'Dysprosium'},
  67: {symbol: 'Ho', name: 'Holmium'}, 68: {symbol: 'Er', name: 'Erbium'}, 69: {symbol: 'Tm', name: 'Thulium'},
  70: {symbol: 'Yb', name: 'Ytterbium'}, 71: {symbol: 'Lu', name: 'Lutetium'}, 72: {symbol: 'Hf', name: 'Hafnium'},
  73: {symbol: 'Ta', name: 'Tantalum'}, 74: {symbol: 'W', name: 'Tungsten'}, 75: {symbol: 'Re', name: 'Rhenium'},
  76: {symbol: 'Os', name: 'Osmium'}, 77: {symbol: 'Ir', name: 'Iridium'}, 78: {symbol: 'Pt', name: 'Platinum'},
  79: {symbol: 'Au', name: 'Gold'}, 80: {symbol: 'Hg', name: 'Mercury'}, 81: {symbol: 'Tl', name: 'Thallium'},
  82: {symbol: 'Pb', name: 'Lead'}, 83: {symbol: 'Bi', name: 'Bismuth'}, 84: {symbol: 'Po', name: 'Polonium'},
  85: {symbol: 'At', name: 'Astatine'}, 86: {symbol: 'Rn', name: 'Radon'}, 87: {symbol: 'Fr', name: 'Francium'},
  88: {symbol: 'Ra', name: 'Radium'}, 89: {symbol: 'Ac', name: 'Actinium'}, 90: {symbol: 'Th', name: 'Thorium'},
  91: {symbol: 'Pa', name: 'Protactinium'}, 92: {symbol: 'U', name: 'Uranium'}, 93: {symbol: 'Np', name: 'Neptunium'},
  94: {symbol: 'Pu', name: 'Plutonium'}, 95: {symbol: 'Am', name: 'Americium'}, 96: {symbol: 'Cm', name: 'Curium'},
  97: {symbol: 'Bk', name: 'Berkelium'}, 98: {symbol: 'Cf', name: 'Californium'}, 99: {symbol: 'Es', name: 'Einsteinium'},
  100: {symbol: 'Fm', name: 'Fermium'}, 101: {symbol: 'Md', name: 'Mendelevium'}, 102: {symbol: 'No', name: 'Nobelium'},
  103: {symbol: 'Lr', name: 'Lawrencium'}, 104: {symbol: 'Rf', name: 'Rutherfordium'}, 105: {symbol: 'Db', name: 'Dubnium'},
  106: {symbol: 'Sg', name: 'Seaborgium'}, 107: {symbol: 'Bh', name: 'Bohrium'}, 108: {symbol: 'Hs', name: 'Hassium'},
  109: {symbol: 'Mt', name: 'Meitnerium'}, 110: {symbol: 'Ds', name: 'Darmstadtium'}, 111: {symbol: 'Rg', name: 'Roentgenium'},
  112: {symbol: 'Cn', name: 'Copernicium'}, 113: {symbol: 'Nh', name: 'Nihonium'}, 114: {symbol: 'Fl', name: 'Flerovium'},
  115: {symbol: 'Mc', name: 'Moscovium'}, 116: {symbol: 'Lv', name: 'Livermorium'}, 117: {symbol: 'Ts', name: 'Tennessine'},
  118: {symbol: 'Og', name: 'Oganesson'}
};

const symbolToZ = {};
Object.keys(elements).forEach(z => {
  symbolToZ[elements[z].symbol.toLowerCase()] = parseInt(z);
});

// Element categories for coloring
const elementCategories = {
  'noble-gas': [2, 10, 18, 36, 54, 86, 118],
  'alkali': [3, 11, 19, 37, 55, 87],
  'alkaline': [4, 12, 20, 38, 56, 88],
  'transition': [21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 72, 73, 74, 75, 76, 77, 78, 79, 80, 104, 105, 106, 107, 108, 109, 110, 111, 112],
  'metal': [13, 31, 49, 50, 81, 82, 83, 84, 113, 114, 115, 116],
  'metalloid': [5, 14, 32, 33, 51, 52, 85],
  'nonmetal': [1, 6, 7, 8, 15, 16, 34],
  'halogen': [9, 17, 35, 53, 85, 117],
  'lanthanide': [57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71],
  'actinide': [89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103]
};

function getElementCategory(z){
  for(const [category, elements] of Object.entries(elementCategories)){
    if(elements.includes(z)) return category;
  }
  return '';
}

// Populate dropdown on page load
function populateElementDropdown(){
  const select = document.getElementById('elementSelect');
  Object.keys(elements).forEach(z => {
    const el = elements[z];
    const option = document.createElement('option');
    option.value = z;
    option.textContent = `${z} - ${el.symbol} (${el.name})`;
    const category = getElementCategory(parseInt(z));
    if(category) option.className = `element-${category}`;
    select.appendChild(option);
  });
}

function loadFromDropdown(){
  const z = document.getElementById('elementSelect').value;
  if(z){
    document.getElementById('atomicNumber').value = z;
    if(document.getElementById('autoCalc').checked) calculateConfig();
  }
}

const orbitalOrder = [
  ['1s', 2], ['2s', 2], ['2p', 6], ['3s', 2], ['3p', 6], ['4s', 2], ['3d', 10], ['4p', 6],
  ['5s', 2], ['4d', 10], ['5p', 6], ['6s', 2], ['4f', 14], ['5d', 10], ['6p', 6],
  ['7s', 2], ['5f', 14], ['6d', 10], ['7p', 6]
];

const nobleGases = {2: 'He', 10: 'Ne', 18: 'Ar', 36: 'Kr', 54: 'Xe', 86: 'Rn', 118: 'Og'};

// Exceptions to Aufbau principle
const exceptions = {
  24: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 1, '3d', 5], // Cr
  29: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 1, '3d', 10], // Cu
  41: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 1, '4d', 4], // Nb
  42: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 1, '4d', 5], // Mo
  44: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 1, '4d', 7], // Ru
  45: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 1, '4d', 8], // Rh
  46: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '4d', 10], // Pd
  47: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 1, '4d', 10], // Ag
  78: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 2, '4d', 10, '5p', 6, '6s', 1, '4f', 14, '5d', 9], // Pt
  79: ['1s', 2, '2s', 2, '2p', 6, '3s', 2, '3p', 6, '4s', 2, '3d', 10, '4p', 6, '5s', 2, '4d', 10, '5p', 6, '6s', 1, '4f', 14, '5d', 10] // Au
};

function parseInput(input){
  input = input.trim();
  const num = parseInt(input);
  if(!isNaN(num) && num >= 1 && num <= 118) return num;

  const sym = symbolToZ[input.toLowerCase()];
  if(sym) return sym;

  return null;
}

function loadElement(z){
  document.getElementById('atomicNumber').value = z;
  document.getElementById('elementSelect').value = z;
  document.getElementById('charge').value = '';
  if(document.getElementById('autoCalc').checked) calculateConfig();
}

function getElectronConfig(electrons, Z){
  if(exceptions[Z]) return exceptions[Z];

  const config = [];
  let remaining = electrons;

  for(let i = 0; i < orbitalOrder.length && remaining > 0; i++){
    const [orbital, capacity] = orbitalOrder[i];
    const fill = Math.min(remaining, capacity);
    config.push(orbital, fill);
    remaining -= fill;
  }

  return config;
}

function configToString(config){
  let str = '';
  for(let i = 0; i < config.length; i += 2){
    str += config[i] + '<sup>' + config[i+1] + '</sup> ';
  }
  return str.trim();
}

function getNobleGasNotation(config, Z){
  let ngZ = 0;
  Object.keys(nobleGases).forEach(z => {
    z = parseInt(z);
    if(z < Z) ngZ = z;
  });

  if(ngZ === 0) return configToString(config);

  const ngConfig = getElectronConfig(ngZ, ngZ);
  let skipCount = 0;

  for(let i = 0; i < ngConfig.length; i += 2){
    skipCount += ngConfig[i+1];
  }

  let remaining = [];
  let counted = 0;
  for(let i = 0; i < config.length; i += 2){
    if(counted < skipCount){
      counted += config[i+1];
    } else {
      remaining.push(config[i], config[i+1]);
    }
  }

  return '[' + nobleGases[ngZ] + '] ' + configToString(remaining);
}

function getValenceElectrons(config){
  // Valence = electrons in highest principal quantum number
  let maxN = 0;
  let valence = 0;

  for(let i = 0; i < config.length; i += 2){
    const orbital = config[i];
    const count = config[i+1];
    const n = parseInt(orbital.charAt(0));

    if(n > maxN){
      maxN = n;
      valence = count;
    } else if(n === maxN){
      valence += count;
    }
  }

  return valence;
}

function generateOrbitalDiagram(config){
  const diagram = {};

  for(let i = 0; i < config.length; i += 2){
    const orbital = config[i];
    const electrons = config[i+1];
    const type = orbital.substring(1); // s, p, d, f

    let boxes = 1;
    if(type === 'p') boxes = 3;
    else if(type === 'd') boxes = 5;
    else if(type === 'f') boxes = 7;

    const filling = [];
    let e = electrons;

    // First pass: add one electron to each box (Hund's rule)
    for(let b = 0; b < boxes && e > 0; b++){
      filling[b] = [1];
      e--;
    }

    // Second pass: pair up electrons
    for(let b = 0; b < boxes && e > 0; b++){
      filling[b].push(-1);
      e--;
    }

    diagram[orbital] = filling;
  }

  return diagram;
}

function renderOrbitalDiagram(diagram){
  let html = '<div class="orbital-diagram"><strong>Orbital Diagram:</strong>';

  Object.keys(diagram).forEach(orbital => {
    const boxes = diagram[orbital];
    html += '<div class="orbital-level">';
    html += `<span class="orbital-label">${orbital}</span>`;

    boxes.forEach(box => {
      html += '<div class="orbital-box">';
      if(box.includes(1)) html += '<div class="electron-up arrow-up"></div>';
      if(box.includes(-1)) html += '<div class="electron-down arrow-down"></div>';
      html += '</div>';
    });

    html += '</div>';
  });

  html += '</div>';
  return html;
}

function calculateConfig(){
  const input = document.getElementById('atomicNumber').value;
  const charge = parseInt(document.getElementById('charge').value) || 0;
  const res = document.getElementById('result');

  const Z = parseInput(input);

  if(!Z){
    res.innerHTML = '<div class="alert alert-warning">Enter a valid atomic number (1-118) or element symbol</div>';
    return;
  }

  const element = elements[Z];
  const electrons = Z - charge; // Positive charge = fewer electrons

  if(electrons <= 0 || electrons > 200){
    res.innerHTML = '<div class="alert alert-warning">Invalid electron count</div>';
    return;
  }

  const config = getElectronConfig(electrons, Z);
  const fullConfig = configToString(config);
  const nobleGas = getNobleGasNotation(config, Z);
  const valence = getValenceElectrons(config);
  const diagram = generateOrbitalDiagram(config);
  const orbitalHTML = renderOrbitalDiagram(diagram);

  const chargeStr = charge !== 0 ? (charge > 0 ? `<sup>${charge}+</sup>` : `<sup>${Math.abs(charge)}−</sup>`) : '';

  const resultHTML = `
    <div class="element-info">
      <strong>${element.name} (${element.symbol}${chargeStr})</strong>
      <div class="mt-1">Atomic Number: ${Z}</div>
      <div>Electrons: ${electrons}</div>
      ${charge !== 0 ? `<div>Charge: ${charge > 0 ? '+' + charge : charge}</div>` : ''}
    </div>

    <div class="result-section mt-3">
      <strong>Full Configuration:</strong>
      <div class="config-display">${fullConfig}</div>
    </div>

    <div class="result-section">
      <strong>Noble Gas Notation:</strong>
      <div class="config-display">${nobleGas}</div>
    </div>

    <div class="result-section">
      <span class="result-badge">Valence Electrons: ${valence}</span>
    </div>

    ${orbitalHTML}
  `;

  res.innerHTML = resultHTML;
  // Store properly formatted text for copy/export (using ^ for superscripts)
  const textConfig = fullConfig.replace(/<sup>/g, '^').replace(/<\/sup>/g, '');
  const textNobleGas = nobleGas.replace(/<sup>/g, '^').replace(/<\/sup>/g, '');
  res.dataset.result = `${element.name} (${element.symbol}${chargeStr.replace(/<[^>]*>/g, '')})\nFull: ${textConfig}\nNoble Gas: ${textNobleGas}\nValence: ${valence} electrons`;
  res.dataset.latex = generateLaTeX(element, fullConfig);
}

function generateLaTeX(element, fullConfig){
  // Convert HTML superscripts to LaTeX
  const latex = fullConfig.replace(/<sup>(\d+)<\/sup>/g, '^{$1}');
  return `\\text{${element.symbol}}: ${latex}`;
}

function resetCalc(){
  document.getElementById('atomicNumber').value = '';
  document.getElementById('charge').value = '';
  document.getElementById('result').innerHTML = '';
}

function copyResult(){
  const el = document.getElementById('result');
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

  const lines = text.split('\n').filter(l => l.trim());

  // Calculate max width considering superscripts
  let maxWidth = 0;
  lines.forEach(line => {
    let width = 0;
    let i = 0;
    while(i < line.length){
      if(line[i] === '^' && i + 1 < line.length && /\d/.test(line[i+1])){
        ctx.font = `${superFont}px Arial`;
        width += ctx.measureText(line[i+1]).width;
        i += 2;
      } else {
        ctx.font = `${baseFont}px Arial`;
        width += ctx.measureText(line[i]).width;
        i++;
      }
    }
    maxWidth = Math.max(maxWidth, width);
  });

  const lineHeight = 30;
  const pad = 30;
  canvas.width = maxWidth + pad * 2;
  canvas.height = lines.length * lineHeight + pad * 2;

  ctx.fillStyle = '#ffffff';
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.fillStyle = '#000000';

  // Draw each line with proper superscript formatting
  lines.forEach((line, lineIdx) => {
    let x = pad;
    const y = pad + (lineIdx + 1) * lineHeight;
    let i = 0;

    while(i < line.length){
      if(line[i] === '^' && i + 1 < line.length && /\d/.test(line[i+1])){
        // Draw superscript
        ctx.font = `${superFont}px Arial`;
        ctx.fillText(line[i+1], x, y - 8);
        x += ctx.measureText(line[i+1]).width;
        i += 2;
      } else {
        // Draw regular character
        ctx.font = `${baseFont}px Arial`;
        ctx.fillText(line[i], x, y);
        x += ctx.measureText(line[i]).width;
        i++;
      }
    }
  });

  const a = document.createElement('a');
  a.href = canvas.toDataURL('image/png');
  a.download = 'electron-config.png';
  a.click();
}

function shareLink(){
  const input = document.getElementById('atomicNumber').value;
  const charge = document.getElementById('charge').value;

  const params = new URLSearchParams();
  if(input) params.set('z', input);
  if(charge) params.set('charge', charge);

  const url = window.location.origin + window.location.pathname + '?' + params.toString();
  if(navigator.clipboard) navigator.clipboard.writeText(url);
  window.history.replaceState({}, '', url);
}

// Load from URL and initialize
(function(){
  // Populate dropdown first
  populateElementDropdown();

  const params = new URLSearchParams(window.location.search);
  const z = params.get('z');
  const charge = params.get('charge');

  if(z){
    document.getElementById('atomicNumber').value = z;
    document.getElementById('elementSelect').value = z;
  }
  if(charge) document.getElementById('charge').value = charge;

  if(z) calculateConfig();
})();
</script>

<!-- JSON-LD -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Electron Configuration Calculator",
  "alternateName": ["Electron Configuration Generator", "Orbital Diagram Calculator", "Noble Gas Notation Calculator"],
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "inLanguage": "en",
  "isAccessibleForFree": true,
  "url": "https://8gwifi.org/electron-configuration-calculator.jsp",
  "image": "https://8gwifi.org/images/site/electron-config.png",
  "description": "Free electron configuration calculator. Generate full configurations, noble gas notation, orbital diagrams, and identify valence electrons.",
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
  "name": "Electron Configuration Calculator",
  "url": "https://8gwifi.org/electron-configuration-calculator.jsp",
  "description": "Calculate electron configurations, orbital diagrams, and noble gas notation for elements and ions.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "Electron Configuration Calculator", "item": "https://8gwifi.org/electron-configuration-calculator.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "What is electron configuration?", "acceptedAnswer": {"@type": "Answer", "text": "Electron configuration describes how electrons are distributed in an atom's orbitals, following the Aufbau principle, Pauli exclusion principle, and Hund's rule."}},
    {"@type": "Question", "name": "What is noble gas notation?", "acceptedAnswer": {"@type": "Answer", "text": "Noble gas notation is a shorthand that uses the previous noble gas symbol in brackets, followed by the remaining electron configuration."}},
    {"@type": "Question", "name": "What are valence electrons?", "acceptedAnswer": {"@type": "Answer", "text": "Valence electrons are the electrons in the outermost energy level of an atom, responsible for chemical bonding."}}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Write electron configuration for an element",
  "description": "Step-by-step guide to determine electron configuration",
  "totalTime": "PT2M",
  "step": [
    {"@type": "HowToStep", "name": "Identify atomic number", "text": "Find the element's atomic number Z (number of protons = number of electrons)."},
    {"@type": "HowToStep", "name": "Fill orbitals", "text": "Fill orbitals in order: 1s, 2s, 2p, 3s, 3p, 4s, 3d, 4p, 5s, 4d, etc."},
    {"@type": "HowToStep", "name": "Write configuration", "text": "Write each orbital with its electron count as a superscript (e.g., 1s² 2s² 2p⁶)."}
  ]
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
</html>
