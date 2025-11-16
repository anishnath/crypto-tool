<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free electrochemistry calculator - Calculate cell potential, use Nernst equation, apply Faraday's laws for electrolysis, and solve galvanic cell problems with step-by-step solutions.">
    <meta name="keywords" content="electrochemistry calculator, Nernst equation, cell potential, Faraday's laws, electrolysis, galvanic cell, standard reduction potential, electroplating calculator">
    <title>Electrochemistry Calculator - Nernst Equation, Cell Potential, Faraday's Laws | Free Tool</title>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="Electrochemistry Calculator - Nernst Equation & Cell Potential">
    <meta property="og:description" content="Free online electrochemistry calculator. Solve Nernst equation, calculate cell potential, and apply Faraday's laws with step-by-step solutions.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Electrochemistry Calculator",
        "description": "Calculate cell potentials using Nernst equation, determine electrolysis quantities using Faraday's laws, and solve galvanic cell problems.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Nernst equation calculator, Standard cell potential calculator, Faraday's laws calculator, Electrolysis calculator, Standard reduction potential database, Galvanic cell calculator, Concentration cell calculator, Electroplating calculator",
        "audience": {
            "@type": "EducationalAudience",
            "educationalRole": "student"
        },
        "educationalLevel": "High School, College"
    }
    </script>

<%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container-fluid mt-4">
    <div class="row">
        <div class="col-lg-10 mx-auto">
            <h1 class="text-center mb-3">
                <i class="fas fa-bolt text-primary"></i> Electrochemistry Calculator
            </h1>
            <p class="text-center text-muted mb-4">
                Calculate cell potentials, solve Nernst equation, and apply Faraday's laws for electrolysis
            </p>

            <!-- Electrochemistry Calculator Tabs -->
            <ul class="nav nav-tabs mb-3" id="electroTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="cell-potential-tab" data-toggle="tab" href="#cell-potential" role="tab">
                        <i class="fas fa-battery-full"></i> Cell Potential
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="nernst-tab" data-toggle="tab" href="#nernst" role="tab">
                        <i class="fas fa-calculator"></i> Nernst Equation
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="faraday-tab" data-toggle="tab" href="#faraday" role="tab">
                        <i class="fas fa-flask"></i> Faraday's Laws
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="potentials-tab" data-toggle="tab" href="#potentials" role="tab">
                        <i class="fas fa-table"></i> Standard Potentials
                    </a>
                </li>
            </ul>

            <div class="tab-content" id="electroTabsContent">
                <!-- CELL POTENTIAL TAB -->
                <div class="tab-pane fade show active" id="cell-potential" role="tabpanel">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-battery-full text-primary"></i> Standard Cell Potential Calculator</h5>
                                    <p class="text-muted small">E°<sub>cell</sub> = E°<sub>cathode</sub> - E°<sub>anode</sub></p>

                                    <div class="form-group">
                                        <label>Cathode Half-Reaction (Reduction):</label>
                                        <select class="form-control" id="cathodeReaction" onchange="updateCathodeE()">
                                            <option value="">Select half-reaction...</option>
                                        </select>
                                        <small class="form-text text-muted">E°<sub>cathode</sub> = <span id="cathodeEDisplay">--</span> V</small>
                                    </div>

                                    <div class="form-group">
                                        <label>Or enter custom E°<sub>cathode</sub> (V):</label>
                                        <input type="number" class="form-control" id="customCathodeE" placeholder="e.g., 0.34" step="0.01">
                                    </div>

                                    <hr>

                                    <div class="form-group">
                                        <label>Anode Half-Reaction (Oxidation):</label>
                                        <select class="form-control" id="anodeReaction" onchange="updateAnodeE()">
                                            <option value="">Select half-reaction...</option>
                                        </select>
                                        <small class="form-text text-muted">E°<sub>anode</sub> = <span id="anodeEDisplay">--</span> V</small>
                                    </div>

                                    <div class="form-group">
                                        <label>Or enter custom E°<sub>anode</sub> (V):</label>
                                        <input type="number" class="form-control" id="customAnodeE" placeholder="e.g., -0.76" step="0.01">
                                    </div>

                                    <button class="btn btn-primary btn-block" onclick="calculateCellPotential()">
                                        <i class="fas fa-calculator"></i> Calculate E°<sub>cell</sub>
                                    </button>

                                    <hr>
                                    <h6 class="text-muted">Example Problems:</h6>
                                    <div class="example-section">
                                        <div class="example-category">⭐ Classic Galvanic Cells</div>
                                        <span class="example-badge" onclick="setCellExample('Cu2+/Cu', 'Zn2+/Zn')">Daniell cell: Cu²⁺/Cu cathode, Zn²⁺/Zn anode</span>
                                        <span class="example-badge" onclick="setCellExample('Ag+/Ag', 'Cu2+/Cu')">Silver-copper cell</span>
                                        <span class="example-badge" onclick="setCellExample('Cl2/Cl-', 'Br2/Br-')">Chlorine-bromine cell</span>

                                        <div class="example-category">⭐⭐ Practical Applications</div>
                                        <span class="example-badge" onclick="setCellExample('O2/H2O', 'H+/H2')">Hydrogen fuel cell</span>
                                        <span class="example-badge" onclick="setCellExample('MnO2/Mn2+', 'Zn2+/Zn')">Alkaline battery (approximation)</span>
                                        <span class="example-badge" onclick="setCellExample('PbO2/Pb2+', 'Pb2+/Pb')">Lead-acid battery</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="card sticky-top" style="top: 20px;">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-check-circle text-success"></i> Result</h5>
                                    <div id="cellPotentialResult">
                                        <p class="text-muted">Select half-reactions and click Calculate</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- NERNST EQUATION TAB -->
                <div class="tab-pane fade" id="nernst" role="tabpanel">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-calculator text-primary"></i> Nernst Equation Calculator</h5>
                                    <p class="text-muted small">E = E° - (RT/nF)ln(Q) = E° - (0.0592/n)log(Q) at 25°C</p>

                                    <div class="form-group">
                                        <label>Standard Cell Potential E° (V):</label>
                                        <input type="number" class="form-control" id="nernstE0" placeholder="e.g., 1.10" step="0.01">
                                    </div>

                                    <div class="form-group">
                                        <label>Temperature (°C):</label>
                                        <input type="number" class="form-control" id="nernstTemp" value="25" placeholder="25" step="1">
                                    </div>

                                    <div class="form-group">
                                        <label>Number of Electrons Transferred (n):</label>
                                        <input type="number" class="form-control" id="nernstN" placeholder="e.g., 2" step="1" min="1">
                                    </div>

                                    <div class="form-group">
                                        <label>Reaction Quotient (Q):</label>
                                        <input type="number" class="form-control" id="nernstQ" placeholder="e.g., 0.01" step="any">
                                        <small class="form-text text-muted">Q = [products]/[reactants]. For aA + bB → cC + dD: Q = [C]^c[D]^d / [A]^a[B]^b</small>
                                    </div>

                                    <button class="btn btn-primary btn-block" onclick="calculateNernst()">
                                        <i class="fas fa-calculator"></i> Calculate Cell Potential (E)
                                    </button>

                                    <hr>
                                    <div class="alert alert-info">
                                        <h6><i class="fas fa-info-circle"></i> About the Nernst Equation</h6>
                                        <ul class="small mb-0">
                                            <li><strong>At 25°C:</strong> E = E° - (0.0592/n)log(Q)</li>
                                            <li><strong>At equilibrium:</strong> E = 0, so Q = K (equilibrium constant)</li>
                                            <li><strong>Q < 1:</strong> E > E° (reaction favored)</li>
                                            <li><strong>Q > 1:</strong> E < E° (reverse reaction favored)</li>
                                        </ul>
                                    </div>

                                    <hr>
                                    <h6 class="text-muted">Example Problems:</h6>
                                    <div class="example-section">
                                        <div class="example-category">⭐ Standard Conditions</div>
                                        <span class="example-badge" onclick="setNernstExample(1.10, 2, 1, 25)">Standard conditions: E°=1.10V, n=2, Q=1</span>
                                        <span class="example-badge" onclick="setNernstExample(0.80, 2, 1, 25)">Silver cell: E°=0.80V, standard conditions</span>

                                        <div class="example-category">⭐⭐ Non-Standard Concentrations</div>
                                        <span class="example-badge" onclick="setNernstExample(1.10, 2, 0.01, 25)">Dilute products: Q=0.01</span>
                                        <span class="example-badge" onclick="setNernstExample(1.10, 2, 100, 25)">Concentrated products: Q=100</span>
                                        <span class="example-badge" onclick="setNernstExample(0.34, 2, 0.001, 25)">Very dilute: Q=0.001</span>

                                        <div class="example-category">⭐⭐⭐ Temperature Effects</div>
                                        <span class="example-badge" onclick="setNernstExample(1.10, 2, 1, 0)">At 0°C: T=0°C</span>
                                        <span class="example-badge" onclick="setNernstExample(1.10, 2, 1, 50)">At 50°C: T=50°C</span>
                                        <span class="example-badge" onclick="setNernstExample(1.10, 2, 0.1, 37)">Body temp: 37°C, Q=0.1</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="card sticky-top" style="top: 20px;">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-check-circle text-success"></i> Result</h5>
                                    <div id="nernstResult">
                                        <p class="text-muted">Enter values and click Calculate</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- FARADAY'S LAWS TAB -->
                <div class="tab-pane fade" id="faraday" role="tabpanel">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-flask text-primary"></i> Faraday's Laws of Electrolysis</h5>
                                    <p class="text-muted small">m = (Q × M) / (n × F) = (I × t × M) / (n × F)</p>

                                    <div class="form-group">
                                        <label>Calculate:</label>
                                        <select class="form-control" id="faradayCalculateWhat" onchange="updateFaradayFields()">
                                            <option value="mass">Mass deposited/produced (m)</option>
                                            <option value="charge">Charge required (Q)</option>
                                            <option value="time">Time required (t)</option>
                                            <option value="current">Current required (I)</option>
                                        </select>
                                    </div>

                                    <div id="faradayInputFields">
                                        <!-- Dynamic fields -->
                                    </div>

                                    <button class="btn btn-primary btn-block" onclick="calculateFaraday()">
                                        <i class="fas fa-calculator"></i> Calculate
                                    </button>

                                    <hr>
                                    <div class="alert alert-info">
                                        <h6><i class="fas fa-info-circle"></i> Constants & Formulas</h6>
                                        <ul class="small mb-0">
                                            <li><strong>Faraday constant (F):</strong> 96485 C/mol</li>
                                            <li><strong>Charge (Q):</strong> Q = I × t</li>
                                            <li><strong>Moles:</strong> n<sub>mol</sub> = Q / (n × F)</li>
                                            <li><strong>Mass:</strong> m = n<sub>mol</sub> × M</li>
                                        </ul>
                                    </div>

                                    <hr>
                                    <h6 class="text-muted">Example Problems:</h6>
                                    <div class="example-section">
                                        <div class="example-category">⭐ Electroplating Copper</div>
                                        <span class="example-badge" onclick="setFaradayMassExample(5, 3600, 63.55, 2)">Cu deposition: 5A for 1 hour</span>
                                        <span class="example-badge" onclick="setFaradayMassExample(10, 1800, 63.55, 2)">Cu deposition: 10A for 30 min</span>

                                        <div class="example-category">⭐⭐ Silver Electroplating</div>
                                        <span class="example-badge" onclick="setFaradayMassExample(2, 7200, 107.87, 1)">Ag deposition: 2A for 2 hours</span>
                                        <span class="example-badge" onclick="setFaradayChargeExample(10, 107.87, 1)">Charge for 10g Ag</span>

                                        <div class="example-category">⭐⭐⭐ Aluminum Production</div>
                                        <span class="example-badge" onclick="setFaradayMassExample(100000, 3600, 26.98, 3)">Al production: 100kA for 1 hour</span>
                                        <span class="example-badge" onclick="setFaradayTimeExample(1000, 5, 26.98, 3)">Time for 1kg Al at 5A</span>

                                        <div class="example-category">🧪 Hydrogen Production</div>
                                        <span class="example-badge" onclick="setFaradayMassExample(10, 1800, 2.016, 2)">H₂ production: 10A for 30 min</span>
                                        <span class="example-badge" onclick="setFaradayCurrentExample(100, 3600, 2.016, 2)">Current for 100g H₂ in 1 hour</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="card sticky-top" style="top: 20px;">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-check-circle text-success"></i> Result</h5>
                                    <div id="faradayResult">
                                        <p class="text-muted">Enter values and click Calculate</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- STANDARD POTENTIALS DATABASE TAB -->
                <div class="tab-pane fade" id="potentials" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-table text-primary"></i> Standard Reduction Potentials (25°C, 1 M)</h5>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover table-sm">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>Half-Reaction (Reduction)</th>
                                            <th>E° (V)</th>
                                            <th>Category</th>
                                        </tr>
                                    </thead>
                                    <tbody id="potentialsTableBody">
                                        <!-- Populated by JavaScript -->
                                    </tbody>
                                </table>
                            </div>

                            <div class="alert alert-info mt-3">
                                <h6><i class="fas fa-lightbulb"></i> How to Use This Table</h6>
                                <ul class="small mb-0">
                                    <li><strong>More positive E°:</strong> Stronger oxidizing agent (easier to reduce)</li>
                                    <li><strong>More negative E°:</strong> Stronger reducing agent (easier to oxidize)</li>
                                    <li><strong>E°<sub>cell</sub> = E°<sub>cathode</sub> - E°<sub>anode</sub>:</strong> Positive E°<sub>cell</sub> means spontaneous reaction</li>
                                    <li><strong>Reference:</strong> Standard hydrogen electrode (SHE) defined as 0.00 V</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<style>
.example-section {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
}

.example-badge {
    display: inline-block;
    background-color: #17a2b8;
    color: white;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.85rem;
    cursor: pointer;
    transition: all 0.2s;
}

.example-badge:hover {
    background-color: #138496;
    transform: scale(1.05);
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.example-category {
    width: 100%;
    font-weight: bold;
    color: #6c757d;
    margin-top: 10px;
    margin-bottom: 5px;
    font-size: 0.9rem;
}

.sticky-top {
    position: sticky;
}

@media (max-width: 992px) {
    .sticky-top {
        position: relative;
        top: 0 !important;
    }
}
</style>

<script>
// ============================================
// STANDARD REDUCTION POTENTIALS DATABASE
// ============================================
const reductionPotentials = {
    'F2/F-': { equation: 'F₂ + 2e⁻ → 2F⁻', E0: 2.87, category: 'Halogen' },
    'H2O2/H2O': { equation: 'H₂O₂ + 2H⁺ + 2e⁻ → 2H₂O', E0: 1.78, category: 'Oxygen' },
    'MnO4-/Mn2+': { equation: 'MnO₄⁻ + 8H⁺ + 5e⁻ → Mn²⁺ + 4H₂O', E0: 1.51, category: 'Transition metal' },
    'Cl2/Cl-': { equation: 'Cl₂ + 2e⁻ → 2Cl⁻', E0: 1.36, category: 'Halogen' },
    'Cr2O7 2-/Cr3+': { equation: 'Cr₂O₇²⁻ + 14H⁺ + 6e⁻ → 2Cr³⁺ + 7H₂O', E0: 1.33, category: 'Transition metal' },
    'O2/H2O': { equation: 'O₂ + 4H⁺ + 4e⁻ → 2H₂O', E0: 1.23, category: 'Oxygen' },
    'Br2/Br-': { equation: 'Br₂ + 2e⁻ → 2Br⁻', E0: 1.07, category: 'Halogen' },
    'NO3-/NO': { equation: 'NO₃⁻ + 4H⁺ + 3e⁻ → NO + 2H₂O', E0: 0.96, category: 'Nitrogen' },
    'Ag+/Ag': { equation: 'Ag⁺ + e⁻ → Ag', E0: 0.80, category: 'Metal' },
    'Fe3+/Fe2+': { equation: 'Fe³⁺ + e⁻ → Fe²⁺', E0: 0.77, category: 'Transition metal' },
    'I2/I-': { equation: 'I₂ + 2e⁻ → 2I⁻', E0: 0.54, category: 'Halogen' },
    'Cu2+/Cu': { equation: 'Cu²⁺ + 2e⁻ → Cu', E0: 0.34, category: 'Metal' },
    'Sn4+/Sn2+': { equation: 'Sn⁴⁺ + 2e⁻ → Sn²⁺', E0: 0.15, category: 'Transition metal' },
    'H+/H2': { equation: '2H⁺ + 2e⁻ → H₂', E0: 0.00, category: 'Reference' },
    'Pb2+/Pb': { equation: 'Pb²⁺ + 2e⁻ → Pb', E0: -0.13, category: 'Metal' },
    'Sn2+/Sn': { equation: 'Sn²⁺ + 2e⁻ → Sn', E0: -0.14, category: 'Metal' },
    'Ni2+/Ni': { equation: 'Ni²⁺ + 2e⁻ → Ni', E0: -0.25, category: 'Metal' },
    'Co2+/Co': { equation: 'Co²⁺ + 2e⁻ → Co', E0: -0.28, category: 'Metal' },
    'Fe2+/Fe': { equation: 'Fe²⁺ + 2e⁻ → Fe', E0: -0.44, category: 'Metal' },
    'Cr3+/Cr': { equation: 'Cr³⁺ + 3e⁻ → Cr', E0: -0.74, category: 'Metal' },
    'Zn2+/Zn': { equation: 'Zn²⁺ + 2e⁻ → Zn', E0: -0.76, category: 'Metal' },
    'Mn2+/Mn': { equation: 'Mn²⁺ + 2e⁻ → Mn', E0: -1.18, category: 'Metal' },
    'Al3+/Al': { equation: 'Al³⁺ + 3e⁻ → Al', E0: -1.66, category: 'Metal' },
    'Mg2+/Mg': { equation: 'Mg²⁺ + 2e⁻ → Mg', E0: -2.37, category: 'Metal' },
    'Na+/Na': { equation: 'Na⁺ + e⁻ → Na', E0: -2.71, category: 'Metal' },
    'Ca2+/Ca': { equation: 'Ca²⁺ + 2e⁻ → Ca', E0: -2.87, category: 'Metal' },
    'K+/K': { equation: 'K⁺ + e⁻ → K', E0: -2.93, category: 'Metal' },
    'Li+/Li': { equation: 'Li⁺ + e⁻ → Li', E0: -3.05, category: 'Metal' },
    'PbO2/Pb2+': { equation: 'PbO₂ + 4H⁺ + 2e⁻ → Pb²⁺ + 2H₂O', E0: 1.46, category: 'Lead' },
    'MnO2/Mn2+': { equation: 'MnO₂ + 4H⁺ + 2e⁻ → Mn²⁺ + 2H₂O', E0: 1.23, category: 'Transition metal' }
};

// Populate dropdowns and table on page load
document.addEventListener('DOMContentLoaded', function() {
    const cathodeSelect = document.getElementById('cathodeReaction');
    const anodeSelect = document.getElementById('anodeReaction');
    const tableBody = document.getElementById('potentialsTableBody');

    // Sort by E0 (descending)
    const sortedKeys = Object.keys(reductionPotentials).sort((a, b) =>
        reductionPotentials[b].E0 - reductionPotentials[a].E0
    );

    sortedKeys.forEach(key => {
        const data = reductionPotentials[key];

        // Populate dropdowns
        const option1 = document.createElement('option');
        option1.value = key;
        option1.textContent = `${data.equation} (E° = ${data.E0.toFixed(2)} V)`;
        cathodeSelect.appendChild(option1);

        const option2 = document.createElement('option');
        option2.value = key;
        option2.textContent = `${data.equation} (E° = ${data.E0.toFixed(2)} V)`;
        anodeSelect.appendChild(option2);

        // Populate table
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${data.equation}</td>
            <td><strong>${data.E0.toFixed(2)}</strong></td>
            <td><span class="badge badge-secondary">${data.category}</span></td>
        `;
        tableBody.appendChild(row);
    });

    updateFaradayFields();
});

// ============================================
// CELL POTENTIAL CALCULATOR
// ============================================
function updateCathodeE() {
    const key = document.getElementById('cathodeReaction').value;
    const display = document.getElementById('cathodeEDisplay');
    if (key && reductionPotentials[key]) {
        display.textContent = reductionPotentials[key].E0.toFixed(2);
        document.getElementById('customCathodeE').value = '';
    } else {
        display.textContent = '--';
    }
}

function updateAnodeE() {
    const key = document.getElementById('anodeReaction').value;
    const display = document.getElementById('anodeEDisplay');
    if (key && reductionPotentials[key]) {
        display.textContent = reductionPotentials[key].E0.toFixed(2);
        document.getElementById('customAnodeE').value = '';
    } else {
        display.textContent = '--';
    }
}

function calculateCellPotential() {
    let cathodeE, anodeE, cathodeEq = '', anodeEq = '';

    // Get cathode E
    const customCathode = document.getElementById('customCathodeE').value;
    if (customCathode) {
        cathodeE = parseFloat(customCathode);
        cathodeEq = 'Custom cathode';
    } else {
        const cathodeKey = document.getElementById('cathodeReaction').value;
        if (cathodeKey && reductionPotentials[cathodeKey]) {
            cathodeE = reductionPotentials[cathodeKey].E0;
            cathodeEq = reductionPotentials[cathodeKey].equation;
        }
    }

    // Get anode E
    const customAnode = document.getElementById('customAnodeE').value;
    if (customAnode) {
        anodeE = parseFloat(customAnode);
        anodeEq = 'Custom anode';
    } else {
        const anodeKey = document.getElementById('anodeReaction').value;
        if (anodeKey && reductionPotentials[anodeKey]) {
            anodeE = reductionPotentials[anodeKey].E0;
            anodeEq = reductionPotentials[anodeKey].equation;
        }
    }

    if (cathodeE === undefined || anodeE === undefined) {
        showError('cellPotentialResult', 'Please select or enter both cathode and anode potentials');
        return;
    }

    const Ecell = cathodeE - anodeE;
    const spontaneous = Ecell > 0;

    const result = `
        <div class="alert alert-success">
            <h5><i class="fas fa-battery-full"></i> Cell Potential</h5>
            <p><strong>E°<sub>cell</sub> = ${Ecell.toFixed(3)} V</strong></p>
            <p>${spontaneous ?
                '<span class="badge badge-success">Spontaneous Reaction ✓</span>' :
                '<span class="badge badge-danger">Non-spontaneous (requires external energy)</span>'}</p>
            <hr>
            <h6>Calculation:</h6>
            <ol class="small">
                <li><strong>Cathode (reduction):</strong> E° = ${cathodeE.toFixed(2)} V
                    ${cathodeEq ? `<br><span class="text-muted">${cathodeEq}</span>` : ''}</li>
                <li><strong>Anode (oxidation):</strong> E° = ${anodeE.toFixed(2)} V
                    ${anodeEq ? `<br><span class="text-muted">${anodeEq}</span>` : ''}</li>
                <li>E°<sub>cell</sub> = E°<sub>cathode</sub> - E°<sub>anode</sub></li>
                <li>E°<sub>cell</sub> = ${cathodeE.toFixed(2)} - (${anodeE.toFixed(2)}) = <strong>${Ecell.toFixed(3)} V</strong></li>
            </ol>
            ${!spontaneous ? '<p class="text-warning small mb-0"><i class="fas fa-exclamation-triangle"></i> Negative E° indicates this would be an electrolytic cell</p>' : ''}
        </div>
    `;

    document.getElementById('cellPotentialResult').innerHTML = result;
}

function setCellExample(cathode, anode) {
    document.getElementById('cathodeReaction').value = cathode;
    document.getElementById('anodeReaction').value = anode;
    updateCathodeE();
    updateAnodeE();
    calculateCellPotential();
}

// ============================================
// NERNST EQUATION CALCULATOR
// ============================================
function calculateNernst() {
    const E0 = parseFloat(document.getElementById('nernstE0').value);
    const T = parseFloat(document.getElementById('nernstTemp').value);
    const n = parseFloat(document.getElementById('nernstN').value);
    const Q = parseFloat(document.getElementById('nernstQ').value);

    if (isNaN(E0) || isNaN(T) || isNaN(n) || isNaN(Q)) {
        showError('nernstResult', 'Please enter all values');
        return;
    }

    if (Q <= 0) {
        showError('nernstResult', 'Q must be positive');
        return;
    }

    const R = 8.314; // J/(mol·K)
    const F = 96485; // C/mol
    const TKelvin = T + 273.15;

    // E = E0 - (RT/nF)ln(Q)
    const E = E0 - (R * TKelvin / (n * F)) * Math.log(Q);

    // At 25°C: E = E0 - (0.0592/n)log(Q)
    const coefficient25 = 0.0592 / n;
    const logQ = Math.log10(Q);

    const result = `
        <div class="alert alert-success">
            <h5><i class="fas fa-bolt"></i> Cell Potential (Nernst)</h5>
            <p><strong>E = ${E.toFixed(4)} V</strong></p>
            ${E > 0 ? '<span class="badge badge-success">Spontaneous</span>' : '<span class="badge badge-danger">Non-spontaneous</span>'}
            <hr>
            <h6>Calculation:</h6>
            <ol class="small">
                <li>Given: E° = ${E0} V, T = ${T}°C (${TKelvin.toFixed(2)} K), n = ${n}, Q = ${Q}</li>
                <li>Nernst equation: E = E° - (RT/nF)ln(Q)</li>
                <li>RT/nF = (8.314 × ${TKelvin.toFixed(2)}) / (${n} × 96485) = ${(R * TKelvin / (n * F)).toExponential(4)}</li>
                <li>ln(Q) = ln(${Q}) = ${Math.log(Q).toFixed(4)}</li>
                <li>E = ${E0} - ${(R * TKelvin / (n * F)).toExponential(4)} × ${Math.log(Q).toFixed(4)}</li>
                <li><strong>E = ${E.toFixed(4)} V</strong></li>
            </ol>
            ${T === 25 ? `
                <hr>
                <h6>Simplified form at 25°C:</h6>
                <p class="small mb-0">E = E° - (0.0592/n)log(Q)</p>
                <p class="small mb-0">E = ${E0} - (${coefficient25.toFixed(4)})×(${logQ.toFixed(4)}) = ${E.toFixed(4)} V</p>
            ` : ''}
        </div>
    `;

    document.getElementById('nernstResult').innerHTML = result;
}

function setNernstExample(E0, n, Q, T) {
    document.getElementById('nernstE0').value = E0;
    document.getElementById('nernstN').value = n;
    document.getElementById('nernstQ').value = Q;
    document.getElementById('nernstTemp').value = T;
    calculateNernst();
}

// ============================================
// FARADAY'S LAWS CALCULATOR
// ============================================
const F = 96485; // Faraday constant in C/mol

function updateFaradayFields() {
    const calcType = document.getElementById('faradayCalculateWhat').value;
    const container = document.getElementById('faradayInputFields');

    if (calcType === 'mass') {
        container.innerHTML = `
            <div class="form-group">
                <label>Current (A):</label>
                <input type="number" class="form-control" id="faradayCurrent" placeholder="e.g., 5" step="any">
            </div>
            <div class="form-group">
                <label>Time (seconds):</label>
                <input type="number" class="form-control" id="faradayTime" placeholder="e.g., 3600" step="1">
                <small class="form-text text-muted">Hint: 1 hour = 3600 s, 1 min = 60 s</small>
            </div>
            <div class="form-group">
                <label>Molar Mass (g/mol):</label>
                <input type="number" class="form-control" id="faradayMolarMass" placeholder="e.g., 63.55 for Cu" step="0.01">
            </div>
            <div class="form-group">
                <label>Number of Electrons (n):</label>
                <input type="number" class="form-control" id="faradayN" placeholder="e.g., 2" step="1" min="1">
                <small class="form-text text-muted">Cu²⁺ + 2e⁻ → Cu: n=2</small>
            </div>
        `;
    } else if (calcType === 'charge') {
        container.innerHTML = `
            <div class="form-group">
                <label>Mass (g):</label>
                <input type="number" class="form-control" id="faradayMass" placeholder="e.g., 10" step="any">
            </div>
            <div class="form-group">
                <label>Molar Mass (g/mol):</label>
                <input type="number" class="form-control" id="faradayMolarMass" placeholder="e.g., 63.55 for Cu" step="0.01">
            </div>
            <div class="form-group">
                <label>Number of Electrons (n):</label>
                <input type="number" class="form-control" id="faradayN" placeholder="e.g., 2" step="1" min="1">
            </div>
        `;
    } else if (calcType === 'time') {
        container.innerHTML = `
            <div class="form-group">
                <label>Mass (g):</label>
                <input type="number" class="form-control" id="faradayMass" placeholder="e.g., 100" step="any">
            </div>
            <div class="form-group">
                <label>Current (A):</label>
                <input type="number" class="form-control" id="faradayCurrent" placeholder="e.g., 5" step="any">
            </div>
            <div class="form-group">
                <label>Molar Mass (g/mol):</label>
                <input type="number" class="form-control" id="faradayMolarMass" placeholder="e.g., 63.55 for Cu" step="0.01">
            </div>
            <div class="form-group">
                <label>Number of Electrons (n):</label>
                <input type="number" class="form-control" id="faradayN" placeholder="e.g., 2" step="1" min="1">
            </div>
        `;
    } else if (calcType === 'current') {
        container.innerHTML = `
            <div class="form-group">
                <label>Mass (g):</label>
                <input type="number" class="form-control" id="faradayMass" placeholder="e.g., 100" step="any">
            </div>
            <div class="form-group">
                <label>Time (seconds):</label>
                <input type="number" class="form-control" id="faradayTime" placeholder="e.g., 3600" step="1">
            </div>
            <div class="form-group">
                <label>Molar Mass (g/mol):</label>
                <input type="number" class="form-control" id="faradayMolarMass" placeholder="e.g., 63.55 for Cu" step="0.01">
            </div>
            <div class="form-group">
                <label>Number of Electrons (n):</label>
                <input type="number" class="form-control" id="faradayN" placeholder="e.g., 2" step="1" min="1">
            </div>
        `;
    }
}

function calculateFaraday() {
    const calcType = document.getElementById('faradayCalculateWhat').value;
    let result = '';

    if (calcType === 'mass') {
        const I = parseFloat(document.getElementById('faradayCurrent').value);
        const t = parseFloat(document.getElementById('faradayTime').value);
        const M = parseFloat(document.getElementById('faradayMolarMass').value);
        const n = parseFloat(document.getElementById('faradayN').value);

        if (isNaN(I) || isNaN(t) || isNaN(M) || isNaN(n)) {
            showError('faradayResult', 'Please enter all values');
            return;
        }

        const Q = I * t;
        const moles = Q / (n * F);
        const mass = moles * M;

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-weight"></i> Mass Deposited</h5>
                <p><strong>m = ${mass.toFixed(4)} g</strong></p>
                <hr>
                <h6>Step-by-Step Calculation:</h6>
                <ol class="small">
                    <li>Calculate charge: Q = I × t = ${I} A × ${t} s = ${Q.toFixed(2)} C</li>
                    <li>Calculate moles: n<sub>mol</sub> = Q / (n × F) = ${Q.toFixed(2)} / (${n} × 96485)</li>
                    <li>n<sub>mol</sub> = ${moles.toExponential(4)} mol</li>
                    <li>Calculate mass: m = n<sub>mol</sub> × M = ${moles.toExponential(4)} × ${M}</li>
                    <li><strong>m = ${mass.toFixed(4)} g</strong></li>
                </ol>
                <p class="small mb-0 text-muted">Time: ${(t/3600).toFixed(2)} hours = ${(t/60).toFixed(2)} minutes</p>
            </div>
        `;
    } else if (calcType === 'charge') {
        const m = parseFloat(document.getElementById('faradayMass').value);
        const M = parseFloat(document.getElementById('faradayMolarMass').value);
        const n = parseFloat(document.getElementById('faradayN').value);

        if (isNaN(m) || isNaN(M) || isNaN(n)) {
            showError('faradayResult', 'Please enter all values');
            return;
        }

        const moles = m / M;
        const Q = moles * n * F;

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-bolt"></i> Charge Required</h5>
                <p><strong>Q = ${Q.toExponential(4)} C</strong></p>
                <p><strong>Q = ${(Q/3600).toFixed(2)} Ah</strong> (Ampere-hours)</p>
                <hr>
                <h6>Step-by-Step Calculation:</h6>
                <ol class="small">
                    <li>Calculate moles: n<sub>mol</sub> = m / M = ${m} / ${M} = ${moles.toFixed(6)} mol</li>
                    <li>Calculate charge: Q = n<sub>mol</sub> × n × F</li>
                    <li>Q = ${moles.toFixed(6)} × ${n} × 96485</li>
                    <li><strong>Q = ${Q.toExponential(4)} C</strong></li>
                </ol>
            </div>
        `;
    } else if (calcType === 'time') {
        const m = parseFloat(document.getElementById('faradayMass').value);
        const I = parseFloat(document.getElementById('faradayCurrent').value);
        const M = parseFloat(document.getElementById('faradayMolarMass').value);
        const n = parseFloat(document.getElementById('faradayN').value);

        if (isNaN(m) || isNaN(I) || isNaN(M) || isNaN(n)) {
            showError('faradayResult', 'Please enter all values');
            return;
        }

        const moles = m / M;
        const Q = moles * n * F;
        const t = Q / I;

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-clock"></i> Time Required</h5>
                <p><strong>t = ${t.toFixed(2)} seconds</strong></p>
                <p><strong>t = ${(t/60).toFixed(2)} minutes = ${(t/3600).toFixed(2)} hours</strong></p>
                <hr>
                <h6>Step-by-Step Calculation:</h6>
                <ol class="small">
                    <li>Calculate moles: n<sub>mol</sub> = m / M = ${m} / ${M} = ${moles.toFixed(6)} mol</li>
                    <li>Calculate charge: Q = n<sub>mol</sub> × n × F = ${Q.toExponential(4)} C</li>
                    <li>Calculate time: t = Q / I = ${Q.toExponential(4)} / ${I}</li>
                    <li><strong>t = ${t.toFixed(2)} s</strong></li>
                </ol>
            </div>
        `;
    } else if (calcType === 'current') {
        const m = parseFloat(document.getElementById('faradayMass').value);
        const t = parseFloat(document.getElementById('faradayTime').value);
        const M = parseFloat(document.getElementById('faradayMolarMass').value);
        const n = parseFloat(document.getElementById('faradayN').value);

        if (isNaN(m) || isNaN(t) || isNaN(M) || isNaN(n)) {
            showError('faradayResult', 'Please enter all values');
            return;
        }

        const moles = m / M;
        const Q = moles * n * F;
        const I = Q / t;

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-plug"></i> Current Required</h5>
                <p><strong>I = ${I.toFixed(4)} A</strong></p>
                <hr>
                <h6>Step-by-Step Calculation:</h6>
                <ol class="small">
                    <li>Calculate moles: n<sub>mol</sub> = m / M = ${m} / ${M} = ${moles.toFixed(6)} mol</li>
                    <li>Calculate charge: Q = n<sub>mol</sub> × n × F = ${Q.toExponential(4)} C</li>
                    <li>Calculate current: I = Q / t = ${Q.toExponential(4)} / ${t}</li>
                    <li><strong>I = ${I.toFixed(4)} A</strong></li>
                </ol>
            </div>
        `;
    }

    document.getElementById('faradayResult').innerHTML = result;
}

function setFaradayMassExample(I, t, M, n) {
    document.getElementById('faradayCalculateWhat').value = 'mass';
    updateFaradayFields();
    setTimeout(() => {
        document.getElementById('faradayCurrent').value = I;
        document.getElementById('faradayTime').value = t;
        document.getElementById('faradayMolarMass').value = M;
        document.getElementById('faradayN').value = n;
        calculateFaraday();
    }, 100);
}

function setFaradayChargeExample(m, M, n) {
    document.getElementById('faradayCalculateWhat').value = 'charge';
    updateFaradayFields();
    setTimeout(() => {
        document.getElementById('faradayMass').value = m;
        document.getElementById('faradayMolarMass').value = M;
        document.getElementById('faradayN').value = n;
        calculateFaraday();
    }, 100);
}

function setFaradayTimeExample(m, I, M, n) {
    document.getElementById('faradayCalculateWhat').value = 'time';
    updateFaradayFields();
    setTimeout(() => {
        document.getElementById('faradayMass').value = m;
        document.getElementById('faradayCurrent').value = I;
        document.getElementById('faradayMolarMass').value = M;
        document.getElementById('faradayN').value = n;
        calculateFaraday();
    }, 100);
}

function setFaradayCurrentExample(m, t, M, n) {
    document.getElementById('faradayCalculateWhat').value = 'current';
    updateFaradayFields();
    setTimeout(() => {
        document.getElementById('faradayMass').value = m;
        document.getElementById('faradayTime').value = t;
        document.getElementById('faradayMolarMass').value = M;
        document.getElementById('faradayN').value = n;
        calculateFaraday();
    }, 100);
}

// ============================================
// UTILITY FUNCTIONS
// ============================================
function showError(elementId, message) {
    document.getElementById(elementId).innerHTML = `<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${message}</div>`;
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
</html>
