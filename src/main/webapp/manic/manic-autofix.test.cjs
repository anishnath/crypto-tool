/* Unit tests for the shared auto-correct apply-loop (manic-autofix.js).
 * Pure — uses a MOCK `check`, so it needs neither Monaco nor the WASM.
 *   run:  node manic-autofix.test.cjs
 */
const fs = require('fs');
// manic-autofix.js is a browser IIFE that ALSO sets module.exports; load it in a
// fresh scope so this works regardless of any ambient package.json "type".
const mod = { exports: {} };
new Function('module', 'self', fs.readFileSync(__dirname + '/manic-autofix.js', 'utf8'))(mod, {});
const applyFixes = mod.exports.applyFixes;

let pass = 0, fail = 0;
function ok(name, cond, extra) {
  if (cond) { pass++; }
  else { fail++; console.log('  FAIL: ' + name + (extra != null ? ' — ' + extra : '')); }
}
function eq(name, got, want) { ok(name, got === want, JSON.stringify(got) + ' !== ' + JSON.stringify(want)); }

const fix = (start, len, replacement) => ({ fix: { start, len, replacement } });

// 1) a single fix is applied (mock returns the fix only while the error is present,
//    like the real check(): once corrected, no diagnostic)
{
  const r = applyFixes('ab cd', (code) => code === 'ab cd' ? [fix(3, 2, 'C * D')] : []);
  eq('single fix', r.code, 'ab C * D');
  eq('single fix count', r.fixed, 1);
}

// 2) MULTIPLE fixes in one pass apply with correct offsets (proves last→first order)
{
  let calls = 0;
  const r = applyFixes('xx yy zz', () => (calls++ === 0 ? [fix(0, 2, 'AAAA'), fix(6, 2, 'C')] : []));
  eq('multi-fix offsets', r.code, 'AAAA yy C');
  eq('multi-fix count', r.fixed, 2);
}

// 3) OVERLAPPING fixes: only the non-overlapping one is applied in a pass
{
  const r = applyFixes('abcdef', (code) => code === 'abcdef' ? [fix(0, 4, 'ZZ'), fix(2, 2, 'Q')] : []); // [0,4) and [2,4) overlap
  ok('overlap: not both applied', r.fixed <= 1, 'fixed=' + r.fixed);
  ok('overlap: still a string', typeof r.code === 'string');
}

// 4) clean input is left untouched (idempotent)
{
  const r = applyFixes('circle(c, (0,0), 5);', () => []);
  eq('idempotent code', r.code, 'circle(c, (0,0), 5);');
  eq('idempotent count', r.fixed, 0);
}

// 5) MULTI-PASS: a fix revealed only after a prior fix is still applied
{
  const check = (code) => {
    if (code.indexOf('P') >= 0) return [fix(code.indexOf('P'), 1, 'Q')];
    if (code.indexOf('Q') >= 0) return [fix(code.indexOf('Q'), 1, 'R')];
    return [];
  };
  const r = applyFixes('..P..', check);
  eq('multi-pass result', r.code, '..R..');
  eq('multi-pass count', r.fixed, 2);
}

// 6) out-of-range fixes are ignored (robustness against a bad diagnostic)
{
  const r = applyFixes('abc', () => [fix(-1, 2, 'X'), fix(10, 5, 'Y')]);
  eq('OOB ignored', r.code, 'abc');
  eq('OOB count', r.fixed, 0);
}

// 7) a check that throws doesn't crash — returns input unchanged
{
  const r = applyFixes('abc', () => { throw new Error('boom'); });
  eq('throwing check safe', r.code, 'abc');
}

// 8) null input
eq('null input', applyFixes(null, () => []).code, '');

// 9) ONE-ERROR-PER-PASS: the real check() bails on the first expand error, so a
//    file with N glued names heals one fix per pass. This must survive well past
//    the old 6-pass cap (regression: a loop body with 16 slips only got 6 fixed).
{
  // 16 markers 'P'; each pass fixes exactly the first one it sees -> 'Q'
  let code = 'P P P P P P P P P P P P P P P P';
  const check = (c) => { const i = c.indexOf('P'); return i < 0 ? [] : [fix(i, 1, 'Q')]; };
  const r = applyFixes(code, check);
  eq('one-per-pass count', r.fixed, 16);
  ok('one-per-pass healed', r.code.indexOf('P') < 0, r.code);
}

// 10) includeRemovals: a DESTRUCTIVE fix (empty replacement) is skipped by default-
//     off, applied when on. Mirrors stray-token removal: silent pass vs the button.
{
  const strayRemoval = (code) => code.indexOf('sadas') >= 0
    ? [{ fix: { start: code.indexOf('sadas'), len: 5, replacement: '' } }] : [];
  const silent = applyFixes('a\nsadas\nb', strayRemoval, { includeRemovals: false });
  eq('removal skipped when off', silent.fixed, 0);
  eq('removal leaves code intact', silent.code, 'a\nsadas\nb');
  const manual = applyFixes('a\nsadas\nb', strayRemoval, { includeRemovals: true });
  eq('removal applied when on', manual.fixed, 1);
  eq('removal deletes the token', manual.code, 'a\n\nb');
  // default (no opts) includes removals — matches the manual/button behaviour
  eq('removal on by default', applyFixes('a\nsadas\nb', strayRemoval).fixed, 1);
}

console.log((fail ? 'FAILED ' : 'OK ') + pass + ' passed, ' + fail + ' failed');
process.exit(fail ? 1 : 0);
