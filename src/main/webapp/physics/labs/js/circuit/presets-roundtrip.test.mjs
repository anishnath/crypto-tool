// Bulk fixture test: run every built-in PRESET through
//   elements → formatNetlist → parseNetlist → elements'
// and assert deep equality per element.
//
// Any mismatch means a canonical param key has no PARAM_ALIAS entry, or
// an element type is missing from netlist.js's KNOWN_TYPES set.
//
// Run:   node presets-roundtrip.test.mjs

import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { parseNetlist, formatNetlist } from './netlist.js';

const here = dirname(fileURLToPath(import.meta.url));
const appPath = join(here, 'ui', 'app.js');
const src = readFileSync(appPath, 'utf8');

// Grab the `const PRESETS = { … };` block.  The PRESETS literal is pure data —
// no template strings, no function calls — so eval on a sliced copy is safe.
const start = src.indexOf('const PRESETS = {');
if (start < 0) { console.error('PRESETS literal not found in', appPath); process.exit(1); }
const openIdx = src.indexOf('{', start);
let depth = 0, closeIdx = -1;
for (let i = openIdx; i < src.length; i++) {
    const c = src[i];
    if (c === '{') depth++;
    else if (c === '}') { depth--; if (depth === 0) { closeIdx = i; break; } }
}
if (closeIdx < 0) { console.error('could not find matching brace'); process.exit(1); }
const PRESETS = eval('(' + src.slice(openIdx, closeIdx + 1) + ')');

const names = Object.keys(PRESETS);
console.log(`Loaded ${names.length} presets from ui/app.js\n`);

function canon(el) {
    return {
        type: el.type,
        x1: +el.x1, y1: +el.y1,
        x2: +el.x2, y2: +el.y2,
        params: Object.fromEntries(
            Object.entries(el.params || {})
                .filter(([, v]) => v !== undefined && v !== null)
                .sort(([a], [b]) => a.localeCompare(b))
        ),
    };
}
const deepEq = (a, b) => JSON.stringify(a) === JSON.stringify(b);

let pass = 0, fail = 0;
const failures = [];
const typeSet = new Set();

for (const name of names) {
    const original = PRESETS[name];
    original.forEach(e => typeSet.add(e.type));

    let text, parsed;
    try {
        text = formatNetlist(original);
        parsed = parseNetlist(text).elements;
    } catch (err) {
        fail++;
        failures.push({ name, reason: 'threw: ' + err.message });
        continue;
    }

    if (parsed.length !== original.length) {
        fail++;
        failures.push({ name, reason: `count mismatch: ${original.length} → ${parsed.length}` });
        continue;
    }

    let mismatch = null;
    for (let i = 0; i < original.length; i++) {
        const a = canon(original[i]);
        const b = canon(parsed[i]);
        if (!deepEq(a, b)) { mismatch = { i, a, b }; break; }
    }
    if (mismatch) {
        fail++;
        failures.push({ name, reason: `element ${mismatch.i} mismatch`, a: mismatch.a, b: mismatch.b });
    } else {
        pass++;
    }
}

console.log(`✓ pass: ${pass}`);
console.log(`✗ fail: ${fail}\n`);

if (failures.length) {
    console.log('── FAILURES ──');
    for (const f of failures.slice(0, 20)) {
        console.log(`\n${f.name}: ${f.reason}`);
        if (f.a) console.log('  original:  ', JSON.stringify(f.a));
        if (f.b) console.log('  roundtrip: ', JSON.stringify(f.b));
    }
    if (failures.length > 20) console.log(`\n…and ${failures.length - 20} more`);
}

console.log(`\nDistinct element types exercised: ${typeSet.size}`);
console.log([...typeSet].sort().join(', '));

process.exit(fail ? 1 : 0);
