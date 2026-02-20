/**
 * Molecular Geometry Calculator - Render Module
 * VSEPR geometry results, step-by-step, diagrams, molecule table
 */
(function() {
'use strict';

// ==================== Molecule Database ====================

var molecules = [
    // Linear (AX₂)
    { formula: 'CO2', display: 'CO\u2082', name: 'Carbon Dioxide', bp: 2, lp: 0, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    { formula: 'BeCl2', display: 'BeCl\u2082', name: 'Beryllium Chloride', bp: 2, lp: 0, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    { formula: 'CS2', display: 'CS\u2082', name: 'Carbon Disulfide', bp: 2, lp: 0, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    { formula: 'BeF2', display: 'BeF\u2082', name: 'Beryllium Fluoride', bp: 2, lp: 0, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    { formula: 'HCN', display: 'HCN', name: 'Hydrogen Cyanide', bp: 2, lp: 0, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    { formula: 'N2O', display: 'N\u2082O', name: 'Nitrous Oxide', bp: 2, lp: 0, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    // Linear (AXE)
    { formula: 'CO', display: 'CO', name: 'Carbon Monoxide', bp: 1, lp: 1, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp' },
    // Trigonal Planar (AX₃)
    { formula: 'BF3', display: 'BF\u2083', name: 'Boron Trifluoride', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'SO3', display: 'SO\u2083', name: 'Sulfur Trioxide', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'NO3-', display: 'NO\u2083\u207b', name: 'Nitrate Ion', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'AlCl3', display: 'AlCl\u2083', name: 'Aluminium Chloride', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'CH2O', display: 'CH\u2082O', name: 'Formaldehyde', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'C2H4', display: 'C\u2082H\u2084', name: 'Ethylene', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2' },
    // Bent from Trigonal Planar (AX₂E)
    { formula: 'SO2', display: 'SO\u2082', name: 'Sulfur Dioxide', bp: 2, lp: 1, geometry: 'Bent', angle: '119\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'O3', display: 'O\u2083', name: 'Ozone', bp: 2, lp: 1, geometry: 'Bent', angle: '117\u00b0', hybridization: 'sp\u00b2' },
    { formula: 'NO2-', display: 'NO\u2082\u207b', name: 'Nitrite Ion', bp: 2, lp: 1, geometry: 'Bent', angle: '115\u00b0', hybridization: 'sp\u00b2' },
    // Tetrahedral (AX₄)
    { formula: 'CH4', display: 'CH\u2084', name: 'Methane', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'CCl4', display: 'CCl\u2084', name: 'Carbon Tetrachloride', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'NH4+', display: 'NH\u2084\u207a', name: 'Ammonium Ion', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'SiH4', display: 'SiH\u2084', name: 'Silane', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'CF4', display: 'CF\u2084', name: 'Carbon Tetrafluoride', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5\u00b0', hybridization: 'sp\u00b3' },
    // Trigonal Pyramidal (AX₃E)
    { formula: 'NH3', display: 'NH\u2083', name: 'Ammonia', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '107\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'PCl3', display: 'PCl\u2083', name: 'Phosphorus Trichloride', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '107\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'H3O+', display: 'H\u2083O\u207a', name: 'Hydronium Ion', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '107\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'PF3', display: 'PF\u2083', name: 'Phosphorus Trifluoride', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '97.8\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'AsH3', display: 'AsH\u2083', name: 'Arsine', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '91.8\u00b0', hybridization: 'sp\u00b3' },
    // Bent from Tetrahedral (AX₂E₂)
    { formula: 'H2O', display: 'H\u2082O', name: 'Water', bp: 2, lp: 2, geometry: 'Bent', angle: '104.5\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'H2S', display: 'H\u2082S', name: 'Hydrogen Sulfide', bp: 2, lp: 2, geometry: 'Bent', angle: '92\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'OF2', display: 'OF\u2082', name: 'Oxygen Difluoride', bp: 2, lp: 2, geometry: 'Bent', angle: '103\u00b0', hybridization: 'sp\u00b3' },
    { formula: 'SCl2', display: 'SCl\u2082', name: 'Sulfur Dichloride', bp: 2, lp: 2, geometry: 'Bent', angle: '103\u00b0', hybridization: 'sp\u00b3' },
    // Diatomic / Simple
    { formula: 'HF', display: 'HF', name: 'Hydrogen Fluoride', bp: 1, lp: 3, geometry: 'Linear', angle: 'N/A', hybridization: 'sp\u00b3' },
    { formula: 'HCl', display: 'HCl', name: 'Hydrogen Chloride', bp: 1, lp: 3, geometry: 'Linear', angle: 'N/A', hybridization: 'sp\u00b3' },
    // Trigonal Bipyramidal (AX₅)
    { formula: 'PCl5', display: 'PCl\u2085', name: 'Phosphorus Pentachloride', bp: 5, lp: 0, geometry: 'Trigonal Bipyramidal', angle: '90\u00b0, 120\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'PF5', display: 'PF\u2085', name: 'Phosphorus Pentafluoride', bp: 5, lp: 0, geometry: 'Trigonal Bipyramidal', angle: '90\u00b0, 120\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'AsF5', display: 'AsF\u2085', name: 'Arsenic Pentafluoride', bp: 5, lp: 0, geometry: 'Trigonal Bipyramidal', angle: '90\u00b0, 120\u00b0', hybridization: 'sp\u00b3d' },
    // See-Saw (AX₄E)
    { formula: 'SF4', display: 'SF\u2084', name: 'Sulfur Tetrafluoride', bp: 4, lp: 1, geometry: 'See-Saw', angle: '~102\u00b0, ~173\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'TeCl4', display: 'TeCl\u2084', name: 'Tellurium Tetrachloride', bp: 4, lp: 1, geometry: 'See-Saw', angle: '~102\u00b0, ~173\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'SeF4', display: 'SeF\u2084', name: 'Selenium Tetrafluoride', bp: 4, lp: 1, geometry: 'See-Saw', angle: '~101\u00b0, ~164\u00b0', hybridization: 'sp\u00b3d' },
    // T-Shaped (AX₃E₂)
    { formula: 'ClF3', display: 'ClF\u2083', name: 'Chlorine Trifluoride', bp: 3, lp: 2, geometry: 'T-Shaped', angle: '~87.5\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'BrF3', display: 'BrF\u2083', name: 'Bromine Trifluoride', bp: 3, lp: 2, geometry: 'T-Shaped', angle: '~86\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'ICl3', display: 'ICl\u2083', name: 'Iodine Trichloride', bp: 3, lp: 2, geometry: 'T-Shaped', angle: '~87\u00b0', hybridization: 'sp\u00b3d' },
    // Linear from TBP (AX₂E₃)
    { formula: 'XeF2', display: 'XeF\u2082', name: 'Xenon Difluoride', bp: 2, lp: 3, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b3d' },
    { formula: 'I3-', display: 'I\u2083\u207b', name: 'Triiodide Ion', bp: 2, lp: 3, geometry: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b3d' },
    // Octahedral (AX₆)
    { formula: 'SF6', display: 'SF\u2086', name: 'Sulfur Hexafluoride', bp: 6, lp: 0, geometry: 'Octahedral', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    { formula: 'PF6-', display: 'PF\u2086\u207b', name: 'Hexafluorophosphate', bp: 6, lp: 0, geometry: 'Octahedral', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    { formula: 'WF6', display: 'WF\u2086', name: 'Tungsten Hexafluoride', bp: 6, lp: 0, geometry: 'Octahedral', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    // Square Pyramidal (AX₅E)
    { formula: 'BrF5', display: 'BrF\u2085', name: 'Bromine Pentafluoride', bp: 5, lp: 1, geometry: 'Square Pyramidal', angle: '~84\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    { formula: 'IF5', display: 'IF\u2085', name: 'Iodine Pentafluoride', bp: 5, lp: 1, geometry: 'Square Pyramidal', angle: '~81\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    { formula: 'XeOF4', display: 'XeOF\u2084', name: 'Xenon Oxytetrafluoride', bp: 5, lp: 1, geometry: 'Square Pyramidal', angle: '~91\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    // Square Planar (AX₄E₂)
    { formula: 'XeF4', display: 'XeF\u2084', name: 'Xenon Tetrafluoride', bp: 4, lp: 2, geometry: 'Square Planar', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    { formula: 'ICl4-', display: 'ICl\u2084\u207b', name: 'Tetrachloroiodate', bp: 4, lp: 2, geometry: 'Square Planar', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2' },
    // Pentagonal Bipyramidal (AX₇)
    { formula: 'IF7', display: 'IF\u2087', name: 'Iodine Heptafluoride', bp: 7, lp: 0, geometry: 'Pentagonal Bipyramidal', angle: '72\u00b0, 90\u00b0', hybridization: 'sp\u00b3d\u00b3' },
    { formula: 'ReF7', display: 'ReF\u2087', name: 'Rhenium Heptafluoride', bp: 7, lp: 0, geometry: 'Pentagonal Bipyramidal', angle: '72\u00b0, 90\u00b0', hybridization: 'sp\u00b3d\u00b3' }
];

// ==================== VSEPR Geometry Data ====================

var geometryData = {
    '1-0': { electronGeom: 'Linear', molecularGeom: 'Linear', angle: 'N/A', hybridization: 's', notation: 'AX', examples: ['H\u207a', 'Li', 'Na'], description: 'Single atom or monatomic ion.', diagram: 'A\u2014X' },
    '2-0': { electronGeom: 'Linear', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp', notation: 'AX\u2082', examples: ['CO\u2082', 'BeCl\u2082', 'CS\u2082'], description: 'Two bonding pairs arrange in a straight line to minimize repulsion.', diagram: 'X\u2014A\u2014X' },
    '1-1': { electronGeom: 'Linear', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp', notation: 'AXE', examples: ['CO', 'NO\u207a', 'CN\u207b'], description: 'One bond and one lone pair in linear arrangement.', diagram: ':\u2014A\u2014X' },
    '3-0': { electronGeom: 'Trigonal Planar', molecularGeom: 'Trigonal Planar', angle: '120\u00b0', hybridization: 'sp\u00b2', notation: 'AX\u2083', examples: ['BF\u2083', 'SO\u2083', 'AlCl\u2083'], description: 'Three bonding pairs form a flat triangle in one plane.', diagram: '    X\n    |\n X\u2014A\u2014X' },
    '2-1': { electronGeom: 'Trigonal Planar', molecularGeom: 'Bent', angle: '~119\u00b0', hybridization: 'sp\u00b2', notation: 'AX\u2082E', examples: ['SO\u2082', 'NO\u2082\u207b', 'O\u2083'], description: 'Lone pair pushes bonding pairs closer, creating bent shape.', diagram: '    :\n    |\n X\u2014A\u2014X' },
    '1-2': { electronGeom: 'Trigonal Planar', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b2', notation: 'AXE\u2082', examples: ['Very rare'], description: 'Two lone pairs leave single bonding pair (very rare).', diagram: ': A\u2014X :' },
    '4-0': { electronGeom: 'Tetrahedral', molecularGeom: 'Tetrahedral', angle: '109.5\u00b0', hybridization: 'sp\u00b3', notation: 'AX\u2084', examples: ['CH\u2084', 'CCl\u2084', 'SiH\u2084'], description: 'Four bonding pairs arrange at corners of a tetrahedron.', diagram: '    X\n    |\n X\u2014A\u2014X\n    |\n    X' },
    '3-1': { electronGeom: 'Tetrahedral', molecularGeom: 'Trigonal Pyramidal', angle: '~107\u00b0', hybridization: 'sp\u00b3', notation: 'AX\u2083E', examples: ['NH\u2083', 'PCl\u2083', 'AsH\u2083'], description: 'Lone pair occupies one tetrahedral position, forming pyramid.', diagram: '    :\n    |\n X\u2014A\u2014X\n    |\n    X' },
    '2-2': { electronGeom: 'Tetrahedral', molecularGeom: 'Bent', angle: '104.5\u00b0', hybridization: 'sp\u00b3', notation: 'AX\u2082E\u2082', examples: ['H\u2082O', 'H\u2082S', 'SCl\u2082'], description: 'Two lone pairs compress bond angle below tetrahedral.', diagram: '  : :\n   |\n X\u2014A\u2014X' },
    '1-3': { electronGeom: 'Tetrahedral', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b3', notation: 'AXE\u2083', examples: ['Extremely rare'], description: 'Three lone pairs leave single bond (extremely rare).', diagram: ': : : A\u2014X' },
    '5-0': { electronGeom: 'Trigonal Bipyramidal', molecularGeom: 'Trigonal Bipyramidal', angle: '90\u00b0, 120\u00b0', hybridization: 'sp\u00b3d', notation: 'AX\u2085', examples: ['PCl\u2085', 'PF\u2085', 'AsF\u2085'], description: 'Five bonding pairs with axial (90\u00b0) and equatorial (120\u00b0) positions.', diagram: '    X\n    |\nX\u2014A\u2014X\n  / \\\n X   X' },
    '4-1': { electronGeom: 'Trigonal Bipyramidal', molecularGeom: 'See-Saw', angle: '~102\u00b0, ~173\u00b0', hybridization: 'sp\u00b3d', notation: 'AX\u2084E', examples: ['SF\u2084', 'XeO\u2082F\u2082'], description: 'Lone pair in equatorial position creates see-saw shape.', diagram: '    X\n    |\n:\u2014A\u2014X\n    |\n    X' },
    '3-2': { electronGeom: 'Trigonal Bipyramidal', molecularGeom: 'T-Shaped', angle: '~87.5\u00b0', hybridization: 'sp\u00b3d', notation: 'AX\u2083E\u2082', examples: ['ClF\u2083', 'BrF\u2083', 'ICl\u2083'], description: 'Two lone pairs in equatorial positions form T-shape.', diagram: '    X\n    |\n: A :\n    |\n    X' },
    '2-3': { electronGeom: 'Trigonal Bipyramidal', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b3d', notation: 'AX\u2082E\u2083', examples: ['XeF\u2082', 'I\u2083\u207b'], description: 'Three lone pairs in equatorial plane leave linear molecule.', diagram: ': : : A X\u2014X' },
    '1-4': { electronGeom: 'Trigonal Bipyramidal', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b3d', notation: 'AXE\u2084', examples: ['Theoretical'], description: 'Four lone pairs with single bond (extremely unstable).', diagram: ': : : : A\u2014X' },
    '6-0': { electronGeom: 'Octahedral', molecularGeom: 'Octahedral', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2', notation: 'AX\u2086', examples: ['SF\u2086', 'PF\u2086\u207b'], description: 'Six bonding pairs form regular octahedron.', diagram: '    X\n    |\nX\u2014A\u2014X\n  / | \\\n X  |  X\n    X' },
    '5-1': { electronGeom: 'Octahedral', molecularGeom: 'Square Pyramidal', angle: '~84\u00b0', hybridization: 'sp\u00b3d\u00b2', notation: 'AX\u2085E', examples: ['BrF\u2085', 'IF\u2085'], description: 'Lone pair at one position creates square pyramid.', diagram: '    X\n    |\nX\u2014A\u2014X\n  / | \\\n X  :  X' },
    '4-2': { electronGeom: 'Octahedral', molecularGeom: 'Square Planar', angle: '90\u00b0', hybridization: 'sp\u00b3d\u00b2', notation: 'AX\u2084E\u2082', examples: ['XeF\u2084', 'ICl\u2084\u207b'], description: 'Two opposite lone pairs leave square planar shape.', diagram: '    :\n    |\nX\u2014A\u2014X\n  / | \\\n X  :  X' },
    '3-3': { electronGeom: 'Octahedral', molecularGeom: 'T-Shaped', angle: '~90\u00b0', hybridization: 'sp\u00b3d\u00b2', notation: 'AX\u2083E\u2083', examples: ['Very rare'], description: 'Three lone pairs create T-shaped geometry (extremely rare).', diagram: '    X\n    |\n: A :\n    |\n    X\n    :\n    X' },
    '2-4': { electronGeom: 'Octahedral', molecularGeom: 'Linear', angle: '180\u00b0', hybridization: 'sp\u00b3d\u00b2', notation: 'AX\u2082E\u2084', examples: ['Theoretical'], description: 'Four lone pairs leave linear geometry (extremely unstable).', diagram: ': : X\u2014A\u2014X : :' },
    '7-0': { electronGeom: 'Pentagonal Bipyramidal', molecularGeom: 'Pentagonal Bipyramidal', angle: '72\u00b0, 90\u00b0', hybridization: 'sp\u00b3d\u00b3', notation: 'AX\u2087', examples: ['IF\u2087', 'ReF\u2087'], description: 'Seven bonding pairs form pentagonal bipyramid (rare, heavy elements only).', diagram: '      X\n      |\n  X\u2014A\u2014X\n / /|\\ \\\nX X | X X\n    X' },
    '6-1': { electronGeom: 'Pentagonal Bipyramidal', molecularGeom: 'Pentagonal Pyramidal', angle: '~72\u00b0, ~90\u00b0', hybridization: 'sp\u00b3d\u00b3', notation: 'AX\u2086E', examples: ['Very rare'], description: 'Lone pair at axial position creates pentagonal pyramid (very rare).', diagram: '      X\n      |\n  X\u2014A\u2014X\n / /|\\ \\\nX : | X X\n    X' },
    '5-2': { electronGeom: 'Pentagonal Bipyramidal', molecularGeom: 'Pentagonal Planar', angle: '72\u00b0', hybridization: 'sp\u00b3d\u00b3', notation: 'AX\u2085E\u2082', examples: ['XeF\u2085\u207b (theoretical)'], description: 'Two axial lone pairs leave pentagonal plane (very rare).', diagram: '      :\n      |\n  X\u2014A\u2014X\n / /|\\ \\\nX : | X X\n    :\n    X' },
    '4-3': { electronGeom: 'Pentagonal Bipyramidal', molecularGeom: 'Square Planar', angle: '~90\u00b0', hybridization: 'sp\u00b3d\u00b3', notation: 'AX\u2084E\u2083', examples: ['Theoretical'], description: 'Three lone pairs create square planar geometry (extremely rare).', diagram: '  : X :\n    |\n  X\u2014A\u2014X\n    |\n    X' }
};

// ==================== Valence Electrons ====================

var valenceMap = {
    'H': 1, 'LI': 1, 'NA': 1, 'K': 1, 'RB': 1, 'CS': 1,
    'BE': 2, 'MG': 2, 'CA': 2, 'SR': 2, 'BA': 2,
    'B': 3, 'AL': 3, 'GA': 3, 'IN': 3,
    'C': 4, 'SI': 4, 'GE': 4, 'SN': 4, 'PB': 4,
    'N': 5, 'P': 5, 'AS': 5, 'SB': 5, 'BI': 5,
    'O': 6, 'S': 6, 'SE': 6, 'TE': 6,
    'F': 7, 'CL': 7, 'BR': 7, 'I': 7, 'AT': 7,
    'W': 6, 'MO': 6, 'CR': 6, 'RE': 7, 'MN': 7, 'TC': 7,
    'HE': 8, 'NE': 8, 'AR': 8, 'KR': 8, 'XE': 8, 'RN': 8
};

function getValence(el) {
    var v = valenceMap[el.toUpperCase()];
    if (v === undefined) throw new Error('Unknown element: ' + el);
    return v;
}

// ==================== Formula Parser ====================

function parseMolecularFormula(formula) {
    var charge = 0;
    var clean = formula.replace(/\s+/g, '');

    var chargeMatch = clean.match(/([+-]\d*|\(\d*[+-]\))$/);
    if (chargeMatch) {
        var cs = chargeMatch[0].replace(/[()]/g, '');
        if (cs.indexOf('+') !== -1) {
            charge = cs === '+' ? -1 : -parseInt(cs.replace('+', ''));
        } else if (cs.indexOf('-') !== -1) {
            charge = cs === '-' ? 1 : parseInt(cs.replace('-', ''));
        }
        clean = clean.replace(chargeMatch[0], '');
    }

    var elementRegex = /([A-Z][a-z]?)(\d*)/g;
    var elements = [];
    var match;
    while ((match = elementRegex.exec(clean)) !== null) {
        if (match[1]) {
            elements.push({ symbol: match[1], count: match[2] ? parseInt(match[2]) : 1 });
        }
    }
    if (elements.length === 0) throw new Error('No valid elements found');

    // H is always terminal — swap central atom if H is listed first
    if (elements[0].symbol === 'H' && elements.length > 1) {
        var tmp = elements[0];
        elements[0] = elements[1];
        elements[1] = tmp;
    }

    // Homonuclear polyatomic (e.g., I3-): split first element into central(1) + terminal(n-1)
    if (elements.length === 1 && elements[0].count > 1) {
        var sym = elements[0].symbol;
        var cnt = elements[0].count;
        elements = [{ symbol: sym, count: 1 }, { symbol: sym, count: cnt - 1 }];
    }

    var centralAtom = elements[0].symbol;
    var bondingPairs = 0;
    for (var i = 1; i < elements.length; i++) bondingPairs += elements[i].count;

    var centralValence = getValence(centralAtom);
    var totalValence = centralValence * elements[0].count;
    for (var j = 1; j < elements.length; j++) {
        totalValence += getValence(elements[j].symbol) * elements[j].count;
    }
    totalValence += charge;

    // Count non-H terminal atoms (each has 3 lone pairs = 6 electrons)
    var terminalNonH = 0;
    for (var k = 1; k < elements.length; k++) {
        if (elements[k].symbol.toUpperCase() !== 'H') {
            terminalNonH += elements[k].count;
        }
    }

    // Lone pairs on central atom only:
    // Total electrons - bonding electrons - terminal lone pair electrons
    var centralLPElectrons = totalValence - 2 * bondingPairs - 6 * terminalNonH;
    var lonePairs = Math.max(0, Math.floor(centralLPElectrons / 2));
    // Multi-center molecule detection:
    // 1. Central atom has count > 1 (e.g. C6H12O6, C2H6)
    // 2. Bonding pairs exceed what central atom can accommodate (valence)
    var centralMax = getValence(centralAtom);
    // For expanded octet atoms (P, S, Xe, etc.) allow up to 7 bonds
    if (centralMax >= 5) centralMax = 7;
    if (elements[0].count > 1 || bondingPairs > centralMax) {
        return analyzeMultiCenter(formula, elements, totalValence, charge);
    }

    var key = bondingPairs + '-' + lonePairs;
    var data = geometryData[key];
    if (!data) throw new Error('No geometry for ' + bondingPairs + ' BP and ' + lonePairs + ' LP');

    return {
        formula: formula, centralAtom: centralAtom,
        bondingPairs: bondingPairs, lonePairs: lonePairs,
        totalValence: totalValence, charge: charge,
        data: data, elements: elements
    };
}

// ==================== Multi-Center Analysis ====================

// Standard bonding patterns per atom type (valence → typical bp, lp)
var typicalBonding = {
    'C':  [{ bp: 4, lp: 0, label: 'sp\u00b3 tetrahedral (single bonds)', note: '4 single bonds' },
           { bp: 3, lp: 0, label: 'sp\u00b2 trigonal planar (1 double bond)', note: '1 double + 2 single bonds' },
           { bp: 2, lp: 0, label: 'sp linear (2 double bonds or 1 triple)', note: 'e.g. CO\u2082, HCN' }],
    'N':  [{ bp: 3, lp: 1, label: 'sp\u00b3 trigonal pyramidal', note: '3 bonds + 1 lone pair' },
           { bp: 3, lp: 0, label: 'sp\u00b2 trigonal planar (in amine double bond)', note: 'e.g. peptide N' },
           { bp: 2, lp: 1, label: 'sp\u00b2 bent', note: '1 double + 1 single bond' }],
    'O':  [{ bp: 2, lp: 2, label: 'sp\u00b3 bent', note: '2 bonds + 2 lone pairs' },
           { bp: 1, lp: 2, label: 'sp\u00b2 (in C=O)', note: 'carbonyl oxygen' }],
    'S':  [{ bp: 2, lp: 2, label: 'sp\u00b3 bent', note: '2 bonds + 2 lone pairs' },
           { bp: 4, lp: 1, label: 'sp\u00b3d see-saw', note: 'e.g. SF\u2084' },
           { bp: 6, lp: 0, label: 'sp\u00b3d\u00b2 octahedral', note: 'e.g. SF\u2086' }],
    'P':  [{ bp: 3, lp: 1, label: 'sp\u00b3 trigonal pyramidal', note: '3 bonds + 1 lone pair' },
           { bp: 5, lp: 0, label: 'sp\u00b3d trigonal bipyramidal', note: 'e.g. PCl\u2085' }],
    'B':  [{ bp: 3, lp: 0, label: 'sp\u00b2 trigonal planar', note: '3 bonds, electron deficient' }],
    'SI': [{ bp: 4, lp: 0, label: 'sp\u00b3 tetrahedral', note: '4 single bonds' }],
    'CL': [{ bp: 1, lp: 3, label: 'sp\u00b3 linear (terminal)', note: '1 bond + 3 lone pairs' }],
    'F':  [{ bp: 1, lp: 3, label: 'sp\u00b3 linear (terminal)', note: '1 bond + 3 lone pairs' }],
    'BR': [{ bp: 1, lp: 3, label: 'sp\u00b3 linear (terminal)', note: '1 bond + 3 lone pairs' }],
    'I':  [{ bp: 1, lp: 3, label: 'sp\u00b3 linear (terminal)', note: '1 bond + 3 lone pairs' }]
};

function analyzeMultiCenter(formula, elements, totalValence, charge) {
    // Index of Hydrogen Deficiency (unsaturation)
    var cCount = 0, hCount = 0, nCount = 0, halCount = 0;
    for (var i = 0; i < elements.length; i++) {
        var sym = elements[i].symbol.toUpperCase();
        var cnt = elements[i].count;
        if (sym === 'C' || sym === 'SI') cCount += cnt;
        else if (sym === 'H') hCount += cnt;
        else if (sym === 'N' || sym === 'P') nCount += cnt;
        else if (sym === 'F' || sym === 'CL' || sym === 'BR' || sym === 'I') halCount += cnt;
        // O, S don't affect IHD
    }
    var ihd = Math.max(0, (2 * cCount + 2 + nCount - hCount - halCount) / 2);

    // Analyze each non-H atom type
    var centers = [];
    for (var j = 0; j < elements.length; j++) {
        var el = elements[j];
        var upper = el.symbol.toUpperCase();
        if (upper === 'H') continue;
        var val = getValence(el.symbol);
        var patterns = typicalBonding[upper];
        var primary;
        if (patterns) {
            primary = patterns[0]; // most common pattern
        } else {
            // Fallback: standard bonds = min(valence, 8-valence), LP = (valence - bonds)/2
            var bonds = Math.min(val, 8 - val);
            var lp = Math.max(0, Math.floor((val - bonds) / 2));
            primary = { bp: bonds, lp: lp, label: 'Estimated', note: val + ' valence electrons' };
        }

        var geoKey = primary.bp + '-' + primary.lp;
        var geo = geometryData[geoKey];

        centers.push({
            symbol: el.symbol,
            count: el.count,
            valence: val,
            bp: primary.bp,
            lp: primary.lp,
            label: primary.label,
            note: primary.note,
            geometry: geo ? geo.molecularGeom : 'Unknown',
            angle: geo ? geo.angle : 'N/A',
            hybridization: geo ? geo.hybridization : 'N/A',
            notation: geo ? geo.notation : 'N/A',
            diagram: geo ? geo.diagram : ''
        });
    }

    return {
        formula: formula,
        multiCenter: true,
        totalValence: totalValence,
        charge: charge,
        ihd: ihd,
        centers: centers,
        elements: elements
    };
}

// ==================== Unicode Formula Helper ====================

var subscriptMap = { '0':'\u2080','1':'\u2081','2':'\u2082','3':'\u2083','4':'\u2084','5':'\u2085','6':'\u2086','7':'\u2087','8':'\u2088','9':'\u2089' };
var superscriptMap = { '0':'\u2070','1':'\u00b9','2':'\u00b2','3':'\u00b3','4':'\u2074','5':'\u2075','6':'\u2076','7':'\u2077','8':'\u2078','9':'\u2079','+':'\u207a','-':'\u207b' };

function unicodeFormula(formula) {
    // Convert plain formula like "CO2" → "CO₂", "NH4+" → "NH₄⁺"
    return formula.replace(/(\d+)/g, function(m) {
        var out = '';
        for (var i = 0; i < m.length; i++) out += subscriptMap[m[i]] || m[i];
        return out;
    }).replace(/([+-])$/, function(m) {
        return superscriptMap[m] || m;
    });
}

// ==================== PubChem 3D Integration ====================

var pubchemCache = {};

/**
 * Fetch 3D SDF from PubChem for a given formula or name.
 * Returns a Promise that resolves to { sdf: string, cid: number } or null.
 */
function fetchPubChem3D(query) {
    // Normalize query: strip charges, whitespace
    var clean = query.replace(/\s+/g, '').replace(/\(\d*[+-]\)$/, '').replace(/[+-]$/, '');
    if (!clean) return Promise.resolve(null);

    // Check cache
    if (pubchemCache[clean.toUpperCase()]) {
        return Promise.resolve(pubchemCache[clean.toUpperCase()]);
    }

    // Step 1: Resolve formula/name to CID
    // Try by formula first, then by name
    var cidUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/formula/' +
        encodeURIComponent(clean) + '/cids/JSON?MaxRecords=1';
    var nameUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/' +
        encodeURIComponent(clean) + '/cids/JSON?MaxRecords=1';

    return fetchCIDFromUrl(cidUrl)
        .then(function(cid) {
            if (cid) return cid;
            // Fallback: try by name
            return fetchCIDFromUrl(nameUrl);
        })
        .then(function(cid) {
            if (!cid) return null;
            // Step 2: Fetch 3D SDF conformer
            var sdfUrl = 'https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/' +
                cid + '/SDF?record_type=3d';
            return fetch(sdfUrl)
                .then(function(resp) {
                    if (!resp.ok) return null;
                    return resp.text();
                })
                .then(function(sdf) {
                    if (!sdf || sdf.indexOf('V2000') === -1 && sdf.indexOf('V3000') === -1) {
                        return null;
                    }
                    var result = { sdf: sdf, cid: cid };
                    pubchemCache[clean.toUpperCase()] = result;
                    return result;
                });
        })
        .catch(function() {
            return null;
        });
}

function fetchCIDFromUrl(url) {
    return fetch(url)
        .then(function(resp) {
            if (!resp.ok) return null;
            return resp.json();
        })
        .then(function(data) {
            if (data && data.IdentifierList && data.IdentifierList.CID &&
                data.IdentifierList.CID.length > 0) {
                return data.IdentifierList.CID[0];
            }
            // PubChem formula endpoint returns "Waiting" for async lookups
            if (data && data.Waiting) {
                // Wait and retry once
                var listKey = data.Waiting.ListKey;
                return new Promise(function(resolve) { setTimeout(resolve, 2000); })
                    .then(function() {
                        return fetch('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/listkey/' +
                            listKey + '/cids/JSON?MaxRecords=1');
                    })
                    .then(function(resp) { return resp.ok ? resp.json() : null; })
                    .then(function(data2) {
                        if (data2 && data2.IdentifierList && data2.IdentifierList.CID &&
                            data2.IdentifierList.CID.length > 0) {
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

/**
 * Parse an SDF string to extract atom positions and bonds.
 * Returns { atoms: [{elem, x, y, z}], bonds: [{from, to, order}] } or null.
 */
function parseSDF(sdf) {
    var lines = sdf.split('\n');
    // Find counts line (V2000 format): line index 3 typically
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
        atoms.push({
            x: parseFloat(parts[0]),
            y: parseFloat(parts[1]),
            z: parseFloat(parts[2]),
            elem: parts[3]
        });
    }

    var bonds = [];
    for (var b = 0; b < numBonds; b++) {
        var bline = lines[countsIdx + 1 + numAtoms + b];
        if (!bline) continue;
        var bparts = bline.trim().split(/\s+/);
        if (bparts.length < 3) continue;
        bonds.push({
            from: parseInt(bparts[0]) - 1, // 0-indexed
            to: parseInt(bparts[1]) - 1,
            order: parseInt(bparts[2])
        });
    }

    return { atoms: atoms, bonds: bonds };
}

/**
 * Calculate the angle in degrees between three points (a-b-c) where b is center.
 */
function calcAngle(a, b, c) {
    var v1 = { x: a.x - b.x, y: a.y - b.y, z: a.z - b.z };
    var v2 = { x: c.x - b.x, y: c.y - b.y, z: c.z - b.z };
    var dot = v1.x * v2.x + v1.y * v2.y + v1.z * v2.z;
    var mag1 = Math.sqrt(v1.x * v1.x + v1.y * v1.y + v1.z * v1.z);
    var mag2 = Math.sqrt(v2.x * v2.x + v2.y * v2.y + v2.z * v2.z);
    if (mag1 === 0 || mag2 === 0) return 0;
    var cosAngle = Math.max(-1, Math.min(1, dot / (mag1 * mag2)));
    return Math.acos(cosAngle) * 180 / Math.PI;
}

/**
 * Calculate distance between two points.
 */
function calcDistance(a, b) {
    var dx = a.x - b.x, dy = a.y - b.y, dz = a.z - b.z;
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
}

/**
 * Find the central (heaviest non-H) atom index in parsed SDF data.
 */
function findCentralAtom(parsed) {
    // The central atom is typically the heaviest non-H atom, or the one with most bonds
    var bondCounts = new Array(parsed.atoms.length);
    for (var i = 0; i < bondCounts.length; i++) bondCounts[i] = 0;
    for (var b = 0; b < parsed.bonds.length; b++) {
        bondCounts[parsed.bonds[b].from]++;
        bondCounts[parsed.bonds[b].to]++;
    }

    var bestIdx = 0;
    var bestScore = -1;
    for (var j = 0; j < parsed.atoms.length; j++) {
        if (parsed.atoms[j].elem === 'H') continue;
        // Prefer atom with most bonds, then heaviest
        var score = bondCounts[j] * 100 + (valenceMap[parsed.atoms[j].elem.toUpperCase()] || 0);
        if (score > bestScore) {
            bestScore = score;
            bestIdx = j;
        }
    }
    return bestIdx;
}

/**
 * Build a 3Dmol viewer from PubChem SDF data with lone pair overlays and measurements.
 * Returns the wrapper element, or null on failure.
 */
function buildPubChem3DViewer(container, sdfData, bp, lp, formula, cid) {
    if (typeof $3Dmol === 'undefined') return null;

    var parsed = parseSDF(sdfData);
    if (!parsed || parsed.atoms.length === 0) return null;

    var wrapper = document.createElement('div');
    wrapper.className = 'mg-3d-wrapper';

    var viewerDiv = document.createElement('div');
    viewerDiv.className = 'mg-3d-viewer';
    wrapper.appendChild(viewerDiv);

    container.appendChild(wrapper);

    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    var bgColor = isDark ? '#1e293b' : '#ffffff';

    var viewer = $3Dmol.createViewer(viewerDiv, {
        backgroundColor: bgColor,
        antialias: true,
        preserveDrawingBuffer: true
    });

    // Load the SDF into the viewer
    viewer.addModel(sdfData, 'sdf');
    viewer.setStyle({}, {
        stick: { radius: 0.12, colorscheme: 'Jmol' },
        sphere: { scale: 0.3, colorscheme: 'Jmol' }
    });

    // Add atom labels for all non-H atoms
    var model = viewer.getModel();
    var allAtoms = model.selectedAtoms({});
    for (var i = 0; i < allAtoms.length; i++) {
        var a = allAtoms[i];
        if (a.elem !== 'H') {
            viewer.addLabel(a.elem, {
                position: { x: a.x, y: a.y, z: a.z },
                fontSize: 12,
                fontColor: isDark ? '#f1f5f9' : '#1e293b',
                backgroundColor: 'transparent',
                borderThickness: 0,
                showBackground: false
            });
        }
    }

    // Add lone pair lobes on the central atom using VSEPR positions
    var centralIdx = findCentralAtom(parsed);
    var centralPos = parsed.atoms[centralIdx];

    if (lp > 0) {
        // Get neighbors of central atom
        var neighbors = [];
        for (var b = 0; b < parsed.bonds.length; b++) {
            if (parsed.bonds[b].from === centralIdx) neighbors.push(parsed.atoms[parsed.bonds[b].to]);
            if (parsed.bonds[b].to === centralIdx) neighbors.push(parsed.atoms[parsed.bonds[b].from]);
        }

        // Calculate average bond direction
        var lpPositions = calculateLonePairPositions(centralPos, neighbors, lp);
        for (var lpi = 0; lpi < lpPositions.length; lpi++) {
            viewer.addSphere({
                center: lpPositions[lpi],
                radius: 0.4,
                color: '#FFD700',
                opacity: 0.35
            });
            viewer.addLabel('LP', {
                position: lpPositions[lpi],
                fontSize: 10,
                fontColor: '#b8860b',
                backgroundColor: 'transparent',
                borderThickness: 0,
                showBackground: false
            });
        }
    }

    // Add bond angle measurements on the central atom
    var centralNeighborIndices = [];
    for (var bn = 0; bn < parsed.bonds.length; bn++) {
        if (parsed.bonds[bn].from === centralIdx) centralNeighborIndices.push(parsed.bonds[bn].to);
        if (parsed.bonds[bn].to === centralIdx) centralNeighborIndices.push(parsed.bonds[bn].from);
    }

    // Show first non-trivial bond angle measurement
    var angleLabelsAdded = 0;
    if (centralNeighborIndices.length >= 2 && angleLabelsAdded < 2) {
        for (var ai = 0; ai < centralNeighborIndices.length - 1 && angleLabelsAdded < 2; ai++) {
            for (var aj = ai + 1; aj < centralNeighborIndices.length && angleLabelsAdded < 2; aj++) {
                var atomA = parsed.atoms[centralNeighborIndices[ai]];
                var atomC = parsed.atoms[centralNeighborIndices[aj]];
                // Skip H-center-H angles if there are non-H atoms
                var hasNonH = centralNeighborIndices.some(function(idx) { return parsed.atoms[idx].elem !== 'H'; });
                if (hasNonH && atomA.elem === 'H' && atomC.elem === 'H') continue;

                var angle = calcAngle(atomA, centralPos, atomC);
                // Label position: midpoint of the angle arc
                var mid = {
                    x: (atomA.x + atomC.x) / 2,
                    y: (atomA.y + atomC.y) / 2,
                    z: (atomA.z + atomC.z) / 2
                };
                // Offset slightly toward center
                var labelPos = {
                    x: mid.x * 0.6 + centralPos.x * 0.4,
                    y: mid.y * 0.6 + centralPos.y * 0.4,
                    z: mid.z * 0.6 + centralPos.z * 0.4
                };
                viewer.addLabel(angle.toFixed(1) + '\u00b0', {
                    position: labelPos,
                    fontSize: 11,
                    fontColor: isDark ? '#fbbf24' : '#d97706',
                    backgroundColor: isDark ? 'rgba(30,41,59,0.8)' : 'rgba(255,255,255,0.85)',
                    borderThickness: 1,
                    borderColor: isDark ? '#fbbf24' : '#d97706',
                    showBackground: true
                });
                angleLabelsAdded++;
            }
        }
    }

    // Show one bond distance label
    if (centralNeighborIndices.length >= 1) {
        var nIdx = centralNeighborIndices[0];
        var nAtom = parsed.atoms[nIdx];
        var dist = calcDistance(centralPos, nAtom);
        var distMid = {
            x: (centralPos.x + nAtom.x) / 2,
            y: (centralPos.y + nAtom.y) / 2,
            z: (centralPos.z + nAtom.z) / 2
        };
        viewer.addLabel(dist.toFixed(2) + ' \u00c5', {
            position: distMid,
            fontSize: 10,
            fontColor: isDark ? '#94a3b8' : '#6b7280',
            backgroundColor: isDark ? 'rgba(30,41,59,0.8)' : 'rgba(255,255,255,0.85)',
            borderThickness: 1,
            borderColor: isDark ? '#475569' : '#d1d5db',
            showBackground: true
        });
    }

    viewer.zoomTo();
    viewer.render();
    viewer.spin('y', 0.5);

    // Controls
    var controls = document.createElement('div');
    controls.className = 'mg-viewer-controls';

    var spinning = true;
    var lpVisible = true;
    var measureVisible = true;

    // Spin toggle
    var spinBtn = document.createElement('button');
    spinBtn.className = 'mg-viewer-ctrl-btn';
    spinBtn.textContent = 'Spin: On';
    spinBtn.onclick = function() {
        spinning = !spinning;
        viewer.spin(spinning ? 'y' : false, 0.5);
        spinBtn.textContent = 'Spin: ' + (spinning ? 'On' : 'Off');
    };
    controls.appendChild(spinBtn);

    // Reset view
    var resetBtn = document.createElement('button');
    resetBtn.className = 'mg-viewer-ctrl-btn';
    resetBtn.textContent = 'Reset View';
    resetBtn.onclick = function() { viewer.zoomTo(); viewer.render(); };
    controls.appendChild(resetBtn);

    // Style toggle: ball-and-stick vs space-fill
    var styleMode = 'ballstick';
    var styleBtn = document.createElement('button');
    styleBtn.className = 'mg-viewer-ctrl-btn';
    styleBtn.textContent = 'Space Fill';
    styleBtn.onclick = function() {
        if (styleMode === 'ballstick') {
            viewer.setStyle({}, { sphere: { scale: 0.8, colorscheme: 'Jmol' } });
            styleMode = 'spacefill';
            styleBtn.textContent = 'Ball & Stick';
        } else {
            viewer.setStyle({}, {
                stick: { radius: 0.12, colorscheme: 'Jmol' },
                sphere: { scale: 0.3, colorscheme: 'Jmol' }
            });
            styleMode = 'ballstick';
            styleBtn.textContent = 'Space Fill';
        }
        viewer.render();
    };
    controls.appendChild(styleBtn);

    wrapper.appendChild(controls);

    // Interaction hint
    var hintDiv = document.createElement('div');
    hintDiv.className = 'mg-viewer-hint';
    hintDiv.textContent = 'Drag to rotate \u00b7 Scroll to zoom \u00b7 Right-drag to pan';
    wrapper.appendChild(hintDiv);

    return wrapper;
}

/**
 * Calculate lone pair positions relative to a central atom and its neighbors.
 * Uses the real bond geometry to place LPs opposite to bonded atoms.
 */
function calculateLonePairPositions(centralPos, neighbors, numLP) {
    var positions = [];
    var lpDist = 0.8; // distance from central atom (shorter than bonds)

    if (neighbors.length === 0) {
        // No neighbors, just place LP along +y
        for (var i = 0; i < numLP; i++) {
            var angle = (i / numLP) * 2 * Math.PI;
            positions.push({
                x: centralPos.x + lpDist * Math.cos(angle),
                y: centralPos.y + lpDist * Math.sin(angle),
                z: centralPos.z
            });
        }
        return positions;
    }

    // Calculate the average direction of all bonds
    var avgDir = { x: 0, y: 0, z: 0 };
    for (var n = 0; n < neighbors.length; n++) {
        var dx = neighbors[n].x - centralPos.x;
        var dy = neighbors[n].y - centralPos.y;
        var dz = neighbors[n].z - centralPos.z;
        var mag = Math.sqrt(dx * dx + dy * dy + dz * dz) || 1;
        avgDir.x += dx / mag;
        avgDir.y += dy / mag;
        avgDir.z += dz / mag;
    }

    // Lone pairs go OPPOSITE to the average bond direction
    var oppMag = Math.sqrt(avgDir.x * avgDir.x + avgDir.y * avgDir.y + avgDir.z * avgDir.z) || 1;
    var oppDir = {
        x: -avgDir.x / oppMag,
        y: -avgDir.y / oppMag,
        z: -avgDir.z / oppMag
    };

    if (numLP === 1) {
        positions.push({
            x: centralPos.x + oppDir.x * lpDist,
            y: centralPos.y + oppDir.y * lpDist,
            z: centralPos.z + oppDir.z * lpDist
        });
    } else if (numLP >= 2) {
        // Find a perpendicular vector for spreading
        var perp = { x: 0, y: 0, z: 0 };
        if (Math.abs(oppDir.x) < 0.9) {
            perp = { x: 1, y: 0, z: 0 };
        } else {
            perp = { x: 0, y: 1, z: 0 };
        }
        // Cross product: oppDir x perp
        var cross = {
            x: oppDir.y * perp.z - oppDir.z * perp.y,
            y: oppDir.z * perp.x - oppDir.x * perp.z,
            z: oppDir.x * perp.y - oppDir.y * perp.x
        };
        var crossMag = Math.sqrt(cross.x * cross.x + cross.y * cross.y + cross.z * cross.z) || 1;
        cross.x /= crossMag; cross.y /= crossMag; cross.z /= crossMag;

        var spread = 0.4; // spread angle
        for (var k = 0; k < numLP; k++) {
            var spreadAngle = (k - (numLP - 1) / 2) * spread;
            var dir = {
                x: oppDir.x * Math.cos(spreadAngle) + cross.x * Math.sin(spreadAngle),
                y: oppDir.y * Math.cos(spreadAngle) + cross.y * Math.sin(spreadAngle),
                z: oppDir.z * Math.cos(spreadAngle) + cross.z * Math.sin(spreadAngle)
            };
            positions.push({
                x: centralPos.x + dir.x * lpDist,
                y: centralPos.y + dir.y * lpDist,
                z: centralPos.z + dir.z * lpDist
            });
        }
    }

    return positions;
}

// ==================== CPK Color Scheme ====================

var cpkColors = {
    'H': '#FFFFFF', 'C': '#555555', 'N': '#3050F8', 'O': '#FF0D0D',
    'F': '#90E050', 'CL': '#1FF01F', 'BR': '#A62929', 'I': '#940094',
    'S': '#FFFF30', 'P': '#FF8000', 'B': '#FFB5B5', 'BE': '#C2FF00',
    'SI': '#F0C8A0', 'XE': '#429EB0', 'KR': '#5CB8D1', 'SE': '#FFA100',
    'TE': '#D47A00', 'AS': '#BD80E3', 'AL': '#BFA6A6', 'W': '#2194D6',
    'RE': '#267DAB', 'MO': '#54B5B5'
};

function getCPKColor(element) {
    if (!element) return '#FF69B4';
    return cpkColors[element.toUpperCase()] || '#FF69B4';
}

// ==================== VSEPR 3D Coordinate Generator ====================

function getVSEPRPositions(bp, lp) {
    var total = bp + lp;
    var allPositions = [];
    var sqrt3_2 = Math.sqrt(3) / 2;
    var sqrt6_3 = Math.sqrt(6) / 3;
    var sqrt2_3 = Math.sqrt(2) / 3;
    var sqrt8_3 = Math.sqrt(8) / 3;

    switch (total) {
        case 1:
            allPositions = [{x:0, y:0, z:1}];
            break;
        case 2:
            allPositions = [{x:0, y:0, z:1}, {x:0, y:0, z:-1}];
            break;
        case 3:
            // Trigonal planar in xz-plane
            allPositions = [
                {x:0, y:0, z:1},
                {x:sqrt3_2, y:0, z:-0.5},
                {x:-sqrt3_2, y:0, z:-0.5}
            ];
            break;
        case 4:
            // Tetrahedral
            allPositions = [
                {x:0, y:1, z:0},
                {x:0, y:-1/3, z:sqrt8_3},
                {x:sqrt6_3, y:-1/3, z:-sqrt2_3},
                {x:-sqrt6_3, y:-1/3, z:-sqrt2_3}
            ];
            break;
        case 5:
            // Trigonal bipyramidal: axial first, then equatorial
            // Lone pairs prefer equatorial positions
            allPositions = [
                // Equatorial (indices 0,1,2) — lone pairs go here first
                {x:0, y:0, z:1},
                {x:sqrt3_2, y:0, z:-0.5},
                {x:-sqrt3_2, y:0, z:-0.5},
                // Axial (indices 3,4)
                {x:0, y:1, z:0},
                {x:0, y:-1, z:0}
            ];
            break;
        case 6:
            // Octahedral: lone pairs go to opposite positions (trans)
            allPositions = [
                {x:1, y:0, z:0},   // 0
                {x:-1, y:0, z:0},  // 1
                {x:0, y:0, z:1},   // 2
                {x:0, y:0, z:-1},  // 3
                {x:0, y:1, z:0},   // 4 — first LP here
                {x:0, y:-1, z:0}   // 5 — second LP opposite
            ];
            break;
        case 7:
            // Pentagonal bipyramidal: equatorial first, then axial
            var pentPositions = [];
            for (var i = 0; i < 5; i++) {
                var angle = i * 2 * Math.PI / 5;
                pentPositions.push({x: Math.cos(angle), y: 0, z: Math.sin(angle)});
            }
            pentPositions.push({x:0, y:1, z:0});
            pentPositions.push({x:0, y:-1, z:0});
            allPositions = pentPositions;
            break;
        default:
            // Fallback: distribute evenly
            allPositions = [{x:0, y:0, z:1}];
            break;
    }

    // Assign lone pair positions based on VSEPR rules
    var bondPositions = [];
    var lonePairPositions = [];

    if (total === 5) {
        // TBP: lone pairs occupy equatorial positions first (indices 0,1,2), then axial (3,4)
        var lpOrder5 = [0, 1, 2, 3, 4]; // equatorial first, then axial
        var lpSet5 = {};
        for (var j5 = 0; j5 < lp && j5 < lpOrder5.length; j5++) {
            lpSet5[lpOrder5[j5]] = true;
        }
        for (var j = 0; j < allPositions.length; j++) {
            if (lpSet5[j]) {
                lonePairPositions.push(allPositions[j]);
            } else {
                bondPositions.push(allPositions[j]);
            }
        }
    } else if (total === 6) {
        // Octahedral: LP placement order: index 4, then 5 (trans), then 1, then 0, ...
        var lpOrder6 = [4, 5, 1, 0, 2, 3];
        var lpSet6 = {};
        for (var k6 = 0; k6 < lp && k6 < lpOrder6.length; k6++) {
            lpSet6[lpOrder6[k6]] = true;
        }
        for (var k = 0; k < allPositions.length; k++) {
            if (lpSet6[k]) {
                lonePairPositions.push(allPositions[k]);
            } else {
                bondPositions.push(allPositions[k]);
            }
        }
    } else if (total === 7) {
        // Pentagonal bipyramidal: LP in equatorial first
        var lpCount7 = 0;
        for (var m = 0; m < allPositions.length; m++) {
            if (lpCount7 < lp && m < 5) {
                lonePairPositions.push(allPositions[m]);
                lpCount7++;
            } else {
                bondPositions.push(allPositions[m]);
            }
        }
    } else {
        // For 2,3,4 total pairs: lone pairs take the last positions
        for (var n = 0; n < allPositions.length; n++) {
            if (n < bp) {
                bondPositions.push(allPositions[n]);
            } else {
                lonePairPositions.push(allPositions[n]);
            }
        }
    }

    return { bondPositions: bondPositions, lonePairPositions: lonePairPositions };
}

function scalePos(pos, factor) {
    return {x: pos.x * factor, y: pos.y * factor, z: pos.z * factor};
}

// ==================== 3D Viewer Builder ====================

function build3DViewer(container, bp, lp, centralAtom, terminalAtoms) {
    if (typeof $3Dmol === 'undefined') {
        // Fallback: return null so caller can use ASCII diagram
        return null;
    }

    var wrapper = document.createElement('div');
    wrapper.className = 'mg-3d-wrapper';

    // Viewer div
    var viewerDiv = document.createElement('div');
    viewerDiv.className = 'mg-3d-viewer';
    wrapper.appendChild(viewerDiv);

    container.appendChild(wrapper);

    // Determine background based on theme
    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    var bgColor = isDark ? '#1e293b' : '#ffffff';

    var viewer = $3Dmol.createViewer(viewerDiv, {
        backgroundColor: bgColor,
        antialias: true,
        preserveDrawingBuffer: true
    });

    var positions = getVSEPRPositions(bp, lp);
    var bondLength = 2.0;
    var lpDistance = 1.2;

    // Central atom
    viewer.addSphere({
        center: {x:0, y:0, z:0},
        radius: 0.45,
        color: getCPKColor(centralAtom)
    });
    viewer.addLabel(centralAtom || 'A', {
        position: {x:0, y:0, z:0},
        fontSize: 14,
        fontColor: isDark ? '#f1f5f9' : '#1e293b',
        backgroundColor: 'transparent',
        borderThickness: 0,
        showBackground: false
    });

    // Terminal atoms + bonds
    for (var i = 0; i < positions.bondPositions.length; i++) {
        var pos = scalePos(positions.bondPositions[i], bondLength);
        var termAtom = (terminalAtoms && terminalAtoms[i]) ? terminalAtoms[i] : 'X';

        // Bond cylinder
        viewer.addCylinder({
            start: {x:0, y:0, z:0},
            end: pos,
            radius: 0.08,
            color: isDark ? '#94a3b8' : '#888888',
            fromCap: false,
            toCap: false
        });

        // Terminal atom sphere
        viewer.addSphere({
            center: pos,
            radius: 0.35,
            color: getCPKColor(termAtom)
        });

        // Terminal atom label
        viewer.addLabel(termAtom, {
            position: pos,
            fontSize: 12,
            fontColor: isDark ? '#f1f5f9' : '#1e293b',
            backgroundColor: 'transparent',
            borderThickness: 0,
            showBackground: false
        });
    }

    // Lone pairs as translucent lobes
    for (var j = 0; j < positions.lonePairPositions.length; j++) {
        var lpPos = scalePos(positions.lonePairPositions[j], lpDistance);
        viewer.addSphere({
            center: lpPos,
            radius: 0.45,
            color: '#FFD700',
            opacity: 0.35
        });
        // Small "LP" label
        viewer.addLabel('LP', {
            position: lpPos,
            fontSize: 10,
            fontColor: '#b8860b',
            backgroundColor: 'transparent',
            borderThickness: 0,
            showBackground: false
        });
    }

    viewer.zoomTo();
    viewer.render();
    viewer.spin('y', 0.5);

    // Controls bar
    var controls = document.createElement('div');
    controls.className = 'mg-viewer-controls';

    var spinning = true;
    var lpVisible = true;

    // Spin toggle
    var spinBtn = document.createElement('button');
    spinBtn.className = 'mg-viewer-ctrl-btn';
    spinBtn.textContent = 'Spin: On';
    spinBtn.onclick = function() {
        spinning = !spinning;
        if (spinning) {
            viewer.spin('y', 0.5);
            spinBtn.textContent = 'Spin: On';
        } else {
            viewer.spin(false);
            spinBtn.textContent = 'Spin: Off';
        }
    };
    controls.appendChild(spinBtn);

    // Reset view
    var resetBtn = document.createElement('button');
    resetBtn.className = 'mg-viewer-ctrl-btn';
    resetBtn.textContent = 'Reset View';
    resetBtn.onclick = function() {
        viewer.zoomTo();
        viewer.render();
    };
    controls.appendChild(resetBtn);

    // Toggle lone pairs
    if (lp > 0) {
        var lpBtn = document.createElement('button');
        lpBtn.className = 'mg-viewer-ctrl-btn';
        lpBtn.textContent = 'LP: Visible';
        lpBtn.onclick = function() {
            lpVisible = !lpVisible;
            // Rebuild viewer to toggle LP visibility
            // Simple approach: rebuild the entire scene
            viewer.removeAllShapes();
            viewer.removeAllLabels();

            // Re-add central atom
            viewer.addSphere({
                center: {x:0, y:0, z:0},
                radius: 0.45,
                color: getCPKColor(centralAtom)
            });
            viewer.addLabel(centralAtom || 'A', {
                position: {x:0, y:0, z:0},
                fontSize: 14,
                fontColor: isDark ? '#f1f5f9' : '#1e293b',
                backgroundColor: 'transparent',
                borderThickness: 0,
                showBackground: false
            });

            // Re-add bonds and terminal atoms
            for (var ii = 0; ii < positions.bondPositions.length; ii++) {
                var p = scalePos(positions.bondPositions[ii], bondLength);
                var ta = (terminalAtoms && terminalAtoms[ii]) ? terminalAtoms[ii] : 'X';
                viewer.addCylinder({
                    start: {x:0, y:0, z:0},
                    end: p,
                    radius: 0.08,
                    color: isDark ? '#94a3b8' : '#888888',
                    fromCap: false,
                    toCap: false
                });
                viewer.addSphere({ center: p, radius: 0.35, color: getCPKColor(ta) });
                viewer.addLabel(ta, {
                    position: p, fontSize: 12,
                    fontColor: isDark ? '#f1f5f9' : '#1e293b',
                    backgroundColor: 'transparent', borderThickness: 0, showBackground: false
                });
            }

            // Conditionally re-add lone pairs
            if (lpVisible) {
                for (var jj = 0; jj < positions.lonePairPositions.length; jj++) {
                    var lpp = scalePos(positions.lonePairPositions[jj], lpDistance);
                    viewer.addSphere({ center: lpp, radius: 0.45, color: '#FFD700', opacity: 0.35 });
                    viewer.addLabel('LP', {
                        position: lpp, fontSize: 10, fontColor: '#b8860b',
                        backgroundColor: 'transparent', borderThickness: 0, showBackground: false
                    });
                }
            }

            viewer.render();
            lpBtn.textContent = lpVisible ? 'LP: Visible' : 'LP: Hidden';
        };
        controls.appendChild(lpBtn);
    }

    wrapper.appendChild(controls);

    // Interaction hint
    var hint = document.createElement('div');
    hint.className = 'mg-viewer-hint';
    hint.textContent = 'Drag to rotate \u00b7 Scroll to zoom \u00b7 Right-drag to pan';
    wrapper.appendChild(hint);

    return wrapper;
}

/**
 * Build terminal atoms array from formula elements.
 * Returns array like ['F','F','F','F'] for SF4.
 */
function buildTerminalAtoms(elements, bp) {
    if (!elements || elements.length < 2) {
        var generic = [];
        for (var i = 0; i < bp; i++) generic.push('X');
        return generic;
    }
    var atoms = [];
    for (var j = 1; j < elements.length; j++) {
        for (var k = 0; k < elements[j].count; k++) {
            atoms.push(elements[j].symbol);
        }
    }
    // Pad or trim to match bp
    while (atoms.length < bp) atoms.push('X');
    if (atoms.length > bp) atoms = atoms.slice(0, bp);
    return atoms;
}

// ==================== DOM Builders ====================

function buildStep(number, desc, detail) {
    var step = document.createElement('div');
    step.className = 'mg-step';
    var numEl = document.createElement('div');
    numEl.className = 'mg-step-number';
    numEl.innerHTML = number;
    var content = document.createElement('div');
    content.className = 'mg-step-content';
    var descEl = document.createElement('div');
    descEl.className = 'mg-step-desc';
    descEl.innerHTML = desc;
    content.appendChild(descEl);
    if (detail) {
        var mathEl = document.createElement('div');
        mathEl.className = 'mg-step-math';
        mathEl.innerHTML = detail;
        content.appendChild(mathEl);
    }
    step.appendChild(numEl);
    step.appendChild(content);
    return step;
}

function buildResultGrid(items) {
    var grid = document.createElement('div');
    grid.className = 'mg-result-grid';
    for (var i = 0; i < items.length; i++) {
        var item = document.createElement('div');
        item.className = 'mg-result-item';
        item.innerHTML = '<div class="mg-result-label">' + items[i].label + '</div>' +
            '<div class="mg-result-value">' + items[i].value + '</div>';
        grid.appendChild(item);
    }
    return grid;
}

function buildDiagram(diagramText) {
    var wrap = document.createElement('div');
    var pre = document.createElement('div');
    pre.className = 'mg-diagram';
    pre.textContent = diagramText;
    wrap.appendChild(pre);
    var legend = document.createElement('div');
    legend.className = 'mg-diagram-legend';
    legend.textContent = 'A = central atom, X = bonded atom, : = lone pair';
    wrap.appendChild(legend);
    return wrap;
}

function buildStepsSection(steps) {
    var frag = document.createDocumentFragment();

    var toggle = document.createElement('button');
    toggle.className = 'mg-steps-toggle';
    toggle.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="6 9 12 15 18 9"/></svg> Step-by-step analysis';
    frag.appendChild(toggle);

    var wrap = document.createElement('div');
    wrap.className = 'mg-steps-wrap';
    for (var i = 0; i < steps.length; i++) {
        wrap.appendChild(steps[i]);
    }
    frag.appendChild(wrap);

    toggle.onclick = function() {
        var isOpen = wrap.classList.contains('open');
        wrap.classList.toggle('open');
        toggle.classList.toggle('open');
    };

    return frag;
}

// ==================== Render Results ====================

function renderByPairs(container, bp, lp) {
    if (!container) return;
    container.innerHTML = '';
    var key = bp + '-' + lp;
    var data = geometryData[key];
    if (!data) {
        showError(container, 'Invalid combination: ' + bp + ' bonding pairs and ' + lp + ' lone pairs.');
        return;
    }
    var totalPairs = bp + lp;

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
    header.innerHTML = '<span class="mg-badge">' + data.notation + ' \u2014 ' + data.molecularGeom + '</span>';
    container.appendChild(header);

    container.appendChild(buildResultGrid([
        { label: 'Molecular Shape', value: data.molecularGeom },
        { label: 'Bond Angle', value: data.angle },
        { label: 'Electron Geometry', value: data.electronGeom },
        { label: 'Hybridization', value: data.hybridization },
        { label: 'Total Pairs', value: totalPairs },
        { label: 'VSEPR Notation', value: data.notation }
    ]));

    // 3D viewer (with ASCII fallback)
    var viewer3d = build3DViewer(container, bp, lp, 'A', null);
    if (!viewer3d) {
        container.appendChild(buildDiagram(data.diagram));
    }

    var steps = [
        buildStep(1, '<strong>Count electron pairs</strong>',
            'Bonding: ' + bp + ', Lone: ' + lp + ', Total: ' + totalPairs),
        buildStep(2, '<strong>Determine electron geometry</strong>',
            totalPairs + ' electron pairs \u2192 <strong>' + data.electronGeom + '</strong>'),
        buildStep(3, '<strong>Determine molecular geometry</strong>',
            'Remove lone pairs from geometry \u2192 <strong>' + data.molecularGeom + '</strong>'),
        buildStep(4, '<strong>Description</strong>', data.description)
    ];
    if (data.examples && data.examples.length > 0) {
        steps.push(buildStep('\u26d7', '<strong>Example molecules</strong>',
            data.examples.join(', ')));
    }
    container.appendChild(buildStepsSection(steps));

    return data;
}

function renderByFormula(container, formula) {
    if (!container) return;

    var molecule = null;
    var upperFormula = formula.toUpperCase();
    var lowerFormula = formula.toLowerCase().trim();

    // 1. Try matching by formula (e.g., "CH4", "H2O")
    for (var i = 0; i < molecules.length; i++) {
        if (molecules[i].formula.toUpperCase() === upperFormula) {
            molecule = molecules[i];
            break;
        }
    }

    // 2. Try matching by name (e.g., "Methane", "Water", "Ammonia")
    if (!molecule) {
        for (var j = 0; j < molecules.length; j++) {
            if (molecules[j].name.toLowerCase() === lowerFormula) {
                molecule = molecules[j];
                break;
            }
        }
    }

    if (molecule) {
        renderKnownMolecule(container, molecule);
        return molecule;
    }

    // 3. Try parsing as chemical formula
    try {
        var result = parseMolecularFormula(formula);
        if (result.multiCenter) {
            renderMultiCenter(container, result);
        } else {
            renderDynamic(container, result);
        }
        return result;
    } catch (e) {
        // 4. Last resort: try PubChem name/formula lookup
        renderByNameLookup(container, formula);
        return null;
    }
}

function renderByNameLookup(container, query) {
    if (!container) return;
    container.innerHTML = '';

    var loadingDiv = document.createElement('div');
    loadingDiv.className = 'mg-3d-loading';
    loadingDiv.innerHTML = '<div class="mg-3d-loading-spinner"></div>';
    container.appendChild(loadingDiv);

    fetchPubChem3D(query).then(function(pubchemData) {
        container.innerHTML = '';
        if (!pubchemData || !pubchemData.sdf) {
            showError(container, 'Could not find "' + query.replace(/[<>&"]/g, '') +
                '". Try a chemical formula (e.g., CH4, H2O) or a common name (e.g., Methane, Water).');
            return;
        }

        // Parse the SDF to extract info
        var parsed = parseSDF(pubchemData.sdf);
        var centralIdx = findCentralAtom(parsed);
        var centralAtom = parsed.atoms[centralIdx];

        // Count bonds to central atom
        var bp = 0;
        for (var b = 0; b < parsed.bonds.length; b++) {
            if (parsed.bonds[b].from === centralIdx || parsed.bonds[b].to === centralIdx) {
                bp++;
            }
        }

        // Header
        var header = document.createElement('div');
        header.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
        header.innerHTML = '<span class="mg-badge">' + query.replace(/[<>&"]/g, '') +
            ' (from PubChem CID: ' + pubchemData.cid + ')</span>';
        container.appendChild(header);

        // Basic info grid
        container.appendChild(buildResultGrid([
            { label: 'Central Atom', value: centralAtom.elem },
            { label: 'Bonds to Central', value: bp },
            { label: 'Total Atoms', value: parsed.atoms.length },
            { label: 'PubChem CID', value: pubchemData.cid }
        ]));

        // 3D viewer
        var viewerDiv = document.createElement('div');
        viewerDiv.className = 'mg-3d-placeholder';
        container.appendChild(viewerDiv);

        var pubchemViewer = buildPubChem3DViewer(viewerDiv, pubchemData.sdf, bp, 0, query, pubchemData.cid);
        if (!pubchemViewer) {
            showError(viewerDiv, '3Dmol.js could not render the structure. Ensure WebGL is supported.');
        }
    });
}

function renderKnownMolecule(container, mol) {
    if (!container) return;
    container.innerHTML = '';
    var key = mol.bp + '-' + mol.lp;
    var data = geometryData[key];
    var totalPairs = mol.bp + mol.lp;

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
    var displayFormula = mol.display || mol.formula;
    header.innerHTML = '<span class="mg-badge">' + mol.name + ' (' + displayFormula + ')</span>';
    container.appendChild(header);

    container.appendChild(buildResultGrid([
        { label: 'Molecular Shape', value: mol.geometry },
        { label: 'Bond Angle', value: mol.angle },
        { label: 'Electron Geometry', value: data ? data.electronGeom : 'N/A' },
        { label: 'Hybridization', value: mol.hybridization },
        { label: 'Bonding Pairs', value: mol.bp },
        { label: 'Lone Pairs', value: mol.lp }
    ]));

    // 3D viewer: try PubChem real coordinates first, then VSEPR fallback
    var viewerPlaceholder = document.createElement('div');
    viewerPlaceholder.className = 'mg-3d-placeholder';
    viewerPlaceholder.innerHTML = '<div class="mg-3d-loading"><div class="mg-3d-loading-spinner"></div><div class="mg-3d-loading-text">Loading 3D model\u2026</div></div>';
    container.appendChild(viewerPlaceholder);

    // Try PubChem, with VSEPR fallback
    (function(placeholder, molecule, geoData) {
        var formulaClean = molecule.formula.replace(/[+-]$/, '').replace(/\(\d*[+-]\)$/, '');
        fetchPubChem3D(formulaClean).then(function(pubchemData) {
            placeholder.innerHTML = '';
            if (pubchemData && pubchemData.sdf) {
                var pubchemViewer = buildPubChem3DViewer(placeholder, pubchemData.sdf, molecule.bp, molecule.lp, molecule.formula, pubchemData.cid);
                if (pubchemViewer) return;
            }
            // Fallback to VSEPR programmatic viewer
            var termAtoms = buildTerminalAtoms(null, molecule.bp);
            try {
                var parsed = parseMolecularFormula(molecule.formula);
                if (!parsed.multiCenter && parsed.elements) {
                    termAtoms = buildTerminalAtoms(parsed.elements, molecule.bp);
                }
            } catch(e) { /* use default */ }
            var centralMatch = molecule.formula.match(/^([A-Z][a-z]?)/);
            var centralEl = (centralMatch && centralMatch[1]) ? centralMatch[1] : 'A';
            var viewer3d = build3DViewer(placeholder, molecule.bp, molecule.lp, centralEl, termAtoms);
            if (!viewer3d && geoData) {
                placeholder.appendChild(buildDiagram(geoData.diagram));
            }
        });
    })(viewerPlaceholder, mol, data);

    var steps = [
        buildStep(1, '<strong>Molecule identified</strong>',
            mol.name + ' (' + displayFormula + ') found in database'),
        buildStep(2, '<strong>Electron pairs</strong>',
            'Bonding: ' + mol.bp + ', Lone: ' + mol.lp + ', Total: ' + totalPairs),
        buildStep(3, '<strong>VSEPR classification</strong>',
            (data ? data.notation : 'N/A') + ' \u2192 ' + mol.geometry)
    ];
    if (data) {
        steps.push(buildStep(4, '<strong>Description</strong>', data.description));
    }
    container.appendChild(buildStepsSection(steps));
}

function renderDynamic(container, result) {
    if (!container) return;
    container.innerHTML = '';
    var totalPairs = result.bondingPairs + result.lonePairs;

    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
    header.innerHTML = '<span class="mg-badge">' + unicodeFormula(result.formula) + ' \u2014 ' + result.data.molecularGeom + '</span>';
    container.appendChild(header);

    container.appendChild(buildResultGrid([
        { label: 'Molecular Shape', value: result.data.molecularGeom },
        { label: 'Bond Angle', value: result.data.angle },
        { label: 'Electron Geometry', value: result.data.electronGeom },
        { label: 'Hybridization', value: result.data.hybridization },
        { label: 'Central Atom', value: result.centralAtom },
        { label: 'Valence Electrons', value: result.totalValence }
    ]));

    // 3D viewer: try PubChem first, then VSEPR fallback
    var viewerPlaceholder = document.createElement('div');
    viewerPlaceholder.className = 'mg-3d-placeholder';
    viewerPlaceholder.innerHTML = '<div class="mg-3d-loading"><div class="mg-3d-loading-spinner"></div><div class="mg-3d-loading-text">Loading 3D model\u2026</div></div>';
    container.appendChild(viewerPlaceholder);

    (function(placeholder, res) {
        var formulaClean = res.formula.replace(/[+-]$/, '').replace(/\(\d*[+-]\)$/, '');
        fetchPubChem3D(formulaClean).then(function(pubchemData) {
            placeholder.innerHTML = '';
            if (pubchemData && pubchemData.sdf) {
                var pubchemViewer = buildPubChem3DViewer(placeholder, pubchemData.sdf, res.bondingPairs, res.lonePairs, res.formula, pubchemData.cid);
                if (pubchemViewer) return;
            }
            // Fallback to VSEPR
            var termAtoms = buildTerminalAtoms(res.elements, res.bondingPairs);
            var viewer3d = build3DViewer(placeholder, res.bondingPairs, res.lonePairs, res.centralAtom, termAtoms);
            if (!viewer3d) {
                placeholder.appendChild(buildDiagram(res.data.diagram));
            }
        });
    })(viewerPlaceholder, result);

    var steps = [
        buildStep(1, '<strong>Parse formula</strong>',
            'Central atom: ' + result.centralAtom + ', Surrounding atoms: ' + result.bondingPairs),
        buildStep(2, '<strong>Count valence electrons</strong>',
            'Total: ' + result.totalValence + (result.charge !== 0 ? ' (charge adjusted)' : '')),
        buildStep(3, '<strong>Determine pairs</strong>',
            'Bonding: ' + result.bondingPairs + ', Lone: ' + result.lonePairs + ', Total: ' + totalPairs),
        buildStep(4, '<strong>VSEPR classification</strong>',
            result.data.notation + ' \u2192 ' + result.data.molecularGeom),
        buildStep(5, '<strong>Description</strong>', result.data.description)
    ];
    if (result.data.examples && result.data.examples.length > 0) {
        steps.push(buildStep('\u26d7', '<strong>Similar molecules</strong>',
            result.data.examples.join(', ')));
    }
    container.appendChild(buildStepsSection(steps));
}

// ==================== Molecule Table ====================

function renderMoleculeTable(tbody, filter) {
    if (!tbody) return;
    tbody.innerHTML = '';
    var term = (filter || '').toLowerCase();
    for (var i = 0; i < molecules.length; i++) {
        var m = molecules[i];
        if (term && m.formula.toLowerCase().indexOf(term) === -1 &&
            m.name.toLowerCase().indexOf(term) === -1 &&
            m.geometry.toLowerCase().indexOf(term) === -1) continue;
        var tr = document.createElement('tr');
        tr.innerHTML = '<td><strong>' + (m.display || m.formula) + '</strong></td>' +
            '<td>' + m.name + '</td>' +
            '<td>' + m.bp + '</td><td>' + m.lp + '</td>' +
            '<td><span class="mg-geom-badge">' + m.geometry + '</span></td>' +
            '<td>' + m.angle + '</td>' +
            '<td><button class="mg-table-btn" data-formula="' + m.formula + '">View</button></td>';
        tbody.appendChild(tr);
    }
}

// ==================== Multi-Center Renderer ====================

function renderMultiCenter(container, result) {
    if (!container) return;
    container.innerHTML = '';

    var displayF = unicodeFormula(result.formula);

    // Header badge
    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:0.75rem;';
    header.innerHTML = '<span class="mg-badge">Multi-Center \u2014 ' + displayF + '</span>';
    container.appendChild(header);

    // Summary grid
    var summaryItems = [
        { label: 'Formula', value: displayF },
        { label: 'Total Valence e\u207b', value: result.totalValence },
        { label: 'Unsaturation (IHD)', value: result.ihd },
        { label: 'Atom Centers', value: result.centers.length + ' types' }
    ];
    if (result.charge !== 0) {
        summaryItems.push({ label: 'Charge', value: (result.charge > 0 ? '+' : '') + result.charge });
    }
    container.appendChild(buildResultGrid(summaryItems));

    // Full molecule 3D view from PubChem
    var multiViewerPlaceholder = document.createElement('div');
    multiViewerPlaceholder.className = 'mg-3d-placeholder';
    multiViewerPlaceholder.innerHTML = '<div class="mg-3d-loading"><div class="mg-3d-loading-spinner"></div><div class="mg-3d-loading-text">Loading 3D model\u2026</div></div>';
    container.appendChild(multiViewerPlaceholder);

    (function(placeholder, formula) {
        var formulaClean = formula.replace(/[+-]$/, '').replace(/\(\d*[+-]\)$/, '');
        fetchPubChem3D(formulaClean).then(function(pubchemData) {
            placeholder.innerHTML = '';
            if (pubchemData && pubchemData.sdf) {
                buildPubChem3DViewer(placeholder, pubchemData.sdf, 0, 0, formula, pubchemData.cid);
            }
            // If PubChem fails, no fallback for multi-center (individual centers have their own viewers)
        });
    })(multiViewerPlaceholder, result.formula);

    // IHD explanation step
    var ihdNote = result.ihd === 0 ? 'Fully saturated (no rings or double bonds)' :
        result.ihd + ' degree' + (result.ihd !== 1 ? 's' : '') + ' of unsaturation (rings and/or \u03c0 bonds)';
    container.appendChild(buildStep(1, '<strong>Index of Hydrogen Deficiency</strong>', ihdNote));
    container.appendChild(buildStep(2, '<strong>Analyze each atom center</strong>',
        'VSEPR applies to each heavy atom individually. Below is the geometry at each unique center.'));

    // Per-center cards
    var stepNum = 3;
    for (var i = 0; i < result.centers.length; i++) {
        var c = result.centers[i];
        var countLabel = c.count > 1 ? ' (\u00d7' + c.count + ' in molecule)' : '';

        var card = document.createElement('div');
        card.className = 'mg-center-card';
        card.style.cssText = 'margin:0.75rem 0;padding:1rem;border:1px solid var(--border,#e2e8f0);border-radius:0.75rem;background:var(--bg-secondary,#f8fafc);';

        // Center header
        var centerHdr = document.createElement('div');
        centerHdr.style.cssText = 'display:flex;justify-content:space-between;align-items:center;margin-bottom:0.5rem;';
        centerHdr.innerHTML = '<div style="font-weight:700;font-size:1rem;color:var(--mg-tool,#059669);">' +
            c.symbol + ' Center' + countLabel + '</div>' +
            '<span class="mg-geom-badge" style="font-size:0.75rem;">' + c.geometry + '</span>';
        card.appendChild(centerHdr);

        // Info grid
        var infoGrid = document.createElement('div');
        infoGrid.style.cssText = 'display:grid;grid-template-columns:repeat(auto-fit,minmax(100px,1fr));gap:0.5rem;margin-bottom:0.5rem;';
        var infoItems = [
            { l: 'Bonding Pairs', v: c.bp },
            { l: 'Lone Pairs', v: c.lp },
            { l: 'Bond Angle', v: c.angle },
            { l: 'Hybridization', v: c.hybridization },
            { l: 'VSEPR', v: c.notation }
        ];
        for (var k = 0; k < infoItems.length; k++) {
            var cell = document.createElement('div');
            cell.className = 'mg-result-item';
            cell.innerHTML = '<span class="mg-result-label">' + infoItems[k].l + '</span>' +
                '<span class="mg-result-value">' + infoItems[k].v + '</span>';
            infoGrid.appendChild(cell);
        }
        card.appendChild(infoGrid);

        // 3D mini-viewer for each center
        var centerViewer = build3DViewer(card, c.bp, c.lp, c.symbol, null);
        if (!centerViewer && c.diagram) {
            var diag = document.createElement('pre');
            diag.className = 'mg-diagram';
            diag.style.cssText = 'margin:0.5rem 0 0;padding:0.5rem;font-size:0.75rem;';
            diag.textContent = c.diagram;
            card.appendChild(diag);
        }

        // Description
        var desc = document.createElement('div');
        desc.style.cssText = 'font-size:0.75rem;color:var(--text-secondary,#64748b);margin-top:0.5rem;';
        desc.textContent = c.label + ' \u2014 ' + c.note;
        card.appendChild(desc);

        container.appendChild(card);
        stepNum++;
    }

    // Summary step
    var summaryText = result.centers.map(function(c) {
        return '<strong>' + c.symbol + '</strong>: ' + c.geometry + ' (' + c.angle + ')';
    }).join(' &nbsp;\u2022&nbsp; ');
    container.appendChild(buildStep('\u2713', '<strong>Summary</strong>', summaryText));
}

// ==================== Error ====================

function showError(container, message) {
    if (!container) return;
    container.innerHTML = '<div style="padding:1rem;background:#fef2f2;border-left:3px solid #ef4444;border-radius:0.5rem;color:#dc2626;font-size:0.8125rem;">' +
        '<div style="font-weight:600;margin-bottom:0.25rem;">\u274c Error</div>' +
        '<div>' + message + '</div></div>';
}

// ==================== Exports ====================

// ==================== Compare Renderer ====================

function resolveMolecule(input) {
    if (!input) return null;
    var clean = input.trim();
    var upper = clean.toUpperCase();
    var lower = clean.toLowerCase();

    // Try formula match
    for (var i = 0; i < molecules.length; i++) {
        if (molecules[i].formula.toUpperCase() === upper) return molecules[i];
    }
    // Try name match
    for (var j = 0; j < molecules.length; j++) {
        if (molecules[j].name.toLowerCase() === lower) return molecules[j];
    }
    // Try formula parse
    try {
        var parsed = parseMolecularFormula(clean);
        if (!parsed.multiCenter) {
            return {
                formula: clean,
                display: unicodeFormula(clean),
                name: unicodeFormula(clean),
                bp: parsed.bondingPairs,
                lp: parsed.lonePairs,
                geometry: parsed.data.molecularGeom,
                angle: parsed.data.angle,
                hybridization: parsed.data.hybridization,
                _parsed: parsed
            };
        }
    } catch(e) { /* not a parseable formula */ }
    return null;
}

function renderCompareSide(container, mol) {
    container.innerHTML = '';
    if (!mol) {
        container.innerHTML = '<div style="padding:2rem;text-align:center;color:var(--text-muted);font-size:0.75rem;">Enter a formula or name</div>';
        return;
    }

    var displayFormula = mol.display || unicodeFormula(mol.formula);

    // Badge
    var header = document.createElement('div');
    header.style.cssText = 'text-align:center;margin-bottom:0.375rem;';
    header.innerHTML = '<span class="mg-badge">' + (mol.name || displayFormula) + '</span>';
    container.appendChild(header);

    // Compact result grid
    container.appendChild(buildResultGrid([
        { label: 'Shape', value: mol.geometry },
        { label: 'Angle', value: mol.angle },
        { label: 'Hybrid', value: mol.hybridization },
        { label: 'BP / LP', value: mol.bp + ' / ' + mol.lp }
    ]));

    // 3D viewer
    var viewerPlaceholder = document.createElement('div');
    viewerPlaceholder.className = 'mg-3d-placeholder';
    viewerPlaceholder.innerHTML = '<div class="mg-3d-loading"><div class="mg-3d-loading-spinner"></div><div class="mg-3d-loading-text">Loading 3D model\u2026</div></div>';
    container.appendChild(viewerPlaceholder);

    (function(placeholder, molecule) {
        var formulaClean = molecule.formula.replace(/[+-]$/, '').replace(/\(\d*[+-]\)$/, '');
        fetchPubChem3D(formulaClean).then(function(pubchemData) {
            placeholder.innerHTML = '';
            if (pubchemData && pubchemData.sdf) {
                var pv = buildPubChem3DViewer(placeholder, pubchemData.sdf, molecule.bp, molecule.lp, molecule.formula, pubchemData.cid);
                if (pv) return;
            }
            // VSEPR fallback
            var termAtoms = buildTerminalAtoms(null, molecule.bp);
            try {
                var parsed = parseMolecularFormula(molecule.formula);
                if (!parsed.multiCenter && parsed.elements) termAtoms = buildTerminalAtoms(parsed.elements, molecule.bp);
            } catch(e) {}
            var centralMatch = molecule.formula.match(/^([A-Z][a-z]?)/);
            var centralEl = (centralMatch && centralMatch[1]) ? centralMatch[1] : 'A';
            build3DViewer(placeholder, molecule.bp, molecule.lp, centralEl, termAtoms);
        });
    })(viewerPlaceholder, mol);
}

function renderCompareDiff(container, mol1, mol2) {
    container.innerHTML = '';
    if (!mol1 || !mol2) return;

    var table = document.createElement('table');
    table.className = 'mg-compare-diff-table';

    var thead = '<thead><tr><th>Property</th><th>' + (mol1.display || unicodeFormula(mol1.formula)) +
        '</th><th>' + (mol2.display || unicodeFormula(mol2.formula)) + '</th></tr></thead>';

    var props = [
        { label: 'Geometry', key: 'geometry' },
        { label: 'Bond Angle', key: 'angle' },
        { label: 'Hybridization', key: 'hybridization' },
        { label: 'Bonding Pairs', key: 'bp' },
        { label: 'Lone Pairs', key: 'lp' }
    ];

    var tbody = '<tbody>';
    for (var i = 0; i < props.length; i++) {
        var v1 = String(mol1[props[i].key]);
        var v2 = String(mol2[props[i].key]);
        var cls = v1 === v2 ? 'mg-compare-diff-match' : 'mg-compare-diff-diff';
        tbody += '<tr><td><strong>' + props[i].label + '</strong></td>' +
            '<td class="' + cls + '">' + v1 + '</td>' +
            '<td class="' + cls + '">' + v2 + '</td></tr>';
    }
    tbody += '</tbody>';

    table.innerHTML = thead + tbody;
    container.appendChild(table);
}

window.MolGeomRender = {
    molecules: molecules,
    geometryData: geometryData,
    parseMolecularFormula: parseMolecularFormula,
    unicodeFormula: unicodeFormula,
    renderByPairs: renderByPairs,
    renderByFormula: renderByFormula,
    renderMoleculeTable: renderMoleculeTable,
    resolveMolecule: resolveMolecule,
    renderCompareSide: renderCompareSide,
    renderCompareDiff: renderCompareDiff,
    showError: showError,
    buildStep: buildStep
};

})();
