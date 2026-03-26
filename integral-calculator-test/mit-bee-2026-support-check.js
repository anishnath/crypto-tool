#!/usr/bin/env node
/**
 * MIT Integration Bee 2026 qualifying — support matrix vs integral-calculator stack.
 * Uses: normalizeExpr (core), nerdamer integrate, SymPy via child_process when needed.
 */
'use strict';

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const tmpPy = path.join(__dirname, '.mit-bee-sympy-tmp.py');
const nerdamer = require('nerdamer');
require('nerdamer/Calculus.js');
require('nerdamer/Algebra.js');

const Core = require('./require-core');
const normalizeExpr = Core.normalizeExpr;

function tryNerdamer(expr, v) {
    const n = normalizeExpr(expr);
    try {
        const r = nerdamer('integrate(' + n + ', ' + v + ')');
        const unresolved = r.hasIntegral && r.hasIntegral();
        const t = r.text();
        return { ok: !unresolved, normalized: n, text: t.substring(0, 120), unresolved };
    } catch (e) {
        return { ok: false, normalized: n, error: e.message };
    }
}

function trySymPy(pyExpr, v, definite) {
    const bounds = definite
        ? `(${v}, sympify('${definite.a.replace(/'/g, "\\'")}'), sympify('${definite.b.replace(/'/g, "\\'")}'))`
        : v;
    const code = `from sympy import *
import warnings
warnings.filterwarnings('ignore')
${v} = symbols('${v}', real=True)
try:
    expr = ${pyExpr}
except Exception as e:
    print('PARSE_FAIL', e)
    raise SystemExit(1)
try:
    ${definite ? `r = integrate(expr, ${bounds})` : `r = integrate(expr, ${v})`}
    if isinstance(r, Integral) or (hasattr(r,'has') and r.has(Integral)):
        print('SYM_UNRESOLVED')
    else:
        print('SYM_OK', str(r)[:200])
except Exception as e:
    print('SYM_ERR', str(e)[:120])
`;
    try {
        fs.writeFileSync(tmpPy, code, 'utf8');
        const out = execSync('python3 "' + tmpPy + '"', {
            encoding: 'utf8',
            timeout: 12000,
            maxBuffer: 512000
        }).trim();
        try { fs.unlinkSync(tmpPy); } catch (_) {}
        if (out.startsWith('PARSE_FAIL') || out.startsWith('SYM_ERR')) return { ok: false, detail: out };
        if (out.startsWith('SYM_UNRESOLVED')) return { ok: false, detail: out };
        if (out.startsWith('SYM_OK')) return { ok: true, detail: out };
        return { ok: false, detail: out };
    } catch (e) {
        return { ok: false, detail: (e.stderr || e.message || '').substring(0, 150) };
    }
}

/** Minimal nerdamer→Python for SymPy check (same idea as integral-calculator.js) */
function toPy(e) {
    let py = (e || '')
        .replace(/e\^([a-zA-Z_]+\([^)]*\))/g, 'exp($1)')
        .replace(/e\^(\([^)]+\))/g, 'exp$1')
        .replace(/e\^([a-zA-Z0-9_]+)/g, 'exp($1)')
        .replace(/\^/g, '**');
    const FUNS = 'sin|cos|tan|sec|csc|cot|sinh|cosh|tanh|coth|csch|sech|log|ln|sqrt|asin|acos|atan|asinh|acosh|atanh|exp|abs|floor|ceil|min|max|frac';
    py = py.replace(new RegExp('\\b(' + FUNS + ')\\(', 'gi'), '\uE000$1\uE001(');
    py = py
        .replace(/\)(\()/g, ')*$1')
        .replace(/\)([a-zA-Z])/g, ')*$1')
        .replace(/([a-zA-Z0-9])\(/g, '$1*(');
    py = py.replace(/\uE000(\w+)\uE001\(/g, '$1(');
    return py;
}

const CASES = [
    // Full sin^2025*cos^2026 hangs Nerdamer — use same-shape low power for CAS timing
    { id: 1, ui: 'sin(x)^3*cos(x)^4', v: 'x', py: 'sin(x)**3*cos(x)**4', def: { a: '-pi', b: 'pi' }, note: 'exam has sin^2025·cos^2026 (UI ok; CAS use symmetry answer 0)' },
    { id: 2, ui: 'e^(2026*e^x+x)', v: 'x', py: 'exp(2026*exp(x)+x)' },
    { id: 3, ui: 'mod(floor(x)/3,1)', v: 'x', py: 'Mod(floor(x)/3, 1)', def: { a: '0', b: '2026' }, note: 'frac part ⌊x⌋/3 — SymPy Mod' },
    { id: 4, ui: 'abs(x+abs(x))', v: 'x', py: null, note: '2026 nested abs — not expressible as single short UI string' },
    { id: 5, ui: '1/(sqrt(x+1)-sqrt(x-1))', v: 'x', py: '1/(sqrt(x+1)-sqrt(x-1))' },
    { id: 6, ui: 'sqrt(1+cosh(x))', v: 'x', py: 'sqrt(1+cosh(x))' },
    { id: '7a', ui: '2^log(x)/x^2', v: 'x', py: '2**log(x)/x**2', note: '2^log x interpretation' },
    { id: '7b', ui: '2*log(x)/x^2', v: 'x', py: '2*log(x)/x**2', note: '2 log x interpretation' },
    { id: 8, ui: null, v: 'x', py: null, note: 'Sum x^n/n! — not a single closed UI integrand without Sum()' },
    { id: 9, ui: 'x^2*sin(x)', v: 'x', py: 'x**2*sin(x)' },
    { id: 10, ui: '(x-1)^2/(2*e^x+x^2+1)', v: 'x', py: '(x-1)**2/(2*exp(x)+x**2+1)' },
    { id: 11, ui: 'max(0,sqrt(1-x^2)-1/2)', v: 'x', py: 'Max(0, sqrt(1-x**2)-Rational(1,2))', def: { a: '-1', b: '1' } },
    { id: 12, ui: null, v: 'x', py: null, note: 'Infinite nested radical — no finite UI string' },
    { id: 13, ui: 'cos(x)^5-10*cos(x)^3*sin(x)^2+5*cos(x)*sin(x)^4', v: 'x', py: 'cos(x)**5-10*cos(x)**3*sin(x)**2+5*cos(x)*sin(x)**4' },
    { id: 14, ui: 'atan(sqrt(x))', v: 'x', py: 'atan(sqrt(x))' },
    { id: 15, ui: null, v: 'x', py: null, note: 'Floor/ceiling combo on [0,1000] — not practical in UI' },
    { id: 16, ui: 'sqrt(cos(x)*cot(x)*csc(x)/(sin(x)*tan(x)*sec(x)))', v: 'x', py: 'sqrt(cos(x)*cot(x)*csc(x)/(sin(x)*tan(x)*sec(x)))' },
    { id: 17, ui: 'e^(-x^2)/(1+e^(2*x))', v: 'x', py: 'exp(-x**2)/(1+exp(2*x))', def: { a: '-oo', b: 'oo' } },
    { id: 18, ui: 'sin(x)^2/x^2-sin(2*x)/x', v: 'x', py: 'sin(x)**2/x**2-sin(2*x)/x' },
    { id: 19, ui: 'log(log(x))*log(log(log(x)))/(x*log(x))', v: 'x', py: 'log(log(x))*log(log(log(x)))/(x*log(x))' },
    { id: 20, ui: 'cos(pi/2*cos(pi/2*cos(x)^2)^2)^2', v: 'x', py: 'cos(pi/2*cos(pi/2*cos(x)**2)**2)**2', def: { a: '0', b: 'pi/2' } }
];

console.log('MIT Integration Bee 2026 qualifying — calculator support check\n');
console.log('Legend: Nerdamer=browser CAS; SymPy=OneCompiler fallback; UI=typable in box\n');

const rows = [];
for (const c of CASES) {
    if (!c.ui && !c.py) {
        rows.push({ id: c.id, nerd: '—', sym: '—', ui: 'NOT EXPRESSIBLE', note: c.note || '' });
        continue;
    }
    let nm = { ok: false, nerd: '—' };
    if (c.ui) {
        nm = tryNerdamer(c.ui, c.v);
    }
    let sym = { ok: false, detail: 'skip' };
    if (c.py) {
        const pyExpr = c.py;
        try {
            sym = trySymPy(pyExpr, c.v, c.def);
        } catch (e) {
            sym = { ok: false, detail: String(e) };
        }
    }
    const nerdLabel = nm.ok ? 'YES' : (nm.unresolved ? 'unresolved' : (nm.error || 'no'));
    const symLabel = sym.ok ? 'YES' : (sym.detail || '').substring(0, 40);
    rows.push({
        id: c.id,
        nerd: nerdLabel,
        sym: symLabel,
        ui: c.ui ? 'yes' : 'partial',
        note: (c.note || '') + (nm.ok ? '' : '')
    });
}

for (const r of rows) {
    console.log(
        String(r.id).padStart(4),
        '| Nerdamer:', String(r.nerd).padEnd(12),
        '| SymPy:', String(r.sym).padEnd(44),
        '| UI:', r.ui,
        r.note ? ' — ' + r.note : ''
    );
}

console.log('\nRun: npm test && npm run test:sympy (project root integral-calculator-test)');
