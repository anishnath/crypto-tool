<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Profit Calculator – Net Profit, ROI, Break‑Even, Fees & Taxes</title>
    <meta name="description" content="Free stock profit calculator to compute net profit/loss, ROI, break‑even price, and total fees/taxes. Supports multiple scenarios with charts.">
    <meta name="keywords" content="stock profit calculator, share market profit calculator, break-even price, ROI calculator stocks, stock fees calculator, capital gains tax calculator, trading profit calculator, day trading calculator, swing trading calculator">
    <link rel="canonical" href="https://8gwifi.org/stock-calc.jsp"/>
    <meta property="og:title" content="Stock Profit Calculator – Net Profit, ROI, Break‑Even, Fees & Taxes">
    <meta property="og:description" content="Compute stock net profit/loss, ROI, break‑even price, and fees/taxes across multiple scenarios with charts.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/stock-calc.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/stock-calc.png">
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Stock Profit Calculator – Net Profit, ROI, Break‑Even">
    <meta name="twitter:description" content="Quickly calculate net P/L, ROI, break‑even and fees/taxes with charts.">
    <meta name="twitter:image" content="https://8gwifi.org/images/site/stock-calc.png">
    <!-- Add Bootstrap CSS -->

  <script type="application/ld+json">
  {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Stock Profit Calculator",
      "url": "https://8gwifi.org/stock-calc.jsp",
      "applicationCategory": "FinanceApplication",
      "operatingSystem": "Web",
      "description": "Calculate stock net profit/loss, ROI, break‑even price, and fees/taxes across multiple scenarios with charts.",
      "offers": {"@type":"Offer","price":"0","priceCurrency":"USD"},
      "featureList": [
        "Multiple scenarios via comma‑separated inputs",
        "Net profit after fees and taxes",
        "Break‑even sale price",
        "ROI and total investment",
        "Profit/Loss chart"
      ]
    }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Finance","item":"https://8gwifi.org/stock-calc.jsp#finance"},
      {"@type":"ListItem","position":2,"name":"Stock Calculators","item":"https://8gwifi.org/stock-calc.jsp#stocks"},
      {"@type":"ListItem","position":3,"name":"Stock Profit Calculator","item":"https://8gwifi.org/stock-calc.jsp"}
    ]
  }
  </script>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {"@type": "Question", "name": "How do I calculate stock profit?",
         "acceptedAnswer": {"@type": "Answer", "text": "Enter purchase price, sale price and shares. Optionally add fees and tax. The calculator shows net profit, ROI, and break‑even price."}},
        {"@type": "Question", "name": "How is break‑even price calculated?",
         "acceptedAnswer": {"@type": "Answer", "text": "Break‑even sale price = PurchasePrice × (1 + BuyFees%) ÷ (1 − SellFees%)."}},
        {"@type": "Question", "name": "Does it account for fees and taxes?",
         "acceptedAnswer": {"@type": "Answer", "text": "Yes. Set Buy Fees %, Sell Fees % and optional tax %. Net profit accounts for these adjustments."}}
      ]
    }
    </script>
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "HowTo",
      "name": "How to compute stock profit and ROI",
      "step": [
        {"@type":"HowToStep","name":"Enter inputs","text":"Add purchase price, sale price and number of shares. You can add multiple scenarios separated by commas."},
        {"@type":"HowToStep","name":"Add fees/tax","text":"Set Buy Fees %, Sell Fees % and optional Tax % to get net profit."},
        {"@type":"HowToStep","name":"View results","text":"See net P/L, ROI, and break‑even sale price per scenario with a chart."}
      ]
    }
    </script>

<%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <style>
      .stk-compact .card-header { padding:.5rem .75rem; font-weight:600; }
      .stk-compact .card-body { padding:.75rem; }
      .stk-compact .form-group { margin-bottom:.5rem; }
      .stk-compact label { margin-bottom:.25rem; font-size:.9rem; }
      .stk-kpi .kpi { background:#f8f9fb; border:1px solid #eef0f3; border-radius:8px; padding:.75rem; }
      .stk-kpi .kpi .label { color:#6c757d; font-size:.85rem; }
      .stk-kpi .kpi .value { font-weight:700; font-size:1.05rem; }
      .stk-chart { position:relative; width:100%; height:420px; }
      .stk-chart canvas { width:100% !important; height:100% !important; }
      .stk-sticky { position: sticky; top: 70px; z-index: 1020; }
    </style>

    <div class="container mt-4">
      <h1 class="mb-2">Stock Profit Calculator</h1>
      <p class="text-muted mb-4">Compute net profit/loss, ROI, break‑even price, fees, taxes, and annualized return. Add multiple scenarios in the table below (each with its own dates).</p>

      <div class="row">
        <!-- Left: Inputs -->
        <div class="col-lg-4 stk-compact">

          <div class="card mb-3">
            <h5 class="card-header">Position & Currency</h5>
            <div class="card-body">
              <div class="form-row">
                <div class="form-group col-6">
                  <label for="positionType">Position</label>
                  <select class="form-control" id="positionType">
                    <option value="long" selected>Long</option>
                    <option value="short">Short</option>
                  </select>
                </div>
                <div class="form-group col-6" id="stocks">
                  <label for="currency">Currency</label>
                  <select class="form-control" id="currency">
                    <option value="USD" selected>USD</option>
                    <option value="EUR">EUR</option>
                    <option value="GBP">GBP</option>
                    <option value="INR">INR</option>
                    <option value="JPY">JPY</option>
                  </select>
                </div>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">Costs & Taxes</h5>
            <div class="card-body">
              <div class="form-row">
                <div class="form-group col-6">
                  <label for="buyFeePct">Buy Fees %</label>
                  <input type="number" step="0.01" class="form-control" id="buyFeePct" value="0" placeholder="e.g. 0.10">
                </div>
                <div class="form-group col-6">
                  <label for="sellFeePct">Sell Fees %</label>
                  <input type="number" step="0.01" class="form-control" id="sellFeePct" value="0" placeholder="e.g. 0.10">
                </div>
              </div>
              <div class="form-row">
                <div class="form-group col-6">
                  <label for="buyFixed">Buy Fixed Fee</label>
                  <input type="number" step="0.01" class="form-control" id="buyFixed" value="0" placeholder="e.g. 1.50">
                </div>
                <div class="form-group col-6">
                  <label for="sellFixed">Sell Fixed Fee</label>
                  <input type="number" step="0.01" class="form-control" id="sellFixed" value="0" placeholder="e.g. 1.50">
                </div>
              </div>
              <div class="form-row">
                <div class="form-group col-6">
                  <label for="taxPct">Tax % (on gains)</label>
                  <input type="number" step="0.01" class="form-control" id="taxPct" value="0" placeholder="e.g. 10">
                </div>
                <div class="form-group col-6">
                  <label for="slippagePct">Slippage %</label>
                  <input type="number" step="0.01" class="form-control" id="slippagePct" value="0" placeholder="e.g. 0.05">
                </div>
              </div>
            </div>
          </div>

          

          <div class="mb-3">
            <button class="btn btn-primary btn-block" id="calculateButton">Calculate</button>
            <button class="btn btn-outline-secondary btn-block mt-2" id="exportCsvBtn">Export CSV</button>
          </div>
        </div>

        <!-- Right: Scenarios + Results -->
        <div class="col-lg-8">
          <div class="card mb-3">
            <h5 class="card-header d-flex justify-content-between align-items-center">Scenarios
              <button class="btn btn-sm btn-outline-primary" type="button" id="addRowBtn">Add Row</button>
            </h5>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-sm mb-0" id="scenariosTable">
                  <thead>
                    <tr>
                      <th style="min-width:90px;">Symbol</th>
                      <th style="min-width:100px;">Purchase</th>
                      <th style="min-width:100px;">Sale</th>
                      <th style="min-width:80px;">Shares</th>
                      <th style="min-width:130px;">Buy Date</th>
                      <th style="min-width:130px;">Sell Date</th>
                      <th style="min-width:90px;">Dividend</th>
                      <th style="width:40px;"></th>
                    </tr>
                  </thead>
                  <tbody id="scenariosTbody"></tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">CSV Import / Paste</h5>
            <div class="card-body">
              <textarea class="form-control" id="csvInput" rows="5" placeholder="Paste CSV with headers: ticker,purchase,sale,shares,buydate,selldate,dividend"></textarea>
              <div class="mt-2 d-flex justify-content-between">
                <small class="text-muted">Headers recognized: ticker|symbol, purchase|buy, sale|sell, shares|qty, buydate, selldate, dividend</small>
                <button class="btn btn-sm btn-outline-primary" type="button" id="parseCsvBtn">Parse CSV</button>
              </div>
            </div>
          </div>
          <!-- What-If Simulator -->
          <div class="card mb-3">
            <h5 class="card-header">What‑If Simulator</h5>
            <div class="card-body">
              <div class="form-row align-items-end">
                <div class="form-group col-md-4">
                  <label for="wiScenario">Scenario</label>
                  <select id="wiScenario" class="form-control"></select>
                </div>
                <div class="form-group col-md-4">
                  <label for="wiBuyPrice">Buy More At (price)</label>
                  <input type="number" step="0.0001" id="wiBuyPrice" class="form-control" placeholder="e.g. 95">
                </div>
                <div class="form-group col-md-4">
                  <label for="wiTargetSell">Target Sell Price</label>
                  <input type="number" step="0.0001" id="wiTargetSell" class="form-control" placeholder="e.g. 110">
                </div>
              </div>
              <div class="form-row align-items-end">
                <div class="form-group col-md-4">
                  <label for="wiGoal">Goal</label>
                  <select id="wiGoal" class="form-control">
                    <option value="breakeven" selected>Break‑Even</option>
                    <option value="roi">Target ROI %</option>
                  </select>
                </div>
                <div class="form-group col-md-4">
                  <label for="wiRoiTarget">ROI Target %</label>
                  <input type="number" step="0.01" id="wiRoiTarget" class="form-control" value="10" placeholder="e.g. 10">
                </div>
                <div class="form-group col-md-4">
                  <button type="button" id="wiCompute" class="btn btn-success btn-block">Recommend Buy Qty</button>
                </div>
              </div>
              <div id="wiResult" class="small"></div>
            </div>
          </div>

          <div class="stk-kpi mb-3 stk-sticky">
            <div class="row">
              <div class="col-md-4 mb-2">
                <div class="kpi">
                  <div class="label">Total Invested</div>
                  <div class="value" id="kpiInvested">–</div>
                </div>
              </div>
              <div class="col-md-4 mb-2">
                <div class="kpi">
                  <div class="label">Total Net Profit/Loss</div>
                  <div class="value" id="totalProfitLoss">–</div>
                </div>
              </div>
              <div class="col-md-4 mb-2">
                <div class="kpi">
                  <div class="label">Total ROI</div>
                  <div class="value" id="kpiTotalRoi">–</div>
                </div>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">Performance Chart</h5>
            <div class="card-body">
              <div class="stk-chart">
                <canvas id="profitChart"></canvas>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">Allocation by Invested</h5>
            <div class="card-body">
              <div class="stk-chart" style="height:320px;">
                <canvas id="allocChart"></canvas>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">P/L Components</h5>
            <div class="card-body">
              <div class="stk-chart" style="height:420px;">
                <canvas id="componentsChart"></canvas>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">Results Table</h5>
            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table mb-0">
                  <thead>
                    <tr>
                      <th>Symbol</th>
                      <th>Shares</th>
                      <th>Purchase Price</th>
                      <th>Total Invested</th>
                      <th>Sale Price</th>
                      <th>Break‑Even</th>
                      <th>Net Profit/Loss</th>
                      <th>ROI %</th>
                      <th>Annualized %</th>
                    </tr>
                  </thead>
                  <tbody id="resultsTable"></tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="card mb-3">
            <h5 class="card-header">How It Works</h5>
            <div class="card-body">
              <p class="mb-2">Net Profit = (Sale Price × (1 − Sell Fees %) − Purchase Price × (1 + Buy Fees %)) × Shares. If tax is provided, it applies to gains only.</p>
              <p class="mb-0">Break‑Even Sale Price (Long) = Purchase Price × (1 + Buy Fees %) ÷ (1 − Sell Fees %).</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Chart.js for charts -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        let chartInstance = null;
        let allocInstance = null;
        let componentsInstance = null;
        let lastRows = [];
        function fmtCurrency(v, currency){
            try { return new Intl.NumberFormat(undefined,{style:'currency',currency}).format(v); } catch(e){ return v.toFixed ? v.toFixed(2) : v; }
        }
        function sanitizeStr(s){
            if (s === undefined || s === null) return '';
            const v = (''+s).trim();
            if (/^(false|null|undefined)$/i.test(v)) return '';
            return v;
        }
        function addScenarioRow(data){
            const tbody = document.getElementById('scenariosTbody');
            const tr = document.createElement('tr');
            tr.innerHTML = `
              <td><input type="text" class="form-control form-control-sm scenario-input" data-field="ticker" value="${sanitizeStr(data&&data.ticker)}"></td>
              <td><input type="number" step="0.0001" class="form-control form-control-sm scenario-input" data-field="purchase" value="${(data&&data.purchase)||''}"></td>
              <td><input type="number" step="0.0001" class="form-control form-control-sm scenario-input" data-field="sale" value="${(data&&data.sale)||''}"></td>
              <td><input type="number" step="1" class="form-control form-control-sm scenario-input" data-field="shares" value="${(data&&data.shares)||''}"></td>
              <td><input type="date" class="form-control form-control-sm scenario-input" data-field="buydate" value="${(data&&data.buydate)||''}"></td>
              <td><input type="date" class="form-control form-control-sm scenario-input" data-field="selldate" value="${(data&&data.selldate)||''}"></td>
              <td><input type="number" step="0.0001" class="form-control form-control-sm scenario-input" data-field="dividend" value="${(data&&data.dividend)||''}"></td>
              <td><button type="button" class="btn btn-sm btn-link text-danger remove-row" title="Remove">&times;</button></td>
            `;
            tbody.appendChild(tr);
        }
        function readScenarioRows(){
            const rows = [];
            document.querySelectorAll('#scenariosTbody tr').forEach((tr,idx)=>{
                const get = f => {
                    const el = tr.querySelector(`[data-field="${f}"]`);
                    return el ? el.value : '';
                };
                rows.push({
                    ticker: sanitizeStr(get('ticker')),
                    purchase: parseFloat(get('purchase')),
                    sale: parseFloat(get('sale')),
                    shares: parseInt(get('shares'),10),
                    buydate: get('buydate'),
                    selldate: get('selldate'),
                    dividend: parseFloat(get('dividend')) || 0
                });
            });
            return rows;
        }

        function calculateProfit() {
    const scenarios = readScenarioRows();
    const buyFeePct = (parseFloat(document.getElementById('buyFeePct').value) || 0) / 100.0;
    const sellFeePct = (parseFloat(document.getElementById('sellFeePct').value) || 0) / 100.0;
    const taxPct = (parseFloat(document.getElementById('taxPct').value) || 0) / 100.0;
    const buyFixed = (parseFloat(document.getElementById('buyFixed').value) || 0);
    const sellFixed = (parseFloat(document.getElementById('sellFixed').value) || 0);
    const slippagePct = (parseFloat(document.getElementById('slippagePct').value) || 0) / 100.0;
    const positionType = document.getElementById('positionType').value; // long | short
    const currency = document.getElementById('currency').value || 'USD';

    const resultsTable = document.getElementById('resultsTable');
    resultsTable.innerHTML = '';

    const profitData = [];
    const roiData = [];
    const labels = [];
    const allocLabels = [];
    const allocInvested = [];
    const compInvested = [];
    const compProceeds = [];
    const compFees = [];
    const compTax = [];
    let totalProfitLoss = 0; // total net profit/loss
    let totalInvestment = 0; // total invested including buy fees
    lastRows = [];

    for (let i = 0; i < scenarios.length; i++) {
        const row = scenarios[i];
        const purchasePrice = row.purchase;
        const salePrice = row.sale;
        const share = row.shares;
        const total_price = share * purchasePrice;

        if (isNaN(purchasePrice) || isNaN(salePrice) || isNaN(share)) {
            continue; // Skip invalid data
        }

        // Costs and proceeds including fees and slippage
        const slpBuy = (1 + (positionType==='long' ? buyFeePct + slippagePct : buyFeePct));
        const slpSell = (1 - (positionType==='long' ? sellFeePct + slippagePct : sellFeePct));

        let invested = 0, proceeds = 0, netProfit = 0;
        const dividend = ((row.dividend != null && !isNaN(row.dividend)) ? row.dividend : 0) * share;

        let buyFeesCost = 0, sellFeesCost = 0, taxCost = 0;
        if (positionType === 'long') {
            const buyCostPerShare = purchasePrice * slpBuy;
            const sellProceedsPerShare = salePrice * slpSell;
            invested = buyCostPerShare * share + buyFixed;
            proceeds = sellProceedsPerShare * share - sellFixed;
            netProfit = (proceeds - invested) + dividend;
            buyFeesCost = (buyCostPerShare - purchasePrice) * share + buyFixed;
            sellFeesCost = (salePrice - sellProceedsPerShare) * share + sellFixed;
        } else { // short
            const entrySellPerShare = purchasePrice * (1 - sellFeePct); // entering short by selling first (no slippage by default)
            const exitBuyPerShare = salePrice * (1 + buyFeePct + slippagePct);
            proceeds = entrySellPerShare * share - sellFixed; // cash received at entry
            invested = exitBuyPerShare * share + buyFixed; // cash paid to cover
            netProfit = (proceeds - invested) - dividend; // shorts owe dividends
            buyFeesCost = (exitBuyPerShare - salePrice) * share + buyFixed;
            sellFeesCost = (purchasePrice - entrySellPerShare) * share + sellFixed;
        }

        // Apply tax only on gains
        if (netProfit > 0 && taxPct > 0) {
            taxCost = netProfit * taxPct;
            netProfit = netProfit - taxCost;
        }

        const stockLabel = (row.ticker && row.ticker.length>0) ? row.ticker : `stock-${i}`;
        const scenario = stockLabel;

        const profitColor = netProfit < 0 ? 'red' : 'green';

        const roiPct = (netProfit / (invested || 1)) * 100; // ROI relative to invested capital
        const breakEvenSalePrice = (positionType==='long')
            ? (purchasePrice * (1 + buyFeePct)) / (1 - sellFeePct)
            : (purchasePrice * (1 - sellFeePct)) / (1 + buyFeePct);

        // Annualized return if dates provided
        let annualizedPct = null;
        const buyD = row.buydate ? new Date(row.buydate) : null;
        const sellD = row.selldate ? new Date(row.selldate) : null;
        if (buyD && sellD && !isNaN(buyD) && !isNaN(sellD)) {
            const days = Math.max(1, (sellD - buyD) / (1000*60*60*24));
            const roiDec = (invested !== 0) ? (netProfit / invested) : 0;
            annualizedPct = (Math.pow(1 + roiDec, 365 / days) - 1) * 100;
        }

        // Add row to the table
        const tr = document.createElement('tr');

        tr.innerHTML = "<td>" + stockLabel + "</td>"
            + "<td>" + share + "</td>"
            + "<td>" + fmtCurrency(purchasePrice, currency) + "</td>"
            + "<td>" + fmtCurrency(invested, currency) + "</td>"
            + "<td>" + fmtCurrency(salePrice, currency) + "</td>"
            + "<td>" + breakEvenSalePrice.toFixed(4) + "</td>"
            + "<td style='color:" + profitColor + ";'>" + fmtCurrency(netProfit, currency) + "</td>"
            + "<td>" + (isFinite(roiPct)? roiPct.toFixed(2):'0.00') + "%</td>"
            + "<td>" + (annualizedPct!=null && isFinite(annualizedPct) ? annualizedPct.toFixed(2) : '-') + "%</td>";

        resultsTable.appendChild(tr);

        // Collect data for the chart
        labels.push(scenario);
        profitData.push(netProfit);
        roiData.push(isFinite(roiPct)? +roiPct.toFixed(2) : 0);
        allocLabels.push(scenario);
        allocInvested.push(invested);
        compInvested.push(invested);
        compProceeds.push(proceeds);
        compFees.push(Math.max(0, buyFeesCost + sellFeesCost));
        compTax.push(Math.max(0, taxCost));

        // Update total profit/loss
        totalProfitLoss += netProfit;
        totalInvestment += invested;

        lastRows.push({
            scenario,
            ticker: stockLabel,
            shares: share,
            purchasePrice,
            invested,
            salePrice,
            breakEven: breakEvenSalePrice,
            netProfit,
            roiPct: (isFinite(roiPct)? roiPct:0),
            annualizedPct: (annualizedPct!=null && isFinite(annualizedPct))? annualizedPct: null
        });
    }

    // Calculate overall percentage gain or loss
    const totalProfitPercentage = ((totalProfitLoss / totalInvestment) * 100) || 0;

    // Update the total profit/loss element
    const totalProfitLossElement = document.getElementById('totalProfitLoss');
    //totalProfitLossElement.textContent = totalProfitLoss.toFixed(2);
    totalProfitLossElement.textContent = fmtCurrency(totalProfitLoss, currency) + " (" + totalProfitPercentage.toFixed(2) + "%)";
    var investedEl = document.getElementById('kpiInvested');
    if (investedEl) investedEl.textContent = fmtCurrency(totalInvestment, currency);
    var roiEl = document.getElementById('kpiTotalRoi');
    if (roiEl) roiEl.textContent = totalProfitPercentage.toFixed(2) + '%';



 // Set color based on totalProfitLoss value
    const totalProfitLossColor = totalProfitLoss < 0 ? 'red' : 'green';
    totalProfitLossElement.style.fontWeight = 'bold';
    totalProfitLossElement.style.backgroundColor = '#fffbea';
    totalProfitLossElement.style.color = totalProfitLossColor;
    totalProfitLossElement.style.padding = '0.25rem 0.5rem';
    totalProfitLossElement.style.borderRadius = '6px';

    // Destroy the existing chart if it exists
    if (chartInstance) {
        chartInstance.destroy();
    }

    // Create a mixed chart with both bar and line chart types
    const ctx = document.getElementById('profitChart').getContext('2d');
    chartInstance = new Chart(ctx, {
    type: 'bar', // Set the default chart type to bar
    data: {
        labels: labels,
        datasets: [
            {
                label: 'Net Profit/Loss',
                data: profitData,
                backgroundColor: profitData.map(profit => profit >= 0 ? 'green' : 'red'),
                borderColor: 'blue',
                borderWidth: 1,
                type: 'bar' // This dataset is for the bar chart
            },
            {
                label: 'ROI %',
                data: roiData,
                borderColor: 'orange',
                borderWidth: 2,
                fill: false,
                type: 'line', // line chart
                yAxisID: 'y1'
            }
        ]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                title: { display: true, text: 'Profit/Loss' }
            },
            y1: {
                beginAtZero: true,
                position: 'right',
                grid: { drawOnChartArea: false },
                title: { display: true, text: 'ROI %' }
            }
        },
        plugins: {
            tooltip: {
                callbacks: {
                    label: function(ctx){
                        if(ctx.dataset.label === 'ROI %') return 'ROI: ' + ctx.parsed.y + '%';
                        return 'P/L: ' + fmtCurrency(ctx.parsed.y, (document.getElementById('currency').value||'USD'));
                    }
                }
            }
        }
    }
});

    if (allocInstance) allocInstance.destroy();
    const allocCtx = document.getElementById('allocChart').getContext('2d');
    allocInstance = new Chart(allocCtx, {
      type: 'doughnut',
      data: { labels: allocLabels, datasets: [{ data: allocInvested, backgroundColor: allocLabels.map((_,i)=>`hsl(${(i*53)%360} 70% 60%)`) }] },
      options: { plugins: { legend: { position: 'right' } } }
    });

    if (componentsInstance) componentsInstance.destroy();
    const compCtx = document.getElementById('componentsChart').getContext('2d');
    componentsInstance = new Chart(compCtx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [
          { label: 'Invested', data: compInvested, backgroundColor: '#93c5fd', stack: 'stack1' },
          { label: 'Proceeds', data: compProceeds, backgroundColor: '#86efac', stack: 'stack1' },
          { label: 'Fees+Slippage', data: compFees, backgroundColor: '#fdba74', stack: 'stack2' },
          { label: 'Tax', data: compTax, backgroundColor: '#fca5a5', stack: 'stack2' }
        ]
      },
      options: { responsive: true, scales: { x: { stacked: true }, y: { stacked: true, beginAtZero: true } } }
    });
}


        // Call calculateProfit when the button is clicked
        document.getElementById('calculateButton').addEventListener('click', calculateProfit);

        // Call calculateProfit when input values change
        // Scenario table change handlers
        document.getElementById('scenariosTable').addEventListener('input', function(e){
            if(e.target && e.target.classList.contains('scenario-input')) calculateProfit();
        });
        document.getElementById('scenariosTable').addEventListener('click', function(e){
            if(e.target && e.target.classList.contains('remove-row')){
                const tr = e.target.closest('tr');
                if(tr){ tr.parentNode.removeChild(tr); calculateProfit(); }
            }
        });
        document.getElementById('buyFeePct').addEventListener('input', calculateProfit);
        document.getElementById('sellFeePct').addEventListener('input', calculateProfit);
        document.getElementById('taxPct').addEventListener('input', calculateProfit);
        document.getElementById('buyFixed').addEventListener('input', calculateProfit);
        document.getElementById('sellFixed').addEventListener('input', calculateProfit);
        
        document.getElementById('slippagePct').addEventListener('input', calculateProfit);
        document.getElementById('positionType').addEventListener('change', calculateProfit);
        document.getElementById('currency').addEventListener('change', calculateProfit);

        // Add row button
        document.getElementById('addRowBtn').addEventListener('click', function(){ addScenarioRow({}); });

        // Seed with sample rows if empty
        (function seed(){
            const tbody = document.getElementById('scenariosTbody');
            if(!tbody.children.length){
                addScenarioRow({ticker:'', purchase:100, sale:90, shares:10});
                addScenarioRow({ticker:'', purchase:110, sale:130, shares:15});
                addScenarioRow({ticker:'', purchase:120, sale:110, shares:10});
            }
        })();

        // Initial chart rendering
        calculateProfit();

        // CSV export
        document.getElementById('exportCsvBtn').addEventListener('click', function(){
            if(!lastRows.length){ return; }
            const header = ['Scenario','Ticker','Shares','Purchase Price','Invested','Sale Price','Break-Even','Net Profit','ROI %','Annualized %'];
            const csv = [header.join(',')].concat(lastRows.map(r => [
                r.scenario,
                r.ticker,
                r.shares,
                r.purchasePrice,
                r.invested,
                r.salePrice,
                r.breakEven,
                r.netProfit,
                (r.roiPct!=null? r.roiPct : ''),
                (r.annualizedPct!=null? r.annualizedPct : '')
            ].join(','))).join('\n');
            const blob = new Blob([csv], {type:'text/csv;charset=utf-8;'});
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'stock-profit-calculator.csv';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        });
        // What-If dropdown refresh and compute
        function refreshWiOptions(){
          const sel = document.getElementById('wiScenario');
          if(!sel) return;
          const scenarios = readScenarioRows();
          const current = sel.value;
          sel.innerHTML = '';
          scenarios.forEach((r,idx)=>{
            const opt = document.createElement('option');
            const label = (r.ticker && r.ticker.length)? r.ticker : `stock-${idx}`;
            opt.value = String(idx);
            opt.textContent = label;
            sel.appendChild(opt);
          });
          if(current && sel.querySelector(`option[value="${current}"]`)) sel.value = current;
        }
        refreshWiOptions();

        document.getElementById('wiCompute').addEventListener('click', function(){
          const idx = parseInt(document.getElementById('wiScenario').value||'0',10) || 0;
          const rows = readScenarioRows();
          if(idx<0 || idx>=rows.length) return;
          const r = rows[idx];
          const Pc = parseFloat(document.getElementById('wiBuyPrice').value);
          const Pt = parseFloat(document.getElementById('wiTargetSell').value);
          const goal = document.getElementById('wiGoal').value;
          const roiTarget = parseFloat(document.getElementById('wiRoiTarget').value||'0')/100.0;
          const bf = (parseFloat(document.getElementById('buyFeePct').value)||0)/100.0;
          const sf = (parseFloat(document.getElementById('sellFeePct').value)||0)/100.0;
          const t = (parseFloat(document.getElementById('taxPct').value)||0)/100.0;
          const bFix = (parseFloat(document.getElementById('buyFixed').value)||0);
          const sFix = (parseFloat(document.getElementById('sellFixed').value)||0);
          const pos = document.getElementById('positionType').value;
          const out = document.getElementById('wiResult');
          out.className = 'small';
          if(pos !== 'long') { out.innerHTML = '<span class="text-muted">What‑if recommendations currently support long positions only.</span>'; return; }
          if(!isFinite(Pc) || !isFinite(Pt)) { out.innerHTML = '<span class="text-danger">Provide valid Buy At and Target Sell prices.</span>'; return; }

          const S0 = r.shares; const P0 = r.purchase;
          const A = Pt*(1 - sf) - Pc*(1 + bf);
          const C = (S0*Pt*(1 - sf) - sFix) - (S0*P0*(1 + bf) + bFix + bFix);
          let Sx = null;
          if(goal === 'breakeven') {
            if (A <= 0) { out.innerHTML = '<span class="text-warning">Buying more at this price cannot reach break‑even at the target sell price.</span>'; return; }
            Sx = ( (S0*P0*(1+bf) + bFix + bFix + sFix) - (S0*Pt*(1 - sf)) ) / A;
          } else {
            const B = Pc*(1 + bf);
            const D = S0*P0*(1 + bf) + bFix + bFix;
            const k = (roiTarget >= 0 && t < 1) ? (roiTarget/(1 - t)) : roiTarget;
            const denom = (A - k*B);
            if (denom <= 0) { out.innerHTML = '<span class="text-warning">At these prices and fees, the ROI target is not attainable by buying more.</span>'; return; }
            Sx = (k*D - C) / denom;
          }
          if(!isFinite(Sx)) { out.innerHTML = '<span class="text-danger">Could not compute recommendation. Check inputs.</span>'; return; }
          const SxInt = Math.max(0, Math.ceil(Sx));
          out.innerHTML = `Buy <b>${SxInt}</b> more shares at <b>${Pc}</b> to achieve <b>${goal==='breakeven'?'break‑even':('~'+(roiTarget*100).toFixed(2)+'% ROI')}</b> when selling at <b>${Pt}</b>.`;
        });
        // CSV Parse
        document.getElementById('parseCsvBtn').addEventListener('click', function(){
            const text = (document.getElementById('csvInput').value||'').trim();
            if(!text) return;
            const lines = text.split(/\r?\n/).filter(l=>l.trim().length>0);
            if(!lines.length) return;
            const headers = lines[0].split(',').map(h=>h.trim().toLowerCase());
            let startIdx = 1;
            // If first row looks like data (numbers) and not headers, treat as no header
            const isDataFirst = headers.every(h=>/^[-+\d.\/a-z]+$/.test(h)) && !headers.some(h=>/(ticker|symbol|purchase|buy|sale|sell|shares|qty|buydate|selldate|dividend)/.test(h));
            let idx = {ticker:-1,purchase:-1,sale:-1,shares:-1,buydate:-1,selldate:-1,dividend:-1};
            if(isDataFirst){
                startIdx = 0;
                idx = {ticker:0,purchase:1,sale:2,shares:3,buydate:4,selldate:5,dividend:6};
            } else {
                headers.forEach((h,i)=>{
                    if(/^(ticker|symbol)$/.test(h)) idx.ticker = i;
                    else if(/^(purchase|buy)$/.test(h)) idx.purchase = i;
                    else if(/^(sale|sell)$/.test(h)) idx.sale = i;
                    else if(/^(shares|qty)$/.test(h)) idx.shares = i;
                    else if(/^buydate$/.test(h)) idx.buydate = i;
                    else if(/^selldate$/.test(h)) idx.selldate = i;
                    else if(/^dividend$/.test(h)) idx.dividend = i;
                });
            }

            const col = {ticker:[], purchase:[], sale:[], shares:[], buydate:[], selldate:[], dividend:[]};
            for(let i=startIdx;i<lines.length;i++){
                const parts = lines[i].split(',');
                const g = (k,def='') => {
                    const j = idx[k];
                    return (j>=0 && j<parts.length) ? parts[j].trim() : def;
                };
                col.ticker.push(g('ticker',''));
                col.purchase.push(g('purchase',''));
                col.sale.push(g('sale',''));
                col.shares.push(g('shares',''));
                col.buydate.push(g('buydate',''));
                col.selldate.push(g('selldate',''));
                col.dividend.push(g('dividend',''));
            }

            // Populate rows from CSV (replace existing)
            const tbody = document.getElementById('scenariosTbody');
            tbody.innerHTML = '';
            for(let i=0;i<col.purchase.length;i++){
                addScenarioRow({
                    ticker: (col.ticker[i]||'') && !/^(false|null|undefined)$/i.test(col.ticker[i]) ? col.ticker[i] : '',
                    purchase: col.purchase[i]||'',
                    sale: col.sale[i]||'',
                    shares: col.shares[i]||'',
                    buydate: col.buydate[i]||'',
                    selldate: col.selldate[i]||'',
                    dividend: col.dividend[i]||''
                });
            }
            calculateProfit();
        });
    </script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
