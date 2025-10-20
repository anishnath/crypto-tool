<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Prepay vs Invest Calculator (Home Loan, India) – Interest Saved vs Corpus</title>
    <meta name="description" content="Should you prepay your home loan or invest the surplus? Compare months saved, interest saved, and investment corpus over time with this Prepay vs Invest calculator.">
    <meta name="keywords" content="home loan prepayment calculator, prepay vs invest, loan prepayment vs investment calculator, emi prepayment India, mortgage prepayment calculator">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Prepay vs Invest Calculator (Home Loan)",
      "applicationCategory": "FinanceApplication",
      "description": "Compare home loan prepayment versus investing the same surplus; see months saved, interest saved, and investment corpus.",
      "url": "https://8gwifi.org/prepay-vs-invest-calculator.jsp",
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
    <h1 class="mb-4">Home Loan: Prepay or Invest? Calculator</h1>
    <p>Compare two strategies for your surplus: prepay the home loan (reduce tenure) or invest the same amount. See how many months you save on the loan, interest saved, and the value of your investments over time.</p>

    <form id="pvi-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Loan Details</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="principal">Loan Principal (₹)</label>
                            <input type="number" class="form-control" id="principal" value="5000000">
                        </div>
                        <div class="form-group">
                            <label for="annualRate">Interest Rate (% p.a.)</label>
                            <input type="number" class="form-control" id="annualRate" value="9" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="tenureYears">Tenure (years)</label>
                            <input type="number" class="form-control" id="tenureYears" value="20">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Surplus & Investment</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="extraMonthly">Extra Monthly Amount (₹) — either Prepay or Invest</label>
                            <input type="number" class="form-control" id="extraMonthly" value="10000">
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="oneTimeExtra">One-time Extra (₹)</label>
                                <input type="number" class="form-control" id="oneTimeExtra" value="0">
                            </div>
                            <div class="form-group col-6">
                                <label for="oneTimeMonth">One-time Month (1..n)</label>
                                <input type="number" class="form-control" id="oneTimeMonth" value="12">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="investReturn">Investment Return (% p.a.)</label>
                            <input type="number" class="form-control" id="investReturn" value="10" step="0.1">
                        </div>
                        <div class="form-group">
                            <label for="horizonYears">Comparison Horizon (years)</label>
                            <input type="number" class="form-control" id="horizonYears" value="20">
                            <small class="text-muted">Default equals loan tenure. Used for charts and investment growth tracking.</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Prepay strategy: Fixed EMI plus extra monthly prepayment; tenure reduces. One-time extra (if any) is applied at the chosen month.</li>
                        <li>Invest strategy: Pay only EMI; invest the extra monthly and the one-time extra to grow at the chosen return.</li>
                        <li>Outputs compare interest saved and months saved versus the investment corpus at the chosen horizon.</li>
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
                                    <div><strong>EMI (Baseline)</strong></div>
                                    <div id="emiVal" style="font-size:1.1rem;">—</div>
                                    <small class="text-muted">Based on principal, rate, and tenure</small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Debt-free (Prepay)</strong></div>
                                    <div id="monthsSaved" style="font-size:1.1rem;">—</div>
                                    <small class="text-muted">Months saved vs baseline</small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Interest Saved (Prepay)</strong></div>
                                    <div id="interestSaved" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Investment Corpus (Invest)</strong></div>
                                    <div id="investCorpus" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Recommendation</strong></div>
                                    <div id="recommendation" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <small class="text-muted">This is an estimate. Taxes, fees, and rate changes are not modeled.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Outstanding vs Investment</div>
                    <div class="card-body">
                        <canvas id="pvi-chart" height="150"></canvas>
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
                        <th>Outstanding (Baseline)</th>
                        <th>Outstanding (Prepay)</th>
                        <th>Cumulative Interest (Baseline)</th>
                        <th>Cumulative Interest (Prepay)</th>
                        <th>Investment Corpus</th>
                    </tr>
                </thead>
                <tbody id="pvi-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var pviChart = null;

    function fmtINR(x) {
        if (isNaN(x)) return "—";
        try { return "₹ " + Number(x).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
        catch(e) { return "₹ " + (Math.round(Number(x))).toString(); }
    }

    function calculatePVI() {
        var P = parseFloat($("#principal").val()) || 0;
        var annual = (parseFloat($("#annualRate").val()) || 0) / 100.0;
        var years = parseInt($("#tenureYears").val()) || 0;
        var extraMonthly = parseFloat($("#extraMonthly").val()) || 0;
        var oneTimeExtra = parseFloat($("#oneTimeExtra").val()) || 0;
        var oneTimeMonth = parseInt($("#oneTimeMonth").val()) || 0;
        var invAnnual = (parseFloat($("#investReturn").val()) || 0) / 100.0;
        var horizonYears = parseInt($("#horizonYears").val()) || years;

        if (P <= 0 || years <= 0) {
            $("#emiVal, #monthsSaved, #interestSaved, #investCorpus, #recommendation").text("—");
            $("#pvi-table").html("");
            if (pviChart) { pviChart.destroy(); pviChart = null; }
            return;
        }

        var r = annual / 12.0;
        var n = years * 12;
        var emi = 0;
        if (r > 0) {
            emi = P * r * Math.pow(1 + r, n) / (Math.pow(1 + r, n) - 1);
        } else {
            emi = P / n;
        }
        $("#emiVal").text(fmtINR(emi));

        var horizonMonths = Math.max(n, horizonYears * 12);

        // Baseline (no prepay)
        var outB = P;
        var cumIntB = 0;
        var outB_year = [];
        var cumIntB_year = [];

        // Prepay (reduce tenure)
        var outP = P;
        var cumIntP = 0;
        var outP_year = [];
        var cumIntP_year = [];
        var monthsToClosePrepay = 0;

        // Invest scenario
        var rInv = invAnnual / 12.0;
        var investVal = 0;
        var invest_year = [];

        var tableHTML = [];
        var labels = [];

        for (var m = 1; m <= horizonMonths; m++) {
            // Baseline month
            if (outB > 0) {
                var intB = outB * r;
                var prinB = Math.min(emi - intB, outB);
                if (prinB < 0) prinB = 0;
                outB = Math.max(0, outB - prinB);
                cumIntB += intB;
            }

            // Prepay month
            if (outP > 0) {
                var intP = outP * r;
                var prinP = Math.min(emi - intP, outP);
                if (prinP < 0) prinP = 0;
                outP = Math.max(0, outP - prinP);

                // Apply extra monthly prepayment
                var extra = extraMonthly;
                // Apply one-time extra at specified month
                if (oneTimeExtra > 0 && m === oneTimeMonth) {
                    extra += oneTimeExtra;
                }
                if (extra > 0 && outP > 0) {
                    var applied = Math.min(extra, outP);
                    outP -= applied;
                }

                cumIntP += intP;

                if (outP <= 0 && monthsToClosePrepay === 0) {
                    monthsToClosePrepay = m;
                }
            }

            // Invest month: contribute then grow
            var invContrib = extraMonthly;
            if (oneTimeExtra > 0 && m === oneTimeMonth) {
                invContrib += oneTimeExtra;
            }
            investVal = (investVal + invContrib) * (1 + rInv);

            // Year-end snapshot
            if (m % 12 === 0) {
                var yr = m / 12;
                labels.push("Year " + yr);
                outB_year.push(outB);
                outP_year.push(outP);
                cumIntB_year.push(cumIntB);
                cumIntP_year.push(cumIntP);
                invest_year.push(investVal);
                tableHTML.push(
                    "<tr>" +
                    "<td>" + yr + "</td>" +
                    "<td>" + fmtINR(outB) + "</td>" +
                    "<td>" + fmtINR(outP) + "</td>" +
                    "<td>" + fmtINR(cumIntB) + "</td>" +
                    "<td>" + fmtINR(cumIntP) + "</td>" +
                    "<td><strong>" + fmtINR(investVal) + "</strong></td>" +
                    "</tr>"
                );
            }
        }

        // If prepay closed earlier than baseline tenure
        var monthsSaved = 0;
        if (monthsToClosePrepay > 0) {
            monthsSaved = Math.max(0, n - monthsToClosePrepay);
        }
        $("#monthsSaved").text(monthsSaved > 0 ? (monthsSaved + " months") : "No early closure");

        // Interest saved compared to baseline until prepay closure or baseline tenure whichever is earlier
        // Use cumulative interest arrays; if closed earlier, cumIntP is final at closure while baseline continues
        var interestSaved = Math.max(0, cumIntB - cumIntP);
        $("#interestSaved").text(fmtINR(interestSaved));

        // Investment corpus at horizon
        $("#investCorpus").text(fmtINR(investVal));

        // Recommendation: compare interest saved vs investment corpus
        var rec = "";
        if (investVal > interestSaved) {
            rec = "Invest may be better by " + fmtINR(investVal - interestSaved);
        } else if (interestSaved > investVal) {
            rec = "Prepay may be better by " + fmtINR(interestSaved - investVal);
        } else {
            rec = "Both strategies appear similar";
        }
        $("#recommendation").text(rec);

        // Update table
        $("#pvi-table").html(tableHTML.join(""));

        // Chart
        if (pviChart) pviChart.destroy();
        var ctx = document.getElementById("pvi-chart").getContext("2d");
        pviChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "Outstanding (Baseline)",
                        data: outB_year,
                        borderColor: "#b71c1c",
                        backgroundColor: "rgba(183,28,28,0.1)",
                        tension: 0.15
                    },
                    {
                        label: "Outstanding (Prepay)",
                        data: outP_year,
                        borderColor: "#1b5e20",
                        backgroundColor: "rgba(27,94,32,0.1)",
                        tension: 0.15
                    },
                    {
                        label: "Investment Corpus",
                        data: invest_year,
                        borderColor: "#1565c0",
                        backgroundColor: "rgba(21,101,192,0.1)",
                        tension: 0.15
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: "top" },
                    tooltip: {
                        callbacks: {
                            label: function(ctx){ return ctx.dataset.label + ": " + fmtINR(ctx.parsed.y); }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(v){ return "₹ " + Number(v).toLocaleString('en-IN'); }
                        },
                        title: { display: true, text: "Amount (₹)" }
                    },
                    x: {
                        title: { display: true, text: "Year" }
                    }
                }
            }
        });
    }

    $("#principal, #annualRate, #tenureYears, #extraMonthly, #oneTimeExtra, #oneTimeMonth, #investReturn, #horizonYears")
        .on("input", calculatePVI);

    // Initial calculation
    calculatePVI();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
