<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chemical Equation Balancer | Balance Equations + Steps (Free) | 8gwifi.org</title>
  <meta name="robots" content="index, follow">
  <link rel="canonical" href="https://8gwifi.org/chemical-equation-balancer.jsp">
  <meta name="description" content="Free online chemical equation balancer. Balance reactions with steps, atom counts, and formatted output. Supports parentheses and hydrates. No sign‑up; runs in your browser.">

  <!-- Open Graph -->
  <meta property="og:type" content="website">
  <meta property="og:site_name" content="8gwifi.org">
  <meta property="og:title" content="Chemical Equation Balancer | Balance Equations + Steps (Free)">
  <meta property="og:description" content="Balance chemical equations online with steps, atom counts, and formatted output. Free and browser‑only.">
  <meta property="og:url" content="https://8gwifi.org/chemical-equation-balancer.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/chem-balance.png">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@anish2good">
  <meta name="twitter:title" content="Chemical Equation Balancer | Free Online Tool">
  <meta name="twitter:description" content="Balance equations, see steps and atom counts. Works in your browser.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/chem-balance.png">

  <style>
    .min-h-result { min-height: 220px; max-height: 600px; overflow-y: auto; }
    @media (min-width: 992px) { .min-h-result { min-height: 280px; max-height: 70vh; } }
    .sticky-side { position: -webkit-sticky; position: sticky; top: 80px; max-height: calc(100vh - 100px); }
    .sticky-side .card-body { overflow-y: auto; max-height: calc(100vh - 150px); }
    .monospace { font-family: SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
    .eq-input { font-size: 1.05rem; }
    .coeff { font-weight: 600; margin-right: .25rem; }
    .atom-equal { color: #28a745; }
    .atom-mismatch { color: #dc3545; }
    .nowrap { white-space: nowrap; }
    .chip-bar { display: flex; flex-wrap: wrap; gap: .5rem; }
    .chip { display: inline-flex; align-items: center; gap: .35rem; padding: .25rem .5rem; border: 1px solid #ced4da; border-radius: 16px; background: #f8f9fa; }
    .chip .chip-formula { cursor: pointer; }
    .chip .btn-xs { padding: .05rem .35rem; font-size: .75rem; }
    .section-title { font-weight: 600; margin-top: .25rem; margin-bottom: .25rem; }
    .options-bar { display:flex; flex-wrap: wrap; gap: .75rem; align-items:center; }
    .examples a { margin-right: .5rem; }
  </style>
  <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>
<div class="container mt-5">
  <h1 class="mb-3">Chemical Equation Balancer</h1>
  <p class="lead mb-4">Balance chemical equations in your browser. Get integer coefficients, atom counts on each side, and a formatted balanced equation you can copy or share.</p>

  <!-- Tabs for Atom Balance and Redox (beta) -->
  <ul class="nav nav-tabs mb-3" role="tablist">
    <li class="nav-item">
      <a class="nav-link active" id="tab-atom" href="#" role="tab" onclick="switchSection('atom'); return false;">Atom Balance</a>
    </li>
    <li class="nav-item">
      <a class="nav-link" id="tab-redox" href="#" role="tab" onclick="switchSection('redox'); return false;">Redox (beta)</a>
    </li>
  </ul>

  <!-- Intro helper moved to Learn section below -->

  <div id="sectionAtom">
  <div class="row">
    <div class="col-lg-7 mb-4">
      <div class="card shadow-sm h-100">
        <div class="card-body">
          <h5 class="card-title">Input</h5>
          <form id="eqForm" onsubmit="event.preventDefault(); balanceEquation();">
            <div class="form-group">
              <label for="eq">Unbalanced Equation</label>
              <input type="text" id="eq" class="form-control eq-input monospace" placeholder="e.g., C3H8 + O2 -> CO2 + H2O" value="Fe + O2 -> Fe2O3">
              <small class="form-text text-muted">Use "+" to separate species, and "->" or "=>" between reactants and products.</small>
              <div id="eqPreview" class="small text-muted mt-2"></div>
            </div>

            <div class="options-bar mb-3">
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="checkbox" id="optAuto" checked>
                <label class="form-check-label" for="optAuto">Auto balance</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="checkbox" id="optHide1" checked>
                <label class="form-check-label" for="optHide1">Hide coefficient 1</label>
              </div>
              <div class="form-check form-check-inline">
                <input class="form-check-input" type="checkbox" id="optFrac">
                <label class="form-check-label" for="optFrac">Show fractions</label>
              </div>
            </div>

            <div class="mb-2 examples">
              <span class="text-muted mr-2">Examples:</span>
              <a href="#" onclick="loadExample('C3H8 + O2 -> CO2 + H2O');return false;">Combustion</a>
              <a href="#" onclick="loadExample('Fe + O2 -> Fe2O3');return false;">Oxidation</a>
              <a href="#" onclick="loadExample('Ca(OH)2 + H3PO4 -> Ca3(PO4)2 + H2O');return false;">Acid-Base</a>
              <a href="#" onclick="loadExample('CuSO4·5H2O -> CuSO4 + H2O');return false;">Hydrate</a>
            </div>

            <div class="mb-3">
              <div class="section-title">Reactants</div>
              <div id="chipsLeft" class="chip-bar mb-2"></div>
              <div class="input-group input-group-sm mb-3" style="max-width:420px;">
                <input id="addLeft" type="text" class="form-control monospace" placeholder="Add reactant (e.g., H2SO4)">
                <div class="input-group-append"><button class="btn btn-outline-secondary" type="button" onclick="addSpecies('left')">Add</button></div>
              </div>

              <div class="section-title">Products</div>
              <div id="chipsRight" class="chip-bar mb-2"></div>
              <div class="input-group input-group-sm" style="max-width:420px;">
                <input id="addRight" type="text" class="form-control monospace" placeholder="Add product (e.g., NaCl)">
                <div class="input-group-append"><button class="btn btn-outline-secondary" type="button" onclick="addSpecies('right')">Add</button></div>
              </div>
            </div>
            <div class="d-flex align-items-center">
              <button type="submit" class="btn btn-primary mr-2">Balance</button>
              <button type="reset" class="btn btn-outline-secondary" onclick="resetUI()">Reset</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-lg-5">
      <div class="card shadow-sm sticky-side">
        <div class="card-body">
          <h5 class="card-title mb-3">Result</h5>
          <div id="result" class="min-h-result"></div>
          <div class="mt-3">
            <h6 class="mb-2">History</h6>
            <div id="historyList" class="small"></div>
            <button class="btn btn-sm btn-link p-0 mt-1" onclick="clearHistory()">Clear history</button>
          </div>
        </div>
      </div>
    </div>
  </div>
  </div>
  <!-- End Atom section -->

  <!-- Redox (beta) section -->
  <div id="sectionRedox" style="display:none;">
    <div class="card shadow-sm mb-4">
      <div class="card-body">
        <h5 class="card-title">Redox Balance (Half-Reaction Method)</h5>
        <p class="text-muted mb-3">Guide: Enter two half‑reactions that are already balanced for atoms and charge in your chosen medium, including electrons (e<sup>−</sup>). This tool will equalize electrons and combine them into a net reaction.</p>
        <div class="form-row">
          <div class="form-group col-lg-6">
            <label for="redoxMedia">Medium</label>
            <select id="redoxMedia" class="form-control form-control-sm" style="max-width:220px;">
              <option value="acidic">Acidic (H<sup>+</sup>, H<sub>2</sub>O)</option>
              <option value="basic">Basic (OH<sup>−</sup>, H<sub>2</sub>O)</option>
            </select>
          </div>
        </div>
        <div class="form-group">
          <label for="halfOx">Oxidation Half‑Reaction (include e<sup>−</sup>)</label>
          <input id="halfOx" type="text" class="form-control monospace" placeholder="e.g., Fe2+ -> Fe3+ + e-" value="Fe2+ -> Fe3+ + e-">
        </div>
        <div class="form-group">
          <label for="halfRed">Reduction Half‑Reaction (include e<sup>−</sup>)</label>
          <input id="halfRed" type="text" class="form-control monospace" placeholder="e.g., MnO4- + 8H+ + 5e- -> Mn2+ + 4H2O" value="MnO4- + 8H+ + 5e- -> Mn2+ + 4H2O">
        </div>
        <div class="d-flex align-items-center mb-3">
          <button class="btn btn-primary mr-2" onclick="combineHalfReactions()">Combine Half‑Reactions</button>
          <button class="btn btn-outline-secondary" onclick="resetRedox()">Reset</button>
        </div>
        <div id="redoxResult" class="min-h-result"></div>
      </div>
    </div>
  </div>
</div>

<!-- Learn Section: moved below for better task-first UX -->
<div class="container mt-4">
  <div id="learn" class="card shadow-sm mb-4">
    <div class="card-body">
      <h5 class="card-title mb-3">What Is a Chemical Equation?</h5>
      <p>A chemical equation represents a reaction using chemical formulas. Reactants appear on the left and products on the right, separated by an arrow (&rarr;). Balancing ensures the <strong>law of conservation of mass</strong> is met: the number of atoms of each element is the same on both sides.</p>

      <h6 class="mt-4">How to Balance (At a Glance)</h6>
      <ol class="mb-3">
        <li>Write the unbalanced equation (formulas correct).</li>
        <li>Count atoms of each element on both sides.</li>
        <li>Add coefficients (whole numbers) to species to equalize counts.</li>
        <li>Balance elements that appear in fewer species first (often metals, then non‑metals, then H and O).</li>
        <li>Reduce coefficients to the smallest whole‑number ratio and double‑check counts.</li>
      </ol>

      <h6>Common Reaction Types</h6>
      <ul class="mb-3">
        <li><strong>Combustion:</strong> Hydrocarbon + O<sub>2</sub> &rarr; CO<sub>2</sub> + H<sub>2</sub>O</li>
        <li><strong>Acid–Base:</strong> Acid + Base &rarr; Salt + Water</li>
        <li><strong>Redox:</strong> Electron transfer changes oxidation states (balance via half‑reactions)</li>
        <li><strong>Synthesis/Decomposition:</strong> A + B &rarr; AB, or AB &rarr; A + B</li>
      </ul>

      <h5 class="mt-3 mb-2">Worked Examples</h5>
      <div class="mb-3">
        <p class="mb-1"><strong>1) Combustion of Propane</strong></p>
        <p class="mb-1">Unbalanced: C<sub>3</sub>H<sub>8</sub> + O<sub>2</sub> &rarr; CO<sub>2</sub> + H<sub>2</sub>O</p>
        <p class="mb-1">Balanced: C<sub>3</sub>H<sub>8</sub> + 5 O<sub>2</sub> &rarr; 3 CO<sub>2</sub> + 4 H<sub>2</sub>O</p>
        <ul class="mb-2">
          <li>Balance C: 3 CO<sub>2</sub></li>
          <li>Balance H: 4 H<sub>2</sub>O</li>
          <li>Balance O: 3×2 + 4×1 = 10 &rarr; 5 O<sub>2</sub></li>
        </ul>
        <a href="#" onclick="loadExample('C3H8 + O2 -> CO2 + H2O');return false;">Load this example</a>
      </div>

      <div class="mb-2">
        <p class="mb-1"><strong>2) Formation of Iron(III) Oxide</strong></p>
        <p class="mb-1">Unbalanced: Fe + O<sub>2</sub> &rarr; Fe<sub>2</sub>O<sub>3</sub></p>
        <p class="mb-1">Balanced: 4 Fe + 3 O<sub>2</sub> &rarr; 2 Fe<sub>2</sub>O<sub>3</sub></p>
        <ul class="mb-2">
          <li>Balance Fe to even: 2 Fe<sub>2</sub>O<sub>3</sub> &rarr; 4 Fe</li>
          <li>Balance O: 2×3 = 6 &rarr; 3 O<sub>2</sub></li>
        </ul>
        <a href="#" onclick="loadExample('Fe + O2 -> Fe2O3');return false;">Load this example</a>
      </div>

      <hr>
      <h5 class="mt-3 mb-2">More Examples</h5>
      <div id="examplesCarousel" class="carousel slide" data-ride="carousel" data-interval="7000">
        <ol class="carousel-indicators">
          <li data-target="#examplesCarousel" data-slide-to="0" class="active"></li>
          <li data-target="#examplesCarousel" data-slide-to="1"></li>
          <li data-target="#examplesCarousel" data-slide-to="2"></li>
          <li data-target="#examplesCarousel" data-slide-to="3"></li>
          <li data-target="#examplesCarousel" data-slide-to="4"></li>
          <li data-target="#examplesCarousel" data-slide-to="5"></li>
          <li data-target="#examplesCarousel" data-slide-to="6"></li>
          <li data-target="#examplesCarousel" data-slide-to="7"></li>
        </ol>
        <div class="carousel-inner">
          <div class="carousel-item active">
            <div class="p-3">
              <p class="mb-1"><strong>Single Replacement</strong></p>
              <p class="mb-1">Unbalanced: Zn + HCl &rarr; ZnCl<sub>2</sub> + H<sub>2</sub></p>
              <p class="mb-1">Balanced: Zn + 2 HCl &rarr; ZnCl<sub>2</sub> + H<sub>2</sub></p>
              <a href="#" onclick="loadExample('Zn + HCl -> ZnCl2 + H2');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Double Replacement</strong></p>
              <p class="mb-1">Unbalanced: AgNO<sub>3</sub> + NaCl &rarr; AgCl + NaNO<sub>3</sub></p>
              <p class="mb-1">Balanced: AgNO<sub>3</sub> + NaCl &rarr; AgCl + NaNO<sub>3</sub></p>
              <a href="#" onclick="loadExample('AgNO3 + NaCl -> AgCl + NaNO3');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Decomposition</strong></p>
              <p class="mb-1">Unbalanced: KClO<sub>3</sub> &rarr; KCl + O<sub>2</sub></p>
              <p class="mb-1">Balanced: 2 KClO<sub>3</sub> &rarr; 2 KCl + 3 O<sub>2</sub></p>
              <a href="#" onclick="loadExample('KClO3 -> KCl + O2');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Synthesis</strong></p>
              <p class="mb-1">Unbalanced: H<sub>2</sub> + O<sub>2</sub> &rarr; H<sub>2</sub>O</p>
              <p class="mb-1">Balanced: 2 H<sub>2</sub> + O<sub>2</sub> &rarr; 2 H<sub>2</sub>O</p>
              <a href="#" onclick="loadExample('H2 + O2 -> H2O');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Neutralization</strong></p>
              <p class="mb-1">Unbalanced: HCl + NaOH &rarr; NaCl + H<sub>2</sub>O</p>
              <p class="mb-1">Balanced: HCl + NaOH &rarr; NaCl + H<sub>2</sub>O</p>
              <a href="#" onclick="loadExample('HCl + NaOH -> NaCl + H2O');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Photosynthesis</strong></p>
              <p class="mb-1">Unbalanced: CO<sub>2</sub> + H<sub>2</sub>O &rarr; C<sub>6</sub>H<sub>12</sub>O<sub>6</sub> + O<sub>2</sub></p>
              <p class="mb-1">Balanced: 6 CO<sub>2</sub> + 6 H<sub>2</sub>O &rarr; C<sub>6</sub>H<sub>12</sub>O<sub>6</sub> + 6 O<sub>2</sub></p>
              <a href="#" onclick="loadExample('CO2 + H2O -> C6H12O6 + O2');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Polyatomic Neutralization</strong></p>
              <p class="mb-1">Unbalanced: Al<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub> + Ca(OH)<sub>2</sub> &rarr; Al(OH)<sub>3</sub> + CaSO<sub>4</sub></p>
              <p class="mb-1">Balanced: Al<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub> + 3 Ca(OH)<sub>2</sub> &rarr; 2 Al(OH)<sub>3</sub> + 3 CaSO<sub>4</sub></p>
              <a href="#" onclick="loadExample('Al2(SO4)3 + Ca(OH)2 -> Al(OH)3 + CaSO4');return false;">Load this example</a>
            </div>
          </div>
          <div class="carousel-item">
            <div class="p-3">
              <p class="mb-1"><strong>Double Replacement (with parentheses)</strong></p>
              <p class="mb-1">Unbalanced: BaCl<sub>2</sub> + Al<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub> &rarr; BaSO<sub>4</sub> + AlCl<sub>3</sub></p>
              <p class="mb-1">Balanced: 3 BaCl<sub>2</sub> + Al<sub>2</sub>(SO<sub>4</sub>)<sub>3</sub> &rarr; 3 BaSO<sub>4</sub> + 2 AlCl<sub>3</sub></p>
              <a href="#" onclick="loadExample('BaCl2 + Al2(SO4)3 -> BaSO4 + AlCl3');return false;">Load this example</a>
            </div>
          </div>
        </div>
        <a class="carousel-control-prev" href="#examplesCarousel" role="button" data-slide="prev">
          <span class="carousel-control-prev-icon" aria-hidden="true"></span>
          <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#examplesCarousel" role="button" data-slide="next">
          <span class="carousel-control-next-icon" aria-hidden="true"></span>
          <span class="sr-only">Next</span>
        </a>
      </div>

      <hr>
      <h5 class="mt-3 mb-2">Redox Primer (Acidic/Basic)</h5>
      <p>Redox (reduction–oxidation) reactions involve electron transfer. Balancing typically uses the <em>half‑reaction method</em>:</p>
      <ol class="mb-2">
        <li>Split into oxidation and reduction half‑reactions; assign oxidation states.</li>
        <li>Balance atoms other than O and H.</li>
        <li>Balance O with H<sub>2</sub>O and H with H<sup>+</sup> (acidic) or OH<sup>−</sup> (basic).</li>
        <li>Balance charge with electrons (e<sup>−</sup>).</li>
        <li>Equalize electrons and add half‑reactions; simplify.</li>
      </ol>
      <div class="mb-2">
        <p class="mb-1"><strong>Example (Acidic):</strong> Fe<sup>2+</sup> + MnO<sub>4</sub><sup>−</sup> + H<sup>+</sup> &rarr; Fe<sup>3+</sup> + Mn<sup>2+</sup> + H<sub>2</sub>O</p>
        <p class="mb-1">Balanced: 5 Fe<sup>2+</sup> + MnO<sub>4</sub><sup>−</sup> + 8 H<sup>+</sup> &rarr; 5 Fe<sup>3+</sup> + Mn<sup>2+</sup> + 4 H<sub>2</sub>O</p>
        <small class="text-muted">Note: This tool balances by atoms and does not track charge explicitly; use the steps above for charged redox systems.</small>
      </div>
    </div>
  </div>
</div>
<%--    </div>--%>
<%--  </div>--%>
<%--</div>--%>

<script>
  function gcd(a,b){ a=Math.abs(a); b=Math.abs(b); while(b){ let t=b; b=a%b; a=t; } return a||1; }
  function lcm(a,b){ return a/gcd(a,b)*b; }
  function lcmArr(arr){ return arr.reduce((x,y)=>lcm(x,y),1); }

  function formatFormulaHTML(formula){
    // Pretty hydrates and subscripts: element/group counts become subscripts, '.' → middle dot
    let out = escapeHtml(formula || '').replace(/\./g,'&middot;');
    out = out.replace(/([A-Za-z\)\]])(\d+)/g, (m,p1,p2)=> `${p1}<sub>${p2}</sub>`);
    return out;
  }

  function renderEqPreview(){
    var el = document.getElementById('eq');
    var prev = document.getElementById('eqPreview');
    if(!el || !prev) return;
    var text = el.value || '';
    if(!text.trim()){ prev.innerHTML=''; return; }
    try{
      const {left,right,arrow} = parseEquation(text);
      const fmt = (side)=> side.map(({coef,formula})=>`${coef>1?`<span class=\"coeff\">${coef}</span>`:''}${formatFormulaHTML(formula)}`).join(' + ');
      const arrowSymbol = (arrow==='=>' || arrow==='⇒' ? '&rArr;' : '&rarr;');
      prev.innerHTML = `Preview: ${fmt(left)} ${arrowSymbol} ${fmt(right)}`;
    }catch(e){
      // Fallback: best-effort formatting without full parsing
      let out = formatFormulaHTML(text).replace(/(=&gt;|=>|->|→|⇒|-->|=)/g, m=> (m.includes('=>')||m.includes('⇒')?'&rArr;':'&rarr;'));
      prev.innerHTML = `Preview: ${out}`;
    }
  }

  // --- Chip state management ---
  let state = { left: [], right: [] };

  function buildStateFromInput(){
    try{
      const {left,right} = parseEquation((document.getElementById('eq').value||'').trim());
      state.left = left.map(x=>({coef: Math.max(1, x.coef||1), formula: x.formula}));
      state.right = right.map(x=>({coef: Math.max(1, x.coef||1), formula: x.formula}));
    }catch(e){
      // fallback: naive split by arrow and plus
      const raw = (document.getElementById('eq').value||'').split(/=>|->/);
      const L = (raw[0]||'').split('+').map(s=>s.trim()).filter(Boolean);
      const R = (raw[1]||'').split('+').map(s=>s.trim()).filter(Boolean);
      state.left = L.map(f=>({coef:1, formula:f}));
      state.right = R.map(f=>({coef:1, formula:f}));
    }
  }

  function applyStateToInput(){
    function sideToText(arr){
      return arr.map(x=> (x.coef>1? (x.coef+'') : '') + x.formula).join(' + ');
    }
    const eq = `${sideToText(state.left)} -> ${sideToText(state.right)}`.replace(/^\s*\+\s*/,'').replace(/\+\s*$/,'');
    const el = document.getElementById('eq');
    el.value = eq;
    renderEqPreview();
    if(document.getElementById('optAuto').checked){ debounceBalance(); }
  }

  function renderChips(){
    const cL = document.getElementById('chipsLeft');
    const cR = document.getElementById('chipsRight');
    function chipHTML(x, idx, side){
      return `<span class="chip" data-side="${side}" data-idx="${idx}">
        <button class="btn btn-outline-secondary btn-xs" onclick="adjustCoef('${side}', ${idx}, -1)">−</button>
        <span class="coeff">${x.coef}</span>
        <span class="chip-formula" onclick="editSpecies('${side}', ${idx})">${formatFormulaHTML(x.formula)}</span>
        <button class="btn btn-outline-secondary btn-xs" onclick="adjustCoef('${side}', ${idx}, 1)">+</button>
        <button class="btn btn-outline-danger btn-xs" onclick="deleteSpecies('${side}', ${idx})">×</button>
      </span>`;
    }
    cL.innerHTML = state.left.map((x,i)=>chipHTML(x,i,'left')).join('');
    cR.innerHTML = state.right.map((x,i)=>chipHTML(x,i,'right')).join('');
  }

  function adjustCoef(side, idx, delta){
    const arr = state[side];
    if(!arr || !arr[idx]) return;
    arr[idx].coef = Math.max(1, (arr[idx].coef||1) + delta);
    renderChips();
    applyStateToInput();
  }
  function deleteSpecies(side, idx){
    const arr = state[side];
    if(!arr || !arr[idx]) return;
    arr.splice(idx,1);
    renderChips();
    applyStateToInput();
  }
  function editSpecies(side, idx){
    const arr = state[side];
    if(!arr || !arr[idx]) return;
    const val = prompt('Edit formula', arr[idx].formula);
    if(val!=null){ arr[idx].formula = val.trim(); renderChips(); applyStateToInput(); }
  }
  function addSpecies(side){
    const inp = document.getElementById(side==='left'?'addLeft':'addRight');
    if(!inp) return; const v = (inp.value||'').trim(); if(!v) return;
    state[side].push({coef:1, formula:v});
    inp.value=''; renderChips(); applyStateToInput();
  }

  // --- Options and history ---
  let balanceTimer=null;
  function debounceBalance(){ clearTimeout(balanceTimer); balanceTimer=setTimeout(balanceEquation, 350); }
  function saveHistory(eq){
    try{
      const key='chem_eq_history';
      const arr = JSON.parse(localStorage.getItem(key)||'[]');
      if(eq && arr[0]!==eq){ arr.unshift(eq); }
      while(arr.length>10) arr.pop();
      localStorage.setItem(key, JSON.stringify(arr));
      renderHistory();
    }catch(e){}
  }
  function renderHistory(){
    try{
      const key='chem_eq_history';
      const arr = JSON.parse(localStorage.getItem(key)||'[]');
      const el = document.getElementById('historyList'); if(!el) return;
      el.innerHTML = arr.map(x=>`<a href="#" onclick="loadExample('${escapeHtml(x)}');return false;">${escapeHtml(x)}</a>`).join('<br>');
    }catch(e){}
  }
  function clearHistory(){ localStorage.removeItem('chem_eq_history'); renderHistory(); }

  // Load a provided example into the input and update UI/state
  function loadExample(eq){
    // Ensure Atom Balance tab is active so users see the result
    switchSection('atom');
    const el = document.getElementById('eq');
    if(!el) return false;
    el.value = eq;
    buildStateFromInput();
    renderChips();
    renderEqPreview();
    // Always balance on example load for immediate feedback
    balanceEquation();
    saveHistory(eq);
    try { el.focus(); el.scrollIntoView({behavior:'smooth', block:'center'}); } catch(e) {}
    return false;
  }


  // Parse a chemical formula into element counts, supports parentheses and hydrates with '.'
  function parseFormula(formula){
    // Replace hydrate dot with plus to treat like separate species internally
    formula = formula.replace(/·/g, '.');
    let i=0;
    function parseGroup(){
      let counts = {};
      while(i < formula.length){
        if(formula[i] === '(' || formula[i] === '['){
          i++; // skip '('
          let inner = parseGroup();
          if(i >= formula.length || (formula[i] !== ')' && formula[i] !== ']')) break;
          i++; // skip ')'
          let mult = readNumber();
          for(const el in inner){ counts[el]=(counts[el]||0)+inner[el]*mult; }
        } else if(formula[i] === ')' || formula[i] === ']'){
          break;
        } else if(formula[i] === '.'){
          // Hydrate separator, treat as break in this group
          i++;
        } else if(/[A-Z]/.test(formula[i])){
          let el = formula[i++];
          while(i<formula.length && /[a-z]/.test(formula[i])) el += formula[i++];
          let num = readNumber();
          counts[el]=(counts[el]||0)+num;
        } else if(/\s/.test(formula[i])){
          i++;
        } else {
          // unknown char
          i++;
        }
      }
      return counts;
    }
    function readNumber(){
      let start=i; while(i<formula.length && /\d/.test(formula[i])) i++;
      return start===i?1:parseInt(formula.slice(start,i),10);
    }
    return parseGroup();
  }

  function tokenizeSide(side){
    // split by '+' and handle leading coefficients like '2H2O'
    return side.split('+').map(s=>s.trim()).filter(Boolean).map(sp=>{
      let m = sp.match(/^(\d+)\s*(.*)$/);
      let coef = 1, formula = sp;
      if(m){ coef = parseInt(m[1],10); formula = m[2].trim(); }
      return {coef, formula};
    });
  }

  function parseEquation(input){
    const m = input.match(/(=>|->|→|⇒|-->|=)/);
    if(!m) throw new Error('NO_ARROW');
    const arrow = m[0];
    const parts = input.split(/=>|->|→|⇒|-->|=/);
    if(parts.length!==2) throw new Error('MULTI_ARROW');
    const left = tokenizeSide(parts[0]);
    const right = tokenizeSide(parts[1]);
    return {left,right,arrow};
  }

  function uniqueElements(left,right){
    const set = new Set();
    [...left,...right].forEach(sp=>{ const c=parseFormula(sp.formula); Object.keys(c).forEach(e=>set.add(e)); });
    return Array.from(set).sort();
  }

  function buildMatrix(elements,left,right){
    // rows: elements; cols: species (left then right)
    const cols = left.length + right.length;
    const A = elements.map(()=>Array(cols).fill(0));
    const fill = (sp,offset,sign)=>{
      sp.forEach((s,j)=>{
        const counts = parseFormula(s.formula);
        elements.forEach((el,i)=>{ A[i][offset+j] = (counts[el]||0)*sign; });
      });
    };
    fill(left,0, 1); // reactants positive
    fill(right,left.length, -1); // products negative
    return A;
  }

  // Compute a non-trivial integer solution to A*x=0 using Gaussian elimination, return smallest integers
  function nullspaceInt(A){
    const rows=A.length, cols=A[0].length;
    // Convert to rational numbers using fractions represented by [num,den]
    const M = A.map(r=>r.map(v=>[v,1]));
    function simplify([n,d]){ const g=gcd(n,d); d<0 && (n=-n,d=-d); return [n/g,d/g]; }
    function add(a,b){ return simplify([a[0]*b[1]+b[0]*a[1], a[1]*b[1]]); }
    function sub(a,b){ return add(a,[-b[0],b[1]]); }
    function mul(a,b){ return simplify([a[0]*b[0], a[1]*b[1]]); }
    function div(a,b){ return simplify([a[0]*b[1], a[1]*b[0]]); }

    let r=0;
    for(let c=0;c<cols && r<rows;c++){
      // find pivot
      let piv=r; while(piv<rows && M[piv][c][0]===0) piv++;
      if(piv===rows) continue;
      // swap
      if(piv!==r){ const tmp=M[r]; M[r]=M[piv]; M[piv]=tmp; }
      // normalize row r
      const pivVal=M[r][c];
      for(let j=c;j<cols;j++) M[r][j]=div(M[r][j],pivVal);
      // eliminate others
      for(let i=0;i<rows;i++) if(i!==r && M[i][c][0]!==0){
        const f=M[i][c];
        for(let j=c;j<cols;j++) M[i][j]=sub(M[i][j], mul(f,M[r][j]));
      }
      r++;
    }
    // Identify free variables (those without pivot). Set last free var = 1, backsolve others = 1 or determined
    const pivotCol = Array(rows).fill(-1);
    let row=0;
    for(let c=0;c<cols && row<rows;c++){
      if(Math.abs(M[row][c][0])===1 && M[row][c][1]===1){ pivotCol[row]=c; row++; }
    }
    const isPivotCol = Array(cols).fill(false);
    pivotCol.forEach(c=>{ if(c>=0) isPivotCol[c]=true; });
    const free = [];
    for(let c=0;c<cols;c++) if(!isPivotCol[c]) free.push(c);
    if(free.length===0){
      // trivial or fully determined, set last variable to 1 as free
      free.push(cols-1);
    }
    const x = Array(cols).fill([0,1]);
    // set free vars = 1
    free.forEach(c=>{ x[c]=[1,1]; });
    // backsolve pivot rows: for each pivot row, x[pivot] = - sum(other * coeff)
    for(let i=rows-1;i>=0;i--){
      const pc = pivotCol[i];
      if(pc<0) continue;
      let sum=[0,1];
      for(let j=pc+1;j<cols;j++) if(M[i][j][0]!==0){ sum = add(sum, mul(M[i][j], x[j])); }
      x[pc]=simplify([-sum[0], sum[1]]);
    }
    // Convert rationals to integers by lcm of denominators
    const dens = x.map(fr=>fr[1]);
    const L = lcmArr(dens);
    let ints = x.map(fr=> (fr[0]* (L/fr[1])) );
    // normalize: make them positive and reduce gcd
    const allNeg = ints.every(v=>v<=0);
    if(allNeg) ints = ints.map(v=>-v);
    const G = ints.reduce((a,b)=>gcd(a,b), Math.abs(ints[0])||1);
    ints = ints.map(v=> v/G);
    return ints;
  }

  function balanceEquation(){
    const inp = document.getElementById('eq').value.trim();
    const res = document.getElementById('result');
    try{
      const {left,right,arrow} = parseEquation(inp);
      const elements = uniqueElements(left,right);
      if(elements.length===0) throw new Error('Could not find any chemical elements.');
      const A = buildMatrix(elements,left,right);
      const coeffs = nullspaceInt(A);
      const split = {left: coeffs.slice(0,left.length), right: coeffs.slice(left.length)};
      // Build output
      function formatFormulaHTML(formula){
        // Pretty hydrates and subscripts for counts after element or group
        let out = escapeHtml(formula).replace(/\./g,'&middot;');
        out = out.replace(/([A-Za-z\)\]])(\d+)/g, (m,p1,p2)=> `${p1}<sub>${p2}</sub>`);
        return out;
      }
      const hide1 = document.getElementById('optHide1') && document.getElementById('optHide1').checked;
      const showFrac = document.getElementById('optFrac') && document.getElementById('optFrac').checked;

      const fmtSide = (side, coefs)=> side.map((s,i)=>{
        const c = coefs[i];
        const cStr = (hide1 && c===1)? '' : `<span class=\"coeff\">${c}</span>`;
        return `<span class="nowrap">${cStr}${formatFormulaHTML(s.formula)}</span>`;
      }).join(' + ');

      const arrowSymbol = (arrow==='=>' || arrow==='⇒' ? '&rArr;' : '&rarr;');
      let eqHtml = `<div class="mb-2"><strong>Balanced:</strong><br>${fmtSide(left, split.left)} ${arrowSymbol} ${fmtSide(right, split.right)}</div>`;

      // Fractions view (optional): scale so first nonzero is 1 and show others as p/q
      if(showFrac){
        const first = coeffs.find(v=>v!==0) || 1;
        function toFrac(n, d){
          const g=gcd(n,d); n/=g; d/=g; return d===1? `${n}` : `${n}/${d}`; }
        const fracSide = (side, coefs)=> side.map((s,i)=>{
          const num = coefs[i]; const den = first; // represent as num/first
          const cStr = (hide1 && num===first)? '' : `<span class=\"coeff\">${toFrac(num, den)}</span>`;
          return `<span class="nowrap">${cStr}${formatFormulaHTML(s.formula)}</span>`;
        }).join(' + ');
        eqHtml += `<div class="mt-2"><small class="text-muted">Fractions view:</small><br>${fracSide(left, split.left)} ${arrowSymbol} ${fracSide(right, split.right)}</div>`;
      }

      // Atom counts table
      function totalCounts(spList, coefs){
        const totals={};
        spList.forEach((s,i)=>{
          const c=parseFormula(s.formula);
          Object.keys(c).forEach(el=>{
            totals[el]=(totals[el]||0)+c[el]*coefs[i];
          });
        });
        return totals;
      }
      const totL = totalCounts(left, split.left);
      const totR = totalCounts(right, split.right);
      const rows = elements.map(el=>{
        const a=totL[el]||0, b=totR[el]||0;
        const cls = (a===b)?'atom-equal':'atom-mismatch';
        return `<tr><td>${el}</td><td>${a}</td><td>${b}</td><td class="${cls}">${a===b?'✓':'✗'}</td></tr>`;
      }).join('');

      const table = `<div class="table-responsive"><table class="table table-sm">
        <thead><tr><th>Element</th><th>Left</th><th>Right</th><th>Status</th></tr></thead>
        <tbody>${rows}</tbody></table></div>`;

      const actions = `<div class="mt-2">
        <button class="btn btn-outline-secondary btn-sm mr-2" onclick="copyBalanced()" title="Copy balanced equation">📋 Copy</button>
        <button class="btn btn-outline-secondary btn-sm mr-2" onclick="copyLaTeX()" title="Copy LaTeX">𝛌 LaTeX</button>
        <button class="btn btn-outline-secondary btn-sm mr-2" onclick="exportPNG()" title="Export as PNG">🖼 PNG</button>
        <button class="btn btn-outline-secondary btn-sm" onclick="shareLink()" title="Share link with equation">🔗 Share</button>
      </div>`;

      res.innerHTML = eqHtml + table + actions;
      res.dataset.balanced = stripHtml(eqHtml);
      res.dataset.latex = toLaTeXEquation(left, right, split.left, split.right, hide1);
      res.dataset.pretty = toUnicodePretty(left, right, split.left, split.right, hide1, arrowSymbol==='&rArr;'?'⇒':'→');
      saveHistory(inp);
    }catch(e){
      if(e && e.message==='NO_ARROW'){
        showSingleSideAnalysis(inp);
        return;
      }
      res.innerHTML = `<div class="alert alert-warning">${escapeHtml(e.message || 'Error parsing equation')}</div>`;
    }
  }

  function copyBalanced(){
    const res = document.getElementById('result');
    const text = res && res.dataset.balanced ? res.dataset.balanced : '';
    if(!text) return;
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(text); return; }
    const ta=document.createElement('textarea'); ta.value=text; ta.style.position='fixed'; ta.style.opacity='0'; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta);
  }

  function shareLink(){
    const inp = document.getElementById('eq').value.trim();
    const url = new URL(window.location.href.split('#')[0]);
    url.searchParams.set('q', inp);
    if(document.getElementById('optAuto').checked) url.searchParams.set('auto','1');
    if(document.getElementById('optHide1').checked) url.searchParams.set('hide1','1');
    if(document.getElementById('optFrac').checked) url.searchParams.set('frac','1');
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(url.toString()); }
    window.history.replaceState({}, '', url.toString());
  }

  function resetUI(){
    const res = document.getElementById('result');
    if(res) res.innerHTML='';
  }

  function escapeHtml(s){ return (s||'').replace(/[&<>"']/g, c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[c])); }
  function stripHtml(s){ const div=document.createElement('div'); div.innerHTML=s; return div.textContent || div.innerText || ''; }

  // Build LaTeX string for the balanced equation
  function toLaTeXFormula(formula){
    // replace counts with _{n}, keep parentheses, replace hydrate dot with \cdot
    let f = formula.replace(/\./g,' \\cdot ');
    // Insert _{n} after element/group + digits
    f = f.replace(/([A-Za-z\)\]])(\d+)/g, (m,p1,p2)=> `${p1}_\{${p2}\}`);
    // charges like 2+ or 3- at end: convert to ^{2+}
    f = f.replace(/([A-Za-z\]\)])(\d*)([\+\-])$/g, (m,p1,p2,p3)=> `${p1}^{${(p2||'')+p3}}`);
    return f;
  }
  function toLaTeXEquation(left, right, coL, coR, hide1){
    const fmt = (side, coefs)=> side.map((s,i)=>{
      const c=coefs[i]; const cStr = (hide1 && c===1)? '' : c+'';
      return `${cStr}${toLaTeXFormula(s.formula)}`;
    }).join(' + ');
    return `${fmt(left, coL)} \\rightarrow ${fmt(right, coR)}`;
  }

  // Pretty unicode subscripts for quick PNG export
  function subNum(n){ const map={'0':'₀','1':'₁','2':'₂','3':'₃','4':'₄','5':'₅','6':'₆','7':'₇','8':'₈','9':'₉'}; return n.replace(/[0-9]/g, d=>map[d]); }
  function toUnicodePretty(left, right, coL, coR, hide1, arrow){
    const fmt = (side, coefs)=> side.map((s,i)=>{
      const c=coefs[i]; const cStr = (hide1 && c===1)? '' : (c+' ');
      let f = s.formula.replace(/\./g,'·');
      f = f.replace(/([A-Za-z\)\]])(\d+)/g, (m,p1,p2)=> `${p1}${subNum(p2)}`);
      return `${cStr}${f}`;
    }).join(' + ');
    return `${fmt(left,coL)} ${arrow} ${fmt(right,coR)}`;
  }

  function copyLaTeX(){
    const res = document.getElementById('result');
    const tex = res && res.dataset.latex; if(!tex) return;
    if(navigator.clipboard && navigator.clipboard.writeText){ navigator.clipboard.writeText(tex); return; }
    const ta=document.createElement('textarea'); ta.value=tex; ta.style.position='fixed'; ta.style.opacity='0'; document.body.appendChild(ta); ta.select(); document.execCommand('copy'); document.body.removeChild(ta);
  }

  function exportPNG(){
    const res = document.getElementById('result');
    const text = res && res.dataset.pretty; if(!text) return;
    const pad=20; const font='20px Arial';
    const canvas=document.createElement('canvas'); const ctx=canvas.getContext('2d');
    // rough width estimate
    const tmp=document.createElement('canvas').getContext('2d'); tmp.font=font; const w=tmp.measureText(text).width; const h=34;
    canvas.width = Math.ceil(w)+pad*2; canvas.height = h+pad*2;
    ctx.fillStyle='#ffffff'; ctx.fillRect(0,0,canvas.width,canvas.height);
    ctx.fillStyle='#000000'; ctx.font=font; ctx.fillText(text, pad, pad+h*0.7);
    const a=document.createElement('a'); a.href=canvas.toDataURL('image/png'); a.download='balanced-equation.png'; a.click();
  }

  function switchSection(which){
    const atom=document.getElementById('sectionAtom');
    const redox=document.getElementById('sectionRedox');
    const ta=document.getElementById('tab-atom'); const tr=document.getElementById('tab-redox');
    if(which==='redox'){ atom.style.display='none'; redox.style.display='block'; ta.classList.remove('active'); tr.classList.add('active'); }
    else { redox.style.display='none'; atom.style.display='block'; tr.classList.remove('active'); ta.classList.add('active'); }
  }

  // --- Redox combiner (beta): equalize electrons and merge ---
  function tokenizeSideSimple(side){
    return side.split('+').map(s=>s.trim()).filter(Boolean).map(sp=>{
      let m = sp.match(/^(\d+)\s*(.*)$/); let coef=1, formula=sp;
      if(m){ coef=parseInt(m[1],10); formula=m[2].trim(); }
      return {coef, formula};
    });
  }
  function parseHalf(text){
    const parts = text.split(/=>|->/); if(parts.length!==2) throw new Error('Half‑reaction needs one arrow');
    return { left: tokenizeSideSimple(parts[0]), right: tokenizeSideSimple(parts[1]) };
  }
  function speciesKey(s){ return s.formula.replace(/\s+/g,''); }
  function scaleList(list, k){ return list.map(x=>({coef:x.coef*k, formula:x.formula})); }
  function combineLists(a,b,sign){
    // sign=+1 add to left, sign=-1 subtract to cancel
    const map=new Map();
    function addList(lst, mult){
      lst.forEach(x=>{
        const key=speciesKey(x); const cur=map.get(key)||0; map.set(key, cur + mult*x.coef);
      });
    }
    addList(a, +1); addList(b, sign);
    const out=[]; map.forEach((v,k)=>{ if(v!==0) out.push({coef:v, formula:k}); });
    return out;
  }
  function formatSideText(list){ return list.map(x=> (x.coef===1? '' : x.coef+' ')+x.formula).join(' + '); }

  function combineHalfReactions(){
    const out = document.getElementById('redoxResult');
    try{
      const h1 = parseHalf((document.getElementById('halfOx').value||'').trim());
      const h2 = parseHalf((document.getElementById('halfRed').value||'').trim());
      const e = 'e-';
      const eProd = (lst)=> (lst.find(x=>x.formula===e)||{coef:0}).coef;
      const eCons = (lst)=> (lst.find(x=>x.formula===e)||{coef:0}).coef;
      const e1 = eProd(h1.right) - eCons(h1.left); // positive if produced on right
      const e2 = eCons(h2.left) - eProd(h2.right); // positive if consumed on left
      if(e1<=0 || e2<=0) throw new Error('Provide oxidation with e- on the product side and reduction with e- on the reactant side.');
      const L = lcm(e1, e2);
      const k1 = L / e1; const k2 = L / e2;
      const H1L = scaleList(h1.left, k1), H1R = scaleList(h1.right, k1);
      const H2L = scaleList(h2.left, k2), H2R = scaleList(h2.right, k2);
      // Remove electrons
      function removeE(list){ return list.filter(x=>x.formula!==e); }
      const leftCombined = combineLists(removeE(H1L), removeE(H2L), -1); // will be fixed below
      // Actually build net: (H1L + H2L) -> (H1R + H2R), then cancel common species across sides
      const netL = removeE(H1L).concat(removeE(H2L));
      const netR = removeE(H1R).concat(removeE(H2R));
      // cancel common species
      const mapL=new Map(); netL.forEach(x=>{ const k=speciesKey(x); mapL.set(k,(mapL.get(k)||0)+x.coef); });
      const mapR=new Map(); netR.forEach(x=>{ const k=speciesKey(x); mapR.set(k,(mapR.get(k)||0)+x.coef); });
      const allKeys=new Set([...mapL.keys(), ...mapR.keys()]);
      const outL=[], outR=[];
      allKeys.forEach(k=>{
        const l = mapL.get(k)||0, r = mapR.get(k)||0;
        if(l>r) outL.push({coef:l-r, formula:k});
        else if(r>l) outR.push({coef:r-l, formula:k});
      });
      const eqText = `${formatSideText(outL)} → ${formatSideText(outR)}`;
      out.innerHTML = `<div class="mb-2"><strong>Net Reaction (beta):</strong><br>${escapeHtml(eqText)}</div>`;
    }catch(e){ out.innerHTML = `<div class="alert alert-warning">${escapeHtml(e.message)}</div>`; }
  }
  function resetRedox(){
    document.getElementById('halfOx').value='';
    document.getElementById('halfRed').value='';
    document.getElementById('redoxResult').innerHTML='';
  }

  // Load from query param
  (function(){
    const params = new URLSearchParams(window.location.search);
    const q = params.get('q'); if(q){ document.getElementById('eq').value=q; }
    // live preview
    const inp = document.getElementById('eq');
    if(inp){ inp.addEventListener('input', renderEqPreview); }
    renderEqPreview();
    // options from URL
    if(params.get('auto')==='1') document.getElementById('optAuto').checked = true;
    if(params.get('hide1')==='1') document.getElementById('optHide1').checked = true;
    if(params.get('frac')==='1') document.getElementById('optFrac').checked = true;

    buildStateFromInput();
    renderChips();
    renderHistory();
    if(q){ balanceEquation(); }
  })();

  // Helper: show best-effort analysis when no arrow is present
  function showSingleSideAnalysis(text){
    const res = document.getElementById('result');
    const species = text.split('+').map(s=>s.trim()).filter(Boolean);
    if(species.length===0){ res.innerHTML = `<div class="alert alert-warning">No formula detected. Add species like H2 + O2 and a reaction arrow.</div>`; return; }
    // build per-species counts and totals
    function countsFor(form){ const c=parseFormula(form); return c; }
    const elementsSet = new Set();
    const rows = species.map(f=>{ const c=countsFor(f); Object.keys(c).forEach(e=>elementsSet.add(e)); return {f, c}; });
    const elements = Array.from(elementsSet).sort();
    // totals
    const totals={}; rows.forEach(r=>{ elements.forEach(e=>{ totals[e]=(totals[e]||0)+(r.c[e]||0); }); });
    const head = `<thead><tr><th>Species</th>${elements.map(e=>`<th>${e}</th>`).join('')}</tr></thead>`;
    const body = rows.map(r=>`<tr><td>${formatFormulaHTML(r.f)}</td>${elements.map(e=>`<td>${r.c[e]||0}</td>`).join('')}</tr>`).join('');
    const totalRow = `<tr class="font-weight-bold"><td>Total</td>${elements.map(e=>`<td>${totals[e]||0}</td>`).join('')}</tr>`;
    res.innerHTML = `<div class="alert alert-info mb-2">No reaction arrow detected. Showing single‑side analysis. Add an arrow (->, =>, →, ⇒, -->, or =) to balance.</div>
    <div class="table-responsive"><table class="table table-sm">${head}<tbody>${body}${totalRow}</tbody></table></div>`;
  }
</script>

<!-- JSON-LD: WebPage + Breadcrumbs + FAQ + HowTo -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Chemical Equation Balancer",
  "alternateName": ["Balance Chemical Equations Online", "Equation Balancer"],
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "inLanguage": "en",
  "isAccessibleForFree": true,
  "url": "https://8gwifi.org/chemical-equation-balancer.jsp",
  "image": "https://8gwifi.org/images/site/chem-balance.png",
  "description": "Free online chemical equation balancer with steps and atom counts. Balance reactions in your browser and copy results as text or LaTeX.",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org",
    "url": "https://8gwifi.org",
    "logo": {"@type": "ImageObject", "url": "https://8gwifi.org/images/site/8gwifiorg-logos_white.png"}
  }
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "Chemical Equation Balancer",
  "url": "https://8gwifi.org/chemical-equation-balancer.jsp",
  "description": "Balance chemical equations online with steps and atom counts.",
  "isPartOf": {"@id": "https://8gwifi.org#website"}
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {"@type": "ListItem", "position": 1, "name": "Home", "item": "https://8gwifi.org"},
    {"@type": "ListItem", "position": 2, "name": "Chemical Equation Balancer", "item": "https://8gwifi.org/chemical-equation-balancer.jsp"}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {"@type": "Question", "name": "How do you balance equations?", "acceptedAnswer": {"@type": "Answer", "text": "We apply a matrix (Gaussian elimination) method to compute the smallest integer coefficients that conserve each element."}},
    {"@type": "Question", "name": "Does it support parentheses and hydrates?", "acceptedAnswer": {"@type": "Answer", "text": "Yes, common parentheses and hydrate dots (·) are supported. Complex nested cases are handled in most scenarios."}},
    {"@type": "Question", "name": "Is it free and private?", "acceptedAnswer": {"@type": "Answer", "text": "Yes. It runs in your browser and is free to use. No sign‑up required."}}
  ]
}
</script>
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "Balance a chemical equation online",
  "description": "Free browser‑only chemical equation balancer.",
  "totalTime": "PT1M",
  "step": [
    {"@type": "HowToStep", "name": "Enter equation", "text": "Type an unbalanced equation, e.g., Fe + O2 -> Fe2O3."},
    {"@type": "HowToStep", "name": "Balance", "text": "Click Balance to compute integer coefficients."},
    {"@type": "HowToStep", "name": "Review", "text": "Check atom counts for both sides and copy the result."}
  ],
  "url": "https://8gwifi.org/chemical-equation-balancer.jsp"
}
</script>

<%@ include file="thanks.jsp"%>
<hr>

<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
