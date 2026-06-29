#!/usr/bin/env node
/**
 * Matrix Math AI integration — parse, visualize eligibility, fence extraction smoke tests.
 * Run: node matrix-ai-integration-test.cjs
 */
'use strict';

const fs = require('fs');
const vm = require('vm');
const path = require('path');

function loadCore() {
  const ctx = { window: {}, module: { exports: {} }, exports: {} };
  const file = path.join(__dirname, 'src/main/webapp/modern/js/matrix-calculator-core.js');
  vm.runInNewContext(fs.readFileSync(file, 'utf8'), ctx);
  return ctx.window.MatrixCalculatorCore;
}

/** Minimal mirror of extractMathActions matrix fence parsing (no ESM/katex deps). */
function extractMatrixBlocks(text) {
  const found = [];
  const fenceRe = /```([\w#+.-]*)\s*\n([\s\S]*?)```/g;
  let m;
  while ((m = fenceRe.exec(text)) !== null) {
    const lang = (m[1] || '').toLowerCase();
    if (lang !== 'matrix' && lang !== 'matrices') continue;
    const kv = {};
    for (const line of m[2].trim().split(/\r?\n/)) {
      const pm = line.match(/^([a-z_]+)\s*:\s*(.+)$/i);
      if (pm) kv[pm[1].toLowerCase()] = pm[2].trim();
    }
    if (!kv.op && !kv.raw && !kv.matrixa) continue;
    found.push({
      action: 'matrix',
      op: kv.op || 'determinant',
      matrixA: kv.matrixa || kv.matrix_a || kv.latexa,
      matrixB: kv.matrixb || kv.matrix_b || kv.latexb,
      raw: kv.raw,
      n: kv.n != null ? parseInt(kv.n, 10) : undefined,
    });
  }
  return found;
}

let pass = 0;
let fail = 0;

function ok(cond, msg) {
  if (cond) {
    pass += 1;
    console.log('  OK  ' + msg);
  } else {
    fail += 1;
    console.log(' FAIL ' + msg);
  }
}

const core = loadCore();

console.log('\n=== MatrixCalculatorCore task scenarios ===\n');

const scenarios = [
  { name: 'multiply 2×2', task: { action: 'matrix', op: 'multiply', matrixA: '\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}', matrixB: '\\begin{pmatrix}5 & 6\\\\7 & 8\\end{pmatrix}' }, viz: true, op: 'multiply' },
  { name: 'det 3×3 raw', task: { action: 'matrix', raw: '\\det \\begin{pmatrix}1 & 2 & 3\\\\4 & 5 & 6\\\\7 & 8 & 10\\end{pmatrix}' }, viz: true, op: 'determinant' },
  { name: 'inverse 2×2', task: { action: 'matrix', op: 'inverse', matrixA: '\\begin{pmatrix}4 & 7\\\\2 & 6\\end{pmatrix}' }, viz: true, op: 'inverse' },
  { name: 'eigenvalues', task: { action: 'matrix', op: 'eigenvalues', matrixA: '\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}' }, viz: false, op: 'eigenvalues' },
  { name: 'eigenvectors 2×2 (viz)', task: { action: 'matrix', op: 'eigenvectors', matrixA: '\\begin{pmatrix}2 & 1\\\\1 & 2\\end{pmatrix}' }, viz: true, op: 'eigenvectors' },
  { name: 'rank', task: { action: 'matrix', op: 'rank', matrixA: '\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}' }, viz: false, op: 'rank' },
  { name: 'trace', task: { action: 'matrix', op: 'trace', matrixA: '\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}' }, viz: false, op: 'trace' },
  { name: 'rref', task: { action: 'matrix', op: 'rref', matrixA: '\\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}' }, viz: false, op: 'rref' },
  { name: 'JSON [[…]] multiply', task: { action: 'matrix', op: 'multiply', matrixA: '[[1,2],[3,4]]', matrixB: '[[5,6],[7,8]]' }, viz: true, op: 'multiply' },
  { name: 'power n=2', task: { action: 'matrix', op: 'power', n: 2, matrixA: '\\begin{pmatrix}2 & 0\\\\0 & 3\\end{pmatrix}' }, viz: true, op: 'power' },
  { name: '4×4 det (no viz)', task: { action: 'matrix', op: 'determinant', matrixA: '\\begin{pmatrix}1&0&0&0\\\\0&1&0&0\\\\0&0&1&0\\\\0&0&0&1\\end{pmatrix}' }, viz: false, op: 'determinant' },
  { name: 'symbolic inverse (no viz)', task: { action: 'matrix', op: 'inverse', matrixA: '\\begin{pmatrix}a & b\\\\c & d\\end{pmatrix}' }, viz: false, op: 'inverse' },
  { name: 'add 2×2', task: { action: 'matrix', op: 'add', matrixA: '\\begin{pmatrix}1 & 0\\\\0 & 1\\end{pmatrix}', matrixB: '\\begin{pmatrix}2 & 1\\\\0 & 2\\end{pmatrix}' }, viz: true, op: 'add' },
];

for (const s of scenarios) {
  const parsed = core.parseTask(s.task);
  ok(!!parsed, `${s.name} → parseTask`);
  if (parsed) ok(parsed.op === s.op, `${s.name} op=${parsed.op}`);
  ok(core.canVisualizeTask(s.task) === s.viz, `${s.name} Show graph eligible=${s.viz}`);
  ok(!!core.buildLatexFromTask(s.task), `${s.name} buildLatexFromTask`);
  ok(!!core.parseLatexMatrix(core.buildLatexFromTask(s.task)), `${s.name} latex round-trip`);
}

console.log('\n=== AI fence extraction (matrix blocks) ===\n');

const aiReply = `Here is a multiplication example:

\`\`\`matrix
op: multiply
matrixA: \\begin{pmatrix}1 & 2\\\\3 & 4\\end{pmatrix}
matrixB: \\begin{pmatrix}5 & 6\\\\7 & 8\\end{pmatrix}
\`\`\`

And a determinant:

\`\`\`matrix
raw: \\det \\begin{pmatrix}1 & 2 & 3\\\\4 & 5 & 6\\\\7 & 8 & 10\\end{pmatrix}
\`\`\`
`;

const blocks = extractMatrixBlocks(aiReply);
ok(blocks.length === 2, 'extracts 2 matrix fences from sample AI reply');
if (blocks[0]) {
  const t0 = { action: 'matrix', ...blocks[0] };
  ok(core.parseTask(t0)?.op === 'multiply', 'first block → multiply task');
  ok(core.canVisualizeTask(t0), 'multiply block → Show graph');
}
if (blocks[1]) {
  const t1 = { action: 'matrix', ...blocks[1] };
  ok(core.parseTask(t1)?.op === 'determinant', 'raw det block → determinant');
}

console.log('\n=== Prompt contract checklist (manual in browser) ===\n');
const manual = [
  'Integral page: "multiply [[1,2],[3,4]] by [[5,6],[7,8]]" → matrix card + Solve/Steps/Show graph',
  'Integral page: "show matrix multiplication example" → ```matrix``` block (not ```latex```)',
  'Matrix page: eigenvalues 2×2 → Solve works (SymPy, no 404 on context path)',
  'Chat: broken pmatrix row sep (single \\) still renders in card KaTeX',
  'Cross-topic: ask ODE on matrix page still routes to ```ode``` block',
];
manual.forEach((line, i) => console.log(`  ${i + 1}. ${line}`));

console.log(`\n${pass} passed, ${fail} failed\n`);
process.exit(fail ? 1 : 0);
