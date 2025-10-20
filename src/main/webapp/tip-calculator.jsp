<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tip Calculator & Split Bill – Restaurant Gratuity, Per-Person Split</title>
    <meta name="description" content="Calculate tip and split the bill per person. Set tip %, tax, currency, and party size. Includes rounding options and a QR code to share the bill breakdown.">
    <meta name="keywords" content="tip calculator, split the bill calculator, restaurant tip calculator, gratuity calculator">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Tip Calculator & Split Bill",
      "applicationCategory": "LifestyleApplication",
      "description": "Calculate restaurant tips and split bills per person with currency, tax, and rounding.",
      "url": "https://8gwifi.org/tip-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Tip Calculator & Split Bill</h1>
    <p>Compute gratuity and split the bill fairly across the table. Adjust tip %, tax, and rounding, with currency presets.</p>

    <form id="tip-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Bill Details</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <select id="currencyCode" class="form-control">
                                    <option value="USD">USD</option>
                                    <option value="EUR">EUR</option>
                                    <option value="GBP">GBP</option>
                                    <option value="INR" selected>INR</option>
                                    <option value="AUD">AUD</option>
                                    <option value="CAD">CAD</option>
                                    <option value="JPY">JPY</option>
                                    <option value="SGD">SGD</option>
                                </select>
                            </div>
                            <div class="form-group col-6">
                                <label for="billAmount">Bill Total (before tip)</label>
                                <input type="number" class="form-control" id="billAmount" value="2500" step="0.01">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="tipPercent">Tip %</label>
                                <input type="number" class="form-control" id="tipPercent" value="10" step="0.5">
                                <small class="text-muted d-block">Customs vary by country/venue</small>
                            </div>
                            <div class="form-group col-6">
                                <label for="taxPercent">Tax % (optional)</label>
                                <input type="number" class="form-control" id="taxPercent" value="0" step="0.1">
                                <small class="text-muted d-block">Applied on pre-tip bill</small>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="partySize">Party Size</label>
                                <input type="number" class="form-control" id="partySize" value="4" min="1">
                            </div>
                            <div class="form-group col-6">
                                <label for="rounding">Rounding</label>
                                <select id="rounding" class="form-control">
                                    <option value="none" selected>No Rounding</option>
                                    <option value="nearest">Per-person to nearest</option>
                                    <option value="up">Per-person round up</option>
                                </select>
                                <small class="text-muted d-block">Round to currency unit</small>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="tipAdjust">Adjust Tip (+/−)</label>
                            <input type="range" class="form-control-range w-100" id="tipAdjust" min="-5" max="5" value="0">
                            <small class="text-muted">Fine-tune tip by ±5 percentage points</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Some venues add service charge automatically; set Tip % accordingly.</li>
                        <li>Rounding applies per-person to simplify settlement.</li>
                        <li>Use QR to share the breakdown with your group.</li>
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
                                    <div><strong>Tip Amount</strong></div>
                                    <div id="tipAmount" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Total with Tax + Tip</strong></div>
                                    <div id="totalWithAll" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Per Person</strong></div>
                                    <div id="perPerson" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3 d-flex align-items-center">
                                <img id="qrImg" alt="QR" width="120" height="120" class="ml-auto d-none"/>
                            </div>
                        </div>
                        <button type="button" class="btn btn-outline-primary btn-sm" id="makeQR">Generate Shareable QR</button>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 2 }); }
    }

    function calcTip() {
        var curr = ($("#currencyCode").val() || "INR").toUpperCase();
        var bill = parseFloat($("#billAmount").val()) || 0;
        var tipPct = (parseFloat($("#tipPercent").val()) || 0) + (parseFloat($("#tipAdjust").val()) || 0);
        var taxPct = (parseFloat($("#taxPercent").val()) || 0);
        var party = Math.max(1, parseInt($("#partySize").val()) || 1);
        var rounding = $("#rounding").val();

        var taxAmt = bill * (taxPct/100.0);
        var tipAmt = bill * (tipPct/100.0);
        var total = bill + taxAmt + tipAmt;

        var per = total / party;
        if (rounding !== "none") {
            if (rounding === "nearest") per = Math.round(per);
            if (rounding === "up") per = Math.ceil(per);
        }

        $("#tipAmount").text(fmtCurr(tipAmt, curr));
        $("#totalWithAll").text(fmtCurr(total, curr));
        $("#perPerson").text(fmtCurr(per, curr));
    }

    function buildQR() {
        var curr = ($("#currencyCode").val() || "INR").toUpperCase();
        var bill = parseFloat($("#billAmount").val()) || 0;
        var tipPct = (parseFloat($("#tipPercent").val()) || 0) + (parseFloat($("#tipAdjust").val()) || 0);
        var taxPct = (parseFloat($("#taxPercent").val()) || 0);
        var party = Math.max(1, parseInt($("#partySize").val()) || 1);

        var taxAmt = bill * (taxPct/100.0);
        var tipAmt = bill * (tipPct/100.0);
        var total = bill + taxAmt + tipAmt;
        var per = total / party;

        var payload = "Bill: " + bill + " " + curr +
                      "\\nTip%: " + tipPct.toFixed(1) +
                      "\\nTax%: " + taxPct.toFixed(1) +
                      "\\nTotal: " + total.toFixed(2) + " " + curr +
                      "\\nParty: " + party +
                      "\\nPer-person: " + per.toFixed(2) + " " + curr;

        var url = "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=" + encodeURIComponent(payload);
        $("#qrImg").attr("src", url).removeClass("d-none");
    }

    $("#currencyCode, #billAmount, #tipPercent, #taxPercent, #partySize, #rounding, #tipAdjust").on("input change", calcTip);
    $("#makeQR").on("click", buildQR);

    calcTip();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
