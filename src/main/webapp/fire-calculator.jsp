<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FIRE Calculator (Financial Independence) – Early Retirement Planner</title>
    <meta name="description" content="Plan your Financial Independence (FIRE). Estimate your FI number, years to FI, and monthly savings needed. Includes inflation, SWR, pre/post-retirement returns, and contribution growth.">
    <meta name="keywords" content="FIRE calculator, financial independence calculator, early retirement calculator, FI number, safe withdrawal rate, SWR, retirement planning">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "FIRE Calculator (Financial Independence)",
      "applicationCategory": "FinanceApplication",
      "description": "Estimate your FI number, monthly savings needed, and years to financial independence with inflation and safe withdrawal rate.",
      "url": "https://8gwifi.org/fire-calculator.jsp",
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
    <h1 class="mb-4">FIRE Calculator (Financial Independence)</h1>
    <p>Estimate how much you need to retire early and when you can reach Financial Independence. Adjust assumptions for returns, inflation, safe withdrawal rate (SWR), and contribution growth.</p>

    <form id="fire-form">
        <div class="row">
            <div class="col-lg-5">

                <div class="card mb-3">
                    <div class="card-header">Personal & Expenses</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currentAge">Current Age</label>
                                <input type="number" class="form-control" id="currentAge" value="30">
                            </div>
                            <div class="form-group col-6">
                                <label for="targetAge">Target Retirement Age (optional)</label>
                                <input type="number" class="form-control" id="targetAge" value="45">
                                <small class="text-muted">Used to compute savings required by this age</small>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="annualExpense">Current Annual Expenses (₹)</label>
                            <input type="number" class="form-control" id="annualExpense" value="1200000">
                        </div>
                        <div class="form-group">
                            <label for="expensePct">Post-Retirement Expenses (% of current)</label>
                            <input type="number" class="form-control" id="expensePct" value="80" step="1">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Investments & Assumptions</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="currentSavings">Current Invested Savings (₹)</label>
                            <input type="number" class="form-control" id="currentSavings" value="1000000">
                        </div>
                        <div class="form-group">
                            <label for="monthlySavings">Monthly Savings (₹)</label>
                            <input type="number" class="form-control" id="monthlySavings" value="25000">
                        </div>
                        <div class="form-group">
                            <label for="contribGrowth">Annual Contribution Growth (% per year)</label>
                            <input type="number" class="form-control" id="contribGrowth" value="5" step="0.1">
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="preRetReturn">Pre-Retirement Return (% p.a.)</label>
                                <input type="number" class="form-control" id="preRetReturn" value="12" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="postRetReturn">Post-Retirement Return (% p.a.)</label>
                                <input type="number" class="form-control" id="postRetReturn" value="8" step="0.1">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="inflation">Inflation (% p.a.)</label>
                                <input type="number" class="form-control" id="inflation" value="6" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="swr">Safe Withdrawal Rate (SWR) (% p.a.)</label>
                                <input type="number" class="form-control" id="swr" value="4" step="0.1">
                            </div>
                        </div>
                        <small class="text-muted">SWR is typically 3–4% depending on risk and longevity assumptions.</small>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Required corpus at retirement = Annual expense at retirement ÷ SWR.</li>
                        <li>Annual expense at retirement grows with inflation and expense percentage.</li>
                        <li>Accumulation simulates yearly contributions (with growth) and investment returns.</li>
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
                                    <div><strong>FI Number (Required Corpus)</strong></div>
                                    <div id="fiNumber" style="font-size:1.25rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Estimated FI Age</strong></div>
                                    <div id="fiAge" style="font-size:1.25rem;">—</div>
                                    <small class="text-muted">Years to FI: <span id="yearsToFi">—</span></small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>FI Corpus at Target Age</strong></div>
                                    <div id="corpusAtTarget" style="font-size:1.1rem;">—</div>
                                    <small class="text-muted">Compared to required corpus</small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Monthly Savings Needed (for Target Age)</strong></div>
                                    <div id="monthlyNeeded" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <small class="text-muted">Estimates only. Market returns and inflation vary. Consider consulting a financial advisor.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Corpus vs Required Over Time</div>
                    <div class="card-body">
                        <canvas id="fi-chart" height="160"></canvas>
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
                        <th>Age</th>
                        <th>Year</th>
                        <th>Contribution (₹)</th>
                        <th>Investment Value (₹)</th>
                        <th>Required Corpus (₹)</th>
                        <th>Gap (₹)</th>
                    </tr>
                </thead>
                <tbody id="fi-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var fiChart = null;

    function fmtINR(x) {
        if (isNaN(x)) return "—";
        try { return "₹ " + Number(x).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
        catch(e) { return "₹ " + (Math.round(Number(x))).toString(); }
    }

    // Compute FI number for given years until FI (expenses inflated, SWR)
    function requiredCorpusAt(years, annualExpense, expensePct, inflation, swrPct) {
        var expAtRet = annualExpense * (expensePct/100.0) * Math.pow(1 + inflation, years);
        var swr = swrPct / 100.0;
        if (swr <= 0) swr = 0.01;
        return expAtRet / swr;
    }

    // Simulate accumulation annually until maxYears
    function simulateAccumulation(currentSavings, monthlySavings, contribGrowth, preRetReturn, years) {
        var value = currentSavings;
        var contrib = monthlySavings * 12;
        var r = preRetReturn;
        var g = contribGrowth;
        var series = [];
        for (var y = 1; y <= years; y++) {
            value = (value + contrib) * (1 + r);
            series.push({year: y, value: value, contrib: contrib});
            contrib = contrib * (1 + g);
        }
        return series;
    }

    // Solve monthly savings needed by target years using binary search on annual contributions
    function solveMonthlyNeeded(targetCorpus, currentSavings, years, preRetReturn, contribGrowth) {
        var low = 0, high = targetCorpus; // rough bounds
        var r = preRetReturn, g = contribGrowth;

        function futureValueWithMonthly(ms) {
            var value = currentSavings;
            var contrib = ms * 12;
            for (var y = 1; y <= years; y++) {
                value = (value + contrib) * (1 + r);
                contrib = contrib * (1 + g);
            }
            return value;
        }

        for (var i = 0; i < 40; i++) {
            var mid = (low + high) / 2;
            var fv = futureValueWithMonthly(mid);
            if (fv < targetCorpus) {
                low = mid;
            } else {
                high = mid;
            }
        }
        return high;
    }

    function calculateFIRE() {
        var currentAge = parseInt($("#currentAge").val()) || 0;
        var targetAge = parseInt($("#targetAge").val()) || 0;

        var annualExpense = parseFloat($("#annualExpense").val()) || 0;
        var expensePct = (parseFloat($("#expensePct").val()) || 0);
        var currentSavings = parseFloat($("#currentSavings").val()) || 0;
        var monthlySavings = parseFloat($("#monthlySavings").val()) || 0;

        var contribGrowth = (parseFloat($("#contribGrowth").val()) || 0) / 100.0;
        var preRetReturn = (parseFloat($("#preRetReturn").val()) || 0) / 100.0;
        var postRetReturn = (parseFloat($("#postRetReturn").val()) || 0) / 100.0;
        var inflation = (parseFloat($("#inflation").val()) || 0) / 100.0;
        var swrPct = (parseFloat($("#swr").val()) || 0);

        if (currentAge <= 0 || annualExpense <= 0 || expensePct <= 0) {
            // clear outputs
            $("#fiNumber").text("—");
            $("#fiAge").text("—");
            $("#yearsToFi").text("—");
            $("#corpusAtTarget").text("—");
            $("#monthlyNeeded").text("—");
            $("#fi-table").html("");
            if (fiChart) { fiChart.destroy(); fiChart = null; }
            return;
        }

        var maxYears = 60; // simulate up to 60 years
        var labels = [];
        var corpusSeries = [];
        var requiredSeries = [];
        var tableHTML = "";

        var sim = simulateAccumulation(currentSavings, monthlySavings, contribGrowth, preRetReturn, maxYears);
        var fiReachedYear = null;

        for (var i = 0; i < sim.length; i++) {
            var y = sim[i].year;
            var age = currentAge + y;
            var required = requiredCorpusAt(y, annualExpense, expensePct, inflation, swrPct);
            if (fiReachedYear === null && sim[i].value >= required) {
                fiReachedYear = y;
            }
            labels.push("Age " + age);
            corpusSeries.push(sim[i].value);
            requiredSeries.push(required);

            var gap = required - sim[i].value;
            tableHTML += "<tr>" +
                "<td>" + age + "</td>" +
                "<td>" + y + "</td>" +
                "<td>" + fmtINR(sim[i].contrib) + "</td>" +
                "<td><strong>" + fmtINR(sim[i].value) + "</strong></td>" +
                "<td>" + fmtINR(required) + "</td>" +
                "<td>" + fmtINR(gap) + "</td>" +
                "</tr>";
        }

        // Summary: FI number for targetAge years ahead or for first FI year
        var yearsToTarget = (targetAge > currentAge) ? (targetAge - currentAge) : 0;
        var fiNumberAtTarget = (yearsToTarget > 0) ? requiredCorpusAt(yearsToTarget, annualExpense, expensePct, inflation, swrPct) : requiredCorpusAt(0, annualExpense, expensePct, 0, swrPct);
        $("#fiNumber").text(fmtINR(fiNumberAtTarget));

        if (fiReachedYear !== null) {
            $("#fiAge").text(currentAge + fiReachedYear);
            $("#yearsToFi").text(fiReachedYear);
        } else {
            $("#fiAge").text("Not within " + maxYears + " years");
            $("#yearsToFi").text("—");
        }

        // Corpus by target and monthly needed for target
        if (yearsToTarget > 0) {
            var valueAtTarget = currentSavings;
            var contrib = monthlySavings * 12;
            for (var y2 = 1; y2 <= yearsToTarget; y2++) {
                valueAtTarget = (valueAtTarget + contrib) * (1 + preRetReturn);
                contrib = contrib * (1 + contribGrowth);
            }
            $("#corpusAtTarget").text(fmtINR(valueAtTarget));

            var neededMonthly = solveMonthlyNeeded(fiNumberAtTarget, currentSavings, yearsToTarget, preRetReturn, contribGrowth);
            $("#monthlyNeeded").text(fmtINR(neededMonthly));
        } else {
            $("#corpusAtTarget").text("—");
            $("#monthlyNeeded").text("—");
        }

        $("#fi-table").html(tableHTML);

        // Chart
        if (fiChart) fiChart.destroy();
        var ctx = document.getElementById("fi-chart").getContext("2d");
        fiChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "Investment Value",
                        data: corpusSeries,
                        borderColor: "#1565c0",
                        backgroundColor: "rgba(21,101,192,0.1)",
                        tension: 0.15
                    },
                    {
                        label: "Required Corpus",
                        data: requiredSeries,
                        borderColor: "#c62828",
                        backgroundColor: "rgba(198,40,40,0.1)",
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
                        title: { display: true, text: "Age" }
                    }
                }
            }
        });
    }

    $("#currentAge, #targetAge, #annualExpense, #expensePct, #currentSavings, #monthlySavings, #contribGrowth, #preRetReturn, #postRetReturn, #inflation, #swr")
        .on("input", calculateFIRE);

    // Initial calculation
    calculateFIRE();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
