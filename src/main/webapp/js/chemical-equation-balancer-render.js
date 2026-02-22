/**
 * Chemical Equation Balancer — Render & Algorithm Module
 * Exposed as window.CEBRender
 * Requires: math.js loaded globally (for math.fraction)
 */
window.CEBRender = (function () {
    'use strict';

    /* ===== Utility ===== */
    function escapeHtml(s) {
        return (s || '').replace(/[&<>"']/g, function (c) {
            return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[c];
        });
    }
    function stripHtml(s) {
        var div = document.createElement('div');
        div.innerHTML = s;
        return div.textContent || div.innerText || '';
    }
    function gcd(a, b) { a = Math.abs(a); b = Math.abs(b); while (b) { var t = b; b = a % b; a = t; } return a || 1; }
    function lcm(a, b) { return a / gcd(a, b) * b; }
    function lcmArr(arr) { return arr.reduce(function (x, y) { return lcm(x, y); }, 1); }

    /* ===== Formula Formatting ===== */
    function formatFormulaHTML(formula) {
        var out = escapeHtml(formula || '').replace(/\./g, '&middot;');
        out = out.replace(/([A-Za-z\)\]])(\d+)/g, function (m, p1, p2) { return p1 + '<sub>' + p2 + '</sub>'; });
        return out;
    }

    /* ===== Formula Parser ===== */
    function parseFormula(formula) {
        formula = (formula || '').replace(/·/g, '.');
        var i = 0;
        function parseGroup() {
            var counts = {};
            while (i < formula.length) {
                if (formula[i] === '(' || formula[i] === '[') {
                    i++;
                    var inner = parseGroup();
                    if (i >= formula.length || (formula[i] !== ')' && formula[i] !== ']')) break;
                    i++;
                    var mult = readNumber();
                    for (var el in inner) { counts[el] = (counts[el] || 0) + inner[el] * mult; }
                } else if (formula[i] === ')' || formula[i] === ']') {
                    break;
                } else if (formula[i] === '.') {
                    i++;
                } else if (/[A-Z]/.test(formula[i])) {
                    var el = formula[i++];
                    while (i < formula.length && /[a-z]/.test(formula[i])) el += formula[i++];
                    var num = readNumber();
                    counts[el] = (counts[el] || 0) + num;
                } else if (/\s/.test(formula[i])) {
                    i++;
                } else {
                    i++;
                }
            }
            return counts;
        }
        function readNumber() {
            var start = i;
            while (i < formula.length && /\d/.test(formula[i])) i++;
            return start === i ? 1 : parseInt(formula.slice(start, i), 10);
        }
        return parseGroup();
    }

    /* ===== Tokenize & Parse Equation ===== */
    function tokenizeSide(side) {
        return side.split('+').map(function (s) { return s.trim(); }).filter(Boolean).map(function (sp) {
            var m = sp.match(/^(\d+)\s*(.*)$/);
            var coef = 1, formula = sp;
            if (m) { coef = parseInt(m[1], 10); formula = m[2].trim(); }
            return { coef: coef, formula: formula };
        });
    }

    function parseEquation(input) {
        var m = input.match(/(=>|->|→|⇒|-->|=)/);
        if (!m) throw new Error('NO_ARROW');
        var arrow = m[0];
        var parts = input.split(/=>|->|→|⇒|-->|=/);
        if (parts.length !== 2) throw new Error('MULTI_ARROW');
        var left = tokenizeSide(parts[0]);
        var right = tokenizeSide(parts[1]);
        return { left: left, right: right, arrow: arrow };
    }

    /* ===== Unique Elements ===== */
    function uniqueElements(left, right) {
        var set = {};
        left.concat(right).forEach(function (sp) {
            var c = parseFormula(sp.formula);
            Object.keys(c).forEach(function (e) { set[e] = true; });
        });
        return Object.keys(set).sort();
    }

    /* ===== Build Matrix ===== */
    function buildMatrix(elements, left, right) {
        var cols = left.length + right.length;
        var A = elements.map(function () { return new Array(cols).fill(0); });
        function fill(sp, offset, sign) {
            sp.forEach(function (s, j) {
                var counts = parseFormula(s.formula);
                elements.forEach(function (el, i) { A[i][offset + j] = (counts[el] || 0) * sign; });
            });
        }
        fill(left, 0, 1);
        fill(right, left.length, -1);
        return A;
    }

    /* ===== Nullspace (math.js fractions) ===== */
    function nullspaceInt(A) {
        var rows = A.length, cols = A[0].length;
        // Use math.js fractions for exact arithmetic
        var M = A.map(function (r) {
            return r.map(function (v) { return math.fraction(v); });
        });

        var r = 0;
        for (var c = 0; c < cols && r < rows; c++) {
            // find pivot
            var piv = r;
            while (piv < rows && math.equal(M[piv][c], math.fraction(0))) piv++;
            if (piv === rows) continue;
            // swap
            if (piv !== r) { var tmp = M[r]; M[r] = M[piv]; M[piv] = tmp; }
            // normalize row r
            var pivVal = M[r][c];
            for (var j = c; j < cols; j++) M[r][j] = math.divide(M[r][j], pivVal);
            // eliminate others
            for (var i = 0; i < rows; i++) {
                if (i !== r && !math.equal(M[i][c], math.fraction(0))) {
                    var f = M[i][c];
                    for (var j2 = c; j2 < cols; j2++) {
                        M[i][j2] = math.subtract(M[i][j2], math.multiply(f, M[r][j2]));
                    }
                }
            }
            r++;
        }

        // Identify pivot columns
        var pivotCol = new Array(rows).fill(-1);
        var row = 0;
        for (var c2 = 0; c2 < cols && row < rows; c2++) {
            var val = M[row][c2];
            if (math.equal(val, math.fraction(1))) { pivotCol[row] = c2; row++; }
        }
        var isPivotCol = new Array(cols).fill(false);
        pivotCol.forEach(function (c3) { if (c3 >= 0) isPivotCol[c3] = true; });
        var free = [];
        for (var c4 = 0; c4 < cols; c4++) { if (!isPivotCol[c4]) free.push(c4); }
        if (free.length === 0) free.push(cols - 1);

        // Backsolve
        var x = [];
        for (var k = 0; k < cols; k++) x[k] = math.fraction(0);
        free.forEach(function (c5) { x[c5] = math.fraction(1); });
        for (var i2 = rows - 1; i2 >= 0; i2--) {
            var pc = pivotCol[i2];
            if (pc < 0) continue;
            var sum = math.fraction(0);
            for (var j3 = pc + 1; j3 < cols; j3++) {
                if (!math.equal(M[i2][j3], math.fraction(0))) {
                    sum = math.add(sum, math.multiply(M[i2][j3], x[j3]));
                }
            }
            x[pc] = math.unaryMinus(sum);
        }

        // Convert fractions to integers (math.js uses BigInt internally, so convert to Number)
        var dens = x.map(function (fr) { return Number(fr.d); });
        var L = lcmArr(dens);
        var ints = x.map(function (fr) { return Number(fr.s) * Number(fr.n) * (L / Number(fr.d)); });
        // normalize positive
        var allNeg = ints.every(function (v) { return v <= 0; });
        if (allNeg) ints = ints.map(function (v) { return -v; });
        var G = ints.reduce(function (a, b) { return gcd(a, b); }, Math.abs(ints[0]) || 1);
        ints = ints.map(function (v) { return v / G; });
        return ints;
    }

    /* ===== Build Balanced HTML ===== */
    function buildBalancedHTML(left, right, coL, coR, arrow, opts) {
        var hide1 = opts && opts.hide1;
        var arrowSymbol = (arrow === '=>' || arrow === '⇒') ? '&rArr;' : '&rarr;';

        function fmtSide(side, coefs) {
            return side.map(function (s, i) {
                var c = coefs[i];
                var cStr = (hide1 && c === 1) ? '' : '<span class="cb-coeff">' + c + '</span>';
                return '<span class="cb-nowrap">' + cStr + formatFormulaHTML(s.formula) + '</span>';
            }).join(' + ');
        }

        return fmtSide(left, coL) + ' <span class="cb-arrow">' + arrowSymbol + '</span> ' + fmtSide(right, coR);
    }

    /* ===== Build Atom Table ===== */
    function buildAtomTable(elements, left, right, coL, coR) {
        function totalCounts(spList, coefs) {
            var totals = {};
            spList.forEach(function (s, i) {
                var c = parseFormula(s.formula);
                Object.keys(c).forEach(function (el) {
                    totals[el] = (totals[el] || 0) + c[el] * coefs[i];
                });
            });
            return totals;
        }
        var totL = totalCounts(left, coL);
        var totR = totalCounts(right, coR);
        var rowsHTML = elements.map(function (el) {
            var a = totL[el] || 0, b = totR[el] || 0;
            var cls = (a === b) ? 'cb-atom-equal' : 'cb-atom-mismatch';
            var icon = (a === b) ? '&#10003;' : '&#10007;';
            return '<tr><td>' + el + '</td><td>' + a + '</td><td>' + b + '</td><td class="' + cls + '">' + icon + '</td></tr>';
        }).join('');

        return '<div class="cb-atom-table-wrap"><table class="cb-atom-table">' +
            '<thead><tr><th>Element</th><th>Left</th><th>Right</th><th>Status</th></tr></thead>' +
            '<tbody>' + rowsHTML + '</tbody></table></div>';
    }

    /* ===== LaTeX ===== */
    function toLaTeXFormula(formula) {
        var f = formula.replace(/\./g, ' \\cdot ');
        f = f.replace(/([A-Za-z\)\]])(\d+)/g, function (m, p1, p2) { return p1 + '_{' + p2 + '}'; });
        f = f.replace(/([A-Za-z\]\)])(\d*)([\+\-])$/g, function (m, p1, p2, p3) { return p1 + '^{' + (p2 || '') + p3 + '}'; });
        return f;
    }
    function toLaTeXEquation(left, right, coL, coR, hide1) {
        function fmt(side, coefs) {
            return side.map(function (s, i) {
                var c = coefs[i];
                var cStr = (hide1 && c === 1) ? '' : c + '';
                return cStr + toLaTeXFormula(s.formula);
            }).join(' + ');
        }
        return fmt(left, coL) + ' \\rightarrow ' + fmt(right, coR);
    }

    /* ===== Unicode Pretty ===== */
    var subMap = { '0': '\u2080', '1': '\u2081', '2': '\u2082', '3': '\u2083', '4': '\u2084', '5': '\u2085', '6': '\u2086', '7': '\u2087', '8': '\u2088', '9': '\u2089' };
    function subNum(n) { return String(n).replace(/[0-9]/g, function (d) { return subMap[d]; }); }

    function toUnicodePretty(left, right, coL, coR, hide1, arrowChar) {
        function fmt(side, coefs) {
            return side.map(function (s, i) {
                var c = coefs[i];
                var cStr = (hide1 && c === 1) ? '' : (c + ' ');
                var f = s.formula.replace(/\./g, '\u00b7');
                f = f.replace(/([A-Za-z\)\]])(\d+)/g, function (m, p1, p2) { return p1 + subNum(p2); });
                return cStr + f;
            }).join(' + ');
        }
        return fmt(left, coL) + ' ' + arrowChar + ' ' + fmt(right, coR);
    }

    /* ===== Build Full Result DOM ===== */
    function buildResultDOM(left, right, coeffs, elements, arrow, opts) {
        var coL = coeffs.slice(0, left.length);
        var coR = coeffs.slice(left.length);
        var hide1 = opts && opts.hide1;
        var showFrac = opts && opts.showFrac;
        var arrowSymbol = (arrow === '=>' || arrow === '⇒') ? '&rArr;' : '&rarr;';
        var arrowChar = (arrow === '=>' || arrow === '⇒') ? '\u21D2' : '\u2192';

        var html = '<div class="cb-balanced-eq">' + buildBalancedHTML(left, right, coL, coR, arrow, opts) + '</div>';

        // fractions view
        if (showFrac) {
            var first = 0;
            for (var i = 0; i < coeffs.length; i++) { if (coeffs[i] !== 0) { first = coeffs[i]; break; } }
            first = first || 1;
            function toFrac(n, d) { var g = gcd(n, d); n /= g; d /= g; return d === 1 ? '' + n : n + '/' + d; }
            function fracSide(side, coefs) {
                return side.map(function (s, i2) {
                    var num = coefs[i2], den = first;
                    var cStr = (hide1 && num === first) ? '' : '<span class="cb-coeff">' + toFrac(num, den) + '</span>';
                    return '<span class="cb-nowrap">' + cStr + formatFormulaHTML(s.formula) + '</span>';
                }).join(' + ');
            }
            html += '<div class="cb-fractions-view">Fractions: ' + fracSide(left, coL) + ' ' + arrowSymbol + ' ' + fracSide(right, coR) + '</div>';
        }

        html += buildAtomTable(elements, left, right, coL, coR);

        html += '<div class="cb-actions">' +
            '<button type="button" class="cb-action-btn" data-action="copy" title="Copy balanced equation">Copy</button>' +
            '<button type="button" class="cb-action-btn" data-action="latex" title="Copy LaTeX">LaTeX</button>' +
            '<button type="button" class="cb-action-btn" data-action="png" title="Export as PNG">PNG</button>' +
            '<button type="button" class="cb-action-btn" data-action="pdf" title="Download as PDF">PDF</button>' +
            '<button type="button" class="cb-action-btn" data-action="share" title="Share link">Share</button>' +
            '</div>';

        // store data for actions
        var data = {
            balanced: stripHtml(buildBalancedHTML(left, right, coL, coR, arrow, opts)),
            latex: toLaTeXEquation(left, right, coL, coR, hide1),
            pretty: toUnicodePretty(left, right, coL, coR, hide1, arrowChar)
        };

        return { html: html, data: data };
    }

    /* ===== Single Side Analysis ===== */
    function buildSingleSideAnalysis(text) {
        var species = text.split('+').map(function (s) { return s.trim(); }).filter(Boolean);
        if (species.length === 0) {
            return '<div class="cb-alert cb-alert-warning">No formula detected. Add species like H2 + O2 and a reaction arrow.</div>';
        }
        var elementsSet = {};
        var rows = species.map(function (f) {
            var c = parseFormula(f);
            Object.keys(c).forEach(function (e) { elementsSet[e] = true; });
            return { f: f, c: c };
        });
        var elements = Object.keys(elementsSet).sort();
        var totals = {};
        rows.forEach(function (r) { elements.forEach(function (e) { totals[e] = (totals[e] || 0) + (r.c[e] || 0); }); });

        var head = '<thead><tr><th>Species</th>' + elements.map(function (e) { return '<th>' + e + '</th>'; }).join('') + '</tr></thead>';
        var body = rows.map(function (r) {
            return '<tr><td>' + formatFormulaHTML(r.f) + '</td>' + elements.map(function (e) { return '<td>' + (r.c[e] || 0) + '</td>'; }).join('') + '</tr>';
        }).join('');
        var totalRow = '<tr style="font-weight:600"><td>Total</td>' + elements.map(function (e) { return '<td>' + (totals[e] || 0) + '</td>'; }).join('') + '</tr>';

        return '<div class="cb-alert cb-alert-info" style="margin-bottom:0.75rem">No reaction arrow detected. Showing single-side analysis. Add an arrow (-&gt;, =&gt;, or =) to balance.</div>' +
            '<div class="cb-atom-table-wrap"><table class="cb-atom-table">' + head + '<tbody>' + body + totalRow + '</tbody></table></div>';
    }

    /* ===== Redox Half-Reaction Combiner ===== */
    function parseHalf(text) {
        var parts = text.split(/=>|->/);
        if (parts.length !== 2) throw new Error('Half-reaction needs one arrow (-> or =>)');
        return { left: tokenizeSide(parts[0]), right: tokenizeSide(parts[1]) };
    }
    function speciesKey(s) { return s.formula.replace(/\s+/g, ''); }
    function scaleList(list, k) { return list.map(function (x) { return { coef: x.coef * k, formula: x.formula }; }); }
    function formatSideText(list) {
        return list.map(function (x) { return (x.coef === 1 ? '' : x.coef + ' ') + x.formula; }).join(' + ');
    }

    function combineHalfReactions(oxText, redText) {
        var h1 = parseHalf(oxText.trim());
        var h2 = parseHalf(redText.trim());
        var e = 'e-';
        function eCount(lst) { var found = lst.filter(function (x) { return x.formula === e; }); return found.length ? found[0].coef : 0; }
        var e1 = eCount(h1.right) - eCount(h1.left);
        var e2 = eCount(h2.left) - eCount(h2.right);
        if (e1 <= 0 || e2 <= 0) throw new Error('Provide oxidation with e- on product side and reduction with e- on reactant side.');
        var L = lcm(e1, e2);
        var k1 = L / e1, k2 = L / e2;
        function removeE(list) { return list.filter(function (x) { return x.formula !== e; }); }
        var netL = removeE(scaleList(h1.left, k1)).concat(removeE(scaleList(h2.left, k2)));
        var netR = removeE(scaleList(h1.right, k1)).concat(removeE(scaleList(h2.right, k2)));
        // cancel common species
        var mapL = {}, mapR = {};
        netL.forEach(function (x) { var k = speciesKey(x); mapL[k] = (mapL[k] || 0) + x.coef; });
        netR.forEach(function (x) { var k = speciesKey(x); mapR[k] = (mapR[k] || 0) + x.coef; });
        var allKeys = {};
        Object.keys(mapL).forEach(function (k) { allKeys[k] = true; });
        Object.keys(mapR).forEach(function (k) { allKeys[k] = true; });
        var outL = [], outR = [];
        Object.keys(allKeys).forEach(function (k) {
            var l = mapL[k] || 0, r = mapR[k] || 0;
            if (l > r) outL.push({ coef: l - r, formula: k });
            else if (r > l) outR.push({ coef: r - l, formula: k });
        });
        return escapeHtml(formatSideText(outL) + ' \u2192 ' + formatSideText(outR));
    }

    /* ===== Public API ===== */
    return {
        escapeHtml: escapeHtml,
        stripHtml: stripHtml,
        formatFormulaHTML: formatFormulaHTML,
        parseFormula: parseFormula,
        tokenizeSide: tokenizeSide,
        parseEquation: parseEquation,
        uniqueElements: uniqueElements,
        buildMatrix: buildMatrix,
        nullspaceInt: nullspaceInt,
        buildBalancedHTML: buildBalancedHTML,
        buildAtomTable: buildAtomTable,
        toLaTeXFormula: toLaTeXFormula,
        toLaTeXEquation: toLaTeXEquation,
        toUnicodePretty: toUnicodePretty,
        buildResultDOM: buildResultDOM,
        buildSingleSideAnalysis: buildSingleSideAnalysis,
        parseHalf: parseHalf,
        combineHalfReactions: combineHalfReactions,
        gcd: gcd,
        lcm: lcm
    };
})();
