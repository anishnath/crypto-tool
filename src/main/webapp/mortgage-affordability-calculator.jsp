<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mortgage Affordability Calculator (Global) – How Much House Can I Afford?</title>
    <meta name="description" content="Estimate how much house you can afford anywhere in the world. Uses front-end and back-end DTI, interest rate, taxes, insurance, HOA, and down payment to compute the maximum home price and monthly payment breakdown.">
    <meta name="keywords" content="mortgage affordability calculator, how much house can I afford, home affordability, DTI, global mortgage calculator, loan affordability">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Mortgage Affordability Calculator (Global)",
      "applicationCategory": "FinanceApplication",
      "description": "Estimate affordable home price using income, DTI, rate, taxes, insurance, and HOA with global currency support.",
      "url": "https://8gwifi.org/mortgage-affordability-calculator.jsp",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Mortgage Affordability Calculator (Global)</h1>
    <p>Estimate the maximum home price you can afford based on your income, debt-to-income ratios (DTI), down payment, interest rate, property taxes, insurance, and HOA fees.</p>

    <form id="ma-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Income & Debt</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="annualIncome">Gross Annual Income</label>
                            <input type="number" class="form-control" id="annualIncome" value="120000">
                        </div>
                        <div class="form-group">
                            <label for="monthlyDebts">Existing Monthly Debt Payments</label>
                            <input type="number" class="form-control" id="monthlyDebts" value="500">
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="frontDTI">Front-end DTI (%)</label>
                                <input type="number" class="form-control" id="frontDTI" value="28" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="backDTI">Back-end DTI (%)</label>
                                <input type="number" class="form-control" id="backDTI" value="36" step="0.1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="currencyCode">Currency</label>
                                <input type="text" class="form-control" id="currencyCode" value="USD">
                            </div>
                            <div class="form-group col-6">
                                <label for="rate">Interest Rate (% p.a.)</label>
                                <input type="number" class="form-control" id="rate" value="7" step="0.1">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="termYears">Loan Term (years)</label>
                            <input type="number" class="form-control" id="termYears" value="30">
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Property Costs</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="downPct">Down Payment (%)</label>
                                <input type="number" class="form-control" id="downPct" value="20" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="taxRatePct">Property Tax Rate (% of price per year)</label>
                                <input type="number" class="form-control" id="taxRatePct" value="1.2" step="0.1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="insAnnual">Home Insurance (per year)</label>
                                <input type="number" class="form-control" id="insAnnual" value="1200">
                            </div>
                            <div class="form-group col-6">
                                <label for="hoaMonthly">HOA (per month)</label>
                                <input type="number" class="form-control" id="hoaMonthly" value="0">
                            </div>
                        </div>
                        <small class="text-muted">Housing cost includes P&I, property tax, insurance, and HOA.</small>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Front-end DTI limits total housing costs. Back-end DTI limits housing plus existing debts.</li>
                        <li>The calculator solves for the maximum affordable home price using your inputs.</li>
                        <li>For comparison, it also estimates affordability using a 15-year term.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Summary</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Max Home Price</strong></div>
                                    <div id="maxPrice" style="font-size:1.25rem;">—</div>
                                    <small class="text-muted">Loan: <span id="loanAmt">—</span>, Down: <span id="downAmt">—</span></small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Monthly Housing Cost (PITI+HOA)</strong></div>
                                    <div id="housingCost" style="font-size:1.25rem;">—</div>
                                    <small class="text-muted">Limiter: <span id="limiter">—</span></small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>P&I</strong></div>
                                    <div id="pi" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Taxes + Insurance + HOA</strong></div>
                                    <div id="tih" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">If allowed housing cost is very low, results may be zero.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Housing Cost vs Allowed</div>
                    <div class="card-body">
                        <canvas id="ma-chart" height="150"></canvas>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Quick Compare (15-year vs 30-year)</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-2">
                                <div class="p-2 border rounded">
                                    <div><strong>Max Price (15-year)</strong></div>
                                    <div id="price15">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-2">
                                <div class="p-2 border rounded">
                                    <div><strong>Max Price (30-year)</strong></div>
                                    <div id="price30">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Assumes same interest rate for comparison.</small>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    var maChart = null;

    function fmtCurr(amount, curr) {
        if (isNaN(amount)) return "—";
        try { return amount.toLocaleString('en-IN', { style: 'currency', currency: curr }); }
        catch (e) { return curr + " " + Number(amount).toLocaleString('en-IN', { maximumFractionDigits: 0 }); }
    }

    function payment(loan, monthlyRate, months) {
        if (loan <= 0) return 0;
        if (monthlyRate <= 0) return loan / months;
        var pow = Math.pow(1 + monthlyRate, months);
        return loan * monthlyRate * pow / (pow - 1);
    }

    function solveMaxPrice(params) {
        var annualIncome = params.annualIncome;
        var monthlyDebts = params.monthlyDebts;
        var front = params.frontDTI / 100.0;
        var back = params.backDTI / 100.0;
        var rateAnnual = params.rate / 100.0;
        var termYears = params.termYears;
        var dpPct = params.downPct / 100.0;
        var taxRate = params.taxRatePct / 100.0;
        var insMonthly = params.insAnnual / 12.0;
        var hoaMonthly = params.hoaMonthly;

        var monthlyGross = annualIncome / 12.0;
        var maxHousingFront = front * monthlyGross;
        var maxHousingBack = back * monthlyGross - monthlyDebts;
        var limiter = "—";
        var allowedHousing = Math.min(maxHousingFront, maxHousingBack);
        if (allowedHousing === maxHousingFront) limiter = "Front-end DTI";
        if (allowedHousing === maxHousingBack) limiter = "Back-end DTI";

        if (allowedHousing <= 0) {
            return { price: 0, loan: 0, down: 0, pi: 0, tax: 0, ins: 0, hoa: hoaMonthly, total: 0, allowed: 0, limiter: limiter };
        }

        var low = 0, high = Math.max(annualIncome * 10, 1000000);
        for (var i = 0; i < 50; i++) {
            var mid = (low + high) / 2;
            var down = mid * dpPct;
            var loan = Math.max(0, mid - down);
            var mRate = rateAnnual / 12.0;
            var months = termYears * 12;
            var pi = payment(loan, mRate, months);
            var tax = mid * taxRate / 12.0;
            var total = pi + tax + insMonthly + hoaMonthly;

            if (total > allowedHousing) {
                high = mid;
            } else {
                low = mid;
            }
        }
        var price = low;
        var downFinal = price * dpPct;
        var loanFinal = Math.max(0, price - downFinal);
        var piFinal = payment(loanFinal, rateAnnual / 12.0, termYears * 12);
        var taxFinal = price * taxRate / 12.0;
        var totalFinal = piFinal + taxFinal + insMonthly + hoaMonthly;

        return {
            price: price, loan: loanFinal, down: downFinal,
            pi: piFinal, tax: taxFinal, ins: insMonthly, hoa: hoaMonthly,
            total: totalFinal, allowed: allowedHousing, limiter: limiter
        };
    }

    function recalcMA() {
        var params = {
            annualIncome: parseFloat($("#annualIncome").val()) || 0,
            monthlyDebts: parseFloat($("#monthlyDebts").val()) || 0,
            frontDTI: parseFloat($("#frontDTI").val()) || 0,
            backDTI: parseFloat($("#backDTI").val()) || 0,
            rate: parseFloat($("#rate").val()) || 0,
            termYears: parseInt($("#termYears").val()) || 0,
            downPct: parseFloat($("#downPct").val()) || 0,
            taxRatePct: parseFloat($("#taxRatePct").val()) || 0,
            insAnnual: parseFloat($("#insAnnual").val()) || 0,
            hoaMonthly: parseFloat($("#hoaMonthly").val()) || 0,
            currency: ($("#currencyCode").val() || "USD").toUpperCase()
        };

        if (params.annualIncome <= 0 || params.termYears <= 0) {
            $("#maxPrice, #loanAmt, #downAmt, #housingCost, #limiter, #pi, #tih, #price15, #price30").text("—");
            if (maChart) { maChart.destroy(); maChart = null; }
            return;
        }

        var res30 = solveMaxPrice(params);
        $("#maxPrice").text(fmtCurr(res30.price, params.currency));
        $("#loanAmt").text(fmtCurr(res30.loan, params.currency));
        $("#downAmt").text(fmtCurr(res30.down, params.currency));
        $("#housingCost").text(fmtCurr(res30.total, params.currency));
        $("#limiter").text(res30.limiter);
        $("#pi").text(fmtCurr(res30.pi, params.currency));
        $("#tih").text(fmtCurr(res30.tax + res30.ins + res30.hoa, params.currency));

        // Quick compare for 15-year
        var params15 = Object.assign({}, params, { termYears: 15 });
        var res15 = solveMaxPrice(params15);
        $("#price15").text(fmtCurr(res15.price, params.currency));
        $("#price30").text(fmtCurr(res30.price, params.currency));

        // Chart: Allowed vs Components
        if (maChart) maChart.destroy();
        var ctx = document.getElementById("ma-chart").getContext("2d");
        maChart = new Chart(ctx, {
            type: "bar",
            data: {
                labels: ["Allowed Housing", "Actual Total"],
                datasets: [
                    {
                        label: "P&I",
                        data: [0, res30.pi],
                        backgroundColor: "rgba(21,101,192,0.7)",
                        stack: "stack1"
                    },
                    {
                        label: "Taxes",
                        data: [0, res30.tax],
                        backgroundColor: "rgba(198,40,40,0.7)",
                        stack: "stack1"
                    },
                    {
                        label: "Insurance",
                        data: [0, res30.ins],
                        backgroundColor: "rgba(255,167,38,0.7)",
                        stack: "stack1"
                    },
                    {
                        label: "HOA",
                        data: [0, res30.hoa],
                        backgroundColor: "rgba(0,121,107,0.7)",
                        stack: "stack1"
                    },
                    {
                        label: "Allowed",
                        data: [res30.allowed, 0],
                        backgroundColor: "rgba(76,175,80,0.5)",
                        stack: "stack2"
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: "top" }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: "Monthly Amount" }
                    }
                }
            }
        });
    }

    $("#annualIncome, #monthlyDebts, #frontDTI, #backDTI, #rate, #termYears, #downPct, #taxRatePct, #insAnnual, #hoaMonthly, #currencyCode")
        .on("input", recalcMA);

    // Initial calculation
    recalcMA();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
