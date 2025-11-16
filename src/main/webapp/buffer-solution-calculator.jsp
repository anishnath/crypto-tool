<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free buffer solution calculator - Calculate buffer pH using Henderson-Hasselbalch equation, determine buffer capacity, and prepare buffer solutions with step-by-step instructions.">
    <meta name="keywords" content="buffer solution calculator, Henderson-Hasselbalch equation, buffer capacity, buffer preparation, pH buffer, pKa calculator, acetic acid buffer, phosphate buffer">
    <title>Buffer Solution Calculator - Henderson-Hasselbalch, Capacity, Preparation | Free Tool</title>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="Buffer Solution Calculator - Henderson-Hasselbalch Equation & Buffer Capacity">
    <meta property="og:description" content="Free online buffer calculator. Calculate pH, buffer capacity, and get step-by-step buffer preparation instructions.">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Buffer Solution Calculator",
        "description": "Calculate buffer solution pH using Henderson-Hasselbalch equation, determine buffer capacity, and prepare buffer solutions with detailed instructions.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Henderson-Hasselbalch equation solver, Buffer capacity calculator, Buffer preparation instructions, Common buffer database (acetate, phosphate, citrate, Tris), pH range recommendations, Step-by-step solutions",
        "audience": {
            "@type": "EducationalAudience",
            "educationalRole": "student"
        },
        "educationalLevel": "College, Graduate"
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
                <i class="fas fa-vial text-primary"></i> Buffer Solution Calculator
            </h1>
            <p class="text-center text-muted mb-4">
                Calculate pH, buffer capacity, and prepare buffer solutions using Henderson-Hasselbalch equation
            </p>

            <!-- Buffer Calculator Tabs -->
            <ul class="nav nav-tabs mb-3" id="bufferTabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" id="hh-tab" data-toggle="tab" href="#hh" role="tab">
                        <i class="fas fa-calculator"></i> Henderson-Hasselbalch
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="capacity-tab" data-toggle="tab" href="#capacity" role="tab">
                        <i class="fas fa-chart-line"></i> Buffer Capacity
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="preparation-tab" data-toggle="tab" href="#preparation" role="tab">
                        <i class="fas fa-flask"></i> Buffer Preparation
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="database-tab" data-toggle="tab" href="#database" role="tab">
                        <i class="fas fa-database"></i> Common Buffers
                    </a>
                </li>
            </ul>

            <div class="tab-content" id="bufferTabsContent">
                <!-- HENDERSON-HASSELBALCH TAB -->
                <div class="tab-pane fade show active" id="hh" role="tabpanel">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-calculator text-primary"></i> Henderson-Hasselbalch Equation</h5>
                                    <p class="text-muted small">pH = pKa + log([A⁻]/[HA])</p>

                                    <div class="form-group">
                                        <label>Calculate:</label>
                                        <select class="form-control" id="hhCalculateWhat" onchange="updateHHFields()">
                                            <option value="pH">pH (given pKa and concentrations)</option>
                                            <option value="ratio">Ratio [A⁻]/[HA] (given pH and pKa)</option>
                                            <option value="pKa">pKa (given pH and ratio)</option>
                                        </select>
                                    </div>

                                    <div id="hhInputFields">
                                        <!-- Dynamic fields based on selection -->
                                    </div>

                                    <button class="btn btn-primary btn-block" onclick="calculateHH()">
                                        <i class="fas fa-calculator"></i> Calculate
                                    </button>

                                    <hr>
                                    <h6 class="text-muted">Example Problems:</h6>
                                    <div class="example-section">
                                        <div class="example-category">⭐ Basic Buffer pH</div>
                                        <span class="example-badge" onclick="setHHExample(4.76, 0.1, 0.1)">Acetic acid buffer: pKa=4.76, [HA]=[A⁻]=0.1M</span>
                                        <span class="example-badge" onclick="setHHExample(7.21, 0.05, 0.05)">Phosphate buffer: pKa=7.21, equal concentrations</span>
                                        <span class="example-badge" onclick="setHHExample(9.25, 0.1, 0.1)">NH₃/NH₄⁺ buffer: pKa=9.25, [base]=[acid]=0.1M</span>

                                        <div class="example-category">⭐⭐ Unequal Concentrations</div>
                                        <span class="example-badge" onclick="setHHExample(4.76, 0.2, 0.1)">Acetate: [HA]=0.2M, [A⁻]=0.1M</span>
                                        <span class="example-badge" onclick="setHHExample(7.21, 0.15, 0.05)">Phosphate: [HA]=0.15M, [A⁻]=0.05M</span>
                                        <span class="example-badge" onclick="setHHExample(3.75, 0.25, 0.05)">Formate: pKa=3.75, ratio 1:5</span>

                                        <div class="example-category">⭐⭐⭐ Reverse Calculations</div>
                                        <span class="example-badge" onclick="setRatioExample(5.0, 4.76)">Find ratio: pH=5.0, pKa=4.76</span>
                                        <span class="example-badge" onclick="setRatioExample(7.4, 7.21)">Blood pH: pH=7.4, phosphate pKa=7.21</span>
                                        <span class="example-badge" onclick="setPKaExample(4.5, 0.2, 0.1)">Find pKa: pH=4.5, given concentrations</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        -<div class="col-lg-5">
                            <div class="card sticky-top" style="top: 20px;">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-check-circle text-success"></i> Result</h5>
                                    <div id="hhResult">
                                        <p class="text-muted">Enter values and click Calculate to see the result</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- BUFFER CAPACITY TAB -->
                <div class="tab-pane fade" id="capacity" role="tabpanel">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-chart-line text-primary"></i> Buffer Capacity Calculator</h5>
                                    <p class="text-muted small">β = 2.303 × [Buffer] × ([H⁺][OH⁻]) / ([H⁺] + Ka)²</p>

                                    <div class="form-group">
                                        <label>Buffer pH:</label>
                                        <input type="number" class="form-control" id="capacityPH" placeholder="e.g., 7.4" step="0.01">
                                    </div>

                                    <div class="form-group">
                                        <label>pKa of Weak Acid:</label>
                                        <input type="number" class="form-control" id="capacityPKa" placeholder="e.g., 4.76" step="0.01">
                                    </div>

                                    <div class="form-group">
                                        <label>Total Buffer Concentration (M):</label>
                                        <input type="number" class="form-control" id="capacityConcentration" placeholder="e.g., 0.1" step="0.001">
                                    </div>

                                    <button class="btn btn-primary btn-block" onclick="calculateCapacity()">
                                        <i class="fas fa-calculator"></i> Calculate Buffer Capacity
                                    </button>

                                    <hr>
                                    <div class="alert alert-info">
                                        <h6><i class="fas fa-info-circle"></i> About Buffer Capacity</h6>
                                        <ul class="small mb-0">
                                            <li>Maximum capacity when pH = pKa</li>
                                            <li>Effective range: pKa ± 1</li>
                                            <li>Higher concentration = higher capacity</li>
                                            <li>Capacity measures resistance to pH change</li>
                                        </ul>
                                    </div>

                                    <hr>
                                    <h6 class="text-muted">Example Problems:</h6>
                                    <div class="example-section">
                                        <span class="example-badge" onclick="setCapacityExample(4.76, 4.76, 0.1)">Maximum capacity: pH=pKa=4.76, [buffer]=0.1M</span>
                                        <span class="example-badge" onclick="setCapacityExample(7.4, 7.21, 0.05)">Phosphate buffer: pH=7.4, pKa=7.21</span>
                                        <span class="example-badge" onclick="setCapacityExample(5.0, 4.76, 0.2)">High concentration: 0.2M acetate buffer</span>
                                        <span class="example-badge" onclick="setCapacityExample(3.0, 4.76, 0.1)">Outside range: pH=3.0, pKa=4.76</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="card sticky-top" style="top: 20px;">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-check-circle text-success"></i> Result</h5>
                                    <div id="capacityResult">
                                        <p class="text-muted">Enter values and click Calculate to see buffer capacity</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- BUFFER PREPARATION TAB -->
                <div class="tab-pane fade" id="preparation" role="tabpanel">
                    <div class="row">
                        <div class="col-lg-7">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-flask text-primary"></i> Buffer Preparation Calculator</h5>

                                    <div class="form-group">
                                        <label>Select Buffer System:</label>
                                        <select class="form-control" id="prepBufferType" onchange="updatePrepFields()">
                                            <option value="acetate">Acetate Buffer (CH₃COOH/CH₃COONa)</option>
                                            <option value="phosphate">Phosphate Buffer (H₂PO₄⁻/HPO₄²⁻)</option>
                                            <option value="citrate">Citrate Buffer</option>
                                            <option value="tris">Tris Buffer (Tris-HCl)</option>
                                            <option value="carbonate">Carbonate Buffer</option>
                                            <option value="ammonia">Ammonia Buffer (NH₃/NH₄Cl)</option>
                                            <option value="custom">Custom Buffer System</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label>Desired pH:</label>
                                        <input type="number" class="form-control" id="prepPH" placeholder="e.g., 7.4" step="0.1">
                                        <small class="form-text text-muted" id="prepPHRange"></small>
                                    </div>

                                    <div class="form-group">
                                        <label>Total Buffer Concentration (M):</label>
                                        <input type="number" class="form-control" id="prepConcentration" placeholder="e.g., 0.1" step="0.01">
                                    </div>

                                    <div class="form-group">
                                        <label>Total Volume (mL):</label>
                                        <input type="number" class="form-control" id="prepVolume" placeholder="e.g., 1000" step="1">
                                    </div>

                                    <div id="prepCustomFields" style="display: none;">
                                        <div class="form-group">
                                            <label>pKa of Weak Acid:</label>
                                            <input type="number" class="form-control" id="prepCustomPKa" placeholder="e.g., 4.76" step="0.01">
                                        </div>
                                        <div class="form-group">
                                            <label>Weak Acid Molar Mass (g/mol):</label>
                                            <input type="number" class="form-control" id="prepCustomMW1" placeholder="e.g., 60.05" step="0.01">
                                        </div>
                                        <div class="form-group">
                                            <label>Conjugate Base Molar Mass (g/mol):</label>
                                            <input type="number" class="form-control" id="prepCustomMW2" placeholder="e.g., 82.03" step="0.01">
                                        </div>
                                    </div>

                                    <button class="btn btn-primary btn-block" onclick="calculatePreparation()">
                                        <i class="fas fa-flask"></i> Calculate Preparation
                                    </button>

                                    <hr>
                                    <h6 class="text-muted">Example Problems:</h6>
                                    <div class="example-section">
                                        <span class="example-badge" onclick="setPrepExample('acetate', 4.76, 0.1, 1000)">1L of 0.1M acetate buffer, pH 4.76</span>
                                        <span class="example-badge" onclick="setPrepExample('phosphate', 7.4, 0.05, 500)">500mL phosphate buffer, pH 7.4</span>
                                        <span class="example-badge" onclick="setPrepExample('tris', 8.0, 0.1, 250)">250mL Tris buffer, pH 8.0</span>
                                        <span class="example-badge" onclick="setPrepExample('citrate', 5.0, 0.1, 1000)">1L citrate buffer, pH 5.0</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-5">
                            <div class="card sticky-top" style="top: 20px;">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-check-circle text-success"></i> Preparation Instructions</h5>
                                    <div id="prepResult">
                                        <p class="text-muted">Enter values and click Calculate to see preparation instructions</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- COMMON BUFFERS DATABASE TAB -->
                <div class="tab-pane fade" id="database" role="tabpanel">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title"><i class="fas fa-database text-primary"></i> Common Buffer Systems</h5>

                            <div class="table-responsive">
                                <table class="table table-striped table-hover">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>Buffer Name</th>
                                            <th>Chemical System</th>
                                            <th>pKa</th>
                                            <th>Effective pH Range</th>
                                            <th>Common Uses</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><strong>Acetate</strong></td>
                                            <td>CH₃COOH/CH₃COO⁻</td>
                                            <td>4.76</td>
                                            <td>3.76 - 5.76</td>
                                            <td>DNA/RNA work, electrophoresis</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Citrate</strong></td>
                                            <td>Citric acid/Citrate</td>
                                            <td>3.13, 4.76, 6.40</td>
                                            <td>2.1 - 7.4</td>
                                            <td>Antigen retrieval, enzyme assays</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Phosphate (PBS)</strong></td>
                                            <td>H₂PO₄⁻/HPO₄²⁻</td>
                                            <td>7.21</td>
                                            <td>6.2 - 8.2</td>
                                            <td>Cell culture, biological work</td>
                                        </tr>
                                        <tr>
                                            <td><strong>HEPES</strong></td>
                                            <td>HEPES acid/base</td>
                                            <td>7.48</td>
                                            <td>6.8 - 8.2</td>
                                            <td>Cell culture, tissue culture</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Tris</strong></td>
                                            <td>Tris-H⁺/Tris</td>
                                            <td>8.06</td>
                                            <td>7.0 - 9.0</td>
                                            <td>Biochemistry, molecular biology</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Bicarbonate</strong></td>
                                            <td>H₂CO₃/HCO₃⁻</td>
                                            <td>6.35</td>
                                            <td>5.4 - 7.4</td>
                                            <td>Blood, physiological systems</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Carbonate</strong></td>
                                            <td>HCO₃⁻/CO₃²⁻</td>
                                            <td>10.33</td>
                                            <td>9.3 - 11.3</td>
                                            <td>Alkaline solutions</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Ammonia</strong></td>
                                            <td>NH₄⁺/NH₃</td>
                                            <td>9.25</td>
                                            <td>8.25 - 10.25</td>
                                            <td>Basic pH applications</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Borate</strong></td>
                                            <td>Boric acid/Borate</td>
                                            <td>9.24</td>
                                            <td>8.2 - 10.2</td>
                                            <td>Electrophoresis, biochemistry</td>
                                        </tr>
                                        <tr>
                                            <td><strong>Glycine</strong></td>
                                            <td>Glycine-H⁺/Glycine</td>
                                            <td>9.78</td>
                                            <td>8.8 - 10.8</td>
                                            <td>Western blotting, electrophoresis</td>
                                        </tr>
                                        <tr>
                                            <td><strong>MES</strong></td>
                                            <td>MES acid/base</td>
                                            <td>6.15</td>
                                            <td>5.5 - 6.7</td>
                                            <td>Biological buffers</td>
                                        </tr>
                                        <tr>
                                            <td><strong>MOPS</strong></td>
                                            <td>MOPS acid/base</td>
                                            <td>7.20</td>
                                            <td>6.5 - 7.9</td>
                                            <td>RNA work, enzyme reactions</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="alert alert-info mt-3">
                                <h6><i class="fas fa-lightbulb"></i> Buffer Selection Tips</h6>
                                <ul class="small mb-0">
                                    <li><strong>Choose pKa close to desired pH:</strong> Best buffering capacity when pH ≈ pKa</li>
                                    <li><strong>Consider temperature:</strong> pKa values change with temperature (especially Tris)</li>
                                    <li><strong>Check compatibility:</strong> Some buffers interact with metal ions or proteins</li>
                                    <li><strong>Physiological work:</strong> Use PBS or HEPES for cell culture</li>
                                    <li><strong>Molecular biology:</strong> Tris is widely used for DNA/RNA work</li>
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
// BUFFER DATABASE
// ============================================
const bufferDatabase = {
    acetate: {
        name: 'Acetate Buffer',
        acid: 'Acetic Acid (CH₃COOH)',
        base: 'Sodium Acetate (CH₃COONa)',
        pKa: 4.76,
        mwAcid: 60.05,
        mwBase: 82.03,
        range: '3.76 - 5.76'
    },
    phosphate: {
        name: 'Phosphate Buffer',
        acid: 'Sodium Dihydrogen Phosphate (NaH₂PO₄)',
        base: 'Disodium Hydrogen Phosphate (Na₂HPO₄)',
        pKa: 7.21,
        mwAcid: 119.98,
        mwBase: 141.96,
        range: '6.2 - 8.2'
    },
    citrate: {
        name: 'Citrate Buffer',
        acid: 'Citric Acid (C₆H₈O₇)',
        base: 'Sodium Citrate (Na₃C₆H₅O₇)',
        pKa: 4.76,
        mwAcid: 192.12,
        mwBase: 258.07,
        range: '3.0 - 6.5'
    },
    tris: {
        name: 'Tris Buffer',
        acid: 'Tris-HCl',
        base: 'Tris base (C₄H₁₁NO₃)',
        pKa: 8.06,
        mwAcid: 157.60,
        mwBase: 121.14,
        range: '7.0 - 9.0'
    },
    carbonate: {
        name: 'Carbonate Buffer',
        acid: 'Sodium Bicarbonate (NaHCO₃)',
        base: 'Sodium Carbonate (Na₂CO₃)',
        pKa: 10.33,
        mwAcid: 84.01,
        mwBase: 105.99,
        range: '9.3 - 11.3'
    },
    ammonia: {
        name: 'Ammonia Buffer',
        acid: 'Ammonium Chloride (NH₄Cl)',
        base: 'Ammonia (NH₃)',
        pKa: 9.25,
        mwAcid: 53.49,
        mwBase: 17.03,
        range: '8.25 - 10.25'
    }
};

// ============================================
// HENDERSON-HASSELBALCH CALCULATOR
// ============================================
function updateHHFields() {
    const calcType = document.getElementById('hhCalculateWhat').value;
    const container = document.getElementById('hhInputFields');

    if (calcType === 'pH') {
        container.innerHTML = `
            <div class="form-group">
                <label>pKa of Weak Acid:</label>
                <input type="number" class="form-control" id="hhPKa" placeholder="e.g., 4.76" step="0.01">
            </div>
            <div class="form-group">
                <label>Concentration of Weak Acid [HA] (M):</label>
                <input type="number" class="form-control" id="hhAcidConc" placeholder="e.g., 0.1" step="0.001">
            </div>
            <div class="form-group">
                <label>Concentration of Conjugate Base [A⁻] (M):</label>
                <input type="number" class="form-control" id="hhBaseConc" placeholder="e.g., 0.1" step="0.001">
            </div>
        `;
    } else if (calcType === 'ratio') {
        container.innerHTML = `
            <div class="form-group">
                <label>Desired pH:</label>
                <input type="number" class="form-control" id="hhPH" placeholder="e.g., 5.0" step="0.01">
            </div>
            <div class="form-group">
                <label>pKa of Weak Acid:</label>
                <input type="number" class="form-control" id="hhPKa" placeholder="e.g., 4.76" step="0.01">
            </div>
        `;
    } else if (calcType === 'pKa') {
        container.innerHTML = `
            <div class="form-group">
                <label>Buffer pH:</label>
                <input type="number" class="form-control" id="hhPH" placeholder="e.g., 4.5" step="0.01">
            </div>
            <div class="form-group">
                <label>Concentration of Weak Acid [HA] (M):</label>
                <input type="number" class="form-control" id="hhAcidConc" placeholder="e.g., 0.2" step="0.001">
            </div>
            <div class="form-group">
                <label>Concentration of Conjugate Base [A⁻] (M):</label>
                <input type="number" class="form-control" id="hhBaseConc" placeholder="e.g., 0.1" step="0.001">
            </div>
        `;
    }
}

function calculateHH() {
    const calcType = document.getElementById('hhCalculateWhat').value;
    let result = '';

    if (calcType === 'pH') {
        const pKa = parseFloat(document.getElementById('hhPKa').value);
        const acidConc = parseFloat(document.getElementById('hhAcidConc').value);
        const baseConc = parseFloat(document.getElementById('hhBaseConc').value);

        if (isNaN(pKa) || isNaN(acidConc) || isNaN(baseConc)) {
            showError('hhResult', 'Please enter all values');
            return;
        }

        const ratio = baseConc / acidConc;
        const pH = pKa + Math.log10(ratio);

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-check-circle"></i> pH Calculation</h5>
                <p><strong>pH = ${pH.toFixed(3)}</strong></p>
                <hr>
                <h6>Step-by-Step Solution:</h6>
                <ol class="small">
                    <li>Use Henderson-Hasselbalch: pH = pKa + log([A⁻]/[HA])</li>
                    <li>Given: pKa = ${pKa}, [HA] = ${acidConc} M, [A⁻] = ${baseConc} M</li>
                    <li>Calculate ratio: [A⁻]/[HA] = ${baseConc}/${acidConc} = ${ratio.toFixed(4)}</li>
                    <li>Calculate log: log(${ratio.toFixed(4)}) = ${Math.log10(ratio).toFixed(4)}</li>
                    <li>pH = ${pKa} + ${Math.log10(ratio).toFixed(4)} = <strong>${pH.toFixed(3)}</strong></li>
                </ol>
                ${ratio < 0.1 || ratio > 10 ? '<p class="text-warning small mb-0"><i class="fas fa-exclamation-triangle"></i> Warning: Ratio outside 0.1-10 range may have poor buffering capacity</p>' : ''}
            </div>
        `;
    } else if (calcType === 'ratio') {
        const pH = parseFloat(document.getElementById('hhPH').value);
        const pKa = parseFloat(document.getElementById('hhPKa').value);

        if (isNaN(pH) || isNaN(pKa)) {
            showError('hhResult', 'Please enter all values');
            return;
        }

        const ratio = Math.pow(10, pH - pKa);

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-check-circle"></i> Ratio Calculation</h5>
                <p><strong>[A⁻]/[HA] = ${ratio.toFixed(4)}</strong></p>
                <hr>
                <h6>Step-by-Step Solution:</h6>
                <ol class="small">
                    <li>Rearrange H-H equation: log([A⁻]/[HA]) = pH - pKa</li>
                    <li>Given: pH = ${pH}, pKa = ${pKa}</li>
                    <li>log([A⁻]/[HA]) = ${pH} - ${pKa} = ${(pH - pKa).toFixed(3)}</li>
                    <li>[A⁻]/[HA] = 10^${(pH - pKa).toFixed(3)} = <strong>${ratio.toFixed(4)}</strong></li>
                </ol>
                <p class="small mb-0"><strong>Interpretation:</strong> For every ${ratio < 1 ? '1' : ratio.toFixed(2)} mole(s) of A⁻, use ${ratio < 1 ? (1/ratio).toFixed(2) : '1'} mole(s) of HA</p>
            </div>
        `;
    } else if (calcType === 'pKa') {
        const pH = parseFloat(document.getElementById('hhPH').value);
        const acidConc = parseFloat(document.getElementById('hhAcidConc').value);
        const baseConc = parseFloat(document.getElementById('hhBaseConc').value);

        if (isNaN(pH) || isNaN(acidConc) || isNaN(baseConc)) {
            showError('hhResult', 'Please enter all values');
            return;
        }

        const ratio = baseConc / acidConc;
        const pKa = pH - Math.log10(ratio);

        result = `
            <div class="alert alert-success">
                <h5><i class="fas fa-check-circle"></i> pKa Calculation</h5>
                <p><strong>pKa = ${pKa.toFixed(3)}</strong></p>
                <hr>
                <h6>Step-by-Step Solution:</h6>
                <ol class="small">
                    <li>Rearrange H-H equation: pKa = pH - log([A⁻]/[HA])</li>
                    <li>Given: pH = ${pH}, [HA] = ${acidConc} M, [A⁻] = ${baseConc} M</li>
                    <li>Calculate ratio: [A⁻]/[HA] = ${baseConc}/${acidConc} = ${ratio.toFixed(4)}</li>
                    <li>Calculate log: log(${ratio.toFixed(4)}) = ${Math.log10(ratio).toFixed(4)}</li>
                    <li>pKa = ${pH} - ${Math.log10(ratio).toFixed(4)} = <strong>${pKa.toFixed(3)}</strong></li>
                </ol>
            </div>
        `;
    }

    document.getElementById('hhResult').innerHTML = result;
}

function setHHExample(pKa, acidConc, baseConc) {
    document.getElementById('hhCalculateWhat').value = 'pH';
    updateHHFields();
    setTimeout(() => {
        document.getElementById('hhPKa').value = pKa;
        document.getElementById('hhAcidConc').value = acidConc;
        document.getElementById('hhBaseConc').value = baseConc;
        calculateHH();
    }, 100);
}

function setRatioExample(pH, pKa) {
    document.getElementById('hhCalculateWhat').value = 'ratio';
    updateHHFields();
    setTimeout(() => {
        document.getElementById('hhPH').value = pH;
        document.getElementById('hhPKa').value = pKa;
        calculateHH();
    }, 100);
}

function setPKaExample(pH, acidConc, baseConc) {
    document.getElementById('hhCalculateWhat').value = 'pKa';
    updateHHFields();
    setTimeout(() => {
        document.getElementById('hhPH').value = pH;
        document.getElementById('hhAcidConc').value = acidConc;
        document.getElementById('hhBaseConc').value = baseConc;
        calculateHH();
    }, 100);
}

// ============================================
// BUFFER CAPACITY CALCULATOR
// ============================================
function calculateCapacity() {
    const pH = parseFloat(document.getElementById('capacityPH').value);
    const pKa = parseFloat(document.getElementById('capacityPKa').value);
    const totalConc = parseFloat(document.getElementById('capacityConcentration').value);

    if (isNaN(pH) || isNaN(pKa) || isNaN(totalConc)) {
        showError('capacityResult', 'Please enter all values');
        return;
    }

    const Ka = Math.pow(10, -pKa);
    const H = Math.pow(10, -pH);
    const OH = 1e-14 / H;

    // β = 2.303 × C × (Ka × H) / (Ka + H)²
    const beta = 2.303 * totalConc * (Ka * H) / Math.pow(Ka + H, 2);

    const pHDiff = Math.abs(pH - pKa);
    let effectiveness = '';
    if (pHDiff < 0.5) {
        effectiveness = '<span class="badge badge-success">Excellent buffering capacity</span>';
    } else if (pHDiff < 1.0) {
        effectiveness = '<span class="badge badge-success">Good buffering capacity</span>';
    } else if (pHDiff < 1.5) {
        effectiveness = '<span class="badge badge-warning">Moderate buffering capacity</span>';
    } else {
        effectiveness = '<span class="badge badge-danger">Poor buffering capacity</span>';
    }

    const result = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Buffer Capacity</h5>
            <p><strong>β = ${beta.toExponential(3)} mol/(L·pH)</strong></p>
            <p>${effectiveness}</p>
            <hr>
            <h6>Analysis:</h6>
            <ul class="small">
                <li>pH difference from pKa: |${pH} - ${pKa}| = ${pHDiff.toFixed(2)}</li>
                <li>Maximum capacity at pH = pKa: β<sub>max</sub> = ${(0.576 * totalConc).toExponential(3)}</li>
                <li>Current capacity is ${((beta / (0.576 * totalConc)) * 100).toFixed(1)}% of maximum</li>
                <li>Can neutralize ~${(beta * 0.1).toExponential(2)} mol of strong acid/base per liter per 0.1 pH change</li>
            </ul>
            ${pHDiff > 1 ? '<p class="text-warning small mb-0"><i class="fas fa-exclamation-triangle"></i> Buffer is outside optimal range (pKa ± 1)</p>' : ''}
        </div>
    `;

    document.getElementById('capacityResult').innerHTML = result;
}

function setCapacityExample(pH, pKa, conc) {
    document.getElementById('capacityPH').value = pH;
    document.getElementById('capacityPKa').value = pKa;
    document.getElementById('capacityConcentration').value = conc;
    calculateCapacity();
}

// ============================================
// BUFFER PREPARATION CALCULATOR
// ============================================
function updatePrepFields() {
    const bufferType = document.getElementById('prepBufferType').value;
    const customFields = document.getElementById('prepCustomFields');

    if (bufferType === 'custom') {
        customFields.style.display = 'block';
        document.getElementById('prepPHRange').textContent = 'Enter custom pKa below';
    } else {
        customFields.style.display = 'none';
        const buffer = bufferDatabase[bufferType];
        document.getElementById('prepPHRange').textContent = `Effective range: ${buffer.range} (pKa = ${buffer.pKa})`;
    }
}

function calculatePreparation() {
    const bufferType = document.getElementById('prepBufferType').value;
    const pH = parseFloat(document.getElementById('prepPH').value);
    const totalConc = parseFloat(document.getElementById('prepConcentration').value);
    const volume = parseFloat(document.getElementById('prepVolume').value);

    if (isNaN(pH) || isNaN(totalConc) || isNaN(volume)) {
        showError('prepResult', 'Please enter all values');
        return;
    }

    let buffer, pKa, mwAcid, mwBase, acidName, baseName;

    if (bufferType === 'custom') {
        pKa = parseFloat(document.getElementById('prepCustomPKa').value);
        mwAcid = parseFloat(document.getElementById('prepCustomMW1').value);
        mwBase = parseFloat(document.getElementById('prepCustomMW2').value);
        acidName = 'Weak Acid';
        baseName = 'Conjugate Base';

        if (isNaN(pKa) || isNaN(mwAcid) || isNaN(mwBase)) {
            showError('prepResult', 'Please enter all custom buffer parameters');
            return;
        }
    } else {
        buffer = bufferDatabase[bufferType];
        pKa = buffer.pKa;
        mwAcid = buffer.mwAcid;
        mwBase = buffer.mwBase;
        acidName = buffer.acid;
        baseName = buffer.base;
    }

    // Calculate ratio using Henderson-Hasselbalch
    const ratio = Math.pow(10, pH - pKa); // [A-]/[HA]

    // Calculate individual concentrations
    const acidConc = totalConc / (1 + ratio);
    const baseConc = totalConc * ratio / (1 + ratio);

    // Calculate masses needed
    const volumeL = volume / 1000;
    const molesAcid = acidConc * volumeL;
    const molesBase = baseConc * volumeL;
    const massAcid = molesAcid * mwAcid;
    const massBase = molesBase * mwBase;

    const pHDiff = Math.abs(pH - pKa);
    let warning = '';
    if (pHDiff > 1) {
        warning = '<div class="alert alert-warning mt-2"><i class="fas fa-exclamation-triangle"></i> Warning: pH is outside optimal buffering range (pKa ± 1)</div>';
    }

    const result = `
        <div class="alert alert-success">
            <h5><i class="fas fa-flask"></i> Preparation Instructions</h5>
            ${bufferType !== 'custom' ? `<h6>${buffer.name} at pH ${pH}</h6>` : `<h6>Custom Buffer at pH ${pH}</h6>`}

            <div class="card mt-3 mb-3" style="background-color: #e3f2fd;">
                <div class="card-body">
                    <h6 class="text-primary">📋 Recipe:</h6>
                    <ul>
                        <li><strong>${massAcid.toFixed(3)} g</strong> of ${acidName}</li>
                        <li><strong>${massBase.toFixed(3)} g</strong> of ${baseName}</li>
                        <li>Dissolve in <strong>${(volume * 0.8).toFixed(0)} mL</strong> of deionized water</li>
                    </ul>
                </div>
            </div>

            <h6>Step-by-Step Procedure:</h6>
            <ol class="small">
                <li>Weigh <strong>${massAcid.toFixed(3)} g</strong> of ${acidName} and add to a beaker</li>
                <li>Weigh <strong>${massBase.toFixed(3)} g</strong> of ${baseName} and add to the same beaker</li>
                <li>Add approximately ${(volume * 0.8).toFixed(0)} mL of deionized water</li>
                <li>Stir until completely dissolved</li>
                <li>Transfer to a ${volume} mL volumetric flask</li>
                <li>Fill to the ${volume} mL mark with deionized water</li>
                <li>Mix thoroughly</li>
                <li><strong>Verify pH</strong> with a calibrated pH meter and adjust if needed</li>
            </ol>

            <hr>
            <h6>Technical Details:</h6>
            <ul class="small mb-0">
                <li>Total buffer concentration: ${totalConc} M</li>
                <li>[HA] = ${acidConc.toFixed(4)} M (${molesAcid.toFixed(4)} mol)</li>
                <li>[A⁻] = ${baseConc.toFixed(4)} M (${molesBase.toFixed(4)} mol)</li>
                <li>Ratio [A⁻]/[HA] = ${ratio.toFixed(4)}</li>
                <li>pKa = ${pKa}, target pH = ${pH}</li>
            </ul>
        </div>
        ${warning}
    `;

    document.getElementById('prepResult').innerHTML = result;
}

function setPrepExample(type, pH, conc, vol) {
    document.getElementById('prepBufferType').value = type;
    updatePrepFields();
    document.getElementById('prepPH').value = pH;
    document.getElementById('prepConcentration').value = conc;
    document.getElementById('prepVolume').value = vol;
    calculatePreparation();
}

// ============================================
// UTILITY FUNCTIONS
// ============================================
function showError(elementId, message) {
    document.getElementById(elementId).innerHTML = `<div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${message}</div>`;
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    updateHHFields();
    updatePrepFields();
});
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
</html>
