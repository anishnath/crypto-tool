<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Profit Calculator</title>
    <meta name="description" content="Calculate the profit or loss on your stock investment.">
    <meta name="keywords" content="stock profit calculator, investment calculator, stock market, financial calculator">
    <!-- Add Bootstrap CSS -->

    <script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "WebPage",
  "name": "Stock Profit Calculator",
  "description": "Stock Profit Calculator helps traders and investors calculate their profit for each trade. Whether you're a professional trader or a total newbie in the stock market, this stock calculator will surely come in handy.",
  "url": "https://8gwifi.org/stock-calc.jsp",
  "about": {
    "@type": "WebPage",
    "name": "Share Market Profit Calculator",
    "description": "Share Market Profit Calculator is a tool to measure the total profit or loss obtained in your financial transactions. Stock profit refers to the profit earned when the selling price is higher than the broker's commission and the purchase price."
  }
}
</script>

<%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <div class="container">
        <h1 class="mt-4">Stock Profit Calculator</h1>
        <p>Calculate the profit or loss on your stock investment.</p>

        <div class="form-group">
            <label for="purchasePrice">Purchase Price (comma-separated values):</label>
            <input type="text" class="form-control" id="purchasePrice" value="100,110,120" placeholder="Enter purchase prices">
        </div>
        <div class="form-group">
            <label for="salePrice">Sale Price (comma-separated values):</label>
            <input type="text" class="form-control" id="salePrice" value="90,130,110" placeholder="Enter sale prices">
        </div>
        <div class="form-group">
            <label for="shares">Number of Shares (comma-separated values):</label>
            <input type="text" class="form-control" id="shares" value="10,15,10" placeholder="Enter shares">
        </div>
        <div class="form-group">
            <button class="btn btn-primary" id="calculateButton">Calculate</button>
        </div>

        <div class="mt-4">
            <h2>Results</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Stocks</th>
                        <th>Shares</th>
                        <th>Purchase Price</th>
                        <th>Total Invested</th>
                        <th>Sale Price</th>
                        <th>Profit/Loss</th>
                    </tr>
                </thead>
                <tbody id="resultsTable">
                    <!-- Table data will be displayed here -->
                </tbody>
            </table>
        </div>

        <div class="mt-4">
            <h2>Total Profit/Loss</h2>
            <p id="totalProfitLoss">$0.00</p>
        </div>

        <div class="mt-4">
            <h2>Chart</h2>
            <canvas id="profitChart"></canvas>
        </div>
    </div>

    <!-- Add Bootstrap JS and Popper.js -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <!-- Add Chart.js library -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        let chartInstance = null;

        function calculateProfit() {
    const purchasePrices = document.getElementById('purchasePrice').value.split(',').map(price => parseFloat(price.trim()));
    const salePrices = document.getElementById('salePrice').value.split(',').map(price => parseFloat(price.trim()));
    const shares = document.getElementById('shares').value.split(',').map(share => parseInt(share.trim()));

    const resultsTable = document.getElementById('resultsTable');
    resultsTable.innerHTML = '';

    const profitData = [];
    const labels = [];
    let totalProfitLoss = 0; // Initialize total profit/loss
    let totalInvestment = 0; // Initialize total investment

    for (let i = 0; i < purchasePrices.length; i++) {
        const purchasePrice = purchasePrices[i];
        const salePrice = salePrices[i];
        const share = shares[i];
        const total_price = share * purchasePrice

        if (isNaN(purchasePrice) || isNaN(salePrice) || isNaN(share)) {
            continue; // Skip invalid data
        }

        const profit = (salePrice - purchasePrice) * share;
        const scenario = `Scenario ${i + 1}`;

        const profitColor = profit < 0 ? 'red' : 'green';

        const profitPercentage = ((salePrice - purchasePrice) / purchasePrice) * 100; // Calculate percentage gain or loss
        const profitPercentageColor = profitPercentage < 0 ? 'red' : 'green';

        // Add row to the table
        const row = document.createElement('tr');

        //row.innerHTML = "<td>stock-"+i+"</td><td>"+share+"</td><td>"+purchasePrice.toFixed(2)+"</td><td>"+total_price.toFixed(2)+"</td><td>"+salePrice.toFixed(2)+"</td><td>"+profit.toFixed(2)+"</td>";

        row.innerHTML = "<td>stock-" + i + "</td><td>" + share + "</td><td>" + purchasePrice.toFixed(2) + "</td><td>" + total_price.toFixed(2) + "</td><td>" + salePrice.toFixed(2) + "</td><td style='color:" + profitColor + ";'>" + profit.toFixed(2) + " (" + profitPercentage.toFixed(2) + "%)</td>";

        resultsTable.appendChild(row);

        // Collect data for the chart
        labels.push(scenario);
        profitData.push(profit);

        // Update total profit/loss
        totalProfitLoss += profit;
        totalInvestment += total_price;
    }

    // Calculate overall percentage gain or loss
    const totalProfitPercentage = ((totalProfitLoss / totalInvestment) * 100) || 0;

    // Update the total profit/loss element
    const totalProfitLossElement = document.getElementById('totalProfitLoss');
    //totalProfitLossElement.textContent = totalProfitLoss.toFixed(2);
    totalProfitLossElement.textContent = totalProfitLoss.toFixed(2) + " (" + totalProfitPercentage.toFixed(2) + "%)";



 // Set color based on totalProfitLoss value
    const totalProfitLossColor = totalProfitLoss < 0 ? 'red' : 'green';
    totalProfitLossElement.style.fontWeight = 'bold';
    totalProfitLossElement.style.backgroundColor = 'yellow';
    totalProfitLossElement.style.color = totalProfitLossColor;

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
                label: 'Profit/Loss',
                data: profitData,
                backgroundColor: profitData.map(profit => profit >= 0 ? 'green' : 'red'),
                borderColor: 'blue',
                borderWidth: 1,
                type: 'bar' // This dataset is for the bar chart
            },
            {
                label: 'Profit/Loss (Line)',
                data: profitData,
                borderColor: 'orange',
                borderWidth: 2,
                fill: false,
                type: 'line' // This dataset is for the line chart
            }
        ]
    },
    options: {
        scales: {
            y: {
                beginAtZero: true,
                title: {
                    display: true,
                    text: 'Profit/Loss'
                }
            }
        }
    }
});
}


        // Call calculateProfit when the button is clicked
        document.getElementById('calculateButton').addEventListener('click', calculateProfit);

        // Call calculateProfit when input values change
        document.getElementById('purchasePrice').addEventListener('input', calculateProfit);
        document.getElementById('salePrice').addEventListener('input', calculateProfit);
        document.getElementById('shares').addEventListener('input', calculateProfit);

        // Initial chart rendering
        calculateProfit();
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

<p>Whether you are an experienced trader or new to the world of stock markets, our Stock Profit Calculator is a valuable tool to help you calculate your profits for each trade.</p>

    <h2>Share Market Profit Calculation</h2>
    <p>The Share Market Profit Calculator is designed to determine the total profit or loss from your financial transactions. It calculates stock profits by comparing the selling price to the purchase price, taking into account any broker's commission.</p>


<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
