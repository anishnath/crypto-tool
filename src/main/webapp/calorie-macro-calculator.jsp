<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daily Calorie Needs & Macro Calculator – BMR, TDEE, Macros</title>
    <meta name="description" content="Calculate your daily calorie needs (TDEE) using BMR and activity level. Set a goal to lose, gain, or maintain weight, and get a macro split for protein, carbs, and fats.">
    <meta name="keywords" content="calorie calculator, daily calorie intake, macro calculator, BMR, TDEE">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Daily Calorie Needs & Macro Calculator",
      "applicationCategory": "HealthApplication",
      "description": "Estimate daily calories and macros using BMR, TDEE and goals.",
      "url": "https://8gwifi.org/calorie-macro-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Daily Calorie Needs & Macro Calculator</h1>
    <p>Estimate your daily calories and a balanced macro split based on your BMR, activity level, and goal.</p>

    <form id="cal-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Personal Details</div>
                    <div class="card-body">
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
                        <div class="form-group">
                            <label for="activity">Activity Level</label>
                            <select id="activity" class="form-control">
                                <option value="1.2">Sedentary</option>
                                <option value="1.375">Lightly Active</option>
                                <option value="1.55" selected>Moderately Active</option>
                                <option value="1.725">Very Active</option>
                                <option value="1.9">Extra Active</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="goal">Goal</label>
                            <select id="goal" class="form-control">
                                <option value="maintain" selected>Maintain</option>
                                <option value="lose">Lose Weight</option>
                                <option value="gain">Gain Muscle</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="macroPreset">Macro Split</label>
                            <select id="macroPreset" class="form-control">
                                <option value="40-30-30" selected>40% Carbs / 30% Protein / 30% Fat</option>
                                <option value="50-20-30">50% Carbs / 20% Protein / 30% Fat</option>
                                <option value="30-40-30">30% Carbs / 40% Protein / 30% Fat</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>BMR via Mifflin–St Jeor; TDEE = BMR × activity factor.</li>
                        <li>Goals: lose ~−500 kcal/day; gain ~+300 kcal/day (adjust to taste).</li>
                        <li>Macros convert calories to grams: protein/carbs 4 kcal/g, fat 9 kcal/g.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Results</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>BMR</strong></div>
                                    <div id="bmrVal" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Daily Calories</strong></div>
                                    <div id="calVal" style="font-size:1.2rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-1">
                            <div class="col-md-12 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Macros (g per day)</strong></div>
                                    <div id="macrosVal" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                        </div>
                        <small class="text-muted">Consult a professional for personalized nutrition planning.</small>
                    </div>
                </div>
                <div class="card mb-3">
                    <div class="card-header">Macro Split</div>
                    <div class="card-body">
                        <canvas id="macro-chart" height="140"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    var macroChart = null;

    function calcBMR(age, gender, heightCm, weightKg) {
        if (gender === "male") return 10*weightKg + 6.25*heightCm - 5*age + 5;
        return 10*weightKg + 6.25*heightCm - 5*age - 161;
    }

    function parsePreset(p) {
        var parts = p.split("-");
        return { carbs: parseFloat(parts[0]||0), protein: parseFloat(parts[1]||0), fat: parseFloat(parts[2]||0) };
    }

    function calcCalorie() {
        var age = parseFloat($("#age").val()) || 0;
        var gender = $("#gender").val();
        var height = parseFloat($("#heightCm").val()) || 0;
        var weight = parseFloat($("#weightKg").val()) || 0;
        var activity = parseFloat($("#activity").val()) || 1;
        var goal = $("#goal").val();
        var preset = parsePreset($("#macroPreset").val());

        if (age <= 0 || height <= 0 || weight <= 0) {
            $("#bmrVal, #calVal, #macrosVal").text("—");
            if (macroChart) { macroChart.destroy(); macroChart = null; }
            return;
        }

        var bmr = calcBMR(age, gender, height, weight);
        var tdee = bmr * activity;

        if (goal === "lose") tdee -= 500;
        if (goal === "gain") tdee += 300;

        $("#bmrVal").text(Math.round(bmr) + " kcal");
        $("#calVal").text(Math.round(tdee) + " kcal");

        var cPct = preset.carbs/100.0, pPct = preset.protein/100.0, fPct = preset.fat/100.0;
        var carbsG = (tdee * cPct) / 4.0;
        var proteinG = (tdee * pPct) / 4.0;
        var fatG = (tdee * fPct) / 9.0;

        $("#macrosVal").text("Carbs: " + Math.round(carbsG) + " g, Protein: " + Math.round(proteinG) + " g, Fat: " + Math.round(fatG) + " g");

        if (macroChart) macroChart.destroy();
        var ctx = document.getElementById("macro-chart").getContext("2d");
        macroChart = new Chart(ctx, {
            type: "pie",
            data: {
                labels: ["Carbs", "Protein", "Fat"],
                datasets: [{ data: [preset.carbs, preset.protein, preset.fat], backgroundColor: ["#1565c0","#2e7d32","#f9a825"] }]
            },
            options: { responsive: true, plugins: { legend: { position: "bottom" } } }
        });
    }

    $("#age, #gender, #heightCm, #weightKg, #activity, #goal, #macroPreset").on("input change", calcCalorie);
    calcCalorie();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
