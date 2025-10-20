<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Savings Goal Calculator – Goal/Date, Monthly Needed, Inflation Adjusted</title>
    <meta name="description" content="Plan your savings goal by date or amount. Calculate monthly savings needed or time to reach your goal, with inflation adjustment and contribution growth. Includes charts and year-wise breakdown.">
    <meta name="keywords" content="savings goal calculator, savings goal planner, monthly savings needed, time to reach savings goal, inflation adjusted savings, contribution growth">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Savings Goal Calculator",
      "applicationCategory": "FinanceApplication",
      "description": "Calculate monthly savings needed or time to reach a savings goal with inflation and contribution growth.",
      "url": "https://8gwifi.org/savings-goal-calculator.jsp",
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
    <h1 class="mb-4">Savings Goal Planner</h1>
    <p>Set a goal amount and a target date (or years), and find the monthly savings needed. Or, enter your monthly contribution to estimate when you'll reach your inflation-adjusted goal.</p>

    <form id="sg-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Goal & Mode</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <input type="text" class="form-control" id="currencyCode" value="USD">
                            </div>
                            <div class="form-group col-6">
                                <label for="goalToday">Goal Amount (today's value)</label>
                                <input type="number" class="form-control" id="goalToday" value="1000000">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="mode">Compute</label>
                            <select id="mode" class="form-control">
                                <option value="monthlyNeeded">Monthly Needed by Target Date</option>
                                <option value="timeToGoal">Time to Reach Goal (with current monthly)</option>
                            </select>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="targetDate">Target Date (optional)</label>
                                <input type="date" class="form-control" id="targetDate">
                                <small class="text-muted">Use this or enter Years</small>
                            </div>
                            <div class="form-group col-6">
                                <label for="years">Years (if no date)</label>
                                <input type="number" class="form-control" id="years" value="10">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Savings & Assumptions</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currentSavings">Current Savings</label>
                                <input type="number" class="form-control" id="currentSavings" value="100000">
                            </div>
                            <div class="form-group col-6">
                                <label for="monthlyContribution">Monthly Contribution</label>
                                <input type="number" class="form-control" id="monthlyContribution" value="20000">
                                <small class="text-muted">Used for Time to Goal mode, and preview</small>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="expectedReturn">Expected Return (% p.a.)</label>
                                <input type="number" class="form-control" id="expectedReturn" value="10" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="inflation">Inflation (% p.a.)</label>
                                <input type="number" class="form-control" id="inflation" value="6" step="0.1">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="contribGrowth">Contribution Growth (% per year)</label>
                            <input type="number" class="form-control" id="contribGrowth" value="5" step="0.1">
                            <small class="text-muted">Increase your monthly contributions annually by this %</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Goal is adjusted for inflation to the target horizon.</li>
                        <li>Future value uses monthly compounding; contributions can grow annually.</li>
                        <li>For "Monthly Needed", we solve for the initial monthly that grows annually by your chosen rate.</li>
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
                                    <div><strong>Inflation-Adjusted Goal</strong></div>
                                    <div id="goalInflated" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Goal value at target horizon</small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Projected Value (Current Plan)</strong></div>
                                    <div id="projectedValue" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">With current monthly & growth</small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong id="primaryLabel">Monthly Needed</strong></div>
                                    <div id="primaryValue" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Surplus / Shortfall</strong></div>
                                    <div id="gapValue" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <small class="text-muted">Estimates based on constant rates. Actual results vary with market conditions and changes in contributions.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Balance Growth Over Time</div>
                    <div class="card-body">
                        <canvas id="sg-chart" height="160"></canvas>
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
                        <th>Contribution (Year)</th>
                        <th>End Balance</th>
                        <th>Real Balance (today's value)</th>
                    </tr>
                </thead>
                <tbody id="sg-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var sgChart = null;

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
    }

    function getMonthsToTarget() {
        var dateStr = $("#targetDate").val();
        if (dateStr) {
            var target = new Date(dateStr);
            var now = new Date();
            var months = (target.getFullYear() - now.getFullYear()) * 12 + (target.getMonth() - now.getMonth());
            return Math.max(0, months);
        }
        var years = parseFloat($("#years").val()) || 0;
        return Math.max(0, Math.round(years * 12));
    }

    function projectValue(currentSavings, monthly, contribGrowth, annualReturn, months) {
        var value = currentSavings;
        var r = annualReturn / 12.0;
        var g = contribGrowth;

        var yearContrib = monthly * 12;
        for (var m = 1; m <= months; m++) {
            value = (value + monthly) * (1 + r);
            if (m % 12 === 0) {
                monthly = monthly * (1 + g);
            }
        }
        return value;
    }

    function solveMonthlyNeeded(goalFV, currentSavings, annualReturn, months, contribGrowth) {
        // Binary search for initial monthly that grows annually by g to reach goalFV
        var low = 0;
        var high = goalFV; // rough upper bound
        for (var i = 0; i < 40; i++) {
            var mid = (low + high) / 2;
            var fv = projectValue(currentSavings, mid, contribGrowth, annualReturn, months);
            if (fv < goalFV) low = mid; else high = mid;
        }
        return high;
    }

    function timeToReach(goalFV, currentSavings, monthly, annualReturn, contribGrowth) {
        // Simulate month by month increasing monthly each year until reaching goalFV or a cap
        var value = currentSavings;
        var r = annualReturn / 12.0;
        var g = contribGrowth;
        var months = 0;
        var monthlyNow = monthly;

        while (value < goalFV && months < 12 * 100) {
            months++;
            value = (value + monthlyNow) * (1 + r);
            if (months % 12 === 0) {
                monthlyNow = monthlyNow * (1 + g);
            }
        }
        return months;
    }

    function calculateSG() {
        var curr = ($("#currencyCode").val() || "USD").toUpperCase();
        var mode = $("#mode").val();

        var goalToday = parseFloat($("#goalToday").val()) || 0;
        var currentSavings = parseFloat($("#currentSavings").val()) || 0;
        var monthlyContribution = parseFloat($("#monthlyContribution").val()) || 0;

        var expectedReturn = (parseFloat($("#expectedReturn").val()) || 0) / 100.0;
        var inflation = (parseFloat($("#inflation").val()) || 0) / 100.0;
        var contribGrowth = (parseFloat($("#contribGrowth").val()) || 0) / 100.0;

        var months = getMonthsToTarget();
        if (goalToday <= 0 || expectedReturn < 0) {
            $("#goalInflated, #projectedValue, #primaryValue, #gapValue").text("—");
            $("#sg-table").html("");
            if (sgChart) { sgChart.destroy(); sgChart = null; }
            return;
        }

        var years = months / 12.0;
        var goalFV = goalToday * Math.pow(1 + inflation, years);

        // Project current plan
        var proj = projectValue(currentSavings, monthlyContribution, contribGrowth, expectedReturn, months);

        $("#goalInflated").text(fmtCurr(goalFV, curr));
        $("#projectedValue").text(fmtCurr(proj, curr));

        var primaryLabel = "Monthly Needed";
        var primaryValue = "—";
        var gapText = "—";

        if (mode === "monthlyNeeded") {
            primaryLabel = "Monthly Needed";
            var monthlyNeeded = (months > 0) ? solveMonthlyNeeded(goalFV, currentSavings, expectedReturn, months, contribGrowth) : 0;
            primaryValue = fmtCurr(monthlyNeeded, curr);
            var gap = proj - goalFV;
            gapText = (gap >= 0 ? "Surplus " : "Shortfall ") + fmtCurr(Math.abs(gap), curr);
        } else {
            primaryLabel = "Time to Goal";
            var monthsNeeded = timeToReach(goalFV, currentSavings, monthlyContribution, expectedReturn, contribGrowth);
            var yearsNeeded = (monthsNeeded / 12.0);
            if (monthsNeeded >= 12 * 100) {
                primaryValue = "Over 100 years";
            } else {
                primaryValue = yearsNeeded.toFixed(1) + " years (" + monthsNeeded + " months)";
            }
            var gap2 = proj - goalFV;
            gapText = (gap2 >= 0 ? "Surplus " : "Shortfall ") + fmtCurr(Math.abs(gap2), curr);
        }

        $("#primaryLabel").text(primaryLabel);
        $("#primaryValue").text(primaryValue);
        $("#gapValue").text(gapText);

        // Build year-wise table and chart
        var labels = [];
        var series = [];
        var tableHTML = "";
        var value = currentSavings;
        var r = expectedReturn / 12.0;
        var monthly = monthlyContribution;
        var g = contribGrowth;
        var monthsToSim = Math.max(months, 12); // at least a year for chart
        var todayInfl = inflation;

        for (var m = 1; m <= monthsToSim; m++) {
            value = (value + monthly) * (1 + r);
            if (m % 12 === 0) {
                var yr = m / 12;
                labels.push("Year " + yr);
                series.push(value);
                var realVal = value / Math.pow(1 + todayInfl, yr);
                var contribYear = monthly * 12;
                tableHTML += "<tr>" +
                    "<td>" + yr + "</td>" +
                    "<td>" + fmtCurr(contribYear, curr) + "</td>" +
                    "<td><strong>" + fmtCurr(value, curr) + "</strong></td>" +
                    "<td>" + fmtCurr(realVal, curr) + "</td>" +
                    "</tr>";
                monthly = monthly * (1 + g);
            }
        }
        $("#sg-table").html(tableHTML);

        if (sgChart) sgChart.destroy();
        var ctx = document.getElementById("sg-chart").getContext("2d");
        sgChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    { label: "Projected Balance", data: series, borderColor: "#1565c0", backgroundColor: "rgba(21,101,192,0.1)", tension: 0.15 }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: "top" } },
                scales: {
                    y: { beginAtZero: true, title: { display: true, text: "Amount" } },
                    x: { title: { display: true, text: "Year" } }
                }
            }
        });
    }

    $("#currencyCode, #goalToday, #mode, #targetDate, #years, #currentSavings, #monthlyContribution, #expectedReturn, #inflation, #contribGrowth")
        .on("input change", calculateSG);

    // Initial calculation
    calculateSG();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
