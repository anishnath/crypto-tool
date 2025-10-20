<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Percentage Calculator – Percent Of, Change, Increase/Decrease</title>
    <meta name="description" content="Solve percentage problems fast: percent of, what percent, increase/decrease, percent change, reverse percentage, and discount simulator with tax.">
    <meta name="keywords" content="percentage calculator, percent of, percent increase, percent decrease, percent change, discount calculator, sale price">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "WebApplication",
      "name": "Percentage Calculator",
      "applicationCategory": "EducationalApplication",
      "description": "Fast percentage calculations with explanations and a discount/tax simulator.",
      "url": "https://8gwifi.org/percentage-calculator.jsp",
      "author": { "@type": "Person", "name": "Anish Nath" },
      "datePublished": "2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Percentage Calculator</h1>
    <p>Solve common percentage questions quickly. Pick a mode, enter values, and get the answer with a short explanation.</p>

    <form id="pct-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Mode & Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="mode">Mode</label>
                            <select id="mode" class="form-control">
                                <option value="percentOf" selected>X% of Y</option>
                                <option value="whatPercent">X is what % of Y</option>
                                <option value="increaseBy">Increase Y by X%</option>
                                <option value="decreaseBy">Decrease Y by X%</option>
                                <option value="percentChange">% Change from A to B</option>
                                <option value="reversePct">Original before discount X% (final F)</option>
                                <option value="discountSim">Discount + Tax Simulator</option>
                                <option value="chain">Chained Steps (e.g., +10%, -5%, +8%)</option>
                            </select>
                        </div>

                        <div id="inputsSimple">
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="xVal">X (percent/value)</label>
                                    <input type="number" class="form-control" id="xVal" value="10" step="0.01">
                                </div>
                                <div class="form-group col-6">
                                    <label for="yVal">Y (base)</label>
                                    <input type="number" class="form-control" id="yVal" value="200" step="0.01">
                                </div>
                            </div>
                        </div>

                        <div id="inputsChange" class="d-none">
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="aVal">A (from)</label>
                                    <input type="number" class="form-control" id="aVal" value="120" step="0.01">
                                </div>
                                <div class="form-group col-6">
                                    <label for="bVal">B (to)</label>
                                    <input type="number" class="form-control" id="bVal" value="150" step="0.01">
                                </div>
                            </div>
                        </div>

                        <div id="inputsReverse" class="d-none">
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="discountPct">Discount %</label>
                                    <input type="number" class="form-control" id="discountPct" value="20" step="0.01">
                                </div>
                                <div class="form-group col-6">
                                    <label for="finalPrice">Final Price (after discount)</label>
                                    <input type="number" class="form-control" id="finalPrice" value="80" step="0.01">
                                </div>
                            </div>
                        </div>

                        <div id="inputsSim" class="d-none">
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="basePrice">Base Price</label>
                                    <input type="number" class="form-control" id="basePrice" value="1000" step="0.01">
                                </div>
                                <div class="form-group col-6">
                                    <label for="discPctSim">Discount %</label>
                                    <input type="number" class="form-control" id="discPctSim" value="15" step="0.01">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-6">
                                    <label for="taxPctSim">Tax %</label>
                                    <input type="number" class="form-control" id="taxPctSim" value="5" step="0.01">
                                </div>
                                <div class="form-group col-6">
                                    <label for="qtySim">Quantity</label>
                                    <input type="number" class="form-control" id="qtySim" value="1" step="1">
                                </div>
                            </div>
                        </div>

                        <div id="inputsChain" class="d-none">
                            <div class="form-group">
                                <label for="chainStart">Start Value</label>
                                <input type="number" class="form-control" id="chainStart" value="100" step="0.01">
                            </div>
                            <div class="form-group">
                                <label for="chainSteps">Steps (comma-separated)</label>
                                <input type="text" class="form-control" id="chainSteps" value="+10%, -5%, +8%">
                                <small class="text-muted">Use +X% or -X% for percentage steps; +X or -X for absolute steps</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>X% of Y = (X/100) × Y</li>
                        <li>% Change = (B - A)/A × 100%</li>
                        <li>Reverse %: Original = Final ÷ (1 - discount%)</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Result</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div id="result" style="font-size:1.2rem;">—</div>
                            <small id="explain" class="text-muted d-block">—</small>
                        </div>
                    </div>
                </div>

                <div class="card mb-3 d-none" id="simCard">
                    <div class="card-header">Discount Simulator</div>
                    <div class="card-body">
                        <ul id="simList" class="mb-0"></ul>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function show(id, show){ document.getElementById(id).classList.toggle("d-none", !show); }

function parseSteps(str){
  return (str||"").split(",").map(function(s){ return s.trim(); }).filter(Boolean);
}

function applyChain(start, steps){
  var v = start;
  steps.forEach(function(step){
    if (/^[+-]\d+(\.\d+)?%$/.test(step)){
      var p = parseFloat(step); v = v * (1 + p/100);
    } else if (/^[+-]\d+(\.\d+)?$/.test(step)){
      var n = parseFloat(step); v = v + n;
    }
  });
  return v;
}

function calc(){
  var mode = document.getElementById("mode").value;
  show("inputsSimple", mode==="percentOf" || mode==="whatPercent" || mode==="increaseBy" || mode==="decreaseBy");
  show("inputsChange", mode==="percentChange");
  show("inputsReverse", mode==="reversePct");
  show("inputsSim", mode==="discountSim");
  show("inputsChain", mode==="chain");
  document.getElementById("simCard").classList.toggle("d-none", mode!=="discountSim");

  var result = "—", explain = "—";

  if (mode === "percentOf"){
    var x = parseFloat(document.getElementById("xVal").value)||0;
    var y = parseFloat(document.getElementById("yVal").value)||0;
    result = (x/100)*y;
    explain = x + "% of " + y + " = (" + x + "/100) × " + y + " = " + result.toFixed(2);
  }
  else if (mode === "whatPercent"){
    var a = parseFloat(document.getElementById("xVal").value)||0;
    var b = parseFloat(document.getElementById("yVal").value)||0;
    var pct = b !== 0 ? (a/b)*100 : 0;
    result = pct.toFixed(2) + "%";
    explain = a + " is what % of " + b + "? (" + a + "/" + b + ")×100 = " + pct.toFixed(2) + "%";
  }
  else if (mode === "increaseBy"){
    var p = parseFloat(document.getElementById("xVal").value)||0;
    var base = parseFloat(document.getElementById("yVal").value)||0;
    var newV = base*(1+p/100);
    result = newV;
    explain = "Increase " + base + " by " + p + "% → " + base + "×(1+" + p + "/100) = " + newV.toFixed(2);
  }
  else if (mode === "decreaseBy"){
    var p2 = parseFloat(document.getElementById("xVal").value)||0;
    var base2 = parseFloat(document.getElementById("yVal").value)||0;
    var newV2 = base2*(1-p2/100);
    result = newV2;
    explain = "Decrease " + base2 + " by " + p2 + "% → " + base2 + "×(1−" + p2 + "/100) = " + newV2.toFixed(2);
  }
  else if (mode === "percentChange"){
    var A = parseFloat(document.getElementById("aVal").value)||0;
    var B = parseFloat(document.getElementById("bVal").value)||0;
    var ch = A!==0 ? ((B-A)/A)*100 : 0;
    var sign = ch>=0 ? "+" : "";
    result = sign + ch.toFixed(2) + "%";
    explain = "% Change = (B−A)/A×100 = ("+B+"−"+A+")/"+A+"×100 = " + result;
  }
  else if (mode === "reversePct"){
    var d = parseFloat(document.getElementById("discountPct").value)||0;
    var F = parseFloat(document.getElementById("finalPrice").value)||0;
    var orig = (1 - d/100) !== 0 ? F/(1 - d/100) : 0;
    result = orig;
    explain = "Original = Final ÷ (1 − "+d+"%) = " + F + " ÷ " + (1 - d/100).toFixed(2) + " = " + orig.toFixed(2);
  }
  else if (mode === "discountSim"){
    var BP = parseFloat(document.getElementById("basePrice").value)||0;
    var DP = parseFloat(document.getElementById("discPctSim").value)||0;
    var TP = parseFloat(document.getElementById("taxPctSim").value)||0;
    var qty = parseFloat(document.getElementById("qtySim").value)||0;
    var discAmt = BP*(DP/100);
    var priceAfterDisc = BP - discAmt;
    var taxAmt = priceAfterDisc*(TP/100);
    var finalEach = priceAfterDisc + taxAmt;
    var grand = finalEach * qty;
    result = grand;
    explain = "Base " + BP + " − " + DP + "% + " + TP + "% tax, Qty " + qty;

    var lines = [
      "Discount: " + discAmt.toFixed(2),
      "Price after discount: " + priceAfterDisc.toFixed(2),
      "Tax: " + taxAmt.toFixed(2),
      "Final each: " + finalEach.toFixed(2),
      "Grand total: " + grand.toFixed(2)
    ];
    document.getElementById("simList").innerHTML = lines.map(function(s){ return "<li>"+s+"</li>"; }).join("");
  }
  else if (mode === "chain"){
    var start = parseFloat(document.getElementById("chainStart").value)||0;
    var steps = parseSteps(document.getElementById("chainSteps").value);
    var out = applyChain(start, steps);
    result = out;
    explain = "Start: " + start + " → steps " + steps.join(", ") + " → " + out.toFixed(2);
  }

  var resEl = document.getElementById("result");
  var expEl = document.getElementById("explain");
  if (typeof result === "number") resEl.textContent = result.toFixed(2); else resEl.textContent = result;
  expEl.textContent = explain;
}

document.getElementById("mode").addEventListener("change", calc);
["xVal","yVal","aVal","bVal","discountPct","finalPrice","basePrice","discPctSim","taxPctSim","qtySim","chainStart","chainSteps"].forEach(function(id){
  var el = document.getElementById(id); if (el) el.addEventListener("input", calc);
});

// initial compute
calc();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
