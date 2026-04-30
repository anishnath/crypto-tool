#!/usr/bin/env node
/**
 * Extracts buildPythonScript from trig-calculator-scripts.jsp and runs
 * it through python3.11 with sample inputs — verifies the Python the
 * JSP would actually POST is correct, before we wire it into the
 * controllers.
 *
 * Run:   node backend-script-test.js
 */
const fs = require('fs');
const { execSync } = require('child_process');

const jsp = fs.readFileSync(
    '../src/main/webapp/math/partials/trig-calculator-scripts.jsp', 'utf8');

// Extract the buildPythonScript function body
const m = jsp.match(/function buildPythonScript\(opts\) \{[\s\S]*?\n    \}/);
if (!m) { console.error('Could not extract buildPythonScript'); process.exit(2); }

// Wrap in IIFE that returns the function
const buildScript = new Function(
    'return (function () { ' + m[0] + ' return buildPythonScript; })()'
)();

// ─── Test cases mirroring the user's reports ──────────────────────
const cases = [
    { label: 'eq: sin(2x)=cos(x)',
      opts: { latex: '\\sin\\left(2x\\right)=\\cos\\left(x\\right)', mode: 'solve_equation' } },
    { label: 'eq: 2cos(x)^2-1=0',
      opts: { latex: '2\\cos\\left(x\\right)^2-1=0', mode: 'solve_equation' } },
    { label: 'ineq: sin(x)>1/2',
      opts: { latex: '\\sin\\left(x\\right)>\\frac{1}{2}', mode: 'solve_inequality' } },
    { label: 'simp: sin^4-cos^4 / sin^2-cos^2',
      opts: { latex: '\\frac{\\sin\\left(x\\right)^4-\\cos\\left(x\\right)^4}{\\sin\\left(x\\right)^2-\\cos\\left(x\\right)^2}',
              mode: 'simplify' } },
    { label: 'eval (deg): sin(45)',
      opts: { text: 'sin(45)', mode: 'evaluate', unit: 'deg' } },
    { label: 'eval (rad): sin(pi/6)',
      opts: { latex: '\\sin\\left(\\frac{\\pi}{6}\\right)', mode: 'evaluate', unit: 'rad' } },
    { label: 'prove: tan²-sin² = tan²·sin²',
      opts: { mode: 'prove',
              lhs: '\\tan^2\\left(x\\right)-\\sin^2\\left(x\\right)',
              rhs: '\\tan^2\\left(x\\right)\\sin^2\\left(x\\right)' } },
    { label: 'prove: sin²+cos² = 1',
      opts: { mode: 'prove',
              lhs: '\\sin^2\\left(x\\right)+\\cos^2\\left(x\\right)', rhs: '1' } },
    { label: 'prove FALSE: sin(x) = cos(x)',
      opts: { mode: 'prove',
              lhs: '\\sin\\left(x\\right)', rhs: '\\cos\\left(x\\right)' } },
    // Plain-text fallback path (Text mode)
    { label: 'text-mode eq: sin(2x)=cos(x)',
      opts: { text: 'sin(2*x)=cos(x)', mode: 'solve_equation' } },

    // ── PROVE MODE — identities students actually try ──
    { label: 'prove: 1+tan²x = sec²x (Pythagorean variant)',
      opts: { mode: 'prove',
              lhs: '1+\\tan^2\\left(x\\right)',
              rhs: '\\sec^2\\left(x\\right)' } },
    { label: 'prove: sin(2x) = 2 sin x cos x (double angle)',
      opts: { mode: 'prove',
              lhs: '\\sin\\left(2x\\right)',
              rhs: '2\\sin\\left(x\\right)\\cos\\left(x\\right)' } },
    { label: 'prove: cos(2x) = 1 − 2 sin²x',
      opts: { mode: 'prove',
              lhs: '\\cos\\left(2x\\right)',
              rhs: '1-2\\sin^2\\left(x\\right)' } },
    { label: 'prove: cos(2x) = 2 cos²x − 1',
      opts: { mode: 'prove',
              lhs: '\\cos\\left(2x\\right)',
              rhs: '2\\cos^2\\left(x\\right)-1' } },
    { label: 'prove: sec²x − 1 = tan²x',
      opts: { mode: 'prove',
              lhs: '\\sec^2\\left(x\\right)-1',
              rhs: '\\tan^2\\left(x\\right)' } },
    { label: 'prove: (1−cos 2x)/sin 2x = tan x',
      opts: { mode: 'prove',
              lhs: '\\frac{1-\\cos\\left(2x\\right)}{\\sin\\left(2x\\right)}',
              rhs: '\\tan\\left(x\\right)' } },
    { label: 'prove: cosh²−sinh² = 1 (hyperbolic Pythagorean)',
      opts: { mode: 'prove',
              lhs: '\\cosh^2\\left(x\\right)-\\sinh^2\\left(x\\right)',
              rhs: '1' } },
    { label: 'prove FALSE: tan(x) = sin(x)/cos(2x)',
      opts: { mode: 'prove',
              lhs: '\\tan\\left(x\\right)',
              rhs: '\\frac{\\sin\\left(x\\right)}{\\cos\\left(2x\\right)}' } },
    { label: 'prove FALSE: sin(x+y) = sin x + sin y',
      opts: { mode: 'prove',
              lhs: '\\sin\\left(x+y\\right)',
              rhs: '\\sin\\left(x\\right)+\\sin\\left(y\\right)' } },
    // ── Plain-text Prove mode (Text-mode user) ──
    { label: 'text prove: tan²x − sin²x = tan²x sin²x',
      opts: { mode: 'prove',
              lhs: 'tan(x)^2 - sin(x)^2',
              rhs: 'tan(x)^2 * sin(x)^2' } },

    // ── Regression: chip-driven prove with text input
    //    (the path that showed "not an identity" because the
    //    math-field's getValue('latex') was returning the smart-
    //    moded "s\in(2x)" form). We now send TEXT, not LaTeX. ──
    { label: 'chip text prove: (1 - cos(2*x))/sin(2*x) = tan(x)',
      opts: { mode: 'prove',
              lhs: '(1 - cos(2*x))/sin(2*x)',
              rhs: 'tan(x)' } },
    { label: 'chip text prove: 2sin(x)cos(x) = sin(2x)',
      opts: { mode: 'prove',
              lhs: '2*sin(x)*cos(x)',
              rhs: 'sin(2*x)' } },
    { label: 'chip text prove: 1+tan^2 = sec^2',
      opts: { mode: 'prove',
              lhs: '1+tan(x)^2',
              rhs: 'sec(x)^2' } },

    // ── EVALUATE MODE — composed expressions the simple
    //    parser rejects (the function calc's main SymPy win) ──
    { label: 'eval composed: sin(20°)sin(40°)sin(80°) = √3/8',
      opts: { mode: 'evaluate', unit: 'deg',
              text: 'sin(20)*sin(40)*sin(80)' } },
    { label: 'eval composed: cos(20°)cos(40°)cos(80°) = 1/8',
      opts: { mode: 'evaluate', unit: 'deg',
              text: 'cos(20)*cos(40)*cos(80)' } },
    { label: 'eval composed: sin(45°) + cos(45°) = √2',
      opts: { mode: 'evaluate', unit: 'deg',
              text: 'sin(45)+cos(45)' } },
    { label: 'eval rad: 2*sin(pi/4)*cos(pi/4) = 1',
      opts: { mode: 'evaluate', unit: 'rad',
              latex: '2\\sin\\left(\\frac{\\pi}{4}\\right)\\cos\\left(\\frac{\\pi}{4}\\right)' } },
    { label: 'eval composed: sin²(30°) + cos²(60°) = 1/2',
      opts: { mode: 'evaluate', unit: 'deg',
              text: 'sin(30)^2+cos(60)^2' } },
    { label: 'eval rad latex: sin(π/6)+sin(π/3)',
      opts: { mode: 'evaluate', unit: 'rad',
              latex: '\\sin\\left(\\frac{\\pi}{6}\\right)+\\sin\\left(\\frac{\\pi}{3}\\right)' } },
];

let pass = 0, fail = 0;
const t0 = Date.now();
for (const c of cases) {
    const code = buildScript(c.opts);
    const tmp = '/tmp/_trig_backend_test.py';
    fs.writeFileSync(tmp, code);
    let out, err = null, t = Date.now();
    try {
        out = execSync('python3.11 ' + tmp, { encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
    } catch (e) {
        err = e.stderr ? e.stderr.toString() : e.message;
    }
    const elapsed = Date.now() - t;
    const m2 = out && out.match(/RESULT:(\{[\s\S]*\})/);
    let parsed = null;
    if (m2) try { parsed = JSON.parse(m2[1]); } catch (_) {}

    const ok = parsed && parsed.ok;
    if (ok) pass++; else fail++;
    const mark = ok ? '✓' : '✗';
    const steps = (parsed && parsed.steps) || [];
    console.log(`${mark}  [${elapsed.toString().padStart(5)}ms]  ${c.label}` +
                (steps.length ? `  [${steps.length} steps]` : ''));
    if (parsed) {
        const summary = parsed.kind + ' → ' + (parsed.answer_latex || JSON.stringify(parsed));
        console.log(`             ${summary.length > 100 ? summary.slice(0, 97) + '…' : summary}`);
        if (steps.length) {
            steps.forEach((s, i) => {
                console.log(`             step ${i+1}: ${s.label}  (${s.rule})`);
            });
        }
        if (parsed.is_identity !== undefined)
            console.log(`             is_identity: ${parsed.is_identity}` +
                        (parsed.counterexample ? ' counterexample: ' + JSON.stringify(parsed.counterexample) : ''));
    } else {
        console.log(`             ${err || 'no RESULT line'}`);
        if (out) console.log(`             stdout: ${out.trim().slice(0, 200)}`);
    }
}
console.log('\n══════════════════════════════════════');
console.log(`${pass}/${cases.length} passed (${Date.now()-t0}ms total)`);
console.log('══════════════════════════════════════');
process.exit(fail ? 1 : 0);
