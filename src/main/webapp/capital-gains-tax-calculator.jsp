<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Capital Gains Tax Calculator – Equity, Mutual Funds, Debt, Gold, Property</title>
    <meta name="description" content="Calculate capital gains tax for Equity, Mutual Funds, Debt Funds, Gold, and Property. Supports indexation (CII), equity LTCG exemption, slab tax, and property exemptions.">
    <meta name="keywords" content="capital gains tax calculator, ltcg calculator, stcg calculator, equity ltcg, mutual fund tax, debt fund tax, gold tax, property capital gains, indexation CII, India">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Capital Gains Tax Calculator (India)",
      "applicationCategory": "FinanceApplication",
      "description": "Calculate capital gains tax for Equity, Mutual Funds, Debt Funds, Gold, and Property in India with indexation, exemptions, and slab tax.",
      "url": "https://8gwifi.org/capital-gains-tax-calculator.jsp",
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
    <h1 class="mb-4">Capital Gains Tax Calculator (India)</h1>
    <p>Estimate capital gains tax across Equity, Mutual Funds, Debt, Gold, and Property. Supports indexation (CII), equity LTCG exemption, slab and cess, and basic property exemptions.</p>

    <form id="cgt-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Asset & Transaction</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="assetType">Asset Type</label>
                            <select id="assetType" class="form-control">
                                <option value="equity">Equity Shares / Equity Mutual Fund</option>
                                <option value="debtmf">Debt Mutual Fund</option>
                                <option value="gold">Gold (Physical/ETC)</option>
                                <option value="property">Property (Real Estate)</option>
                            </select>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="buyPrice">Purchase Price (₹)</label>
                                <input type="number" class="form-control" id="buyPrice" value="500000">
                            </div>
                            <div class="form-group col-6">
                                <label for="buyExpenses">Purchase Expenses (₹)</label>
                                <input type="number" class="form-control" id="buyExpenses" value="0">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="sellPrice">Sale Price (₹)</label>
                                <input type="number" class="form-control" id="sellPrice" value="750000">
                            </div>
                            <div class="form-group col-6">
                                <label for="sellExpenses">Sale Expenses (₹)</label>
                                <input type="number" class="form-control" id="sellExpenses" value="0">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="holdMonths">Holding Period (months)</label>
                            <input type="number" class="form-control" id="holdMonths" value="18">
                            <small class="text-muted">Enter months held. LTCG/STCG thresholds vary by asset: Equity ≥12m, Debt MF legacy ≥36m, Gold ≥36m, Property ≥24m.</small>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Indexation (CII) & Rules</div>
                    <div class="card-body">
                        <div class="form-group">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="applyIndexation" checked>
                                <label class="form-check-label" for="applyIndexation">Apply Indexation (CII)</label>
                            </div>
                            <small class="text-muted d-block mb-2">Indexation generally applies to Property and Gold LTCG and legacy Debt MF LTCG.</small>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="ciiBuy">CII at Purchase</label>
                                <input type="number" class="form-control" id="ciiBuy" value="280">
                            </div>
                            <div class="form-group col-6">
                                <label for="ciiSell">CII at Sale</label>
                                <input type="number" class="form-control" id="ciiSell" value="348">
                            </div>
                        </div>

                        <div class="form-group" id="debtRuleGroup">
                            <label for="debtRule">Debt MF Rule</label>
                            <select id="debtRule" class="form-control">
                                <option value="current">Current: No indexation; gains taxed at slab</option>
                                <option value="legacy">Legacy: LTCG ≥36m at 20% with indexation</option>
                            </select>
                        </div>

                        <div class="form-group" id="propertyExemptionGroup">
                            <label for="propertyExemption">Property Exemption (54/54EC/54F) (₹)</label>
                            <input type="number" class="form-control" id="propertyExemption" value="0">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Tax Settings</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="taxSlabPct">Tax Slab Rate (% for STCG on non-equity)</label>
                                <input type="number" class="form-control" id="taxSlabPct" value="30" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="cessPct">Cess (%)</label>
                                <input type="number" class="form-control" id="cessPct" value="4" step="0.1">
                            </div>
                        </div>
                        <div class="form-group" id="equityExemptionGroup">
                            <label for="equityLTCGExempt">Equity LTCG Exemption (₹)</label>
                            <input type="number" class="form-control" id="equityLTCGExempt" value="100000">
                        </div>
                        <small class="text-muted">Surcharge is not modeled; enter an effective rate in slab if needed.</small>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Indexed cost = (Purchase Price + Expenses) × (CII at Sale / CII at Purchase), when indexation applies.</li>
                        <li>Equity LTCG at 10% beyond exemption; Equity STCG at 15%; Non-equity STCG taxed at slab.</li>
                        <li>Property LTCG allows exemptions; Debt MF “Current” rule taxes gains at slab without indexation.</li>
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
                                    <div><strong>Gain Type</strong></div>
                                    <div id="gainType" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Tax Rate Applied</strong></div>
                                    <div id="taxRateApplied" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Unindexed Gain</strong></div>
                                    <div id="unindexedGain" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Indexed Cost</strong></div>
                                    <div id="indexedCost" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Taxable Gain</strong></div>
                                    <div id="taxableGain" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Total Tax (incl. cess)</strong></div>
                                    <div id="totalTax" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <small class="text-muted">If gains are negative, tax is zero. Figures are estimates; consult a tax advisor for personalized advice.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Components</div>
                    <div class="card-body">
                        <canvas id="cgt-chart" height="140"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    var cgtChart = null;

    function fmtINR(x) {
        if (isNaN(x)) return "—";
        try { return "₹ " + Number(x).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
        catch(e) { return "₹ " + (Math.round(Number(x))).toString(); }
    }

    function updateVisibility() {
        var asset = $("#assetType").val();
        if (asset === "equity") {
            $("#applyIndexation").prop("checked", false).prop("disabled", true);
            $("#equityExemptionGroup").show();
            $("#debtRuleGroup").hide();
            $("#propertyExemptionGroup").hide();
        } else if (asset === "debtmf") {
            $("#applyIndexation").prop("disabled", false);
            $("#equityExemptionGroup").hide();
            $("#debtRuleGroup").show();
            $("#propertyExemptionGroup").hide();
            var rule = $("#debtRule").val();
            if (rule === "current") {
                $("#applyIndexation").prop("checked", false).prop("disabled", true);
            } else {
                $("#applyIndexation").prop("disabled", false);
            }
        } else if (asset === "gold") {
            $("#applyIndexation").prop("checked", true).prop("disabled", false);
            $("#equityExemptionGroup").hide();
            $("#debtRuleGroup").hide();
            $("#propertyExemptionGroup").hide();
        } else if (asset === "property") {
            $("#applyIndexation").prop("checked", true).prop("disabled", false);
            $("#equityExemptionGroup").hide();
            $("#debtRuleGroup").hide();
            $("#propertyExemptionGroup").show();
        }
    }

    function calculateCGT() {
        var asset = $("#assetType").val();
        var buyPrice = parseFloat($("#buyPrice").val()) || 0;
        var buyExpenses = parseFloat($("#buyExpenses").val()) || 0;
        var sellPrice = parseFloat($("#sellPrice").val()) || 0;
        var sellExpenses = parseFloat($("#sellExpenses").val()) || 0;
        var holdMonths = parseInt($("#holdMonths").val()) || 0;

        var applyIdx = $("#applyIndexation").is(":checked");
        var ciiBuy = parseFloat($("#ciiBuy").val()) || 0;
        var ciiSell = parseFloat($("#ciiSell").val()) || 0;
        var debtRule = $("#debtRule").val();

        var taxSlab = (parseFloat($("#taxSlabPct").val()) || 0) / 100.0;
        var cessPct = (parseFloat($("#cessPct").val()) || 0) / 100.0;
        var equityExempt = parseFloat($("#equityLTCGExempt").val()) || 0;
        var propExempt = parseFloat($("#propertyExemption").val()) || 0;

        var costBasis = buyPrice + buyExpenses;
        var netSale = sellPrice - sellExpenses;
        var unindexedGain = netSale - costBasis;

        var indexedCost = costBasis;
        if (applyIdx && ciiBuy > 0 && ciiSell > 0) {
            indexedCost = costBasis * (ciiSell / ciiBuy);
        }
        var indexedGain = netSale - indexedCost;

        // Determine STCG/LTCG thresholds
        var isLTCG = false;
        var rate = 0.0;
        var taxableGain = 0.0;
        var gainTypeLabel = "—";

        if (asset === "equity") {
            isLTCG = holdMonths >= 12;
            if (isLTCG) {
                gainTypeLabel = "LTCG (Equity)";
                // Equity LTCG 10% on gains beyond exemption; no indexation
                var taxable = Math.max(0, unindexedGain - equityExempt);
                taxableGain = taxable;
                rate = 0.10;
            } else {
                gainTypeLabel = "STCG (Equity)";
                taxableGain = Math.max(0, unindexedGain);
                rate = 0.15;
            }
            indexedCost = costBasis; // no indexation for equity
        } else if (asset === "debtmf") {
            if (debtRule === "current") {
                // Current rule: no indexation, slab rate irrespective of period
                isLTCG = false;
                gainTypeLabel = "STCG (Debt MF - Current Rule)";
                taxableGain = Math.max(0, unindexedGain);
                rate = taxSlab;
                indexedCost = costBasis;
            } else {
                // Legacy: LTCG ≥ 36m at 20% with indexation
                isLTCG = holdMonths >= 36;
                if (isLTCG) {
                    gainTypeLabel = "LTCG (Debt MF - Legacy Indexation)";
                    taxableGain = Math.max(0, indexedGain);
                    rate = 0.20;
                } else {
                    gainTypeLabel = "STCG (Debt MF)";
                    taxableGain = Math.max(0, unindexedGain);
                    rate = taxSlab;
                    indexedCost = costBasis;
                }
            }
        } else if (asset === "gold") {
            isLTCG = holdMonths >= 36;
            if (isLTCG) {
                gainTypeLabel = "LTCG (Gold)";
                taxableGain = Math.max(0, applyIdx ? indexedGain : unindexedGain);
                rate = 0.20;
            } else {
                gainTypeLabel = "STCG (Gold)";
                taxableGain = Math.max(0, unindexedGain);
                rate = taxSlab;
                indexedCost = costBasis;
            }
        } else if (asset === "property") {
            isLTCG = holdMonths >= 24;
            if (isLTCG) {
                gainTypeLabel = "LTCG (Property)";
                var base = applyIdx ? indexedGain : unindexedGain;
                taxableGain = Math.max(0, base - propExempt);
                rate = 0.20;
            } else {
                gainTypeLabel = "STCG (Property)";
                taxableGain = Math.max(0, unindexedGain);
                rate = taxSlab;
                indexedCost = costBasis;
            }
        }

        var tax = Math.max(0, taxableGain * rate);
        var cess = tax * cessPct;
        var totalTax = tax + cess;

        // Update UI
        $("#gainType").text(gainTypeLabel + (isLTCG ? "" : ""));
        $("#taxRateApplied").text((rate * 100).toFixed(2) + " %");
        $("#unindexedGain").text(fmtINR(unindexedGain));
        $("#indexedCost").text(fmtINR(indexedCost));
        $("#taxableGain").text(fmtINR(taxableGain));
        $("#totalTax").text(fmtINR(totalTax));

        // Chart
        var compLabels = ["Sale Price", "Cost Basis", "Indexed Cost", "Unindexed Gain", "Tax (incl. cess)"];
        var compData = [netSale, costBasis, indexedCost, Math.max(0, unindexedGain), totalTax];

        if (cgtChart) cgtChart.destroy();
        var ctx = document.getElementById("cgt-chart").getContext("2d");
        cgtChart = new Chart(ctx, {
            type: "bar",
            data: {
                labels: compLabels,
                datasets: [{
                    label: "Amount (₹)",
                    data: compData,
                    backgroundColor: ["#1565c0","#6d4c41","#8d6e63","#2e7d32","#c62828"]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        callbacks: {
                            label: function(ctx){ return "₹ " + Number(ctx.parsed.y).toLocaleString('en-IN'); }
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
                    }
                }
            }
        });
    }

    function wireUp() {
        $("#assetType, #buyPrice, #buyExpenses, #sellPrice, #sellExpenses, #holdMonths, #applyIndexation, #ciiBuy, #ciiSell, #debtRule, #taxSlabPct, #cessPct, #equityLTCGExempt, #propertyExemption")
            .on("input change", function(){ updateVisibility(); calculateCGT(); });
        updateVisibility();
        calculateCGT();
    }

    $(document).ready(wireUp);
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
