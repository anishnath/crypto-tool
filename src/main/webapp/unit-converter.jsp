<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Unit Converter – Length, Weight, Temperature</title>
    <meta name="description" content="Convert between common units for length, weight, and temperature. Supports instant conversion and batch conversion for multiple values.">
    <meta name="keywords" content="unit converter, length converter, weight converter, temperature converter, cm to inches, kg to lbs, celsius to fahrenheit">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Unit Converter",
      "applicationCategory":"UtilityApplication",
      "description":"Convert length, weight, and temperature units with batch support.",
      "url":"https://8gwifi.org/unit-converter.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Unit Converter</h1>
    <p>Convert among popular length, weight, and temperature units. Use batch mode to convert multiple values at once.</p>

    <form id="uc-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Conversion</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="category">Category</label>
                            <select id="category" class="form-control">
                                <option value="length" selected>Length</option>
                                <option value="weight">Weight</option>
                                <option value="temp">Temperature</option>
                            </select>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="fromUnit">From</label>
                                <select id="fromUnit" class="form-control"></select>
                            </div>
                            <div class="form-group col-6">
                                <label for="toUnit">To</label>
                                <select id="toUnit" class="form-control"></select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="value">Value</label>
                            <input type="number" class="form-control" id="value" value="1" step="0.0001">
                        </div>
                        <button type="button" class="btn btn-primary" id="btnConv">Convert</button>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Batch Convert</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="batchVals">Values (comma or newline separated)</label>
                            <textarea class="form-control" id="batchVals" rows="3" placeholder="12, 45.7, 100"></textarea>
                        </div>
                        <button type="button" class="btn btn-outline-primary" id="btnBatch">Convert Batch</button>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Result</div>
                    <div class="card-body">
                        <div class="p-3 border rounded" id="ucResult">—</div>
                    </div>
                </div>
                <div class="card mb-3">
                    <div class="card-header">Batch Results</div>
                    <div class="card-body">
                        <ul id="batchList" class="mb-0"></ul>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
var units = {
  length: ["mm","cm","m","km","inch","ft","yd","mile"],
  weight: ["g","kg","lb","oz"],
  temp: ["C","F","K"]
};

function populateUnits(){
  var cat = document.getElementById("category").value;
  var from = document.getElementById("fromUnit");
  var to = document.getElementById("toUnit");
  from.innerHTML = ""; to.innerHTML = "";
  units[cat].forEach(function(u){
    var o1=document.createElement("option"); o1.value=o1.textContent=u; from.appendChild(o1);
    var o2=document.createElement("option"); o2.value=o2.textContent=u; to.appendChild(o2);
  });
  if (cat==="length"){ from.value="cm"; to.value="inch"; }
  if (cat==="weight"){ from.value="kg"; to.value="lb"; }
  if (cat==="temp"){ from.value="C"; to.value="F"; }
}

function convertOne(cat, val, from, to){
  if (cat==="length"){
    var toMeters = {mm:0.001, cm:0.01, m:1, km:1000, inch:0.0254, ft:0.3048, yd:0.9144, mile:1609.344};
    var m = val * (toMeters[from]||1);
    var out = m / (toMeters[to]||1);
    return out;
  } else if (cat==="weight"){
    var toKg = {g:0.001, kg:1, lb:0.45359237, oz:0.028349523125};
    var kg = val * (toKg[from]||1);
    var outW = kg / (toKg[to]||1);
    return outW;
  } else if (cat==="temp"){
    // convert from -> C, then to -> target
    var c;
    if (from==="C") c=val;
    else if (from==="F") c=(val-32)*5/9;
    else if (from==="K") c=val-273.15;
    var outT;
    if (to==="C") outT=c;
    else if (to==="F") outT=c*9/5+32;
    else if (to==="K") outT=c+273.15;
    return outT;
  }
  return val;
}

function convert(){
  var cat=document.getElementById("category").value;
  var val=parseFloat(document.getElementById("value").value)||0;
  var from=document.getElementById("fromUnit").value;
  var to=document.getElementById("toUnit").value;
  var res=convertOne(cat,val,from,to);
  document.getElementById("ucResult").textContent = val+" "+from+" = "+res.toLocaleString('en-IN',{maximumFractionDigits:6})+" "+to;
}

function convertBatch(){
  var cat=document.getElementById("category").value;
  var from=document.getElementById("fromUnit").value;
  var to=document.getElementById("toUnit").value;
  var raw=(document.getElementById("batchVals").value||"").split(/,|\n/).map(function(s){return s.trim();}).filter(Boolean);
  var out=raw.map(function(s){
    var v=parseFloat(s); if(isNaN(v)) return s+" → invalid";
    var r=convertOne(cat,v,from,to);
    return v+" "+from+" = "+r.toLocaleString('en-IN',{maximumFractionDigits:6})+" "+to;
  });
  document.getElementById("batchList").innerHTML = out.map(function(x){return "<li>"+x+"</li>";}).join("");
}

document.getElementById("category").addEventListener("change", populateUnits);
document.getElementById("btnConv").addEventListener("click", convert);
document.getElementById("btnBatch").addEventListener("click", convertBatch);

// init
populateUnits(); convert();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
