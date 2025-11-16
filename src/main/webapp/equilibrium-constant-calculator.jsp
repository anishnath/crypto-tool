<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Equilibrium Constant Calculator (Kc, Kp, Ka, Kb) | ICE Table Solver | 8gwifi.org</title>
    <meta name="description" content="Free equilibrium constant calculator for Kc, Kp, Ka, Kb, and Kw. Includes ICE table solver, pH calculations, Kc↔Kp conversion, and reaction quotient (Q) calculations.">
    <meta name="keywords" content="equilibrium constant calculator, Kc calculator, Kp calculator, Ka calculator, Kb calculator, ICE table solver, reaction quotient, equilibrium chemistry, chemical equilibrium, Le Chatelier principle">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/equilibrium-constant-calculator.jsp">
    <meta property="og:title" content="Equilibrium Constant Calculator - Kc, Kp, Ka, Kb & ICE Tables">
    <meta property="og:description" content="Calculate equilibrium constants, solve ICE tables, and determine pH from Ka/Kb. Comprehensive chemistry equilibrium calculator.">
    <meta property="og:image" content="https://8gwifi.org/images/site/equilibrium-og.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/equilibrium-constant-calculator.jsp">
    <meta property="twitter:title" content="Equilibrium Constant Calculator - Kc, Kp, Ka, Kb & ICE Tables">
    <meta property="twitter:description" content="Calculate equilibrium constants, solve ICE tables, and determine pH from Ka/Kb.">
    <meta property="twitter:image" content="https://8gwifi.org/images/site/equilibrium-og.png">

    <link rel="canonical" href="https://8gwifi.org/equilibrium-constant-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- JSON-LD Schema Markup -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Equilibrium Constant Calculator",
      "description": "Calculate Kc, Kp, Ka, Kb equilibrium constants, solve ICE tables, and perform pH calculations from acid/base dissociation constants",
      "url": "https://8gwifi.org/equilibrium-constant-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "featureList": [
        "Kc (concentration) calculator",
        "Kp (pressure) calculator",
        "Ka/Kb acid-base calculator",
        "ICE table solver",
        "Reaction quotient (Q) calculator",
        "Kc to Kp conversion",
        "pH from Ka/Kb",
        "Common equilibrium constants database"
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
        "name": "Equilibrium Constant Calculator",
        "item": "https://8gwifi.org/equilibrium-constant-calculator.jsp"
      }]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What is an equilibrium constant?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "An equilibrium constant (K) is a number that expresses the relationship between products and reactants at equilibrium. Kc uses concentrations, Kp uses partial pressures, Ka is for weak acids, and Kb is for weak bases."
        }
      },{
        "@type": "Question",
        "name": "How do you calculate Kc from concentrations?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Kc = [products]^coefficients / [reactants]^coefficients. For example, for aA + bB ⇌ cC + dD: Kc = [C]^c[D]^d / [A]^a[B]^b. Use equilibrium concentrations only."
        }
      },{
        "@type": "Question",
        "name": "What is an ICE table?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "ICE stands for Initial, Change, Equilibrium. It's a table used to calculate equilibrium concentrations by tracking initial amounts, changes during reaction, and final equilibrium values."
        }
      },{
        "@type": "Question",
        "name": "How do you convert Kc to Kp?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Kp = Kc(RT)^Δn, where R is the gas constant (0.0821 L·atm/mol·K), T is temperature in Kelvin, and Δn is the change in moles of gas (moles products - moles reactants)."
        }
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
        .equilibrium-info {
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }
        .equilibrium-info-item {
            flex: 1;
            min-width: 150px;
            padding: 0.75rem;
            background: white;
            border-radius: 0.25rem;
            border-left: 4px solid #667eea;
        }
        .equilibrium-info-item strong {
            display: block;
            color: #495057;
            margin-bottom: 0.25rem;
        }
        .example-reaction {
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
        .example-reaction:hover {
            background: #e9ecef;
            border-color: #667eea;
            transform: translateY(-2px);
        }
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 0.25rem;
        }
        .ice-table {
            width: 100%;
            margin-top: 1rem;
            font-size: 0.9rem;
        }
        .ice-table th {
            background: #f8f9fa;
            padding: 0.5rem;
            border: 1px solid #dee2e6;
            text-align: center;
        }
        .ice-table td {
            padding: 0.5rem;
            border: 1px solid #dee2e6;
            text-align: center;
        }
        .ice-table input {
            width: 100%;
            padding: 0.25rem;
            border: 1px solid #ced4da;
            border-radius: 0.25rem;
        }
        .k-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: #667eea;
            color: white;
            border-radius: 2rem;
            font-weight: 600;
            margin: 0.25rem;
        }
        .reaction-display {
            background: white;
            padding: 1rem;
            border: 2px solid #dee2e6;
            border-radius: 0.5rem;
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            text-align: center;
            margin: 1rem 0;
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
        .formula-box {
            background: white;
            padding: 1rem;
            border-left: 4px solid #667eea;
            border-radius: 0.25rem;
            font-family: 'Courier New', monospace;
            margin: 0.5rem 0;
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
                <h1 class="mb-3">Equilibrium Constant Calculator</h1>
                <p class="lead">Calculate Kc, Kp, Ka, Kb equilibrium constants, solve ICE tables, and perform pH calculations from dissociation constants.</p>

                <!-- Tabs -->
                <div class="tabs-container">
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="kc-tab" data-toggle="tab" href="#kc" role="tab">
                                <i class="fas fa-flask"></i> Kc Calculator
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="kp-tab" data-toggle="tab" href="#kp" role="tab">
                                <i class="fas fa-compress-arrows-alt"></i> Kp Calculator
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="ka-kb-tab" data-toggle="tab" href="#ka-kb" role="tab">
                                <i class="fas fa-atom"></i> Ka/Kb Calculator
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="ice-tab" data-toggle="tab" href="#ice" role="tab">
                                <i class="fas fa-table"></i> ICE Table
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="learn-tab" data-toggle="tab" href="#learn" role="tab">
                                <i class="fas fa-book"></i> Learn
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Tab 1: Kc Calculator -->
                        <div class="tab-pane fade show active" id="kc" role="tabpanel">
                            <h4>Kc (Concentration Equilibrium Constant)</h4>

                            <div class="form-group">
                                <label>Reaction</label>
                                <input type="text" class="form-control" id="kcReaction" placeholder="e.g., N2 + 3H2 ⇌ 2NH3">
                                <small class="help-text">Supports: ⇌, &lt;=&gt;, &lt;--&gt;, ==, or = • Auto-parses coefficients from equation</small>
                            </div>
                            <div id="equationParse" style="display:none;"></div>

                            <div class="form-group">
                                <label>Calculation Type</label>
                                <select class="form-control" id="kcCalcType">
                                    <option value="calculateKc">Calculate Kc from concentrations</option>
                                    <option value="calculateQ">Calculate Q (Reaction Quotient)</option>
                                    <option value="findConcentration">Find equilibrium concentration</option>
                                </select>
                            </div>

                            <div id="kcConcentrations">
                                <h6 class="mt-3">Equilibrium Concentrations (M)</h6>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Reactant 1</label>
                                            <input type="number" step="any" class="form-control" id="kcR1" placeholder="Concentration">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Reactant 2</label>
                                            <input type="number" step="any" class="form-control" id="kcR2" placeholder="Concentration (optional)">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Product 1</label>
                                            <input type="number" step="any" class="form-control" id="kcP1" placeholder="Concentration">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Product 2</label>
                                            <input type="number" step="any" class="form-control" id="kcP2" placeholder="Concentration (optional)">
                                        </div>
                                    </div>
                                </div>
                            </div>



                            <button class="btn btn-primary" onclick="calculateKc()">
                                <i class="fas fa-calculator"></i> Calculate Kc
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearKc()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>

                            <div class="form-group">
                                <label>Common Equilibrium Examples (Click to load)</label>
                                <div>
                                    <span class="example-reaction" onclick="setKcExample('N2 + 3H2 ⇌ 2NH3')">Haber Process</span>
                                    <span class="example-reaction" onclick="setKcExample('H2 + I2 <=> 2HI')">H₂ + I₂ ⇌ HI</span>
                                    <span class="example-reaction" onclick="setKcExample('N2O4 == 2NO2')">N₂O₄ ⇌ NO₂</span>
                                    <span class="example-reaction" onclick="setKcExample('CO + 2H2 = CH3OH')">Methanol Synthesis</span>
                                    <span class="example-reaction" onclick="setKcExample('2SO2 + O2 <--> 2SO3')">Contact Process</span>
                                    <span class="example-reaction" onclick="setKcExample('4NH3 + 5O2 ⇌ 4NO + 6H2O')">Ostwald Process</span>
                                    <span class="example-reaction" onclick="setKcExample('PCl5 <=> PCl3 + Cl2')">PCl₅ dissociation</span>
                                    <span class="example-reaction" onclick="setKcExample('2HI == H2 + I2')">HI decomposition</span>
                                </div>
                            </div>

                        </div>

                        <!-- Tab 2: Kp Calculator -->
                        <div class="tab-pane fade" id="kp" role="tabpanel">
                            <h4>Kp (Pressure Equilibrium Constant)</h4>

                            <div class="form-group">
                                <label>Calculation Type</label>
                                <select class="form-control" id="kpCalcType">
                                    <option value="calculateKp">Calculate Kp from partial pressures</option>
                                    <option value="convertKcToKp">Convert Kc to Kp</option>
                                    <option value="convertKpToKc">Convert Kp to Kc</option>
                                </select>
                            </div>

                            <div id="kpPressures">
                                <h6 class="mt-3">Partial Pressures (atm)</h6>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Reactant 1 Pressure</label>
                                            <input type="number" step="any" class="form-control" id="kpR1" placeholder="Partial pressure (atm)">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Reactant 2 Pressure</label>
                                            <input type="number" step="any" class="form-control" id="kpR2" placeholder="Partial pressure (atm)">
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Product 1 Pressure</label>
                                            <input type="number" step="any" class="form-control" id="kpP1" placeholder="Partial pressure (atm)">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Product 2 Pressure</label>
                                            <input type="number" step="any" class="form-control" id="kpP2" placeholder="Partial pressure (atm)">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div id="kpConversion" style="display:none;">
                                <div class="form-group">
                                    <label>Known Constant Value</label>
                                    <input type="number" step="any" class="form-control" id="kpKnownValue" placeholder="Enter Kc or Kp value">
                                </div>
                                <div class="form-group">
                                    <label>Temperature (K)</label>
                                    <input type="number" step="any" class="form-control" id="kpTemp" placeholder="Temperature in Kelvin">
                                </div>
                                <div class="form-group">
                                    <label>Δn (Change in moles of gas)</label>
                                    <input type="number" step="any" class="form-control" id="kpDeltaN" placeholder="(moles products) - (moles reactants)">
                                    <small class="help-text">Δn = (sum of gas coefficients in products) - (sum of gas coefficients in reactants)</small>
                                </div>
                            </div>

                            <div class="alert alert-info mt-3">
                                <strong>Formula:</strong> Kp = Kc(RT)<sup>Δn</sup><br>
                                Where R = 0.0821 L·atm/(mol·K), T = temperature (K), Δn = change in moles of gas
                            </div>

                            <button class="btn btn-primary" onclick="calculateKp()">
                                <i class="fas fa-calculator"></i> Calculate Kp
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearKp()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 3: Ka/Kb Calculator -->
                        <div class="tab-pane fade" id="ka-kb" role="tabpanel">
                            <h4>Ka/Kb (Acid-Base Equilibrium)</h4>

                            <div class="form-group">
                                <label>Calculation Type</label>
                                <select class="form-control" id="kaKbType">
                                    <option value="calculateKa">Calculate Ka (weak acid)</option>
                                    <option value="calculateKb">Calculate Kb (weak base)</option>
                                    <option value="pHfromKa">Calculate pH from Ka</option>
                                    <option value="pOHfromKb">Calculate pOH from Kb</option>
                                    <option value="kaKbRelation">Ka × Kb = Kw relation</option>
                                </select>
                            </div>

                            <div id="kaKbInputs">
                                <div class="form-group">
                                    <label>Acid/Base Formula</label>
                                    <input type="text" class="form-control" id="kaKbFormula" placeholder="e.g., CH3COOH, NH3">
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>[H⁺] or [OH⁻] (M)</label>
                                            <input type="number" step="any" class="form-control" id="kaKbIon" placeholder="Ion concentration">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>[Acid] or [Base] (M)</label>
                                            <input type="number" step="any" class="form-control" id="kaKbConc" placeholder="Initial concentration">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Common Weak Acids & Bases</label>
                                <div>
                                    <span class="example-reaction" onclick="setKaKbExample('CH3COOH', 1.8e-5, 'Ka')">Acetic acid (Ka=1.8×10⁻⁵)</span>
                                    <span class="example-reaction" onclick="setKaKbExample('HF', 6.8e-4, 'Ka')">HF (Ka=6.8×10⁻⁴)</span>
                                    <span class="example-reaction" onclick="setKaKbExample('NH3', 1.8e-5, 'Kb')">Ammonia (Kb=1.8×10⁻⁵)</span>
                                    <span class="example-reaction" onclick="setKaKbExample('C5H5N', 1.7e-9, 'Kb')">Pyridine (Kb=1.7×10⁻⁹)</span>
                                </div>
                            </div>

                            <div class="alert alert-info mt-3">
                                <strong>Key Relationships:</strong><br>
                                • Ka = [H⁺][A⁻] / [HA]<br>
                                • Kb = [OH⁻][BH⁺] / [B]<br>
                                • Ka × Kb = Kw = 1.0 × 10⁻¹⁴ (at 25°C)<br>
                                • pKa = -log(Ka), pKb = -log(Kb)<br>
                                • pKa + pKb = 14 (at 25°C)
                            </div>

                            <button class="btn btn-primary" onclick="calculateKaKb()">
                                <i class="fas fa-calculator"></i> Calculate
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearKaKb()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 4: ICE Table Solver -->
                        <div class="tab-pane fade" id="ice" role="tabpanel">
                            <h4>ICE Table Solver</h4>
                            <p>ICE = Initial, Change, Equilibrium</p>

                            <div class="form-group">
                                <label>Reaction</label>
                                <input type="text" class="form-control" id="iceReaction" placeholder="e.g., A + B ⇌ C">
                            </div>

                            <div class="form-group">
                                <label>Equilibrium Constant (K)</label>
                                <input type="number" step="any" class="form-control" id="iceK" placeholder="Enter K value">
                            </div>

                            <div class="form-group">
                                <label>Common ICE Table Examples (Click to load)</label>
                                <div>
                                    <span class="example-reaction" onclick="setICEExample('H2 + I2 ⇌ 2HI', 50, 1.0, 1.0, 0)">H₂ + I₂ ⇌ 2HI</span>
                                    <span class="example-reaction" onclick="setICEExample('N2O4 ⇌ 2NO2', 0.36, 0.5, 0, 0)">N₂O₄ ⇌ 2NO₂</span>
                                    <span class="example-reaction" onclick="setICEExample('PCl5 ⇌ PCl3 + Cl2', 0.042, 0.5, 0, 0)">PCl₅ dissociation</span>
                                    <span class="example-reaction" onclick="setICEExample('CO + H2O ⇌ CO2 + H2', 5.0, 1.0, 1.0, 0)">Water-gas shift</span>
                                    <span class="example-reaction" onclick="setICEExample('CH3COOH ⇌ H+ + CH3COO-', 1.8e-5, 0.1, 0, 0)">Acetic acid dissociation</span>
                                    <span class="example-reaction" onclick="setICEExample('NH3 + H2O ⇌ NH4+ + OH-', 1.8e-5, 0.15, 0, 0)">Ammonia in water</span>
                                </div>
                            </div>

                            <h6 class="mt-3">ICE Table</h6>
                            <table class="ice-table">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>Reactant A</th>
                                        <th>Reactant B</th>
                                        <th>Product C</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <th>Initial (M)</th>
                                        <td><input type="number" step="any" id="iceIA" placeholder="0"></td>
                                        <td><input type="number" step="any" id="iceIB" placeholder="0"></td>
                                        <td><input type="number" step="any" id="iceIC" placeholder="0"></td>
                                    </tr>
                                    <tr>
                                        <th>Change (M)</th>
                                        <td><input type="text" id="iceCA" placeholder="-x" readonly style="background:#f8f9fa;"></td>
                                        <td><input type="text" id="iceCB" placeholder="-x" readonly style="background:#f8f9fa;"></td>
                                        <td><input type="text" id="iceCC" placeholder="+x" readonly style="background:#f8f9fa;"></td>
                                    </tr>
                                    <tr>
                                        <th>Equilibrium (M)</th>
                                        <td><input type="text" id="iceEA" placeholder="I - C" readonly style="background:#e9ecef;"></td>
                                        <td><input type="text" id="iceEB" placeholder="I - C" readonly style="background:#e9ecef;"></td>
                                        <td><input type="text" id="iceEC" placeholder="I + C" readonly style="background:#e9ecef;"></td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="alert alert-info mt-3">
                                <strong>Instructions:</strong><br>
                                1. Enter initial concentrations<br>
                                2. Click Solve to find equilibrium concentrations<br>
                                3. The solver will determine 'x' from the equilibrium expression
                            </div>

                            <button class="btn btn-primary" onclick="solveICE()">
                                <i class="fas fa-calculator"></i> Solve ICE Table
                            </button>
                            <button class="btn btn-outline-secondary ml-2" onclick="clearICE()">
                                <i class="fas fa-eraser"></i> Clear
                            </button>
                        </div>

                        <!-- Tab 5: Learn -->
                        <div class="tab-pane fade" id="learn" role="tabpanel">
                            <div class="learn-section">
                                <h5><i class="fas fa-book-open"></i> Understanding Equilibrium Constants</h5>

                                <h6>What is Chemical Equilibrium?</h6>
                                <p>Chemical equilibrium occurs when the forward and reverse reaction rates are equal, resulting in constant concentrations of reactants and products.</p>

                                <h6>Types of Equilibrium Constants</h6>

                                <div class="formula-box">
                                    <strong>Kc (Concentration Equilibrium Constant)</strong><br>
                                    For: aA + bB ⇌ cC + dD<br>
                                    Kc = [C]^c [D]^d / [A]^a [B]^b
                                </div>

                                <div class="formula-box">
                                    <strong>Kp (Pressure Equilibrium Constant)</strong><br>
                                    Kp = (P_C)^c (P_D)^d / (P_A)^a (P_B)^b<br>
                                    Relationship: Kp = Kc(RT)^Δn
                                </div>

                                <div class="formula-box">
                                    <strong>Ka (Acid Dissociation Constant)</strong><br>
                                    For: HA ⇌ H⁺ + A⁻<br>
                                    Ka = [H⁺][A⁻] / [HA]
                                </div>

                                <div class="formula-box">
                                    <strong>Kb (Base Dissociation Constant)</strong><br>
                                    For: B + H₂O ⇌ BH⁺ + OH⁻<br>
                                    Kb = [BH⁺][OH⁻] / [B]
                                </div>

                                <h6>Interpreting K Values</h6>
                                <ul>
                                    <li><strong>K &gt;&gt; 1:</strong> Products favored at equilibrium (reaction goes nearly to completion)</li>
                                    <li><strong>K ≈ 1:</strong> Significant amounts of both reactants and products</li>
                                    <li><strong>K &lt;&lt; 1:</strong> Reactants favored at equilibrium (little product formed)</li>
                                </ul>

                                <h6>Reaction Quotient (Q)</h6>
                                <p>Q has the same form as K but uses current concentrations (not equilibrium values):</p>
                                <ul>
                                    <li><strong>Q &lt; K:</strong> Reaction proceeds forward (toward products)</li>
                                    <li><strong>Q = K:</strong> System at equilibrium</li>
                                    <li><strong>Q &gt; K:</strong> Reaction proceeds backward (toward reactants)</li>
                                </ul>

                                <h6>ICE Table Method</h6>
                                <p><strong>I</strong>nitial, <strong>C</strong>hange, <strong>E</strong>quilibrium - A systematic way to track concentrations:</p>
                                <ol>
                                    <li>Write initial concentrations</li>
                                    <li>Define change in terms of x (stoichiometry matters!)</li>
                                    <li>Write equilibrium concentrations as (Initial ± Change)</li>
                                    <li>Substitute into K expression and solve for x</li>
                                    <li>Calculate final equilibrium concentrations</li>
                                </ol>

                                <h6>Le Chatelier's Principle</h6>
                                <p>When a system at equilibrium is disturbed, it shifts to counteract the disturbance:</p>
                                <ul>
                                    <li><strong>Add reactant:</strong> Shifts toward products</li>
                                    <li><strong>Add product:</strong> Shifts toward reactants</li>
                                    <li><strong>Increase temperature:</strong> Shifts in endothermic direction</li>
                                    <li><strong>Increase pressure:</strong> Shifts toward fewer moles of gas</li>
                                </ul>

                                <h6>Common Equilibrium Constant Values</h6>
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th>Compound</th>
                                            <th>Type</th>
                                            <th>Value (25°C)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr><td>Acetic acid (CH₃COOH)</td><td>Ka</td><td>1.8 × 10⁻⁵</td></tr>
                                        <tr><td>Hydrofluoric acid (HF)</td><td>Ka</td><td>6.8 × 10⁻⁴</td></tr>
                                        <tr><td>Ammonia (NH₃)</td><td>Kb</td><td>1.8 × 10⁻⁵</td></tr>
                                        <tr><td>Water (H₂O)</td><td>Kw</td><td>1.0 × 10⁻¹⁴</td></tr>
                                    </tbody>
                                </table>
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
                                    Select a calculator type and enter values to see results
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

<%--                    <%@ include file="chem-menu-nav.jsp"%>--%>
                </div>
            </div>
        </div>
    </div>

    <script>
        let currentResult = '';
        let parsedEquation = null;

        // Chemical equation parser - supports multiple arrow formats
        function parseChemicalEquation(equation) {
            // Normalize the equation - support multiple arrow formats
            // ⇌, <=>, <-->, ==, =
            equation = equation.replace(/⇌|<=>|<-->|==|=/g, '→');

            // Split into reactants and products
            const parts = equation.split('→');
            if (parts.length !== 2) {
                return null;
            }

            const reactantsStr = parts[0].trim();
            const productsStr = parts[1].trim();

            // Parse species with coefficients
            function parseSpecies(speciesStr) {
                const species = [];
                // Match coefficient (optional) + formula
                // e.g., "2H2", "H2O", "3Fe2O3", "NH3"
                const regex = /(\d*\.?\d+)?\s*([A-Z][a-z]?\d*(?:\([^)]+\)\d*)*)+/g;
                let match;

                while ((match = regex.exec(speciesStr)) !== null) {
                    const coefficient = match[1] ? parseFloat(match[1]) : 1;
                    const formula = match[2] ? match[2].trim() : '';

                    if (formula) {
                        species.push({
                            coefficient: coefficient,
                            formula: formula
                        });
                    }
                }

                return species;
            }

            const reactants = parseSpecies(reactantsStr);
            const products = parseSpecies(productsStr);

            if (reactants.length === 0 || products.length === 0) {
                return null;
            }

            return {
                reactants: reactants,
                products: products,
                reactantsStr: reactantsStr,
                productsStr: productsStr,
                original: equation.replace('→', ' ⇌ ')
            };
        }

        // Display parsed equation info
        function displayParsedEquation(parsed) {
            if (!parsed) return '';

            let html = '<div class="alert alert-success mt-2"><strong>Parsed Equation:</strong><br>';
            html += '<strong>Reactants:</strong> ';
            html += parsed.reactants.map(r => `${r.coefficient !== 1 ? r.coefficient : ''}${r.formula}`).join(' + ');
            html += '<br><strong>Products:</strong> ';
            html += parsed.products.map(p => `${p.coefficient !== 1 ? p.coefficient : ''}${p.formula}`).join(' + ');
            html += '</div>';

            return html;
        }

        // Calculate Kc with coefficients from parsed equation
        function calculateKcWithCoefficients(parsed, concentrations) {
            const { reactants, products } = parsed;

            // Kc = [products]^coeff / [reactants]^coeff
            let numerator = 1;
            let denominator = 1;

            products.forEach((p, index) => {
                const conc = concentrations.products[index] || 0;
                numerator *= Math.pow(conc, p.coefficient);
            });

            reactants.forEach((r, index) => {
                const conc = concentrations.reactants[index] || 0;
                denominator *= Math.pow(conc, r.coefficient);
            });

            return numerator / denominator;
        }

        // Show/hide sections based on selection
        document.getElementById('kpCalcType').addEventListener('change', function() {
            const type = this.value;
            if (type === 'calculateKp') {
                document.getElementById('kpPressures').style.display = 'block';
                document.getElementById('kpConversion').style.display = 'none';
            } else {
                document.getElementById('kpPressures').style.display = 'none';
                document.getElementById('kpConversion').style.display = 'block';
            }
        });

        // Parse chemical equation when user enters it
        document.getElementById('kcReaction').addEventListener('blur', function() {
            const equation = this.value.trim();
            if (equation) {
                const parsed = parseChemicalEquation(equation);
                if (parsed) {
                    parsedEquation = parsed;
                    document.getElementById('equationParse').innerHTML = displayParsedEquation(parsed);
                    document.getElementById('equationParse').style.display = 'block';
                } else {
                    document.getElementById('equationParse').style.display = 'none';
                }
            } else {
                document.getElementById('equationParse').style.display = 'none';
            }
        });

        // Calculate Kc
        function calculateKc() {
            const reaction = document.getElementById('kcReaction').value.trim();
            const type = document.getElementById('kcCalcType').value;

            if (!reaction) {
                alert('Please enter a chemical reaction');
                return;
            }

            // Parse equation to get coefficients
            const parsed = parsedEquation || parseChemicalEquation(reaction);
            if (!parsed) {
                alert('Unable to parse chemical equation. Please check the format.');
                return;
            }

            // Collect concentrations for reactants and products
            const r1 = parseFloat(document.getElementById('kcR1').value) || 0;
            const r2 = parseFloat(document.getElementById('kcR2').value) || 0;
            const p1 = parseFloat(document.getElementById('kcP1').value) || 0;
            const p2 = parseFloat(document.getElementById('kcP2').value) || 0;

            const reactantConcs = [r1, r2].filter(c => c > 0);
            const productConcs = [p1, p2].filter(c => c > 0);

            if (reactantConcs.length === 0 || productConcs.length === 0) {
                alert('Please enter at least one reactant and one product concentration');
                return;
            }

            // Calculate Kc using coefficients from parsed equation
            let numerator = 1;
            let denominator = 1;
            let numeratorFormula = [];
            let denominatorFormula = [];

            // Products in numerator
            parsed.products.forEach((prod, i) => {
                const conc = i === 0 ? p1 : p2;
                if (conc > 0) {
                    numerator *= Math.pow(conc, prod.coefficient);
                    if (prod.coefficient === 1) {
                        numeratorFormula.push(`[${prod.formula}]`);
                    } else {
                        numeratorFormula.push(`[${prod.formula}]^${prod.coefficient}`);
                    }
                }
            });

            // Reactants in denominator
            parsed.reactants.forEach((react, i) => {
                const conc = i === 0 ? r1 : r2;
                if (conc > 0) {
                    denominator *= Math.pow(conc, react.coefficient);
                    if (react.coefficient === 1) {
                        denominatorFormula.push(`[${react.formula}]`);
                    } else {
                        denominatorFormula.push(`[${react.formula}]^${react.coefficient}`);
                    }
                }
            });

            const kc = numerator / denominator;

            // Build result HTML
            let concDisplay = '';
            parsed.reactants.forEach((react, i) => {
                const conc = i === 0 ? r1 : r2;
                if (conc > 0) {
                    concDisplay += `
                        <div class="equilibrium-info-item">
                            <strong>[${react.formula}]${react.coefficient > 1 ? '^' + react.coefficient : ''}</strong>
                            <span>${conc.toExponential(3)} M</span>
                        </div>`;
                }
            });
            parsed.products.forEach((prod, i) => {
                const conc = i === 0 ? p1 : p2;
                if (conc > 0) {
                    concDisplay += `
                        <div class="equilibrium-info-item">
                            <strong>[${prod.formula}]${prod.coefficient > 1 ? '^' + prod.coefficient : ''}</strong>
                            <span>${conc.toExponential(3)} M</span>
                        </div>`;
                }
            });

            let resultHTML = `
                <div class="result-section">
                    <h6><strong>Reaction:</strong></h6>
                    <div class="reaction-display">${reaction}</div>

                    <div class="equilibrium-info">
                        ${concDisplay}
                    </div>

                    <div class="result-label">Equilibrium Constant (Kc):</div>
                    <div class="result-value">
                        <span class="k-badge">Kc = ${kc.toExponential(4)}</span>
                    </div>

                    <div class="result-label">Interpretation:</div>
                    <div class="result-value">
                        ${kc > 100 ? 'Products strongly favored (Kc ≫ 1)' :
                          kc > 1 ? 'Products favored (Kc > 1)' :
                          kc > 0.01 ? 'Significant amounts of both reactants and products (Kc ≈ 1)' :
                          kc > 0.001 ? 'Reactants favored (Kc < 1)' :
                          'Reactants strongly favored (Kc ≪ 1)'}
                    </div>

                    <div class="alert alert-info mt-3">
                        <strong>Formula Used:</strong><br>
                        Kc = ${numeratorFormula.join(' × ')} / ${denominatorFormula.join(' × ')}<br>
                        <small>Kc = ${kc.toExponential(4)}</small>
                    </div>
                </div>
            `;

            currentResult = resultHTML;
            document.getElementById('resultDisplay').innerHTML = resultHTML;
            document.getElementById('actionButtons').style.display = 'block';
        }

        // Calculate Kp
        function calculateKp() {
            const type = document.getElementById('kpCalcType').value;

            if (type === 'calculateKp') {
                const r1 = parseFloat(document.getElementById('kpR1').value) || 0;
                const r2 = parseFloat(document.getElementById('kpR2').value) || 1;
                const p1 = parseFloat(document.getElementById('kpP1').value) || 0;
                const p2 = parseFloat(document.getElementById('kpP2').value) || 1;

                if (r1 === 0 || p1 === 0) {
                    alert('Please enter at least one reactant and one product pressure');
                    return;
                }

                const kp = (p1 * p2) / (r1 * r2);

                let resultHTML = `
                    <div class="result-section">
                        <h6><strong>Kp Calculation from Partial Pressures</strong></h6>

                        <div class="equilibrium-info">
                            <div class="equilibrium-info-item">
                                <strong>Reactant 1</strong>
                                <span>${r1.toFixed(4)} atm</span>
                            </div>
                            ${r2 !== 1 ? `<div class="equilibrium-info-item">
                                <strong>Reactant 2</strong>
                                <span>${r2.toFixed(4)} atm</span>
                            </div>` : ''}
                            <div class="equilibrium-info-item">
                                <strong>Product 1</strong>
                                <span>${p1.toFixed(4)} atm</span>
                            </div>
                            ${p2 !== 1 ? `<div class="equilibrium-info-item">
                                <strong>Product 2</strong>
                                <span>${p2.toFixed(4)} atm</span>
                            </div>` : ''}
                        </div>

                        <div class="result-label">Equilibrium Constant (Kp):</div>
                        <div class="result-value">
                            <span class="k-badge">Kp = ${kp.toExponential(4)}</span>
                        </div>

                        <div class="alert alert-info mt-3">
                            <strong>Formula:</strong> Kp = [products] / [reactants]<br>
                            Kp = (${p1} × ${p2}) / (${r1} × ${r2}) = ${kp.toExponential(4)}
                        </div>
                    </div>
                `;

                currentResult = resultHTML;
                document.getElementById('resultDisplay').innerHTML = resultHTML;
                document.getElementById('actionButtons').style.display = 'block';

            } else if (type === 'convertKcToKp' || type === 'convertKpToKc') {
                const knownValue = parseFloat(document.getElementById('kpKnownValue').value);
                const temp = parseFloat(document.getElementById('kpTemp').value);
                const deltaN = parseFloat(document.getElementById('kpDeltaN').value);
                const R = 0.0821; // L·atm/(mol·K)

                if (!knownValue || !temp || isNaN(deltaN)) {
                    alert('Please enter all required values');
                    return;
                }

                let result, resultType, formula;
                if (type === 'convertKcToKp') {
                    result = knownValue * Math.pow(R * temp, deltaN);
                    resultType = 'Kp';
                    formula = `Kp = Kc(RT)^Δn = ${knownValue} × (${R} × ${temp})^${deltaN}`;
                } else {
                    result = knownValue / Math.pow(R * temp, deltaN);
                    resultType = 'Kc';
                    formula = `Kc = Kp / (RT)^Δn = ${knownValue} / (${R} × ${temp})^${deltaN}`;
                }

                let resultHTML = `
                    <div class="result-section">
                        <h6><strong>${type === 'convertKcToKp' ? 'Kc → Kp Conversion' : 'Kp → Kc Conversion'}</strong></h6>

                        <div class="equilibrium-info">
                            <div class="equilibrium-info-item">
                                <strong>Given</strong>
                                <span>${type === 'convertKcToKp' ? 'Kc' : 'Kp'} = ${knownValue.toExponential(3)}</span>
                            </div>
                            <div class="equilibrium-info-item">
                                <strong>Temperature</strong>
                                <span>${temp} K</span>
                            </div>
                            <div class="equilibrium-info-item">
                                <strong>Δn</strong>
                                <span>${deltaN}</span>
                            </div>
                        </div>

                        <div class="result-label">Result (${resultType}):</div>
                        <div class="result-value">
                            <span class="k-badge">${resultType} = ${result.toExponential(4)}</span>
                        </div>

                        <div class="alert alert-info mt-3">
                            <strong>Formula:</strong><br>
                            ${formula}<br>
                            <strong>Result:</strong> ${resultType} = ${result.toExponential(4)}
                        </div>
                    </div>
                `;

                currentResult = resultHTML;
                document.getElementById('resultDisplay').innerHTML = resultHTML;
                document.getElementById('actionButtons').style.display = 'block';
            }
        }

        // Calculate Ka/Kb
        function calculateKaKb() {
            const type = document.getElementById('kaKbType').value;
            const formula = document.getElementById('kaKbFormula').value.trim();
            const ion = parseFloat(document.getElementById('kaKbIon').value);
            const conc = parseFloat(document.getElementById('kaKbConc').value);

            if (!formula) {
                alert('Please enter acid/base formula');
                return;
            }

            if (type === 'calculateKa' || type === 'calculateKb') {
                if (!ion || !conc) {
                    alert('Please enter ion concentration and acid/base concentration');
                    return;
                }

                const K = (ion * ion) / (conc - ion);
                const pK = -Math.log10(K);
                const constType = type === 'calculateKa' ? 'Ka' : 'Kb';
                const pConstType = type === 'calculateKa' ? 'pKa' : 'pKb';

                let resultHTML = `
                    <div class="result-section">
                        <h6><strong>${type === 'calculateKa' ? 'Weak Acid' : 'Weak Base'}: ${formula}</strong></h6>

                        <div class="equilibrium-info">
                            <div class="equilibrium-info-item">
                                <strong>${type === 'calculateKa' ? '[H⁺]' : '[OH⁻]'}</strong>
                                <span>${ion.toExponential(3)} M</span>
                            </div>
                            <div class="equilibrium-info-item">
                                <strong>[${formula}]</strong>
                                <span>${conc.toExponential(3)} M</span>
                            </div>
                        </div>

                        <div class="result-label">${constType}:</div>
                        <div class="result-value">
                            <span class="k-badge">${constType} = ${K.toExponential(3)}</span>
                        </div>

                        <div class="result-label">${pConstType}:</div>
                        <div class="result-value">
                            <span class="k-badge">${pConstType} = ${pK.toFixed(2)}</span>
                        </div>

                        <div class="alert alert-info mt-3">
                            <strong>Formula:</strong> ${constType} = [ion]² / [${formula}]<br>
                            ${constType} = (${ion})² / (${conc} - ${ion})<br>
                            ${constType} = ${K.toExponential(3)}<br>
                            ${pConstType} = -log(${constType}) = ${pK.toFixed(2)}
                        </div>
                    </div>
                `;

                currentResult = resultHTML;
                document.getElementById('resultDisplay').innerHTML = resultHTML;
                document.getElementById('actionButtons').style.display = 'block';

            } else if (type === 'pHfromKa' || type === 'pOHfromKb') {
                if (!ion || !conc) {
                    alert('Please enter Ka/Kb and concentration');
                    return;
                }

                // Assume ion is Ka/Kb value, conc is initial concentration
                const Ka = ion;
                const C = conc;
                const H = Math.sqrt(Ka * C); // Approximation for weak acid
                const pH = -Math.log10(H);
                const pOH = 14 - pH;

                let resultHTML = `
                    <div class="result-section">
                        <h6><strong>${type === 'pHfromKa' ? 'pH' : 'pOH'} Calculation: ${formula}</strong></h6>

                        <div class="equilibrium-info">
                            <div class="equilibrium-info-item">
                                <strong>${type === 'pHfromKa' ? 'Ka' : 'Kb'}</strong>
                                <span>${Ka.toExponential(3)}</span>
                            </div>
                            <div class="equilibrium-info-item">
                                <strong>Concentration</strong>
                                <span>${C.toFixed(4)} M</span>
                            </div>
                            <div class="equilibrium-info-item">
                                <strong>[H⁺]</strong>
                                <span>${H.toExponential(3)} M</span>
                            </div>
                        </div>

                        <div class="result-label">pH:</div>
                        <div class="result-value">
                            <span class="k-badge">pH = ${pH.toFixed(2)}</span>
                        </div>

                        <div class="result-label">pOH:</div>
                        <div class="result-value">
                            <span class="k-badge">pOH = ${pOH.toFixed(2)}</span>
                        </div>

                        <div class="alert alert-info mt-3">
                            <strong>Approximation:</strong> [H⁺] = √(Ka × C)<br>
                            [H⁺] = √(${Ka.toExponential(3)} × ${C}) = ${H.toExponential(3)}<br>
                            pH = -log[H⁺] = ${pH.toFixed(2)}
                        </div>
                    </div>
                `;

                currentResult = resultHTML;
                document.getElementById('resultDisplay').innerHTML = resultHTML;
                document.getElementById('actionButtons').style.display = 'block';
            }
        }

        // Solve ICE Table
        function solveICE() {
            const reaction = document.getElementById('iceReaction').value.trim();
            const K = parseFloat(document.getElementById('iceK').value);
            const IA = parseFloat(document.getElementById('iceIA').value) || 0;
            const IB = parseFloat(document.getElementById('iceIB').value) || 0;
            const IC = parseFloat(document.getElementById('iceIC').value) || 0;

            if (!reaction || !K) {
                alert('Please enter reaction and K value');
                return;
            }

            // Simple approximation: assume x is small compared to initial concentrations
            // For A + B ⇌ C: K = [C] / ([A][B])
            // If initial [C] = 0: K = x / (IA-x)(IB-x) ≈ x / (IA × IB)
            // Solving: x ≈ K × IA × IB (very simplified)

            let x;
            if (IC === 0) {
                // Products forming from reactants
                x = Math.sqrt(K * IA * IB) / (1 + K);
            } else {
                // More complex case
                x = K * IA * IB / (1 + K);
            }

            const EA = IA - x;
            const EB = IB - x;
            const EC = IC + x;

            document.getElementById('iceCA').value = `-${x.toExponential(2)}`;
            document.getElementById('iceCB').value = `-${x.toExponential(2)}`;
            document.getElementById('iceCC').value = `+${x.toExponential(2)}`;
            document.getElementById('iceEA').value = EA.toExponential(3);
            document.getElementById('iceEB').value = EB.toExponential(3);
            document.getElementById('iceEC').value = EC.toExponential(3);

            let resultHTML = `
                <div class="result-section">
                    <h6><strong>ICE Table Solution</strong></h6>
                    <div class="reaction-display">${reaction}</div>

                    <div class="result-label">Equilibrium Concentrations:</div>
                    <div class="equilibrium-info">
                        <div class="equilibrium-info-item">
                            <strong>Reactant A</strong>
                            <span>${EA.toExponential(3)} M</span>
                        </div>
                        <div class="equilibrium-info-item">
                            <strong>Reactant B</strong>
                            <span>${EB.toExponential(3)} M</span>
                        </div>
                        <div class="equilibrium-info-item">
                            <strong>Product C</strong>
                            <span>${EC.toExponential(3)} M</span>
                        </div>
                    </div>

                    <div class="result-label">Change (x):</div>
                    <div class="result-value">
                        x = ${x.toExponential(3)} M
                    </div>

                    <div class="alert alert-info mt-3">
                        <strong>Note:</strong> This is a simplified calculation.<br>
                        For precise results, use quadratic formula when x is significant.
                    </div>
                </div>
            `;

            currentResult = resultHTML;
            document.getElementById('resultDisplay').innerHTML = resultHTML;
            document.getElementById('actionButtons').style.display = 'block';
        }

        // Set examples
        function setKcExample(reaction) {
            document.getElementById('kcReaction').value = reaction;

            // Parse and display the equation
            const parsed = parseChemicalEquation(reaction);
            if (parsed) {
                parsedEquation = parsed;
                document.getElementById('equationParse').innerHTML = displayParsedEquation(parsed);
                document.getElementById('equationParse').style.display = 'block';

                // Log parsed structure for debugging
                console.log('Parsed:', parsed.reactants.length, 'reactants,', parsed.products.length, 'products');
            }
        }

        function setKaKbExample(formula, value, type) {
            document.getElementById('kaKbFormula').value = formula;
            document.getElementById('kaKbType').value = type === 'Ka' ? 'calculateKa' : 'calculateKb';
            document.getElementById('kaKbIon').placeholder = `${type} = ${value}`;
        }

        function setICEExample(reaction, K, iA, iB, iC) {
            document.getElementById('iceReaction').value = reaction;
            document.getElementById('iceK').value = K;
            document.getElementById('iceIA').value = iA;
            document.getElementById('iceIB').value = iB;
            document.getElementById('iceIC').value = iC;
        }

        // Clear functions
        function clearKc() {
            document.getElementById('kcReaction').value = '';
            document.getElementById('kcR1').value = '';
            document.getElementById('kcR2').value = '';
            document.getElementById('kcP1').value = '';
            document.getElementById('kcP2').value = '';
            document.getElementById('equationParse').style.display = 'none';
            document.getElementById('equationParse').innerHTML = '';
            parsedEquation = null;
            document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter values and click Calculate</p>';
            document.getElementById('actionButtons').style.display = 'none';
        }

        function clearKp() {
            document.getElementById('kpR1').value = '';
            document.getElementById('kpR2').value = '';
            document.getElementById('kpP1').value = '';
            document.getElementById('kpP2').value = '';
            document.getElementById('kpKnownValue').value = '';
            document.getElementById('kpTemp').value = '';
            document.getElementById('kpDeltaN').value = '';
            document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter values and click Calculate</p>';
            document.getElementById('actionButtons').style.display = 'none';
        }

        function clearKaKb() {
            document.getElementById('kaKbFormula').value = '';
            document.getElementById('kaKbIon').value = '';
            document.getElementById('kaKbConc').value = '';
            document.getElementById('resultDisplay').innerHTML = '<p class="text-muted text-center"><i class="fas fa-info-circle fa-2x mb-2"></i><br>Enter values and click Calculate</p>';
            document.getElementById('actionButtons').style.display = 'none';
        }

        function clearICE() {
            document.getElementById('iceReaction').value = '';
            document.getElementById('iceK').value = '';
            document.getElementById('iceIA').value = '';
            document.getElementById('iceIB').value = '';
            document.getElementById('iceIC').value = '';
            document.getElementById('iceCA').value = '';
            document.getElementById('iceCB').value = '';
            document.getElementById('iceCC').value = '';
            document.getElementById('iceEA').value = '';
            document.getElementById('iceEB').value = '';
            document.getElementById('iceEC').value = '';
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
            const reaction = document.getElementById('kcReaction').value.trim();

            if (!reaction) {
                alert('Please enter a chemical reaction first!');
                return;
            }

            // Collect all input values
            const params = new URLSearchParams();
            params.set('reaction', reaction);

            const r1 = document.getElementById('kcR1').value;
            const r2 = document.getElementById('kcR2').value;
            const p1 = document.getElementById('kcP1').value;
            const p2 = document.getElementById('kcP2').value;

            if (r1) params.set('r1', r1);
            if (r2) params.set('r2', r2);
            if (p1) params.set('p1', p1);
            if (p2) params.set('p2', p2);

            // Create URL with parameters
            const baseURL = window.location.origin + window.location.pathname;
            const shareableURL = `${baseURL}?${params.toString()}`;

            // Display the shareable URL
            document.getElementById('shareURLInput').value = shareableURL;
            document.getElementById('shareURLDisplay').style.display = 'block';

            // Scroll to show the URL
            setTimeout(() => {
                document.getElementById('shareURLDisplay').scrollIntoView({behavior: 'smooth', block: 'nearest'});
            }, 100);
        }

        // Copy shareable URL to clipboard
        function copyShareURL() {
            const urlInput = document.getElementById('shareURLInput');
            urlInput.select();
            urlInput.setSelectionRange(0, 99999); // For mobile devices

            navigator.clipboard.writeText(urlInput.value).then(() => {
                // Visual feedback
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
                // Fallback for older browsers
                document.execCommand('copy');
                alert('URL copied to clipboard!');
            });
        }

        // Load parameters from URL on page load
        window.addEventListener('DOMContentLoaded', function() {
            const params = new URLSearchParams(window.location.search);

            if (params.has('reaction')) {
                document.getElementById('kcReaction').value = params.get('reaction');

                // Parse the equation
                const parsed = parseChemicalEquation(params.get('reaction'));
                if (parsed) {
                    parsedEquation = parsed;
                    document.getElementById('equationParse').innerHTML = displayParsedEquation(parsed);
                    document.getElementById('equationParse').style.display = 'block';
                }
            }

            if (params.has('r1')) document.getElementById('kcR1').value = params.get('r1');
            if (params.has('r2')) document.getElementById('kcR2').value = params.get('r2');
            if (params.has('p1')) document.getElementById('kcP1').value = params.get('p1');
            if (params.has('p2')) document.getElementById('kcP2').value = params.get('p2');

            // Auto-calculate if all parameters are present
            if (params.has('reaction') && params.has('r1') && params.has('p1')) {
                calculateKc();
            }
        });

        // Export PDF (placeholder)
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
