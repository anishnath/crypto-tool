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
                    <div class="card-body">
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
                        <small class="text-muted">Consult your doctor for personalized guidance; this is an estimate.</small>
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

    function calcBMI() {
        var h = getHeightMeters();
        var w = getWeightKg();
        if (h <= 0 || w <= 0) {
            $("#bmiVal, #bmiCat, #idealRange, #bfVal, #planVal").text("—");
            return;
        }
        var b = w / (h * h);
        $("#bmiVal").text(b.toFixed(1));
        $("#bmiCat").text(bmiCategory(b));

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
