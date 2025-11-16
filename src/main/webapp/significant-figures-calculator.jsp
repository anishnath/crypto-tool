<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Significant Figures Calculator - Sig Fig Counter & Calculator</title>
    <meta name="description" content="Free significant figures calculator. Count sig figs, perform calculations with proper sig fig rules, round to significant figures, and convert to scientific notation. Step-by-step solutions included.">
    <meta name="keywords" content="significant figures calculator, sig figs calculator, significant digits, sig fig counter, scientific notation, chemistry calculator">

    <!-- Open Graph tags -->
    <meta property="og:title" content="Significant Figures Calculator - Count & Calculate">
    <meta property="og:description" content="Count significant figures, perform arithmetic with sig fig rules, and round numbers. Free calculator with step-by-step solutions.">
    <meta property="og:type" content="website">

    <!-- Schema.org structured data -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Significant Figures Calculator",
        "description": "Calculate significant figures, perform arithmetic operations with proper sig fig rules, round to significant figures, and convert to scientific notation. Educational tool with detailed explanations.",
        "applicationCategory": "EducationalApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "featureList": "Sig fig counter, Addition and subtraction, Multiplication and division, Rounding to sig figs, Scientific notation conversion, Sig fig rules explanation",
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

    <style>
        body {
            background-color: #f8f9fa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        }

        .card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
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

        .sig-badge {
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

        .number-display {
            font-family: 'Courier New', monospace;
            font-size: 1.3rem;
            font-weight: 600;
            color: #1f2937;
            background: #f3f4f6;
            padding: 10px;
            border-radius: 4px;
            margin: 10px 0;
        }

        .sig-digit {
            color: #059669;
            font-weight: 700;
        }

        .non-sig-digit {
            color: #9ca3af;
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

        .rule-box {
            background: #f0fdf4;
            border-left: 4px solid #059669;
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
    <h1 class="mb-3">Significant Figures Calculator</h1>
    <p class="lead mb-4">
        Count significant figures, perform calculations with proper sig fig rules, and round numbers.
    </p>

    <div class="row">
        <!-- Left Column - Input Forms -->
        <div class="col-lg-7 mb-4">
            <div class="card shadow-sm">
                <div class="card-body">
                    <ul class="nav nav-tabs mb-3" id="calculatorTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="count-tab" data-toggle="tab" href="#countTab" role="tab">
                                <i class="fas fa-calculator"></i> Count Sig Figs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="arithmetic-tab" data-toggle="tab" href="#arithmeticTab" role="tab">
                                <i class="fas fa-plus"></i> Arithmetic
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="round-tab" data-toggle="tab" href="#roundTab" role="tab">
                                <i class="fas fa-redo"></i> Round
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="notation-tab" data-toggle="tab" href="#notationTab" role="tab">
                                <i class="fas fa-superscript"></i> Scientific
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content">
                        <!-- Count Sig Figs Tab -->
                        <div class="tab-pane fade show active" id="countTab" role="tabpanel">
                            <h5 class="mb-3">Count Significant Figures</h5>
                            <p class="text-muted small">Enter a number to count its significant figures.</p>

                            <div class="form-group">
                                <label><strong>Number</strong></label>
                                <input type="text" class="form-control" id="countNumber" placeholder="e.g., 0.00450, 1200, 3.140">
                            </div>

                            <button class="btn btn-primary btn-block" onclick="countSigFigs()">
                                <i class="fas fa-calculator"></i> Count Significant Figures
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Numbers:</h6>

                                <div class="example-category">⭐ Leading Zeros (Not Significant)</div>
                                <span class="example-reaction" onclick="setCountExample('0.00450')">0.00450</span>
                                <span class="example-reaction" onclick="setCountExample('0.0123')">0.0123</span>
                                <span class="example-reaction" onclick="setCountExample('0.500')">0.500</span>

                                <div class="example-category">⭐⭐ Trailing Zeros (Context Matters)</div>
                                <span class="example-reaction" onclick="setCountExample('1200')">1200</span>
                                <span class="example-reaction" onclick="setCountExample('1200.')">1200.</span>
                                <span class="example-reaction" onclick="setCountExample('1200.0')">1200.0</span>
                                <span class="example-reaction" onclick="setCountExample('120')">120</span>

                                <div class="example-category">⭐⭐⭐ Trapped Zeros (Always Significant)</div>
                                <span class="example-reaction" onclick="setCountExample('1002')">1002</span>
                                <span class="example-reaction" onclick="setCountExample('50.03')">50.03</span>
                                <span class="example-reaction" onclick="setCountExample('1.0023')">1.0023</span>

                                <div class="example-category">⭐⭐⭐⭐ Scientific Notation</div>
                                <span class="example-reaction" onclick="setCountExample('1.23e5')">1.23×10⁵</span>
                                <span class="example-reaction" onclick="setCountExample('4.500e-3')">4.500×10⁻³</span>
                                <span class="example-reaction" onclick="setCountExample('6.02e23')">6.02×10²³</span>
                            </div>
                        </div>

                        <!-- Arithmetic Tab -->
                        <div class="tab-pane fade" id="arithmeticTab" role="tabpanel">
                            <h5 class="mb-3">Arithmetic with Sig Figs</h5>
                            <p class="text-muted small">Perform calculations following significant figure rules.</p>

                            <div class="form-group">
                                <label><strong>Operation</strong></label>
                                <select class="form-control" id="arithmeticOp">
                                    <option value="add">Addition (+)</option>
                                    <option value="subtract">Subtraction (−)</option>
                                    <option value="multiply">Multiplication (×)</option>
                                    <option value="divide">Division (÷)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label><strong>First Number</strong></label>
                                <input type="text" class="form-control" id="arithmeticNum1" placeholder="e.g., 12.34">
                            </div>

                            <div class="form-group">
                                <label><strong>Second Number</strong></label>
                                <input type="text" class="form-control" id="arithmeticNum2" placeholder="e.g., 5.6">
                            </div>

                            <button class="btn btn-primary btn-block" onclick="calculateArithmetic()">
                                <i class="fas fa-calculator"></i> Calculate with Sig Figs
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Calculations:</h6>

                                <div class="example-category">⭐ Addition (Decimal Places)</div>
                                <span class="example-reaction" onclick="setArithmeticExample('add', '12.34', '5.6')">12.34 + 5.6</span>
                                <span class="example-reaction" onclick="setArithmeticExample('add', '100.5', '23.456')">100.5 + 23.456</span>

                                <div class="example-category">⭐⭐ Subtraction (Decimal Places)</div>
                                <span class="example-reaction" onclick="setArithmeticExample('subtract', '45.67', '12.3')">45.67 − 12.3</span>
                                <span class="example-reaction" onclick="setArithmeticExample('subtract', '1000', '5.5')">1000 − 5.5</span>

                                <div class="example-category">⭐⭐⭐ Multiplication (Sig Figs)</div>
                                <span class="example-reaction" onclick="setArithmeticExample('multiply', '12.34', '5.6')">12.34 × 5.6</span>
                                <span class="example-reaction" onclick="setArithmeticExample('multiply', '0.0045', '123')">0.0045 × 123</span>

                                <div class="example-category">⭐⭐⭐⭐ Division (Sig Figs)</div>
                                <span class="example-reaction" onclick="setArithmeticExample('divide', '45.67', '12.3')">45.67 ÷ 12.3</span>
                                <span class="example-reaction" onclick="setArithmeticExample('divide', '100', '3.0')">100 ÷ 3.0</span>
                            </div>
                        </div>

                        <!-- Round Tab -->
                        <div class="tab-pane fade" id="roundTab" role="tabpanel">
                            <h5 class="mb-3">Round to Significant Figures</h5>
                            <p class="text-muted small">Round a number to a specific number of significant figures.</p>

                            <div class="form-group">
                                <label><strong>Number to Round</strong></label>
                                <input type="text" class="form-control" id="roundNumber" placeholder="e.g., 123.4567">
                            </div>

                            <div class="form-group">
                                <label><strong>Round to How Many Sig Figs?</strong></label>
                                <input type="number" class="form-control" id="roundSigFigs" placeholder="e.g., 3" min="1" max="10">
                            </div>

                            <button class="btn btn-primary btn-block" onclick="roundToSigFigs()">
                                <i class="fas fa-redo"></i> Round Number
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Problems:</h6>

                                <div class="example-category">⭐ Basic Rounding</div>
                                <span class="example-reaction" onclick="setRoundExample('123.456', 3)">123.456 → 3 sig figs</span>
                                <span class="example-reaction" onclick="setRoundExample('0.004567', 2)">0.004567 → 2 sig figs</span>

                                <div class="example-category">⭐⭐ Large Numbers</div>
                                <span class="example-reaction" onclick="setRoundExample('12345', 3)">12345 → 3 sig figs</span>
                                <span class="example-reaction" onclick="setRoundExample('98765', 2)">98765 → 2 sig figs</span>

                                <div class="example-category">⭐⭐⭐ Decimal Numbers</div>
                                <span class="example-reaction" onclick="setRoundExample('45.678', 4)">45.678 → 4 sig figs</span>
                                <span class="example-reaction" onclick="setRoundExample('0.123456', 3)">0.123456 → 3 sig figs</span>
                            </div>
                        </div>

                        <!-- Scientific Notation Tab -->
                        <div class="tab-pane fade" id="notationTab" role="tabpanel">
                            <h5 class="mb-3">Scientific Notation</h5>
                            <p class="text-muted small">Convert numbers to/from scientific notation.</p>

                            <div class="form-group">
                                <label><strong>Number</strong></label>
                                <input type="text" class="form-control" id="notationNumber" placeholder="e.g., 0.00456 or 1.23e-5">
                            </div>

                            <div class="form-group">
                                <label><strong>Significant Figures (optional)</strong></label>
                                <input type="number" class="form-control" id="notationSigFigs" placeholder="Leave blank for auto">
                            </div>

                            <button class="btn btn-primary btn-block" onclick="convertNotation()">
                                <i class="fas fa-exchange-alt"></i> Convert to Scientific Notation
                            </button>

                            <div class="mt-4">
                                <h6 class="text-muted">Example Conversions:</h6>

                                <div class="example-category">⭐ Small Numbers</div>
                                <span class="example-reaction" onclick="setNotationExample('0.00456')">0.00456</span>
                                <span class="example-reaction" onclick="setNotationExample('0.0000789')">0.0000789</span>

                                <div class="example-category">⭐⭐ Large Numbers</div>
                                <span class="example-reaction" onclick="setNotationExample('123000')">123000</span>
                                <span class="example-reaction" onclick="setNotationExample('6020000000000000000000000')">Avogadro's number</span>

                                <div class="example-category">⭐⭐⭐ Already in Scientific</div>
                                <span class="example-reaction" onclick="setNotationExample('1.23e5')">1.23×10⁵</span>
                                <span class="example-reaction" onclick="setNotationExample('4.5e-3')">4.5×10⁻³</span>
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
                            Enter a number and click Calculate
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
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Significant Figures Rules</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><strong>Counting Significant Figures</strong></h6>
                            <ol>
                                <li><strong>All non-zero digits are significant</strong>
                                    <br><small class="text-muted">Example: 123 has 3 sig figs</small>
                                </li>
                                <li><strong>Trapped zeros are significant</strong>
                                    <br><small class="text-muted">Example: 1002 has 4 sig figs</small>
                                </li>
                                <li><strong>Leading zeros are NOT significant</strong>
                                    <br><small class="text-muted">Example: 0.0045 has 2 sig figs</small>
                                </li>
                                <li><strong>Trailing zeros after decimal ARE significant</strong>
                                    <br><small class="text-muted">Example: 1.200 has 4 sig figs</small>
                                </li>
                                <li><strong>Trailing zeros without decimal are ambiguous</strong>
                                    <br><small class="text-muted">Example: 1200 has 2-4 sig figs (use scientific notation)</small>
                                </li>
                            </ol>
                        </div>
                        <div class="col-md-6">
                            <h6><strong>Calculation Rules</strong></h6>
                            <div class="rule-box">
                                <p class="mb-2"><strong>Addition & Subtraction:</strong></p>
                                <p class="mb-0">Round to the <strong>fewest decimal places</strong></p>
                                <small class="text-muted">12.34 + 5.6 = 17.9 (not 17.94)</small>
                            </div>

                            <div class="rule-box">
                                <p class="mb-2"><strong>Multiplication & Division:</strong></p>
                                <p class="mb-0">Round to the <strong>fewest sig figs</strong></p>
                                <small class="text-muted">12.34 × 5.6 = 69 (2 sig figs from 5.6)</small>
                            </div>

                            <h6 class="mt-3"><strong>Scientific Notation</strong></h6>
                            <p>Format: <strong>a × 10<sup>n</sup></strong></p>
                            <p class="mb-0">Where 1 ≤ |a| < 10</p>
                            <small class="text-muted">Example: 1200 = 1.2 × 10³ (2 sig figs)<br>
                            Example: 0.00456 = 4.56 × 10⁻³ (3 sig figs)</small>
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
// Count Significant Figures
function countSigFigs() {
    const input = document.getElementById('countNumber').value.trim();

    if (!input) {
        alert('Please enter a number');
        return;
    }

    const result = analyzeSigFigs(input);
    displaySigFigCount(result, input);
}

function analyzeSigFigs(numStr) {
    // Remove spaces
    numStr = numStr.trim();

    // Handle scientific notation (e.g., 1.23e5 or 1.23E5)
    const sciMatch = numStr.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);
    if (sciMatch) {
        const mantissa = sciMatch[1];
        const exponent = sciMatch[2];
        return analyzeSigFigs(mantissa);
    }

    // Remove positive sign if present
    numStr = numStr.replace(/^\+/, '');

    // Check if negative
    const isNegative = numStr.startsWith('-');
    if (isNegative) {
        numStr = numStr.substring(1);
    }

    // Split by decimal point
    const parts = numStr.split('.');
    const hasDecimal = parts.length === 2;
    const integerPart = parts[0];
    const decimalPart = parts[1] || '';

    let sigFigs = 0;
    let explanation = [];
    let highlightedDigits = [];

    if (hasDecimal) {
        // Has decimal point
        if (integerPart === '0' || integerPart === '') {
            // Number like 0.00450
            // Leading zeros are not significant
            let foundNonZero = false;
            for (let i = 0; i < decimalPart.length; i++) {
                const digit = decimalPart[i];
                if (!foundNonZero && digit !== '0') {
                    foundNonZero = true;
                }
                if (foundNonZero) {
                    sigFigs++;
                    highlightedDigits.push(true);
                } else {
                    highlightedDigits.push(false);
                }
            }
            explanation.push(`Leading zeros after decimal are NOT significant`);
            explanation.push(`All digits after the first non-zero digit ARE significant (including trailing zeros)`);
        } else {
            // Number like 123.450
            // All digits in integer part are significant
            for (let char of integerPart) {
                if (char !== '0' || sigFigs > 0) {
                    sigFigs++;
                }
            }
            // All digits in decimal part are significant
            sigFigs += decimalPart.length;
            explanation.push(`All non-zero digits are significant`);
            explanation.push(`Trailing zeros after decimal point ARE significant`);
        }
    } else {
        // No decimal point (e.g., 1200)
        let foundNonZero = false;
        let trailingZeros = 0;

        // Count from left
        for (let i = 0; i < integerPart.length; i++) {
            const digit = integerPart[i];
            if (digit !== '0') {
                foundNonZero = true;
                sigFigs++;
                trailingZeros = 0;
            } else if (foundNonZero) {
                // This is either trapped zero or trailing zero
                if (i < integerPart.length - 1 && integerPart.substring(i + 1).match(/[1-9]/)) {
                    // Trapped zero
                    sigFigs++;
                } else {
                    // Trailing zero (ambiguous)
                    trailingZeros++;
                }
            }
        }

        if (trailingZeros > 0) {
            explanation.push(`Trailing zeros without decimal point are AMBIGUOUS`);
            explanation.push(`Assuming ${sigFigs} sig figs (not counting trailing zeros)`);
            explanation.push(`Use scientific notation to clarify: e.g., 1.20 × 10³ for 3 sig figs`);
        } else {
            explanation.push(`All non-zero digits are significant`);
            explanation.push(`Trapped zeros (between non-zero digits) are significant`);
        }
    }

    return {
        sigFigs: sigFigs,
        explanation: explanation,
        original: (isNegative ? '-' : '') + numStr
    };
}

function displaySigFigCount(result, original) {
    let html = `
        <div class="result-section">
            <h6><span class="result-badge">SIGNIFICANT FIGURES</span></h6>
            <div class="number-display">${original}</div>
            <h4 class="mb-3">${result.sigFigs} significant figure${result.sigFigs !== 1 ? 's' : ''}</h4>

            <hr>

            <h6><span class="step-badge">EXPLANATION</span></h6>
            <div class="step-section">
    `;

    result.explanation.forEach(exp => {
        html += `<p class="mb-2">• ${exp}</p>`;
    });

    html += `
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Arithmetic with Sig Figs
function calculateArithmetic() {
    const op = document.getElementById('arithmeticOp').value;
    const num1Str = document.getElementById('arithmeticNum1').value.trim();
    const num2Str = document.getElementById('arithmeticNum2').value.trim();

    if (!num1Str || !num2Str) {
        alert('Please enter both numbers');
        return;
    }

    const num1 = parseFloat(num1Str);
    const num2 = parseFloat(num2Str);

    if (isNaN(num1) || isNaN(num2)) {
        alert('Please enter valid numbers');
        return;
    }

    const sig1 = analyzeSigFigs(num1Str);
    const sig2 = analyzeSigFigs(num2Str);

    let rawResult, finalResult, rule, steps;

    if (op === 'add' || op === 'subtract') {
        // Addition/Subtraction: round to fewest decimal places
        rawResult = op === 'add' ? num1 + num2 : num1 - num2;

        const dec1 = getDecimalPlaces(num1Str);
        const dec2 = getDecimalPlaces(num2Str);
        const minDecimals = Math.min(dec1, dec2);

        finalResult = rawResult.toFixed(minDecimals);
        rule = `Round to ${minDecimals} decimal place${minDecimals !== 1 ? 's' : ''} (fewest among inputs)`;

        steps = `
            <p class="mb-2"><strong>Input Numbers:</strong></p>
            <p class="mb-1 ml-3">${num1Str} (${dec1} decimal places)</p>
            <p class="mb-3 ml-3">${num2Str} (${dec2} decimal places)</p>

            <p class="mb-2"><strong>Raw Result:</strong></p>
            <p class="mb-3 ml-3">${rawResult}</p>

            <p class="mb-2"><strong>Rule for Addition/Subtraction:</strong></p>
            <p class="mb-3 ml-3">Round to the fewest decimal places</p>

            <p class="mb-2"><strong>Final Result:</strong></p>
            <p class="mb-0 ml-3">${finalResult} (${minDecimals} decimal places)</p>
        `;
    } else {
        // Multiplication/Division: round to fewest sig figs
        rawResult = op === 'multiply' ? num1 * num2 : num1 / num2;

        const minSigFigs = Math.min(sig1.sigFigs, sig2.sigFigs);

        finalResult = roundToNSigFigs(rawResult, minSigFigs);
        rule = `Round to ${minSigFigs} sig fig${minSigFigs !== 1 ? 's' : ''} (fewest among inputs)`;

        steps = `
            <p class="mb-2"><strong>Input Numbers:</strong></p>
            <p class="mb-1 ml-3">${num1Str} (${sig1.sigFigs} sig figs)</p>
            <p class="mb-3 ml-3">${num2Str} (${sig2.sigFigs} sig figs)</p>

            <p class="mb-2"><strong>Raw Result:</strong></p>
            <p class="mb-3 ml-3">${rawResult}</p>

            <p class="mb-2"><strong>Rule for Multiplication/Division:</strong></p>
            <p class="mb-3 ml-3">Round to the fewest significant figures</p>

            <p class="mb-2"><strong>Final Result:</strong></p>
            <p class="mb-0 ml-3">${finalResult} (${minSigFigs} sig figs)</p>
        `;
    }

    const opSymbol = { add: '+', subtract: '−', multiply: '×', divide: '÷' }[op];

    let html = `
        <div class="result-section">
            <h6><span class="result-badge">RESULT</span></h6>
            <div class="number-display">${num1Str} ${opSymbol} ${num2Str} = ${finalResult}</div>

            <hr>

            <h6><span class="step-badge">CALCULATION STEPS</span></h6>
            <div class="step-section">
                ${steps}
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Rule Applied:</strong> ${rule}</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

function getDecimalPlaces(numStr) {
    const parts = numStr.split('.');
    return parts.length === 2 ? parts[1].length : 0;
}

function roundToNSigFigs(num, n) {
    if (num === 0) return '0';

    const d = Math.ceil(Math.log10(Math.abs(num)));
    const power = n - d;

    const magnitude = Math.pow(10, power);
    const shifted = Math.round(num * magnitude);
    const result = shifted / magnitude;

    // Format the result
    if (Math.abs(result) >= 1000 || Math.abs(result) < 0.001) {
        // Use scientific notation
        return result.toExponential(n - 1);
    } else {
        // Use fixed notation
        let str = result.toPrecision(n);
        // Remove unnecessary trailing zeros
        if (str.indexOf('.') !== -1) {
            str = str.replace(/\.?0+$/, '');
        }
        return str;
    }
}

// Round to Sig Figs
function roundToSigFigs() {
    const numStr = document.getElementById('roundNumber').value.trim();
    const targetSigFigs = parseInt(document.getElementById('roundSigFigs').value);

    if (!numStr || isNaN(targetSigFigs) || targetSigFigs < 1) {
        alert('Please enter a valid number and number of sig figs');
        return;
    }

    const num = parseFloat(numStr);
    const original = analyzeSigFigs(numStr);

    const rounded = roundToNSigFigs(num, targetSigFigs);

    let html = `
        <div class="result-section">
            <h6><span class="result-badge">ROUNDED RESULT</span></h6>
            <div class="number-display">${rounded}</div>
            <p class="mb-2">${targetSigFigs} significant figure${targetSigFigs !== 1 ? 's' : ''}</p>

            <hr>

            <h6><span class="step-badge">ORIGINAL NUMBER</span></h6>
            <div class="step-section">
                <p class="mb-2">Number: ${numStr}</p>
                <p class="mb-0">Original sig figs: ${original.sigFigs}</p>
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Rounding:</strong> ${original.sigFigs > targetSigFigs ? 'Decreased' : 'Increased'} precision from ${original.sigFigs} to ${targetSigFigs} sig figs</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Scientific Notation
function convertNotation() {
    const numStr = document.getElementById('notationNumber').value.trim();
    const targetSigFigs = document.getElementById('notationSigFigs').value;

    if (!numStr) {
        alert('Please enter a number');
        return;
    }

    // Check if already in scientific notation
    const sciMatch = numStr.match(/^([+-]?[\d.]+)[eE]([+-]?\d+)$/);

    let num = parseFloat(numStr);
    const original = analyzeSigFigs(numStr);

    let mantissa, exponent, scientific, standard;

    if (sciMatch) {
        // Already in scientific notation, convert to standard
        exponent = parseInt(sciMatch[2]);
        mantissa = parseFloat(sciMatch[1]);
        scientific = numStr;
        standard = num.toString();
    } else {
        // Convert to scientific notation
        if (num === 0) {
            scientific = '0';
            standard = '0';
            exponent = 0;
            mantissa = 0;
        } else {
            exponent = Math.floor(Math.log10(Math.abs(num)));
            mantissa = num / Math.pow(10, exponent);

            // Use target sig figs if specified, otherwise use original
            const sigFigs = targetSigFigs ? parseInt(targetSigFigs) : original.sigFigs;
            const mantissaStr = mantissa.toPrecision(sigFigs);

            scientific = `${mantissaStr} × 10^${exponent}`;
            standard = num.toString();
        }
    }

    let html = `
        <div class="result-section">
            <h6><span class="sig-badge">SCIENTIFIC NOTATION</span></h6>
            <div class="number-display">${scientific}</div>

            <hr>

            <h6><span class="step-badge">CONVERSIONS</span></h6>
            <div class="step-section">
                <p class="mb-2"><strong>Standard Form:</strong></p>
                <p class="mb-3 ml-3">${standard}</p>

                <p class="mb-2"><strong>Scientific Notation:</strong></p>
                <p class="mb-3 ml-3">${scientific}</p>

                <p class="mb-2"><strong>Components:</strong></p>
                <p class="mb-1 ml-3">Mantissa: ${mantissa}</p>
                <p class="mb-0 ml-3">Exponent: ${exponent}</p>
            </div>

            <hr>

            <div class="info-box">
                <p class="mb-0"><strong>Significant Figures:</strong> ${original.sigFigs}</p>
            </div>
        </div>
    `;

    document.getElementById('resultDisplay').innerHTML = html;
}

// Example setters
function setCountExample(num) {
    document.getElementById('countNumber').value = num;
}

function setArithmeticExample(op, num1, num2) {
    document.getElementById('arithmeticOp').value = op;
    document.getElementById('arithmeticNum1').value = num1;
    document.getElementById('arithmeticNum2').value = num2;
}

function setRoundExample(num, sigFigs) {
    document.getElementById('roundNumber').value = num;
    document.getElementById('roundSigFigs').value = sigFigs;
}

function setNotationExample(num) {
    document.getElementById('notationNumber').value = num;
    document.getElementById('notationSigFigs').value = '';
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
