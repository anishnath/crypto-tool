<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Molecular Geometry Calculator | VSEPR Theory | 8gwifi.org</title>
    <meta name="description" content="Calculate molecular geometry using VSEPR theory. Determine electron geometry, molecular shape, bond angles, and hybridization from chemical formula or electron pairs. Free chemistry tool with 3D geometry visualization.">
    <meta name="keywords" content="molecular geometry calculator, VSEPR theory, electron geometry, molecular shape, bond angles, hybridization, Lewis structure, chemistry calculator">

    <link rel="canonical" href="https://8gwifi.org/molecular-geometry-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Molecular Geometry Calculator",
      "description": "Calculate molecular geometry and shape using VSEPR theory from electron pairs or chemical formula.",
      "url": "https://8gwifi.org/molecular-geometry-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What is VSEPR theory?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on electron pair repulsion. Electron pairs arrange themselves to minimize repulsion, determining the 3D shape of molecules."
        }
      },{
        "@type": "Question",
        "name": "How do you determine molecular geometry?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Count bonding pairs and lone pairs around the central atom. The total gives electron geometry. Subtract lone pairs to get molecular geometry. For example, 4 electron pairs with 2 lone pairs gives tetrahedral electron geometry but bent molecular shape."
        }
      }]
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-cube"></i> Molecular Geometry Calculator</h1>
    <p class="text-center text-muted mb-4">
        Determine molecular shape using VSEPR theory<br>
        <span class="badge badge-success"><i class="fas fa-magic"></i> Dynamic Formula Parser - Enter ANY Chemical Formula!</span>
    </p>

    <div class="row">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="pairs-tab" data-toggle="tab" href="#pairs" role="tab">
                                <i class="fas fa-atom"></i> By Electron Pairs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="formula-tab" data-toggle="tab" href="#formula" role="tab">
                                <i class="fas fa-flask"></i> By Formula
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="database-tab" data-toggle="tab" href="#database" role="tab">
                                <i class="fas fa-database"></i> Molecule Database
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- By Electron Pairs Tab -->
                        <div class="tab-pane fade show active" id="pairs" role="tabpanel">
                            <form onsubmit="calculateByPairs(); return false;">
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label>Bonding Pairs (BP)</label>
                                        <input type="number" class="form-control" id="bondingPairs" min="1" max="7" value="4" required>
                                        <small class="form-text text-muted">Number of atoms bonded to central atom</small>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>Lone Pairs (LP)</label>
                                        <input type="number" class="form-control" id="lonePairs" min="0" max="4" value="0" required>
                                        <small class="form-text text-muted">Number of lone electron pairs</small>
                                    </div>
                                </div>
                                <button type="submit" class="btn btn-primary btn-block">
                                    <i class="fas fa-calculator"></i> Calculate Geometry
                                </button>
                            </form>
                            <div id="pairsResult" class="mt-4"></div>
                        </div>

                        <!-- By Formula Tab -->
                        <div class="tab-pane fade" id="formula" role="tabpanel">
                            <form onsubmit="calculateByFormula(); return false;">
                                <div class="form-group">
                                    <label>Chemical Formula</label>
                                    <input type="text" class="form-control form-control-lg" id="chemFormula"
                                           placeholder="e.g., CH4, NH3, H2O, SF6, NH4+, SO4(2-)" required>
                                    <small class="form-text text-muted">
                                        <strong><i class="fas fa-magic"></i> Dynamic Calculator:</strong> Enter ANY chemical formula!
                                        Supports ions (e.g., NH4+, SO4(2-)). Central atom should be first.
                                    </small>
                                </div>
                                <button type="submit" class="btn btn-primary btn-block">
                                    <i class="fas fa-calculator"></i> Determine Geometry
                                </button>
                            </form>
                            <div id="formulaResult" class="mt-4"></div>
                        </div>

                        <!-- Molecule Database Tab -->
                        <div class="tab-pane fade" id="database" role="tabpanel">
                            <div class="form-group">
                                <input type="text" class="form-control" id="searchMolecule"
                                       placeholder="Search molecules..." onkeyup="searchMolecules()">
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover" id="moleculeTable">
                                    <thead class="thead-light">
                                        <tr>
                                            <th>Formula</th>
                                            <th>Name</th>
                                            <th>BP</th>
                                            <th>LP</th>
                                            <th>Geometry</th>
                                            <th>Bond Angle</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody id="moleculeTableBody"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-magic"></i> Dynamic Calculator</h5>
                </div>
                <div class="card-body">
                    <div class="alert alert-success small mb-3">
                        <strong>Enter ANY chemical formula!</strong><br>
                        Automatically calculates geometry using VSEPR theory and valence electrons.
                    </div>

                    <h6>Features</h6>
                    <ul class="small">
                        <li>✓ Parse any formula (CH4, NH3, etc.)</li>
                        <li>✓ Support ions (NH4+, SO4(2-))</li>
                        <li>✓ Auto-detect central atom</li>
                        <li>✓ Calculate bonding/lone pairs</li>
                        <li>✓ Show 3D ASCII diagrams</li>
                        <li>✓ 26 geometries covered</li>
                    </ul>

                    <h6>Try These Examples</h6>
                    <button class="btn btn-sm btn-outline-success btn-block" onclick="loadFormulaExample('SiH4')">SiH₄ (Silane)</button>
                    <button class="btn btn-sm btn-outline-success btn-block" onclick="loadFormulaExample('AsF5')">AsF₅ (Arsenic Pentafluoride)</button>
                    <button class="btn btn-sm btn-outline-success btn-block" onclick="loadFormulaExample('NH4+')">NH₄⁺ (Ammonium)</button>
                    <button class="btn btn-sm btn-outline-success btn-block" onclick="loadFormulaExample('ClO2-')">ClO₂⁻ (Chlorite)</button>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> VSEPR Theory</h5>
                </div>
                <div class="card-body">
                    <h6>Notation</h6>
                    <div class="alert alert-info small">
                        <strong>AX<sub>n</sub>E<sub>m</sub></strong><br>
                        A = Central atom<br>
                        X = Bonding pairs (n)<br>
                        E = Lone pairs (m)
                    </div>

                    <h6>Common Geometries</h6>
                    <ul class="small">
                        <li><strong>Linear:</strong> 180°</li>
                        <li><strong>Trigonal Planar:</strong> 120°</li>
                        <li><strong>Tetrahedral:</strong> 109.5°</li>
                        <li><strong>Trigonal Bipyramidal:</strong> 90°, 120°</li>
                        <li><strong>Octahedral:</strong> 90°</li>
                        <li><strong>Pentagonal Bipyramidal:</strong> 72°, 90°</li>
                    </ul>
                </div>
            </div>

            <%@ include file="related-encoders.jsp"%>
        </div>
    </div>

    <%@ include file="thanks.jsp"%>
    <hr>
    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
// Molecular geometry database
const molecules = [
    // Linear (2 electron pairs)
    { formula: 'CO2', name: 'Carbon Dioxide', bp: 2, lp: 0, geometry: 'Linear', angle: '180°', hybridization: 'sp' },
    { formula: 'BeCl2', name: 'Beryllium Chloride', bp: 2, lp: 0, geometry: 'Linear', angle: '180°', hybridization: 'sp' },
    { formula: 'CO', name: 'Carbon Monoxide', bp: 1, lp: 1, geometry: 'Linear', angle: '180°', hybridization: 'sp' },

    // Trigonal Planar (3 electron pairs)
    { formula: 'BF3', name: 'Boron Trifluoride', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120°', hybridization: 'sp²' },
    { formula: 'SO3', name: 'Sulfur Trioxide', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120°', hybridization: 'sp²' },
    { formula: 'NO3-', name: 'Nitrate Ion', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120°', hybridization: 'sp²' },
    { formula: 'SO2', name: 'Sulfur Dioxide', bp: 2, lp: 1, geometry: 'Bent', angle: '119°', hybridization: 'sp²' },
    { formula: 'O3', name: 'Ozone', bp: 2, lp: 1, geometry: 'Bent', angle: '117°', hybridization: 'sp²' },

    // Tetrahedral (4 electron pairs)
    { formula: 'CH4', name: 'Methane', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5°', hybridization: 'sp³' },
    { formula: 'CCl4', name: 'Carbon Tetrachloride', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5°', hybridization: 'sp³' },
    { formula: 'NH4+', name: 'Ammonium Ion', bp: 4, lp: 0, geometry: 'Tetrahedral', angle: '109.5°', hybridization: 'sp³' },
    { formula: 'NH3', name: 'Ammonia', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '107°', hybridization: 'sp³' },
    { formula: 'PCl3', name: 'Phosphorus Trichloride', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '107°', hybridization: 'sp³' },
    { formula: 'H3O+', name: 'Hydronium Ion', bp: 3, lp: 1, geometry: 'Trigonal Pyramidal', angle: '107°', hybridization: 'sp³' },
    { formula: 'H2O', name: 'Water', bp: 2, lp: 2, geometry: 'Bent', angle: '104.5°', hybridization: 'sp³' },
    { formula: 'H2S', name: 'Hydrogen Sulfide', bp: 2, lp: 2, geometry: 'Bent', angle: '92°', hybridization: 'sp³' },
    { formula: 'OF2', name: 'Oxygen Difluoride', bp: 2, lp: 2, geometry: 'Bent', angle: '103°', hybridization: 'sp³' },

    // Trigonal Bipyramidal (5 electron pairs)
    { formula: 'PCl5', name: 'Phosphorus Pentachloride', bp: 5, lp: 0, geometry: 'Trigonal Bipyramidal', angle: '90°, 120°', hybridization: 'sp³d' },
    { formula: 'PF5', name: 'Phosphorus Pentafluoride', bp: 5, lp: 0, geometry: 'Trigonal Bipyramidal', angle: '90°, 120°', hybridization: 'sp³d' },
    { formula: 'SF4', name: 'Sulfur Tetrafluoride', bp: 4, lp: 1, geometry: 'See-Saw', angle: '~102°, ~173°', hybridization: 'sp³d' },
    { formula: 'ClF3', name: 'Chlorine Trifluoride', bp: 3, lp: 2, geometry: 'T-Shaped', angle: '~87.5°', hybridization: 'sp³d' },
    { formula: 'BrF3', name: 'Bromine Trifluoride', bp: 3, lp: 2, geometry: 'T-Shaped', angle: '~86°', hybridization: 'sp³d' },
    { formula: 'XeF2', name: 'Xenon Difluoride', bp: 2, lp: 3, geometry: 'Linear', angle: '180°', hybridization: 'sp³d' },
    { formula: 'I3-', name: 'Triiodide Ion', bp: 2, lp: 3, geometry: 'Linear', angle: '180°', hybridization: 'sp³d' },

    // Octahedral (6 electron pairs)
    { formula: 'SF6', name: 'Sulfur Hexafluoride', bp: 6, lp: 0, geometry: 'Octahedral', angle: '90°', hybridization: 'sp³d²' },
    { formula: 'PF6-', name: 'Hexafluorophosphate Ion', bp: 6, lp: 0, geometry: 'Octahedral', angle: '90°', hybridization: 'sp³d²' },
    { formula: 'BrF5', name: 'Bromine Pentafluoride', bp: 5, lp: 1, geometry: 'Square Pyramidal', angle: '~84°', hybridization: 'sp³d²' },
    { formula: 'IF5', name: 'Iodine Pentafluoride', bp: 5, lp: 1, geometry: 'Square Pyramidal', angle: '~81°', hybridization: 'sp³d²' },
    { formula: 'XeF4', name: 'Xenon Tetrafluoride', bp: 4, lp: 2, geometry: 'Square Planar', angle: '90°', hybridization: 'sp³d²' },
    { formula: 'ICl4-', name: 'Tetrachloroiodate Ion', bp: 4, lp: 2, geometry: 'Square Planar', angle: '90°', hybridization: 'sp³d²' },

    // Pentagonal Bipyramidal (7 electron pairs) - Rare
    { formula: 'IF7', name: 'Iodine Heptafluoride', bp: 7, lp: 0, geometry: 'Pentagonal Bipyramidal', angle: '72°, 90°', hybridization: 'sp³d³' },

    // Other common molecules
    { formula: 'CH2O', name: 'Formaldehyde', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120°', hybridization: 'sp²' },
    { formula: 'C2H4', name: 'Ethylene', bp: 3, lp: 0, geometry: 'Trigonal Planar', angle: '120°', hybridization: 'sp²' },
    { formula: 'NO2-', name: 'Nitrite Ion', bp: 2, lp: 1, geometry: 'Bent', angle: '115°', hybridization: 'sp²' },
];

// VSEPR geometry data
const geometryData = {
    '1-0': {
        electronGeom: 'Linear',
        molecularGeom: 'Linear',
        angle: 'N/A',
        hybridization: 's',
        notation: 'AX',
        examples: ['H⁺', 'Li', 'Na'],
        description: 'Single atom or monatomic ion.',
        diagram: 'A—X'
    },
    '2-0': {
        electronGeom: 'Linear',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp',
        notation: 'AX₂',
        examples: ['CO₂', 'BeCl₂', 'CS₂'],
        description: 'Two bonding pairs arrange in a straight line to minimize repulsion.',
        diagram: 'X—A—X'
    },
    '1-1': {
        electronGeom: 'Linear',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp',
        notation: 'AXE',
        examples: ['CO', 'NO⁺', 'CN⁻'],
        description: 'One bond and one lone pair in linear arrangement.',
        diagram: ':—A—X'
    },
    '3-0': {
        electronGeom: 'Trigonal Planar',
        molecularGeom: 'Trigonal Planar',
        angle: '120°',
        hybridization: 'sp²',
        notation: 'AX₃',
        examples: ['BF₃', 'SO₃', 'AlCl₃'],
        description: 'Three bonding pairs form a flat triangle in one plane.',
        diagram: '    X\n    |\n X—A—X'
    },
    '2-1': {
        electronGeom: 'Trigonal Planar',
        molecularGeom: 'Bent',
        angle: '~119°',
        hybridization: 'sp²',
        notation: 'AX₂E',
        examples: ['SO₂', 'NO₂⁻', 'O₃'],
        description: 'Lone pair pushes bonding pairs closer, creating bent shape.',
        diagram: '    :\n    |\n X—A—X'
    },
    '1-2': {
        electronGeom: 'Trigonal Planar',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp²',
        notation: 'AXE₂',
        examples: ['SnCl₂ (gas)', 'NO₂⁺ (excited)'],
        description: 'Two lone pairs leave single bonding pair (very rare).',
        diagram: ': A—X :'
    },
    '4-0': {
        electronGeom: 'Tetrahedral',
        molecularGeom: 'Tetrahedral',
        angle: '109.5°',
        hybridization: 'sp³',
        notation: 'AX₄',
        examples: ['CH₄', 'CCl₄', 'SiH₄'],
        description: 'Four bonding pairs arrange at corners of a tetrahedron.',
        diagram: '    X\n    |\n X—A—X\n    |\n    X'
    },
    '3-1': {
        electronGeom: 'Tetrahedral',
        molecularGeom: 'Trigonal Pyramidal',
        angle: '~107°',
        hybridization: 'sp³',
        notation: 'AX₃E',
        examples: ['NH₃', 'PCl₃', 'AsH₃'],
        description: 'Lone pair occupies one tetrahedral position, forming pyramid.',
        diagram: '    :\n    |\n X—A—X\n    |\n    X'
    },
    '2-2': {
        electronGeom: 'Tetrahedral',
        molecularGeom: 'Bent',
        angle: '104.5°',
        hybridization: 'sp³',
        notation: 'AX₂E₂',
        examples: ['H₂O', 'H₂S', 'SCl₂'],
        description: 'Two lone pairs compress bond angle below tetrahedral.',
        diagram: '  : :\n   |\n X—A—X'
    },
    '1-3': {
        electronGeom: 'Tetrahedral',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp³',
        notation: 'AXE₃',
        examples: ['ClO⁻ (theoretical)'],
        description: 'Three lone pairs leave single bond (extremely rare/unstable).',
        diagram: ': : : A—X'
    },
    '5-0': {
        electronGeom: 'Trigonal Bipyramidal',
        molecularGeom: 'Trigonal Bipyramidal',
        angle: '90°, 120°',
        hybridization: 'sp³d',
        notation: 'AX₅',
        examples: ['PCl₅', 'PF₅', 'AsF₅'],
        description: 'Five bonding pairs with axial (90°) and equatorial (120°) positions.',
        diagram: '     X\n     |\n X—A—X\n   / | \\\n  X  X'
    },
    '4-1': {
        electronGeom: 'Trigonal Bipyramidal',
        molecularGeom: 'See-Saw',
        angle: '~102°, ~173°',
        hybridization: 'sp³d',
        notation: 'AX₄E',
        examples: ['SF₄', 'XeO₂F₂', 'IF₄⁺'],
        description: 'Lone pair in equatorial position creates see-saw shape.',
        diagram: '     X\n     |\n :—A—X\n     |\n     X'
    },
    '3-2': {
        electronGeom: 'Trigonal Bipyramidal',
        molecularGeom: 'T-Shaped',
        angle: '~87.5°',
        hybridization: 'sp³d',
        notation: 'AX₃E₂',
        examples: ['ClF₃', 'BrF₃', 'ICl₃'],
        description: 'Two lone pairs in equatorial positions form T-shape.',
        diagram: '     X\n     |\n : A :\n     |\n     X'
    },
    '2-3': {
        electronGeom: 'Trigonal Bipyramidal',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp³d',
        notation: 'AX₂E₃',
        examples: ['XeF₂', 'I₃⁻', 'ICl₂⁻'],
        description: 'Three lone pairs in equatorial plane leave linear molecule.',
        diagram: ': : : A X—X'
    },
    '1-4': {
        electronGeom: 'Trigonal Bipyramidal',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp³d',
        notation: 'AXE₄',
        examples: ['Theoretical only'],
        description: 'Four lone pairs with single bond (extremely unstable).',
        diagram: ': : : : A—X'
    },
    '6-0': {
        electronGeom: 'Octahedral',
        molecularGeom: 'Octahedral',
        angle: '90°',
        hybridization: 'sp³d²',
        notation: 'AX₆',
        examples: ['SF₆', 'PF₆⁻', 'SiF₆²⁻'],
        description: 'Six bonding pairs form regular octahedron.',
        diagram: '     X\n     |\n X—A—X\n   / | \\\n  X  |  X\n     X'
    },
    '5-1': {
        electronGeom: 'Octahedral',
        molecularGeom: 'Square Pyramidal',
        angle: '~84°',
        hybridization: 'sp³d²',
        notation: 'AX₅E',
        examples: ['BrF₅', 'IF₅', 'XeOF₄'],
        description: 'Lone pair at one position creates square pyramid.',
        diagram: '     X\n     |\n X—A—X\n   / | \\\n  X  :  X'
    },
    '4-2': {
        electronGeom: 'Octahedral',
        molecularGeom: 'Square Planar',
        angle: '90°',
        hybridization: 'sp³d²',
        notation: 'AX₄E₂',
        examples: ['XeF₄', 'ICl₄⁻', 'BrF₄⁻'],
        description: 'Two opposite lone pairs leave square planar shape.',
        diagram: '     :\n     |\n X—A—X\n   / | \\\n  X  :  X'
    },
    '3-3': {
        electronGeom: 'Octahedral',
        molecularGeom: 'T-Shaped',
        angle: '~90°',
        hybridization: 'sp³d²',
        notation: 'AX₃E₃',
        examples: ['XeF₃⁻ (theoretical)', 'Very rare'],
        description: 'Three lone pairs create T-shaped geometry (extremely rare).',
        diagram: '     X\n     |\n : A :\n     |\n     X\n     :\n     X'
    },
    '2-4': {
        electronGeom: 'Octahedral',
        molecularGeom: 'Linear',
        angle: '180°',
        hybridization: 'sp³d²',
        notation: 'AX₂E₄',
        examples: ['Theoretical only'],
        description: 'Four lone pairs leave linear geometry (extremely unstable).',
        diagram: ': : X—A—X : :'
    },
    '7-0': {
        electronGeom: 'Pentagonal Bipyramidal',
        molecularGeom: 'Pentagonal Bipyramidal',
        angle: '72°, 90°',
        hybridization: 'sp³d³',
        notation: 'AX₇',
        examples: ['IF₇', 'ReF₇', 'OsF₇'],
        description: 'Seven bonding pairs form pentagonal bipyramid (rare, heavy elements only).',
        diagram: '       X\n       |\n   X—A—X\n  / /|\\ \\\n X X | X X\n     X'
    },
    '6-1': {
        electronGeom: 'Pentagonal Bipyramidal',
        molecularGeom: 'Pentagonal Pyramidal',
        angle: '~72°, ~90°',
        hybridization: 'sp³d³',
        notation: 'AX₆E',
        examples: ['XeOF₅⁻ (theoretical)', 'Very rare'],
        description: 'Lone pair at axial position creates pentagonal pyramid (very rare).',
        diagram: '       X\n       |\n   X—A—X\n  / /|\\ \\\n X : | X X\n     X'
    },
    '5-2': {
        electronGeom: 'Pentagonal Bipyramidal',
        molecularGeom: 'Pentagonal Planar',
        angle: '72°',
        hybridization: 'sp³d³',
        notation: 'AX₅E₂',
        examples: ['XeF₅⁻ (theoretical)'],
        description: 'Two axial lone pairs leave pentagonal plane (very rare).',
        diagram: '       :\n       |\n   X—A—X\n  / /|\\ \\\n X : | X X\n     :\n     X'
    },
    '4-3': {
        electronGeom: 'Pentagonal Bipyramidal',
        molecularGeom: 'Square Planar',
        angle: '~90°',
        hybridization: 'sp³d³',
        notation: 'AX₄E₃',
        examples: ['Theoretical'],
        description: 'Three lone pairs create square planar geometry (extremely rare).',
        diagram: '   : X :\n     |\n   X—A—X\n     |\n     X'
    }
};

function calculateByPairs() {
    const bp = parseInt(document.getElementById('bondingPairs').value);
    const lp = parseInt(document.getElementById('lonePairs').value);
    const key = `${bp}-${lp}`;

    if (!geometryData[key]) {
        document.getElementById('pairsResult').innerHTML = `
            <div class="alert alert-warning">
                <strong>Invalid combination:</strong> ${bp} bonding pairs and ${lp} lone pairs.
                Please try a different combination.
            </div>
        `;
        return;
    }

    const data = geometryData[key];
    const totalPairs = bp + lp;

    let resultHTML = `
        <div class="card border-success">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-check-circle"></i> Molecular Geometry Results</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-primary">VSEPR Notation</h6>
                        <p class="h4">${data.notation}</p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-primary">Total Electron Pairs</h6>
                        <p class="h4">${totalPairs}</p>
                    </div>
                </div>
                <hr>

                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-info">Electron Geometry</h6>
                        <p class="lead">${data.electronGeom}</p>
                        <small class="text-muted">Based on all electron pairs (${totalPairs})</small>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-success">Molecular Geometry</h6>
                        <p class="lead"><strong>${data.molecularGeom}</strong></p>
                        <small class="text-muted">Based on atom positions only</small>
                    </div>
                </div>
                <hr>

                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-primary">Bond Angle</h6>
                        <p class="h4">${data.angle}</p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-primary">Hybridization</h6>
                        <p class="h4">${data.hybridization}</p>
                    </div>
                </div>

                <div class="alert alert-secondary mt-3">
                    <h6><i class="fas fa-shapes"></i> 3D Structure Diagram</h6>
                    <pre class="mb-0" style="font-size: 1.1rem; line-height: 1.4; font-family: monospace; background: #f8f9fa; padding: 15px; border-radius: 5px; border: 2px solid #6c757d;">${data.diagram}

<small style="font-size: 0.8rem; color: #6c757d;">Legend: A = central atom, X = bonded atom, : = lone pair</small></pre>
                </div>

                <div class="alert alert-info">
                    <h6><i class="fas fa-lightbulb"></i> Description</h6>
                    <p class="mb-0">${data.description}</p>
                </div>

                <div class="alert alert-light">
                    <h6><i class="fas fa-flask"></i> Example Molecules</h6>
                    <p class="mb-0"><strong>${data.examples.join(', ')}</strong></p>
                </div>

                <h6 class="mt-3"><i class="fas fa-calculator"></i> Summary</h6>
                <ul>
                    <li>Bonding Pairs: <strong>${bp}</strong></li>
                    <li>Lone Pairs: <strong>${lp}</strong></li>
                    <li>Total Electron Pairs: <strong>${totalPairs}</strong></li>
                    <li>Electron Geometry: <strong>${data.electronGeom}</strong></li>
                    <li>Molecular Shape: <strong>${data.molecularGeom}</strong></li>
                </ul>
            </div>
        </div>
    `;

    document.getElementById('pairsResult').innerHTML = resultHTML;
}

function calculateByFormula() {
    const formula = document.getElementById('chemFormula').value.trim().toUpperCase();

    // First, try to find molecule in database
    const molecule = molecules.find(m => m.formula.toUpperCase() === formula);

    if (molecule) {
        // Use database entry
        displayMoleculeResult(molecule);
        return;
    }

    // If not in database, try dynamic calculation
    try {
        const result = parseMolecularFormula(formula);
        displayDynamicResult(result);
    } catch (error) {
        document.getElementById('formulaResult').innerHTML = `
            <div class="alert alert-warning">
                <strong>Could not parse formula:</strong> ${error.message}<br>
                <small>Please check the formula or use the "By Electron Pairs" tab for manual entry.</small>
            </div>
        `;
    }
}

function parseMolecularFormula(formula) {
    // Remove spaces and handle ions
    let charge = 0;
    let cleanFormula = formula.replace(/\s+/g, '');

    // Handle charges like NH4+, SO4(2-), etc.
    const chargeMatch = cleanFormula.match(/([+-]\d*|\(\d*[+-]\))$/);
    if (chargeMatch) {
        const chargeStr = chargeMatch[0].replace(/[()]/g, '');
        if (chargeStr.includes('+')) {
            charge = chargeStr === '+' ? -1 : -parseInt(chargeStr.replace('+', ''));
        } else if (chargeStr.includes('-')) {
            charge = chargeStr === '-' ? 1 : parseInt(chargeStr.replace('-', ''));
        }
        cleanFormula = cleanFormula.replace(chargeMatch[0], '');
    }

    // Parse elements and counts
    const elementRegex = /([A-Z][a-z]?)(\d*)/g;
    const elements = [];
    let match;

    while ((match = elementRegex.exec(cleanFormula)) !== null) {
        if (match[1]) {
            elements.push({
                symbol: match[1],
                count: match[2] ? parseInt(match[2]) : 1
            });
        }
    }

    if (elements.length === 0) {
        throw new Error('No valid elements found in formula');
    }

    // Identify central atom (usually first element, or least electronegative)
    const centralAtom = elements[0].symbol;

    // Calculate bonding pairs (sum of all surrounding atoms)
    let bondingPairs = 0;
    for (let i = 1; i < elements.length; i++) {
        bondingPairs += elements[i].count;
    }

    // Get valence electrons
    const centralValence = getValenceElectrons(centralAtom);

    // Calculate total valence electrons
    let totalValence = centralValence * elements[0].count;
    for (let i = 1; i < elements.length; i++) {
        totalValence += getValenceElectrons(elements[i].symbol) * elements[i].count;
    }
    totalValence += charge; // Add/subtract for ions

    // Calculate lone pairs on central atom
    // Total electron pairs = totalValence / 2
    // Bonding pairs are used in bonds
    // Remaining pairs are lone pairs
    const totalPairs = Math.floor(totalValence / 2);
    const lonePairs = totalPairs - bondingPairs;

    // Get geometry
    const key = `${bondingPairs}-${lonePairs}`;
    const data = geometryData[key];

    if (!data) {
        throw new Error(`No geometry data for ${bondingPairs} bonding pairs and ${lonePairs} lone pairs`);
    }

    return {
        formula: formula,
        centralAtom: centralAtom,
        bondingPairs: bondingPairs,
        lonePairs: lonePairs,
        totalValence: totalValence,
        charge: charge,
        data: data,
        elements: elements
    };
}

function getValenceElectrons(element) {
    const valenceMap = {
        // Group 1
        'H': 1, 'LI': 1, 'NA': 1, 'K': 1, 'RB': 1, 'CS': 1,
        // Group 2
        'BE': 2, 'MG': 2, 'CA': 2, 'SR': 2, 'BA': 2,
        // Group 13
        'B': 3, 'AL': 3, 'GA': 3, 'IN': 3,
        // Group 14
        'C': 4, 'SI': 4, 'GE': 4, 'SN': 4, 'PB': 4,
        // Group 15
        'N': 5, 'P': 5, 'AS': 5, 'SB': 5, 'BI': 5,
        // Group 16
        'O': 6, 'S': 6, 'SE': 6, 'TE': 6,
        // Group 17
        'F': 7, 'CL': 7, 'BR': 7, 'I': 7, 'AT': 7,
        // Group 18
        'HE': 8, 'NE': 8, 'AR': 8, 'KR': 8, 'XE': 8, 'RN': 8
    };

    const valence = valenceMap[element.toUpperCase()];
    if (valence === undefined) {
        throw new Error(`Unknown element: ${element}`);
    }
    return valence;
}

function displayDynamicResult(result) {
    const totalPairs = result.bondingPairs + result.lonePairs;
    const chargeStr = result.charge > 0 ? `${result.charge}+` : result.charge < 0 ? `${Math.abs(result.charge)}-` : '';

    let resultHTML = `
        <div class="card border-info">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0"><i class="fas fa-atom"></i> Dynamic Analysis: ${result.formula}${chargeStr}</h5>
            </div>
            <div class="card-body">
                <div class="alert alert-success">
                    <strong><i class="fas fa-magic"></i> Automatically calculated from formula!</strong>
                    Not found in database - computed using VSEPR theory.
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-primary">VSEPR Notation</h6>
                        <p class="h4">${result.data.notation}</p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-primary">Molecular Geometry</h6>
                        <p class="h4">${result.data.molecularGeom}</p>
                    </div>
                </div>
                <hr>

                <div class="row">
                    <div class="col-md-4">
                        <h6 class="text-info">Central Atom</h6>
                        <p class="lead">${result.centralAtom}</p>
                    </div>
                    <div class="col-md-4">
                        <h6 class="text-info">Bond Angle</h6>
                        <p class="lead">${result.data.angle}</p>
                    </div>
                    <div class="col-md-4">
                        <h6 class="text-info">Hybridization</h6>
                        <p class="lead">${result.data.hybridization}</p>
                    </div>
                </div>

                <div class="alert alert-secondary mt-3">
                    <h6><i class="fas fa-shapes"></i> 3D Structure Diagram</h6>
                    <pre class="mb-0" style="font-size: 1.1rem; line-height: 1.4; font-family: monospace; background: #f8f9fa; padding: 15px; border-radius: 5px; border: 2px solid #6c757d;">${result.data.diagram}

<small style="font-size: 0.8rem; color: #6c757d;">Legend: A = central atom, X = bonded atom, : = lone pair</small></pre>
                </div>

                <div class="alert alert-info">
                    <h6><i class="fas fa-lightbulb"></i> Description</h6>
                    <p class="mb-0">${result.data.description}</p>
                </div>

                <h6 class="mt-3"><i class="fas fa-calculator"></i> Calculation Details</h6>
                <ul>
                    <li>Formula: <strong>${result.formula}${chargeStr}</strong></li>
                    <li>Central Atom: <strong>${result.centralAtom}</strong></li>
                    <li>Bonding Pairs: <strong>${result.bondingPairs}</strong></li>
                    <li>Lone Pairs: <strong>${result.lonePairs}</strong></li>
                    <li>Total Electron Pairs: <strong>${totalPairs}</strong></li>
                    <li>Total Valence Electrons: <strong>${result.totalValence}</strong></li>
                    <li>Electron Geometry: <strong>${result.data.electronGeom}</strong></li>
                    <li>Molecular Geometry: <strong>${result.data.molecularGeom}</strong></li>
                </ul>

                <div class="alert alert-light">
                    <h6><i class="fas fa-flask"></i> Similar Example Molecules</h6>
                    <p class="mb-0"><strong>${result.data.examples.join(', ')}</strong></p>
                </div>
            </div>
        </div>
    `;

    document.getElementById('formulaResult').innerHTML = resultHTML;
}

function displayMoleculeResult(molecule) {

    const key = `${molecule.bp}-${molecule.lp}`;
    const data = geometryData[key];
    const totalPairs = molecule.bp + molecule.lp;

    let resultHTML = `
        <div class="card border-success">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-check-circle"></i> ${molecule.name} (${molecule.formula})</h5>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <h6 class="text-primary">VSEPR Notation</h6>
                        <p class="h4">${data.notation}</p>
                    </div>
                    <div class="col-md-6">
                        <h6 class="text-primary">Molecular Geometry</h6>
                        <p class="h4">${molecule.geometry}</p>
                    </div>
                </div>
                <hr>

                <div class="row">
                    <div class="col-md-4">
                        <h6 class="text-info">Bond Angle</h6>
                        <p class="lead">${molecule.angle}</p>
                    </div>
                    <div class="col-md-4">
                        <h6 class="text-info">Hybridization</h6>
                        <p class="lead">${molecule.hybridization}</p>
                    </div>
                    <div class="col-md-4">
                        <h6 class="text-info">Electron Pairs</h6>
                        <p class="lead">${totalPairs}</p>
                    </div>
                </div>

                <div class="alert alert-secondary mt-3">
                    <h6><i class="fas fa-shapes"></i> 3D Structure Diagram</h6>
                    <pre class="mb-0" style="font-size: 1.1rem; line-height: 1.4; font-family: monospace; background: #f8f9fa; padding: 15px; border-radius: 5px; border: 2px solid #6c757d;">${data.diagram}

<small style="font-size: 0.8rem; color: #6c757d;">Legend: A = central atom, X = bonded atom, : = lone pair</small></pre>
                </div>

                <div class="alert alert-info">
                    <h6><i class="fas fa-lightbulb"></i> Description</h6>
                    <p class="mb-0">${data.description}</p>
                </div>

                <h6 class="mt-3"><i class="fas fa-atom"></i> Structure Details</h6>
                <ul>
                    <li>Bonding Pairs: <strong>${molecule.bp}</strong></li>
                    <li>Lone Pairs: <strong>${molecule.lp}</strong></li>
                    <li>Electron Geometry: <strong>${data.electronGeom}</strong></li>
                    <li>Molecular Geometry: <strong>${molecule.geometry}</strong></li>
                </ul>
            </div>
        </div>
    `;

    document.getElementById('formulaResult').innerHTML = resultHTML;
}

function loadPairsExample(bp, lp) {
    document.getElementById('bondingPairs').value = bp;
    document.getElementById('lonePairs').value = lp;
    $('#pairs-tab').tab('show');
    calculateByPairs();
}

function loadFormulaExample(formula) {
    document.getElementById('chemFormula').value = formula;
    $('#formula-tab').tab('show');
    calculateByFormula();
}

function loadMolecule(formula) {
    document.getElementById('chemFormula').value = formula;
    $('#formula-tab').tab('show');
    calculateByFormula();
}

function searchMolecules() {
    const searchTerm = document.getElementById('searchMolecule').value.toLowerCase();
    const filteredMolecules = molecules.filter(m =>
        m.formula.toLowerCase().includes(searchTerm) ||
        m.name.toLowerCase().includes(searchTerm) ||
        m.geometry.toLowerCase().includes(searchTerm)
    );

    displayMoleculeTable(filteredMolecules);
}

function displayMoleculeTable(moleculeList) {
    const tbody = document.getElementById('moleculeTableBody');
    tbody.innerHTML = '';

    moleculeList.forEach(molecule => {
        const row = `
            <tr>
                <td><strong>${molecule.formula}</strong></td>
                <td>${molecule.name}</td>
                <td>${molecule.bp}</td>
                <td>${molecule.lp}</td>
                <td><span class="badge badge-info">${molecule.geometry}</span></td>
                <td>${molecule.angle}</td>
                <td>
                    <button class="btn btn-sm btn-primary" onclick="loadMolecule('${molecule.formula}')">
                        <i class="fas fa-eye"></i> View
                    </button>
                </td>
            </tr>
        `;
        tbody.innerHTML += row;
    });
}

// Initialize molecule table on page load
document.addEventListener('DOMContentLoaded', function() {
    displayMoleculeTable(molecules);
});
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
