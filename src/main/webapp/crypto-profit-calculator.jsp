<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crypto Profit Calculator – Net Profit, ROI%, Break-even</title>
    <meta name="description" content="Calculate crypto trade profit and ROI%. Enter buy price, sell price, amount, and fees to see net results. Includes break-even price and quick scenarios.">
    <meta name="keywords" content="crypto profit calculator, crypto calculator, roi calculator, break-even price">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Crypto Profit Calculator",
      "applicationCategory":"FinanceApplication",
      "description":"Compute net profit and ROI% for crypto trades with fees.",
      "url":"https://8gwifi.org/crypto-profit-calculator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Crypto Profit Calculator</h1>
    <p>Calculate net profit and ROI% for your crypto trades. Enter prices, amount, and fees to get your results. Includes break-even price.</p>

    <form id="cp-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="coin">Coin</label>
                            <select class="form-control" id="coin">
                                <option>BTC</option>
                                <option>ETH</option>
                                <option>BNB</option>
                                <option>ADA</option>
                                <option>MATIC</option>
                                <option>SOL</option>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="buyPrice">Buy Price</label>
                                <input type="number" class="form-control" id="buyPrice" value="30000" step="0.0001">
                            </div>
                            <div class="form-group col-6">
                                <label for="sellPrice">Sell Price</label>
                                <input type="number" class="form-control" id="sellPrice" value="35000" step="0.0001">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="amount">Amount</label>
                                <input type="number" class="form-control" id="amount" value="0.5" step="0.00000001">
                            </div>
                            <div class="form-group col-6">
                                <label for="feesPct">Fees % (both sides total)</label>
                                <input type="number" class="form-control" id="feesPct" value="0.2" step="0.01">
                            </div>
                        </div>
                        <button type="button" class="btn btn-primary" id="btnCalc">Calculate</button>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Fees are applied on buy and sell combined as a single percentage of trade notional.</li>
                        <li>Break-even price includes fees.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Summary</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>Net Profit</strong>: <span id="netOut">—</span></div>
                            <div><strong>ROI%</strong>: <span id="roiOut">—</span></div>
                            <div><strong>Break-even Price</strong>: <span id="beOut">—</span></div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Quick Scenarios</div>
                    <div class="card-body">
                        <table class="table table-sm">
                            <thead><tr><th>Sell Price</th><th>Profit</th><th>ROI%</th></tr></thead>
                            <tbody id="scnBody"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function fmt(x){ return Number(x).toLocaleString('en-IN', { maximumFractionDigits: 8 }); }

function calc(){
  var buy = parseFloat(document.getElementById("buyPrice").value)||0;
  var sell = parseFloat(document.getElementById("sellPrice").value)||0;
  var amt = parseFloat(document.getElementById("amount").value)||0;
  var feePct = parseFloat(document.getElementById("feesPct").value)||0;

  var grossBuy = buy * amt;
  var grossSell = sell * amt;
  var fees = (grossBuy + grossSell) * (feePct/100);
  var net = grossSell - grossBuy - fees;
  var roi = grossBuy>0 ? (net / grossBuy) * 100 : 0;

  document.getElementById("netOut").textContent = fmt(net);
  document.getElementById("roiOut").textContent = roi.toFixed(2) + "%";

  // Break-even sell price: set net=0 => sell*amt - buy*amt - ( (buy*amt + sell*amt)*f ) = 0
  // => sell - buy - f*(buy + sell) = 0 => sell*(1 - f) = buy*(1+f) => sell = buy*(1+f)/(1-f)
  var f = feePct/100;
  var be = (1-f) !== 0 ? buy * (1+f) / (1-f) : buy;
  document.getElementById("beOut").textContent = fmt(be);

  // Scenarios
  var body = document.getElementById("scnBody");
  body.innerHTML = "";
  [ -10, -5, 5, 10, 20 ].forEach(function(pct){
    var s = buy * (1 + pct/100);
    var gb = buy*amt, gs = s*amt, fees2 = (gb+gs)*(f), net2 = gs - gb - fees2;
    var roi2 = gb>0 ? (net2/gb)*100 : 0;
    var tr = "<tr><td>"+fmt(s)+"</td><td>"+fmt(net2)+"</td><td>"+roi2.toFixed(2)+"%</td></tr>";
    body.insertAdjacentHTML("beforeend", tr);
  });
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
