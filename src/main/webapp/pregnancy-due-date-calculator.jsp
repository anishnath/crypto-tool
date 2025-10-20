<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pregnancy Due Date & Trimester Planner</title>
    <meta name="description" content="Calculate your pregnancy due date from last menstrual period (LMP) or conception date. See trimester breakdown, current week, and key milestones.">
    <meta name="keywords" content="due date calculator, pregnancy calculator, weeks pregnant, trimester calculator">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Pregnancy Due Date & Trimester Planner",
      "applicationCategory": "HealthApplication",
      "description": "Estimate due date, current week, and trimester milestones from LMP or conception date.",
      "url": "https://8gwifi.org/pregnancy-due-date-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Pregnancy Due Date & Trimester Planner</h1>
    <p>Estimate your due date and track your current week with trimester milestones.</p>

    <form id="due-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="lmp">Last Menstrual Period (LMP)</label>
                            <input type="date" class="form-control" id="lmp">
                        </div>
                        <div class="form-group">
                            <label for="conception">Conception Date (optional)</label>
                            <input type="date" class="form-control" id="conception">
                            <small class="text-muted">If given, due date ~ conception + 266 days</small>
                        </div>
                        <div class="form-group">
                            <label for="cycleLen">Average Cycle Length (days)</label>
                            <input type="number" class="form-control" id="cycleLen" value="28">
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Due date by LMP adds 280 days; by conception adds ~266 days.</li>
                        <li>Current week is estimated from LMP unless conception provided.</li>
                        <li>Consult your healthcare provider for confirmation.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Results</div>
                    <div class="card-body">
                        <div class="p-3 border rounded mb-3">
                            <div><strong>Estimated Due Date</strong></div>
                            <div id="dueDate" style="font-size:1.2rem;">—</div>
                            <small class="text-muted">Current Week: <span id="currentWeek">—</span></small>
                        </div>
                        <div>
                            <h5>Trimesters</h5>
                            <ul id="trimList"></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    function addDays(d, n){ var x=new Date(d); x.setDate(x.getDate()+n); return x; }
    function fmtDate(d){ return d.toISOString().slice(0,10); }

    function calcDue() {
        var lmpStr = $("#lmp").val();
        var conStr = $("#conception").val();
        var cycle = parseInt($("#cycleLen").val()) || 28;

        if (!lmpStr && !conStr) {
            $("#dueDate").text("—"); $("#currentWeek").text("—"); $("#trimList").html("");
            return;
        }

        var due = null;
        var refDate = null;

        if (conStr) {
            var con = new Date(conStr);
            due = addDays(con, 266);
            refDate = con;
        } else if (lmpStr) {
            var lmp = new Date(lmpStr);
            // Adjust for non-28 day cycle: add (cycle-28) days
            due = addDays(lmp, 280 + (cycle - 28));
            refDate = lmp;
        }

        $("#dueDate").text(fmtDate(due));

        // Current week from LMP (or conception+14)
        var start = conStr ? addDays(new Date(conStr), -14) : new Date(lmpStr);
        var now = new Date();
        var days = Math.max(0, Math.floor((now - start) / (1000*60*60*24)));
        var week = Math.min(40, Math.floor(days / 7));
        $("#currentWeek").text(week + " / 40");

        // Trimesters
        var t1End = addDays(start, 13*7);
        var t2End = addDays(start, 27*7);
        var list = ""
            + "<li>First Trimester: " + fmtDate(start) + " to " + fmtDate(t1End) + "</li>"
            + "<li>Second Trimester: " + fmtDate(addDays(t1End,1)) + " to " + fmtDate(t2End) + "</li>"
            + "<li>Third Trimester: " + fmtDate(addDays(t2End,1)) + " to " + fmtDate(due) + "</li>";
        $("#trimList").html(list);
    }

    $("#lmp, #conception, #cycleLen").on("input change", calcDue);
    calcDue();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
