<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Roman Numeral Converter – Roman ↔ Arabic</title>
    <meta name="description" content="Convert Roman numerals to Arabic numbers and vice versa. Validates input and supports up to 3999 (MMMCMXCIX).">
    <meta name="keywords" content="roman numerals, roman numeral converter, roman to arabic, arabic to roman">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Roman Numeral Converter",
      "applicationCategory":"EducationalApplication",
      "description":"Convert Roman ↔ Arabic with validation up to 3999.",
      "url":"https://8gwifi.org/roman-numeral-converter.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Roman Numeral Converter</h1>
    <p>Convert between Roman numerals and Arabic numbers (1–3999). Includes input validation and examples.</p>

    <form id="roman-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Inputs</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="arabicVal">Arabic (1–3999)</label>
                            <input type="number" class="form-control" id="arabicVal" value="2025" min="1" max="3999">
                        </div>
                        <div class="form-group">
                            <label for="romanVal">Roman (I–MMMCMXCIX)</label>
                            <input type="text" class="form-control" id="romanVal" value="MMXXV">
                        </div>
                        <button type="button" class="btn btn-primary" id="toRoman">Arabic → Roman</button>
                        <button type="button" class="btn btn-outline-primary ml-2" id="toArabic">Roman → Arabic</button>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Rules:
                    <ul class="mb-0">
                        <li>Allowed symbols: I, V, X, L, C, D, M</li>
                        <li>Subtractive notation: IV(4), IX(9), XL(40), XC(90), CD(400), CM(900)</li>
                        <li>Maximum 3999 (MMMCMXCIX)</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Result</div>
                    <div class="card-body">
                        <div class="p-3 border rounded">
                            <div id="romanResult" style="font-size:1.2rem;">—</div>
                            <small id="romanExplain" class="text-muted d-block">—</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
var map = [
  {val:1000, sym:"M"},{val:900, sym:"CM"},{val:500, sym:"D"},{val:400, sym:"CD"},
  {val:100, sym:"C"},{val:90, sym:"XC"},{val:50, sym:"L"},{val:40, sym:"XL"},
  {val:10, sym:"X"},{val:9, sym:"IX"},{val:5, sym:"V"},{val:4, sym:"IV"},{val:1, sym:"I"}
];
var validRoman = /^M{0,3}(CM|CD|D?C{0,3})(XC|XL|L?X{0,3})(IX|IV|V?I{0,3})$/i;

function toRoman(n){
  if (n<1 || n>3999) return null;
  var out = ""; var i=0;
  while(n>0){
    if (n>=map[i].val){ out += map[i].sym; n -= map[i].val; }
    else i++;
  }
  return out;
}

function toArabic(r){
  if(!validRoman.test(r)) return null;
  r = r.toUpperCase();
  var i=0, sum=0;
  while(i<r.length){
    var two = r.substr(i,2);
    var one = r.substr(i,1);
    var found = map.find(m=>m.sym===two);
    if(found){ sum += found.val; i+=2; continue; }
    found = map.find(m=>m.sym===one);
    if(found){ sum += found.val; i+=1; continue; }
    return null;
  }
  return sum;
}

function show(res, msg){
  document.getElementById("romanResult").textContent = res;
  document.getElementById("romanExplain").textContent = msg || "—";
}

document.getElementById("toRoman").addEventListener("click", function(){
  var n = parseInt(document.getElementById("arabicVal").value,10);
  var roman = toRoman(n);
  if(roman===null) show("Invalid (1–3999)"); else show(roman, "Arabic "+n+" → Roman "+roman);
});
document.getElementById("toArabic").addEventListener("click", function(){
  var r = (document.getElementById("romanVal").value||"").trim();
  var arab = toArabic(r);
  if(arab===null) show("Invalid Roman numeral");
  else show(arab, "Roman "+r.toUpperCase()+" → Arabic "+arab);
});

// Prefill compute
(function(){ document.getElementById("toRoman").click(); })();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
