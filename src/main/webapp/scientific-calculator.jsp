<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Scientific Calculator Online | Free Math Calculator | 8gwifi.org</title>
    <meta name="description" content="Free online scientific calculator with advanced mathematical functions. Calculate trigonometry, logarithms, exponents, roots, factorials and more. Full keyboard support with calculation history.">
    <meta name="keywords" content="scientific calculator, online calculator, math calculator, trigonometry calculator, log calculator, free calculator">

    <link rel="canonical" href="https://8gwifi.org/scientific-calculator.jsp">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "Scientific Calculator",
      "description": "Free online scientific calculator with advanced mathematical functions including trigonometry, logarithms, and more.",
      "url": "https://8gwifi.org/scientific-calculator.jsp",
      "applicationCategory": "EducationalApplication",
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"}
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        .calculator {
            max-width: 400px;
            margin: 0 auto;
            background: linear-gradient(145deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }

        .calc-display {
            background: #2d3748;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            min-height: 80px;
        }

        .calc-expression {
            color: #a0aec0;
            font-size: 0.9rem;
            min-height: 20px;
            text-align: right;
            margin-bottom: 5px;
            word-wrap: break-word;
        }

        .calc-result {
            color: #fff;
            font-size: 2rem;
            font-weight: bold;
            text-align: right;
            word-wrap: break-word;
        }

        .calc-buttons {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
        }

        .calc-btn {
            background: rgba(255,255,255,0.1);
            border: none;
            border-radius: 10px;
            color: white;
            font-size: 1.1rem;
            font-weight: 600;
            padding: 20px 10px;
            cursor: pointer;
            transition: all 0.2s;
            backdrop-filter: blur(10px);
        }

        .calc-btn:hover {
            background: rgba(255,255,255,0.2);
            transform: translateY(-2px);
        }

        .calc-btn:active {
            transform: translateY(0);
        }

        .calc-btn.operator {
            background: rgba(255,193,7,0.3);
        }

        .calc-btn.operator:hover {
            background: rgba(255,193,7,0.5);
        }

        .calc-btn.function {
            background: rgba(76,175,80,0.3);
            font-size: 0.9rem;
        }

        .calc-btn.function:hover {
            background: rgba(76,175,80,0.5);
        }

        .calc-btn.clear {
            background: rgba(244,67,54,0.3);
        }

        .calc-btn.clear:hover {
            background: rgba(244,67,54,0.5);
        }

        .calc-btn.equals {
            background: linear-gradient(145deg, #4caf50, #45a049);
            grid-column: span 2;
        }

        .calc-btn.equals:hover {
            background: linear-gradient(145deg, #45a049, #3d8b40);
        }

        .calc-btn.span-2 {
            grid-column: span 2;
        }

        .history-panel {
            background: white;
            border-radius: 10px;
            padding: 15px;
            max-height: 300px;
            overflow-y: auto;
        }

        .history-item {
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
            cursor: pointer;
            transition: background 0.2s;
        }

        .history-item:hover {
            background: #f7fafc;
        }

        .history-expr {
            color: #718096;
            font-size: 0.9rem;
        }

        .history-result {
            color: #2d3748;
            font-size: 1.1rem;
            font-weight: bold;
        }

        .mode-switch {
            margin-bottom: 15px;
        }

        .deg-rad-indicator {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            display: inline-block;
            font-size: 0.9rem;
            margin-bottom: 10px;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<%@ include file="math-menu-nav.jsp"%>

<div class="container mt-4">
    <h1 class="text-center mb-4"><i class="fas fa-calculator"></i> Scientific Calculator</h1>
    <p class="text-center text-muted mb-4">
        Advanced online calculator with scientific functions<br>
        <span class="badge badge-primary">Full Keyboard Support</span>
        <span class="badge badge-success">Calculation History</span>
    </p>

    <div class="row">
        <div class="col-lg-6">
            <div class="calculator">
                <div class="text-center">
                    <span class="deg-rad-indicator" id="angleMode">DEG</span>
                </div>

                <div class="calc-display">
                    <div class="calc-expression" id="expression"></div>
                    <div class="calc-result" id="result">0</div>
                </div>

                <div class="calc-buttons">
                    <!-- Row 1: Functions -->
                    <button class="calc-btn function" onclick="appendFunction('sin(')">sin</button>
                    <button class="calc-btn function" onclick="appendFunction('cos(')">cos</button>
                    <button class="calc-btn function" onclick="appendFunction('tan(')">tan</button>
                    <button class="calc-btn function" onclick="appendFunction('log(')">log</button>
                    <button class="calc-btn function" onclick="appendFunction('ln(')">ln</button>

                    <!-- Row 2: Functions -->
                    <button class="calc-btn function" onclick="appendFunction('asin(')">asin</button>
                    <button class="calc-btn function" onclick="appendFunction('acos(')">acos</button>
                    <button class="calc-btn function" onclick="appendFunction('atan(')">atan</button>
                    <button class="calc-btn function" onclick="appendFunction('sqrt(')">√</button>
                    <button class="calc-btn function" onclick="appendOperator('^')">x<sup>y</sup></button>

                    <!-- Row 3: Constants & Memory -->
                    <button class="calc-btn function" onclick="appendConstant('Math.PI')">π</button>
                    <button class="calc-btn function" onclick="appendConstant('Math.E')">e</button>
                    <button class="calc-btn function" onclick="calculateFactorial()">x!</button>
                    <button class="calc-btn function" onclick="append('(')">(</button>
                    <button class="calc-btn function" onclick="append(')')">)</button>

                    <!-- Row 4: Clear & Numbers -->
                    <button class="calc-btn clear" onclick="clearAll()">AC</button>
                    <button class="calc-btn clear" onclick="clearEntry()">CE</button>
                    <button class="calc-btn clear" onclick="backspace()">⌫</button>
                    <button class="calc-btn operator" onclick="appendOperator('/')">/</button>
                    <button class="calc-btn operator" onclick="appendOperator('*')">×</button>

                    <!-- Row 5: Numbers -->
                    <button class="calc-btn" onclick="append('7')">7</button>
                    <button class="calc-btn" onclick="append('8')">8</button>
                    <button class="calc-btn" onclick="append('9')">9</button>
                    <button class="calc-btn operator" onclick="appendOperator('-')">-</button>
                    <button class="calc-btn function" onclick="toggleAngleMode()">DEG/RAD</button>

                    <!-- Row 6: Numbers -->
                    <button class="calc-btn" onclick="append('4')">4</button>
                    <button class="calc-btn" onclick="append('5')">5</button>
                    <button class="calc-btn" onclick="append('6')">6</button>
                    <button class="calc-btn operator" onclick="appendOperator('+')">+</button>
                    <button class="calc-btn function" onclick="appendFunction('exp(')">exp</button>

                    <!-- Row 7: Numbers -->
                    <button class="calc-btn" onclick="append('1')">1</button>
                    <button class="calc-btn" onclick="append('2')">2</button>
                    <button class="calc-btn" onclick="append('3')">3</button>
                    <button class="calc-btn function" onclick="append('%')">%</button>
                    <button class="calc-btn function" onclick="negate()">+/-</button>

                    <!-- Row 8: Zero & Equals -->
                    <button class="calc-btn span-2" onclick="append('0')">0</button>
                    <button class="calc-btn" onclick="append('.')">.</button>
                    <button class="calc-btn equals span-2" onclick="calculate()">=</button>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0"><i class="fas fa-history"></i> Calculation History</h5>
                    <button class="btn btn-sm btn-light float-right" style="margin-top: -30px;" onclick="clearHistory()">Clear</button>
                </div>
                <div class="card-body p-0">
                    <div class="history-panel" id="historyPanel">
                        <p class="text-center text-muted p-3">No calculations yet</p>
                    </div>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-keyboard"></i> Keyboard Shortcuts</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <ul class="small">
                                <li><kbd>0-9</kbd> Numbers</li>
                                <li><kbd>+ - * /</kbd> Operators</li>
                                <li><kbd>.</kbd> Decimal point</li>
                                <li><kbd>Enter</kbd> Calculate</li>
                                <li><kbd>Backspace</kbd> Delete</li>
                            </ul>
                        </div>
                        <div class="col-md-6">
                            <ul class="small">
                                <li><kbd>Escape</kbd> Clear all</li>
                                <li><kbd>( )</kbd> Parentheses</li>
                                <li><kbd>^</kbd> Power</li>
                                <li><kbd>%</kbd> Percentage</li>
                                <li><kbd>p</kbd> π (pi)</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card mt-3">
                <div class="card-header bg-success text-white">
                    <h5 class="mb-0"><i class="fas fa-info-circle"></i> Functions</h5>
                </div>
                <div class="card-body">
                    <ul class="small">
                        <li><strong>sin, cos, tan:</strong> Trigonometric functions</li>
                        <li><strong>asin, acos, atan:</strong> Inverse trig functions</li>
                        <li><strong>log:</strong> Base-10 logarithm</li>
                        <li><strong>ln:</strong> Natural logarithm (base-e)</li>
                        <li><strong>√:</strong> Square root</li>
                        <li><strong>x<sup>y</sup>:</strong> Power/exponent</li>
                        <li><strong>x!:</strong> Factorial</li>
                        <li><strong>exp:</strong> e<sup>x</sup></li>
                        <li><strong>π:</strong> Pi (3.14159...)</li>
                        <li><strong>e:</strong> Euler's number (2.71828...)</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="thanks.jsp"%>
    <hr>
    <%@ include file="addcomments.jsp"%>
</div>

<%@ include file="footer_adsense.jsp"%>

<script>
let currentExpression = '';
let currentResult = '0';
let history = [];
let angleMode = 'deg'; // 'deg' or 'rad'

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    updateDisplay();
    loadHistory();

    // Keyboard support
    document.addEventListener('keydown', handleKeyboard);
});

function handleKeyboard(event) {
    const key = event.key;

    if (/[0-9.]/.test(key)) {
        append(key);
    } else if (['+', '-', '*', '/', '(', ')', '^', '%'].includes(key)) {
        append(key);
    } else if (key === 'Enter') {
        event.preventDefault();
        calculate();
    } else if (key === 'Backspace') {
        event.preventDefault();
        backspace();
    } else if (key === 'Escape') {
        clearAll();
    } else if (key.toLowerCase() === 'p') {
        appendConstant('Math.PI');
    } else if (key.toLowerCase() === 'e') {
        appendConstant('Math.E');
    }
}

function append(value) {
    if (currentResult !== '0' && currentExpression === '') {
        // Starting new calculation after result
        currentExpression = value;
    } else {
        currentExpression += value;
    }
    updateDisplay();
}

function appendOperator(op) {
    if (currentExpression === '' && currentResult !== '0') {
        currentExpression = currentResult + op;
    } else {
        // Replace last operator if expression ends with operator
        const lastChar = currentExpression.slice(-1);
        if (['+', '-', '*', '/', '^'].includes(lastChar)) {
            currentExpression = currentExpression.slice(0, -1) + op;
        } else {
            currentExpression += op;
        }
    }
    updateDisplay();
}

function appendFunction(func) {
    if (currentExpression === '' && currentResult !== '0') {
        currentExpression = func + currentResult + ')';
    } else {
        currentExpression += func;
    }
    updateDisplay();
}

function appendConstant(constant) {
    currentExpression += constant;
    updateDisplay();
}

function backspace() {
    currentExpression = currentExpression.slice(0, -1);
    updateDisplay();
}

function clearEntry() {
    currentExpression = '';
    updateDisplay();
}

function clearAll() {
    currentExpression = '';
    currentResult = '0';
    updateDisplay();
}

function negate() {
    if (currentResult !== '0') {
        const num = parseFloat(currentResult);
        currentResult = (-num).toString();
        currentExpression = currentResult;
        updateDisplay();
    }
}

function toggleAngleMode() {
    angleMode = angleMode === 'deg' ? 'rad' : 'deg';
    document.getElementById('angleMode').textContent = angleMode.toUpperCase();
}

function calculateFactorial() {
    if (currentResult !== '0') {
        try {
            const num = parseInt(currentResult);
            if (num < 0 || num > 170) {
                throw new Error('Factorial only supports 0-170');
            }
            let result = 1;
            for (let i = 2; i <= num; i++) {
                result *= i;
            }
            currentExpression = currentResult + '!';
            currentResult = result.toString();
            addToHistory(currentExpression, currentResult);
            currentExpression = '';
            updateDisplay();
        } catch (error) {
            currentResult = 'Error';
            updateDisplay();
        }
    }
}

function calculate() {
    if (currentExpression === '') return;

    try {
        // Prepare expression for evaluation
        let expr = currentExpression;

        // Replace Math constants
        expr = expr.replace(/Math\.PI/g, Math.PI);
        expr = expr.replace(/Math\.E/g, Math.E);

        // Replace operators
        expr = expr.replace(/\^/g, '**');

        // Handle trigonometric functions (convert degrees to radians if needed)
        if (angleMode === 'deg') {
            expr = expr.replace(/sin\(([^)]+)\)/g, (match, angle) => {
                return `Math.sin((${angle}) * Math.PI / 180)`;
            });
            expr = expr.replace(/cos\(([^)]+)\)/g, (match, angle) => {
                return `Math.cos((${angle}) * Math.PI / 180)`;
            });
            expr = expr.replace(/tan\(([^)]+)\)/g, (match, angle) => {
                return `Math.tan((${angle}) * Math.PI / 180)`;
            });
            expr = expr.replace(/asin\(([^)]+)\)/g, (match, value) => {
                return `(Math.asin(${value}) * 180 / Math.PI)`;
            });
            expr = expr.replace(/acos\(([^)]+)\)/g, (match, value) => {
                return `(Math.acos(${value}) * 180 / Math.PI)`;
            });
            expr = expr.replace(/atan\(([^)]+)\)/g, (match, value) => {
                return `(Math.atan(${value}) * 180 / Math.PI)`;
            });
        } else {
            expr = expr.replace(/sin/g, 'Math.sin');
            expr = expr.replace(/cos/g, 'Math.cos');
            expr = expr.replace(/tan/g, 'Math.tan');
            expr = expr.replace(/asin/g, 'Math.asin');
            expr = expr.replace(/acos/g, 'Math.acos');
            expr = expr.replace(/atan/g, 'Math.atan');
        }

        // Replace other functions
        expr = expr.replace(/log\(/g, 'Math.log10(');
        expr = expr.replace(/ln\(/g, 'Math.log(');
        expr = expr.replace(/sqrt\(/g, 'Math.sqrt(');
        expr = expr.replace(/exp\(/g, 'Math.exp(');

        // Evaluate
        const result = eval(expr);

        // Format result
        let formattedResult = result.toString();
        if (!isNaN(result) && isFinite(result)) {
            // Round to 10 decimal places to avoid floating point errors
            formattedResult = parseFloat(result.toFixed(10)).toString();
        }

        // Add to history
        addToHistory(currentExpression, formattedResult);

        currentResult = formattedResult;
        currentExpression = '';
        updateDisplay();

    } catch (error) {
        currentResult = 'Error';
        updateDisplay();
    }
}

function updateDisplay() {
    document.getElementById('expression').textContent = currentExpression || ' ';
    document.getElementById('result').textContent = currentResult;
}

function addToHistory(expression, result) {
    history.unshift({ expression, result, timestamp: new Date() });
    if (history.length > 20) history.pop(); // Keep last 20
    saveHistory();
    displayHistory();
}

function displayHistory() {
    const panel = document.getElementById('historyPanel');

    if (history.length === 0) {
        panel.innerHTML = '<p class="text-center text-muted p-3">No calculations yet</p>';
        return;
    }

    let html = '';
    history.forEach((item, index) => {
        html += `
            <div class="history-item" onclick="loadFromHistory(${index})">
                <div class="history-expr">${item.expression}</div>
                <div class="history-result">= ${item.result}</div>
            </div>
        `;
    });
    panel.innerHTML = html;
}

function loadFromHistory(index) {
    const item = history[index];
    currentExpression = item.expression;
    currentResult = item.result;
    updateDisplay();
}

function clearHistory() {
    if (confirm('Clear all calculation history?')) {
        history = [];
        saveHistory();
        displayHistory();
    }
}

function saveHistory() {
    try {
        localStorage.setItem('calcHistory', JSON.stringify(history));
    } catch (e) {}
}

function loadHistory() {
    try {
        const saved = localStorage.getItem('calcHistory');
        if (saved) {
            history = JSON.parse(saved);
            displayHistory();
        }
    } catch (e) {}
}
</script>

<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="body-close.jsp"%>
