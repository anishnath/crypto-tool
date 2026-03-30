#!/usr/bin/env node
/**
 * Test suite for Lewis Structure Generator
 * Validates: formula parsing, pattern detection (ring/chain/alcohol/ether/oxyacid),
 * bonding analysis (bond orders, lone pairs), and routing correctness.
 *
 * The core functions are extracted from lewis-structure-generator.jsp so we can
 * unit-test them headlessly in Node without a browser.
 */

var pass = 0, fail = 0;
var errors = [];

function assert(condition, msg) {
    if (condition) { pass++; }
    else { fail++; errors.push('FAIL: ' + msg); }
}

// ================================================================
// Extracted Lewis-structure logic (from lewis-structure-generator.jsp)
// ================================================================

var valenceElectrons = {
    'H': 1, 'He': 2,
    'Li': 1, 'Be': 2, 'B': 3, 'C': 4, 'N': 5, 'O': 6, 'F': 7, 'Ne': 8,
    'Na': 1, 'Mg': 2, 'Al': 3, 'Si': 4, 'P': 5, 'S': 6, 'Cl': 7, 'Ar': 8,
    'K': 1, 'Ca': 2, 'Ga': 3, 'Ge': 4, 'As': 5, 'Se': 6, 'Br': 7, 'Kr': 8,
    'Rb': 1, 'Sr': 2, 'In': 3, 'Sn': 4, 'Sb': 5, 'Te': 6, 'I': 7, 'Xe': 8,
    'M': 4, 'A': 4, 'X': 7, 'L': 7, 'E': 6, 'R': 1, 'G': 8
};

var genericSymbols = ['M', 'A', 'X', 'L', 'E', 'R', 'G'];

function getMaxBonds(el) {
    var expanded = {
        'P': 5, 'S': 6, 'Cl': 7, 'Br': 7, 'I': 7,
        'Xe': 8, 'Se': 6, 'Te': 6, 'As': 5
    };
    if (expanded[el] !== undefined) return expanded[el];
    var v = valenceElectrons[el];
    if (!v) return 4;
    if (v <= 4) return v;
    return 8 - v;
}

function parseMolecularFormula(formula) {
    formula = formula.replace(/[\u2080-\u2089]/g, function(ch) {
        return String(ch.charCodeAt(0) - 0x2080);
    });
    formula = formula.replace(/[\u2070\u00B9\u00B2\u00B3\u2074-\u2079]/g, function(ch) {
        var map = {'\u2070':'0','\u00B9':'1','\u00B2':'2','\u00B3':'3',
            '\u2074':'4','\u2075':'5','\u2076':'6','\u2077':'7',
            '\u2078':'8','\u2079':'9'};
        return map[ch] || ch;
    });
    formula = formula.replace(/[\u207A\u207B\u2212+\-]+$/, '');
    var atoms = {};
    var regex = /([A-Z][a-z]?)(\d*)/g;
    var match;
    while ((match = regex.exec(formula)) !== null) {
        var element = match[1];
        var count = match[2] ? parseInt(match[2]) : 1;
        atoms[element] = (atoms[element] || 0) + count;
    }
    return atoms;
}

function detectOxyacid(atoms, centralAtom) {
    var oxyacidCenters = ['N', 'P', 'S', 'Cl', 'Br', 'I', 'Se', 'Te', 'As', 'C'];
    var numH = atoms['H'] || 0;
    var numO = atoms['O'] || 0;
    var nonHOFCenters = Object.keys(atoms).filter(function(el) {
        return el !== 'H' && el !== 'O' && el !== 'F' && (atoms[el] || 0) > 0;
    });
    return numH >= 1 && numO >= 2 &&
        centralAtom !== 'H' && centralAtom !== 'O' && centralAtom !== 'F' &&
        (atoms[centralAtom] || 0) === 1 &&
        nonHOFCenters.length === 1 &&
        oxyacidCenters.indexOf(centralAtom) !== -1 &&
        numH <= numO;
}

function detectAlcohol(atoms) {
    var c = atoms['C'] || 0;
    var h = atoms['H'] || 0;
    var o = atoms['O'] || 0;
    return c >= 1 && o === 1 && h >= 1 &&
        (atoms['C'] || 0) >= 1 && (atoms['O'] || 0) === 1 &&
        Object.keys(atoms).length === 3 &&
        h === (2 * c + 2);
}

function detectEther(formulaRaw) {
    if (!formulaRaw) return false;
    var normalized = formulaRaw.replace(/\s+/g, '');
    normalized = normalized.replace(/[\u2080-\u2089]/g, function(ch) {
        return String(ch.charCodeAt(0) - 0x2080);
    });
    normalized = normalized.replace(/[\u207A\u207B\u2212+\-]+$/, '');
    return /C[0-9H]+O[0-9H]*C(?![a-z])/.test(normalized);
}

function detectRing(atoms) {
    if (!atoms['C']) return false;
    var elementKeys = Object.keys(atoms).filter(function(el) { return atoms[el] > 0; });
    for (var i = 0; i < elementKeys.length; i++) {
        if (elementKeys[i] !== 'C' && elementKeys[i] !== 'H') return false;
    }
    var numC = atoms['C'] || 0;
    var numH = atoms['H'] || 0;
    return (numC >= 3 && numH === 2 * numC) ||
        (numC >= 6 && numH === numC) ||
        (numC >= 3 && numH === 2 * numC - 2);
}

function analyzeBonding(atoms, centralAtom, totalValence) {
    if (centralAtom === 'N' &&
        (atoms['N'] || 0) === 1 &&
        (atoms['O'] || 0) === 2 &&
        Object.keys(atoms).length === 2 &&
        totalValence === 17) {
        return {
            peripherals: ['O', 'O'],
            bondOrders: [2, 1],
            peripheralLonePairs: [2, 3],
            centralLonePairs: 0,
            hasResonance: true,
            isRadical: true,
            unpairedElectrons: 1
        };
    }
    var peripherals = [];
    for (var el in atoms) {
        if (el === centralAtom && atoms[el] === 1) continue;
        var count = (el === centralAtom) ? atoms[el] - 1 : atoms[el];
        for (var i = 0; i < count; i++) peripherals.push(el);
    }
    var bondOrders = [];
    for (var i = 0; i < peripherals.length; i++) bondOrders.push(1);
    var usedE = peripherals.length * 2;
    var remaining = totalValence - usedE;
    var pLonePairs = [];
    for (var i = 0; i < peripherals.length; i++) pLonePairs.push(0);
    for (var i = 0; i < peripherals.length; i++) {
        var need = (peripherals[i] === 'H') ? 0 : 3;
        var canGive = Math.min(need, Math.floor(remaining / 2));
        pLonePairs[i] = canGive;
        remaining -= canGive * 2;
    }
    var centralE = 0;
    for (var i = 0; i < bondOrders.length; i++) centralE += bondOrders[i] * 2;
    var cLonePairs = 0;
    var electronDeficient = ['B', 'Be', 'Al'];
    var centralTarget = (centralAtom === 'H') ? 2 :
        (electronDeficient.indexOf(centralAtom) !== -1) ? centralE : 8;
    while (centralE + cLonePairs * 2 < centralTarget && remaining >= 2) {
        cLonePairs++;
        remaining -= 2;
    }
    var centralTotal = centralE + cLonePairs * 2;
    while (centralTotal < centralTarget) {
        var bestIdx = -1;
        var bestPairs = 0;
        for (var i = 0; i < peripherals.length; i++) {
            if (pLonePairs[i] > 0 && peripherals[i] !== 'H' && bondOrders[i] < 3) {
                if (pLonePairs[i] > bestPairs) {
                    bestPairs = pLonePairs[i];
                    bestIdx = i;
                }
            }
        }
        if (bestIdx === -1) break;
        pLonePairs[bestIdx]--;
        bondOrders[bestIdx]++;
        centralTotal += 2;
    }
    var expandedEls = ['P', 'S', 'Cl', 'Br', 'I', 'Xe', 'Se', 'Te', 'As'];
    if (remaining > 0 && expandedEls.indexOf(centralAtom) !== -1) {
        var extraPairs = Math.floor(remaining / 2);
        cLonePairs += extraPairs;
        remaining -= extraPairs * 2;
    }
    var hasResonance = false;
    var elOrders = {};
    for (var i = 0; i < peripherals.length; i++) {
        if (!elOrders[peripherals[i]]) elOrders[peripherals[i]] = [];
        elOrders[peripherals[i]].push(bondOrders[i]);
    }
    for (var el in elOrders) {
        var orders = elOrders[el];
        if (orders.length > 1) {
            for (var j = 1; j < orders.length; j++) {
                if (orders[j] !== orders[0]) { hasResonance = true; break; }
            }
        }
        if (hasResonance) break;
    }
    return {
        peripherals: peripherals,
        bondOrders: bondOrders,
        peripheralLonePairs: pLonePairs,
        centralLonePairs: cLonePairs,
        hasResonance: hasResonance,
        isRadical: (totalValence % 2 !== 0),
        unpairedElectrons: remaining
    };
}

function analyzeChainBonding(backbone, termsPerAtom, totalValence) {
    var bbBonds = backbone.length - 1;
    var termBonds = 0;
    for (var i = 0; i < termsPerAtom.length; i++) termBonds += termsPerAtom[i].length;
    var remaining = totalValence - (bbBonds + termBonds) * 2;
    var termBondOrders = [];
    for (var i = 0; i < termsPerAtom.length; i++) {
        var arr = [];
        for (var t = 0; t < termsPerAtom[i].length; t++) arr.push(1);
        termBondOrders.push(arr);
    }
    var termLonePairs = [];
    for (var i = 0; i < termsPerAtom.length; i++) {
        var arr = [];
        for (var t = 0; t < termsPerAtom[i].length; t++) {
            var need = (termsPerAtom[i][t] === 'H') ? 0 : 3;
            var canGive = Math.min(need, Math.floor(remaining / 2));
            arr.push(canGive);
            remaining -= canGive * 2;
        }
        termLonePairs.push(arr);
    }
    var bbLonePairs = [];
    for (var i = 0; i < backbone.length; i++) bbLonePairs.push(0);
    for (var i = 0; i < backbone.length; i++) {
        var bondCount = (i > 0 ? 1 : 0) + (i < backbone.length - 1 ? 1 : 0) + termsPerAtom[i].length;
        var atomE = bondCount * 2;
        var target = (backbone[i] === 'H') ? 2 : 8;
        var needed = Math.max(0, Math.floor((target - atomE) / 2));
        var canGive = Math.min(needed, Math.floor(remaining / 2));
        bbLonePairs[i] = canGive;
        remaining -= canGive * 2;
    }
    var expandedEls = ['P', 'S', 'Cl', 'Br', 'I', 'Xe', 'Se', 'Te', 'As'];
    while (remaining >= 2) {
        var bestIdx = -1, maxBonds = -1;
        for (var i = 0; i < backbone.length; i++) {
            if (expandedEls.indexOf(backbone[i]) === -1) continue;
            var bCnt = (i > 0 ? 1 : 0) + (i < backbone.length - 1 ? 1 : 0) + termsPerAtom[i].length;
            if (bCnt > maxBonds) { maxBonds = bCnt; bestIdx = i; }
        }
        if (bestIdx === -1) break;
        bbLonePairs[bestIdx]++;
        remaining -= 2;
    }
    var bbBondOrders = [];
    for (var i = 0; i < Math.max(0, backbone.length - 1); i++) bbBondOrders.push(1);
    for (var pass = 0; pass < 3; pass++) {
        for (var i = 0; i < backbone.length; i++) {
            var myBondE = 0;
            if (i > 0) myBondE += bbBondOrders[i - 1] * 2;
            if (i < backbone.length - 1) myBondE += bbBondOrders[i] * 2;
            for (var ti = 0; ti < termBondOrders[i].length; ti++) myBondE += termBondOrders[i][ti] * 2;
            var atomE = myBondE + bbLonePairs[i] * 2;
            var target = (backbone[i] === 'H') ? 2 : 8;
            while (atomE < target) {
                var increased = false;
                if (i > 0 && bbLonePairs[i - 1] > 0 && bbBondOrders[i - 1] < 3) {
                    bbLonePairs[i - 1]--;
                    bbBondOrders[i - 1]++;
                    atomE += 2;
                    increased = true;
                }
                if (!increased && i < backbone.length - 1 && bbLonePairs[i + 1] > 0 && bbBondOrders[i] < 3) {
                    bbLonePairs[i + 1]--;
                    bbBondOrders[i]++;
                    atomE += 2;
                    increased = true;
                }
                if (!increased) {
                    for (var ti = 0; ti < termsPerAtom[i].length; ti++) {
                        var maxTermBond = getMaxBonds(termsPerAtom[i][ti]);
                        if (termsPerAtom[i][ti] !== 'H' &&
                            termLonePairs[i][ti] > 0 &&
                            termBondOrders[i][ti] < maxTermBond) {
                            termLonePairs[i][ti]--;
                            termBondOrders[i][ti]++;
                            atomE += 2;
                            increased = true;
                            break;
                        }
                    }
                }
                if (!increased) break;
            }
        }
    }
    function atomTarget(idx) {
        return (backbone[idx] === 'H') ? 2 : 8;
    }
    function atomElectronCount(idx) {
        var e = bbLonePairs[idx] * 2;
        if (idx > 0) e += bbBondOrders[idx - 1] * 2;
        if (idx < backbone.length - 1) e += bbBondOrders[idx] * 2;
        for (var ti = 0; ti < termBondOrders[idx].length; ti++) e += termBondOrders[idx][ti] * 2;
        return e;
    }
    var changed = true;
    var guard = 0;
    while (changed && guard < 8) {
        changed = false;
        guard++;
        for (var bi = 0; bi < bbBondOrders.length; bi++) {
            if (bbBondOrders[bi] >= 3) continue;
            var leftE = atomElectronCount(bi);
            var rightE = atomElectronCount(bi + 1);
            if (leftE < atomTarget(bi) && rightE < atomTarget(bi + 1)) {
                bbBondOrders[bi]++;
                changed = true;
            }
        }
    }
    return {
        bbBondOrders: bbBondOrders,
        bbLonePairs: bbLonePairs,
        termLonePairs: termLonePairs,
        termBondOrders: termBondOrders
    };
}

// ---------- Routing logic (mirrors generateLewis decision tree) ----------

function resolveStructureType(formula) {
    var atoms = parseMolecularFormula(formula);
    var totalValence = 0;
    for (var el in atoms) {
        if (!valenceElectrons[el]) return { error: 'Unknown element: ' + el };
        totalValence += valenceElectrons[el] * atoms[el];
    }
    var atomKeys = Object.keys(atoms);
    var centralAtom = atomKeys.find(function(a) { return a !== 'H' && a !== 'F'; }) || atomKeys[0];
    var centralCount = atoms[centralAtom] || 0;

    var isOxyacid = detectOxyacid(atoms, centralAtom);
    var isEther = detectEther(formula);
    var isAlcohol = !isEther && detectAlcohol(atoms);
    var isRing = detectRing(atoms);
    var isChain = !isOxyacid && !isAlcohol && !isEther && !isRing && centralCount >= 2;

    var type;
    if (isOxyacid) type = 'oxyacid';
    else if (isAlcohol) type = 'alcohol';
    else if (isEther) type = 'ether';
    else if (isRing) type = 'ring';
    else if (isChain) type = 'chain';
    else type = 'star';

    return {
        type: type,
        atoms: atoms,
        centralAtom: centralAtom,
        totalValence: totalValence
    };
}

// Build backbone + termsPerAtom the same way generateLewis does for chain/alcohol/ether/ring
function buildStructure(formula) {
    var info = resolveStructureType(formula);
    if (info.error) return info;

    var atoms = info.atoms;
    var centralAtom = info.centralAtom;
    var totalValence = info.totalValence;
    var backbone, termsPerAtom, bonding;

    if (info.type === 'alcohol') {
        backbone = [];
        var numC = atoms['C'] || 0;
        for (var k = 0; k < numC; k++) backbone.push('C');
        backbone.push('O');
        termsPerAtom = [];
        for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);
        var numH = atoms['H'] || 0;
        termsPerAtom[backbone.length - 1].push('H');
        numH--;
        for (var k = 0; k < numC && numH > 0; k++) {
            var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
            var maxH = 4 - bbBonds;
            var give = Math.min(maxH, numH);
            for (var h = 0; h < give; h++) termsPerAtom[k].push('H');
            numH -= give;
        }
        bonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);

    } else if (info.type === 'ether') {
        var numC = atoms['C'] || 0;
        var halfC = Math.floor(numC / 2);
        backbone = [];
        for (var k = 0; k < halfC; k++) backbone.push('C');
        backbone.push('O');
        for (var k = 0; k < numC - halfC; k++) backbone.push('C');
        termsPerAtom = [];
        for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);
        var numH = atoms['H'] || 0;
        for (var k = 0; k < backbone.length && numH > 0; k++) {
            if (backbone[k] === 'O') continue;
            var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
            var maxH = 4 - bbBonds;
            var give = Math.min(maxH, numH);
            for (var h = 0; h < give; h++) termsPerAtom[k].push('H');
            numH -= give;
        }
        bonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);

    } else if (info.type === 'ring') {
        var numC = atoms['C'] || 0;
        backbone = [];
        for (var k = 0; k < numC; k++) backbone.push('C');
        termsPerAtom = [];
        for (var k = 0; k < numC; k++) termsPerAtom.push([]);
        var numH = atoms['H'] || 0;
        var hPerC = Math.floor(numH / numC);
        var extraH = numH % numC;
        for (var k = 0; k < numC; k++) {
            var give = hPerC + (k < extraH ? 1 : 0);
            for (var h = 0; h < give; h++) termsPerAtom[k].push('H');
        }
        // NOTE: ring path ignores non-C/H atoms entirely

    } else if (info.type === 'chain') {
        var centralCount = atoms[centralAtom] || 0;
        backbone = [];
        for (var k = 0; k < centralCount; k++) backbone.push(centralAtom);
        var allTerminals = [];
        for (var el in atoms) {
            if (el === centralAtom) continue;
            for (var k = 0; k < atoms[el]; k++) allTerminals.push(el);
        }
        termsPerAtom = [];
        for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);
        var remaining = allTerminals.slice();
        var capacities = [];
        for (var k = 0; k < backbone.length; k++) {
            var bbBonds = (k > 0 ? 1 : 0) + (k < backbone.length - 1 ? 1 : 0);
            capacities[k] = Math.max(0, getMaxBonds(backbone[k]) - bbBonds);
        }
        var idx = 0;
        while (remaining.length > 0) {
            var assigned = false;
            for (var tries = 0; tries < backbone.length; tries++) {
                var target = (idx + tries) % backbone.length;
                if (capacities[target] > 0) {
                    termsPerAtom[target].push(remaining.shift());
                    capacities[target]--;
                    idx = (target + 1) % backbone.length;
                    assigned = true;
                    break;
                }
            }
            if (!assigned) break;
        }
        if (remaining.length > 0) {
            termsPerAtom[backbone.length - 1] = termsPerAtom[backbone.length - 1].concat(remaining);
        }
        bonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);

    } else if (info.type === 'oxyacid') {
        // Oxyacid routing — we don't replicate full oxyacid bonding here,
        // just return enough to validate routing and atom counts
        return {
            type: 'oxyacid',
            centralAtom: centralAtom,
            atoms: atoms,
            totalValence: totalValence
        };

    } else if (info.type === 'star') {
        bonding = analyzeBonding(atoms, centralAtom, totalValence);
        return {
            type: 'star',
            centralAtom: centralAtom,
            atoms: atoms,
            totalValence: totalValence,
            bonding: bonding
        };
    }

    return {
        type: info.type,
        centralAtom: centralAtom,
        atoms: atoms,
        totalValence: totalValence,
        backbone: backbone,
        termsPerAtom: termsPerAtom,
        bonding: bonding
    };
}

// Helper: count total atoms placed in the structure
function countPlacedAtoms(result) {
    if (result.type === 'star') {
        return 1 + result.bonding.peripherals.length; // central + peripherals (H not separated)
    }
    if (result.type === 'oxyacid') {
        // Oxyacid: central + O atoms + H atoms (H bonded to O in OH groups)
        var atoms = result.atoms;
        var total = 0;
        for (var el in atoms) total += atoms[el];
        return total;
    }
    if (!result.backbone) return -1; // unknown structure
    var count = result.backbone.length;
    for (var i = 0; i < result.termsPerAtom.length; i++) {
        count += result.termsPerAtom[i].length;
    }
    return count;
}

function totalAtomsFromFormula(atoms) {
    var total = 0;
    for (var el in atoms) total += atoms[el];
    return total;
}

// Helper: count total valence electrons accounted for in bonding result
function countElectronsUsed(result) {
    if (result.type === 'star') {
        var b = result.bonding;
        var e = 0;
        for (var i = 0; i < b.bondOrders.length; i++) e += b.bondOrders[i] * 2;
        for (var i = 0; i < b.peripheralLonePairs.length; i++) e += b.peripheralLonePairs[i] * 2;
        e += b.centralLonePairs * 2;
        e += (b.unpairedElectrons || 0);
        return e;
    }
    if (!result.bonding) return -1; // ring without bonding analysis in this test
    var b = result.bonding;
    var e = 0;
    // Backbone bonds
    for (var i = 0; i < b.bbBondOrders.length; i++) e += b.bbBondOrders[i] * 2;
    // Terminal bonds
    for (var i = 0; i < b.termBondOrders.length; i++) {
        for (var j = 0; j < b.termBondOrders[i].length; j++) {
            e += b.termBondOrders[i][j] * 2;
        }
    }
    // Backbone lone pairs
    for (var i = 0; i < b.bbLonePairs.length; i++) e += b.bbLonePairs[i] * 2;
    // Terminal lone pairs
    for (var i = 0; i < b.termLonePairs.length; i++) {
        for (var j = 0; j < b.termLonePairs[i].length; j++) {
            e += b.termLonePairs[i][j] * 2;
        }
    }
    return e;
}


// ================================================================
// TEST 1: Formula Parser
// ================================================================
console.log('\n=== TEST 1: Formula Parser ===');
var parserTests = [
    { input: 'H2O', expected: { H: 2, O: 1 } },
    { input: 'CO2', expected: { C: 1, O: 2 } },
    { input: 'CH4', expected: { C: 1, H: 4 } },
    { input: 'C2H6', expected: { C: 2, H: 6 } },
    { input: 'C3H8', expected: { C: 3, H: 8 } },
    { input: 'C6H6', expected: { C: 6, H: 6 } },
    { input: 'H2SO4', expected: { H: 2, S: 1, O: 4 } },
    { input: 'C3H6O', expected: { C: 3, H: 6, O: 1 } },
    { input: 'CH3OCH3', expected: { C: 2, H: 6, O: 1 } },
    { input: 'NH3', expected: { N: 1, H: 3 } },
    { input: 'PCl5', expected: { P: 1, Cl: 5 } },
    { input: 'SF6', expected: { S: 1, F: 6 } },
    { input: 'XeF2', expected: { Xe: 1, F: 2 } },
];

parserTests.forEach(function(t) {
    var result = parseMolecularFormula(t.input);
    var match = JSON.stringify(result) === JSON.stringify(t.expected);
    assert(match, 'parse "' + t.input + '": got ' + JSON.stringify(result) + ', expected ' + JSON.stringify(t.expected));
});


// ================================================================
// TEST 2: Valence Electron Counts
// ================================================================
console.log('\n=== TEST 2: Total Valence Electrons ===');
var valenceTests = [
    { formula: 'H2O',    expected: 8 },
    { formula: 'CO2',    expected: 16 },
    { formula: 'CH4',    expected: 8 },
    { formula: 'NH3',    expected: 8 },
    { formula: 'O2',     expected: 12 },
    { formula: 'N2',     expected: 10 },
    { formula: 'HCN',    expected: 10 },
    { formula: 'C2H6',   expected: 14 },
    { formula: 'C2H4',   expected: 12 },
    { formula: 'C2H2',   expected: 10 },
    { formula: 'C3H6O',  expected: 24 },
    { formula: 'C3H8',   expected: 20 },
    { formula: 'H2SO4',  expected: 32 },
    { formula: 'SF6',    expected: 48 },
    { formula: 'PCl5',   expected: 40 },
    { formula: 'XeF2',   expected: 22 },
    { formula: 'C6H6',   expected: 30 },
    { formula: 'NO2',    expected: 17 },
];

valenceTests.forEach(function(t) {
    var atoms = parseMolecularFormula(t.formula);
    var total = 0;
    for (var el in atoms) total += valenceElectrons[el] * atoms[el];
    assert(total === t.expected,
        t.formula + ' valence: got ' + total + ', expected ' + t.expected);
});


// ================================================================
// TEST 3: Pattern Detection — Structure Type Routing
// ================================================================
console.log('\n=== TEST 3: Structure Type Routing ===');
var routingTests = [
    // Simple star molecules
    { formula: 'H2O',   expectedType: 'star' },
    { formula: 'CO2',   expectedType: 'star' },
    { formula: 'NH3',   expectedType: 'star' },
    { formula: 'CH4',   expectedType: 'star' },
    { formula: 'BF3',   expectedType: 'star' },
    { formula: 'SF6',   expectedType: 'star' },
    { formula: 'PCl5',  expectedType: 'star' },
    { formula: 'XeF2',  expectedType: 'star' },
    { formula: 'HCN',   expectedType: 'star' },
    { formula: 'NO2',   expectedType: 'star' },
    { formula: 'SO2',   expectedType: 'star' },
    { formula: 'O3',    expectedType: 'chain' },  // O-O-O chain (centralAtom=O, count=3)
    { formula: 'CCl4',  expectedType: 'star' },

    // Chains
    { formula: 'C2H6',  expectedType: 'chain' },
    { formula: 'C3H8',  expectedType: 'chain' },
    { formula: 'C2H4',  expectedType: 'chain' },
    { formula: 'C2H2',  expectedType: 'chain' },

    // Alcohols (CnH(2n+2)O)
    { formula: 'CH4O',     expectedType: 'alcohol' },  // methanol
    { formula: 'C2H6O',   expectedType: 'alcohol' },  // ethanol

    // Ethers (explicit connectivity)
    { formula: 'CH3OCH3', expectedType: 'ether' },

    // Oxyacids
    { formula: 'H2SO4',   expectedType: 'oxyacid' },
    { formula: 'HNO3',    expectedType: 'oxyacid' },
    { formula: 'H3PO4',   expectedType: 'oxyacid' },
    { formula: 'H2CO3',   expectedType: 'oxyacid' },

    // Rings
    { formula: 'C3H6',  expectedType: 'ring' },   // cyclopropane
    { formula: 'C5H10', expectedType: 'ring' },   // cyclopentane
    { formula: 'C6H6',  expectedType: 'ring' },   // benzene
    { formula: 'C6H12', expectedType: 'ring' },   // cyclohexane

    // C3H6O was previously misdetected as ring (oxygen dropped) — now fixed
    { formula: 'C3H6O', expectedType: 'chain' },  // acetone — should be chain
];

routingTests.forEach(function(t) {
    var info = resolveStructureType(t.formula);
    assert(info.type === t.expectedType,
        t.formula + ' routing: got "' + info.type + '", expected "' + t.expectedType + '"');
});


// ================================================================
// TEST 4: Star Molecule Bonding Analysis
// ================================================================
console.log('\n=== TEST 4: Star Molecule Bonding ===');
var starTests = [
    // { formula, centralAtom, bondOrders, centralLP, peripheralLP }
    { formula: 'H2O', central: 'O', bondOrders: [1, 1], centralLP: 2, totalE: 8 },
    { formula: 'CO2', central: 'C', bondOrders: [2, 2], centralLP: 0, totalE: 16 },
    { formula: 'NH3', central: 'N', bondOrders: [1, 1, 1], centralLP: 1, totalE: 8 },
    { formula: 'CH4', central: 'C', bondOrders: [1, 1, 1, 1], centralLP: 0, totalE: 8 },
    { formula: 'BF3', central: 'B', bondOrders: [1, 1, 1], centralLP: 0, totalE: 24 },
    { formula: 'CCl4', central: 'C', bondOrders: [1, 1, 1, 1], centralLP: 0, totalE: 32 },
    { formula: 'SO2', central: 'S', bondOrders: [2, 1], centralLP: 1, totalE: 18 },
    { formula: 'HCN', central: 'C', bondOrders: [1, 3], centralLP: 0, totalE: 10 },
    { formula: 'PCl5', central: 'P', bondOrders: [1, 1, 1, 1, 1], centralLP: 0, totalE: 40 },
    { formula: 'SF6', central: 'S', bondOrders: [1, 1, 1, 1, 1, 1], centralLP: 0, totalE: 48 },
    { formula: 'XeF2', central: 'Xe', bondOrders: [1, 1], centralLP: 3, totalE: 22 },
];

starTests.forEach(function(t) {
    var result = buildStructure(t.formula);
    assert(result.type === 'star',
        t.formula + ' is star type');
    if (result.type !== 'star') return;

    assert(result.centralAtom === t.central,
        t.formula + ' central: got "' + result.centralAtom + '", expected "' + t.central + '"');

    var bo = result.bonding.bondOrders;
    // Sort both for comparison (peripheral order may vary)
    var gotOrders = bo.slice().sort().join(',');
    var expectOrders = t.bondOrders.slice().sort().join(',');
    assert(gotOrders === expectOrders,
        t.formula + ' bond orders: got [' + gotOrders + '], expected [' + expectOrders + ']');

    assert(result.bonding.centralLonePairs === t.centralLP,
        t.formula + ' central LP: got ' + result.bonding.centralLonePairs + ', expected ' + t.centralLP);

    var used = countElectronsUsed(result);
    assert(used === t.totalE,
        t.formula + ' electron count: got ' + used + ', expected ' + t.totalE);
});


// ================================================================
// TEST 5: Chain Molecule Bonding
// ================================================================
console.log('\n=== TEST 5: Chain Molecule Bonding ===');
var chainTests = [
    {
        formula: 'C2H6', // ethane
        backbone: ['C', 'C'],
        bbBondOrders: [1],
        totalE: 14
    },
    {
        formula: 'C2H4', // ethylene
        backbone: ['C', 'C'],
        bbBondOrders: [2],
        totalE: 12
    },
    {
        formula: 'C2H2', // acetylene
        backbone: ['C', 'C'],
        bbBondOrders: [3],
        totalE: 10
    },
    {
        formula: 'C3H8', // propane
        backbone: ['C', 'C', 'C'],
        bbBondOrders: [1, 1],
        totalE: 20
    },
];

chainTests.forEach(function(t) {
    var result = buildStructure(t.formula);
    assert(result.type === 'chain',
        t.formula + ' is chain type');
    if (result.type !== 'chain') return;

    assert(JSON.stringify(result.backbone) === JSON.stringify(t.backbone),
        t.formula + ' backbone: got ' + JSON.stringify(result.backbone) + ', expected ' + JSON.stringify(t.backbone));

    assert(JSON.stringify(result.bonding.bbBondOrders) === JSON.stringify(t.bbBondOrders),
        t.formula + ' bb bond orders: got ' + JSON.stringify(result.bonding.bbBondOrders) +
        ', expected ' + JSON.stringify(t.bbBondOrders));

    var used = countElectronsUsed(result);
    assert(used === t.totalE,
        t.formula + ' electron count: got ' + used + ', expected ' + t.totalE);
});


// ================================================================
// TEST 6: Alcohol Bonding
// ================================================================
console.log('\n=== TEST 6: Alcohol Bonding ===');
var alcoholTests = [
    {
        formula: 'CH4O', // methanol
        backbone: ['C', 'O'],
        bbBondOrders: [1],
        totalE: 14
    },
    {
        formula: 'C2H6O', // ethanol
        backbone: ['C', 'C', 'O'],
        bbBondOrders: [1, 1],
        totalE: 20
    },
];

alcoholTests.forEach(function(t) {
    var result = buildStructure(t.formula);
    assert(result.type === 'alcohol',
        t.formula + ' is alcohol type');
    if (result.type !== 'alcohol') return;

    assert(JSON.stringify(result.backbone) === JSON.stringify(t.backbone),
        t.formula + ' backbone: got ' + JSON.stringify(result.backbone) + ', expected ' + JSON.stringify(t.backbone));

    assert(JSON.stringify(result.bonding.bbBondOrders) === JSON.stringify(t.bbBondOrders),
        t.formula + ' bb bond orders: got ' + JSON.stringify(result.bonding.bbBondOrders) +
        ', expected ' + JSON.stringify(t.bbBondOrders));

    var used = countElectronsUsed(result);
    assert(used === t.totalE,
        t.formula + ' electron count: got ' + used + ', expected ' + t.totalE);
});


// ================================================================
// TEST 7: Ether Detection
// ================================================================
console.log('\n=== TEST 7: Ether Detection ===');
var etherTests = [
    { formula: 'CH3OCH3',     expectedType: 'ether', backbone: ['C', 'O', 'C'] },
    { formula: 'C2H5OC2H5',   expectedType: 'ether', backbone: ['C', 'C', 'O', 'C', 'C'] },
];

etherTests.forEach(function(t) {
    var result = buildStructure(t.formula);
    assert(result.type === t.expectedType,
        t.formula + ' is ether type');
    if (result.type !== 'ether') return;
    assert(JSON.stringify(result.backbone) === JSON.stringify(t.backbone),
        t.formula + ' backbone: got ' + JSON.stringify(result.backbone) + ', expected ' + JSON.stringify(t.backbone));
});


// ================================================================
// TEST 8: Atom Conservation — No Atoms Dropped
// ================================================================
console.log('\n=== TEST 8: Atom Conservation ===');
var conservationTests = [
    'H2O', 'CO2', 'NH3', 'CH4', 'C2H6', 'C2H4', 'C3H8',
    'CH4O', 'C2H6O',       // alcohols
    'CH3OCH3',              // ether
    'C3H6',                 // cyclopropane (ring)
    'C6H6',                 // benzene (ring)
    'C6H12',                // cyclohexane (ring)
    'H2SO4',                // oxyacid
    'SF6', 'PCl5', 'XeF2', // star
    'BF3', 'CCl4', 'SO2',
    // Known bug candidates:
    'C3H6O',                // acetone — ring path drops O
    'C4H8O',                // butanone — ring path would drop O
    'C2H4O',                // acetaldehyde — ring path would drop O
];

conservationTests.forEach(function(formula) {
    var atoms = parseMolecularFormula(formula);
    var expectedTotal = totalAtomsFromFormula(atoms);
    var result = buildStructure(formula);
    if (result.error) {
        fail++;
        errors.push('FAIL: ' + formula + ' buildStructure error: ' + result.error);
        return;
    }
    var placed = countPlacedAtoms(result);
    assert(placed === expectedTotal,
        formula + ' atom conservation: placed ' + placed + '/' + expectedTotal + ' atoms (type=' + result.type + ')');
});


// ================================================================
// TEST 9: Electron Conservation — Total Electrons Accounted For
// ================================================================
console.log('\n=== TEST 9: Electron Conservation ===');
var electronTests = [
    'H2O', 'CO2', 'NH3', 'CH4', 'C2H6', 'C2H4', 'C2H2', 'C3H8',
    'CH4O', 'C2H6O',
    'SF6', 'PCl5', 'XeF2',
    'BF3', 'CCl4', 'SO2', 'HCN',
];

electronTests.forEach(function(formula) {
    var result = buildStructure(formula);
    if (result.error) return;
    var used = countElectronsUsed(result);
    if (used < 0) return; // ring without chain bonding
    assert(used === result.totalValence,
        formula + ' electron conservation: used ' + used + '/' + result.totalValence +
        ' (type=' + result.type + ')');
});


// ================================================================
// TEST 10: NO2 Radical Special Case
// ================================================================
console.log('\n=== TEST 10: NO2 Radical ===');
(function() {
    var result = buildStructure('NO2');
    assert(result.type === 'star', 'NO2 is star');
    if (result.type !== 'star') return;
    assert(result.bonding.isRadical === true, 'NO2 is radical');
    assert(result.bonding.unpairedElectrons === 1, 'NO2 has 1 unpaired electron');
    assert(result.bonding.hasResonance === true, 'NO2 has resonance');
    var bo = result.bonding.bondOrders.slice().sort().join(',');
    assert(bo === '1,2', 'NO2 bond orders: got [' + bo + '], expected [1,2]');
})();


// ================================================================
// TEST 11: detectRing False Positives (Known Bug Area)
// ================================================================
console.log('\n=== TEST 11: detectRing False Positives ===');
var ringFalsePositives = [
    // These have C:H ratio matching CnH2n but contain other atoms
    // detectRing should ideally return false for these
    { formula: 'C3H6O',  hasOtherAtoms: true, label: 'acetone/propanal' },
    { formula: 'C4H8O',  hasOtherAtoms: true, label: 'butanone' },
    { formula: 'C2H4O',  hasOtherAtoms: true, label: 'acetaldehyde' },
    { formula: 'C3H6Cl2', hasOtherAtoms: true, label: 'dichloropropane' },
    { formula: 'C6H6O',  hasOtherAtoms: true, label: 'phenol (CnHn but has O)' },
];

ringFalsePositives.forEach(function(t) {
    var atoms = parseMolecularFormula(t.formula);
    var result = detectRing(atoms);
    // Currently these are bugs — detectRing returns true
    // We log the status so we know what to fix
    if (result && t.hasOtherAtoms) {
        fail++;
        errors.push('BUG: detectRing("' + t.formula + '") = true but molecule has non-C/H atoms (' + t.label + '). Oxygen/halogen will be silently dropped.');
    } else {
        pass++;
    }
});


// ================================================================
// TEST 12: Octet Rule Compliance (star molecules)
// ================================================================
console.log('\n=== TEST 12: Octet Rule Compliance ===');
var octetTests = [
    'H2O', 'CO2', 'NH3', 'CH4', 'HCN', 'SO2', 'O3',
];

octetTests.forEach(function(formula) {
    var result = buildStructure(formula);
    if (result.type !== 'star') return;
    var b = result.bonding;
    // Check central atom octet
    var centralE = b.centralLonePairs * 2;
    for (var i = 0; i < b.bondOrders.length; i++) centralE += b.bondOrders[i] * 2;
    var target = (result.centralAtom === 'H') ? 2 : 8;
    assert(centralE === target,
        formula + ' central ' + result.centralAtom + ' octet: got ' + centralE + 'e, expected ' + target);

    // Check peripheral atom octets (H=2, others=8)
    for (var i = 0; i < b.peripherals.length; i++) {
        var pTarget = (b.peripherals[i] === 'H') ? 2 : 8;
        var pE = b.bondOrders[i] * 2 + b.peripheralLonePairs[i] * 2;
        assert(pE === pTarget,
            formula + ' peripheral ' + b.peripherals[i] + '[' + i + '] octet: got ' + pE + 'e, expected ' + pTarget);
    }
});


// ================================================================
// TEST 13: Chain Octet Compliance
// ================================================================
console.log('\n=== TEST 13: Chain Octet Compliance ===');
var chainOctetTests = ['C2H6', 'C2H4', 'C2H2', 'C3H8'];

chainOctetTests.forEach(function(formula) {
    var result = buildStructure(formula);
    if (result.type !== 'chain' || !result.bonding) return;
    var b = result.bonding;
    var bb = result.backbone;

    for (var i = 0; i < bb.length; i++) {
        var e = b.bbLonePairs[i] * 2;
        if (i > 0) e += b.bbBondOrders[i - 1] * 2;
        if (i < bb.length - 1) e += b.bbBondOrders[i] * 2;
        for (var ti = 0; ti < b.termBondOrders[i].length; ti++) {
            e += b.termBondOrders[i][ti] * 2;
        }
        var target = (bb[i] === 'H') ? 2 : 8;
        assert(e === target,
            formula + ' backbone ' + bb[i] + '[' + i + '] octet: got ' + e + 'e, expected ' + target);
    }
});


// ================================================================
// TEST 14: fullMoleculePool — Practice Worksheet Molecules
// Validates all 82 molecules from the practice sheet render without
// dropping atoms or crashing.
// ================================================================
console.log('\n=== TEST 14: fullMoleculePool (82 molecules) ===');
var fullMoleculePool = [
    { formula: 'H\u2082O', name: 'Water' },
    { formula: 'CO\u2082', name: 'Carbon Dioxide' },
    { formula: 'NH\u2083', name: 'Ammonia' },
    { formula: 'CH\u2084', name: 'Methane' },
    { formula: 'O\u2082', name: 'Oxygen' },
    { formula: 'N\u2082', name: 'Nitrogen' },
    { formula: 'HCN', name: 'Hydrogen Cyanide' },
    { formula: 'SO\u2082', name: 'Sulfur Dioxide' },
    { formula: 'CCl\u2084', name: 'Carbon Tetrachloride' },
    { formula: 'BF\u2083', name: 'Boron Trifluoride' },
    { formula: 'PCl\u2085', name: 'Phosphorus Pentachloride' },
    { formula: 'SF\u2086', name: 'Sulfur Hexafluoride' },
    { formula: 'F\u2082', name: 'Fluorine' },
    { formula: 'Cl\u2082', name: 'Chlorine' },
    { formula: 'HCl', name: 'Hydrogen Chloride' },
    { formula: 'HF', name: 'Hydrogen Fluoride' },
    { formula: 'H\u2082S', name: 'Hydrogen Sulfide' },
    { formula: 'BeCl\u2082', name: 'Beryllium Chloride' },
    { formula: 'O\u2083', name: 'Ozone' },
    { formula: 'C\u2082H\u2082', name: 'Acetylene' },
    { formula: 'C\u2082H\u2084', name: 'Ethene' },
    { formula: 'C\u2082H\u2086', name: 'Ethane' },
    { formula: 'PCl\u2083', name: 'Phosphorus Trichloride' },
    { formula: 'SO\u2083', name: 'Sulfur Trioxide' },
    { formula: 'NO\u2082', name: 'Nitrogen Dioxide' },
    { formula: 'N\u2082O', name: 'Nitrous Oxide' },
    { formula: 'XeF\u2082', name: 'Xenon Difluoride' },
    { formula: 'XeF\u2084', name: 'Xenon Tetrafluoride' },
    { formula: 'BrF\u2083', name: 'Bromine Trifluoride' },
    { formula: 'ClF\u2083', name: 'Chlorine Trifluoride' },
    { formula: 'SF\u2084', name: 'Sulfur Tetrafluoride' },
    { formula: 'H\u2082CO', name: 'Formaldehyde' },
    { formula: 'CH\u2083OH', name: 'Methanol' },
    { formula: 'CO', name: 'Carbon Monoxide' },
    { formula: 'NF\u2083', name: 'Nitrogen Trifluoride' },
    { formula: 'COCl\u2082', name: 'Phosgene' },
    { formula: 'C\u2083H\u2088', name: 'Propane' },
    { formula: 'H\u2082', name: 'Hydrogen' },
    { formula: 'Br\u2082', name: 'Bromine' },
    { formula: 'I\u2082', name: 'Iodine' },
    { formula: 'HBr', name: 'Hydrogen Bromide' },
    { formula: 'CF\u2084', name: 'Carbon Tetrafluoride' },
    { formula: 'CBr\u2084', name: 'Carbon Tetrabromide' },
    { formula: 'SiH\u2084', name: 'Silane' },
    { formula: 'PH\u2083', name: 'Phosphine' },
    { formula: 'CS\u2082', name: 'Carbon Disulfide' },
    { formula: 'H\u2082O\u2082', name: 'Hydrogen Peroxide' },
    { formula: 'N\u2082H\u2084', name: 'Hydrazine' },
    { formula: 'NO', name: 'Nitric Oxide' },
    { formula: 'OF\u2082', name: 'Oxygen Difluoride' },
    { formula: 'ClO\u2082', name: 'Chlorine Dioxide' },
    { formula: 'IF\u2085', name: 'Iodine Pentafluoride' },
    { formula: 'IF\u2087', name: 'Iodine Heptafluoride' },
    { formula: 'SbCl\u2085', name: 'Antimony Pentachloride' },
    { formula: 'SeF\u2086', name: 'Selenium Hexafluoride' },
    { formula: 'TeF\u2086', name: 'Tellurium Hexafluoride' },
    { formula: 'KrF\u2082', name: 'Krypton Difluoride' },
    { formula: 'C\u2084H\u2081\u2080', name: 'Butane' },
    { formula: 'C\u2082H\u2085OH', name: 'Ethanol' },
    { formula: 'CH\u2083CHO', name: 'Acetaldehyde' },
    { formula: 'CH\u2083NH\u2082', name: 'Methylamine' },
    { formula: 'C\u2082H\u2085Cl', name: 'Chloroethane' },
    { formula: 'CH\u2082F\u2082', name: 'Difluoromethane' },
    { formula: 'CHF\u2083', name: 'Fluoroform' },
    { formula: 'CH\u2083F', name: 'Methyl Fluoride' },
    { formula: 'B\u2082H\u2086', name: 'Diborane' },
    { formula: 'HN\u2083', name: 'Hydrazoic Acid' },
    { formula: 'C\u2082H\u2083F\u2083', name: 'Trifluoroethane' },
    { formula: 'H\u2082SO\u2084', name: 'Sulfuric Acid' },
    { formula: 'NOF', name: 'Nitrosyl Fluoride' },
    { formula: 'ClF', name: 'Chlorine Monofluoride' },
    { formula: 'BrF\u2085', name: 'Bromine Pentafluoride' },
    { formula: 'ICl\u2083', name: 'Iodine Trichloride' },
    { formula: 'AsF\u2085', name: 'Arsenic Pentafluoride' },
    { formula: 'SbF\u2085', name: 'Antimony Pentafluoride' },
    { formula: 'NCl\u2083', name: 'Nitrogen Trichloride' },
    { formula: 'Cl\u2082O', name: 'Dichlorine Monoxide' },
    { formula: 'C\u2085H\u2081\u2082', name: 'Pentane' },
    { formula: 'CH\u2083COCH\u2083', name: 'Acetone' },
    { formula: 'HCOOH', name: 'Formic Acid' },
    { formula: 'CH\u2083COOH', name: 'Acetic Acid' },
];

fullMoleculePool.forEach(function(mol) {
    var formula = mol.formula;
    try {
        var atoms = parseMolecularFormula(formula);
        var expectedTotal = totalAtomsFromFormula(atoms);

        // Check all elements are known
        var allKnown = true;
        for (var el in atoms) {
            if (!valenceElectrons[el]) {
                allKnown = false;
                fail++;
                errors.push('FAIL: ' + mol.name + ' (' + formula + ') has unknown element: ' + el);
            }
        }
        if (!allKnown) return;

        var result = buildStructure(formula);
        if (result.error) {
            fail++;
            errors.push('FAIL: ' + mol.name + ' (' + formula + ') error: ' + result.error);
            return;
        }

        // Validate type is one of the known types
        var validTypes = ['star', 'chain', 'ring', 'alcohol', 'ether', 'oxyacid'];
        assert(validTypes.indexOf(result.type) !== -1,
            mol.name + ' (' + formula + ') has valid type: ' + result.type);

        // Atom conservation
        var placed = countPlacedAtoms(result);
        if (placed !== -1) {
            assert(placed === expectedTotal,
                mol.name + ' (' + formula + ') atom conservation: placed ' + placed + '/' + expectedTotal +
                ' (type=' + result.type + ')');
        }

        // Electron conservation (for star/chain/alcohol/ether)
        if (result.type !== 'ring' && result.type !== 'oxyacid') {
            var used = countElectronsUsed(result);
            if (used >= 0) {
                assert(used === result.totalValence,
                    mol.name + ' (' + formula + ') electron conservation: ' + used + '/' + result.totalValence);
            }
        }
    } catch(e) {
        fail++;
        errors.push('FAIL: ' + mol.name + ' (' + formula + ') threw: ' + e.message);
    }
});


// ================================================================
// TEST 15: Ambiguous formula structure check
// What does the heuristic actually build for ambiguous formulas?
// ================================================================
console.log('\n=== TEST 15: Ambiguous Formula Structures ===');
var ambiguousFormulas = [
    'C3H6O',   // acetone? propanal? allyl alcohol?
    'C2H4O',   // acetaldehyde? ethylene oxide?
    'C4H8O',   // butanone? butanal?
    'C2H4O2',  // acetic acid? glycolaldehyde? (has predefined template)
];

ambiguousFormulas.forEach(function(formula) {
    var result = buildStructure(formula);
    var detail = '';
    if (result.backbone) {
        detail += 'backbone=' + JSON.stringify(result.backbone);
        detail += ' terms=' + JSON.stringify(result.termsPerAtom);
        if (result.bonding && result.bonding.bbBondOrders) {
            detail += ' bbOrders=' + JSON.stringify(result.bonding.bbBondOrders);
        }
        if (result.bonding && result.bonding.termBondOrders) {
            detail += ' termOrders=' + JSON.stringify(result.bonding.termBondOrders);
        }
    }
    console.log('  ' + formula + ' => type=' + result.type + ' ' + detail);
});


// ================================================================
// RESULTS
// ================================================================
console.log('\n' + '='.repeat(50));
console.log('RESULTS: ' + pass + ' passed, ' + fail + ' failed');
console.log('='.repeat(50));

if (errors.length > 0) {
    console.log('\nFailures:');
    errors.forEach(function(e) { console.log('  ' + e); });
}

if (fail === 0) {
    console.log('\nAll tests passed!');
} else {
    console.log('\n' + fail + ' test(s) need attention.');
}

process.exit(fail > 0 ? 1 : 0);
