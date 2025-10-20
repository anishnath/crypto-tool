<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIP vs Lumpsum Calculator – Which Builds Wealth Faster?</title>
    <meta name="description" content="Compare SIP vs Lumpsum investment strategies. See final values, total invested, and which approach reaches your goal faster. Includes value-over-time charts and a year-wise breakdown.">
    <meta name="keywords" content="sip vs lumpsum calculator, sip or lumpsum which is better, lumpsum vs sip returns, mutual fund calculator, india">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "SIP vs Lumpsum Calculator",
      "applicationCategory": "FinanceApplication",
      "description": "Compare SIP vs Lumpsum investment strategies with value-over-time charts and year-wise breakdown.",
      "url": "https://8gwifi.org/sip-vs-lumpsum-calculator.jsp",
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
    <h1 class="mb-4">SIP vs Lumpsum Calculator</h1>
    <p>Compare SIP and Lumpsum strategies over your chosen horizon. Adjust returns, contributions, and match total investment to see which approach builds more wealth.</p>

    <form id="svl-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="sipMonthly">SIP Monthly Amount (₹)</label>
                            <input type="number" class="form-control" id="sipMonthly" value="10000">
                        </div>
                        <div class="form-group">
                            <label for="years">Investment Horizon (years)</label>
                            <input type="number" class="form-control" id="years" value="15">
                        </div>
                        <div class="form-group">
                            <label for="retPct">Expected Annual Return (% p.a.)</label>
                            <input type="number" class="form-control" id="retPct" value="12" step="0.1">
                        </div>
                        <div class="form-group">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="matchTotal" checked>
                                <label class="form-check-label" for="matchTotal">Match Lumpsum to total SIP contribution</label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="lumpSum">Lumpsum Amount (₹)</label>
                            <input type="number" class="form-control" id="lumpSum" value="1800000">
                            <small class="text-muted">Disabled if "Match Lumpsum" is selected.</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>SIP is compounded monthly with contributions at month-end.</li>
                        <li>Lumpsum is invested up front and compounded monthly.</li>
                        <li>Use "Match Lumpsum" to compare both with equal total invested principal.</li>
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
                                    <div><strong>Final Value (SIP)</strong></div>
                                    <div id="finalSip" style="font-size:1.1rem;">—</div>
                                    <small class="text-muted">Total invested: <span id="investedSip">—</span></small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Final Value (Lumpsum)</strong></div>
                                    <div id="finalLs" style="font-size:1.1rem;">—</div>
                                    <small class="text-muted">Total invested: <span id="investedLs">—</span></small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Difference (Winner – Other)</strong></div>
                                    <div id="diffVal" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Recommendation</strong></div>
                                    <div id="recommendation" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Assumes constant returns for illustration. Actual returns vary with market conditions.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Value Over Time</div>
                    <div class="card-body">
                        <canvas id="svl-chart" height="150"></canvas>
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
                        <th>SIP Invested (₹)</th>
                        <th>SIP Value (₹)</th>
                        <th>Lumpsum Invested (₹)</th>
                        <th>Lumpsum Value (₹)</th>
                    </tr>
                </thead>
                <tbody id="svl-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var svlChart = null;

    function fmtINR(x) {
        if (isNaN(x)) return "—";
        try { return "₹ " + Number(x).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
        catch(e) { return "₹ " + (Math.round(Number(x))).toString(); }
    }

    function recalcMatchLumpsum() {
        var sipMonthly = parseFloat($("#sipMonthly").val()) || 0;
        var years = parseInt($("#years").val()) || 0;
        var months = years * 12;
        if ($("#matchTotal").is(":checked")) {
            var ls = sipMonthly * months;
            $("#lumpSum").val(ls);
            $("#lumpSum").prop("disabled", true);
        } else {
            $("#lumpSum").prop("disabled", false);
        }
    }

    function calculateSVL() {
        var sipMonthly = parseFloat($("#sipMonthly").val()) || 0;
        var years = parseInt($("#years").val()) || 0;
        var retPct = (parseFloat($("#retPct").val()) || 0) / 100.0;
        var months = Math.max(0, years * 12);
        var r = retPct / 12.0;

        if ($("#matchTotal").is(":checked")) {
            recalcMatchLumpsum();
        }
        var lumpSum = parseFloat($("#lumpSum").val()) || 0;

        // SIP Future Value (monthly payment at end of month)
        // FV = P * [((1+r)^n - 1) / r]
        var fvSip = 0;
        if (r > 0) {
            fvSip = sipMonthly * ((Math.pow(1 + r, months) - 1) / r);
        } else {
            fvSip = sipMonthly * months;
        }

        // Lumpsum Future Value
        var fvLs = lumpSum * Math.pow(1 + r, months);

        var investedSip = sipMonthly * months;
        var investedLs = lumpSum;

        // Build per-year series for chart/table by simulating monthly
        var sipVal = 0;
        var lsVal = lumpSum;
        var tableHTML = "";
        var labels = [];
        var sipSeries = [];
        var lsSeries = [];
        var sipInvestedToDate = 0;

        for (var m = 1; m <= months; m++) {
            // month-end contribution for SIP
            sipVal = (sipVal + sipMonthly) * (1 + r);
            lsVal = lsVal * (1 + r);
            sipInvestedToDate += sipMonthly;

            if (m % 12 === 0) {
                var yr = m / 12;
                labels.push("Year " + yr);
                sipSeries.push(sipVal);
                lsSeries.push(lsVal);
                tableHTML += "<tr>" +
                    "<td>" + yr + "</td>" +
                    "<td>" + fmtINR(sipInvestedToDate) + "</td>" +
                    "<td><strong>" + fmtINR(sipVal) + "</strong></td>" +
                    "<td>" + fmtINR(investedLs) + "</td>" +
                    "<td><strong>" + fmtINR(lsVal) + "</strong></td>" +
                    "</tr>";
            }
        }

        // Summary and recommendation
        $("#finalSip").text(fmtINR(fvSip));
        $("#finalLs").text(fmtINR(fvLs));
        $("#investedSip").text(fmtINR(investedSip));
        $("#investedLs").text(fmtINR(investedLs));

        var diff = Math.abs(fvSip - fvLs);
        var rec = fvSip > fvLs ? "SIP leads by " + fmtINR(diff) : (fvLs > fvSip ? "Lumpsum leads by " + fmtINR(diff) : "Both are similar");
        $("#diffVal").text(fmtINR(diff));
        $("#recommendation").text(rec);

        $("#svl-table").html(tableHTML);

        if (svlChart) svlChart.destroy();
        var ctx = document.getElementById("svl-chart").getContext("2d");
        svlChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    {
                        label: "SIP – Value",
                        data: sipSeries,
                        borderColor: "#1565c0",
                        backgroundColor: "rgba(21,101,192,0.1)",
                        tension: 0.15
                    },
                    {
                        label: "Lumpsum – Value",
                        data: lsSeries,
                        borderColor: "#2e7d32",
                        backgroundColor: "rgba(46,125,50,0.1)",
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
                        title: { display: true, text: "Value (₹)" }
                    },
                    x: {
                        title: { display: true, text: "Year" }
                    }
                }
            }
        });
    }

    function wireUpSVL() {
        $("#sipMonthly, #years, #retPct, #matchTotal, #lumpSum")
            .on("input change", function(){
                if (this.id === "matchTotal" || this.id === "sipMonthly" || this.id === "years") {
                    recalcMatchLumpsum();
                }
                calculateSVL();
            });

        recalcMatchLumpsum();
        calculateSVL();
    }

    $(document).ready(wireUpSVL);
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
