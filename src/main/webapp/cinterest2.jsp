<!--  -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compound Interest Calculator with Multiple Rates</title>
    <!-- Include Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta name="description" content="Calculate compound interest and compare different interest rates with this free online compound interest calculator. Visualize your savings growth with interactive graphs.">
    <!-- Meta Keywords -->
    <meta name="keywords" content="compound interest calculator, interest rate calculator, savings calculator, finance calculator, financial planning, interest rate comparison, investment calculator">
    
    <%@ include file="header-script.jsp"%>
    
    <script type="application/ld+json">
{
    "@context": "http://schema.org",
    "@type": "WebPage",
    "name": "Compound Interest Calculator with Multiple Rates",
    "description": "Calculate compound interest and compare different interest rates with this free online compound interest calculator. Visualize your savings growth with interactive graphs.",
    "keywords": "compound interest calculator, interest rate calculator, savings calculator, finance calculator, financial planning, interest rate comparison, investment calculator",
    "url": "https://your-website.com/compound-interest-calculator-multiple-rates",
    "breadcrumb": {
        "@type": "BreadcrumbList",
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
                "name": "Compound Interest Calculator with Multiple Rates",
                "item": "https://8gwifi.org/cinterest2.jsp"
            }
        ]
    }
}
</script>
    
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mt-4">Compound Interest Calculator with Multiple Rates</h1>
    <div>
        <label for="principal">Principal Amount:</label>
        <input type="number" class="form-control" id="principal" value=50000 placeholder="Enter principal amount">
    </div>
    <div>
        <label for="rates">Annual Interest Rates (%):  </label>
        <input type="text" class="form-control" id="rates" value=2,3,4 placeholder="Enter interest rates separated by commas (e.g., 5, 6, 7)">
        <small> Comma separated list of rates e.g 1,7.4,6 </small>
    </div>
    <div>
        <label for="time">Time (years):</label>
        <input type="number" class="form-control" id="time" value=10 placeholder="Enter time in years">
    </div>
    <div>
        <h2>Profit Loss:</h2>
        <ul id="resultsList"></ul>
    </div>
    <div>
        <button class="btn btn-primary" onclick="calculateCompoundInterest()">Calculate</button>
    </div>
    <div>
        <canvas id="interestChart"></canvas>
    </div>
    <script>
        let chartInstance = null; // Variable to store the chart instance

        function calculateCompoundInterest() {
            const principal = parseFloat(document.getElementById('principal').value);
            const rateInput = document.getElementById('rates').value;
            const rates = rateInput.split(',').map(rate => parseFloat(rate.trim()) / 100);
            const time = parseFloat(document.getElementById('time').value);

            const resultsList = document.getElementById('resultsList');
            resultsList.innerHTML = '';

            let chartData = []; // Define chartData here

            for (let i = 0; i < rates.length; i++) {
                const rate = rates[i];
                const data = []; // Define data for each rate
                let balance = principal;
                let totalGain = 0;

                for (let year = 0; year <= time; year++) {
                    const interest = balance * rate;
                    balance += interest;
                    data.push(balance.toFixed(2));
                    totalGain += interest;
                }

                // Calculate r (interest rate in percentage) and v (final balance)
                const r = rate * 100;
                const v = data[data.length - 1];

                // Add result to the list
                const listItem = document.createElement('li');
                /* listItem.textContent = `Rate: ${r.toFixed(2)}%, Final Balance: $${v}, Total Gain: $${totalGain.toFixed(2)}`; */
                listItem.textContent = "Rate: " + (rate * 100).toFixed(2) + "%, Final Balance: " + data[data.length - 1] + ", Profit/Loss: " +  totalGain.toFixed(2);
                resultsList.appendChild(listItem);

                // Collect data for the chart
                chartData.push({
                    label: "Rate: " + (rate * 100).toFixed(2),
                    data: data,
                    borderColor: getRandomColor(),
                    borderWidth: 2,
                    fill: false
                });
            }

            // Destroy the existing chart if it exists
            if (chartInstance) {
                chartInstance.destroy();
            }

            // Create a new chart
            const ctx = document.getElementById('interestChart').getContext('2d');
            chartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: Array.from({ length: time + 1 }, (_, i) => i), // Use time + 1 as the length
                    datasets: chartData
                },
                options: {
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'Years'
                            }
                        },
                        y: {
                            title: {
                                display: true,
                                text: 'Balance'
                            }
                        }
                    }
                }
            });
        }

        // Helper function to generate random colors for chart lines
        function getRandomColor() {
            const letters = '0123456789ABCDEF';
            let color = '#';
            for (let i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        }
        
        document.getElementById('principal').addEventListener('input', calculateCompoundInterest);
        document.getElementById('rates').addEventListener('input', calculateCompoundInterest);
        document.getElementById('time').addEventListener('input', calculateCompoundInterest);

        // Initial chart rendering
        calculateCompoundInterest();
    </script>
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

