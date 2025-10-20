<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Random Number Generator – Picker, Lottery, Coin & Dice</title>
    <meta name="description" content="Generate random numbers in a range with quantity and repeat options. Lottery mode, coin flip, and dice roller included. Copy results easily.">
    <meta name="keywords" content="random number generator, random picker, lottery generator, coin flip, dice roller">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Random Number Generator",
      "applicationCategory":"UtilityApplication",
      "description":"Random numbers, lottery mode, coin flip, and dice roller.",
      "url":"https://8gwifi.org/random-number-generator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Random Number Generator</h1>
    <p>Generate random numbers in your chosen range. Use lottery mode for unique picks, or try coin flip and dice roller.</p>

    <form id="rng-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Settings</div>
                    <div class="card-body">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="minVal">Min</label>
                                <input type="number" class="form-control" id="minVal" value="1">
                            </div>
                            <div class="form-group col-6">
                                <label for="maxVal">Max</label>
                                <input type="number" class="form-control" id="maxVal" value="100">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label for="qty">Quantity</label>
                                <input type="number" class="form-control" id="qty" value="5" min="1" max="1000">
                            </div>
                            <div class="form-group col-6">
                                <label for="allowRepeat">Repeats</label>
                                <select id="allowRepeat" class="form-control">
                                    <option value="yes" selected>Allow repeats</option>
                                    <option value="no">No repeats (unique)</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="lotteryMode">
                            <label class="form-check-label" for="lotteryMode">Lottery Mode (force unique)</label>
                        </div>
                        <div class="mt-3">
                            <button type="button" class="btn btn-primary" id="btnGen">Generate</button>
                            <button type="button" class="btn btn-outline-secondary ml-2" id="btnCopy">Copy</button>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Quick Picks</div>
                    <div class="card-body">
                        <button type="button" class="btn btn-outline-primary btn-sm" id="coinFlip">Coin Flip</button>
                        <button type="button" class="btn btn-outline-primary btn-sm ml-2" id="diceRoll">Roll Dice</button>
                    </div>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Results</div>
                    <div class="card-body">
                        <div class="p-3 border rounded" id="outBox" style="min-height:120px; font-family:monospace;">—</div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
function randInt(min, max){ return Math.floor(Math.random()*(max-min+1))+min; }

function generate(){
  var min = parseInt(document.getElementById("minVal").value,10);
  var max = parseInt(document.getElementById("maxVal").value,10);
  var qty = parseInt(document.getElementById("qty").value,10);
  var rep = document.getElementById("allowRepeat").value === "yes";
  var lottery = document.getElementById("lotteryMode").checked;
  var unique = lottery || !rep;

  if (isNaN(min)||isNaN(max)||min>max||qty<1){ document.getElementById("outBox").textContent="Invalid input."; return; }

  var res = [];
  if (unique){
    var pool = [];
    for (var i=min;i<=max;i++) pool.push(i);
    if (qty > pool.length) { document.getElementById("outBox").textContent="Quantity exceeds unique pool."; return; }
    for (var k=0;k<qty;k++){
      var idx = randInt(0, pool.length-1);
      res.push(pool[idx]);
      pool.splice(idx,1);
    }
  } else {
    for (var j=0;j<qty;j++) res.push(randInt(min,max));
  }

  document.getElementById("outBox").textContent = res.join(", ");
}

function copyOut(){
  var txt = document.getElementById("outBox").textContent||"";
  var ta = document.createElement("textarea");
  ta.value = txt; document.body.appendChild(ta); ta.select(); document.execCommand("copy"); document.body.removeChild(ta);
}

function coinFlip(){
  document.getElementById("outBox").textContent = (Math.random()<0.5) ? "Heads" : "Tails";
}
function diceRoll(){
  document.getElementById("outBox").textContent = "🎲 " + randInt(1,6);
}

document.getElementById("btnGen").addEventListener("click", generate);
document.getElementById("btnCopy").addEventListener("click", copyOut);
document.getElementById("coinFlip").addEventListener("click", coinFlip);
document.getElementById("diceRoll").addEventListener("click", diceRoll);

// initial
generate();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
