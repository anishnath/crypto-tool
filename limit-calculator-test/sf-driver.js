// Drive THREE different equations through MathInsert.solve and verify
// we get one solution-NNN.tex file per call.

const fs = require('fs');
const vm = require('vm');
const path = require('path');

global.nerdamer = require('nerdamer');
require('nerdamer/Calculus.js');
require('nerdamer/Algebra.js');

function makeFakeCM(initial) {
  const lines = initial.split('\n');
  return {
    _lines: lines,
    getValue() { return this._lines.join('\n'); },
    setValue(s) { this._lines = s.split('\n'); },
    lineCount() { return this._lines.length; },
    getLine(i) { return this._lines[i] || ''; },
    getCursor(_) { return { line: this._lines.length - 1, ch: this._lines[this._lines.length - 1].length }; },
    getSelection() { return ''; },
    setBookmark(pos) { return { find: () => pos, clear: () => {} }; },
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
  fetch: () => Promise.reject(new Error('no backend')),
  Promise, setTimeout, clearTimeout,
  document: { getElementById: () => null, querySelectorAll: () => [] }
};
sandbox.global = sandbox;
sandbox.window.fileContents = {};
sandbox.window.addFileToTree = (name, isImage, content) => {
  if (content != null) sandbox.window.fileContents[name] = content;
};
sandbox.window.reuploadFile = () => {};
sandbox.CONFIG = { ctx: '', uploadUrl: '/upload' };
sandbox.window.CONFIG = sandbox.CONFIG;
sandbox.showSuccessToast = (m) => console.log('toast:', m);
sandbox.showErrorToast = (m) => console.log('err:  ', m);
sandbox.showWarningToast = (m) => console.log('warn: ', m);
vm.createContext(sandbox);

const modJs = '/Users/anish/git/crypto-tool/src/main/webapp/modern/js';
const latJs = '/Users/anish/git/crypto-tool/src/main/webapp/latex/static/js';
vm.runInContext(fs.readFileSync(path.join(modJs, 'integral-calculator-core.js'), 'utf8'), sandbox);
vm.runInContext(fs.readFileSync(path.join(modJs, 'limit-calculator-core.js'), 'utf8'), sandbox);
vm.runInContext(fs.readFileSync(path.join(modJs, 'derivative-calculator-core.js'), 'utf8'), sandbox);
vm.runInContext(fs.readFileSync(path.join(latJs, 'solutions-file.js'), 'utf8'), sandbox);
vm.runInContext(fs.readFileSync(path.join(latJs, 'math-insert.js'), 'utf8'), sandbox);

const cm = makeFakeCM([
  '\\documentclass{article}',
  '\\usepackage{amsmath}',
  '\\begin{document}',
  '',
  'Three problems:',
  '$\\lim_{x \\to 0} \\frac{\\sin(x)}{x}$, $\\frac{d}{dx} x^3$, $\\int x^2\\,dx$',
  '',
  '\\end{document}'
].join('\n'));
sandbox.window.editorInstance = cm;
const MI = sandbox.window.MathInsert;

(async () => {
  const equations = [
    '\\lim_{x \\to 0} \\frac{\\sin(x)}{x}',
    '\\frac{d}{dx} x^3',
    '\\int x^2 \\, dx',
  ];
  for (const eq of equations) {
    const det = MI.detect(eq);
    console.log('---', det.type, ':', eq);
    MI.solve(det, 'simple');
    await new Promise(r => setTimeout(r, 30));
  }

  console.log('\n=== main.tex (after) ===');
  console.log(cm.getValue());
  console.log('\n=== files in tree ===');
  for (const fn of Object.keys(sandbox.window.fileContents).sort()) {
    console.log('  ' + fn + ' (' + sandbox.window.fileContents[fn].length + ' bytes)');
    console.log('    ' + sandbox.window.fileContents[fn].split('\n').slice(0, 2).join(' | '));
  }
})();
