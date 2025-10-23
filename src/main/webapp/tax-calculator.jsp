<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Income Tax Calculator - Calculate Your Tax Liability</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta name="description" content="Free online income tax calculator. Calculate your income tax, compare tax regimes, and optimize your tax savings with deductions under Section 80C, 80D, and more.">
    <meta name="keywords" content="income tax calculator, tax calculator, tax planning, 80C deductions, tax savings, old vs new tax regime">

    <script type="application/ld+json">
    {
        "@context": "http://schema.org",
        "@type": "WebPage",
        "name": "Income Tax Calculator",
        "description": "Calculate your income tax liability and compare old vs new tax regimes. Optimize your tax savings with our comprehensive tax calculator.",
        "url": "https://8gwifi.org/tax-calculator.jsp",
        "author": {
            "@type": "Person",
            "name": "Anish Nath"
        },
        "datePublished": "2025-01-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
    <style>
        .regime-card {
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin: 10px 0;
            transition: all 0.3s ease;
        }
        .regime-card.selected {
            border-color: #4285F4;
            background-color: #E8F0FE;
            box-shadow: 0 4px 8px rgba(66, 133, 244, 0.3);
        }
        .tax-breakdown {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .comparison-highlight {
            font-size: 1.2em;
            font-weight: bold;
            color: #34A853;
        }
        .section-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background-color: #fff;
        }
        .nav-tabs .nav-link {
            color: #495057;
        }
        .nav-tabs .nav-link.active {
            color: #4285F4;
            font-weight: bold;
        }
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 20px;
        }
        .sticky-summary {
            position: sticky;
            top: 20px;
            z-index: 100;
        }
        .compact-form .form-group {
            margin-bottom: 10px;
        }
        .compact-form label {
            font-size: 0.9em;
            margin-bottom: 3px;
        }
        .compact-form input {
            font-size: 0.9em;
        }
        .compact-form small {
            font-size: 0.75em;
        }
    </style>
</head>
<%@ include file="body-script.jsp"%>
    <div class="container-fluid mt-4">
        <h1 class="mb-3">Income Tax Calculator</h1>
        <p class="mb-4">Calculate your income tax liability and compare different tax regimes to optimize your tax savings.</p>

        <div class="row">
            <!-- Left Column - Input Forms -->
            <div class="col-lg-5">
                <div class="section-card compact-form">
                    <h5 class="mb-3"><i class="fas fa-rupee-sign"></i> Income Details</h5>

                    <div class="form-group">
                        <label for="annualIncome">Annual Gross Income:</label>
                        <input type="number" value="1200000" class="form-control" id="annualIncome" required>
                    </div>

                    <div class="form-group">
                        <label for="otherIncome">Other Income (Interest, Rental, etc.):</label>
                        <input type="number" value="50000" class="form-control" id="otherIncome">
                    </div>

                    <div class="form-group">
                        <label for="standardDeduction">Standard Deduction:</label>
                        <input type="number" value="50000" class="form-control" id="standardDeduction">
                        <small class="form-text text-muted">Available in both regimes</small>
                    </div>
                </div>

                <!-- Deductions Section - Collapsible -->
                <div class="section-card compact-form">
                    <h5 class="mb-3">
                        <a data-toggle="collapse" href="#deductionsSection" role="button" aria-expanded="true" aria-controls="deductionsSection" class="text-decoration-none">
                            <i class="fas fa-file-invoice-dollar"></i> Deductions (Old Regime)
                            <i class="fas fa-chevron-down float-right"></i>
                        </a>
                    </h5>

                    <div class="collapse show" id="deductionsSection">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="section80C">Section 80C:</label>
                                    <input type="number" value="150000" max="150000" class="form-control" id="section80C">
                                    <small>Max ₹1,50,000</small>
                                </div>

                                <div class="form-group">
                                    <label for="section80D">Section 80D:</label>
                                    <input type="number" value="25000" max="100000" class="form-control" id="section80D">
                                    <small>Up to ₹25,000</small>
                                </div>

                                <div class="form-group">
                                    <label for="section80CCD">Section 80CCD(1B):</label>
                                    <input type="number" value="50000" max="50000" class="form-control" id="section80CCD">
                                    <small>Max ₹50,000</small>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="hra">HRA:</label>
                                    <input type="number" value="120000" class="form-control" id="hra">
                                </div>

                                <div class="form-group">
                                    <label for="lta">LTA:</label>
                                    <input type="number" value="20000" class="form-control" id="lta">
                                </div>

                                <div class="form-group">
                                    <label for="homeLoanInterest">Home Loan Interest:</label>
                                    <input type="number" value="0" max="200000" class="form-control" id="homeLoanInterest">
                                    <small>Max ₹2,00,000</small>
                                </div>

                                <div class="form-group">
                                    <label for="otherDeductions">Other Deductions:</label>
                                    <input type="number" value="0" class="form-control" id="otherDeductions">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tax Slabs Editor - Collapsible -->
                <div class="section-card">
                    <h5 class="mb-3">
                        <a data-toggle="collapse" href="#taxSlabsEditor" role="button" aria-expanded="false" aria-controls="taxSlabsEditor" class="text-decoration-none">
                            <i class="fas fa-cog"></i> Tax Slabs Configuration
                            <i class="fas fa-chevron-down float-right"></i>
                        </a>
                    </h5>

                    <div class="text-center mb-3">
                        <button type="button" class="btn btn-sm btn-secondary" onclick="resetTaxSlabs()">
                            <i class="fas fa-undo"></i> Reset to Default
                        </button>
                    </div>

                    <div id="taxSlabsEditor" class="collapse">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-2">
                                    <div class="card-header bg-primary text-white py-2">
                                        <small><strong>Old Regime Slabs</strong></small>
                                    </div>
                                    <div class="card-body p-2">
                                        <table class="table table-sm mb-0" id="oldSlabsTable">
                                            <thead>
                                                <tr>
                                                    <th style="font-size: 0.8em;">From</th>
                                                    <th style="font-size: 0.8em;">To</th>
                                                    <th style="font-size: 0.8em;">Rate (%)</th>
                                                </tr>
                                            </thead>
                                            <tbody id="oldSlabsBody"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="card mb-2">
                                    <div class="card-header bg-success text-white py-2">
                                        <small><strong>New Regime Slabs</strong></small>
                                    </div>
                                    <div class="card-body p-2">
                                        <table class="table table-sm mb-0" id="newSlabsTable">
                                            <thead>
                                                <tr>
                                                    <th style="font-size: 0.8em;">From</th>
                                                    <th style="font-size: 0.8em;">To</th>
                                                    <th style="font-size: 0.8em;">Rate (%)</th>
                                                </tr>
                                            </thead>
                                            <tbody id="newSlabsBody"></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - Results & Charts -->
            <div class="col-lg-7">
                <!-- Tax Comparison Cards -->
                <div class="section-card">
                    <h5 class="mb-3"><i class="fas fa-chart-bar"></i> Tax Comparison - Old vs New Regime</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="regime-card" id="old-regime-card">
                                <h6><strong>Old Tax Regime</strong></h6>
                                <p class="text-muted small mb-2">With Deductions & Exemptions</p>
                                <div class="tax-breakdown">
                                    <p class="mb-1 small"><strong>Gross Income:</strong> <span id="old-gross-income">0</span></p>
                                    <p class="mb-1 small"><strong>Deductions:</strong> <span id="old-deductions">0</span></p>
                                    <p class="mb-1 small"><strong>Taxable Income:</strong> <span id="old-taxable-income">0</span></p>
                                    <p class="mb-1 small"><strong>Income Tax:</strong> <span id="old-income-tax">0</span></p>
                                    <p class="mb-2 small"><strong>Cess (4%):</strong> <span id="old-cess">0</span></p>
                                    <hr class="my-2">
                                    <p class="comparison-highlight mb-0"><strong>Total Tax:</strong> <span id="old-total-tax">0</span></p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="regime-card" id="new-regime-card">
                                <h6><strong>New Tax Regime</strong></h6>
                                <p class="text-muted small mb-2">Lower Rates, Minimal Deductions</p>
                                <div class="tax-breakdown">
                                    <p class="mb-1 small"><strong>Gross Income:</strong> <span id="new-gross-income">0</span></p>
                                    <p class="mb-1 small"><strong>Standard Ded:</strong> <span id="new-standard-ded">0</span></p>
                                    <p class="mb-1 small"><strong>Taxable Income:</strong> <span id="new-taxable-income">0</span></p>
                                    <p class="mb-1 small"><strong>Income Tax:</strong> <span id="new-income-tax">0</span></p>
                                    <p class="mb-2 small"><strong>Cess (4%):</strong> <span id="new-cess">0</span></p>
                                    <hr class="my-2">
                                    <p class="comparison-highlight mb-0"><strong>Total Tax:</strong> <span id="new-total-tax">0</span></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="alert alert-success mt-3 mb-0" id="recommendation">
                        <h6 class="mb-2"><i class="fas fa-lightbulb"></i> Recommendation</h6>
                        <p id="recommendation-text" class="mb-0"></p>
                    </div>
                </div>

                <!-- Tabs for Charts -->
                <div class="section-card">
                    <ul class="nav nav-tabs" id="chartTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="comparison-tab" data-toggle="tab" href="#comparisonTab" role="tab">
                                <i class="fas fa-balance-scale"></i> Comparison
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="old-slab-tab" data-toggle="tab" href="#oldSlabTab" role="tab">
                                <i class="fas fa-layer-group"></i> Old Regime Slabs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="new-slab-tab" data-toggle="tab" href="#newSlabTab" role="tab">
                                <i class="fas fa-layer-group"></i> New Regime Slabs
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="distribution-tab" data-toggle="tab" href="#distributionTab" role="tab">
                                <i class="fas fa-chart-pie"></i> Distribution
                            </a>
                        </li>
                    </ul>

                    <div class="tab-content mt-3" id="chartTabsContent">
                        <div class="tab-pane fade show active" id="comparisonTab" role="tabpanel">
                            <div class="chart-container">
                                <canvas id="tax-comparison-chart"></canvas>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="oldSlabTab" role="tabpanel">
                            <div class="chart-container">
                                <canvas id="old-slab-chart"></canvas>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="newSlabTab" role="tabpanel">
                            <div class="chart-container">
                                <canvas id="new-slab-chart"></canvas>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="distributionTab" role="tabpanel">
                            <div class="chart-container">
                                <canvas id="income-distribution-chart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        var comparisonChart = null;
        var oldSlabChart = null;
        var newSlabChart = null;
        var incomeDistChart = null;

        // Default Tax slabs for Old Regime (Standard rates - adjust as needed)
        var defaultOldTaxSlabs = [
            { min: 0, max: 250000, rate: 0 },
            { min: 250000, max: 500000, rate: 0.05 },
            { min: 500000, max: 1000000, rate: 0.20 },
            { min: 1000000, max: Infinity, rate: 0.30 }
        ];

        // Default Tax slabs for New Regime (2023-24 onwards - adjust as needed)
        var defaultNewTaxSlabs = [
            { min: 0, max: 300000, rate: 0 },
            { min: 300000, max: 600000, rate: 0.05 },
            { min: 600000, max: 900000, rate: 0.10 },
            { min: 900000, max: 1200000, rate: 0.15 },
            { min: 1200000, max: 1500000, rate: 0.20 },
            { min: 1500000, max: Infinity, rate: 0.30 }
        ];

        // Working copies of tax slabs
        var oldTaxSlabs = JSON.parse(JSON.stringify(defaultOldTaxSlabs));
        var newTaxSlabs = JSON.parse(JSON.stringify(defaultNewTaxSlabs));

        // Populate tax slab tables
        function populateTaxSlabTables() {
            var oldSlabsHTML = "";
            for (var i = 0; i < oldTaxSlabs.length; i++) {
                var slab = oldTaxSlabs[i];
                var maxDisplay = slab.max === Infinity ? "Above" : slab.max;
                oldSlabsHTML += "<tr>" +
                    "<td><input type='number' class='form-control form-control-sm' value='" + slab.min + "' onchange='updateOldSlab(" + i + ", \"min\", this.value)' readonly></td>" +
                    "<td>" + (slab.max === Infinity ? "Above" : "<input type='number' class='form-control form-control-sm' value='" + slab.max + "' onchange='updateOldSlab(" + i + ", \"max\", this.value)'>") + "</td>" +
                    "<td><input type='number' step='0.01' class='form-control form-control-sm' value='" + (slab.rate * 100) + "' onchange='updateOldSlab(" + i + ", \"rate\", this.value / 100)'></td>" +
                    "</tr>";
            }
            $("#oldSlabsBody").html(oldSlabsHTML);

            var newSlabsHTML = "";
            for (var i = 0; i < newTaxSlabs.length; i++) {
                var slab = newTaxSlabs[i];
                var maxDisplay = slab.max === Infinity ? "Above" : slab.max;
                newSlabsHTML += "<tr>" +
                    "<td><input type='number' class='form-control form-control-sm' value='" + slab.min + "' onchange='updateNewSlab(" + i + ", \"min\", this.value)' readonly></td>" +
                    "<td>" + (slab.max === Infinity ? "Above" : "<input type='number' class='form-control form-control-sm' value='" + slab.max + "' onchange='updateNewSlab(" + i + ", \"max\", this.value)'>") + "</td>" +
                    "<td><input type='number' step='0.01' class='form-control form-control-sm' value='" + (slab.rate * 100) + "' onchange='updateNewSlab(" + i + ", \"rate\", this.value / 100)'></td>" +
                    "</tr>";
            }
            $("#newSlabsBody").html(newSlabsHTML);
        }

        function updateOldSlab(index, field, value) {
            oldTaxSlabs[index][field] = field === 'rate' ? parseFloat(value) : parseInt(value);
            calculateTax();
        }

        function updateNewSlab(index, field, value) {
            newTaxSlabs[index][field] = field === 'rate' ? parseFloat(value) : parseInt(value);
            calculateTax();
        }

        function resetTaxSlabs() {
            oldTaxSlabs = JSON.parse(JSON.stringify(defaultOldTaxSlabs));
            newTaxSlabs = JSON.parse(JSON.stringify(defaultNewTaxSlabs));
            populateTaxSlabTables();
            calculateTax();
        }

        function calculateTaxForSlabs(taxableIncome, slabs) {
            var tax = 0;
            var slabBreakdown = [];

            for (var i = 0; i < slabs.length; i++) {
                var slab = slabs[i];
                if (taxableIncome > slab.min) {
                    var taxableInSlab = Math.min(taxableIncome, slab.max) - slab.min;
                    var taxInSlab = taxableInSlab * slab.rate;
                    tax += taxInSlab;

                    slabBreakdown.push({
                        slab: slab.min + " - " + (slab.max === Infinity ? "Above" : slab.max),
                        rate: (slab.rate * 100) + "%",
                        taxableAmount: taxableInSlab,
                        tax: taxInSlab
                    });
                }
            }

            return { tax: tax, breakdown: slabBreakdown };
        }

        function calculateTax() {
            // Get inputs
            var annualIncome = parseFloat($("#annualIncome").val()) || 0;
            var otherIncome = parseFloat($("#otherIncome").val()) || 0;
            var section80C = Math.min(parseFloat($("#section80C").val()) || 0, 150000);
            var section80D = parseFloat($("#section80D").val()) || 0;
            var section80CCD = Math.min(parseFloat($("#section80CCD").val()) || 0, 50000);
            var hra = parseFloat($("#hra").val()) || 0;
            var lta = parseFloat($("#lta").val()) || 0;
            var homeLoanInterest = Math.min(parseFloat($("#homeLoanInterest").val()) || 0, 200000);
            var otherDeductions = parseFloat($("#otherDeductions").val()) || 0;
            var standardDeduction = parseFloat($("#standardDeduction").val()) || 0;

            var grossIncome = annualIncome + otherIncome;

            // OLD REGIME CALCULATION
            var oldTotalDeductions = section80C + section80D + section80CCD + hra + lta +
                                    homeLoanInterest + otherDeductions + standardDeduction;
            var oldTaxableIncome = Math.max(0, grossIncome - oldTotalDeductions);
            var oldTaxResult = calculateTaxForSlabs(oldTaxableIncome, oldTaxSlabs);
            var oldIncomeTax = oldTaxResult.tax;
            var oldCess = oldIncomeTax * 0.04;
            var oldTotalTax = oldIncomeTax + oldCess;

            // NEW REGIME CALCULATION (only standard deduction, no other deductions)
            var newTaxableIncome = Math.max(0, grossIncome - standardDeduction);
            var newTaxResult = calculateTaxForSlabs(newTaxableIncome, newTaxSlabs);
            var newIncomeTax = newTaxResult.tax;
            var newCess = newIncomeTax * 0.04;
            var newTotalTax = newIncomeTax + newCess;

            // Update OLD REGIME display
            $("#old-gross-income").text(grossIncome.toFixed(2));
            $("#old-deductions").text(oldTotalDeductions.toFixed(2));
            $("#old-taxable-income").text(oldTaxableIncome.toFixed(2));
            $("#old-income-tax").text(oldIncomeTax.toFixed(2));
            $("#old-cess").text(oldCess.toFixed(2));
            $("#old-total-tax").text(oldTotalTax.toFixed(2));

            // Update NEW REGIME display
            $("#new-gross-income").text(grossIncome.toFixed(2));
            $("#new-standard-ded").text(standardDeduction.toFixed(2));
            $("#new-taxable-income").text(newTaxableIncome.toFixed(2));
            $("#new-income-tax").text(newIncomeTax.toFixed(2));
            $("#new-cess").text(newCess.toFixed(2));
            $("#new-total-tax").text(newTotalTax.toFixed(2));

            // Recommendation
            var savings = Math.abs(oldTotalTax - newTotalTax);
            var recommendationText = "";

            if (oldTotalTax < newTotalTax) {
                recommendationText = "Old Tax Regime is better for you! You save ₹" +
                    savings.toFixed(2) + " by choosing the old regime with deductions.";
                $("#old-regime-card").addClass("selected");
                $("#new-regime-card").removeClass("selected");
            } else if (newTotalTax < oldTotalTax) {
                recommendationText = "New Tax Regime is better for you! You save ₹" +
                    savings.toFixed(2) + " by choosing the new regime with lower tax rates.";
                $("#new-regime-card").addClass("selected");
                $("#old-regime-card").removeClass("selected");
            } else {
                recommendationText = "Both regimes result in the same tax liability. Choose based on your preference.";
                $("#old-regime-card").removeClass("selected");
                $("#new-regime-card").removeClass("selected");
            }

            $("#recommendation-text").text(recommendationText);

            // CHARTS
            // Tax Comparison Chart
            if (comparisonChart) comparisonChart.destroy();
            var ctx1 = document.getElementById('tax-comparison-chart').getContext('2d');
            comparisonChart = new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: ['Old Regime', 'New Regime'],
                    datasets: [{
                        label: 'Total Tax Payable',
                        data: [oldTotalTax, newTotalTax],
                        backgroundColor: ['#4285F4', '#34A853'],
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Tax Amount' }
                        }
                    }
                }
            });

            // Old Regime Slab Chart
            if (oldSlabChart) oldSlabChart.destroy();
            var oldSlabLabels = oldTaxResult.breakdown.map(b => b.slab + " @ " + b.rate);
            var oldSlabData = oldTaxResult.breakdown.map(b => b.tax);

            var ctx2 = document.getElementById('old-slab-chart').getContext('2d');
            oldSlabChart = new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: oldSlabLabels,
                    datasets: [{
                        label: 'Tax per Slab',
                        data: oldSlabData,
                        backgroundColor: '#4285F4',
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Tax Amount' }
                        }
                    }
                }
            });

            // New Regime Slab Chart
            if (newSlabChart) newSlabChart.destroy();
            var newSlabLabels = newTaxResult.breakdown.map(b => b.slab + " @ " + b.rate);
            var newSlabData = newTaxResult.breakdown.map(b => b.tax);

            var ctx3 = document.getElementById('new-slab-chart').getContext('2d');
            newSlabChart = new Chart(ctx3, {
                type: 'bar',
                data: {
                    labels: newSlabLabels,
                    datasets: [{
                        label: 'Tax per Slab',
                        data: newSlabData,
                        backgroundColor: '#34A853',
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: { display: true, text: 'Tax Amount' }
                        }
                    }
                }
            });

            // Income Distribution Chart
            if (incomeDistChart) incomeDistChart.destroy();
            var ctx4 = document.getElementById('income-distribution-chart').getContext('2d');

            var inHandOld = grossIncome - oldTotalTax;
            var inHandNew = grossIncome - newTotalTax;

            incomeDistChart = new Chart(ctx4, {
                type: 'doughnut',
                data: {
                    labels: ['Tax (Old Regime)', 'Tax (New Regime)', 'In-hand (Old)', 'In-hand (New)'],
                    datasets: [{
                        data: [oldTotalTax, newTotalTax, inHandOld, inHandNew],
                        backgroundColor: ['#EA4335', '#FBBC04', '#34A853', '#4285F4'],
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });
        }

        // Event listeners
        $("#annualIncome, #otherIncome, #section80C, #section80D, #section80CCD, #hra, #lta, #homeLoanInterest, #otherDeductions, #standardDeduction").on("input", calculateTax);

        // Initialize on page load
        $(document).ready(function() {
            populateTaxSlabTables();
            calculateTax();
        });
    </script>

    <div class="mt-5">
        <h5 class="card-header">Try Other Calculators</h5>
        <ul>
            <li><a href="tax-calculator.jsp">Income Tax Calculator</a></li>
            <li><a href="retirement-calculator.jsp">Retirement Planning Calculator</a></li>
            <li><a href="sip-calculator.jsp">SIP Calculator</a></li>
            <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
            <li><a href="cinterest2.jsp">Compound Interest Calculator</a></li>
            <li><a href="stock-calc.jsp">Stock Profit Calculator</a></li>
        </ul>
    </div>

    <hr>

    <div class="mt-4">
        <h2>Understanding Income Tax in India</h2>
        <p>Income tax is a tax levied by the government on your income. The tax is calculated based on tax slabs, which define different tax rates for different income ranges.</p>

        <h3>Old vs New Tax Regime</h3>
        <p>Indian taxpayers can choose between two tax regimes:</p>

        <h4>Old Tax Regime</h4>
        <ul>
            <li>Allows various deductions and exemptions (80C, 80D, HRA, LTA, etc.)</li>
            <li>Three tax slabs: 5%, 20%, 30%</li>
            <li>Best for those who can maximize deductions</li>
            <li>Requires documentation for claiming deductions</li>
        </ul>

        <h4>New Tax Regime</h4>
        <ul>
            <li>Lower tax rates but minimal deductions</li>
            <li>More tax slabs: 0%, 5%, 10%, 15%, 20%, 30%</li>
            <li>Only standard deduction of ₹50,000 allowed</li>
            <li>Simpler with less paperwork</li>
            <li>Best for those with limited deductions</li>
        </ul>

        <h3>Common Deductions (Old Regime)</h3>
        <ul>
            <li><strong>Section 80C:</strong> Up to ₹1,50,000 - PPF, EPF, ELSS, Life Insurance, Home Loan Principal</li>
            <li><strong>Section 80D:</strong> Up to ₹25,000 - Health Insurance Premium (₹50,000 for senior citizens)</li>
            <li><strong>Section 80CCD(1B):</strong> Additional ₹50,000 - NPS contributions</li>
            <li><strong>Section 24:</strong> Up to ₹2,00,000 - Home Loan Interest</li>
            <li><strong>HRA:</strong> Exemption on House Rent Allowance</li>
            <li><strong>LTA:</strong> Leave Travel Allowance exemption</li>
            <li><strong>Standard Deduction:</strong> ₹50,000 for salaried individuals</li>
        </ul>

        <h3>Tax Saving Tips</h3>
        <ul>
            <li><strong>Maximize 80C:</strong> Invest in ELSS, PPF, EPF to claim ₹1.5 lakh deduction</li>
            <li><strong>Health Insurance:</strong> Buy health insurance for yourself and parents for 80D benefit</li>
            <li><strong>NPS:</strong> Additional ₹50,000 deduction under 80CCD(1B)</li>
            <li><strong>Home Loan:</strong> Claim both principal (80C) and interest (24) deductions</li>
            <li><strong>Choose Right Regime:</strong> Calculate tax under both regimes and choose the beneficial one</li>
            <li><strong>Plan Early:</strong> Start tax planning at the beginning of financial year</li>
        </ul>

        <h3>Who Should Choose Old Regime?</h3>
        <ul>
            <li>Those with home loans (interest deduction)</li>
            <li>Those investing heavily in 80C instruments</li>
            <li>Those claiming HRA exemption</li>
            <li>Higher deductions available (typically total deductions > ₹2.5 lakhs)</li>
        </ul>

        <h3>Who Should Choose New Regime?</h3>
        <ul>
            <li>Those with minimal investments and deductions</li>
            <li>Those who prefer simplicity over documentation</li>
            <li>Lower income individuals (below ₹7.5 lakhs)</li>
            <li>Those not claiming HRA or home loan benefits</li>
        </ul>

        <h3>Important Notes</h3>
        <ul>
            <li>Health and Education Cess: 4% on income tax</li>
            <li>Rebate under Section 87A: Up to ₹12,500 if income is below ₹5 lakhs (new regime: ₹7 lakhs)</li>
            <li>TDS: Tax Deducted at Source on salary</li>
            <li>You can switch between regimes every year (except for business income)</li>
        </ul>

        <p class="alert alert-warning"><strong>Disclaimer:</strong> This calculator provides estimates based on standard tax slabs. Actual tax liability may vary based on specific circumstances. Tax laws change periodically. Please consult a tax professional or refer to official government sources for accurate tax planning.</p>
    </div>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
