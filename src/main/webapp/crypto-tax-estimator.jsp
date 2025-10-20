<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crypto Tax Estimator (US) – Short/Long-Term</title>
    <meta name="description" content="Estimate crypto taxes in the US. Enter gains/losses, holding period, and tax bracket to calculate estimated tax owed.">
    <meta name="keywords" content="crypto tax calculator, bitcoin tax calculator, capital gains tax, short term, long term, us brackets">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Crypto Tax Estimator",
      "applicationCategory":"FinanceApplication",
      "description":"Estimate US crypto taxes using short/long-term rates and bracket selection.",
      "url":"https://8gwifi.org/crypto-tax-estimator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Crypto Tax Estimator (US)</h1>
    <p>Estimate US crypto taxes. Select holding period (short vs long), choose a filing bracket, and apply loss offsets.</p>

    <form id="tax-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="gain">Gains/Losses ($)</label>
                            <input type="number" class="form-control" id="gain" value="5000" step="0.01">
                        </div>
                        <div class="form-group">
                            <label for="hold">Holding Period</label>
                            <select id="hold" class="form-control">
                                <option value="short" selected>Short-term (≤ 12 months)</option>
                                <option value="long">Long-term (> 12 months)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="bracket">Tax Bracket</label>
                            <select id="bracket" class="form-control">
                                <option value="0">0%</option>
                                <option value="10">10%</option>
                                <option value="12">12%</option>
                                <option value="22">22%</option>
                                <option value="24">24%</option>
                                <option value="32">32%</option>
                                <option value="35">35%</option>
                                <option value="37">37%</option>
                            </select>
                            <small class="text-muted d-block">Approximate; consult current IRS tables</small>
                        </div>
                        <div class="form-group">
                            <label for="ltcgr">Long-term Capital Gains Rate</label>
                            <select id="ltcgr" class="form-control">
                                <option value="0">0%</option>
                                <option value="15" selected>15%</option>
                                <option value="20">20%</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="lossOffset">Loss Offset ($)</label>
                            <input type="number" class="form-control" id="lossOffset" value="0" step="0.01">
                        </div>
                        <button type="button" class="btn btn-primary" id="btnCalc">Estimate Tax</button>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Assumptions:
                    <ul class="mb-0">
                        <li>Short-term gains taxed at ordinary income bracket selected above.</li>
                        <li>Long-term gains taxed at LTCG rate selected above.</li>
                        <li>Loss offset reduces taxable gains; capped to gains here for simplicity.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Result</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>Taxable Gain</strong>: <span id="taxable">—</span></div>
                            <div><strong>Estimated Tax Owed</strong>: <span id="taxOwed">—</span></div>
                            <div><strong>Effective Tax Rate</strong>: <span id="effRate">—</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function fmt(x){ return Number(x).toLocaleString('en-IN', { maximumFractionDigits: 2 }); }

function calc(){
  var gain = parseFloat(document.getElementById("gain").value)||0;
  var hold = document.getElementById("hold").value;
  var bracket = parseFloat(document.getElementById("bracket").value)||0;
  var ltcg = parseFloat(document.getElementById("ltcgr").value)||0;
  var loss = parseFloat(document.getElementById("lossOffset").value)||0;

  var taxableGain = Math.max(0, gain - Math.max(0, loss));
  var rate = (hold === "short") ? bracket : ltcg;
  var tax = taxableGain * (rate/100);
  var eff = gain>0 ? (tax/gain)*100 : 0;

  document.getElementById("taxable").textContent = fmt(taxableGain);
  document.getElementById("taxOwed").textContent = fmt(tax);
  document.getElementById("effRate").textContent = eff.toFixed(2) + "%";
}
document.getElementById("btnCalc").addEventListener("click", calc);
calc();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>
    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
