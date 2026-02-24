#!/usr/bin/env node
/**
 * Test the enhanced exprToLatex parser from ode-solver-calculator.js
 * Extracts the tokenizer + recursive-descent parser and verifies output.
 * Run: node test-ode-latex-preview.js
 */

// ========== Extract parser from the JS file ==========
var LATEX_FUNS = { sin:'\\sin', cos:'\\cos', tan:'\\tan', sec:'\\sec', csc:'\\csc', cot:'\\cot',
    sinh:'\\sinh', cosh:'\\cosh', tanh:'\\tanh', asin:'\\arcsin', acos:'\\arccos', atan:'\\arctan',
    log:'\\ln', ln:'\\ln', sqrt:'\\sqrt', abs:'\\left|' };
var LATEX_FUN_NAMES = Object.keys(LATEX_FUNS).sort(function(a,b){ return b.length - a.length; });
var LATEX_FUN_RE = new RegExp('^(' + LATEX_FUN_NAMES.join('|') + ')\\(');

function tokenize(s) {
    var tokens = [], i = 0;
    s = s.replace(/\*\*/g, '^');
    while (i < s.length) {
        var ch = s[i];
        if (/\s/.test(ch)) { i++; continue; }
        if (/[0-9]/.test(ch) || (ch === '.' && i+1 < s.length && /[0-9]/.test(s[i+1]))) {
            var num = '';
            while (i < s.length && /[0-9.]/.test(s[i])) num += s[i++];
            tokens.push({ type: 'num', val: num }); continue;
        }
        var fm = s.slice(i).match(LATEX_FUN_RE);
        if (fm) { tokens.push({ type: 'fn', val: fm[1] }); i += fm[1].length; continue; }
        if (s.slice(i, i+4) === 'exp(') { tokens.push({ type: 'fn', val: 'exp' }); i += 3; continue; }
        if (s.slice(i, i+4) === 'yppp' && (i+4 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+4]))) {
            tokens.push({ type: 'var', val: "y'''" }); i += 4; continue;
        }
        if (s.slice(i, i+3) === 'ypp' && (i+3 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+3]))) {
            tokens.push({ type: 'var', val: "y''" }); i += 3; continue;
        }
        if (s.slice(i, i+2) === 'yp' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
            tokens.push({ type: 'var', val: "y'" }); i += 2; continue;
        }
        if (s.slice(i, i+2) === 'y5' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
            tokens.push({ type: 'var', val: "y^{(5)}" }); i += 2; continue;
        }
        if (s.slice(i, i+2) === 'y4' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
            tokens.push({ type: 'var', val: "y^{(4)}" }); i += 2; continue;
        }
        if (s.slice(i, i+2) === 'pi' && (i+2 >= s.length || !/[a-zA-Z0-9_]/.test(s[i+2]))) {
            tokens.push({ type: 'var', val: '\\pi' }); i += 2; continue;
        }
        if (/[a-zA-Z_]/.test(ch)) { tokens.push({ type: 'var', val: ch }); i++; continue; }
        if ('+-*/^()'.indexOf(ch) !== -1) { tokens.push({ type: 'op', val: ch }); i++; continue; }
        i++;
    }
    return tokens;
}

function parseExpr(tokens, pos) { return parseAdd(tokens, pos); }
function parseAdd(tokens, pos) {
    var r = parseMul(tokens, pos); var node = r.node; pos = r.pos;
    while (pos < tokens.length && tokens[pos].type === 'op' && (tokens[pos].val === '+' || tokens[pos].val === '-')) {
        var op = tokens[pos].val; pos++;
        var r2 = parseMul(tokens, pos);
        node = { type: 'binop', op: op, left: node, right: r2.node }; pos = r2.pos;
    }
    return { node: node, pos: pos };
}
function parseMul(tokens, pos) {
    var r = parseUnary(tokens, pos); var node = r.node; pos = r.pos;
    while (pos < tokens.length) {
        var t = tokens[pos];
        if (t.type === 'op' && t.val === '*') {
            pos++; var r2 = parseUnary(tokens, pos);
            node = { type: 'binop', op: '*', left: node, right: r2.node }; pos = r2.pos;
        } else if (t.type === 'op' && t.val === '/') {
            pos++; var r2 = parseUnary(tokens, pos);
            node = { type: 'binop', op: '/', left: node, right: r2.node }; pos = r2.pos;
        } else if (t.type === 'num' || t.type === 'var' || t.type === 'fn' || (t.type === 'op' && t.val === '(')) {
            var prev = node.type;
            var canImplicit = (prev === 'num' || prev === 'var' || prev === 'fn' || prev === 'paren' || prev === 'power');
            if (canImplicit) {
                var r2 = parseUnary(tokens, pos);
                node = { type: 'binop', op: '*', left: node, right: r2.node }; pos = r2.pos;
            } else break;
        } else break;
    }
    return { node: node, pos: pos };
}
function parseUnary(tokens, pos) {
    if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '-') {
        pos++; var r = parseUnary(tokens, pos);
        return { node: { type: 'unary', op: '-', child: r.node }, pos: r.pos };
    }
    if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '+') { pos++; return parseUnary(tokens, pos); }
    return parsePower(tokens, pos);
}
function parsePower(tokens, pos) {
    var r = parseAtom(tokens, pos); var node = r.node; pos = r.pos;
    if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '^') {
        pos++; var r2 = parseUnary(tokens, pos);
        node = { type: 'power', base: node, exp: r2.node }; pos = r2.pos;
    }
    return { node: node, pos: pos };
}
function parseAtom(tokens, pos) {
    if (pos >= tokens.length) return { node: { type: 'var', val: '?' }, pos: pos };
    var t = tokens[pos];
    if (t.type === 'num') return { node: { type: 'num', val: t.val }, pos: pos + 1 };
    if (t.type === 'var') return { node: { type: 'var', val: t.val }, pos: pos + 1 };
    if (t.type === 'fn') {
        var fname = t.val; pos++;
        if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === '(') {
            pos++; var r = parseExpr(tokens, pos); pos = r.pos;
            if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === ')') pos++;
            return { node: { type: 'fn', name: fname, arg: r.node }, pos: pos };
        }
        return { node: { type: 'fn', name: fname, arg: { type: 'var', val: '' } }, pos: pos };
    }
    if (t.type === 'op' && t.val === '(') {
        pos++; var r = parseExpr(tokens, pos); pos = r.pos;
        if (pos < tokens.length && tokens[pos].type === 'op' && tokens[pos].val === ')') pos++;
        return { node: { type: 'paren', child: r.node }, pos: pos };
    }
    return { node: { type: 'var', val: t.val }, pos: pos + 1 };
}
function astToLatex(node) {
    if (!node) return '';
    switch (node.type) {
        case 'num': return node.val;
        case 'var': return node.val;
        case 'unary':
            var child = astToLatex(node.child);
            if (node.child.type === 'binop' && (node.child.op === '+' || node.child.op === '-'))
                return '-\\left(' + child + '\\right)';
            return '-' + child;
        case 'binop':
            var left = astToLatex(node.left);
            var right = astToLatex(node.right);
            if (node.op === '/') {
                var numNode = node.left.type === 'paren' ? node.left.child : node.left;
                var denNode = node.right.type === 'paren' ? node.right.child : node.right;
                return '\\frac{' + astToLatex(numNode) + '}{' + astToLatex(denNode) + '}';
            }
            if (node.op === '*') {
                var needDot = (node.left.type === 'num' && node.right.type === 'num');
                return left + (needDot ? ' \\cdot ' : '') + right;
            }
            if (node.op === '+') return left + ' + ' + right;
            if (node.op === '-') return left + ' - ' + right;
            return left + ' ' + node.op + ' ' + right;
        case 'power':
            var base = astToLatex(node.base);
            var expNode = node.exp.type === 'paren' ? node.exp.child : node.exp;
            var exp = astToLatex(expNode);
            if (node.base.type === 'binop' || node.base.type === 'unary')
                base = '\\left(' + base + '\\right)';
            return base + '^{' + exp + '}';
        case 'paren': return '\\left(' + astToLatex(node.child) + '\\right)';
        case 'fn':
            var arg = astToLatex(node.arg);
            if (node.name === 'exp') return 'e^{' + arg + '}';
            if (node.name === 'sqrt') return '\\sqrt{' + arg + '}';
            if (node.name === 'abs') return '\\left|' + arg + '\\right|';
            var ltx = LATEX_FUNS[node.name] || '\\mathrm{' + node.name + '}';
            return ltx + '\\left(' + arg + '\\right)';
        default: return '';
    }
}

function exprToLatex(expr) {
    if (!expr) return '';
    var tokens = tokenize(expr);
    if (tokens.length === 0) return '';
    var result = parseExpr(tokens, 0);
    return astToLatex(result.node);
}

// ========== TEST CASES ==========
var pass = 0, fail = 0;

function test(input, expected, desc) {
    var got = exprToLatex(input);
    if (got === expected) {
        pass++;
        console.log('  \u2705 ' + desc);
    } else {
        fail++;
        console.log('  \u274C ' + desc);
        console.log('      input:    ' + input);
        console.log('      expected: ' + expected);
        console.log('      got:      ' + got);
    }
}

console.log('========================================');
console.log(' Enhanced LaTeX Preview — Test Suite');
console.log('========================================\n');

// --- Fractions ---
console.log('── Fractions ──');
test('sin(x)/y',       '\\frac{\\sin\\left(x\\right)}{y}',        'sin(x)/y → frac');
test('(x-y)/x',        '\\frac{x - y}{x}',                        '(x-y)/x → frac');
test('1/(1+y**2)',      '\\frac{1}{1 + y^{2}}',                    '1/(1+y²) → frac');
test('x/y',            '\\frac{x}{y}',                             'x/y → frac');
test('(x-y)/(x+y)',    '\\frac{x - y}{x + y}',                    '(x-y)/(x+y) → frac');
test('x**2/y',         '\\frac{x^{2}}{y}',                         'x²/y → frac');

// --- Implicit multiplication ---
console.log('\n── Implicit Multiplication ──');
test('2*x*y',          '2xy',                                       '2*x*y → 2xy');
test('x*y',            'xy',                                        'x*y → xy');
test('-2*x*y',         '-2xy',                                      '-2*x*y → -2xy');
test('3*yp-2*y',       "3y' - 2y",                                  '3*yp-2*y → 3y\' - 2y');

// --- Functions ---
console.log('\n── Functions ──');
test('sin(x)',          '\\sin\\left(x\\right)',                     'sin(x)');
test('cos(2*x)',        '\\cos\\left(2x\\right)',                    'cos(2*x)');
test('exp(x)',          'e^{x}',                                     'exp(x) → e^x');
test('exp(-x)',         'e^{-x}',                                    'exp(-x) → e^{-x}');
test('sqrt(x)',         '\\sqrt{x}',                                 'sqrt(x)');
test('log(x)',          '\\ln\\left(x\\right)',                      'log(x) → ln(x)');
test('asin(x)',         '\\arcsin\\left(x\\right)',                  'asin(x)');

// --- Powers ---
console.log('\n── Powers ──');
test('x**2',            'x^{2}',                                     'x**2 → x²');
test('y**2',            'y^{2}',                                     'y**2 → y²');
test('x^3',            'x^{3}',                                     'x^3 → x³');
test('(x+1)**2',       '\\left(x + 1\\right)^{2}',                 '(x+1)² with paren');

// --- Second-order: yp → y' ---
console.log('\n── Second-Order yp Notation ──');
test('yp',              "y'",                                        'yp → y\'');
test('-2*yp-y',         "-2y' - y",                                  '-2*yp-y → -2y\'-y');
test('-yp+y+cos(2*x)',  "-y' + y + \\cos\\left(2x\\right)",         '-yp+y+cos(2*x)');
test('3*yp-2*y',        "3y' - 2y",                                  '3*yp-2*y');

// --- Higher-order: ypp, yppp, y4, y5 ---
console.log('\n── Higher-Order Derivative Aliases ──');
test('ypp',              "y''",                                       'ypp → y\'\'');
test('yppp',             "y'''",                                      'yppp → y\'\'\'');
test('y4',               "y^{(4)}",                                   'y4 → y^{(4)}');
test('y5',               "y^{(5)}",                                   'y5 → y^{(5)}');
test('-ypp-yp-y',        "-y'' - y' - y",                             '-ypp-yp-y → -y\'\'-y\'-y');
test('6*ypp-11*yp+6*y',  "6y'' - 11y' + 6y",                         '6*ypp-11*yp+6*y → 3rd order char eq');
test('-2*ypp-y',          "-2y'' - y",                                 '-2*ypp-y → 4th order coeff');
test('y4+y',              "y^{(4)} + y",                               'y4+y → 4th order');
test('-4*yppp+6*ypp-4*yp+y', "-4y''' + 6y'' - 4y' + y",              '-4*yppp+6*ypp-4*yp+y → mixed higher order');

// --- Constants ---
console.log('\n── Constants ──');
test('pi',              '\\pi',                                      'pi → π');
test('2*pi*x',          '2\\pix',                                    '2*pi*x');

// --- Combined / ODE expressions ---
console.log('\n── Real ODE Expressions ──');
test('y',               'y',                                         'y\' = y (exponential growth)');
test('-2*x*y',          '-2xy',                                      'y\' = -2xy (Gaussian)');
test('y*(1-y)',         'y\\left(1 - y\\right)',                     'y\' = y(1-y) (logistic)');
test('4-2*y',           '4 - 2y',                                    'y\' = 4-2y (linear)');
test('-y+cos(x)',       '-y + \\cos\\left(x\\right)',                'y\'\' = -y+cos(x)');
test('-4*y+8',          '-4y + 8',                                   'y\'\' = -4y+8');
test('y+exp(x)',        'y + e^{x}',                                 'y\'\' = y+exp(x)');
test('x+y',             'x + y',                                     'dy/dx = x+y (field)');
test('-x/y',            '\\frac{-x}{y}',                             'dy/dx = -x/y (circle)');
test('x**2-y',          'x^{2} - y',                                 'dy/dx = x²-y');
test('exp(-x)*y',       'e^{-x}y',                                   'exp(-x)*y');

// --- Nested fractions ---
console.log('\n── Nested Fractions ──');
test('1/x/y',          '\\frac{\\frac{1}{x}}{y}',                    '1/x/y → chained division (left-assoc)');
test('x/(y/z)',         '\\frac{x}{\\frac{y}{z}}',                   'x/(y/z) → nested frac in denominator');
test('(a/b)/(c/d)',     '\\frac{\\frac{a}{b}}{\\frac{c}{d}}',        '(a/b)/(c/d) → double nested frac');
test('x/y+a/b',        '\\frac{x}{y} + \\frac{a}{b}',               'x/y+a/b → two separate fracs');
test('1/(x*(x+1))',     '\\frac{1}{x\\left(x + 1\\right)}',          '1/(x*(x+1)) → product in denominator');
test('(x**2+1)/(x**2-1)', '\\frac{x^{2} + 1}{x^{2} - 1}',           '(x²+1)/(x²-1) → powers in frac');

// --- Function composition ---
console.log('\n── Function Composition ──');
test('sin(cos(x))',     '\\sin\\left(\\cos\\left(x\\right)\\right)',   'sin(cos(x)) → nested trig');
test('exp(sin(x))',     'e^{\\sin\\left(x\\right)}',                  'exp(sin(x)) → e^{sin(x)}');
test('sqrt(log(x))',    '\\sqrt{\\ln\\left(x\\right)}',               'sqrt(log(x)) → sqrt of ln');
test('abs(sin(x))',     '\\left|\\sin\\left(x\\right)\\right|',       'abs(sin(x)) → |sin(x)|');
test('sin(x+y)',        '\\sin\\left(x + y\\right)',                   'sin(x+y) → function of sum');
test('cos(2*pi*x)',     '\\cos\\left(2\\pix\\right)',                  'cos(2*pi*x) → cos with pi');
test('exp(exp(x))',     'e^{e^{x}}',                                  'exp(exp(x)) → double exp');
test('log(sqrt(x))',    '\\ln\\left(\\sqrt{x}\\right)',               'log(sqrt(x)) → ln of sqrt');

// --- Functions with powers ---
console.log('\n── Functions with Powers ──');
test('sin(x)^2',       '\\sin\\left(x\\right)^{2}',                  'sin(x)^2 → trig squared');
test('cos(x)^2+sin(x)^2', '\\cos\\left(x\\right)^{2} + \\sin\\left(x\\right)^{2}', 'cos²+sin² identity');
test('exp(x)^2',       'e^{x}^{2}',                                   'exp(x)^2');
test('sqrt(x)^3',      '\\sqrt{x}^{3}',                              'sqrt(x)^3');

// --- Complex exponents ---
console.log('\n── Complex Exponents ──');
test('x^(2+3)',         'x^{2 + 3}',                                  'x^(2+3) → sum in exponent');
test('x^(-2)',          'x^{-2}',                                     'x^(-2) → negative exponent');
test('x^(1/2)',         'x^{\\frac{1}{2}}',                           'x^(1/2) → fractional exponent');
test('(x+1)^(y-1)',    '\\left(x + 1\\right)^{y - 1}',               '(x+1)^(y-1) → both paren');
test('x^y^2',          'x^{y^{2}}',                                   'x^y^2 → right-assoc? (actually x^y then no chain)');
test('(x^2)^3',        '\\left(x^{2}\\right)^{3}',                   '(x²)³ → power of power with parens');
test('2^x',            '2^{x}',                                       '2^x → number base');
test('e^(-x^2)',        'e^{-x^{2}}',                                 'exp(-x²) Gaussian-like');

// --- Implicit multiplication edge cases ---
console.log('\n── Implicit Multiplication Edge Cases ──');
test('2(x+1)',          '2\\left(x + 1\\right)',                       '2(x+1) → num * paren');
test('(x+1)(x-1)',      '\\left(x + 1\\right)\\left(x - 1\\right)',   '(x+1)(x-1) → paren * paren');
test('x(x+1)',          'x\\left(x + 1\\right)',                      'x(x+1) → var * paren');
test('sin(x)cos(x)',    '\\sin\\left(x\\right)\\cos\\left(x\\right)', 'sin(x)cos(x) → fn * fn');
test('2sin(x)',         '2\\sin\\left(x\\right)',                      '2sin(x) → num * fn');
test('xsin(x)',         'x\\sin\\left(x\\right)',                      'xsin(x) → var * fn');
test('3x',             '3x',                                           '3x → num * var');
test('xy',             'xy',                                           'xy → var * var');
test('3x^2',           '3x^{2}',                                      '3x² → num * power');

// --- Unary operator stress ---
console.log('\n── Unary Operator Stress ──');
test('-x',              '-x',                                          '-x → simple negation');
test('--x',             '--x',                                         '--x → double negation');
test('-(x+y)',          '-\\left(x + y\\right)',                       '-(x+y) → negated group');
test('-sin(x)',         '-\\sin\\left(x\\right)',                      '-sin(x) → negated function');
test('-x^2',            '-x^{2}',                                     '-x² → negation vs power precedence');
test('(-x)^2',          '\\left(-x\\right)^{2}',                      '(-x)² → negation inside power');
test('x-(-y)',          'x - \\left(-y\\right)',                       'x-(-y) → subtract negative');
test('-x/y',            '\\frac{-x}{y}',                              '-x/y → negative numerator');
test('x/(-y)',          '\\frac{x}{-y}',                              'x/(-y) → negative denominator');

// --- Decimal numbers ---
console.log('\n── Decimal Numbers ──');
test('3.14',            '3.14',                                        '3.14 → decimal literal');
test('3.14*x',          '3.14x',                                      '3.14*x → decimal times var');
test('0.5*y',           '0.5y',                                       '0.5*y → decimal coeff');
test('.5*x',            '.5x',                                        '.5*x → leading dot decimal');

// --- Large compound expressions ---
console.log('\n── Compound Expressions ──');
test('x^2+2*x*y+y^2',  'x^{2} + 2xy + y^{2}',                       '(x+y)² expanded');
test('x^3-3*x^2+3*x-1', 'x^{3} - 3x^{2} + 3x - 1',                 '(x-1)³ expanded');
test('sin(x)*cos(x)/2', '\\frac{\\sin\\left(x\\right)\\cos\\left(x\\right)}{2}', 'sin(x)cos(x)/2');
test('(x^2+y^2)^(1/2)', '\\left(x^{2} + y^{2}\\right)^{\\frac{1}{2}}', 'distance formula');
test('exp(-x^2/2)',     'e^{\\frac{-x^{2}}{2}}',                      'Gaussian exp(-x²/2)');
test('x*exp(-x)',       'xe^{-x}',                                    'x*exp(-x) → xe^{-x}');
test('y*sin(x)+x*cos(y)', 'y\\sin\\left(x\\right) + x\\cos\\left(y\\right)', 'mixed product sum');
test('1/(1+exp(-x))',   '\\frac{1}{1 + e^{-x}}',                     'sigmoid function');

// --- Real-world ODE RHS (complex) ---
console.log('\n── Complex ODE Expressions ──');
test('y^2-x^2',        'y^{2} - x^{2}',                              'y²-x² Riccati-like');
test('x*y/(x^2+y^2)',  '\\frac{xy}{x^{2} + y^{2}}',                  'xy/(x²+y²) homogeneous');
test('sin(x)*exp(-y)',  '\\sin\\left(x\\right)e^{-y}',                'sin(x)exp(-y) separable');
test('-2*yp-5*y+sin(x)', "-2y' - 5y + \\sin\\left(x\\right)",        'damped forced oscillator');
test('yp^2-y',          "y'^{2} - y",                                 'yp² nonlinear');
test('x*yp-y+x^2',     "xy' - y + x^{2}",                            'x*yp-y+x² Bernoulli-like');
test('(1-y^2)*yp-y',   "\\left(1 - y^{2}\\right)y' - y",             "Van der Pol: (1-y²)y'-y");
test('sqrt(x^2+y^2)',  '\\sqrt{x^{2} + y^{2}}',                      'sqrt(x²+y²) radial');
test('y/x+x/y',        '\\frac{y}{x} + \\frac{x}{y}',               'y/x + x/y homogeneous');
test('exp(-x)*sin(x)-y', 'e^{-x}\\sin\\left(x\\right) - y',          'exp(-x)sin(x)-y');
test('abs(x)*y',        '\\left|x\\right|y',                          '|x|*y');

// --- Edge cases ---
console.log('\n── Edge Cases ──');
test('',                '',                                           'empty string');
test('x',              'x',                                          'single variable');
test('42',             '42',                                          'single number');
test('-y',              '-y',                                         'negation');
test('-(x+y)',          '-\\left(x + y\\right)',                      '-(x+y)');
test('((x))',           '\\left(\\left(x\\right)\\right)',            '((x)) double parens');
test('(((1+2)))',       '\\left(\\left(\\left(1 + 2\\right)\\right)\\right)', 'triple nested parens');
test('+x',             'x',                                           '+x → unary plus stripped');
test('x+-y',            'x + -y',                                     'x+-y → plus then negative');

console.log('\n========================================');
console.log(' RESULTS: ' + pass + ' passed, ' + fail + ' failed (of ' + (pass+fail) + ')');
console.log('========================================');
if (fail === 0) console.log(' \uD83C\uDF89 ALL TESTS PASSED!');
else console.log(' \u26A0\uFE0F  ' + fail + ' test(s) failed');
process.exit(fail > 0 ? 1 : 0);
