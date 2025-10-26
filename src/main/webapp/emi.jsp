<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Home Loan EMI Calculator (India) – Prepayment, Amortization, Interest Savings</title>
  <%@ include file="header-script.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>
  <meta name="description" content="Free Home Loan EMI Calculator (India) with prepayment options, amortization schedule, interest vs principal breakup, taxes/insurance/maintenance, balance, and payoff date. Compare savings with prepayments.">
  <meta name="keywords" content="home loan emi calculator, emi calculator india, housing loan calculator, mortgage calculator india, emi breakup principal interest, home loan prepayment calculator, loan amortization schedule, extra payment savings, balance payoff date, sbi home loan emi, hdfc home loan emi, icici home loan emi">
  <link rel="canonical" href="https://8gwifi.org/emi.jsp">
  <!-- Open Graph / Twitter for richer sharing -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="Home Loan EMI Calculator (India) – Prepayment & Amortization">
  <meta property="og:description" content="Calculate EMI, see interest vs principal breakup, model prepayments, and view payoff & balance with full amortization.">
  <meta property="og:url" content="https://8gwifi.org/emi.jsp">
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="Home Loan EMI Calculator (India) – Prepayment & Amortization">
  <meta name="twitter:description" content="EMI with prepayments, interest savings, amortization, and balance charts.">
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Home Loan EMI Calculator",
    "url": "https://8gwifi.org/emi.jsp",
    "applicationCategory": "FinanceApplication",
    "description": "EMI, prepayments, taxes, insurance, and maintenance with charts and amortization.",
    "featureList": [
      "EMI computation",
      "Prepayments (monthly + lump sum)",
      "Property tax, insurance, maintenance",
      "Amortization and balance chart"
    ],
    "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
  }
  </script>
  <!-- FAQ schema and breadcrumbs for SEO -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type": "Question", "name": "How is EMI calculated?", "acceptedAnswer": {"@type": "Answer", "text": "EMI = P × R × (1+R)^N / ((1+R)^N − 1) where P=loan amount, R=monthly rate, N=months."}},
      {"@type": "Question", "name": "How do prepayments reduce interest?", "acceptedAnswer": {"@type": "Answer", "text": "Prepayments directly reduce principal so less interest accrues, saving interest and shortening the payoff period."}},
      {"@type": "Question", "name": "Can I see principal vs interest breakup and balance?", "acceptedAnswer": {"@type": "Answer", "text": "Yes. The chart and amortization table show monthly and yearly principal/interest breakup and the running balance."}}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type": "ListItem", "position": 1, "name": "Tools", "item": "https://8gwifi.org/"},
      {"@type": "ListItem", "position": 2, "name": "Home Loan EMI Calculator", "item": "https://8gwifi.org/emi.jsp"}
    ]
  }
  </script>
  <style>
    /* Compact left panel styling */
    .emi-compact .card-header { padding: .5rem .75rem; font-size: 1rem; }
    .emi-compact .card-body { padding: .75rem; }
    .emi-compact .form-group { margin-bottom: .5rem; }
    .emi-compact label { margin-bottom: .25rem; font-size: .85rem; }
    .emi-compact .form-control { padding: .25rem .5rem; height: calc(1.5em + .5rem + 2px); font-size: .875rem; }
    /* Make charts larger and easier to read */
    .emi-charts .chart-box { position: relative; width: 100%; height: 600px; }
    /* Let pie chart keep native aspect ratio but cap its size */
    .emi-charts .chart-box.pie { height: auto; max-width: 360px; margin: 0 auto; }
    .emi-charts .chart-box.pie canvas { height: auto !important; width: 100% !important; }
    @media (max-width: 992px) {
      .emi-charts .chart-box.pie { max-width: 300px; }
    }
    @media (max-width: 992px) {
      .emi-charts .chart-box { height: 520px; }
      .emi-charts .chart-box.pie { height: 320px; }
    }
    .emi-charts canvas { width: 100% !important; height: 100% !important; }
  </style>
</head>
<%@ include file="body-script.jsp"%>
<div class="container mt-4">
  <h1 class="mb-3">Home Loan EMI Calculator</h1>
  <div class="row">
    <div class="col-lg-3 emi-compact">
      <div class="card mb-3">
        <h5 class="card-header">Loan Details</h5>
        <div class="card-body">
          <div class="form-row">
            <div class="form-group col-12">
              <label for="loanAmount">Loan Amount</label>
              <input type="number" class="form-control form-control-sm" id="loanAmount" value="5000000" min="0" step="1000">
              <input type="range" class="form-control-range mt-1" id="loanAmountRange" min="0" max="100000000" step="10000">
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-6">
              <label for="annualRate">Interest Rate (% p.a.)</label>
              <input type="number" class="form-control form-control-sm" id="annualRate" value="9" min="0" step="0.05">
              <input type="range" class="form-control-range mt-1" id="annualRateRange" min="0" max="20" step="0.05">
            </div>
            <div class="form-group col-6">
              <label for="tenureYears">Tenure (years)</label>
              <input type="number" class="form-control form-control-sm" id="tenureYears" value="20" min="1" step="1">
              <input type="range" class="form-control-range mt-1" id="tenureYearsRange" min="1" max="40" step="1">
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-12">
              <label for="startDate">Start Date</label>
              <input type="date" class="form-control form-control-sm" id="startDate">
              <small class="form-text text-muted">Used for payoff date and yearly aggregation.</small>
            </div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Prepayments</h5>
        <div class="card-body">
          <div class="form-row">
            <div class="form-group col-7">
              <label for="monthlyExtra">Monthly Extra Payment</label>
              <input type="number" class="form-control form-control-sm" id="monthlyExtra" value="0" min="0" step="100">
              <input type="range" class="form-control-range mt-1" id="monthlyExtraRange" min="0" max="500000" step="500">
            </div>
            <div class="form-group col-5">
              <label for="monthlyExtraFrom">Start After (months)</label>
              <input type="number" class="form-control form-control-sm" id="monthlyExtraFrom" value="0" min="0" step="1">
              <input type="range" class="form-control-range mt-1" id="monthlyExtraFromRange" min="0" max="120" step="1">
            </div>
          </div>
          <div class="form-group">
            <label for="lumpsums">Lump Sum Prepayments (month:amount, comma-separated)</label>
            <input type="text" class="form-control form-control-sm" id="lumpsums" placeholder="e.g. 12:100000, 24:50000">
            <small class="form-text text-muted">Month is 1-indexed from start date (e.g., 12 means after 12 months).</small>
          </div>
          <hr>
          <div class="form-row align-items-end">
            <div class="form-group col-7">
              <label for="targetPayoffDate">Target Payoff Date</label>
              <input type="date" class="form-control form-control-sm" id="targetPayoffDate">
            </div>
            <div class="form-group col-5">
              <button type="button" id="suggestExtra" class="btn btn-sm btn-outline-success btn-block">Suggest Monthly Extra</button>
            </div>
          </div>
          <div class="small text-muted" id="suggestedExtraDisplay" style="display:none;"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Taxes, Insurance & Maintenance</h5>
        <div class="card-body">
          <div class="form-row">
            <div class="form-group col-12">
              <label for="propertyValue">Property Value</label>
              <input type="number" class="form-control form-control-sm" id="propertyValue" value="6000000" min="0" step="1000">
              <input type="range" class="form-control-range mt-1" id="propertyValueRange" min="0" max="100000000" step="10000">
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-4">
              <label for="propertyTaxPct">Property Tax (%/yr)</label>
              <input type="number" class="form-control form-control-sm" id="propertyTaxPct" value="1" min="0" step="0.1">
              <input type="range" class="form-control-range mt-1" id="propertyTaxPctRange" min="0" max="5" step="0.1">
            </div>
            <div class="form-group col-4">
              <label for="insuranceAnnual">Insurance (per year)</label>
              <input type="number" class="form-control form-control-sm" id="insuranceAnnual" value="12000" min="0" step="500">
              <input type="range" class="form-control-range mt-1" id="insuranceAnnualRange" min="0" max="200000" step="500">
            </div>
            <div class="form-group col-4">
              <label for="maintenancePct">Maintenance (%/yr)</label>
              <input type="number" class="form-control form-control-sm" id="maintenancePct" value="1.5" min="0" step="0.1">
              <input type="range" class="form-control-range mt-1" id="maintenancePctRange" min="0" max="10" step="0.1">
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-6">
              <label for="maintenanceEscPct">Maintenance Escalation (%/yr)</label>
              <input type="number" class="form-control form-control-sm" id="maintenanceEscPct" value="5" min="0" step="0.5">
              <input type="range" class="form-control-range mt-1" id="maintenanceEscPctRange" min="0" max="15" step="0.5">
            </div>
            <div class="form-group col-6">
              <label for="includeCosts">Include costs in monthly cashflow</label>
              <select id="includeCosts" class="form-control form-control-sm">
                <option value="yes" selected>Yes</option>
                <option value="no">No (show separately)</option>
              </select>
            </div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Display Options</h5>
        <div class="card-body">
          <div class="form-row">
            <div class="form-group col-6">
              <label for="chartView">Chart Granularity</label>
              <select id="chartView" class="form-control form-control-sm">
                <option value="monthly">Monthly</option>
                <option value="yearly" selected>Yearly</option>
              </select>
            </div>
            <div class="form-group col-6">
              <label for="showBaseline">Compare</label>
              <div class="form-check">
                <input class="form-check-input" type="checkbox" id="showBaseline" checked>
                <label class="form-check-label" for="showBaseline">Show baseline (no prepayments)</label>
              </div>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group col-12">
              <button type="button" id="downloadPdf" class="btn btn-sm btn-outline-primary">Download PDF</button>
              <button type="button" id="copyLink" class="btn btn-sm btn-outline-secondary">Copy Link</button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-9">
      <div class="card mb-3">
        <h5 class="card-header">Summary</h5>
        <div class="card-body">
          <div class="row text-center">
            <div class="col-6 col-md-4 mb-3"><div><small class="text-muted">EMI</small></div><div class="h5" id="sumEmi">-</div></div>
            <div class="col-6 col-md-4 mb-3"><div><small class="text-muted">Total Interest</small></div><div class="h5" id="sumInterest">-</div></div>
            <div class="col-6 col-md-4 mb-3"><div><small class="text-muted">Total Principal</small></div><div class="h5" id="sumPrincipal">-</div></div>
            <div class="col-6 col-md-4 mb-3"><div><small class="text-muted">Taxes+Ins+Maint</small></div><div class="h5" id="sumCosts">-</div></div>
            <div class="col-6 col-md-4 mb-3"><div><small class="text-muted">Months to Payoff</small></div><div class="h5" id="sumMonths">-</div></div>
            <div class="col-6 col-md-4 mb-3"><div><small class="text-muted">Payoff Date</small></div><div class="h6" id="sumPayoff">-</div></div>
          </div>
          <div class="row text-center mt-2" id="savingsRow" style="display:none;">
            <div class="col-6 col-md-4 mb-3"><div><small class="text-success">Interest Saved</small></div><div class="h6" id="saveInterest">-</div></div>
            <div class="col-6 col-md-4 mb-3"><div><small class="text-success">Months Saved</small></div><div class="h6" id="saveMonths">-</div></div>
            <div class="col-12 col-md-4 mb-3"><div><small class="text-success">Baseline Payoff</small></div><div class="h6" id="baselinePayoff">-</div></div>
          </div>
          <div class="row emi-charts">
            <div class="col-12 mb-3"><div class="chart-box pie"><canvas id="pieChart"></canvas></div></div>
            <div class="col-12 mb-3"><div class="chart-box"><canvas id="balanceChart"></canvas></div></div>
          </div>
        </div>
      </div>

      <div class="card mb-3" id="amortCard">
        <h5 class="card-header">Amortization Schedule</h5>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-sm table-striped table-hover mb-0 amort-table align-middle">
              <thead class="thead-light">
                <tr>
                  <th>Month</th>
                  <th>EMI</th>
                  <th>Principal</th>
                  <th>Interest</th>
                  <th>Extra</th>
                  <th>Tax</th>
                  <th>Insurance</th>
                  <th>Maint</th>
                  <th>Balance</th>
                </tr>
              </thead>
              <tbody id="table-body"></tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mt-4">
    <div class="card-body">
      <h2 class="h4">About This Calculator</h2>
      <p>This home loan EMI calculator estimates your monthly repayment and shows how each payment splits into principal and interest over time. It also models prepayments (monthly extra and lump sums) and ongoing costs like property tax, home insurance, and maintenance with escalation. Use it to explore faster payoff strategies and year-wise cash outflows.</p>
      <h3 class="h5 mt-3">How to Use</h3>
      <ul>
        <li>Enter loan amount, annual interest rate, tenure, and a start date.</li>
        <li>Add prepayments: a fixed monthly extra (starting after N months) and optional lump sums (as <code>month:amount</code> pairs).</li>
        <li>Provide property value and yearly percentages for property tax and maintenance; insurance is annual.</li>
        <li>Switch the chart granularity between Monthly and Yearly. Hover bars to see exact values and balance; break-even markers show when principal overtakes interest and when cumulative principal exceeds cumulative interest.</li>
        <li>Download a PDF including the summary, charts, and the full amortization schedule, or copy a shareable link with your inputs.</li>
      </ul>
      <h3 class="h5 mt-3">Notes</h3>
      <ul>
        <li>Prepayments reduce outstanding principal and shorten the loan; costs are tracked as cash outflows but do not change amortization.</li>
        <li>Yearly chart stacks Principal, Prepayments, Interest, and Taxes/Insurance/Maintenance with lines for Balance and total annual payment.</li>
        <li>All values are approximations for planning; consult your lender for exact schedules.</li>
      </ul>
    </div>
  </div>
</div>

  <script>
  var pieChart = null;
  var balanceChart = null;
  // Custom plugin to draw breakeven vertical markers
  const breakevenPlugin = {
    id: 'breakevenMarkers',
    afterDatasetsDraw(chart, args, options){
      if (!options || !options.markers || !options.markers.length) return;
      const ctx = chart.ctx;
      const xScale = chart.scales.x;
      const topY = chart.chartArea.top;
      const bottomY = chart.chartArea.bottom;
      options.markers.forEach(m => {
        if (m.index == null) return;
        const x = xScale.getPixelForValue(m.index);
        ctx.save();
        ctx.strokeStyle = m.color || '#6f42c1';
        ctx.setLineDash(m.dash || [4,4]);
        ctx.lineWidth = m.width || 1;
        ctx.beginPath();
        ctx.moveTo(x, topY);
        ctx.lineTo(x, bottomY);
        ctx.stroke();
        ctx.restore();
      });
    }
  };
  if (window.Chart && Chart.register) { Chart.register(breakevenPlugin); }
  function buildShareUrl(){
    var params = new URLSearchParams();
    params.set('amount',$('#loanAmount').val());
    params.set('rate',$('#annualRate').val());
    params.set('years',$('#tenureYears').val());
    params.set('start',$('#startDate').val());
    params.set('mextra',$('#monthlyExtra').val());
    params.set('mfrom',$('#monthlyExtraFrom').val());
    params.set('lumps',$('#lumpsums').val());
    params.set('pval',$('#propertyValue').val());
    params.set('tax',$('#propertyTaxPct').val());
    params.set('ins',$('#insuranceAnnual').val());
    params.set('maint',$('#maintenancePct').val());
    params.set('mesc',$('#maintenanceEscPct').val());
    params.set('incl',$('#includeCosts').val());
    params.set('view',$('#chartView').val());
    params.set('baseline', $('#showBaseline').is(':checked') ? '1' : '0');
    return location.origin + location.pathname + '?' + params.toString();
  }

  function applyFromQuery(){
    var q = new URLSearchParams(location.search);
    function set(id,key){ if(q.has(key)) $('#'+id).val(q.get(key)); }
    set('loanAmount','amount');
    set('annualRate','rate');
    set('tenureYears','years');
    set('startDate','start');
    set('monthlyExtra','mextra');
    set('monthlyExtraFrom','mfrom');
    set('lumpsums','lumps');
    set('propertyValue','pval');
    set('propertyTaxPct','tax');
    set('insuranceAnnual','ins');
    set('maintenancePct','maint');
    set('maintenanceEscPct','mesc');
    set('includeCosts','incl');
    set('chartView','view');
    if (q.has('baseline')) $('#showBaseline').prop('checked', q.get('baseline') !== '0');
  }

  function parseLumpsums(input) {
    var map = {};
    if (!input) return map;
    input.split(',').forEach(function(pair){
      var p = pair.trim(); if (!p) return;
      var parts = p.split(':');
      if (parts.length === 2) {
        var m = parseInt(parts[0].trim());
        var a = parseFloat(parts[1].trim());
        if (!isNaN(m) && m > 0 && !isNaN(a) && a > 0) map[m] = (map[m]||0)+a;
      }
    });
    return map;
  }

  function monthName(n){
    return ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][n-1];
  }
  function getStartDate(){
    var v = $('#startDate').val();
    if (v) {
      var d = new Date(v);
      if (!isNaN(d.getTime())) return d;
    }
    var now = new Date();
    return new Date(now.getFullYear(), now.getMonth(), 1);
  }

  function monthsBetween(start, end){
    // inclusive months between start-month and end-month boundary
    var s = new Date(start.getFullYear(), start.getMonth(), 1);
    var e = new Date(end.getFullYear(), end.getMonth(), 1);
    var months = (e.getFullYear()-s.getFullYear())*12 + (e.getMonth()-s.getMonth());
    return Math.max(0, months);
  }

  function simulatePayoffMonths(P, r, n, emi, monthlyExtraFrom, lumps, monthlyExtraValue){
    var bal = P;
    var month = 0;
    while (bal>0 && month < n+600){
      month++;
      var interest = bal * r;
      var basePrincipal = Math.max(0, emi - interest);
      var extra = (month>monthlyExtraFrom) ? monthlyExtraValue : 0;
      if (lumps[month]) extra += lumps[month];
      var principal = Math.min(bal, basePrincipal + extra);
      bal = Math.max(0, bal - principal);
      if (bal <= 0.01) break;
    }
    return month;
  }

  function currency(x){
    var v = Number(x||0);
    return '₹ ' + v.toLocaleString(undefined,{maximumFractionDigits:0});
  }

  function recalc(){
    var P = parseFloat($('#loanAmount').val())||0;
    var rA = (parseFloat($('#annualRate').val())||0)/100.0;
    var nY = parseInt($('#tenureYears').val())||0;
    var n = nY*12;
    var r = rA/12.0;
    if (P<=0 || n<=0) return;

    // base EMI (without extra costs)
    var emi = r>0 ? P*r*Math.pow(1+r,n)/(Math.pow(1+r,n)-1) : P/n;

    var monthlyExtra = Math.max(0, parseFloat($('#monthlyExtra').val())||0);
    var monthlyExtraFrom = Math.max(0, parseInt($('#monthlyExtraFrom').val())||0);
    var lumps = parseLumpsums($('#lumpsums').val());

    var propVal = Math.max(0, parseFloat($('#propertyValue').val())||0);
    var taxPct = Math.max(0, parseFloat($('#propertyTaxPct').val())||0)/100.0;
    var insAnnual = Math.max(0, parseFloat($('#insuranceAnnual').val())||0);
    var maintPct = Math.max(0, parseFloat($('#maintenancePct').val())||0)/100.0;
    var maintEsc = Math.max(0, parseFloat($('#maintenanceEscPct').val())||0)/100.0;
    var includeCosts = $('#includeCosts').val()==='yes';

    var bal = P;
    var month = 0;
    var totalInt=0,totalPrin=0,totalBasePrin=0,totalExtra=0,totalCosts=0;
    var rowsHtml = '';
    var balSeries=[]; var labels=[];
    var basePrinSeries=[]; var prepaySeries=[]; var interestSeries=[]; var costsSeries=[];
    var payoffMonth = n;
    var crossoverMonth = null; // first month when principal >= interest
    var cumBreakevenMonth = null; // first month when cumulative principal >= cumulative interest
    var cumPrin=0, cumInt=0;

    var curDate = new Date(getStartDate().getTime());
    while (bal>0 && month < n+600) { // safety cap
      month++;
      var interest = bal * r;
      var basePrincipal = Math.max(0, emi - interest);
      var extra = (month>monthlyExtraFrom) ? monthlyExtra : 0;
      if (lumps[month]) extra += lumps[month];

      var principal = Math.min(bal, basePrincipal + extra);
      var tax = (propVal*taxPct)/12.0;
      var ins = insAnnual/12.0;
      var yearIndex = Math.floor((month-1)/12);
      var maint = (propVal*maintPct)/12.0 * Math.pow(1+maintEsc, yearIndex);
      var costs = tax + ins + maint;

      bal = Math.max(0, bal - principal);

      totalInt += interest;
      totalPrin += principal;
      totalBasePrin += Math.min(principal, Math.max(0, principal - Math.min(extra, principal)));
      totalExtra += Math.min(extra, principal);
      // breakeven tracking
      if (crossoverMonth == null && principal >= interest) crossoverMonth = month;
      cumPrin += principal; cumInt += interest;
      if (cumBreakevenMonth == null && cumPrin >= cumInt) cumBreakevenMonth = month;
      totalCosts += costs;
      balSeries.push(bal);
      labels.push(month);
      basePrinSeries.push(Math.max(0, principal - Math.min(extra, principal)));
      prepaySeries.push(Math.min(extra, principal));
      interestSeries.push(interest);
      costsSeries.push(costs);

      rowsHtml += '<tr>'+
        '<td>'+month+'</td>'+
        '<td>'+currency(emi.toFixed(2))+'</td>'+
        '<td>'+currency((principal - extra).toFixed(2))+'</td>'+
        '<td>'+currency(interest.toFixed(2))+'</td>'+
        '<td>'+currency(extra.toFixed(2))+'</td>'+
        '<td>'+currency(tax.toFixed(2))+'</td>'+
        '<td>'+currency(ins.toFixed(2))+'</td>'+
        '<td>'+currency(maint.toFixed(2))+'</td>'+
        '<td>'+currency(bal.toFixed(2))+'</td>'+
      '</tr>';

      if (bal <= 0.01) { payoffMonth = month; }
      // push series and advance date
      curDate.setMonth(curDate.getMonth()+1);
      if (bal <= 0.01) break;
    }

    // Baseline (no prepayments) scenario for comparison
    var bal0 = P, month0 = 0, totalInt0 = 0; var balSeries0 = [];
    while (bal0>0 && month0 < n+600) {
      month0++;
      var int0 = bal0 * r;
      var prin0 = Math.min(bal0, Math.max(0, emi - int0));
      bal0 = Math.max(0, bal0 - prin0);
      totalInt0 += int0;
      balSeries0.push(bal0);
      if (bal0 <= 0.01) break;
    }

    $('#table-body').html(rowsHtml);

    var sDate = getStartDate();
    var payoffDate = new Date(sDate.getTime());
    payoffDate.setMonth(payoffDate.getMonth()+payoffMonth);
    var payoffMonthIdx = payoffDate.getMonth()+1;
    var payoffYearCalc = payoffDate.getFullYear();

    $('#sumEmi').text(currency(emi.toFixed(2))+'/mo');
    $('#sumInterest').text(currency(totalInt.toFixed(0)));
    $('#sumPrincipal').text(currency(totalPrin.toFixed(0)));
    $('#sumCosts').text(currency(totalCosts.toFixed(0)));
    $('#sumMonths').text(payoffMonth+' months');
    $('#sumPayoff').text(['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][payoffMonthIdx-1]+' '+payoffYearCalc);

    // Savings with prepayments
    var interestSaved = Math.max(0, totalInt0 - totalInt);
    var monthsSaved = Math.max(0, (balSeries0.length) - payoffMonth);
    if (interestSaved > 0 || monthsSaved > 0) {
      $('#savingsRow').show();
      $('#saveInterest').text(currency(interestSaved.toFixed(0)));
      $('#saveMonths').text(monthsSaved+' months');
      var b0Date = new Date(sDate.getTime()); b0Date.setMonth(b0Date.getMonth()+balSeries0.length);
      $('#baselinePayoff').text(monthName(b0Date.getMonth()+1)+' '+b0Date.getFullYear());
    } else {
      $('#savingsRow').hide();
    }

    if (pieChart) pieChart.destroy();
    var pieCtx = document.getElementById('pieChart').getContext('2d');
    var pieData = [totalBasePrin, totalExtra, totalInt, totalCosts];
    var pieLabels = ['Principal','Prepayments','Interest','Taxes, Home Insurance & Maintenance'];
    var pieTotal = pieData.reduce((a,b)=>a+b,0) || 1;
    pieChart = new Chart(pieCtx, {
      type: 'pie',
      data: { labels: pieLabels, datasets: [{ data: pieData, backgroundColor: ['#0d6efd','#17a2b8','#dc3545','#6c757d'], hoverOffset: 6, borderWidth: 1 }] },
      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 1,
        plugins: {
          legend: { position: 'bottom' },
          tooltip: {
            callbacks: {
              label: function(ctx){
                var v = ctx.parsed; var pct = (v/pieTotal*100).toFixed(1)+'%';
                return ctx.label+': '+currency(v)+' ('+pct+')';
              }
            }
          }
        }
      }
    });

    if (balanceChart) balanceChart.destroy();
    var balCtx = document.getElementById('balanceChart').getContext('2d');
    var chartView = $('#chartView').val();
    var chartData;
    var markerPositions = [];
    if (chartView === 'yearly') {
      // Aggregate per year
      var s = getStartDate();
      var yMap = {};
      for (var i=0;i<labels.length;i++){
        var d = new Date(s.getTime());
        d.setMonth(d.getMonth()+i);
        var y = d.getFullYear();
        if (!yMap[y]) yMap[y] = {bp:0, pp:0, in:0, co:0, bal:0};
        yMap[y].bp += basePrinSeries[i];
        yMap[y].pp += prepaySeries[i];
        yMap[y].in += interestSeries[i];
        yMap[y].co += costsSeries[i];
        yMap[y].bal = balSeries[i]; // last month of year wins
      }
      var yLabels = Object.keys(yMap).sort();
      var yBP=[], yPP=[], yIN=[], yCO=[], yBAL=[], yPAY=[];
      yLabels.forEach(function(y){
        var o=yMap[y];
        yBP.push(o.bp); yPP.push(o.pp); yIN.push(o.in); yCO.push(o.co); yBAL.push(o.bal);
        yPAY.push(o.bp + o.pp + o.in + o.co);
      });
      // marker indices for yearly: map months to their year index
      function yearIndexForMonth(m){ var d=new Date(s.getTime()); d.setMonth(d.getMonth()+m-1); return yLabels.indexOf(String(d.getFullYear())); }
      var crossIdx = crossoverMonth? yearIndexForMonth(crossoverMonth) : null;
      var cumIdx = cumBreakevenMonth? yearIndexForMonth(cumBreakevenMonth) : null;
      if (crossIdx!=null && crossIdx>=0) markerPositions.push({index: crossIdx, color:'#ffc107'});
      if (cumIdx!=null && cumIdx>=0) markerPositions.push({index: cumIdx, color:'#20c997'});
      // prepare baseline yearly balance if needed
      var showBaseline = $('#showBaseline').is(':checked');
      var yBAL0 = [];
      if (showBaseline) {
        for (var i=0;i<yLabels.length;i++){ yBAL0.push(null); }
        var s2 = getStartDate();
        for (var i=0;i<balSeries0.length;i++){
          var d2 = new Date(s2.getTime()); d2.setMonth(d2.getMonth()+i);
          if (d2.getMonth()===11) {
            var idxY = yLabels.indexOf(String(d2.getFullYear()));
            if (idxY>=0) yBAL0[idxY] = balSeries0[i];
          }
        }
        // fill forward last known
        var last = 0; for (var i=0;i<yBAL0.length;i++){ if (yBAL0[i]==null) yBAL0[i]= (i>0? yBAL0[i-1]: balSeries0[0]||0); }
      }

      chartData = {
        labels: yLabels,
        datasets: [
          { type: 'bar', label: 'Principal', data: yBP, backgroundColor: '#0d6efd', stack: 'cash' },
          { type: 'bar', label: 'Prepayments', data: yPP, backgroundColor: '#17a2b8', stack: 'cash' },
          { type: 'bar', label: 'Interest', data: yIN, backgroundColor: '#dc3545', stack: 'cash' },
          { type: 'bar', label: 'Taxes, Home Insurance & Maintenance', data: yCO, backgroundColor: '#6c757d', stack: 'cash' },
          { type: 'line', label: 'Home Loan Payment / year', data: yPAY, borderColor:'#6f42c1', backgroundColor:'#6f42c1', fill:false, yAxisID: 'y', order: 9, pointRadius: 0, borderWidth: 3 },
          { type: 'line', label: 'Balance', data: yBAL, borderColor:'#28a745', fill:false, yAxisID: 'y', order: 10, pointRadius: 0, borderWidth: 3 },
          ...(showBaseline ? [{ type:'line', label:'Balance (no prepayment)', data: yBAL0, borderColor:'#343a40', borderDash:[6,4], fill:false, yAxisID:'y', order: 8, pointRadius: 0, borderWidth: 2 }] : [])
        ]
      };
    } else {
      var showBaselineM = $('#showBaseline').is(':checked');
      chartData = {
        labels: labels,
        datasets: [
          { type: 'bar', label: 'Principal', data: basePrinSeries, backgroundColor: '#0d6efd', stack: 'cash' },
          { type: 'bar', label: 'Prepayments', data: prepaySeries, backgroundColor: '#17a2b8', stack: 'cash' },
          { type: 'bar', label: 'Interest', data: interestSeries, backgroundColor: '#dc3545', stack: 'cash' },
          { type: 'bar', label: 'Taxes, Home Insurance & Maintenance', data: costsSeries, backgroundColor: '#6c757d', stack: 'cash' },
          { type: 'line', label: 'Balance', data: balSeries, borderColor:'#28a745', fill:false, yAxisID: 'y', order: 10, pointRadius: 0, borderWidth: 3 },
          ...(showBaselineM ? [{ type:'line', label:'Balance (no prepayment)', data: balSeries0, borderColor:'#343a40', borderDash:[6,4], fill:false, yAxisID:'y', order: 8, pointRadius: 0, borderWidth: 2 }] : [])
        ]
      };
      if (crossoverMonth) markerPositions.push({index: crossoverMonth-1, color:'#ffc107'});
      if (cumBreakevenMonth) markerPositions.push({index: cumBreakevenMonth-1, color:'#20c997'});
    }
    // compute dynamic y max to prevent clipping
    var yMax = P;
    if (chartView === 'yearly') {
      for (var i=0;i<chartData.labels.length;i++){
        var sum = (chartData.datasets[0].data[i]||0) + (chartData.datasets[1].data[i]||0) + (chartData.datasets[2].data[i]||0) + (chartData.datasets[3].data[i]||0);
        if (sum > yMax) yMax = sum;
      }
    } else {
      for (var i=0;i<chartData.labels.length;i++){
        var sum = (basePrinSeries[i]||0) + (prepaySeries[i]||0) + (interestSeries[i]||0) + (costsSeries[i]||0);
        if (sum > yMax) yMax = sum;
      }
    }

    balanceChart = new Chart(balCtx, {
      data: chartData,
      options: {
        maintainAspectRatio: false,
        layout: { padding: { top: 12 } },
        elements: { line: { tension: 0.2 }, point: { radius: 0 } },
        scales: { x:{ stacked:true }, y:{ stacked:true, beginAtZero:true, max: Math.ceil(yMax * 1.1) } },
        plugins: {
          breakevenMarkers: { markers: markerPositions },
          tooltip: {
            mode: 'index', intersect: false,
            callbacks: {
              label: function(ctx){ return ctx.dataset.label+': '+currency(ctx.parsed.y); },
              footer: function(items){
                var idx = items[0].dataIndex;
                var bal = (chartView==='yearly') ? (function(){ var s=getStartDate(); var d=new Date(s.getTime()); d.setMonth(d.getMonth()+idx*12+11); return (items[0].chart.data.datasets.find(d=>d.label==='Balance')||{data:[]}).data[idx] || 0; })() : balSeries[idx];
                return 'Balance: '+currency(bal);
              }
            }
          },
          legend: { position: 'top' }
        }
      }
    });

    // Show breakeven info under summary
    var crossDate = new Date(sDate.getTime()); if (crossoverMonth) crossDate.setMonth(crossDate.getMonth()+crossoverMonth);
    var cumDate = new Date(sDate.getTime()); if (cumBreakevenMonth) cumDate.setMonth(cumDate.getMonth()+cumBreakevenMonth);
    $('#breakevenInfo').remove();
    var infoHtml = '<div id="breakevenInfo" class="text-muted small">'+
      (crossoverMonth? ('Crossover (Principal > Interest): '+ monthName(crossDate.getMonth()+1)+' '+crossDate.getFullYear()):'')+
      (crossoverMonth&&cumBreakevenMonth?' | ':'')+
      (cumBreakevenMonth? ('Cumulative break-even (ΣP ≥ ΣI): '+ monthName(cumDate.getMonth()+1)+' '+cumDate.getFullYear()):'')+
      '</div>';
    $(infoHtml).insertAfter($('.card:contains("Summary") .card-body .row').last());
  }

  $('#loanAmount, #annualRate, #tenureYears, #startDate, #chartView, #monthlyExtra, #monthlyExtraFrom, #lumpsums, #propertyValue, #propertyTaxPct, #insuranceAnnual, #maintenancePct, #maintenanceEscPct, #includeCosts')
    .on('input change', recalc);

  // Share & PDF handlers
  $(document).on('click','#copyLink',function(){
    var url = buildShareUrl();
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(url);
      $(this).text('Copied!');
      var btn = this; setTimeout(function(){ $(btn).text('Copy Link'); }, 1500);
    } else {
      prompt('Copy this link:', url);
    }
  });

  $(document).on('click','#downloadPdf',async function(){
    try {
      const { jsPDF } = window.jspdf;
      var doc = new jsPDF({orientation:'portrait', unit:'pt', format:'a4'});
      var margin = 36, y = margin;
      doc.setFontSize(14);
      doc.text('Home Loan EMI Summary', margin, y); y += 18;
      doc.setFontSize(10);
      doc.text('EMI: ' + $('#sumEmi').text() + '   Total Interest: ' + $('#sumInterest').text(), margin, y); y += 14;
      doc.text('Total Principal: ' + $('#sumPrincipal').text() + '   Total Costs: ' + $('#sumCosts').text(), margin, y); y += 14;
      doc.text('Payoff: ' + $('#sumMonths').text() + '   ' + $('#sumPayoff').text(), margin, y); y += 20;

      // Add charts
      function addCanvas(id, title){
        var c = document.getElementById(id);
        if (!c) return;
        var img = c.toDataURL('image/png', 1.0);
        doc.setFontSize(12); doc.text(title, margin, y); y += 8;
        var pageWidth = doc.internal.pageSize.getWidth() - margin*2;
        var imgHeight = pageWidth * (c.height / c.width);
        if (y + imgHeight > doc.internal.pageSize.getHeight() - margin) { doc.addPage(); y = margin; }
        doc.addImage(img, 'PNG', margin, y, pageWidth, imgHeight); y += imgHeight + 16;
      }
      addCanvas('pieChart','Composition');
      addCanvas('balanceChart','Yearly Breakdown & Balance');
      // Add amortization table (multi-page image slices)
      const amortEl = document.getElementById('amortCard');
      if (amortEl) {
        const canvas = await html2canvas(amortEl, { scale: 2, useCORS: true, windowWidth: 1400 });
        const imgWidth = canvas.width;
        const imgHeight = canvas.height;
        const pageWidthPt = doc.internal.pageSize.getWidth() - margin*2;
        const pageHeightPt = doc.internal.pageSize.getHeight() - margin*2;
        const pxPerPt = imgWidth / pageWidthPt; // scale factor from PDF pt to canvas px
        const sliceHeightPx = Math.floor(pageHeightPt * pxPerPt);

        let yPx = 0;
        let firstTablePage = true;
        while (yPx < imgHeight) {
          if (!firstTablePage) doc.addPage();
          firstTablePage = false;
          const sliceCanvas = document.createElement('canvas');
          sliceCanvas.width = imgWidth;
          sliceCanvas.height = Math.min(sliceHeightPx, imgHeight - yPx);
          const sctx = sliceCanvas.getContext('2d');
          sctx.drawImage(canvas, 0, yPx, imgWidth, sliceCanvas.height, 0, 0, imgWidth, sliceCanvas.height);
          const imgData = sliceCanvas.toDataURL('image/png');
          const sliceHeightPt = sliceCanvas.height / pxPerPt;
          doc.addImage(imgData, 'PNG', margin, margin, pageWidthPt, sliceHeightPt);
          yPx += sliceHeightPx;
        }
      }

      // Footer with site link and page numbers
      var pageCount = doc.getNumberOfPages();
      for (var i=1; i<=pageCount; i++){
        doc.setPage(i);
        var pw = doc.internal.pageSize.getWidth();
        var ph = doc.internal.pageSize.getHeight();
        doc.setFontSize(9);
        doc.text('https://8gwifi.org/emi.jsp', margin, ph - margin/2);
        doc.text(i + ' / ' + pageCount, pw - margin, ph - margin/2, {align:'right'});
      }

      doc.save('home-loan-emi.pdf');
    } catch(e) { console.error(e); alert('PDF generation failed'); }
  });

  // Initialize start date default and apply query params
  (function init(){
    var sd = $('#startDate').val();
    if (!sd) {
      var now = new Date();
      var first = new Date(now.getFullYear(), now.getMonth(), 1);
      var mm = String(first.getMonth()+1).padStart(2,'0');
      var dd = String(first.getDate()).padStart(2,'0');
      $('#startDate').val(first.getFullYear()+'-'+mm+'-'+dd);
    }
    applyFromQuery();
    recalc();
  })();

  // Sliders sync with inputs
  function bindSlider(numberId, rangeId){
    var num = $('#'+numberId);
    var rng = $('#'+rangeId);
    if (!num.length || !rng.length) return;
    // initialize slider value from number
    rng.val(num.val());
    rng.on('input change', function(){ num.val($(this).val()).trigger('input'); });
    num.on('input change', function(){ rng.val($(this).val()); });
  }
  $(function(){
    bindSlider('loanAmount','loanAmountRange');
    bindSlider('annualRate','annualRateRange');
    bindSlider('tenureYears','tenureYearsRange');
    bindSlider('monthlyExtra','monthlyExtraRange');
    bindSlider('monthlyExtraFrom','monthlyExtraFromRange');
    bindSlider('propertyValue','propertyValueRange');
    bindSlider('propertyTaxPct','propertyTaxPctRange');
    bindSlider('insuranceAnnual','insuranceAnnualRange');
    bindSlider('maintenancePct','maintenancePctRange');
    bindSlider('maintenanceEscPct','maintenanceEscPctRange');
  });

  // Target Payoff Date helper
  $(document).on('click', '#suggestExtra', function(){
    var P = parseFloat($('#loanAmount').val())||0;
    var rA = (parseFloat($('#annualRate').val())||0)/100.0;
    var nY = parseInt($('#tenureYears').val())||0;
    var n = nY*12;
    var r = rA/12.0;
    if (!(P>0 && n>0)) { alert('Enter loan amount and tenure'); return; }
    var emi = r>0 ? P*r*Math.pow(1+r,n)/(Math.pow(1+r,n)-1) : P/n;
    var monthlyExtraFrom = Math.max(0, parseInt($('#monthlyExtraFrom').val())||0);
    var lumps = parseLumpsums($('#lumpsums').val());
    var start = getStartDate();
    var tStr = $('#targetPayoffDate').val();
    if (!tStr) { alert('Select a target payoff date'); return; }
    var target = new Date(tStr);
    if (isNaN(target.getTime())) { alert('Invalid target date'); return; }
    var targetMonths = monthsBetween(start, target);
    if (targetMonths <= 0) { alert('Target must be after start date'); return; }

    // current payoff months under current extras
    var currentExtra = Math.max(0, parseFloat($('#monthlyExtra').val())||0);
    var currentMonths = simulatePayoffMonths(P, r, n, emi, monthlyExtraFrom, lumps, currentExtra);
    if (currentMonths <= targetMonths) {
      $('#suggestedExtraDisplay').text('You already meet the target payoff with current prepayments.').show();
      return;
    }

    // Binary search for extra to achieve payoff <= targetMonths
    var lo = 0, hi = P; // upper bound generous
    for (var iter=0; iter<40; iter++){
      var mid = (lo+hi)/2;
      var m = simulatePayoffMonths(P, r, n, emi, monthlyExtraFrom, lumps, mid);
      if (m > targetMonths) lo = mid; else hi = mid;
    }
    var needed = Math.ceil(hi/100)*100; // round to nearest 100
    $('#monthlyExtra').val(needed);
    $('#suggestedExtraDisplay').html('Suggested monthly extra to finish by '+ monthName(target.getMonth()+1)+' '+target.getFullYear()+': <span class="text-success">'+currency(needed)+'</span>. Clicked value is filled above.').show();
    recalc();
  });
  </script>

  <style>
    /* Beautify amortization table header and numeric columns */
    .amort-table thead th { position: sticky; top: 0; z-index: 2; background: #f8f9fa; }
    .amort-table td:nth-child(n+2), .amort-table th:nth-child(n+2) { text-align: right; white-space: nowrap; }
  </style>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>
<%@ include file="body-close.jsp"%>
