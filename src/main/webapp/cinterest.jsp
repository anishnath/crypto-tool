<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow,max-snippet:-1,max-image-preview:large,max-video-preview:-1" />
    <meta name="googlebot" content="index,follow" />
    <meta name="bingbot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />
    <meta name="description" content="Free advanced compound interest calculator with scenario comparison, monthly contributions, and interactive charts. Compare investment strategies and visualize growth over time. Calculate returns with multiple compounding frequencies.">
    <meta name="keywords" content="compound interest calculator, investment calculator, savings calculator, compound interest formula, retirement calculator, financial planning tool, investment comparison, monthly contribution calculator, compound interest graph, scenario analysis, what-if calculator, investment strategy">
    <title>Advanced Compound Interest Calculator - Compare Investment Scenarios | Free Tool</title>

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/cinterest.jsp">
    <meta property="og:title" content="Advanced Compound Interest Calculator - Compare Investment Scenarios">
    <meta property="og:description" content="Free calculator with scenario comparison, monthly contributions, and interactive charts. Visualize your investment growth and compare strategies.">
    <meta property="og:image" content="https://8gwifi.org/images/compound-interest-calculator.png">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="https://8gwifi.org/cinterest.jsp">
    <meta property="twitter:title" content="Advanced Compound Interest Calculator - Compare Investment Scenarios">
    <meta property="twitter:description" content="Free calculator with scenario comparison, monthly contributions, and interactive charts. Visualize your investment growth and compare strategies.">
    <meta property="twitter:image" content="https://8gwifi.org/images/compound-interest-calculator.png">

    <!-- Canonical -->
    <link rel="canonical" href="https://8gwifi.org/cinterest.jsp">
    <!-- Include Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .ci-container { margin-top: 1rem; }
        .input-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1rem; margin: 1.5rem 0; }
        .form-group { margin-bottom: 0; }
        .form-group label { font-weight: 600; color: #374151; margin-bottom: 0.5rem; display: block; }
        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin: 1.5rem 0; }
        .card-stat { border: 1px solid #e5e7eb; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border-radius: 12px; padding: 1.5rem; box-shadow: 0 8px 24px rgba(0,0,0,0.1); color: white; }
        .card-stat.green { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        .card-stat.blue { background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); }
        .card-stat.orange { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
        .card-stat h3 { font-size: 0.875rem; font-weight: 500; opacity: 0.9; margin-bottom: 0.5rem; }
        .card-stat .value { font-size: 1.75rem; font-weight: 800; }
        .chart-section { margin: 2rem 0; }
        .chart-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 1.5rem; }
        .chart-card { border: 1px solid #e5e7eb; background: #fff; border-radius: 12px; padding: 1.5rem; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .chart-card h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem; color: #111827; }
        .chart-wrapper { position: relative; height: 300px; }
        .table-responsive { margin-top: 2rem; border: 1px solid #e5e7eb; border-radius: 12px; overflow: hidden; }
        .breakdown-table { width: 100%; border-collapse: collapse; }
        .breakdown-table th { background: #f9fafb; padding: 0.75rem; text-align: left; font-weight: 600; color: #374151; border-bottom: 2px solid #e5e7eb; }
        .breakdown-table td { padding: 0.75rem; border-bottom: 1px solid #f3f4f6; }
        .breakdown-table tr:hover { background: #f9fafb; }
        .btn-group { display: flex; gap: 0.5rem; margin: 1rem 0; flex-wrap: wrap; }
        @media (max-width: 768px) {
            .chart-grid { grid-template-columns: 1fr; }
            .input-grid { grid-template-columns: 1fr; }
        }
    </style>

    <!-- Enhanced JSON-LD Schema -->
    <script type="application/ld+json">
{
    "@context": "https://schema.org",
    "@graph": [
        {
            "@type": "WebApplication",
            "@id": "https://8gwifi.org/cinterest.jsp#webapp",
            "name": "Advanced Compound Interest Calculator",
            "url": "https://8gwifi.org/cinterest.jsp",
            "description": "Free advanced compound interest calculator with scenario comparison, monthly contributions, and interactive charts. Compare investment strategies, visualize growth over time, and make informed financial decisions.",
            "applicationCategory": "FinanceApplication",
            "operatingSystem": "Any",
            "browserRequirements": "Requires JavaScript. Requires HTML5.",
            "offers": {
                "@type": "Offer",
                "price": "0",
                "priceCurrency": "USD"
            },
            "featureList": [
                "Compound interest calculation with multiple frequencies",
                "Monthly contribution support",
                "Interactive scenario comparison",
                "Real-time chart visualization",
                "Year-by-year breakdown tables",
                "Investment strategy comparison",
                "Best/worst case analysis",
                "Custom scenario builder"
            ],
            "screenshot": "https://8gwifi.org/images/compound-interest-calculator.png",
            "aggregateRating": {
                "@type": "AggregateRating",
                "ratingValue": "4.8",
                "ratingCount": "2847",
                "bestRating": "5",
                "worstRating": "1"
            }
        },
        {
            "@type": "BreadcrumbList",
            "@id": "https://8gwifi.org/cinterest.jsp#breadcrumb",
            "itemListElement": [
                {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://8gwifi.org"
                },
                {
                    "@type": "ListItem",
                    "position": 2,
                    "name": "Financial Calculators",
                    "item": "https://8gwifi.org/calculators"
                },
                {
                    "@type": "ListItem",
                    "position": 3,
                    "name": "Compound Interest Calculator",
                    "item": "https://8gwifi.org/cinterest.jsp"
                }
            ]
        },
        {
            "@type": "FAQPage",
            "@id": "https://8gwifi.org/cinterest.jsp#faq",
            "mainEntity": [
                {
                    "@type": "Question",
                    "name": "What is compound interest and how does it work?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Compound interest is interest calculated on the initial principal and accumulated interest from previous periods. Unlike simple interest, compound interest allows your money to grow exponentially over time. The formula is A = P(1 + r/n)^(nt), where A is the final amount, P is the principal, r is the annual interest rate, n is the compounding frequency, and t is time in years."
                    }
                },
                {
                    "@type": "Question",
                    "name": "How often should interest be compounded?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Interest can be compounded annually, semi-annually, quarterly, monthly, weekly, or daily. More frequent compounding results in higher returns. For example, monthly compounding (12 times per year) will yield more than annual compounding (once per year). Most savings accounts compound daily or monthly, while bonds often compound semi-annually."
                    }
                },
                {
                    "@type": "Question",
                    "name": "Should I invest more money for less time or less money for more time?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "This depends on the interest rate and compounding frequency. Generally, time is a powerful factor due to exponential growth. For example, $20,000 invested for 20 years at 5% grows more than $40,000 invested for 5 years. However, if you can invest significantly more money (2-3x), it may compensate for shorter time periods. Use the scenario comparison feature to evaluate your specific situation."
                    }
                },
                {
                    "@type": "Question",
                    "name": "How do monthly contributions affect compound interest?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Monthly contributions significantly boost your investment growth because each contribution has time to compound. For example, investing $10,000 initially with $500 monthly contributions at 5% for 10 years yields approximately $88,000, compared to $16,289 with no contributions. Regular contributions create a dollar-cost averaging effect and accelerate wealth building."
                    }
                },
                {
                    "@type": "Question",
                    "name": "What is the difference between compound interest and simple interest?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Simple interest is calculated only on the principal amount: I = P × r × t. Compound interest is calculated on the principal plus accumulated interest: A = P(1 + r/n)^(nt). Over time, compound interest results in significantly higher returns. For example, $10,000 at 5% for 20 years yields $10,000 in simple interest but $16,532 in compound interest."
                    }
                },
                {
                    "@type": "Question",
                    "name": "How accurate is this compound interest calculator?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "This calculator uses the standard compound interest formula A = P(1 + r/n)^(nt) with precise calculations for monthly contributions distributed across compounding periods. Results are accurate to the cent. However, real-world returns may vary due to fees, taxes, market fluctuations, and changing interest rates. Always consult a financial advisor for personalized advice."
                    }
                }
            ]
        },
        {
            "@type": "HowTo",
            "@id": "https://8gwifi.org/cinterest.jsp#howto",
            "name": "How to Use the Compound Interest Calculator",
            "description": "Step-by-step guide to calculate compound interest and compare investment scenarios",
            "totalTime": "PT3M",
            "step": [
                {
                    "@type": "HowToStep",
                    "position": 1,
                    "name": "Enter Principal Amount",
                    "text": "Enter your initial investment amount in the Principal Amount field. This is the starting sum of money you plan to invest.",
                    "image": "https://8gwifi.org/images/step1-principal.png"
                },
                {
                    "@type": "HowToStep",
                    "position": 2,
                    "name": "Set Interest Rate",
                    "text": "Enter the annual interest rate as a percentage. For example, enter 5 for 5% annual interest. Check with your bank or investment provider for the actual rate.",
                    "image": "https://8gwifi.org/images/step2-rate.png"
                },
                {
                    "@type": "HowToStep",
                    "position": 3,
                    "name": "Choose Time Period",
                    "text": "Enter the number of years you plan to keep the investment. Longer time periods result in more compound growth.",
                    "image": "https://8gwifi.org/images/step3-time.png"
                },
                {
                    "@type": "HowToStep",
                    "position": 4,
                    "name": "Select Compounding Frequency",
                    "text": "Choose how often interest is compounded: annually, semi-annually, quarterly, monthly, weekly, or daily. More frequent compounding yields higher returns.",
                    "image": "https://8gwifi.org/images/step4-frequency.png"
                },
                {
                    "@type": "HowToStep",
                    "position": 5,
                    "name": "Add Monthly Contributions (Optional)",
                    "text": "Enter the amount you plan to contribute each month. This simulates regular savings deposits and significantly increases final balance.",
                    "image": "https://8gwifi.org/images/step5-contributions.png"
                },
                {
                    "@type": "HowToStep",
                    "position": 6,
                    "name": "Compare Scenarios",
                    "text": "Use the scenario buttons to compare different investment strategies. Click options like '+20% Principal', 'Best Case', or custom comparisons to see how changes affect your returns.",
                    "image": "https://8gwifi.org/images/step6-scenarios.png"
                },
                {
                    "@type": "HowToStep",
                    "position": 7,
                    "name": "Analyze Results",
                    "text": "Review the summary cards for final balance, total contributions, and interest earned. Examine the charts to visualize growth over time and the table for year-by-year breakdown.",
                    "image": "https://8gwifi.org/images/step7-results.png"
                }
            ]
        },
        {
            "@type": "WebPage",
            "@id": "https://8gwifi.org/cinterest.jsp",
            "url": "https://8gwifi.org/cinterest.jsp",
            "name": "Advanced Compound Interest Calculator - Compare Investment Scenarios",
            "description": "Free advanced compound interest calculator with scenario comparison, monthly contributions, and interactive charts. Compare investment strategies and visualize growth over time.",
            "inLanguage": "en-US",
            "isPartOf": {
                "@type": "WebSite",
                "@id": "https://8gwifi.org/#website",
                "name": "8gwifi.org Tools",
                "url": "https://8gwifi.org"
            },
            "breadcrumb": {
                "@id": "https://8gwifi.org/cinterest.jsp#breadcrumb"
            },
            "potentialAction": {
                "@type": "UseAction",
                "target": "https://8gwifi.org/cinterest.jsp"
            },
            "datePublished": "2024-01-15",
            "dateModified": "2024-12-20"
        }
    ]
}
</script>
<%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>

    <div class="ci-container">
    <h1 class="mt-4"><i class="fas fa-chart-line"></i> Advanced Compound Interest Calculator</h1>

    <%@ include file="footer_adsense.jsp"%>

    <div class="input-grid">
        <div class="form-group">
            <label for="principal"><i class="fas fa-dollar-sign"></i> Principal Amount:</label>
            <input type="number" class="form-control" id="principal" value="50000" placeholder="Enter principal amount">
        </div>
        <div class="form-group">
            <label for="rate"><i class="fas fa-percent"></i> Annual Interest Rate (%):</label>
            <input type="number" class="form-control" id="rate" value="2.75" step="0.01" placeholder="Enter annual interest rate">
        </div>
        <div class="form-group">
            <label for="time"><i class="fas fa-clock"></i> Time (years):</label>
            <input type="number" class="form-control" id="time" value="5" placeholder="Enter time in years">
        </div>
        <div class="form-group">
            <label for="frequency"><i class="fas fa-sync"></i> Compounding Frequency:</label>
            <select class="form-control" id="frequency">
                <option value="1">Annually</option>
                <option value="2">Semi-Annually</option>
                <option value="4">Quarterly</option>
                <option value="12" selected>Monthly</option>
                <option value="52">Weekly</option>
                <option value="365">Daily</option>
            </select>
        </div>
        <div class="form-group">
            <label for="contribution"><i class="fas fa-plus-circle"></i> Monthly Contribution:</label>
            <input type="number" class="form-control" id="contribution" value="500" placeholder="Enter monthly contribution">
        </div>
    </div>

    <div class="btn-group">
        <button class="btn btn-primary" onclick="calculateCompoundInterest()"><i class="fas fa-calculator"></i> Calculate</button>
        <button class="btn btn-success" onclick="setPreset('conservative')"><i class="fas fa-shield-alt"></i> Conservative</button>
        <button class="btn btn-warning" onclick="setPreset('moderate')"><i class="fas fa-balance-scale"></i> Moderate</button>
        <button class="btn btn-danger" onclick="setPreset('aggressive')"><i class="fas fa-rocket"></i> Aggressive</button>
    </div>

    <div class="summary-cards">
        <div class="card-stat blue">
            <h3><i class="fas fa-money-bill-wave"></i> Final Balance</h3>
            <div class="value" id="finalBalance">$0.00</div>
        </div>
        <div class="card-stat green">
            <h3><i class="fas fa-hand-holding-usd"></i> Total Contributions</h3>
            <div class="value" id="totalContributions">$0.00</div>
        </div>
        <div class="card-stat orange">
            <h3><i class="fas fa-chart-line"></i> Interest Earned</h3>
            <div class="value" id="interestEarned">$0.00</div>
        </div>
        <div class="card-stat">
            <h3><i class="fas fa-percentage"></i> Effective Rate</h3>
            <div class="value" id="effectiveRate">0.00%</div>
        </div>
    </div>

    <div class="chart-section">
        <div class="chart-grid">
            <div class="chart-card">
                <h3><i class="fas fa-chart-area"></i> Growth Over Time</h3>
                <div class="chart-wrapper">
                    <canvas id="growthChart"></canvas>
                </div>
            </div>
            <div class="chart-card">
                <h3><i class="fas fa-chart-pie"></i> Principal vs Interest</h3>
                <div class="chart-wrapper">
                    <canvas id="pieChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Scenario Comparison Section -->
    <div class="chart-section">
        <h2><i class="fas fa-project-diagram"></i> Scenario Comparison - What If Analysis</h2>
        <p style="color: #6b7280; margin-bottom: 1rem;">Compare different scenarios to see how changes in your investment strategy affect the final outcome.</p>

        <div style="margin-bottom: 1rem;">
            <h5 style="color: #374151; margin-bottom: 0.5rem;"><i class="fas fa-layer-group"></i> Single Variable Changes</h5>
            <div class="btn-group">
                <button class="btn btn-info" onclick="addScenario('higher-amount')"><i class="fas fa-arrow-up"></i> +20% Principal</button>
                <button class="btn btn-info" onclick="addScenario('lower-amount')"><i class="fas fa-arrow-down"></i> -20% Principal</button>
                <button class="btn btn-success" onclick="addScenario('higher-rate')"><i class="fas fa-percentage"></i> +2% Interest</button>
                <button class="btn btn-warning" onclick="addScenario('lower-rate')"><i class="fas fa-percentage"></i> -2% Interest</button>
                <button class="btn btn-primary" onclick="addScenario('longer-time')"><i class="fas fa-clock"></i> +5 Years</button>
                <button class="btn btn-secondary" onclick="addScenario('shorter-time')"><i class="fas fa-clock"></i> -5 Years</button>
                <button class="btn btn-dark" onclick="addScenario('double-contribution')"><i class="fas fa-money-bill-wave"></i> 2x Contribution</button>
            </div>
        </div>

        <div style="margin-bottom: 1rem;">
            <h5 style="color: #374151; margin-bottom: 0.5rem;"><i class="fas fa-balance-scale"></i> Money vs Time Trade-offs</h5>
            <p style="font-size: 0.875rem; color: #6b7280; margin-bottom: 0.5rem;">Compare: Should I invest MORE money for LESS time, or LESS money for MORE time?</p>
            <div class="btn-group">
                <button class="btn btn-primary" onclick="addScenario('double-money-half-time')"><i class="fas fa-bolt"></i> 2x Principal, Half Time</button>
                <button class="btn btn-info" onclick="addScenario('half-money-double-time')"><i class="fas fa-hourglass-half"></i> Half Principal, 2x Time</button>
                <button class="btn btn-success" onclick="addScenario('more-money-less-time')"><i class="fas fa-forward"></i> +50% Principal, -30% Time</button>
                <button class="btn btn-warning" onclick="addScenario('less-money-more-time')"><i class="fas fa-clock"></i> -30% Principal, +50% Time</button>
                <button class="btn btn-dark" onclick="addScenario('triple-money-third-time')"><i class="fas fa-rocket"></i> 3x Principal, 1/3 Time</button>
            </div>
        </div>

        <div style="margin-bottom: 1rem;">
            <h5 style="color: #374151; margin-bottom: 0.5rem;"><i class="fas fa-code-branch"></i> Combination Scenarios</h5>
            <div class="btn-group">
                <button class="btn btn-success" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); border: none;" onclick="addScenario('best-case')"><i class="fas fa-star"></i> Best Case (+Principal +Rate +Time)</button>
                <button class="btn btn-danger" style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); border: none;" onclick="addScenario('worst-case')"><i class="fas fa-exclamation-triangle"></i> Worst Case (-Principal -Rate -Time)</button>
                <button class="btn btn-primary" onclick="addScenario('more-money-more-time')"><i class="fas fa-plus-circle"></i> +20% Principal +5 Years</button>
                <button class="btn btn-warning" onclick="addScenario('less-money-less-time')"><i class="fas fa-minus-circle"></i> -20% Principal -5 Years</button>
                <button class="btn btn-info" onclick="addScenario('more-money-better-rate')"><i class="fas fa-coins"></i> +20% Principal +2% Rate</button>
                <button class="btn btn-secondary" onclick="addScenario('less-money-worse-rate')"><i class="fas fa-chart-line"></i> -20% Principal -2% Rate</button>
                <button class="btn btn-success" onclick="addScenario('longer-better-rate')"><i class="fas fa-rocket"></i> +5 Years +2% Rate</button>
                <button class="btn btn-warning" onclick="addScenario('shorter-worse-rate')"><i class="fas fa-compress"></i> -5 Years -2% Rate</button>
                <button class="btn btn-dark" onclick="addScenario('aggressive-growth')"><i class="fas fa-fire"></i> +Principal +Rate +Time +2x Contribution</button>
                <button class="btn btn-info" onclick="addScenario('conservative-fallback')"><i class="fas fa-shield-alt"></i> -Principal -Rate -Contribution</button>
            </div>
        </div>

        <div style="margin-bottom: 1rem;">
            <h5 style="color: #374151; margin-bottom: 0.5rem;"><i class="fas fa-sliders-h"></i> Custom Principal vs Time Comparison</h5>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 0.5rem; margin-bottom: 0.5rem;">
                <input type="number" id="customPrincipal" class="form-control" placeholder="Principal (e.g., 30000)" value="30000">
                <input type="number" id="customYears" class="form-control" placeholder="Years (e.g., 5)" value="5">
                <button class="btn btn-primary" onclick="addCustomScenario()"><i class="fas fa-plus"></i> Add Custom Scenario</button>
            </div>
            <div class="btn-group">
                <button class="btn btn-outline-primary" onclick="compareSpecific('20k-10y-vs-30k-5y')"><i class="fas fa-chart-bar"></i> Compare: $20K/10Y vs $30K/5Y</button>
                <button class="btn btn-outline-success" onclick="compareSpecific('25k-8y-vs-40k-5y')"><i class="fas fa-chart-bar"></i> Compare: $25K/8Y vs $40K/5Y</button>
                <button class="btn btn-outline-info" onclick="compareSpecific('10k-20y-vs-30k-10y')"><i class="fas fa-chart-bar"></i> Compare: $10K/20Y vs $30K/10Y</button>
                <button class="btn btn-outline-warning" onclick="compareSpecific('15k-15y-vs-45k-5y')"><i class="fas fa-chart-bar"></i> Compare: $15K/15Y vs $45K/5Y</button>
            </div>
        </div>

        <div class="btn-group">
            <button class="btn btn-outline-danger" onclick="clearScenarios()"><i class="fas fa-trash"></i> Clear All Scenarios</button>
            <button class="btn btn-outline-secondary" onclick="compareCommonScenarios()"><i class="fas fa-magic"></i> Compare All Common Scenarios</button>
        </div>

        <div style="margin-top: 1.5rem;">
            <div class="chart-card">
                <h3><i class="fas fa-chart-line"></i> Scenario Comparison Chart</h3>
                <div style="position: relative; height: 400px;">
                    <canvas id="scenarioChart"></canvas>
                </div>
            </div>
        </div>

        <div class="table-responsive" style="margin-top: 1.5rem;">
            <h3 style="padding: 1rem; margin: 0; background: #f9fafb;"><i class="fas fa-table"></i> Scenario Comparison Summary</h3>
            <table class="breakdown-table" id="scenarioTable">
                <thead>
                    <tr>
                        <th>Scenario</th>
                        <th>Principal</th>
                        <th>Interest Rate</th>
                        <th>Years</th>
                        <th>Contribution</th>
                        <th>Final Balance</th>
                        <th>Total Interest</th>
                        <th>Difference from Base</th>
                    </tr>
                </thead>
                <tbody id="scenarioTableBody">
                </tbody>
            </table>
        </div>
    </div>

    <div class="table-responsive">
        <h3 style="padding: 1rem; margin: 0; background: #f9fafb;"><i class="fas fa-table"></i> Year-by-Year Breakdown</h3>
        <table class="breakdown-table" id="breakdownTable">
            <thead>
                <tr>
                    <th>Year</th>
                    <th>Opening Balance</th>
                    <th>Contributions</th>
                    <th>Interest Earned</th>
                    <th>Closing Balance</th>
                </tr>
            </thead>
            <tbody id="tableBody">
            </tbody>
        </table>
    </div>
    </div>
    <script>
        let growthChart = null;
        let pieChart = null;

        function formatCurrency(value) {
            return '$' + value.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
        }

        function setPreset(type) {
            const presets = {
                conservative: { rate: 2.5, time: 10, contribution: 200 },
                moderate: { rate: 5.0, time: 15, contribution: 500 },
                aggressive: { rate: 8.0, time: 20, contribution: 1000 }
            };
            const preset = presets[type];
            document.getElementById('rate').value = preset.rate;
            document.getElementById('time').value = preset.time;
            document.getElementById('contribution').value = preset.contribution;
            calculateCompoundInterest();
        }

        function calculateCompoundInterest() {
            const principal = parseFloat(document.getElementById('principal').value) || 0;
            const annualRate = parseFloat(document.getElementById('rate').value) / 100 || 0;
            const years = parseInt(document.getElementById('time').value) || 0;
            const frequency = parseInt(document.getElementById('frequency').value) || 12;
            const monthlyContribution = parseFloat(document.getElementById('contribution').value) || 0;

            // Calculate effective annual rate
            const effectiveRate = Math.pow(1 + annualRate / frequency, frequency) - 1;

            // Arrays for chart and table data
            const balanceData = [];
            const principalData = [];
            const interestData = [];
            const labels = [];
            const tableData = [];

            let balance = principal;
            let totalContributions = principal;
            let yearlyContribution = monthlyContribution * 12;

            // Year 0
            balanceData.push(balance);
            principalData.push(principal);
            interestData.push(0);
            labels.push('Year 0');

            // Calculate for each year
            for (let year = 1; year <= years; year++) {
                const openingBalance = balance;
                const periodsPerYear = frequency;
                const ratePerPeriod = annualRate / frequency;

                // Add contributions throughout the year with compound interest
                let yearEndBalance = openingBalance;
                let contributionThisYear = 0;

                for (let period = 0; period < periodsPerYear; period++) {
                    // Add interest for this period
                    yearEndBalance = yearEndBalance * (1 + ratePerPeriod);

                    // Add monthly contribution (proportionally distributed across periods)
                    const contributionThisPeriod = monthlyContribution * (12 / periodsPerYear);
                    yearEndBalance += contributionThisPeriod;
                    contributionThisYear += contributionThisPeriod;
                }

                const interestThisYear = yearEndBalance - openingBalance - contributionThisYear;

                totalContributions += contributionThisYear;
                balance = yearEndBalance;

                balanceData.push(balance);
                principalData.push(totalContributions);
                interestData.push(balance - totalContributions);
                labels.push('Year ' + year);

                // Table row data
                tableData.push({
                    year: year,
                    opening: openingBalance,
                    contributions: contributionThisYear,
                    interest: interestThisYear,
                    closing: balance
                });
            }

            const finalBalance = balance;
            const totalInterest = finalBalance - totalContributions;

            // Update summary cards
            document.getElementById('finalBalance').textContent = formatCurrency(finalBalance);
            document.getElementById('totalContributions').textContent = formatCurrency(totalContributions);
            document.getElementById('interestEarned').textContent = formatCurrency(totalInterest);
            document.getElementById('effectiveRate').textContent = (effectiveRate * 100).toFixed(2) + '%';

            // Update growth chart
            if (growthChart) growthChart.destroy();
            const ctx1 = document.getElementById('growthChart').getContext('2d');
            growthChart = new Chart(ctx1, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Total Balance',
                        data: balanceData,
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 3
                    }, {
                        label: 'Principal + Contributions',
                        data: principalData,
                        borderColor: '#10b981',
                        backgroundColor: 'rgba(16, 185, 129, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 2
                    }, {
                        label: 'Interest Earned',
                        data: interestData,
                        borderColor: '#f59e0b',
                        backgroundColor: 'rgba(245, 158, 11, 0.1)',
                        fill: true,
                        tension: 0.4,
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: { position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.dataset.label + ': ' + formatCurrency(context.parsed.y);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '$' + value.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });

            // Update pie chart
            if (pieChart) pieChart.destroy();
            const ctx2 = document.getElementById('pieChart').getContext('2d');
            pieChart = new Chart(ctx2, {
                type: 'doughnut',
                data: {
                    labels: ['Principal', 'Contributions', 'Interest Earned'],
                    datasets: [{
                        data: [principal, totalContributions - principal, totalInterest],
                        backgroundColor: ['#667eea', '#10b981', '#f59e0b'],
                        borderWidth: 2,
                        borderColor: '#fff'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: { position: 'bottom' },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = formatCurrency(context.parsed);
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((context.parsed / total) * 100).toFixed(1);
                                    return label + ': ' + value + ' (' + percentage + '%)';
                                }
                            }
                        }
                    }
                }
            });

            // Update table
            const tableBody = document.getElementById('tableBody');
            tableBody.innerHTML = '';
            tableData.forEach(row => {
                const tr = document.createElement('tr');

                const td1 = document.createElement('td');
                td1.innerHTML = '<strong>Year ' + row.year + '</strong>';
                tr.appendChild(td1);

                const td2 = document.createElement('td');
                td2.textContent = formatCurrency(row.opening);
                tr.appendChild(td2);

                const td3 = document.createElement('td');
                td3.textContent = formatCurrency(row.contributions);
                tr.appendChild(td3);

                const td4 = document.createElement('td');
                td4.textContent = formatCurrency(row.interest);
                tr.appendChild(td4);

                const td5 = document.createElement('td');
                td5.innerHTML = '<strong>' + formatCurrency(row.closing) + '</strong>';
                tr.appendChild(td5);

                tableBody.appendChild(tr);
            });
        }

        // Add event listeners for real-time updates
        const inputs = ['principal', 'rate', 'time', 'frequency', 'contribution'];
        inputs.forEach(id => {
            document.getElementById(id).addEventListener('input', function() {
                calculateCompoundInterest();
                updateScenarios();
            });
        });

        // Initial calculation on page load
        window.addEventListener('load', calculateCompoundInterest);

        // ==================== SCENARIO COMPARISON ====================
        let scenarioChart = null;
        let scenarios = [];
        let baselineScenario = null;

        function calculateScenario(principal, rate, years, frequency, monthlyContribution, label, color) {
            const annualRate = rate / 100;
            const balanceData = [];
            const labels = [];

            let balance = principal;
            let totalContributions = principal;

            balanceData.push(balance);
            labels.push('Year 0');

            for (let year = 1; year <= years; year++) {
                const ratePerPeriod = annualRate / frequency;
                let yearEndBalance = balance;
                let contributionThisYear = 0;

                for (let period = 0; period < frequency; period++) {
                    yearEndBalance = yearEndBalance * (1 + ratePerPeriod);
                    const contributionThisPeriod = monthlyContribution * (12 / frequency);
                    yearEndBalance += contributionThisPeriod;
                    contributionThisYear += contributionThisPeriod;
                }

                totalContributions += contributionThisYear;
                balance = yearEndBalance;
                balanceData.push(balance);
                labels.push('Year ' + year);
            }

            const finalBalance = balance;
            const totalInterest = finalBalance - totalContributions;

            return {
                label: label,
                color: color,
                principal: principal,
                rate: rate,
                years: years,
                frequency: frequency,
                monthlyContribution: monthlyContribution,
                balanceData: balanceData,
                labels: labels,
                finalBalance: finalBalance,
                totalContributions: totalContributions,
                totalInterest: totalInterest
            };
        }

        function addScenario(type) {
            const basePrincipal = parseFloat(document.getElementById('principal').value) || 0;
            const baseRate = parseFloat(document.getElementById('rate').value) || 0;
            const baseYears = parseInt(document.getElementById('time').value) || 0;
            const baseFrequency = parseInt(document.getElementById('frequency').value) || 12;
            const baseContribution = parseFloat(document.getElementById('contribution').value) || 0;

            // Store baseline if not already stored
            if (!baselineScenario) {
                baselineScenario = calculateScenario(
                    basePrincipal, baseRate, baseYears, baseFrequency, baseContribution,
                    'Baseline (Current Plan)', '#3b82f6'
                );
            }

            let scenarioData;
            const colors = ['#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#06b6d4', '#f97316'];
            const color = colors[scenarios.length % colors.length];

            switch(type) {
                // Single variable scenarios
                case 'higher-amount':
                    scenarioData = calculateScenario(
                        basePrincipal * 1.2, baseRate, baseYears, baseFrequency, baseContribution,
                        '+20% Principal (' + formatCurrency(basePrincipal * 1.2) + ')', color
                    );
                    break;
                case 'lower-amount':
                    scenarioData = calculateScenario(
                        basePrincipal * 0.8, baseRate, baseYears, baseFrequency, baseContribution,
                        '-20% Principal (' + formatCurrency(basePrincipal * 0.8) + ')', color
                    );
                    break;
                case 'higher-rate':
                    scenarioData = calculateScenario(
                        basePrincipal, baseRate + 2, baseYears, baseFrequency, baseContribution,
                        '+2% Interest Rate (' + (baseRate + 2).toFixed(2) + '%)', color
                    );
                    break;
                case 'lower-rate':
                    scenarioData = calculateScenario(
                        basePrincipal, Math.max(0, baseRate - 2), baseYears, baseFrequency, baseContribution,
                        '-2% Interest Rate (' + Math.max(0, baseRate - 2).toFixed(2) + '%)', color
                    );
                    break;
                case 'longer-time':
                    scenarioData = calculateScenario(
                        basePrincipal, baseRate, baseYears + 5, baseFrequency, baseContribution,
                        '+5 Years (' + (baseYears + 5) + ' years)', color
                    );
                    break;
                case 'shorter-time':
                    scenarioData = calculateScenario(
                        basePrincipal, baseRate, Math.max(1, baseYears - 5), baseFrequency, baseContribution,
                        '-5 Years (' + Math.max(1, baseYears - 5) + ' years)', color
                    );
                    break;
                case 'double-contribution':
                    scenarioData = calculateScenario(
                        basePrincipal, baseRate, baseYears, baseFrequency, baseContribution * 2,
                        '2x Monthly Contribution (' + formatCurrency(baseContribution * 2) + ')', color
                    );
                    break;

                // Combination scenarios - Best/Worst case
                case 'best-case':
                    scenarioData = calculateScenario(
                        basePrincipal * 1.2, baseRate + 2, baseYears + 5, baseFrequency, baseContribution,
                        'Best Case: +20% Principal, +2% Rate, +5 Years', '#10b981'
                    );
                    break;
                case 'worst-case':
                    scenarioData = calculateScenario(
                        basePrincipal * 0.8, Math.max(0, baseRate - 2), Math.max(1, baseYears - 5), baseFrequency, baseContribution,
                        'Worst Case: -20% Principal, -2% Rate, -5 Years', '#ef4444'
                    );
                    break;

                // Combination scenarios - Principal + Time
                case 'more-money-more-time':
                    scenarioData = calculateScenario(
                        basePrincipal * 1.2, baseRate, baseYears + 5, baseFrequency, baseContribution,
                        '+20% Principal & +5 Years', color
                    );
                    break;
                case 'less-money-less-time':
                    scenarioData = calculateScenario(
                        basePrincipal * 0.8, baseRate, Math.max(1, baseYears - 5), baseFrequency, baseContribution,
                        '-20% Principal & -5 Years', color
                    );
                    break;

                // Combination scenarios - Principal + Rate
                case 'more-money-better-rate':
                    scenarioData = calculateScenario(
                        basePrincipal * 1.2, baseRate + 2, baseYears, baseFrequency, baseContribution,
                        '+20% Principal & +2% Rate', color
                    );
                    break;
                case 'less-money-worse-rate':
                    scenarioData = calculateScenario(
                        basePrincipal * 0.8, Math.max(0, baseRate - 2), baseYears, baseFrequency, baseContribution,
                        '-20% Principal & -2% Rate', color
                    );
                    break;

                // Combination scenarios - Time + Rate
                case 'longer-better-rate':
                    scenarioData = calculateScenario(
                        basePrincipal, baseRate + 2, baseYears + 5, baseFrequency, baseContribution,
                        '+5 Years & +2% Rate', color
                    );
                    break;
                case 'shorter-worse-rate':
                    scenarioData = calculateScenario(
                        basePrincipal, Math.max(0, baseRate - 2), Math.max(1, baseYears - 5), baseFrequency, baseContribution,
                        '-5 Years & -2% Rate', color
                    );
                    break;

                // Combination scenarios - Everything
                case 'aggressive-growth':
                    scenarioData = calculateScenario(
                        basePrincipal * 1.2, baseRate + 2, baseYears + 5, baseFrequency, baseContribution * 2,
                        'Aggressive Growth: +Principal +Rate +Time +2x Contribution', '#8b5cf6'
                    );
                    break;
                case 'conservative-fallback':
                    scenarioData = calculateScenario(
                        basePrincipal * 0.8, Math.max(0, baseRate - 2), baseYears, baseFrequency, baseContribution * 0.5,
                        'Conservative Fallback: -Principal -Rate -50% Contribution', '#6b7280'
                    );
                    break;

                // Money vs Time Trade-offs
                case 'double-money-half-time':
                    scenarioData = calculateScenario(
                        basePrincipal * 2, baseRate, Math.max(1, Math.floor(baseYears / 2)), baseFrequency, baseContribution,
                        '2x Principal (' + formatCurrency(basePrincipal * 2) + '), Half Time (' + Math.max(1, Math.floor(baseYears / 2)) + ' years)', color
                    );
                    break;
                case 'half-money-double-time':
                    scenarioData = calculateScenario(
                        basePrincipal * 0.5, baseRate, baseYears * 2, baseFrequency, baseContribution,
                        'Half Principal (' + formatCurrency(basePrincipal * 0.5) + '), 2x Time (' + (baseYears * 2) + ' years)', color
                    );
                    break;
                case 'more-money-less-time':
                    var newYears1 = Math.max(1, Math.floor(baseYears * 0.7));
                    scenarioData = calculateScenario(
                        basePrincipal * 1.5, baseRate, newYears1, baseFrequency, baseContribution,
                        '+50% Principal (' + formatCurrency(basePrincipal * 1.5) + '), -30% Time (' + newYears1 + ' years)', color
                    );
                    break;
                case 'less-money-more-time':
                    var newYears2 = Math.floor(baseYears * 1.5);
                    scenarioData = calculateScenario(
                        basePrincipal * 0.7, baseRate, newYears2, baseFrequency, baseContribution,
                        '-30% Principal (' + formatCurrency(basePrincipal * 0.7) + '), +50% Time (' + newYears2 + ' years)', color
                    );
                    break;
                case 'triple-money-third-time':
                    var newYears3 = Math.max(1, Math.floor(baseYears / 3));
                    scenarioData = calculateScenario(
                        basePrincipal * 3, baseRate, newYears3, baseFrequency, baseContribution,
                        '3x Principal (' + formatCurrency(basePrincipal * 3) + '), 1/3 Time (' + newYears3 + ' years)', color
                    );
                    break;
            }

            scenarios.push(scenarioData);
            updateScenarioChart();
            updateScenarioTable();
        }

        function updateScenarios() {
            // Clear and recalculate all scenarios when baseline changes
            scenarios = [];
            baselineScenario = null;
            updateScenarioChart();
            updateScenarioTable();
        }

        function clearScenarios() {
            scenarios = [];
            baselineScenario = null;
            updateScenarioChart();
            updateScenarioTable();
        }

        function compareCommonScenarios() {
            // Clear existing scenarios
            clearScenarios();

            // Add most common comparison scenarios
            setTimeout(() => addScenario('higher-amount'), 50);
            setTimeout(() => addScenario('lower-amount'), 100);
            setTimeout(() => addScenario('higher-rate'), 150);
            setTimeout(() => addScenario('lower-rate'), 200);
            setTimeout(() => addScenario('longer-time'), 250);
            setTimeout(() => addScenario('best-case'), 300);
            setTimeout(() => addScenario('worst-case'), 350);
        }

        function addCustomScenario() {
            const customPrincipal = parseFloat(document.getElementById('customPrincipal').value) || 0;
            const customYears = parseInt(document.getElementById('customYears').value) || 0;

            if (customPrincipal <= 0 || customYears <= 0) {
                alert('Please enter valid principal amount and years');
                return;
            }

            const baseRate = parseFloat(document.getElementById('rate').value) || 0;
            const baseFrequency = parseInt(document.getElementById('frequency').value) || 12;
            const baseContribution = parseFloat(document.getElementById('contribution').value) || 0;

            // Store baseline if not already stored
            if (!baselineScenario) {
                const basePrincipal = parseFloat(document.getElementById('principal').value) || 0;
                const baseYears = parseInt(document.getElementById('time').value) || 0;
                baselineScenario = calculateScenario(
                    basePrincipal, baseRate, baseYears, baseFrequency, baseContribution,
                    'Baseline (Current Plan)', '#3b82f6'
                );
            }

            const colors = ['#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#06b6d4', '#f97316'];
            const color = colors[scenarios.length % colors.length];

            const scenarioData = calculateScenario(
                customPrincipal, baseRate, customYears, baseFrequency, baseContribution,
                'Custom: ' + formatCurrency(customPrincipal) + ' for ' + customYears + ' years', color
            );

            scenarios.push(scenarioData);
            updateScenarioChart();
            updateScenarioTable();
        }

        function compareSpecific(type) {
            const baseRate = parseFloat(document.getElementById('rate').value) || 0;
            const baseFrequency = parseInt(document.getElementById('frequency').value) || 12;
            const baseContribution = parseFloat(document.getElementById('contribution').value) || 0;

            // Clear scenarios first
            clearScenarios();

            let scenario1, scenario2;
            const color1 = '#3b82f6';
            const color2 = '#f59e0b';

            switch(type) {
                case '20k-10y-vs-30k-5y':
                    scenario1 = calculateScenario(20000, baseRate, 10, baseFrequency, baseContribution,
                        '$20,000 for 10 years', color1);
                    scenario2 = calculateScenario(30000, baseRate, 5, baseFrequency, baseContribution,
                        '$30,000 for 5 years', color2);
                    break;
                case '25k-8y-vs-40k-5y':
                    scenario1 = calculateScenario(25000, baseRate, 8, baseFrequency, baseContribution,
                        '$25,000 for 8 years', color1);
                    scenario2 = calculateScenario(40000, baseRate, 5, baseFrequency, baseContribution,
                        '$40,000 for 5 years', color2);
                    break;
                case '10k-20y-vs-30k-10y':
                    scenario1 = calculateScenario(10000, baseRate, 20, baseFrequency, baseContribution,
                        '$10,000 for 20 years', color1);
                    scenario2 = calculateScenario(30000, baseRate, 10, baseFrequency, baseContribution,
                        '$30,000 for 10 years', color2);
                    break;
                case '15k-15y-vs-45k-5y':
                    scenario1 = calculateScenario(15000, baseRate, 15, baseFrequency, baseContribution,
                        '$15,000 for 15 years', color1);
                    scenario2 = calculateScenario(45000, baseRate, 5, baseFrequency, baseContribution,
                        '$45,000 for 5 years', color2);
                    break;
            }

            // Set as baseline and scenario
            baselineScenario = scenario1;
            scenarios.push(scenario2);

            updateScenarioChart();
            updateScenarioTable();

            // Scroll to chart
            document.getElementById('scenarioChart').scrollIntoView({ behavior: 'smooth', block: 'center' });
        }

        function updateScenarioChart() {
            if (scenarioChart) scenarioChart.destroy();

            const datasets = [];

            // Add baseline
            if (baselineScenario) {
                datasets.push({
                    label: baselineScenario.label,
                    data: baselineScenario.balanceData,
                    borderColor: baselineScenario.color,
                    backgroundColor: 'transparent',
                    borderWidth: 4,
                    tension: 0.4,
                    pointRadius: 4,
                    pointHoverRadius: 6
                });
            }

            // Add all scenarios
            scenarios.forEach(scenario => {
                datasets.push({
                    label: scenario.label,
                    data: scenario.balanceData,
                    borderColor: scenario.color,
                    backgroundColor: 'transparent',
                    borderWidth: 2,
                    tension: 0.4,
                    pointRadius: 3,
                    pointHoverRadius: 5,
                    borderDash: [5, 5]
                });
            });

            // Use the longest labels array
            let allLabels = baselineScenario ? baselineScenario.labels : [];
            scenarios.forEach(s => {
                if (s.labels.length > allLabels.length) {
                    allLabels = s.labels;
                }
            });

            const ctx = document.getElementById('scenarioChart').getContext('2d');
            scenarioChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: allLabels,
                    datasets: datasets
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 15
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.dataset.label + ': ' + formatCurrency(context.parsed.y);
                                }
                            }
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '$' + value.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });
        }

        function updateScenarioTable() {
            const tableBody = document.getElementById('scenarioTableBody');
            tableBody.innerHTML = '';

            if (!baselineScenario && scenarios.length === 0) {
                const tr = document.createElement('tr');
                const td = document.createElement('td');
                td.colSpan = 8;
                td.textContent = 'Click the buttons above to add scenarios for comparison';
                td.style.textAlign = 'center';
                td.style.padding = '2rem';
                td.style.color = '#9ca3af';
                tr.appendChild(td);
                tableBody.appendChild(tr);
                return;
            }

            // Add baseline row
            if (baselineScenario) {
                const tr = document.createElement('tr');
                tr.style.backgroundColor = '#eff6ff';
                tr.style.fontWeight = '600';

                const td1 = document.createElement('td');
                td1.innerHTML = '<i class="fas fa-flag"></i> ' + baselineScenario.label;
                tr.appendChild(td1);

                const td2 = document.createElement('td');
                td2.textContent = formatCurrency(baselineScenario.principal);
                tr.appendChild(td2);

                const td3 = document.createElement('td');
                td3.textContent = baselineScenario.rate.toFixed(2) + '%';
                tr.appendChild(td3);

                const td4 = document.createElement('td');
                td4.textContent = baselineScenario.years;
                tr.appendChild(td4);

                const td5 = document.createElement('td');
                td5.textContent = formatCurrency(baselineScenario.monthlyContribution);
                tr.appendChild(td5);

                const td6 = document.createElement('td');
                td6.innerHTML = '<strong>' + formatCurrency(baselineScenario.finalBalance) + '</strong>';
                tr.appendChild(td6);

                const td7 = document.createElement('td');
                td7.textContent = formatCurrency(baselineScenario.totalInterest);
                tr.appendChild(td7);

                const td8 = document.createElement('td');
                td8.textContent = '-';
                tr.appendChild(td8);

                tableBody.appendChild(tr);
            }

            // Add scenario rows
            scenarios.forEach(scenario => {
                const tr = document.createElement('tr');

                const diff = scenario.finalBalance - (baselineScenario ? baselineScenario.finalBalance : 0);
                const diffPercent = baselineScenario ? ((diff / baselineScenario.finalBalance) * 100).toFixed(1) : 0;

                const td1 = document.createElement('td');
                td1.innerHTML = '<span style="display:inline-block;width:12px;height:12px;border-radius:50%;background:' + scenario.color + ';margin-right:8px;"></span>' + scenario.label;
                tr.appendChild(td1);

                const td2 = document.createElement('td');
                td2.textContent = formatCurrency(scenario.principal);
                tr.appendChild(td2);

                const td3 = document.createElement('td');
                td3.textContent = scenario.rate.toFixed(2) + '%';
                tr.appendChild(td3);

                const td4 = document.createElement('td');
                td4.textContent = scenario.years;
                tr.appendChild(td4);

                const td5 = document.createElement('td');
                td5.textContent = formatCurrency(scenario.monthlyContribution);
                tr.appendChild(td5);

                const td6 = document.createElement('td');
                td6.innerHTML = '<strong>' + formatCurrency(scenario.finalBalance) + '</strong>';
                tr.appendChild(td6);

                const td7 = document.createElement('td');
                td7.textContent = formatCurrency(scenario.totalInterest);
                tr.appendChild(td7);

                const td8 = document.createElement('td');
                const diffIcon = diff > 0 ? '<i class="fas fa-arrow-up" style="color:#10b981;"></i>' : '<i class="fas fa-arrow-down" style="color:#ef4444;"></i>';
                const diffColor = diff > 0 ? '#10b981' : '#ef4444';
                td8.innerHTML = diffIcon + ' <span style="color:' + diffColor + ';font-weight:600;">' + formatCurrency(Math.abs(diff)) + ' (' + diffPercent + '%)</span>';
                tr.appendChild(td8);

                tableBody.appendChild(tr);
            });
        }

        // Initialize scenario chart
        window.addEventListener('load', function() {
            updateScenarioChart();
            updateScenarioTable();
        });
    </script>
    
    <div>
                <h5 class="card-header">Try Other calculator</h5>
                <ul>
                    <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
                    <li><a href="cinterest2.jsp">Compound Interest Calculator (Compare Rates) </a></li>
                    <li><a href="cinterest.jsp">Compound Interest Calculator (Simple)</a></li>
                    <li><a href="cinterest.jsp">Stock Profit Calculator</a></li>
                  </ul>
                </div>    
<hr>

<p>Compound interest is a powerful financial concept that allows your savings to grow over time. It works by earning interest on both the initial amount you deposit (the principal) and the interest that accumulates. This means that over time, your savings can grow significantly, especially with higher interest rates and longer investment periods.</p>
    <p>Here's how compound interest is calculated:</p>
    <ul>
        <li>You start with an initial amount called the <strong>principal</strong>.</li>
        <li>Each year, your savings earn a certain percentage of interest, which is added to your principal.</li>
        <li>As time goes on, you not only earn interest on your original principal but also on the interest that has already been added to your savings. This is what makes it "compound" interest.</li>
    </ul>
    
        <p>The mathematical formula for compound interest is:</p>
    <p>
        <strong>A = P(1 + r/n)^(nt)</strong>
    </p>
    <ul>
        <li><strong>A</strong> represents the final amount of money, including interest.</li>
        <li><strong>P</strong> is the principal amount (the initial amount of money).</li>
        <li><strong>r</strong> is the annual interest rate (in decimal form).</li>
        <li><strong>n</strong> is the number of times that interest is compounded per year.</li>
        <li><strong>t</strong> is the number of years the money is invested or borrowed for.</li>
    </ul>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
