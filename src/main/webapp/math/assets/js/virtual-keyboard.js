/**
 * virtual-keyboard.js — Custom MathLive virtual keyboard layouts
 * Math Editor — tailored for equation editing UX
 *
 * Layouts: Numbers, Operators, Calculus, Greek, Letters
 * Activates on math-field focus, deactivates on blur.
 */
(function () {
    'use strict';

    // Wait for MathLive to be available
    document.addEventListener('me:editor-ready', function () {
        if (typeof mathVirtualKeyboard === 'undefined') return;

        // =========================================================
        //  LAYOUT 1: Numbers & Basic Operators
        // =========================================================
        var numbersLayout = {
            label: '123',
            tooltip: 'Numbers & operators',
            rows: [
                [
                    { latex: '7', width: 1.2 },
                    { latex: '8', width: 1.2 },
                    { latex: '9', width: 1.2 },
                    { latex: '\\div', aside: '\u00F7', width: 1.2 },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\frac{#@}{#?}', label: '<span style="font-size:12px"><sup>a</sup>&frasl;<sub>b</sub></span>', aside: 'frac', width: 1.4 },
                    { latex: '\\sqrt{#0}', label: '&radic;', aside: 'sqrt', width: 1.2 },
                    { latex: '\\sqrt[#?]{#0}', label: '<sup>n</sup>&radic;', aside: 'nth root', width: 1.2 }
                ],
                [
                    { latex: '4', width: 1.2 },
                    { latex: '5', width: 1.2 },
                    { latex: '6', width: 1.2 },
                    { latex: '\\times', aside: '\u00D7', width: 1.2 },
                    { label: '[separator]', width: 0.3 },
                    { latex: '^{#?}', label: 'x<sup>n</sup>', aside: 'power', width: 1.2 },
                    { latex: '_{#?}', label: 'x<sub>n</sub>', aside: 'subscript', width: 1.2 },
                    { latex: '^{2}', label: 'x\u00B2', aside: 'square', width: 1.2 }
                ],
                [
                    { latex: '1', width: 1.2 },
                    { latex: '2', width: 1.2 },
                    { latex: '3', width: 1.2 },
                    { latex: '-', width: 1.2 },
                    { label: '[separator]', width: 0.3 },
                    { latex: '(', class: 'small', width: 1.2 },
                    { latex: ')', class: 'small', width: 1.2 },
                    { label: '[backspace]', width: 1.2 }
                ],
                [
                    { latex: '0', width: 1.2 },
                    { latex: '.', width: 1.2 },
                    { latex: '=', width: 1.2 },
                    { latex: '+', width: 1.2 },
                    { label: '[separator]', width: 0.3 },
                    { label: '[left]', width: 1.2 },
                    { label: '[right]', width: 1.2 },
                    { label: '[return]', width: 1.2 }
                ]
            ]
        };

        // =========================================================
        //  LAYOUT 2: Symbols & Relations
        // =========================================================
        var symbolsLayout = {
            label: '\u00B1\u221E',
            tooltip: 'Symbols & relations',
            rows: [
                [
                    { latex: '\\leq', aside: '\u2264' },
                    { latex: '\\geq', aside: '\u2265' },
                    { latex: '\\neq', aside: '\u2260' },
                    { latex: '\\approx', aside: '\u2248' },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\pm', aside: '\u00B1' },
                    { latex: '\\mp', aside: '\u2213' },
                    { latex: '\\cdot', aside: '\u00B7' },
                    { latex: '\\infty', aside: '\u221E' }
                ],
                [
                    { latex: '\\in', aside: '\u2208' },
                    { latex: '\\notin', aside: '\u2209' },
                    { latex: '\\subset', aside: '\u2282' },
                    { latex: '\\subseteq', aside: '\u2286' },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\cup', aside: '\u222A' },
                    { latex: '\\cap', aside: '\u2229' },
                    { latex: '\\emptyset', aside: '\u2205' },
                    { latex: '\\mathbb{R}', label: '\u211D', aside: 'reals' }
                ],
                [
                    { latex: '\\Rightarrow', aside: '\u21D2' },
                    { latex: '\\Leftrightarrow', aside: '\u21D4' },
                    { latex: '\\forall', aside: '\u2200' },
                    { latex: '\\exists', aside: '\u2203' },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\lvert #0 \\rvert', label: '|a|', aside: 'abs' },
                    { latex: '\\lfloor #0 \\rfloor', label: '\u230Aa\u230B', aside: 'floor' },
                    { latex: '\\lceil #0 \\rceil', label: '\u2308a\u2309', aside: 'ceil' },
                    { label: '[backspace]' }
                ],
                [
                    { latex: '\\land', aside: '\u2227', label: '\u2227' },
                    { latex: '\\lor', aside: '\u2228', label: '\u2228' },
                    { latex: '\\neg', aside: '\u00AC', label: '\u00AC' },
                    { latex: '\\therefore', aside: '\u2234', label: '\u2234' },
                    { label: '[separator]', width: 0.3 },
                    { label: '[left]' },
                    { label: '[right]' },
                    { latex: ',\\,' },
                    { label: '[return]' }
                ]
            ]
        };

        // =========================================================
        //  LAYOUT 3: Calculus & Analysis
        // =========================================================
        var calculusLayout = {
            label: '\u222B dx',
            tooltip: 'Calculus & analysis',
            rows: [
                [
                    { latex: '\\int_{#?}^{#?}#0\\,d#?', label: '\u222B<sup>b</sup><sub>a</sub>', aside: 'def. int', width: 1.5 },
                    { latex: '\\int #0\\,d#?', label: '\u222B dx', aside: 'integral', width: 1.3 },
                    { latex: '\\iint #0\\,d#?\\,d#?', label: '\u222C', aside: 'double', width: 1.3 },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\frac{d}{d#?}\\left(#0\\right)', label: 'd/dx', aside: 'deriv', width: 1.5 },
                    { latex: '\\frac{\\partial}{\\partial #?}#0', label: '\u2202/\u2202x', aside: 'partial', width: 1.5 },
                    { latex: '\\frac{d^{#?}}{d#?^{#?}}#0', label: 'd\u207F/dx\u207F', aside: 'nth deriv', width: 1.5 }
                ],
                [
                    { latex: '\\lim_{#? \\to #?}#0', label: 'lim', aside: 'limit', width: 1.5 },
                    { latex: '\\sum_{#?}^{#?}#0', label: '\u2211', aside: 'sum', width: 1.3 },
                    { latex: '\\prod_{#?}^{#?}#0', label: '\u220F', aside: 'product', width: 1.3 },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\sin', aside: 'sin', width: 1 },
                    { latex: '\\cos', aside: 'cos', width: 1 },
                    { latex: '\\tan', aside: 'tan', width: 1 },
                    { latex: '\\ln', aside: 'ln', width: 1 },
                    { latex: '\\log', aside: 'log', width: 1 }
                ],
                [
                    { latex: '\\to', aside: '\u2192' },
                    { latex: '\\infty', aside: '\u221E' },
                    { latex: '-\\infty', aside: '-\u221E' },
                    { latex: '\\Delta', aside: '\u0394' },
                    { label: '[separator]', width: 0.3 },
                    { latex: '\\arcsin', aside: 'asin', class: 'small' },
                    { latex: '\\arccos', aside: 'acos', class: 'small' },
                    { latex: '\\arctan', aside: 'atan', class: 'small' },
                    { latex: 'e^{#?}', label: 'e<sup>x</sup>', aside: 'exp' },
                    { label: '[backspace]' }
                ],
                [
                    { latex: '\\nabla', aside: '\u2207' },
                    { latex: '\\partial', aside: '\u2202' },
                    { latex: 'dx', aside: 'dx' },
                    { latex: 'dy', aside: 'dy' },
                    { label: '[separator]', width: 0.3 },
                    { label: '[left]' },
                    { label: '[right]' },
                    { latex: '\\,' },
                    { label: '[return]' }
                ]
            ]
        };

        // =========================================================
        //  LAYOUT 4: Greek Letters
        // =========================================================
        var greekLayout = {
            label: '\u03B1\u03B2\u03B3',
            tooltip: 'Greek letters',
            rows: [
                [
                    { latex: '\\alpha', aside: '\u03B1', shift: { latex: 'A', aside: 'A' } },
                    { latex: '\\beta', aside: '\u03B2', shift: { latex: 'B', aside: 'B' } },
                    { latex: '\\gamma', aside: '\u03B3', shift: { latex: '\\Gamma', aside: '\u0393' } },
                    { latex: '\\delta', aside: '\u03B4', shift: { latex: '\\Delta', aside: '\u0394' } },
                    { latex: '\\epsilon', aside: '\u03F5', shift: { latex: 'E', aside: 'E' }, variants: ['\\varepsilon'] },
                    { latex: '\\zeta', aside: '\u03B6', shift: { latex: 'Z', aside: 'Z' } },
                    { latex: '\\eta', aside: '\u03B7', shift: { latex: 'H', aside: 'H' } },
                    { latex: '\\theta', aside: '\u03B8', shift: { latex: '\\Theta', aside: '\u0398' }, variants: ['\\vartheta'] }
                ],
                [
                    { latex: '\\iota', aside: '\u03B9', shift: { latex: 'I', aside: 'I' } },
                    { latex: '\\kappa', aside: '\u03BA', shift: { latex: 'K', aside: 'K' } },
                    { latex: '\\lambda', aside: '\u03BB', shift: { latex: '\\Lambda', aside: '\u039B' } },
                    { latex: '\\mu', aside: '\u03BC', shift: { latex: 'M', aside: 'M' } },
                    { latex: '\\nu', aside: '\u03BD', shift: { latex: 'N', aside: 'N' } },
                    { latex: '\\xi', aside: '\u03BE', shift: { latex: '\\Xi', aside: '\u039E' } },
                    { latex: '\\pi', aside: '\u03C0', shift: { latex: '\\Pi', aside: '\u03A0' } },
                    { latex: '\\rho', aside: '\u03C1', shift: { latex: 'P', aside: 'P' }, variants: ['\\varrho'] }
                ],
                [
                    { label: '[shift]' },
                    { latex: '\\sigma', aside: '\u03C3', shift: { latex: '\\Sigma', aside: '\u03A3' }, variants: ['\\varsigma'] },
                    { latex: '\\tau', aside: '\u03C4', shift: { latex: 'T', aside: 'T' } },
                    { latex: '\\upsilon', aside: '\u03C5', shift: { latex: '\\Upsilon', aside: '\u03A5' } },
                    { latex: '\\phi', aside: '\u03D5', shift: { latex: '\\Phi', aside: '\u03A6' }, variants: ['\\varphi'] },
                    { latex: '\\chi', aside: '\u03C7', shift: { latex: 'X', aside: 'X' } },
                    { latex: '\\psi', aside: '\u03C8', shift: { latex: '\\Psi', aside: '\u03A8' } },
                    { label: '[backspace]' }
                ],
                [
                    { latex: '\\omega', aside: '\u03C9', shift: { latex: '\\Omega', aside: '\u03A9' } },
                    { latex: '\\ell', aside: '\u2113' },
                    { latex: '\\hbar', aside: '\u210F' },
                    { latex: '\\aleph', aside: '\u2135' },
                    { label: '[separator]', width: 0.3 },
                    { label: '[left]' },
                    { label: '[right]' },
                    { latex: '\\,' },
                    { label: '[return]' }
                ]
            ]
        };

        // =========================================================
        //  LAYOUT 5: Matrices & Structures
        // =========================================================
        var matrixLayout = {
            label: '[ ]',
            tooltip: 'Matrices & structures',
            rows: [
                [
                    { insert: '\\begin{pmatrix} #? & #? \\\\ #? & #? \\end{pmatrix}',
                      label: '<span style="font-size:11px">(\u2003)</span>', aside: '2\u00D72', width: 1.6 },
                    { insert: '\\begin{pmatrix} #? & #? & #? \\\\ #? & #? & #? \\\\ #? & #? & #? \\end{pmatrix}',
                      label: '<span style="font-size:11px">(\u2003\u2003)</span>', aside: '3\u00D73', width: 1.6 },
                    { label: '[separator]', width: 0.3 },
                    { insert: '\\begin{bmatrix} #? & #? \\\\ #? & #? \\end{bmatrix}',
                      label: '<span style="font-size:11px">[\u2003]</span>', aside: '2\u00D72', width: 1.6 },
                    { insert: '\\begin{bmatrix} #? & #? & #? \\\\ #? & #? & #? \\\\ #? & #? & #? \\end{bmatrix}',
                      label: '<span style="font-size:11px">[\u2003\u2003]</span>', aside: '3\u00D73', width: 1.6 },
                    { label: '[separator]', width: 0.3 },
                    { insert: '\\begin{vmatrix} #? & #? \\\\ #? & #? \\end{vmatrix}',
                      label: '<span style="font-size:11px">|\u2003|</span>', aside: 'det 2\u00D72', width: 1.6 }
                ],
                [
                    { insert: '\\begin{pmatrix} #? \\\\ #? \\\\ #? \\end{pmatrix}',
                      label: '<span style="font-size:11px">(col)</span>', aside: 'column', width: 1.4 },
                    { insert: '\\begin{pmatrix} #? & #? & #? \\end{pmatrix}',
                      label: '<span style="font-size:11px">(row)</span>', aside: 'row', width: 1.4 },
                    { label: '[separator]', width: 0.3 },
                    { insert: '\\begin{cases} #? & \\text{if } #? \\\\ #? & \\text{if } #? \\\\ #? & \\text{otherwise} \\end{cases}',
                      label: '<span style="font-size:11px">{ cases</span>', aside: 'piecewise', width: 2 },
                    { label: '[separator]', width: 0.3 },
                    { insert: '\\begin{aligned} #? &= #? \\\\ #? &= #? \\end{aligned}',
                      label: '<span style="font-size:11px">align</span>', aside: 'aligned', width: 1.8 },
                    { label: '[backspace]', width: 1.2 }
                ],
                [
                    { latex: '\\vec{#0}', label: 'a\u20D7', aside: 'vector', width: 1.2 },
                    { latex: '\\hat{#0}', label: 'a\u0302', aside: 'hat', width: 1.2 },
                    { latex: '\\bar{#0}', label: 'a\u0305', aside: 'bar', width: 1.2 },
                    { latex: '\\dot{#0}', label: 'a\u0307', aside: 'dot', width: 1.2 },
                    { latex: '\\ddot{#0}', label: 'a\u0308', aside: 'ddot', width: 1.2 },
                    { latex: '\\tilde{#0}', label: 'a\u0303', aside: 'tilde', width: 1.2 },
                    { latex: '\\overline{#0}', label: '<span style="text-decoration:overline">ab</span>', aside: 'overline', width: 1.2 }
                ],
                [
                    { latex: '\\binom{#?}{#?}', label: '<span style="font-size:11px">(<sup>n</sup><sub>k</sub>)</span>', aside: 'binomial', width: 1.4 },
                    { latex: '#?!', label: 'n!', aside: 'factorial', width: 1.2 },
                    { latex: '\\ldots', aside: '\u2026' },
                    { latex: '\\cdots', aside: '\u22EF' },
                    { label: '[separator]', width: 0.3 },
                    { label: '[left]' },
                    { label: '[right]' },
                    { latex: '\\,' },
                    { label: '[return]' }
                ]
            ]
        };

        // =========================================================
        //  REGISTER LAYOUTS
        // =========================================================
        mathVirtualKeyboard.layouts = [
            numbersLayout,
            symbolsLayout,
            calculusLayout,
            greekLayout,
            matrixLayout
        ];
    });
})();
