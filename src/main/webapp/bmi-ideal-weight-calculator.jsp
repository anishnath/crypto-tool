<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BMI & Ideal Weight Calculator – Body Mass Index, Category, Ideal Range</title>
    <meta name="description" content="Calculate your BMI, category, and ideal weight range. Supports metric and imperial units. Includes optional body fat % estimate using age and gender.">
    <meta name="keywords" content="bmi calculator, body mass index calculator, ideal weight calculator, body fat estimate">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "BMI & Ideal Weight Calculator",
      "applicationCategory": "HealthApplication",
      "description": "Calculate BMI, category, and ideal weight range with metric/imperial units and optional body fat % estimate.",
      "url": "https://8gwifi.org/bmi-ideal-weight-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">BMI & Ideal Weight Calculator</h1>
    <p>Compute your body mass index (BMI), BMI category, and ideal weight range. Switch between metric and imperial. Optionally estimate body fat %.</p>

    <form id="bmi-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="units">Units</label>
                            <select id="units" class="form-control">
                                <option value="metric" selected>Metric (cm, kg)</option>
                                <option value="imperial">Imperial (ft/in, lbs)</option>
                            </select>
                        </div>

                        <div id="metricBlock">
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="heightCm">Height (cm)</label>
                                    <input type="number" class="form-control" id="heightCm" value="170">
                                </div>
                                <div class="form-group col-6">
                                    <label for="weightKg">Weight (kg)</label>
                                    <input type="number" class="form-control" id="weightKg" value="70">
                                </div>
                            </div>
                        </div>

                        <div id="imperialBlock" class="d-none">
                            <div class="form-row">
                                <div class="form-group col-4">
                                    <label for="heightFt">Height (ft)</label>
                                    <input type="number" class="form-control" id="heightFt" value="5">
                                </div>
                                <div class="form-group col-4">
                                    <label for="heightIn">Height (in)</label>
                                    <input type="number" class="form-control" id="heightIn" value="7">
                                </div>
                                <div class="form-group col-4">
                                    <label for="weightLbs">Weight (lbs)</label>
                                    <input type="number" class="form-control" id="weightLbs" value="154">
                                </div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="age">Age</label>
                                <input type="number" class="form-control" id="age" value="30">
                            </div>
                            <div class="form-group col-6">
                                <label for="gender">Gender</label>
                                <select id="gender" class="form-control">
                                    <option value="male" selected>Male</option>
                                    <option value="female">Female</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>BMI categories (WHO): Underweight &lt;18.5, Normal 18.5–24.9, Overweight 25–29.9, Obese ≥30.</li>
                        <li>Ideal weight range uses BMI 18.5–24.9 on your height.</li>
                        <li>Body fat % uses the Deurenberg estimate from BMI, age, and gender.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Results</div>
                    <div class="card-body" id="resultsSection">
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>BMI</strong></div>
                                    <div id="bmiVal" style="font-size:1.3rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Category</strong></div>
                                    <div id="bmiCat" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Ideal Weight</strong></div>
                                    <div id="idealRange" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Body Fat % (est.)</strong></div>
                                    <div id="bfVal" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Weekly Plan (±0.5 kg)</strong></div>
                                    <div id="planVal" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>

                        <!-- BMI Gauge Chart -->
                        <div class="mt-3">
                            <h6 class="text-center">BMI Spectrum</h6>
                            <canvas id="bmiGauge" height="200"></canvas>
                        </div>

                        <small class="text-muted">Consult your doctor for personalized guidance; this is an estimate.</small>
                    </div>
                </div>

                <!-- Export and Share Buttons -->
                <div class="card mb-3">
                    <div class="card-header">Export & Share</div>
                    <div class="card-body">
                        <div class="btn-group d-flex flex-wrap" role="group">
                            <button type="button" class="btn btn-primary mb-2 mr-2" onclick="exportPDF()">
                                <i class="fa fa-file-pdf-o"></i> Export as PDF
                            </button>
                            <button type="button" class="btn btn-success mb-2 mr-2" onclick="exportCSV()">
                                <i class="fa fa-file-excel-o"></i> Export as CSV
                            </button>
                            <button type="button" class="btn btn-info mb-2 mr-2" onclick="shareResults()">
                                <i class="fa fa-share-alt"></i> Share Results
                            </button>
                            <button type="button" class="btn btn-secondary mb-2" onclick="copyToClipboard()">
                                <i class="fa fa-clipboard"></i> Copy to Clipboard
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    function toggleUnits() {
        var u = $("#units").val();
        if (u === "metric") { $("#metricBlock").removeClass("d-none"); $("#imperialBlock").addClass("d-none"); }
        else { $("#metricBlock").addClass("d-none"); $("#imperialBlock").removeClass("d-none"); }
        calcBMI();
    }

    function getHeightMeters() {
        var u = $("#units").val();
        if (u === "metric") {
            var cm = parseFloat($("#heightCm").val()) || 0;
            return cm / 100.0;
        } else {
            var ft = parseFloat($("#heightFt").val()) || 0;
            var inch = parseFloat($("#heightIn").val()) || 0;
            var totalIn = ft * 12 + inch;
            return totalIn * 0.0254;
        }
    }

    function getWeightKg() {
        var u = $("#units").val();
        if (u === "metric") return parseFloat($("#weightKg").val()) || 0;
        var lbs = parseFloat($("#weightLbs").val()) || 0;
        return lbs * 0.45359237;
    }

    function bmiCategory(b) {
        if (b < 18.5) return "Underweight";
        if (b < 25) return "Normal";
        if (b < 30) return "Overweight";
        return "Obese";
    }

    function idealWeightRange(hMeters) {
        // Using BMI 18.5 to 24.9
        var min = 18.5 * hMeters * hMeters;
        var max = 24.9 * hMeters * hMeters;
        return { min: min, max: max };
    }

    var bmiChart = null;

    function getBMIColor(b) {
        if (b < 18.5) return '#3498db'; // Blue - Underweight
        if (b < 25) return '#2ecc71';   // Green - Normal
        if (b < 30) return '#f39c12';   // Orange - Overweight
        return '#e74c3c';               // Red - Obese
    }

    function updateBMIGauge(bmi) {
        var ctx = document.getElementById('bmiGauge').getContext('2d');

        // Destroy previous chart if exists
        if (bmiChart) {
            bmiChart.destroy();
        }

        // Create gradient for background
        var data = {
            labels: ['Underweight', 'Normal', 'Overweight', 'Obese'],
            datasets: [{
                data: [18.5, 6.4, 5.1, 10], // 18.5, 18.5-24.9, 25-29.9, 30-40
                backgroundColor: ['#3498db', '#2ecc71', '#f39c12', '#e74c3c'],
                borderWidth: 2,
                borderColor: '#fff'
            }]
        };

        var options = {
            responsive: true,
            maintainAspectRatio: true,
            circumference: Math.PI,
            rotation: Math.PI,
            cutout: '70%',
            plugins: {
                legend: {
                    display: true,
                    position: 'bottom'
                },
                tooltip: {
                    enabled: true,
                    callbacks: {
                        label: function(context) {
                            var label = context.label || '';
                            var ranges = ['<18.5', '18.5-24.9', '25-29.9', '≥30'];
                            return label + ': ' + ranges[context.dataIndex];
                        }
                    }
                }
            }
        };

        bmiChart = new Chart(ctx, {
            type: 'doughnut',
            data: data,
            options: options,
            plugins: [{
                afterDraw: function(chart) {
                    var ctx = chart.ctx;
                    ctx.save();

                    // Draw BMI value in center
                    var centerX = (chart.chartArea.left + chart.chartArea.right) / 2;
                    var centerY = (chart.chartArea.top + chart.chartArea.bottom) / 2 + 20;

                    ctx.font = 'bold 24px Arial';
                    ctx.fillStyle = getBMIColor(bmi);
                    ctx.textAlign = 'center';
                    ctx.textBaseline = 'middle';
                    ctx.fillText(bmi.toFixed(1), centerX, centerY);

                    ctx.font = '14px Arial';
                    ctx.fillStyle = '#666';
                    ctx.fillText('BMI', centerX, centerY - 25);

                    ctx.restore();
                }
            }]
        });
    }

    function calcBMI() {
        var h = getHeightMeters();
        var w = getWeightKg();
        if (h <= 0 || w <= 0) {
            $("#bmiVal, #bmiCat, #idealRange, #bfVal, #planVal").text("—");
            return;
        }
        var b = w / (h * h);
        $("#bmiVal").text(b.toFixed(1));

        var category = bmiCategory(b);
        $("#bmiCat").text(category);
        $("#bmiCat").css('color', getBMIColor(b));

        var r = idealWeightRange(h);
        $("#idealRange").text(r.min.toFixed(1) + " kg – " + r.max.toFixed(1) + " kg");

        var age = parseFloat($("#age").val()) || 0;
        var gender = $("#gender").val();
        var sex = (gender === "male") ? 1 : 0;
        var bf = 1.20 * b + 0.23 * age - 10.8 * sex - 5.4;
        $("#bfVal").text(Math.max(0, bf).toFixed(1) + " %");

        // Weekly plan to move toward mid of ideal range
        var mid = (r.min + r.max) / 2;
        var delta = (w - mid);
        var plan = "";
        if (Math.abs(delta) < 1) plan = "Close to ideal range";
        else if (delta > 0) plan = "Target −0.5 kg/week for ~" + Math.ceil(delta / 0.5) + " weeks";
        else plan = "Target +0.5 kg/week for ~" + Math.ceil(Math.abs(delta) / 0.5) + " weeks";
        $("#planVal").text(plan);

        // Update BMI Gauge
        updateBMIGauge(b);
    }

    // Export to PDF
    function exportPDF() {
        var bmiVal = $("#bmiVal").text();
        if (bmiVal === "—") {
            alert("Please calculate BMI first!");
            return;
        }

        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        // Add title
        doc.setFontSize(20);
        doc.setTextColor(40, 40, 40);
        doc.text("BMI & Ideal Weight Report", 20, 20);

        // Add date
        doc.setFontSize(10);
        doc.setTextColor(100, 100, 100);
        doc.text("Generated: " + new Date().toLocaleString(), 20, 28);

        // Add line
        doc.setDrawColor(200, 200, 200);
        doc.line(20, 32, 190, 32);

        // Add inputs section
        doc.setFontSize(14);
        doc.setTextColor(40, 40, 40);
        doc.text("Inputs", 20, 42);

        doc.setFontSize(11);
        var units = $("#units").val();
        var y = 50;

        if (units === "metric") {
            doc.text("Height: " + $("#heightCm").val() + " cm", 30, y);
            doc.text("Weight: " + $("#weightKg").val() + " kg", 30, y + 7);
        } else {
            doc.text("Height: " + $("#heightFt").val() + "' " + $("#heightIn").val() + "\"", 30, y);
            doc.text("Weight: " + $("#weightLbs").val() + " lbs", 30, y + 7);
        }
        doc.text("Age: " + $("#age").val() + " years", 30, y + 14);
        doc.text("Gender: " + $("#gender").val(), 30, y + 21);

        // Add results section
        y = 82;
        doc.setFontSize(14);
        doc.text("Results", 20, y);

        doc.setFontSize(11);
        y += 8;
        doc.text("BMI: " + $("#bmiVal").text(), 30, y);
        doc.text("Category: " + $("#bmiCat").text(), 30, y + 7);
        doc.text("Ideal Weight Range: " + $("#idealRange").text(), 30, y + 14);
        doc.text("Body Fat %: " + $("#bfVal").text(), 30, y + 21);
        doc.text("Weekly Plan: " + $("#planVal").text(), 30, y + 28);

        // Add disclaimer
        y += 42;
        doc.setFontSize(9);
        doc.setTextColor(150, 150, 150);
        doc.text("Disclaimer: This is an estimate. Consult your doctor for personalized guidance.", 20, y, { maxWidth: 170 });

        // Add footer
        doc.setFontSize(8);
        doc.text("Generated by 8gwifi.org/bmi-ideal-weight-calculator.jsp", 20, 280);

        // Save PDF
        doc.save("BMI_Report_" + new Date().toISOString().split('T')[0] + ".pdf");
    }

    // Export to CSV
    function exportCSV() {
        var bmiVal = $("#bmiVal").text();
        if (bmiVal === "—") {
            alert("Please calculate BMI first!");
            return;
        }

        var units = $("#units").val();
        var csv = "BMI & Ideal Weight Report\n";
        csv += "Generated," + new Date().toLocaleString() + "\n\n";
        csv += "INPUTS\n";
        csv += "Metric,Value\n";

        if (units === "metric") {
            csv += "Height (cm)," + $("#heightCm").val() + "\n";
            csv += "Weight (kg)," + $("#weightKg").val() + "\n";
        } else {
            csv += "Height (ft)," + $("#heightFt").val() + "\n";
            csv += "Height (in)," + $("#heightIn").val() + "\n";
            csv += "Weight (lbs)," + $("#weightLbs").val() + "\n";
        }
        csv += "Age," + $("#age").val() + "\n";
        csv += "Gender," + $("#gender").val() + "\n\n";

        csv += "RESULTS\n";
        csv += "Metric,Value\n";
        csv += "BMI," + $("#bmiVal").text() + "\n";
        csv += "Category," + $("#bmiCat").text() + "\n";
        csv += "Ideal Weight Range," + $("#idealRange").text() + "\n";
        csv += "Body Fat %," + $("#bfVal").text() + "\n";
        csv += "Weekly Plan," + $("#planVal").text() + "\n";

        // Download CSV
        var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        var link = document.createElement("a");
        var url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        link.setAttribute("download", "BMI_Report_" + new Date().toISOString().split('T')[0] + ".csv");
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }

    // Share Results
    function shareResults() {
        var bmiVal = $("#bmiVal").text();
        if (bmiVal === "—") {
            alert("Please calculate BMI first!");
            return;
        }

        var shareText = "My BMI Results:\n";
        shareText += "BMI: " + $("#bmiVal").text() + "\n";
        shareText += "Category: " + $("#bmiCat").text() + "\n";
        shareText += "Ideal Weight: " + $("#idealRange").text() + "\n";
        shareText += "\nCalculate yours at: " + window.location.href;

        if (navigator.share) {
            navigator.share({
                title: 'BMI Calculator Results',
                text: shareText
            }).then(() => {
                console.log('Shared successfully');
            }).catch((error) => {
                console.log('Error sharing:', error);
                copyToClipboard();
            });
        } else {
            // Fallback for browsers that don't support Web Share API
            copyToClipboard();
        }
    }

    // Copy to Clipboard
    function copyToClipboard() {
        var bmiVal = $("#bmiVal").text();
        if (bmiVal === "—") {
            alert("Please calculate BMI first!");
            return;
        }

        var copyText = "BMI Results:\n";
        copyText += "═══════════════\n";
        copyText += "BMI: " + $("#bmiVal").text() + "\n";
        copyText += "Category: " + $("#bmiCat").text() + "\n";
        copyText += "Ideal Weight Range: " + $("#idealRange").text() + "\n";
        copyText += "Body Fat %: " + $("#bfVal").text() + "\n";
        copyText += "Weekly Plan: " + $("#planVal").text() + "\n";
        copyText += "═══════════════\n";
        copyText += "Calculate yours at: " + window.location.href;

        var tempInput = document.createElement("textarea");
        tempInput.value = copyText;
        document.body.appendChild(tempInput);
        tempInput.select();
        document.execCommand("copy");
        document.body.removeChild(tempInput);

        alert("Results copied to clipboard!");
    }

    $("#units, #heightCm, #weightKg, #heightFt, #heightIn, #weightLbs, #age, #gender").on("input change", calcBMI);
    $("#units").on("change", toggleUnits);

    // Init
    toggleUnits();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
