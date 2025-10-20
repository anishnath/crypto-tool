<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Debt Payoff Calculator – Snowball vs Avalanche</title>
    <meta name="description" content="Compare Snowball vs Avalanche debt payoff strategies. Enter multiple debts, minimum payments, APRs, and extra payments to see debt-free date, total interest, and which method saves more.">
    <meta name="keywords" content="debt payoff calculator, snowball vs avalanche, debt repayment, debt-free date, interest saved, loan payoff calculator">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Debt Payoff Calculator – Snowball vs Avalanche",
      "applicationCategory": "FinanceApplication",
      "description": "Compare Snowball and Avalanche debt payoff strategies with monthly simulation, charts, and year-wise breakdown.",
      "url": "https://8gwifi.org/debt-payoff-calculator.jsp",
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
    <h1 class="mb-4">Debt Payoff Calculator – Snowball vs Avalanche</h1>
    <p>Enter your debts and compare Snowball (lowest balance first) vs Avalanche (highest APR first). See debt-free date, total interest, and which strategy saves more.</p>

    <form id="debt-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Debts</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm" id="debts-table">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Balance</th>
                                        <th>APR (%)</th>
                                        <th>Min Payment</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="debts-body">
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm name" value="Card A"></td>
                                        <td><input type="number" class="form-control form-control-sm balance" value="150000"></td>
                                        <td><input type="number" class="form-control form-control-sm apr" value="24" step="0.1"></td>
                                        <td><input type="number" class="form-control form-control-sm minpay" value="5000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-row">&times;</button></td>
                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm name" value="Card B"></td>
                                        <td><input type="number" class="form-control form-control-sm balance" value="90000"></td>
                                        <td><input type="number" class="form-control form-control-sm apr" value="18" step="0.1"></td>
                                        <td><input type="number" class="form-control form-control-sm minpay" value="3000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-row">&times;</button></td>
                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm name" value="Loan C"></td>
                                        <td><input type="number" class="form-control form-control-sm balance" value="250000"></td>
                                        <td><input type="number" class="form-control form-control-sm apr" value="12" step="0.1"></td>
                                        <td><input type="number" class="form-control form-control-sm minpay" value="8000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-row">&times;</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary" id="add-debt">Add Debt</button>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Strategy & Extra Payment</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="extraPay">Extra Monthly Payment (applied to target debt)</label>
                            <input type="number" class="form-control" id="extraPay" value="5000">
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="strategy">Strategy</label>
                                <select id="strategy" class="form-control">
                                    <option value="snowball">Snowball (Lowest Balance First)</option>
                                    <option value="avalanche">Avalanche (Highest APR First)</option>
                                </select>
                            </div>
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <input type="text" class="form-control" id="currencyCode" value="INR">
                            </div>
                        </div>
                        <small class="text-muted">Both strategies roll freed minimums into the next target as each debt is paid off.</small>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Tips:
                    <ul class="mb-0">
                        <li>Snowball builds momentum by clearing small balances first.</li>
                        <li>Avalanche minimizes interest by targeting highest APR first.</li>
                        <li>Adjust extra payment to see impact on debt-free date and interest saved.</li>
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
                                    <div><strong>Debt-free Months (Snowball)</strong></div>
                                    <div id="monthsSnowball" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Total interest: <span id="intSnowball">—</span></small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Debt-free Months (Avalanche)</strong></div>
                                    <div id="monthsAvalanche" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Total interest: <span id="intAvalanche">—</span></small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-12 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Recommendation</strong></div>
                                    <div id="recommendation" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Assumes fixed APRs and on-time payments. This is an estimate.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Remaining Balance Over Time</div>
                    <div class="card-body">
                        <canvas id="debt-chart" height="160"></canvas>
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
                        <th>Remaining (Snowball)</th>
                        <th>Remaining (Avalanche)</th>
                        <th>Cumulative Interest (Snowball)</th>
                        <th>Cumulative Interest (Avalanche)</th>
                    </tr>
                </thead>
                <tbody id="debt-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var debtChart = null;

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch(e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
    }

    function readDebts() {
        var rows = [];
        $("#debts-body tr").each(function(){
            var name = $(this).find(".name").val() || "Debt";
            var bal = parseFloat($(this).find(".balance").val()) || 0;
            var apr = (parseFloat($(this).find(".apr").val()) || 0) / 100.0;
            var minp = parseFloat($(this).find(".minpay").val()) || 0;
            if (bal > 0 && minp >= 0) {
                rows.push({ name: name, balance: bal, apr: apr, minpay: minp });
            }
        });
        return rows;
    }

    function simulate(debts, extra, method) {
        // Deep copy
        debts = debts.map(function(d){ return { name: d.name, balance: d.balance, apr: d.apr, minpay: d.minpay }; });

        var monthlyInterest = function(d){ return d.balance * (d.apr / 12.0); };

        var months = 0;
        var cumInterest = 0;
        var yearlyRemaining = [];
        var yearlyInterest = [];
        var totalMin = debts.reduce(function(s,d){ return s + d.minpay; }, 0);

        function chooseTarget() {
            var idx = -1;
            if (method === "snowball") {
                var minBal = Infinity;
                for (var i = 0; i < debts.length; i++) {
                    if (debts[i].balance > 0 && debts[i].balance < minBal) { minBal = debts[i].balance; idx = i; }
                }
            } else {
                var maxApr = -1;
                for (var j = 0; j < debts.length; j++) {
                    if (debts[j].balance > 0 && debts[j].apr > maxApr) { maxApr = debts[j].apr; idx = j; }
                }
            }
            return idx;
        }

        var closed = false;
        while (debts.some(function(d){ return d.balance > 0.01; }) && months < 1200) {
            months++;

            // 1) Accrue interest
            var monthInt = 0;
            for (var i = 0; i < debts.length; i++) {
                if (debts[i].balance <= 0) continue;
                var add = monthlyInterest(debts[i]);
                monthInt += add;
                debts[i].balance += add;
            }
            cumInterest += monthInt;

            // 2) Pay minimums
            for (var k = 0; k < debts.length; k++) {
                if (debts[k].balance <= 0) continue;
                var pay = Math.min(debts[k].minpay, debts[k].balance);
                debts[k].balance -= pay;
            }

            // 3) Apply extra to target debt
            var t = chooseTarget();
            if (t >= 0 && debts[t].balance > 0 && extra > 0) {
                var apply = Math.min(extra, debts[t].balance);
                debts[t].balance -= apply;
            }

            // 4) Yearly snapshot
            if (months % 12 === 0) {
                var remaining = debts.reduce(function(s,d){ return s + Math.max(0, d.balance); }, 0);
                yearlyRemaining.push(remaining);
                yearlyInterest.push(cumInterest);
            }

            // Prevent infinite loops if minimums don't cover interest: bump extra to avoid negative amortization
            if (months % 120 === 0 && !closed) {
                var minCover = debts.every(function(d){ return (d.minpay + (d === debts[chooseTarget()] ? extra : 0)) > (d.balance * d.apr / 12.0); });
                if (!minCover) { extra += 100; }
            }

            closed = debts.every(function(d){ return d.balance <= 0.01; });
        }

        return { months: months, interest: cumInterest, yearlyRemaining: yearlyRemaining, yearlyInterest: yearlyInterest };
    }

    function recalcDebt() {
        var debts = readDebts();
        var extra = parseFloat($("#extraPay").val()) || 0;
        var strategy = $("#strategy").val();
        var curr = ($("#currencyCode").val() || "INR").toUpperCase();

        if (debts.length === 0) {
            $("#monthsSnowball, #intSnowball, #monthsAvalanche, #intAvalanche, #recommendation").text("—");
            $("#debt-table").html("");
            if (debtChart) { debtChart.destroy(); debtChart = null; }
            return;
        }

        // Always compute both to recommend
        var resSnow = simulate(debts, extra, "snowball");
        var resAva = simulate(debts, extra, "avalanche");

        $("#monthsSnowball").text(resSnow.months);
        $("#intSnowball").text(fmtCurr(resSnow.interest, curr));
        $("#monthsAvalanche").text(resAva.months);
        $("#intAvalanche").text(fmtCurr(resAva.interest, curr));

        var rec = "";
        if (resAva.interest < resSnow.interest) {
            rec = "Avalanche saves " + fmtCurr(resSnow.interest - resAva.interest, curr) + " in interest compared to Snowball.";
        } else if (resSnow.months < resAva.months) {
            rec = "Snowball becomes debt-free " + (resAva.months - resSnow.months) + " months earlier than Avalanche.";
        } else {
            rec = "Both strategies are similar based on your inputs.";
        }
        $("#recommendation").text(rec);

        // Build year table (use max length of arrays)
        var rows = Math.max(resSnow.yearlyRemaining.length, resAva.yearlyRemaining.length);
        var tableHTML = "";
        for (var y = 1; y <= rows; y++) {
            var sRem = resSnow.yearlyRemaining[y-1] || 0;
            var aRem = resAva.yearlyRemaining[y-1] || 0;
            var sInt = resSnow.yearlyInterest[y-1] || 0;
            var aInt = resAva.yearlyInterest[y-1] || 0;
            tableHTML += "<tr>" +
                "<td>" + y + "</td>" +
                "<td>" + fmtCurr(sRem, curr) + "</td>" +
                "<td>" + fmtCurr(aRem, curr) + "</td>" +
                "<td>" + fmtCurr(sInt, curr) + "</td>" +
                "<td>" + fmtCurr(aInt, curr) + "</td>" +
                "</tr>";
        }
        $("#debt-table").html(tableHTML);

        // Chart
        if (debtChart) debtChart.destroy();
        var labels = [];
        for (var i = 1; i <= rows; i++) labels.push("Year " + i);
        var ctx = document.getElementById("debt-chart").getContext("2d");
        debtChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    { label: "Remaining (Snowball)", data: resSnow.yearlyRemaining, borderColor: "#1565c0", backgroundColor: "rgba(21,101,192,0.1)", tension: 0.15 },
                    { label: "Remaining (Avalanche)", data: resAva.yearlyRemaining, borderColor: "#2e7d32", backgroundColor: "rgba(46,125,50,0.1)", tension: 0.15 }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: "top" }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: "Remaining Balance" }
                    },
                    x: {
                        title: { display: true, text: "Year" }
                    }
                }
            }
        });
    }

    // Events
    $("#extraPay, #strategy, #currencyCode").on("input change", recalcDebt);
    $("#debts-body").on("input", ".name, .balance, .apr, .minpay", recalcDebt);
    $("#debts-body").on("click", ".del-row", function(){
        $(this).closest("tr").remove();
        recalcDebt();
    });
    $("#add-debt").on("click", function(){
        var row = '<tr>' +
            '<td><input type="text" class="form-control form-control-sm name" value="New Debt"></td>' +
            '<td><input type="number" class="form-control form-control-sm balance" value="0"></td>' +
            '<td><input type="number" class="form-control form-control-sm apr" value="10" step="0.1"></td>' +
            '<td><input type="number" class="form-control form-control-sm minpay" value="0"></td>' +
            '<td><button type="button" class="btn btn-sm btn-outline-danger del-row">&times;</button></td>' +
            '</tr>';
        $("#debts-body").append(row);
        recalcDebt();
    });

    // Initial calc
    recalcDebt();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
