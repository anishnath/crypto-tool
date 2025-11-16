<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Titration Calculator - Acid-Base Titration & pH Calculator</title>
    <meta name="description" content="Free titration calculator for acid-base titrations. Calculate concentration, volume, pH at equivalence point, and generate titration curves. Supports strong and weak acids/bases, polyprotic acids.">
    <meta name="keywords" content="titration calculator, acid-base titration, pH calculator, equivalence point, titration curve, chemistry calculator">

    <!-- Open Graph tags -->
    <meta property="og:title" content="Titration Calculator - Acid-Base Titration & pH">
    <meta property="og:description" content="Calculate concentration, volume, pH at equivalence point, and generate titration curves. Free chemistry calculator with step-by-step solutions.">
    <meta property="og:type" content="website">

    <!-- Schema.org structured data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Titration Calculator",
        "description": "Calculate concentration, volume, pH at equivalence point, and generate titration curves for acid-base titrations. Supports strong and weak acids/bases with detailed step-by-step solutions.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Basic titration calculations (M1V1=M2V2), pH at equivalence point, Titration curve generation, Weak acid and weak base support, Polyprotic acid support, Step-by-step solutions",
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

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
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

        .result-badge {
            background: #3b82f6;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .equiv-badge {
            background: #8b5cf6;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .step-badge {
            background: #059669;
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

        #titrationChart {
            max-width: 100%;
            height: 400px;
            margin-top: 15px;
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
    </style>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="mb-3">Titration Calculator</h1>
    <p class="lead mb-4">
        Calculate concentration, volume, pH at equivalence point, and generate titration curves for acid-base titrations.
    </p>

    <div class="row">
        <!-- Left Column - Input Forms -->
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" id="calculatorTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="basic-tab" data-toggle="tab" href="#basicTab" role="tab">
                                <i class="fas fa-flask"></i> Basic Titration
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="ph-tab" data-toggle="tab" href="#phTab" role="tab">
                                <i class="fas fa-tint"></i> pH at Equivalence
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="curve-tab" data-toggle="tab" href="#curveTab" role="tab">
                                <i class="fas fa-chart-line"></i> Titration Curve
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Basic Titration Tab -->
                        <div class="tab-pane fade show active" id="basicTab" role="tabpanel">
                            <h5 class="mb-3">Basic Titration Calculator (M₁V₁ = M₂V₂)</h5>
                            <p class="text-muted small">Calculate unknown concentration or volume using the titration equation.</p>

                            <div class="form-group">
                                <label><strong>Calculate:</strong></label>
                                <select class="form-control" id="basicCalculateWhat">
                                    <option value="V1">Volume of analyte (V₁)</option>
                                    <option value="M1">Concentration of analyte (M₁)</option>
                                    <option value="V2">Volume of titrant (V₂)</option>
                                    <option value="M2">Concentration of titrant (M₂)</option>
                                </select>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-muted mt-3">Analyte (Solution Being Titrated)</h6>
                                    <div class="form-group">
                                        <label>Concentration (M₁)</label>
                                        <input type="number" step="any" class="form-control" id="basicM1" placeholder="e.g., 0.100">
                                    </div>
                                    <div class="form-group">
                                        <label>Volume (V₁)</label>
                                        <input type="number" step="any" class="form-control" id="basicV1" placeholder="e.g., 25.0">
                                    </div>
                                    <div class="form-group">
                                        <label>Volume Unit</label>
                                        <select class="form-control" id="basicV1Unit">
                                            <option value="mL">mL</option>
                                            <option value="L">L</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mt-3">Titrant (Solution in Burette)</h6>
                                    <div class="form-group">
                                        <label>Concentration (M₂)</label>
                                        <input type="number" step="any" class="form-control" id="basicM2" placeholder="e.g., 0.150">
                                    </div>
                                    <div class="form-group">
                                        <label>Volume (V₂)</label>
                                        <input type="number" step="any" class="form-control" id="basicV2" placeholder="e.g., 16.7">
                                    </div>
                                    <div class="form-group">
                                        <label>Volume Unit</label>
                                        <select class="form-control" id="basicV2Unit">
                                            <option value="mL">mL</option>
                                            <option value="L">L</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label><strong>Stoichiometry Ratio (n₁:n₂)</strong></label>
                                <div class="row">
                                    <div class="col-6">
                                        <input type="number" step="1" class="form-control" id="basicN1" value="1" placeholder="n₁">
                                    </div>
                                    <div class="col-6">
                                        <input type="number" step="1" class="form-control" id="basicN2" value="1" placeholder="n₂">
                                    </div>
                                </div>
                                <small class="form-text text-muted">For HCl + NaOH → NaCl + H₂O, ratio is 1:1. For H₂SO₄ + 2NaOH, ratio is 1:2</small>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateBasicTitration()">
                                <i class="fas fa-calculator"></i> Calculate
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Basic (1:1 Stoichiometry)</div>
                                <span class="example-reaction" onclick="setBasicExample('M1', '', 25.0, 16.7, 0.150, 1, 1)">Find M₁: 25mL HCl + 16.7mL 0.150M NaOH</span>
                                <span class="example-reaction" onclick="setBasicExample('V2', 0.100, 25.0, '', 0.150, 1, 1)">Find V₂: 25mL 0.100M HCl + ? 0.150M NaOH</span>
                                <span class="example-reaction" onclick="setBasicExample('M2', 0.100, 20.0, 15.5, '', 1, 1)">Find M₂: 20mL 0.100M acid + 15.5mL NaOH</span>
                                <span class="example-reaction" onclick="setBasicExample('V1', 0.250, '', 30.0, 0.100, 1, 1)">Find V₁: ? 0.250M HNO₃ + 30mL 0.100M KOH</span>
                                <span class="example-reaction" onclick="setBasicExample('M1', '', 50.0, 25.0, 0.200, 1, 1)">Find M₁: 50mL CH₃COOH + 25mL 0.200M NaOH</span>

                                <div class="example-category">⭐⭐ Polyprotic Acids (1:2 Stoichiometry)</div>
                                <span class="example-reaction" onclick="setBasicExample('M1', '', 20.0, 18.5, 0.200, 1, 2)">Find M₁: H₂SO₄ + 2NaOH (18.5mL 0.200M)</span>
                                <span class="example-reaction" onclick="setBasicExample('V2', 0.150, 15.0, '', 0.100, 1, 2)">Find V₂: 15mL 0.150M H₂SO₄ + 2NaOH</span>
                                <span class="example-reaction" onclick="setBasicExample('M1', '', 30.0, 45.0, 0.100, 1, 2)">Find M₁: H₂C₂O₄ + 2KOH (45mL 0.100M)</span>

                                <div class="example-category">⭐⭐⭐ Triprotic Acids (1:3 Stoichiometry)</div>
                                <span class="example-reaction" onclick="setBasicExample('V2', 0.100, 10.0, '', 0.150, 1, 3)">Find V₂: 10mL 0.100M H₃PO₄ + 3NaOH</span>
                                <span class="example-reaction" onclick="setBasicExample('M1', '', 25.0, 35.0, 0.120, 1, 3)">Find M₁: H₃PO₄ + 3KOH (35mL 0.120M)</span>

                                <div class="example-category">🧪 Reverse Titrations (Base as Analyte)</div>
                                <span class="example-reaction" onclick="setBasicExample('M1', '', 30.0, 22.5, 0.200, 1, 1)">Find M₁: 30mL NaOH + 22.5mL 0.200M HCl</span>
                                <span class="example-reaction" onclick="setBasicExample('V2', 0.080, 40.0, '', 0.100, 2, 1)">Find V₂: 40mL 0.080M Ba(OH)₂ + HCl (2:1)</span>
                            </div>
                        </div>

                        <!-- pH at Equivalence Tab -->
                        <div class="tab-pane fade" id="phTab" role="tabpanel">
                            <h5 class="mb-3">pH at Equivalence Point</h5>
                            <p class="text-muted small">Calculate the pH at the equivalence point for strong or weak acid/base titrations.</p>

                            <div class="form-group">
                                <label><strong>Titration Type</strong></label>
                                <select class="form-control" id="phTitrationType" onchange="updatePhFields()">
                                    <option value="strong-strong">Strong Acid + Strong Base</option>
                                    <option value="weak-strong">Weak Acid + Strong Base</option>
                                    <option value="strong-weak">Strong Acid + Weak Base</option>
                                    <option value="weak-weak">Weak Acid + Weak Base</option>
                                </select>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-muted mt-3">Acid</h6>
                                    <div class="form-group">
                                        <label>Initial Concentration (M)</label>
                                        <input type="number" step="any" class="form-control" id="phAcidConc" placeholder="e.g., 0.100">
                                    </div>
                                    <div class="form-group">
                                        <label>Initial Volume (mL)</label>
                                        <input type="number" step="any" class="form-control" id="phAcidVol" placeholder="e.g., 25.0">
                                    </div>
                                    <div class="form-group" id="phKaGroup" style="display:none;">
                                        <label>Ka (Acid Dissociation Constant)</label>
                                        <input type="number" step="any" class="form-control" id="phKa" placeholder="e.g., 1.8e-5">
                                        <small class="form-text text-muted">Enter in scientific notation (e.g., 1.8e-5)</small>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mt-3">Base</h6>
                                    <div class="form-group">
                                        <label>Concentration (M)</label>
                                        <input type="number" step="any" class="form-control" id="phBaseConc" placeholder="e.g., 0.100">
                                    </div>
                                    <div class="form-group">
                                        <label>Volume at Equiv. Point (mL)</label>
                                        <input type="number" step="any" class="form-control" id="phBaseVol" placeholder="e.g., 25.0">
                                    </div>
                                    <div class="form-group" id="phKbGroup" style="display:none;">
                                        <label>Kb (Base Dissociation Constant)</label>
                                        <input type="number" step="any" class="form-control" id="phKb" placeholder="e.g., 1.8e-5">
                                        <small class="form-text text-muted">Enter in scientific notation (e.g., 1.8e-5)</small>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateEquivalencePh()">
                                <i class="fas fa-calculator"></i> Calculate pH at Equivalence Point
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Strong Acid + Strong Base (pH = 7.0)</div>
                                <span class="example-reaction" onclick="setPhExample('strong-strong', 0.100, 25.0, 0.100, 25.0)">HCl + NaOH (0.1M, 25mL each)</span>
                                <span class="example-reaction" onclick="setPhExample('strong-strong', 0.200, 30.0, 0.150, 40.0)">HNO₃ + KOH (0.2M/0.15M)</span>
                                <span class="example-reaction" onclick="setPhExample('strong-strong', 0.050, 50.0, 0.100, 25.0)">HCl + NaOH (dilute 0.05M)</span>

                                <div class="example-category">⭐⭐ Weak Acid + Strong Base (pH > 7)</div>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.100, 25.0, 0.100, 25.0, 1.8e-5)">CH₃COOH + NaOH (Ka=1.8×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.050, 50.0, 0.100, 25.0, 6.3e-5)">HNO₂ + KOH (Ka=6.3×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.100, 30.0, 0.100, 30.0, 6.5e-5)">HF + NaOH (Ka=6.5×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.200, 20.0, 0.100, 40.0, 1.3e-5)">HCOOH + KOH (Ka=1.3×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.150, 25.0, 0.150, 25.0, 4.9e-10)">HCN + NaOH (Ka=4.9×10⁻¹⁰)</span>

                                <div class="example-category">⭐⭐ Strong Acid + Weak Base (pH < 7)</div>
                                <span class="example-reaction" onclick="setPhExample('strong-weak', 0.100, 25.0, 0.100, 25.0, null, 1.8e-5)">HCl + NH₃ (Kb=1.8×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setPhExample('strong-weak', 0.150, 30.0, 0.150, 30.0, null, 1.8e-5)">HNO₃ + NH₃ (Kb=1.8×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setPhExample('strong-weak', 0.100, 40.0, 0.200, 20.0, null, 4.4e-4)">H₂SO₄ + CH₃NH₂ (Kb=4.4×10⁻⁴)</span>

                                <div class="example-category">⭐⭐⭐ Various Weak Acids</div>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.100, 25.0, 0.100, 25.0, 1.8e-4)">HClO₂ + NaOH (Ka=1.8×10⁻⁴)</span>
                                <span class="example-reaction" onclick="setPhExample('weak-strong', 0.100, 25.0, 0.100, 25.0, 6.6e-4)">HF₂⁻ + KOH (Ka=6.6×10⁻⁴)</span>
                            </div>
                        </div>

                        <!-- Titration Curve Tab -->
                        <div class="tab-pane fade" id="curveTab" role="tabpanel">
                            <h5 class="mb-3">Titration Curve Generator</h5>
                            <p class="text-muted small">Generate a pH vs volume titration curve.</p>

                            <div class="form-group">
                                <label><strong>Titration Type</strong></label>
                                <select class="form-control" id="curveTitrationType" onchange="updateCurveFields()">
                                    <option value="strong-acid-strong-base">Strong Acid + Strong Base</option>
                                    <option value="weak-acid-strong-base">Weak Acid + Strong Base</option>
                                    <option value="strong-acid-weak-base">Strong Acid + Weak Base</option>
                                </select>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Acid Concentration (M)</label>
                                        <input type="number" step="any" class="form-control" id="curveAcidConc" placeholder="e.g., 0.100">
                                    </div>
                                    <div class="form-group">
                                        <label>Acid Volume (mL)</label>
                                        <input type="number" step="any" class="form-control" id="curveAcidVol" placeholder="e.g., 50.0">
                                    </div>
                                    <div class="form-group" id="curveKaGroup" style="display:none;">
                                        <label>Ka (for weak acid)</label>
                                        <input type="number" step="any" class="form-control" id="curveKa" placeholder="e.g., 1.8e-5">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Base Concentration (M)</label>
                                        <input type="number" step="any" class="form-control" id="curveBaseConc" placeholder="e.g., 0.100">
                                    </div>
                                    <div class="form-group" id="curveKbGroup" style="display:none;">
                                        <label>Kb (for weak base)</label>
                                        <input type="number" step="any" class="form-control" id="curveKb" placeholder="e.g., 1.8e-5">
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="generateTitrationCurve()">
                                <i class="fas fa-chart-line"></i> Generate Titration Curve
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Curves:</h6>

                                <div class="example-category">⭐ Strong Acid + Strong Base (Sharp Curve)</div>
                                <span class="example-reaction" onclick="setCurveExample('strong-acid-strong-base', 0.100, 50.0, 0.100)">HCl + NaOH (0.1M standard)</span>
                                <span class="example-reaction" onclick="setCurveExample('strong-acid-strong-base', 0.200, 25.0, 0.100)">HNO₃ + KOH (2:1 conc)</span>
                                <span class="example-reaction" onclick="setCurveExample('strong-acid-strong-base', 0.050, 100.0, 0.100)">HCl + NaOH (dilute)</span>

                                <div class="example-category">⭐⭐ Weak Acid + Strong Base (Buffer Region)</div>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.100, 50.0, 0.100, 1.8e-5)">CH₃COOH + NaOH (Ka=1.8×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.050, 25.0, 0.100, 1.8e-5)">CH₃COOH dilute (0.05M)</span>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.100, 40.0, 0.100, 6.3e-5)">HNO₂ + KOH (Ka=6.3×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.100, 30.0, 0.100, 6.5e-5)">HF + NaOH (Ka=6.5×10⁻⁵)</span>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.100, 50.0, 0.100, 4.9e-10)">HCN + NaOH (very weak)</span>

                                <div class="example-category">⭐⭐⭐ Compare Strong vs Weak</div>
                                <span class="example-reaction" onclick="setCurveExample('strong-acid-strong-base', 0.100, 50.0, 0.100)">Strong (HCl)</span>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.100, 50.0, 0.100, 1.8e-5)">Weak (CH₃COOH)</span>
                                <span class="example-reaction" onclick="setCurveExample('weak-acid-strong-base', 0.100, 50.0, 0.100, 1.8e-4)">Medium weak (HClO₂)</span>
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
                            Enter data and click Calculate to see results
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
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Understanding Titrations</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><strong>Titration Basics</strong></h6>
                            <p>A titration is a technique to determine the concentration of an unknown solution by reacting it with a solution of known concentration.</p>

                            <h6 class="mt-3"><strong>Key Terms</strong></h6>
                            <ul>
                                <li><strong>Analyte:</strong> The solution being analyzed (in flask)</li>
                                <li><strong>Titrant:</strong> The solution of known concentration (in burette)</li>
                                <li><strong>Equivalence Point:</strong> When moles of acid = moles of base</li>
                                <li><strong>Endpoint:</strong> When indicator changes color</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6><strong>Titration Equation</strong></h6>
                            <p><strong>M₁V₁/n₁ = M₂V₂/n₂</strong></p>
                            <p>Where M = molarity, V = volume, n = stoichiometric coefficient</p>

                            <h6 class="mt-3"><strong>pH at Equivalence Point</strong></h6>
                            <ul>
                                <li><strong>Strong + Strong:</strong> pH = 7.0</li>
                                <li><strong>Weak Acid + Strong Base:</strong> pH > 7 (basic)</li>
                                <li><strong>Strong Acid + Weak Base:</strong> pH < 7 (acidic)</li>
                                <li><strong>Weak + Weak:</strong> Depends on Ka and Kb</li>
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
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<script>
// Basic Titration Calculator
function calculateBasicTitration() {
    const calculateWhat = document.getElementById('basicCalculateWhat').value;
    const m1 = parseFloat(document.getElementById('basicM1').value);
    const v1 = parseFloat(document.getElementById('basicV1').value);
    const v1Unit = document.getElementById('basicV1Unit').value;
    const m2 = parseFloat(document.getElementById('basicM2').value);
    const v2 = parseFloat(document.getElementById('basicV2').value);
    const v2Unit = document.getElementById('basicV2Unit').value;
    const n1 = parseFloat(document.getElementById('basicN1').value);
    const n2 = parseFloat(document.getElementById('basicN2').value);

    // Convert to L if needed
    const v1L = v1Unit === 'mL' ? v1 / 1000 : v1;
    const v2L = v2Unit === 'mL' ? v2 / 1000 : v2;

    let result, resultValue, resultUnit;

    // Equation: M1*V1/n1 = M2*V2/n2
    switch(calculateWhat) {
        case 'M1':
            if (isNaN(v1) || isNaN(m2) || isNaN(v2)) {
                alert('Please enter V₁, M₂, and V₂');
                return;
            }
            resultValue = (m2 * v2L * n1) / (v1L * n2);
            result = `M₁ = ${resultValue.toFixed(4)} M`;
            resultUnit = 'M';
            break;
        case 'V1':
            if (isNaN(m1) || isNaN(m2) || isNaN(v2)) {
                alert('Please enter M₁, M₂, and V₂');
                return;
            }
            resultValue = (m2 * v2L * n1) / (m1 * n2);
            result = v1Unit === 'mL' ?
                `V₁ = ${(resultValue * 1000).toFixed(2)} mL` :
                `V₁ = ${resultValue.toFixed(4)} L`;
            resultUnit = v1Unit;
            break;
        case 'M2':
            if (isNaN(m1) || isNaN(v1) || isNaN(v2)) {
                alert('Please enter M₁, V₁, and V₂');
                return;
            }
            resultValue = (m1 * v1L * n2) / (v2L * n1);
            result = `M₂ = ${resultValue.toFixed(4)} M`;
            resultUnit = 'M';
            break;
        case 'V2':
            if (isNaN(m1) || isNaN(v1) || isNaN(m2)) {
                alert('Please enter M₁, V₁, and M₂');
                return;
            }
            resultValue = (m1 * v1L * n2) / (m2 * n1);
            result = v2Unit === 'mL' ?
                `V₂ = ${(resultValue * 1000).toFixed(2)} mL` :
                `V₂ = ${resultValue.toFixed(4)} L`;
            resultUnit = v2Unit;
            break;
    }

    // Display result
    let html = `
        <div class="result-section">
            <h6><span class="result-badge">RESULT</span></h6>
            <h4 class="mb-3">${result}</h4>

            <hr>

            <h6><span class="step-badge">CALCULATION STEPS</span></h6>
            <div class="step-section">
                <p class="mb-2"><strong>Given:</strong></p>
                ${!isNaN(m1) ? `<p class="mb-1 ml-3">M₁ = ${m1} M</p>` : ''}
                ${!isNaN(v1) ? `<p class="mb-1 ml-3">V₁ = ${v1} ${v1Unit}</p>` : ''}
                ${!isNaN(m2) ? `<p class="mb-1 ml-3">M₂ = ${m2} M</p>` : ''}
                ${!isNaN(v2) ? `<p class="mb-1 ml-3">V₂ = ${v2} ${v2Unit}</p>` : ''}
                <p class="mb-3 ml-3">Ratio n₁:n₂ = ${n1}:${n2}</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">M₁V₁/n₁ = M₂V₂/n₂</p>

                <p class="mb-2"><strong>Solve for ${calculateWhat}:</strong></p>
                <p class="mb-1 ml-3">${getFormulaRearranged(calculateWhat, n1, n2)}</p>
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Moles at Equivalence Point:</strong></p>
                <p class="mb-0">n(analyte) = ${calculateMoles(m1 || resultValue, v1L || (resultValue * (v1Unit === 'mL' ? 0.001 : 1)), n1, n2).toFixed(6)} mol</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

function calculateMoles(m, v, n1, n2) {
    return m * v;
}

function getFormulaRearranged(variable, n1, n2) {
    switch(variable) {
        case 'M1': return `M₁ = (M₂ × V₂ × n₁) / (V₁ × n₂)`;
        case 'V1': return `V₁ = (M₂ × V₂ × n₁) / (M₁ × n₂)`;
        case 'M2': return `M₂ = (M₁ × V₁ × n₂) / (V₂ × n₁)`;
        case 'V2': return `V₂ = (M₁ × V₁ × n₂) / (M₂ × n₁)`;
    }
}

// pH at Equivalence Point Calculator
function updatePhFields() {
    const type = document.getElementById('phTitrationType').value;
    const kaGroup = document.getElementById('phKaGroup');
    const kbGroup = document.getElementById('phKbGroup');

    if (type === 'weak-strong' || type === 'weak-weak') {
        kaGroup.style.display = 'block';
    } else {
        kaGroup.style.display = 'none';
    }

    if (type === 'strong-weak' || type === 'weak-weak') {
        kbGroup.style.display = 'block';
    } else {
        kbGroup.style.display = 'none';
    }
}

function calculateEquivalencePh() {
    const type = document.getElementById('phTitrationType').value;
    const acidConc = parseFloat(document.getElementById('phAcidConc').value);
    const acidVol = parseFloat(document.getElementById('phAcidVol').value);
    const baseConc = parseFloat(document.getElementById('phBaseConc').value);
    const baseVol = parseFloat(document.getElementById('phBaseVol').value);
    const ka = parseFloat(document.getElementById('phKa').value);
    const kb = parseFloat(document.getElementById('phKb').value);

    if (isNaN(acidConc) || isNaN(acidVol) || isNaN(baseConc) || isNaN(baseVol)) {
        alert('Please enter all concentrations and volumes');
        return;
    }

    const totalVol = acidVol + baseVol; // mL
    let pH, explanation;

    switch(type) {
        case 'strong-strong':
            pH = 7.0;
            explanation = `
                <p class="mb-2">For strong acid + strong base titrations, the equivalence point is always at pH 7.0</p>
                <p class="mb-2">This is because the salt formed (e.g., NaCl from HCl + NaOH) does not hydrolyze.</p>
            `;
            break;

        case 'weak-strong':
            if (isNaN(ka)) {
                alert('Please enter Ka for the weak acid');
                return;
            }
            // At equivalence, weak acid is converted to its conjugate base
            // [A-] = moles/total volume
            const molesBase = acidConc * (acidVol / 1000); // mol
            const concBase = molesBase / (totalVol / 1000); // M

            // Kb = Kw/Ka
            const kw = 1e-14;
            const kbCalc = kw / ka;

            // [OH-] = sqrt(Kb * C)
            const ohConc = Math.sqrt(kbCalc * concBase);
            const poh = -Math.log10(ohConc);
            pH = 14 - poh;

            explanation = `
                <p class="mb-2"><strong>Step 1:</strong> Calculate moles of conjugate base formed</p>
                <p class="mb-2 ml-3">moles = ${acidConc} M × ${acidVol / 1000} L = ${molesBase.toFixed(6)} mol</p>

                <p class="mb-2"><strong>Step 2:</strong> Calculate concentration of conjugate base</p>
                <p class="mb-2 ml-3">[A⁻] = ${molesBase.toFixed(6)} mol / ${totalVol / 1000} L = ${concBase.toFixed(4)} M</p>

                <p class="mb-2"><strong>Step 3:</strong> Calculate Kb from Ka</p>
                <p class="mb-2 ml-3">Kb = Kw/Ka = 1×10⁻¹⁴ / ${ka.toExponential(2)} = ${kbCalc.toExponential(2)}</p>

                <p class="mb-2"><strong>Step 4:</strong> Calculate [OH⁻]</p>
                <p class="mb-2 ml-3">[OH⁻] = √(Kb × [A⁻]) = ${ohConc.toExponential(2)} M</p>

                <p class="mb-2"><strong>Step 5:</strong> Calculate pH</p>
                <p class="mb-2 ml-3">pOH = ${poh.toFixed(2)}, so pH = 14 - ${poh.toFixed(2)} = ${pH.toFixed(2)}</p>
            `;
            break;

        case 'strong-weak':
            if (isNaN(kb)) {
                alert('Please enter Kb for the weak base');
                return;
            }
            // At equivalence, weak base is converted to its conjugate acid
            const molesAcid = baseConc * (baseVol / 1000);
            const concAcid = molesAcid / (totalVol / 1000);

            // Ka = Kw/Kb
            const kaCalc = 1e-14 / kb;

            // [H+] = sqrt(Ka * C)
            const hConc = Math.sqrt(kaCalc * concAcid);
            pH = -Math.log10(hConc);

            explanation = `
                <p class="mb-2"><strong>Step 1:</strong> Calculate moles of conjugate acid formed</p>
                <p class="mb-2 ml-3">moles = ${baseConc} M × ${baseVol / 1000} L = ${molesAcid.toFixed(6)} mol</p>

                <p class="mb-2"><strong>Step 2:</strong> Calculate concentration of conjugate acid</p>
                <p class="mb-2 ml-3">[BH⁺] = ${molesAcid.toFixed(6)} mol / ${totalVol / 1000} L = ${concAcid.toFixed(4)} M</p>

                <p class="mb-2"><strong>Step 3:</strong> Calculate Ka from Kb</p>
                <p class="mb-2 ml-3">Ka = Kw/Kb = 1×10⁻¹⁴ / ${kb.toExponential(2)} = ${kaCalc.toExponential(2)}</p>

                <p class="mb-2"><strong>Step 4:</strong> Calculate [H⁺]</p>
                <p class="mb-2 ml-3">[H⁺] = √(Ka × [BH⁺]) = ${hConc.toExponential(2)} M</p>

                <p class="mb-2"><strong>Step 5:</strong> Calculate pH</p>
                <p class="mb-2 ml-3">pH = -log[H⁺] = ${pH.toFixed(2)}</p>
            `;
            break;

        case 'weak-weak':
            alert('Weak acid + weak base calculations are complex and depend on both Ka and Kb values. Use pH = 7 + 0.5(pKa - pKb) as approximation.');
            return;
    }

    let html = `
        <div class="result-section">
            <h6><span class="equiv-badge">pH AT EQUIVALENCE POINT</span></h6>
            <h4 class="mb-3">pH = ${pH.toFixed(2)}</h4>

            <hr>

            <h6><span class="step-badge">CALCULATION STEPS</span></h6>
            <div class="step-section">
                <p class="mb-2"><strong>Titration Type:</strong> ${getTitrationTypeName(type)}</p>
                ${explanation}
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-1"><strong>Total Volume at Equivalence:</strong> ${totalVol} mL</p>
                <p class="mb-0"><strong>Expected pH Range:</strong> ${getExpectedRange(type)}</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

function getTitrationTypeName(type) {
    const names = {
        'strong-strong': 'Strong Acid + Strong Base',
        'weak-strong': 'Weak Acid + Strong Base',
        'strong-weak': 'Strong Acid + Weak Base',
        'weak-weak': 'Weak Acid + Weak Base'
    };
    return names[type];
}

function getExpectedRange(type) {
    const ranges = {
        'strong-strong': 'pH = 7.0 (neutral)',
        'weak-strong': 'pH > 7 (basic)',
        'strong-weak': 'pH < 7 (acidic)',
        'weak-weak': 'pH ≈ 7 (depends on Ka and Kb)'
    };
    return ranges[type];
}

// Titration Curve Generator
let titrationChart = null;

function updateCurveFields() {
    const type = document.getElementById('curveTitrationType').value;
    const kaGroup = document.getElementById('curveKaGroup');
    const kbGroup = document.getElementById('curveKbGroup');

    if (type === 'weak-acid-strong-base') {
        kaGroup.style.display = 'block';
        kbGroup.style.display = 'none';
    } else if (type === 'strong-acid-weak-base') {
        kaGroup.style.display = 'none';
        kbGroup.style.display = 'block';
    } else {
        kaGroup.style.display = 'none';
        kbGroup.style.display = 'none';
    }
}

function generateTitrationCurve() {
    const type = document.getElementById('curveTitrationType').value;
    const acidConc = parseFloat(document.getElementById('curveAcidConc').value);
    const acidVol = parseFloat(document.getElementById('curveAcidVol').value);
    const baseConc = parseFloat(document.getElementById('curveBaseConc').value);
    const ka = parseFloat(document.getElementById('curveKa').value);

    if (isNaN(acidConc) || isNaN(acidVol) || isNaN(baseConc)) {
        alert('Please enter all required values');
        return;
    }

    if (type === 'weak-acid-strong-base' && isNaN(ka)) {
        alert('Please enter Ka for weak acid');
        return;
    }

    // Calculate equivalence volume
    const equivVol = (acidConc * acidVol) / baseConc;

    // Generate data points
    const dataPoints = [];
    const volumes = [];

    // Before equivalence (0 to 1.2x equiv volume)
    for (let v = 0; v <= equivVol * 1.2; v += equivVol / 50) {
        volumes.push(v);
        const pH = calculatePh(type, acidConc, acidVol, baseConc, v, ka);
        dataPoints.push(pH);
    }

    // Display curve
    displayTitrationCurve(volumes, dataPoints, equivVol, type);
}

function calculatePh(type, ca, va, cb, vb, ka) {
    const kw = 1e-14;
    const totalVol = va + vb;
    const molesAcid = ca * va / 1000;
    const molesBase = cb * vb / 1000;

    if (type === 'strong-acid-strong-base') {
        if (vb === 0) {
            // Initial pH of strong acid
            return -Math.log10(ca);
        } else if (molesBase < molesAcid) {
            // Before equivalence - excess acid
            const excessAcid = molesAcid - molesBase;
            const hConc = excessAcid / (totalVol / 1000);
            return -Math.log10(hConc);
        } else if (molesBase === molesAcid) {
            // At equivalence
            return 7.0;
        } else {
            // After equivalence - excess base
            const excessBase = molesBase - molesAcid;
            const ohConc = excessBase / (totalVol / 1000);
            const poh = -Math.log10(ohConc);
            return 14 - poh;
        }
    } else if (type === 'weak-acid-strong-base') {
        if (vb === 0) {
            // Initial pH of weak acid - use Henderson-Hasselbalch approximation
            const hConc = Math.sqrt(ka * ca);
            return -Math.log10(hConc);
        } else if (molesBase < molesAcid) {
            // Buffer region - Henderson-Hasselbalch
            const molesA = molesBase; // conjugate base
            const molesHA = molesAcid - molesBase; // remaining acid
            const pka = -Math.log10(ka);
            return pka + Math.log10(molesA / molesHA);
        } else if (Math.abs(molesBase - molesAcid) < 0.0001) {
            // At equivalence - conjugate base hydrolysis
            const concBase = molesAcid / (totalVol / 1000);
            const kb = kw / ka;
            const ohConc = Math.sqrt(kb * concBase);
            const poh = -Math.log10(ohConc);
            return 14 - poh;
        } else {
            // After equivalence - excess strong base
            const excessBase = molesBase - molesAcid;
            const ohConc = excessBase / (totalVol / 1000);
            const poh = -Math.log10(ohConc);
            return 14 - poh;
        }
    }

    return 7; // Default
}

function displayTitrationCurve(volumes, pHs, equivVol, type) {
    let html = `
        <div class="result-section">
            <h6><span class="result-badge">TITRATION CURVE</span></h6>
            <canvas id="titrationChart"></canvas>

            <hr>

            <div class="info-box mt-3">
                <p class="mb-1"><strong>Equivalence Point:</strong> ${equivVol.toFixed(2)} mL</p>
                <p class="mb-1"><strong>pH at Equivalence:</strong> ${pHs[Math.floor(volumes.indexOf(equivVol) || volumes.length / 2)].toFixed(2)}</p>
                <p class="mb-0"><strong>Titration Type:</strong> ${type.replace(/-/g, ' ')}</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;

    // Create chart
    const ctx = document.getElementById('titrationChart').getContext('2d');

    if (titrationChart) {
        titrationChart.destroy();
    }

    titrationChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: volumes.map(v => v.toFixed(1)),
            datasets: [{
                label: 'pH',
                data: pHs,
                borderColor: '#3b82f6',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                borderWidth: 2,
                pointRadius: 0,
                tension: 0.1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                legend: {
                    display: false
                },
                annotation: {
                    annotations: [{
                        type: 'line',
                        mode: 'vertical',
                        scaleID: 'x',
                        value: equivVol.toFixed(1),
                        borderColor: '#ef4444',
                        borderWidth: 2,
                        borderDash: [5, 5],
                        label: {
                            content: 'Equivalence Point',
                            enabled: true
                        }
                    }]
                }
            },
            scales: {
                x: {
                    title: {
                        display: true,
                        text: 'Volume of Base Added (mL)'
                    },
                    ticks: {
                        maxTicksLimit: 10
                    }
                },
                y: {
                    title: {
                        display: true,
                        text: 'pH'
                    },
                    min: 0,
                    max: 14,
                    ticks: {
                        stepSize: 1
                    }
                }
            }
        }
    });
}

// Example setters
function setBasicExample(calc, m1, v1, v2, m2, n1, n2) {
    document.getElementById('basicCalculateWhat').value = calc;
    document.getElementById('basicM1').value = m1 || '';
    document.getElementById('basicV1').value = v1 || '';
    document.getElementById('basicV2').value = v2 || '';
    document.getElementById('basicM2').value = m2 || '';
    document.getElementById('basicN1').value = n1;
    document.getElementById('basicN2').value = n2;
}

function setPhExample(type, acidC, acidV, baseC, baseV, ka, kb) {
    document.getElementById('phTitrationType').value = type;
    updatePhFields();
    document.getElementById('phAcidConc').value = acidC;
    document.getElementById('phAcidVol').value = acidV;
    document.getElementById('phBaseConc').value = baseC;
    document.getElementById('phBaseVol').value = baseV;
    if (ka) document.getElementById('phKa').value = ka;
    if (kb) document.getElementById('phKb').value = kb;
}

function setCurveExample(type, acidC, acidV, baseC, ka) {
    document.getElementById('curveTitrationType').value = type;
    updateCurveFields();
    document.getElementById('curveAcidConc').value = acidC;
    document.getElementById('curveAcidVol').value = acidV;
    document.getElementById('curveBaseConc').value = baseC;
    if (ka) document.getElementById('curveKa').value = ka;
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
