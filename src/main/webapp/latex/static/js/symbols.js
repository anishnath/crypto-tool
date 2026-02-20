(function() {
'use strict';

var SYMBOL_CATEGORIES = {
  'Greek': [
    { sym: '\\alpha', display: '\u03B1' },
    { sym: '\\beta', display: '\u03B2' },
    { sym: '\\gamma', display: '\u03B3' },
    { sym: '\\delta', display: '\u03B4' },
    { sym: '\\epsilon', display: '\u03B5' },
    { sym: '\\zeta', display: '\u03B6' },
    { sym: '\\eta', display: '\u03B7' },
    { sym: '\\theta', display: '\u03B8' },
    { sym: '\\iota', display: '\u03B9' },
    { sym: '\\kappa', display: '\u03BA' },
    { sym: '\\lambda', display: '\u03BB' },
    { sym: '\\mu', display: '\u03BC' },
    { sym: '\\nu', display: '\u03BD' },
    { sym: '\\xi', display: '\u03BE' },
    { sym: '\\pi', display: '\u03C0' },
    { sym: '\\rho', display: '\u03C1' },
    { sym: '\\sigma', display: '\u03C3' },
    { sym: '\\tau', display: '\u03C4' },
    { sym: '\\phi', display: '\u03C6' },
    { sym: '\\chi', display: '\u03C7' },
    { sym: '\\psi', display: '\u03C8' },
    { sym: '\\omega', display: '\u03C9' },
    { sym: '\\Gamma', display: '\u0393' },
    { sym: '\\Delta', display: '\u0394' },
    { sym: '\\Theta', display: '\u0398' },
    { sym: '\\Lambda', display: '\u039B' },
    { sym: '\\Pi', display: '\u03A0' },
    { sym: '\\Sigma', display: '\u03A3' },
    { sym: '\\Phi', display: '\u03A6' },
    { sym: '\\Psi', display: '\u03A8' },
    { sym: '\\Omega', display: '\u03A9' }
  ],
  'Math': [
    { sym: '\\sum', display: '\u2211' },
    { sym: '\\prod', display: '\u220F' },
    { sym: '\\int', display: '\u222B' },
    { sym: '\\oint', display: '\u222E' },
    { sym: '\\partial', display: '\u2202' },
    { sym: '\\nabla', display: '\u2207' },
    { sym: '\\infty', display: '\u221E' },
    { sym: '\\sqrt{}', display: '\u221A' },
    { sym: '\\pm', display: '\u00B1' },
    { sym: '\\mp', display: '\u2213' },
    { sym: '\\times', display: '\u00D7' },
    { sym: '\\div', display: '\u00F7' },
    { sym: '\\cdot', display: '\u00B7' },
    { sym: '\\leq', display: '\u2264' },
    { sym: '\\geq', display: '\u2265' },
    { sym: '\\neq', display: '\u2260' },
    { sym: '\\approx', display: '\u2248' },
    { sym: '\\equiv', display: '\u2261' },
    { sym: '\\subset', display: '\u2282' },
    { sym: '\\supset', display: '\u2283' },
    { sym: '\\in', display: '\u2208' },
    { sym: '\\notin', display: '\u2209' },
    { sym: '\\cup', display: '\u222A' },
    { sym: '\\cap', display: '\u2229' },
    { sym: '\\forall', display: '\u2200' },
    { sym: '\\exists', display: '\u2203' },
    { sym: '\\rightarrow', display: '\u2192' },
    { sym: '\\leftarrow', display: '\u2190' },
    { sym: '\\Rightarrow', display: '\u21D2' },
    { sym: '\\Leftarrow', display: '\u21D0' },
    { sym: '\\leftrightarrow', display: '\u2194' }
  ],
  'Arrows': [
    { sym: '\\rightarrow', display: '\u2192' },
    { sym: '\\leftarrow', display: '\u2190' },
    { sym: '\\uparrow', display: '\u2191' },
    { sym: '\\downarrow', display: '\u2193' },
    { sym: '\\Rightarrow', display: '\u21D2' },
    { sym: '\\Leftarrow', display: '\u21D0' },
    { sym: '\\Uparrow', display: '\u21D1' },
    { sym: '\\Downarrow', display: '\u21D3' },
    { sym: '\\leftrightarrow', display: '\u2194' },
    { sym: '\\Leftrightarrow', display: '\u21D4' },
    { sym: '\\mapsto', display: '\u21A6' },
    { sym: '\\hookrightarrow', display: '\u21AA' },
    { sym: '\\nearrow', display: '\u2197' },
    { sym: '\\searrow', display: '\u2198' },
    { sym: '\\nwarrow', display: '\u2196' },
    { sym: '\\swarrow', display: '\u2199' }
  ],
  'Accents': [
    { sym: '\\hat{}', display: '\u0302x' },
    { sym: '\\bar{}', display: '\u0304x' },
    { sym: '\\vec{}', display: '\u20D7x' },
    { sym: '\\dot{}', display: '\u0307x' },
    { sym: '\\ddot{}', display: '\u0308x' },
    { sym: '\\tilde{}', display: '\u0303x' },
    { sym: '\\frac{}{}', display: 'a/b' },
    { sym: '\\binom{}{}', display: 'C' }
  ]
};

var currentCategory = 'Greek';

function initSymbolPicker() {
  var tabsEl = document.getElementById('sp-tabs');
  if (!tabsEl) return;

  tabsEl.innerHTML = '';
  var cats = Object.keys(SYMBOL_CATEGORIES);
  for (var i = 0; i < cats.length; i++) {
    var btn = document.createElement('button');
    btn.className = 'sp-tab' + (cats[i] === currentCategory ? ' active' : '');
    btn.textContent = cats[i];
    btn.setAttribute('data-cat', cats[i]);
    btn.onclick = (function(cat) {
      return function() { selectCategory(cat); };
    })(cats[i]);
    tabsEl.appendChild(btn);
  }
  renderSymbols(currentCategory);
}

function selectCategory(cat) {
  currentCategory = cat;
  var tabs = document.querySelectorAll('.sp-tab');
  for (var i = 0; i < tabs.length; i++) {
    tabs[i].classList.toggle('active', tabs[i].getAttribute('data-cat') === cat);
  }
  renderSymbols(cat);
}

function renderSymbols(cat) {
  var grid = document.getElementById('sp-grid');
  if (!grid) return;
  grid.innerHTML = '';

  var syms = SYMBOL_CATEGORIES[cat] || [];
  for (var i = 0; i < syms.length; i++) {
    var btn = document.createElement('button');
    btn.className = 'sp-sym';
    btn.textContent = syms[i].display;
    btn.title = syms[i].sym;
    btn.onclick = (function(sym) {
      return function() { insertSymbol(sym); };
    })(syms[i].sym);
    grid.appendChild(btn);
  }
}

function insertSymbol(sym) {
  if (window.editorInstance) {
    var doc = window.editorInstance.getDoc();
    var cursor = doc.getCursor();
    doc.replaceRange(sym, cursor);
    window.editorInstance.focus();
  }
  document.getElementById('symbol-picker').classList.remove('visible');
}

function filterSymbols(query) {
  query = query.toLowerCase();
  var grid = document.getElementById('sp-grid');
  if (!grid) return;
  grid.innerHTML = '';

  var cats = Object.keys(SYMBOL_CATEGORIES);
  for (var c = 0; c < cats.length; c++) {
    var syms = SYMBOL_CATEGORIES[cats[c]];
    for (var i = 0; i < syms.length; i++) {
      if (syms[i].sym.toLowerCase().indexOf(query) !== -1 || query === '') {
        var btn = document.createElement('button');
        btn.className = 'sp-sym';
        btn.textContent = syms[i].display;
        btn.title = syms[i].sym;
        btn.onclick = (function(sym) {
          return function() { insertSymbol(sym); };
        })(syms[i].sym);
        grid.appendChild(btn);
      }
    }
  }
}

// Expose
window.LatexSymbols = {
  init: initSymbolPicker,
  filter: filterSymbols,
  categories: SYMBOL_CATEGORIES
};

})();
