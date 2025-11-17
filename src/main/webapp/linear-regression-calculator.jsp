<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- SEO Meta -->
<title>Linear Regression Calculator - Calculate Regression Line, R², Predictions | Free Tool</title>
<meta name="description" content="Free online Linear Regression Calculator with scatter plot and regression line visualization. Calculate slope, intercept, R-squared, correlation coefficient, and make predictions. Perfect for statistics students and data analysts.">
<meta name="keywords" content="linear regression calculator, regression line, r squared calculator, correlation regression, least squares calculator, slope intercept calculator, prediction calculator, scatter plot regression">
<link rel="canonical" href="https://8gwifi.org/linear-regression-calculator.jsp">

<!-- Open Graph / Twitter -->
<meta property="og:title" content="Linear Regression Calculator - Free Online Tool">
<meta property="og:description" content="Calculate linear regression equations, R-squared, correlation, and make predictions with interactive scatter plot visualization.">
<meta property="og:type" content="website">
<meta property="og:url" content="https://8gwifi.org/linear-regression-calculator.jsp">
<meta property="og:image" content="https://8gwifi.org/images/linear-regression-calculator.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="Linear Regression Calculator - Free Online Tool">
<meta name="twitter:description" content="Calculate linear regression equations, R-squared, correlation, and make predictions with interactive scatter plot visualization.">
<meta name="twitter:image" content="https://8gwifi.org/images/linear-regression-calculator.png">

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@3.9.1/dist/chart.min.js"></script>

<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Linear Regression Calculator",
  "url": "https://8gwifi.org/linear-regression-calculator.jsp",
  "description": "Calculate linear regression equations, slope, intercept, R-squared, correlation coefficient, and make predictions with interactive scatter plot visualization. Free online statistical tool.",
  "applicationCategory": "EducationalApplication",
  "operatingSystem": "Any",
  "browserRequirements": "Requires JavaScript",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "featureList": "Linear regression equation, Slope and intercept calculation, R-squared calculation, Correlation coefficient, Residual analysis, Scatter plot with regression line, Prediction calculator, Standard error of estimate",
  "screenshot": "https://8gwifi.org/images/linear-regression-calculator.png",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1875"
  }
}
</script>

    <style>
        :root {
            --primary-color: #0891b2;
            --primary-dark: #0e7490;
            --primary-light: #67e8f9;
            --bg-light: #f0fdfa;
            --border-color: #99f6e4;
        }

        .calculator-section {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 1.5rem;
        }

        .section-title {
            color: var(--primary-color);
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border-color);
        }

        .form-label {
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-select {
            border: 1.5px solid #e5e7eb;
            border-radius: 6px;
            padding: 0.5rem 0.75rem;
            transition: all 0.2s;
        }

        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(8, 145, 178, 0.1);
        }

        .btn-calculate {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            font-size: 1rem;
            font-weight: 500;
            border-radius: 6px;
            transition: all 0.2s;
            width: 100%;
        }

        .btn-calculate:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(8, 145, 178, 0.3);
        }

        .btn-sample {
            background: white;
            color: var(--primary-color);
            border: 1.5px solid var(--primary-color);
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            border-radius: 6px;
            transition: all 0.2s;
        }

        .btn-sample:hover {
            background: var(--bg-light);
        }

        .results-panel {
            background: var(--bg-light);
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            position: sticky;
            top: 20px;
        }

        .result-item {
            background: white;
            border-left: 4px solid var(--primary-color);
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: 6px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .result-label {
            font-size: 0.85rem;
            color: #6b7280;
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .result-value {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-color);
            font-family: 'Courier New', monospace;
        }

        .result-equation {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-dark);
            font-family: 'Courier New', monospace;
            word-break: break-all;
        }

        .interpretation {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 0.75rem;
            border-radius: 4px;
            font-size: 0.85rem;
            margin-top: 0.5rem;
            color: #92400e;
        }

        #regressionPlot, #residualPlot {
            width: 100%;
            max-height: 250px;
            border-radius: 8px;
        }

        .chart-container {
            background: white;
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }

        .info-box {
            background: #eff6ff;
            border-left: 4px solid #3b82f6;
            padding: 1rem;
            border-radius: 6px;
            margin: 1rem 0;
        }

        .info-box i {
            color: #3b82f6;
            margin-right: 0.5rem;
        }

        .educational-section {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-top: 2rem;
        }

        .educational-section h3 {
            color: var(--primary-color);
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .educational-section h4 {
            color: var(--primary-dark);
            font-size: 1.1rem;
            font-weight: 600;
            margin-top: 1.5rem;
            margin-bottom: 0.75rem;
        }

        .formula-box {
            background: var(--bg-light);
            border: 2px solid var(--border-color);
            border-radius: 8px;
            padding: 1rem;
            font-family: 'Courier New', monospace;
            font-size: 1rem;
            margin: 1rem 0;
            text-align: center;
        }

        .example-table {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            margin: 1rem 0;
        }

        .example-table table {
            margin-bottom: 0;
        }

        .example-table th {
            background: var(--primary-color);
            color: white;
            font-weight: 500;
            padding: 0.75rem;
        }

        .example-table td {
            padding: 0.5rem 0.75rem;
            border-bottom: 1px solid #e5e7eb;
        }

        .prediction-section {
            background: white;
            border: 2px dashed var(--primary-color);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .prediction-input {
            display: flex;
            gap: 0.5rem;
            align-items: center;
            margin-top: 0.5rem;
        }

        .prediction-result {
            background: var(--bg-light);
            padding: 0.75rem;
            border-radius: 6px;
            margin-top: 0.5rem;
            font-weight: 600;
            color: var(--primary-dark);
        }

        @media (max-width: 991px) {
            .results-panel {
                position: static;
                margin-top: 1.5rem;
            }
        }

        @media (max-width: 768px) {
            .page-header h1 {
                font-size: 1.5rem;
            }
            .result-value {
                font-size: 1.25rem;
            }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>
<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
  <h1>Linear Regression Calculator</h1>
  <p class="text-muted">Calculate regression equations, R², correlation, and make predictions with interactive visualizations</p>

  <%@ include file="footer_adsense.jsp"%>

  <div class="row">
            <!-- Left Column: Input -->
            <div class="col-lg-7">
                <div class="calculator-section">
                    <h2 class="section-title"><i class="fas fa-database"></i> Data Input</h2>

                    <div class="info-box">
                        <i class="fas fa-info-circle"></i>
                        <strong>Enter your data:</strong> Provide X and Y values as comma-separated pairs, one per line. Example: 1,2 or use the sample data button.
                    </div>

                    <div class="mb-3">
                        <label for="dataInput" class="form-label">X, Y Data Pairs (one per line)</label>
                        <textarea class="form-control" id="dataInput" rows="8" placeholder="Example:&#10;1, 2&#10;2, 4&#10;3, 5&#10;4, 4&#10;5, 5"></textarea>
                        <button class="btn btn-sample mt-2" onclick="loadSampleData()">
                            <i class="fas fa-flask"></i> Load Sample Data
                        </button>
                    </div>

                    <button class="btn btn-calculate" onclick="calculateRegression()">
                        <i class="fas fa-calculator"></i> Calculate Regression
                    </button>

                    <!-- Prediction Section -->
                    <div class="prediction-section" id="predictionSection" style="display: none;">
                        <h5 style="color: var(--primary-color); margin-bottom: 1rem;">
                            <i class="fas fa-crystal-ball"></i> Make Predictions
                        </h5>
                        <div class="prediction-input">
                            <label style="min-width: 80px; margin-bottom: 0;">X Value:</label>
                            <input type="number" class="form-control" id="predictionX" step="any" placeholder="Enter X value">
                            <button class="btn btn-sample" onclick="makePrediction()">
                                <i class="fas fa-search"></i> Predict Y
                            </button>
                        </div>
                        <div id="predictionResult"></div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Results -->
            <div class="col-lg-5">
                <div class="results-panel">
                    <h2 class="section-title"><i class="fas fa-chart-area"></i> Results</h2>
                    <div id="resultsContent">
                        <div class="text-center text-muted py-4">
                            <i class="fas fa-arrow-left" style="font-size: 2rem; opacity: 0.3;"></i>
                            <p class="mt-2">Enter data and click Calculate to see results</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Educational Content -->
        <div class="educational-section">
            <h3><i class="fas fa-graduation-cap"></i> Understanding Linear Regression</h3>

            <p><strong>Linear regression</strong> is a statistical method for modeling the relationship between a dependent variable (Y) and an independent variable (X). It finds the best-fitting straight line through the data points.</p>

            <h4>The Regression Equation</h4>
            <p>The linear regression line is expressed as:</p>
            <div class="formula-box">
                y = a + bx
            </div>
            <p>Where:</p>
            <ul>
                <li><strong>y</strong> = predicted value (dependent variable)</li>
                <li><strong>x</strong> = independent variable (predictor)</li>
                <li><strong>b</strong> = slope (change in y for each unit change in x)</li>
                <li><strong>a</strong> = y-intercept (value of y when x = 0)</li>
            </ul>

            <h4>Key Calculations</h4>
            <div class="formula-box">
                <strong>Slope (b):</strong> b = Σ[(xᵢ - x̄)(yᵢ - ȳ)] / Σ(xᵢ - x̄)²
            </div>
            <div class="formula-box">
                <strong>Intercept (a):</strong> a = ȳ - b × x̄
            </div>
            <div class="formula-box">
                <strong>R² (Coefficient of Determination):</strong> R² = 1 - (SS_res / SS_tot)
            </div>

            <h4>Understanding R² (R-Squared)</h4>
            <p>R² measures how well the regression line fits the data:</p>
            <div class="example-table">
                <table class="table">
                    <thead>
                        <tr>
                            <th>R² Value</th>
                            <th>Interpretation</th>
                            <th>Fit Quality</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>0.90 - 1.00</td>
                            <td>90-100% of variance explained</td>
                            <td><span style="color: #10b981; font-weight: 600;">Excellent</span></td>
                        </tr>
                        <tr>
                            <td>0.70 - 0.89</td>
                            <td>70-89% of variance explained</td>
                            <td><span style="color: #3b82f6; font-weight: 600;">Good</span></td>
                        </tr>
                        <tr>
                            <td>0.50 - 0.69</td>
                            <td>50-69% of variance explained</td>
                            <td><span style="color: #f59e0b; font-weight: 600;">Moderate</span></td>
                        </tr>
                        <tr>
                            <td>0.00 - 0.49</td>
                            <td>Less than 50% explained</td>
                            <td><span style="color: #ef4444; font-weight: 600;">Weak</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <h4>Correlation Coefficient (r)</h4>
            <p>The correlation coefficient measures the strength and direction of the linear relationship:</p>
            <ul>
                <li><strong>r = +1:</strong> Perfect positive correlation</li>
                <li><strong>r = 0:</strong> No linear correlation</li>
                <li><strong>r = -1:</strong> Perfect negative correlation</li>
                <li><strong>|r| &gt; 0.7:</strong> Strong correlation</li>
                <li><strong>0.3 &lt; |r| &lt; 0.7:</strong> Moderate correlation</li>
                <li><strong>|r| &lt; 0.3:</strong> Weak correlation</li>
            </ul>

            <h4>Standard Error of Estimate (SEE)</h4>
            <p>The standard error measures the typical distance between observed and predicted values:</p>
            <div class="formula-box">
                SEE = √[Σ(yᵢ - ŷᵢ)² / (n - 2)]
            </div>
            <p>A smaller SEE indicates better predictions.</p>

            <h4>Assumptions of Linear Regression</h4>
            <ul>
                <li><strong>Linearity:</strong> The relationship between X and Y is linear</li>
                <li><strong>Independence:</strong> Observations are independent of each other</li>
                <li><strong>Homoscedasticity:</strong> Residuals have constant variance</li>
                <li><strong>Normality:</strong> Residuals are normally distributed</li>
                <li><strong>No outliers:</strong> Extreme values can disproportionately affect the line</li>
            </ul>

            <h4>Real-World Applications</h4>
            <ul>
                <li><strong>Business:</strong> Sales forecasting, price optimization, demand prediction</li>
                <li><strong>Economics:</strong> GDP analysis, inflation prediction, market trends</li>
                <li><strong>Healthcare:</strong> Drug dosage, disease progression, risk factors</li>
                <li><strong>Science:</strong> Calibration curves, experimental relationships</li>
                <li><strong>Education:</strong> Grade prediction, study time vs. performance</li>
                <li><strong>Real Estate:</strong> Property valuation based on features</li>
            </ul>

            <h4>Interpreting Results</h4>
            <p><strong>Slope Interpretation:</strong> "For every 1-unit increase in X, Y increases/decreases by b units."</p>
            <p><strong>Intercept Interpretation:</strong> "When X = 0, the predicted value of Y is a."</p>
            <p><strong>R² Interpretation:</strong> "The model explains R²×100% of the variance in Y."</p>

            <div class="info-box">
                <i class="fas fa-lightbulb"></i>
                <strong>Tip:</strong> Always visualize your data with a scatter plot before performing regression. Linear regression assumes a linear relationship - if your data shows a curved pattern, consider polynomial regression or data transformation.
            </div>
        </div>
    </div>

  <%@ include file="thanks.jsp"%>

  <%@ include file="footer_adsense.jsp"%>
  <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>

<script>
        let regressionChart = null;
        let residualChart = null;
        let regressionData = null;

        function loadSampleData() {
            const sampleData = `1, 2.1
2, 3.9
3, 6.2
4, 7.8
5, 10.1
6, 11.9
7, 14.2
8, 15.8
9, 18.1
10, 19.9`;
            document.getElementById('dataInput').value = sampleData;
        }

        function parseData() {
            const input = document.getElementById('dataInput').value.trim();
            const lines = input.split('\n');
            const xValues = [];
            const yValues = [];

            for (let line of lines) {
                line = line.trim();
                if (line === '') continue;

                const parts = line.split(',');
                if (parts.length !== 2) {
                    alert('Error: Each line must contain exactly two values (X, Y) separated by a comma.');
                    return null;
                }

                const x = parseFloat(parts[0].trim());
                const y = parseFloat(parts[1].trim());

                if (isNaN(x) || isNaN(y)) {
                    alert('Error: All values must be valid numbers.');
                    return null;
                }

                xValues.push(x);
                yValues.push(y);
            }

            if (xValues.length < 2) {
                alert('Error: You need at least 2 data points for regression.');
                return null;
            }

            return { x: xValues, y: yValues };
        }

        function calculateMean(arr) {
            return arr.reduce((a, b) => a + b, 0) / arr.length;
        }

        function calculateRegression() {
            const data = parseData();
            if (!data) return;

            const { x, y } = data;
            const n = x.length;

            // Calculate means
            const xMean = calculateMean(x);
            const yMean = calculateMean(y);

            // Calculate slope (b) and intercept (a)
            let numerator = 0;
            let denominator = 0;

            for (let i = 0; i < n; i++) {
                numerator += (x[i] - xMean) * (y[i] - yMean);
                denominator += Math.pow(x[i] - xMean, 2);
            }

            const slope = numerator / denominator;
            const intercept = yMean - slope * xMean;

            // Calculate R² and correlation
            let ssRes = 0; // Residual sum of squares
            let ssTot = 0; // Total sum of squares
            const predicted = [];
            const residuals = [];

            for (let i = 0; i < n; i++) {
                const yPred = intercept + slope * x[i];
                predicted.push(yPred);
                const residual = y[i] - yPred;
                residuals.push(residual);
                ssRes += Math.pow(residual, 2);
                ssTot += Math.pow(y[i] - yMean, 2);
            }

            const rSquared = 1 - (ssRes / ssTot);
            const correlation = Math.sqrt(rSquared) * (slope >= 0 ? 1 : -1);

            // Calculate standard error of estimate
            const see = Math.sqrt(ssRes / (n - 2));

            // Store regression data for predictions
            regressionData = { slope, intercept, x, y, predicted, residuals };

            displayResults(slope, intercept, rSquared, correlation, see, n);
            drawRegressionPlot(x, y, predicted);
            drawResidualPlot(x, residuals);

            // Show prediction section
            document.getElementById('predictionSection').style.display = 'block';
        }

        function displayResults(slope, intercept, rSquared, correlation, see, n) {
            const equation = `y = ${intercept.toFixed(4)} ${slope >= 0 ? '+' : ''} ${slope.toFixed(4)}x`;

            let rSquaredInterpretation = '';
            if (rSquared >= 0.9) {
                rSquaredInterpretation = '<strong style="color: #10b981;">Excellent fit!</strong> The model explains ' + (rSquared * 100).toFixed(1) + '% of the variance.';
            } else if (rSquared >= 0.7) {
                rSquaredInterpretation = '<strong style="color: #3b82f6;">Good fit.</strong> The model explains ' + (rSquared * 100).toFixed(1) + '% of the variance.';
            } else if (rSquared >= 0.5) {
                rSquaredInterpretation = '<strong style="color: #f59e0b;">Moderate fit.</strong> The model explains ' + (rSquared * 100).toFixed(1) + '% of the variance.';
            } else {
                rSquaredInterpretation = '<strong style="color: #ef4444;">Weak fit.</strong> The model explains only ' + (rSquared * 100).toFixed(1) + '% of the variance.';
            }

            let corrInterpretation = '';
            const absCorr = Math.abs(correlation);
            if (absCorr >= 0.7) {
                corrInterpretation = '<strong>Strong</strong> ' + (correlation > 0 ? 'positive' : 'negative') + ' correlation';
            } else if (absCorr >= 0.3) {
                corrInterpretation = '<strong>Moderate</strong> ' + (correlation > 0 ? 'positive' : 'negative') + ' correlation';
            } else {
                corrInterpretation = '<strong>Weak</strong> ' + (correlation > 0 ? 'positive' : 'negative') + ' correlation';
            }

            const html = `
                <div class="result-item">
                    <div class="result-label">Regression Equation</div>
                    <div class="result-equation">${equation}</div>
                    <div class="interpretation">
                        <i class="fas fa-info-circle"></i> For every 1-unit increase in X, Y ${slope >= 0 ? 'increases' : 'decreases'} by ${Math.abs(slope).toFixed(4)} units.
                    </div>
                </div>

                <div class="result-item">
                    <div class="result-label">Slope (b)</div>
                    <div class="result-value">${slope.toFixed(6)}</div>
                </div>

                <div class="result-item">
                    <div class="result-label">Y-Intercept (a)</div>
                    <div class="result-value">${intercept.toFixed(6)}</div>
                </div>

                <div class="result-item">
                    <div class="result-label">R² (R-Squared)</div>
                    <div class="result-value">${rSquared.toFixed(6)}</div>
                    <div class="interpretation">
                        <i class="fas fa-chart-line"></i> ${rSquaredInterpretation}
                    </div>
                </div>

                <div class="result-item">
                    <div class="result-label">Correlation (r)</div>
                    <div class="result-value">${correlation.toFixed(6)}</div>
                    <div class="interpretation">
                        <i class="fas fa-link"></i> ${corrInterpretation}
                    </div>
                </div>

                <div class="result-item">
                    <div class="result-label">Standard Error of Estimate</div>
                    <div class="result-value">${see.toFixed(6)}</div>
                    <div class="interpretation">
                        <i class="fas fa-ruler"></i> Average distance between observed and predicted values
                    </div>
                </div>

                <div class="result-item">
                    <div class="result-label">Sample Size (n)</div>
                    <div class="result-value">${n}</div>
                </div>
            `;

            document.getElementById('resultsContent').innerHTML = html;
        }

        function drawRegressionPlot(x, y, predicted) {
            const ctx = document.getElementById('regressionPlot');

            if (!ctx) {
                // Create canvas if it doesn't exist
                const container = document.getElementById('resultsContent');
                const chartHtml = `
                    <div class="chart-container">
                        <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
                            <i class="fas fa-chart-scatter"></i> Scatter Plot with Regression Line
                        </h5>
                        <canvas id="regressionPlot"></canvas>
                    </div>
                `;
                container.insertAdjacentHTML('beforeend', chartHtml);
                return drawRegressionPlot(x, y, predicted);
            }

            if (regressionChart) {
                regressionChart.destroy();
            }

            // Create datasets
            const scatterData = x.map((xi, i) => ({ x: xi, y: y[i] }));
            const lineData = x.map((xi, i) => ({ x: xi, y: predicted[i] }));

            regressionChart = new Chart(ctx, {
                type: 'scatter',
                data: {
                    datasets: [
                        {
                            label: 'Observed Data',
                            data: scatterData,
                            backgroundColor: 'rgba(8, 145, 178, 0.6)',
                            borderColor: 'rgba(8, 145, 178, 1)',
                            borderWidth: 2,
                            pointRadius: 5,
                            pointHoverRadius: 7
                        },
                        {
                            label: 'Regression Line',
                            data: lineData,
                            type: 'line',
                            borderColor: 'rgba(239, 68, 68, 0.8)',
                            backgroundColor: 'rgba(239, 68, 68, 0.1)',
                            borderWidth: 2,
                            pointRadius: 0,
                            fill: false
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 1.5,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                boxWidth: 12,
                                font: { size: 10 }
                            }
                        },
                        title: {
                            display: true,
                            text: 'Linear Regression',
                            font: { size: 11, weight: 'bold' }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.dataset.label + ': (' +
                                           context.parsed.x.toFixed(2) + ', ' +
                                           context.parsed.y.toFixed(2) + ')';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'X',
                                font: { size: 10, weight: 'bold' }
                            },
                            ticks: { font: { size: 9 } }
                        },
                        y: {
                            title: {
                                display: true,
                                text: 'Y',
                                font: { size: 10, weight: 'bold' }
                            },
                            ticks: { font: { size: 9 } }
                        }
                    }
                }
            });
        }

        function drawResidualPlot(x, residuals) {
            const container = document.getElementById('resultsContent');

            // Check if residual plot already exists
            let ctx = document.getElementById('residualPlot');
            if (!ctx) {
                const chartHtml = `
                    <div class="chart-container">
                        <h5 style="color: var(--primary-color); margin-bottom: 1rem; font-size: 0.95rem;">
                            <i class="fas fa-chart-bar"></i> Residual Plot
                        </h5>
                        <canvas id="residualPlot"></canvas>
                    </div>
                `;
                container.insertAdjacentHTML('beforeend', chartHtml);
                ctx = document.getElementById('residualPlot');
            }

            if (residualChart) {
                residualChart.destroy();
            }

            const residualData = x.map((xi, i) => ({ x: xi, y: residuals[i] }));

            residualChart = new Chart(ctx, {
                type: 'scatter',
                data: {
                    datasets: [{
                        label: 'Residuals',
                        data: residualData,
                        backgroundColor: 'rgba(147, 51, 234, 0.6)',
                        borderColor: 'rgba(147, 51, 234, 1)',
                        borderWidth: 2,
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }, {
                        label: 'Zero Line',
                        data: x.map(xi => ({ x: xi, y: 0 })),
                        type: 'line',
                        borderColor: 'rgba(107, 114, 128, 0.5)',
                        borderWidth: 1,
                        borderDash: [5, 5],
                        pointRadius: 0,
                        fill: false
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    aspectRatio: 1.5,
                    plugins: {
                        legend: {
                            position: 'top',
                            labels: {
                                boxWidth: 12,
                                font: { size: 10 }
                            }
                        },
                        title: {
                            display: true,
                            text: 'Residuals vs X',
                            font: { size: 11, weight: 'bold' }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    if (context.datasetIndex === 0) {
                                        return 'Residual: ' + context.parsed.y.toFixed(4) + ' at X=' + context.parsed.x.toFixed(2);
                                    }
                                    return '';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            title: {
                                display: true,
                                text: 'X',
                                font: { size: 10, weight: 'bold' }
                            },
                            ticks: { font: { size: 9 } }
                        },
                        y: {
                            title: {
                                display: true,
                                text: 'Residual (Y - Ŷ)',
                                font: { size: 10, weight: 'bold' }
                            },
                            ticks: { font: { size: 9 } }
                        }
                    }
                }
            });
        }

        function makePrediction() {
            if (!regressionData) {
                alert('Please calculate regression first!');
                return;
            }

            const xValue = parseFloat(document.getElementById('predictionX').value);
            if (isNaN(xValue)) {
                alert('Please enter a valid X value.');
                return;
            }

            const { slope, intercept } = regressionData;
            const yPredicted = intercept + slope * xValue;

            const resultHtml = `
                <div class="prediction-result">
                    <i class="fas fa-arrow-right"></i>
                    For <strong>X = ${xValue}</strong>, predicted <strong>Y = ${yPredicted.toFixed(4)}</strong>
                </div>
            `;
            document.getElementById('predictionResult').innerHTML = resultHtml;
        }
</script>
