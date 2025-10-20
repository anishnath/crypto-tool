<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ethereum Gas Fee Estimator – Gas × Gwei = Cost</title>
    <meta name="description" content="Estimate Ethereum gas fees. Enter gas units and gwei price to see total cost in ETH and USD. Includes low/avg/high presets.">
    <meta name="keywords" content="ethereum gas calculator, gas fee calculator, gas to eth, gwei to usd">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Ethereum Gas Fee Estimator",
      "applicationCategory":"UtilityApplication",
      "description":"Estimate ETH gas fees with gwei presets and USD conversion.",
      "url":"https://8gwifi.org/ethereum-gas-fee-estimator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Ethereum Gas Fee Estimator</h1>
    <p>Enter gas units and gwei to estimate transaction cost in ETH and USD. Use presets for low/avg/high network conditions.</p>

    <form id="gas-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="gasUnits">Gas Units</label>
                                <input type="number" class="form-control" id="gasUnits" value="21000" step="1">
                                <small class="text-muted">Simple transfer ≈ 21,000</small>
                            </div>
                            <div class="form-group col-6">
                                <label for="gwei">Gwei</label>
                                <input type="number" class="form-control" id="gwei" value="30" step="1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="ethPrice">ETH Price ($)</label>
                                <input type="number" class="form-control" id="ethPrice" value="3000" step="0.01">
                                <small id="ethLiveNote" class="text-muted d-block">Live price: fetching…</small>
                            </div>
                            <div class="form-group col-6">
                                <label>Presets</label><br>
                                <button type="button" class="btn btn-sm btn-light" data-gwei="10">Low</button>
                                <button type="button" class="btn btn-sm btn-light" data-gwei="30">Avg</button>
                                <button type="button" class="btn btn-sm btn-light" data-gwei="80">High</button>
                            </div>
                        </div>
                        <button type="button" class="btn btn-primary" id="btnCalc">Estimate</button>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Result</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>Cost (ETH)</strong>: <span id="ethOut">—</span></div>
                            <div><strong>Cost (USD)</strong>: <span id="usdOut">—</span></div>
                            <small class="text-muted d-block mt-2">Formula: gas × gwei ÷ 1e9 = ETH</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function fmt(x){ return Number(x).toLocaleString('en-IN', { maximumFractionDigits: 8 }); }

function calc(){
  var gas = parseFloat(document.getElementById("gasUnits").value)||0;
  var gwei = parseFloat(document.getElementById("gwei").value)||0;
  var price = parseFloat(document.getElementById("ethPrice").value)||0;
  var eth = gas * gwei / 1e9;
  var usd = eth * price;
  document.getElementById("ethOut").textContent = fmt(eth);
  document.getElementById("usdOut").textContent = fmt(usd);
}
document.getElementById("btnCalc").addEventListener("click", calc);
document.querySelectorAll("[data-gwei]").forEach(function(b){
  b.addEventListener("click", function(){ document.getElementById("gwei").value = this.getAttribute("data-gwei"); calc(); });
});
calc();

// Try to fetch live ETH price with a fallback to the current input
async function fetchETHPrice() {
  var note = document.getElementById("ethLiveNote");
  var input = document.getElementById("ethPrice");
  try {
    // timeout wrapper (3 seconds)
    var withTimeout = function(p, ms){ return Promise.race([p, new Promise(function(_,rej){ setTimeout(function(){ rej(new Error("timeout")); }, ms); })]); };
    var resp = await withTimeout(fetch("https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd"), 3000);
    if (!resp.ok) throw new Error("http "+resp.status);
    var data = await resp.json();
    var price = data && data.ethereum && data.ethereum.usd;
    if (typeof price === "number" && isFinite(price)) {
      input.value = price.toFixed(2);
      if (note) note.textContent = "Live price: $" + price.toFixed(2) + " (CoinGecko)";
      calc();
      return;
    }
    if (note) note.textContent = "Live price unavailable; using entered price.";
  } catch (e) {
    if (note) note.textContent = "Live price fetch failed; using entered price.";
  }
}
// Kick off live fetch (non-blocking)
fetchETHPrice();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>
    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
