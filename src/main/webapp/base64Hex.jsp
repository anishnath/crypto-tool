<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Base64 to Hex Converter (Hex to Base64) – Online, Fast, Free</title>
  <meta name="description" content="Free online Base64 to Hex converter and Hex to Base64 tool. Clean separators, add 0x prefix, uppercase, and copy results instantly. Client‑side, secure.">
  <meta name="keywords" content="base64 to hex, hex to base64, base64 converter, hex converter, base64 decode hex, base64 hex online, base64 to hex string, hex string to base64">
  <link rel="canonical" href="https://8gwifi.org/base64Hex.jsp">
  <meta property="og:type" content="website">
  <meta property="og:title" content="Base64 to Hex Converter (Hex to Base64) – Online, Fast, Free">
  <meta property="og:description" content="Convert Base64 ↔ Hex in your browser. Add prefixes, separators, and uppercase. No server upload.">
  <meta property="og:url" content="https://8gwifi.org/base64Hex.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/base64Hex.png">
  <meta name="twitter:card" content="summary">
  <meta name="twitter:title" content="Base64 to Hex Converter (Hex to Base64)">
  <meta name="twitter:description" content="Convert Base64 ↔ Hex in your browser. Add prefixes, separators, and uppercase.">

  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Base64 to Hex Converter (Hex to Base64)",
    "url": "https://8gwifi.org/base64Hex.jsp",
    "applicationCategory": "UtilitiesApplication",
    "description": "Convert Base64 to Hex and Hex to Base64 in the browser. Add separators, uppercase, 0x prefix, and copy results.",
    "offers": {"@type":"Offer","price":"0","priceCurrency":"USD"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"How do I convert Base64 to Hex?","acceptedAnswer":{"@type":"Answer","text":"Paste Base64, choose Base64 → Hex, then copy the Hex result. Use options to add separators, uppercase, or 0x prefix."}},
      {"@type":"Question","name":"Is the conversion secure?","acceptedAnswer":{"@type":"Answer","text":"Yes. Conversions run entirely in your browser (client‑side). No data is uploaded."}},
      {"@type":"Question","name":"Can I format the Hex output?","acceptedAnswer":{"@type":"Answer","text":"Yes. You can insert spaces or colons, add 0x prefix per byte, and switch to uppercase."}}
    ]
  }
  </script>
  <style>
    .b64hex .card-header { padding:.6rem .9rem; font-weight:600; }
    .b64hex .card-body { padding:.9rem; }
    .b64hex .form-group { margin-bottom:.6rem; }
    .b64hex .opts small { color:#6c757d; }
    .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
    .help { color:#6c757d; font-size:.9rem; }
    .drop-hint { border:2px dashed #cbd5e1; border-radius:8px; padding:.5rem; text-align:center; color:#64748b; }
    .drop-hint.drag { background:#f1f5f9; }
    #imgPreview { max-height: 160px; display:none; border:1px solid #e5e7eb; border-radius:6px; }
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 b64hex">
  <h1 class="mb-2">Base64 ↔ Hex Converter</h1>
  <p class="help mb-3">Convert Base64 to Hex and Hex to Base64 entirely in your browser (secure).</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Mode</h5>
        <div class="card-body">
          <div class="form-group">
            <select id="mode" class="form-control">
              <option value="b64tohex" selected>Base64 → Hex</option>
              <option value="hextob64">Hex → Base64</option>
            </select>
          </div>
          <div class="opts">
            <div class="form-group">
              <label for="separator">Hex Separator</label>
              <select id="separator" class="form-control">
                <option value="none">None</option>
                <option value="space">Space</option>
                <option value="colon" selected>Colon</option>
                <option value="dash">Dash (-)</option>
                <option value="comma">Comma (,)</option>
              </select>
              <small>Applies when output is Hex</small>
            </div>
            <div class="form-group">
              <label for="groupSize">Group every N bytes</label>
              <select id="groupSize" class="form-control">
                <option value="0" selected>None</option>
                <option value="2">2</option>
                <option value="4">4</option>
                <option value="8">8</option>
                <option value="16">16</option>
              </select>
              <small>Adds extra spacing between groups</small>
            </div>
            <div class="form-group form-check">
              <input type="checkbox" class="form-check-input" id="prefix0x">
              <label class="form-check-label" for="prefix0x">Add 0x prefix per byte</label>
            </div>
            <div class="form-group form-check">
              <input type="checkbox" class="form-check-input" id="uppercase">
              <label class="form-check-label" for="uppercase">Uppercase Hex</label>
            </div>
          </div>
        </div>
      </div>

      <div class="mb-3">
        <button class="btn btn-primary btn-block" id="btnConvert">Convert</button>
        <button class="btn btn-outline-secondary btn-block mt-2" id="btnClear">Clear</button>
        <button class="btn btn-outline-info btn-block mt-2" id="btnRoundtrip">Round‑trip Test</button>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Input</h5>
        <div class="card-body">
          <div class="drop-hint mb-2" id="dropZone">Drop a file here to auto‑convert</div>
          <textarea id="input" rows="6" class="form-control mono" placeholder="Paste Base64, Hex, or a data URI (data:image/png;base64,...)">SGVsbG8gOGd3aWZpLm9yZw==</textarea>
          <div id="err" class="text-danger small mt-2" style="display:none;"></div>
          <div class="mt-2">
            <img id="imgPreview" alt="preview"/>
          </div>
        </div>
      </div>
      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Output
          <span>
            <button class="btn btn-sm btn-outline-secondary mr-2" id="btnCopy">Copy</button>
            <button class="btn btn-sm btn-outline-secondary" id="btnDownload">Download</button>
          </span>
        </h5>
        <div class="card-body">
          <textarea id="output" rows="8" class="form-control mono" readonly></textarea>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Code Examples
          <span class="d-flex align-items-center">
            <select id="codeLang" class="form-control form-control-sm mr-2" style="width:auto;">
              <option value="java">Java</option>
              <option value="python">Python</option>
              <option value="js-browser">JavaScript (Browser)</option>
              <option value="js-node">JavaScript (Node.js)</option>
              <option value="go">Go</option>
              <option value="csharp">C#</option>
              <option value="php">PHP</option>
            </select>
            <button class="btn btn-sm btn-outline-secondary" id="btnCopyCode">Copy</button>
          </span>
        </h5>
        <div class="card-body">
<pre class="mono"><code id="codeBlock" class="language-java"></code></pre>
        </div>
      </div>
    </div>
  </div>
  <div class="card mb-3">
    <h5 class="card-header">Related Tools</h5>
    <div class="card-body">
      <ul class="mb-0">
        <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
        <li><a href="HexToStringFunctions.jsp">Hex ↔ String Converter</a></li>
        <li><a href="hexdump.jsp">Hexdump Generator</a></li>
        <li><a href="hexeditor.jsp">Hex Editor</a></li>
      </ul>
    </div>
  </div>
</div>

<script>
(function(){
  function cleanHex(s){
    return (s||'').replace(/0x/gi,'').replace(/[^0-9a-fA-F]/g,'');
  }
  function b64ToBytes(b64){
    try{
      const bin = atob(b64.replace(/\s+/g,''));
      const out = new Uint8Array(bin.length);
      for(let i=0;i<bin.length;i++) out[i] = bin.charCodeAt(i);
      return out;
    }catch(e){ throw new Error('Invalid Base64 input'); }
  }
  function bytesToHex(bytes, {sep='none', prefix=false, upper=false, group=0}={}){
    const parts = [];
    for(let i=0;i<bytes.length;i++){
      let h = bytes[i].toString(16).padStart(2,'0');
      if(upper) h = h.toUpperCase();
      parts.push(prefix ? (upper? '0X'+h : '0x'+h) : h);
    }
    let joiner = '';
    if(sep==='space') joiner = ' ';
    if(sep==='colon') joiner = ':';
    if(sep==='dash') joiner = '-';
    if(sep==='comma') joiner = ',';
    if(!group || group<=0) return parts.join(joiner);
    const out = [];
    for(let i=0;i<parts.length;i+=group){
      const chunk = parts.slice(i,i+group).join(joiner);
      out.push(chunk);
    }
    // extra spacing between groups for readability
    return out.join(joiner + joiner);
  }
  function hexToBytes(hex){
    const s = cleanHex(hex);
    if(s.length%2!==0) throw new Error('Hex length must be even');
    const out = new Uint8Array(s.length/2);
    for(let i=0;i<s.length;i+=2){
      out[i/2] = parseInt(s.substr(i,2),16);
    }
    return out;
  }
  function bytesToB64(bytes){
    let bin='';
    for(let i=0;i<bytes.length;i++) bin += String.fromCharCode(bytes[i]);
    return btoa(bin);
  }

  function convert(){
    const mode = document.getElementById('mode').value;
    let input = document.getElementById('input').value || '';
    const err = document.getElementById('err');
    err.style.display = 'none'; err.textContent='';
    try{
      // Detect data URI and auto‑extract Base64; preview if image
      const m = input.match(/^data:([^;]+);base64,(.*)$/i);
      if(m){
        document.getElementById('mode').value = 'b64tohex';
        input = m[2];
        const mime = m[1]||'';
        const img = document.getElementById('imgPreview');
        if(/^image\//i.test(mime)) { img.src = m[0]; img.style.display='inline-block'; } else { img.style.display='none'; }
      } else {
        document.getElementById('imgPreview').style.display='none';
      }
      if(mode==='b64tohex'){
        const bytes = b64ToBytes(input);
        const sep = document.getElementById('separator').value;
        const prefix = document.getElementById('prefix0x').checked;
        const upper = document.getElementById('uppercase').checked;
        const group = parseInt(document.getElementById('groupSize').value,10)||0;
        document.getElementById('output').value = bytesToHex(bytes,{sep, prefix, upper, group});
      } else {
        const bytes = hexToBytes(input);
        document.getElementById('output').value = bytesToB64(bytes);
      }
    }catch(e){ err.style.display='block'; err.textContent = e.message; document.getElementById('output').value=''; }
    // keep code sample in sync with user's current input/mode
    generateCode();
  }

  function jsEscDQ(s){ return (s||'').replace(/\\/g,'\\\\').replace(/\"/g,'\\\"'); }
  function jsEscSQ(s){ return (s||'').replace(/\\/g,'\\\\').replace(/'/g,"\\'"); }
  function generateCode(){
    const mode = document.getElementById('mode').value; // b64tohex | hextob64
    const lang = document.getElementById('codeLang').value;
    const raw = document.getElementById('input').value || '';
    // derive input
    let userB64 = null, userHex = null;
    const m = raw.match(/^data:[^;]+;base64,(.*)$/i);
    if(mode==='b64tohex'){
      userB64 = m ? m[1] : raw.trim();
    } else {
      userHex = (typeof cleanHex==='function') ? cleanHex(raw) : raw.trim();
    }
    let code = '', cls = '';
    if(lang==='java'){
      cls = 'language-java';
      if(mode==='b64tohex'){
        const v = jsEscDQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `import java.util.Base64;\n\nString b64 = "${v}";\nbyte[] bytes = Base64.getDecoder().decode(b64);\nStringBuilder sb = new StringBuilder();\nfor (byte b : bytes) sb.append(String.format("%02x", b));\nString hex = sb.toString();\nSystem.out.println(hex);`;
      } else {
        const v = jsEscDQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `import java.util.Base64;\n\nString hex = "${v}";\nint len = hex.length();\nbyte[] bytes = new byte[len/2];\nfor(int i=0;i<len;i+=2){ bytes[i/2] = (byte) Integer.parseInt(hex.substring(i,i+2), 16); }\nString b64 = Base64.getEncoder().encodeToString(bytes);\nSystem.out.println(b64);`;
      }
    } else if(lang==='python'){
      cls = 'language-python';
      if(mode==='b64tohex'){
        const v = jsEscSQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `import base64\n\nb64 = '${v}'\nhex_str = base64.b64decode(b64).hex()\nprint(hex_str)`;
      } else {
        const v = jsEscSQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `import base64\n\nhex_str = '${v}'\nb64 = base64.b64encode(bytes.fromhex(hex_str)).decode()\nprint(b64)`;
      }
    } else if(lang==='js-browser'){
      cls = 'language-javascript';
      if(mode==='b64tohex'){
        const v = jsEscSQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `const b64 = '${v}';\nconst bin = atob(b64);\nlet hex = '';\nfor (let i=0;i<bin.length;i++){ hex += bin.charCodeAt(i).toString(16).padStart(2,'0'); }\nconsole.log(hex);`;
      } else {
        const v = jsEscSQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `const hex = '${v}';\nlet bin = '';\nfor (let i=0;i<hex.length;i+=2){ bin += String.fromCharCode(parseInt(hex.substr(i,2),16)); }\nconst b64 = btoa(bin);\nconsole.log(b64);`;
      }
    } else if(lang==='js-node'){
      cls = 'language-javascript';
      if(mode==='b64tohex'){
        const v = jsEscSQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `const b64 = '${v}';\nconst hex = Buffer.from(b64, 'base64').toString('hex');\nconsole.log(hex);`;
      } else {
        const v = jsEscSQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `const hex = '${v}';\nconst b64 = Buffer.from(hex, 'hex').toString('base64');\nconsole.log(b64);`;
      }
    } else if(lang==='go'){
      cls = 'language-go';
      if(mode==='b64tohex'){
        const v = jsEscDQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `package main\nimport (\n  "encoding/base64"\n  "encoding/hex"\n  "fmt"\n)\nfunc main(){\n  b64 := "${v}"\n  data, _ := base64.StdEncoding.DecodeString(b64)\n  fmt.Println(hex.EncodeToString(data))\n}`;
      } else {
        const v = jsEscDQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `package main\nimport (\n  "encoding/base64"\n  "encoding/hex"\n  "fmt"\n)\nfunc main(){\n  hexStr := "${v}"\n  data, _ := hex.DecodeString(hexStr)\n  fmt.Println(base64.StdEncoding.EncodeToString(data))\n}`;
      }
    } else if(lang==='csharp'){
      cls = 'language-csharp';
      if(mode==='b64tohex'){
        const v = jsEscDQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `using System;\nusing System.Linq;\n\nvar b64 = "${v}";\nvar bytes = Convert.FromBase64String(b64);\nvar hex = BitConverter.ToString(bytes).Replace("-", "").ToLowerInvariant();\nConsole.WriteLine(hex);`;
      } else {
        const v = jsEscDQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `using System;\nusing System.Linq;\n\nvar hex = "${v}";\nbyte[] bytes = Enumerable.Range(0, hex.Length/2)\n  .Select(i => Convert.ToByte(hex.Substring(i*2,2), 16)).ToArray();\nvar b64 = Convert.ToBase64String(bytes);\nConsole.WriteLine(b64);`;
      }
    } else if(lang==='php'){
      cls = 'language-php';
      if(mode==='b64tohex'){
        const v = jsEscSQ(userB64 || 'SGVsbG8gOGd3aWZpLm9yZw==');
        code = `<?php\n$b64 = '${v}';\n$hex = bin2hex(base64_decode($b64));\necho $hex;`;
      } else {
        const v = jsEscSQ(userHex || '48656c6c6f203867776966692e6f7267');
        code = `<?php\n$hex = '${v}';\n$b64 = base64_encode(hex2bin($hex));\necho $b64;`;
      }
    }
    const block = document.getElementById('codeBlock');
    block.className = cls;
    block.textContent = code;
    if(window.hljs){
      if(hljs.highlightElement){ hljs.highlightElement(block); }
      else if(hljs.highlightBlock){ hljs.highlightBlock(block); }
    }
  }

  document.getElementById('btnConvert').addEventListener('click', convert);
  document.getElementById('input').addEventListener('input', function(){
    // live convert if output already produced or input changed after selection
    convert();
  });
  document.getElementById('mode').addEventListener('change', function(){
    const outEl = document.getElementById('output');
    const inEl = document.getElementById('input');
    const val = (outEl.value||'').trim();
    if(val.length){
      inEl.value = val;
      outEl.value = '';
    }
    // reset any preview on mode switch
    document.getElementById('imgPreview').style.display='none';
    convert();
    generateCode();
  });
  document.getElementById('separator').addEventListener('change', convert);
  document.getElementById('groupSize').addEventListener('change', convert);
  document.getElementById('prefix0x').addEventListener('change', convert);
  document.getElementById('uppercase').addEventListener('change', convert);
  document.getElementById('codeLang').addEventListener('change', generateCode);
  document.getElementById('btnClear').addEventListener('click', function(){
    document.getElementById('input').value='';
    document.getElementById('output').value='';
    document.getElementById('err').style.display='none';
  });
  document.getElementById('btnCopy').addEventListener('click', function(){
    const v = document.getElementById('output').value||'';
    navigator.clipboard.writeText(v).catch(()=>{});
  });

  // Copy code example
  document.getElementById('btnCopyCode').addEventListener('click', function(){
    const code = document.getElementById('codeBlock').textContent || '';
    const btn = this;
    function fallback(){
      const ta = document.createElement('textarea');
      ta.value = code; document.body.appendChild(ta); ta.select();
      try{ document.execCommand('copy'); }catch(e){}
      document.body.removeChild(ta);
    }
    if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(code).then(()=>{ btn.textContent='Copied'; setTimeout(()=>btn.textContent='Copy',1200); }).catch(()=>{ fallback(); btn.textContent='Copied'; setTimeout(()=>btn.textContent='Copy',1200); });
    } else { fallback(); btn.textContent='Copied'; setTimeout(()=>btn.textContent='Copy',1200); }
  });

  // Download output
  document.getElementById('btnDownload').addEventListener('click', function(){
    const v = document.getElementById('output').value||'';
    if(!v) return;
    const mode = document.getElementById('mode').value;
    const ext = (mode==='b64tohex')? 'hex' : 'b64';
    const blob = new Blob([v], {type:'text/plain'});
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url; a.download = `output.${ext}.txt`;
    document.body.appendChild(a); a.click(); document.body.removeChild(a);
    URL.revokeObjectURL(url);
  });

  // Drag & drop
  const dz = document.getElementById('dropZone');
  ;['dragenter','dragover'].forEach(ev=>dz.addEventListener(ev,(e)=>{e.preventDefault(); dz.classList.add('drag');}));
  ;['dragleave','drop'].forEach(ev=>dz.addEventListener(ev,(e)=>{e.preventDefault(); dz.classList.remove('drag');}));
  dz.addEventListener('drop', function(e){
    const file = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
    if(!file) return;
    const reader = new FileReader();
    reader.onload = function(){
      const buf = new Uint8Array(reader.result);
      const b64 = bytesToB64(buf);
      document.getElementById('mode').value = 'b64tohex';
      document.getElementById('input').value = b64;
      convert();
      dz.textContent = `Loaded ${file.name} (${file.size} bytes)`;
    };
    reader.readAsArrayBuffer(file);
  });

  // Round‑trip test
  document.getElementById('btnRoundtrip').addEventListener('click', function(){
    const mode = document.getElementById('mode').value;
    const input = document.getElementById('input').value || '';
    const err = document.getElementById('err');
    err.style.display='none'; err.textContent='';
    try{
      let bytes1, bytes2;
      if(mode==='b64tohex'){
        const m = input.match(/^data:[^;]+;base64,(.*)$/i);
        const src = m? m[1] : input;
        bytes1 = b64ToBytes(src);
        const hex = bytesToHex(bytes1);
        bytes2 = hexToBytes(hex);
      } else {
        bytes1 = hexToBytes(input);
        const b64 = bytesToB64(bytes1);
        bytes2 = b64ToBytes(b64);
      }
      if(bytes1.length !== bytes2.length) throw new Error('Mismatch after round‑trip');
      for(let i=0;i<bytes1.length;i++){ if(bytes1[i]!==bytes2[i]) throw new Error('Mismatch after round‑trip'); }
      err.style.display='block'; err.classList.remove('text-danger'); err.classList.add('text-success'); err.textContent='Round‑trip OK: bytes match.';
      setTimeout(()=>{ err.style.display='none'; err.classList.remove('text-success'); err.classList.add('text-danger'); }, 2000);
    }catch(e){ err.style.display='block'; err.classList.remove('text-success'); err.classList.add('text-danger'); err.textContent=e.message; }
  });

  // initial convert for default sample
  convert();
  generateCode();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>




<%@ include file="footer_adsense.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
