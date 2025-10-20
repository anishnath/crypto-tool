<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cost of Living & Salary Purchasing Power Comparison (Global)</title>
    <meta name="description" content="Compare cost of living between cities worldwide and calculate equivalent salary to maintain your lifestyle. Adjust category weights and FX rates for accurate purchasing power comparison.">
    <meta name="keywords" content="cost of living comparison, salary equivalence calculator, city comparison, purchasing power calculator, global cost of living, salary comparator">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Cost of Living & Salary Purchasing Power Comparator",
      "applicationCategory": "FinanceApplication",
      "description": "Compare cost of living across cities and estimate equivalent salary with category weights and FX conversion.",
      "url": "https://8gwifi.org/cost-of-living-comparison.jsp",
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
    <h1 class="mb-4">Cost of Living & Salary Purchasing Power Comparison</h1>
    <p>Select your current city and destination to estimate the equivalent salary needed to maintain your lifestyle. Adjust category weights and FX conversion for more precise results.</p>

    <form id="col-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Cities & Salary</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="srcCity">Current City</label>
                            <select id="srcCity" class="form-control"></select>
                        </div>
                        <div class="form-group">
                            <label for="dstCity">Destination City</label>
                            <select id="dstCity" class="form-control"></select>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-8">
                                <label for="srcSalary">Your Annual Salary (source currency)</label>
                                <input type="number" class="form-control" id="srcSalary" value="80000">
                            </div>
                            <div class="form-group col-4">
                                <label for="srcCurr">Source Currency</label>
                                <input type="text" class="form-control" id="srcCurr" value="USD">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-8">
                                <label for="dstOffer">Offered Salary (destination currency) (optional)</label>
                                <input type="number" class="form-control" id="dstOffer" value="">
                            </div>
                            <div class="form-group col-4">
                                <label for="dstCurr">Destination Currency</label>
                                <input type="text" class="form-control" id="dstCurr" value="USD">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-8">
                                <label for="fxRate">FX Rate (1 source = ? destination)</label>
                                <input type="number" class="form-control" id="fxRate" value="1" step="0.0001">
                                <small class="text-muted">Set to 1 if same currency</small>
                            </div>
                            <div class="form-group col-4 d-flex align-items-end">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="applyFx" checked>
                                    <label class="form-check-label" for="applyFx">Apply FX conversion</label>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Tip: Enter your offer to see the surplus/deficit vs required equivalent salary.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Advanced: Category Weights (%)</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-4">
                                <label for="wHousing">Housing</label>
                                <input type="number" class="form-control" id="wHousing" value="35" step="0.1">
                            </div>
                            <div class="form-group col-4">
                                <label for="wFood">Food</label>
                                <input type="number" class="form-control" id="wFood" value="20" step="0.1">
                            </div>
                            <div class="form-group col-4">
                                <label for="wTransport">Transport</label>
                                <input type="number" class="form-control" id="wTransport" value="10" step="0.1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-4">
                                <label for="wHealthcare">Healthcare</label>
                                <input type="number" class="form-control" id="wHealthcare" value="10" step="0.1">
                            </div>
                            <div class="form-group col-4">
                                <label for="wUtilities">Utilities</label>
                                <input type="number" class="form-control" id="wUtilities" value="10" step="0.1">
                            </div>
                            <div class="form-group col-4">
                                <label for="wMisc">Misc</label>
                                <input type="number" class="form-control" id="wMisc" value="15" step="0.1">
                            </div>
                        </div>
                        <small class="text-muted">Weights should total 100. Tool will normalize if they don’t.</small>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>City indices are relative to 100 baseline; category weights compute overall cost indices dynamically.</li>
                        <li>Equivalent salary (dest) = source salary × (dest index ÷ source index) × FX (if applied).</li>
                        <li>Chart compares category indices to visualize where costs differ most.</li>
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
                                    <div><strong>Required Equivalent Salary</strong></div>
                                    <div id="eqSalary" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted"><span id="dstCurrLabel">—</span></small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Offer vs Required</strong></div>
                                    <div id="surplus" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Positive = surplus; Negative = shortfall</small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Overall Index (Source)</strong></div>
                                    <div id="idxSrc" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Overall Index (Destination)</strong></div>
                                    <div id="idxDst" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <small class="text-muted">This is an estimate. Actual expenses vary by lifestyle and neighborhood. Taxes are not included.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Category Comparison</div>
                    <div class="card-body">
                        <canvas id="col-chart" height="150"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <div class="mt-4">
        <h4>Category Breakdown</h4>
        <div style="max-height: 420px; overflow-y: auto;">
            <table class="table table-striped">
                <thead style="position: sticky; top: 0; background-color: white;">
                    <tr>
                        <th>Category</th>
                        <th>Source Index</th>
                        <th>Destination Index</th>
                        <th>Weight (%)</th>
                    </tr>
                </thead>
                <tbody id="col-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var colChart = null;

    // Expanded global dataset: indices relative to 100 baseline (illustrative values)
    var cityData = {
        // North America (US)
        "New York, US": { currency: "USD", categories: { housing: 185, food: 135, transport: 120, healthcare: 140, utilities: 130, misc: 145 } },
        "San Francisco, US": { currency: "USD", categories: { housing: 200, food: 140, transport: 120, healthcare: 135, utilities: 125, misc: 150 } },
        "Los Angeles, US": { currency: "USD", categories: { housing: 160, food: 125, transport: 120, healthcare: 130, utilities: 125, misc: 130 } },
        "Chicago, US": { currency: "USD", categories: { housing: 130, food: 115, transport: 110, healthcare: 120, utilities: 115, misc: 115 } },
        "Austin, US": { currency: "USD", categories: { housing: 135, food: 115, transport: 110, healthcare: 115, utilities: 110, misc: 115 } },
        "Seattle, US": { currency: "USD", categories: { housing: 165, food: 125, transport: 115, healthcare: 125, utilities: 120, misc: 130 } },
        "Boston, US": { currency: "USD", categories: { housing: 170, food: 125, transport: 115, healthcare: 130, utilities: 125, misc: 135 } },
        "Miami, US": { currency: "USD", categories: { housing: 140, food: 120, transport: 110, healthcare: 120, utilities: 115, misc: 120 } },
        "Washington DC, US": { currency: "USD", categories: { housing: 165, food: 125, transport: 120, healthcare: 130, utilities: 120, misc: 130 } },
        "Houston, US": { currency: "USD", categories: { housing: 120, food: 110, transport: 110, healthcare: 115, utilities: 110, misc: 110 } },

        // Canada
        "Toronto, CA": { currency: "CAD", categories: { housing: 150, food: 120, transport: 115, healthcare: 120, utilities: 120, misc: 125 } },
        "Vancouver, CA": { currency: "CAD", categories: { housing: 160, food: 125, transport: 120, healthcare: 120, utilities: 125, misc: 130 } },
        "Montreal, CA": { currency: "CAD", categories: { housing: 120, food: 110, transport: 110, healthcare: 115, utilities: 110, misc: 110 } },
        "Calgary, CA": { currency: "CAD", categories: { housing: 130, food: 115, transport: 115, healthcare: 115, utilities: 115, misc: 115 } },
        "Ottawa, CA": { currency: "CAD", categories: { housing: 125, food: 110, transport: 110, healthcare: 115, utilities: 110, misc: 110 } },

        // UK & Ireland
        "London, UK": { currency: "GBP", categories: { housing: 170, food: 135, transport: 130, healthcare: 120, utilities: 140, misc: 140 } },
        "Manchester, UK": { currency: "GBP", categories: { housing: 115, food: 115, transport: 110, healthcare: 110, utilities: 115, misc: 110 } },
        "Edinburgh, UK": { currency: "GBP", categories: { housing: 130, food: 120, transport: 115, healthcare: 115, utilities: 120, misc: 120 } },
        "Birmingham, UK": { currency: "GBP", categories: { housing: 110, food: 110, transport: 110, healthcare: 110, utilities: 110, misc: 110 } },
        "Dublin, IE": { currency: "EUR", categories: { housing: 150, food: 125, transport: 115, healthcare: 115, utilities: 130, misc: 125 } },

        // Western Europe
        "Paris, FR": { currency: "EUR", categories: { housing: 160, food: 125, transport: 115, healthcare: 115, utilities: 130, misc: 130 } },
        "Lyon, FR": { currency: "EUR", categories: { housing: 120, food: 115, transport: 110, healthcare: 110, utilities: 115, misc: 115 } },
        "Berlin, DE": { currency: "EUR", categories: { housing: 120, food: 110, transport: 105, healthcare: 110, utilities: 120, misc: 110 } },
        "Munich, DE": { currency: "EUR", categories: { housing: 150, food: 120, transport: 110, healthcare: 115, utilities: 125, misc: 120 } },
        "Amsterdam, NL": { currency: "EUR", categories: { housing: 150, food: 120, transport: 115, healthcare: 115, utilities: 120, misc: 125 } },
        "Rotterdam, NL": { currency: "EUR", categories: { housing: 120, food: 115, transport: 110, healthcare: 110, utilities: 115, misc: 115 } },
        "Zurich, CH": { currency: "CHF", categories: { housing: 200, food: 160, transport: 130, healthcare: 140, utilities: 140, misc: 160 } },
        "Geneva, CH": { currency: "CHF", categories: { housing: 195, food: 155, transport: 130, healthcare: 140, utilities: 140, misc: 155 } },
        "Stockholm, SE": { currency: "SEK", categories: { housing: 140, food: 125, transport: 120, healthcare: 120, utilities: 125, misc: 125 } },
        "Copenhagen, DK": { currency: "DKK", categories: { housing: 150, food: 130, transport: 120, healthcare: 120, utilities: 130, misc: 130 } },
        "Oslo, NO": { currency: "NOK", categories: { housing: 160, food: 135, transport: 120, healthcare: 120, utilities: 130, misc: 135 } },
        "Vienna, AT": { currency: "EUR", categories: { housing: 130, food: 120, transport: 110, healthcare: 115, utilities: 120, misc: 120 } },
        "Madrid, ES": { currency: "EUR", categories: { housing: 125, food: 115, transport: 110, healthcare: 110, utilities: 115, misc: 115 } },
        "Barcelona, ES": { currency: "EUR", categories: { housing: 130, food: 120, transport: 110, healthcare: 110, utilities: 115, misc: 120 } },
        "Rome, IT": { currency: "EUR", categories: { housing: 130, food: 120, transport: 110, healthcare: 110, utilities: 120, misc: 120 } },
        "Milan, IT": { currency: "EUR", categories: { housing: 145, food: 125, transport: 115, healthcare: 115, utilities: 125, misc: 125 } },

        // Central & Eastern Europe
        "Prague, CZ": { currency: "CZK", categories: { housing: 110, food: 105, transport: 100, healthcare: 105, utilities: 110, misc: 105 } },
        "Warsaw, PL": { currency: "PLN", categories: { housing: 105, food: 100, transport: 100, healthcare: 100, utilities: 105, misc: 100 } },
        "Budapest, HU": { currency: "HUF", categories: { housing: 100, food: 100, transport: 95, healthcare: 100, utilities: 100, misc: 100 } },

        // Asia
        "Singapore, SG": { currency: "SGD", categories: { housing: 190, food: 120, transport: 130, healthcare: 130, utilities: 140, misc: 140 } },
        "Hong Kong, HK": { currency: "HKD", categories: { housing: 210, food: 140, transport: 120, healthcare: 130, utilities: 135, misc: 150 } },
        "Tokyo, JP": { currency: "JPY", categories: { housing: 150, food: 120, transport: 140, healthcare: 120, utilities: 120, misc: 125 } },
        "Seoul, KR": { currency: "KRW", categories: { housing: 130, food: 120, transport: 120, healthcare: 120, utilities: 120, misc: 120 } },
        "Kuala Lumpur, MY": { currency: "MYR", categories: { housing: 90, food: 90, transport: 85, healthcare: 90, utilities: 95, misc: 90 } },
        "Bangkok, TH": { currency: "THB", categories: { housing: 85, food: 90, transport: 85, healthcare: 90, utilities: 90, misc: 90 } },
        "Jakarta, ID": { currency: "IDR", categories: { housing: 80, food: 85, transport: 80, healthcare: 85, utilities: 85, misc: 85 } },
        "Manila, PH": { currency: "PHP", categories: { housing: 85, food: 85, transport: 80, healthcare: 85, utilities: 85, misc: 85 } },
        "Shanghai, CN": { currency: "CNY", categories: { housing: 130, food: 110, transport: 110, healthcare: 110, utilities: 115, misc: 115 } },
        "Beijing, CN": { currency: "CNY", categories: { housing: 125, food: 110, transport: 110, healthcare: 110, utilities: 115, misc: 110 } },
        "Shenzhen, CN": { currency: "CNY", categories: { housing: 120, food: 110, transport: 110, healthcare: 110, utilities: 110, misc: 110 } },
        "Bangalore, IN": { currency: "INR", categories: { housing: 70, food: 80, transport: 65, healthcare: 75, utilities: 85, misc: 80 } },
        "Mumbai, IN": { currency: "INR", categories: { housing: 95, food: 85, transport: 75, healthcare: 80, utilities: 90, misc: 85 } },
        "Delhi, IN": { currency: "INR", categories: { housing: 80, food: 80, transport: 70, healthcare: 75, utilities: 85, misc: 80 } },
        "Hyderabad, IN": { currency: "INR", categories: { housing: 75, food: 80, transport: 70, healthcare: 75, utilities: 80, misc: 80 } },
        "Chennai, IN": { currency: "INR", categories: { housing: 75, food: 80, transport: 70, healthcare: 75, utilities: 80, misc: 80 } },
        "Pune, IN": { currency: "INR", categories: { housing: 80, food: 80, transport: 70, healthcare: 75, utilities: 80, misc: 80 } },
        "Kolkata, IN": { currency: "INR", categories: { housing: 65, food: 75, transport: 65, healthcare: 70, utilities: 75, misc: 75 } },
        "Ahmedabad, IN": { currency: "INR", categories: { housing: 65, food: 75, transport: 65, healthcare: 70, utilities: 75, misc: 75 } },

        // Middle East
        "Dubai, AE": { currency: "AED", categories: { housing: 145, food: 115, transport: 100, healthcare: 120, utilities: 110, misc: 120 } },
        "Riyadh, SA": { currency: "SAR", categories: { housing: 110, food: 105, transport: 90, healthcare: 110, utilities: 100, misc: 105 } },
        "Doha, QA": { currency: "QAR", categories: { housing: 135, food: 110, transport: 95, healthcare: 110, utilities: 105, misc: 110 } },
        "Tel Aviv, IL": { currency: "ILS", categories: { housing: 170, food: 130, transport: 115, healthcare: 120, utilities: 125, misc: 130 } },

        // Africa
        "Johannesburg, ZA": { currency: "ZAR", categories: { housing: 90, food: 90, transport: 85, healthcare: 90, utilities: 90, misc: 90 } },
        "Cape Town, ZA": { currency: "ZAR", categories: { housing: 95, food: 95, transport: 85, healthcare: 90, utilities: 90, misc: 95 } },
        "Nairobi, KE": { currency: "KES", categories: { housing: 80, food: 85, transport: 80, healthcare: 85, utilities: 85, misc: 85 } },
        "Lagos, NG": { currency: "NGN", categories: { housing: 85, food: 90, transport: 85, healthcare: 85, utilities: 85, misc: 90 } },
        "Cairo, EG": { currency: "EGP", categories: { housing: 70, food: 80, transport: 75, healthcare: 80, utilities: 80, misc: 80 } },

        // Latin America
        "Mexico City, MX": { currency: "MXN", categories: { housing: 90, food: 90, transport: 85, healthcare: 90, utilities: 90, misc: 90 } },
        "Sao Paulo, BR": { currency: "BRL", categories: { housing: 95, food: 95, transport: 90, healthcare: 90, utilities: 90, misc: 95 } },
        "Rio de Janeiro, BR": { currency: "BRL", categories: { housing: 90, food: 95, transport: 90, healthcare: 90, utilities: 90, misc: 95 } },
        "Buenos Aires, AR": { currency: "ARS", categories: { housing: 85, food: 90, transport: 85, healthcare: 85, utilities: 85, misc: 90 } },
        "Santiago, CL": { currency: "CLP", categories: { housing: 95, food: 95, transport: 90, healthcare: 90, utilities: 90, misc: 95 } },
        "Lima, PE": { currency: "PEN", categories: { housing: 85, food: 90, transport: 85, healthcare: 85, utilities: 85, misc: 90 } },
        "Bogota, CO": { currency: "COP", categories: { housing: 85, food: 90, transport: 85, healthcare: 85, utilities: 85, misc: 90 } },

        // Oceania
        "Sydney, AU": { currency: "AUD", categories: { housing: 160, food: 130, transport: 120, healthcare: 120, utilities: 130, misc: 130 } },
        "Melbourne, AU": { currency: "AUD", categories: { housing: 150, food: 125, transport: 115, healthcare: 115, utilities: 125, misc: 125 } },
        "Brisbane, AU": { currency: "AUD", categories: { housing: 130, food: 120, transport: 110, healthcare: 115, utilities: 120, misc: 120 } },
        "Auckland, NZ": { currency: "NZD", categories: { housing: 150, food: 125, transport: 115, healthcare: 115, utilities: 125, misc: 125 } },
        "Wellington, NZ": { currency: "NZD", categories: { housing: 140, food: 120, transport: 115, healthcare: 115, utilities: 120, misc: 120 } }
    };

    var categoriesOrder = ["housing", "food", "transport", "healthcare", "utilities", "misc"];
    var categoryLabels = {
        housing: "Housing",
        food: "Food",
        transport: "Transport",
        healthcare: "Healthcare",
        utilities: "Utilities",
        misc: "Misc"
    };

    function fmt(x) {
        if (isNaN(x)) return "—";
        return Number(x).toLocaleString('en-IN', { maximumFractionDigits: 0 });
    }

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + fmt(amount); }
    }

    function getWeights() {
        var w = {
            housing: parseFloat($("#wHousing").val()) || 0,
            food: parseFloat($("#wFood").val()) || 0,
            transport: parseFloat($("#wTransport").val()) || 0,
            healthcare: parseFloat($("#wHealthcare").val()) || 0,
            utilities: parseFloat($("#wUtilities").val()) || 0,
            misc: parseFloat($("#wMisc").val()) || 0
        };
        var sum = w.housing + w.food + w.transport + w.healthcare + w.utilities + w.misc;
        if (sum <= 0) sum = 1;
        // Normalize to 100
        for (var k in w) {
            w[k] = w[k] * (100.0 / sum);
        }
        return w;
    }

    function overallIndex(cityName, weights) {
        var c = cityData[cityName];
        var idx = 0;
        categoriesOrder.forEach(function(cat){
            idx += (c.categories[cat] || 100) * (weights[cat] / 100.0);
        });
        return idx;
    }

    function fillCitySelects() {
        var options = Object.keys(cityData);
        options.sort();
        $("#srcCity, #dstCity").empty();
        options.forEach(function(name){
            $("#srcCity").append('<option value="'+name+'">'+name+'</option>');
            $("#dstCity").append('<option value="'+name+'">'+name+'</option>');
        });
        $("#srcCity").val("New York, US");
        $("#dstCity").val("London, UK");
        $("#srcCurr").val(cityData[$("#srcCity").val()].currency);
        $("#dstCurr").val(cityData[$("#dstCity").val()].currency);
        $("#dstCurrLabel").text($("#dstCurr").val());
    }

    function updateCurrencies() {
        var s = $("#srcCity").val();
        var d = $("#dstCity").val();
        $("#srcCurr").val(cityData[s].currency);
        $("#dstCurr").val(cityData[d].currency);
        $("#dstCurrLabel").text($("#dstCurr").val());
    }

    function calculateCOL() {
        var srcCity = $("#srcCity").val();
        var dstCity = $("#dstCity").val();
        var srcSalary = parseFloat($("#srcSalary").val()) || 0;
        var dstOffer = parseFloat($("#dstOffer").val()) || 0;
        var srcCurr = $("#srcCurr").val().toUpperCase();
        var dstCurr = $("#dstCurr").val().toUpperCase();
        var fxRate = parseFloat($("#fxRate").val()) || 1; // 1 source = fxRate destination
        var applyFx = $("#applyFx").is(":checked");
        var weights = getWeights();

        if (!srcCity || !dstCity || srcSalary <= 0) {
            $("#eqSalary").text("—");
            $("#surplus").text("—");
            $("#idxSrc").text("—");
            $("#idxDst").text("—");
            $("#col-table").html("");
            if (colChart) { colChart.destroy(); colChart = null; }
            return;
        }

        var idxS = overallIndex(srcCity, weights);
        var idxD = overallIndex(dstCity, weights);

        $("#idxSrc").text(idxS.toFixed(1));
        $("#idxDst").text(idxD.toFixed(1));

        var conv = applyFx ? fxRate : 1.0;
        var eqDestSalary = srcSalary * (idxD / idxS) * conv;

        $("#eqSalary").text(fmtCurr(eqDestSalary, dstCurr));

        if (dstOffer > 0) {
            var diff = dstOffer - eqDestSalary;
            var sign = diff >= 0 ? "+" : "-";
            $("#surplus").text(sign + " " + fmtCurr(Math.abs(diff), dstCurr));
        } else {
            $("#surplus").text("—");
        }

        // Build table and chart datasets
        var tableHTML = "";
        var srcVals = [], dstVals = [], labels = [];
        categoriesOrder.forEach(function(cat){
            var s = cityData[srcCity].categories[cat] || 100;
            var d = cityData[dstCity].categories[cat] || 100;
            srcVals.push(s);
            dstVals.push(d);
            labels.push(categoryLabels[cat]);
            tableHTML += "<tr>" +
                "<td>" + categoryLabels[cat] + "</td>" +
                "<td>" + s.toFixed(1) + "</td>" +
                "<td>" + d.toFixed(1) + "</td>" +
                "<td>" + weights[cat].toFixed(1) + "</td>" +
                "</tr>";
        });
        $("#col-table").html(tableHTML);

        if (colChart) colChart.destroy();
        var ctx = document.getElementById("col-chart").getContext("2d");
        colChart = new Chart(ctx, {
            type: "bar",
            data: {
                labels: labels,
                datasets: [
                    { label: "Source", data: srcVals, backgroundColor: "rgba(21,101,192,0.6)" },
                    { label: "Destination", data: dstVals, backgroundColor: "rgba(46,125,50,0.6)" }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: "top" },
                    tooltip: {
                        callbacks: {
                            label: function(ctx){ return ctx.dataset.label + ": " + ctx.parsed.y.toFixed(1); }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: "Category Index (100 = baseline)" }
                    }
                }
            }
        });
    }

    function wireUpCOL() {
        fillCitySelects();
        $("#srcCity, #dstCity").on("change", function(){
            updateCurrencies();
            calculateCOL();
        });
        $("#srcSalary, #dstOffer, #srcCurr, #dstCurr, #fxRate, #applyFx, #wHousing, #wFood, #wTransport, #wHealthcare, #wUtilities, #wMisc")
            .on("input change", calculateCOL);
        calculateCOL();
    }

    $(document).ready(wireUpCOL);
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
