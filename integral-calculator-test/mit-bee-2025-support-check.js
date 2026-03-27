#!/usr/bin/env node
/**
 * MIT Integration Bee 2025 qualifying — support matrix vs integral-calculator stack.
 * LaTeX source: qualifying_round_2025_test.pdf (official MIT).
 * Uses: normalizeExpr (core), nerdamer integrate, SymPy via child_process.
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
        return { ok: !unresolved, normalized: n, unresolved, error: null };
    } catch (e) {
        return { ok: false, normalized: n, unresolved: false, error: e.message };
    }
}

/** SymPy check; optional extraSymbols; opts: { timeoutMs, meijergOff, skipDoitSum } */
function trySymPy(pyExpr, v, definite, extraSymbols, opts) {
    opts = opts || {};
    const timeoutMs = opts.timeoutMs != null ? opts.timeoutMs : 25000;
    const meijergKw = definite && opts.meijergOff ? ', meijerg=False' : '';
    const bounds = definite
        ? `(${v}, sympify('${definite.a.replace(/'/g, "\\'")}'), sympify('${definite.b.replace(/'/g, "\\'")}'))${meijergKw}`
        : v;
    const extra = extraSymbols ? extraSymbols + '\n' : '';
    const doitBlock = opts.skipDoitSum
        ? ''
        : 'try:\n' +
          '    if expr.has(Sum):\n' +
          '        expr = expr.doit(deep=True)\n' +
          'except Exception:\n' +
          '    pass\n';
    const code =
        'from sympy import *\n' +
        'import warnings\n' +
        "warnings.filterwarnings('ignore')\n" +
        extra +
        v +
        " = symbols('" +
        v +
        "', real=True)\n" +
        'try:\n' +
        '    expr = ' +
        pyExpr +
        '\n' +
        'except Exception as e:\n' +
        "    print('PARSE_FAIL', e)\n" +
        '    raise SystemExit(1)\n' +
        doitBlock +
        'try:\n' +
        '    ' +
        (definite ? 'r = integrate(expr, ' + bounds + ')' : 'r = integrate(expr, ' + v + ')') +
        '\n' +
        "    if isinstance(r, Integral) or (hasattr(r,'has') and r.has(Integral)):\n" +
        "        print('SYM_UNRESOLVED')\n" +
        '    else:\n' +
        "        print('SYM_OK', str(r)[:220])\n" +
        'except Exception as e:\n' +
        "    print('SYM_ERR', str(e)[:120])\n";
    try {
        fs.writeFileSync(tmpPy, code, 'utf8');
        const out = execSync('python3 "' + tmpPy + '"', {
            encoding: 'utf8',
            timeout: timeoutMs,
            maxBuffer: 512000
        }).trim();
        try {
            fs.unlinkSync(tmpPy);
        } catch (_) {}
        if (out.startsWith('PARSE_FAIL') || out.startsWith('SYM_ERR')) return { ok: false, detail: out };
        if (out.startsWith('SYM_UNRESOLVED')) return { ok: false, detail: out };
        if (out.startsWith('SYM_OK')) return { ok: true, detail: out };
        return { ok: false, detail: out };
    } catch (e) {
        return { ok: false, detail: (e.stderr || e.message || '').substring(0, 150) };
    }
}

/**
 * Cases from qualifying_round_2025_test.pdf (user-provided LaTeX).
 * ui: typable integrand (calculator / nerdamer style, ^ for powers).
 * py: SymPy expression (single assignment rhs).
 */
const CASES = [
    { id: 1, ui: '(x+sqrt(x))/(1+sqrt(x))', v: 'x', py: '(x+sqrt(x))/(1+sqrt(x))' },
    { id: 2, ui: 'e^(x+1)/(e^x+1)', v: 'x', py: 'exp(x+1)/(exp(x)+1)' },
    {
        id: 3,
        ui: '(3*sin(x)-sin(3*x))^(1/3)',
        v: 'x',
        py: '(3*sin(x)-sin(3*x))**Rational(1,3)',
        note: '∛(3sin x − sin 3x)'
    },
    {
        id: 4,
        ui: null,
        v: 'x',
        py: 'log(x**(log(x**x)))/x**2',
        def: { a: '1', b: 'exp(exp(1))' },
        note: '∫₁^{e^e} log(x^{log(x^x)})/x² — bounds sympify e^e'
    },
    {
        id: 5,
        ui: 'cos(20*x)*sin(25*x)',
        v: 'x',
        py: 'cos(20*x)*sin(25*x)',
        def: { a: '-pi/2', b: 'pi/2' }
    },
    {
        id: 6,
        ui: 'sin(x)*cos(x)*tan(x)*cot(x)*sec(x)*csc(x)',
        v: 'x',
        py: 'sin(x)*cos(x)*tan(x)*cot(x)*sec(x)*csc(x)',
        def: { a: '0', b: '2*pi' },
        note: 'singularities on [0,2π]; CAS may disagree with contest convention'
    },
    {
        id: 7,
        ui: '(x*log(x)*cos(x)-sin(x))/(x*log(x)^2)',
        v: 'x',
        py: '(x*log(x)*cos(x)-sin(x))/(x*log(x)**2)',
        note: 'log = natural log'
    },
    {
        id: 8,
        ui: '2^(x-1)+log(2*x)/log(2)',
        v: 'x',
        py: '2**(x-1)+log(2*x)/log(2)',
        def: { a: '1', b: '2' },
        note: 'log₂(2x) = ln(2x)/ln 2'
    },
    {
        id: 9,
        ui: 'x^2024*(1-x^2025)^2025',
        v: 'x',
        symV: 'u',
        py: '(1-u)**2025/Rational(2025)',
        def: { a: '0', b: '1' },
        note: 'SymPy uses u=x^{2025} form (same value); direct ∫x^{2024}(1-x^{2025})^{2025}dx times out in SymPy'
    },
    {
        id: 10,
        ui: 'x*(x-1/2)*(x-1)',
        v: 'x',
        py: 'x*(x-Rational(1,2))*(x-1)',
        def: { a: '0', b: '10' }
    },
    {
        id: 11,
        ui: 'floor(floor(x)/2)',
        v: 'x',
        py: 'floor(floor(x)/2)',
        def: { a: '0', b: '20' },
        note: 'SymPy often leaves ∫floor as unevaluated — use manual sum on intervals'
    },
    {
        id: 12,
        ui: null,
        v: 'x',
        py: null,
        note: 'Nested radical ··· — no finite closed UI string'
    },
    {
        id: 13,
        ui: 'sec(x)^4-tan(x)^4',
        v: 'x',
        py: 'sec(x)**4-tan(x)**4'
    },
    {
        id: 14,
        ui: 'sqrt(x*(1-x))',
        v: 'x',
        py: 'sqrt(x*(1-x))',
        def: { a: '0', b: '1' }
    },
    {
        id: 15,
        ui: 'sin(4*x)*cos(x)/(cos(2*x)*sin(x))',
        v: 'x',
        py: 'sin(4*x)*cos(x)/(cos(2*x)*sin(x))'
    },
    { id: 16, ui: 'sin(x)*sinh(x)', v: 'x', py: 'sin(x)*sinh(x)' },
    {
        id: 17,
        ui: 'sin(x)*cos(pi/3-x)',
        v: 'x',
        py: 'sin(x)*cos(pi/3-x)',
        def: { a: '0', b: 'pi/3' }
    },
    {
        id: 18,
        ui: '(cos(x)+cos(x+2*pi/3)+cos(x-2*pi/3))^2',
        v: 'x',
        py: '(cos(x)+cos(x+2*pi/3)+cos(x-2*pi/3))**2'
    },
    {
        id: 19,
        ui: 'Sum((-1)^k*x^(2*k),(k,1,oo))',
        v: 'x',
        py: 'Sum((-1)**k * x**(2*k), (k, 1, oo))',
        def: { a: '0', b: '1' },
        extra: "k = symbols('k', integer=True, positive=True)",
        note: 'Σ (−1)^k x^{2k} = −x²/(1+x²) for |x|<1; doit + integrate'
    }
];

console.log('MIT Integration Bee 2025 qualifying — calculator support check\n');
console.log('Legend: Nerdamer=browser CAS; SymPy=local Python; UI=typable integrand\n');

const rows = [];
let symPyOk = 0;
let symPyTotal = 0;
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
        symPyTotal++;
        const symVar = c.symV || c.v;
        try {
            sym = trySymPy(c.py, symVar, c.def, c.extra, c.sympyOpts);
            if (sym.ok) symPyOk++;
        } catch (e) {
            sym = { ok: false, detail: String(e) };
        }
    }
    const nerdLabel = nm.ok ? 'YES' : (nm.unresolved ? 'unresolved' : (nm.error ? nm.error.substring(0, 28) : 'no'));
    const symLabel = sym.ok ? 'YES' : (sym.detail || '').substring(0, 48);
    rows.push({
        id: c.id,
        nerd: nerdLabel,
        sym: symLabel,
        ui: c.ui ? 'yes' : 'partial',
        note: c.note || ''
    });
}

for (const r of rows) {
    console.log(
        String(r.id).padStart(4),
        '| Nerdamer:',
        String(r.nerd).padEnd(14),
        '| SymPy:',
        String(r.sym).padEnd(50),
        '| UI:',
        r.ui,
        r.note ? ' — ' + r.note : ''
    );
}

console.log('\nSymPy resolved: ' + symPyOk + ' / ' + symPyTotal);
console.log('Run: npm run test:mit-bee-2025');
