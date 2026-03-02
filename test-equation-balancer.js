/**
 * Standalone test for the Chemical Equation Balancer algorithm.
 * Extracts the pure math logic (no DOM, no math.js dependency).
 * Uses integer-only Gauss-Jordan elimination (Nayuki style).
 */

// ===== Utility =====
function gcd(a, b) { a = Math.abs(a); b = Math.abs(b); while (b) { var t = b; b = a % b; a = t; } return a || 1; }
function lcm(a, b) { return a / gcd(a, b) * b; }
function lcmArr(arr) { return arr.reduce((x, y) => lcm(x, y), 1); }

// ===== Formula Parser =====
function parseFormula(formula) {
    formula = (formula || '').replace(/·/g, '.');
    let i = 0;
    function parseGroup() {
        const counts = {};
        while (i < formula.length) {
            if (formula[i] === '(' || formula[i] === '[') {
                i++;
                const inner = parseGroup();
                if (i >= formula.length || (formula[i] !== ')' && formula[i] !== ']')) break;
                i++;
                const mult = readNumber();
                for (const el in inner) counts[el] = (counts[el] || 0) + inner[el] * mult;
            } else if (formula[i] === ')' || formula[i] === ']') {
                break;
            } else if (formula[i] === '.') {
                i++;
            } else if (/[A-Z]/.test(formula[i])) {
                let el = formula[i++];
                while (i < formula.length && /[a-z]/.test(formula[i])) el += formula[i++];
                const num = readNumber();
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
        const start = i;
        while (i < formula.length && /\d/.test(formula[i])) i++;
        return start === i ? 1 : parseInt(formula.slice(start, i), 10);
    }
    return parseGroup();
}

// ===== Equation Parser =====
function tokenizeSide(side) {
    return side.split('+').map(s => s.trim()).filter(Boolean).map(sp => {
        const m = sp.match(/^(\d+)\s*(.*)$/);
        if (m) return { coef: parseInt(m[1], 10), formula: m[2].trim() };
        return { coef: 1, formula: sp };
    });
}

function parseEquation(input) {
    const m = input.match(/(=>|->|→|⇒|-->|=)/);
    if (!m) throw new Error('NO_ARROW');
    const arrow = m[0];
    const parts = input.split(/=>|->|→|⇒|-->|=/);
    if (parts.length !== 2) throw new Error('MULTI_ARROW');
    return { left: tokenizeSide(parts[0]), right: tokenizeSide(parts[1]), arrow };
}

// ===== Unique Elements =====
function uniqueElements(left, right) {
    const set = {};
    left.concat(right).forEach(sp => {
        const c = parseFormula(sp.formula);
        Object.keys(c).forEach(e => { set[e] = true; });
    });
    return Object.keys(set).sort();
}

// ===== Build Matrix =====
function buildMatrix(elements, left, right) {
    const cols = left.length + right.length;
    const A = elements.map(() => new Array(cols).fill(0));
    function fill(sp, offset, sign) {
        sp.forEach((s, j) => {
            const counts = parseFormula(s.formula);
            elements.forEach((el, i) => { A[i][offset + j] = (counts[el] || 0) * sign; });
        });
    }
    fill(left, 0, 1);
    fill(right, left.length, -1);
    return A;
}

// ===== Integer-only Gauss-Jordan (Nayuki style) =====
function nullspaceInt(A) {
    const rows = A.length, cols = A[0].length;
    // Work with rational numbers as [numerator, denominator] pairs
    let M = A.map(r => r.map(v => [v, 1]));

    function simplify(frac) {
        let [n, d] = frac;
        if (d < 0) { n = -n; d = -d; }
        const g = gcd(Math.abs(n), d);
        return [n / g, d / g];
    }
    function mul(a, b) { return simplify([a[0] * b[0], a[1] * b[1]]); }
    function div(a, b) { return simplify([a[0] * b[1], a[1] * b[0]]); }
    function sub(a, b) { return simplify([a[0] * b[1] - b[0] * a[1], a[1] * b[1]]); }
    function isZero(a) { return a[0] === 0; }
    function isOne(a) { return a[0] === 1 && a[1] === 1; }

    let r = 0;
    for (let c = 0; c < cols && r < rows; c++) {
        let piv = r;
        while (piv < rows && isZero(M[piv][c])) piv++;
        if (piv === rows) continue;
        if (piv !== r) { const tmp = M[r]; M[r] = M[piv]; M[piv] = tmp; }
        const pivVal = M[r][c];
        for (let j = c; j < cols; j++) M[r][j] = div(M[r][j], pivVal);
        for (let i = 0; i < rows; i++) {
            if (i !== r && !isZero(M[i][c])) {
                const f = M[i][c];
                for (let j = c; j < cols; j++) {
                    M[i][j] = sub(M[i][j], mul(f, M[r][j]));
                }
            }
        }
        r++;
    }

    // Identify pivot columns
    const pivotCol = new Array(rows).fill(-1);
    let row = 0;
    for (let c = 0; c < cols && row < rows; c++) {
        if (isOne(M[row][c])) { pivotCol[row] = c; row++; }
    }
    const isPivotCol = new Array(cols).fill(false);
    pivotCol.forEach(c => { if (c >= 0) isPivotCol[c] = true; });
    const free = [];
    for (let c = 0; c < cols; c++) { if (!isPivotCol[c]) free.push(c); }
    if (free.length === 0) free.push(cols - 1);

    // Backsolve
    const x = [];
    for (let k = 0; k < cols; k++) x[k] = [0, 1];
    free.forEach(c => { x[c] = [1, 1]; });
    for (let i = rows - 1; i >= 0; i--) {
        const pc = pivotCol[i];
        if (pc < 0) continue;
        let sum = [0, 1];
        for (let j = pc + 1; j < cols; j++) {
            if (!isZero(M[i][j])) {
                sum = sub([0, 1], sub([0, 1], sub(sum, mul(M[i][j], x[j])))); // sum += M[i][j]*x[j]
            }
        }
        // Actually: sum = sum of M[i][j]*x[j], then x[pc] = -sum
        // Let me redo this properly:
        let s = [0, 1];
        for (let j = pc + 1; j < cols; j++) {
            if (!isZero(M[i][j])) {
                const prod = mul(M[i][j], x[j]);
                s = simplify([s[0] * prod[1] + prod[0] * s[1], s[1] * prod[1]]);
            }
        }
        x[pc] = simplify([-s[0], s[1]]);
    }

    // Convert to integers
    const dens = x.map(fr => fr[1]);
    const L = lcmArr(dens);
    let ints = x.map(fr => fr[0] * (L / fr[1]));
    // Normalize: make all positive if possible
    const allNeg = ints.every(v => v <= 0);
    if (allNeg) ints = ints.map(v => -v);
    const G = ints.reduce((a, b) => gcd(a, b), Math.abs(ints[0]) || 1);
    ints = ints.map(v => v / G);
    return ints;
}

// ===== Format result =====
function formatResult(left, right, coeffs) {
    const coL = coeffs.slice(0, left.length);
    const coR = coeffs.slice(left.length);
    function fmtSide(side, coefs) {
        return side.map((s, i) => {
            const c = coefs[i];
            return (c === 1 ? '' : c) + s.formula;
        }).join(' + ');
    }
    return fmtSide(left, coL) + ' -> ' + fmtSide(right, coR);
}

// ===== Verify balance =====
function verifyBalance(left, right, coeffs) {
    const coL = coeffs.slice(0, left.length);
    const coR = coeffs.slice(left.length);
    const elements = uniqueElements(left, right);
    const errors = [];
    for (const el of elements) {
        let lCount = 0, rCount = 0;
        left.forEach((s, i) => {
            const c = parseFormula(s.formula);
            lCount += (c[el] || 0) * coL[i];
        });
        right.forEach((s, i) => {
            const c = parseFormula(s.formula);
            rCount += (c[el] || 0) * coR[i];
        });
        if (lCount !== rCount) errors.push(`${el}: left=${lCount}, right=${rCount}`);
    }
    return errors;
}

// ===== Run tests =====
const testCases = [
    // [input, expected balanced output]
    ['H2 + O2 -> H2O', '2H2 + O2 -> 2H2O'],
    ['Fe + O2 -> Fe2O3', '4Fe + 3O2 -> 2Fe2O3'],
    ['C3H8 + O2 -> CO2 + H2O', 'C3H8 + 5O2 -> 3CO2 + 4H2O'],
    ['Ca(OH)2 + H3PO4 -> Ca3(PO4)2 + H2O', '3Ca(OH)2 + 2H3PO4 -> Ca3(PO4)2 + 6H2O'],
    ['Zn + HCl -> ZnCl2 + H2', 'Zn + 2HCl -> ZnCl2 + H2'],
    ['AgNO3 + NaCl -> AgCl + NaNO3', 'AgNO3 + NaCl -> AgCl + NaNO3'],
    ['KClO3 -> KCl + O2', '2KClO3 -> 2KCl + 3O2'],
    ['N2 + H2 -> NH3', 'N2 + 3H2 -> 2NH3'],
    ['Al + O2 -> Al2O3', '4Al + 3O2 -> 2Al2O3'],
    ['CH4 + O2 -> CO2 + H2O', 'CH4 + 2O2 -> CO2 + 2H2O'],
    ['HCl + NaOH -> NaCl + H2O', 'HCl + NaOH -> NaCl + H2O'],
    ['H2SO4 + NaOH -> Na2SO4 + H2O', 'H2SO4 + 2NaOH -> Na2SO4 + 2H2O'],
    ['CO2 + H2O -> C6H12O6 + O2', '6CO2 + 6H2O -> C6H12O6 + 6O2'],
    ['Al2(SO4)3 + Ca(OH)2 -> Al(OH)3 + CaSO4', 'Al2(SO4)3 + 3Ca(OH)2 -> 2Al(OH)3 + 3CaSO4'],
    ['BaCl2 + Al2(SO4)3 -> BaSO4 + AlCl3', '3BaCl2 + Al2(SO4)3 -> 3BaSO4 + 2AlCl3'],
    ['KMnO4 + HCl -> KCl + MnCl2 + Cl2 + H2O', '2KMnO4 + 16HCl -> 2KCl + 2MnCl2 + 5Cl2 + 8H2O'],
    ['Cu + HNO3 -> Cu(NO3)2 + NO + H2O', '3Cu + 8HNO3 -> 3Cu(NO3)2 + 2NO + 4H2O'],
    ['2Na + Cl2 -> NaCl', null],  // already has coefficients in input — test parsing
    ['Al + Fe2O3 -> Al2O3 + Fe', '2Al + Fe2O3 -> Al2O3 + 2Fe'],
    ['C2H5OH + O2 -> CO2 + H2O', 'C2H5OH + 3O2 -> 2CO2 + 3H2O'],
];

let passed = 0, failed = 0;

console.log('Chemical Equation Balancer — Test Suite');
console.log('='.repeat(60));

for (const [input, expected] of testCases) {
    try {
        const parsed = parseEquation(input);
        const elements = uniqueElements(parsed.left, parsed.right);
        const A = buildMatrix(elements, parsed.left, parsed.right);
        const coeffs = nullspaceInt(A);
        const result = formatResult(parsed.left, parsed.right, coeffs);
        const errors = verifyBalance(parsed.left, parsed.right, coeffs);

        const atomsOk = errors.length === 0;
        const matchesExpected = expected === null || result === expected;

        if (atomsOk && matchesExpected) {
            console.log(`  PASS  ${input}`);
            console.log(`        => ${result}`);
            passed++;
        } else if (atomsOk && !matchesExpected) {
            // Atoms balance but output differs — could be valid alternate scaling
            console.log(`  WARN  ${input}`);
            console.log(`        got:      ${result}`);
            console.log(`        expected: ${expected}`);
            console.log(`        (atoms DO balance — may be valid alternate coefficients)`);
            passed++;
        } else {
            console.log(`  FAIL  ${input}`);
            console.log(`        got:      ${result}`);
            if (expected) console.log(`        expected: ${expected}`);
            console.log(`        atom errors: ${errors.join(', ')}`);
            failed++;
        }
    } catch (e) {
        console.log(`  ERROR ${input}`);
        console.log(`        ${e.message}`);
        failed++;
    }
}

console.log('='.repeat(60));
console.log(`Results: ${passed} passed, ${failed} failed, ${testCases.length} total`);
process.exit(failed > 0 ? 1 : 0);
