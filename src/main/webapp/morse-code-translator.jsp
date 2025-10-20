<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Morse Code Translator – Text ↔ Morse, Audio Beeps</title>
    <meta name="description" content="Translate text to Morse code and back. Play audio beeps, toggle uppercase, detect SOS, and copy or share results.">
    <meta name="keywords" content="morse code translator, morse code, text to morse, morse to text, sos">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Morse Code Translator",
      "applicationCategory":"UtilityApplication",
      "description":"Convert text to Morse and Morse to text with audio playback.",
      "url":"https://8gwifi.org/morse-code-translator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Morse Code Translator</h1>
    <p>Encode or decode Morse code. Supports audio beeps, uppercase toggle, and quick copy/share.</p>

    <form id="morse-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Input</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="textIn">Text (for encode) or Morse (for decode)</label>
                            <textarea id="textIn" class="form-control" rows="4" placeholder="Hello World or .... . .-.. .-.. --- / .-- --- .-. .-.. -..">SOS Help</textarea>
                            <small class="text-muted d-block">Separate Morse letters with spaces and words with slash (/).</small>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="uppercase" checked>
                                    <label class="form-check-label" for="uppercase">Uppercase output</label>
                                </div>
                            </div>
                            <div class="form-group col-6">
                                <label for="dotMs">Dot length (ms)</label>
                                <input type="number" class="form-control" id="dotMs" value="120" min="40" max="400">
                            </div>
                        </div>
                        <div class="mt-2">
                            <button type="button" class="btn btn-primary" id="btnEncode">Encode Text → Morse</button>
                            <button type="button" class="btn btn-outline-primary ml-2" id="btnDecode">Decode Morse → Text</button>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Letters in Morse separated by spaces; words separated by slash (/).</li>
                        <li>Audio timing: dot 1 unit, dash 3 units, intra-part 1, letter gap 3, word gap 7.</li>
                    </ul>
                </div>
            </div>

            <div class="col-lg-7">
                <div class="card mb-3">
                    <div class="card-header">Output</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="textOut">Result</label>
                            <textarea id="textOut" class="form-control" rows="4" readonly></textarea>
                        </div>
                        <div class="mb-2">
                            <span id="sosBadge" class="badge badge-danger d-none">SOS detected (... --- ...)</span>
                        </div>
                        <div class="mt-2">
                            <button type="button" class="btn btn-success" id="btnPlay">Play Audio</button>
                            <button type="button" class="btn btn-outline-secondary ml-2" id="btnCopy">Copy</button>
                            <button type="button" class="btn btn-outline-secondary ml-2" id="btnShare">Share</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
/* Mapping */
var MORSE = {
  "A":".-","B":"-...","C":"-.-.","D":"-..","E":".","F":"..-.","G":"--.","H":"....","I":"..","J":".---",
  "K":"-.-","L":".-..","M":"--","N":"-.","O":"---","P":".--.","Q":"--.-","R":".-.","S":"...","T":"-",
  "U":"..-","V":"...-","W":".--","X":"-..-","Y":"-.--","Z":"--..",
  "0":"-----","1":".----","2":"..---","3":"...--","4":"....-","5":".....","6":"-....","7":"--...","8":"---..","9":"----.",
  ".":".-.-.-",",":"--..--","?":"..--..","!":"-.-.--","/":"-..-.","(":"-.--.",")":"-.--.-","&":".-...",
  ":":"---...",";":"-.-.-.","=":"-...-","+":".-.-.","-":"-....-","_":"..--.-","\"":".-..-.","$":"...-..-","'":".----.","@":".--.-."
};
var REV = {};
Object.keys(MORSE).forEach(function(k){ REV[MORSE[k]] = k; });

function encodeText(txt, upper){
  var out = [];
  var words = txt.split(/\s+/);
  words.forEach(function(word, wi){
    var letters = word.split("");
    var codes = letters.map(function(ch){
      var up = ch.toUpperCase();
      return MORSE[up] ? MORSE[up] : ""; // ignore unknowns
    }).filter(Boolean);
    if (codes.length) out.push(codes.join(" "));
  });
  var morse = out.join(" / ");
  return upper ? morse.toUpperCase() : morse;
}

function decodeMorse(morse){
  var out = [];
  var words = morse.trim().split(/\s*\/\s*/);
  words.forEach(function(w){
    var letters = w.trim().split(/\s+/);
    var decoded = letters.map(function(code){ return REV[code] || ""; }).join("");
    if (decoded) out.push(decoded);
  });
  return out.join(" ");
}

function setOutput(text){
  var out = document.getElementById("textOut");
  out.value = text;
  // SOS detector
  var badge = document.getElementById("sosBadge");
  if (text.indexOf("... --- ...") !== -1 || text.toUpperCase().indexOf("SOS") !== -1) badge.classList.remove("d-none");
  else badge.classList.add("d-none");
}

function doEncode(){
  var upper = document.getElementById("uppercase").checked;
  var val = document.getElementById("textIn").value || "";
  var morse = encodeText(val, upper);
  setOutput(morse);
}

function doDecode(){
  var val = document.getElementById("textIn").value || "";
  var text = decodeMorse(val);
  var upper = document.getElementById("uppercase").checked;
  setOutput(upper ? text.toUpperCase() : text);
}

/* Audio */
var audioCtx = null;
function playTone(durationMs, freq){
  if (!audioCtx) audioCtx = new (window.AudioContext || window.webkitAudioContext)();
  var o = audioCtx.createOscillator();
  var g = audioCtx.createGain();
  o.frequency.value = freq || 600;
  o.type = "sine";
  o.connect(g); g.connect(audioCtx.destination);
  o.start();
  g.gain.setValueAtTime(0.2, audioCtx.currentTime);
  o.stop(audioCtx.currentTime + durationMs/1000);
  return new Promise(function(res){ setTimeout(res, durationMs); });
}
function sleep(ms){ return new Promise(function(r){ setTimeout(r, ms); }); }

async function playMorseSequence(seq){
  var dot = parseInt(document.getElementById("dotMs").value,10) || 120;
  var dash = dot * 3;
  // spacing: 1 unit between elements, 3 units between letters, 7 units between words
  for (var i=0; i<seq.length; i++){
    var ch = seq[i];
    if (ch === "."){
      await playTone(dot, 600);
      await sleep(dot);
    } else if (ch === "-"){
      await playTone(dash, 600);
      await sleep(dot);
    } else if (ch === " "){
      await sleep(dot*2); // we already slept 1 unit after element; add 2 more to make 3 units for letter gap
    } else if (ch === "/"){
      await sleep(dot*6); // plus previous 1 -> ~7 units
    }
  }
}

/* Copy & Share */
function copyOut(){
  var txt = document.getElementById("textOut").value || "";
  var ta = document.createElement("textarea");
  ta.value = txt; document.body.appendChild(ta); ta.select(); document.execCommand("copy"); document.body.removeChild(ta);
}
function shareOut(){
  var txt = document.getElementById("textOut").value || "";
  if (navigator.share){
    navigator.share({ text: txt }).catch(function(){});
  } else {
    copyOut();
    alert("Copied to clipboard!");
  }
}

document.getElementById("btnEncode").addEventListener("click", doEncode);
document.getElementById("btnDecode").addEventListener("click", doDecode);
document.getElementById("btnPlay").addEventListener("click", function(){
  var seq = document.getElementById("textOut").value || "";
  playMorseSequence(seq);
});
document.getElementById("btnCopy").addEventListener("click", copyOut);
document.getElementById("btnShare").addEventListener("click", shareOut);

// Initial encode
doEncode();
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
