#!/usr/bin/env node
/**
 * Verify Lewis Structure Generator heuristics against PubChem real data.
 * For each molecule in fullMoleculePool, fetches the SDF from PubChem,
 * parses actual bonds, and compares with what our heuristic produces.
 */

var https = require('https');

// ================================================================
// Extracted Lewis logic (same as test-lewis-structure.cjs)
// ================================================================

var valenceElectrons = {
    'H': 1, 'He': 2,
    'Li': 1, 'Be': 2, 'B': 3, 'C': 4, 'N': 5, 'O': 6, 'F': 7, 'Ne': 8,
    'Na': 1, 'Mg': 2, 'Al': 3, 'Si': 4, 'P': 5, 'S': 6, 'Cl': 7, 'Ar': 8,
    'K': 1, 'Ca': 2, 'Ga': 3, 'Ge': 4, 'As': 5, 'Se': 6, 'Br': 7, 'Kr': 8,
    'Rb': 1, 'Sr': 2, 'In': 3, 'Sn': 4, 'Sb': 5, 'Te': 6, 'I': 7, 'Xe': 8,
    'M': 4, 'A': 4, 'X': 7, 'L': 7, 'E': 6, 'R': 1, 'G': 8
};

function getMaxBonds(el) {
    var expanded = { 'P': 5, 'S': 6, 'Cl': 7, 'Br': 7, 'I': 7, 'Xe': 8, 'Se': 6, 'Te': 6, 'As': 5 };
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
    if (centralAtom === 'N' && (atoms['N'] || 0) === 1 && (atoms['O'] || 0) === 2 &&
        Object.keys(atoms).length === 2 && totalValence === 17) {
        return { peripherals: ['O', 'O'], bondOrders: [2, 1], peripheralLonePairs: [2, 3],
            centralLonePairs: 0, hasResonance: true, isRadical: true, unpairedElectrons: 1 };
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
        cLonePairs++; remaining -= 2;
    }
    var centralTotal = centralE + cLonePairs * 2;
    while (centralTotal < centralTarget) {
        var bestIdx = -1, bestPairs = 0;
        for (var i = 0; i < peripherals.length; i++) {
            if (pLonePairs[i] > 0 && peripherals[i] !== 'H' && bondOrders[i] < 3) {
                if (pLonePairs[i] > bestPairs) { bestPairs = pLonePairs[i]; bestIdx = i; }
            }
        }
        if (bestIdx === -1) break;
        pLonePairs[bestIdx]--; bondOrders[bestIdx]++; centralTotal += 2;
    }
    var expandedEls = ['P', 'S', 'Cl', 'Br', 'I', 'Xe', 'Se', 'Te', 'As'];
    if (remaining > 0 && expandedEls.indexOf(centralAtom) !== -1) {
        var extraPairs = Math.floor(remaining / 2);
        cLonePairs += extraPairs; remaining -= extraPairs * 2;
    }
    return { peripherals: peripherals, bondOrders: bondOrders, peripheralLonePairs: pLonePairs,
        centralLonePairs: cLonePairs, hasResonance: false, isRadical: (totalValence % 2 !== 0),
        unpairedElectrons: remaining };
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
            arr.push(canGive); remaining -= canGive * 2;
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
        bbLonePairs[i] = canGive; remaining -= canGive * 2;
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
        bbLonePairs[bestIdx]++; remaining -= 2;
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
                    bbLonePairs[i - 1]--; bbBondOrders[i - 1]++; atomE += 2; increased = true;
                }
                if (!increased && i < backbone.length - 1 && bbLonePairs[i + 1] > 0 && bbBondOrders[i] < 3) {
                    bbLonePairs[i + 1]--; bbBondOrders[i]++; atomE += 2; increased = true;
                }
                if (!increased) {
                    for (var ti = 0; ti < termsPerAtom[i].length; ti++) {
                        var maxTermBond = getMaxBonds(termsPerAtom[i][ti]);
                        if (termsPerAtom[i][ti] !== 'H' && termLonePairs[i][ti] > 0 && termBondOrders[i][ti] < maxTermBond) {
                            termLonePairs[i][ti]--; termBondOrders[i][ti]++; atomE += 2; increased = true; break;
                        }
                    }
                }
                if (!increased) break;
            }
        }
    }
    function atomTarget(idx) { return (backbone[idx] === 'H') ? 2 : 8; }
    function atomElectronCount(idx) {
        var e = bbLonePairs[idx] * 2;
        if (idx > 0) e += bbBondOrders[idx - 1] * 2;
        if (idx < backbone.length - 1) e += bbBondOrders[idx] * 2;
        for (var ti = 0; ti < termBondOrders[idx].length; ti++) e += termBondOrders[idx][ti] * 2;
        return e;
    }
    var changed = true, guard = 0;
    while (changed && guard < 8) {
        changed = false; guard++;
        for (var bi = 0; bi < bbBondOrders.length; bi++) {
            if (bbBondOrders[bi] >= 3) continue;
            if (atomElectronCount(bi) < atomTarget(bi) && atomElectronCount(bi + 1) < atomTarget(bi + 1)) {
                bbBondOrders[bi]++; changed = true;
            }
        }
    }
    return { bbBondOrders: bbBondOrders, bbLonePairs: bbLonePairs,
        termLonePairs: termLonePairs, termBondOrders: termBondOrders };
}

function canonicalFormulaKey(atoms, charge) {
    var keys = Object.keys(atoms);
    keys.sort(function(a, b) {
        if (a === 'C') return -1;
        if (b === 'C') return 1;
        if (a === 'H' && keys.indexOf('C') !== -1 && b !== 'C') return -1;
        if (b === 'H' && keys.indexOf('C') !== -1 && a !== 'C') return 1;
        return a.localeCompare(b);
    });
    var f = '';
    for (var i = 0; i < keys.length; i++) {
        var el = keys[i];
        f += el + (atoms[el] > 1 ? atoms[el] : '');
    }
    return f + '|' + charge;
}

// Predefined templates for molecules that heuristics get wrong
var predefinedTemplates = {
    'C3H6O|0': {
        kind: 'chain',
        backbone: ['C', 'C', 'C'],
        termsPerAtom: [['H', 'H', 'H'], ['O'], ['H', 'H', 'H']],
        chainBonding: {
            bbBondOrders: [1, 1], bbLonePairs: [0, 0, 0],
            termLonePairs: [[0, 0, 0], [2], [0, 0, 0]],
            termBondOrders: [[1, 1, 1], [2], [1, 1, 1]]
        }
    },
    'C2H4O|0': {
        kind: 'chain',
        backbone: ['C', 'C'],
        termsPerAtom: [['H', 'H', 'H'], ['O', 'H']],
        chainBonding: {
            bbBondOrders: [1], bbLonePairs: [0, 0],
            termLonePairs: [[0, 0, 0], [2, 0]],
            termBondOrders: [[1, 1, 1], [2, 1]]
        }
    },
    'CH5N|0': {
        kind: 'chain',
        backbone: ['C', 'N'],
        termsPerAtom: [['H', 'H', 'H'], ['H', 'H']],
        chainBonding: {
            bbBondOrders: [1], bbLonePairs: [0, 1],
            termLonePairs: [[0, 0, 0], [0, 0]],
            termBondOrders: [[1, 1, 1], [1, 1]]
        }
    },
    'Cl2O|0': {
        kind: 'star',
        centralAtom: 'O',
        bonding: {
            peripherals: ['Cl', 'Cl'], bondOrders: [1, 1],
            peripheralLonePairs: [3, 3], centralLonePairs: 2,
            hasResonance: false, isRadical: false, unpairedElectrons: 0
        }
    },
    'C2H4O2|0': {
        kind: 'chain',
        backbone: ['C', 'C'],
        termsPerAtom: [['H', 'H', 'H'], ['O', 'O']],
        chainBonding: {
            bbBondOrders: [1], bbLonePairs: [0, 0],
            termLonePairs: [[0, 0, 0], [2, 2]],
            termBondOrders: [[1, 1, 1], [1, 2]],
            termAttachedHydrogens: [[0, 0, 0], [1, 0]]
        }
    }
};

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
    return { type: type, atoms: atoms, centralAtom: centralAtom, totalValence: totalValence };
}

function buildStructure(formula) {
    var info = resolveStructureType(formula);
    if (info.error) return info;
    var atoms = info.atoms, centralAtom = info.centralAtom, totalValence = info.totalValence;

    // Check predefined templates first
    var key = canonicalFormulaKey(atoms, 0);
    var tpl = predefinedTemplates[key];
    if (tpl) {
        if (tpl.kind === 'star') {
            return { type: 'star', centralAtom: tpl.centralAtom, atoms: atoms,
                totalValence: totalValence, bonding: tpl.bonding };
        }
        return { type: 'chain', centralAtom: centralAtom, atoms: atoms,
            totalValence: totalValence, backbone: tpl.backbone,
            termsPerAtom: tpl.termsPerAtom, bonding: tpl.chainBonding };
    }

    var backbone, termsPerAtom, bonding;

    if (info.type === 'alcohol') {
        backbone = [];
        var numC = atoms['C'] || 0;
        for (var k = 0; k < numC; k++) backbone.push('C');
        backbone.push('O');
        termsPerAtom = [];
        for (var k = 0; k < backbone.length; k++) termsPerAtom.push([]);
        var numH = atoms['H'] || 0;
        termsPerAtom[backbone.length - 1].push('H'); numH--;
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
    } else if (info.type === 'oxyacid') {
        return { type: 'oxyacid', centralAtom: centralAtom, atoms: atoms, totalValence: totalValence };
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
                    capacities[target]--; idx = (target + 1) % backbone.length;
                    assigned = true; break;
                }
            }
            if (!assigned) break;
        }
        if (remaining.length > 0) {
            termsPerAtom[backbone.length - 1] = termsPerAtom[backbone.length - 1].concat(remaining);
        }
        bonding = analyzeChainBonding(backbone, termsPerAtom, totalValence);
    } else {
        bonding = analyzeBonding(atoms, centralAtom, totalValence);
        return { type: 'star', centralAtom: centralAtom, atoms: atoms,
            totalValence: totalValence, bonding: bonding };
    }
    return { type: info.type, centralAtom: centralAtom, atoms: atoms,
        totalValence: totalValence, backbone: backbone,
        termsPerAtom: termsPerAtom, bonding: bonding };
}

// ================================================================
// SDF Parser
// ================================================================

function parseSDF(sdf) {
    var lines = sdf.split('\n');
    var countsIdx = -1;
    for (var i = 0; i < Math.min(lines.length, 10); i++) {
        if (lines[i].indexOf('V2000') !== -1 || lines[i].indexOf('V3000') !== -1) {
            countsIdx = i; break;
        }
    }
    if (countsIdx === -1) return null;
    var countsParts = lines[countsIdx].trim().split(/\s+/);
    var numAtoms = parseInt(countsParts[0]);
    var numBonds = parseInt(countsParts[1]);
    if (isNaN(numAtoms) || isNaN(numBonds) || numAtoms < 1) return null;
    var atoms = [];
    for (var a = 0; a < numAtoms; a++) {
        var line = lines[countsIdx + 1 + a];
        if (!line) continue;
        var parts = line.trim().split(/\s+/);
        if (parts.length < 4) continue;
        atoms.push({ x: parseFloat(parts[0]), y: parseFloat(parts[1]),
            z: parseFloat(parts[2]), elem: parts[3], idx: a });
    }
    var bonds = [];
    for (var b = 0; b < numBonds; b++) {
        var bline = lines[countsIdx + 1 + numAtoms + b];
        if (!bline) continue;
        var bparts = bline.trim().split(/\s+/);
        if (bparts.length < 3) continue;
        bonds.push({ from: parseInt(bparts[0]) - 1, to: parseInt(bparts[1]) - 1,
            order: parseInt(bparts[2]) });
    }
    return { atoms: atoms, bonds: bonds };
}

// Build a bond fingerprint from SDF: for each heavy atom, what elements
// is it bonded to and with what bond orders?
function sdfBondFingerprint(parsed) {
    var atomBonds = {};
    for (var i = 0; i < parsed.atoms.length; i++) {
        atomBonds[i] = [];
    }
    for (var b = 0; b < parsed.bonds.length; b++) {
        var bond = parsed.bonds[b];
        atomBonds[bond.from].push({ neighbor: bond.to, order: bond.order });
        atomBonds[bond.to].push({ neighbor: bond.from, order: bond.order });
    }

    // For each heavy atom, build sorted list of (neighborElement, bondOrder)
    var fingerprint = [];
    for (var i = 0; i < parsed.atoms.length; i++) {
        var a = parsed.atoms[i];
        if (a.elem === 'H') continue;
        var neighbors = atomBonds[i].map(function(nb) {
            return { elem: parsed.atoms[nb.neighbor].elem, order: nb.order };
        }).sort(function(a, b) {
            return a.elem.localeCompare(b.elem) || a.order - b.order;
        });
        fingerprint.push({
            elem: a.elem,
            bonds: neighbors,
            totalBondOrder: neighbors.reduce(function(s, n) { return s + n.order; }, 0)
        });
    }
    return fingerprint;
}

// Build the same fingerprint from our heuristic structure
function heuristicBondFingerprint(result) {
    if (result.type === 'oxyacid') return null; // skip for now

    if (result.type === 'star') {
        var b = result.bonding;
        // Central atom bonds
        var centralBonds = [];
        for (var i = 0; i < b.peripherals.length; i++) {
            centralBonds.push({ elem: b.peripherals[i], order: b.bondOrders[i] });
        }
        centralBonds.sort(function(a, b) {
            return a.elem.localeCompare(b.elem) || a.order - b.order;
        });
        var fingerprint = [{
            elem: result.centralAtom,
            bonds: centralBonds,
            totalBondOrder: centralBonds.reduce(function(s, n) { return s + n.order; }, 0)
        }];
        // Peripheral non-H atoms
        for (var i = 0; i < b.peripherals.length; i++) {
            if (b.peripherals[i] === 'H') continue;
            fingerprint.push({
                elem: b.peripherals[i],
                bonds: [{ elem: result.centralAtom, order: b.bondOrders[i] }],
                totalBondOrder: b.bondOrders[i]
            });
        }
        return fingerprint;
    }

    // Chain / alcohol / ether / ring
    if (!result.backbone || !result.bonding) return null;
    var bb = result.backbone;
    var bnd = result.bonding;
    var bbOrders = bnd.bbBondOrders || [];
    var termOrders = bnd.termBondOrders || [];

    var fingerprint = [];
    for (var i = 0; i < bb.length; i++) {
        var bonds = [];
        // Left backbone neighbor
        if (i > 0) bonds.push({ elem: bb[i - 1], order: bbOrders[i - 1] });
        // Right backbone neighbor
        if (i < bb.length - 1) bonds.push({ elem: bb[i + 1], order: bbOrders[i] });
        // Ring closing bond (for rings, not in our current data since ring bonding is separate)
        // Terminals
        if (result.termsPerAtom && result.termsPerAtom[i]) {
            for (var t = 0; t < result.termsPerAtom[i].length; t++) {
                var tEl = result.termsPerAtom[i][t];
                var tOrd = (termOrders[i] && termOrders[i][t] !== undefined) ? termOrders[i][t] : 1;
                bonds.push({ elem: tEl, order: tOrd });
            }
        }
        bonds.sort(function(a, b) {
            return a.elem.localeCompare(b.elem) || a.order - b.order;
        });

        if (bb[i] !== 'H') {
            fingerprint.push({
                elem: bb[i],
                bonds: bonds,
                totalBondOrder: bonds.reduce(function(s, n) { return s + n.order; }, 0)
            });
        }
    }
    // Also add non-H terminal atoms
    if (result.termsPerAtom) {
        for (var i = 0; i < result.termsPerAtom.length; i++) {
            for (var t = 0; t < result.termsPerAtom[i].length; t++) {
                var tEl = result.termsPerAtom[i][t];
                if (tEl === 'H') continue;
                var tOrd = (termOrders[i] && termOrders[i][t] !== undefined) ? termOrders[i][t] : 1;
                fingerprint.push({
                    elem: tEl,
                    bonds: [{ elem: bb[i], order: tOrd }],
                    totalBondOrder: tOrd
                });
            }
        }
    }
    return fingerprint;
}

// Compare fingerprints by grouping heavy atoms by element and checking
// bond order totals match
function compareFingerprints(heurFp, sdfFp, name) {
    if (!heurFp || !sdfFp) return { match: false, reason: 'missing fingerprint' };

    // Group by element, sort by totalBondOrder within each group
    function groupByElement(fp) {
        var groups = {};
        fp.forEach(function(a) {
            if (!groups[a.elem]) groups[a.elem] = [];
            groups[a.elem].push(a);
        });
        for (var el in groups) {
            groups[el].sort(function(a, b) { return a.totalBondOrder - b.totalBondOrder; });
        }
        return groups;
    }

    var hGroups = groupByElement(heurFp);
    var sGroups = groupByElement(sdfFp);

    var issues = [];

    // Check same heavy atoms
    var allEls = {};
    for (var el in hGroups) allEls[el] = true;
    for (var el in sGroups) allEls[el] = true;

    for (var el in allEls) {
        var hAtoms = hGroups[el] || [];
        var sAtoms = sGroups[el] || [];
        if (hAtoms.length !== sAtoms.length) {
            issues.push(el + ' count: heuristic=' + hAtoms.length + ' pubchem=' + sAtoms.length);
            continue;
        }
        // Compare bond order totals
        for (var i = 0; i < hAtoms.length; i++) {
            if (hAtoms[i].totalBondOrder !== sAtoms[i].totalBondOrder) {
                var hBondDesc = hAtoms[i].bonds.map(function(b) { return b.elem + '(' + b.order + ')'; }).join(',');
                var sBondDesc = sAtoms[i].bonds.map(function(b) { return b.elem + '(' + b.order + ')'; }).join(',');
                issues.push(el + ' atom bond order total: heuristic=' +
                    hAtoms[i].totalBondOrder + ' [' + hBondDesc + '] vs pubchem=' +
                    sAtoms[i].totalBondOrder + ' [' + sBondDesc + ']');
            }
        }
    }

    return {
        match: issues.length === 0,
        issues: issues
    };
}

// ================================================================
// PubChem fetch helpers
// ================================================================

function httpsGet(url) {
    return new Promise(function(resolve, reject) {
        https.get(url, function(res) {
            var data = '';
            res.on('data', function(chunk) { data += chunk; });
            res.on('end', function() {
                if (res.statusCode >= 200 && res.statusCode < 300) resolve(data);
                else resolve(null);
            });
        }).on('error', function(e) { resolve(null); });
    });
}

function delay(ms) { return new Promise(function(r) { setTimeout(r, ms); }); }

async function fetchCID(query) {
    // Try by name first (more reliable for specific molecules)
    var nameUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/' +
        encodeURIComponent(query) + '/cids/JSON?MaxRecords=1';
    var data = await httpsGet(nameUrl);
    if (data) {
        try {
            var json = JSON.parse(data);
            if (json.IdentifierList && json.IdentifierList.CID && json.IdentifierList.CID.length > 0) {
                return json.IdentifierList.CID[0];
            }
        } catch(e) {}
    }

    // Fallback: try by formula (async endpoint)
    var formulaUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/formula/' +
        encodeURIComponent(query) + '/cids/JSON?MaxRecords=1';
    data = await httpsGet(formulaUrl);
    if (data) {
        try {
            var json = JSON.parse(data);
            if (json.IdentifierList && json.IdentifierList.CID && json.IdentifierList.CID.length > 0) {
                return json.IdentifierList.CID[0];
            }
            // Async waiting
            if (json.Waiting && json.Waiting.ListKey) {
                await delay(2500);
                var listUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/listkey/' +
                    json.Waiting.ListKey + '/cids/JSON?MaxRecords=1';
                data = await httpsGet(listUrl);
                if (data) {
                    json = JSON.parse(data);
                    if (json.IdentifierList && json.IdentifierList.CID && json.IdentifierList.CID.length > 0) {
                        return json.IdentifierList.CID[0];
                    }
                }
            }
        } catch(e) {}
    }
    return null;
}

async function fetchSDF(cid) {
    var url = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' + cid + '/SDF?record_type=3d';
    var data = await httpsGet(url);
    if (!data || (data.indexOf('V2000') === -1 && data.indexOf('V3000') === -1)) {
        // Try 2D fallback
        url = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' + cid + '/SDF';
        data = await httpsGet(url);
    }
    return data;
}

// ================================================================
// Main verification
// ================================================================

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

async function main() {
    var pass = 0, fail = 0, skip = 0;
    var failures = [];

    console.log('Verifying ' + fullMoleculePool.length + ' molecules against PubChem...\n');

    for (var mi = 0; mi < fullMoleculePool.length; mi++) {
        var mol = fullMoleculePool[mi];
        var formula = mol.formula;
        var name = mol.name;

        // Build heuristic structure
        var hResult = buildStructure(formula);
        if (hResult.error) {
            console.log('  SKIP ' + name + ' (' + formula + '): ' + hResult.error);
            skip++; continue;
        }

        var hFp = heuristicBondFingerprint(hResult);
        if (!hFp) {
            console.log('  SKIP ' + name + ' (' + formula + '): type=' + hResult.type + ' (no fingerprint)');
            skip++; continue;
        }

        // Fetch from PubChem (use name for precise match)
        var cid = await fetchCID(name);
        if (!cid) {
            console.log('  SKIP ' + name + ': no CID found');
            skip++; continue;
        }

        var sdfData = await fetchSDF(cid);
        if (!sdfData) {
            console.log('  SKIP ' + name + ' (CID ' + cid + '): no SDF');
            skip++; continue;
        }

        var parsed = parseSDF(sdfData);
        if (!parsed) {
            console.log('  SKIP ' + name + ' (CID ' + cid + '): SDF parse failed');
            skip++; continue;
        }

        var sFp = sdfBondFingerprint(parsed);
        var comparison = compareFingerprints(hFp, sFp, name);

        if (comparison.match) {
            console.log('  OK   ' + name + ' (CID ' + cid + ', type=' + hResult.type + ')');
            pass++;
        } else {
            console.log('  FAIL ' + name + ' (CID ' + cid + ', type=' + hResult.type + ')');
            comparison.issues.forEach(function(issue) {
                console.log('       ' + issue);
            });
            fail++;
            failures.push({ name: name, formula: formula, cid: cid, type: hResult.type,
                issues: comparison.issues });
        }

        // Rate limit: PubChem allows 5 req/sec
        await delay(250);
    }

    console.log('\n' + '='.repeat(60));
    console.log('PUBCHEM VERIFICATION: ' + pass + ' match, ' + fail + ' mismatch, ' + skip + ' skipped');
    console.log('='.repeat(60));

    if (failures.length > 0) {
        console.log('\nMismatches (heuristic differs from PubChem):');
        failures.forEach(function(f) {
            console.log('  ' + f.name + ' (' + f.formula + ') CID=' + f.cid + ' type=' + f.type);
            f.issues.forEach(function(i) { console.log('    - ' + i); });
        });
    }

    process.exit(fail > 0 ? 1 : 0);
}

main().catch(function(e) { console.error(e); process.exit(1); });
