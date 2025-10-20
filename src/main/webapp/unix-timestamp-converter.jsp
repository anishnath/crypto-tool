<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unix Timestamp Converter – Epoch ↔ Human Date (UTC/Local/TZ)</title>
    <meta name="description" content="Convert Unix timestamps to human-readable dates and back. Shows UTC, local time, and a custom timezone offset. Includes a batch converter for multiple timestamps.">
    <meta name="keywords" content="unix timestamp converter, epoch converter, timestamp to date, epoch to date, milliseconds to date, date to timestamp">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Unix Timestamp Converter",
      "applicationCategory":"UtilityApplication",
      "description":"Convert Unix timestamps ↔ dates with UTC, local, and custom timezone displays and batch mode.",
      "url":"https://8gwifi.org/unix-timestamp-converter.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Unix Timestamp Converter</h1>
    <p>Convert Unix timestamps (epoch seconds/milliseconds) to human-readable dates and vice versa. See UTC, local, and custom timezone outputs. Use batch mode for multi-line inputs.</p>

    <form id="ts-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="mode">Mode</label>
                            <select id="mode" class="form-control">
                                <option value="ts2date" selected>Timestamp → Date</option>
                                <option value="date2ts">Date → Timestamp</option>
                            </select>
                        </div>

                        <div id="tsBlock">
                            <div class="form-group">
                                <label for="tsInput">Unix Timestamp (seconds or milliseconds)</label>
                                <input type="text" class="form-control" id="tsInput" value="1700000000" placeholder="e.g., 1700000000 or 1700000000000">
                                <small class="text-muted">Auto-detects seconds vs. milliseconds by length.</small>
                            </div>
                        </div>

                        <div id="dateBlock" class="d-none">
                            <div class="form-row">
                                <div class="form-group col-7">
                                    <label for="dateInput">Date</label>
                                    <input type="date" class="form-control" id="dateInput">
                                </div>
                                <div class="form-group col-5">
                                    <label for="timeInput">Time</label>
                                    <input type="time" class="form-control" id="timeInput" value="12:00">
                                </div>
                            </div>
                            <small class="text-muted">Assumes local time when converting to a timestamp.</small>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="tzOffset">Custom TZ Offset (hours)</label>
                                <input type="number" class="form-control" id="tzOffset" value="0" step="0.5">
                                <small class="text-muted">e.g., +5.5 (IST), -4 (EDT)</small>
                            </div>
                            <div class="form-group col-6 d-flex align-items-end">
                                <button type="button" class="btn btn-primary btn-block" id="btnConvert">Convert</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Batch Converter</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="batchInput">Timestamps (one per line)</label>
                            <textarea class="form-control" id="batchInput" rows="4" placeholder="1700000000&#10;1700000500&#10;1700001000000"></textarea>
                        </div>
                        <button type="button" class="btn btn-outline-primary" id="btnBatch">Convert Batch</button>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Unix timestamp is seconds since 1970-01-01T00:00:00Z. Milliseconds are seconds × 1000.</li>
                        <li>Use the custom TZ offset to visualize the same instant in a chosen timezone.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Results</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>Epoch Seconds</strong>: <span id="secOut">—</span></div>
                            <div><strong>Epoch Milliseconds</strong>: <span id="msOut">—</span></div>
                            <hr>
                            <div><strong>UTC</strong>: <span id="utcOut">—</span></div>
                            <div><strong>Local</strong>: <span id="localOut">—</span></div>
                            <div><strong>Custom TZ</strong>: <span id="tzOut">—</span></div>
                            <div><strong>ISO 8601</strong>: <span id="isoOut">—</span></div>
                            <div><strong>Relative</strong>: <span id="relOut">—</span></div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Current Time (updates every second)</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div><strong>Now Epoch Seconds</strong>: <span id="nowSec">—</span></div>
                            <div><strong>Now Epoch Milliseconds</strong>: <span id="nowMs">—</span></div>
                            <hr>
                            <div><strong>UTC</strong>: <span id="nowUTC">—</span></div>
                            <div><strong>Local</strong>: <span id="nowLocal">—</span></div>
                            <div><strong>Custom TZ</strong>: <span id="nowTZ">—</span></div>
                            <div><strong>ISO 8601</strong>: <span id="nowISO">—</span></div>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Batch Output</div>
                    <div class="card-body">
                        <ul id="batchOut" class="mb-0"></ul>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function $(id){ return document.getElementById(id); }
function setText(id, v){ $(id).textContent = v; }
function fmtLocal(d){
  try { return d.toLocaleString(); }
  catch(e){ return d.toString(); }
}
function fmtUTC(d){
  var y=d.getUTCFullYear(), m=("0"+(d.getUTCMonth()+1)).slice(-2), da=("0"+d.getUTCDate()).slice(-2);
  var hh=("0"+d.getUTCHours()).slice(-2), mm=("0"+d.getUTCMinutes()).slice(-2), ss=("0"+d.getUTCSeconds()).slice(-2);
  return y+"-"+m+"-"+da+" "+hh+":"+mm+":"+ss+" UTC";
}
function relativeFromNow(d){
  var now = new Date();
  var diff = d - now;
  var s = Math.round(diff/1000);
  var abs = Math.abs(s);
  if (abs < 60) return (s>=0? "in ":"")+abs+" seconds";
  var m = Math.round(abs/60);
  if (m < 60) return (s>=0? "in ":"")+m+" minutes";
  var h = Math.round(m/60);
  if (h < 48) return (s>=0? "in ":"")+h+" hours";
  var days = Math.round(h/24);
  return (s>=0? "in ":"")+days+" days";
}
function toMsAuto(str){
  // accepts seconds or milliseconds as integer/float
  var n = Number(str);
  if (!isFinite(n)) return null;
  if (Math.abs(n) < 1e12) return Math.round(n*1000); // assume seconds
  return Math.round(n); // assume milliseconds
}
function applyTzOffset(d, hours){
  var ms = d.getTime() + (hours*3600*1000);
  return new Date(ms);
}

function showResults(d){
  if (!d){ setText("secOut","—"); setText("msOut","—"); setText("utcOut","—"); setText("localOut","—"); setText("tzOut","—"); setText("isoOut","—"); setText("relOut","—"); return; }
  var sec = Math.floor(d.getTime()/1000);
  var ms = d.getTime();
  var tzHrs = parseFloat($("tzOffset").value)||0;

  setText("secOut", sec.toString());
  setText("msOut", ms.toString());
  setText("utcOut", fmtUTC(d));
  setText("localOut", fmtLocal(d));
  setText("tzOut", fmtLocal(applyTzOffset(d, tzHrs)));
  setText("isoOut", d.toISOString());
  setText("relOut", relativeFromNow(d));
}

function convert(){
  var mode = $("mode").value;
  if (mode === "ts2date"){
    var input = $("tsInput").value.trim();
    var ms = toMsAuto(input);
    if (ms === null){ showResults(null); return; }
    var d = new Date(ms);
    showResults(d);
  } else {
    var di = $("dateInput").value, ti = $("timeInput").value;
    if (!di) { showResults(null); return; }
    var parts = ti ? ti.split(":") : ["00","00"];
    var d = new Date(di+"T"+parts[0]+":"+parts[1]+":00");
    showResults(d);
  }
}

function convertBatch(){
  var lines = ($("batchInput").value||"").split(/\r?\n/).map(function(s){ return s.trim(); }).filter(Boolean);
  var out = [];
  lines.forEach(function(line){
    var ms = toMsAuto(line);
    if (ms === null){ out.push("Invalid: "+line); return; }
    var d = new Date(ms);
    out.push(line+" → "+fmtUTC(d)+" | "+fmtLocal(d));
  });
  $("batchOut").innerHTML = out.map(function(x){ return "<li>"+x+"</li>"; }).join("");
}

$("mode").addEventListener("change", function(){
  var isTs = $("mode").value === "ts2date";
  $("tsBlock").classList.toggle("d-none", !isTs);
  $("dateBlock").classList.toggle("d-none", isTs);
  convert();
});
["tsInput","dateInput","timeInput","tzOffset"].forEach(function(id){
  var el=$(id); if(el) el.addEventListener("input", convert);
});
$("btnConvert").addEventListener("click", convert);
$("btnBatch").addEventListener("click", convertBatch);

function updateNowPanel(){
  var now = new Date();
  var tzHrs = parseFloat($("tzOffset").value)||0;
  setText("nowSec", Math.floor(now.getTime()/1000).toString());
  setText("nowMs", now.getTime().toString());
  setText("nowUTC", fmtUTC(now));
  setText("nowLocal", fmtLocal(now));
  setText("nowTZ", fmtLocal(applyTzOffset(now, tzHrs)));
  setText("nowISO", now.toISOString());
}

// init
(function(){
  var now = new Date();
  $("dateInput").value = now.toISOString().slice(0,10);
  convert();
  updateNowPanel();
  // refresh current time every second
  setInterval(updateNowPanel, 1000);
})();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
