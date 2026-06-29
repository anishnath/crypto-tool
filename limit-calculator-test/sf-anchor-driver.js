// Drive THREE solves at THREE different cursor positions in the doc.
// Verify each `\input{solution-NNN}` line lands right after its origin line.

const fs = require('fs');
const vm = require('vm');
const path = require('path');

global.nerdamer = require('nerdamer');
require('nerdamer/Calculus.js');
require('nerdamer/Algebra.js');

function makeCM(initial) {
  const lines = initial.split('\n');
  return {
    _lines: lines,
    _cursorLine: 0,
    _cursorCh: 0,
    setCursorAt(line, ch) { this._cursorLine = line; this._cursorCh = ch; },
    getValue() { return this._lines.join('\n'); },
    setValue(s) { this._lines = s.split('\n'); },
    lineCount() { return this._lines.length; },
    getLine(i) { return this._lines[i] || ''; },
    getCursor(which) { return { line: this._cursorLine, ch: this._cursorCh }; },
    getSelection() { return ''; },
    setBookmark(pos) {
      var p = Object.assign({}, pos);
      var lines = this._lines;
      // Bookmarks should track edits — simulate by storing line content reference
      var lineText = lines[p.line];
      var self = this;
      return {
        find() {
          // Return current position of the bookmark by line content match
          for (var i = 0; i < self._lines.length; i++) {
            if (self._lines[i] === lineText) return { line: i, ch: p.ch };
          }
          return p;
        },
        clear() {}
      };
    },
    replaceRange(text, from, to) {
      const offset = (line, ch) => {
        let o = 0;
        for (let i = 0; i < line; i++) o += this._lines[i].length + 1;
        return o + ch;
      };
      const all = this._lines.join('\n');
      const a = offset(from.line, from.ch);
      const b = to ? offset(to.line, to.ch) : a;
      this._lines = (all.slice(0, a) + text + all.slice(b)).split('\n');
    },
    focus() {}
  };
}

const sandbox = {
  nerdamer: global.nerdamer,
  console, Math, parseFloat, String, RegExp, Number, Object, Array, isFinite, isNaN, Infinity, parseInt,
  window: {},
  fetch: () => Promise.reject(),
  Promise, setTimeout, clearTimeout,
  document: { getElementById: () => null, querySelectorAll: () => [] }
};
sandbox.global = sandbox;
sandbox.window.addEventListener = () => {};
sandbox.window.fileContents = {};
sandbox.window.addFileToTree = (n, _, c) => { if (c) sandbox.window.fileContents[n] = c; };
sandbox.window.reuploadFile = () => {};
sandbox.window.CONFIG = sandbox.CONFIG = { ctx: '', uploadUrl: '/upload' };
sandbox.showSuccessToast = () => {}; sandbox.showErrorToast = () => {}; sandbox.showWarningToast = () => {};
vm.createContext(sandbox);

const m = '/Users/anish/git/crypto-tool/src/main/webapp/modern/js';
const l = '/Users/anish/git/crypto-tool/src/main/webapp/latex/static/js';
['integral-calculator-core.js', 'limit-calculator-core.js', 'derivative-calculator-core.js'].forEach(f =>
  vm.runInContext(fs.readFileSync(path.join(m, f), 'utf8'), sandbox));
['solutions-file.js', 'math-insert.js'].forEach(f =>
  vm.runInContext(fs.readFileSync(path.join(l, f), 'utf8'), sandbox));

const cm = makeCM([
  '\\documentclass{article}',                          // 0
  '\\usepackage{amsmath}',                             // 1
  '\\begin{document}',                                 // 2
  '',                                                  // 3
  '\\section{Limits}',                                 // 4
  'Try this: $\\lim_{x \\to 0} \\frac{\\sin(x)}{x}$',  // 5  ← solve target #1
  '',                                                  // 6
  '\\section{Derivatives}',                            // 7
  'Differentiate: $\\frac{d}{dx} x^3$',                // 8  ← solve target #2
  '',                                                  // 9
  '\\section{Integrals}',                              // 10
  'Compute: $\\int x^2 \\, dx$',                       // 11 ← solve target #3
  '',                                                  // 12
  '\\end{document}'                                    // 13
].join('\n'));
sandbox.window.editorInstance = cm;
const MI = sandbox.window.MathInsert;

(async () => {
  const targets = [
    { search: 'Try this:', eq: '\\lim_{x \\to 0} \\frac{\\sin(x)}{x}' },
    { search: 'Differentiate:', eq: '\\frac{d}{dx} x^3' },
    { search: 'Compute:', eq: '\\int x^2 \\, dx' },
  ];
  for (const t of targets) {
    // Find the CURRENT line containing the search marker (post-mutation)
    let lineNum = -1;
    for (let i = 0; i < cm.lineCount(); i++) {
      if (cm.getLine(i).indexOf(t.search) >= 0) { lineNum = i; break; }
    }
    cm.setCursorAt(lineNum, cm.getLine(lineNum).length);
    MI.solve(MI.detect(t.eq), 'simple');
    await new Promise(r => setTimeout(r, 30));
  }
  console.log('=== main.tex after 3 solves at 3 positions ===');
  cm.getValue().split('\n').forEach((line, i) => console.log(String(i).padStart(2,' ') + ': ' + line));
})();
