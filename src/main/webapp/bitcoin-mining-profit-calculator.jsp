<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bitcoin Mining Profit Calculator – Daily/Monthly Profit & ROI</title>
    <meta name="description" content="Estimate Bitcoin mining profitability. Enter hashrate, power usage, electricity rate, BTC price, network hashrate, and block reward to see daily/monthly profit and payback.">
    <meta name="keywords" content="bitcoin mining calculator, crypto mining calculator, mining roi, hashrate profit">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Bitcoin Mining Profit Calculator",
      "applicationCategory":"FinanceApplication",
      "description":"Estimate BTC mining profitability with hashrate, costs, and network assumptions.",
      "url":"https://8gwifi.org/bitcoin-mining-profit-calculator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Bitcoin Mining Profit Calculator</h1>
    <p>Estimate your daily and monthly profit. Adjust inputs for hashrate, power usage, electricity cost, network hashrate, block reward, and BTC price.</p>

    <form id="bm-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="myHash">Your Hashrate (TH/s)</label>
                                <input type="number" class="form-control" id="myHash" value="100" step="0.01">
                            </div>
                            <div class="form-group col-6">
                                <label for="powerW">Power Usage (W)</label>
                                <input type="number" class="form-control" id="powerW" value="3000" step="1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="elecRate">Electricity Rate ($/kWh)</label>
                                <input type="number" class="form-control" id="elecRate" value="0.10" step="0.001">
                            </div>
                            <div class="form-group col-6">
                                <label for="btcPrice">BTC Price ($)</label>
                                <input type="number" class="form-control" id="btcPrice" value="60000" step="0.01">
                                <small id="btcLiveNote" class="text-muted d-block">Live price: fetching…</small>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="netHash">Network Hashrate (EH/s)</label>
                                <input type="number" class="form-control" id="netHash" value="500" step="1">
                            </div>
                            <div class="form-group col-6">
                                <label for="reward">Block Reward (BTC)</label>
                                <input type="number" class="form-control" id="reward" value="3.125" step="0.0001">
                                <small class="text-muted d-block">Blocks per day ≈ 144</small>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="rigCost">Hardware Cost ($)</label>
                            <input type="number" class="form-control" id="rigCost" value="3000" step="0.01">
                        </div>
                        <button type="button" class="btn btn-primary" id="btnCalc">Calculate</button>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Assumptions:
                    <ul class="mb-0">
                        <li>Expected BTC/day = (your hashrate / network hashrate) × 144 × block reward.</li>
                        <li>Power cost/day = (W ÷ 1000) × rate × 24.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Summary</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>BTC per Day</strong>: <span id="btcDay">—</span></div>
                            <div><strong>Revenue per Day ($)</strong>: <span id="revDay">—</span></div>
                            <div><strong>Power Cost per Day ($)</strong>: <span id="costDay">—</span></div>
                            <div><strong>Profit per Day ($)</strong>: <span id="profDay">—</span></div>
                            <hr>
                            <div><strong>Profit per Month ($)</strong>: <span id="profMonth">—</span></div>
                            <div><strong>Payback (months)</strong>: <span id="payback">—</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function fmt(x){ return Number(x).toLocaleString('en-IN', { maximumFractionDigits: 8 }); }

function calc(){
  var myTH = parseFloat(document.getElementById("myHash").value)||0;
  var W = parseFloat(document.getElementById("powerW").value)||0;
  var rate = parseFloat(document.getElementById("elecRate").value)||0;
  var price = parseFloat(document.getElementById("btcPrice").value)||0;
  var netEH = parseFloat(document.getElementById("netHash").value)||0;
  var reward = parseFloat(document.getElementById("reward").value)||0;
  var rig = parseFloat(document.getElementById("rigCost").value)||0;

  var myH = myTH * 1e12;
  var netH = netEH * 1e18;
  var blocksPerDay = 144;
  var btcDay = netH>0 ? (myH/netH) * blocksPerDay * reward : 0;
  var revDay = btcDay * price;
  var costDay = (W/1000) * rate * 24;
  var profDay = revDay - costDay;
  var profMonth = profDay * 30;
  var payback = profMonth>0 ? (rig/profMonth) : Infinity;

  document.getElementById("btcDay").textContent = fmt(btcDay);
  document.getElementById("revDay").textContent = fmt(revDay);
  document.getElementById("costDay").textContent = fmt(costDay);
  document.getElementById("profDay").textContent = fmt(profDay);
  document.getElementById("profMonth").textContent = isFinite(profMonth) ? fmt(profMonth) : "—";
  document.getElementById("payback").textContent = isFinite(payback) ? payback.toFixed(1) : "—";
}
document.getElementById("btnCalc").addEventListener("click", calc);
calc();

// Try to fetch live BTC price (fallback to current value if it fails)
async function fetchBTCPrice() {
  const note = document.getElementById("btcLiveNote");
  const input = document.getElementById("btcPrice");
  try {
    // timeout helper (3s)
    const withTimeout = (p, ms) => Promise.race([
      p,
      new Promise((_, rej) => setTimeout(() => rej(new Error("timeout")), ms))
    ]);
    const resp = await withTimeout(fetch("https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"), 3000);
    if (!resp.ok) throw new Error("http " + resp.status);
    const data = await resp.json();
    const price = data && data.bitcoin && data.bitcoin.usd;
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

// Kick off live price fetch (non-blocking)
fetchBTCPrice();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>
    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
