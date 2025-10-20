<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dividend Reinvestment (DRIP) Calculator – Dividend Growth & Income</title>
    <meta name="description" content="Estimate portfolio value, shares accumulated, and dividend income with DRIP. Model dividend yield, dividend growth, price growth, tax, frequency, and contributions.">
    <meta name="keywords" content="dividend reinvestment calculator, DRIP calculator, dividend growth calculator, dividend income calculator, reinvest dividends, dividend yield">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Dividend Reinvestment (DRIP) Calculator",
      "applicationCategory": "FinanceApplication",
      "description": "Estimate portfolio value, shares accumulated, and dividend income with DRIP, including dividend growth, price growth, tax, and frequency settings.",
      "url": "https://8gwifi.org/drip-calculator.jsp",
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
    <h1 class="mb-4">Dividend Reinvestment (DRIP) Calculator</h1>
    <p>Project your dividend portfolio with reinvested dividends. Adjust dividend yield and growth, price growth, payout frequency, dividend tax, and contributions to see how your income and portfolio value grow over time.</p>

    <form id="drip-form">
        <div class="row">
            <div class="col-lg-5">

                <div class="card mb-3">
                    <div class="card-header">Investment & Settings</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <input type="text" class="form-control" id="currencyCode" value="USD">
                            </div>
                            <div class="form-group col-6">
                                <label for="years">Years</label>
                                <input type="number" class="form-control" id="years" value="20">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="initialInvestment">Initial Investment</label>
                                <input type="number" class="form-control" id="initialInvestment" value="10000">
                            </div>
                            <div class="form-group col-6">
                                <label for="monthlyContribution">Monthly Contribution</label>
                                <input type="number" class="form-control" id="monthlyContribution" value="200">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="startPrice">Starting Share Price</label>
                                <input type="number" class="form-control" id="startPrice" value="50">
                            </div>
                            <div class="form-group col-6">
                                <label for="priceGrowth">Price Growth (% p.a.)</label>
                                <input type="number" class="form-control" id="priceGrowth" value="6" step="0.1">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="divYield">Dividend Yield (% p.a.)</label>
                                <input type="number" class="form-control" id="divYield" value="3" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="divGrowth">Dividend Growth (% p.a.)</label>
                                <input type="number" class="form-control" id="divGrowth" value="5" step="0.1">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="frequency">Dividend Frequency</label>
                                <select class="form-control" id="frequency">
                                    <option value="annual">Annual</option>
                                    <option value="semiannual">Semi-Annual</option>
                                    <option value="quarterly" selected>Quarterly</option>
                                    <option value="monthly">Monthly</option>
                                </select>
                            </div>
                            <div class="form-group col-6">
                                <label for="divTax">Dividend Tax (% of dividends)</label>
                                <input type="number" class="form-control" id="divTax" value="0" step="0.1">
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="reinvest" checked>
                                <label class="form-check-label" for="reinvest">Reinvest Dividends (DRIP)</label>
                            </div>
                            <small class="text-muted">If unchecked, dividends accumulate as cash and are not reinvested.</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Dividends are calculated from current dividend per share (DPS) which grows annually; yield shown is at year 0.</li>
                        <li>Price growth is applied monthly; dividends are paid at the selected frequency and taxed before reinvestment.</li>
                        <li>Results are estimates; market behavior and taxes vary.</li>
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
                                    <div><strong>Final Portfolio Value</strong></div>
                                    <div id="finalValue" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Shares: <span id="finalShares">—</span></small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Annual Dividend (Final Year)</strong></div>
                                    <div id="finalIncome" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Cumulative Dividends (net): <span id="cumDivNet">—</span></small>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Cumulative dividends are net of tax. Final income is based on the last-year DPS and final shares.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Value & Dividend Income Over Time</div>
                    <div class="card-body">
                        <canvas id="drip-chart" height="160"></canvas>
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
                        <th>Shares</th>
                        <th>Price</th>
                        <th>Portfolio Value</th>
                        <th>Dividends (Gross)</th>
                        <th>Dividends (Net)</th>
                        <th>Contributions</th>
                    </tr>
                </thead>
                <tbody id="drip-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var dripChart = null;

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
    }
    function fmt(x) { return Number(x).toLocaleString('en-IN', { maximumFractionDigits: 2 }); }

    function recalcDRIP() {
        var curr = ($("#currencyCode").val() || "USD").toUpperCase();
        var years = parseInt($("#years").val()) || 0;
        var initInv = parseFloat($("#initialInvestment").val()) || 0;
        var monthlyContrib = parseFloat($("#monthlyContribution").val()) || 0;
        var startPrice = parseFloat($("#startPrice").val()) || 0;
        var priceGrowth = (parseFloat($("#priceGrowth").val()) || 0) / 100.0;
        var divYield = (parseFloat($("#divYield").val()) || 0) / 100.0;
        var divGrowth = (parseFloat($("#divGrowth").val()) || 0) / 100.0;
        var freq = $("#frequency").val();
        var divTax = (parseFloat($("#divTax").val()) || 0) / 100.0;
        var reinvest = $("#reinvest").is(":checked");

        if (years <= 0 || startPrice <= 0) {
            $("#finalValue, #finalShares, #finalIncome, #cumDivNet").text("—");
            $("#drip-table").html("");
            if (dripChart) { dripChart.destroy(); dripChart = null; }
            return;
        }

        var periodsPerYear = (freq === "monthly") ? 12 : (freq === "quarterly") ? 4 : (freq === "semiannual") ? 2 : 1;
        var months = years * 12;
        var priceMonthlyGrowth = Math.pow(1 + priceGrowth, 1/12) - 1;

        // Initial shares from initial investment
        var shares = (initInv > 0) ? (initInv / startPrice) : 0;
        var price = startPrice;

        // DPS at year 0 from yield: DPS0 = yield * price0
        var dpsAnnual = divYield * startPrice;

        var cumDivGross = 0;
        var cumDivNet = 0;
        var contribSum = initInv;

        var labels = [];
        var valueSeries = [];
        var incomeSeries = [];
        var tableHTML = "";

        for (var m = 1; m <= months; m++) {
            // Monthly price growth
            price = price * (1 + priceMonthlyGrowth);

            // Monthly contribution buys shares at current price
            if (monthlyContrib > 0) {
                shares += monthlyContrib / price;
                contribSum += monthlyContrib;
            }

            // Dividend payout if this month aligns with frequency (approximate by month index)
            var pay = false;
            if (periodsPerYear === 12) {
                pay = true;
            } else if (periodsPerYear === 4 && (m % 3 === 0)) {
                pay = true;
            } else if (periodsPerYear === 2 && (m % 6 === 0)) {
                pay = true;
            } else if (periodsPerYear === 1 && (m % 12 === 0)) {
                pay = true;
            }

            if (pay) {
                var divThisPeriodGross = shares * (dpsAnnual / periodsPerYear);
                var divThisPeriodNet = divThisPeriodGross * (1 - divTax);
                cumDivGross += divThisPeriodGross;
                cumDivNet += divThisPeriodNet;

                if (reinvest && divThisPeriodNet > 0) {
                    // Reinvest at current price
                    shares += divThisPeriodNet / price;
                }
            }

            // At year end, grow DPS annually
            if (m % 12 === 0) {
                var year = m / 12;
                // annual income based on current DPS and current shares
                var annualIncomeGross = shares * dpsAnnual;
                var annualIncomeNet = annualIncomeGross * (1 - divTax);

                labels.push("Year " + year);
                valueSeries.push(shares * price);
                incomeSeries.push(annualIncomeNet);

                tableHTML += "<tr>" +
                    "<td>" + year + "</td>" +
                    "<td>" + fmt(shares) + "</td>" +
                    "<td>" + fmtCurr(price, curr) + "</td>" +
                    "<td><strong>" + fmtCurr(shares * price, curr) + "</strong></td>" +
                    "<td>" + fmtCurr(annualIncomeGross, curr) + "</td>" +
                    "<td><strong>" + fmtCurr(annualIncomeNet, curr) + "</strong></td>" +
                    "<td>" + fmtCurr(contribSum, curr) + "</td>" +
                    "</tr>";

                // Increase DPS for next year by dividend growth
                dpsAnnual = dpsAnnual * (1 + divGrowth);
            }
        }

        // Final outputs
        var finalValue = (shares * price);
        var finalIncomeNet = incomeSeries.length > 0 ? incomeSeries[incomeSeries.length - 1] : 0;

        $("#finalValue").text(fmtCurr(finalValue, curr));
        $("#finalShares").text(fmt(shares));
        $("#finalIncome").text(fmtCurr(finalIncomeNet, curr));
        $("#cumDivNet").text(fmtCurr(cumDivNet, curr));

        $("#drip-table").html(tableHTML);

        // Chart
        if (dripChart) dripChart.destroy();
        var ctx = document.getElementById("drip-chart").getContext("2d");
        dripChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "Portfolio Value",
                        data: valueSeries,
                        borderColor: "#1565c0",
                        backgroundColor: "rgba(21,101,192,0.1)",
                        tension: 0.15
                    },
                    {
                        label: "Annual Dividend (Net)",
                        data: incomeSeries,
                        borderColor: "#2e7d32",
                        backgroundColor: "rgba(46,125,50,0.1)",
                        tension: 0.15,
                        yAxisID: "y1"
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: "top" } },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: "Portfolio Value" }
                    },
                    y1: {
                        beginAtZero: true,
                        position: "right",
                        grid: { drawOnChartArea: false },
                        title: { display: true, text: "Annual Dividend (Net)" }
                    },
                    x: { title: { display: true, text: "Year" } }
                }
            }
        });
    }

    $("#currencyCode, #years, #initialInvestment, #monthlyContribution, #startPrice, #priceGrowth, #divYield, #divGrowth, #frequency, #divTax, #reinvest")
        .on("input change", recalcDRIP);

    // Initial calculation
    recalcDRIP();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
