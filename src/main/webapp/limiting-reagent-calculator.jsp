<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Limiting Reagent Calculator - Find Limiting Reactant & Theoretical Yield</title>
    <meta name="description" content="Free limiting reagent calculator. Find the limiting reactant, excess reagent, theoretical yield, and percent yield for any chemical reaction. Perfect for chemistry students and stoichiometry problems.">
    <meta name="keywords" content="limiting reagent calculator, limiting reactant calculator, stoichiometry calculator, theoretical yield calculator, excess reagent calculator, chemistry calculator">

    <!-- Open Graph tags -->
    <meta property="og:title" content="Limiting Reagent Calculator - Stoichiometry Tool">
    <meta property="og:description" content="Calculate limiting reactant, excess reagent, and theoretical yield for chemical reactions. Free chemistry calculator with step-by-step solutions.">
    <meta property="og:type" content="website">

    <!-- Schema.org structured data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Limiting Reagent Calculator",
        "description": "Calculate limiting reactant, excess reagent, theoretical yield, and percent yield for chemical reactions",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Limiting reagent identification, Excess reagent calculation, Theoretical yield, Percent yield, Step-by-step solutions"
    }
    </script>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        .example-reaction {
            display: inline-block;
            padding: 6px 12px;
            margin: 3px;
            background: #f3f4f6;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.9rem;
        }
        .example-reaction:hover {
            background: #e5e7eb;
            border-color: #9ca3af;
        }
        .limiting-badge {
            display: inline-block;
            padding: 6px 12px;
            background: #dc2626;
            color: white;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .excess-badge {
            display: inline-block;
            padding: 6px 12px;
            background: #2563eb;
            color: white;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .yield-badge {
            display: inline-block;
            padding: 6px 12px;
            background: #059669;
            color: white;
            border-radius: 4px;
            font-weight: 600;
            font-size: 0.95rem;
        }
        .reagent-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 10px;
            margin: 15px 0;
        }
        .reagent-info-item {
            background: #f9fafb;
            padding: 12px;
            border-radius: 6px;
            border-left: 3px solid #6366f1;
        }
        .reagent-info-item strong {
            display: block;
            color: #4b5563;
            margin-bottom: 4px;
            font-size: 0.85rem;
        }
        .reagent-info-item span {
            font-size: 1rem;
            color: #111827;
            font-weight: 600;
        }
        .reaction-display {
            background: #f3f4f6;
            padding: 12px;
            border-radius: 6px;
            font-size: 1rem;
            text-align: center;
            font-weight: 600;
            color: #1f2937;
            border: 1px solid #e5e7eb;
            margin: 10px 0;
        }
        .formula-box {
            background: #f9fafb;
            padding: 12px;
            border-radius: 6px;
            border-left: 3px solid #6366f1;
            margin: 10px 0;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
        }
        .step-box {
            background: #fef3c7;
            padding: 12px;
            border-radius: 6px;
            border-left: 3px solid #f59e0b;
            margin: 10px 0;
        }
        .step-box strong {
            color: #92400e;
        }
        .min-h-result {
            min-height: 200px;
        }
        .sticky-side {
            position: -webkit-sticky;
            position: sticky;
            top: 80px;
            max-height: calc(100vh - 100px);
        }
        .sticky-side .card-body {
            overflow-y: auto;
            max-height: calc(100vh - 150px);
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-4">

    <h1 class="mb-3">Limiting Reagent Calculator</h1>
    <p class="lead mb-4">Calculate the limiting reactant, excess reagent, theoretical yield, and percent yield for chemical reactions.</p>

    <div class="row">
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="basic-tab" data-toggle="tab" href="#basic" role="tab">
                                <i class="fas fa-calculator"></i> Basic Calculator
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="advanced-tab" data-toggle="tab" href="#advanced" role="tab">
                                <i class="fas fa-chart-line"></i> With Yields
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="learn-tab" data-toggle="tab" href="#learn" role="tab">
                                <i class="fas fa-book"></i> Learn
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Tab 1: Basic Calculator -->
                        <div class="tab-pane fade show active" id="basic" role="tabpanel">
                            <h4 class="mt-3">Limiting Reagent Calculator</h4>

                            <div class="form-group">
                                <label>Balanced Chemical Equation</label>
                                <input type="text" class="form-control" id="basicEquation" placeholder="e.g., 2H2 + O2 → 2H2O">
                                <small class="help-text">Enter a balanced equation with coefficients. Supports: →, ⇌, =, ==</small>
                            </div>

                            <div class="form-group">
                                <label>Common Reactions (Click to load)</label>

                                <!-- Easy Reactions -->
                                <h6 class="mt-3 mb-2" style="font-size: 0.9rem; color: #059669;"><i class="fas fa-star"></i> Easy - Synthesis & Decomposition</h6>
                                <div class="mb-2">
                                    <span class="example-reaction" onclick="setBasicExample('2H2 + O2 → 2H2O')">💧 Water synthesis</span>
                                    <span class="example-reaction" onclick="setBasicExample('2Na + Cl2 → 2NaCl')">🧂 Sodium chloride</span>
                                    <span class="example-reaction" onclick="setBasicExample('2Mg + O2 → 2MgO')">Magnesium oxide</span>
                                    <span class="example-reaction" onclick="setBasicExample('H2 + Cl2 → 2HCl')">Hydrogen chloride</span>
                                    <span class="example-reaction" onclick="setBasicExample('2KClO3 → 2KCl + 3O2')">Potassium chlorate decomp</span>
                                    <span class="example-reaction" onclick="setBasicExample('CaCO3 → CaO + CO2')">Limestone decomp</span>
                                </div>

                                <!-- Medium Reactions -->
                                <h6 class="mt-3 mb-2" style="font-size: 0.9rem; color: #2563eb;"><i class="fas fa-star"></i><i class="fas fa-star"></i> Medium - Combustion & Single Replacement</h6>
                                <div class="mb-2">
                                    <span class="example-reaction" onclick="setBasicExample('CH4 + 2O2 → CO2 + 2H2O')">🔥 Methane combustion</span>
                                    <span class="example-reaction" onclick="setBasicExample('C3H8 + 5O2 → 3CO2 + 4H2O')">Propane combustion</span>
                                    <span class="example-reaction" onclick="setBasicExample('2C8H18 + 25O2 → 16CO2 + 18H2O')">Octane combustion</span>
                                    <span class="example-reaction" onclick="setBasicExample('C2H5OH + 3O2 → 2CO2 + 3H2O')">Ethanol combustion</span>
                                    <span class="example-reaction" onclick="setBasicExample('Zn + 2HCl → ZnCl2 + H2')">Zinc + acid</span>
                                    <span class="example-reaction" onclick="setBasicExample('Fe + CuSO4 → FeSO4 + Cu')">Iron + copper sulfate</span>
                                    <span class="example-reaction" onclick="setBasicExample('Mg + 2AgNO3 → Mg(NO3)2 + 2Ag')">Magnesium + silver nitrate</span>
                                </div>

                                <!-- Hard Reactions -->
                                <h6 class="mt-3 mb-2" style="font-size: 0.9rem; color: #dc2626;"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i> Hard - Double Replacement & Complex</h6>
                                <div class="mb-2">
                                    <span class="example-reaction" onclick="setBasicExample('AgNO3 + NaCl → AgCl + NaNO3')">Precipitation (AgCl)</span>
                                    <span class="example-reaction" onclick="setBasicExample('BaCl2 + Na2SO4 → BaSO4 + 2NaCl')">Barium sulfate ppt</span>
                                    <span class="example-reaction" onclick="setBasicExample('Pb(NO3)2 + 2KI → PbI2 + 2KNO3')">Lead iodide ppt</span>
                                    <span class="example-reaction" onclick="setBasicExample('Ca(OH)2 + 2HCl → CaCl2 + 2H2O')">Neutralization</span>
                                    <span class="example-reaction" onclick="setBasicExample('H2SO4 + 2NaOH → Na2SO4 + 2H2O')">Acid-base titration</span>
                                    <span class="example-reaction" onclick="setBasicExample('3Ca(OH)2 + 2H3PO4 → Ca3(PO4)2 + 6H2O')">Phosphoric acid + calcium</span>
                                </div>

                                <!-- Industrial/Advanced -->
                                <h6 class="mt-3 mb-2" style="font-size: 0.9rem; color: #7c3aed;"><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i><i class="fas fa-star"></i> Very Hard - Industrial & Redox</h6>
                                <div class="mb-2">
                                    <span class="example-reaction" onclick="setBasicExample('N2 + 3H2 → 2NH3')">⚗️ Haber Process</span>
                                    <span class="example-reaction" onclick="setBasicExample('4NH3 + 5O2 → 4NO + 6H2O')">Ostwald Process</span>
                                    <span class="example-reaction" onclick="setBasicExample('2SO2 + O2 → 2SO3')">Contact Process</span>
                                    <span class="example-reaction" onclick="setBasicExample('4FeS2 + 11O2 → 2Fe2O3 + 8SO2')">Pyrite roasting</span>
                                    <span class="example-reaction" onclick="setBasicExample('2Al + 3CuO → Al2O3 + 3Cu')">🔥 Thermite reaction</span>
                                    <span class="example-reaction" onclick="setBasicExample('Fe2O3 + 3CO → 2Fe + 3CO2')">Iron ore reduction</span>
                                    <span class="example-reaction" onclick="setBasicExample('4Fe + 3O2 + 6H2O → 4Fe(OH)3')">Rust formation</span>
                                    <span class="example-reaction" onclick="setBasicExample('C6H12O6 + 6O2 → 6CO2 + 6H2O')">Glucose combustion</span>
                                </div>

                                <!-- Organic Chemistry -->
                                <h6 class="mt-3 mb-2" style="font-size: 0.9rem; color: #ea580c;"><i class="fas fa-flask"></i> Organic Chemistry</h6>
                                <div class="mb-2">
                                    <span class="example-reaction" onclick="setBasicExample('C2H4 + H2O → C2H5OH')">Ethanol synthesis</span>
                                    <span class="example-reaction" onclick="setBasicExample('C2H4 + Br2 → C2H4Br2')">Bromination of ethene</span>
                                    <span class="example-reaction" onclick="setBasicExample('CH3COOH + C2H5OH → CH3COOC2H5 + H2O')">Esterification</span>
                                    <span class="example-reaction" onclick="setBasicExample('C6H6 + 3H2 → C6H12')">Benzene hydrogenation</span>
                                    <span class="example-reaction" onclick="setBasicExample('2C4H10 + 13O2 → 8CO2 + 10H2O')">Butane combustion</span>
                                </div>

                                <!-- Complex Multi-step -->
                                <h6 class="mt-3 mb-2" style="font-size: 0.9rem; color: #be123c;"><i class="fas fa-flask"></i><i class="fas fa-flask"></i> Expert - Multiple Products</h6>
                                <div class="mb-2">
                                    <span class="example-reaction" onclick="setBasicExample('C7H6O2 + C4H6O3 → C9H8O4 + C2H4O2')">Aspirin synthesis</span>
                                    <span class="example-reaction" onclick="setBasicExample('3Cu + 8HNO3 → 3Cu(NO3)2 + 2NO + 4H2O')">Copper + nitric acid</span>
                                    <span class="example-reaction" onclick="setBasicExample('KMnO4 + 5FeSO4 + 8H2SO4 → K2SO4 + 2MnSO4 + 5Fe2(SO4)3 + 8H2O')">Permanganate titration</span>
                                    <span class="example-reaction" onclick="setBasicExample('2KMnO4 + 16HCl → 2KCl + 2MnCl2 + 5Cl2 + 8H2O')">Permanganate + HCl</span>
                                </div>
                            </div>

                            <div class="alert alert-info">
                                <small><strong>💡 How it works:</strong> Enter your equation above and press Tab/Enter. Input fields will be generated automatically with molar masses calculated!</small>
                            </div>

                            <!-- Dynamic input fields will be generated here -->
                            <div id="dynamicReactantFields"></div>

                            <button class="btn btn-primary" onclick="calculateBasic()">
                                <i class="fas fa-calculator"></i> Calculate Limiting Reagent
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearBasic()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 2: Advanced with Yields -->
                        <div class="tab-pane fade" id="advanced" role="tabpanel">
                            <h4 class="mt-3">Calculate with Actual & Percent Yield</h4>

                            <div class="alert alert-info">
                                <strong><i class="fas fa-info-circle"></i> Note:</strong>
                                First calculate theoretical yield, then enter actual yield to find percent yield.
                            </div>

                            <div class="form-group">
                                <label>Theoretical Yield (from previous calculation)</label>
                                <input type="number" step="any" class="form-control" id="advTheoYield" placeholder="Enter theoretical yield">
                            </div>

                            <div class="form-group">
                                <label>Actual Yield (experimental result)</label>
                                <input type="number" step="any" class="form-control" id="advActualYield" placeholder="Enter actual yield obtained">
                            </div>

                            <div class="form-group">
                                <label>Unit</label>
                                <select class="form-control" id="advUnit">
                                    <option value="g">grams (g)</option>
                                    <option value="mol">moles (mol)</option>
                                    <option value="kg">kilograms (kg)</option>
                                    <option value="mg">milligrams (mg)</option>
                                </select>
                            </div>

                            <button class="btn btn-primary" onclick="calculateAdvanced()">
                                <i class="fas fa-percentage"></i> Calculate Percent Yield
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearAdvanced()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 3: Learn -->
                        <div class="tab-pane fade" id="learn" role="tabpanel">
                            <div class="learn-section">
                                <h5><i class="fas fa-book-open"></i> Understanding Limiting Reagents</h5>

                                <h6>What is a Limiting Reagent?</h6>
                                <p>The <strong>limiting reagent</strong> (or limiting reactant) is the reactant that is completely consumed first in a chemical reaction. It determines the maximum amount of product that can be formed.</p>

                                <div class="formula-box">
                                    <strong>Key Concept:</strong><br>
                                    The reactant that produces the LEAST amount of product is the limiting reagent.
                                </div>

                                <h6>Step-by-Step Process</h6>

                                <div class="step-box">
                                    <strong>Step 1:</strong> Write the balanced chemical equation<br>
                                    Example: 2H₂ + O₂ → 2H₂O
                                </div>

                                <div class="step-box">
                                    <strong>Step 2:</strong> Convert all given amounts to moles<br>
                                    • If given grams: moles = grams ÷ molar mass<br>
                                    • If given moles: use directly
                                </div>

                                <div class="step-box">
                                    <strong>Step 3:</strong> Calculate mole ratio for each reactant<br>
                                    • Divide moles available by coefficient in balanced equation<br>
                                    • The reactant with the SMALLEST ratio is the limiting reagent
                                </div>

                                <div class="step-box">
                                    <strong>Step 4:</strong> Calculate theoretical yield<br>
                                    • Use moles of limiting reagent<br>
                                    • Apply stoichiometry from balanced equation<br>
                                    • Convert to desired unit (g, mol, etc.)
                                </div>

                                <div class="step-box">
                                    <strong>Step 5:</strong> Calculate excess reagent remaining<br>
                                    • Determine how much was used based on limiting reagent<br>
                                    • Subtract from initial amount
                                </div>

                                <h6>Example Problem</h6>
                                <div class="alert alert-info">
                                    <strong>Problem:</strong> 4.0 g of H₂ reacts with 32.0 g of O₂. Find the limiting reagent and theoretical yield of H₂O.<br><br>

                                    <strong>Balanced equation:</strong> 2H₂ + O₂ → 2H₂O<br><br>

                                    <strong>Step 1 - Convert to moles:</strong><br>
                                    • H₂: 4.0 g ÷ 2.016 g/mol = 1.98 mol<br>
                                    • O₂: 32.0 g ÷ 32.00 g/mol = 1.00 mol<br><br>

                                    <strong>Step 2 - Calculate mole ratios:</strong><br>
                                    • H₂: 1.98 mol ÷ 2 = 0.99<br>
                                    • O₂: 1.00 mol ÷ 1 = 1.00<br><br>

                                    <strong>Result:</strong> H₂ is the limiting reagent (smallest ratio)<br><br>

                                    <strong>Step 3 - Theoretical yield:</strong><br>
                                    • From equation: 2 mol H₂ → 2 mol H₂O<br>
                                    • So: 1.98 mol H₂ → 1.98 mol H₂O<br>
                                    • Mass: 1.98 mol × 18.015 g/mol = 35.7 g H₂O
                                </div>

                                <h6>Percent Yield</h6>
                                <p>Percent yield compares actual yield (what you got in the lab) to theoretical yield (maximum possible):</p>

                                <div class="formula-box">
                                    <strong>Percent Yield Formula:</strong><br>
                                    % Yield = (Actual Yield ÷ Theoretical Yield) × 100%
                                </div>

                                <p><strong>Why is percent yield less than 100%?</strong></p>
                                <ul>
                                    <li>Incomplete reactions</li>
                                    <li>Side reactions producing unwanted products</li>
                                    <li>Product lost during purification/transfer</li>
                                    <li>Measurement errors</li>
                                </ul>

                                <h6>Common Mistakes to Avoid</h6>
                                <ul>
                                    <li>❌ Forgetting to balance the equation first</li>
                                    <li>❌ Using grams instead of moles for comparison</li>
                                    <li>❌ Not dividing by stoichiometric coefficients</li>
                                    <li>❌ Assuming the reactant with less mass is limiting</li>
                                    <li>✅ Always convert to moles and use mole ratios!</li>
                                </ul>

                                <h6>Real-World Applications</h6>
                                <ul>
                                    <li><strong>Industrial Chemistry:</strong> Minimize waste by using excess of cheaper reactant</li>
                                    <li><strong>Pharmaceutical Manufacturing:</strong> Calculate exact amounts needed for drug synthesis</li>
                                    <li><strong>Environmental Chemistry:</strong> Predict pollutant formation in combustion</li>
                                    <li><strong>Food Chemistry:</strong> Optimize ingredient ratios in recipes</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Results Column -->
        <div class="col-lg-5 mb-4">
            <div class="card shadow-sm sticky-side">
                <div class="card-body">
                    <h5 class="card-title">Results</h5>
                    <div id="resultDisplay" class="min-h-result">
                        <p class="text-muted text-center">
                            <i class="fas fa-info-circle fa-2x mb-2"></i><br>
                            Enter reactant amounts and click Calculate to see results
                        </p>
                    </div>

                    <!-- Action buttons (initially hidden) -->
                    <div id="actionButtons" style="display:none;" class="mt-3">
                        <button class="btn btn-sm btn-outline-primary btn-block" onclick="shareURL()">
                            <i class="fas fa-share-alt"></i> Share URL
                        </button>
                        <button class="btn btn-sm btn-outline-primary btn-block" onclick="copyResult()">
                            <i class="fas fa-copy"></i> Copy Results
                        </button>
                        <button class="btn btn-sm btn-outline-primary btn-block" onclick="exportPDF()">
                            <i class="fas fa-file-pdf"></i> Export PDF (Coming Soon!)
                        </button>
                    </div>

                    <!-- Share URL Display -->
                    <div id="shareURLDisplay" style="display: none; margin-top: 15px; padding: 15px; background: #f0f9ff; border: 2px solid #3b82f6; border-radius: 8px;">
                        <div style="font-size: 0.9rem; color: #1e40af; margin-bottom: 8px; font-weight: 600;">
                            <i class="fas fa-link"></i> Shareable URL:
                        </div>
                        <div style="display: flex; gap: 10px; align-items: center;">
                            <input type="text" id="shareURLInput" readonly class="form-control" style="font-size: 0.85rem; font-family: monospace;">
                            <button class="btn btn-primary btn-sm" onclick="copyShareURL()" style="white-space: nowrap;">
                                <i class="fas fa-copy"></i> Copy
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>

<script>
    let currentResult = '';
    let parsedEquationData = null;

    // Periodic table data for molar mass calculation (IUPAC 2021 values)
    const ELEMENTS = {
        'H': 1.008, 'He': 4.003, 'Li': 6.941, 'Be': 9.012, 'B': 10.81, 'C': 12.01, 'N': 14.01, 'O': 16.00,
        'F': 19.00, 'Ne': 20.18, 'Na': 22.99, 'Mg': 24.31, 'Al': 26.98, 'Si': 28.09, 'P': 30.97, 'S': 32.07,
        'Cl': 35.45, 'Ar': 39.95, 'K': 39.10, 'Ca': 40.08, 'Sc': 44.96, 'Ti': 47.87, 'V': 50.94, 'Cr': 52.00,
        'Mn': 54.94, 'Fe': 55.85, 'Co': 58.93, 'Ni': 58.69, 'Cu': 63.55, 'Zn': 65.39, 'Ga': 69.72, 'Ge': 72.61,
        'As': 74.92, 'Se': 78.96, 'Br': 79.90, 'Kr': 83.80, 'Rb': 85.47, 'Sr': 87.62, 'Y': 88.91, 'Zr': 91.22,
        'Nb': 92.91, 'Mo': 95.94, 'Tc': 98.0, 'Ru': 101.1, 'Rh': 102.9, 'Pd': 106.4, 'Ag': 107.9, 'Cd': 112.4,
        'In': 114.8, 'Sn': 118.7, 'Sb': 121.8, 'Te': 127.6, 'I': 126.9, 'Xe': 131.3, 'Cs': 132.9, 'Ba': 137.3,
        'La': 138.9, 'Ce': 140.1, 'Pr': 140.9, 'Nd': 144.2, 'Pm': 145.0, 'Sm': 150.4, 'Eu': 152.0, 'Gd': 157.3,
        'Tb': 158.9, 'Dy': 162.5, 'Ho': 164.9, 'Er': 167.3, 'Tm': 168.9, 'Yb': 173.0, 'Lu': 175.0, 'Hf': 178.5,
        'Ta': 180.9, 'W': 183.8, 'Re': 186.2, 'Os': 190.2, 'Ir': 192.2, 'Pt': 195.1, 'Au': 197.0, 'Hg': 200.6,
        'Tl': 204.4, 'Pb': 207.2, 'Bi': 209.0, 'Po': 209.0, 'At': 210.0, 'Rn': 222.0, 'Fr': 223.0, 'Ra': 226.0,
        'Ac': 227.0, 'Th': 232.0, 'Pa': 231.0, 'U': 238.0, 'Np': 237.0, 'Pu': 244.0
    };

    // Calculate molar mass from chemical formula
    function calculateMolarMass(formula) {
        let mass = 0;
        // Match element symbols with optional counts and handle parentheses
        const regex = /([A-Z][a-z]?)(\d*)|(\()([^)]+)(\))(\d*)/g;
        let match;

        while ((match = regex.exec(formula)) !== null) {
            if (match[1]) {
                // Simple element
                const element = match[1];
                const count = match[2] ? parseInt(match[2]) : 1;
                if (ELEMENTS[element]) {
                    mass += ELEMENTS[element] * count;
                }
            } else if (match[4]) {
                // Group in parentheses
                const groupFormula = match[4];
                const groupCount = match[6] ? parseInt(match[6]) : 1;
                mass += calculateMolarMass(groupFormula) * groupCount;
            }
        }
        return mass;
    }

    // Check if equation is balanced
    function isEquationBalanced(parsed) {
        const elementCount = {};

        // Count elements in reactants
        parsed.reactants.forEach(r => {
            const elements = countElements(r.formula);
            for (const elem in elements) {
                elementCount[elem] = (elementCount[elem] || 0) + (elements[elem] * r.coefficient);
            }
        });

        // Subtract elements in products
        parsed.products.forEach(p => {
            const elements = countElements(p.formula);
            for (const elem in elements) {
                elementCount[elem] = (elementCount[elem] || 0) - (elements[elem] * p.coefficient);
            }
        });

        // Check if all counts are zero
        for (const elem in elementCount) {
            if (Math.abs(elementCount[elem]) > 0.001) {
                return false;
            }
        }
        return true;
    }

    // Count elements in a formula
    function countElements(formula) {
        const elements = {};
        const regex = /([A-Z][a-z]?)(\d*)|(\()([^)]+)(\))(\d*)/g;
        let match;

        while ((match = regex.exec(formula)) !== null) {
            if (match[1]) {
                const element = match[1];
                const count = match[2] ? parseInt(match[2]) : 1;
                elements[element] = (elements[element] || 0) + count;
            } else if (match[4]) {
                const groupFormula = match[4];
                const groupCount = match[6] ? parseInt(match[6]) : 1;
                const groupElements = countElements(groupFormula);
                for (const elem in groupElements) {
                    elements[elem] = (elements[elem] || 0) + (groupElements[elem] * groupCount);
                }
            }
        }
        return elements;
    }

    // Parse chemical equation to extract coefficients and formulas
    function parseEquation(equation) {
        // Normalize arrows
        equation = equation.replace(/⇌|<=>|<-->|==|=/g, '→');

        const parts = equation.split('→');
        if (parts.length !== 2) return null;

        const reactantsStr = parts[0].trim();
        const productsStr = parts[1].trim();

        function parseSpecies(speciesStr) {
            const species = [];
            // Split by + sign first, then parse each species
            const speciesList = speciesStr.split('+').map(s => s.trim()).filter(s => s.length > 0);

            speciesList.forEach(spec => {
                // Match coefficient and formula separately
                const match = spec.match(/^(\d*\.?\d+)?\s*(.+)$/);
                if (match) {
                    const coefficient = match[1] ? parseFloat(match[1]) : 1;
                    const formula = match[2] ? match[2].trim() : '';

                    if (formula) {
                        species.push({
                            coefficient: coefficient,
                            formula: formula,
                            molarMass: calculateMolarMass(formula)
                        });
                    }
                }
            });

            return species;
        }

        const reactants = parseSpecies(reactantsStr);
        const products = parseSpecies(productsStr);

        if (reactants.length === 0 || products.length === 0) return null;

        return {
            reactants: reactants,
            products: products,
            original: equation
        };
    }

    // Convert units to grams
    function convertToGrams(amount, unit) {
        const conversions = {
            'g': 1,
            'kg': 1000,
            'mg': 0.001,
            'mol': 1 // will be handled separately with molar mass
        };
        return amount * (conversions[unit] || 1);
    }

    // Generate dynamic input fields based on parsed equation
    function generateDynamicFields(parsed) {
        const container = document.getElementById('dynamicReactantFields');
        if (!container) return;

        let html = '<h6 class="mt-3">Reactant Amounts</h6>';

        parsed.reactants.forEach((reactant, index) => {
            html += `
                <div class="card mb-3">
                    <div class="card-body">
                        <h6 class="card-subtitle mb-2 text-muted">
                            <strong>${reactant.formula}</strong>
                            <span class="badge badge-info ml-2">MM: ${reactant.molarMass.toFixed(3)} g/mol</span>
                        </h6>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Amount</label>
                                    <input type="number" step="any" class="form-control" id="reactant${index}Amount" placeholder="Enter amount">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Unit</label>
                                    <select class="form-control" id="reactant${index}Unit">
                                        <option value="g">grams (g)</option>
                                        <option value="mol">moles (mol)</option>
                                        <option value="kg">kilograms (kg)</option>
                                        <option value="mg">milligrams (mg)</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });

        html += '<h6 class="mt-3">Select Product to Calculate</h6>';
        html += '<select class="form-control mb-3" id="selectedProduct">';
        parsed.products.forEach((product, index) => {
            html += `<option value="${index}">${product.formula} (MM: ${product.molarMass.toFixed(3)} g/mol)</option>`;
        });
        html += '</select>';

        container.innerHTML = html;
        parsedEquationData = parsed;
    }

    // Calculate basic limiting reagent (now supports 3+ reactants!)
    function calculateBasic() {
        const equation = document.getElementById('basicEquation').value.trim();

        if (!equation) {
            alert('Please enter a chemical equation');
            return;
        }

        // Parse equation
        const parsed = parseEquation(equation);
        if (!parsed || parsed.reactants.length < 1) {
            alert('Please enter a valid chemical equation');
            return;
        }

        // Check if equation is balanced
        if (!isEquationBalanced(parsed)) {
            const confirmCalc = confirm('⚠️ Warning: This equation does not appear to be balanced!\n\nAtom counts don\'t match on both sides.\n\nDo you want to continue anyway?');
            if (!confirmCalc) return;
        }

        // Collect reactant amounts
        const reactantData = [];
        for (let i = 0; i < parsed.reactants.length; i++) {
            const amount = parseFloat(document.getElementById(`reactant${i}Amount`).value);
            const unit = document.getElementById(`reactant${i}Unit`).value;

            if (isNaN(amount) || amount <= 0) {
                alert(`Please enter a valid amount for ${parsed.reactants[i].formula}`);
                return;
            }

            // Convert to moles
            let moles;
            if (unit === 'mol') {
                moles = amount;
            } else {
                const grams = convertToGrams(amount, unit);
                moles = grams / parsed.reactants[i].molarMass;
            }

            reactantData.push({
                formula: parsed.reactants[i].formula,
                coefficient: parsed.reactants[i].coefficient,
                molarMass: parsed.reactants[i].molarMass,
                initialAmount: amount,
                unit: unit,
                moles: moles,
                ratio: moles / parsed.reactants[i].coefficient
            });
        }

        // Find limiting reagent
        let limitingIndex = 0;
        let minRatio = reactantData[0].ratio;
        for (let i = 1; i < reactantData.length; i++) {
            if (reactantData[i].ratio < minRatio) {
                minRatio = reactantData[i].ratio;
                limitingIndex = i;
            }
        }

        const limitingReagent = reactantData[limitingIndex];

        // Calculate excess reagents
        const excessReagents = [];
        for (let i = 0; i < reactantData.length; i++) {
            if (i !== limitingIndex) {
                const required = (limitingReagent.moles / limitingReagent.coefficient) * reactantData[i].coefficient;
                const remaining = reactantData[i].moles - required;
                const remainingGrams = remaining * reactantData[i].molarMass;
                excessReagents.push({
                    formula: reactantData[i].formula,
                    remaining: remaining,
                    remainingGrams: remainingGrams
                });
            }
        }

        // Calculate theoretical yields for selected product
        const selectedProductIndex = parseInt(document.getElementById('selectedProduct').value);
        const selectedProduct = parsed.products[selectedProductIndex];

        const productMoles = (limitingReagent.moles / limitingReagent.coefficient) * selectedProduct.coefficient;
        const theoreticalYield = productMoles * selectedProduct.molarMass;

        // Calculate all products
        const allProducts = parsed.products.map(product => {
            const moles = (limitingReagent.moles / limitingReagent.coefficient) * product.coefficient;
            const mass = moles * product.molarMass;
            return {
                formula: product.formula,
                moles: moles,
                mass: mass
            };
        });

        // Build result HTML
        let resultHTML = `
            <div class="result-section">
                <h6><strong>Equation:</strong></h6>
                <div class="reaction-display">${equation}</div>

                ${!isEquationBalanced(parsed) ? '<div class="alert alert-warning mb-2"><small>⚠️ Equation may not be balanced</small></div>' : '<div class="alert alert-success mb-2"><small>✓ Equation is balanced</small></div>'}

                <h6 class="mt-3"><strong>Reactant Moles:</strong></h6>
                <div class="reagent-info">
                    ${reactantData.map(r => `
                        <div class="reagent-info-item">
                            <strong>${r.formula}</strong>
                            <span>${r.moles.toFixed(4)} mol</span>
                        </div>
                    `).join('')}
                </div>

                <h6 class="mt-3"><strong>Limiting Reagent:</strong></h6>
                <div class="mb-2">
                    <span class="limiting-badge">${limitingReagent.formula}</span>
                </div>
                <small>Mole ratios: ${reactantData.map(r => `${r.formula}: ${r.ratio.toFixed(4)}`).join(' | ')}</small>

                ${excessReagents.length > 0 ? `
                    <h6 class="mt-3"><strong>Excess Reagents Remaining:</strong></h6>
                    ${excessReagents.map(e => `
                        <div class="mb-2">
                            <span class="excess-badge">${e.formula}: ${e.remainingGrams.toFixed(3)} g (${e.remaining.toFixed(4)} mol)</span>
                        </div>
                    `).join('')}
                ` : ''}

                <h6 class="mt-3"><strong>Theoretical Yields:</strong></h6>
                ${allProducts.map((p, idx) => `
                    <div class="mb-2">
                        <span class="yield-badge ${idx === selectedProductIndex ? 'font-weight-bold' : ''}">${p.formula}: ${p.mass.toFixed(3)} g (${p.moles.toFixed(4)} mol)${idx === selectedProductIndex ? ' ⭐' : ''}</span>
                    </div>
                `).join('')}

                <div class="alert alert-info mt-3">
                    <strong>Summary:</strong><br>
                    • Limiting reagent: <strong>${limitingReagent.formula}</strong><br>
                    • Theoretical yield of ${selectedProduct.formula}: <strong>${theoreticalYield.toFixed(3)} g</strong><br>
                    ${excessReagents.length > 0 ? '• ' + excessReagents.map(e => `${e.remainingGrams.toFixed(2)} g ${e.formula} left over`).join('<br>• ') : ''}
                </div>
            </div>
        `;

        currentResult = resultHTML;
        document.getElementById('resultDisplay').innerHTML = resultHTML;
        document.getElementById('actionButtons').style.display = 'block';

        // Auto-populate advanced tab with theoretical yield
        document.getElementById('advTheoYield').value = theoreticalYield.toFixed(3);
    }

    // Parse equation when user enters it
    document.getElementById('basicEquation').addEventListener('blur', function() {
        const equation = this.value.trim();
        if (equation) {
            const parsed = parseEquation(equation);
            if (parsed) {
                generateDynamicFields(parsed);
            }
        }
    });

    // Calculate percent yield
    function calculateAdvanced() {
        const theoYield = parseFloat(document.getElementById('advTheoYield').value);
        const actualYield = parseFloat(document.getElementById('advActualYield').value);
        const unit = document.getElementById('advUnit').value;

        if (isNaN(theoYield) || isNaN(actualYield)) {
            alert('Please enter both theoretical and actual yield');
            return;
        }

        if (actualYield > theoYield) {
            alert('Warning: Actual yield cannot be greater than theoretical yield! Please check your values.');
        }

        const percentYield = (actualYield / theoYield) * 100;

        let resultHTML = `
            <div class="result-section">
                <h6><strong>Yield Calculation</strong></h6>

                <div class="reagent-info">
                    <div class="reagent-info-item">
                        <strong>Theoretical Yield</strong>
                        <span>${theoYield.toFixed(3)} ${unit}</span>
                    </div>
                    <div class="reagent-info-item">
                        <strong>Actual Yield</strong>
                        <span>${actualYield.toFixed(3)} ${unit}</span>
                    </div>
                </div>

                <div class="result-label">Percent Yield:</div>
                <div class="result-value">
                    <span class="yield-badge">${percentYield.toFixed(2)}%</span>
                </div>

                <div class="alert ${percentYield >= 80 ? 'alert-success' : percentYield >= 50 ? 'alert-warning' : 'alert-danger'} mt-3">
                    <strong>Interpretation:</strong><br>
                    ${percentYield >= 90 ? '🌟 Excellent yield! Very efficient reaction.' :
                      percentYield >= 80 ? '✅ Good yield. This is typical for many reactions.' :
                      percentYield >= 50 ? '⚠️ Moderate yield. Some optimization may be needed.' :
                      '❌ Low yield. Check reaction conditions, purity, or side reactions.'}
                </div>

                <div class="formula-box mt-3">
                    <strong>Formula Used:</strong><br>
                    % Yield = (Actual Yield ÷ Theoretical Yield) × 100%<br>
                    % Yield = (${actualYield.toFixed(3)} ÷ ${theoYield.toFixed(3)}) × 100%<br>
                    % Yield = ${percentYield.toFixed(2)}%
                </div>
            </div>
        `;

        currentResult = resultHTML;
        document.getElementById('resultDisplay').innerHTML = resultHTML;
        document.getElementById('actionButtons').style.display = 'block';
    }

    // Set example
    function setBasicExample(equation) {
        document.getElementById('basicEquation').value = equation;

        // Parse equation and generate dynamic fields
        const parsed = parseEquation(equation);
        if (parsed) {
            generateDynamicFields(parsed);

            // Auto-fill with example amounts (1 gram for each reactant)
            setTimeout(() => {
                parsed.reactants.forEach((reactant, index) => {
                    const amountInput = document.getElementById(`reactant${index}Amount`);
                    if (amountInput) {
                        amountInput.value = 10; // 10 grams as default
                    }
                });
            }, 100);
        }
    }

    // Clear functions
    function clearBasic() {
        document.getElementById('basicEquation').value = '';
        document.getElementById('dynamicReactantFields').innerHTML = '';
        parsedEquationData = null;
        document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter equation and input amounts to calculate</p>';
        document.getElementById('actionButtons').style.display = 'none';
    }

    function clearAdvanced() {
        document.getElementById('advTheoYield').value = '';
        document.getElementById('advActualYield').value = '';
        document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter values and click Calculate</p>';
        document.getElementById('actionButtons').style.display = 'none';
    }

    // Copy result
    function copyResult() {
        const resultDiv = document.getElementById('resultDisplay');
        const text = resultDiv.innerText;
        navigator.clipboard.writeText(text).then(() => {
            alert('Result copied to clipboard!');
        }).catch(err => {
            console.error('Could not copy text: ', err);
        });
    }

    // Share URL
    function shareURL() {
        const equation = document.getElementById('basicEquation').value.trim();

        if (!equation) {
            alert('Please enter a chemical equation first!');
            return;
        }

        const params = new URLSearchParams();
        params.set('eq', equation);
        params.set('r1', document.getElementById('basicR1Amount').value);
        params.set('r2', document.getElementById('basicR2Amount').value);
        params.set('u1', document.getElementById('basicR1Unit').value);
        params.set('u2', document.getElementById('basicR2Unit').value);
        params.set('mm1', document.getElementById('basicR1MM').value);
        params.set('mm2', document.getElementById('basicR2MM').value);
        params.set('mmp', document.getElementById('basicPMM').value);

        const baseURL = window.location.origin + window.location.pathname;
        const shareableURL = `${baseURL}?${params.toString()}`;

        document.getElementById('shareURLInput').value = shareableURL;
        document.getElementById('shareURLDisplay').style.display = 'block';

        setTimeout(() => {
            document.getElementById('shareURLDisplay').scrollIntoView({behavior: 'smooth', block: 'nearest'});
        }, 100);
    }

    // Copy shareable URL
    function copyShareURL() {
        const urlInput = document.getElementById('shareURLInput');
        urlInput.select();
        urlInput.setSelectionRange(0, 99999);

        navigator.clipboard.writeText(urlInput.value).then(() => {
            const button = event.target.closest('button');
            const originalHTML = button.innerHTML;
            button.innerHTML = '<i class="fas fa-check"></i> Copied!';
            button.classList.remove('btn-primary');
            button.classList.add('btn-success');

            setTimeout(() => {
                button.innerHTML = originalHTML;
                button.classList.remove('btn-success');
                button.classList.add('btn-primary');
            }, 2000);
        }).catch(err => {
            document.execCommand('copy');
            alert('URL copied to clipboard!');
        });
    }

    // Load parameters from URL
    window.addEventListener('DOMContentLoaded', function() {
        const params = new URLSearchParams(window.location.search);

        if (params.has('eq')) {
            document.getElementById('basicEquation').value = params.get('eq');
            if (params.has('r1')) document.getElementById('basicR1Amount').value = params.get('r1');
            if (params.has('r2')) document.getElementById('basicR2Amount').value = params.get('r2');
            if (params.has('u1')) document.getElementById('basicR1Unit').value = params.get('u1');
            if (params.has('u2')) document.getElementById('basicR2Unit').value = params.get('u2');
            if (params.has('mm1')) document.getElementById('basicR1MM').value = params.get('mm1');
            if (params.has('mm2')) document.getElementById('basicR2MM').value = params.get('mm2');
            if (params.has('mmp')) document.getElementById('basicPMM').value = params.get('mmp');

            // Auto-calculate if all parameters present
            if (params.has('r1') && params.has('r2') && params.has('mm1') && params.has('mm2') && params.has('mmp')) {
                calculateBasic();
            }
        }
    });

    // Export PDF placeholder
    function exportPDF() {
        alert('PDF export feature coming soon!');
    }
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
