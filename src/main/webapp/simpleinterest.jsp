<!DOCTYPE html>
<html>
<head>
    <title>Simple Interest Calculator</title>
    <meta name="description" content="A calculator for solving simple interest rate problems.">
    <meta name="keywords" content="simple interest, interest rate, calculator, finance, math">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
<h1>Simple Interest Calculator</h1>
<p>This calculator can solve the following simple interest rate problems:</p>
<ol>
    <li>A = P(1 + rt)</li>
    <li>P = A / (1 + rt)</li>
    <li>r = (1/t)(A/P - 1)</li>
    <li>t = (1/r)(A/P - 1)</li>
</ol>

<label for="calculation-type">Select a Calculation Type:</label>
<select id="calculation-type" onchange="updateForm()">
    <option value="principle">Calculate P (Principal)</option>
    <option value="interest-rate">Calculate r (Interest Rate)</option>
    <option value="time">Calculate t (Time)</option>
    <option value="total-amount">Calculate A (Total Amount)</option>
</select>

<div id="form-principle">
    <h2>Calculate P (Principal)</h2>
    <form>
        <label for="total-amount-p">Total Amount:</label>
        <input type="number" id="total-amount-p" name="total-amount-p" step="0.01">
        <br><br>
        <label for="interest-rate-p">Interest Rate:</label>
        <input type="number" id="interest-rate-p" name="interest-rate-p" step="0.01">
        <br><br>
        <label for="time-p">Time (in years):</label>
        <input type="number" id="time-p" name="time-p">
        <br><br>
        <button type="button" onclick="calculateP()">Calculate Principal</button>
    </form>
    <br>
    <div id="result-p"></div>
</div>

<div id="form-interest-rate">
    <h2>Calculate r (Interest Rate)</h2>
    <form>
        <label for="total-amount-r">Total Amount:</label>
        <input type="number" id="total-amount-r" name="total-amount-r" step="0.01">
        <br><br>
        <label for="principal-r">Principal:</label>
        <input type="number" id="principal-r" name="principal-r" step="0.01">
        <br><br>
        <label for="time-r">Time (in years):</label>
        <input type="number" id="time-r" name="time-r">
        <br><br>
        <button type="button" onclick="calculateR()">Calculate Interest Rate</button>
    </form>
    <br>
    <div id="result-r"></div>
</div>

<div id="form-time">
    <h2>Calculate t (Time)</h2>
    <form>
        <label for="total-amount-t">Total Amount:</label>
        <input type="number" id="total-amount-t" name="total-amount-t" step="0.01">
        <br><br>
        <label for="principal-t">Principal:</label>
        <input type="number" id="principal-t" name="principal-t" step="0.01">
        <br><br>
        <label for="interest-rate-t">Interest Rate:</label>
        <input type="number" id="interest-rate-t" name="interest-rate-t" step="0.01">
        <br><br>
        <button type="button" onclick="calculateT()">Calculate Time (in years)</button>
    </form>
    <br>
    <div id="result-t"></div>
</div>

<div id="form-total-amount">
    <h2>Calculate A (Total Amount)</h2>
    <form>
        <label for="principal-a">Principal:</label>
        <input type="number" id="principal-a" name="principal-a" step="0.01">
        <br><br>
        <label for="interest-rate-a">Interest Rate:</label>
        <input type="number" id="interest-rate-a" name="interest-rate-a" step="0.01">
        <br><br>
        <label for="time-a">Time (in years):</label>
        <input type="number" id="time-a" name="time-a">
        <br><br>
        <button type="button" onclick="calculateA()">Calculate Total Amount</button>
    </form>
    <br>
    <div id="result-a"></div>
</div>

<script>
    const principleForm = document.getElementById('form-principle');
    const interestRateForm = document.getElementById('form-interest-rate');
    const timeForm = document.getElementById('form-time');
    const totalAmountForm = document.getElementById('form-total-amount');

    function updateForm() {
        const selectElement = document.getElementById('calculation-type');
        const selectedValue = selectElement.options[selectElement.selectedIndex].value;

        if (selectedValue === 'principle') {
            principleForm.style.display = 'block';
            interestRateForm.style.display = 'none';
            timeForm.style.display = 'none';
            totalAmountForm.style.display = 'none';
        } else if (selectedValue === 'interest-rate') {
            principleForm.style.display = 'none';
            interestRateForm.style.display = 'block';
            timeForm.style.display = 'none';
            totalAmountForm.style.display = 'none';
        } else if (selectedValue === 'time') {
            principleForm.style.display = 'none';
            interestRateForm.style.display = 'none';
            timeForm.style.display = 'block';
            totalAmountForm.style.display = 'none';
        } else if (selectedValue === 'total-amount') {
            principleForm.style.display = 'none';
            interestRateForm.style.display = 'none';
            timeForm.style.display = 'none';
            totalAmountForm.style.display = 'block';
        }
    }

    function calculateP() {
        const totalAmount = document.getElementById('total-amount-p').value;
        const interestRate = document.getElementById('interest-rate-p').value;
        const time = document.getElementById('time-p').value;

        const principal = totalAmount / (1 + (interestRate * time));
        document.getElementById('result-p').innerHTML = `The Principal is $${principal.toFixed(2)}`;
    }

    function calculateR() {
        const totalAmount = document.getElementById('total-amount-r').value;
        const principal = document.getElementById('principal-r').value;
        const time = document.getElementById('time-r').value;

        const interestRate = (1/time) * ((totalAmount / principal) - 1);
        document.getElementById('result-r').innerHTML = `The Interest Rate is ${interestRate.toFixed(2)}%`;
    }

    function calculateT() {
        const totalAmount = document.getElementById('total-amount-t').value;
        const principal = document.getElementById('principal-t').value;
        const interestRate = document.getElementById('interest-rate-t').value;

        const time = Math.log(totalAmount / principal) / (Math.log(1 + interestRate));
        document.getElementById('result-t').innerHTML = `The Time (in years) is ${time.toFixed(2)}`;
    }

    function calculateA() {
        const principal = document.getElementById        ('principal-a').value;
        const interestRate = document.getElementById('interest-rate-a').value;
        const time = document.getElementById('time-a').value;

        const totalAmount = principal * (1 + (interestRate * time));
        document.getElementById('result-a').innerHTML = `The Total Amount is $${totalAmount.toFixed(2)}`;
    }
</script>
<hr>

<%--<%@ include file="addcomments.jsp"%>--%>

</div>

<%@ include file="body-close.jsp"%>
