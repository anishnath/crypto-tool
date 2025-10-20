<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Age Calculator & Milestone Tracker</title>
    <meta name="description" content="Calculate your exact age in years, months, days, and hours. See next birthday countdown, age difference, and life expectancy milestones.">
    <meta name="keywords" content="age calculator, next birthday, age difference, life expectancy, milestone tracker">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Age Calculator & Milestone Tracker",
      "applicationCategory": "LifestyleApplication",
      "description": "Accurate age breakdown with next birthday countdown and milestones.",
      "url": "https://8gwifi.org/age-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Age Calculator & Milestone Tracker</h1>
    <p>Enter your date of birth to see a precise age breakdown, next birthday countdown, age differences, and key milestones.</p>

    <form id="age-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="dob">Date of Birth</label>
                            <input type="date" class="form-control" id="dob">
                        </div>
                        <div class="form-group">
                            <label for="compareDob">Compare with (optional)</label>
                            <input type="date" class="form-control" id="compareDob" placeholder="Partner/friend DOB">
                            <small class="text-muted">Shows age difference</small>
                        </div>
                        <div class="form-group">
                            <label for="expectancy">Life Expectancy (years)</label>
                            <input type="number" class="form-control" id="expectancy" value="80">
                            <small class="text-muted">Simple estimator to see projected milestones</small>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Calculations use your browser’s current time and calendar awareness.</li>
                        <li>Life expectancy is indicative; consult official statistics for your region and health profile.</li>
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
                                    <div><strong>Exact Age</strong></div>
                                    <div id="ageBreak" style="font-size:1.1rem;">—</div>
                                    <small id="ageHours" class="text-muted d-block">—</small>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Next Birthday</strong></div>
                                    <div id="nextBday" style="font-size:1.1rem;">—</div>
                                    <small id="bdayCount" class="text-muted d-block">—</small>
                                </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Age Difference</strong></div>
                                    <div id="diffOut" style="font-size:1.1rem;">—</div>
                                </div>
                            </div>
                            <div class="col-md-6 mb-3">
                                <div class="p-3 border rounded">
                                    <div><strong>Life Expectancy</strong></div>
                                    <div id="lifeOut" style="font-size:1.1rem;">—</div>
                                    <small id="lifePct" class="text-muted d-block">—</small>
                                </div>
                            </div>
                        </div>

                        <small class="text-muted">Times are approximate; daylight saving and leap years are handled automatically.</small>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Milestones</div>
                    <div class="card-body">
                        <ul id="milestones" class="mb-0"></ul>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function daysInMonth(y, m){ return new Date(y, m+1, 0).getDate(); }

function calcAgeParts(dob, now){
  var y = now.getFullYear() - dob.getFullYear();
  var m = now.getMonth() - dob.getMonth();
  var d = now.getDate() - dob.getDate();
  if (d < 0){
    m -= 1;
    d += daysInMonth(now.getFullYear(), (now.getMonth()-1+12)%12);
  }
  if (m < 0){
    y -= 1; m += 12;
  }
  return { years:y, months:m, days:d };
}

function nextBirthday(dob, now){
  var nb = new Date(now.getFullYear(), dob.getMonth(), dob.getDate());
  if (nb < now) nb = new Date(now.getFullYear()+1, dob.getMonth(), dob.getDate());
  return nb;
}

function formatDiff(ms){
  var s = Math.floor(ms/1000);
  var d = Math.floor(s/(3600*24)); s -= d*3600*24;
  var h = Math.floor(s/3600); s -= h*3600;
  var m = Math.floor(s/60);
  return d + " days " + h + " hours " + m + " minutes";
}

function diffYMD(a, b){
  if (b < a) { var t=a; a=b; b=t; }
  return calcAgeParts(a, b);
}

function addDays(d, n){ var x = new Date(d); x.setDate(x.getDate()+n); return x; }

function render(){
  var dobStr = document.getElementById("dob").value;
  if (!dobStr){
    document.getElementById("ageBreak").textContent = "—";
    document.getElementById("ageHours").textContent = "—";
    document.getElementById("nextBday").textContent = "—";
    document.getElementById("bdayCount").textContent = "—";
    document.getElementById("diffOut").textContent = "—";
    document.getElementById("lifeOut").textContent = "—";
    document.getElementById("lifePct").textContent = "—";
    document.getElementById("milestones").innerHTML = "";
    return;
  }
  var dob = new Date(dobStr + "T00:00:00");
  var now = new Date();

  // Exact age
  var parts = calcAgeParts(dob, now);
  var totalMs = now - dob;
  var totalHours = Math.floor(totalMs / (1000*3600));
  document.getElementById("ageBreak").textContent = parts.years + " years, " + parts.months + " months, " + parts.days + " days";
  document.getElementById("ageHours").textContent = totalHours.toLocaleString('en-IN') + " hours old";

  // Next birthday
  var nb = nextBirthday(dob, now);
  document.getElementById("nextBday").textContent = nb.toISOString().slice(0,10);
  document.getElementById("bdayCount").textContent = formatDiff(nb - now) + " remaining";

  // Age difference
  var cmpStr = document.getElementById("compareDob").value;
  if (cmpStr){
    var cmp = new Date(cmpStr + "T00:00:00");
    var dparts = diffYMD(dob, cmp);
    document.getElementById("diffOut").textContent = dparts.years + "y " + dparts.months + "m " + dparts.days + "d";
  } else {
    document.getElementById("diffOut").textContent = "—";
  }

  // Life expectancy
  var exp = parseFloat(document.getElementById("expectancy").value) || 80;
  var lifeEnd = new Date(dob.getFullYear() + Math.floor(exp), dob.getMonth(), dob.getDate());
  var leftParts = calcAgeParts(now, lifeEnd);
  var pct = Math.min(100, Math.max(0, (parts.years/exp)*100));
  document.getElementById("lifeOut").textContent = "Projected " + lifeEnd.toISOString().slice(0,10) + " (" + leftParts.years + "y " + leftParts.months + "m left)";
  document.getElementById("lifePct").textContent = pct.toFixed(1) + "% of " + exp + " years";

  // Milestones
  var ml = [];
  // birthdays
  [10, 18, 21, 25, 30, 40, 50, 60, 65].forEach(function(age){
    var dt = new Date(dob.getFullYear()+age, dob.getMonth(), dob.getDate());
    if (dt >= now) ml.push("Turn " + age + ": " + dt.toISOString().slice(0,10));
  });
  // 10,000 days old
  var d10k = addDays(dob, 10000);
  if (d10k >= now) ml.push("10,000th day: " + d10k.toISOString().slice(0,10));
  // 1 billion seconds (approx 31.7 years)
  var s1b = new Date(dob.getTime() + 1e9*1000);
  if (s1b >= now) ml.push("1,000,000,000 seconds: " + s1b.toISOString().slice(0,10));

  document.getElementById("milestones").innerHTML = ml.map(function(x){ return "<li>"+x+"</li>"; }).join("");
}

document.getElementById("dob").addEventListener("change", render);
document.getElementById("compareDob").addEventListener("change", render);
document.getElementById("expectancy").addEventListener("input", render);

// init
(function(){
  // prefill dob (optional none)
  render();
})();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
