<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rent vs Buy Calculator (India) – Break-even, Net Worth, and Total Cost</title>
    <meta name="description" content="Compare renting vs buying a house in India. Estimate break-even year, net worth over time, and the total cost of ownership based on home price, rent, loan rate, appreciation, and investment returns.">
    <meta name="keywords" content="rent vs buy calculator, rent or buy, total cost of ownership, home loan vs rent, break-even rent vs buy, India housing calculator">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Rent vs Buy Calculator (India)",
      "applicationCategory": "FinanceApplication",
      "description": "Compare renting vs buying a house in India with break-even, net worth, and cost analysis.",
      "url": "https://8gwifi.org/rent-vs-buy-calculator.jsp",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Rent vs Buy Calculator (India)</h1>
    <p>Compare renting vs buying over your chosen time horizon. This tool models loan amortization, property appreciation, rent escalation, maintenance, and investment growth to estimate which option builds higher net worth and when buying may break even.</p>

    <form id="rvb-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Property & Financing</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="propertyPrice">Property Price (₹)</label>
                            <input type="number" class="form-control" id="propertyPrice" value="10000000">
                        </div>
                        <div class="form-group">
                            <label for="downPaymentPct">Down Payment (%)</label>
                            <input type="number" class="form-control" id="downPaymentPct" value="20" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="loanRate">Home Loan Interest Rate (% p.a.)</label>
                            <input type="number" class="form-control" id="loanRate" value="9" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="loanTenureYears">Loan Tenure (years)</label>
                            <input type="number" class="form-control" id="loanTenureYears" value="20">
                        </div>
                        <div class="form-group">
                            <label for="purchaseCostsPct">Purchase Costs (Stamp, Registration, Brokerage) (% of price)</label>
                            <input type="number" class="form-control" id="purchaseCostsPct" value="7" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="sellingCostsPct">Selling/Exit Costs (% of value)</label>
                            <input type="number" class="form-control" id="sellingCostsPct" value="2" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="appreciationRate">Property Appreciation (% p.a.)</label>
                            <input type="number" class="form-control" id="appreciationRate" value="5" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="maintenancePct">Maintenance (% of property value per year)</label>
                            <input type="number" class="form-control" id="maintenancePct" value="1" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="propertyTaxPct">Property Tax (% of property value per year)</label>
                            <input type="number" class="form-control" id="propertyTaxPct" value="0.2" step="0.1">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Rent & Investing</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="rentMonthly">Current Monthly Rent (₹)</label>
                            <input type="number" class="form-control" id="rentMonthly" value="25000">
                        </div>
                        <div class="form-group">
                            <label for="rentEscalationPct">Rent Escalation (% per year)</label>
                            <input type="number" class="form-control" id="rentEscalationPct" value="5" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="investmentReturnPct">Investment Return (% p.a.)</label>
                            <input type="number" class="form-control" id="investmentReturnPct" value="10" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="horizonYears">Time Horizon (years)</label>
                            <input type="number" class="form-control" id="horizonYears" value="20">
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Rent scenario invests the avoided down payment and purchase costs upfront, and invests yearly surplus if renting is cheaper than owning.</li>
                        <li>Buy scenario net worth reflects equity if sold (after subtracting selling/exit costs).</li>
                        <li>Loan amortization is simulated monthly; other cash flows are annual.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Summary</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Recommendation</strong></div>
                                    <div id="recommendation" style="font-size:1.25rem;"></div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Break-even Year</strong></div>
                                    <div id="breakeven" style="font-size:1.25rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Net Worth at Horizon (Buy)</strong></div>
                                    <div id="networth-buy" style="font-size:1.25rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Net Worth at Horizon (Rent + Invest)</strong></div>
                                    <div id="networth-rent" style="font-size:1.25rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Net worth values assume a sale at the end of each year for comparability (selling/exit costs applied).</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Net Worth Over Time</div>
                    <div class="card-body">
                        <canvas id="networth-chart" height="140"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <div class="mt-4">
        <h4>Year-wise Breakdown</h4>
        <div style="max-height: 420px; overflow-y: auto;">
            <table class="table table-striped">
                <thead style="position: sticky; top: 0; background-color: white;">
                    <tr>
                        <th>Year</th>
                        <th>Property Value (₹)</th>
                        <th>Outstanding Loan (₹)</th>
                        <th>Buy Net Worth if Sold (₹)</th>
                        <th>Annual Rent Paid (₹)</th>
                        <th>Invested Corpus (₹)</th>
                    </tr>
                </thead>
                <tbody id="rvb-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var networthChart = null;

    function fmtINR(x) {
        if (isNaN(x)) return "—";
        try {
            return "₹ " + Number(x).toLocaleString('en-IN', { maximumFractionDigits: 0 });
        } catch (e) {
            return "₹ " + (Math.round(Number(x))).toString();
        }
    }

    function calculateRentVsBuy() {
        // Read inputs
        var price = parseFloat($("#propertyPrice").val()) || 0;
        var dpPct = (parseFloat($("#downPaymentPct").val()) || 0) / 100.0;
        var loanRateAnnual = (parseFloat($("#loanRate").val()) || 0) / 100.0;
        var tenureYears = parseInt($("#loanTenureYears").val()) || 0;
        var purchasePct = (parseFloat($("#purchaseCostsPct").val()) || 0) / 100.0;
        var sellingPct = (parseFloat($("#sellingCostsPct").val()) || 0) / 100.0;
        var appr = (parseFloat($("#appreciationRate").val()) || 0) / 100.0;
        var maintPct = (parseFloat($("#maintenancePct").val()) || 0) / 100.0;
        var taxPct = (parseFloat($("#propertyTaxPct").val()) || 0) / 100.0;

        var rentMonthly = parseFloat($("#rentMonthly").val()) || 0;
        var rentEsc = (parseFloat($("#rentEscalationPct").val()) || 0) / 100.0;
        var invRet = (parseFloat($("#investmentReturnPct").val()) || 0) / 100.0;
        var horizon = parseInt($("#horizonYears").val()) || 0;

        if (price <= 0 || horizon <= 0 || tenureYears < 0) {
            // Clear outputs if inputs invalid
            $("#recommendation").text("—");
            $("#breakeven").text("—");
            $("#networth-buy").text("—");
            $("#networth-rent").text("—");
            $("#rvb-table").html("");
            if (networthChart) { networthChart.destroy(); networthChart = null; }
            return;
        }

        // Loan setup
        var downPayment = price * dpPct;
        var loanPrincipal = Math.max(0, price - downPayment);
        var purchaseCosts = price * purchasePct;
        var sellingCostRate = sellingPct;

        var monthlyRate = loanRateAnnual / 12.0;
        var totalMonths = Math.max(0, tenureYears * 12);
        var emi = 0;
        if (loanPrincipal > 0 && monthlyRate > 0 && totalMonths > 0) {
            emi = loanPrincipal * monthlyRate * Math.pow(1 + monthlyRate, totalMonths) / (Math.pow(1 + monthlyRate, totalMonths) - 1);
        } else if (loanPrincipal > 0 && totalMonths > 0) {
            emi = loanPrincipal / totalMonths;
        }

        // Initial values
        var outstanding = loanPrincipal;
        var propValue = price;
        var monthsLeft = totalMonths;

        // Rent-invest scenario
        var investCorpus = downPayment + purchaseCosts; // upfront avoided cost invested
        var currentRentMonthly = rentMonthly;

        // Outputs
        var labels = [];
        var buyNW = [];
        var rentNW = [];
        var tableHTML = "";
        var breakevenYear = null;

        for (var year = 1; year <= horizon; year++) {
            var propValueStart = propValue;

            // Amortization for the year
            var monthsThisYear = Math.min(12, Math.max(0, monthsLeft));
            var annualEMI = 0;
            for (var m = 0; m < monthsThisYear; m++) {
                var interest = outstanding * monthlyRate;
                var principal = emi - interest;
                if (principal > outstanding) {
                    principal = outstanding;
                }
                outstanding = Math.max(0, outstanding - principal);
                annualEMI += (interest + principal);
            }
            monthsLeft -= monthsThisYear;

            // Ownership annual costs (maintenance and property tax based on start-of-year value)
            var maintenance = propValueStart * maintPct;
            var propTax = propValueStart * taxPct;

            var ownershipAnnualCash = annualEMI + maintenance + propTax;

            // Rent annual cost
            var rentAnnual = currentRentMonthly * 12;

            // Rent surplus invested (can be negative if rent > ownership cash)
            var annualContribution = ownershipAnnualCash - rentAnnual;
            investCorpus = (investCorpus + annualContribution) * (1 + invRet);

            // Property appreciates by year end
            propValue = propValueStart * (1 + appr);

            // Equity if sold now (after selling cost)
            var equityIfSold = propValue - outstanding - (propValue * sellingCostRate);
            if (equityIfSold < 0) equityIfSold = 0;

            labels.push("Year " + year);
            buyNW.push(equityIfSold);
            rentNW.push(Math.max(0, investCorpus));

            if (breakevenYear === null && equityIfSold >= investCorpus) {
                breakevenYear = year;
            }

            tableHTML += "<tr>" +
                "<td>" + year + "</td>" +
                "<td>" + fmtINR(propValue) + "</td>" +
                "<td>" + fmtINR(outstanding) + "</td>" +
                "<td><strong>" + fmtINR(equityIfSold) + "</strong></td>" +
                "<td>" + fmtINR(rentAnnual) + "</td>" +
                "<td><strong>" + fmtINR(investCorpus) + "</strong></td>" +
                "</tr>";

            // Escalate rent for next year
            currentRentMonthly = currentRentMonthly * (1 + rentEsc);
        }

        // Final results
        var finalBuy = buyNW[buyNW.length - 1] || 0;
        var finalRent = rentNW[rentNW.length - 1] || 0;

        var recText = "";
        if (finalBuy > finalRent) {
            recText = "Buy (+" + fmtINR(finalBuy - finalRent).replace("₹ ", "") + " vs Rent at horizon)";
        } else if (finalRent > finalBuy) {
            recText = "Rent (+" + fmtINR(finalRent - finalBuy).replace("₹ ", "") + " vs Buy at horizon)";
        } else {
            recText = "Both are similar at horizon";
        }

        $("#recommendation").text(recText);
        $("#breakeven").text(breakevenYear ? ("Year " + breakevenYear) : "No break-even within horizon");
        $("#networth-buy").text(fmtINR(finalBuy));
        $("#networth-rent").text(fmtINR(finalRent));
        $("#rvb-table").html(tableHTML);

        // Chart
        if (networthChart) {
            networthChart.destroy();
        }
        var ctx = document.getElementById('networth-chart').getContext('2d');
        networthChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [
                    {
                        label: 'Buy – Net Worth',
                        data: buyNW,
                        borderColor: '#1b5e20',
                        backgroundColor: 'rgba(27, 94, 32, 0.1)',
                        tension: 0.15
                    },
                    {
                        label: 'Rent + Invest – Net Worth',
                        data: rentNW,
                        borderColor: '#1565c0',
                        backgroundColor: 'rgba(21, 101, 192, 0.1)',
                        tension: 0.15
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },
                    tooltip: {
                        callbacks: {
                            label: function(ctx) {
                                return ctx.dataset.label + ": " + fmtINR(ctx.parsed.y);
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return "₹ " + Number(value).toLocaleString('en-IN'); }
                        },
                        title: { display: true, text: 'Net Worth (₹)' }
                    },
                    x: {
                        title: { display: true, text: 'Year' }
                    }
                }
            }
        });
    }

    // Attach events
    $("#propertyPrice, #downPaymentPct, #loanRate, #loanTenureYears, #purchaseCostsPct, #sellingCostsPct, #appreciationRate, #maintenancePct, #propertyTaxPct, #rentMonthly, #rentEscalationPct, #investmentReturnPct, #horizonYears")
        .on("input", calculateRentVsBuy);

    // Initial run
    calculateRentVsBuy();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
