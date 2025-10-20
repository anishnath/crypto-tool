<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ovulation & Fertility Window Calculator – Next Cycles</title>
    <meta name="description" content="Estimate your fertile window and ovulation day from your last period date and average cycle length. See the next cycles and peak fertility days.">
    <meta name="keywords" content="ovulation calculator, fertility calculator, period tracker, fertile window">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Ovulation & Fertility Window Calculator",
      "applicationCategory": "HealthApplication",
      "description": "Predict ovulation and fertile windows from cycle length and LMP.",
      "url": "https://8gwifi.org/ovulation-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Ovulation & Fertility Window Calculator</h1>
    <p>Enter your last period start date and average cycle length to estimate your next ovulation day and fertile window.</p>

    <form id="ovu-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Cycle Details</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="lmp">Last Period Start Date</label>
                            <input type="date" class="form-control" id="lmp">
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
                        <li>Ovulation typically occurs ~14 days before the next period.</li>
                        <li>Fertile window spans ovulation day ± 2 days.</li>
                        <li>This is an estimate and not medical advice.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Results</div>
                    <div class="card-body">
                        <div class="p-3 border rounded mb-3">
                            <div><strong>Estimated Ovulation</strong></div>
                            <div id="ovuDay" style="font-size:1.2rem;">—</div>
                            <small class="text-muted">Fertile Window: <span id="fertileWin">—</span></small>
                        </div>
                        <div>
                            <h5>Upcoming Cycles</h5>
                            <ul id="cyclesList"></ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
    function fmtDate(d) { return d.toISOString().slice(0,10); }
    function addDays(d, n){ var x=new Date(d); x.setDate(x.getDate()+n); return x; }

    function calcOvu() {
        var lmpStr = $("#lmp").val();
        var cycle = parseInt($("#cycleLen").val()) || 28;
        if (!lmpStr) {
            $("#ovuDay").text("—"); $("#fertileWin").text("—"); $("#cyclesList").html("");
            return;
        }
        var lmp = new Date(lmpStr);
        var nextPeriod = addDays(lmp, cycle);
        var ovu = addDays(nextPeriod, -14);
        var winStart = addDays(ovu, -2);
        var winEnd = addDays(ovu, 2);

        $("#ovuDay").text(fmtDate(ovu));
        $("#fertileWin").text(fmtDate(winStart) + " to " + fmtDate(winEnd));

        // Next 6 cycles
        var list = "";
        var base = lmp;
        for (var i = 1; i <= 6; i++) {
            var periodStart = addDays(base, cycle * i);
            var nextP = addDays(periodStart, cycle);
            var ovuI = addDays(nextP, -14);
            var winS = addDays(ovuI, -2);
            var winE = addDays(ovuI, 2);
            list += "<li>Cycle " + i + ": Ovulation " + fmtDate(ovuI) + " (Window " + fmtDate(winS) + " - " + fmtDate(winE) + ")</li>";
        }
        $("#cyclesList").html(list);
    }

    $("#lmp, #cycleLen").on("input change", calcOvu);
    calcOvu();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
