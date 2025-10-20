<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Date Difference Calculator – Days Between Dates, Weeks, Months, Years</title>
    <meta name="description" content="Calculate days, weeks, months, and years between two dates. Toggle weekends to count business days. Includes 'age in days' mode and next milestone hints.">
    <meta name="keywords" content="date calculator, days between dates, date difference, business days, age in days">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Date Difference Calculator",
      "applicationCategory":"ProductivityApplication",
      "description":"Compute days, weeks, months, and years between dates with business-day toggle.",
      "url":"https://8gwifi.org/date-difference-calculator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Date Difference Calculator</h1>
    <p>Find the difference between two dates in days, weeks, months, and years. Optionally exclude weekends to count business days, or switch to "Age in days" mode.</p>

    <form id="date-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="mode">Mode</label>
                            <select id="mode" class="form-control">
                                <option value="diff" selected>Difference between Start and End</option>
                                <option value="age">Age in Days (Start = DOB, End = Today)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="startDate">Start Date</label>
                            <input type="date" class="form-control" id="startDate">
                        </div>
                        <div class="form-group" id="endBlock">
                            <label for="endDate">End Date</label>
                            <input type="date" class="form-control" id="endDate">
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="excludeWeekends">
                            <label class="form-check-label" for="excludeWeekends">Exclude Weekends (Business Days)</label>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Months and years are shown as calendar-based approximations (Y, M, D breakdown).</li>
                        <li>Business days exclude Saturdays and Sundays. Holidays are not considered.</li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Summary</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>Days</strong>: <span id="daysOut">—</span></div>
                            <div><strong>Weeks</strong>: <span id="weeksOut">—</span></div>
                            <div><strong>Months/Years</strong>: <span id="ymdOut">—</span></div>
                            <div><strong>Business Days</strong>: <span id="bizOut">—</span></div>
                        </div>
                        <small class="text-muted d-block mt-2" id="extraOut">—</small>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function parseDate(id){ var v=document.getElementById(id).value; return v? new Date(v+"T00:00:00") : null; }
function setText(id, v){ document.getElementById(id).textContent = v; }

function daysBetween(a,b){ var ms = b - a; return Math.floor(ms/(1000*3600*24)); }
function weeksBetween(a,b){ return (daysBetween(a,b)/7).toFixed(2); }
function ymdBetween(a,b){
  var y = b.getFullYear() - a.getFullYear();
  var m = b.getMonth() - a.getMonth();
  var d = b.getDate() - a.getDate();
  if (d < 0) {
    m -= 1;
    var pm = new Date(b.getFullYear(), b.getMonth(), 0).getDate();
    d += pm;
  }
  if (m < 0) { y -= 1; m += 12; }
  return y+" years, "+m+" months, "+d+" days";
}
function businessDays(a,b){
  var start = new Date(a); var end = new Date(b);
  if (end < start) { var t=start; start=end; end=t; }
  var count=0, cur=new Date(start);
  while (cur <= end){
    var day = cur.getDay();
    if (day !== 0 && day !== 6) count++;
    cur.setDate(cur.getDate()+1);
  }
  // If counting inclusive, adjust; we typically want exclusive of end
  return Math.max(0, count - 1);
}

function onModeChange(){
  var mode = document.getElementById("mode").value;
  document.getElementById("endBlock").style.display = (mode === "diff") ? "" : "none";
  compute();
}

function compute(){
  var mode = document.getElementById("mode").value;
  var exclude = document.getElementById("excludeWeekends").checked;
  var start = parseDate("startDate");
  var end = (mode === "diff") ? parseDate("endDate") : new Date();

  if (!start || (mode === "diff" && !end)){
    setText("daysOut","—"); setText("weeksOut","—"); setText("ymdOut","—"); setText("bizOut","—"); setText("extraOut","—"); return;
  }

  if (end < start){ var t=start; start=end; end=t; }

  var days = daysBetween(start,end);
  var weeks = weeksBetween(start,end);
  var ymd = ymdBetween(start,end);
  var biz = exclude ? businessDays(start,end) : "—";

  setText("daysOut", days.toLocaleString('en-IN'));
  setText("weeksOut", weeks);
  setText("ymdOut", ymd);
  setText("bizOut", biz === "—" ? "—" : biz.toLocaleString('en-IN'));

  var extra = "";
  if (mode === "age"){
    extra = "Age in days: " + days.toLocaleString('en-IN') + ". Next 10,000th day: ";
    var d10k = new Date(start.getTime() + 10000*24*3600*1000);
    if (d10k > end) extra += d10k.toISOString().slice(0,10); else extra += "already passed";
  } else {
    extra = "Difference computed from " + start.toISOString().slice(0,10) + " to " + end.toISOString().slice(0,10) + ".";
  }
  setText("extraOut", extra);
}

document.getElementById("mode").addEventListener("change", onModeChange);
document.getElementById("startDate").addEventListener("change", compute);
document.getElementById("endDate").addEventListener("change", compute);
document.getElementById("excludeWeekends").addEventListener("change", compute);

(function init(){
  var today = new Date();
  var iso = today.toISOString().slice(0,10);
  document.getElementById("startDate").value = iso;
  document.getElementById("endDate").value = iso;
  onModeChange();
})();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
