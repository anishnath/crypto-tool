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
</head>
<%@ include file="body-script.jsp"%>
    <div class="container mt-5">
        <h1 class="mb-4">SIP Calculator - Systematic Investment Plan</h1>
        <p>Plan your mutual fund investments and calculate expected returns from SIP investments.</p>

        <form id="sip-form">
            <div class="form-group">
                <label for="monthlyInvestment">Monthly Investment Amount:</label>
                <input type="number" value="5000" class="form-control" id="monthlyInvestment" required>
            </div>

            <div class="form-group">
                <label for="expectedReturn">Expected Annual Return Rate (%):</label>
                <input type="number" value="12" step="0.1" class="form-control" id="expectedReturn" required>
            </div>

            <div class="form-group">
                <label for="timePeriod">Investment Period (in years):</label>
                <input type="number" value="10" class="form-control" id="timePeriod" required>
            </div>

            <div class="form-group">
                <label for="stepUpPercentage">Annual Step-Up Percentage (Optional):</label>
                <input type="number" value="0" step="0.1" class="form-control" id="stepUpPercentage" placeholder="e.g., 10 for 10% yearly increase">
                <small class="form-text text-muted">Leave 0 for fixed monthly investment. Enter percentage to increase investment annually.</small>
            </div>
        </form>

        <div class="mt-4">
            <h4>Investment Summary</h4>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Total Investment:</strong> <span id="total-invested">0.00</span></p>
                    <p><strong>Expected Returns:</strong> <span id="total-returns">0.00</span></p>
                    <p><strong>Maturity Value:</strong> <span id="maturity-value" style="color: green; font-size: 1.5em; font-weight: bold;">0.00</span></p>
                </div>
                <div class="col-md-6">
                    <canvas id="pie-chart" width="400" height="400"></canvas>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <h4>Wealth Accumulation Over Time</h4>
            <canvas id="wealth-chart"></canvas>
        </div>

        <div class="mt-4">
            <h4>Year-wise Breakdown</h4>
            <div style="max-height: 400px; overflow-y: auto;">
                <table class="table table-striped">
                    <thead style="position: sticky; top: 0; background-color: white;">
                        <tr>
                            <th>Year</th>
                            <th>Investment This Year</th>
                            <th>Total Invested</th>
                            <th>Expected Returns</th>
                            <th>Total Value</th>
                        </tr>
                    </thead>
                    <tbody id="table-body">
                        <!-- Table data will be displayed here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        var pieChart = null;
        var wealthChart = null;

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
                    maintainAspectRatio: true,
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
        }

        // Attach event listeners for dynamic updates
        $("#monthlyInvestment, #expectedReturn, #timePeriod, #stepUpPercentage").on("input", calculateSIP);

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