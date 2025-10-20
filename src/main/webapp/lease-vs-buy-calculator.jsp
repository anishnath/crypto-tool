<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lease vs Buy Calculator (Car/Equipment) – Total Cost & Breakeven</title>
    <meta name="description" content="Compare leasing vs buying a car or equipment. Estimate total cost over your horizon including financing, taxes, fees, maintenance, depreciation, mileage overage, and investing the difference.">
    <meta name="keywords" content="lease vs buy calculator, car lease vs buy, equipment lease vs buy, total cost of ownership, lease calculator, buy calculator, depreciation">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Lease vs Buy Calculator (Car/Equipment)",
      "applicationCategory": "FinanceApplication",
      "description": "Compare leasing vs buying a car or equipment with taxes, fees, financing, maintenance, depreciation, and investing the difference.",
      "url": "https://8gwifi.org/lease-vs-buy-calculator.jsp",
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
    <h1 class="mb-4">Lease vs Buy Calculator (Car/Equipment)</h1>
    <p>Compare the total cost of leasing vs buying over your chosen horizon. The model includes financing, taxes and fees, maintenance, depreciation, mileage overage, and an optional “invest the difference” scenario.</p>

    <form id="lvb-form">
        <div class="row">
            <div class="col-lg-5">

                <div class="card mb-3">
                    <div class="card-header">Settings & Horizon</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <input type="text" class="form-control" id="currencyCode" value="USD">
                            </div>
                            <div class="form-group col-6">
                                <label for="horizonYears">Horizon (years)</label>
                                <input type="number" class="form-control" id="horizonYears" value="3">
                                <small class="text-muted">Commonly 2–4 years for leases</small>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="investDiff" checked>
                                <label class="form-check-label" for="investDiff">Invest the cash-flow difference</label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="investReturn">Investment Return (% p.a.)</label>
                            <input type="number" class="form-control" id="investReturn" value="6" step="0.1">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Buy Parameters</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="buyPrice">Purchase Price</label>
                            <input type="number" class="form-control" id="buyPrice" value="30000">
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="buyDown">Down Payment</label>
                                <input type="number" class="form-control" id="buyDown" value="5000">
                            </div>
                            <div class="form-group col-6">
                                <label for="salesTaxPct">Sales Tax (% of price, upfront)</label>
                                <input type="number" class="form-control" id="salesTaxPct" value="8" step="0.1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="buyFees">Upfront Fees (doc/reg/etc.)</label>
                                <input type="number" class="form-control" id="buyFees" value="500">
                            </div>
                            <div class="form-group col-6">
                                <label for="loanApr">Loan APR (% p.a.)</label>
                                <input type="number" class="form-control" id="loanApr" value="7" step="0.1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="loanTermYears">Loan Term (years)</label>
                                <input type="number" class="form-control" id="loanTermYears" value="5">
                            </div>
                            <div class="form-group col-6">
                                <label for="deprPct">Depreciation (% per year)</label>
                                <input type="number" class="form-control" id="deprPct" value="15" step="0.1">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="maintBuy">Maintenance (per year)</label>
                            <input type="number" class="form-control" id="maintBuy" value="600">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Lease Parameters</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="leaseMonthly">Lease Monthly Payment</label>
                                <input type="number" class="form-control" id="leaseMonthly" value="400">
                            </div>
                            <div class="form-group col-6">
                                <label for="leaseTermMonths">Lease Term (months)</label>
                                <input type="number" class="form-control" id="leaseTermMonths" value="36">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="leaseDriveOff">Drive-off / Down (lease)</label>
                                <input type="number" class="form-control" id="leaseDriveOff" value="2000">
                            </div>
                            <div class="form-group col-6">
                                <label for="leaseAcq">Acquisition Fee (lease)</label>
                                <input type="number" class="form-control" id="leaseAcq" value="650">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="leaseDisp">Disposition Fee (end)</label>
                                <input type="number" class="form-control" id="leaseDisp" value="350">
                            </div>
                            <div class="form-group col-6">
                                <label for="maintLease">Maintenance (per year)</label>
                                <input type="number" class="form-control" id="maintLease" value="400">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="milesAllow">Miles Allowance (per year)</label>
                                <input type="number" class="form-control" id="milesAllow" value="12000">
                            </div>
                            <div class="form-group col-6">
                                <label for="milesActual">Expected Miles (per year)</label>
                                <input type="number" class="form-control" id="milesActual" value="15000">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="overMileFee">Overage Fee (per mile)</label>
                            <input type="number" class="form-control" id="overMileFee" value="0.25" step="0.01">
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Buy cost includes loan payments, upfront taxes/fees/down, maintenance, minus resale value; if loan not fully paid by horizon, remaining balance is added.</li>
                        <li>Lease cost includes drive-off, acquisition and disposition fees, monthly payments, overage, and maintenance.</li>
                        <li>“Invest the difference” assumes surplus cash flows grow at the chosen rate.</li>
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
                                    <div><strong>Total Cost – Buy</strong></div>
                                    <div id="costBuy" style="font-size:1.25rem;">—</div>
                                    <small class="text-muted">Includes payments, upfront, maintenance, loan balance; less resale</small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Total Cost – Lease</strong></div>
                                    <div id="costLease" style="font-size:1.25rem;">—</div>
                                    <small class="text-muted">Includes fees, payments, maintenance, overage</small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-12 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Recommendation</strong></div>
                                    <div id="recommendation" style="font-size:1.1rem;">—</div>
                                    <small class="text-muted">With investment effect: <span id="investEffect">—</span></small>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Estimates only. Taxes/insurance variations and market values can differ.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Cost Components</div>
                    <div class="card-body">
                        <canvas id="lvb-chart" height="160"></canvas>
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
                        <th>Loan Balance (Buy)</th>
                        <th>Vehicle Value (Buy)</th>
                        <th>Cumulative Cost – Buy</th>
                        <th>Cumulative Cost – Lease</th>
                        <th>Invested Difference</th>
                    </tr>
                </thead>
                <tbody id="lvb-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var lvbChart = null;

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
    }

    function payment(loan, monthlyRate, months) {
        if (loan <= 0) return 0;
        if (monthlyRate <= 0) return loan / months;
        var pow = Math.pow(1 + monthlyRate, months);
        return loan * monthlyRate * pow / (pow - 1);
    }

    function recalcLVB() {
        var curr = ($("#currencyCode").val() || "USD").toUpperCase();
        var horizonYears = parseInt($("#horizonYears").val()) || 0;
        var investDiff = $("#investDiff").is(":checked");
        var investReturn = (parseFloat($("#investReturn").val()) || 0) / 100.0;

        var buyPrice = parseFloat($("#buyPrice").val()) || 0;
        var buyDown = parseFloat($("#buyDown").val()) || 0;
        var salesTaxPct = (parseFloat($("#salesTaxPct").val()) || 0) / 100.0;
        var buyFees = parseFloat($("#buyFees").val()) || 0;
        var loanApr = (parseFloat($("#loanApr").val()) || 0) / 100.0;
        var loanTermYears = parseInt($("#loanTermYears").val()) || 0;
        var deprPct = (parseFloat($("#deprPct").val()) || 0) / 100.0;
        var maintBuy = parseFloat($("#maintBuy").val()) || 0;

        var leaseMonthly = parseFloat($("#leaseMonthly").val()) || 0;
        var leaseTermMonths = parseInt($("#leaseTermMonths").val()) || 0;
        var leaseDriveOff = parseFloat($("#leaseDriveOff").val()) || 0;
        var leaseAcq = parseFloat($("#leaseAcq").val()) || 0;
        var leaseDisp = parseFloat($("#leaseDisp").val()) || 0;
        var maintLease = parseFloat($("#maintLease").val()) || 0;
        var milesAllow = parseFloat($("#milesAllow").val()) || 0;
        var milesActual = parseFloat($("#milesActual").val()) || 0;
        var overMileFee = parseFloat($("#overMileFee").val()) || 0;

        if (horizonYears <= 0 || buyPrice <= 0) {
            $("#costBuy, #costLease, #recommendation, #investEffect").text("—");
            $("#lvb-table").html("");
            if (lvbChart) { lvbChart.destroy(); lvbChart = null; }
            return;
        }

        var months = horizonYears * 12;

        // Buy scenario
        var upfrontTax = buyPrice * salesTaxPct;
        var upfront = buyDown + buyFees + upfrontTax;
        var loanPrincipal = Math.max(0, buyPrice - buyDown);
        var mRate = loanApr / 12.0;
        var loanMonths = Math.max(0, loanTermYears * 12);
        var emi = payment(loanPrincipal, mRate, loanMonths);

        var balance = loanPrincipal;
        var cumPayments = 0;
        var cumCostBuy = upfront;
        var cumCostLease = leaseDriveOff + leaseAcq; // start with lease upfronts
        var invested = 0;

        var labels = [];
        var tableHTML = [];
        var valueSeriesBuy = 0;

        var leaseMonthsPaid = Math.min(months, leaseTermMonths);

        for (var m = 1; m <= months; m++) {
            // Buy monthly loan payment if within term
            if (m <= loanMonths && balance > 0) {
                var interest = balance * mRate;
                var principal = Math.min(emi - interest, balance);
                if (principal < 0) principal = 0;
                balance = Math.max(0, balance - principal);
                cumPayments += (principal + interest);
                cumCostBuy += (principal + interest);
            }

            // Lease monthly payment if within lease term
            if (m <= leaseMonthsPaid) {
                cumCostLease += leaseMonthly;
            }

            // Maintenance monthly allocations
            cumCostBuy += (maintBuy / 12.0);
            cumCostLease += (maintLease / 12.0);

            // Invest difference: positive surplus invested
            if (investDiff) {
                var buyOutflowMonthly = ((m <= loanMonths) ? emi : 0) + (maintBuy / 12.0);
                var leaseOutflowMonthly = ((m <= leaseMonthsPaid) ? leaseMonthly : 0) + (maintLease / 12.0);
                var surplus = buyOutflowMonthly - leaseOutflowMonthly;

                // initial month: account for upfront deltas (buy upfront vs lease upfront)
                if (m === 1) {
                    var upfrontDelta = upfront - (leaseDriveOff + leaseAcq);
                    // If buy spends more upfront than lease, leasing frees cash: invest positive if upfrontDelta > 0
                    // We consider surplusFromLease = upfrontDelta > 0 ? upfrontDelta : 0
                    var investInit = Math.max(0, upfrontDelta);
                    invested = (invested + investInit) * (1 + investReturn/12.0);
                }

                // Each month invest positive surplus (if buying costs more monthly, leasing invests; vice versa none)
                if (surplus > 0) {
                    invested = (invested + surplus) * (1 + investReturn/12.0);
                } else {
                    invested = invested * (1 + investReturn/12.0);
                }
            }

            // Yearly snapshot
            if (m % 12 === 0) {
                var year = m / 12;
                // Vehicle value using straight depreciation
                var vehicleVal = buyPrice * Math.pow(1 - deprPct, year);

                // At lease end, add disposition fee and mileage overage once
                if (m === leaseMonthsPaid) {
                    var extraMilesPerYear = Math.max(0, milesActual - milesAllow);
                    var overage = (extraMilesPerYear * (leaseMonthsPaid/12)) * overMileFee;
                    cumCostLease += leaseDisp + overage;
                }

                labels.push("Year " + year);
                var row = "<tr>" +
                    "<td>" + year + "</td>" +
                    "<td>" + fmtCurr(balance, curr) + "</td>" +
                    "<td>" + fmtCurr(vehicleVal, curr) + "</td>" +
                    "<td>" + fmtCurr(cumCostBuy - vehicleVal + (balance > 0 && m >= months ? balance : 0), curr) + "</td>" +
                    "<td>" + fmtCurr(cumCostLease, curr) + "</td>" +
                    "<td>" + fmtCurr(invested, curr) + "</td>" +
                    "</tr>";
                tableHTML += row;
            }
        }

        // Final vehicle value and remaining balance adjustment at horizon
        var years = months / 12.0;
        var vehicleValEnd = buyPrice * Math.pow(1 - deprPct, years);

        // Overages if lease did not end on a year boundary
        if (months < leaseTermMonths) {
            // partial lease, approximate disposition and overage at horizon
            var partialYears = months / 12.0;
            var extraMilesPerYear2 = Math.max(0, milesActual - milesAllow);
            var overage2 = (extraMilesPerYear2 * partialYears) * overMileFee;
            cumCostLease += leaseDisp + overage2;
        } else if (months > leaseTermMonths && leaseTermMonths > 0) {
            // If horizon exceeds lease term, assume single lease cycle (no new lease)
            // Already added disposition and overage at lease end in yearly snapshot if aligned.
        }

        var totalCostBuy = cumCostBuy - vehicleValEnd + (balance > 0 ? balance : 0);
        var totalCostLease = cumCostLease;

        $("#costBuy").text(fmtCurr(totalCostBuy, curr));
        $("#costLease").text(fmtCurr(totalCostLease, curr));

        var rec = "";
        if (totalCostBuy < totalCostLease) {
            rec = "Buy may be better by " + fmtCurr(totalCostLease - totalCostBuy, curr);
        } else if (totalCostLease < totalCostBuy) {
            rec = "Lease may be better by " + fmtCurr(totalCostBuy - totalCostLease, curr);
        } else {
            rec = "Both options appear similar over this horizon.";
        }
        $("#recommendation").text(rec);

        if (investDiff) {
            $("#investEffect").text("Investment value of surplus: " + fmtCurr(invested, curr));
        } else {
            $("#investEffect").text("—");
        }

        $("#lvb-table").html(tableHTML);

        // Build chart (components)
        if (lvbChart) lvbChart.destroy();

        // Estimate components
        var compBuyPayments = Math.min(months, loanMonths) > 0 ? (Math.min(months, loanMonths) * payment(loanPrincipal, mRate, loanMonths)) : 0;
        var compBuyUpfront = upfront;
        var compBuyMaint = maintBuy * years;
        var compBuyResale = vehicleValEnd;
        var compBuyLoanBal = balance;

        var compLeaseUpfront = leaseDriveOff + leaseAcq + leaseDisp;
        var compLeasePayments = leaseMonthly * Math.min(months, leaseTermMonths);
        var compLeaseMaint = maintLease * years;
        var compLeaseOverage = Math.max(0, (milesActual - milesAllow)) * years * overMileFee;

        var ctx = document.getElementById("lvb-chart").getContext("2d");
        lvbChart = new Chart(ctx, {
            type: "bar",
            data: {
                labels: ["Buy", "Lease"],
                datasets: [
                    { label: "Payments", data: [compBuyPayments, compLeasePayments], backgroundColor: "rgba(21,101,192,0.7)" },
                    { label: "Upfront Fees/Taxes", data: [compBuyUpfront, compLeaseUpfront], backgroundColor: "rgba(255,167,38,0.7)" },
                    { label: "Maintenance", data: [compBuyMaint, compLeaseMaint], backgroundColor: "rgba(0,121,107,0.7)" },
                    { label: "Overage (Lease only)", data: [0, compLeaseOverage], backgroundColor: "rgba(198,40,40,0.7)" },
                    { label: "Loan Balance (end)", data: [compBuyLoanBal, 0], backgroundColor: "rgba(94,53,177,0.7)" },
                    { label: "Less Resale Value", data: [-compBuyResale, 0], backgroundColor: "rgba(76,175,80,0.7)" }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: "top" } },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: "Amount" }
                    }
                }
            }
        });
    }

    $("#currencyCode, #horizonYears, #investDiff, #investReturn, #buyPrice, #buyDown, #salesTaxPct, #buyFees, #loanApr, #loanTermYears, #deprPct, #maintBuy, #leaseMonthly, #leaseTermMonths, #leaseDriveOff, #leaseAcq, #leaseDisp, #maintLease, #milesAllow, #milesActual, #overMileFee")
        .on("input change", recalcLVB);

    // Initial calculation
    recalcLVB();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
