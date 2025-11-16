<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lewis Structure Generator & VSEPR Theory Calculator | 8gwifi.org</title>
    <meta name="description" content="Free Lewis Structure Generator with VSEPR theory, molecular geometry, bond angles, and polarity predictions. Draw Lewis dot structures, calculate formal charges, and visualize 3D molecular shapes.">
    <meta name="keywords" content="lewis structure, lewis dot structure, vsepr theory, molecular geometry, electron geometry, bond angles, formal charge calculator, octet rule, valence electrons, molecular shape, polarity">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/lewis-structure-generator.jsp">
    <meta property="og:title" content="Lewis Structure Generator & VSEPR Theory Calculator">
    <meta property="og:description" content="Generate Lewis structures, predict molecular geometry using VSEPR theory, and calculate formal charges online.">
    <meta property="og:image" content="https://8gwifi.org/images/site/lewis-structure-og.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/lewis-structure-generator.jsp">
    <meta property="twitter:title" content="Lewis Structure Generator & VSEPR Theory Calculator">
    <meta property="twitter:description" content="Generate Lewis structures, predict molecular geometry using VSEPR theory, and calculate formal charges online.">
    <meta property="twitter:image" content="https://8gwifi.org/images/site/lewis-structure-og.png">

    <link rel="canonical" href="https://8gwifi.org/lewis-structure-generator.jsp">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- TikZJax for TikZ rendering -->
    <script src="https://tikzjax.com/v1/tikzjax.js"></script>

    <!-- JSON-LD Schema Markup -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Lewis Structure Generator & VSEPR Theory Calculator",
      "description": "Generate Lewis dot structures with VSEPR theory predictions, molecular geometry, bond angles, and polarity analysis",
      "url": "https://8gwifi.org/lewis-structure-generator.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Lewis structure generation",
        "VSEPR geometry prediction",
        "Formal charge calculation",
        "Bond angle determination",
        "Molecular polarity analysis",
        "3D structure visualization",
        "Electron domain geometry",
        "Octet rule validation"
      ]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [{
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "https://8gwifi.org/"
      },{
        "@type": "ListItem",
        "position": 2,
        "name": "Chemistry Tools",
        "item": "https://8gwifi.org/chemical-equation-balancer.jsp"
      },{
        "@type": "ListItem",
        "position": 3,
        "name": "Lewis Structure Generator",
        "item": "https://8gwifi.org/lewis-structure-generator.jsp"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What is a Lewis structure?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "A Lewis structure (or Lewis dot diagram) is a representation of a molecule showing all valence electrons as dots or lines (bonds). It helps visualize bonding patterns, lone pairs, and formal charges in molecules."
        }
      },{
        "@type": "Question",
        "name": "What is VSEPR theory?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "VSEPR (Valence Shell Electron Pair Repulsion) theory predicts molecular geometry based on electron pair repulsion. Electron domains (bonds and lone pairs) arrange themselves to minimize repulsion, determining the 3D shape of molecules."
        }
      },{
        "@type": "Question",
        "name": "How do you calculate formal charge?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Formal charge = (Valence electrons) - (Non-bonding electrons) - (Bonding electrons/2). The most stable Lewis structure has formal charges closest to zero, with negative charges on more electronegative atoms."
        }
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to Draw a Lewis Structure",
      "step": [{
        "@type": "HowToStep",
        "position": 1,
        "name": "Count valence electrons",
        "text": "Add up all valence electrons from each atom. For ions, add electrons for negative charge or subtract for positive charge."
      },{
        "@type": "HowToStep",
        "position": 2,
        "name": "Arrange atoms",
        "text": "Place the least electronegative atom in the center (usually the unique atom). Hydrogen is always terminal."
      },{
        "@type": "HowToStep",
        "position": 3,
        "name": "Draw single bonds",
        "text": "Connect atoms with single bonds. Each bond uses 2 electrons."
      },{
        "@type": "HowToStep",
        "position": 4,
        "name": "Complete octets",
        "text": "Distribute remaining electrons as lone pairs to satisfy the octet rule (8 electrons for most atoms, 2 for hydrogen)."
      },{
        "@type": "HowToStep",
        "position": 5,
        "name": "Form multiple bonds",
        "text": "If central atom doesn't have an octet, form double or triple bonds by converting lone pairs from outer atoms."
      },{
        "@type": "HowToStep",
        "position": 6,
        "name": "Check formal charges",
        "text": "Calculate formal charges. The best structure has formal charges closest to zero."
      }]
    }
    </script>

    <style>
        .main-content { min-height: 500px; }
        .sticky-side { position: sticky; top: 20px; }
        .min-h-result {
            min-height: 220px;
            max-height: 600px;
            overflow-y: auto;
        }
        .sticky-side {
            max-height: calc(100vh - 100px);
        }
        .sticky-side .card-body {
            overflow-y: auto;
            max-height: calc(100vh - 150px);
        }
        .tabs-container { margin-top: 1.5rem; }
        .nav-tabs .nav-link {
            color: #495057;
            border: 1px solid transparent;
            border-top-left-radius: 0.5rem;
            border-top-right-radius: 0.5rem;
            font-weight: 500;
        }
        .nav-tabs .nav-link:hover { border-color: #e9ecef #e9ecef #dee2e6; }
        .nav-tabs .nav-link.active {
            color: #007bff;
            background-color: #fff;
            border-color: #dee2e6 #dee2e6 #fff;
        }
        .tab-content {
            padding: 1.5rem;
            border: 1px solid #dee2e6;
            border-top: none;
            background: #fff;
        }
        .form-group label { font-weight: 500; color: #495057; }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 0.6rem 1.5rem;
            font-weight: 500;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #5568d3 0%, #63408a 100%);
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .btn-outline-secondary {
            border: 2px solid #6c757d;
            font-weight: 500;
        }
        .result-section {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-top: 1rem;
        }
        .result-label {
            font-weight: 600;
            color: #495057;
            margin-top: 0.75rem;
            margin-bottom: 0.5rem;
        }
        .result-value {
            padding: 0.75rem;
            background: white;
            border-radius: 0.25rem;
            border-left: 4px solid #667eea;
            font-size: 1.05rem;
        }
        #moleculeCanvas {
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            background: white;
            cursor: grab;
            display: block;
            margin: 1rem auto;
        }
        #moleculeCanvas:active {
            cursor: grabbing;
        }
        .geometry-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: #667eea;
            color: white;
            border-radius: 2rem;
            font-weight: 600;
            margin: 0.25rem;
        }
        .polarity-polar {
            background: #e74c3c;
        }
        .polarity-nonpolar {
            background: #27ae60;
        }
        .formal-charge-table {
            width: 100%;
            margin-top: 1rem;
        }
        .formal-charge-table td {
            padding: 0.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        .example-molecule {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            margin: 0.25rem;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .example-molecule:hover {
            background: #e9ecef;
            border-color: #667eea;
            transform: translateY(-2px);
        }
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }
        .atom-input-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 0.5rem;
            margin-top: 0.5rem;
        }
        .atom-input-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .atom-input-item label {
            margin: 0;
            font-size: 0.9rem;
        }
        .atom-input-item input {
            width: 60px;
        }
        .vsepr-table {
            width: 100%;
            font-size: 0.9rem;
            margin-top: 1rem;
        }
        .vsepr-table th {
            background: #f8f9fa;
            padding: 0.5rem;
            border: 1px solid #dee2e6;
        }
        .vsepr-table td {
            padding: 0.5rem;
            border: 1px solid #dee2e6;
        }
        .learn-section {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 0.5rem;
            margin-top: 1rem;
        }
        .learn-section h5 {
            color: #667eea;
            margin-bottom: 1rem;
        }
        .bonding-info {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }
        .bonding-info-item {
            flex: 1;
            min-width: 150px;
            padding: 0.75rem;
            background: white;
            border-radius: 0.25rem;
            border-left: 4px solid #667eea;
        }
        .bonding-info-item strong {
            display: block;
            color: #495057;
            margin-bottom: 0.25rem;
        }
        #tikzCanvas {
            width: 100%;
            min-height: 300px;
            height: 400px;
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            margin: 1rem 0;
        }
        #tikzCanvas iframe {
            width: 100%;
            height: 100%;
            border: none;
        }
        .geometry-visualization {
            margin-top: 1rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 0.5rem;
        }
        .latex-output {
            background: white;
            padding: 1rem;
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            font-family: 'Courier New', monospace;
            white-space: pre-wrap;
            margin-top: 0.5rem;
            max-height: 200px;
            overflow-y: auto;
        }
    </style>
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>

    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Main Content -->
            <div class="col-lg-7 col-md-7 main-content">
                <h1 class="mb-3">Lewis Structure Generator & VSEPR Theory Calculator</h1>
                <p class="lead">Generate Lewis dot structures, predict molecular geometry using VSEPR theory, calculate bond angles, and analyze molecular polarity.</p>

                <!-- Tabs -->
                <div class="tabs-container">
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="generator-tab" data-toggle="tab" href="#generator" role="tab">
                                <i class="fas fa-project-diagram"></i> Lewis Structure
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="vsepr-tab" data-toggle="tab" href="#vsepr" role="tab">
                                <i class="fas fa-cube"></i> VSEPR Predictor
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="formal-tab" data-toggle="tab" href="#formal" role="tab">
                                <i class="fas fa-calculator"></i> Formal Charge
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="learn-tab" data-toggle="tab" href="#learn" role="tab">
                                <i class="fas fa-book"></i> Learn
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Tab 1: Lewis Structure Generator -->
                        <div class="tab-pane fade show active" id="generator" role="tabpanel">
                            <h4>Generate Lewis Structure</h4>

                            <div class="form-group">
                                <label>Molecular Formula</label>
                                <input type="text" class="form-control" id="molecularFormula" placeholder="e.g., H2O, CO2, NH3, or ML2 (generic)">
                                <small class="help-text">Enter formula like H2O, CO2, NH3, or use generic notation (ML₂, AX₃, MX₄, etc.)</small>
                            </div>

                            <div class="form-group">
                                <label>Quick Examples</label>
                                <div>
                                    <span class="example-molecule" onclick="setExample('H2O')">H₂O (Water)</span>
                                    <span class="example-molecule" onclick="setExample('CO2')">CO₂ (Carbon Dioxide)</span>
                                    <span class="example-molecule" onclick="setExample('NH3')">NH₃ (Ammonia)</span>
                                    <span class="example-molecule" onclick="setExample('CH4')">CH₄ (Methane)</span>
                                    <span class="example-molecule" onclick="setExample('O2')">O₂ (Oxygen)</span>
                                    <span class="example-molecule" onclick="setExample('N2')">N₂ (Nitrogen)</span>
                                    <span class="example-molecule" onclick="setExample('SO2')">SO₂ (Sulfur Dioxide)</span>
                                    <span class="example-molecule" onclick="setExample('HCN')">HCN (Hydrogen Cyanide)</span>
                                    <span class="example-molecule" onclick="setExample('C2H4')">C₂H₄ (Ethylene)</span>
                                    <span class="example-molecule" onclick="setExample('PCl3')">PCl₃ (Phosphorus Trichloride)</span>
                                    <span class="example-molecule" onclick="setExample('ML2')" style="border-color: #ff9800;">ML₂ (Generic)</span>
                                    <span class="example-molecule" onclick="setExample('AX3')" style="border-color: #ff9800;">AX₃ (Generic)</span>
                                    <span class="example-molecule" onclick="setExample('MX4')" style="border-color: #ff9800;">MX₄ (Generic)</span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Charge (optional)</label>
                                <input type="number" class="form-control" id="molecularCharge" value="0" placeholder="0">
                                <small class="help-text">For ions: +1 for cation, -1 for anion</small>
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" class="form-check-input" id="autoCalcLewis">
                                <label class="form-check-label" for="autoCalcLewis">Auto-calculate on input</label>
                            </div>

                            <button class="btn btn-primary" onclick="generateLewis()">
                                <i class="fas fa-atom"></i> Generate Lewis Structure
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearLewis()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 2: VSEPR Predictor -->
                        <div class="tab-pane fade" id="vsepr" role="tabpanel">
                            <h4>VSEPR Geometry Predictor</h4>

                            <div class="form-group">
                                <label>Central Atom</label>
                                <input type="text" class="form-control" id="centralAtom" placeholder="e.g., C, N, O, S">
                            </div>

                            <div class="form-group">
                                <label>Bonding Electron Pairs (Bonds)</label>
                                <input type="number" class="form-control" id="bondingPairs" min="1" max="6" value="4" placeholder="Number of bonds">
                                <small class="help-text">Count single, double, and triple bonds as 1 bonding region each</small>
                            </div>

                            <div class="form-group">
                                <label>Lone Electron Pairs</label>
                                <input type="number" class="form-control" id="lonePairs" min="0" max="4" value="0" placeholder="Number of lone pairs">
                            </div>

                            <div class="form-group">
                                <label>Quick VSEPR Examples</label>
                                <div>
                                    <span class="example-molecule" onclick="setVSEPR(2,0)">2B-0LP (Linear)</span>
                                    <span class="example-molecule" onclick="setVSEPR(3,0)">3B-0LP (Trigonal Planar)</span>
                                    <span class="example-molecule" onclick="setVSEPR(2,1)">2B-1LP (Bent)</span>
                                    <span class="example-molecule" onclick="setVSEPR(4,0)">4B-0LP (Tetrahedral)</span>
                                    <span class="example-molecule" onclick="setVSEPR(3,1)">3B-1LP (Trigonal Pyramidal)</span>
                                    <span class="example-molecule" onclick="setVSEPR(2,2)">2B-2LP (Bent)</span>
                                    <span class="example-molecule" onclick="setVSEPR(5,0)">5B-0LP (Trigonal Bipyramidal)</span>
                                    <span class="example-molecule" onclick="setVSEPR(6,0)">6B-0LP (Octahedral)</span>
                                </div>
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" class="form-check-input" id="autoCalcVSEPR">
                                <label class="form-check-label" for="autoCalcVSEPR">Auto-calculate on input</label>
                            </div>

                            <button class="btn btn-primary" onclick="predictVSEPR()">
                                <i class="fas fa-cube"></i> Predict Geometry
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearVSEPR()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 3: Formal Charge Calculator -->
                        <div class="tab-pane fade" id="formal" role="tabpanel">
                            <h4>Formal Charge Calculator</h4>

                            <div class="alert alert-info">
                                <strong>Formula:</strong> Formal Charge = (Valence e⁻) - (Non-bonding e⁻) - (Bonding e⁻ / 2)
                            </div>

                            <div class="form-group">
                                <label>Atom</label>
                                <input type="text" class="form-control" id="formalAtom" placeholder="e.g., C, N, O">
                            </div>

                            <div class="form-group">
                                <label>Valence Electrons</label>
                                <input type="number" class="form-control" id="valenceElectrons" min="1" max="8" placeholder="Valence electrons for this atom">
                                <small class="help-text">C=4, N=5, O=6, H=1, etc.</small>
                            </div>

                            <div class="form-group">
                                <label>Non-bonding Electrons (Lone Pairs × 2)</label>
                                <input type="number" class="form-control" id="nonBondingElectrons" min="0" placeholder="Number of non-bonding electrons">
                            </div>

                            <div class="form-group">
                                <label>Bonding Electrons</label>
                                <input type="number" class="form-control" id="bondingElectrons" min="0" placeholder="Number of bonding electrons">
                                <small class="help-text">Single bond = 2, Double = 4, Triple = 6</small>
                            </div>

                            <div class="form-check mb-3">
                                <input type="checkbox" class="form-check-input" id="autoCalcFormal">
                                <label class="form-check-label" for="autoCalcFormal">Auto-calculate on input</label>
                            </div>

                            <button class="btn btn-primary" onclick="calculateFormalCharge()">
                                <i class="fas fa-calculator"></i> Calculate Formal Charge
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearFormal()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 4: Learn -->
                        <div class="tab-pane fade" id="learn" role="tabpanel">
                            <div class="learn-section">
                                <h5><i class="fas fa-book-open"></i> Understanding Lewis Structures</h5>

                                <h6>What are Lewis Structures?</h6>
                                <p>Lewis structures (or Lewis dot diagrams) are visual representations of molecules showing:</p>
                                <ul>
                                    <li><strong>Bonding electrons</strong> as lines between atoms (each line = 2 electrons)</li>
                                    <li><strong>Lone pairs</strong> as dots around atoms</li>
                                    <li><strong>Formal charges</strong> when electron distribution differs from neutral atoms</li>
                                </ul>

                                <h6>Steps to Draw Lewis Structures</h6>
                                <ol>
                                    <li><strong>Count valence electrons:</strong> Add up all valence electrons (adjust for charge)</li>
                                    <li><strong>Arrange atoms:</strong> Least electronegative in center (H always terminal)</li>
                                    <li><strong>Draw single bonds:</strong> Each bond uses 2 electrons</li>
                                    <li><strong>Complete octets:</strong> Distribute remaining electrons (8 for most, 2 for H)</li>
                                    <li><strong>Form multiple bonds:</strong> If needed to satisfy octet rule</li>
                                    <li><strong>Check formal charges:</strong> Best structure has charges closest to zero</li>
                                </ol>

                                <h6>VSEPR Theory</h6>
                                <p><strong>Valence Shell Electron Pair Repulsion (VSEPR)</strong> theory predicts 3D molecular geometry based on:</p>
                                <ul>
                                    <li>Electron pairs repel each other and arrange to minimize repulsion</li>
                                    <li>Both bonding pairs and lone pairs count as "electron domains"</li>
                                    <li>Lone pairs occupy more space than bonding pairs</li>
                                </ul>

                                <h6>Common Geometries</h6>
                                <table class="vsepr-table">
                                    <thead>
                                        <tr>
                                            <th>Steric #</th>
                                            <th>Bonds</th>
                                            <th>Lone Pairs</th>
                                            <th>Molecular Geometry</th>
                                            <th>Bond Angle</th>
                                            <th>Example</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr><td>2</td><td>2</td><td>0</td><td>Linear</td><td>180°</td><td>CO₂</td></tr>
                                        <tr><td>3</td><td>3</td><td>0</td><td>Trigonal Planar</td><td>120°</td><td>BF₃</td></tr>
                                        <tr><td>3</td><td>2</td><td>1</td><td>Bent</td><td>&lt;120°</td><td>SO₂</td></tr>
                                        <tr><td>4</td><td>4</td><td>0</td><td>Tetrahedral</td><td>109.5°</td><td>CH₄</td></tr>
                                        <tr><td>4</td><td>3</td><td>1</td><td>Trigonal Pyramidal</td><td>&lt;109.5°</td><td>NH₃</td></tr>
                                        <tr><td>4</td><td>2</td><td>2</td><td>Bent</td><td>&lt;109.5°</td><td>H₂O</td></tr>
                                        <tr><td>5</td><td>5</td><td>0</td><td>Trigonal Bipyramidal</td><td>90°, 120°</td><td>PCl₅</td></tr>
                                        <tr><td>6</td><td>6</td><td>0</td><td>Octahedral</td><td>90°</td><td>SF₆</td></tr>
                                    </tbody>
                                </table>

                                <h6>Formal Charge Rules</h6>
                                <ul>
                                    <li>The best Lewis structure has formal charges closest to zero</li>
                                    <li>Negative formal charges should be on more electronegative atoms</li>
                                    <li>Adjacent atoms should not have same-sign formal charges</li>
                                    <li>Minimize the number of atoms with non-zero formal charges</li>
                                </ul>

                                <h6>Exceptions to Octet Rule</h6>
                                <ul>
                                    <li><strong>Incomplete octets:</strong> H (2e⁻), Be (4e⁻), B (6e⁻)</li>
                                    <li><strong>Expanded octets:</strong> Period 3+ elements can use d-orbitals (P, S, Cl, etc.)</li>
                                    <li><strong>Odd-electron molecules:</strong> Free radicals like NO, NO₂</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar with Sticky Result -->
            <div class="col-lg-5 col-md-5">
                <div class="sticky-side">
                    <div class="card shadow-sm">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-chart-bar"></i> Results</h5>
                        </div>
                        <div class="card-body min-h-result">
                            <div id="resultDisplay">
                                <p class="text-muted text-center">
                                    <i class="fas fa-info-circle fa-2x mb-2"></i><br>
                                    Enter molecular formula or VSEPR parameters and click Calculate to see results
                                </p>
                            </div>

                            <!-- Action buttons (initially hidden) -->
                            <div id="actionButtons" style="display:none;" class="mt-3">
                                <button class="btn btn-sm btn-outline-primary btn-block" onclick="copyResult()">
                                    <i class="fas fa-copy"></i> Copy
                                </button>
                                <button class="btn btn-sm btn-outline-primary btn-block" onclick="exportPNG()">
                                    <i class="fas fa-download"></i> Export PNG
                                </button>
                                <button class="btn btn-sm btn-outline-primary btn-block" onclick="shareURL()">
                                    <i class="fas fa-share-alt"></i> Share URL
                                </button>
                            </div>
                        </div>
                    </div>

<%--                    <%@ include file="sidebar.jsp"%>--%>
                </div>
            </div>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

    <script>
        // Valence electron data - comprehensive periodic table coverage
        const valenceElectrons = {
            // Period 1
            'H': 1, 'He': 2,

            // Period 2
            'Li': 1, 'Be': 2, 'B': 3, 'C': 4, 'N': 5, 'O': 6, 'F': 7, 'Ne': 8,

            // Period 3
            'Na': 1, 'Mg': 2, 'Al': 3, 'Si': 4, 'P': 5, 'S': 6, 'Cl': 7, 'Ar': 8,

            // Period 4
            'K': 1, 'Ca': 2, 'Sc': 3, 'Ti': 4, 'V': 5, 'Cr': 6, 'Mn': 7, 'Fe': 8,
            'Co': 9, 'Ni': 10, 'Cu': 11, 'Zn': 12, 'Ga': 3, 'Ge': 4, 'As': 5, 'Se': 6, 'Br': 7, 'Kr': 8,

            // Period 5 (selected)
            'Rb': 1, 'Sr': 2, 'Ag': 11, 'Cd': 12, 'In': 3, 'Sn': 4, 'Sb': 5, 'Te': 6, 'I': 7, 'Xe': 8,

            // Period 6 (selected)
            'Cs': 1, 'Ba': 2, 'Au': 11, 'Hg': 12, 'Tl': 3, 'Pb': 4, 'Bi': 5, 'Po': 6, 'At': 7, 'Rn': 8,

            // Generic atom symbols (commonly used in textbooks)
            'M': 4,  // Generic metal (assume 4 valence for versatility)
            'A': 4,  // Generic central atom
            'X': 7,  // Generic halogen/ligand
            'L': 7,  // Generic ligand
            'E': 6,  // Generic electronegative atom
            'R': 1,  // Generic alkyl group
            'G': 8   // Generic group
        };

        // VSEPR geometry data - comprehensive coverage
        const vseprData = {
            // Steric number 2
            '2-0': { electron: 'Linear', molecular: 'Linear', angle: '180°', example: 'CO₂, BeF₂, HCN' },

            // Steric number 3
            '3-0': { electron: 'Trigonal Planar', molecular: 'Trigonal Planar', angle: '120°', example: 'BF₃, SO₃, NO₃⁻' },
            '3-1': { electron: 'Trigonal Planar', molecular: 'Bent', angle: '<120° (~119°)', example: 'SO₂, O₃, NO₂⁻' },

            // Steric number 4
            '4-0': { electron: 'Tetrahedral', molecular: 'Tetrahedral', angle: '109.5°', example: 'CH₄, CCl₄, SO₄²⁻' },
            '4-1': { electron: 'Tetrahedral', molecular: 'Trigonal Pyramidal', angle: '<109.5° (~107°)', example: 'NH₃, PCl₃, H₃O⁺' },
            '4-2': { electron: 'Tetrahedral', molecular: 'Bent', angle: '<109.5° (~104.5°)', example: 'H₂O, H₂S, OF₂' },
            '4-3': { electron: 'Tetrahedral', molecular: 'Linear', angle: '180°', example: 'FHF⁻ (rare)' },

            // Steric number 5
            '5-0': { electron: 'Trigonal Bipyramidal', molecular: 'Trigonal Bipyramidal', angle: '90°, 120°', example: 'PCl₅, PF₅' },
            '5-1': { electron: 'Trigonal Bipyramidal', molecular: 'Seesaw', angle: '<90°, <120°', example: 'SF₄, TeCl₄' },
            '5-2': { electron: 'Trigonal Bipyramidal', molecular: 'T-shaped', angle: '<90°', example: 'ClF₃, BrF₃' },
            '5-3': { electron: 'Trigonal Bipyramidal', molecular: 'Linear', angle: '180°', example: 'XeF₂, I₃⁻' },

            // Steric number 6
            '6-0': { electron: 'Octahedral', molecular: 'Octahedral', angle: '90°', example: 'SF₆, PF₆⁻' },
            '6-1': { electron: 'Octahedral', molecular: 'Square Pyramidal', angle: '<90°', example: 'BrF₅, IF₅' },
            '6-2': { electron: 'Octahedral', molecular: 'Square Planar', angle: '90°', example: 'XeF₄, ICl₄⁻' },
            '6-3': { electron: 'Octahedral', molecular: 'T-shaped', angle: '90°', example: 'ClF₃ (alternative)' },

            // Steric number 7 (rare but exists)
            '7-0': { electron: 'Pentagonal Bipyramidal', molecular: 'Pentagonal Bipyramidal', angle: '72°, 90°', example: 'IF₇' },
            '7-1': { electron: 'Pentagonal Bipyramidal', molecular: 'Pentagonal Pyramidal', angle: '<90°', example: 'XeOF₅⁻' },

            // Edge cases
            '1-0': { electron: 'Linear', molecular: 'Linear', angle: 'N/A', example: 'H, Free radical' },
            '3-2': { electron: 'Trigonal Planar', molecular: 'Linear', angle: '180°', example: 'XeF₂ (alternative desc)' }
        };

        let currentResult = '';

        // Parse molecular formula
        function parseMolecularFormula(formula) {
            const atoms = {};
            const regex = /([A-Z][a-z]?)(\d*)/g;
            let match;

            while ((match = regex.exec(formula)) !== null) {
                const element = match[1];
                const count = match[2] ? parseInt(match[2]) : 1;
                atoms[element] = (atoms[element] || 0) + count;
            }

            return atoms;
        }

        // Generate Lewis Structure
        function generateLewis() {
            const formula = document.getElementById('molecularFormula').value.trim();
            const charge = parseInt(document.getElementById('molecularCharge').value) || 0;

            if (!formula) {
                alert('Please enter a molecular formula');
                return;
            }

            try {
                const atoms = parseMolecularFormula(formula);
                let totalValence = 0;
                let atomList = [];

                // Calculate total valence electrons
                const genericSymbols = ['M', 'A', 'X', 'L', 'E', 'R', 'G'];
                let hasGenericSymbol = false;

                for (const [element, count] of Object.entries(atoms)) {
                    if (!valenceElectrons[element]) {
                        alert(`Unknown element: ${element}\n\nSupported elements include:\n- All main group elements (H, C, N, O, F, S, Cl, Br, I, etc.)\n- Transition metals (Fe, Cu, Zn, Ag, Au, etc.)\n- Generic symbols (M, A, X, L, E, R, G for textbook notation)\n\nTip: For generic notation, use symbols like ML₂, AX₃E, etc.`);
                        return;
                    }
                    if (genericSymbols.includes(element)) {
                        hasGenericSymbol = true;
                    }
                    totalValence += valenceElectrons[element] * count;
                    atomList.push(`${element}<sub>${count > 1 ? count : ''}</sub>`);
                }

                totalValence -= charge; // Adjust for charge

                // Determine central atom (usually the one with lowest electronegativity or unique)
                const atomKeys = Object.keys(atoms);
                let centralAtom = atomKeys.find(a => a !== 'H' && a !== 'F') || atomKeys[0];

                // Basic bonding analysis
                const totalAtoms = Object.values(atoms).reduce((a, b) => a + b, 0);
                const bonds = totalAtoms - 1; // Minimum single bonds
                const bondingElectrons = bonds * 2;
                const remainingElectrons = totalValence - bondingElectrons;

                // Build result HTML
                let resultHTML = `
                    <div class="result-section">
                        <h6><strong>Molecular Formula:</strong> ${atomList.join('')}</h6>
                        ${hasGenericSymbol ? `
                        <div class="alert alert-warning mt-2 mb-2" style="font-size: 0.9rem; padding: 0.6rem;">
                            <i class="fas fa-info-circle"></i> <strong>Generic Notation Detected:</strong>
                            Using textbook symbols (M=4e⁻, A=4e⁻, X=7e⁻, L=7e⁻, E=6e⁻, R=1e⁻, G=8e⁻).
                            Replace with real elements for specific calculations.
                        </div>
                        ` : ''}

                        <div class="bonding-info">
                            <div class="bonding-info-item">
                                <strong>Total Valence e⁻</strong>
                                <span>${totalValence}</span>
                            </div>
                            <div class="bonding-info-item">
                                <strong>Bonding e⁻</strong>
                                <span>${bondingElectrons}</span>
                            </div>
                            <div class="bonding-info-item">
                                <strong>Remaining e⁻</strong>
                                <span>${remainingElectrons}</span>
                            </div>
                        </div>

                        <div class="result-label">Central Atom:</div>
                        <div class="result-value">${centralAtom}</div>

                        <div class="result-label">Bonding Pattern:</div>
                        <div class="result-value">
                            ${bonds} single bond${bonds !== 1 ? 's' : ''} connecting ${totalAtoms} atom${totalAtoms !== 1 ? 's' : ''}
                        </div>

                        <div class="result-label">Lewis Structure Notation:</div>
                        <div class="result-value" style="font-family: monospace; white-space: pre;">
${generateLewisNotation(atoms, centralAtom, totalValence)}
                        </div>

                        <div class="alert alert-info mt-3">
                            <strong>Next Steps:</strong>
                            <ol class="mb-0" style="padding-left: 1.2rem;">
                                <li>Distribute ${remainingElectrons} remaining electrons as lone pairs</li>
                                <li>Check if central atom has octet (8 e⁻)</li>
                                <li>Form double/triple bonds if needed</li>
                                <li>Calculate formal charges for each atom</li>
                            </ol>
                        </div>
                    </div>
                `;

                currentResult = resultHTML;
                document.getElementById('resultDisplay').innerHTML = resultHTML;
                document.getElementById('actionButtons').style.display = 'block';

            } catch (error) {
                alert('Error generating Lewis structure: ' + error.message);
            }
        }

        // Generate simple Lewis notation
        function generateLewisNotation(atoms, central, totalValence) {
            let notation = '';
            const peripheralAtoms = [];

            for (const [element, count] of Object.entries(atoms)) {
                if (element === central && count === 1) continue;
                for (let i = 0; i < count; i++) {
                    peripheralAtoms.push(element);
                }
            }

            if (peripheralAtoms.length <= 2) {
                notation = peripheralAtoms[0] + ' — ' + central;
                if (peripheralAtoms[1]) notation += ' — ' + peripheralAtoms[1];
            } else {
                notation = '       ' + (peripheralAtoms[0] || '') + '\n';
                notation += '       |\n';
                notation += (peripheralAtoms[2] || '') + ' — ' + central + ' — ' + (peripheralAtoms[1] || '') + '\n';
                notation += '       |\n';
                notation += '       ' + (peripheralAtoms[3] || '');
            }

            return notation;
        }

        // Predict VSEPR geometry
        function predictVSEPR() {
            const bonds = parseInt(document.getElementById('bondingPairs').value);
            const lone = parseInt(document.getElementById('lonePairs').value);
            const atom = document.getElementById('centralAtom').value.trim() || 'X';

            if (isNaN(bonds) || bonds < 1) {
                alert('Please enter number of bonding pairs');
                return;
            }

            if (isNaN(lone) || lone < 0) {
                alert('Please enter number of lone pairs (0 or more)');
                return;
            }

            const stericNumber = bonds + lone;
            const key = `${stericNumber}-${lone}`;
            const geometry = vseprData[key];

            if (!geometry) {
                alert('No VSEPR data for this combination');
                return;
            }

            // Determine polarity (simplified)
            let polarity = 'Unknown';
            let polarityClass = '';
            if (lone === 0 && bonds > 1) {
                polarity = 'Nonpolar (symmetric)';
                polarityClass = 'polarity-nonpolar';
            } else if (lone > 0 || bonds === 1) {
                polarity = 'Likely Polar (asymmetric)';
                polarityClass = 'polarity-polar';
            }

            let resultHTML = `
                <div class="result-section">
                    <h6><strong>Central Atom:</strong> ${atom}</h6>

                    <div class="bonding-info">
                        <div class="bonding-info-item">
                            <strong>Bonding Pairs</strong>
                            <span>${bonds}</span>
                        </div>
                        <div class="bonding-info-item">
                            <strong>Lone Pairs</strong>
                            <span>${lone}</span>
                        </div>
                        <div class="bonding-info-item">
                            <strong>Steric Number</strong>
                            <span>${stericNumber}</span>
                        </div>
                    </div>

                    <div class="result-label">Electron Geometry:</div>
                    <div class="result-value">
                        <span class="geometry-badge">${geometry.electron}</span>
                    </div>

                    <div class="result-label">Molecular Geometry:</div>
                    <div class="result-value">
                        <span class="geometry-badge">${geometry.molecular}</span>
                    </div>

                    <div class="result-label">Bond Angle:</div>
                    <div class="result-value">${geometry.angle}</div>

                    <div class="result-label">Polarity:</div>
                    <div class="result-value">
                        <span class="geometry-badge ${polarityClass}">${polarity}</span>
                    </div>

                    <div class="result-label">Examples:</div>
                    <div class="result-value">${geometry.example}</div>

                    <div class="alert alert-info mt-3">
                        <strong>Explanation:</strong> With ${bonds} bonding region${bonds !== 1 ? 's' : ''} and ${lone} lone pair${lone !== 1 ? 's' : ''},
                        the steric number is ${stericNumber}, giving ${geometry.electron.toLowerCase()} electron geometry.
                        ${lone > 0 ? 'Lone pairs occupy more space, compressing bond angles.' : 'All positions are bonds, maintaining ideal angles.'}
                    </div>
                </div>
            `;

            // Generate TikZ visualization
            const tikzCode = generateTikZ(bonds, lone, atom, geometry.molecular);

            resultHTML += `
                <div class="geometry-visualization">
                    <h6><strong>3D Geometry Visualization:</strong></h6>
                    <div id="tikzCanvas">
                        <div style="padding: 3rem; text-align: center; color: #6c757d;">
                            <i class="fas fa-spinner fa-spin fa-2x mb-2"></i>
                            <p>Rendering molecular geometry...</p>
                        </div>
                    </div>

                    <button class="btn btn-sm btn-outline-secondary mt-2" onclick="toggleLatexCode()">
                        <i class="fas fa-code"></i> Show/Hide LaTeX Code
                    </button>
                    <div id="latexCode" class="latex-output" style="display:none;">${escapeHtml(tikzCode)}</div>
                </div>
            `;

            currentResult = resultHTML;
            document.getElementById('resultDisplay').innerHTML = resultHTML;
            document.getElementById('actionButtons').style.display = 'block';

            // Render TikZ using MathJax
            renderTikZ(tikzCode);
        }

        // Calculate formal charge
        function calculateFormalCharge() {
            const atom = document.getElementById('formalAtom').value.trim();
            const valence = parseInt(document.getElementById('valenceElectrons').value);
            const nonBonding = parseInt(document.getElementById('nonBondingElectrons').value);
            const bonding = parseInt(document.getElementById('bondingElectrons').value);

            if (!atom || isNaN(valence) || isNaN(nonBonding) || isNaN(bonding)) {
                alert('Please fill in all fields');
                return;
            }

            const formalCharge = valence - nonBonding - (bonding / 2);

            let chargeStr = '';
            if (formalCharge > 0) chargeStr = '+' + formalCharge;
            else if (formalCharge < 0) chargeStr = formalCharge.toString();
            else chargeStr = '0 (neutral)';

            let interpretation = '';
            if (formalCharge === 0) {
                interpretation = 'This atom has a neutral formal charge, which is ideal.';
            } else if (formalCharge > 0) {
                interpretation = 'Positive formal charge indicates electron deficiency. Consider if resonance structures exist.';
            } else {
                interpretation = 'Negative formal charge indicates excess electrons. This is favorable on electronegative atoms.';
            }

            let resultHTML = `
                <div class="result-section">
                    <h6><strong>Atom:</strong> ${atom}</h6>

                    <div class="result-label">Formula:</div>
                    <div class="result-value" style="font-family: monospace;">
                        FC = V - N - (B/2)<br>
                        FC = ${valence} - ${nonBonding} - (${bonding}/2)<br>
                        FC = ${valence} - ${nonBonding} - ${bonding/2}
                    </div>

                    <div class="result-label">Formal Charge:</div>
                    <div class="result-value" style="font-size: 1.5rem; font-weight: bold; color: ${formalCharge === 0 ? '#27ae60' : (formalCharge > 0 ? '#e74c3c' : '#3498db')};">
                        ${chargeStr}
                    </div>

                    <table class="formal-charge-table">
                        <tr>
                            <td><strong>Valence electrons (V):</strong></td>
                            <td>${valence}</td>
                        </tr>
                        <tr>
                            <td><strong>Non-bonding electrons (N):</strong></td>
                            <td>${nonBonding}</td>
                        </tr>
                        <tr>
                            <td><strong>Bonding electrons (B):</strong></td>
                            <td>${bonding}</td>
                        </tr>
                        <tr>
                            <td><strong>Bonding electrons / 2:</strong></td>
                            <td>${bonding/2}</td>
                        </tr>
                    </table>

                    <div class="alert alert-info mt-3">
                        <strong>Interpretation:</strong> ${interpretation}
                    </div>
                </div>
            `;

            currentResult = resultHTML;
            document.getElementById('resultDisplay').innerHTML = resultHTML;
            document.getElementById('actionButtons').style.display = 'block';
        }

        // Set example molecule
        function setExample(formula) {
            document.getElementById('molecularFormula').value = formula;
            document.getElementById('molecularCharge').value = 0;
            if (document.getElementById('autoCalcLewis').checked) {
                generateLewis();
            }
        }

        // Set VSEPR example
        function setVSEPR(bonds, lone) {
            document.getElementById('bondingPairs').value = bonds;
            document.getElementById('lonePairs').value = lone;
            if (document.getElementById('autoCalcVSEPR').checked) {
                predictVSEPR();
            }
        }

        // Clear functions
        function clearLewis() {
            document.getElementById('molecularFormula').value = '';
            document.getElementById('molecularCharge').value = 0;
            document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter molecular formula and click Calculate</p>';
            document.getElementById('actionButtons').style.display = 'none';
        }

        function clearVSEPR() {
            document.getElementById('centralAtom').value = '';
            document.getElementById('bondingPairs').value = 4;
            document.getElementById('lonePairs').value = 0;
            document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter VSEPR parameters and click Calculate</p>';
            document.getElementById('actionButtons').style.display = 'none';
        }

        function clearFormal() {
            document.getElementById('formalAtom').value = '';
            document.getElementById('valenceElectrons').value = '';
            document.getElementById('nonBondingElectrons').value = '';
            document.getElementById('bondingElectrons').value = '';
            document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter atom data and click Calculate</p>';
            document.getElementById('actionButtons').style.display = 'none';
        }

        // Copy result to clipboard
        function copyResult() {
            const resultDiv = document.getElementById('resultDisplay');
            const text = resultDiv.innerText;
            navigator.clipboard.writeText(text).then(() => {
                alert('Result copied to clipboard!');
            }).catch(err => {
                console.error('Could not copy text: ', err);
            });
        }

        // Export as PNG
        function exportPNG() {
            const resultDiv = document.getElementById('resultDisplay');

            // Create canvas
            const canvas = document.createElement('canvas');
            canvas.width = 800;
            canvas.height = 1000;
            const ctx = canvas.getContext('2d');

            // White background
            ctx.fillStyle = 'white';
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // Add text
            ctx.fillStyle = 'black';
            ctx.font = '16px Arial';

            const text = resultDiv.innerText;
            const lines = text.split('\n');
            let y = 40;

            lines.forEach(line => {
                ctx.fillText(line, 20, y);
                y += 24;
            });

            // Download
            canvas.toBlob(blob => {
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = 'lewis-structure-result.png';
                a.click();
                URL.revokeObjectURL(url);
            });
        }

        // Share URL
        function shareURL() {
            const url = window.location.href.split('?')[0];
            const formula = document.getElementById('molecularFormula').value;
            let shareUrl = url;

            if (formula) {
                shareUrl += '?formula=' + encodeURIComponent(formula);
            }

            navigator.clipboard.writeText(shareUrl).then(() => {
                alert('Share URL copied to clipboard!');
            }).catch(err => {
                prompt('Copy this URL:', shareUrl);
            });
        }

        // Generate TikZ code for molecular geometry
        function generateTikZ(bonds, lone, atom, geometryName) {
            const steric = bonds + lone;
            let tikzCode = '';

            switch(steric + '-' + lone) {
                case '2-0': // Linear
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Bonds
  \\draw[line width=2pt] (-1.5,0) -- (-0.3,0);
  \\draw[line width=2pt] (0.3,0) -- (1.5,0);

  % Bonding atoms
  \\fill[red!30] (-1.5,0) circle (0.25);
  \\node at (-1.5,0) {\\small X};
  \\fill[red!30] (1.5,0) circle (0.25);
  \\node at (1.5,0) {\\small X};

  % Bond angle
  \\draw[<->, dashed] (-1.3,0.5) arc (0:180:1.3cm and 0.5cm);
  \\node at (0,0.8) {$180^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '3-0': // Trigonal Planar
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Bonds (120° apart)
  \\draw[line width=2pt] (0,0) -- (1.3,0);
  \\draw[line width=2pt] (0,0) -- (-0.65,1.126);
  \\draw[line width=2pt] (0,0) -- (-0.65,-1.126);

  % Bonding atoms
  \\fill[red!30] (1.3,0) circle (0.25);
  \\node at (1.5,0) {\\small X};
  \\fill[red!30] (-0.65,1.126) circle (0.25);
  \\node at (-0.8,1.3) {\\small X};
  \\fill[red!30] (-0.65,-1.126) circle (0.25);
  \\node at (-0.8,-1.3) {\\small X};

  % Bond angle
  \\draw[<->, dashed] (0.8,0.2) arc (0:120:0.8cm);
  \\node at (0.3,0.6) {$120^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '3-1': // Bent (from trigonal planar)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pair
  \\fill[green!30] (0,1.3) circle (0.15);
  \\fill[green!30] (0,1.55) circle (0.15);
  \\node[green!70!black] at (0,1.9) {\\tiny LP};

  % Bonds
  \\draw[line width=2pt] (0,0) -- (1.2,-0.8);
  \\draw[line width=2pt] (0,0) -- (-1.2,-0.8);

  % Bonding atoms
  \\fill[red!30] (1.2,-0.8) circle (0.25);
  \\node at (1.4,-1) {\\small X};
  \\fill[red!30] (-1.2,-0.8) circle (0.25);
  \\node at (-1.4,-1) {\\small X};

  % Bond angle
  \\draw[<->, dashed] (0.8,-0.4) arc (-30:-150:0.8cm);
  \\node at (0,-0.9) {$<120^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '4-0': // Tetrahedral
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Bonds (tetrahedral - 3D projection)
  \\draw[line width=2pt] (0,0) -- (1.2,0.8);
  \\draw[line width=2pt] (0,0) -- (-1.2,0.8);
  \\draw[line width=2pt] (0,0) -- (0.6,-1.2);
  \\draw[line width=2pt,dashed] (0,0) -- (-0.3,-0.5);

  % Bonding atoms
  \\fill[red!30] (1.2,0.8) circle (0.25);
  \\node at (1.4,1) {\\small X};
  \\fill[red!30] (-1.2,0.8) circle (0.25);
  \\node at (-1.4,1) {\\small X};
  \\fill[red!30] (0.6,-1.2) circle (0.25);
  \\node at (0.8,-1.4) {\\small X};
  \\fill[red!30,opacity=0.5] (-0.3,-0.5) circle (0.25);
  \\node[opacity=0.7] at (-0.5,-0.7) {\\small X};

  % Bond angle
  \\node at (0,-1.8) {$109.5^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '4-1': // Trigonal Pyramidal
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pair (on top)
  \\fill[green!30] (-0.1,1.2) circle (0.15);
  \\fill[green!30] (0.1,1.4) circle (0.15);
  \\node[green!70!black] at (0,1.7) {\\tiny LP};

  % Bonds (pyramid base)
  \\draw[line width=2pt] (0,0) -- (1.2,-0.6);
  \\draw[line width=2pt] (0,0) -- (-1.2,-0.6);
  \\draw[line width=2pt] (0,0) -- (0,-1.3);

  % Bonding atoms
  \\fill[red!30] (1.2,-0.6) circle (0.25);
  \\node at (1.4,-0.7) {\\small X};
  \\fill[red!30] (-1.2,-0.6) circle (0.25);
  \\node at (-1.4,-0.7) {\\small X};
  \\fill[red!30] (0,-1.3) circle (0.25);
  \\node at (0,-1.6) {\\small X};

  % Bond angle
  \\node at (0,-2) {$\\approx 107^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '4-2': // Bent (from tetrahedral)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pairs
  \\fill[green!30] (-0.7,1.1) circle (0.15);
  \\fill[green!30] (-0.5,1.35) circle (0.15);
  \\node[green!70!black] at (-0.6,1.6) {\\tiny LP};

  \\fill[green!30] (0.7,1.1) circle (0.15);
  \\fill[green!30] (0.5,1.35) circle (0.15);
  \\node[green!70!black] at (0.6,1.6) {\\tiny LP};

  % Bonds
  \\draw[line width=2pt] (0,0) -- (1.2,-0.9);
  \\draw[line width=2pt] (0,0) -- (-1.2,-0.9);

  % Bonding atoms
  \\fill[red!30] (1.2,-0.9) circle (0.25);
  \\node at (1.4,-1.1) {\\small X};
  \\fill[red!30] (-1.2,-0.9) circle (0.25);
  \\node at (-1.4,-1.1) {\\small X};

  % Bond angle
  \\draw[<->, dashed] (0.9,-0.5) arc (-30:-150:0.9cm);
  \\node at (0,-1.3) {$\\approx 104.5^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '5-0': // Trigonal Bipyramidal
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Axial bonds (vertical)
  \\draw[line width=2pt] (0,0) -- (0,1.5);
  \\draw[line width=2pt] (0,0) -- (0,-1.5);

  % Equatorial bonds (120° in plane)
  \\draw[line width=2pt] (0,0) -- (1.3,0);
  \\draw[line width=2pt] (0,0) -- (-0.65,1.126);
  \\draw[line width=2pt] (0,0) -- (-0.65,-1.126);

  % Bonding atoms
  \\fill[red!30] (0,1.5) circle (0.25);
  \\node at (0,1.8) {\\small X};
  \\fill[red!30] (0,-1.5) circle (0.25);
  \\node at (0,-1.8) {\\small X};
  \\fill[red!30] (1.3,0) circle (0.25);
  \\node at (1.6,0) {\\small X};
  \\fill[red!30] (-0.65,1.126) circle (0.25);
  \\node at (-0.9,1.4) {\\small X};
  \\fill[red!30] (-0.65,-1.126) circle (0.25);
  \\node at (-0.9,-1.4) {\\small X};

  % Bond angles
  \\node at (1.8,0.8) {$90^\\circ, 120^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '6-0': // Octahedral
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Bonds (6 directions)
  \\draw[line width=2pt] (0,0) -- (0,1.5);
  \\draw[line width=2pt] (0,0) -- (0,-1.5);
  \\draw[line width=2pt] (0,0) -- (1.5,0);
  \\draw[line width=2pt] (0,0) -- (-1.5,0);
  \\draw[line width=2pt,dashed] (0,0) -- (0.7,0.7);
  \\draw[line width=2pt,dashed] (0,0) -- (-0.7,-0.7);

  % Bonding atoms
  \\fill[red!30] (0,1.5) circle (0.25);
  \\node at (0,1.8) {\\small X};
  \\fill[red!30] (0,-1.5) circle (0.25);
  \\node at (0,-1.8) {\\small X};
  \\fill[red!30] (1.5,0) circle (0.25);
  \\node at (1.8,0) {\\small X};
  \\fill[red!30] (-1.5,0) circle (0.25);
  \\node at (-1.8,0) {\\small X};
  \\fill[red!30,opacity=0.5] (0.7,0.7) circle (0.25);
  \\node[opacity=0.7] at (0.9,0.9) {\\small X};
  \\fill[red!30,opacity=0.5] (-0.7,-0.7) circle (0.25);
  \\node[opacity=0.7] at (-0.9,-0.9) {\\small X};

  % Bond angle
  \\node at (0,-2.2) {$90^\\circ$};
\\end{tikzpicture}`;
                    break;

                case '5-1': // Seesaw (SF4)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pair (equatorial position)
  \\fill[green!30] (-1.4,0) circle (0.15);
  \\fill[green!30] (-1.65,0) circle (0.15);
  \\node[green!70!black] at (-1.9,0) {\\tiny LP};

  % Axial bonds (vertical)
  \\draw[line width=2pt] (0,0) -- (0,1.4);
  \\draw[line width=2pt] (0,0) -- (0,-1.4);

  % Equatorial bonds (2 bonds in plane)
  \\draw[line width=2pt] (0,0) -- (1.3,0);
  \\draw[line width=2pt] (0,0) -- (0.3,0.8);

  % Bonding atoms
  \\fill[red!30] (0,1.4) circle (0.25);
  \\node at (0,1.7) {\\small X};
  \\fill[red!30] (0,-1.4) circle (0.25);
  \\node at (0,-1.7) {\\small X};
  \\fill[red!30] (1.3,0) circle (0.25);
  \\node at (1.6,0) {\\small X};
  \\fill[red!30] (0.3,0.8) circle (0.25);
  \\node at (0.5,1.1) {\\small X};

  \\node at (0,-2.1) {Seesaw};
\\end{tikzpicture}`;
                    break;

                case '5-2': // T-shaped (ClF3)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pairs (2 equatorial positions)
  \\fill[green!30] (-1.3,0.3) circle (0.15);
  \\fill[green!30] (-1.5,0.1) circle (0.15);
  \\node[green!70!black] at (-1.8,0.2) {\\tiny LP};

  \\fill[green!30] (-1.3,-0.3) circle (0.15);
  \\fill[green!30] (-1.5,-0.1) circle (0.15);
  \\node[green!70!black] at (-1.8,-0.2) {\\tiny LP};

  % T-shaped bonds (axial and one equatorial)
  \\draw[line width=2pt] (0,0) -- (0,1.4);
  \\draw[line width=2pt] (0,0) -- (0,-1.4);
  \\draw[line width=2pt] (0,0) -- (1.4,0);

  % Bonding atoms
  \\fill[red!30] (0,1.4) circle (0.25);
  \\node at (0,1.7) {\\small X};
  \\fill[red!30] (0,-1.4) circle (0.25);
  \\node at (0,-1.7) {\\small X};
  \\fill[red!30] (1.4,0) circle (0.25);
  \\node at (1.7,0) {\\small X};

  \\node at (0,-2.1) {T-shaped};
\\end{tikzpicture}`;
                    break;

                case '5-3': // Linear (from trigonal bipyramidal - XeF2, I3-)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pairs (3 equatorial positions)
  \\fill[green!30] (0,0.8) circle (0.15);
  \\fill[green!30] (0,1.05) circle (0.15);
  \\node[green!70!black] at (0,1.35) {\\tiny LP};

  \\fill[green!30] (-0.7,-0.4) circle (0.15);
  \\fill[green!30] (-0.9,-0.55) circle (0.15);
  \\node[green!70!black] at (-1.1,-0.8) {\\tiny LP};

  \\fill[green!30] (0.7,-0.4) circle (0.15);
  \\fill[green!30] (0.9,-0.55) circle (0.15);
  \\node[green!70!black] at (1.1,-0.8) {\\tiny LP};

  % Linear bonds (axial positions)
  \\draw[line width=2pt] (-1.5,0) -- (-0.3,0);
  \\draw[line width=2pt] (0.3,0) -- (1.5,0);

  % Bonding atoms
  \\fill[red!30] (-1.5,0) circle (0.25);
  \\node at (-1.8,0) {\\small X};
  \\fill[red!30] (1.5,0) circle (0.25);
  \\node at (1.8,0) {\\small X};

  \\node at (0,-1.6) {Linear ($180^\\circ$)};
\\end{tikzpicture}`;
                    break;

                case '6-1': // Square Pyramidal (BrF5)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pair (top position)
  \\fill[green!30] (0,1.3) circle (0.15);
  \\fill[green!30] (0,1.55) circle (0.15);
  \\node[green!70!black] at (0,1.85) {\\tiny LP};

  % Square pyramid bonds
  \\draw[line width=2pt] (0,0) -- (0,-1.4);  % Bottom (apex)
  \\draw[line width=2pt] (0,0) -- (1.1,0);   % Right
  \\draw[line width=2pt] (0,0) -- (-1.1,0);  % Left
  \\draw[line width=2pt] (0,0) -- (0.5,-0.5); % Front-right
  \\draw[line width=2pt] (0,0) -- (-0.5,-0.5); % Front-left

  % Bonding atoms
  \\fill[red!30] (0,-1.4) circle (0.25);
  \\node at (0,-1.7) {\\small X};
  \\fill[red!30] (1.1,0) circle (0.25);
  \\node at (1.4,0) {\\small X};
  \\fill[red!30] (-1.1,0) circle (0.25);
  \\node at (-1.4,0) {\\small X};
  \\fill[red!30] (0.5,-0.5) circle (0.25);
  \\node at (0.7,-0.8) {\\small X};
  \\fill[red!30] (-0.5,-0.5) circle (0.25);
  \\node at (-0.7,-0.8) {\\small X};

  \\node at (0,-2.2) {Square Pyramidal};
\\end{tikzpicture}`;
                    break;

                case '6-2': // Square Planar (XeF4)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pairs (axial positions - top and bottom)
  \\fill[green!30] (0,1.2) circle (0.15);
  \\fill[green!30] (0,1.45) circle (0.15);
  \\node[green!70!black] at (0,1.75) {\\tiny LP};

  \\fill[green!30] (0,-1.2) circle (0.15);
  \\fill[green!30] (0,-1.45) circle (0.15);
  \\node[green!70!black] at (0,-1.75) {\\tiny LP};

  % Square planar bonds (equatorial)
  \\draw[line width=2pt] (0,0) -- (1.3,0);
  \\draw[line width=2pt] (0,0) -- (-1.3,0);
  \\draw[line width=2pt] (0,0) -- (0.65,0.65);
  \\draw[line width=2pt] (0,0) -- (-0.65,0.65);

  % Bonding atoms
  \\fill[red!30] (1.3,0) circle (0.25);
  \\node at (1.6,0) {\\small X};
  \\fill[red!30] (-1.3,0) circle (0.25);
  \\node at (-1.6,0) {\\small X};
  \\fill[red!30] (0.65,0.65) circle (0.25);
  \\node at (0.9,0.9) {\\small X};
  \\fill[red!30] (-0.65,0.65) circle (0.25);
  \\node at (-0.9,0.9) {\\small X};

  \\node at (0,-2.2) {Square Planar ($90^\\circ$)};
\\end{tikzpicture}`;
                    break;

                case '6-3': // T-shaped (from octahedral - very rare)
                case '3-2': // Linear (from trigonal planar)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pairs
  \\fill[green!30] (-0.7,0.8) circle (0.15);
  \\fill[green!30] (-0.5,1.05) circle (0.15);
  \\node[green!70!black] at (-0.6,1.35) {\\tiny LP};

  \\fill[green!30] (0.7,0.8) circle (0.15);
  \\fill[green!30] (0.5,1.05) circle (0.15);
  \\node[green!70!black] at (0.6,1.35) {\\tiny LP};

  % Linear bonds
  \\draw[line width=2pt] (-1.5,0) -- (-0.3,0);
  \\draw[line width=2pt] (0.3,0) -- (1.5,0);

  % Bonding atoms
  \\fill[red!30] (-1.5,0) circle (0.25);
  \\node at (-1.8,0) {\\small X};
  \\fill[red!30] (1.5,0) circle (0.25);
  \\node at (1.8,0) {\\small X};

  \\node at (0,-1.2) {Linear ($180^\\circ$)};
\\end{tikzpicture}`;
                    break;

                case '7-0': // Pentagonal Bipyramidal (IF7)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Axial bonds
  \\draw[line width=2pt] (0,0) -- (0,1.4);
  \\draw[line width=2pt] (0,0) -- (0,-1.4);

  % Pentagon bonds (5 equatorial at 72° intervals)
  \\draw[line width=2pt] (0,0) -- (1.2,0);
  \\draw[line width=2pt] (0,0) -- (0.37,1.14);
  \\draw[line width=2pt] (0,0) -- (-0.97,0.71);
  \\draw[line width=2pt] (0,0) -- (-0.97,-0.71);
  \\draw[line width=2pt] (0,0) -- (0.37,-1.14);

  % Bonding atoms
  \\fill[red!30] (0,1.4) circle (0.2);
  \\node at (0,1.65) {\\tiny X};
  \\fill[red!30] (0,-1.4) circle (0.2);
  \\node at (0,-1.65) {\\tiny X};
  \\fill[red!30] (1.2,0) circle (0.2);
  \\node at (1.45,0) {\\tiny X};
  \\fill[red!30] (0.37,1.14) circle (0.2);
  \\node at (0.55,1.35) {\\tiny X};
  \\fill[red!30] (-0.97,0.71) circle (0.2);
  \\node at (-1.2,0.9) {\\tiny X};
  \\fill[red!30] (-0.97,-0.71) circle (0.2);
  \\node at (-1.2,-0.9) {\\tiny X};
  \\fill[red!30] (0.37,-1.14) circle (0.2);
  \\node at (0.55,-1.35) {\\tiny X};

  \\node at (0,-2.1) {Pentagonal Bipyramidal};
\\end{tikzpicture}`;
                    break;

                case '7-1': // Pentagonal Pyramidal (XeOF5-)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pair (one axial position)
  \\fill[green!30] (0,1.3) circle (0.15);
  \\fill[green!30] (0,1.55) circle (0.15);
  \\node[green!70!black] at (0,1.85) {\\tiny LP};

  % Apex bond (one axial)
  \\draw[line width=2pt] (0,0) -- (0,-1.4);

  % Pentagon bonds (5 equatorial)
  \\draw[line width=2pt] (0,0) -- (1.1,0);
  \\draw[line width=2pt] (0,0) -- (0.34,1.05);
  \\draw[line width=2pt] (0,0) -- (-0.89,0.65);
  \\draw[line width=2pt] (0,0) -- (-0.89,-0.65);
  \\draw[line width=2pt] (0,0) -- (0.34,-1.05);

  % Bonding atoms
  \\fill[red!30] (0,-1.4) circle (0.2);
  \\node at (0,-1.65) {\\tiny X};
  \\fill[red!30] (1.1,0) circle (0.2);
  \\node at (1.35,0) {\\tiny X};
  \\fill[red!30] (0.34,1.05) circle (0.2);
  \\node at (0.5,1.3) {\\tiny X};
  \\fill[red!30] (-0.89,0.65) circle (0.2);
  \\node at (-1.1,0.85) {\\tiny X};
  \\fill[red!30] (-0.89,-0.65) circle (0.2);
  \\node at (-1.1,-0.85) {\\tiny X};
  \\fill[red!30] (0.34,-1.05) circle (0.2);
  \\node at (0.5,-1.3) {\\tiny X};

  \\node at (0,-2.2) {Pentagonal Pyramidal};
\\end{tikzpicture}`;
                    break;

                case '4-3': // Linear (from tetrahedral - FHF-)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom
  \\fill[blue!30] (0,0) circle (0.3);
  \\node at (0,0) {\\textbf{${atom}}};

  % Lone pairs (3 positions forming trigonal pyramid)
  \\fill[green!30] (-0.3,1.1) circle (0.15);
  \\fill[green!30] (-0.1,1.35) circle (0.15);
  \\node[green!70!black] at (0,1.65) {\\tiny LP};

  \\fill[green!30] (0.8,-0.6) circle (0.15);
  \\fill[green!30] (1.0,-0.75) circle (0.15);
  \\node[green!70!black] at (1.2,-0.95) {\\tiny LP};

  \\fill[green!30] (-0.8,-0.6) circle (0.15);
  \\fill[green!30] (-1.0,-0.75) circle (0.15);
  \\node[green!70!black] at (-1.2,-0.95) {\\tiny LP};

  % Linear bonds
  \\draw[line width=2pt] (-1.5,0.2) -- (-0.3,0.1);
  \\draw[line width=2pt] (0.3,0.1) -- (1.5,0.2);

  % Bonding atoms
  \\fill[red!30] (-1.5,0.2) circle (0.25);
  \\node at (-1.8,0.3) {\\small X};
  \\fill[red!30] (1.5,0.2) circle (0.25);
  \\node at (1.8,0.3) {\\small X};

  \\node at (0,-1.7) {Linear (rare)};
\\end{tikzpicture}`;
                    break;

                case '1-0': // Single atom (free radical)
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  % Central atom (larger for single atom)
  \\fill[blue!30] (0,0) circle (0.5);
  \\node at (0,0) {\\textbf{\\Large ${atom}}};

  % Unpaired electron notation
  \\fill[red!50] (0.7,0) circle (0.12);
  \\node[red!70!black] at (1.1,0) {\\small $e^-$};

  \\node at (0,-1.2) {Free Radical};
  \\node[font=\\small] at (0,-1.6) {(unpaired electron)};
\\end{tikzpicture}`;
                    break;

                default:
                    tikzCode = `\\begin{tikzpicture}[scale=1.5]
  \\node[align=center] at (0,0) {
    \\textbf{${geometryName}} \\\\[0.5em]
    ${bonds} Bonds + ${lone} Lone Pair${lone !== 1 ? 's' : ''}
  };
\\end{tikzpicture}`;
            }

            return tikzCode;
        }

        // Render TikZ using TikZJax in iframe
        function renderTikZ(tikzCode) {
            const canvas = document.getElementById('tikzCanvas');
            if (!canvas) return;

            // Build iframe HTML with TikZJax
            const iframeHtml = '<!DOCTYPE html>' +
'<html>' +
'<head>' +
'  <meta charset="UTF-8">' +
'  <style>' +
'    body {' +
'      margin: 0;' +
'      padding: 20px;' +
'      display: flex;' +
'      justify-content: center;' +
'      align-items: center;' +
'      min-height: 100vh;' +
'      background: white;' +
'    }' +
'    svg {' +
'      display: block;' +
'      margin: auto;' +
'      max-width: 100%;' +
'      height: auto;' +
'    }' +
'  </style>' +
'  <script src="https://tikzjax.com/v1/tikzjax.js"><' + '/script>' +
'</head>' +
'<body>' +
'  <script type="text/tikz">' +
tikzCode +
'  <' + '/script>' +
'</body>' +
'</html>';

            // Clear and create iframe
            canvas.innerHTML = '';
            const iframe = document.createElement('iframe');
            iframe.srcdoc = iframeHtml;
            canvas.appendChild(iframe);

            console.log('TikZ geometry rendering initiated');
        }

        // Toggle LaTeX code visibility
        function toggleLatexCode() {
            const codeDiv = document.getElementById('latexCode');
            if (codeDiv) {
                codeDiv.style.display = codeDiv.style.display === 'none' ? 'block' : 'none';
            }
        }

        // HTML escape utility
        function escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        // Auto-calculate listeners
        document.getElementById('molecularFormula').addEventListener('input', function() {
            if (document.getElementById('autoCalcLewis').checked) {
                generateLewis();
            }
        });

        document.getElementById('molecularCharge').addEventListener('input', function() {
            if (document.getElementById('autoCalcLewis').checked) {
                generateLewis();
            }
        });

        ['bondingPairs', 'lonePairs', 'centralAtom'].forEach(id => {
            document.getElementById(id).addEventListener('input', function() {
                if (document.getElementById('autoCalcVSEPR').checked) {
                    predictVSEPR();
                }
            });
        });

        ['formalAtom', 'valenceElectrons', 'nonBondingElectrons', 'bondingElectrons'].forEach(id => {
            document.getElementById(id).addEventListener('input', function() {
                if (document.getElementById('autoCalcFormal').checked) {
                    calculateFormalCharge();
                }
            });
        });

        // Parse URL parameters on load
        window.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const formula = urlParams.get('formula');

            if (formula) {
                document.getElementById('molecularFormula').value = formula;
                generateLewis();
            }
        });
    </script>
    <%@ include file="thanks.jsp"%>
    <hr>

    <%@ include file="addcomments.jsp"%>
    </div>
    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="body-close.jsp"%>
