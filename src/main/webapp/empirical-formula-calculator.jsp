<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Empirical & Molecular Formula Calculator - Chemistry Tools</title>
    <meta name="description" content="Calculate empirical and molecular formulas from percent composition, mass data, or combustion analysis. Free online chemistry calculator with step-by-step solutions.">
    <meta name="keywords" content="empirical formula calculator, molecular formula calculator, percent composition, combustion analysis, chemistry calculator">

    <!-- Open Graph tags -->
    <meta property="og:title" content="Empirical & Molecular Formula Calculator">
    <meta property="og:description" content="Calculate empirical and molecular formulas from percent composition, mass data, or combustion analysis. Free chemistry calculator with step-by-step solutions.">
    <meta property="og:type" content="website">

    <!-- Schema.org structured data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Empirical & Molecular Formula Calculator",
        "description": "Calculate empirical formulas from percent composition or mass data, and determine molecular formulas from empirical formulas and molar mass. Includes combustion analysis calculator.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Percent composition to empirical formula, Mass data to empirical formula, Empirical to molecular formula conversion, Combustion analysis calculator, Automatic molar mass calculation, Step-by-step solutions",
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

        .empirical-badge {
            background: #8b5cf6;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .molecular-badge {
            background: #ec4899;
            color: white;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .step-badge {
            background: #3b82f6;
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

        .element-input-group {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 12px;
            margin-bottom: 10px;
        }

        .add-element-btn {
            width: 100%;
            border: 2px dashed #d1d5db;
            background: #f9fafb;
            color: #6b7280;
            padding: 10px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .add-element-btn:hover {
            border-color: #9ca3af;
            background: #f3f4f6;
            color: #374151;
        }

        .remove-element-btn {
            color: #dc2626;
            cursor: pointer;
            font-size: 1.2rem;
        }

        .remove-element-btn:hover {
            color: #991b1b;
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

        .formula-display {
            font-family: 'Courier New', monospace;
            font-size: 1.1rem;
            font-weight: 600;
            color: #1f2937;
        }

        sub {
            font-size: 0.75em;
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="mb-3">Empirical & Molecular Formula Calculator</h1>
    <p class="lead mb-4">
        Calculate empirical formulas from percent composition or mass data, and determine molecular formulas from empirical formulas and molar mass.
    </p>

    <div class="row">
        <!-- Left Column - Input Forms -->
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" id="calculatorTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="percent-tab" data-toggle="tab" href="#percentTab" role="tab">
                                <i class="fas fa-percentage"></i> % Composition
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="mass-tab" data-toggle="tab" href="#massTab" role="tab">
                                <i class="fas fa-weight"></i> Mass Data
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="molecular-tab" data-toggle="tab" href="#molecularTab" role="tab">
                                <i class="fas fa-arrow-right"></i> Emp → Mol
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="combustion-tab" data-toggle="tab" href="#combustionTab" role="tab">
                                <i class="fas fa-fire"></i> Combustion
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Percent Composition Tab -->
                        <div class="tab-pane fade show active" id="percentTab" role="tabpanel">
                            <h5 class="mb-3">Percent Composition → Empirical Formula</h5>
                            <p class="text-muted small">Enter the percent composition of each element. Total should equal 100%.</p>

                            <div id="percentElementsList"></div>

                            <button type="button" class="add-element-btn mb-3" onclick="addPercentElement()">
                                <i class="fas fa-plus"></i> Add Element
                            </button>

                            <button class="btn btn-primary btn-block" onclick="calculateFromPercent()">
                                <i class="fas fa-calculator"></i> Calculate Empirical Formula
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>
                                <span class="example-reaction" onclick="setPercentExample('C', 40.0, 'H', 6.7, 'O', 53.3)">C: 40.0%, H: 6.7%, O: 53.3% (CH₂O)</span>
                                <span class="example-reaction" onclick="setPercentExample('C', 92.3, 'H', 7.7)">C: 92.3%, H: 7.7% (CH)</span>
                                <span class="example-reaction" onclick="setPercentExample('Na', 32.4, 'S', 22.6, 'O', 45.0)">Na: 32.4%, S: 22.6%, O: 45% (Na₂SO₄)</span>
                                <span class="example-reaction" onclick="setPercentExample('C', 85.7, 'H', 14.3)">C: 85.7%, H: 14.3% (CH₂)</span>
                                <span class="example-reaction" onclick="setPercentExample('Fe', 69.9, 'O', 30.1)">Fe: 69.9%, O: 30.1% (Fe₂O₃)</span>
                                <span class="example-reaction" onclick="setPercentExample('Ca', 40.0, 'C', 12.0, 'O', 48.0)">Ca: 40%, C: 12%, O: 48% (CaCO₃)</span>
                            </div>
                        </div>

                        <!-- Mass Data Tab -->
                        <div class="tab-pane fade" id="massTab" role="tabpanel">
                            <h5 class="mb-3">Mass Data → Empirical Formula</h5>
                            <p class="text-muted small">Enter the mass (in grams) of each element in the compound.</p>

                            <div id="massElementsList"></div>

                            <button type="button" class="add-element-btn mb-3" onclick="addMassElement()">
                                <i class="fas fa-plus"></i> Add Element
                            </button>

                            <button class="btn btn-primary btn-block" onclick="calculateFromMass()">
                                <i class="fas fa-calculator"></i> Calculate Empirical Formula
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>
                                <span class="example-reaction" onclick="setMassExample('C', 12.01, 'H', 2.02, 'O', 16.00)">12.01g C, 2.02g H, 16.00g O</span>
                                <span class="example-reaction" onclick="setMassExample('Na', 2.30, 'Cl', 3.55)">2.30g Na, 3.55g Cl</span>
                                <span class="example-reaction" onclick="setMassExample('Fe', 11.16, 'O', 4.80)">11.16g Fe, 4.80g O</span>
                                <span class="example-reaction" onclick="setMassExample('C', 1.50, 'H', 0.25, 'N', 1.75)">1.50g C, 0.25g H, 1.75g N</span>
                            </div>
                        </div>

                        <!-- Empirical to Molecular Tab -->
                        <div class="tab-pane fade" id="molecularTab" role="tabpanel">
                            <h5 class="mb-3">Empirical → Molecular Formula</h5>
                            <p class="text-muted small">Convert an empirical formula to its molecular formula using the compound's molar mass.</p>

                            <div class="form-group">
                                <label><strong>Empirical Formula</strong></label>
                                <input type="text" class="form-control" id="empiricalFormula" placeholder="e.g., CH2O, CH, NO2">
                                <small class="form-text text-muted">Enter the empirical formula</small>
                            </div>

                            <div class="form-group">
                                <label><strong>Molar Mass of Compound (g/mol)</strong></label>
                                <input type="number" step="any" class="form-control" id="compoundMolarMass" placeholder="e.g., 180.16">
                                <small class="form-text text-muted">Enter the experimentally determined molar mass</small>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateMolecularFormula()">
                                <i class="fas fa-calculator"></i> Calculate Molecular Formula
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>
                                <span class="example-reaction" onclick="setMolecularExample('CH2O', 180.16)">CH₂O → ? (MM: 180 g/mol)</span>
                                <span class="example-reaction" onclick="setMolecularExample('CH', 78.11)">CH → ? (MM: 78 g/mol)</span>
                                <span class="example-reaction" onclick="setMolecularExample('NO2', 92.02)">NO₂ → ? (MM: 92 g/mol)</span>
                                <span class="example-reaction" onclick="setMolecularExample('CH2', 84.16)">CH₂ → ? (MM: 84 g/mol)</span>
                                <span class="example-reaction" onclick="setMolecularExample('C2H5', 58.12)">C₂H₅ → ? (MM: 58 g/mol)</span>
                            </div>
                        </div>

                        <!-- Combustion Analysis Tab -->
                        <div class="tab-pane fade" id="combustionTab" role="tabpanel">
                            <h5 class="mb-3">Combustion Analysis</h5>
                            <p class="text-muted small">Determine empirical formula from combustion products (CO₂ and H₂O).</p>

                            <div class="form-group">
                                <label><strong>Mass of Original Compound (g)</strong></label>
                                <input type="number" step="any" class="form-control" id="compoundMass" placeholder="e.g., 1.000">
                            </div>

                            <div class="form-group">
                                <label><strong>Mass of CO₂ Produced (g)</strong></label>
                                <input type="number" step="any" class="form-control" id="co2Mass" placeholder="e.g., 2.200">
                            </div>

                            <div class="form-group">
                                <label><strong>Mass of H₂O Produced (g)</strong></label>
                                <input type="number" step="any" class="form-control" id="h2oMass" placeholder="e.g., 0.900">
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="containsNitrogen">
                                <label class="form-check-label" for="containsNitrogen">
                                    Compound contains Nitrogen
                                </label>
                            </div>

                            <div id="nitrogenInput" style="display:none;">
                                <div class="form-group">
                                    <label><strong>Mass of N₂ Produced (g)</strong></label>
                                    <input type="number" step="any" class="form-control" id="n2Mass" placeholder="e.g., 0.466">
                                </div>
                            </div>

                            <div class="form-check mb-3">
                                <input class="form-check-input" type="checkbox" id="containsOxygen">
                                <label class="form-check-label" for="containsOxygen">
                                    Compound contains Oxygen
                                </label>
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateFromCombustion()">
                                <i class="fas fa-calculator"></i> Calculate Empirical Formula
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>
                                <span class="example-reaction" onclick="setCombustionExample(1.000, 2.200, 0.900, false, 0, true)">Glucose: 1.00g → 2.20g CO₂, 0.90g H₂O</span>
                                <span class="example-reaction" onclick="setCombustionExample(0.500, 1.467, 0.300, false, 0, false)">Hydrocarbon: 0.50g → 1.47g CO₂, 0.30g H₂O</span>
                                <span class="example-reaction" onclick="setCombustionExample(1.000, 1.467, 0.601, true, 0.466, false)">Amine: 1.00g → 1.47g CO₂, 0.60g H₂O, 0.47g N₂</span>
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
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Understanding Empirical & Molecular Formulas</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><strong>Empirical Formula</strong></h6>
                            <p>The simplest whole-number ratio of atoms in a compound.</p>
                            <p><strong>Example:</strong> Glucose (C₆H₁₂O₆) has empirical formula CH₂O</p>

                            <h6 class="mt-3"><strong>Molecular Formula</strong></h6>
                            <p>The actual number of atoms of each element in a molecule.</p>
                            <p><strong>Example:</strong> Glucose molecular formula is C₆H₁₂O₆</p>
                        </div>
                        <div class="col-md-6">
                            <h6><strong>Key Concepts</strong></h6>
                            <ul>
                                <li><strong>Percent Composition:</strong> % of each element by mass</li>
                                <li><strong>Mole Ratio:</strong> Convert mass/percent to moles, then divide by smallest</li>
                                <li><strong>Combustion Analysis:</strong> Burn compound, analyze CO₂ and H₂O products</li>
                                <li><strong>Multiplier (n):</strong> Molecular Mass / Empirical Mass</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Periodic Table Data (IUPAC 2021 Standard Atomic Weights)
const ELEMENTS = {
    'H': 1.008, 'He': 4.003, 'Li': 6.941, 'Be': 9.012, 'B': 10.81, 'C': 12.01, 'N': 14.01, 'O': 16.00,
    'F': 19.00, 'Ne': 20.18, 'Na': 22.99, 'Mg': 24.31, 'Al': 26.98, 'Si': 28.09, 'P': 30.97, 'S': 32.07,
    'Cl': 35.45, 'Ar': 39.95, 'K': 39.10, 'Ca': 40.08, 'Sc': 44.96, 'Ti': 47.87, 'V': 50.94, 'Cr': 52.00,
    'Mn': 54.94, 'Fe': 55.85, 'Co': 58.93, 'Ni': 58.69, 'Cu': 63.55, 'Zn': 65.38, 'Ga': 69.72, 'Ge': 72.63,
    'As': 74.92, 'Se': 78.97, 'Br': 79.90, 'Kr': 83.80, 'Rb': 85.47, 'Sr': 87.62, 'Y': 88.91, 'Zr': 91.22,
    'Nb': 92.91, 'Mo': 95.95, 'Tc': 98.00, 'Ru': 101.07, 'Rh': 102.91, 'Pd': 106.42, 'Ag': 107.87, 'Cd': 112.41,
    'In': 114.82, 'Sn': 118.71, 'Sb': 121.76, 'Te': 127.60, 'I': 126.90, 'Xe': 131.29, 'Cs': 132.91, 'Ba': 137.33,
    'La': 138.91, 'Ce': 140.12, 'Pr': 140.91, 'Nd': 144.24, 'Pm': 145.00, 'Sm': 150.36, 'Eu': 151.96, 'Gd': 157.25,
    'Tb': 158.93, 'Dy': 162.50, 'Ho': 164.93, 'Er': 167.26, 'Tm': 168.93, 'Yb': 173.05, 'Lu': 174.97, 'Hf': 178.49,
    'Ta': 180.95, 'W': 183.84, 'Re': 186.21, 'Os': 190.23, 'Ir': 192.22, 'Pt': 195.08, 'Au': 196.97, 'Hg': 200.59,
    'Tl': 204.38, 'Pb': 207.2, 'Bi': 208.98, 'Po': 209.00, 'At': 210.00, 'Rn': 222.00, 'Fr': 223.00, 'Ra': 226.00,
    'Ac': 227.00, 'Th': 232.04, 'Pa': 231.04, 'U': 238.03
};

// Calculate molar mass from formula
function calculateMolarMass(formula) {
    let mass = 0;
    const regex = /([A-Z][a-z]?)(\d*)|(\()([^)]+)(\))(\d*)/g;
    let match;

    while ((match = regex.exec(formula)) !== null) {
        if (match[1]) {
            // Simple element
            const element = match[1];
            const count = match[2] ? parseInt(match[2]) : 1;
            if (ELEMENTS[element]) {
                mass += ELEMENTS[element] * count;
            } else {
                throw new Error(`Unknown element: ${element}`);
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

// Initialize with 2 elements for percent composition
let percentElementCount = 0;
function initPercentElements() {
    percentElementCount = 0;
    document.getElementById('percentElementsList').innerHTML = '';
    addPercentElement();
    addPercentElement();
}

function addPercentElement() {
    const container = document.getElementById('percentElementsList');
    const id = percentElementCount++;

    const html = `
        <div class="element-input-group" id="percentElement${id}">
            <div class="row align-items-center">
                <div class="col-4">
                    <label class="mb-1"><strong>Element</strong></label>
                    <input type="text" class="form-control" id="percentElem${id}" placeholder="e.g., C">
                </div>
                <div class="col-6">
                    <label class="mb-1"><strong>Percentage (%)</strong></label>
                    <input type="number" step="any" class="form-control" id="percentVal${id}" placeholder="e.g., 40.0">
                </div>
                <div class="col-2 text-right">
                    <label class="mb-1 d-block">&nbsp;</label>
                    <i class="fas fa-times-circle remove-element-btn" onclick="removePercentElement(${id})"></i>
                </div>
            </div>
        </div>
    `;

    container.insertAdjacentHTML('beforeend', html);
}

function removePercentElement(id) {
    const element = document.getElementById(`percentElement${id}`);
    if (element) {
        element.remove();
    }
}

// Initialize with 2 elements for mass data
let massElementCount = 0;
function initMassElements() {
    massElementCount = 0;
    document.getElementById('massElementsList').innerHTML = '';
    addMassElement();
    addMassElement();
}

function addMassElement() {
    const container = document.getElementById('massElementsList');
    const id = massElementCount++;

    const html = `
        <div class="element-input-group" id="massElement${id}">
            <div class="row align-items-center">
                <div class="col-4">
                    <label class="mb-1"><strong>Element</strong></label>
                    <input type="text" class="form-control" id="massElem${id}" placeholder="e.g., C">
                </div>
                <div class="col-6">
                    <label class="mb-1"><strong>Mass (g)</strong></label>
                    <input type="number" step="any" class="form-control" id="massVal${id}" placeholder="e.g., 12.01">
                </div>
                <div class="col-2 text-right">
                    <label class="mb-1 d-block">&nbsp;</label>
                    <i class="fas fa-times-circle remove-element-btn" onclick="removeMassElement(${id})"></i>
                </div>
            </div>
        </div>
    `;

    container.insertAdjacentHTML('beforeend', html);
}

function removeMassElement(id) {
    const element = document.getElementById(`massElement${id}`);
    if (element) {
        element.remove();
    }
}

// Calculate from percent composition
function calculateFromPercent() {
    const elements = [];
    let totalPercent = 0;

    // Collect all elements
    for (let i = 0; i < percentElementCount; i++) {
        const elemInput = document.getElementById(`percentElem${i}`);
        const valInput = document.getElementById(`percentVal${i}`);

        if (elemInput && valInput && elemInput.value && valInput.value) {
            const element = elemInput.value.trim();
            const percent = parseFloat(valInput.value);

            if (!ELEMENTS[element]) {
                alert(`Unknown element: ${element}`);
                return;
            }

            elements.push({ element, percent });
            totalPercent += percent;
        }
    }

    if (elements.length === 0) {
        alert('Please enter at least one element with its percentage.');
        return;
    }

    // Warn if total is not ~100%
    if (Math.abs(totalPercent - 100) > 0.5) {
        const continueCalc = confirm(`⚠️ Total percentage is ${totalPercent.toFixed(1)}%, not 100%.\n\nContinue anyway?`);
        if (!continueCalc) return;
    }

    // Calculate moles (assume 100g sample)
    const moles = elements.map(e => ({
        element: e.element,
        percent: e.percent,
        mass: e.percent, // Assume 100g sample, so percent = mass
        atomicMass: ELEMENTS[e.element],
        moles: e.percent / ELEMENTS[e.element]
    }));

    // Find smallest moles
    const minMoles = Math.min(...moles.map(m => m.moles));

    // Calculate mole ratios
    const ratios = moles.map(m => ({
        ...m,
        ratio: m.moles / minMoles
    }));

    // Convert to whole numbers
    const empiricalFormula = simplifyRatios(ratios);

    // Display results
    displayEmpiricalResult(empiricalFormula, ratios, 'Percent Composition Method');
}

// Calculate from mass data
function calculateFromMass() {
    const elements = [];

    // Collect all elements
    for (let i = 0; i < massElementCount; i++) {
        const elemInput = document.getElementById(`massElem${i}`);
        const valInput = document.getElementById(`massVal${i}`);

        if (elemInput && valInput && elemInput.value && valInput.value) {
            const element = elemInput.value.trim();
            const mass = parseFloat(valInput.value);

            if (!ELEMENTS[element]) {
                alert(`Unknown element: ${element}`);
                return;
            }

            elements.push({ element, mass });
        }
    }

    if (elements.length === 0) {
        alert('Please enter at least one element with its mass.');
        return;
    }

    // Calculate moles
    const moles = elements.map(e => ({
        element: e.element,
        mass: e.mass,
        atomicMass: ELEMENTS[e.element],
        moles: e.mass / ELEMENTS[e.element]
    }));

    // Find smallest moles
    const minMoles = Math.min(...moles.map(m => m.moles));

    // Calculate mole ratios
    const ratios = moles.map(m => ({
        ...m,
        ratio: m.moles / minMoles
    }));

    // Convert to whole numbers
    const empiricalFormula = simplifyRatios(ratios);

    // Display results
    displayEmpiricalResult(empiricalFormula, ratios, 'Mass Data Method');
}

// Calculate molecular formula from empirical
function calculateMolecularFormula() {
    const empiricalInput = document.getElementById('empiricalFormula').value.trim();
    const molarMassInput = parseFloat(document.getElementById('compoundMolarMass').value);

    if (!empiricalInput || isNaN(molarMassInput)) {
        alert('Please enter both the empirical formula and molar mass.');
        return;
    }

    try {
        // Calculate empirical formula mass
        const empiricalMass = calculateMolarMass(empiricalInput);

        // Calculate multiplier
        const multiplier = Math.round(molarMassInput / empiricalMass);

        // Parse empirical formula to get molecular formula
        const molecularFormula = multiplyFormula(empiricalInput, multiplier);
        const molecularMass = calculateMolarMass(molecularFormula);

        // Display result
        let html = `
            <div class="result-section">
                <h6><span class="empirical-badge">EMPIRICAL</span> ${formatFormula(empiricalInput)}</h6>
                <p class="mb-2">Empirical Formula Mass: <strong>${empiricalMass.toFixed(3)} g/mol</strong></p>

                <hr>

                <h6><span class="molecular-badge">MOLECULAR</span> ${formatFormula(molecularFormula)}</h6>
                <p class="mb-2">Molecular Formula Mass: <strong>${molecularMass.toFixed(3)} g/mol</strong></p>

                <hr>

                <h6><span class="step-badge">CALCULATION</span></h6>
                <div class="step-section">
                    <p class="mb-1"><strong>Step 1:</strong> Calculate empirical formula mass</p>
                    <p class="mb-3 ml-3">EF Mass = ${empiricalMass.toFixed(3)} g/mol</p>

                    <p class="mb-1"><strong>Step 2:</strong> Calculate multiplier (n)</p>
                    <p class="mb-3 ml-3">n = Molecular Mass / Empirical Mass</p>
                    <p class="mb-3 ml-3">n = ${molarMassInput.toFixed(3)} / ${empiricalMass.toFixed(3)} = <strong>${multiplier}</strong></p>

                    <p class="mb-1"><strong>Step 3:</strong> Multiply empirical formula by n</p>
                    <p class="mb-1 ml-3">Molecular Formula = (${formatFormula(empiricalInput)}) × ${multiplier}</p>
                    <p class="mb-0 ml-3"><strong>= ${formatFormula(molecularFormula)}</strong></p>
                </div>
            </div>
        `;

        document.getElementById('resultDisplay').innerHTML = html;

    } catch (error) {
        alert(`Error: ${error.message}`);
    }
}

// Calculate from combustion analysis
function calculateFromCombustion() {
    const compoundMass = parseFloat(document.getElementById('compoundMass').value);
    const co2Mass = parseFloat(document.getElementById('co2Mass').value);
    const h2oMass = parseFloat(document.getElementById('h2oMass').value);
    const containsN = document.getElementById('containsNitrogen').checked;
    const containsO = document.getElementById('containsOxygen').checked;
    const n2Mass = containsN ? parseFloat(document.getElementById('n2Mass').value) : 0;

    if (isNaN(compoundMass) || isNaN(co2Mass) || isNaN(h2oMass)) {
        alert('Please enter all required masses.');
        return;
    }

    if (containsN && isNaN(n2Mass)) {
        alert('Please enter N₂ mass.');
        return;
    }

    // Calculate moles of C from CO2
    const co2Moles = co2Mass / 44.01; // MM of CO2
    const cMoles = co2Moles; // 1:1 ratio
    const cMass = cMoles * 12.01;

    // Calculate moles of H from H2O
    const h2oMoles = h2oMass / 18.02; // MM of H2O
    const hMoles = h2oMoles * 2; // 1:2 ratio
    const hMass = hMoles * 1.008;

    const elements = [
        { element: 'C', mass: cMass, atomicMass: 12.01, moles: cMoles },
        { element: 'H', mass: hMass, atomicMass: 1.008, moles: hMoles }
    ];

    let steps = `
        <p class="mb-1"><strong>Step 1:</strong> Calculate moles of C from CO₂</p>
        <p class="mb-1 ml-3">Moles CO₂ = ${co2Mass} g / 44.01 g/mol = ${co2Moles.toFixed(4)} mol</p>
        <p class="mb-3 ml-3">Moles C = ${co2Moles.toFixed(4)} mol (1:1 ratio) = ${cMass.toFixed(4)} g</p>

        <p class="mb-1"><strong>Step 2:</strong> Calculate moles of H from H₂O</p>
        <p class="mb-1 ml-3">Moles H₂O = ${h2oMass} g / 18.02 g/mol = ${h2oMoles.toFixed(4)} mol</p>
        <p class="mb-3 ml-3">Moles H = ${h2oMoles.toFixed(4)} × 2 = ${hMoles.toFixed(4)} mol = ${hMass.toFixed(4)} g</p>
    `;

    let stepNum = 3;

    // Calculate N if present
    if (containsN) {
        const n2Moles = n2Mass / 28.02; // MM of N2
        const nMoles = n2Moles * 2; // 1:2 ratio
        const nMass = nMoles * 14.01;

        elements.push({ element: 'N', mass: nMass, atomicMass: 14.01, moles: nMoles });

        steps += `
            <p class="mb-1"><strong>Step ${stepNum}:</strong> Calculate moles of N from N₂</p>
            <p class="mb-1 ml-3">Moles N₂ = ${n2Mass} g / 28.02 g/mol = ${n2Moles.toFixed(4)} mol</p>
            <p class="mb-3 ml-3">Moles N = ${n2Moles.toFixed(4)} × 2 = ${nMoles.toFixed(4)} mol = ${nMass.toFixed(4)} g</p>
        `;
        stepNum++;
    }

    // Calculate O by difference if present
    if (containsO) {
        const totalAccountedMass = elements.reduce((sum, e) => sum + e.mass, 0);
        const oMass = compoundMass - totalAccountedMass;
        const oMoles = oMass / 16.00;

        if (oMass > 0.001) {
            elements.push({ element: 'O', mass: oMass, atomicMass: 16.00, moles: oMoles });

            steps += `
                <p class="mb-1"><strong>Step ${stepNum}:</strong> Calculate mass of O by difference</p>
                <p class="mb-1 ml-3">Mass O = ${compoundMass} g - ${totalAccountedMass.toFixed(4)} g = ${oMass.toFixed(4)} g</p>
                <p class="mb-3 ml-3">Moles O = ${oMass.toFixed(4)} / 16.00 = ${oMoles.toFixed(4)} mol</p>
            `;
            stepNum++;
        }
    }

    // Find smallest moles
    const minMoles = Math.min(...elements.map(e => e.moles));

    // Calculate ratios
    const ratios = elements.map(e => ({
        ...e,
        ratio: e.moles / minMoles
    }));

    steps += `
        <p class="mb-1"><strong>Step ${stepNum}:</strong> Calculate mole ratios (divide by smallest)</p>
        <p class="mb-1 ml-3">Smallest moles = ${minMoles.toFixed(4)} mol</p>
    `;

    ratios.forEach(r => {
        steps += `<p class="mb-1 ml-3">${r.element}: ${r.moles.toFixed(4)} / ${minMoles.toFixed(4)} = ${r.ratio.toFixed(3)}</p>`;
    });

    // Simplify to empirical formula
    const empiricalFormula = simplifyRatios(ratios);

    // Display result
    let html = `
        <div class="result-section">
            <h6><span class="empirical-badge">EMPIRICAL FORMULA</span></h6>
            <h4 class="formula-display mb-3">${formatFormula(empiricalFormula)}</h4>

            <hr>

            <h6><span class="step-badge">STEP-BY-STEP SOLUTION</span></h6>
            <div class="step-section">
                ${steps}
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Helper function to simplify mole ratios to whole numbers
function simplifyRatios(ratios) {
    // Try multipliers 1-12 to find whole numbers
    for (let mult = 1; mult <= 12; mult++) {
        const multiplied = ratios.map(r => r.ratio * mult);
        const allClose = multiplied.every(val => Math.abs(val - Math.round(val)) < 0.1);

        if (allClose) {
            const formula = ratios.map(r => {
                const count = Math.round(r.ratio * mult);
                return count === 1 ? r.element : `${r.element}${count}`;
            }).join('');

            return formula;
        }
    }

    // If no good multiplier found, round to nearest
    return ratios.map(r => {
        const count = Math.round(r.ratio);
        return count === 1 ? r.element : `${r.element}${count}`;
    }).join('');
}

// Helper function to multiply a formula by n
function multiplyFormula(formula, multiplier) {
    if (multiplier === 1) return formula;

    const regex = /([A-Z][a-z]?)(\d*)/g;
    let result = '';
    let match;

    while ((match = regex.exec(formula)) !== null) {
        const element = match[1];
        const count = match[2] ? parseInt(match[2]) : 1;
        const newCount = count * multiplier;
        result += element + (newCount === 1 ? '' : newCount);
    }

    return result;
}

// Helper function to format formula with subscripts
function formatFormula(formula) {
    return formula.replace(/(\d+)/g, '<sub>$1</sub>');
}

// Display empirical formula result
function displayEmpiricalResult(formula, ratios, method) {
    const formulaMass = calculateMolarMass(formula);

    let stepsHtml = '';
    ratios.forEach((r, i) => {
        stepsHtml += `
            <p class="mb-1"><strong>${r.element}:</strong></p>
            <p class="mb-1 ml-3">Mass/Percent: ${r.mass ? r.mass.toFixed(3) + ' g' : r.percent.toFixed(1) + '%'}</p>
            <p class="mb-1 ml-3">Moles: ${r.mass ? r.mass.toFixed(3) : r.percent.toFixed(1)} / ${r.atomicMass.toFixed(3)} = ${r.moles.toFixed(4)} mol</p>
            <p class="mb-3 ml-3">Ratio: ${r.moles.toFixed(4)} / ${Math.min(...ratios.map(x => x.moles)).toFixed(4)} = ${r.ratio.toFixed(3)}</p>
        `;
    });

    let html = `
        <div class="result-section">
            <h6><span class="empirical-badge">EMPIRICAL FORMULA</span></h6>
            <h4 class="formula-display mb-3">${formatFormula(formula)}</h4>
            <p class="mb-2">Empirical Formula Mass: <strong>${formulaMass.toFixed(3)} g/mol</strong></p>

            <hr>

            <h6><span class="step-badge">STEP-BY-STEP SOLUTION</span></h6>
            <div class="step-section">
                <p class="mb-3"><strong>Method:</strong> ${method}</p>
                ${stepsHtml}
                <p class="mb-1"><strong>Simplified Whole Number Ratio:</strong></p>
                <p class="mb-0 ml-3 formula-display">${formatFormula(formula)}</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Example setters
function setPercentExample(e1, v1, e2, v2, e3, v3) {
    initPercentElements();
    document.getElementById('percentElem0').value = e1;
    document.getElementById('percentVal0').value = v1;
    document.getElementById('percentElem1').value = e2;
    document.getElementById('percentVal1').value = v2;

    if (e3 && v3) {
        addPercentElement();
        document.getElementById('percentElem2').value = e3;
        document.getElementById('percentVal2').value = v3;
    }
}

function setMassExample(e1, v1, e2, v2, e3, v3) {
    initMassElements();
    document.getElementById('massElem0').value = e1;
    document.getElementById('massVal0').value = v1;
    document.getElementById('massElem1').value = e2;
    document.getElementById('massVal1').value = v2;

    if (e3 && v3) {
        addMassElement();
        document.getElementById('massElem2').value = e3;
        document.getElementById('massVal2').value = v3;
    }
}

function setMolecularExample(ef, mm) {
    document.getElementById('empiricalFormula').value = ef;
    document.getElementById('compoundMolarMass').value = mm;
}

function setCombustionExample(compound, co2, h2o, hasN, n2, hasO) {
    document.getElementById('compoundMass').value = compound;
    document.getElementById('co2Mass').value = co2;
    document.getElementById('h2oMass').value = h2o;
    document.getElementById('containsNitrogen').checked = hasN;
    document.getElementById('containsOxygen').checked = hasO;

    if (hasN) {
        document.getElementById('nitrogenInput').style.display = 'block';
        document.getElementById('n2Mass').value = n2;
    } else {
        document.getElementById('nitrogenInput').style.display = 'none';
    }
}

// Event listeners
document.getElementById('containsNitrogen').addEventListener('change', function() {
    document.getElementById('nitrogenInput').style.display = this.checked ? 'block' : 'none';
});

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    initPercentElements();
    initMassElements();
});
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
