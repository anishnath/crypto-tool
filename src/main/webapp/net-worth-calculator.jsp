<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Net Worth Calculator & Tracker – Assets, Liabilities, CSV Import</title>
    <meta name="description" content="Calculate your net worth by listing assets and liabilities. Track progress over time with snapshots and charts. Import/export CSV for easy updates.">
    <meta name="keywords" content="net worth calculator, calculate my net worth, net worth tracker, asset allocation, liabilities, csv import net worth, FIRE net worth">

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Net Worth Calculator & Tracker",
      "applicationCategory": "FinanceApplication",
      "description": "Compute and track net worth with assets and liabilities, charts, and CSV import/export.",
      "url": "https://8gwifi.org/net-worth-calculator.jsp",
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
    <h1 class="mb-4">Net Worth Calculator & Tracker</h1>
    <p>List your assets and liabilities to calculate your net worth. Save snapshots to track your progress over time, or import/export CSV for quick updates.</p>

    <form id="nw-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Assets</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm" id="assets-table">
                                <thead>
                                    <tr>
                                        <th>Category</th>
                                        <th>Amount</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="assets-body">
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm a-name" value="Cash"></td>
                                        <td><input type="number" class="form-control form-control-sm a-amt" value="200000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-asset">&times;</button></td>
                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm a-name" value="Investments"></td>
                                        <td><input type="number" class="form-control form-control-sm a-amt" value="800000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-asset">&times;</button></td>
                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm a-name" value="Property Equity"></td>
                                        <td><input type="number" class="form-control form-control-sm a-amt" value="1500000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-asset">&times;</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary" id="add-asset">Add Asset</button>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Liabilities</div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-sm" id="liab-table">
                                <thead>
                                    <tr>
                                        <th>Category</th>
                                        <th>Amount</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="liab-body">
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm l-name" value="Home Loan"></td>
                                        <td><input type="number" class="form-control form-control-sm l-amt" value="1200000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-liab">&times;</button></td>
                                    </tr>
                                    <tr>
                                        <td><input type="text" class="form-control form-control-sm l-name" value="Credit Cards"></td>
                                        <td><input type="number" class="form-control form-control-sm l-amt" value="25000"></td>
                                        <td><button type="button" class="btn btn-sm btn-outline-danger del-liab">&times;</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <button type="button" class="btn btn-sm btn-primary" id="add-liab">Add Liability</button>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Snapshot & CSV</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="snapDate">Snapshot Date</label>
                                <input type="date" class="form-control" id="snapDate">
                            </div>
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <input type="text" class="form-control" id="currencyCode" value="INR">
                            </div>
                        </div>
                        <button type="button" class="btn btn-success btn-sm" id="save-snapshot">Save Snapshot</button>
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="export-csv">Export CSV</button>
                        <div class="form-group mt-3">
                            <label for="csvInput">Import CSV (Date, NetWorth)</label>
                            <textarea id="csvInput" class="form-control" rows="3" placeholder="YYYY-MM-DD, 1234567"></textarea>
                            <button type="button" class="btn btn-outline-primary btn-sm mt-2" id="import-csv">Import</button>
                        </div>
                        <small class="text-muted">Tip: Add a snapshot each quarter and export CSV for your records.</small>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Summary</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Total Assets</strong></div>
                                    <div id="totalAssets" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Total Liabilities</strong></div>
                                    <div id="totalLiab" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Net Worth</strong></div>
                                    <div id="netWorth" style="font-size:1.4rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Net Worth = Total Assets − Total Liabilities</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Asset Allocation</div>
                    <div class="card-body">
                        <canvas id="alloc-chart" height="140"></canvas>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Net Worth Over Time</div>
                    <div class="card-body">
                        <canvas id="nw-chart" height="160"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <div class="mt-4">
        <h4>Snapshots</h4>
        <div style="max-height: 420px; overflow-y: auto;">
            <table class="table table-striped">
                <thead style="position: sticky; top: 0; background-color: white;">
                    <tr>
                        <th>Date</th>
                        <th>Net Worth</th>
                    </tr>
                </thead>
                <tbody id="snap-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var allocChart = null;
    var nwChart = null;
    var snapshots = [];

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
    }

    function readAssets() {
        var items = [];
        $("#assets-body tr").each(function(){
            var name = $(this).find(".a-name").val() || "Asset";
            var amt = parseFloat($(this).find(".a-amt").val()) || 0;
            items.push({ name: name, amt: amt });
        });
        return items;
    }

    function readLiabs() {
        var items = [];
        $("#liab-body tr").each(function(){
            var name = $(this).find(".l-name").val() || "Liability";
            var amt = parseFloat($(this).find(".l-amt").val()) || 0;
            items.push({ name: name, amt: amt });
        });
        return items;
    }

    function updateTotals() {
        var curr = ($("#currencyCode").val() || "INR").toUpperCase();
        var assets = readAssets();
        var liabs = readLiabs();

        var totA = assets.reduce(function(s,a){ return s + a.amt; }, 0);
        var totL = liabs.reduce(function(s,l){ return s + l.amt; }, 0);
        var nw = totA - totL;

        $("#totalAssets").text(fmtCurr(totA, curr));
        $("#totalLiab").text(fmtCurr(totL, curr));
        $("#netWorth").text(fmtCurr(nw, curr));

        // Asset allocation chart
        if (allocChart) allocChart.destroy();
        var labels = assets.map(function(a){ return a.name; });
        var data = assets.map(function(a){ return a.amt; });
        var ctxA = document.getElementById("alloc-chart").getContext("2d");
        allocChart = new Chart(ctxA, {
            type: "doughnut",
            data: { labels: labels, datasets: [{ data: data, backgroundColor: ["#1565c0","#2e7d32","#c62828","#f9a825","#6a1b9a","#00838f","#5d4037"] }] },
            options: { responsive: true, plugins: { legend: { position: "bottom" } } }
        });

        return nw;
    }

    function renderSnapshots() {
        var curr = ($("#currencyCode").val() || "INR").toUpperCase();
        snapshots.sort(function(a,b){ return new Date(a.date) - new Date(b.date); });
        var tbody = "";
        var labels = [];
        var series = [];
        for (var i = 0; i < snapshots.length; i++) {
            tbody += "<tr><td>" + snapshots[i].date + "</td><td><strong>" + fmtCurr(snapshots[i].value, curr) + "</strong></td></tr>";
            labels.push(snapshots[i].date);
            series.push(snapshots[i].value);
        }
        $("#snap-table").html(tbody);

        if (nwChart) nwChart.destroy();
        var ctxN = document.getElementById("nw-chart").getContext("2d");
        nwChart = new Chart(ctxN, {
            type: "line",
            data: {
                labels: labels,
                datasets: [{ label: "Net Worth", data: series, borderColor: "#1565c0", backgroundColor: "rgba(21,101,192,0.1)", tension: 0.15 }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: "top" } },
                scales: { y: { beginAtZero: true, title: { display: true, text: "Amount" } } }
            }
        });
    }

    function saveSnapshot() {
        var date = $("#snapDate").val() || new Date().toISOString().slice(0,10);
        var value = updateTotals();
        snapshots.push({ date: date, value: value });
        renderSnapshots();
    }

    function exportCSV() {
        var lines = ["Date,NetWorth"];
        for (var i = 0; i < snapshots.length; i++) {
            lines.push(snapshots[i].date + "," + snapshots[i].value);
        }
        var blob = new Blob([lines.join("\\n")], { type: "text/csv;charset=utf-8;" });
        var url = URL.createObjectURL(blob);
        var a = document.createElement("a");
        a.href = url;
        a.download = "net-worth-snapshots.csv";
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
    }

    function importCSV() {
        var txt = $("#csvInput").val() || "";
        var lines = txt.split(/\\r?\\n/);
        var out = [];
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim();
            if (!line || /^date\\s*,/i.test(line)) continue;
            var parts = line.split(",");
            if (parts.length >= 2) {
                var d = parts[0].trim();
                var v = parseFloat(parts[1].trim());
                if (d && !isNaN(v)) out.push({ date: d, value: v });
            }
        }
        if (out.length > 0) {
            snapshots = out;
            renderSnapshots();
        }
    }

    // Events
    $("#assets-body").on("input", ".a-name, .a-amt", updateTotals);
    $("#liab-body").on("input", ".l-name, .l-amt", updateTotals);
    $("#add-asset").on("click", function(){
        var row = '<tr>' +
            '<td><input type="text" class="form-control form-control-sm a-name" value="New Asset"></td>' +
            '<td><input type="number" class="form-control form-control-sm a-amt" value="0"></td>' +
            '<td><button type="button" class="btn btn-sm btn-outline-danger del-asset">&times;</button></td>' +
            '</tr>';
        $("#assets-body").append(row);
        updateTotals();
    });
    $("#add-liab").on("click", function(){
        var row = '<tr>' +
            '<td><input type="text" class="form-control form-control-sm l-name" value="New Liability"></td>' +
            '<td><input type="number" class="form-control form-control-sm l-amt" value="0"></td>' +
            '<td><button type="button" class="btn btn-sm btn-outline-danger del-liab">&times;</button></td>' +
            '</tr>';
        $("#liab-body").append(row);
        updateTotals();
    });
    $("#assets-body").on("click", ".del-asset", function(){ $(this).closest("tr").remove(); updateTotals(); });
    $("#liab-body").on("click", ".del-liab", function(){ $(this).closest("tr").remove(); updateTotals(); });

    $("#save-snapshot").on("click", saveSnapshot);
    $("#export-csv").on("click", exportCSV);
    $("#import-csv").on("click", importCSV);
    $("#currencyCode").on("input", function(){ updateTotals(); renderSnapshots(); });

    // Initial
    updateTotals();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
