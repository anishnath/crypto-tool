<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Redox Reaction Balancer - Balance Oxidation-Reduction Equations</title>
    <meta name="description" content="Free redox reaction balancer using half-reaction method. Balance oxidation-reduction equations in acidic or basic medium. Calculate oxidation numbers and identify oxidizing/reducing agents.">
    <meta name="keywords" content="redox balancer, redox equation balancer, half-reaction method, oxidation number calculator, oxidizing agent, reducing agent, chemistry calculator">

    <!-- Open Graph tags -->
    <meta property="og:title" content="Redox Reaction Balancer - Half-Reaction Method">
    <meta property="og:description" content="Balance oxidation-reduction equations using the half-reaction method. Supports acidic and basic solutions. Calculate oxidation numbers and identify redox agents.">
    <meta property="og:type" content="website">

    <!-- Schema.org structured data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Redox Reaction Balancer",
        "description": "Balance oxidation-reduction equations using the half-reaction method in acidic or basic medium. Calculate oxidation numbers and split equations into half-reactions.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Redox equation balancing, Half-reaction method, Oxidation number calculator, Acidic and basic medium support, Oxidizing and reducing agent identification, Step-by-step solutions",
        "audience": {
            "@type": "EducationalAudience",
            "educationalRole": "student"
        },
        "educationalLevel": "High School, College",
        "creator": {
            "@type": "Organization",
            "name": "8gwifi.org"
        }
    }
    </script>

<%--    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">--%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        .card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
        }

        .card-header {
            background-color: #fff;
            border-bottom: 2px solid #e0e0e0;
            font-weight: 600;
        }

        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }

        .example-reaction {
            display: inline-block;
            margin: 4px;
            padding: 6px 12px;
            background: #f3f4f6;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.2s;
        }

        .example-reaction:hover {
            background: #e5e7eb;
            border-color: #9ca3af;
        }

        .oxidation-badge {
            background: #dc2626;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .reduction-badge {
            background: #2563eb;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .balanced-badge {
            background: #059669;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .step-badge {
            background: #8b5cf6;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .result-section {
            background: #f9fafb;
            border-left: 4px solid #3b82f6;
            padding: 15px;
            margin-top: 15px;
            border-radius: 4px;
        }

        .step-section {
            background: #fff;
            border: 1px solid #e5e7eb;
            padding: 12px;
            margin-top: 10px;
            border-radius: 4px;
        }

        .half-reaction-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            padding: 12px;
            margin: 10px 0;
            border-radius: 4px;
        }

        .sticky-side {
            position: sticky;
            top: 80px;
            max-height: calc(100vh - 100px);
            overflow-y: auto;
        }

        .min-h-result {
            min-height: 200px;
        }

        .nav-tabs .nav-link {
            color: #6b7280;
        }

        .nav-tabs .nav-link.active {
            color: #007bff;
            font-weight: 600;
        }

        .example-category {
            font-weight: 600;
            color: #374151;
            margin-top: 15px;
            margin-bottom: 8px;
            padding: 6px 0;
            border-bottom: 2px solid #e5e7eb;
        }

        .equation-display {
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
            background: #f3f4f6;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }

        .ox-number {
            color: #dc2626;
            font-weight: 600;
        }

        .info-box {
            background: #eff6ff;
            border-left: 4px solid #3b82f6;
            padding: 12px;
            margin: 10px 0;
            border-radius: 4px;
        }

        .warning-box {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 12px;
            margin: 10px 0;
            border-radius: 4px;
        }

        sub {
            font-size: 0.75em;
        }

        sup {
            font-size: 0.75em;
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="mb-3">Redox Reaction Balancer</h1>
    <p class="lead mb-4">
        Balance oxidation-reduction equations using the half-reaction method. Supports acidic and basic solutions.
    </p>

    <div class="row">
        <!-- Left Column - Input Forms -->
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" id="calculatorTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="balance-tab" data-toggle="tab" href="#balanceTab" role="tab">
                                <i class="fas fa-balance-scale"></i> Balance Equation
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="oxidation-tab" data-toggle="tab" href="#oxidationTab" role="tab">
                                <i class="fas fa-atom"></i> Oxidation Numbers
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="half-tab" data-toggle="tab" href="#halfTab" role="tab">
                                <i class="fas fa-cut"></i> Half-Reactions
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Balance Equation Tab -->
                        <div class="tab-pane fade show active" id="balanceTab" role="tabpanel">
                            <h5 class="mb-3">Balance Redox Equation</h5>
                            <p class="text-muted small">Enter the unbalanced redox equation and select the medium.</p>

                            <div class="form-group">
                                <label><strong>Unbalanced Equation</strong></label>
                                <input type="text" class="form-control" id="balanceEquation" placeholder="e.g., MnO4- + Fe2+ → Mn2+ + Fe3+">
                                <small class="form-text text-muted">Use + for plus, → or = for arrow. Charges: Fe2+ or Fe^2+</small>
                            </div>

                            <div class="form-group">
                                <label><strong>Solution Medium</strong></label>
                                <select class="form-control" id="balanceMedium">
                                    <option value="acidic">Acidic (H⁺/H₂O available)</option>
                                    <option value="basic">Basic (OH⁻/H₂O available)</option>
                                    <option value="neutral">Neutral</option>
                                </select>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="balanceRedoxEquation()">
                                <i class="fas fa-balance-scale"></i> Balance Equation
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Reactions:</h6>

                                <div class="example-category">⭐ Easy - Acidic Medium</div>
                                <span class="example-reaction" onclick="setBalanceExample('MnO4- + Fe2+ = Mn2+ + Fe3+', 'acidic')">MnO₄⁻ + Fe²⁺ → Mn²⁺ + Fe³⁺</span>
                                <span class="example-reaction" onclick="setBalanceExample('Cr2O7^2- + Fe2+ = Cr3+ + Fe3+', 'acidic')">Cr₂O₇²⁻ + Fe²⁺ → Cr³⁺ + Fe³⁺</span>
                                <span class="example-reaction" onclick="setBalanceExample('MnO4- + Cl- = Mn2+ + Cl2', 'acidic')">MnO₄⁻ + Cl⁻ → Mn²⁺ + Cl₂</span>
                                <span class="example-reaction" onclick="setBalanceExample('Cu + NO3- = Cu2+ + NO', 'acidic')">Cu + NO₃⁻ → Cu²⁺ + NO</span>

                                <div class="example-category">⭐⭐ Medium - Basic Medium</div>
                                <span class="example-reaction" onclick="setBalanceExample('MnO4- + I- = MnO2 + I2', 'basic')">MnO₄⁻ + I⁻ → MnO₂ + I₂</span>
                                <span class="example-reaction" onclick="setBalanceExample('Cr(OH)3 + ClO- = CrO4^2- + Cl-', 'basic')">Cr(OH)₃ + ClO⁻ → CrO₄²⁻ + Cl⁻</span>
                                <span class="example-reaction" onclick="setBalanceExample('Al + NO3- = AlO2- + NH3', 'basic')">Al + NO₃⁻ → AlO₂⁻ + NH₃</span>
                                <span class="example-reaction" onclick="setBalanceExample('Zn + NO3- = Zn(OH)4^2- + NH3', 'basic')">Zn + NO₃⁻ → Zn(OH)₄²⁻ + NH₃</span>

                                <div class="example-category">⭐⭐⭐ Hard - Complex Reactions</div>
                                <span class="example-reaction" onclick="setBalanceExample('Cr2O7^2- + C2H5OH = Cr3+ + CO2', 'acidic')">Cr₂O₇²⁻ + C₂H₅OH → Cr³⁺ + CO₂ (organic)</span>
                                <span class="example-reaction" onclick="setBalanceExample('MnO4- + H2O2 = Mn2+ + O2', 'acidic')">MnO₄⁻ + H₂O₂ → Mn²⁺ + O₂</span>
                                <span class="example-reaction" onclick="setBalanceExample('IO3- + I- = I2', 'acidic')">IO₃⁻ + I⁻ → I₂ (disproportionation)</span>
                                <span class="example-reaction" onclick="setBalanceExample('S2O3^2- + I2 = S4O6^2- + I-', 'neutral')">S₂O₃²⁻ + I₂ → S₄O₆²⁻ + I⁻</span>

                                <div class="example-category">⭐⭐⭐⭐ Very Hard - Industrial</div>
                                <span class="example-reaction" onclick="setBalanceExample('K2Cr2O7 + FeSO4 + H2SO4 = Cr2(SO4)3 + Fe2(SO4)3 + K2SO4 + H2O', 'acidic')">Dichromate titration (full)</span>
                                <span class="example-reaction" onclick="setBalanceExample('KMnO4 + H2C2O4 + H2SO4 = MnSO4 + CO2 + K2SO4 + H2O', 'acidic')">Permanganate with oxalic acid</span>
                                <span class="example-reaction" onclick="setBalanceExample('As2S3 + NO3- = H3AsO4 + S + NO', 'acidic')">As₂S₃ oxidation</span>
                            </div>
                        </div>

                        <!-- Oxidation Numbers Tab -->
                        <div class="tab-pane fade" id="oxidationTab" role="tabpanel">
                            <h5 class="mb-3">Calculate Oxidation Numbers</h5>
                            <p class="text-muted small">Determine oxidation numbers for all atoms in a compound or ion.</p>

                            <div class="form-group">
                                <label><strong>Chemical Formula</strong></label>
                                <input type="text" class="form-control" id="oxFormula" placeholder="e.g., H2SO4, MnO4-, Cr2O7^2-">
                                <small class="form-text text-muted">For ions, include charge: MnO4- or MnO4^-</small>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateOxidationNumbers()">
                                <i class="fas fa-calculator"></i> Calculate Oxidation Numbers
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Compounds:</h6>

                                <div class="example-category">⭐ Simple Compounds</div>
                                <span class="example-reaction" onclick="setOxExample('H2O')">H₂O</span>
                                <span class="example-reaction" onclick="setOxExample('H2SO4')">H₂SO₄</span>
                                <span class="example-reaction" onclick="setOxExample('NH3')">NH₃</span>
                                <span class="example-reaction" onclick="setOxExample('CO2')">CO₂</span>
                                <span class="example-reaction" onclick="setOxExample('NaCl')">NaCl</span>

                                <div class="example-category">⭐⭐ Polyatomic Ions</div>
                                <span class="example-reaction" onclick="setOxExample('MnO4-')">MnO₄⁻</span>
                                <span class="example-reaction" onclick="setOxExample('Cr2O7^2-')">Cr₂O₇²⁻</span>
                                <span class="example-reaction" onclick="setOxExample('SO4^2-')">SO₄²⁻</span>
                                <span class="example-reaction" onclick="setOxExample('NO3-')">NO₃⁻</span>
                                <span class="example-reaction" onclick="setOxExample('PO4^3-')">PO₄³⁻</span>

                                <div class="example-category">⭐⭐⭐ Complex Compounds</div>
                                <span class="example-reaction" onclick="setOxExample('K2Cr2O7')">K₂Cr₂O₇</span>
                                <span class="example-reaction" onclick="setOxExample('KMnO4')">KMnO₄</span>
                                <span class="example-reaction" onclick="setOxExample('H2O2')">H₂O₂ (peroxide)</span>
                                <span class="example-reaction" onclick="setOxExample('Fe3O4')">Fe₃O₄ (mixed)</span>
                                <span class="example-reaction" onclick="setOxExample('Na2S2O3')">Na₂S₂O₃</span>
                            </div>
                        </div>

                        <!-- Half-Reactions Tab -->
                        <div class="tab-pane fade" id="halfTab" role="tabpanel">
                            <h5 class="mb-3">Split into Half-Reactions</h5>
                            <p class="text-muted small">Separate a redox equation into oxidation and reduction half-reactions.</p>

                            <div class="form-group">
                                <label><strong>Balanced Redox Equation</strong></label>
                                <input type="text" class="form-control" id="halfEquation" placeholder="e.g., 5Fe2+ + MnO4- + 8H+ = 5Fe3+ + Mn2+ + 4H2O">
                                <small class="form-text text-muted">Enter a balanced redox equation</small>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="splitHalfReactions()">
                                <i class="fas fa-cut"></i> Split into Half-Reactions
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Equations:</h6>

                                <div class="example-category">⭐ Simple Redox</div>
                                <span class="example-reaction" onclick="setHalfExample('5Fe2+ + MnO4- + 8H+ = 5Fe3+ + Mn2+ + 4H2O')">Fe²⁺/MnO₄⁻ (acidic)</span>
                                <span class="example-reaction" onclick="setHalfExample('6Fe2+ + Cr2O7^2- + 14H+ = 6Fe3+ + 2Cr3+ + 7H2O')">Fe²⁺/Cr₂O₇²⁻</span>
                                <span class="example-reaction" onclick="setHalfExample('3Cu + 2NO3- + 8H+ = 3Cu2+ + 2NO + 4H2O')">Cu/NO₃⁻</span>

                                <div class="example-category">⭐⭐ Basic Solutions</div>
                                <span class="example-reaction" onclick="setHalfExample('2MnO4- + I- + H2O = 2MnO2 + IO3- + 2OH-')">MnO₄⁻/I⁻ (basic)</span>
                                <span class="example-reaction" onclick="setHalfExample('2Al + NO3- + 5OH- + 2H2O = 2AlO2- + NH3')">Al/NO₃⁻ (basic)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Results -->
        <div class="col-lg-5 mb-4">
            <div class="card shadow-sm sticky-side">
                <div class="card-body">
                    <h5 class="card-title"><i class="fas fa-flask"></i> Results</h5>
                    <div id="resultDisplay" class="min-h-result">
                        <p class="text-muted text-center mt-5">
                            <i class="fas fa-arrow-left"></i><br>
                            Enter equation and click Balance to see results
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Information Section -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Understanding Redox Reactions</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><strong>Redox Basics</strong></h6>
                            <p>Redox reactions involve the transfer of electrons between species.</p>
                            <ul>
                                <li><strong>Oxidation:</strong> Loss of electrons (increase in oxidation number)</li>
                                <li><strong>Reduction:</strong> Gain of electrons (decrease in oxidation number)</li>
                                <li><strong>Oxidizing Agent:</strong> Species that gets reduced</li>
                                <li><strong>Reducing Agent:</strong> Species that gets oxidized</li>
                            </ul>

                            <h6 class="mt-3"><strong>Oxidation Number Rules</strong></h6>
                            <ol>
                                <li>Free elements: 0</li>
                                <li>Monatomic ions: charge of ion</li>
                                <li>Oxygen: usually -2 (except peroxides: -1)</li>
                                <li>Hydrogen: +1 (with nonmetals), -1 (with metals)</li>
                                <li>Group 1: +1, Group 2: +2</li>
                                <li>Sum = total charge</li>
                            </ol>
                        </div>
                        <div class="col-md-6">
                            <h6><strong>Half-Reaction Method</strong></h6>
                            <p><strong>For Acidic Solutions:</strong></p>
                            <ol>
                                <li>Split into half-reactions</li>
                                <li>Balance atoms except O and H</li>
                                <li>Balance O by adding H₂O</li>
                                <li>Balance H by adding H⁺</li>
                                <li>Balance charge by adding e⁻</li>
                                <li>Equalize electrons transferred</li>
                                <li>Add half-reactions and simplify</li>
                            </ol>

                            <p><strong>For Basic Solutions:</strong></p>
                            <ul>
                                <li>Follow acidic method first</li>
                                <li>Add OH⁻ to neutralize H⁺</li>
                                <li>Combine H⁺ + OH⁻ → H₂O</li>
                                <li>Cancel excess H₂O</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
// Simplified redox balancer (manual approach - user provides balanced equation)
function balanceRedoxEquation() {
    const equation = document.getElementById('balanceEquation').value.trim();
    const medium = document.getElementById('balanceMedium').value;

    if (!equation) {
        alert('Please enter an equation');
        return;
    }

    // For this implementation, we'll provide step-by-step guidance
    // Full automatic balancing is complex and requires linear algebra

    const result = analyzeRedoxEquation(equation, medium);
    displayBalancingSteps(result, medium);
}

function analyzeRedoxEquation(equation, medium) {
    // Parse equation
    equation = equation.replace(/→|=/g, '→');
    const [reactants, products] = equation.split('→').map(s => s.trim());

    return {
        original: equation,
        reactants: reactants,
        products: products,
        medium: medium
    };
}

function displayBalancingSteps(result, medium) {
    const commonEquations = {
        'MnO4- + Fe2+ → Mn2+ + Fe3+': {
            balanced: '5Fe²⁺ + MnO₄⁻ + 8H⁺ → 5Fe³⁺ + Mn²⁺ + 4H₂O',
            oxidation: 'Fe²⁺ → Fe³⁺ + e⁻',
            reduction: 'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O',
            oxidized: 'Fe²⁺ (reducing agent)',
            reduced: 'MnO₄⁻ (oxidizing agent)',
            electrons: 5
        },
        'Cr2O7^2- + Fe2+ → Cr3+ + Fe3+': {
            balanced: '6Fe²⁺ + Cr₂O₇²⁻ + 14H⁺ → 6Fe³⁺ + 2Cr³⁺ + 7H₂O',
            oxidation: 'Fe²⁺ → Fe³⁺ + e⁻',
            reduction: 'Cr₂O₇²⁻ + 14H⁺ + 6e⁻ → 2Cr³⁺ + 7H₂O',
            oxidized: 'Fe²⁺ (reducing agent)',
            reduced: 'Cr₂O₇²⁻ (oxidizing agent)',
            electrons: 6
        },
        'MnO4- + Cl- → Mn2+ + Cl2': {
            balanced: '2MnO₄⁻ + 10Cl⁻ + 16H⁺ → 2Mn²⁺ + 5Cl₂ + 8H₂O',
            oxidation: '2Cl⁻ → Cl₂ + 2e⁻',
            reduction: 'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O',
            oxidized: 'Cl⁻ (reducing agent)',
            reduced: 'MnO₄⁻ (oxidizing agent)',
            electrons: 10
        },
        'Cu + NO3- → Cu2+ + NO': {
            balanced: '3Cu + 2NO₃⁻ + 8H⁺ → 3Cu²⁺ + 2NO + 4H₂O',
            oxidation: 'Cu → Cu²⁺ + 2e⁻',
            reduction: 'NO₃⁻ + 4H⁺ + 3e⁻ → NO + 2H₂O',
            oxidized: 'Cu (reducing agent)',
            reduced: 'NO₃⁻ (oxidizing agent)',
            electrons: 6
        },
        'MnO4- + I- → MnO2 + I2': {
            balanced: '2MnO₄⁻ + I⁻ + H₂O → 2MnO₂ + IO₃⁻ + 2OH⁻',
            oxidation: 'I⁻ + 6OH⁻ → IO₃⁻ + 3H₂O + 6e⁻',
            reduction: 'MnO₄⁻ + 2H₂O + 3e⁻ → MnO₂ + 4OH⁻',
            oxidized: 'I⁻ (reducing agent)',
            reduced: 'MnO₄⁻ (oxidizing agent)',
            electrons: 6
        },
        'Cr(OH)3 + ClO- → CrO4^2- + Cl-': {
            balanced: 'Cr(OH)₃ + ClO⁻ + 2OH⁻ → CrO₄²⁻ + Cl⁻ + 2H₂O',
            oxidation: 'Cr(OH)₃ + 5OH⁻ → CrO₄²⁻ + 4H₂O + 3e⁻',
            reduction: 'ClO⁻ + H₂O + 2e⁻ → Cl⁻ + 2OH⁻',
            oxidized: 'Cr(OH)₃ (reducing agent)',
            reduced: 'ClO⁻ (oxidizing agent)',
            electrons: 6
        },
        'Al + NO3- → AlO2- + NH3': {
            balanced: '8Al + 3NO₃⁻ + 5OH⁻ + 2H₂O → 8AlO₂⁻ + 3NH₃',
            oxidation: 'Al + 4OH⁻ → AlO₂⁻ + 2H₂O + 3e⁻',
            reduction: 'NO₃⁻ + 6H₂O + 8e⁻ → NH₃ + 9OH⁻',
            oxidized: 'Al (reducing agent)',
            reduced: 'NO₃⁻ (oxidizing agent)',
            electrons: 24
        },
        'Zn + NO3- → Zn(OH)4^2- + NH3': {
            balanced: '4Zn + NO₃⁻ + 7OH⁻ → 4Zn(OH)₄²⁻ + NH₃',
            oxidation: 'Zn + 4OH⁻ → Zn(OH)₄²⁻ + 2e⁻',
            reduction: 'NO₃⁻ + 6H₂O + 8e⁻ → NH₃ + 9OH⁻',
            oxidized: 'Zn (reducing agent)',
            reduced: 'NO₃⁻ (oxidizing agent)',
            electrons: 8
        },
        'Cr2O7^2- + C2H5OH → Cr3+ + CO2': {
            balanced: 'Cr₂O₇²⁻ + 3C₂H₅OH + 16H⁺ → 2Cr³⁺ + 3CO₂ + 11H₂O',
            oxidation: 'C₂H₅OH + 3H₂O → 2CO₂ + 12H⁺ + 12e⁻',
            reduction: 'Cr₂O₇²⁻ + 14H⁺ + 6e⁻ → 2Cr³⁺ + 7H₂O',
            oxidized: 'C₂H₅OH (reducing agent)',
            reduced: 'Cr₂O₇²⁻ (oxidizing agent)',
            electrons: 12
        },
        'MnO4- + H2O2 → Mn2+ + O2': {
            balanced: '2MnO₄⁻ + 5H₂O₂ + 6H⁺ → 2Mn²⁺ + 5O₂ + 8H₂O',
            oxidation: 'H₂O₂ → O₂ + 2H⁺ + 2e⁻',
            reduction: 'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O',
            oxidized: 'H₂O₂ (reducing agent)',
            reduced: 'MnO₄⁻ (oxidizing agent)',
            electrons: 10
        },
        'IO3- + I- → I2': {
            balanced: 'IO₃⁻ + 5I⁻ + 6H⁺ → 3I₂ + 3H₂O',
            oxidation: '2I⁻ → I₂ + 2e⁻',
            reduction: 'IO₃⁻ + 6H⁺ + 5e⁻ → ½I₂ + 3H₂O',
            oxidized: 'I⁻ (reducing agent)',
            reduced: 'IO₃⁻ (oxidizing agent)',
            electrons: 10
        },
        'S2O3^2- + I2 → S4O6^2- + I-': {
            balanced: '2S₂O₃²⁻ + I₂ → S₄O₆²⁻ + 2I⁻',
            oxidation: '2S₂O₃²⁻ → S₄O₆²⁻ + 2e⁻',
            reduction: 'I₂ + 2e⁻ → 2I⁻',
            oxidized: 'S₂O₃²⁻ (reducing agent)',
            reduced: 'I₂ (oxidizing agent)',
            electrons: 2
        }
    };

    // Normalize equation for lookup
    const normalized = result.original.replace(/\s+/g, ' ').replace(/→|=/g, '→').replace(/\^/g, '');

    let matchedData = null;
    for (const [key, data] of Object.entries(commonEquations)) {
        const normalizedKey = key.replace(/\s+/g, ' ').replace(/→|=/g, '→').replace(/\^/g, '');
        if (normalized.includes(normalizedKey.split('→')[0].trim()) &&
            normalized.includes(normalizedKey.split('→')[1].trim())) {
            matchedData = data;
            break;
        }
    }

    if (matchedData) {
        let html = `
            <div class="result-section">
                <h6><span class="balanced-badge">BALANCED EQUATION</span></h6>
                <div class="equation-display">${matchedData.balanced}</div>

                <hr>

                <h6><span class="step-badge">HALF-REACTIONS</span></h6>
                <div class="half-reaction-box">
                    <p class="mb-2"><span class="oxidation-badge">OXIDATION</span> (loses electrons)</p>
                    <div class="equation-display">${matchedData.oxidation}</div>
                    <p class="mb-0 text-muted small">${matchedData.oxidized}</p>
                </div>

                <div class="half-reaction-box">
                    <p class="mb-2"><span class="reduction-badge">REDUCTION</span> (gains electrons)</p>
                    <div class="equation-display">${matchedData.reduction}</div>
                    <p class="mb-0 text-muted small">${matchedData.reduced}</p>
                </div>

                <hr>

                <div class="info-box">
                    <p class="mb-1"><strong>Electrons Transferred:</strong> ${matchedData.electrons} e⁻</p>
                    <p class="mb-1"><strong>Medium:</strong> ${medium.charAt(0).toUpperCase() + medium.slice(1)}</p>
                    <p class="mb-0"><strong>Type:</strong> Redox reaction</p>
                </div>

                <hr>

                <h6><span class="step-badge">BALANCING STEPS</span></h6>
                <div class="step-section">
                    ${getBalancingSteps(medium)}
                </div>
            </div>
        `;

        document.getElementById('resultDisplay').innerHTML = html;
    } else {
        // Equation not in database
        document.getElementById('resultDisplay').innerHTML = `
            <div class="warning-box">
                <p class="mb-2"><strong>⚠️ Equation not in database</strong></p>
                <p class="mb-0">Follow the half-reaction method steps below to balance this equation manually.</p>
            </div>
            <div class="step-section">
                ${getBalancingSteps(medium)}
            </div>
        `;
    }
}

function getBalancingSteps(medium) {
    if (medium === 'acidic') {
        return `
            <p class="mb-2"><strong>Step 1:</strong> Identify species being oxidized and reduced</p>
            <p class="mb-2"><strong>Step 2:</strong> Write skeleton half-reactions</p>
            <p class="mb-2"><strong>Step 3:</strong> Balance atoms except O and H</p>
            <p class="mb-2"><strong>Step 4:</strong> Balance O by adding H₂O</p>
            <p class="mb-2"><strong>Step 5:</strong> Balance H by adding H⁺</p>
            <p class="mb-2"><strong>Step 6:</strong> Balance charge by adding e⁻</p>
            <p class="mb-2"><strong>Step 7:</strong> Multiply to equalize electrons</p>
            <p class="mb-0"><strong>Step 8:</strong> Add half-reactions and cancel common terms</p>
        `;
    } else {
        return `
            <p class="mb-2"><strong>Step 1-7:</strong> Follow acidic method first</p>
            <p class="mb-2"><strong>Step 8:</strong> Add OH⁻ to both sides to neutralize H⁺</p>
            <p class="mb-2"><strong>Step 9:</strong> Combine H⁺ + OH⁻ → H₂O on each side</p>
            <p class="mb-0"><strong>Step 10:</strong> Cancel excess H₂O molecules</p>
        `;
    }
}

// Calculate oxidation numbers
function calculateOxidationNumbers() {
    const formula = document.getElementById('oxFormula').value.trim();

    if (!formula) {
        alert('Please enter a formula');
        return;
    }

    const oxStates = getOxidationStates(formula);
    displayOxidationNumbers(formula, oxStates);
}

function getOxidationStates(formula) {
    // Common oxidation states database
    const oxDatabase = {
        'H2O': { 'H': +1, 'O': -2 },
        'H2SO4': { 'H': +1, 'S': +6, 'O': -2 },
        'NH3': { 'N': -3, 'H': +1 },
        'CO2': { 'C': +4, 'O': -2 },
        'NaCl': { 'Na': +1, 'Cl': -1 },
        'MnO4-': { 'Mn': +7, 'O': -2 },
        'Cr2O7^2-': { 'Cr': +6, 'O': -2 },
        'SO4^2-': { 'S': +6, 'O': -2 },
        'NO3-': { 'N': +5, 'O': -2 },
        'PO4^3-': { 'P': +5, 'O': -2 },
        'K2Cr2O7': { 'K': +1, 'Cr': +6, 'O': -2 },
        'KMnO4': { 'K': +1, 'Mn': +7, 'O': -2 },
        'H2O2': { 'H': +1, 'O': -1 },
        'Fe3O4': { 'Fe': +2.67, 'O': -2 },
        'Na2S2O3': { 'Na': +1, 'S': +2, 'O': -2 }
    };

    const normalized = formula.replace(/\^/g, '').replace(/-/g, '').replace(/\+/g, '');

    for (const [key, states] of Object.entries(oxDatabase)) {
        if (key.replace(/\^|-|\+/g, '') === normalized || key === formula) {
            return states;
        }
    }

    return null;
}

function displayOxidationNumbers(formula, oxStates) {
    if (!oxStates) {
        document.getElementById('resultDisplay').innerHTML = `
            <div class="warning-box">
                <p class="mb-0">Oxidation states for this compound are not in the database. Use the rules below to calculate manually.</p>
            </div>
        `;
        return;
    }

    let html = `
        <div class="result-section">
            <h6><span class="balanced-badge">OXIDATION NUMBERS</span></h6>
            <div class="equation-display">${formatFormulaWithOxStates(formula, oxStates)}</div>

            <hr>

            <h6><span class="step-badge">INDIVIDUAL ELEMENTS</span></h6>
            <div class="step-section">
    `;

    for (const [element, oxState] of Object.entries(oxStates)) {
        const sign = oxState > 0 ? '+' : '';
        html += `<p class="mb-1"><strong>${element}:</strong> <span class="ox-number">${sign}${oxState}</span></p>`;
    }

    html += `
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Verification:</strong> Sum of oxidation numbers equals the total charge of the species.</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

function formatFormulaWithOxStates(formula, oxStates) {
    let formatted = formula;
    for (const [element, oxState] of Object.entries(oxStates)) {
        const sign = oxState > 0 ? '+' : '';
        formatted = formatted.replace(new RegExp(element, 'g'),
            `${element}<sup class="ox-number">${sign}${oxState}</sup>`);
    }
    return formatted;
}

// Split half-reactions
function splitHalfReactions() {
    const equation = document.getElementById('halfEquation').value.trim();

    if (!equation) {
        alert('Please enter a balanced equation');
        return;
    }

    const halfReactions = identifyHalfReactions(equation);
    displayHalfReactions(halfReactions);
}

function identifyHalfReactions(equation) {
    // Database of common balanced equations with their half-reactions
    const halfDatabase = {
        '5Fe2+ + MnO4- + 8H+ = 5Fe3+ + Mn2+ + 4H2O': {
            oxidation: 'Fe²⁺ → Fe³⁺ + e⁻ (×5)',
            reduction: 'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O'
        },
        '6Fe2+ + Cr2O7^2- + 14H+ = 6Fe3+ + 2Cr3+ + 7H2O': {
            oxidation: 'Fe²⁺ → Fe³⁺ + e⁻ (×6)',
            reduction: 'Cr₂O₇²⁻ + 14H⁺ + 6e⁻ → 2Cr³⁺ + 7H₂O'
        },
        '3Cu + 2NO3- + 8H+ = 3Cu2+ + 2NO + 4H2O': {
            oxidation: 'Cu → Cu²⁺ + 2e⁻ (×3)',
            reduction: 'NO₃⁻ + 4H⁺ + 3e⁻ → NO + 2H₂O (×2)'
        },
        '2MnO4- + I- + H2O = 2MnO2 + IO3- + 2OH-': {
            oxidation: 'I⁻ + 6OH⁻ → IO₃⁻ + 3H₂O + 6e⁻',
            reduction: 'MnO₄⁻ + 2H₂O + 3e⁻ → MnO₂ + 4OH⁻ (×2)'
        },
        '2Al + NO3- + 5OH- + 2H2O = 2AlO2- + NH3': {
            oxidation: 'Al + 4OH⁻ → AlO₂⁻ + 2H₂O + 3e⁻ (×8)',
            reduction: 'NO₃⁻ + 6H₂O + 8e⁻ → NH₃ + 9OH⁻ (×3)'
        }
    };

    const normalized = equation.replace(/\s+/g, ' ').replace(/→|=/g, '=').replace(/\^/g, '');

    for (const [key, data] of Object.entries(halfDatabase)) {
        const normalizedKey = key.replace(/\s+/g, ' ').replace(/→|=/g, '=').replace(/\^/g, '');
        if (normalized === normalizedKey) {
            return data;
        }
    }

    return null;
}

function displayHalfReactions(halfReactions) {
    if (!halfReactions) {
        document.getElementById('resultDisplay').innerHTML = `
            <div class="warning-box">
                <p class="mb-0">This equation is not in the database. Balance it first using the Balance Equation tab.</p>
            </div>
        `;
        return;
    }

    let html = `
        <div class="result-section">
            <h6><span class="step-badge">HALF-REACTIONS</span></h6>

            <div class="half-reaction-box">
                <p class="mb-2"><span class="oxidation-badge">OXIDATION HALF-REACTION</span></p>
                <div class="equation-display">${halfReactions.oxidation}</div>
                <p class="mb-0 text-muted small">Species loses electrons (oxidation number increases)</p>
            </div>

            <div class="half-reaction-box">
                <p class="mb-2"><span class="reduction-badge">REDUCTION HALF-REACTION</span></p>
                <div class="equation-display">${halfReactions.reduction}</div>
                <p class="mb-0 text-muted small">Species gains electrons (oxidation number decreases)</p>
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Note:</strong> When adding half-reactions, electrons must cancel out completely.</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Example setters
function setBalanceExample(eq, med) {
    document.getElementById('balanceEquation').value = eq;
    document.getElementById('balanceMedium').value = med;
}

function setOxExample(formula) {
    document.getElementById('oxFormula').value = formula;
}

function setHalfExample(eq) {
    document.getElementById('halfEquation').value = eq;
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
