<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thermochemistry Calculator - Calorimetry, Enthalpy, Hess's Law</title>
    <meta name="description" content="Free thermochemistry calculator for calorimetry (q=mcΔT), enthalpy changes, Hess's Law, and phase changes. Calculate heat transfer, specific heat, and energy changes with step-by-step solutions.">
    <meta name="keywords" content="thermochemistry calculator, calorimetry calculator, enthalpy calculator, hess's law calculator, heat capacity, phase change, q=mc delta t, chemistry calculator">

    <!-- Open Graph tags -->
    <meta property="og:title" content="Thermochemistry Calculator - Calorimetry & Enthalpy">
    <meta property="og:description" content="Calculate heat transfer, enthalpy changes, and solve thermochemistry problems. Free chemistry calculator with step-by-step solutions.">
    <meta property="og:type" content="website">

    <!-- Schema.org structured data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Thermochemistry Calculator",
        "description": "Calculate calorimetry problems (q=mcΔT), enthalpy changes, Hess's Law calculations, heat capacity, and phase change energy. Comprehensive thermochemistry tool with step-by-step solutions.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Calorimetry (q=mcΔT), Enthalpy calculations, Hess's Law solver, Heat capacity problems, Phase change calculations, Bond energy calculations, Step-by-step solutions",
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

        .exothermic-badge {
            background: #dc2626;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .endothermic-badge {
            background: #2563eb;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .result-badge {
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

        .equation-box {
            background: #eff6ff;
            border: 1px solid #bfdbfe;
            padding: 12px;
            margin: 10px 0;
            border-radius: 4px;
            font-family: 'Courier New', monospace;
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

        .formula-display {
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<div class="container mt-4">
    <h1 class="mb-3">Thermochemistry Calculator</h1>
    <p class="lead mb-4">
        Calculate heat transfer, enthalpy changes, solve calorimetry problems, and apply Hess's Law.
    </p>

    <div class="row">
        <!-- Left Column - Input Forms -->
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" id="calculatorTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="calorimetry-tab" data-toggle="tab" href="#calorimetryTab" role="tab">
                                <i class="fas fa-thermometer-half"></i> Calorimetry
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="enthalpy-tab" data-toggle="tab" href="#enthalpyTab" role="tab">
                                <i class="fas fa-fire"></i> Enthalpy
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="hess-tab" data-toggle="tab" href="#hessTab" role="tab">
                                <i class="fas fa-plus"></i> Hess's Law
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="phase-tab" data-toggle="tab" href="#phaseTab" role="tab">
                                <i class="fas fa-snowflake"></i> Phase Change
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Calorimetry Tab -->
                        <div class="tab-pane fade show active" id="calorimetryTab" role="tabpanel">
                            <h5 class="mb-3">Calorimetry Calculator (q = mcΔT)</h5>
                            <p class="text-muted small">Calculate heat transfer using the calorimetry equation.</p>

                            <div class="form-group">
                                <label><strong>Calculate:</strong></label>
                                <select class="form-control" id="calWhat">
                                    <option value="q">Heat transferred (q)</option>
                                    <option value="m">Mass (m)</option>
                                    <option value="c">Specific heat capacity (c)</option>
                                    <option value="deltaT">Temperature change (ΔT)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Mass (m)</label>
                                <div class="input-group">
                                    <input type="number" step="any" class="form-control" id="calMass" placeholder="e.g., 100">
                                    <div class="input-group-append">
                                        <select class="form-control" id="calMassUnit">
                                            <option value="g">grams (g)</option>
                                            <option value="kg">kilograms (kg)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Specific Heat Capacity (c)</label>
                                <div class="input-group">
                                    <input type="number" step="any" class="form-control" id="calC" placeholder="e.g., 4.184 for water">
                                    <div class="input-group-append">
                                        <span class="input-group-text">J/(g·°C)</span>
                                    </div>
                                </div>
                                <small class="form-text text-muted">Water: 4.184 J/(g·°C), Aluminum: 0.897, Iron: 0.449</small>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Initial Temperature (T₁)</label>
                                        <div class="input-group">
                                            <input type="number" step="any" class="form-control" id="calT1" placeholder="e.g., 25">
                                            <div class="input-group-append">
                                                <span class="input-group-text">°C</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label>Final Temperature (T₂)</label>
                                        <div class="input-group">
                                            <input type="number" step="any" class="form-control" id="calT2" placeholder="e.g., 75">
                                            <div class="input-group-append">
                                                <span class="input-group-text">°C</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateCalorimetry()">
                                <i class="fas fa-calculator"></i> Calculate
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Water Heating</div>
                                <span class="example-reaction" onclick="setCalExample('q', 100, 4.184, 25, 75)">100g water, 25°C → 75°C</span>
                                <span class="example-reaction" onclick="setCalExample('q', 250, 4.184, 20, 100)">250g water, 20°C → 100°C (boiling)</span>
                                <span class="example-reaction" onclick="setCalExample('deltaT', 500, 4.184, 15, '', 10460)">Heat 500g water with 10.46 kJ</span>

                                <div class="example-category">⭐⭐ Metal Heating</div>
                                <span class="example-reaction" onclick="setCalExample('q', 50, 0.897, 20, 150)">50g aluminum, 20°C → 150°C</span>
                                <span class="example-reaction" onclick="setCalExample('c', 100, '', 25, 85, 2688)">Find c: 100g metal, ΔT=60°C, q=2688J</span>
                                <span class="example-reaction" onclick="setCalExample('q', 75, 0.449, 100, 25)">75g iron cooling, 100°C → 25°C</span>

                                <div class="example-category">⭐⭐⭐ Coffee Cup Calorimetry</div>
                                <span class="example-reaction" onclick="setCalExample('q', 200, 4.184, 22, 28.5)">200g water, 22°C → 28.5°C (reaction)</span>
                            </div>
                        </div>

                        <!-- Enthalpy Tab -->
                        <div class="tab-pane fade" id="enthalpyTab" role="tabpanel">
                            <h5 class="mb-3">Enthalpy Change Calculator</h5>
                            <p class="text-muted small">Calculate enthalpy changes for reactions and processes.</p>

                            <div class="form-group">
                                <label><strong>Calculation Type</strong></label>
                                <select class="form-control" id="enthalpyType" onchange="updateEnthalpyFields()">
                                    <option value="reaction">Reaction Enthalpy (ΔH°rxn)</option>
                                    <option value="formation">Formation from Elements</option>
                                    <option value="combustion">Combustion Reaction</option>
                                    <option value="molar">Molar Enthalpy</option>
                                </select>
                            </div>

                            <div id="reactionEnthalpyFields">
                                <div class="form-group">
                                    <label>Heat Released/Absorbed (q)</label>
                                    <div class="input-group">
                                        <input type="number" step="any" class="form-control" id="enthalpyQ" placeholder="e.g., 5000">
                                        <div class="input-group-append">
                                            <select class="form-control" id="enthalpyQUnit">
                                                <option value="J">Joules (J)</option>
                                                <option value="kJ">kiloJoules (kJ)</option>
                                                <option value="cal">calories (cal)</option>
                                                <option value="kcal">kilocalories (kcal)</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label>Moles of Substance</label>
                                    <input type="number" step="any" class="form-control" id="enthalpyMoles" placeholder="e.g., 0.5">
                                </div>

                                <div class="form-group">
                                    <label><strong>Process Type</strong></label>
                                    <select class="form-control" id="enthalpyProcess">
                                        <option value="exothermic">Exothermic (releases heat, ΔH < 0)</option>
                                        <option value="endothermic">Endothermic (absorbs heat, ΔH > 0)</option>
                                    </select>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateEnthalpy()">
                                <i class="fas fa-calculator"></i> Calculate Enthalpy Change
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Exothermic Reactions</div>
                                <span class="example-reaction" onclick="setEnthalpyExample(890, 'kJ', 1, 'exothermic')">CH₄ combustion: 890 kJ/mol</span>
                                <span class="example-reaction" onclick="setEnthalpyExample(285.8, 'kJ', 2, 'exothermic')">H₂ + ½O₂: 285.8 kJ (2 mol H₂O)</span>
                                <span class="example-reaction" onclick="setEnthalpyExample(46.1, 'kJ', 1, 'exothermic')">HCl neutralization</span>

                                <div class="example-category">⭐⭐ Endothermic Reactions</div>
                                <span class="example-reaction" onclick="setEnthalpyExample(178, 'kJ', 1, 'endothermic')">N₂ + O₂ → 2NO: 178 kJ</span>
                                <span class="example-reaction" onclick="setEnthalpyExample(92.2, 'kJ', 1, 'endothermic')">NH₄NO₃ dissolution</span>
                                <span class="example-reaction" onclick="setEnthalpyExample(393.5, 'kJ', 0.5, 'endothermic')">CO₂ decomposition</span>
                            </div>
                        </div>

                        <!-- Hess's Law Tab -->
                        <div class="tab-pane fade" id="hessTab" role="tabpanel">
                            <h5 class="mb-3">Hess's Law Calculator</h5>
                            <p class="text-muted small">Calculate ΔH for a target reaction using known reactions.</p>

                            <div class="form-group">
                                <label><strong>Target Reaction</strong></label>
                                <input type="text" class="form-control" id="hessTarget" placeholder="e.g., C + O2 → CO2">
                            </div>

                            <div id="hessStepsList">
                                <h6 class="mt-3">Known Reactions</h6>
                            </div>

                            <button type="button" class="btn btn-secondary btn-sm mb-3" onclick="addHessStep()">
                                <i class="fas fa-plus"></i> Add Reaction Step
                            </button>

                            <button class="btn btn-primary btn-block" onclick="calculateHessLaw()">
                                <i class="fas fa-calculator"></i> Calculate ΔH using Hess's Law
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Carbon Monoxide Formation</div>
                                <span class="example-reaction" onclick="setHessExample1()">C + ½O₂ → CO (from C + O₂ and CO + ½O₂)</span>

                                <div class="example-category">⭐⭐ Methane Formation</div>
                                <span class="example-reaction" onclick="setHessExample2()">C + 2H₂ → CH₄ (multi-step)</span>
                            </div>
                        </div>

                        <!-- Phase Change Tab -->
                        <div class="tab-pane fade" id="phaseTab" role="tabpanel">
                            <h5 class="mb-3">Phase Change Energy Calculator</h5>
                            <p class="text-muted small">Calculate energy for melting, freezing, vaporization, or condensation.</p>

                            <div class="form-group">
                                <label><strong>Phase Change Type</strong></label>
                                <select class="form-control" id="phaseType" onchange="updatePhaseFields()">
                                    <option value="fusion">Melting/Freezing (ΔHfus)</option>
                                    <option value="vaporization">Vaporization/Condensation (ΔHvap)</option>
                                    <option value="sublimation">Sublimation/Deposition (ΔHsub)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Substance</label>
                                <select class="form-control" id="phaseSubstance" onchange="updatePhaseConstants()">
                                    <optgroup label="Common Substances">
                                        <option value="water">Water (H₂O)</option>
                                        <option value="ethanol">Ethanol (C₂H₅OH)</option>
                                        <option value="ammonia">Ammonia (NH₃)</option>
                                        <option value="methanol">Methanol (CH₃OH)</option>
                                        <option value="acetone">Acetone (CH₃COCH₃)</option>
                                    </optgroup>
                                    <optgroup label="Elements">
                                        <option value="oxygen">Oxygen (O₂)</option>
                                        <option value="nitrogen">Nitrogen (N₂)</option>
                                        <option value="hydrogen">Hydrogen (H₂)</option>
                                        <option value="helium">Helium (He)</option>
                                        <option value="argon">Argon (Ar)</option>
                                    </optgroup>
                                    <optgroup label="Metals">
                                        <option value="mercury">Mercury (Hg)</option>
                                        <option value="sodium">Sodium (Na)</option>
                                        <option value="lead">Lead (Pb)</option>
                                        <option value="aluminum">Aluminum (Al)</option>
                                        <option value="iron">Iron (Fe)</option>
                                    </optgroup>
                                    <optgroup label="Other">
                                        <option value="benzene">Benzene (C₆H₆)</option>
                                        <option value="chloroform">Chloroform (CHCl₃)</option>
                                        <option value="carbondioxide">Carbon Dioxide (CO₂)</option>
                                        <option value="custom">Custom...</option>
                                    </optgroup>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Enthalpy of Phase Change (ΔH)</label>
                                <div class="input-group">
                                    <input type="number" step="any" class="form-control" id="phaseDeltaH" placeholder="e.g., 6.01 for water fusion">
                                    <div class="input-group-append">
                                        <span class="input-group-text">kJ/mol</span>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Amount</label>
                                <div class="input-group">
                                    <input type="number" step="any" class="form-control" id="phaseAmount" placeholder="e.g., 100">
                                    <div class="input-group-append">
                                        <select class="form-control" id="phaseAmountUnit">
                                            <option value="g">grams (g)</option>
                                            <option value="mol">moles (mol)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Molar Mass (if using grams)</label>
                                <div class="input-group">
                                    <input type="number" step="any" class="form-control" id="phaseMolarMass" placeholder="e.g., 18.015 for water">
                                    <div class="input-group-append">
                                        <span class="input-group-text">g/mol</span>
                                    </div>
                                </div>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculatePhaseChange()">
                                <i class="fas fa-calculator"></i> Calculate Energy
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Water Phase Changes</div>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'water', 100, 'g')">Melt 100g ice</span>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'water', 500, 'g')">Melt 500g ice</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'water', 250, 'g')">Boil 250g water</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'water', 2, 'mol')">Vaporize 2 mol water</span>
                                <span class="example-reaction" onclick="setPhaseExample('sublimation', 'water', 50, 'g')">Sublimate 50g ice</span>

                                <div class="example-category">⭐⭐ Organic Solvents</div>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'ethanol', 100, 'g')">Boil 100g ethanol</span>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'ethanol', 1, 'mol')">Melt 1 mol ethanol</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'methanol', 50, 'g')">Boil 50g methanol</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'acetone', 75, 'g')">Boil 75g acetone</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'benzene', 2, 'mol')">Vaporize 2 mol benzene</span>

                                <div class="example-category">⭐⭐ Gases</div>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'ammonia', 1, 'mol')">Melt 1 mol ammonia</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'oxygen', 32, 'g')">Boil 32g oxygen</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'nitrogen', 2, 'mol')">Vaporize 2 mol nitrogen</span>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'hydrogen', 1, 'mol')">Melt 1 mol hydrogen</span>

                                <div class="example-category">⭐⭐⭐ Metals</div>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'mercury', 200, 'g')">Melt 200g mercury</span>
                                <span class="example-reaction" onclick="setPhaseExample('vaporization', 'mercury', 100, 'g')">Boil 100g mercury</span>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'sodium', 1, 'mol')">Melt 1 mol sodium</span>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'aluminum', 100, 'g')">Melt 100g aluminum</span>
                                <span class="example-reaction" onclick="setPhaseExample('fusion', 'iron', 1, 'mol')">Melt 1 mol iron</span>

                                <div class="example-category">⭐⭐⭐⭐ Sublimation</div>
                                <span class="example-reaction" onclick="setPhaseExample('sublimation', 'carbondioxide', 100, 'g')">Sublimate 100g dry ice (CO₂)</span>
                                <span class="example-reaction" onclick="setPhaseExample('sublimation', 'water', 1, 'mol')">Sublimate 1 mol ice</span>
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
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Understanding Thermochemistry</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><strong>Key Concepts</strong></h6>
                            <ul>
                                <li><strong>Heat (q):</strong> Energy transferred between systems</li>
                                <li><strong>Enthalpy (ΔH):</strong> Heat change at constant pressure</li>
                                <li><strong>Exothermic:</strong> Releases heat (ΔH < 0)</li>
                                <li><strong>Endothermic:</strong> Absorbs heat (ΔH > 0)</li>
                                <li><strong>Specific Heat (c):</strong> Heat per gram per degree</li>
                            </ul>

                            <h6 class="mt-3"><strong>Important Equations</strong></h6>
                            <ul>
                                <li><strong>q = mcΔT</strong> - Calorimetry equation</li>
                                <li><strong>ΔH°rxn = Σ ΔH°f(products) - Σ ΔH°f(reactants)</strong></li>
                                <li><strong>q = n × ΔH</strong> - Heat from moles</li>
                                <li><strong>ΔHsub = ΔHfus + ΔHvap</strong></li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <h6><strong>Hess's Law</strong></h6>
                            <p>The total enthalpy change for a reaction is independent of the pathway taken.</p>
                            <p><strong>Steps:</strong></p>
                            <ol>
                                <li>Reverse reactions: change sign of ΔH</li>
                                <li>Multiply reactions: multiply ΔH by factor</li>
                                <li>Add reactions: add ΔH values</li>
                            </ol>

                            <h6 class="mt-3"><strong>Common Values</strong></h6>
                            <p><strong>Specific Heat (c):</strong></p>
                            <ul>
                                <li>Water: 4.184 J/(g·°C)</li>
                                <li>Ice: 2.09 J/(g·°C)</li>
                                <li>Aluminum: 0.897 J/(g·°C)</li>
                                <li>Iron: 0.449 J/(g·°C)</li>
                            </ul>
                            <p><strong>Water Phase Changes:</strong></p>
                            <ul>
                                <li>ΔHfus: 6.01 kJ/mol</li>
                                <li>ΔHvap: 40.7 kJ/mol</li>
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
// Calorimetry Calculator
function calculateCalorimetry() {
    const what = document.getElementById('calWhat').value;
    const mass = parseFloat(document.getElementById('calMass').value);
    const massUnit = document.getElementById('calMassUnit').value;
    const c = parseFloat(document.getElementById('calC').value);
    const t1 = parseFloat(document.getElementById('calT1').value);
    const t2 = parseFloat(document.getElementById('calT2').value);

    // Convert mass to grams if needed
    const massG = massUnit === 'kg' ? mass * 1000 : mass;

    let result, resultValue, steps;

    const deltaT = t2 - t1;

    switch(what) {
        case 'q':
            if (isNaN(massG) || isNaN(c) || isNaN(deltaT)) {
                alert('Please enter mass, specific heat, and both temperatures');
                return;
            }
            resultValue = massG * c * deltaT;
            result = `q = ${resultValue.toFixed(2)} J`;
            if (Math.abs(resultValue) > 1000) {
                result += ` = ${(resultValue / 1000).toFixed(2)} kJ`;
            }

            steps = `
                <p class="mb-2"><strong>Given:</strong></p>
                <p class="mb-1 ml-3">m = ${mass} ${massUnit} = ${massG} g</p>
                <p class="mb-1 ml-3">c = ${c} J/(g·°C)</p>
                <p class="mb-1 ml-3">T₁ = ${t1}°C</p>
                <p class="mb-1 ml-3">T₂ = ${t2}°C</p>
                <p class="mb-3 ml-3">ΔT = T₂ - T₁ = ${deltaT}°C</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">q = mcΔT</p>

                <p class="mb-2"><strong>Calculation:</strong></p>
                <p class="mb-1 ml-3">q = (${massG} g) × (${c} J/(g·°C)) × (${deltaT}°C)</p>
                <p class="mb-0 ml-3">q = ${resultValue.toFixed(2)} J</p>
            `;
            break;

        case 'deltaT':
            const qInput = parseFloat(prompt('Enter heat (q) in Joules:'));
            if (isNaN(massG) || isNaN(c) || isNaN(qInput)) {
                alert('Please enter mass, specific heat, and heat value');
                return;
            }
            resultValue = qInput / (massG * c);
            result = `ΔT = ${resultValue.toFixed(2)}°C`;

            steps = `
                <p class="mb-2"><strong>Given:</strong></p>
                <p class="mb-1 ml-3">q = ${qInput} J</p>
                <p class="mb-1 ml-3">m = ${massG} g</p>
                <p class="mb-3 ml-3">c = ${c} J/(g·°C)</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">ΔT = q / (m × c)</p>

                <p class="mb-2"><strong>Calculation:</strong></p>
                <p class="mb-1 ml-3">ΔT = ${qInput} J / (${massG} g × ${c} J/(g·°C))</p>
                <p class="mb-0 ml-3">ΔT = ${resultValue.toFixed(2)}°C</p>
            `;
            break;

        case 'c':
            const qForC = parseFloat(prompt('Enter heat (q) in Joules:'));
            if (isNaN(massG) || isNaN(deltaT) || isNaN(qForC)) {
                alert('Please enter mass, temperature change, and heat value');
                return;
            }
            resultValue = qForC / (massG * deltaT);
            result = `c = ${resultValue.toFixed(3)} J/(g·°C)`;

            steps = `
                <p class="mb-2"><strong>Given:</strong></p>
                <p class="mb-1 ml-3">q = ${qForC} J</p>
                <p class="mb-1 ml-3">m = ${massG} g</p>
                <p class="mb-3 ml-3">ΔT = ${deltaT}°C</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">c = q / (m × ΔT)</p>

                <p class="mb-2"><strong>Calculation:</strong></p>
                <p class="mb-1 ml-3">c = ${qForC} J / (${massG} g × ${deltaT}°C)</p>
                <p class="mb-0 ml-3">c = ${resultValue.toFixed(3)} J/(g·°C)</p>
            `;
            break;

        case 'm':
            const qForM = parseFloat(prompt('Enter heat (q) in Joules:'));
            if (isNaN(c) || isNaN(deltaT) || isNaN(qForM)) {
                alert('Please enter specific heat, temperature change, and heat value');
                return;
            }
            resultValue = qForM / (c * deltaT);
            result = `m = ${resultValue.toFixed(2)} g`;

            steps = `
                <p class="mb-2"><strong>Given:</strong></p>
                <p class="mb-1 ml-3">q = ${qForM} J</p>
                <p class="mb-1 ml-3">c = ${c} J/(g·°C)</p>
                <p class="mb-3 ml-3">ΔT = ${deltaT}°C</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">m = q / (c × ΔT)</p>

                <p class="mb-2"><strong>Calculation:</strong></p>
                <p class="mb-1 ml-3">m = ${qForM} J / (${c} J/(g·°C) × ${deltaT}°C)</p>
                <p class="mb-0 ml-3">m = ${resultValue.toFixed(2)} g</p>
            `;
            break;
    }

    const processType = deltaT > 0 ? 'endothermic' : 'exothermic';
    const processBadge = deltaT > 0 ? 'endothermic-badge' : 'exothermic-badge';
    const processText = deltaT > 0 ? 'Heat absorbed (heating)' : 'Heat released (cooling)';

    let html = `
        <div class="result-section">
            <h6><span class="result-badge">RESULT</span></h6>
            <h4 class="mb-3">${result}</h4>

            ${what === 'q' ? `<p class="mb-2"><span class="${processBadge}">${processText.toUpperCase()}</span></p>` : ''}

            <hr>

            <h6><span class="step-badge">CALCULATION STEPS</span></h6>
            <div class="step-section">
                ${steps}
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Enthalpy Calculator
function updateEnthalpyFields() {
    // Placeholder for future field updates
}

function calculateEnthalpy() {
    const q = parseFloat(document.getElementById('enthalpyQ').value);
    const qUnit = document.getElementById('enthalpyQUnit').value;
    const moles = parseFloat(document.getElementById('enthalpyMoles').value);
    const process = document.getElementById('enthalpyProcess').value;

    if (isNaN(q) || isNaN(moles)) {
        alert('Please enter heat and moles');
        return;
    }

    // Convert to kJ
    let qKJ = q;
    if (qUnit === 'J') qKJ = q / 1000;
    else if (qUnit === 'cal') qKJ = q * 0.004184;
    else if (qUnit === 'kcal') qKJ = q * 4.184;

    // Calculate ΔH per mole
    let deltaH = qKJ / moles;

    // Apply sign based on process
    if (process === 'exothermic') {
        deltaH = -Math.abs(deltaH);
    } else {
        deltaH = Math.abs(deltaH);
    }

    const badge = process === 'exothermic' ? 'exothermic-badge' : 'endothermic-badge';
    const processName = process === 'exothermic' ? 'EXOTHERMIC (ΔH < 0)' : 'ENDOTHERMIC (ΔH > 0)';

    let html = `
        <div class="result-section">
            <h6><span class="result-badge">ENTHALPY CHANGE</span></h6>
            <h4 class="mb-3">ΔH = ${deltaH.toFixed(2)} kJ/mol</h4>

            <p class="mb-2"><span class="${badge}">${processName}</span></p>

            <hr>

            <h6><span class="step-badge">CALCULATION</span></h6>
            <div class="step-section">
                <p class="mb-2"><strong>Given:</strong></p>
                <p class="mb-1 ml-3">q = ${q} ${qUnit} = ${qKJ.toFixed(2)} kJ</p>
                <p class="mb-3 ml-3">n = ${moles} mol</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">ΔH = q / n</p>

                <p class="mb-2"><strong>Calculation:</strong></p>
                <p class="mb-1 ml-3">ΔH = ${qKJ.toFixed(2)} kJ / ${moles} mol</p>
                <p class="mb-1 ml-3">ΔH = ${Math.abs(deltaH).toFixed(2)} kJ/mol</p>
                <p class="mb-0 ml-3">Since ${process}, ΔH = ${deltaH.toFixed(2)} kJ/mol</p>
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Interpretation:</strong> ${process === 'exothermic' ? 'Energy is released to surroundings. Products have lower energy than reactants.' : 'Energy is absorbed from surroundings. Products have higher energy than reactants.'}</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Hess's Law Calculator
let hessStepCount = 0;

function addHessStep() {
    const container = document.getElementById('hessStepsList');
    const id = hessStepCount++;

    const html = `
        <div class="equation-box" id="hessStep${id}">
            <div class="row align-items-center">
                <div class="col-8">
                    <input type="text" class="form-control form-control-sm mb-1" id="hessEq${id}" placeholder="Reaction equation">
                    <input type="number" step="any" class="form-control form-control-sm" id="hessDH${id}" placeholder="ΔH (kJ)">
                </div>
                <div class="col-3">
                    <input type="number" step="1" class="form-control form-control-sm" id="hessMult${id}" placeholder="×" value="1">
                    <small class="text-muted">Multiplier</small>
                </div>
                <div class="col-1">
                    <i class="fas fa-times text-danger" style="cursor:pointer;" onclick="removeHessStep(${id})"></i>
                </div>
            </div>
        </div>
    `;

    container.insertAdjacentHTML('beforeend', html);
}

function removeHessStep(id) {
    document.getElementById(`hessStep${id}`)?.remove();
}

function calculateHessLaw() {
    let totalDH = 0;
    let steps = '';

    for (let i = 0; i < hessStepCount; i++) {
        const eq = document.getElementById(`hessEq${i}`)?.value;
        const dh = parseFloat(document.getElementById(`hessDH${i}`)?.value);
        const mult = parseFloat(document.getElementById(`hessMult${i}`)?.value || 1);

        if (eq && !isNaN(dh)) {
            const contribution = dh * mult;
            totalDH += contribution;
            steps += `<p class="mb-1">${eq}: ${dh} kJ × ${mult} = ${contribution.toFixed(2)} kJ</p>`;
        }
    }

    if (steps === '') {
        alert('Please add at least one reaction step');
        return;
    }

    let html = `
        <div class="result-section">
            <h6><span class="result-badge">HESS'S LAW RESULT</span></h6>
            <h4 class="mb-3">ΔH°rxn = ${totalDH.toFixed(2)} kJ</h4>

            <hr>

            <h6><span class="step-badge">REACTION STEPS</span></h6>
            <div class="step-section">
                ${steps}
                <hr>
                <p class="mb-0"><strong>Total: ${totalDH.toFixed(2)} kJ</strong></p>
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Hess's Law:</strong> The total enthalpy change is the sum of the individual steps, regardless of the pathway.</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Phase Change Calculator - Expanded Database
const phaseConstants = {
    // Common substances
    water: { fusion: 6.01, vaporization: 40.7, molarMass: 18.015 },
    ethanol: { fusion: 4.9, vaporization: 38.6, molarMass: 46.07 },
    ammonia: { fusion: 5.66, vaporization: 23.3, molarMass: 17.03 },
    methanol: { fusion: 3.22, vaporization: 35.3, molarMass: 32.04 },
    acetone: { fusion: 5.69, vaporization: 29.1, molarMass: 58.08 },

    // Elements
    oxygen: { fusion: 0.444, vaporization: 6.82, molarMass: 32.00 },
    nitrogen: { fusion: 0.720, vaporization: 5.57, molarMass: 28.01 },
    hydrogen: { fusion: 0.117, vaporization: 0.904, molarMass: 2.016 },
    helium: { fusion: 0.021, vaporization: 0.0829, molarMass: 4.003 },
    argon: { fusion: 1.18, vaporization: 6.43, molarMass: 39.95 },

    // Metals
    mercury: { fusion: 2.29, vaporization: 59.1, molarMass: 200.59 },
    sodium: { fusion: 2.60, vaporization: 97.4, molarMass: 22.99 },
    lead: { fusion: 4.77, vaporization: 179.5, molarMass: 207.2 },
    aluminum: { fusion: 10.71, vaporization: 294, molarMass: 26.98 },
    iron: { fusion: 13.81, vaporization: 340, molarMass: 55.85 },

    // Other
    benzene: { fusion: 9.87, vaporization: 30.8, molarMass: 78.11 },
    chloroform: { fusion: 9.5, vaporization: 29.4, molarMass: 119.38 },
    carbondioxide: { fusion: 8.33, vaporization: 15.3, molarMass: 44.01 }
};

function updatePhaseFields() {
    updatePhaseConstants();
}

function updatePhaseConstants() {
    const substance = document.getElementById('phaseSubstance').value;
    const type = document.getElementById('phaseType').value;

    if (substance !== 'custom' && phaseConstants[substance]) {
        const deltaH = type === 'fusion' ? phaseConstants[substance].fusion :
                       type === 'vaporization' ? phaseConstants[substance].vaporization :
                       phaseConstants[substance].fusion + phaseConstants[substance].vaporization;

        document.getElementById('phaseDeltaH').value = deltaH;
        document.getElementById('phaseMolarMass').value = phaseConstants[substance].molarMass;
    }
}

function calculatePhaseChange() {
    const type = document.getElementById('phaseType').value;
    const deltaH = parseFloat(document.getElementById('phaseDeltaH').value);
    const amount = parseFloat(document.getElementById('phaseAmount').value);
    const amountUnit = document.getElementById('phaseAmountUnit').value;
    const molarMass = parseFloat(document.getElementById('phaseMolarMass').value);

    if (isNaN(deltaH) || isNaN(amount)) {
        alert('Please enter enthalpy and amount');
        return;
    }

    // Convert to moles if needed
    let moles = amountUnit === 'mol' ? amount : amount / molarMass;

    // Calculate energy
    const energy = moles * deltaH;

    const typeName = type === 'fusion' ? 'Melting/Freezing' :
                     type === 'vaporization' ? 'Vaporization/Condensation' : 'Sublimation';

    let html = `
        <div class="result-section">
            <h6><span class="result-badge">PHASE CHANGE ENERGY</span></h6>
            <h4 class="mb-3">q = ${energy.toFixed(2)} kJ</h4>

            <p class="mb-2"><span class="endothermic-badge">${typeName.toUpperCase()}</span></p>

            <hr>

            <h6><span class="step-badge">CALCULATION</span></h6>
            <div class="step-section">
                <p class="mb-2"><strong>Given:</strong></p>
                <p class="mb-1 ml-3">ΔH = ${deltaH} kJ/mol</p>
                <p class="mb-1 ml-3">Amount = ${amount} ${amountUnit}</p>
                ${amountUnit === 'g' ? `<p class="mb-1 ml-3">Molar Mass = ${molarMass} g/mol</p>` : ''}
                <p class="mb-3 ml-3">Moles = ${moles.toFixed(4)} mol</p>

                <p class="mb-2"><strong>Formula:</strong></p>
                <p class="mb-3 ml-3">q = n × ΔH</p>

                <p class="mb-2"><strong>Calculation:</strong></p>
                <p class="mb-1 ml-3">q = ${moles.toFixed(4)} mol × ${deltaH} kJ/mol</p>
                <p class="mb-0 ml-3">q = ${energy.toFixed(2)} kJ</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Example setters
function setCalExample(what, m, c, t1, t2, q) {
    document.getElementById('calWhat').value = what;
    if (m) document.getElementById('calMass').value = m;
    if (c) document.getElementById('calC').value = c;
    if (t1) document.getElementById('calT1').value = t1;
    if (t2) document.getElementById('calT2').value = t2;
}

function setEnthalpyExample(q, unit, moles, process) {
    document.getElementById('enthalpyQ').value = q;
    document.getElementById('enthalpyQUnit').value = unit;
    document.getElementById('enthalpyMoles').value = moles;
    document.getElementById('enthalpyProcess').value = process;
}

function setHessExample1() {
    document.getElementById('hessTarget').value = 'C + 1/2 O2 → CO';
    hessStepCount = 0;
    document.getElementById('hessStepsList').innerHTML = '<h6 class="mt-3">Known Reactions</h6>';
    addHessStep();
    document.getElementById('hessEq0').value = 'C + O2 → CO2';
    document.getElementById('hessDH0').value = -393.5;
    document.getElementById('hessMult0').value = 1;
    addHessStep();
    document.getElementById('hessEq1').value = 'CO + 1/2 O2 → CO2';
    document.getElementById('hessDH1').value = -283.0;
    document.getElementById('hessMult1').value = -1;
}

function setHessExample2() {
    document.getElementById('hessTarget').value = 'C + 2H2 → CH4';
    hessStepCount = 0;
    document.getElementById('hessStepsList').innerHTML = '<h6 class="mt-3">Known Reactions</h6>';
    addHessStep();
    document.getElementById('hessEq0').value = 'C + O2 → CO2';
    document.getElementById('hessDH0').value = -393.5;
    addHessStep();
    document.getElementById('hessEq1').value = 'H2 + 1/2 O2 → H2O';
    document.getElementById('hessDH1').value = -285.8;
    document.getElementById('hessMult1').value = 2;
    addHessStep();
    document.getElementById('hessEq2').value = 'CH4 + 2O2 → CO2 + 2H2O';
    document.getElementById('hessDH2').value = -890.3;
    document.getElementById('hessMult2').value = -1;
}

function setPhaseExample(type, substance, amount, unit) {
    document.getElementById('phaseType').value = type;
    document.getElementById('phaseSubstance').value = substance;
    document.getElementById('phaseAmount').value = amount;
    document.getElementById('phaseAmountUnit').value = unit;
    updatePhaseConstants();
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    addHessStep();
    addHessStep();
});
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
