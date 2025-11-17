<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Density Calculator | Calculate Density, Mass, Volume | 8gwifi.org</title>
    <meta name="description" content="Free density calculator to find density (d=m/v), mass, or volume. Includes unit conversions (g/mL, kg/L, g/cm³), common substance densities, and step-by-step solutions. Perfect for chemistry, physics, and engineering.">
    <meta name="keywords" content="density calculator, calculate density, mass volume density, d=m/v calculator, density formula, unit conversion, g/mL to kg/L, density of substances, chemistry calculator">

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/density-calculator.jsp">
    <meta property="og:title" content="Density Calculator - Calculate Density, Mass, or Volume">
    <meta property="og:description" content="Calculate density (d=m/v), mass, or volume with unit conversions and common substance densities.">
    <meta property="og:image" content="https://8gwifi.org/images/site/density-calculator-og.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/density-calculator.jsp">
    <meta property="twitter:title" content="Density Calculator - d=m/v">
    <meta property="twitter:description" content="Calculate density, mass, or volume with unit conversions.">

    <link rel="canonical" href="https://8gwifi.org/density-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- JSON-LD Schema -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Density Calculator",
      "description": "Calculate density (d=m/v), mass, or volume with unit conversions between g/mL, kg/L, g/cm³, and more. Includes database of common substance densities.",
      "url": "https://8gwifi.org/density-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "operatingSystem": "Any",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "featureList": ["Calculate density from mass and volume", "Calculate mass from density and volume", "Calculate volume from mass and density", "Unit conversions (g/mL, kg/L, g/cm³, lb/ft³)", "Common substance densities database", "Step-by-step solutions"]
    }
    </script>

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [{
        "@type": "Question",
        "name": "What is the density formula?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "The density formula is d = m/v, where d is density, m is mass, and v is volume. Density represents how much mass is contained in a given volume. Rearranged: m = d×v (mass = density × volume) and v = m/d (volume = mass / density)."
        }
      },{
        "@type": "Question",
        "name": "How do I calculate density?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "To calculate density: (1) Measure the mass of the object in grams, kilograms, or pounds. (2) Measure the volume in mL, L, cm³, or ft³. (3) Divide mass by volume: Density = Mass / Volume. Example: A 50g object with 25 mL volume has density = 50g / 25mL = 2 g/mL."
        }
      },{
        "@type": "Question",
        "name": "What are common density units?",
        "acceptedAnswer": {
          "@type": "Answer",
          "text": "Common density units include: g/mL (grams per milliliter), g/cm³ (grams per cubic centimeter, same as g/mL), kg/L (kilograms per liter, same as g/mL), kg/m³ (kilograms per cubic meter), and lb/ft³ (pounds per cubic foot). Water has density of 1 g/mL or 1000 kg/m³ at 4°C."
        }
      }]
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-weight"></i> Density Calculator</h1>
    <p class="text-center text-muted mb-4">Calculate density (d=m/v), mass, or volume with unit conversions</p>

    <div class="row">
        <div class="col-lg-8">
            <!-- Calculator Tabs -->
            <ul class="nav nav-tabs" role="tablist">
                <li class="nav-item">
                    <a class="nav-link active" data-toggle="tab" href="#calcDensity">Calculate Density</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#calcMass">Calculate Mass</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#calcVolume">Calculate Volume</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-toggle="tab" href="#substances">Common Densities</a>
                </li>
            </ul>

            <div class="tab-content border border-top-0 p-4">
                <!-- Calculate Density Tab -->
                <div id="calcDensity" class="tab-pane fade show active">
                    <h5>Calculate Density (d = m / v)</h5>
                    <form id="densityForm" onsubmit="calculateDensity(); return false;">
                        <div class="form-group">
                            <label>Mass</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="mass" step="any" required>
                                <select class="form-control" id="massUnit" style="max-width: 120px;">
                                    <option value="g">g (grams)</option>
                                    <option value="kg">kg</option>
                                    <option value="mg">mg</option>
                                    <option value="lb">lb (pounds)</option>
                                    <option value="oz">oz (ounces)</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Volume</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="volume" step="any" required>
                                <select class="form-control" id="volumeUnit" style="max-width: 120px;">
                                    <option value="mL">mL</option>
                                    <option value="L">L (liters)</option>
                                    <option value="cm3">cm³</option>
                                    <option value="m3">m³</option>
                                    <option value="ft3">ft³</option>
                                    <option value="in3">in³</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Result Units</label>
                            <select class="form-control" id="densityResultUnit">
                                <option value="g/mL">g/mL</option>
                                <option value="g/cm3">g/cm³</option>
                                <option value="kg/L">kg/L</option>
                                <option value="kg/m3">kg/m³</option>
                                <option value="lb/ft3">lb/ft³</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-calculator"></i> Calculate Density
                        </button>
                    </form>
                    <div id="densityResult" class="mt-4"></div>
                </div>

                <!-- Calculate Mass Tab -->
                <div id="calcMass" class="tab-pane fade">
                    <h5>Calculate Mass (m = d × v)</h5>
                    <form id="massForm" onsubmit="calculateMass(); return false;">
                        <div class="form-group">
                            <label>Density</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="densityInput" step="any" required>
                                <select class="form-control" id="densityUnit" style="max-width: 120px;">
                                    <option value="g/mL">g/mL</option>
                                    <option value="g/cm3">g/cm³</option>
                                    <option value="kg/L">kg/L</option>
                                    <option value="kg/m3">kg/m³</option>
                                    <option value="lb/ft3">lb/ft³</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Volume</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="volumeMass" step="any" required>
                                <select class="form-control" id="volumeMassUnit" style="max-width: 120px;">
                                    <option value="mL">mL</option>
                                    <option value="L">L</option>
                                    <option value="cm3">cm³</option>
                                    <option value="m3">m³</option>
                                    <option value="ft3">ft³</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Result Units</label>
                            <select class="form-control" id="massResultUnit">
                                <option value="g">g (grams)</option>
                                <option value="kg">kg</option>
                                <option value="mg">mg</option>
                                <option value="lb">lb</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success btn-block">
                            <i class="fas fa-calculator"></i> Calculate Mass
                        </button>
                    </form>
                    <div id="massResult" class="mt-4"></div>
                </div>

                <!-- Calculate Volume Tab -->
                <div id="calcVolume" class="tab-pane fade">
                    <h5>Calculate Volume (v = m / d)</h5>
                    <form id="volumeForm" onsubmit="calculateVolume(); return false;">
                        <div class="form-group">
                            <label>Mass</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="massVolume" step="any" required>
                                <select class="form-control" id="massVolumeUnit" style="max-width: 120px;">
                                    <option value="g">g</option>
                                    <option value="kg">kg</option>
                                    <option value="mg">mg</option>
                                    <option value="lb">lb</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Density</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="densityVolume" step="any" required>
                                <select class="form-control" id="densityVolumeUnit" style="max-width: 120px;">
                                    <option value="g/mL">g/mL</option>
                                    <option value="g/cm3">g/cm³</option>
                                    <option value="kg/L">kg/L</option>
                                    <option value="kg/m3">kg/m³</option>
                                    <option value="lb/ft3">lb/ft³</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Result Units</label>
                            <select class="form-control" id="volumeResultUnit">
                                <option value="mL">mL</option>
                                <option value="L">L</option>
                                <option value="cm3">cm³</option>
                                <option value="m3">m³</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-info btn-block">
                            <i class="fas fa-calculator"></i> Calculate Volume
                        </button>
                    </form>
                    <div id="volumeResult" class="mt-4"></div>
                </div>

                <!-- Common Densities Tab -->
                <div id="substances" class="tab-pane fade">
                    <h5>Common Substance Densities (at 20°C unless noted)</h5>
                    <div class="form-group">
                        <input type="text" class="form-control" id="searchSubstance" placeholder="Search substances...">
                    </div>
                    <div class="table-responsive">
                        <table class="table table-sm table-hover" id="substanceTable">
                            <thead class="thead-light">
                                <tr>
                                    <th>Substance</th>
                                    <th>Density (g/mL)</th>
                                    <th>Density (kg/m³)</th>
                                    <th>State</th>
                                </tr>
                            </thead>
                            <tbody id="substanceTableBody"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-lg-4">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> About Density</h5>
                </div>
                <div class="card-body">
                    <h6>Density Formula</h6>
                    <div class="alert alert-info">
                        <strong>d = m / v</strong><br>
                        where:<br>
                        • d = density<br>
                        • m = mass<br>
                        • v = volume
                    </div>

                    <h6>Rearranged Formulas</h6>
                    <ul>
                        <li><strong>Mass:</strong> m = d × v</li>
                        <li><strong>Volume:</strong> v = m / d</li>
                    </ul>

                    <h6>Common Units</h6>
                    <ul class="small">
                        <li><strong>g/mL</strong> = <strong>g/cm³</strong> (same value)</li>
                        <li><strong>kg/L</strong> = g/mL (same value)</li>
                        <li><strong>kg/m³</strong> = g/L</li>
                        <li>Water: 1 g/mL = 1000 kg/m³</li>
                    </ul>

                    <h6>Quick Examples</h6>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('water')">Water Example</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('iron')">Iron Example</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('alcohol')">Alcohol Example</button>
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
// Unit conversion factors to base units (g and mL)
const massConversions = {
    'g': 1,
    'kg': 1000,
    'mg': 0.001,
    'lb': 453.59237,
    'oz': 28.349523
};

const volumeConversions = {
    'mL': 1,
    'L': 1000,
    'cm3': 1,
    'm3': 1000000,
    'ft3': 28316.8466,
    'in3': 16.387064
};

const densityConversions = {
    'g/mL': 1,
    'g/cm3': 1,
    'kg/L': 1,
    'kg/m3': 0.001,
    'lb/ft3': 0.016018463
};

// Common substance densities (g/mL at 20°C)
const substances = [
    { name: 'Water', density: 1.0, state: 'Liquid' },
    { name: 'Ice', density: 0.92, state: 'Solid' },
    { name: 'Ethanol (Alcohol)', density: 0.789, state: 'Liquid' },
    { name: 'Gasoline', density: 0.72, state: 'Liquid' },
    { name: 'Mercury', density: 13.534, state: 'Liquid' },
    { name: 'Air', density: 0.001225, state: 'Gas' },
    { name: 'Aluminum', density: 2.70, state: 'Solid' },
    { name: 'Copper', density: 8.96, state: 'Solid' },
    { name: 'Iron', density: 7.87, state: 'Solid' },
    { name: 'Gold', density: 19.32, state: 'Solid' },
    { name: 'Silver', density: 10.49, state: 'Solid' },
    { name: 'Lead', density: 11.34, state: 'Solid' },
    { name: 'Steel', density: 7.85, state: 'Solid' },
    { name: 'Brass', density: 8.50, state: 'Solid' },
    { name: 'Titanium', density: 4.54, state: 'Solid' },
    { name: 'Platinum', density: 21.45, state: 'Solid' },
    { name: 'Uranium', density: 19.05, state: 'Solid' },
    { name: 'Wood (Oak)', density: 0.75, state: 'Solid' },
    { name: 'Wood (Pine)', density: 0.52, state: 'Solid' },
    { name: 'Cork', density: 0.24, state: 'Solid' },
    { name: 'Concrete', density: 2.40, state: 'Solid' },
    { name: 'Glass', density: 2.50, state: 'Solid' },
    { name: 'Plastic (PET)', density: 1.38, state: 'Solid' },
    { name: 'Rubber', density: 1.20, state: 'Solid' },
    { name: 'Milk', density: 1.03, state: 'Liquid' },
    { name: 'Olive Oil', density: 0.92, state: 'Liquid' },
    { name: 'Honey', density: 1.42, state: 'Liquid' },
    { name: 'Glycerin', density: 1.26, state: 'Liquid' },
    { name: 'Seawater', density: 1.025, state: 'Liquid' },
    { name: 'Blood', density: 1.06, state: 'Liquid' }
];

function calculateDensity() {
    const mass = parseFloat(document.getElementById('mass').value);
    const massUnit = document.getElementById('massUnit').value;
    const volume = parseFloat(document.getElementById('volume').value);
    const volumeUnit = document.getElementById('volumeUnit').value;
    const resultUnit = document.getElementById('densityResultUnit').value;

    // Convert to base units (g and mL)
    const massInG = mass * massConversions[massUnit];
    const volumeInML = volume * volumeConversions[volumeUnit];

    // Calculate density in g/mL
    const densityGML = massInG / volumeInML;

    // Convert to desired units
    const density = densityGML / densityConversions[resultUnit];

    displayResult('densityResult', {
        formula: 'd = m / v',
        given: `Mass = ${mass} ${massUnit}, Volume = ${volume} ${volumeUnit}`,
        converted: `Mass = ${massInG.toFixed(4)} g, Volume = ${volumeInML.toFixed(4)} mL`,
        calculation: `Density = ${massInG.toFixed(4)} g / ${volumeInML.toFixed(4)} mL = ${densityGML.toFixed(6)} g/mL`,
        result: `<strong>Density = ${density.toFixed(6)} ${resultUnit}</strong>`,
        interpretation: getDensityInterpretation(densityGML)
    });
}

function calculateMass() {
    const density = parseFloat(document.getElementById('densityInput').value);
    const densityUnit = document.getElementById('densityUnit').value;
    const volume = parseFloat(document.getElementById('volumeMass').value);
    const volumeUnit = document.getElementById('volumeMassUnit').value;
    const resultUnit = document.getElementById('massResultUnit').value;

    // Convert to base units
    const densityGML = density * densityConversions[densityUnit];
    const volumeInML = volume * volumeConversions[volumeUnit];

    // Calculate mass in g
    const massInG = densityGML * volumeInML;

    // Convert to desired units
    const mass = massInG / massConversions[resultUnit];

    displayResult('massResult', {
        formula: 'm = d × v',
        given: `Density = ${density} ${densityUnit}, Volume = ${volume} ${volumeUnit}`,
        converted: `Density = ${densityGML.toFixed(6)} g/mL, Volume = ${volumeInML.toFixed(4)} mL`,
        calculation: `Mass = ${densityGML.toFixed(6)} g/mL × ${volumeInML.toFixed(4)} mL = ${massInG.toFixed(4)} g`,
        result: `<strong>Mass = ${mass.toFixed(4)} ${resultUnit}</strong>`,
        interpretation: getMassInterpretation(mass, resultUnit)
    });
}

function calculateVolume() {
    const mass = parseFloat(document.getElementById('massVolume').value);
    const massUnit = document.getElementById('massVolumeUnit').value;
    const density = parseFloat(document.getElementById('densityVolume').value);
    const densityUnit = document.getElementById('densityVolumeUnit').value;
    const resultUnit = document.getElementById('volumeResultUnit').value;

    // Convert to base units
    const massInG = mass * massConversions[massUnit];
    const densityGML = density * densityConversions[densityUnit];

    // Calculate volume in mL
    const volumeInML = massInG / densityGML;

    // Convert to desired units
    const volume = volumeInML / volumeConversions[resultUnit];

    displayResult('volumeResult', {
        formula: 'v = m / d',
        given: `Mass = ${mass} ${massUnit}, Density = ${density} ${densityUnit}`,
        converted: `Mass = ${massInG.toFixed(4)} g, Density = ${densityGML.toFixed(6)} g/mL`,
        calculation: `Volume = ${massInG.toFixed(4)} g / ${densityGML.toFixed(6)} g/mL = ${volumeInML.toFixed(4)} mL`,
        result: `<strong>Volume = ${volume.toFixed(4)} ${resultUnit}</strong>`,
        interpretation: getVolumeInterpretation(volume, resultUnit)
    });
}

function displayResult(elementId, data) {
    document.getElementById(elementId).innerHTML = `
        <div class="alert alert-success">
            <h5><i class="fas fa-check-circle"></i> Result</h5>
            <p><strong>Formula:</strong> ${data.formula}</p>
            <p><strong>Given:</strong> ${data.given}</p>
            <p><strong>Converted to Base Units:</strong> ${data.converted}</p>
            <p><strong>Calculation:</strong> ${data.calculation}</p>
            <hr>
            <p class="mb-0">${data.result}</p>
        </div>
        <div class="alert alert-info">
            <strong><i class="fas fa-lightbulb"></i> Interpretation:</strong> ${data.interpretation}
        </div>
    `;
}

function getDensityInterpretation(densityGML) {
    if (densityGML < 1) {
        return `This substance is less dense than water (1 g/mL) and will float on water.`;
    } else if (densityGML === 1) {
        return `This substance has the same density as water at 4°C.`;
    } else if (densityGML < 2) {
        return `This substance is denser than water and will sink, but it's still relatively light. Could be plastics or light metals.`;
    } else if (densityGML < 8) {
        return `This substance has medium density, typical of common metals like aluminum (2.7 g/mL) or iron (7.87 g/mL).`;
    } else {
        return `This is a very dense substance, typical of heavy metals like copper (8.96 g/mL), lead (11.34 g/mL), or gold (19.32 g/mL).`;
    }
}

function getMassInterpretation(mass, unit) {
    return `The calculated mass is ${mass.toFixed(2)} ${unit}. This is the amount of matter contained in the given volume at the specified density.`;
}

function getVolumeInterpretation(volume, unit) {
    return `The calculated volume is ${volume.toFixed(2)} ${unit}. This is the space occupied by the given mass at the specified density.`;
}

function loadExample(type) {
    if (type === 'water') {
        document.getElementById('mass').value = 100;
        document.getElementById('massUnit').value = 'g';
        document.getElementById('volume').value = 100;
        document.getElementById('volumeUnit').value = 'mL';
        document.getElementById('densityResultUnit').value = 'g/mL';
        // Switch to first tab
        $('.nav-tabs a[href="#calcDensity"]').tab('show');
    } else if (type === 'iron') {
        document.getElementById('mass').value = 787;
        document.getElementById('massUnit').value = 'g';
        document.getElementById('volume').value = 100;
        document.getElementById('volumeUnit').value = 'cm3';
        document.getElementById('densityResultUnit').value = 'g/cm3';
        $('.nav-tabs a[href="#calcDensity"]').tab('show');
    } else if (type === 'alcohol') {
        document.getElementById('densityInput').value = 0.789;
        document.getElementById('densityUnit').value = 'g/mL';
        document.getElementById('volumeMass').value = 500;
        document.getElementById('volumeMassUnit').value = 'mL';
        document.getElementById('massResultUnit').value = 'g';
        $('.nav-tabs a[href="#calcMass"]').tab('show');
    }
}

// Populate substances table
function populateSubstancesTable() {
    const tbody = document.getElementById('substanceTableBody');
    tbody.innerHTML = substances.map(s => `
        <tr>
            <td><strong>${s.name}</strong></td>
            <td>${s.density.toFixed(3)} g/mL</td>
            <td>${(s.density * 1000).toFixed(1)} kg/m³</td>
            <td><span class="badge badge-${s.state === 'Solid' ? 'primary' : s.state === 'Liquid' ? 'info' : 'secondary'}">${s.state}</span></td>
        </tr>
    `).join('');
}

// Search substances
document.addEventListener('DOMContentLoaded', function() {
    populateSubstancesTable();

    document.getElementById('searchSubstance').addEventListener('input', function(e) {
        const search = e.target.value.toLowerCase();
        const rows = document.querySelectorAll('#substanceTableBody tr');
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

