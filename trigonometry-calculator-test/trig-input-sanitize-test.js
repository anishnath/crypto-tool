#!/usr/bin/env node
/**
 * Test suite for the trig calculator family input sanitizer.
 *
 * Covers everything a student or teacher might type into:
 *   · trigonometric-function-calculator.jsp
 *   · trigonometric-equation-solver.jsp
 *   · trigonometric-identity-calculator.jsp
 *
 * The sanitizer lives in /math/partials/math-input-multi.jsp and runs
 * in two layers (1) latexToAscii — strips LaTeX commands MathLive leaks
 * into getValue('ascii-math') so the SymPy server can parse them, and
 * (2) fullSanitize — also repairs the smart-mode "sin → s\in" mis-parse
 * (typing s-i-n in MathLive Visual mode produces s\in if "sin" isn't
 * registered as an inline shortcut).
 *
 * The function is extracted from the live JSP each run, so this test
 * tracks the production code automatically.
 */

const { latexToAscii, fullSanitize } = require('./load-sanitizer');

// ─── Test runner ─────────────────────────────────────────────────────
//
// `expected` is one of:
//   string                       — exact match
//   { contains: [...] }          — every substring must appear
//   { notContains: [...] }       — none of these substrings may appear
//   { match: /regex/ }           — must match
//
function runTests(label, cases, fn) {
    fn = fn || latexToAscii;
    console.log('\n══════ ' + label + ' ══════');
    let pass = 0, fail = 0;
    cases.forEach((c) => {
        const [input, expected] = c;
        const actual = fn(input);
        let ok;
        if (typeof expected === 'string') {
            ok = actual === expected;
        } else if (expected && expected.contains) {
            ok = expected.contains.every((sub) => actual.indexOf(sub) >= 0);
        } else if (expected && expected.notContains) {
            ok = expected.notContains.every((sub) => actual.indexOf(sub) < 0);
        } else if (expected && expected.match) {
            ok = expected.match.test(actual);
        }
        if (ok) {
            pass++;
        } else {
            fail++;
            console.log('  FAIL ' + JSON.stringify(input));
            console.log('       exp: ' + JSON.stringify(expected));
            console.log('       got: ' + JSON.stringify(actual));
        }
    });
    console.log('  ' + pass + ' passed, ' + fail + ' failed (' + cases.length + ' total)');
    return { pass, fail };
}

const totals = { pass: 0, fail: 0 };
function add(r) { totals.pass += r.pass; totals.fail += r.fail; }

// ════════════════════════════════════════════════════════════════════
// 1. ORIGINAL USER REPORTS — regression coverage for the LaTeX
//    leak that produced 500s on the equation solver.
// ════════════════════════════════════════════════════════════════════
add(runTests('1. Original user reports', [
    ['\\sin\\left(2x\\right)=\\cos\\left(x\\right)', 'sin(2x)=cos(x)'],
    ['2\\cos\\left(x\\right)^2-1=0', '2cos(x)^2-1=0'],
    ['\\sin\\left(x\\right)>\\frac12', 'sin(x)>(1/2)'],
    ['\\frac{\\sin\\left(x\\right)^4-\\cos\\left(x\\right)^4}{\\sin\\left(x\\right)^2-\\cos\\left(x\\right)^2}',
     '((sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2))']
]));

// ════════════════════════════════════════════════════════════════════
// 2. SPECIAL ANGLES — the bread and butter of the function calc.
// ════════════════════════════════════════════════════════════════════
add(runTests('2. Special angles (deg)', [
    ['\\sin\\left(0\\right)',   'sin(0)'],
    ['\\sin\\left(30\\right)',  'sin(30)'],
    ['\\sin\\left(45\\right)',  'sin(45)'],
    ['\\sin\\left(60\\right)',  'sin(60)'],
    ['\\sin\\left(90\\right)',  'sin(90)'],
    ['\\cos\\left(120\\right)', 'cos(120)'],
    ['\\tan\\left(135\\right)', 'tan(135)'],
    ['\\sec\\left(180\\right)', 'sec(180)'],
    ['\\csc\\left(270\\right)', 'csc(270)'],
    ['\\cot\\left(45\\right)',  'cot(45)']
]));

add(runTests('3. Special angles (rad with π)', [
    ['\\sin\\left(\\frac{\\pi}{6}\\right)',  { contains: ['sin(', 'pi', '/', '6'] }],
    ['\\cos\\left(\\frac{\\pi}{4}\\right)',  { contains: ['cos(', 'pi', '/', '4'] }],
    ['\\tan\\left(\\frac{\\pi}{3}\\right)',  { contains: ['tan(', 'pi', '/', '3'] }],
    ['\\sin\\left(\\frac{2\\pi}{3}\\right)', { contains: ['sin(', '2', 'pi', '/', '3'] }],
    ['\\cos\\left(\\frac{5\\pi}{6}\\right)', { contains: ['cos(', '5', 'pi', '/', '6'] }],
    ['\\sin\\left(\\pi\\right)',  'sin(pi)'],
    ['\\cos\\left(2\\pi\\right)', 'cos(2pi)'],
    ['\\sin\\left(-\\frac{\\pi}{2}\\right)', { contains: ['sin(-', 'pi', '/', '2'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 4-6. EQUATIONS, INEQUALITIES, NEGATIVE ANGLES
// ════════════════════════════════════════════════════════════════════
add(runTests('4. Negative angles', [
    ['\\sin\\left(-x\\right)', 'sin(-x)'],
    ['\\cos\\left(-30\\right)', 'cos(-30)'],
    ['-\\sin\\left(x\\right)', '-sin(x)'],
    ['\\tan\\left(-\\frac{\\pi}{4}\\right)', { contains: ['tan(-', 'pi', '/', '4'] }],
    ['-\\frac{1}{2}', { contains: ['1', '/', '2'], notContains: ['frac', '\\\\'] }]
]));

add(runTests('5. Equations', [
    ['\\sin\\left(x\\right)=\\frac{1}{2}',          { contains: ['sin(x)=', '1', '/', '2'] }],
    ['\\cos\\left(x\\right)=\\frac{\\sqrt{3}}{2}',  { contains: ['cos(x)=', 'sqrt(3)', '/', '2'] }],
    ['\\tan\\left(x\\right)=1',                     'tan(x)=1'],
    ['\\tan\\left(x\\right)=\\sqrt{3}',             { contains: ['tan(x)=', 'sqrt(3)'] }],
    ['2\\sin\\left(x\\right)=\\sqrt{2}',            { contains: ['2sin(x)=', 'sqrt(2)'] }],
    ['\\sin\\left(x\\right)+\\cos\\left(x\\right)=1', 'sin(x)+cos(x)=1'],
    ['\\sin^2\\left(x\\right)+\\cos^2\\left(x\\right)=1', 'sin^2(x)+cos^2(x)=1'],
    ['\\sin\\left(2x\\right)+\\cos\\left(2x\\right)=0', 'sin(2x)+cos(2x)=0']
]));

add(runTests('6. Inequalities', [
    ['\\sin\\left(x\\right)>0', 'sin(x)>0'],
    ['\\cos\\left(x\\right)<\\frac{1}{2}',          { contains: ['cos(x)<', '1', '/', '2'] }],
    ['\\tan\\left(x\\right)\\ge 1',                 { contains: ['tan(x)>=', '1'] }],
    ['\\sin\\left(x\\right)\\le -\\frac{1}{2}',     { contains: ['sin(x)<=', '-', '1', '/', '2'] }],
    ['\\sin\\left(x\\right)\\ne 0',                 { contains: ['sin(x)!=', '0'] }],
    ['2\\sin\\left(x\\right)+1>0',                  '2sin(x)+1>0']
]));

// ════════════════════════════════════════════════════════════════════
// 7. POWERS — both braced ^{n} and bare ^n (server tolerates both).
// ════════════════════════════════════════════════════════════════════
add(runTests('7. Powers', [
    ['x^{2}',                                'x^(2)'],
    ['x^2',                                  'x^2'],
    ['\\sin^{2}\\left(x\\right)',            'sin^(2)(x)'],
    ['\\sin^2\\left(x\\right)',              'sin^2(x)'],
    ['\\cos^{4}\\left(x\\right)-\\sin^{4}\\left(x\\right)', 'cos^(4)(x)-sin^(4)(x)'],
    ['x^{n+1}',                              'x^(n+1)'],
    ['e^{x}',                                'e^(x)'],
    ['e^{i\\pi}',                            { contains: ['e^(i', 'pi)'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 8. ROOTS
// ════════════════════════════════════════════════════════════════════
add(runTests('8. Roots', [
    ['\\sqrt{2}',                                            'sqrt(2)'],
    ['\\sqrt{3}/2',                                          'sqrt(3)/2'],
    ['\\sqrt{x^2+1}',                                        { contains: ['sqrt(x^2+1)'] }],
    ['\\sqrt[3]{8}',                                         { contains: ['8', '1/(3)', '^'] }],
    ['\\sqrt{\\frac{1+\\cos\\left(x\\right)}{2}}',           { contains: ['sqrt(', 'cos(x)', '/'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 9. PRODUCT NOTATION — \cdot, \times, juxtaposition.
//    Regression: \cdot must run BEFORE trig-stripping, otherwise
//    "\sin(x)\cdot\cos(x)" → "sin(x)\cdotcos(x)" loses the word
//    boundary the \cdot regex needs.
// ════════════════════════════════════════════════════════════════════
add(runTests('9. Products', [
    ['2\\cdot x',                                            { contains: ['2*', 'x'] }],
    ['a\\cdot b',                                            { contains: ['a*', 'b'] }],
    ['2\\times 3',                                           { contains: ['2*', '3'] }],
    ['\\sin\\left(x\\right)\\cdot\\cos\\left(x\\right)',     { contains: ['sin(x)*cos(x)'] }],
    ['x\\cdot y\\cdot z',                                    { contains: ['x*', 'y*', 'z'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 10-11. INVERSE TRIG + HYPERBOLIC
// ════════════════════════════════════════════════════════════════════
add(runTests('10. Inverse trig', [
    ['\\arcsin\\left(\\frac{1}{2}\\right)', { contains: ['arcsin(', '1', '/', '2'] }],
    ['\\arccos\\left(0\\right)',            'arccos(0)'],
    ['\\arctan\\left(1\\right)',            'arctan(1)'],
    ['\\arctan\\left(\\sqrt{3}\\right)',    { contains: ['arctan(', 'sqrt(3)'] }]
]));

add(runTests('11. Hyperbolic', [
    ['\\sinh\\left(x\\right)',                              'sinh(x)'],
    ['\\cosh\\left(0\\right)',                              'cosh(0)'],
    ['\\tanh\\left(\\frac{x}{2}\\right)',                   { contains: ['tanh(', 'x', '/', '2'] }],
    ['\\cosh^2\\left(x\\right)-\\sinh^2\\left(x\\right)',   'cosh^2(x)-sinh^2(x)']
]));

// ════════════════════════════════════════════════════════════════════
// 12-13. COMPOUND ANGLES & IDENTITIES
// ════════════════════════════════════════════════════════════════════
add(runTests('12. Compound angles', [
    ['\\sin\\left(x+\\frac{\\pi}{6}\\right)',     { contains: ['sin(x+', 'pi', '/', '6'] }],
    ['\\cos\\left(2x+\\frac{\\pi}{4}\\right)',    { contains: ['cos(2x+', 'pi', '/', '4'] }],
    ['\\sin\\left(\\theta+\\phi\\right)',          'sin(theta+phi)'],
    ['\\cos\\left(A-B\\right)',                    'cos(A-B)'],
    ['\\sin\\left(2\\theta\\right)',               'sin(2theta)']
]));

add(runTests('13. Identities (Pythagorean / half-angle / double-angle)', [
    ['\\sin^2\\left(x\\right)+\\cos^2\\left(x\\right)',     'sin^2(x)+cos^2(x)'],
    ['1+\\tan^2\\left(x\\right)',                            '1+tan^2(x)'],
    ['\\sec^2\\left(x\\right)-1',                            'sec^2(x)-1'],
    ['2\\sin\\left(x\\right)\\cos\\left(x\\right)',          { contains: ['2sin(x)', 'cos(x)'] }],
    ['\\frac{1-\\cos\\left(2x\\right)}{2}',                  { contains: ['1-cos(2x)', '/', '2'] }],
    ['\\frac{1+\\cos\\left(2x\\right)}{2}',                  { contains: ['1+cos(2x)', '/', '2'] }],
    ['\\tan\\left(\\frac{x}{2}\\right)',                     { contains: ['tan(', 'x', '/', '2'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 14. GREEK LETTERS & SYMBOLS
// ════════════════════════════════════════════════════════════════════
add(runTests('14. Greek letters & symbols', [
    ['\\theta',           'theta'],
    ['\\alpha+\\beta',    'alpha+beta'],
    ['\\sin\\theta',      'sintheta'],
    ['\\sin\\left(\\theta\\right)', 'sin(theta)'],
    ['\\pi',              'pi'],
    ['2\\pi',             '2pi'],
    ['\\infty',           'oo'],
    ['x\\to\\infty',      'x->oo'],
    ['x\\to 0',           { contains: ['x->', '0'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 15. DEGREE MARKERS — \circ and Unicode °
// ════════════════════════════════════════════════════════════════════
add(runTests('15. Degree markers', [
    ['45^{\\circ}',                              '45^()'],
    ['\\sin\\left(45^{\\circ}\\right)',          'sin(45^())'],
    ['90\u00B0',                                  '90'],
    ['\\sin\\left(90\u00B0\\right)',             'sin(90)']
]));

// ════════════════════════════════════════════════════════════════════
// 16. NESTED FRACTIONS — extra outer parens are mathematically
//     equivalent; SymPy parses them the same.
// ════════════════════════════════════════════════════════════════════
add(runTests('16. Nested fractions', [
    ['\\frac{\\frac{1}{2}}{3}',                              { contains: ['1', '/', '2', '/', '3'], notContains: ['frac', '\\\\'] }],
    ['\\frac{1}{\\frac{1}{2}+1}',                            { contains: ['1', '/', '2', '+1'], notContains: ['frac', '\\\\'] }],
    ['\\frac{\\sin\\left(x\\right)}{\\cos\\left(x\\right)}', { contains: ['sin(x)', '/', 'cos(x)'] }],
    ['\\dfrac{a}{b}',                                        '((a)/(b))'],
    ['\\tfrac{1}{2}',                                        '((1)/(2))']
]));

// ════════════════════════════════════════════════════════════════════
// 17. EDGE CASES — empty input, whitespace, already-clean text.
// ════════════════════════════════════════════════════════════════════
add(runTests('17. Edge cases', [
    ['',              ''],
    ['   ',           ''],
    ['sin(x)=1/2',    'sin(x)=1/2'],
    ['cos(x) > 0',    'cos(x) > 0'],
    ['2*x+1',         '2*x+1'],
    ['x',             'x']
]));

add(runTests('17b. Idempotency on clean input', [
    ['sin(2x)=cos(x)', 'sin(2x)=cos(x)'],
    ['(sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)', '(sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)'],
    ['arctan(1)',      'arctan(1)']
]));

add(runTests('17c. Double-pass safety (f(f(x)) === f(x))', [
    ['\\sin\\left(2x\\right)=\\cos\\left(x\\right)', 'sin(2x)=cos(x)'],
    ['\\frac{1}{2}', '((1)/(2))']
], (s) => latexToAscii(latexToAscii(s))));

// ════════════════════════════════════════════════════════════════════
// 18. SMART-MODE MANGLE REPAIR — typing s-i-n in MathLive Visual
//     mode without the "sin" inline shortcut produces s\in.
// ════════════════════════════════════════════════════════════════════
add(runTests('18. Smart-mode "sin → s∈" repair', [
    ['s\\in\\left(2x\\right)',           'sin(2x)'],
    ['s\\in(x)',                          'sin(x)'],
    ['s \u2208 (x)',                      'sin(x)'],
    ['s in (x)',                          'sin(x)'],
    ['(1-cos(2x))/s\\in(2x)',             '(1-cos(2x))/sin(2x)'],
    // Must NOT touch legitimate set-membership usage:
    ['x\\in S',                           { notContains: ['sin'] }],
    ['1\u2208A',                          { notContains: ['sin'] }],
    ['x\\in\\mathbb{R}',                  { notContains: ['sin'] }]
], fullSanitize));

// ════════════════════════════════════════════════════════════════════
// 19. NO OVER-SUBSTITUTION — words containing "sin" or "in" must
//     be left alone.
// ════════════════════════════════════════════════════════════════════
add(runTests('19. Don\'t over-substitute', [
    ['x',             'x'],
    ['sin',           'sin'],
    ['inside',        'inside'],
    ['line',          'line'],
    ['singularity',   'singularity']
]));

add(runTests('19b. fullSanitize doesn\'t maul words', [
    ['inside',          'inside'],
    ['line',            'line'],
    ['point in space',  'point in space']
], fullSanitize));

// ════════════════════════════════════════════════════════════════════
// 20. AI / IMAGE-SCAN OUTPUT FORMS — what the LLM may emit when
//     scanning a textbook page.
// ════════════════════════════════════════════════════════════════════
add(runTests('20. AI/scan output forms', [
    ['$\\sin(45)$',                        'sin(45)'],
    ['$$\\frac{1}{2}$$',                   '((1)/(2))'],
    ['\\sin\\!\\left(x\\right)',           'sin(x)'],
    ['\\sin \\left( x \\right)',           { contains: ['sin', '(', 'x', ')'] }],
    ['\\operatorname{arccot}(x)',          'arccot(x)'],
    ['\\text{sin}(x)',                     'sin(x)']
]));

// ════════════════════════════════════════════════════════════════════
// 21. PHYSICS / ENGINEERING — multi-variable expressions.
// ════════════════════════════════════════════════════════════════════
add(runTests('21. Multi-variable physics', [
    ['\\sin\\left(\\omega t+\\phi\\right)', { contains: ['sin(', '+phi)'] }],
    ['F=ma',                                'F=ma'],
    ['\\sin\\left(kx-\\omega t\\right)',    { contains: ['sin(kx-'] }],
    ['\\frac{dy}{dx}',                      { contains: ['dy', '/', 'dx'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 22. CHIP-VALUE PASSTHROUGH — the exact strings the headline chips
//     write into the input must round-trip unchanged.
// ════════════════════════════════════════════════════════════════════
add(runTests('22. Chip-value passthrough', [
    ['sin(x)=1/2',                                           'sin(x)=1/2'],
    ['sin(2*x) = cos(x)',                                    'sin(2*x) = cos(x)'],
    ['2*cos(x)^2 - 1 = 0',                                   '2*cos(x)^2 - 1 = 0'],
    ['sin(x) > 1/2',                                         'sin(x) > 1/2'],
    ['sin(x)^4 - cos(x)^4',                                  'sin(x)^4 - cos(x)^4'],
    ['(sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)',              '(sin(x)^4-cos(x)^4)/(sin(x)^2-cos(x)^2)'],
    ['tan(x)^2 - sin(x)^2',                                  'tan(x)^2 - sin(x)^2'],
    ['(1 - cos(2*x)) / sin(2*x)',                            '(1 - cos(2*x)) / sin(2*x)']
]));

// ════════════════════════════════════════════════════════════════════
// 23. HIGHER-DEGREE TRIG POLYNOMIALS — triple/quadruple angle, etc.
// ════════════════════════════════════════════════════════════════════
add(runTests('23. Higher-degree trig polynomials', [
    // Triple angle: sin(3x) = 3sin(x) - 4sin³(x)
    ['4\\sin^3\\left(x\\right)-3\\sin\\left(x\\right)=\\sin\\left(3x\\right)',
     '4sin^3(x)-3sin(x)=sin(3x)'],
    // Triple angle: cos(3x) = 4cos³(x) - 3cos(x)
    ['4\\cos^3\\left(x\\right)-3\\cos\\left(x\\right)=\\cos\\left(3x\\right)',
     '4cos^3(x)-3cos(x)=cos(3x)'],
    // sin⁴ + cos⁴ identity
    ['\\sin^4\\left(x\\right)+\\cos^4\\left(x\\right)=1-2\\sin^2\\left(x\\right)\\cos^2\\left(x\\right)',
     { contains: ['sin^4(x)+cos^4(x)=1-2sin^2(x)', 'cos^2(x)'] }],
    // Quartic
    ['\\tan^4\\left(x\\right)-\\tan^2\\left(x\\right)=0', 'tan^4(x)-tan^2(x)=0'],
    // sin⁶ + cos⁶
    ['\\sin^6\\left(x\\right)+\\cos^6\\left(x\\right)',  'sin^6(x)+cos^6(x)'],
    // Quintic from competition
    ['16\\sin^5\\left(x\\right)-20\\sin^3\\left(x\\right)+5\\sin\\left(x\\right)=\\sin\\left(5x\\right)',
     '16sin^5(x)-20sin^3(x)+5sin(x)=sin(5x)']
]));

// ════════════════════════════════════════════════════════════════════
// 24. COMPOSED INVERSE TRIG — students hit these in calculus prep.
// ════════════════════════════════════════════════════════════════════
add(runTests('24. Composed inverse trig', [
    ['\\sin\\left(\\arccos\\left(x\\right)\\right)=\\sqrt{1-x^2}',
     { contains: ['sin(arccos(x))=', 'sqrt(1-x^2)'] }],
    ['\\cos\\left(\\arctan\\left(x\\right)\\right)=\\frac{1}{\\sqrt{1+x^2}}',
     { contains: ['cos(arctan(x))=', 'sqrt(1+x^2)'] }],
    ['\\tan\\left(\\arcsin\\left(x\\right)\\right)=\\frac{x}{\\sqrt{1-x^2}}',
     { contains: ['tan(arcsin(x))=', 'x', 'sqrt(1-x^2)'] }],
    ['\\arctan\\left(x\\right)+\\arctan\\left(\\frac{1}{x}\\right)=\\frac{\\pi}{2}',
     { contains: ['arctan(x)+arctan(', '1', 'x', ')=', 'pi', '/', '2'] }],
    ['\\arcsin\\left(x\\right)+\\arccos\\left(x\\right)=\\frac{\\pi}{2}',
     { contains: ['arcsin(x)+arccos(x)=', 'pi', '/', '2'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 25. SUM-TO-PRODUCT & PRODUCT-TO-SUM — identity calc territory.
// ════════════════════════════════════════════════════════════════════
add(runTests('25. Sum-to-product & product-to-sum', [
    ['\\sin\\left(A\\right)+\\sin\\left(B\\right)=2\\sin\\left(\\frac{A+B}{2}\\right)\\cos\\left(\\frac{A-B}{2}\\right)',
     { contains: ['sin(A)+sin(B)=2sin(', 'A+B', '/', '2', 'cos(', 'A-B'] }],
    ['\\cos\\left(A\\right)+\\cos\\left(B\\right)=2\\cos\\left(\\frac{A+B}{2}\\right)\\cos\\left(\\frac{A-B}{2}\\right)',
     { contains: ['cos(A)+cos(B)=2cos('] }],
    ['\\sin\\left(A\\right)\\cos\\left(B\\right)=\\frac{1}{2}\\left[\\sin\\left(A+B\\right)+\\sin\\left(A-B\\right)\\right]',
     { contains: ['sin(A)cos(B)=', '1', '/', '2', 'sin(A+B)+sin(A-B)'] }],
    ['\\cos\\left(A\\right)\\cos\\left(B\\right)=\\frac{1}{2}\\left[\\cos\\left(A-B\\right)+\\cos\\left(A+B\\right)\\right]',
     { contains: ['cos(A)cos(B)='] }],
    ['\\sin\\left(75^{\\circ}\\right)-\\sin\\left(15^{\\circ}\\right)',
     { contains: ['sin(75', 'sin(15'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 26. HALF-ANGLE & DOUBLE-ANGLE COMPLEX FORMS
// ════════════════════════════════════════════════════════════════════
add(runTests('26. Half-angle & double-angle', [
    ['\\sin\\left(\\frac{x}{2}\\right)=\\pm\\sqrt{\\frac{1-\\cos\\left(x\\right)}{2}}',
     { contains: ['sin(', 'x', '/', '2', '+-', 'sqrt(', '1-cos(x)'] }],
    ['\\cos\\left(\\frac{x}{2}\\right)=\\pm\\sqrt{\\frac{1+\\cos\\left(x\\right)}{2}}',
     { contains: ['cos(', '+-', 'sqrt(', '1+cos(x)'] }],
    ['\\tan\\left(\\frac{x}{2}\\right)=\\frac{1-\\cos\\left(x\\right)}{\\sin\\left(x\\right)}',
     { contains: ['tan(', 'x', '/', '2', '1-cos(x)', '/', 'sin(x)'] }],
    ['\\cos\\left(2x\\right)=1-2\\sin^2\\left(x\\right)',  'cos(2x)=1-2sin^2(x)'],
    ['\\cos\\left(2x\\right)=2\\cos^2\\left(x\\right)-1',  'cos(2x)=2cos^2(x)-1'],
    ['\\sin\\left(2x\\right)=\\frac{2\\tan\\left(x\\right)}{1+\\tan^2\\left(x\\right)}',
     { contains: ['sin(2x)=', '2tan(x)', '/', '1+tan^2(x)'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 27. RATIONAL TRIG EXPRESSIONS — sum of fractions, complex denominators.
// ════════════════════════════════════════════════════════════════════
add(runTests('27. Rational trig expressions', [
    ['\\frac{\\sin\\left(x\\right)}{1+\\cos\\left(x\\right)}+\\frac{1+\\cos\\left(x\\right)}{\\sin\\left(x\\right)}=\\frac{2}{\\sin\\left(x\\right)}',
     { contains: ['sin(x)', '/', '1+cos(x)', '2', 'sin(x)'] }],
    ['\\frac{1-\\tan^2\\left(\\frac{x}{2}\\right)}{1+\\tan^2\\left(\\frac{x}{2}\\right)}=\\cos\\left(x\\right)',
     { contains: ['1-tan^2(', '1+tan^2(', '=cos(x)'] }],
    ['\\frac{\\sin\\left(x\\right)+\\sin\\left(3x\\right)}{\\cos\\left(x\\right)+\\cos\\left(3x\\right)}=\\tan\\left(2x\\right)',
     { contains: ['sin(x)+sin(3x)', '/', 'cos(x)+cos(3x)', '=tan(2x)'] }],
    ['\\frac{\\tan\\left(x\\right)-\\tan\\left(y\\right)}{1+\\tan\\left(x\\right)\\tan\\left(y\\right)}=\\tan\\left(x-y\\right)',
     { contains: ['tan(x)-tan(y)', '1+tan(x)tan(y)', '=tan(x-y)'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 28. MIT BEE / IIT JEE / OLYMPIAD-STYLE — competition classics.
// ════════════════════════════════════════════════════════════════════
add(runTests('28. Competition-level identities', [
    // Classic: sin(20°)sin(40°)sin(80°) = √3/8
    ['\\sin\\left(20^{\\circ}\\right)\\sin\\left(40^{\\circ}\\right)\\sin\\left(80^{\\circ}\\right)=\\frac{\\sqrt{3}}{8}',
     { contains: ['sin(20', 'sin(40', 'sin(80', 'sqrt(3)', '/', '8'] }],
    // Classic: cos(20°)cos(40°)cos(80°) = 1/8
    ['\\cos\\left(20^{\\circ}\\right)\\cos\\left(40^{\\circ}\\right)\\cos\\left(80^{\\circ}\\right)=\\frac{1}{8}',
     { contains: ['cos(20', 'cos(40', 'cos(80', '1', '/', '8'] }],
    // tan addition with √3: tan(20)+tan(40)+√3·tan(20)tan(40) = √3
    ['\\tan\\left(20^{\\circ}\\right)+\\tan\\left(40^{\\circ}\\right)+\\sqrt{3}\\tan\\left(20^{\\circ}\\right)\\tan\\left(40^{\\circ}\\right)=\\sqrt{3}',
     { contains: ['tan(20', 'tan(40', 'sqrt(3)'] }],
    // sin² + sin²(60+x) + sin²(60-x) = 3/2
    ['\\sin^2\\left(x\\right)+\\sin^2\\left(60^{\\circ}+x\\right)+\\sin^2\\left(60^{\\circ}-x\\right)=\\frac{3}{2}',
     { contains: ['sin^2(x)+sin^2(60', '+x', 'sin^2(60', '-x', '3', '/', '2'] }],
    // cos(π/7)cos(2π/7)cos(3π/7) = 1/8
    ['\\cos\\left(\\frac{\\pi}{7}\\right)\\cos\\left(\\frac{2\\pi}{7}\\right)\\cos\\left(\\frac{3\\pi}{7}\\right)=\\frac{1}{8}',
     { contains: ['cos(', 'pi', '/', '7'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 29. PHYSICS — wave / oscillation expressions.
// ════════════════════════════════════════════════════════════════════
add(runTests('29. Physics (wave / oscillation)', [
    // Travelling wave: y = A sin(kx - ωt + φ)
    ['y=A\\sin\\left(kx-\\omega t+\\phi\\right)',
     { contains: ['y=A', 'sin(kx-omega t+phi)'] }],
    // Damped oscillation
    ['x\\left(t\\right)=Ae^{-\\gamma t}\\cos\\left(\\omega t+\\phi\\right)',
     { contains: ['x(t)=A', 'e^(-gamma t)', 'cos(omega t+phi)'] }],
    // Standing wave
    ['y=2A\\sin\\left(kx\\right)\\cos\\left(\\omega t\\right)',
     { contains: ['y=2A', 'sin(kx)', 'cos(omega t)'] }],
    // Doppler / interference formula — \Delta now stripped, _0 stays as _0
    ['\\Delta f=2f_0\\cdot\\frac{v}{c}\\cdot\\cos\\left(\\theta\\right)',
     { contains: ['Delta f=2f_0', 'v', 'c', 'cos(theta)'] }],
    // Snell's law — \theta_1 stays as theta_1 (SymPy single symbol)
    ['n_1\\sin\\left(\\theta_1\\right)=n_2\\sin\\left(\\theta_2\\right)',
     'n_1sin(theta_1)=n_2sin(theta_2)']
]));

// ════════════════════════════════════════════════════════════════════
// 30. NESTED & DEEPLY-COMPOUND EXPRESSIONS — the gnarly cases.
// ════════════════════════════════════════════════════════════════════
add(runTests('30. Deeply nested expressions', [
    // Fraction inside fraction
    ['\\frac{\\frac{\\sin\\left(x\\right)}{\\cos\\left(x\\right)}}{\\frac{1}{2}}',
     { contains: ['sin(x)', '/', 'cos(x)', '1', '/', '2'], notContains: ['frac', '\\\\'] }],
    // Power of a fraction
    ['\\left(\\frac{\\sin\\left(x\\right)}{\\cos\\left(x\\right)}\\right)^3',
     { contains: ['sin(x)', '/', 'cos(x)', '^3'], notContains: ['frac', '\\\\'] }],
    // Square root of fraction with trig
    ['\\sqrt{\\frac{1+\\sin\\left(2x\\right)}{1-\\sin\\left(2x\\right)}}',
     { contains: ['sqrt(', '1+sin(2x)', '/', '1-sin(2x)'] }],
    // Triple nested: sin(2 * tan(x/2)/(1+tan²(x/2)))
    ['\\sin\\left(\\frac{2\\tan\\left(\\frac{x}{2}\\right)}{1+\\tan^2\\left(\\frac{x}{2}\\right)}\\right)',
     { contains: ['sin(', '2tan(', 'x', '/', '2', '1+tan^2('] }],
    // Mixed nested with sqrt and frac
    ['\\frac{\\sqrt{1-\\cos\\left(2x\\right)}}{\\sqrt{1+\\cos\\left(2x\\right)}}',
     { contains: ['sqrt(1-cos(2x))', '/', 'sqrt(1+cos(2x))'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 31. SYSTEM OF EQUATIONS / CONSTRAINED — multi-line problems.
// ════════════════════════════════════════════════════════════════════
add(runTests('31. Constrained / system equations', [
    // Pythagorean constraint
    ['\\sin\\left(x\\right)+\\cos\\left(x\\right)=1',  'sin(x)+cos(x)=1'],
    ['\\sin^2\\left(x\\right)-\\cos^2\\left(x\\right)=\\frac{1}{2}',
     { contains: ['sin^2(x)-cos^2(x)=', '1', '/', '2'] }],
    // Constrained interval (typed as part of expression)
    ['\\tan\\left(x\\right)+\\cot\\left(x\\right)=2',  'tan(x)+cot(x)=2'],
    // Multiple unknowns
    ['\\sin\\left(x\\right)\\sin\\left(y\\right)=\\frac{1}{4}',
     { contains: ['sin(x)sin(y)=', '1', '/', '4'] }],
    ['\\cos\\left(x+y\\right)+\\cos\\left(x-y\\right)=2\\cos\\left(x\\right)\\cos\\left(y\\right)',
     { contains: ['cos(x+y)+cos(x-y)=2cos(x)cos(y)'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 32. CALCULUS-ADJACENT — derivatives, limits, integrals that share
//     the same MathLive input partial.
// ════════════════════════════════════════════════════════════════════
add(runTests('32. Calculus-adjacent expressions', [
    ['\\frac{d}{dx}\\left[\\sin\\left(x^2\\right)\\right]=2x\\cos\\left(x^2\\right)',
     { contains: ['d', 'dx', 'sin(x^2)', '=2x', 'cos(x^2)'] }],
    ['\\lim_{x\\to 0}\\frac{\\sin\\left(x\\right)}{x}=1',
     { contains: ['lim_(', 'x->', '0', 'sin(x)', '/', 'x', '=1'] }],
    ['\\int\\sin^2\\left(x\\right)dx=\\frac{x}{2}-\\frac{\\sin\\left(2x\\right)}{4}',
     { contains: ['sin^2(x)dx=', 'x', '/', '2', 'sin(2x)', '/', '4'] }],
    ['\\int_0^{\\pi/2}\\sin\\left(x\\right)dx=1',
     { contains: ['_0^(', 'pi/2)', 'sin(x)dx=1'] }]
]));

// ════════════════════════════════════════════════════════════════════
// 33. UGLY REAL-WORLD AI/SCAN OUTPUT — what an LLM may emit when
//     extracting from a textbook with messy spacing & extra braces.
// ════════════════════════════════════════════════════════════════════
add(runTests('33. Messy AI/scan output', [
    // Extra braces around args — \sin{x} is alt syntax; should reduce to sin(x)
    ['\\sin{x}',                                 'sin(x)'],
    ['\\sin\\;\\;\\left(x\\right)',              'sin(x)'],
    // Triple-dollar wrap (some OCR tools)
    ['$$$\\sin(x)=1/2$$$',                       'sin(x)=1/2'],
    // Mixed degree notation
    ['\\sin\\left(45^{\\circ}\\right)+\\cos\\left(\\frac{\\pi}{3}\\right)',
     { contains: ['sin(45', 'cos(', 'pi', '/', '3'] }],
    // Subscripted variables — bare `x_1` (no braces) stays as `x_1`,
    // SymPy treats it as a single symbol.  \theta_1 → theta_1 after greek strip.
    ['x_1\\sin\\left(\\theta_1\\right)+x_2\\sin\\left(\\theta_2\\right)',
     { contains: ['x_1sin(theta_1)+x_2sin(theta_2)'] }],
    // Unicode minus sign (some OCR)
    ['\\sin\\left(x\\right)\u2212\\cos\\left(x\\right)',
     'sin(x)-cos(x)']
]));

// ════════════════════════════════════════════════════════════════════
// 34. ADVERSARIAL — inputs that LOOK like they should break.
// ════════════════════════════════════════════════════════════════════
add(runTests('34. Adversarial inputs (no over-substitution)', [
    // Variable named "n" — must not become "infty"
    ['n\\to\\infty',                  { contains: ['n->oo'] }],
    // Variable "i" inside trig — must not be touched as set membership
    ['\\sin\\left(i\\right)',         'sin(i)'],
    // \in inside text-content (not smart-mode mangle)
    ['\\text{x in domain}',           'x in domain'],
    // pi as a substring of another word
    ['piston',                        'piston'],
    // Function name embedded in a longer name — server tolerates the space
    ['\\sin\\left(x\\right)\\cdot sigmoid\\left(x\\right)',  { contains: ['sin(x)*', 'sigmoid(x)'] }],
    // No-op: empty fraction safety
    ['\\frac{}{}',                    { notContains: ['\\\\frac'] }]
]));

// ─── Final tally ───────────────────────────────────────────────────
console.log('\n══════════════════════════════════════');
console.log('TOTAL: ' + totals.pass + ' passed, ' + totals.fail + ' failed');
console.log('══════════════════════════════════════');
process.exit(totals.fail ? 1 : 0);
