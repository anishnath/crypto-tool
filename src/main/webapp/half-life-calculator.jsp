<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Half-Life Calculator | Radioactive Decay | Carbon Dating | 8gwifi.org</title>
    <meta name="description" content="Calculate radioactive decay, half-life, and remaining amount. Includes carbon-14 dating, decay constant, activity calculations, and common isotopes database. Free nuclear chemistry calculator.">
    <meta name="keywords" content="half life calculator, radioactive decay, carbon dating, decay constant, nuclear chemistry, half life formula, isotope decay, activity calculator">

    <link rel="canonical" href="https://8gwifi.org/half-life-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Half-Life Calculator",
      "description": "Calculate radioactive decay using half-life formula N(t) = N₀(1/2)^(t/t½). Includes carbon dating and common isotopes.",
      "url": "https://8gwifi.org/half-life-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-radiation"></i> Half-Life Calculator</h1>
    <p class="text-center text-muted mb-4">Calculate radioactive decay, half-life, and carbon dating</p>

    <div class="row">
        <div class="col-lg-8">
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#calcRemaining">Remaining Amount</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#calcTime">Time Elapsed</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#calcHalfLife">Half-Life</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#isotopes">Common Isotopes</a>
                </li>
            </ul>

            <div class="tab-content border border-top-0 p-4">
                <!-- Calculate Remaining Amount -->
                <div id="calcRemaining" class="tab-pane fade show active">
                    <h5>Calculate Remaining Amount</h5>
                    <form onsubmit="calculateRemaining(); return false;">
                        <div class="form-group">
                            <label>Initial Amount (N₀)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="initialAmount" step="any" required>
                                <select class="form-control" id="amountUnit" style="max-width: 100px;">
                                    <option value="g">grams</option>
                                    <option value="mg">mg</option>
                                    <option value="kg">kg</option>
                                    <option value="mol">moles</option>
                                    <option value="atoms">atoms</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Half-Life (t½)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="halfLife" step="any" required>
                                <select class="form-control" id="halfLifeUnit" style="max-width: 120px;">
                                    <option value="seconds">seconds</option>
                                    <option value="minutes">minutes</option>
                                    <option value="hours">hours</option>
                                    <option value="days">days</option>
                                    <option value="years" selected>years</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Time Elapsed (t)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="timeElapsed" step="any" required>
                                <select class="form-control" id="timeUnit" style="max-width: 120px;">
                                    <option value="seconds">seconds</option>
                                    <option value="minutes">minutes</option>
                                    <option value="hours">hours</option>
                                    <option value="days">days</option>
                                    <option value="years" selected>years</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-calculator"></i> Calculate Remaining Amount
                        </button>
                    </form>
                    <div id="remainingResult" class="mt-4"></div>
                </div>

                <!-- Calculate Time -->
                <div id="calcTime" class="tab-pane fade">
                    <h5>Calculate Time Elapsed</h5>
                    <form onsubmit="calculateTime(); return false;">
                        <div class="form-group">
                            <label>Initial Amount (N₀)</label>
                            <input type="number" class="form-control" id="initialAmountTime" step="any" required>
                        </div>
                        <div class="form-group">
                            <label>Remaining Amount (N)</label>
                            <input type="number" class="form-control" id="remainingAmountTime" step="any" required>
                        </div>
                        <div class="form-group">
                            <label>Half-Life (t½)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="halfLifeTime" step="any" required>
                                <select class="form-control" id="halfLifeUnitTime" style="max-width: 120px;">
                                    <option value="seconds">seconds</option>
                                    <option value="minutes">minutes</option>
                                    <option value="hours">hours</option>
                                    <option value="days">days</option>
                                    <option value="years" selected>years</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-success btn-block">
                            <i class="fas fa-calculator"></i> Calculate Time Elapsed
                        </button>
                    </form>
                    <div id="timeResult" class="mt-4"></div>
                </div>

                <!-- Calculate Half-Life -->
                <div id="calcHalfLife" class="tab-pane fade">
                    <h5>Calculate Half-Life</h5>
                    <form onsubmit="calculateHalfLife(); return false;">
                        <div class="form-group">
                            <label>Initial Amount (N₀)</label>
                            <input type="number" class="form-control" id="initialAmountHL" step="any" required>
                        </div>
                        <div class="form-group">
                            <label>Remaining Amount (N)</label>
                            <input type="number" class="form-control" id="remainingAmountHL" step="any" required>
                        </div>
                        <div class="form-group">
                            <label>Time Elapsed (t)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="timeElapsedHL" step="any" required>
                                <select class="form-control" id="timeUnitHL" style="max-width: 120px;">
                                    <option value="seconds">seconds</option>
                                    <option value="minutes">minutes</option>
                                    <option value="hours">hours</option>
                                    <option value="days">days</option>
                                    <option value="years" selected>years</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-info btn-block">
                            <i class="fas fa-calculator"></i> Calculate Half-Life
                        </button>
                    </form>
                    <div id="halfLifeResult" class="mt-4"></div>
                </div>

                <!-- Common Isotopes -->
                <div id="isotopes" class="tab-pane fade">
                    <h5>Common Radioactive Isotopes</h5>
                    <div class="form-group">
                        <input type="text" class="form-control" id="searchIsotope" placeholder="Search isotopes...">
                    </div>
                    <div class="table-responsive">
                        <table class="table table-sm table-hover" id="isotopeTable">
                            <thead class="thead-light">
                                <tr>
                                    <th>Isotope</th>
                                    <th>Half-Life</th>
                                    <th>Decay Type</th>
                                    <th>Common Use</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="isotopeTableBody"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header bg-warning text-dark">
                    <h5 class="mb-0"><i class="fas fa-book"></i> Formulas</h5>
                </div>
                <div class="card-body">
                    <h6>Decay Formula</h6>
                    <div class="alert alert-warning">
                        <strong>N(t) = N₀ × (½)^(t/t½)</strong><br>
                        <small>or N(t) = N₀ × e^(-λt)</small>
                    </div>

                    <h6>Where:</h6>
                    <ul class="small">
                        <li><strong>N(t)</strong> = Amount remaining</li>
                        <li><strong>N₀</strong> = Initial amount</li>
                        <li><strong>t</strong> = Time elapsed</li>
                        <li><strong>t½</strong> = Half-life</li>
                        <li><strong>λ</strong> = Decay constant = ln(2)/t½</li>
                    </ul>

                    <h6>Key Facts</h6>
                    <ul class="small">
                        <li>After 1 half-life: 50% remains</li>
                        <li>After 2 half-lives: 25% remains</li>
                        <li>After 3 half-lives: 12.5% remains</li>
                        <li>After 10 half-lives: ~0.1% remains</li>
                    </ul>

                    <h6>Quick Examples</h6>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('carbon')">Carbon-14 Dating</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('uranium')">Uranium-238 Decay</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('iodine')">Medical: Iodine-131</button>
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
// Time conversions to seconds
const timeConversions = {
    'seconds': 1,
    'minutes': 60,
    'hours': 3600,
    'days': 86400,
    'years': 31557600 // 365.25 days
};

// Common isotopes database
const isotopes = [
    { name: 'Carbon-14', symbol: '¹⁴C', halfLife: 5730, unit: 'years', decay: 'β⁻', use: 'Archaeological dating, carbon dating' },
    { name: 'Uranium-238', symbol: '²³⁸U', halfLife: 4.468e9, unit: 'years', decay: 'α', use: 'Geological dating, nuclear fuel' },
    { name: 'Uranium-235', symbol: '²³⁵U', halfLife: 7.04e8, unit: 'years', decay: 'α', use: 'Nuclear reactors, weapons' },
    { name: 'Plutonium-239', symbol: '²³⁹Pu', halfLife: 24110, unit: 'years', decay: 'α', use: 'Nuclear weapons, reactors' },
    { name: 'Radium-226', symbol: '²²⁶Ra', halfLife: 1600, unit: 'years', decay: 'α', use: 'Historical medical use' },
    { name: 'Iodine-131', symbol: '¹³¹I', halfLife: 8.02, unit: 'days', decay: 'β⁻', use: 'Medical thyroid treatment' },
    { name: 'Cobalt-60', symbol: '⁶⁰Co', halfLife: 5.27, unit: 'years', decay: 'β⁻', use: 'Cancer radiation therapy' },
    { name: 'Cesium-137', symbol: '¹³⁷Cs', halfLife: 30.17, unit: 'years', decay: 'β⁻', use: 'Medical radiation source' },
    { name: 'Strontium-90', symbol: '⁹⁰Sr', halfLife: 28.79, unit: 'years', decay: 'β⁻', use: 'Medical, industrial uses' },
    { name: 'Tritium', symbol: '³H', halfLife: 12.32, unit: 'years', decay: 'β⁻', use: 'Nuclear fusion, glow-in-dark' },
    { name: 'Radon-222', symbol: '²²²Rn', halfLife: 3.82, unit: 'days', decay: 'α', use: 'Indoor air quality concern' },
    { name: 'Polonium-210', symbol: '²¹⁰Po', halfLife: 138.4, unit: 'days', decay: 'α', use: 'Industrial static eliminators' },
    { name: 'Technetium-99m', symbol: '⁹⁹ᵐTc', halfLife: 6.01, unit: 'hours', decay: 'γ', use: 'Medical imaging scans' },
    { name: 'Potassium-40', symbol: '⁴⁰K', halfLife: 1.248e9, unit: 'years', decay: 'β⁻/EC', use: 'Geological dating' }
];

function calculateRemaining() {
    const N0 = parseFloat(document.getElementById('initialAmount').value);
    const unit = document.getElementById('amountUnit').value;
    const halfLife = parseFloat(document.getElementById('halfLife').value);
    const halfLifeUnit = document.getElementById('halfLifeUnit').value;
    const time = parseFloat(document.getElementById('timeElapsed').value);
    const timeUnit = document.getElementById('timeUnit').value;

    // Convert to same units
    const halfLifeSec = halfLife * timeConversions[halfLifeUnit];
    const timeSec = time * timeConversions[timeUnit];

    // Calculate remaining amount: N(t) = N0 * (1/2)^(t/t_half)
    const exponent = timeSec / halfLifeSec;
    const remaining = N0 * Math.pow(0.5, exponent);

    // Calculate decay constant
    const lambda = Math.LN2 / halfLifeSec;

    // Calculate percent remaining and decayed
    const percentRemaining = (remaining / N0) * 100;
    const percentDecayed = 100 - percentRemaining;
    const numberHalfLives = timeSec / halfLifeSec;

    displayResult('remainingResult', {
        formula: 'N(t) = N₀ × (½)^(t/t½)',
        given: `Initial: ${N0} ${unit}, Half-life: ${halfLife} ${halfLifeUnit}, Time: ${time} ${timeUnit}`,
        calculation: `N(t) = ${N0} × (0.5)^(${time}/${halfLife}) = ${N0} × (0.5)^${exponent.toFixed(4)}`,
        result: `<strong class="text-primary" style="font-size: 1.5rem;">${remaining.toFixed(6)} ${unit}</strong>`,
        details: `
            <strong>Additional Information:</strong><br>
            • Number of half-lives: ${numberHalfLives.toFixed(2)}<br>
            • Percent remaining: ${percentRemaining.toFixed(2)}%<br>
            • Percent decayed: ${percentDecayed.toFixed(2)}%<br>
            • Decay constant (λ): ${lambda.toExponential(4)} s⁻¹<br>
            • Amount decayed: ${(N0 - remaining).toFixed(6)} ${unit}
        `
    });
}

function calculateTime() {
    const N0 = parseFloat(document.getElementById('initialAmountTime').value);
    const N = parseFloat(document.getElementById('remainingAmountTime').value);
    const halfLife = parseFloat(document.getElementById('halfLifeTime').value);
    const halfLifeUnit = document.getElementById('halfLifeUnitTime').value;

    if (N > N0) {
        alert('Remaining amount cannot be greater than initial amount!');
        return;
    }

    // Calculate time: t = t_half * log(N/N0) / log(0.5)
    const ratio = N / N0;
    const time = halfLife * (Math.log(ratio) / Math.log(0.5));

    const percentRemaining = (N / N0) * 100;
    const numberHalfLives = time / halfLife;

    displayResult('timeResult', {
        formula: 't = t½ × log(N/N₀) / log(0.5)',
        given: `Initial: ${N0}, Remaining: ${N}, Half-life: ${halfLife} ${halfLifeUnit}`,
        calculation: `t = ${halfLife} × log(${N}/${N0}) / log(0.5) = ${halfLife} × ${Math.log(ratio).toFixed(4)} / ${Math.log(0.5).toFixed(4)}`,
        result: `<strong class="text-success" style="font-size: 1.5rem;">${time.toFixed(4)} ${halfLifeUnit}</strong>`,
        details: `
            <strong>Additional Information:</strong><br>
            • Number of half-lives: ${numberHalfLives.toFixed(2)}<br>
            • Percent remaining: ${percentRemaining.toFixed(2)}%<br>
            • Fraction remaining: ${ratio.toFixed(6)}
        `
    });
}

function calculateHalfLife() {
    const N0 = parseFloat(document.getElementById('initialAmountHL').value);
    const N = parseFloat(document.getElementById('remainingAmountHL').value);
    const time = parseFloat(document.getElementById('timeElapsedHL').value);
    const timeUnit = document.getElementById('timeUnitHL').value;

    if (N > N0) {
        alert('Remaining amount cannot be greater than initial amount!');
        return;
    }

    // Calculate half-life: t_half = t * log(0.5) / log(N/N0)
    const ratio = N / N0;
    const halfLife = time * (Math.log(0.5) / Math.log(ratio));

    const percentRemaining = (N / N0) * 100;
    const numberHalfLives = time / halfLife;

    displayResult('halfLifeResult', {
        formula: 't½ = t × log(0.5) / log(N/N₀)',
        given: `Initial: ${N0}, Remaining: ${N}, Time: ${time} ${timeUnit}`,
        calculation: `t½ = ${time} × log(0.5) / log(${N}/${N0}) = ${time} × ${Math.log(0.5).toFixed(4)} / ${Math.log(ratio).toFixed(4)}`,
        result: `<strong class="text-info" style="font-size: 1.5rem;">${halfLife.toFixed(4)} ${timeUnit}</strong>`,
        details: `
            <strong>Additional Information:</strong><br>
            • Number of half-lives elapsed: ${numberHalfLives.toFixed(2)}<br>
            • Percent remaining: ${percentRemaining.toFixed(2)}%<br>
            • Decay constant (λ): ${(Math.LN2 / (halfLife * timeConversions[timeUnit])).toExponential(4)} s⁻¹
        `
    });
}

function displayResult(elementId, data) {
    document.getElementById(elementId).innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p><strong>Formula:</strong> ${data.formula}</p>
            <p><strong>Given:</strong> ${data.given}</p>
            <p><strong>Calculation:</strong> ${data.calculation}</p>
            <hr>
            <div class="text-center">${data.result}</div>
        </div>
        <div class="alert alert-info">
            ${data.details}
        </div>
    `;
}

function loadExample(type) {
    if (type === 'carbon') {
        document.getElementById('initialAmount').value = 100;
        document.getElementById('amountUnit').value = 'g';
        document.getElementById('halfLife').value = 5730;
        document.getElementById('halfLifeUnit').value = 'years';
        document.getElementById('timeElapsed').value = 11460;
        document.getElementById('timeUnit').value = 'years';
        $('.nav-tabs a[href="#calcRemaining"]').tab('show');
    } else if (type === 'uranium') {
        document.getElementById('initialAmount').value = 1000;
        document.getElementById('amountUnit').value = 'g';
        document.getElementById('halfLife').value = 4.468e9;
        document.getElementById('halfLifeUnit').value = 'years';
        document.getElementById('timeElapsed').value = 4.468e9;
        document.getElementById('timeUnit').value = 'years';
        $('.nav-tabs a[href="#calcRemaining"]').tab('show');
    } else if (type === 'iodine') {
        document.getElementById('initialAmount').value = 100;
        document.getElementById('amountUnit').value = 'mg';
        document.getElementById('halfLife').value = 8.02;
        document.getElementById('halfLifeUnit').value = 'days';
        document.getElementById('timeElapsed').value = 24;
        document.getElementById('timeUnit').value = 'days';
        $('.nav-tabs a[href="#calcRemaining"]').tab('show');
    }
}

function useIsotope(halfLife, unit) {
    document.getElementById('halfLife').value = halfLife;
    document.getElementById('halfLifeUnit').value = unit;
    $('.nav-tabs a[href="#calcRemaining"]').tab('show');
}

// Populate isotopes table
function populateIsotopesTable() {
    const tbody = document.getElementById('isotopeTableBody');
    tbody.innerHTML = isotopes.map(iso => `
        <tr>
            <td><strong>${iso.name}</strong> ${iso.symbol}</td>
            <td>${iso.halfLife.toExponential(2)} ${iso.unit}</td>
            <td><span class="badge badge-primary">${iso.decay}</span></td>
            <td class="small">${iso.use}</td>
            <td>
                <button class="btn btn-xs btn-outline-primary" onclick="useIsotope(${iso.halfLife}, '${iso.unit}')">
                    <i class="fas fa-arrow-right"></i> Use
                </button>
            </td>
        </tr>
    `).join('');
}

// Search isotopes
document.addEventListener('DOMContentLoaded', function() {
    populateIsotopesTable();

    document.getElementById('searchIsotope').addEventListener('input', function(e) {
        const search = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#isotopeTableBody tr');
        rows.forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(search) ? '' : 'none';
        });
    });
});
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
