/**
 * Molar Mass Calculator — Core Module
 * Exposed as window.MMCalc
 */
window.MMCalc = (function () {
    'use strict';

    /* ===== DOM Helper ===== */
    function $(id) { return document.getElementById(id); }

    /* ===== Periodic Table Data (IUPAC 2021) ===== */
    var ELEMENTS = {
        'H': {name: 'Hydrogen', mass: 1.008, number: 1},
        'He': {name: 'Helium', mass: 4.0026, number: 2},
        'Li': {name: 'Lithium', mass: 6.94, number: 3},
        'Be': {name: 'Beryllium', mass: 9.0122, number: 4},
        'B': {name: 'Boron', mass: 10.81, number: 5},
        'C': {name: 'Carbon', mass: 12.011, number: 6},
        'N': {name: 'Nitrogen', mass: 14.007, number: 7},
        'O': {name: 'Oxygen', mass: 15.999, number: 8},
        'F': {name: 'Fluorine', mass: 18.998, number: 9},
        'Ne': {name: 'Neon', mass: 20.180, number: 10},
        'Na': {name: 'Sodium', mass: 22.990, number: 11},
        'Mg': {name: 'Magnesium', mass: 24.305, number: 12},
        'Al': {name: 'Aluminum', mass: 26.982, number: 13},
        'Si': {name: 'Silicon', mass: 28.085, number: 14},
        'P': {name: 'Phosphorus', mass: 30.974, number: 15},
        'S': {name: 'Sulfur', mass: 32.06, number: 16},
        'Cl': {name: 'Chlorine', mass: 35.45, number: 17},
        'Ar': {name: 'Argon', mass: 39.948, number: 18},
        'K': {name: 'Potassium', mass: 39.098, number: 19},
        'Ca': {name: 'Calcium', mass: 40.078, number: 20},
        'Sc': {name: 'Scandium', mass: 44.956, number: 21},
        'Ti': {name: 'Titanium', mass: 47.867, number: 22},
        'V': {name: 'Vanadium', mass: 50.942, number: 23},
        'Cr': {name: 'Chromium', mass: 51.996, number: 24},
        'Mn': {name: 'Manganese', mass: 54.938, number: 25},
        'Fe': {name: 'Iron', mass: 55.845, number: 26},
        'Co': {name: 'Cobalt', mass: 58.933, number: 27},
        'Ni': {name: 'Nickel', mass: 58.693, number: 28},
        'Cu': {name: 'Copper', mass: 63.546, number: 29},
        'Zn': {name: 'Zinc', mass: 65.38, number: 30},
        'Ga': {name: 'Gallium', mass: 69.723, number: 31},
        'Ge': {name: 'Germanium', mass: 72.630, number: 32},
        'As': {name: 'Arsenic', mass: 74.922, number: 33},
        'Se': {name: 'Selenium', mass: 78.971, number: 34},
        'Br': {name: 'Bromine', mass: 79.904, number: 35},
        'Kr': {name: 'Krypton', mass: 83.798, number: 36},
        'Rb': {name: 'Rubidium', mass: 85.468, number: 37},
        'Sr': {name: 'Strontium', mass: 87.62, number: 38},
        'Y': {name: 'Yttrium', mass: 88.906, number: 39},
        'Zr': {name: 'Zirconium', mass: 91.224, number: 40},
        'Nb': {name: 'Niobium', mass: 92.906, number: 41},
        'Mo': {name: 'Molybdenum', mass: 95.95, number: 42},
        'Tc': {name: 'Technetium', mass: 98, number: 43},
        'Ru': {name: 'Ruthenium', mass: 101.07, number: 44},
        'Rh': {name: 'Rhodium', mass: 102.91, number: 45},
        'Pd': {name: 'Palladium', mass: 106.42, number: 46},
        'Ag': {name: 'Silver', mass: 107.87, number: 47},
        'Cd': {name: 'Cadmium', mass: 112.41, number: 48},
        'In': {name: 'Indium', mass: 114.82, number: 49},
        'Sn': {name: 'Tin', mass: 118.71, number: 50},
        'Sb': {name: 'Antimony', mass: 121.76, number: 51},
        'Te': {name: 'Tellurium', mass: 127.60, number: 52},
        'I': {name: 'Iodine', mass: 126.90, number: 53},
        'Xe': {name: 'Xenon', mass: 131.29, number: 54},
        'Cs': {name: 'Cesium', mass: 132.91, number: 55},
        'Ba': {name: 'Barium', mass: 137.33, number: 56},
        'La': {name: 'Lanthanum', mass: 138.91, number: 57},
        'Ce': {name: 'Cerium', mass: 140.12, number: 58},
        'Pr': {name: 'Praseodymium', mass: 140.91, number: 59},
        'Nd': {name: 'Neodymium', mass: 144.24, number: 60},
        'Pm': {name: 'Promethium', mass: 145, number: 61},
        'Sm': {name: 'Samarium', mass: 150.36, number: 62},
        'Eu': {name: 'Europium', mass: 151.96, number: 63},
        'Gd': {name: 'Gadolinium', mass: 157.25, number: 64},
        'Tb': {name: 'Terbium', mass: 158.93, number: 65},
        'Dy': {name: 'Dysprosium', mass: 162.50, number: 66},
        'Ho': {name: 'Holmium', mass: 164.93, number: 67},
        'Er': {name: 'Erbium', mass: 167.26, number: 68},
        'Tm': {name: 'Thulium', mass: 168.93, number: 69},
        'Yb': {name: 'Ytterbium', mass: 173.05, number: 70},
        'Lu': {name: 'Lutetium', mass: 174.97, number: 71},
        'Hf': {name: 'Hafnium', mass: 178.49, number: 72},
        'Ta': {name: 'Tantalum', mass: 180.95, number: 73},
        'W': {name: 'Tungsten', mass: 183.84, number: 74},
        'Re': {name: 'Rhenium', mass: 186.21, number: 75},
        'Os': {name: 'Osmium', mass: 190.23, number: 76},
        'Ir': {name: 'Iridium', mass: 192.22, number: 77},
        'Pt': {name: 'Platinum', mass: 195.08, number: 78},
        'Au': {name: 'Gold', mass: 196.97, number: 79},
        'Hg': {name: 'Mercury', mass: 200.59, number: 80},
        'Tl': {name: 'Thallium', mass: 204.38, number: 81},
        'Pb': {name: 'Lead', mass: 207.2, number: 82},
        'Bi': {name: 'Bismuth', mass: 208.98, number: 83},
        'Po': {name: 'Polonium', mass: 209, number: 84},
        'At': {name: 'Astatine', mass: 210, number: 85},
        'Rn': {name: 'Radon', mass: 222, number: 86},
        'Fr': {name: 'Francium', mass: 223, number: 87},
        'Ra': {name: 'Radium', mass: 226, number: 88},
        'Ac': {name: 'Actinium', mass: 227, number: 89},
        'Th': {name: 'Thorium', mass: 232.04, number: 90},
        'Pa': {name: 'Protactinium', mass: 231.04, number: 91},
        'U': {name: 'Uranium', mass: 238.03, number: 92}
    };

    /* ===== Common Compounds (47) ===== */
    var COMMON_COMPOUNDS = [
        {formula: 'H2O', name: 'Water', category: 'basic'},
        {formula: 'CO2', name: 'Carbon Dioxide', category: 'basic'},
        {formula: 'O2', name: 'Oxygen Gas', category: 'basic'},
        {formula: 'N2', name: 'Nitrogen Gas', category: 'basic'},
        {formula: 'NaCl', name: 'Table Salt', category: 'basic'},
        {formula: 'NH3', name: 'Ammonia', category: 'basic'},
        {formula: 'CH4', name: 'Methane', category: 'basic'},
        {formula: 'H2O2', name: 'Hydrogen Peroxide', category: 'basic'},
        {formula: 'H2SO4', name: 'Sulfuric Acid', category: 'acids'},
        {formula: 'HCl', name: 'Hydrochloric Acid', category: 'acids'},
        {formula: 'HNO3', name: 'Nitric Acid', category: 'acids'},
        {formula: 'CH3COOH', name: 'Acetic Acid (Vinegar)', category: 'acids'},
        {formula: 'H3PO4', name: 'Phosphoric Acid', category: 'acids'},
        {formula: 'HF', name: 'Hydrofluoric Acid', category: 'acids'},
        {formula: 'NaOH', name: 'Sodium Hydroxide', category: 'bases'},
        {formula: 'Ca(OH)2', name: 'Calcium Hydroxide', category: 'bases'},
        {formula: 'KOH', name: 'Potassium Hydroxide', category: 'bases'},
        {formula: 'Mg(OH)2', name: 'Magnesium Hydroxide', category: 'bases'},
        {formula: 'CaCO3', name: 'Calcium Carbonate (Limestone)', category: 'salts'},
        {formula: 'NaHCO3', name: 'Sodium Bicarbonate (Baking Soda)', category: 'salts'},
        {formula: 'Na2CO3', name: 'Sodium Carbonate (Washing Soda)', category: 'salts'},
        {formula: 'KNO3', name: 'Potassium Nitrate', category: 'salts'},
        {formula: 'AgNO3', name: 'Silver Nitrate', category: 'salts'},
        {formula: 'BaSO4', name: 'Barium Sulfate', category: 'salts'},
        {formula: 'C2H5OH', name: 'Ethanol (Alcohol)', category: 'organic'},
        {formula: 'C6H12O6', name: 'Glucose (Sugar)', category: 'organic'},
        {formula: 'C12H22O11', name: 'Sucrose (Table Sugar)', category: 'organic'},
        {formula: 'C6H6', name: 'Benzene', category: 'organic'},
        {formula: 'C8H10N4O2', name: 'Caffeine', category: 'organic'},
        {formula: 'C9H8O4', name: 'Aspirin', category: 'organic'},
        {formula: 'CuSO4\u00b75H2O', name: 'Copper Sulfate Pentahydrate', category: 'hydrates'},
        {formula: 'Na2SO4\u00b710H2O', name: 'Sodium Sulfate Decahydrate', category: 'hydrates'},
        {formula: 'MgSO4\u00b77H2O', name: 'Magnesium Sulfate Heptahydrate (Epsom Salt)', category: 'hydrates'},
        {formula: 'CaCl2\u00b72H2O', name: 'Calcium Chloride Dihydrate', category: 'hydrates'},
        {formula: 'Al2(SO4)3', name: 'Aluminum Sulfate', category: 'complex'},
        {formula: 'Fe2O3', name: 'Iron(III) Oxide (Rust)', category: 'complex'},
        {formula: 'Ca3(PO4)2', name: 'Calcium Phosphate', category: 'complex'},
        {formula: '[Cu(NH3)4]SO4', name: 'Tetraamminecopper(II) Sulfate', category: 'complex'},
        {formula: 'K4[Fe(CN)6]', name: 'Potassium Ferrocyanide', category: 'complex'},
        {formula: '2H2O', name: '2 molecules of Water', category: 'coefficients'},
        {formula: '3H2SO4', name: '3 molecules of Sulfuric Acid', category: 'coefficients'},
        {formula: '5NaCl', name: '5 molecules of Sodium Chloride', category: 'coefficients'},
        {formula: '2Ca(OH)2', name: '2 molecules of Calcium Hydroxide', category: 'coefficients'}
    ];

    /* ===== Periodic Table Layout ===== */
    var PERIODIC_LAYOUT = [
        [{sym:'H',cat:'nonmetal'},null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,{sym:'He',cat:'noble-gas'}],
        [{sym:'Li',cat:'alkali-metal'},{sym:'Be',cat:'alkaline-earth'},null,null,null,null,null,null,null,null,null,null,{sym:'B',cat:'metalloid'},{sym:'C',cat:'nonmetal'},{sym:'N',cat:'nonmetal'},{sym:'O',cat:'nonmetal'},{sym:'F',cat:'halogen'},{sym:'Ne',cat:'noble-gas'}],
        [{sym:'Na',cat:'alkali-metal'},{sym:'Mg',cat:'alkaline-earth'},null,null,null,null,null,null,null,null,null,null,{sym:'Al',cat:'post-transition'},{sym:'Si',cat:'metalloid'},{sym:'P',cat:'nonmetal'},{sym:'S',cat:'nonmetal'},{sym:'Cl',cat:'halogen'},{sym:'Ar',cat:'noble-gas'}],
        [{sym:'K',cat:'alkali-metal'},{sym:'Ca',cat:'alkaline-earth'},{sym:'Sc',cat:'transition-metal'},{sym:'Ti',cat:'transition-metal'},{sym:'V',cat:'transition-metal'},{sym:'Cr',cat:'transition-metal'},{sym:'Mn',cat:'transition-metal'},{sym:'Fe',cat:'transition-metal'},{sym:'Co',cat:'transition-metal'},{sym:'Ni',cat:'transition-metal'},{sym:'Cu',cat:'transition-metal'},{sym:'Zn',cat:'transition-metal'},{sym:'Ga',cat:'post-transition'},{sym:'Ge',cat:'metalloid'},{sym:'As',cat:'metalloid'},{sym:'Se',cat:'nonmetal'},{sym:'Br',cat:'halogen'},{sym:'Kr',cat:'noble-gas'}],
        [{sym:'Rb',cat:'alkali-metal'},{sym:'Sr',cat:'alkaline-earth'},{sym:'Y',cat:'transition-metal'},{sym:'Zr',cat:'transition-metal'},{sym:'Nb',cat:'transition-metal'},{sym:'Mo',cat:'transition-metal'},{sym:'Tc',cat:'transition-metal'},{sym:'Ru',cat:'transition-metal'},{sym:'Rh',cat:'transition-metal'},{sym:'Pd',cat:'transition-metal'},{sym:'Ag',cat:'transition-metal'},{sym:'Cd',cat:'transition-metal'},{sym:'In',cat:'post-transition'},{sym:'Sn',cat:'post-transition'},{sym:'Sb',cat:'metalloid'},{sym:'Te',cat:'metalloid'},{sym:'I',cat:'halogen'},{sym:'Xe',cat:'noble-gas'}],
        [{sym:'Cs',cat:'alkali-metal'},{sym:'Ba',cat:'alkaline-earth'},{sym:'La',cat:'lanthanide'},{sym:'Hf',cat:'transition-metal'},{sym:'Ta',cat:'transition-metal'},{sym:'W',cat:'transition-metal'},{sym:'Re',cat:'transition-metal'},{sym:'Os',cat:'transition-metal'},{sym:'Ir',cat:'transition-metal'},{sym:'Pt',cat:'transition-metal'},{sym:'Au',cat:'transition-metal'},{sym:'Hg',cat:'transition-metal'},{sym:'Tl',cat:'post-transition'},{sym:'Pb',cat:'post-transition'},{sym:'Bi',cat:'post-transition'},{sym:'Po',cat:'metalloid'},{sym:'At',cat:'halogen'},{sym:'Rn',cat:'noble-gas'}],
        [{sym:'Fr',cat:'alkali-metal'},{sym:'Ra',cat:'alkaline-earth'},{sym:'Ac',cat:'actinide'},{sym:'Th',cat:'actinide'},{sym:'Pa',cat:'actinide'},{sym:'U',cat:'actinide'},null,null,null,null,null,null,null,null,null,null,null,null]
    ];

    var CATEGORY_LABELS = {
        'basic': 'Basic Compounds',
        'acids': 'Acids',
        'bases': 'Bases',
        'salts': 'Salts',
        'organic': 'Organic Compounds',
        'hydrates': 'Hydrates',
        'complex': 'Complex Compounds',
        'coefficients': 'With Coefficients'
    };

    /* ===== State ===== */
    var calcTimer = null;
    var selectedElements = [];
    var history = [];
    var ptRendered = false;
    var compoundsRendered = false;

    /* ===== Formula Parser (Stack-based) ===== */
    function parseFormula(formula) {
        formula = formula.replace(/\s+/g, '').replace(/\u00b7/g, '.'); // normalize dot

        // Extract leading coefficient
        var coefficient = 1;
        var i = 0;
        var leadNum = '';
        while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
            leadNum += formula[i]; i++;
        }
        if (leadNum) { coefficient = parseInt(leadNum, 10); formula = formula.substring(i); }

        var stack = [{}];
        var curElem = '';
        var curNum = '';

        function flushElement() {
            if (curElem) {
                var count = curNum ? parseInt(curNum, 10) : 1;
                var top = stack[stack.length - 1];
                top[curElem] = (top[curElem] || 0) + count;
            }
            curElem = ''; curNum = '';
        }

        for (var j = 0; j < formula.length; j++) {
            var ch = formula[j];
            if (ch >= 'A' && ch <= 'Z') {
                flushElement();
                curElem = ch;
            } else if (ch >= 'a' && ch <= 'z') {
                curElem += ch;
            } else if (ch >= '0' && ch <= '9') {
                curNum += ch;
            } else if (ch === '(' || ch === '[') {
                flushElement();
                stack.push({});
            } else if (ch === ')' || ch === ']') {
                flushElement();
                var mult = '';
                var k = j + 1;
                while (k < formula.length && formula[k] >= '0' && formula[k] <= '9') { mult += formula[k]; k++; }
                mult = mult ? parseInt(mult, 10) : 1;
                j = k - 1;
                var group = stack.pop();
                var parent = stack[stack.length - 1];
                for (var el in group) { parent[el] = (parent[el] || 0) + group[el] * mult; }
            } else if (ch === '.') {
                flushElement();
                // hydrate separator: read optional number prefix for next part
            }
        }
        flushElement();

        var result = stack[0];
        if (coefficient > 1) {
            for (var el2 in result) { result[el2] *= coefficient; }
        }
        return { composition: result, coefficient: coefficient };
    }

    /* ===== Calculate Molar Mass ===== */
    function calculateMolarMass(isAuto) {
        var formula = ($('mm-formula') || {}).value;
        if (!formula) { formula = ''; }
        formula = formula.trim();
        if (!formula) {
            if (!isAuto) showError('Please enter a chemical formula');
            else hideResults();
            return;
        }

        try {
            var parsed = parseFormula(formula);
            var comp = parsed.composition;

            // Validate
            for (var el in comp) {
                if (!ELEMENTS[el]) throw new Error('Unknown element: ' + el);
            }

            var totalMass = 0;
            var elemData = [];
            for (var el2 in comp) {
                var count = comp[el2];
                var mass = ELEMENTS[el2].mass * count;
                totalMass += mass;
                elemData.push({ symbol: el2, name: ELEMENTS[el2].name, count: count, mass: mass, atomicMass: ELEMENTS[el2].mass });
            }
            elemData.sort(function (a, b) { return b.mass - a.mass; });

            displayResults(formula, totalMass, elemData, parsed.coefficient);
            saveHistory(formula, totalMass);
        } catch (e) {
            if (isAuto) hideResults();
            else showError(e.message || 'Error parsing formula');
        }
    }

    /* ===== Display Results ===== */
    function displayResults(formula, totalMass, elemData, coefficient) {
        var panel = $('mm-panel-result');
        if (!panel) return;

        // Mass card
        var massEl = $('mm-mass-value');
        if (massEl) massEl.textContent = totalMass.toFixed(3);

        // Compound name lookup
        var match = null;
        for (var i = 0; i < COMMON_COMPOUNDS.length; i++) {
            if (COMMON_COMPOUNDS[i].formula === formula) { match = COMMON_COMPOUNDS[i]; break; }
        }
        var nameEl = $('mm-compound-label');
        if (nameEl) nameEl.textContent = match ? match.name : '';

        var formulaEl = $('mm-formula-rendered');
        if (formulaEl) {
            var html = formatFormulaHTML(formula);
            if (coefficient > 1) html += ' <span style="font-size:0.75rem;opacity:0.85;">(' + coefficient + ' molecules)</span>';
            formulaEl.innerHTML = html;
        }

        // Composition table
        var tbody = $('mm-comp-tbody');
        if (tbody) {
            var rows = '';
            for (var j = 0; j < elemData.length; j++) {
                var ed = elemData[j];
                var pct = (ed.mass / totalMass * 100);
                rows += '<tr>' +
                    '<td><span class="mm-elem-sym">' + ed.symbol + '</span><br><span class="mm-elem-name">' + ed.name + '</span></td>' +
                    '<td>' + ed.count + '</td>' +
                    '<td>' + ed.atomicMass.toFixed(3) + '</td>' +
                    '<td><strong>' + pct.toFixed(2) + '%</strong></td>' +
                    '<td><div class="mm-pct-bar"><div class="mm-pct-fill" style="width:' + pct.toFixed(1) + '%"></div></div></td>' +
                    '</tr>';
            }
            tbody.innerHTML = rows;
        }

        // Show result, hide empty state
        var empty = $('mm-empty-state');
        var content = $('mm-result-content');
        if (empty) empty.style.display = 'none';
        if (content) content.style.display = 'block';

        // Store data for copy/share
        panel.dataset.formula = formula;
        panel.dataset.mass = totalMass.toFixed(3);
    }

    function hideResults() {
        var empty = $('mm-empty-state');
        var content = $('mm-result-content');
        if (empty) empty.style.display = '';
        if (content) content.style.display = 'none';
    }

    function showError(msg) {
        var content = $('mm-result-content');
        var empty = $('mm-empty-state');
        if (empty) empty.style.display = 'none';
        if (content) {
            content.style.display = 'block';
            content.innerHTML = '<div class="mm-alert mm-alert-error">' + escapeHtml(msg) + '</div>';
        }
    }

    /* ===== Formula Preview ===== */
    function updatePreview() {
        var input = ($('mm-formula') || {}).value || '';
        var prev = $('mm-preview');
        if (!prev) return;
        if (!input.trim()) { prev.innerHTML = ''; return; }
        prev.innerHTML = formatFormulaHTML(input.trim());
    }

    /* ===== Format Formula as HTML ===== */
    function formatFormulaHTML(formula) {
        var out = '';
        var i = 0;

        // Leading coefficient
        var coef = '';
        while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') { coef += formula[i]; i++; }
        if (coef) out += '<span style="color:var(--mm-tool);font-weight:700;">' + coef + '</span>';

        while (i < formula.length) {
            var ch = formula[i];
            if (ch >= 'A' && ch <= 'Z') {
                var elem = ch; i++;
                if (i < formula.length && formula[i] >= 'a' && formula[i] <= 'z') { elem += formula[i]; i++; }
                out += '<span style="font-weight:600;">' + elem + '</span>';
                var num = '';
                while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') { num += formula[i]; i++; }
                if (num) out += '<sub>' + num + '</sub>';
            } else if (ch === '(' || ch === ')' || ch === '[' || ch === ']') {
                out += '<span style="color:#e53e3e;font-weight:700;">' + ch + '</span>';
                i++;
                if ((ch === ')' || ch === ']') && i < formula.length && formula[i] >= '0' && formula[i] <= '9') {
                    var num2 = '';
                    while (i < formula.length && formula[i] >= '0' && formula[i] <= '9') { num2 += formula[i]; i++; }
                    out += '<sub style="color:#e53e3e;">' + num2 + '</sub>';
                }
            } else if (ch === '\u00b7' || ch === '.') {
                out += '<span style="color:var(--mm-tool);font-weight:700;margin:0 2px;">\u00b7</span>';
                i++;
            } else {
                out += ch; i++;
            }
        }
        return out;
    }

    /* ===== Debounced Auto-Calculate ===== */
    function debounceCalc() {
        clearTimeout(calcTimer);
        calcTimer = setTimeout(function () {
            var f = ($('mm-formula') || {}).value || '';
            if (f.trim()) calculateMolarMass(true);
            else hideResults();
        }, 500);
    }

    function onInput() {
        updatePreview();
        debounceCalc();
    }

    /* ===== Example Chips ===== */
    function loadExample(formula) {
        var inp = $('mm-formula');
        if (!inp) return;
        inp.value = formula;
        updatePreview();
        calculateMolarMass(false);
    }

    /* ===== Tab Switching ===== */
    function switchTab(panelId) {
        var tabs = document.querySelectorAll('.mm-output-tab');
        var panels = document.querySelectorAll('.mm-panel');
        for (var i = 0; i < tabs.length; i++) {
            var active = tabs[i].getAttribute('data-panel') === panelId;
            tabs[i].classList.toggle('active', active);
        }
        for (var j = 0; j < panels.length; j++) {
            panels[j].classList.toggle('active', panels[j].id === 'mm-panel-' + panelId);
        }
        // Lazy render
        if (panelId === 'ptable' && !ptRendered) renderPeriodicTable();
        if (panelId === 'compounds' && !compoundsRendered) renderCompounds();
    }

    /* ===== Periodic Table ===== */
    function renderPeriodicTable() {
        var container = $('mm-ptable');
        if (!container) return;
        ptRendered = true;

        var html = '';
        for (var r = 0; r < PERIODIC_LAYOUT.length; r++) {
            var row = PERIODIC_LAYOUT[r];
            for (var c = 0; c < row.length; c++) {
                var cell = row[c];
                if (!cell) {
                    html += '<div class="mm-ptable-cell mm-ptable-placeholder"></div>';
                } else {
                    var e = ELEMENTS[cell.sym];
                    if (!e) {
                        html += '<div class="mm-ptable-cell mm-ptable-placeholder"></div>';
                    } else {
                        html += '<div class="mm-ptable-cell mm-cat-' + cell.cat + '" data-sym="' + cell.sym + '" title="' + e.name + ' (' + cell.sym + ') — ' + e.mass.toFixed(3) + ' g/mol">' +
                            '<span class="mm-ptable-num">' + e.number + '</span>' +
                            '<span class="mm-ptable-sym">' + cell.sym + '</span>' +
                            '<span class="mm-ptable-mass">' + e.mass.toFixed(2) + '</span>' +
                            '</div>';
                    }
                }
            }
        }
        container.innerHTML = html;

        // Legend
        var legend = $('mm-ptable-legend');
        if (legend) {
            var cats = [
                {cat:'nonmetal',label:'Nonmetal'},{cat:'noble-gas',label:'Noble Gas'},{cat:'alkali-metal',label:'Alkali Metal'},
                {cat:'alkaline-earth',label:'Alkaline Earth'},{cat:'transition-metal',label:'Transition Metal'},
                {cat:'post-transition',label:'Post-Transition'},{cat:'metalloid',label:'Metalloid'},{cat:'halogen',label:'Halogen'},
                {cat:'lanthanide',label:'Lanthanide'},{cat:'actinide',label:'Actinide'}
            ];
            var lh = '';
            for (var li = 0; li < cats.length; li++) {
                lh += '<span class="mm-legend-item"><span class="mm-legend-swatch mm-cat-' + cats[li].cat + '"></span>' + cats[li].label + '</span>';
            }
            legend.innerHTML = lh;
        }

        // Click handler (event delegation)
        container.addEventListener('click', function (e) {
            var cell = e.target.closest('[data-sym]');
            if (!cell) return;
            selectElement(cell.getAttribute('data-sym'));
        });
    }

    function selectElement(sym) {
        var found = false;
        for (var i = 0; i < selectedElements.length; i++) {
            if (selectedElements[i].symbol === sym) { selectedElements[i].count++; found = true; break; }
        }
        if (!found) selectedElements.push({ symbol: sym, count: 1 });
        renderSelectedElements();
    }

    function renderSelectedElements() {
        var container = $('mm-selected-elements');
        var section = $('mm-selected-section');
        if (!container || !section) return;

        if (selectedElements.length === 0) {
            section.style.display = 'none'; return;
        }
        section.style.display = '';

        var html = '';
        for (var i = 0; i < selectedElements.length; i++) {
            html += '<span class="mm-sel-badge">' +
                '<span class="mm-sel-sym">' + selectedElements[i].symbol + '</span>' +
                '<input type="number" class="mm-sel-count" value="' + selectedElements[i].count + '" min="1" max="99" data-idx="' + i + '">' +
                '<button type="button" class="mm-sel-del" data-del="' + i + '">&times;</button>' +
                '</span>';
        }
        container.innerHTML = html;
    }

    function handleSelectedAction(e) {
        var del = e.target.closest('[data-del]');
        if (del) {
            selectedElements.splice(parseInt(del.getAttribute('data-del'), 10), 1);
            renderSelectedElements(); return;
        }
        var countInput = e.target.closest('.mm-sel-count');
        if (countInput) {
            var idx = parseInt(countInput.getAttribute('data-idx'), 10);
            selectedElements[idx].count = Math.max(1, parseInt(countInput.value, 10) || 1);
        }
    }

    function buildFormulaFromSelection() {
        if (selectedElements.length === 0) return;
        // Hill order: C, H, then alphabetical
        var sorted = selectedElements.slice().sort(function (a, b) {
            if (a.symbol === 'C') return -1;
            if (b.symbol === 'C') return 1;
            if (a.symbol === 'H') return -1;
            if (b.symbol === 'H') return 1;
            return a.symbol.localeCompare(b.symbol);
        });
        var formula = '';
        for (var i = 0; i < sorted.length; i++) {
            formula += sorted[i].symbol;
            if (sorted[i].count > 1) formula += sorted[i].count;
        }
        loadExample(formula);
        switchTab('result');
    }

    function clearSelection() {
        selectedElements = [];
        renderSelectedElements();
    }

    /* ===== Compounds Panel ===== */
    function renderCompounds(filter) {
        var container = $('mm-compounds-list');
        if (!container) return;
        compoundsRendered = true;

        var q = (filter || '').toLowerCase();
        var cats = {};
        for (var i = 0; i < COMMON_COMPOUNDS.length; i++) {
            var c = COMMON_COMPOUNDS[i];
            if (q && c.formula.toLowerCase().indexOf(q) === -1 && c.name.toLowerCase().indexOf(q) === -1 && c.category.toLowerCase().indexOf(q) === -1) continue;
            if (!cats[c.category]) cats[c.category] = [];
            cats[c.category].push(c);
        }

        var html = '';
        var catOrder = ['basic','acids','bases','salts','organic','hydrates','complex','coefficients'];
        for (var ci = 0; ci < catOrder.length; ci++) {
            var key = catOrder[ci];
            if (!cats[key] || cats[key].length === 0) continue;
            html += '<div class="mm-cat-header">' + escapeHtml(CATEGORY_LABELS[key] || key) + '</div>';
            for (var j = 0; j < cats[key].length; j++) {
                var comp = cats[key][j];
                html += '<div class="mm-compound-card" data-formula="' + escapeHtml(comp.formula) + '">' +
                    '<div class="mm-compound-formula">' + formatFormulaHTML(comp.formula) + '</div>' +
                    '<div class="mm-compound-name">' + escapeHtml(comp.name) + '</div>' +
                    '</div>';
            }
        }
        container.innerHTML = html || '<p style="color:var(--text-muted);font-size:0.8125rem;padding:1rem;text-align:center;">No compounds match your search.</p>';
    }

    function handleCompoundClick(e) {
        var card = e.target.closest('[data-formula]');
        if (!card) return;
        loadExample(card.getAttribute('data-formula'));
        switchTab('result');
    }

    /* ===== History ===== */
    function loadHistory() {
        try { history = JSON.parse(sessionStorage.getItem('mm-history') || '[]'); } catch (e) { history = []; }
    }

    function saveHistory(formula, mass) {
        // Remove duplicates
        history = history.filter(function (h) { return h.formula !== formula; });
        history.unshift({ formula: formula, mass: mass.toFixed(3) });
        if (history.length > 5) history = history.slice(0, 5);
        try { sessionStorage.setItem('mm-history', JSON.stringify(history)); } catch (e) {}
        renderHistory();
    }

    function renderHistory() {
        var list = $('mm-history-list');
        var section = $('mm-history-section');
        if (!list || !section) return;

        if (history.length === 0) { section.style.display = 'none'; return; }
        section.style.display = '';

        var html = '';
        for (var i = 0; i < history.length; i++) {
            html += '<div class="mm-history-item" data-formula="' + escapeHtml(history[i].formula) + '">' +
                '<span>' + formatFormulaHTML(history[i].formula) + '</span>' +
                '<span class="mm-history-item-mass">' + history[i].mass + ' g/mol</span>' +
                '</div>';
        }
        list.innerHTML = html;
    }

    function clearHistory() {
        history = [];
        try { sessionStorage.removeItem('mm-history'); } catch (e) {}
        renderHistory();
    }

    /* ===== Actions ===== */
    function _toast(msg, dur, type) {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.showToast) {
            ToolUtils.showToast(msg, dur || 2000, type || 'success');
        }
    }

    function _copy(text, label) {
        if (typeof ToolUtils !== 'undefined' && ToolUtils.copyToClipboard) {
            ToolUtils.copyToClipboard(text, { toastMessage: (label || 'Text') + ' copied!' });
        } else if (navigator.clipboard) {
            navigator.clipboard.writeText(text);
            _toast((label || 'Text') + ' copied!', 2000, 'success');
        }
    }

    function shareUrl() {
        var panel = $('mm-panel-result');
        var formula = panel ? panel.dataset.formula : '';
        if (!formula) { _toast('Calculate a formula first', 2000, 'warning'); return; }
        var url = new URL(window.location.href.split('#')[0].split('?')[0]);
        url.searchParams.set('formula', formula);
        _copy(url.toString(), 'Share link');
        window.history.replaceState({}, '', url.toString());
    }

    function copyResult() {
        var panel = $('mm-panel-result');
        if (!panel || !panel.dataset.formula) { _toast('Calculate a formula first', 2000, 'warning'); return; }
        var formula = panel.dataset.formula;
        var mass = panel.dataset.mass;
        var text = 'Formula: ' + formula + '\nMolar Mass: ' + mass + ' g/mol\n';

        var rows = document.querySelectorAll('#mm-comp-tbody tr');
        if (rows.length) {
            text += '\nElemental Composition:\n';
            for (var i = 0; i < rows.length; i++) {
                var cells = rows[i].querySelectorAll('td');
                if (cells.length >= 4) {
                    text += cells[0].textContent.replace(/\n/g, ' ').trim() + ': ' + cells[1].textContent.trim() + ' atoms, ' + cells[3].textContent.trim() + '\n';
                }
            }
        }
        _copy(text, 'Results');
    }

    function printResult() {
        window.print();
    }

    /* ===== URL Params ===== */
    function loadFromURL() {
        var params = new URLSearchParams(window.location.search);
        var formula = params.get('formula');
        if (formula) {
            loadExample(formula);
            return true;
        }
        return false;
    }

    /* ===== Utility ===== */
    function escapeHtml(s) {
        var d = document.createElement('div');
        d.textContent = s;
        return d.innerHTML;
    }

    /* ===== FAQ Toggle ===== */
    function initFAQ() {
        document.addEventListener('click', function (e) {
            var btn = e.target.closest('.mm-faq-question');
            if (!btn) return;
            var item = btn.closest('.mm-faq-item');
            if (item) item.classList.toggle('open');
        });
    }

    /* ===== Scroll Animations ===== */
    function initAnimations() {
        var observer = new IntersectionObserver(function (entries) {
            for (var i = 0; i < entries.length; i++) {
                if (entries[i].isIntersecting) {
                    entries[i].target.classList.add('mm-visible');
                    observer.unobserve(entries[i].target);
                }
            }
        }, { threshold: 0.1 });

        var elems = document.querySelectorAll('.mm-anim');
        for (var j = 0; j < elems.length; j++) observer.observe(elems[j]);
    }

    /* ===== Init ===== */
    function init() {
        loadHistory();
        renderHistory();
        initFAQ();
        initAnimations();

        // Formula input
        var inp = $('mm-formula');
        if (inp) {
            inp.addEventListener('input', onInput);
            inp.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') { e.preventDefault(); calculateMolarMass(false); }
            });
        }

        // Calculate button
        var calcBtn = $('mm-calc-btn');
        if (calcBtn) calcBtn.addEventListener('click', function () { calculateMolarMass(false); });

        // Tab switching
        document.addEventListener('click', function (e) {
            var tab = e.target.closest('.mm-output-tab');
            if (tab) { switchTab(tab.getAttribute('data-panel')); return; }
        });

        // Example chips
        document.addEventListener('click', function (e) {
            var chip = e.target.closest('.mm-example-chip');
            if (chip && chip.dataset.formula) { loadExample(chip.dataset.formula); }
        });

        // Action buttons
        document.addEventListener('click', function (e) {
            var btn = e.target.closest('[data-action]');
            if (!btn) return;
            var action = btn.getAttribute('data-action');
            if (action === 'share') shareUrl();
            else if (action === 'copy') copyResult();
            else if (action === 'print') printResult();
        });

        // History clicks
        var historyList = $('mm-history-list');
        if (historyList) {
            historyList.addEventListener('click', function (e) {
                var item = e.target.closest('[data-formula]');
                if (item) loadExample(item.getAttribute('data-formula'));
            });
        }
        var historyClear = $('mm-history-clear');
        if (historyClear) historyClear.addEventListener('click', clearHistory);

        // Compounds panel - search + click
        var compSearch = $('mm-compound-search');
        if (compSearch) {
            compSearch.addEventListener('input', function () { renderCompounds(compSearch.value); });
        }
        var compList = $('mm-compounds-list');
        if (compList) compList.addEventListener('click', handleCompoundClick);

        // Selected elements panel
        var selContainer = $('mm-selected-elements');
        if (selContainer) selContainer.addEventListener('input', handleSelectedAction);
        if (selContainer) selContainer.addEventListener('click', handleSelectedAction);

        var buildBtn = $('mm-build-btn');
        if (buildBtn) buildBtn.addEventListener('click', buildFormulaFromSelection);
        var clearSelBtn = $('mm-clear-sel');
        if (clearSelBtn) clearSelBtn.addEventListener('click', clearSelection);

        // Load from URL or default
        if (!loadFromURL()) {
            loadExample('C6H12O6');
        }
    }

    /* ===== Public API ===== */
    return {
        init: init,
        ELEMENTS: ELEMENTS,
        COMMON_COMPOUNDS: COMMON_COMPOUNDS,
        parseFormula: parseFormula,
        formatFormulaHTML: formatFormulaHTML
    };
})();

document.addEventListener('DOMContentLoaded', window.MMCalc.init);
