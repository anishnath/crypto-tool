<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIP Calculator - Systematic Investment Plan Calculator</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta name="description" content="Calculate your SIP returns with our free online SIP calculator. Plan your mutual fund investments and see how much wealth you can accumulate over time with systematic investment planning.">
    <meta name="keywords" content="SIP calculator, systematic investment plan, mutual fund calculator, SIP returns, investment calculator, wealth calculator, financial planning">

    <script type="application/ld+json">
    {
        "@context": "http://schema.org",
        "@type": "FinancialProduct",
        "name": "SIP Calculator - Systematic Investment Plan Calculator",
        "description": "Calculate your SIP returns and plan your investments with our free online SIP calculator. See how regular investments can grow your wealth over time.",
        "url": "https://8gwifi.org/sip-calculator.jsp",
        "author": {
            "@type": "Person",
            "name": "Anish Nath"
        },
        "datePublished": "2025-01-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
    <style>
        /* Ensure charts don’t cause resize feedback loops */
        .chart-wrap { position: relative; height: 260px; width: 100%; }
        .chart-wrap-sm { position: relative; height: 220px; width: 100%; }
        .chart-canvas { width: 100% !important; height: 100% !important; display: block; }
    </style>
</head>
<%@ include file="body-script.jsp"%>
    <div class="container mt-4">
        <h1 class="mb-3">SIP Calculator - Systematic Investment Plan</h1>
        <p class="mb-3">Plan your SIP and see results in a compact view.</p>

        <!-- Compact inputs + KPIs -->
        <div class="card mb-3">
            <div class="card-body">
                <form id="sip-form">
                    <div class="form-row">
                        <div class="form-group col-sm-6 col-md-3">
                            <label for="monthlyInvestment">Monthly Investment</label>
                            <div class="input-group input-group-sm">
                                <div class="input-group-prepend"><span class="input-group-text">₹</span></div>
                                <input type="number" value="5000" class="form-control" id="monthlyInvestment" required>
                            </div>
                        </div>
                        <div class="form-group col-sm-6 col-md-3">
                            <label for="expectedReturn">Annual Return</label>
                            <div class="input-group input-group-sm">
                                <input type="number" value="12" step="0.1" class="form-control" id="expectedReturn" required>
                                <div class="input-group-append"><span class="input-group-text">%</span></div>
                            </div>
                        </div>
                        <div class="form-group col-sm-6 col-md-3">
                            <label for="timePeriod">Years</label>
                            <div class="input-group input-group-sm">
                                <input type="number" value="10" class="form-control" id="timePeriod" required>
                                <div class="input-group-append"><span class="input-group-text">yrs</span></div>
                            </div>
                        </div>
                        <div class="form-group col-sm-6 col-md-3">
                            <label for="stepUpPercentage">Step-Up (annual)</label>
                            <div class="input-group input-group-sm">
                                <input type="number" value="0" step="0.1" class="form-control" id="stepUpPercentage" placeholder="0 for fixed">
                                <div class="input-group-append"><span class="input-group-text">%</span></div>
                            </div>
                        </div>
                    </div>
                </form>

                <div class="row no-gutters text-center">
                    <div class="col-sm-4 p-2">
                        <div class="p-2 border rounded small">
                            <div class="text-muted">Total Invested</div>
                            <div id="total-invested" class="font-weight-bold">0.00</div>
                        </div>
                    </div>
                    <div class="col-sm-4 p-2">
                        <div class="p-2 border rounded small">
                            <div class="text-muted">Expected Returns</div>
                            <div id="total-returns" class="font-weight-bold">0.00</div>
                        </div>
                    </div>
                    <div class="col-sm-4 p-2">
                        <div class="p-2 border rounded small">
                            <div class="text-muted">Maturity Value</div>
                            <div id="maturity-value" class="font-weight-bold" style="color:#1b5e20;">0.00</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Charts row -->
        <div class="row">
            <div class="col-lg-4 mb-3">
                <div class="card h-100">
                    <div class="card-header">Allocation</div>
                    <div class="card-body"><div class="chart-wrap"><canvas id="pie-chart" class="chart-canvas"></canvas></div></div>
                </div>
            </div>
            <div class="col-lg-8 mb-3">
                <div class="card h-100">
                    <div class="card-header">Wealth Accumulation</div>
                    <div class="card-body"><div class="chart-wrap"><canvas id="wealth-chart" class="chart-canvas"></canvas></div></div>
                </div>
            </div>
        </div>

        <!-- Scenario variants (compact what-if) -->
        <div class="card mb-3">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Scenario Variants</span>
                <div class="d-flex align-items-center">
                    <small class="text-muted mr-2">Sort by</small>
                    <select id="scenario-sort" class="custom-select custom-select-sm" style="width:auto">
                        <option value="value" selected>Maturity Value</option>
                        <option value="gain">Gain %</option>
                        <option value="invested">Total Invested (low)</option>
                        <option value="monthly">Monthly (low)</option>
                        <option value="years">Years (low)</option>
                    </select>
                </div>
            </div>
            <div class="card-body">
                <div id="scenario-reco" class="alert alert-success py-2 px-3 mb-3" style="display:none;"></div>
                <div class="table-responsive">
                    <table class="table table-sm mb-3">
                        <thead>
                            <tr>
                                <th>Scenario</th>
                                <th>Monthly</th>
                                <th>Years</th>
                                <th>Return</th>
                                <th>Step-Up</th>
                                <th>Total Invested</th>
                                <th>Maturity Value</th>
                                <th>Δ vs Base</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody id="scenario-body"></tbody>
                    </table>
                </div>
                <div class="chart-wrap-sm"><canvas id="scenario-chart" class="chart-canvas"></canvas></div>
            </div>
        </div>

        <!-- Year-wise breakdown (collapsible) -->
        <div class="card mb-3">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Year-wise Breakdown</span>
                <button class="btn btn-sm btn-outline-secondary" type="button" data-toggle="collapse" data-target="#yearlyCollapse">Toggle</button>
            </div>
            <div id="yearlyCollapse" class="collapse show">
                <div class="p-2" style="max-height:320px; overflow-y:auto;">
                    <table class="table table-sm table-striped mb-0">
                        <thead style="position: sticky; top: 0; background-color: white;">
                            <tr>
                                <th>Year</th>
                                <th>Investment (Year)</th>
                                <th>Total Invested</th>
                                <th>Returns (Year)</th>
                                <th>Total Value</th>
                            </tr>
                        </thead>
                        <tbody id="table-body"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        var pieChart = null;
        var wealthChart = null;
        var scenarioChart = null;

        function computeSipSummary(monthly, annualReturnPct, years, stepUpPct){
            var rMonthly = (annualReturnPct || 0) / 100 / 12;
            var totalInvested = 0;
            var currentValue = 0;
            var labels = [];
            var valueData = [];
            var investData = [];
            var monthlyAmt = monthly;
            for (var y=1; y<=years; y++){
                for (var m=1; m<=12; m++){
                    currentValue += monthlyAmt;
                    totalInvested += monthlyAmt;
                    currentValue = currentValue * (1 + rMonthly);
                }
                labels.push('Year ' + y);
                valueData.push(Number(currentValue.toFixed(2)));
                investData.push(Number(totalInvested.toFixed(2)));
                if (stepUpPct > 0 && y < years){ monthlyAmt = monthlyAmt * (1 + (stepUpPct/100)); }
            }
            return { labels: labels, invest: investData, values: valueData, totalInvested: totalInvested, totalValue: currentValue };
        }

        function calculateSIP() {
            var monthlyInvestment = parseFloat($("#monthlyInvestment").val());
            var expectedReturn = parseFloat($("#expectedReturn").val()) / 100 / 12; // Monthly return rate
            var timePeriodYears = parseFloat($("#timePeriod").val());
            var stepUpPercentage = parseFloat($("#stepUpPercentage").val()) / 100;

            var totalMonths = timePeriodYears * 12;
            var totalInvested = 0;
            var currentValue = 0;
            var yearlyData = [];
            var monthlyInvestmentAmount = monthlyInvestment;

            // Arrays for wealth chart
            var labels = [];
            var investedData = [];
            var valueData = [];

            var tableHTML = "";

            for (var year = 1; year <= timePeriodYears; year++) {
                var yearInvestment = 0;
                var yearStartValue = currentValue;

                for (var month = 1; month <= 12; month++) {
                    // Add monthly investment
                    currentValue += monthlyInvestmentAmount;
                    totalInvested += monthlyInvestmentAmount;
                    yearInvestment += monthlyInvestmentAmount;

                    // Calculate returns on current value
                    currentValue = currentValue * (1 + expectedReturn);
                }

                var yearEndValue = currentValue;
                var yearReturns = yearEndValue - yearStartValue - yearInvestment;

                yearlyData.push({
                    year: year,
                    yearInvestment: yearInvestment,
                    totalInvested: totalInvested,
                    yearReturns: yearReturns,
                    totalValue: yearEndValue
                });

                labels.push("Year " + year);
                investedData.push(totalInvested.toFixed(2));
                valueData.push(yearEndValue.toFixed(2));

                tableHTML += "<tr>" +
                    "<td>" + year + "</td>" +
                    "<td>" + yearInvestment.toFixed(2) + "</td>" +
                    "<td>" + totalInvested.toFixed(2) + "</td>" +
                    "<td>" + yearReturns.toFixed(2) + "</td>" +
                    "<td><strong>" + yearEndValue.toFixed(2) + "</strong></td>" +
                    "</tr>";

                // Apply step-up for next year
                if (stepUpPercentage > 0 && year < timePeriodYears) {
                    monthlyInvestmentAmount = monthlyInvestmentAmount * (1 + stepUpPercentage);
                }
            }

            var totalReturns = currentValue - totalInvested;

            // Update summary
            $("#total-invested").text(totalInvested.toFixed(2));
            $("#total-returns").text(totalReturns.toFixed(2));
            $("#maturity-value").text(currentValue.toFixed(2));

            // Update table
            $("#table-body").html(tableHTML);

            // Destroy previous pie chart if exists
            if (pieChart) {
                pieChart.destroy();
            }

            // Create pie chart
            var ctx = document.getElementById('pie-chart').getContext('2d');
            pieChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Total Invested', 'Expected Returns'],
                    datasets: [{
                        data: [totalInvested, totalReturns],
                        backgroundColor: ['#4285F4', '#34A853'],
                    }],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        }
                    }
                }
            });

            // Destroy previous wealth chart if exists
            if (wealthChart) {
                wealthChart.destroy();
            }

            // Create wealth accumulation chart
            var ctxWealth = document.getElementById('wealth-chart').getContext('2d');
            wealthChart = new Chart(ctxWealth, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Total Invested',
                            data: investedData,
                            borderColor: '#4285F4',
                            backgroundColor: 'rgba(66, 133, 244, 0.1)',
                            fill: true,
                        },
                        {
                            label: 'Total Value',
                            data: valueData,
                            borderColor: '#34A853',
                            backgroundColor: 'rgba(52, 168, 83, 0.1)',
                            fill: true,
                        }
                    ],
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: false,
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Amount'
                            }
                        },
                        x: {
                            title: {
                                display: true,
                                text: 'Investment Period'
                            }
                        }
                    }
                }
            });

            // Scenario variants
            var rawAnnual = parseFloat($("#expectedReturn").val());
            var rawStepUp = parseFloat($("#stepUpPercentage").val());

            // Scenarios: keep return fixed; vary Monthly and Years
            function clampYear(y){ return Math.max(1, Math.round(y)); }
            function roundMoney(x){ return Math.max(0, Math.round(x)); }
            var scenarios = [
                { key:'base', label:'Base', monthly: monthlyInvestment, years: timePeriodYears, rate: rawAnnual, step: rawStepUp },
                { key:'m+10', label:'+10% monthly', monthly: roundMoney(monthlyInvestment*1.10), years: timePeriodYears, rate: rawAnnual, step: rawStepUp },
                { key:'m+20', label:'+20% monthly', monthly: roundMoney(monthlyInvestment*1.20), years: timePeriodYears, rate: rawAnnual, step: rawStepUp },
                { key:'m+50', label:'+50% monthly', monthly: roundMoney(monthlyInvestment*1.50), years: timePeriodYears, rate: rawAnnual, step: rawStepUp },
                { key:'m-10', label:'-10% monthly', monthly: roundMoney(monthlyInvestment*0.90), years: timePeriodYears, rate: rawAnnual, step: rawStepUp },
                { key:'y+1', label:'+1 year', monthly: monthlyInvestment, years: clampYear(timePeriodYears+1), rate: rawAnnual, step: rawStepUp },
                { key:'y+3', label:'+3 years', monthly: monthlyInvestment, years: clampYear(timePeriodYears+3), rate: rawAnnual, step: rawStepUp },
                { key:'y-1', label:'-1 year', monthly: monthlyInvestment, years: clampYear(timePeriodYears-1), rate: rawAnnual, step: rawStepUp },
                { key:'y-2', label:'-2 years', monthly: monthlyInvestment, years: clampYear(timePeriodYears-2), rate: rawAnnual, step: rawStepUp },
                { key:'aggr1', label:'+20% monthly, -2y', monthly: roundMoney(monthlyInvestment*1.20), years: clampYear(timePeriodYears-2), rate: rawAnnual, step: rawStepUp },
                { key:'aggr2', label:'+30% monthly, -3y', monthly: roundMoney(monthlyInvestment*1.30), years: clampYear(timePeriodYears-3), rate: rawAnnual, step: rawStepUp },
                { key:'bal1', label:'+10% monthly, +1y', monthly: roundMoney(monthlyInvestment*1.10), years: clampYear(timePeriodYears+1), rate: rawAnnual, step: rawStepUp },
                { key:'step10', label:'Step-Up 10% (override)', monthly: monthlyInvestment, years: timePeriodYears, rate: rawAnnual, step: 10 }
            ];

            // Compute results
            var results = scenarios.map(function(s){
                var R = computeSipSummary(s.monthly, s.rate, s.years, s.step);
                var gain = R.totalValue - R.totalInvested;
                var gainPct = R.totalInvested > 0 ? (gain / R.totalInvested) * 100 : 0;
                return { meta:s, data:R, gain:gain, gainPct:gainPct };
            });

            var baseRes = results.find(function(r){ return r.meta.key === 'base'; });
            function fmt(n){ return Number(n).toFixed(2); }

            // Sort
            var sortMode = $('#scenario-sort').val() || 'value';
            results.sort(function(a,b){
                if (sortMode === 'monthly') return a.meta.monthly - b.meta.monthly;
                if (sortMode === 'years') return a.meta.years - b.meta.years;
                if (sortMode === 'gain') return b.gainPct - a.gainPct;
                if (sortMode === 'invested') return a.data.totalInvested - b.data.totalInvested;
                return b.data.totalValue - a.data.totalValue; // value
            });

            // Recommendation: pick top non-base per current sort, prefer positive delta vs base
            var recommended = results.find(function(r){ return r.meta.key !== 'base' && (!baseRes || r.data.totalValue >= baseRes.data.totalValue); }) || results.find(function(r){ return r.meta.key !== 'base'; });

            // Render table with color cues
            var tbody = '';
            results.forEach(function(r){
                var delta = baseRes ? (r.data.totalValue - baseRes.data.totalValue) : 0;
                var deltaHtml = baseRes ? (delta >= 0 ? '<span class="text-success">+'+fmt(delta)+'</span>' : '<span class="text-danger">'+fmt(delta)+'</span>') : '—';
                var gainBadge = (!baseRes || r.gainPct >= baseRes.gainPct) ? 'badge badge-success' : 'badge badge-secondary';
                var trClass = (recommended && r.meta.key === recommended.meta.key) ? ' class="table-success"' : '';
                tbody += '<tr'+trClass+'>\n'
                    + '<td>'+r.meta.label+'</td>'
                    + '<td>'+fmt(r.meta.monthly)+'</td>'
                    + '<td>'+r.meta.years+'</td>'
                    + '<td>'+fmt(r.meta.rate)+'%</td>'
                    + '<td>'+fmt(r.meta.step||0)+'%</td>'
                    + '<td>'+fmt(r.data.totalInvested)+'</td>'
                    + '<td><strong>'+fmt(r.data.totalValue)+'</strong> <span class="'+gainBadge+'">'+fmt(r.gainPct)+'%</span></td>'
                    + '<td>'+ deltaHtml +'</td>'
                    + '<td><button class="btn btn-sm btn-outline-primary act-apply" data-monthly="'+r.meta.monthly+'" data-years="'+r.meta.years+'" data-rate="'+r.meta.rate+'" data-step="'+(r.meta.step||0)+'">Use</button></td>'
                    + '</tr>';
            });
            $("#scenario-body").html(tbody);

            // Recommendation banner text
            if (recommended) {
                var d = baseRes ? (recommended.data.totalValue - baseRes.data.totalValue) : 0;
                var dHtml = baseRes ? (d >= 0 ? '<span class="text-success">+'+fmt(d)+'</span>' : '<span class="text-danger">'+fmt(d)+'</span>') : '';
                var msg = '<strong>Recommended:</strong> '+recommended.meta.label+
                    ' — Maturity '+ (baseRes ? ('vs Base: '+ dHtml +', ') : '') +
                    'Gain <span class="text-primary">'+fmt(recommended.gainPct)+'%</span>'+ 
                    ', Invested '+fmt(recommended.data.totalInvested)+
                    ' | <a href="#" class="act-apply" data-monthly="'+recommended.meta.monthly+'" data-years="'+recommended.meta.years+'" data-rate="'+recommended.meta.rate+'" data-step="'+(recommended.meta.step||0)+'">Use this</a>';
                $('#scenario-reco').html(msg).show();
            } else {
                $('#scenario-reco').hide();
            }

            // Chart: base + top 3 scenarios
            if (scenarioChart) scenarioChart.destroy();
            var sctx = document.getElementById('scenario-chart').getContext('2d');
            var maxYears = Math.max.apply(null, results.map(function(r){ return r.data.labels.length; }));
            function pad(arr){ var a = arr.slice(); while(a.length<maxYears) a.push(null); return a; }
            var top3 = results.filter(function(r){ return r.meta.key !== 'base'; }).slice(0,3);
            var datasets = [];
            if (baseRes) datasets.push({ label:'Base', data: pad(baseRes.data.values), borderColor:'#1e88e5', backgroundColor:'rgba(30,136,229,0.08)', fill:false, tension:0.15 });
            var colors = ['#43a047','#fb8c00','#8e24aa','#f4511e','#3949ab'];
            top3.forEach(function(r, i){ datasets.push({ label:r.meta.label, data: pad(r.data.values), borderColor: colors[i%colors.length], backgroundColor: 'transparent', fill:false, tension:0.15 }); });
            scenarioChart = new Chart(sctx, {
                type: 'line',
                data: { labels: Array.from({length:maxYears}, (_,i)=>'Year '+(i+1)), datasets: datasets },
                options: { responsive:true, maintainAspectRatio:false, animation:false, plugins:{ legend:{ position:'bottom' } }, scales:{ y:{ beginAtZero:true }, x:{ title:{ display:true, text:'Years' } } } }
            });

            // Apply handler
            $("#scenario-body .act-apply").off('click').on('click', function(){
                var $b = $(this);
                $('#monthlyInvestment').val(Number($b.data('monthly')).toFixed(0));
                $('#timePeriod').val(Number($b.data('years')).toFixed(0));
                // Keep annual return as user set (fixed); do not override
                $('#stepUpPercentage').val(Number($b.data('step')).toFixed(1));
                calculateSIP();
            });
        }

        // Attach event listeners for dynamic updates
        var sipDebounce = null;
        $("#monthlyInvestment, #expectedReturn, #timePeriod, #stepUpPercentage").on("input", function(){
            clearTimeout(sipDebounce);
            sipDebounce = setTimeout(calculateSIP, 200);
        });
        $('#scenario-sort').on('change', calculateSIP);

        // Initial calculation
        calculateSIP();
    </script>

    <div class="mt-5">
        <h5 class="card-header">Try Other Calculators</h5>
        <ul>
            <li><a href="sip-calculator.jsp">SIP Calculator</a></li>
            <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
            <li><a href="cinterest2.jsp">Compound Interest Calculator (Compare Rates)</a></li>
            <li><a href="cinterest.jsp">Compound Interest Calculator (Simple)</a></li>
            <li><a href="stock-calc.jsp">Stock Profit Calculator</a></li>
        </ul>
    </div>

    <hr>

    <div class="mt-4">
        <h2>What is SIP (Systematic Investment Plan)?</h2>
        <p>A Systematic Investment Plan (SIP) is a method of investing in mutual funds where you invest a fixed amount at regular intervals (usually monthly). SIP is one of the most popular and disciplined ways to build wealth over time.</p>

        <h3>Benefits of SIP</h3>
        <ul>
            <li><strong>Rupee Cost Averaging:</strong> By investing regularly, you buy more units when prices are low and fewer when prices are high, averaging out your purchase cost.</li>
            <li><strong>Power of Compounding:</strong> Your returns generate further returns, leading to exponential wealth growth over time.</li>
            <li><strong>Disciplined Investing:</strong> Automated monthly investments ensure consistent saving and investment habits.</li>
            <li><strong>Flexibility:</strong> Start with small amounts and increase investments as your income grows.</li>
            <li><strong>No Market Timing:</strong> You don't need to time the market - regular investments work in all market conditions.</li>
        </ul>

        <h3>How is SIP Return Calculated?</h3>
        <p>The SIP return is calculated using the future value of an annuity formula, which compounds your regular investments over time:</p>
        <p><strong>M = P × ({[1 + i]^n – 1} / i) × (1 + i)</strong></p>
        <ul>
            <li><strong>M</strong> = Maturity amount (final value)</li>
            <li><strong>P</strong> = Monthly investment amount</li>
            <li><strong>i</strong> = Expected monthly return rate (annual rate / 12)</li>
            <li><strong>n</strong> = Total number of months</li>
        </ul>

        <h3>Step-Up SIP</h3>
        <p>A step-up SIP allows you to increase your investment amount periodically (usually annually). This helps you invest more as your income grows, accelerating your wealth creation significantly.</p>

        <h3>Example</h3>
        <p>If you invest ₹5,000 per month for 10 years at an expected annual return of 12%:</p>
        <ul>
            <li>Total Investment: ₹6,00,000</li>
            <li>Expected Returns: ₹5,49,567</li>
            <li>Maturity Value: ₹11,49,567</li>
        </ul>
        <p>Your investment nearly doubles through the power of compounding!</p>
    </div>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
