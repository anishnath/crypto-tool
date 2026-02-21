/**
 * Electronegativity & Polarity Checker - Render Module
 * EN data, polarity logic, 3D viewer with heatmap/charge coloring, bond dipole arrows
 */
(function() {
'use strict';

// ==================== Pauling Electronegativity Table ====================

var EN = {
    H:2.20, Li:0.98, Na:0.93, K:0.82, Be:1.57, Mg:1.31, Ca:1.00,
    B:2.04, Al:1.61, C:2.55, Si:1.90, N:3.04, P:2.19, As:2.18,
    O:3.44, S:2.58, Se:2.55, Te:2.10, F:3.98, Cl:3.16, Br:2.96,
    I:2.66, Xe:2.60, Kr:3.00
};

function getEN(symbol) {
    if (!symbol) return null;
    // Capitalize first letter
    var s = symbol.charAt(0).toUpperCase() + symbol.slice(1).toLowerCase();
    return EN[s] !== undefined ? EN[s] : null;
}

// ==================== Bond Classification ====================

function classifyBond(deltaEN) {
    if (deltaEN < 0.4) return { type: 'Nonpolar Covalent', css: 'ep-bond-nonpolar', color: '#059669' };
    if (deltaEN < 1.7) return { type: 'Polar Covalent', css: 'ep-bond-polar', color: '#4f46e5' };
    return { type: 'Ionic', css: 'ep-bond-ionic', color: '#dc2626' };
}

// ==================== Known Molecule Database ====================

var molecules = [
    { formula:'H2O', display:'H\u2082O', name:'Water', polar:true, dipole:1.85, geometry:'Bent', lp:2, reason:'Two lone pairs on O create asymmetric charge distribution. Bond dipoles do not cancel.', centralEN:3.44, bonds:[{a:'O',b:'H',count:2}] },
    { formula:'CO2', display:'CO\u2082', name:'Carbon Dioxide', polar:false, dipole:0, geometry:'Linear', lp:0, reason:'Linear geometry with identical C=O bonds. Opposing dipoles cancel perfectly.', centralEN:2.55, bonds:[{a:'C',b:'O',count:2}] },
    { formula:'NH3', display:'NH\u2083', name:'Ammonia', polar:true, dipole:1.47, geometry:'Trigonal Pyramidal', lp:1, reason:'One lone pair on N creates asymmetry. Bond dipoles add to net dipole pointing from N.', centralEN:3.04, bonds:[{a:'N',b:'H',count:3}] },
    { formula:'CH4', display:'CH\u2084', name:'Methane', polar:false, dipole:0, geometry:'Tetrahedral', lp:0, reason:'Perfect tetrahedral symmetry with identical C\u2013H bonds. All dipoles cancel.', centralEN:2.55, bonds:[{a:'C',b:'H',count:4}] },
    { formula:'CHCl3', display:'CHCl\u2083', name:'Chloroform', polar:true, dipole:1.04, geometry:'Tetrahedral', lp:0, reason:'Mixed substituents (1 H + 3 Cl) break tetrahedral symmetry. Net dipole toward Cl side.', centralEN:2.55, bonds:[{a:'C',b:'H',count:1},{a:'C',b:'Cl',count:3}] },
    { formula:'CCl4', display:'CCl\u2084', name:'Carbon Tetrachloride', polar:false, dipole:0, geometry:'Tetrahedral', lp:0, reason:'Perfect tetrahedral symmetry with identical C\u2013Cl bonds. All dipoles cancel.', centralEN:2.55, bonds:[{a:'C',b:'Cl',count:4}] },
    { formula:'HCl', display:'HCl', name:'Hydrogen Chloride', polar:true, dipole:1.09, geometry:'Linear', lp:3, reason:'Diatomic molecule with \u0394EN = 0.96. Single bond dipole is the molecular dipole.', centralEN:3.16, bonds:[{a:'Cl',b:'H',count:1}] },
    { formula:'HF', display:'HF', name:'Hydrogen Fluoride', polar:true, dipole:1.82, geometry:'Linear', lp:3, reason:'Diatomic with largest \u0394EN (1.78). Strong bond dipole H\u2192F.', centralEN:3.98, bonds:[{a:'F',b:'H',count:1}] },
    { formula:'BF3', display:'BF\u2083', name:'Boron Trifluoride', polar:false, dipole:0, geometry:'Trigonal Planar', lp:0, reason:'Trigonal planar with three identical B\u2013F bonds at 120\u00b0. Dipoles cancel by symmetry.', centralEN:2.04, bonds:[{a:'B',b:'F',count:3}] },
    { formula:'SF6', display:'SF\u2086', name:'Sulfur Hexafluoride', polar:false, dipole:0, geometry:'Octahedral', lp:0, reason:'Octahedral symmetry with six identical S\u2013F bonds. All dipoles cancel.', centralEN:2.58, bonds:[{a:'S',b:'F',count:6}] },
    { formula:'SO2', display:'SO\u2082', name:'Sulfur Dioxide', polar:true, dipole:1.63, geometry:'Bent', lp:1, reason:'Bent shape from lone pair on S. Two S=O dipoles do not cancel due to angular geometry.', centralEN:2.58, bonds:[{a:'S',b:'O',count:2}] },
    { formula:'H2S', display:'H\u2082S', name:'Hydrogen Sulfide', polar:true, dipole:0.97, geometry:'Bent', lp:2, reason:'Bent geometry with two lone pairs on S. Bond dipoles add to net dipole.', centralEN:2.58, bonds:[{a:'S',b:'H',count:2}] },
    { formula:'CS2', display:'CS\u2082', name:'Carbon Disulfide', polar:false, dipole:0, geometry:'Linear', lp:0, reason:'Linear geometry with identical C=S bonds. Opposing dipoles cancel.', centralEN:2.55, bonds:[{a:'C',b:'S',count:2}] },
    { formula:'NF3', display:'NF\u2083', name:'Nitrogen Trifluoride', polar:true, dipole:0.23, geometry:'Trigonal Pyramidal', lp:1, reason:'Trigonal pyramidal but low dipole because N lone pair opposes N\u2013F bond dipoles.', centralEN:3.04, bonds:[{a:'N',b:'F',count:3}] },
    { formula:'OF2', display:'OF\u2082', name:'Oxygen Difluoride', polar:true, dipole:0.30, geometry:'Bent', lp:2, reason:'Bent with 2 lone pairs on O. Small \u0394EN (0.54) but asymmetric geometry gives net dipole.', centralEN:3.44, bonds:[{a:'O',b:'F',count:2}] },
    { formula:'PCl3', display:'PCl\u2083', name:'Phosphorus Trichloride', polar:true, dipole:0.56, geometry:'Trigonal Pyramidal', lp:1, reason:'Trigonal pyramidal with lone pair on P. Bond dipoles do not cancel.', centralEN:2.19, bonds:[{a:'P',b:'Cl',count:3}] },
    { formula:'PCl5', display:'PCl\u2085', name:'Phosphorus Pentachloride', polar:false, dipole:0, geometry:'Trigonal Bipyramidal', lp:0, reason:'Trigonal bipyramidal with identical P\u2013Cl bonds. Axial and equatorial dipoles cancel.', centralEN:2.19, bonds:[{a:'P',b:'Cl',count:5}] },
    { formula:'SF4', display:'SF\u2084', name:'Sulfur Tetrafluoride', polar:true, dipole:0.63, geometry:'See-Saw', lp:1, reason:'See-saw shape from one equatorial lone pair. Asymmetric arrangement of S\u2013F bonds.', centralEN:2.58, bonds:[{a:'S',b:'F',count:4}] },
    { formula:'XeF2', display:'XeF\u2082', name:'Xenon Difluoride', polar:false, dipole:0, geometry:'Linear', lp:3, reason:'Linear molecular geometry (3 equatorial lone pairs). Two Xe\u2013F bonds oppose and cancel.', centralEN:2.60, bonds:[{a:'Xe',b:'F',count:2}] },
    { formula:'XeF4', display:'XeF\u2084', name:'Xenon Tetrafluoride', polar:false, dipole:0, geometry:'Square Planar', lp:2, reason:'Square planar with trans lone pairs. All Xe\u2013F dipoles cancel by symmetry.', centralEN:2.60, bonds:[{a:'Xe',b:'F',count:4}] },
    { formula:'NO2', display:'NO\u2082', name:'Nitrogen Dioxide', polar:true, dipole:0.32, geometry:'Bent', lp:0.5, reason:'Bent geometry (odd electron). N\u2013O bond dipoles do not fully cancel.', centralEN:3.04, bonds:[{a:'N',b:'O',count:2}] },
    { formula:'ClF3', display:'ClF\u2083', name:'Chlorine Trifluoride', polar:true, dipole:0.56, geometry:'T-Shaped', lp:2, reason:'T-shaped from 2 equatorial lone pairs. Asymmetric Cl\u2013F arrangement.', centralEN:3.16, bonds:[{a:'Cl',b:'F',count:3}] },
    { formula:'CH2Cl2', display:'CH\u2082Cl\u2082', name:'Dichloromethane', polar:true, dipole:1.60, geometry:'Tetrahedral', lp:0, reason:'Tetrahedral but mixed substituents (2 H + 2 Cl). Dipoles do not cancel.', centralEN:2.55, bonds:[{a:'C',b:'H',count:2},{a:'C',b:'Cl',count:2}] },
    { formula:'PH3', display:'PH\u2083', name:'Phosphine', polar:true, dipole:0.58, geometry:'Trigonal Pyramidal', lp:1, reason:'Trigonal pyramidal with lone pair on P. Small \u0394EN but asymmetric shape.', centralEN:2.19, bonds:[{a:'P',b:'H',count:3}] },
    { formula:'AsH3', display:'AsH\u2083', name:'Arsine', polar:true, dipole:0.22, geometry:'Trigonal Pyramidal', lp:1, reason:'Trigonal pyramidal with lone pair. Very small \u0394EN (0.02) but asymmetric geometry.', centralEN:2.18, bonds:[{a:'As',b:'H',count:3}] },
    { formula:'BrF5', display:'BrF\u2085', name:'Bromine Pentafluoride', polar:true, dipole:1.51, geometry:'Square Pyramidal', lp:1, reason:'Square pyramidal with one lone pair. Axial Br\u2013F not balanced by opposite atom.', centralEN:2.96, bonds:[{a:'Br',b:'F',count:5}] },
    { formula:'HBr', display:'HBr', name:'Hydrogen Bromide', polar:true, dipole:0.82, geometry:'Linear', lp:3, reason:'Diatomic with \u0394EN = 0.76. Bond dipole H\u2192Br is the molecular dipole.', centralEN:2.96, bonds:[{a:'Br',b:'H',count:1}] },
    { formula:'HI', display:'HI', name:'Hydrogen Iodide', polar:true, dipole:0.44, geometry:'Linear', lp:3, reason:'Diatomic with \u0394EN = 0.46. Weakly polar due to smaller EN difference.', centralEN:2.66, bonds:[{a:'I',b:'H',count:1}] },
    { formula:'BCl3', display:'BCl\u2083', name:'Boron Trichloride', polar:false, dipole:0, geometry:'Trigonal Planar', lp:0, reason:'Trigonal planar with three identical B\u2013Cl bonds at 120\u00b0. Dipoles cancel.', centralEN:2.04, bonds:[{a:'B',b:'Cl',count:3}] },
    { formula:'SiH4', display:'SiH\u2084', name:'Silane', polar:false, dipole:0, geometry:'Tetrahedral', lp:0, reason:'Tetrahedral symmetry with four identical Si\u2013H bonds. Dipoles cancel.', centralEN:1.90, bonds:[{a:'Si',b:'H',count:4}] }
];

// ==================== Unicode Formula Helper ====================

var subscriptMap = { '0':'\u2080','1':'\u2081','2':'\u2082','3':'\u2083','4':'\u2084','5':'\u2085','6':'\u2086','7':'\u2087','8':'\u2088','9':'\u2089' };
var superscriptMap = { '0':'\u2070','1':'\u00b9','2':'\u00b2','3':'\u00b3','4':'\u2074','5':'\u2075','6':'\u2076','7':'\u2077','8':'\u2078','9':'\u2079','+':'\u207a','-':'\u207b' };

function unicodeFormula(formula) {
    return formula.replace(/(\d+)/g, function(m) {
        var out = '';
        for (var i = 0; i < m.length; i++) out += subscriptMap[m[i]] || m[i];
        return out;
    }).replace(/([+-])$/, function(m) {
        return superscriptMap[m] || m;
    });
}

// ==================== Formula Parser ====================

function parseMolecularFormula(formula) {
    var clean = formula.replace(/\s+/g, '');
    var elementRegex = /([A-Z][a-z]?)(\d*)/g;
    var elements = [];
    var match;
    while ((match = elementRegex.exec(clean)) !== null) {
        if (match[1]) {
            elements.push({ symbol: match[1], count: match[2] ? parseInt(match[2]) : 1 });
        }
    }
    if (elements.length === 0) return null;
    return elements;
}

// ==================== PubChem Integration ====================

var pubchemCache = {};

function fetchPubChem3D(query) {
    var clean = query.replace(/\s+/g, '').replace(/\(\d*[+-]\)$/, '').replace(/[+-]$/, '');
    if (!clean) return Promise.resolve(null);
    if (pubchemCache[clean.toUpperCase()]) {
        return Promise.resolve(pubchemCache[clean.toUpperCase()]);
    }
    var cidUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/formula/' +
        encodeURIComponent(clean) + '/cids/JSON?MaxRecords=1';
    var nameUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/' +
        encodeURIComponent(clean) + '/cids/JSON?MaxRecords=1';

    return fetchCIDFromUrl(cidUrl)
        .then(function(cid) {
            if (cid) return cid;
            return fetchCIDFromUrl(nameUrl);
        })
        .then(function(cid) {
            if (!cid) return null;
            var sdfUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' + cid + '/SDF?record_type=3d';
            return fetch(sdfUrl)
                .then(function(resp) { return resp.ok ? resp.text() : null; })
                .then(function(sdf) {
                    if (!sdf || (sdf.indexOf('V2000') === -1 && sdf.indexOf('V3000') === -1)) return null;
                    var result = { sdf: sdf, cid: cid };
                    pubchemCache[clean.toUpperCase()] = result;
                    return result;
                });
        })
        .catch(function() { return null; });
}

function fetchCIDFromUrl(url) {
    return fetch(url)
        .then(function(resp) { return resp.ok ? resp.json() : null; })
        .then(function(data) {
            if (data && data.IdentifierList && data.IdentifierList.CID && data.IdentifierList.CID.length > 0) {
                return data.IdentifierList.CID[0];
            }
            if (data && data.Waiting) {
                var listKey = data.Waiting.ListKey;
                return new Promise(function(resolve) { setTimeout(resolve, 2000); })
                    .then(function() {
                        return fetch('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/listkey/' + listKey + '/cids/JSON?MaxRecords=1');
                    })
                    .then(function(resp) { return resp.ok ? resp.json() : null; })
                    .then(function(data2) {
                        if (data2 && data2.IdentifierList && data2.IdentifierList.CID && data2.IdentifierList.CID.length > 0) {
                            return data2.IdentifierList.CID[0];
                        }
                        return null;
                    })
                    .catch(function() { return null; });
            }
            return null;
        })
        .catch(function() { return null; });
}

function fetchPubChemChargesByCID(cid) {
    if (!cid) return Promise.resolve(null);
    var url = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' +
        cid + '/record/JSON?record_type=3d';
    return fetch(url)
        .then(function(resp) { return resp.ok ? resp.json() : null; })
        .then(function(data) {
            if (!data || !data.PC_Compounds || !data.PC_Compounds[0]) return null;
            var compound = data.PC_Compounds[0];
            if (!compound.props) return null;
            for (var i = 0; i < compound.props.length; i++) {
                var prop = compound.props[i];
                if (prop.urn && prop.urn.label === 'MMFF94 Partial Charges') {
                    if (prop.value && prop.value.slist && prop.value.slist.string) {
                        var charges = {};
                        var lines = prop.value.slist.string;
                        for (var j = 0; j < lines.length; j++) {
                            var parts = lines[j].trim().split(/\s+/);
                            if (parts.length >= 2) {
                                charges[parseInt(parts[0]) - 1] = parseFloat(parts[1]);
                            }
                        }
                        return charges;
                    }
                }
            }
            return null;
        })
        .catch(function() { return null; });
}

// ==================== SDF Parser ====================

function parseSDF(sdf) {
    var lines = sdf.split('\n');
    var countsIdx = -1;
    for (var i = 0; i < Math.min(lines.length, 10); i++) {
        if (lines[i].indexOf('V2000') !== -1 || lines[i].indexOf('V3000') !== -1) {
            countsIdx = i;
            break;
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
        atoms.push({ x: parseFloat(parts[0]), y: parseFloat(parts[1]), z: parseFloat(parts[2]), elem: parts[3] });
    }

    var bonds = [];
    for (var b = 0; b < numBonds; b++) {
        var bline = lines[countsIdx + 1 + numAtoms + b];
        if (!bline) continue;
        var bparts = bline.trim().split(/\s+/);
        if (bparts.length < 3) continue;
        bonds.push({ from: parseInt(bparts[0]) - 1, to: parseInt(bparts[1]) - 1, order: parseInt(bparts[2]) });
    }
    return { atoms: atoms, bonds: bonds };
}

// ==================== Parse MMFF94 Charges from SDF Properties ====================

function parseChargesFromSDF(sdf) {
    if (!sdf) return null;
    var marker = '> <PUBCHEM_MMFF94_PARTIAL_CHARGES>';
    var idx = sdf.indexOf(marker);
    if (idx === -1) return null;
    var after = sdf.substring(idx + marker.length).trim();
    var lines = after.split('\n');
    if (lines.length < 2) return null;
    var count = parseInt(lines[0].trim());
    if (!count || count === 0) return null;
    var charges = {};
    for (var i = 1; i <= count && i < lines.length; i++) {
        var parts = lines[i].trim().split(/\s+/);
        if (parts.length >= 2) {
            charges[parseInt(parts[0]) - 1] = parseFloat(parts[1]);
        }
    }
    return Object.keys(charges).length > 0 ? charges : null;
}

// ==================== EN Color Mapping ====================

// Map EN value to color: blue (low, 0.82) -> white (mid, ~2.4) -> red (high, 3.98)
function enToColor(en) {
    var minEN = 0.82, maxEN = 3.98, midEN = (minEN + maxEN) / 2;
    var r, g, b;
    if (en <= midEN) {
        var t = (en - minEN) / (midEN - minEN);
        t = Math.max(0, Math.min(1, t));
        r = Math.round(66 + t * (255 - 66));
        g = Math.round(133 + t * (255 - 133));
        b = Math.round(244 + t * (255 - 244));
    } else {
        var t2 = (en - midEN) / (maxEN - midEN);
        t2 = Math.max(0, Math.min(1, t2));
        r = 255;
        g = Math.round(255 - t2 * (255 - 68));
        b = Math.round(255 - t2 * (255 - 68));
    }
    return 'rgb(' + r + ',' + g + ',' + b + ')';
}

function enToHex(en) {
    var minEN = 0.82, maxEN = 3.98, midEN = (minEN + maxEN) / 2;
    var r, g, b;
    if (en <= midEN) {
        var t = Math.max(0, Math.min(1, (en - minEN) / (midEN - minEN)));
        r = Math.round(66 + t * 189);
        g = Math.round(133 + t * 122);
        b = Math.round(244 + t * 11);
    } else {
        var t2 = Math.max(0, Math.min(1, (en - midEN) / (maxEN - midEN)));
        r = 255;
        g = Math.round(255 - t2 * 187);
        b = Math.round(255 - t2 * 187);
    }
    return '0x' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
}

// Map partial charge to color: red (negative, \u03b4\u207b) -> white (0) -> blue (positive, \u03b4\u207a)
function chargeToColor(charge) {
    var maxC = 0.6;
    var t = Math.max(-1, Math.min(1, charge / maxC));
    var r, g, b;
    if (t <= 0) {
        // negative charge -> red
        var s = -t;
        r = 255;
        g = Math.round(255 - s * 187);
        b = Math.round(255 - s * 187);
    } else {
        // positive charge -> blue
        r = Math.round(255 - t * 189);
        g = Math.round(255 - t * 122);
        b = 255;
    }
    return '0x' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1);
}

// ==================== Polarity Verdict Logic ====================

function findMolecule(query) {
    var q = query.replace(/\s+/g, '').toUpperCase();
    for (var i = 0; i < molecules.length; i++) {
        if (molecules[i].formula.toUpperCase() === q || molecules[i].name.toUpperCase() === q) {
            return molecules[i];
        }
    }
    return null;
}

function buildENAnalysis(query) {
    var mol = findMolecule(query);
    if (mol) {
        // Known molecule path
        var bondDetails = [];
        for (var i = 0; i < mol.bonds.length; i++) {
            var bond = mol.bonds[i];
            var enA = getEN(bond.a);
            var enB = getEN(bond.b);
            if (enA !== null && enB !== null) {
                var delta = Math.abs(enA - enB);
                var cls = classifyBond(delta);
                for (var c = 0; c < bond.count; c++) {
                    bondDetails.push({
                        atomA: bond.a, atomB: bond.b,
                        enA: enA, enB: enB,
                        delta: delta, type: cls.type, css: cls.css
                    });
                }
            }
        }
        return {
            known: true,
            formula: mol.formula,
            display: mol.display,
            name: mol.name,
            polar: mol.polar,
            dipole: mol.dipole,
            geometry: mol.geometry,
            lp: mol.lp,
            reason: mol.reason,
            bonds: bondDetails
        };
    }

    // Unknown molecule — parse formula and compute from EN values
    var elements = parseMolecularFormula(query);
    if (!elements || elements.length === 0) return null;

    // First element is central atom for simple molecules
    var central = elements[0].symbol;
    var centralEN = getEN(central);
    if (centralEN === null) return null;

    var bondDetails2 = [];
    var allSameTerminal = true;
    var firstTerminal = elements.length > 1 ? elements[1].symbol : null;

    for (var j = 1; j < elements.length; j++) {
        var sym = elements[j].symbol;
        var termEN = getEN(sym);
        if (termEN === null) continue;
        if (sym !== firstTerminal) allSameTerminal = false;
        var d = Math.abs(centralEN - termEN);
        var cl = classifyBond(d);
        for (var k = 0; k < elements[j].count; k++) {
            bondDetails2.push({
                atomA: central, atomB: sym,
                enA: centralEN, enB: termEN,
                delta: d, type: cl.type, css: cl.css
            });
        }
    }

    // Simple polarity heuristic: if all terminals same and common symmetric geometries
    var totalBonds = bondDetails2.length;
    var maxDelta = 0;
    for (var m = 0; m < bondDetails2.length; m++) {
        if (bondDetails2[m].delta > maxDelta) maxDelta = bondDetails2[m].delta;
    }

    var polarGuess = true;
    var reasonGuess = 'Mixed terminal atoms or asymmetric geometry likely produces a net dipole.';

    if (allSameTerminal && maxDelta < 0.4) {
        polarGuess = false;
        reasonGuess = 'Very small \u0394EN between bonds and likely symmetric geometry. Probably nonpolar.';
    } else if (allSameTerminal && (totalBonds === 2 || totalBonds === 4 || totalBonds === 6)) {
        polarGuess = false;
        reasonGuess = 'Symmetric geometry (' + totalBonds + ' identical bonds) likely cancels dipoles. Check the 3D model.';
    }

    return {
        known: false,
        formula: query,
        display: unicodeFormula(query),
        name: null,
        polar: polarGuess,
        dipole: null,
        geometry: null,
        lp: null,
        reason: reasonGuess,
        bonds: bondDetails2
    };
}

// ==================== 3D Viewer Builder ====================

function buildEPViewer(container, sdfData, analysis, charges) {
    if (typeof $3Dmol === 'undefined') return null;

    var parsed = parseSDF(sdfData);
    if (!parsed || parsed.atoms.length === 0) return null;

    var wrapper = document.createElement('div');
    wrapper.className = 'ep-3d-wrapper';

    var viewerDiv = document.createElement('div');
    viewerDiv.className = 'ep-3d-viewer';
    wrapper.appendChild(viewerDiv);

    container.appendChild(wrapper);

    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    var bgColor = isDark ? '#1e293b' : '#ffffff';

    var viewer = $3Dmol.createViewer(viewerDiv, {
        backgroundColor: bgColor,
        antialias: true,
        preserveDrawingBuffer: true
    });

    viewer.addModel(sdfData, 'sdf');

    // Default: CPK colors
    viewer.setStyle({}, {
        stick: { radius: 0.12, colorscheme: 'Jmol' },
        sphere: { scale: 0.3, colorscheme: 'Jmol' }
    });

    var currentMode = 'cpk';
    var dipolesVisible = true;
    var dipoleShapes = [];

    function applyMode(mode) {
        currentMode = mode;
        viewer.removeAllLabels();

        if (mode === 'cpk') {
            viewer.setStyle({}, {
                stick: { radius: 0.12, colorscheme: 'Jmol' },
                sphere: { scale: 0.3, colorscheme: 'Jmol' }
            });
        } else if (mode === 'en') {
            // EN heatmap
            var atomStyles = {};
            for (var i = 0; i < parsed.atoms.length; i++) {
                var en = getEN(parsed.atoms[i].elem);
                var hexColor = en !== null ? parseInt(enToHex(en), 16) : 0xcccccc;
                atomStyles[i] = { stick: { radius: 0.12, color: hexColor }, sphere: { scale: 0.3, color: hexColor } };
            }
            for (var idx in atomStyles) {
                viewer.setStyle({ index: parseInt(idx) }, atomStyles[idx]);
            }
            // Add EN labels
            for (var k = 0; k < parsed.atoms.length; k++) {
                var enVal = getEN(parsed.atoms[k].elem);
                if (enVal !== null) {
                    viewer.addLabel(parsed.atoms[k].elem + ' ' + enVal.toFixed(2), {
                        position: { x: parsed.atoms[k].x, y: parsed.atoms[k].y, z: parsed.atoms[k].z },
                        fontSize: 9, fontColor: isDark ? '#e2e8f0' : '#334155',
                        backgroundColor: 'transparent', borderThickness: 0, showBackground: false
                    });
                }
            }
        } else if (mode === 'charge' && charges) {
            for (var j = 0; j < parsed.atoms.length; j++) {
                var ch = charges[j] || 0;
                var chHex = parseInt(chargeToColor(ch), 16);
                viewer.setStyle({ index: j }, { stick: { radius: 0.12, color: chHex }, sphere: { scale: 0.3, color: chHex } });
                var label = ch >= 0 ? '\u03b4+' : '\u03b4\u2212';
                if (Math.abs(ch) > 0.05) {
                    viewer.addLabel(label + Math.abs(ch).toFixed(2), {
                        position: { x: parsed.atoms[j].x, y: parsed.atoms[j].y, z: parsed.atoms[j].z },
                        fontSize: 9, fontColor: ch < 0 ? '#dc2626' : '#2563eb',
                        backgroundColor: 'transparent', borderThickness: 0, showBackground: false
                    });
                }
            }
        } else {
            // Fallback to EN heatmap if charges unavailable
            applyMode('en');
            return;
        }
        viewer.render();
    }

    function addDipoleArrows() {
        // Remove existing arrows
        for (var r = 0; r < dipoleShapes.length; r++) {
            viewer.removeShape(dipoleShapes[r]);
        }
        dipoleShapes = [];

        if (!dipolesVisible) { viewer.render(); return; }

        for (var i = 0; i < parsed.bonds.length; i++) {
            var bond = parsed.bonds[i];
            var atomA = parsed.atoms[bond.from];
            var atomB = parsed.atoms[bond.to];
            if (!atomA || !atomB) continue;

            var enA = getEN(atomA.elem);
            var enB = getEN(atomB.elem);
            if (enA === null || enB === null) continue;

            var delta = Math.abs(enA - enB);
            if (delta < 0.4) continue; // skip nonpolar bonds

            // Arrow from low EN to high EN (dipole direction: + to -)
            var startAtom, endAtom;
            if (enA < enB) { startAtom = atomA; endAtom = atomB; }
            else { startAtom = atomB; endAtom = atomA; }

            var shape = viewer.addArrow({
                start: { x: startAtom.x, y: startAtom.y, z: startAtom.z },
                end: { x: endAtom.x, y: endAtom.y, z: endAtom.z },
                radius: 0.06,
                radiusRatio: 2.5,
                mid: 0.7,
                color: '#4f46e5',
                opacity: 0.7
            });
            dipoleShapes.push(shape);
        }
        viewer.render();
    }

    addDipoleArrows();
    viewer.zoomTo();
    viewer.render();
    viewer.spin('y', 0.5);

    // Controls
    var controls = document.createElement('div');
    controls.className = 'ep-viewer-controls';

    var modes = [
        { id: 'cpk', label: 'CPK Colors' },
        { id: 'en', label: 'EN Heatmap' },
        { id: 'charge', label: 'Charge Map' }
    ];

    var modeButtons = [];
    for (var mi = 0; mi < modes.length; mi++) {
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'ep-viewer-ctrl-btn' + (modes[mi].id === 'cpk' ? ' active' : '');
        btn.textContent = modes[mi].label;
        btn.setAttribute('data-mode', modes[mi].id);
        if (modes[mi].id === 'charge' && !charges) {
            btn.disabled = true;
            btn.style.opacity = '0.4';
            btn.title = 'No charge data available';
        }
        btn.addEventListener('click', (function(m) {
            return function() {
                applyMode(m);
                for (var x = 0; x < modeButtons.length; x++) modeButtons[x].classList.remove('active');
                this.classList.add('active');
                addDipoleArrows();
            };
        })(modes[mi].id));
        controls.appendChild(btn);
        modeButtons.push(btn);
    }

    // Dipoles toggle
    var dipoleBtn = document.createElement('button');
    dipoleBtn.type = 'button';
    dipoleBtn.className = 'ep-viewer-ctrl-btn active';
    dipoleBtn.textContent = 'Dipoles: On';
    dipoleBtn.addEventListener('click', function() {
        dipolesVisible = !dipolesVisible;
        this.textContent = 'Dipoles: ' + (dipolesVisible ? 'On' : 'Off');
        this.classList.toggle('active', dipolesVisible);
        addDipoleArrows();
    });
    controls.appendChild(dipoleBtn);

    // Spin toggle
    var spinning = true;
    var spinBtn = document.createElement('button');
    spinBtn.type = 'button';
    spinBtn.className = 'ep-viewer-ctrl-btn';
    spinBtn.textContent = 'Spin: On';
    spinBtn.addEventListener('click', function() {
        spinning = !spinning;
        viewer.spin(spinning ? 'y' : false, 0.5);
        this.textContent = 'Spin: ' + (spinning ? 'On' : 'Off');
    });
    controls.appendChild(spinBtn);

    // Reset view
    var resetBtn = document.createElement('button');
    resetBtn.type = 'button';
    resetBtn.className = 'ep-viewer-ctrl-btn';
    resetBtn.textContent = 'Reset View';
    resetBtn.addEventListener('click', function() {
        viewer.zoomTo();
        viewer.render();
    });
    controls.appendChild(resetBtn);

    wrapper.appendChild(controls);

    var hint = document.createElement('div');
    hint.className = 'ep-viewer-hint';
    hint.textContent = 'Drag to rotate \u00b7 Scroll to zoom \u00b7 Right-drag to pan';
    wrapper.appendChild(hint);

    return wrapper;
}

// ==================== Result Rendering ====================

function buildResultGrid(analysis) {
    var grid = document.createElement('div');
    grid.className = 'ep-result-grid';

    var items = [];
    if (analysis.name) items.push({ label: 'Molecule', value: analysis.name });
    items.push({ label: 'Formula', value: analysis.display });
    if (analysis.geometry) items.push({ label: 'Geometry', value: analysis.geometry });
    if (analysis.dipole !== null && analysis.dipole !== undefined) items.push({ label: 'Dipole Moment', value: analysis.dipole + ' D' });
    if (analysis.lp !== null && analysis.lp !== undefined) items.push({ label: 'Lone Pairs', value: String(analysis.lp) });
    items.push({ label: 'Polarity', value: analysis.polar ? 'Polar' : 'Nonpolar' });

    for (var i = 0; i < items.length; i++) {
        var item = document.createElement('div');
        item.className = 'ep-result-item';
        item.innerHTML = '<div class="ep-result-label">' + items[i].label + '</div>' +
            '<div class="ep-result-value">' + items[i].value + '</div>';
        grid.appendChild(item);
    }
    return grid;
}

function buildBondTable(analysis) {
    var wrap = document.createElement('div');
    wrap.className = 'ep-bond-table-wrap';

    var table = document.createElement('table');
    table.className = 'ep-bond-table';

    var thead = '<thead><tr><th>Bond</th><th>EN(A)</th><th>EN(B)</th><th>\u0394EN</th><th>Type</th></tr></thead>';
    table.innerHTML = thead;

    var tbody = document.createElement('tbody');
    for (var i = 0; i < analysis.bonds.length; i++) {
        var b = analysis.bonds[i];
        var tr = document.createElement('tr');
        tr.innerHTML = '<td style="font-family:var(--font-mono);font-weight:600;">' + b.atomA + '\u2013' + b.atomB + '</td>' +
            '<td>' + b.enA.toFixed(2) + '</td>' +
            '<td>' + b.enB.toFixed(2) + '</td>' +
            '<td style="font-weight:700;">' + b.delta.toFixed(2) + '</td>' +
            '<td><span class="ep-bond-type-badge ' + b.css + '">' + b.type + '</span></td>';
        tbody.appendChild(tr);
    }
    table.appendChild(tbody);
    wrap.appendChild(table);
    return wrap;
}

function buildVerdictCard(analysis) {
    var card = document.createElement('div');
    card.className = 'ep-verdict-card';

    var title = analysis.polar ? 'This molecule is POLAR' : 'This molecule is NONPOLAR';
    card.innerHTML = '<h4>' + title + '</h4><p>' + analysis.reason + '</p>';
    return card;
}

function buildStep(num, desc, math) {
    var step = document.createElement('div');
    step.className = 'ep-step';
    step.innerHTML = '<div class="ep-step-number">' + num + '</div>' +
        '<div class="ep-step-content">' +
            '<div class="ep-step-desc">' + desc + '</div>' +
            (math ? '<div class="ep-step-math">' + math + '</div>' : '') +
        '</div>';
    return step;
}

function buildStepsSection(analysis) {
    var toggle = document.createElement('button');
    toggle.type = 'button';
    toggle.className = 'ep-steps-toggle';
    toggle.innerHTML = '<span>Step-by-Step Polarity Analysis</span>' +
        '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg>';

    var wrap = document.createElement('div');
    wrap.className = 'ep-steps-wrap';

    // Step 1: Identify central atom
    var centralAtom = analysis.bonds.length > 0 ? analysis.bonds[0].atomA : '?';
    wrap.appendChild(buildStep(1, 'Identify the central atom and bonds',
        'Central atom: ' + centralAtom + ' with ' + analysis.bonds.length + ' bond(s)'));

    // Step 2: EN values
    var enList = [];
    var seen = {};
    for (var i = 0; i < analysis.bonds.length; i++) {
        var b = analysis.bonds[i];
        if (!seen[b.atomA]) { enList.push(b.atomA + ' = ' + b.enA.toFixed(2)); seen[b.atomA] = true; }
        if (!seen[b.atomB]) { enList.push(b.atomB + ' = ' + b.enB.toFixed(2)); seen[b.atomB] = true; }
    }
    wrap.appendChild(buildStep(2, 'Look up Pauling electronegativity values', enList.join(', ')));

    // Step 3: Delta EN
    var deltaList = [];
    for (var j = 0; j < analysis.bonds.length; j++) {
        var bd = analysis.bonds[j];
        deltaList.push(bd.atomA + '\u2013' + bd.atomB + ': \u0394EN = |' + bd.enA.toFixed(2) + ' \u2212 ' + bd.enB.toFixed(2) + '| = ' + bd.delta.toFixed(2) + ' (' + bd.type + ')');
    }
    wrap.appendChild(buildStep(3, 'Calculate \u0394EN per bond', deltaList.join(' | ')));

    // Step 4: Geometry
    if (analysis.geometry) {
        wrap.appendChild(buildStep(4, 'Determine molecular geometry (VSEPR)',
            'Geometry: ' + analysis.geometry + (analysis.lp !== null ? ' (' + analysis.lp + ' lone pair' + (analysis.lp !== 1 ? 's' : '') + ')' : '')));
    } else {
        wrap.appendChild(buildStep(4, 'Determine molecular geometry', 'Enter the formula to determine geometry via VSEPR theory.'));
    }

    // Step 5: Symmetry
    wrap.appendChild(buildStep(5, 'Check symmetry \u2014 do dipoles cancel?', analysis.reason));

    // Step 6: Verdict
    var verdictText = analysis.polar ? 'POLAR' : 'NONPOLAR';
    if (analysis.dipole !== null && analysis.dipole !== undefined) {
        verdictText += ' (dipole moment = ' + analysis.dipole + ' D)';
    }
    wrap.appendChild(buildStep(6, 'Verdict', verdictText));

    toggle.addEventListener('click', function() {
        toggle.classList.toggle('open');
        wrap.classList.toggle('open');
    });

    var frag = document.createDocumentFragment();
    frag.appendChild(toggle);
    frag.appendChild(wrap);
    return frag;
}

// ==================== Main Render Function ====================

function renderENResult(container, analysis, sdfData, charges) {
    container.innerHTML = '';

    // Verdict badge
    var badgeClass = analysis.polar ? 'ep-verdict-polar' : 'ep-verdict-nonpolar';
    var badge = document.createElement('div');
    badge.className = 'ep-verdict-badge ' + badgeClass;
    badge.textContent = analysis.polar ? 'POLAR' : 'NONPOLAR';
    container.appendChild(badge);

    // Result grid
    container.appendChild(buildResultGrid(analysis));

    // Bond table
    if (analysis.bonds.length > 0) {
        container.appendChild(buildBondTable(analysis));
    }

    // Verdict card
    container.appendChild(buildVerdictCard(analysis));

    // 3D viewer
    if (sdfData) {
        buildEPViewer(container, sdfData, analysis, charges);
    } else {
        var placeholder = document.createElement('div');
        placeholder.className = 'ep-3d-loading';
        placeholder.innerHTML = '<div class="ep-3d-loading-spinner"></div><div class="ep-3d-loading-text">Loading 3D model from PubChem...</div>';
        container.appendChild(placeholder);
    }

    // Steps
    container.appendChild(buildStepsSection(analysis));
}

function renderByFormula(container, query) {
    var analysis = buildENAnalysis(query);
    if (!analysis) {
        showError(container, 'Could not analyze "' + query.replace(/[<>&"]/g, '') + '". Try a formula like H2O or a name like Water.');
        return;
    }

    // Check local SDF cache first (instant, no network)
    var lookupQuery = analysis.name || analysis.formula;
    var cached = window.EPSdfCache && window.EPSdfCache.get(lookupQuery);
    if (!cached) cached = window.EPSdfCache && window.EPSdfCache.get(analysis.formula);

    if (cached) {
        // Instant render from embedded cache — no network request
        var cachedCharges = parseChargesFromSDF(cached.sdf);
        renderENResult(container, analysis, cached.sdf, cachedCharges);
        return;
    }

    // Not cached — show loading state and fetch from PubChem (hybrid fallback)
    container.innerHTML = '';
    var loadingBadge = document.createElement('div');
    loadingBadge.className = 'ep-verdict-badge ' + (analysis.polar ? 'ep-verdict-polar' : 'ep-verdict-nonpolar');
    loadingBadge.textContent = analysis.polar ? 'POLAR' : 'NONPOLAR';
    container.appendChild(loadingBadge);
    container.appendChild(buildResultGrid(analysis));
    if (analysis.bonds.length > 0) container.appendChild(buildBondTable(analysis));
    container.appendChild(buildVerdictCard(analysis));

    var placeholder = document.createElement('div');
    placeholder.className = 'ep-3d-loading';
    placeholder.innerHTML = '<div class="ep-3d-loading-spinner"></div><div class="ep-3d-loading-text">Loading 3D model from PubChem...</div>';
    container.appendChild(placeholder);
    container.appendChild(buildStepsSection(analysis));

    // Fetch 3D data from PubChem, then use CID for charges
    fetchPubChem3D(lookupQuery)
        .then(function(pubchem) {
            if (!pubchem) {
                // No 3D data — render without it
                renderENResult(container, analysis, null, null);
                return;
            }
            // Use the resolved CID to fetch partial charges
            return fetchPubChemChargesByCID(pubchem.cid)
                .then(function(charges) {
                    renderENResult(container, analysis, pubchem.sdf, charges);
                });
        })
        .catch(function() {
            // Already rendered without 3D — just remove loading
            if (placeholder.parentNode) placeholder.parentNode.removeChild(placeholder);
        });
}

function showError(container, message) {
    container.innerHTML = '<div style="padding:1.5rem;text-align:center;color:#dc2626;">' +
        '<div style="font-size:2rem;margin-bottom:0.5rem;opacity:0.5;">&#9888;</div>' +
        '<p style="font-size:0.875rem;">' + message + '</p></div>';
}

// ==================== Database Table ====================

function renderMoleculeTable(tbody, searchTerm) {
    if (!tbody) return;
    tbody.innerHTML = '';
    var term = (searchTerm || '').toLowerCase();

    for (var i = 0; i < molecules.length; i++) {
        var mol = molecules[i];
        if (term && mol.formula.toLowerCase().indexOf(term) === -1 &&
            mol.name.toLowerCase().indexOf(term) === -1 &&
            mol.geometry.toLowerCase().indexOf(term) === -1 &&
            (mol.polar ? 'polar' : 'nonpolar').indexOf(term) === -1) {
            continue;
        }

        var tr = document.createElement('tr');
        var polarBadge = mol.polar ?
            '<span class="ep-polarity-badge ep-badge-polar">Polar</span>' :
            '<span class="ep-polarity-badge ep-badge-nonpolar">Nonpolar</span>';

        tr.innerHTML = '<td style="font-family:var(--font-mono);font-weight:600;">' + mol.display + '</td>' +
            '<td>' + mol.name + '</td>' +
            '<td>' + polarBadge + '</td>' +
            '<td>' + (mol.dipole !== null ? mol.dipole + ' D' : '\u2014') + '</td>' +
            '<td>' + mol.geometry + '</td>' +
            '<td><button type="button" class="ep-table-btn" data-formula="' + mol.formula + '">View</button></td>';
        tbody.appendChild(tr);
    }

    if (tbody.children.length === 0) {
        var emptyRow = document.createElement('tr');
        emptyRow.innerHTML = '<td colspan="6" style="text-align:center;color:var(--text-muted);padding:1rem;">No molecules match your search.</td>';
        tbody.appendChild(emptyRow);
    }
}

// ==================== Public API ====================

window.EPRender = {
    EN: EN,
    getEN: getEN,
    molecules: molecules,
    classifyBond: classifyBond,
    buildENAnalysis: buildENAnalysis,
    renderByFormula: renderByFormula,
    renderENResult: renderENResult,
    renderMoleculeTable: renderMoleculeTable,
    showError: showError,
    findMolecule: findMolecule,
    unicodeFormula: unicodeFormula,
    enToColor: enToColor,
    parseChargesFromSDF: parseChargesFromSDF
};

})();
