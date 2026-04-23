// Unit tests for netlist.js — round-trip fidelity + parser robustness.
//
// Run:   node netlist.test.mjs

import { parseNetlist, formatNetlist } from './netlist.js';

let pass = 0, fail = 0;
function check(name, cond, detail = '') {
    if (cond) { pass++; console.log(`  ✓ ${name}`); }
    else      { fail++; console.log(`  ✗ ${name}${detail ? ' — ' + detail : ''}`); }
}

// ── 1. Basic round-trip: battery + switch + lamp (from 1.jpg vision test) ──
console.log('── basic round-trip ──');
const input = `dc-voltage 0 8 0 0 v=12
switch 0 0 3 0
lamp 3 0 6 0
wire 6 0 6 8
wire 0 8 3 8
wire 3 8 6 8
ground 0 8
`;
const { elements } = parseNetlist(input);
check('parses 7 elements', elements.length === 7);
check('dc-voltage has voltage=12', elements[0].params.voltage === 12);
check('ground collapses to single point', elements[6].x1 === 0 && elements[6].x2 === 0);

const reformatted = formatNetlist(elements);
check('re-formatted output is byte-identical', reformatted === input);

// ── 2. Shape compatibility with _deserializeCircuit ──
console.log('\n── shape compatibility ──');
const shapeOK = elements.every(e =>
    typeof e.type === 'string' &&
    Number.isFinite(e.x1) && Number.isFinite(e.y1) &&
    Number.isFinite(e.x2) && Number.isFinite(e.y2) &&
    e.params && typeof e.params === 'object'
);
check('every element has {type, x1, y1, x2, y2, params}', shapeOK);

// ── 3. Robustness: prose, code fences, inline comments ──
console.log('\n── robustness ──');
const messy = `Here is the netlist for your circuit:
\`\`\`
# single LED + resistor
dc-voltage 0 0 0 4 v=5
resistor 0 0 4 0 r=330  # current limit
led 4 0 8 0
wire 0 4 8 4
ground 8 4
\`\`\`
`;
const messyParsed = parseNetlist(messy).elements;
check('skips prose and fence lines', messyParsed.length === 5);
check('honors inline # comments', messyParsed[1].params.resistance === 330);

// ── 4. Error handling ──
console.log('\n── error handling ──');
let threw = false;
try { parseNetlist('error unclear_request\n'); } catch { threw = true; }
check('error sentinel throws', threw);

threw = false;
try { parseNetlist('just some random prose about nothing'); } catch { threw = true; }
check('zero-element input throws', threw);

threw = false;
try { parseNetlist(null); } catch { threw = true; }
check('non-string input throws', threw);

// ── 5. PARAM_ALIAS expansion ──
console.log('\n── PARAM_ALIAS expansion ──');
const aliased = parseNetlist(`resistor 0 0 4 0 r=1000
capacitor 0 0 4 0 c=0.000001
inductor 0 0 4 0 l=0.01
ac-voltage 0 0 0 4 vp=12 f=60
zener 0 0 4 0 vz=5.1
bjt-npn 0 0 4 0 beta=100
`).elements;
check('r → resistance', aliased[0].params.resistance === 1000);
check('c → capacitance', aliased[1].params.capacitance === 1e-6);
check('l → inductance',  aliased[2].params.inductance === 0.01);
check('vp → peakVoltage', aliased[3].params.peakVoltage === 12);
check('f → frequency',   aliased[3].params.frequency === 60);
check('vz → vz',         aliased[4].params.vz === 5.1);
check('beta → beta',     aliased[5].params.beta === 100);

// ── summary ──
console.log(`\n─ ${pass}/${pass + fail} passed ─`);
process.exit(fail ? 1 : 0);
