#!/usr/bin/env node
/**
 * Test sdfToLewisStructure converter against real PubChem SDF data.
 * Fetches SDF for known molecules, converts to Lewis format, and validates.
 */

var https = require('https');

// ================================================================
// Extracted functions (same as in the JSP)
// ================================================================

var valenceElectrons = {
    'H': 1, 'He': 2, 'Li': 1, 'Be': 2, 'B': 3, 'C': 4, 'N': 5, 'O': 6, 'F': 7, 'Ne': 8,
    'Na': 1, 'Mg': 2, 'Al': 3, 'Si': 4, 'P': 5, 'S': 6, 'Cl': 7, 'Ar': 8,
    'K': 1, 'Ca': 2, 'Ga': 3, 'Ge': 4, 'As': 5, 'Se': 6, 'Br': 7, 'Kr': 8,
    'Rb': 1, 'Sr': 2, 'In': 3, 'Sn': 4, 'Sb': 5, 'Te': 6, 'I': 7, 'Xe': 8
};

function lewisParseSDF(sdf) {
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
        atoms.push({ elem: parts[3], idx: a });
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

function sdfToLewisStructure(parsed, totalValence) {
    if (!parsed || !parsed.atoms || !parsed.bonds) return null;

    var adj = [];
    for (var i = 0; i < parsed.atoms.length; i++) adj.push([]);
    for (var b = 0; b < parsed.bonds.length; b++) {
        var bond = parsed.bonds[b];
        adj[bond.from].push({ neighbor: bond.to, order: bond.order });
        adj[bond.to].push({ neighbor: bond.from, order: bond.order });
    }

    var heavyIndices = [];
    var hIndices = [];
    for (var i = 0; i < parsed.atoms.length; i++) {
        if (parsed.atoms[i].elem === 'H') hIndices.push(i);
        else heavyIndices.push(i);
    }

    if (heavyIndices.length === 1) {
        var ci = heavyIndices[0];
        var centralAtom = parsed.atoms[ci].elem;
        var peripherals = [];
        var bondOrders = [];
        for (var b = 0; b < adj[ci].length; b++) {
            peripherals.push(parsed.atoms[adj[ci][b].neighbor].elem);
            bondOrders.push(adj[ci][b].order);
        }
        var bondE = bondOrders.reduce(function(s, o) { return s + o * 2; }, 0);
        var remaining = totalValence - bondE;
        var pLonePairs = peripherals.map(function(el) {
            if (el === 'H') return 0;
            var need = 3;
            var canGive = Math.min(need, Math.floor(remaining / 2));
            remaining -= canGive * 2;
            return canGive;
        });
        var centralTarget = (centralAtom === 'H') ? 2 : 8;
        var cLonePairs = Math.max(0, Math.floor((centralTarget - bondE) / 2));
        if (cLonePairs * 2 > remaining) cLonePairs = Math.floor(remaining / 2);

        return {
            type: 'star',
            centralAtom: centralAtom,
            bonding: {
                peripherals: peripherals, bondOrders: bondOrders,
                peripheralLonePairs: pLonePairs, centralLonePairs: cLonePairs,
                hasResonance: false, isRadical: (totalValence % 2 !== 0),
                unpairedElectrons: 0
            }
        };
    }

    var heavyAdj = {};
    for (var i = 0; i < heavyIndices.length; i++) heavyAdj[heavyIndices[i]] = [];
    for (var b = 0; b < parsed.bonds.length; b++) {
        var bond = parsed.bonds[b];
        if (parsed.atoms[bond.from].elem !== 'H' && parsed.atoms[bond.to].elem !== 'H') {
            heavyAdj[bond.from].push({ neighbor: bond.to, order: bond.order });
            heavyAdj[bond.to].push({ neighbor: bond.from, order: bond.order });
        }
    }

    var isRing = false;
    if (heavyIndices.length >= 3) {
        var heavyBondCount = 0;
        for (var b = 0; b < parsed.bonds.length; b++) {
            var bond = parsed.bonds[b];
            if (parsed.atoms[bond.from].elem !== 'H' && parsed.atoms[bond.to].elem !== 'H') {
                heavyBondCount++;
            }
        }
        isRing = heavyBondCount >= heavyIndices.length;
    }

    if (isRing) return null;

    function findLongestPath() {
        var best = [];
        var endpoints = heavyIndices.filter(function(hi) {
            return heavyAdj[hi].length === 1;
        });
        if (endpoints.length === 0) endpoints = [heavyIndices[0]];
        for (var ei = 0; ei < endpoints.length; ei++) {
            var stack = [[endpoints[ei], [endpoints[ei]]]];
            var visited = {};
            while (stack.length > 0) {
                var item = stack.pop();
                var node = item[0], path = item[1];
                if (path.length > best.length) best = path.slice();
                visited[node] = true;
                var neighbors = heavyAdj[node] || [];
                for (var ni = 0; ni < neighbors.length; ni++) {
                    var next = neighbors[ni].neighbor;
                    if (!visited[next] && path.indexOf(next) === -1) {
                        stack.push([next, path.concat(next)]);
                    }
                }
            }
        }
        return best;
    }

    var backbonePath = findLongestPath();
    var backboneSet = {};
    for (var i = 0; i < backbonePath.length; i++) backboneSet[backbonePath[i]] = i;
    var backbone = backbonePath.map(function(idx) { return parsed.atoms[idx].elem; });

    var bbBondOrders = [];
    for (var i = 0; i < backbonePath.length - 1; i++) {
        var fromIdx = backbonePath[i];
        var toIdx = backbonePath[i + 1];
        var order = 1;
        for (var b = 0; b < parsed.bonds.length; b++) {
            if ((parsed.bonds[b].from === fromIdx && parsed.bonds[b].to === toIdx) ||
                (parsed.bonds[b].from === toIdx && parsed.bonds[b].to === fromIdx)) {
                order = parsed.bonds[b].order; break;
            }
        }
        bbBondOrders.push(order);
    }

    var termsPerAtom = [], termBondOrders = [], termLonePairs = [], termAttachedHydrogens = [];
    for (var bi = 0; bi < backbonePath.length; bi++) {
        var bbIdx = backbonePath[bi];
        var terms = [], tOrders = [], tLP = [], tAttH = [];
        for (var ni = 0; ni < adj[bbIdx].length; ni++) {
            var nb = adj[bbIdx][ni];
            if (backboneSet[nb.neighbor] !== undefined) continue;
            var nbElem = parsed.atoms[nb.neighbor].elem;
            if (nbElem === 'H') {
                terms.push('H'); tOrders.push(1); tLP.push(0); tAttH.push(0);
            } else {
                terms.push(nbElem); tOrders.push(nb.order);
                var termTarget = 8;
                var termBondE = nb.order * 2;
                var termH = 0;
                for (var ti = 0; ti < adj[nb.neighbor].length; ti++) {
                    var termNb = adj[nb.neighbor][ti];
                    if (termNb.neighbor !== bbIdx && parsed.atoms[termNb.neighbor].elem === 'H') {
                        termH++; termBondE += 2;
                    }
                }
                tLP.push(Math.max(0, Math.floor((termTarget - termBondE) / 2)));
                tAttH.push(termH);
            }
        }
        termsPerAtom.push(terms); termBondOrders.push(tOrders);
        termLonePairs.push(tLP); termAttachedHydrogens.push(tAttH);
    }

    var bbLonePairs = [];
    for (var bi = 0; bi < backbone.length; bi++) {
        var atomE = 0;
        if (bi > 0) atomE += bbBondOrders[bi - 1] * 2;
        if (bi < backbone.length - 1) atomE += bbBondOrders[bi] * 2;
        for (var ti = 0; ti < termBondOrders[bi].length; ti++) atomE += termBondOrders[bi][ti] * 2;
        var target = (backbone[bi] === 'H') ? 2 : 8;
        bbLonePairs.push(Math.max(0, Math.floor((target - atomE) / 2)));
    }

    var hasTermAttachedH = false;
    for (var bi = 0; bi < termAttachedHydrogens.length; bi++) {
        for (var ti = 0; ti < termAttachedHydrogens[bi].length; ti++) {
            if (termAttachedHydrogens[bi][ti] > 0) { hasTermAttachedH = true; break; }
        }
        if (hasTermAttachedH) break;
    }

    return {
        type: 'chain',
        backbone: backbone,
        termsPerAtom: termsPerAtom,
        chainBonding: {
            bbBondOrders: bbBondOrders, bbLonePairs: bbLonePairs,
            termLonePairs: termLonePairs, termBondOrders: termBondOrders,
            termAttachedHydrogens: hasTermAttachedH ? termAttachedHydrogens : undefined
        },
        termAttachedHydrogens: hasTermAttachedH ? termAttachedHydrogens : null
    };
}

// ================================================================
// PubChem fetcher
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
        }).on('error', function() { resolve(null); });
    });
}

function delay(ms) { return new Promise(function(r) { setTimeout(r, ms); }); }

async function fetchSDF(name) {
    var url = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/' +
        encodeURIComponent(name) + '/cids/JSON?MaxRecords=1';
    var data = await httpsGet(url);
    if (!data) return null;
    var json;
    try { json = JSON.parse(data); } catch(e) { return null; }
    var cid = null;
    if (json.IdentifierList && json.IdentifierList.CID && json.IdentifierList.CID.length > 0) {
        cid = json.IdentifierList.CID[0];
    }
    if (!cid) return null;
    var sdf = await httpsGet('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' + cid + '/SDF?record_type=3d');
    if (!sdf || sdf.indexOf('V2000') === -1) {
        sdf = await httpsGet('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' + cid + '/SDF');
    }
    return { sdf: sdf, cid: cid };
}

// ================================================================
// Test molecules — these are the ones that matter for the converter
// ================================================================

var testMolecules = [
    // Star molecules
    { name: 'Water', formula: 'H2O', valence: 8,
      expectType: 'star', expectCentral: 'O', expectBondOrders: [1, 1] },
    // CO2 has 3 heavy atoms → converter builds chain O=C=O (correct)
    { name: 'Carbon Dioxide', formula: 'CO2', valence: 16,
      expectType: 'chain', expectBackbone: ['O', 'C', 'O'], expectBBOrders: [2, 2] },
    { name: 'Ammonia', formula: 'NH3', valence: 8,
      expectType: 'star', expectCentral: 'N', expectBondOrders: [1, 1, 1] },
    { name: 'Methane', formula: 'CH4', valence: 8,
      expectType: 'star', expectCentral: 'C', expectBondOrders: [1, 1, 1, 1] },
    { name: 'Formaldehyde', formula: 'CH2O', valence: 12,
      expectType: 'chain', expectBackbone: ['O', 'C'], expectBBOrders: [2] },

    // Chain molecules
    { name: 'Ethane', formula: 'C2H6', valence: 14,
      expectType: 'chain', expectBackbone: ['C', 'C'], expectBBOrders: [1] },
    { name: 'Ethene', formula: 'C2H4', valence: 12,
      expectType: 'chain', expectBackbone: ['C', 'C'], expectBBOrders: [2] },
    { name: 'Acetylene', formula: 'C2H2', valence: 10,
      expectType: 'chain', expectBackbone: ['C', 'C'], expectBBOrders: [3] },
    { name: 'Propane', formula: 'C3H8', valence: 20,
      expectType: 'chain', expectBackbone: ['C', 'C', 'C'], expectBBOrders: [1, 1] },

    // Molecules the heuristic got WRONG (the whole point of the converter)
    // DFS finds O/N at chain endpoints, so backbone starts with heteroatom
    { name: 'Acetone', formula: 'C3H6O', valence: 24,
      expectType: 'chain', expectBackbone: ['O', 'C', 'C'],
      expectBBOrders: [2, 1] },
    { name: 'Acetaldehyde', formula: 'C2H4O', valence: 18,
      expectType: 'chain', expectBackbone: ['O', 'C', 'C'],
      expectBBOrders: [2, 1] },
    { name: 'Methylamine', formula: 'CH5N', valence: 14,
      expectType: 'chain', expectBackbone: ['N', 'C'], expectBBOrders: [1] },

    // Alcohol / ether (verify converter handles them too)
    { name: 'Methanol', formula: 'CH4O', valence: 14,
      expectType: 'chain', expectBackbone: ['O', 'C'], expectBBOrders: [1] },
    { name: 'Ethanol', formula: 'C2H6O', valence: 20,
      expectType: 'chain', expectBackbone: ['O', 'C', 'C'], expectBBOrders: [1, 1] },

    // Tricky ones
    { name: 'Hydrogen Peroxide', formula: 'H2O2', valence: 14,
      expectType: 'chain', expectBackbone: ['O', 'O'], expectBBOrders: [1] },
    { name: 'Hydrazine', formula: 'N2H4', valence: 14,
      expectType: 'chain', expectBackbone: ['N', 'N'], expectBBOrders: [1] },
];

// ================================================================
// Run tests
// ================================================================

var pass = 0, fail = 0;
var errors = [];

function assert(cond, msg) {
    if (cond) pass++;
    else { fail++; errors.push('FAIL: ' + msg); }
}

async function main() {
    console.log('Testing sdfToLewisStructure with real PubChem data...\n');

    for (var i = 0; i < testMolecules.length; i++) {
        var t = testMolecules[i];

        var pubData = await fetchSDF(t.name);
        if (!pubData || !pubData.sdf) {
            console.log('  SKIP ' + t.name + ': no SDF from PubChem');
            continue;
        }

        var parsed = lewisParseSDF(pubData.sdf);
        assert(parsed !== null, t.name + ' SDF parses');
        if (!parsed) continue;

        var result = sdfToLewisStructure(parsed, t.valence);
        assert(result !== null, t.name + ' converts');
        if (!result) continue;

        // Type check
        assert(result.type === t.expectType,
            t.name + ' type: got "' + result.type + '", expected "' + t.expectType + '"');

        if (t.expectType === 'star') {
            assert(result.centralAtom === t.expectCentral,
                t.name + ' central: got "' + result.centralAtom + '", expected "' + t.expectCentral + '"');

            var gotOrders = result.bonding.bondOrders.slice().sort().join(',');
            var expectOrders = t.expectBondOrders.slice().sort().join(',');
            assert(gotOrders === expectOrders,
                t.name + ' bond orders: got [' + gotOrders + '], expected [' + expectOrders + ']');

            // Verify electron count
            var totalE = 0;
            for (var j = 0; j < result.bonding.bondOrders.length; j++) totalE += result.bonding.bondOrders[j] * 2;
            for (var j = 0; j < result.bonding.peripheralLonePairs.length; j++) totalE += result.bonding.peripheralLonePairs[j] * 2;
            totalE += result.bonding.centralLonePairs * 2;
            assert(totalE === t.valence,
                t.name + ' electron count: got ' + totalE + ', expected ' + t.valence);

            console.log('  OK   ' + t.name + ' (star, central=' + result.centralAtom +
                ', bonds=[' + result.bonding.bondOrders + '], CID ' + pubData.cid + ')');

        } else if (t.expectType === 'chain') {
            assert(JSON.stringify(result.backbone) === JSON.stringify(t.expectBackbone),
                t.name + ' backbone: got ' + JSON.stringify(result.backbone) +
                ', expected ' + JSON.stringify(t.expectBackbone));

            var cb = result.chainBonding;
            assert(JSON.stringify(cb.bbBondOrders) === JSON.stringify(t.expectBBOrders),
                t.name + ' bb orders: got ' + JSON.stringify(cb.bbBondOrders) +
                ', expected ' + JSON.stringify(t.expectBBOrders));

            // Check terminal O placement and bond order (for acetone, acetaldehyde)
            if (t.expectTermO) {
                var bi = t.expectTermO.backboneIdx;
                var oIdx = -1;
                for (var ti = 0; ti < result.termsPerAtom[bi].length; ti++) {
                    if (result.termsPerAtom[bi][ti] === 'O') { oIdx = ti; break; }
                }
                assert(oIdx !== -1,
                    t.name + ' O on backbone[' + bi + ']: not found (terms=' +
                    JSON.stringify(result.termsPerAtom) + ')');
                if (oIdx !== -1) {
                    var oOrder = cb.termBondOrders[bi][oIdx];
                    assert(oOrder === t.expectTermO.bondOrder,
                        t.name + ' O bond order: got ' + oOrder + ', expected ' + t.expectTermO.bondOrder);
                }
            }

            // Verify total atoms placed
            var placed = result.backbone.length;
            for (var bi = 0; bi < result.termsPerAtom.length; bi++) {
                placed += result.termsPerAtom[bi].length;
                if (result.termAttachedHydrogens && result.termAttachedHydrogens[bi]) {
                    for (var ti = 0; ti < result.termAttachedHydrogens[bi].length; ti++) {
                        placed += result.termAttachedHydrogens[bi][ti];
                    }
                }
            }
            var expectedAtoms = 0;
            for (var j = 0; j < parsed.atoms.length; j++) expectedAtoms++;
            assert(placed === expectedAtoms,
                t.name + ' atom conservation: placed ' + placed + '/' + expectedAtoms);

            // Verify electron conservation
            var totalE = 0;
            for (var j = 0; j < cb.bbBondOrders.length; j++) totalE += cb.bbBondOrders[j] * 2;
            for (var bi = 0; bi < cb.termBondOrders.length; bi++) {
                for (var ti = 0; ti < cb.termBondOrders[bi].length; ti++) {
                    totalE += cb.termBondOrders[bi][ti] * 2;
                }
            }
            for (var bi = 0; bi < cb.bbLonePairs.length; bi++) totalE += cb.bbLonePairs[bi] * 2;
            for (var bi = 0; bi < cb.termLonePairs.length; bi++) {
                for (var ti = 0; ti < cb.termLonePairs[bi].length; ti++) {
                    totalE += cb.termLonePairs[bi][ti] * 2;
                }
            }
            // Count attached H bonds too
            if (cb.termAttachedHydrogens) {
                for (var bi = 0; bi < cb.termAttachedHydrogens.length; bi++) {
                    for (var ti = 0; ti < (cb.termAttachedHydrogens[bi] || []).length; ti++) {
                        totalE += (cb.termAttachedHydrogens[bi][ti] || 0) * 2;
                    }
                }
            }
            assert(totalE === t.valence,
                t.name + ' electron count: got ' + totalE + ', expected ' + t.valence);

            console.log('  OK   ' + t.name + ' (chain, bb=' + JSON.stringify(result.backbone) +
                ', orders=' + JSON.stringify(cb.bbBondOrders) + ', CID ' + pubData.cid + ')');
        }

        await delay(250); // rate limit
    }

    console.log('\n' + '='.repeat(50));
    console.log('SDF-TO-LEWIS: ' + pass + ' passed, ' + fail + ' failed');
    console.log('='.repeat(50));

    if (errors.length > 0) {
        console.log('\nFailures:');
        errors.forEach(function(e) { console.log('  ' + e); });
    }

    process.exit(fail > 0 ? 1 : 0);
}

main().catch(function(e) { console.error(e); process.exit(1); });
