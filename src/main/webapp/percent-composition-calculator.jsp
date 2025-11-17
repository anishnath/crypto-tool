<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Percent Composition Calculator | Mass Percent by Element | 8gwifi.org</title>
    <meta name="description" content="Calculate percent composition by mass for any chemical compound. Find mass percent of each element from chemical formula. Free chemistry calculator with step-by-step solutions.">
    <meta name="keywords" content="percent composition calculator, mass percent, percent by mass, chemical formula, elemental composition, mass percentage calculator, chemistry calculator">

    <link rel="canonical" href="https://8gwifi.org/percent-composition-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Percent Composition Calculator",
      "description": "Calculate percent composition by mass for any chemical compound from its formula.",
      "url": "https://8gwifi.org/percent-composition-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="chem-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-chart-pie"></i> Percent Composition Calculator</h1>
    <p class="text-center text-muted mb-4">Calculate the mass percent of each element in a compound</p>

    <div class="row">
        <div class="col-lg-8">
            <div class="card">
                <div class="card-body">
                    <h5>Enter Chemical Formula</h5>
                    <form onsubmit="calculateComposition(); return false;">
                        <div class="form-group">
                            <label>Chemical Formula</label>
                            <input type="text" class="form-control form-control-lg" id="formula"
                                   placeholder="e.g., H2O, C6H12O6, Ca(OH)2" required>
                            <small class="form-text text-muted">
                                Use element symbols with numbers (H2O). Parentheses supported: Ca(NO3)2
                            </small>
                        </div>
                        <button type="submit" class="btn btn-primary btn-block btn-lg">
                            <i class="fas fa-calculator"></i> Calculate Percent Composition
                        </button>
                    </form>
                </div>
            </div>

            <div id="results" class="mt-4"></div>
        </div>

        <div class="col-lg-4">
            <div class="card">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> About</h5>
                </div>
                <div class="card-body">
                    <h6>Formula</h6>
                    <div class="alert alert-info">
                        <strong>% Mass = (Element Mass / Total Mass) × 100%</strong>
                    </div>

                    <h6>Steps</h6>
                    <ol class="small">
                        <li>Find molar mass of compound</li>
                        <li>Find total mass of each element</li>
                        <li>Divide element mass by total</li>
                        <li>Multiply by 100%</li>
                    </ol>

                    <h6>Quick Examples</h6>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('H2O')">Water (H₂O)</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('CO2')">Carbon Dioxide (CO₂)</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('C6H12O6')">Glucose (C₆H₁₂O₆)</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('Ca(OH)2')">Calcium Hydroxide</button>
                    <button class="btn btn-sm btn-outline-primary btn-block" onclick="loadExample('NaCl')">Salt (NaCl)</button>
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
// Atomic masses (g/mol)
const atomicMasses = {
    H: 1.008, He: 4.003, Li: 6.941, Be: 9.012, B: 10.811, C: 12.011, N: 14.007, O: 15.999, F: 18.998, Ne: 20.180,
    Na: 22.990, Mg: 24.305, Al: 26.982, Si: 28.086, P: 30.974, S: 32.065, Cl: 35.453, Ar: 39.948,
    K: 39.098, Ca: 40.078, Sc: 44.956, Ti: 47.867, V: 50.942, Cr: 51.996, Mn: 54.938, Fe: 55.845,
    Co: 58.933, Ni: 58.693, Cu: 63.546, Zn: 65.38, Ga: 69.723, Ge: 72.64, As: 74.922, Se: 78.96,
    Br: 79.904, Kr: 83.798, Rb: 85.468, Sr: 87.62, Y: 88.906, Zr: 91.224, Nb: 92.906, Mo: 95.96,
    Tc: 98, Ru: 101.07, Rh: 102.91, Pd: 106.42, Ag: 107.87, Cd: 112.41, In: 114.82, Sn: 118.71,
    Sb: 121.76, Te: 127.60, I: 126.90, Xe: 131.29, Cs: 132.91, Ba: 137.33, La: 138.91, Ce: 140.12,
    Pr: 140.91, Nd: 144.24, Pm: 145, Sm: 150.36, Eu: 151.96, Gd: 157.25, Tb: 158.93, Dy: 162.50,
    Ho: 164.93, Er: 167.26, Tm: 168.93, Yb: 173.05, Lu: 174.97, Hf: 178.49, Ta: 180.95, W: 183.84,
    Re: 186.21, Os: 190.23, Ir: 192.22, Pt: 195.08, Au: 196.97, Hg: 200.59, Tl: 204.38, Pb: 207.2,
    Bi: 208.98, Po: 209, At: 210, Rn: 222, Fr: 223, Ra: 226, Ac: 227, Th: 232.04, Pa: 231.04,
    U: 238.03, Np: 237, Pu: 244, Am: 243, Cm: 247, Bk: 247, Cf: 251, Es: 252, Fm: 257, Md: 258,
    No: 259, Lr: 266, Rf: 267, Db: 268, Sg: 269, Bh: 270, Hs: 277, Mt: 278, Ds: 281, Rg: 282,
    Cn: 285, Nh: 286, Fl: 289, Mc: 290, Lv: 293, Ts: 294, Og: 294
};

function parseFormula(formula) {
    const elementCounts = {};

    // Handle parentheses first
    formula = expandParentheses(formula);

    // Parse elements and their counts
    const regex = /([A-Z][a-z]?)(\d*)/g;
    let match;

    while ((match = regex.exec(formula)) !== null) {
        const element = match[1];
        const count = match[2] === '' ? 1 : parseInt(match[2]);

        if (!atomicMasses[element]) {
            throw new Error(`Unknown element: ${element}`);
        }

        elementCounts[element] = (elementCounts[element] || 0) + count;
    }

    return elementCounts;
}

function expandParentheses(formula) {
    // Recursively expand parentheses
    const regex = /\(([^()]+)\)(\d+)/;

    while (regex.test(formula)) {
        formula = formula.replace(regex, (match, group, multiplier) => {
            const mult = parseInt(multiplier);
            let expanded = '';

            const elementRegex = /([A-Z][a-z]?)(\d*)/g;
            let elementMatch;

            while ((elementMatch = elementRegex.exec(group)) !== null) {
                const element = elementMatch[1];
                const count = elementMatch[2] === '' ? 1 : parseInt(elementMatch[2]);
                const newCount = count * mult;
                expanded += element + (newCount > 1 ? newCount : '');
            }

            return expanded;
        });
    }

    return formula;
}

function calculateComposition() {
    const formula = document.getElementById('formula').value.trim();

    if (!formula) {
        alert('Please enter a chemical formula');
        return;
    }

    try {
        const elementCounts = parseFormula(formula);

        // Calculate total molar mass
        let totalMass = 0;
        const elementMasses = {};

        for (const [element, count] of Object.entries(elementCounts)) {
            const mass = atomicMasses[element] * count;
            elementMasses[element] = mass;
            totalMass += mass;
        }

        // Calculate percent composition
        const percentages = {};
        for (const [element, mass] of Object.entries(elementMasses)) {
            percentages[element] = (mass / totalMass) * 100;
        }

        displayResults(formula, elementCounts, elementMasses, totalMass, percentages);

    } catch (error) {
        document.getElementById('results').innerHTML = `
            <div class="alert alert-danger">
                <strong>Error:</strong> ${error.message}
            </div>
        `;
    }
}

function displayResults(formula, elementCounts, elementMasses, totalMass, percentages) {
    // Create pie chart colors
    const colors = ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF'];

    let resultsHTML = `
        <div class="card">
            <div class="card-header bg-success text-white">
                <h5 class="mb-0"><i class="fas fa-check-circle"></i> Results for ${formula}</h5>
            </div>
            <div class="card-body">
                <h6>Total Molar Mass: <span class="text-primary">${totalMass.toFixed(4)} g/mol</span></h6>
                <hr>

                <h6>Percent Composition by Mass:</h6>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead class="thead-light">
                            <tr>
                                <th>Element</th>
                                <th>Count</th>
                                <th>Atomic Mass</th>
                                <th>Total Mass</th>
                                <th>Percent</th>
                                <th>Visual</th>
                            </tr>
                        </thead>
                        <tbody>
    `;

    let index = 0;
    let checkSum = 0;

    for (const [element, count] of Object.entries(elementCounts)) {
        const atomicMass = atomicMasses[element];
        const totalElementMass = elementMasses[element];
        const percent = percentages[element];
        checkSum += percent;

        const color = colors[index % colors.length];
        const barWidth = percent.toFixed(1);

        resultsHTML += `
            <tr>
                <td><strong>${element}</strong></td>
                <td>${count}</td>
                <td>${atomicMass.toFixed(3)} g/mol</td>
                <td>${totalElementMass.toFixed(4)} g</td>
                <td><strong>${percent.toFixed(2)}%</strong></td>
                <td>
                    <div class="progress" style="height: 25px;">
                        <div class="progress-bar" role="progressbar"
                             style="width: ${barWidth}%; background-color: ${color};"
                             aria-valuenow="${barWidth}" aria-valuemin="0" aria-valuemax="100">
                            ${percent.toFixed(1)}%
                        </div>
                    </div>
                </td>
            </tr>
        `;
        index++;
    }

    resultsHTML += `
                        </tbody>
                        <tfoot class="font-weight-bold">
                            <tr>
                                <td colspan="4">Total:</td>
                                <td>${checkSum.toFixed(2)}%</td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="alert alert-info mt-3">
                    <h6><i class="fas fa-calculator"></i> Calculation Steps:</h6>
                    <ol class="mb-0">
    `;

    for (const [element, count] of Object.entries(elementCounts)) {
        const atomicMass = atomicMasses[element];
        const totalElementMass = elementMasses[element];
        const percent = percentages[element];

        resultsHTML += `
            <li>
                <strong>${element}:</strong> ${count} × ${atomicMass.toFixed(3)} = ${totalElementMass.toFixed(4)} g<br>
                <small>Percent = (${totalElementMass.toFixed(4)} / ${totalMass.toFixed(4)}) × 100% = ${percent.toFixed(2)}%</small>
            </li>
        `;
    }

    resultsHTML += `
                    </ol>
                </div>
            </div>
        </div>
    `;

    document.getElementById('results').innerHTML = resultsHTML;
}

function loadExample(formula) {
    document.getElementById('formula').value = formula;
    calculateComposition();
}
</script>

<%@ include file="body-close.jsp"%>
</html>
