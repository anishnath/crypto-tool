#!/usr/bin/env node
/**
 * Test suite for Molecular Geometry Calculator
 * Validates: database molecules, formula parser, geometry data coverage,
 * unicode display, and edge cases.
 */

// Stub browser globals
global.window = {};
global.document = { createElement: function() { return { className:'', innerHTML:'', style:{}, textContent:'', appendChild:function(){} }; } };

// Load the module
require('./src/main/webapp/js/molecular-geometry-render.js');

var R = global.window.MolGeomRender;
var pass = 0, fail = 0, warnings = 0;
var errors = [];

function assert(condition, msg) {
    if (condition) { pass++; }
    else { fail++; errors.push('FAIL: ' + msg); }
}

function warn(msg) { warnings++; console.log('  WARN: ' + msg); }

// ============================================================
// TEST 1: Module loaded
// ============================================================
console.log('\n=== TEST 1: Module Exports ===');
assert(R, 'MolGeomRender exists');
assert(R.molecules && R.molecules.length > 0, 'molecules array exists and non-empty');
assert(R.geometryData, 'geometryData exists');
assert(typeof R.parseMolecularFormula === 'function', 'parseMolecularFormula is a function');
assert(typeof R.unicodeFormula === 'function', 'unicodeFormula is a function');
assert(typeof R.renderByPairs === 'function', 'renderByPairs is a function');
assert(typeof R.renderByFormula === 'function', 'renderByFormula is a function');
assert(typeof R.renderMoleculeTable === 'function', 'renderMoleculeTable is a function');
console.log('  Molecules in database: ' + R.molecules.length);

// ============================================================
// TEST 2: Every molecule has required fields + display
// ============================================================
console.log('\n=== TEST 2: Database Molecule Schema ===');
var requiredFields = ['formula', 'display', 'name', 'bp', 'lp', 'geometry', 'angle', 'hybridization'];
var formulasSeen = {};

R.molecules.forEach(function(m, i) {
    requiredFields.forEach(function(f) {
        assert(m[f] !== undefined && m[f] !== null && m[f] !== '',
            'molecules[' + i + '] (' + m.formula + ') has field "' + f + '"');
    });

    // No duplicate formulas
    var key = m.formula.toUpperCase();
    assert(!formulasSeen[key], 'No duplicate formula: ' + m.formula);
    formulasSeen[key] = true;

    // BP and LP are non-negative integers
    assert(Number.isInteger(m.bp) && m.bp >= 0, m.formula + ' bp is valid integer >= 0');
    assert(Number.isInteger(m.lp) && m.lp >= 0, m.formula + ' lp is valid integer >= 0');
});

// ============================================================
// TEST 3: Every molecule's BP/LP maps to valid geometryData
// ============================================================
console.log('\n=== TEST 3: Geometry Data Coverage ===');
R.molecules.forEach(function(m) {
    var key = m.bp + '-' + m.lp;
    var data = R.geometryData[key];
    assert(data, m.formula + ' (' + m.display + '): geometry key "' + key + '" exists in geometryData');
    if (data) {
        assert(data.molecularGeom, m.formula + ': geometryData has molecularGeom');
        assert(data.hybridization, m.formula + ': geometryData has hybridization');
        assert(data.diagram, m.formula + ': geometryData has diagram');
        assert(data.notation, m.formula + ': geometryData has notation');
    }
});

// ============================================================
// TEST 4: Unicode display field correctness
// ============================================================
console.log('\n=== TEST 4: Unicode Display ===');
var unicodeTests = [
    { formula: 'CO2', expected: 'CO\u2082' },
    { formula: 'BeCl2', expected: 'BeCl\u2082' },
    { formula: 'BF3', expected: 'BF\u2083' },
    { formula: 'CH4', expected: 'CH\u2084' },
    { formula: 'NH4+', expected: 'NH\u2084\u207a' },
    { formula: 'NO3-', expected: 'NO\u2083\u207b' },
    { formula: 'PCl5', expected: 'PCl\u2085' },
    { formula: 'SF6', expected: 'SF\u2086' },
    { formula: 'IF7', expected: 'IF\u2087' },
    { formula: 'PF6-', expected: 'PF\u2086\u207b' },
    { formula: 'I3-', expected: 'I\u2083\u207b' },
    { formula: 'H3O+', expected: 'H\u2083O\u207a' },
    { formula: 'ICl4-', expected: 'ICl\u2084\u207b' },
    { formula: 'C2H4', expected: 'C\u2082H\u2084' },
    { formula: 'XeF2', expected: 'XeF\u2082' },
    { formula: 'XeF4', expected: 'XeF\u2084' },
];

unicodeTests.forEach(function(t) {
    var mol = R.molecules.find(function(m) { return m.formula === t.formula; });
    assert(mol, t.formula + ' found in database');
    if (mol) {
        assert(mol.display === t.expected,
            t.formula + ' display: got "' + mol.display + '", expected "' + t.expected + '"');
    }
});

// Test unicodeFormula() helper for dynamic formulas
var dynTests = [
    { input: 'CO2', expected: 'CO\u2082' },
    { input: 'NH4+', expected: 'NH\u2084\u207a' },
    { input: 'SF6', expected: 'SF\u2086' },
    { input: 'C2H6', expected: 'C\u2082H\u2086' },
    { input: 'PCl3', expected: 'PCl\u2083' },
];
dynTests.forEach(function(t) {
    var result = R.unicodeFormula(t.input);
    assert(result === t.expected,
        'unicodeFormula("' + t.input + '"): got "' + result + '", expected "' + t.expected + '"');
});

// ============================================================
// TEST 5: Formula parser - known molecules
// ============================================================
console.log('\n=== TEST 5: Formula Parser (Known Molecules) ===');
var parserTests = [
    // Simple molecules
    { formula: 'CO2', bp: 2, lp: 0, geom: 'Linear' },
    { formula: 'H2O', bp: 2, lp: 2, geom: 'Bent' },
    { formula: 'NH3', bp: 3, lp: 1, geom: 'Trigonal Pyramidal' },
    { formula: 'CH4', bp: 4, lp: 0, geom: 'Tetrahedral' },
    { formula: 'BF3', bp: 3, lp: 0, geom: 'Trigonal Planar' },
    { formula: 'SF6', bp: 6, lp: 0, geom: 'Octahedral' },
    { formula: 'PCl5', bp: 5, lp: 0, geom: 'Trigonal Bipyramidal' },
    { formula: 'SF4', bp: 4, lp: 1, geom: 'See-Saw' },
    { formula: 'ClF3', bp: 3, lp: 2, geom: 'T-Shaped' },
    { formula: 'XeF2', bp: 2, lp: 3, geom: 'Linear' },
    { formula: 'XeF4', bp: 4, lp: 2, geom: 'Square Planar' },
    { formula: 'BrF5', bp: 5, lp: 1, geom: 'Square Pyramidal' },
    { formula: 'IF7', bp: 7, lp: 0, geom: 'Pentagonal Bipyramidal' },
    // Ions
    { formula: 'NH4+', bp: 4, lp: 0, geom: 'Tetrahedral' },
    { formula: 'H3O+', bp: 3, lp: 1, geom: 'Trigonal Pyramidal' },
];

parserTests.forEach(function(t) {
    try {
        var result = R.parseMolecularFormula(t.formula);
        assert(result.bondingPairs === t.bp,
            t.formula + ' BP: got ' + result.bondingPairs + ', expected ' + t.bp);
        assert(result.lonePairs === t.lp,
            t.formula + ' LP: got ' + result.lonePairs + ', expected ' + t.lp);
        assert(result.data.molecularGeom === t.geom,
            t.formula + ' geometry: got "' + result.data.molecularGeom + '", expected "' + t.geom + '"');
    } catch(e) {
        fail++;
        errors.push('FAIL: parseMolecularFormula("' + t.formula + '") threw: ' + e.message);
    }
});

// ============================================================
// TEST 6: Formula parser - dynamic (not in database)
// ============================================================
console.log('\n=== TEST 6: Dynamic Formula Parser ===');
var dynamicTests = [
    { formula: 'SiF4', bp: 4, lp: 0, geom: 'Tetrahedral' },
    { formula: 'GeH4', bp: 4, lp: 0, geom: 'Tetrahedral' },
    { formula: 'PH3', bp: 3, lp: 1, geom: 'Trigonal Pyramidal' },
    { formula: 'SeF6', bp: 6, lp: 0, geom: 'Octahedral' },
    { formula: 'BH3', bp: 3, lp: 0, geom: 'Trigonal Planar' },
    { formula: 'SbF5', bp: 5, lp: 0, geom: 'Trigonal Bipyramidal' },
    { formula: 'TeF4', bp: 4, lp: 1, geom: 'See-Saw' },
    { formula: 'ICl3', bp: 3, lp: 2, geom: 'T-Shaped' },
];

dynamicTests.forEach(function(t) {
    try {
        var result = R.parseMolecularFormula(t.formula);
        assert(result.bondingPairs === t.bp,
            t.formula + ' (dynamic) BP: got ' + result.bondingPairs + ', expected ' + t.bp);
        assert(result.lonePairs === t.lp,
            t.formula + ' (dynamic) LP: got ' + result.lonePairs + ', expected ' + t.lp);
        assert(result.data.molecularGeom === t.geom,
            t.formula + ' (dynamic) geometry: got "' + result.data.molecularGeom + '", expected "' + t.geom + '"');
    } catch(e) {
        fail++;
        errors.push('FAIL: parseMolecularFormula("' + t.formula + '") threw: ' + e.message);
    }
});

// ============================================================
// TEST 7: Ion parsing
// ============================================================
console.log('\n=== TEST 7: Ion Parsing ===');
var ionTests = [
    { formula: 'NH4+', charge: -1, bp: 4 },
    { formula: 'NO3-', charge: 1, bp: 3 },
    { formula: 'H3O+', charge: -1, bp: 3 },
    { formula: 'PF6-', charge: 1, bp: 6 },
    { formula: 'I3-', charge: 1, bp: 2 },
    { formula: 'ICl4-', charge: 1, bp: 4 },
];

ionTests.forEach(function(t) {
    try {
        var result = R.parseMolecularFormula(t.formula);
        assert(result.charge === t.charge,
            t.formula + ' charge: got ' + result.charge + ', expected ' + t.charge);
        assert(result.bondingPairs === t.bp,
            t.formula + ' ion BP: got ' + result.bondingPairs + ', expected ' + t.bp);
    } catch(e) {
        fail++;
        errors.push('FAIL: ion parse "' + t.formula + '" threw: ' + e.message);
    }
});

// ============================================================
// TEST 8: Error cases
// ============================================================
console.log('\n=== TEST 8: Error Cases ===');
var errorCases = ['', 'Zz', '123', 'QQ5'];
errorCases.forEach(function(f) {
    try {
        R.parseMolecularFormula(f);
        fail++;
        errors.push('FAIL: parseMolecularFormula("' + f + '") should have thrown');
    } catch(e) {
        pass++;
    }
});

// ============================================================
// TEST 8b: Additional edge-case formulas
// ============================================================
console.log('\n=== TEST 8b: Edge Case Formulas ===');
var edgeCases = [
    // H-first formulas (H should not be central)
    { formula: 'HF', bp: 1, geom: 'Linear' },
    { formula: 'HCl', bp: 1, geom: 'Linear' },
    { formula: 'H2S', bp: 2, lp: 2, geom: 'Bent' },
    // Homonuclear
    { formula: 'O3', bp: 2, lp: 1, geom: 'Bent' },
    // Case insensitive database lookup
    { formula: 'co2', dbMatch: true },
    { formula: 'NH3', dbMatch: true },
    { formula: 'sf6', dbMatch: true },
    // Expanded octet molecules
    { formula: 'IF5', bp: 5, lp: 1, geom: 'Square Pyramidal' },
    { formula: 'BrF3', bp: 3, lp: 2, geom: 'T-Shaped' },
];

edgeCases.forEach(function(t) {
    if (t.dbMatch) {
        // Test that database lookup works case-insensitively
        var upper = t.formula.toUpperCase();
        var found = R.molecules.find(function(m) { return m.formula.toUpperCase() === upper; });
        assert(found, t.formula + ' found in database (case-insensitive)');
        return;
    }
    try {
        var result = R.parseMolecularFormula(t.formula);
        assert(result.bondingPairs === t.bp,
            t.formula + ' (edge) BP: got ' + result.bondingPairs + ', expected ' + t.bp);
        if (t.lp !== undefined) {
            assert(result.lonePairs === t.lp,
                t.formula + ' (edge) LP: got ' + result.lonePairs + ', expected ' + t.lp);
        }
        assert(result.data.molecularGeom === t.geom,
            t.formula + ' (edge) geometry: got "' + result.data.molecularGeom + '", expected "' + t.geom + '"');
    } catch(e) {
        fail++;
        errors.push('FAIL: edge case "' + t.formula + '" threw: ' + e.message);
    }
});

// ============================================================
// TEST 9: Geometry data completeness
// ============================================================
console.log('\n=== TEST 9: GeometryData Completeness ===');
// Every key should have all required fields
var geoFields = ['electronGeom', 'molecularGeom', 'angle', 'hybridization', 'notation', 'examples', 'description', 'diagram'];
Object.keys(R.geometryData).forEach(function(key) {
    var d = R.geometryData[key];
    geoFields.forEach(function(f) {
        assert(d[f] !== undefined && d[f] !== null,
            'geometryData["' + key + '"] has field "' + f + '"');
    });
});

// Verify critical keys exist
var criticalKeys = ['2-0','3-0','2-1','4-0','3-1','2-2','5-0','4-1','3-2','2-3','6-0','5-1','4-2','7-0'];
criticalKeys.forEach(function(k) {
    assert(R.geometryData[k], 'geometryData has key "' + k + '"');
});

// ============================================================
// TEST 10: All molecules geometry matches their stated geometry
// ============================================================
console.log('\n=== TEST 10: Database Geometry Consistency ===');
R.molecules.forEach(function(m) {
    var key = m.bp + '-' + m.lp;
    var data = R.geometryData[key];
    if (data) {
        // Special cases: some molecules have simplified geometry names
        var geoMatch = m.geometry === data.molecularGeom ||
            // Bent can come from different electron geometries
            (m.geometry === 'Bent' && data.molecularGeom === 'Bent') ||
            // Linear can come from multiple parent geometries
            (m.geometry === 'Linear' && data.molecularGeom === 'Linear');
        assert(geoMatch,
            m.formula + ' (' + m.display + '): stated geometry "' + m.geometry +
            '" matches geometryData "' + data.molecularGeom + '" for key ' + key);
    }
});

// ============================================================
// TEST 11: All molecules hybridization matches geometry data
// ============================================================
console.log('\n=== TEST 11: Hybridization Consistency ===');
R.molecules.forEach(function(m) {
    var key = m.bp + '-' + m.lp;
    var data = R.geometryData[key];
    if (data) {
        assert(m.hybridization === data.hybridization,
            m.formula + ' (' + m.display + '): hybridization "' + m.hybridization +
            '" matches geometryData "' + data.hybridization + '" for key ' + key);
    }
});

// ============================================================
// TEST 12: Every database molecule can be looked up by formula (case insensitive)
// ============================================================
console.log('\n=== TEST 12: Formula Lookup ===');
R.molecules.forEach(function(m) {
    var upper = m.formula.toUpperCase();
    var found = R.molecules.find(function(x) { return x.formula.toUpperCase() === upper; });
    assert(found && found.formula === m.formula,
        m.formula + ' can be found by case-insensitive lookup');
});

// ============================================================
// RESULTS
// ============================================================
console.log('\n' + '='.repeat(50));
console.log('RESULTS: ' + pass + ' passed, ' + fail + ' failed, ' + warnings + ' warnings');
console.log('='.repeat(50));

if (errors.length > 0) {
    console.log('\nFailures:');
    errors.forEach(function(e) { console.log('  ' + e); });
}

if (fail === 0) {
    console.log('\nAll tests passed!');
}

process.exit(fail > 0 ? 1 : 0);
