<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Binary Code Translator – Text ↔ Binary (8-bit)</title>
    <meta name="description" content="Convert text to binary and binary to text with 8-bit padding and byte grouping. Includes ASCII table lookup and copy/share tools.">
    <meta name="keywords" content="binary translator, text to binary, binary to text, ascii table, 8-bit binary, byte grouping">

    <script type="application/ld+json">
    {
      "@context":"http://schema.org",
      "@type":"WebApplication",
      "name":"Binary Code Translator",
      "applicationCategory":"EducationalApplication",
      "description":"Translate text ↔ binary with 8-bit padding and ASCII lookup.",
      "url":"https://8gwifi.org/binary-code-translator.jsp",
      "author":{"@type":"Person","name":"Anish Nath"},
      "datePublished":"2025-10-19"
    }
    </script>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>
    <h1 class="mb-4">Binary Code Translator</h1>
    <p>Convert between text and binary with 8-bit padding and byte grouping. Use the ASCII lookup for quick inserts, then copy or share your result.</p>

    <form id="bin-form">
        <div class="row">
            <div class="col-lg-5">
                <div class="card mb-3">
                    <div class="card-header">Input</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="textIn">Text (for encode) or Binary (for decode)</label>
                            <textarea id="textIn" class="form-control" rows="4" placeholder="Hello or 01001000 01100101 01101100 01101100 01101111">Hello</textarea>
                            <small class="text-muted">Binary should be space-separated bytes (e.g., 01000001 01100010).</small>
                        </div>

                        <div class="form-row">
                            <div class="form-group col-6">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="pad8" checked>
                                    <label class="form-check-label" for="pad8">Pad to 8 bits</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="groupBytes" checked>
                                    <label class="form-check-label" for="groupBytes">Group by bytes (spaces)</label>
                                </div>
                            </div>
                            <div class="form-group col-6">
                                <label for="asciiPick">ASCII lookup</label>
                                <select id="asciiPick" class="form-control">
                                    <option value="">Select char…</option>
                                </select>
                                <small class="text-muted">Insert selected char into input</small>
                            </div>
                        </div>

                        <div class="mt-2">
                            <button type="button" class="btn btn-primary" id="btnEncode">Encode Text → Binary</button>
                            <button type="button" class="btn btn-outline-primary ml-2" id="btnDecode">Decode Binary → Text</button>
                        </div>
                    </div>
                </div>

                <div class="alert alert-secondary">
                    Notes:
                    <ul class="mb-0">
                        <li>Uses standard 8-bit (byte) binary for ASCII characters.</li>
                        <li>Non-ASCII characters may not decode properly.</li>
                        <li>Ensure binary bytes are space-separated for decoding.</li>
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
                        <div class="mt-2">
                            <button type="button" class="btn btn-success" id="btnCopy">Copy</button>
                            <button type="button" class="btn btn-outline-secondary ml-2" id="btnShare">Share</button>
                        </div>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-header">Validation</div>
                    <div class="card-body">
                        <div id="valMsg" class="text-monospace text-muted">—</div>
                    </div>
                </div>
            </div>
        </div>
    </form>

<script>
// Build ASCII options (printable 32..126)
(function fillAscii(){
  var pick = document.getElementById("asciiPick");
  for (var code=32; code<=126; code++){
    var ch = String.fromCharCode(code);
    var opt = document.createElement("option");
    opt.value = ch; opt.textContent = ch + " (ASCII " + code + ")";
    pick.appendChild(opt);
  }
  pick.addEventListener("change", function(){
    var ch = pick.value || "";
    if (ch){
      var t = document.getElementById("textIn");
      var s = t.selectionStart || t.value.length;
      t.value = t.value.slice(0,s) + ch + t.value.slice(s);
      pick.value = "";
      t.focus();
    }
  });
})();

function pad8bits(bin){
  if (!document.getElementById("pad8").checked) return bin;
  return bin.length >= 8 ? bin : ("00000000".slice(bin.length) + bin);
}

function encodeTextToBinary(txt){
  var grouped = document.getElementById("groupBytes").checked;
  var bytes = [];
  for (var i=0; i<txt.length; i++){
    var code = txt.charCodeAt(i);
    if (code > 255){
      // best-effort: split into 2 bytes (UTF-16)
      var hi = (code >> 8) & 0xFF, lo = code & 0xFF;
      bytes.push(pad8bits(hi.toString(2)));
      bytes.push(pad8bits(lo.toString(2)));
    } else {
      bytes.push(pad8bits(code.toString(2)));
    }
  }
  return grouped ? bytes.join(" ") : bytes.join("");
}

function validateBinaryString(bin){
  var tokens = bin.trim().split(/\s+/).filter(Boolean);
  if (tokens.length === 0) return { ok:false, msg:"No binary tokens found." };
  for (var i=0;i<tokens.length;i++){
    if (!/^[01]+$/.test(tokens[i])) return { ok:false, msg:"Invalid token: " + tokens[i] };
    if (document.getElementById("pad8").checked && tokens[i].length !== 8)
      return { ok:false, msg:"Token not 8-bit padded: " + tokens[i] };
  }
  return { ok:true, msg:"Valid " + tokens.length + " byte(s)." };
}

function decodeBinaryToText(bin){
  var tokens = bin.trim().split(/\s+/).filter(Boolean);
  var chars = [];
  for (var i=0;i<tokens.length;i++){
    var val = parseInt(tokens[i], 2);
    if (isNaN(val)) continue;
    chars.push(String.fromCharCode(val));
  }
  return chars.join("");
}

function setOut(txt){ document.getElementById("textOut").value = txt; }
function setVal(msg){ document.getElementById("valMsg").textContent = msg; }

document.getElementById("btnEncode").addEventListener("click", function(){
  var txt = document.getElementById("textIn").value || "";
  var out = encodeTextToBinary(txt);
  setOut(out);
  setVal("Encoded " + txt.length + " character(s) into " + (out.trim()? out.trim().split(/\s+/).length : 0) + " byte(s).");
});

document.getElementById("btnDecode").addEventListener("click", function(){
  var bin = document.getElementById("textIn").value || "";
  var v = validateBinaryString(bin);
  setVal(v.msg);
  if (!v.ok) { setOut(""); return; }
  var out = decodeBinaryToText(bin);
  setOut(out);
});

document.getElementById("btnCopy").addEventListener("click", function(){
  var txt = document.getElementById("textOut").value || "";
  var ta = document.createElement("textarea");
  ta.value = txt; document.body.appendChild(ta); ta.select(); document.execCommand("copy"); document.body.removeChild(ta);
});

document.getElementById("btnShare").addEventListener("click", function(){
  var txt = document.getElementById("textOut").value || "";
  if (navigator.share) navigator.share({ text: txt }).catch(function(){});
  else { var ta=document.createElement("textarea"); ta.value=txt; document.body.appendChild(ta); ta.select(); document.execCommand("copy"); document.body.removeChild(ta); alert("Copied to clipboard!"); }
});
</script>

    <div class="sharethis-inline-share-buttons"></div>
    <%@ include file="thanks.jsp"%>

    <hr>

    <%@ include file="footer_adsense.jsp"%>
    <%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
