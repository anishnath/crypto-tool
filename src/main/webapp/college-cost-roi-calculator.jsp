<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Cost & ROI Calculator (Global) – Tuition, Loans, Payback & NPV</title>
    <meta name="description" content="Estimate total college cost with inflation, scholarships, and contributions. Model student loans, monthly payments, salary after graduation, payback period, and NPV vs an alternative path.">
    <meta name="keywords" content="college cost calculator, college roi calculator, student loan calculator, payback period, npv degree, return on education, higher education cost">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "College Cost & ROI Calculator",
      "applicationCategory": "FinanceApplication",
      "description": "Estimate college cost, student loans, payback period, and NPV vs alternative career option.",
      "url": "https://8gwifi.org/college-cost-roi-calculator.jsp",
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
    <h1 class="mb-4">College Cost & ROI Calculator</h1>
    <p>Estimate the true cost of college with inflation, scholarships, and contributions; project loans and monthly payments; and compare earnings to an alternate path to see payback and NPV.</p>

    <form id="ccr-form">
        <div class="row">
            <div class="col-lg-5">

                <div class="card mb-3">
                    <div class="card-header">Costs (per year, starting year)</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="tuitionYear">Tuition & Fees</label>
                                <input type="number" class="form-control" id="tuitionYear" value="15000">
                            </div>
                            <div class="form-group col-6">
                                <label for="roomBoardYear">Room & Board</label>
                                <input type="number" class="form-control" id="roomBoardYear" value="12000">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="otherCostYear">Other Costs</label>
                                <input type="number" class="form-control" id="otherCostYear" value="3000">
                            </div>
                            <div class="form-group col-6">
                                <label for="inflationCost">Cost Inflation (% p.a.)</label>
                                <input type="number" class="form-control" id="inflationCost" value="5" step="0.1">
                            </div>
                        </div>
                        <small class="text-muted">Costs will inflate annually over the degree duration.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Scholarships & Contributions (per year)</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="scholarshipYear">Scholarships/Grants</label>
                                <input type="number" class="form-control" id="scholarshipYear" value="5000">
                            </div>
                            <div class="form-group col-6">
                                <label for="parentContributionYear">Parental/Other Contributions</label>
                                <input type="number" class="form-control" id="parentContributionYear" value="2000">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="yearsDegree">Degree Length (years)</label>
                            <input type="number" class="form-control" id="yearsDegree" value="4">
                        </div>
                        <small class="text-muted">Net annual cost = (Tuition + Room & Board + Other) − Scholarships − Contributions.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Loans & Earnings</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="loanRate">Student Loan Rate (% p.a.)</label>
                                <input type="number" class="form-control" id="loanRate" value="6" step="0.1">
                            </div>
                            <div class="form-group col-6">
                                <label for="loanTermYears">Loan Term (years)</label>
                                <input type="number" class="form-control" id="loanTermYears" value="10">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="startSalaryDeg">Starting Salary (with degree)</label>
                                <input type="number" class="form-control" id="startSalaryDeg" value="45000">
                            </div>
                            <div class="form-group col-6">
                                <label for="salaryGrowthDeg">Salary Growth (% p.a.)</label>
                                <input type="number" class="form-control" id="salaryGrowthDeg" value="5" step="0.1">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="startSalaryAlt">Starting Salary (alternate path)</label>
                                <input type="number" class="form-control" id="startSalaryAlt" value="30000">
                            </div>
                            <div class="form-group col-6">
                                <label for="salaryGrowthAlt">Alt Salary Growth (% p.a.)</label>
                                <input type="number" class="form-control" id="salaryGrowthAlt" value="3" step="0.1">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="discountRate">Discount Rate for NPV (% p.a.)</label>
                            <input type="number" class="form-control" id="discountRate" value="5" step="0.1">
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Loan balance accrues interest during study and capitalizes at graduation; payments start post-graduation for the chosen loan term.</li>
                        <li>Payback period is when cumulative earnings premium exceeds total college outlays.</li>
                        <li>NPV compares the discounted earnings premium minus loan payments to the alternative path.</li>
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
                                    <div><strong>Total 4-year Cost (nominal)</strong></div>
                                    <div id="totalCost" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Scholarships: <span id="totalScholarships">—</span></small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Loan at Graduation</strong></div>
                                    <div id="loanAtGrad" style="font-size:1.2rem;">—</div>
                                    <small class="text-muted">Monthly payment: <span id="loanEmi">—</span></small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Payback Year</strong></div>
                                    <div id="paybackYear" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>NPV of Degree vs Alternative</strong></div>
                                    <div id="npvValue" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">NPV discounted at your chosen rate; estimates vary with assumptions.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Cumulative Net Benefit Over Time</div>
                    <div class="card-body">
                        <canvas id="ccr-chart" height="160"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <div class="mt-4">
        <h4>Year-wise Breakdown</h4>
        <div style="max-height: 420px; overflow-y: auto;">
            <table class="table table-striped">
                <thead style="position: sticky; top: 0; background-color: white;">
                    <tr>
                        <th>Year</th>
                        <th>Cost (net)</th>
                        <th>Loan Balance</th>
                        <th>Salary (Degree)</th>
                        <th>Salary (Alt)</th>
                        <th>Loan Payment</th>
                        <th>Cumulative Net Benefit</th>
                    </tr>
                </thead>
                <tbody id="ccr-table"></tbody>
            </table>
        </div>
    </div>

<script>
    var ccrChart = null;

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

    function recalcCCR() {
        var curr = "USD";

        // Inputs
        var tuitionYear = parseFloat($("#tuitionYear").val()) || 0;
        var roomBoardYear = parseFloat($("#roomBoardYear").val()) || 0;
        var otherCostYear = parseFloat($("#otherCostYear").val()) || 0;
        var inflationCost = (parseFloat($("#inflationCost").val()) || 0) / 100.0;

        var scholarshipYear = parseFloat($("#scholarshipYear").val()) || 0;
        var parentContributionYear = parseFloat($("#parentContributionYear").val()) || 0;
        var yearsDegree = parseInt($("#yearsDegree").val()) || 0;

        var loanRate = (parseFloat($("#loanRate").val()) || 0) / 100.0;
        var loanTermYears = parseInt($("#loanTermYears").val()) || 0;

        var startSalaryDeg = parseFloat($("#startSalaryDeg").val()) || 0;
        var salaryGrowthDeg = (parseFloat($("#salaryGrowthDeg").val()) || 0) / 100.0;
        var startSalaryAlt = parseFloat($("#startSalaryAlt").val()) || 0;
        var salaryGrowthAlt = (parseFloat($("#salaryGrowthAlt").val()) || 0) / 100.0;
        var discountRate = (parseFloat($("#discountRate").val()) || 0) / 100.0;

        if (yearsDegree <= 0) {
            $("#totalCost, #totalScholarships, #loanAtGrad, #loanEmi, #paybackYear, #npvValue").text("—");
            $("#ccr-table").html("");
            if (ccrChart) { ccrChart.destroy(); ccrChart = null; }
            return;
        }

        // 1) Accumulate annual costs with inflation and scholarships/contributions; loan accrues during study
        var totalCostNominal = 0;
        var totalScholarships = 0;
        var loanBalance = 0;

        for (var y = 1; y <= yearsDegree; y++) {
            var factor = Math.pow(1 + inflationCost, y - 1);
            var grossCost = (tuitionYear + roomBoardYear + otherCostYear) * factor;
            var schol = scholarshipYear; // assume flat grants per year
            var contrib = parentContributionYear;
            var netCost = Math.max(0, grossCost - schol - contrib);

            totalCostNominal += grossCost;
            totalScholarships += schol;

            // Loan accrues: add net cost, then apply interest annually (compounded monthly approximated yearly)
            loanBalance = (loanBalance + netCost) * (1 + loanRate);
        }

        // 2) At graduation: loan capitalized. Compute monthly payment
        var loanAtGrad = loanBalance;
        var emi = payment(loanAtGrad, loanRate / 12.0, loanTermYears * 12);

        $("#totalCost").text(fmtCurr(totalCostNominal, curr));
        $("#totalScholarships").text(fmtCurr(totalScholarships, curr));
        $("#loanAtGrad").text(fmtCurr(loanAtGrad, curr));
        $("#loanEmi").text(fmtCurr(emi, curr));

        // 3) Earnings paths, payback, and NPV; simulate 30 years after graduation
        var yearsAfter = 30;
        var cumNetBenefit = 0;
        var payback = null;

        var labels = [];
        var benefitSeries = [];
        var tableHTML = "";

        var degSalary = startSalaryDeg;
        var altSalary = startSalaryAlt;
        var loanRem = loanAtGrad;

        // Pre-graduation years: opportunity cost (foregone alt salary)
        for (var y0 = 1; y0 <= yearsDegree; y0++) {
            var altDuring = startSalaryAlt * Math.pow(1 + salaryGrowthAlt, y0 - 1);
            cumNetBenefit -= altDuring; // alternative earns while degree path studies
            labels.push("Year " + y0 + " (Study)");
            benefitSeries.push(cumNetBenefit);
            tableHTML += "<tr>" +
                "<td>" + y0 + " (Study)" + "</td>" +
                "<td>" + fmtCurr(0, curr) + "</td>" +
                "<td>" + fmtCurr(loanAtGrad * Math.pow(1 + loanRate, yearsDegree - y0 + 1), curr) + "</td>" +
                "<td>" + fmtCurr(0, curr) + "</td>" +
                "<td>" + fmtCurr(altDuring, curr) + "</td>" +
                "<td>" + fmtCurr(0, curr) + "</td>" +
                "<td>" + fmtCurr(cumNetBenefit, curr) + "</td>" +
                "</tr>";
        }

        // Post-graduation years
        for (var y2 = 1; y2 <= yearsAfter; y2++) {
            var yearNum = yearsDegree + y2;

            // Salaries for this year
            if (y2 > 1) {
                degSalary = degSalary * (1 + salaryGrowthDeg);
                altSalary = altSalary * (1 + salaryGrowthAlt);
            }

            // Loan payment for the year (12*emi), and reduce remaining balance
            var loanPayYear = Math.min(emi * 12, loanRem * (1 + loanRate)); // cap if near payoff
            // Approximate amortization: apply interest then subtract payments
            loanRem = Math.max(0, loanRem * (1 + loanRate) - loanPayYear);

            var premium = degSalary - altSalary; // earnings premium due to degree
            var netYear = premium - loanPayYear;

            cumNetBenefit += netYear;

            labels.push("Year " + yearNum);
            benefitSeries.push(cumNetBenefit);

            tableHTML += "<tr>" +
                "<td>" + yearNum + "</td>" +
                "<td>" + fmtCurr(0, curr) + "</td>" +
                "<td>" + fmtCurr(loanRem, curr) + "</td>" +
                "<td>" + fmtCurr(degSalary, curr) + "</td>" +
                "<td>" + fmtCurr(altSalary, curr) + "</td>" +
                "<td>" + fmtCurr(loanPayYear, curr) + "</td>" +
                "<td>" + fmtCurr(cumNetBenefit, curr) + "</td>" +
                "</tr>";

            if (payback === null && cumNetBenefit >= 0) {
                payback = yearNum;
            }
        }

        $("#paybackYear").text(payback ? payback : "Not within horizon");

        // NPV of degree premium minus loan payments vs alternative
        var npv = 0;
        // Alternative earns during study; degree does not
        for (var y = 1; y <= yearsDegree; y++) {
            var altEarn = startSalaryAlt * Math.pow(1 + salaryGrowthAlt, y - 1);
            npv += (-altEarn) / Math.pow(1 + discountRate, y); // opportunity cost negative
        }
        // Post-grad
        for (var y = 1; y <= yearsAfter; y++) {
            var t = yearsDegree + y;
            var degE = startSalaryDeg * Math.pow(1 + salaryGrowthDeg, y - 1);
            var altE = startSalaryAlt * Math.pow(1 + salaryGrowthAlt, y - 1);
            var loanPay = Math.min(emi * 12, loanAtGrad * Math.pow(1 + loanRate, y) - Math.max(0, loanAtGrad * Math.pow(1 + loanRate, y - 1) - (emi * 12))); // rough
            var cash = (degE - altE) - (emi * 12); // use emi*12 as annual outflow approximation
            npv += cash / Math.pow(1 + discountRate, t);
        }
        $("#npvValue").text(fmtCurr(npv, curr));

        $("#ccr-table").html(tableHTML);

        if (ccrChart) ccrChart.destroy();
        var ctx = document.getElementById("ccr-chart").getContext("2d");
        ccrChart = new Chart(ctx, {
            type: "line",
            data: {
                labels: labels,
                datasets: [
                    { label: "Cumulative Net Benefit", data: benefitSeries, borderColor: "#1565c0", backgroundColor: "rgba(21,101,192,0.1)", tension: 0.15 }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: "top" } },
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: "Amount" }
                    },
                    x: { title: { display: true, text: "Year" } }
                }
            }
        });
    }

    $("#tuitionYear, #roomBoardYear, #otherCostYear, #inflationCost, #scholarshipYear, #parentContributionYear, #yearsDegree, #loanRate, #loanTermYears, #startSalaryDeg, #salaryGrowthDeg, #startSalaryAlt, #salaryGrowthAlt, #discountRate")
        .on("input", recalcCCR);

    // Initial
    recalcCCR();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
