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

    container.appendChild(buildDiagram(data.diagram));

    container.appendChild(buildStep(1, '<strong>Count electron pairs</strong>',
        'Bonding: ' + bp + ', Lone: ' + lp + ', Total: ' + totalPairs));
    container.appendChild(buildStep(2, '<strong>Determine electron geometry</strong>',
        totalPairs + ' electron pairs \u2192 <strong>' + data.electronGeom + '</strong>'));
    container.appendChild(buildStep(3, '<strong>Determine molecular geometry</strong>',
        'Remove lone pairs from geometry \u2192 <strong>' + data.molecularGeom + '</strong>'));
    container.appendChild(buildStep(4, '<strong>Description</strong>', data.description));

    if (data.examples && data.examples.length > 0) {
        container.appendChild(buildStep('\u26d7', '<strong>Example molecules</strong>',
            data.examples.join(', ')));
    }

    return data;
}

function renderByFormula(container, formula) {
    if (!container) return;

    var molecule = null;
    var upperFormula = formula.toUpperCase();
    for (var i = 0; i < molecules.length; i++) {
        if (molecules[i].formula.toUpperCase() === upperFormula) {
            molecule = molecules[i];
            break;
        }
    }

    if (molecule) {
        renderKnownMolecule(container, molecule);
        return molecule;
    }

    try {
        var result = parseMolecularFormula(formula);
        if (result.multiCenter) {
            renderMultiCenter(container, result);
        } else {
            renderDynamic(container, result);
        }
        return result;
    } catch (e) {
        showError(container, 'Could not parse formula: ' + e.message);
        return null;
    }
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

    if (data) container.appendChild(buildDiagram(data.diagram));

    container.appendChild(buildStep(1, '<strong>Molecule identified</strong>',
        mol.name + ' (' + displayFormula + ') found in database'));
    container.appendChild(buildStep(2, '<strong>Electron pairs</strong>',
        'Bonding: ' + mol.bp + ', Lone: ' + mol.lp + ', Total: ' + totalPairs));
    container.appendChild(buildStep(3, '<strong>VSEPR classification</strong>',
        (data ? data.notation : 'N/A') + ' \u2192 ' + mol.geometry));
    if (data) {
        container.appendChild(buildStep(4, '<strong>Description</strong>', data.description));
    }
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

    container.appendChild(buildDiagram(result.data.diagram));

    container.appendChild(buildStep(1, '<strong>Parse formula</strong>',
        'Central atom: ' + result.centralAtom + ', Surrounding atoms: ' + result.bondingPairs));
    container.appendChild(buildStep(2, '<strong>Count valence electrons</strong>',
        'Total: ' + result.totalValence + (result.charge !== 0 ? ' (charge adjusted)' : '')));
    container.appendChild(buildStep(3, '<strong>Determine pairs</strong>',
        'Bonding: ' + result.bondingPairs + ', Lone: ' + result.lonePairs + ', Total: ' + totalPairs));
    container.appendChild(buildStep(4, '<strong>VSEPR classification</strong>',
        result.data.notation + ' \u2192 ' + result.data.molecularGeom));
    container.appendChild(buildStep(5, '<strong>Description</strong>', result.data.description));

    if (result.data.examples && result.data.examples.length > 0) {
        container.appendChild(buildStep('\u26d7', '<strong>Similar molecules</strong>',
            result.data.examples.join(', ')));
    }
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

        // Diagram
        if (c.diagram) {
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

window.MolGeomRender = {
    molecules: molecules,
    geometryData: geometryData,
    parseMolecularFormula: parseMolecularFormula,
    unicodeFormula: unicodeFormula,
    renderByPairs: renderByPairs,
    renderByFormula: renderByFormula,
    renderMoleculeTable: renderMoleculeTable,
    showError: showError,
    buildStep: buildStep
};

})();
