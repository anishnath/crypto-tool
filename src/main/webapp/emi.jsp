<!DOCTYPE html>
<html>
<head>
    <title>Home loan EMI Calculator</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta name="keywords" content="EMI Calculator, Loan Calculator, Loan Analysis, Loan Breakdown">
    <meta name="description" content="Calculate your loan EMI, total interest payable, and loan breakdown using this EMI Calculator. Get insights into your loan repayment with charts and tables.">
    
    <script type="application/ld+json">
        {
            "@context": "http://schema.org",
            "@type": "FinancialProduct",
            "name": "Loan EMI Calculator",
            "description": "Calculate your loan EMI, total interest payable, and loan breakdown using this EMI Calculator.",
            "url": "https://8gwifi.org/emi.jsp",
			"author" : {
                "@type" : "Person",
                "name" : "Anish Nath"
            },
            "datePublished" : "2023-09-05",
            "interestRate": "9%",
            "currency": "USD"
        }
    </script>
    
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <div class="container mt-5">
        <h1 class="mb-4">Home loan EMI Calculator</h1>
        <form id="emi-form">
            <div class="form-group">
                <label for="principal">Principal Amount :</label>
                <input type="number" value="5000000" class="form-control" id="principal" required>
            </div>

            <div class="form-group">
                <label for="interest">Annual Interest Rate (%):</label>
                <input type="number" value="9" class="form-control" id="interest" required>
            </div>

            <div class="form-group">
                <label for="tenure">Loan Tenure (in months):</label>
                <input type="number" value="5" class="form-control" id="tenure" required>
            </div>
        </form>

        <div class="mt-4">
            <h4>Loan Summary</h4>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Loan EMI:</strong> <span id="emi-info"> 0.00 per month</span></p>
                    <p><strong>Total Interest Payable:</strong> <span id="total-interest-info"> 0.00</span></p>
                    <p><strong>Total Payment:</strong> <span id="total-payment-info">INR 0.00</span></p>
                </div>
                <div class="col-md-6">
                    <canvas id="pie-chart" width="400" height="400"></canvas>
                </div>
            </div>
        </div>

        <div class="mt-4">
            <h4>Loan Analysis</h4>
            <canvas id="stacked-chart"></canvas>
        </div>

        <div class="mt-4">
            <h4>Loan Breakdown</h4>
            <table class="table">
                <thead>
                    <tr>
                        <th>Month</th>
                        <th>EMI</th>
                        <th>Interest Paid</th>
                        <th>Principal Paid</th>
                        <th>Remaining Principal</th>
                    </tr>
                </thead>
                <tbody id="table-body">
                    <!-- Table data will be displayed here -->
                </tbody>
            </table>
        </div>
        

    </div>

    <script>
        var pieChart = null; // Initialize pieChart variable
        var stackedChart = null; // Initialize stackedChart variable

        function calculateEMI() {
            var principal = parseFloat($("#principal").val());
            var interestRate = parseFloat($("#interest").val()) / 100 / 12; // Monthly interest rate
            var tenureMonths = parseFloat($("#tenure").val());
            var emi, totalInterestPaid, monthlyInterest, monthlyPrincipal, remainingPrincipal;
            var emiData = [];
            var interestData = [];
            var principalData = [];
            var balanceData = [];

            // EMI Calculation Formula
            emi = principal * interestRate * Math.pow(1 + interestRate, tenureMonths) / (Math.pow(1 + interestRate, tenureMonths) - 1);

            remainingPrincipal = principal; // Initialize remainingPrincipal

            for (var i = 1; i <= tenureMonths; i++) {
                monthlyInterest = remainingPrincipal * interestRate;
                monthlyPrincipal = emi - monthlyInterest;
                remainingPrincipal -= monthlyPrincipal;
                emiData.push(emi.toFixed(2));
                interestData.push(monthlyInterest.toFixed(2));
                principalData.push(monthlyPrincipal.toFixed(2));
                balanceData.push(remainingPrincipal.toFixed(2));
            }

            

            totalInterestPaid = (emi * tenureMonths) - principal;
            var totalPayment = principal + totalInterestPaid;

            // Display the EMI, Total Interest Payable, and Total Payment
            $("#emi-info").text(" " + emi.toFixed(2) + " per month");
            $("#total-interest-info").text(" " + totalInterestPaid.toFixed(2));
            $("#total-payment-info").text(" " + totalPayment.toFixed(2));

            // Update the table for the loan breakdown
            var tableHTML = "";
            remainingPrincipal = principal; // Initialize remainingPrincipal

            for (var i = 1; i <= tenureMonths; i++) {
                monthlyInterest = remainingPrincipal * interestRate;
                monthlyPrincipal = emi - monthlyInterest;
                remainingPrincipal -= monthlyPrincipal; // Update remainingPrincipal

                tableHTML += "<tr><td>" + i + "</td><td> " + emi.toFixed(2) + "</td><td> " + monthlyInterest.toFixed(2) + "</td><td> " + monthlyPrincipal.toFixed(2) + "</td><td> " + remainingPrincipal.toFixed(2) + "</td></tr>";
            }

            // Update the table body
            $("#table-body").html(tableHTML);

            // Destroy the previous pie chart if it exists
            if (pieChart) {
                pieChart.destroy();
            }

            // Create a new pie chart
            var ctx = document.getElementById('pie-chart').getContext('2d');
            pieChart = new Chart(ctx, {
                type: 'pie',
                data: {
                    labels: ['Principal Loan Amount', 'Total Interest'],
                    datasets: [{
                        data: [principal, totalInterestPaid],
                        backgroundColor: ['blue', 'red'],
                    }],
                },
            });

            // Destroy the previous stacked chart if it exists
            if (stackedChart) {
                stackedChart.destroy();
            }

            // Create a new stacked chart
            var ctxStacked = document.getElementById('stacked-chart').getContext('2d');

        

            stackedChart = new Chart(ctxStacked, {
                type: 'bar',
                data: {
                    labels: Array.from({ length: tenureMonths }, (_, i) => i + 1),
                    datasets: [
                        {
                            label: 'Principal',
                            data: principalData,
                            backgroundColor: 'blue',
                        },
                        {
                            label: 'Interest',
                            data: interestData,
                            backgroundColor: 'red',
                        },
                        // {
                        //     label: 'Balance',
                        //     data: balanceData,
                        //     type: 'line',
                        //     borderColor: 'green',
                        //     fill: false,
                        // },
                    ],
                },
                options: {
                    scales: {
                        x: {
                            stacked: true,
                        },
                        y: {
                            stacked: true,
                        },
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                    },
                },
            });
        }

        // Attach event listeners to input fields for dynamic updates
        $("#principal, #interest, #tenure").on("input", calculateEMI);

        // Initial calculation when the page loads
        calculateEMI();
    </script>
    
    <div>
                <h5 class="card-header">Try Other calculator</h5>
                <ul>
                    <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
                    <li><a href="cinterest2.jsp">Compound Interest Calculator (Compare Rates) </a></li>
                    <li><a href="cinterest.jsp">Compound Interest Calculator (Simple)</a></li>
                    <li><a href="stock-calc.jsp">Stock Profit Calculator</a></li>
                  </ul>
                </div>    
    
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<div>
        <h1>Understanding EMI (Equated Monthly Installment)</h1>
        <p>EMI, or Equated Monthly Installment, is a fixed amount of money that you pay each month towards the repayment of a loan. It includes both the principal amount and the interest on the loan.</p>
        
        <h2>EMI Calculation Formula</h2>
        <p>The formula to calculate EMI is:</p>
        <p style="font-weight: bold;">EMI = [P x R x (1+R)^N] / [(1+R)^N - 1]</p>
        <p>Where:</p>
        <ul>
            <li><strong>EMI</strong> is the Equated Monthly Installment.</li>
            <li><strong>P</strong> is the principal loan amount (the initial loan amount you borrowed).</li>
            <li><strong>R</strong> is the monthly interest rate (annual interest rate divided by 12 months).</li>
            <li><strong>N</strong> is the loan tenure in months (the number of months over which you will repay the loan).</li>
        </ul>
        
        <h2>Example</h2>
        <p>Let's say you borrowed INR 50,000 as a personal loan with an annual interest rate of 9% for a tenure of 24 months (2 years).</p>
        <p>Using the EMI formula:</p>
        <p>EMI = [50,000 x (0.09/12) x (1+0.09/12)^24] / [(1+0.09/12)^24 - 1]</p>
        <p>EMI ≈ INR 2,261.82 per month</p>
        <p>So, your Equated Monthly Installment (EMI) would be approximately INR 2,261.82.</p>
        
        <p>EMI makes it easier to manage your loan repayments as it ensures a consistent monthly payment, which includes both the principal and interest components.</p>
    </div>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
