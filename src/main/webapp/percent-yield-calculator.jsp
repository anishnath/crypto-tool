<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Percent Yield Calculator | Calculate Theoretical & Actual Yield | 8gwifi.org</title>
    <meta name="description" content="Free percent yield calculator for chemistry. Calculate percent yield from actual and theoretical yield, or find theoretical/actual yield. Includes step-by-step solutions and common lab examples.">
    <meta name="keywords" content="percent yield calculator, theoretical yield calculator, actual yield, chemistry calculator, stoichiometry, lab yield, reaction yield, percent yield formula">

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/percent-yield-calculator.jsp">
    <meta property="og:title" content="Percent Yield Calculator">
    <meta property="og:description" content="Calculate percent yield, theoretical yield, or actual yield for chemistry reactions.">

    <link rel="canonical" href="https://8gwifi.org/percent-yield-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- JSON-LD Schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Percent Yield Calculator",
      "description": "Calculate percent yield, theoretical yield, or actual yield for chemistry reactions. Percent Yield = (Actual Yield / Theoretical Yield) × 100%",
      "url": "https://8gwifi.org/percent-yield-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What is percent yield?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Percent yield is the ratio of actual yield to theoretical yield, expressed as a percentage. Formula: Percent Yield = (Actual Yield / Theoretical Yield) × 100%. It measures the efficiency of a chemical reaction. 100% means perfect conversion, while less indicates side reactions or losses."
        }
      },{
        "@type": "Question",
        "name": "Why is percent yield less than 100%?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Percent yield is usually less than 100% due to: incomplete reactions, side reactions producing unwanted products, product losses during transfer/purification, measurement errors, reversible reactions not reaching completion, or impure starting materials."
        }
      }]
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-percentage"></i> Percent Yield Calculator</h1>
    <p class="text-center text-muted mb-4">Calculate percent yield, theoretical yield, or actual yield</p>

    <div class="row">
        <div class="col-lg-8">
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#calcPercent">Calculate % Yield</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#calcActual">Calculate Actual Yield</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#calcTheoretical">Calculate Theoretical Yield</a>
                </li>
            </ul>

            <div class="tab-content border border-top-0 p-4">
                <!-- Calculate Percent Yield -->
                <div id="calcPercent" class="tab-pane fade show active">
                    <h5>Calculate Percent Yield</h5>
                    <form onsubmit="calculatePercentYield(); return false;">
                        <div class="form-group">
                            <label>Actual Yield (what you got in lab)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="actualYield" step="any" required>
                                <select class="form-control" id="actualUnit" style="max-width: 100px;">
                                    <option value="g">grams</option>
                                    <option value="kg">kg</option>
                                    <option value="mg">mg</option>
                                    <option value="mol">mol</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Theoretical Yield (maximum possible)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="theoreticalYield" step="any" required>
                                <select class="form-control" id="theoreticalUnit" style="max-width: 100px;">
                                    <option value="g">grams</option>
                                    <option value="kg">kg</option>
                                    <option value="mg">mg</option>
                                    <option value="mol">mol</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-calculator"></i> Calculate Percent Yield
                        </button>
                    </form>
                    <div id="percentResult" class="mt-4"></div>
                </div>

                <!-- Calculate Actual Yield -->
                <div id="calcActual" class="tab-pane fade">
                    <h5>Calculate Actual Yield</h5>
                    <form onsubmit="calculateActualYield(); return false;">
                        <div class="form-group">
                            <label>Percent Yield (%)</label>
                            <input type="number" class="form-control" id="percentYieldInput" step="any" min="0" max="100" required>
                        </div>
                        <div class="form-group">
                            <label>Theoretical Yield</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="theoreticalYieldActual" step="any" required>
                                <select class="form-control" id="theoreticalUnitActual" style="max-width: 100px;">
                                    <option value="g">grams</option>
                                    <option value="kg">kg</option>
                                    <option value="mg">mg</option>
                                    <option value="mol">mol</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-success btn-block">
                            <i class="fas fa-calculator"></i> Calculate Actual Yield
                        </button>
                    </form>
                    <div id="actualResult" class="mt-4"></div>
                </div>

                <!-- Calculate Theoretical Yield -->
                <div id="calcTheoretical" class="tab-pane fade">
                    <h5>Calculate Theoretical Yield</h5>
                    <form onsubmit="calculateTheoreticalYield(); return false;">
                        <div class="form-group">
                            <label>Actual Yield</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="actualYieldTheoretical" step="any" required>
                                <select class="form-control" id="actualUnitTheoretical" style="max-width: 100px;">
                                    <option value="g">grams</option>
                                    <option value="kg">kg</option>
                                    <option value="mg">mg</option>
                                    <option value="mol">mol</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Percent Yield (%)</label>
                            <input type="number" class="form-control" id="percentYieldTheoretical" step="any" min="0" max="100" required>
                        </div>
                        <button type="submit" class="btn btn-info btn-block">
                            <i class="fas fa-calculator"></i> Calculate Theoretical Yield
                        </button>
                    </form>
                    <div id="theoreticalResult" class="mt-4"></div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-book"></i> Formulas</h5>
                </div>
                <div class="card-body">
                    <h6>Percent Yield Formula</h6>
                    <div class="alert alert-primary">
                        <strong>% Yield = (Actual / Theoretical) × 100%</strong>
                    </div>

                    <h6>Rearranged Formulas</h6>
                    <ul class="small">
                        <li><strong>Actual Yield:</strong><br>Actual = (% Yield / 100) × Theoretical</li>
                        <li><strong>Theoretical Yield:</strong><br>Theoretical = (Actual / % Yield) × 100</li>
                    </ul>

                    <h6>Typical Percent Yields</h6>
                    <ul class="small">
                        <li><strong>90-100%:</strong> Excellent (simple reactions)</li>
                        <li><strong>70-90%:</strong> Good (most lab reactions)</li>
                        <li><strong>50-70%:</strong> Fair (complex reactions)</li>
                        <li><strong>&lt;50%:</strong> Poor (may need optimization)</li>
                    </ul>

                    <h6>Why Less Than 100%?</h6>
                    <ul class="small">
                        <li>Incomplete reactions</li>
                        <li>Side reactions</li>
                        <li>Product losses during transfer</li>
                        <li>Impure reactants</li>
                        <li>Measurement errors</li>
                    </ul>

                    <h6>Quick Examples</h6>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample(1)">Example 1: 85% Yield</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample(2)">Example 2: Find Actual</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample(3)">Example 3: Find Theoretical</button>
                </div>
            </div>

            <%@ include file="related-encoders.jsp"%>
        </div>
    </div>

    <%@ include file="thanks.jsp"%>
    <hr>
    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
const unitConversions = {
    'g': 1,
    'kg': 1000,
    'mg': 0.001,
    'mol': 1 // mol is kept as is for display purposes
};

function calculatePercentYield() {
    const actual = parseFloat(document.getElementById('actualYield').value);
    const actualUnit = document.getElementById('actualUnit').value;
    const theoretical = parseFloat(document.getElementById('theoreticalYield').value);
    const theoreticalUnit = document.getElementById('theoreticalUnit').value;

    // Check if units match
    if (actualUnit !== theoreticalUnit) {
        // Convert both to grams if not mol
        if (actualUnit !== 'mol' && theoreticalUnit !== 'mol') {
            const actualInG = actual * unitConversions[actualUnit];
            const theoreticalInG = theoretical * unitConversions[theoreticalUnit];
            const percentYield = (actualInG / theoreticalInG) * 100;

            displayResult('percentResult', {
                formula: '% Yield = (Actual Yield / Theoretical Yield) × 100%',
                given: `Actual = ${actual} ${actualUnit}, Theoretical = ${theoretical} ${theoreticalUnit}`,
                converted: `Actual = ${actualInG.toFixed(4)} g, Theoretical = ${theoreticalInG.toFixed(4)} g`,
                calculation: `% Yield = (${actualInG.toFixed(4)} / ${theoreticalInG.toFixed(4)}) × 100% = ${percentYield.toFixed(2)}%`,
                result: `<strong class="text-primary" style="font-size: 1.5rem;">${percentYield.toFixed(2)}%</strong>`,
                interpretation: getYieldInterpretation(percentYield)
            });
        } else {
            alert('Units must match! Convert to same units before calculating.');
            return;
        }
    } else {
        // Units match, direct calculation
        const percentYield = (actual / theoretical) * 100;

        displayResult('percentResult', {
            formula: '% Yield = (Actual Yield / Theoretical Yield) × 100%',
            given: `Actual = ${actual} ${actualUnit}, Theoretical = ${theoretical} ${theoreticalUnit}`,
            converted: 'Units match - no conversion needed',
            calculation: `% Yield = (${actual} / ${theoretical}) × 100% = ${percentYield.toFixed(2)}%`,
            result: `<strong class="text-primary" style="font-size: 1.5rem;">${percentYield.toFixed(2)}%</strong>`,
            interpretation: getYieldInterpretation(percentYield)
        });
    }
}

function calculateActualYield() {
    const percentYield = parseFloat(document.getElementById('percentYieldInput').value);
    const theoretical = parseFloat(document.getElementById('theoreticalYieldActual').value);
    const unit = document.getElementById('theoreticalUnitActual').value;

    const actual = (percentYield / 100) * theoretical;

    displayResult('actualResult', {
        formula: 'Actual Yield = (% Yield / 100) × Theoretical Yield',
        given: `% Yield = ${percentYield}%, Theoretical = ${theoretical} ${unit}`,
        converted: 'No conversion needed',
        calculation: `Actual = (${percentYield} / 100) × ${theoretical} = ${actual.toFixed(4)} ${unit}`,
        result: `<strong class="text-success" style="font-size: 1.5rem;">${actual.toFixed(4)} ${unit}</strong>`,
        interpretation: `This is the amount you would actually obtain in the lab with ${percentYield}% yield.`
    });
}

function calculateTheoreticalYield() {
    const actual = parseFloat(document.getElementById('actualYieldTheoretical').value);
    const unit = document.getElementById('actualUnitTheoretical').value;
    const percentYield = parseFloat(document.getElementById('percentYieldTheoretical').value);

    const theoretical = (actual / percentYield) * 100;

    displayResult('theoreticalResult', {
        formula: 'Theoretical Yield = (Actual Yield / % Yield) × 100',
        given: `Actual = ${actual} ${unit}, % Yield = ${percentYield}%`,
        converted: 'No conversion needed',
        calculation: `Theoretical = (${actual} / ${percentYield}) × 100 = ${theoretical.toFixed(4)} ${unit}`,
        result: `<strong class="text-info" style="font-size: 1.5rem;">${theoretical.toFixed(4)} ${unit}</strong>`,
        interpretation: `This is the maximum amount you could have obtained with 100% efficiency. You got ${percentYield}% of this amount.`
    });
}

function displayResult(elementId, data) {
    document.getElementById(elementId).innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p><strong>Formula:</strong> ${data.formula}</p>
            <p><strong>Given:</strong> ${data.given}</p>
            ${data.converted !== 'No conversion needed' ? `<p><strong>Converted:</strong> ${data.converted}</p>` : ''}
            <p><strong>Calculation:</strong> ${data.calculation}</p>
            <hr>
            <div class="text-center">${data.result}</div>
        </div>
        <div class="alert alert-info">
            <strong><i class="fas fa-lightbulb"></i> Interpretation:</strong> ${data.interpretation}
        </div>
    `;
}

function getYieldInterpretation(percentYield) {
    if (percentYield > 100) {
        return `<span class="text-danger">⚠️ Percent yield cannot exceed 100%! This indicates an error in measurement or calculation. Check your values.</span>`;
    } else if (percentYield >= 90) {
        return `<span class="text-success">✓ Excellent yield!</span> This is a very efficient reaction with minimal losses. Typical for simple, well-optimized reactions.`;
    } else if (percentYield >= 70) {
        return `<span class="text-success">✓ Good yield.</span> This is acceptable for most laboratory reactions. Some losses occurred but overall efficiency is good.`;
    } else if (percentYield >= 50) {
        return `<span class="text-warning">⚠ Fair yield.</span> Significant losses occurred. This might be expected for complex reactions with multiple steps or side reactions.`;
    } else if (percentYield >= 25) {
        return `<span class="text-danger">⚠ Poor yield.</span> Major losses occurred. Consider optimizing reaction conditions, purification methods, or checking for side reactions.`;
    } else {
        return `<span class="text-danger">⚠ Very poor yield.</span> This reaction may need significant optimization. Check reactant purity, reaction conditions, and procedure.`;
    }
}

function loadExample(num) {
    if (num === 1) {
        // 85% yield example
        document.getElementById('actualYield').value = 8.5;
        document.getElementById('actualUnit').value = 'g';
        document.getElementById('theoreticalYield').value = 10;
        document.getElementById('theoreticalUnit').value = 'g';
        $('.nav-tabs a[href="#calcPercent"]').tab('show');
    } else if (num === 2) {
        // Find actual yield
        document.getElementById('percentYieldInput').value = 75;
        document.getElementById('theoreticalYieldActual').value = 12.5;
        document.getElementById('theoreticalUnitActual').value = 'g';
        $('.nav-tabs a[href="#calcActual"]').tab('show');
    } else if (num === 3) {
        // Find theoretical yield
        document.getElementById('actualYieldTheoretical').value = 6.8;
        document.getElementById('actualUnitTheoretical').value = 'g';
        document.getElementById('percentYieldTheoretical').value = 82;
        $('.nav-tabs a[href="#calcTheoretical"]').tab('show');
    }
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>

