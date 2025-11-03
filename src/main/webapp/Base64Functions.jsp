<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Base64 Encode/Decode – Text & File, URL‑Safe, Wrap, Data URI</title>
  <meta name="description" content="Free online Base64 encoder/decoder for text and files. URL‑safe option, padding control, line wrap, data URI paste, drag‑and‑drop, and code examples.">
  <meta name="keywords" content="base64 encode, base64 decode, base64 file, base64 url safe, base64 line wrap, base64 data uri, online base64 tool">
  <link rel="canonical" href="https://8gwifi.org/Base64Functions.jsp">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Base64 Encode/Decode","url":"https://8gwifi.org/Base64Functions.jsp","applicationCategory":"UtilitiesApplication","description":"Encode/decode Base64 for text and files with URL‑safe, padding, wrap, and data URI support.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I Base64 encode text?","acceptedAnswer":{"@type":"Answer","text":"Select Encode → Text, paste text, and click Convert. Toggle URL‑safe and wrap options as desired."}},
    {"@type":"Question","name":"How do I decode a Base64 file?","acceptedAnswer":{"@type":"Answer","text":"Select Decode → File, paste Base64 (or drop a file), then Convert to download the decoded file."}},
    {"@type":"Question","name":"Is it secure?","acceptedAnswer":{"@type":"Answer","text":"All conversions run entirely in your browser (client‑side). No uploads."}}
  ]}
  </script>
  <style>
    .b64 .card-header{padding:.6rem .9rem;font-weight:600}
    .b64 .card-body{padding:.9rem}
    .b64 .form-group{margin-bottom:.6rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .drop{border:2px dashed #cbd5e1;border-radius:8px;padding:.5rem;text-align:center;color:#64748b}
    .drop.drag{background:#f1f5f9}
    #imgPrev{max-height:160px;display:none;border:1px solid #e5e7eb;border-radius:6px}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 b64">
  <h1 class="mb-2">Base64 Encode/Decode</h1>
  <p class="text-muted mb-3">Encode/decode Base64 for text and files. URL‑safe option, padding control, line wrapping, data URI paste, drag‑and‑drop, and code examples.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Mode</h5>
        <div class="card-body">
          <div class="form-group">
            <select id="mode" class="form-control">
              <option value="enc-text" selected>Encode → Base64 (Text)</option>
              <option value="dec-text">Decode Base64 → Text</option>
              <option value="enc-file">Encode → Base64 (File)</option>
              <option value="dec-file">Decode Base64 → File</option>
            </select>
          </div>
          <div class="form-group">
            <label for="charset">Character Set (text)</label>
            <select id="charset" class="form-control">
              <option value="utf-8" selected>UTF‑8</option>
              <option value="iso-8859-1">ISO‑8859‑1 (Latin‑1)</option>
              <option value="windows-1252">Windows‑1252</option>
              <option value="ascii">ASCII (7‑bit)</option>
            </select>
          </div>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="buildDataUri">
            <label class="form-check-label" for="buildDataUri">Build Data URI when encoding</label>
          </div>
          <div class="form-group">
            <label for="mimeType">MIME Type (for Data URI)</label>
            <input type="text" id="mimeType" class="form-control" placeholder="e.g., text/plain or image/png" list="mimeList">
            <datalist id="mimeList">
              <option value="text/plain"></option>
              <option value="text/html"></option>
              <option value="application/json"></option>
              <option value="image/png"></option>
              <option value="image/jpeg"></option>
              <option value="application/octet-stream"></option>
            </datalist>
            <small class="text-muted">If empty for files, detects from file type when available.</small>
          </div>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="urlsafe">
            <label class="form-check-label" for="urlsafe">URL‑safe Base64 (-_ instead of +/)</label>
          </div>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="nopad">
            <label class="form-check-label" for="nopad">Remove padding (=)</label>
          </div>
          <div class="form-group">
            <label for="wrap">Line Wrap</label>
            <select id="wrap" class="form-control">
              <option value="0" selected>None</option>
              <option value="64">64</option>
              <option value="76">76 (MIME)</option>
            </select>
            <div class="mt-2">
              <button type="button" id="btnPEM" class="btn btn-sm btn-outline-secondary mr-2">PEM 64</button>
              <button type="button" id="btnMIME" class="btn btn-sm btn-outline-secondary">MIME 76</button>
            </div>
          </div>
        </div>
      </div>
      <div class="mb-3">
        <button class="btn btn-primary btn-block" id="btnConvert">Convert</button>
        <button class="btn btn-outline-secondary btn-block mt-2" id="btnClear">Clear</button>
        <button class="btn btn-outline-info btn-block mt-2" id="btnRound">Round‑trip Test</button>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Input</h5>
        <div class="card-body">
          <div class="drop mb-2" id="drop">Drop a file here to encode as Base64</div>
          <textarea id="input" rows="6" class="form-control mono" placeholder="Enter text or Base64 (or data URI)"></textarea>
          <div id="err" class="text-danger small mt-2" style="display:none;"></div>
          <div class="mt-2"><img id="imgPrev" alt="preview"></div>
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
        <li><a href="base64Hex.jsp">Base64 ↔ Hex</a></li>
        <li><a href="HexToStringFunctions.jsp">Hex ↔ String</a></li>
        <li><a href="hexdump.jsp">Hexdump</a></li>
      </ul>
    </div>
  </div>
</div>

<script>
(function(){
  function isLikelyBase64(s){
    if(!s) return false;
    const str = s.trim();
    if(/^data:[^;]+;base64,/.test(str)) return true;
    const body = str.replace(/\s+/g,'');
    if(!/^[A-Za-z0-9+/_=-]+$/.test(body)) return false; // allow url-safe -_
    try {
      // normalize url-safe for probe
      const probe = body.replace(/-/g,'+').replace(/_/g,'/');
      const pad = probe.length % 4 === 0 ? probe : probe + '='.repeat((4 - (probe.length%4))%4);
      atob(pad);
      return true;
    } catch(e){ return false; }
  }
  function wrapLines(s, n){ n = parseInt(n,10)||0; if(!n) return s; const out=[]; for(let i=0;i<s.length;i+=n){ out.push(s.substr(i,n)); } return out.join('\n'); }
  function toUrlSafe(b64, removePad){ let v=b64.replace(/\+/g,'-').replace(/\//g,'_'); if(removePad) v=v.replace(/=+$/,''); return v; }
  function fromUrlSafe(b64){ return b64.replace(/-/g,'+').replace(/_/g,'/'); }
  function bytesToB64(bytes){ let bin=''; for(let i=0;i<bytes.length;i++) bin+=String.fromCharCode(bytes[i]); return btoa(bin); }
  function b64ToBytes(b64){ const bin=atob(b64); const out=new Uint8Array(bin.length); for(let i=0;i<bin.length;i++) out[i]=bin.charCodeAt(i); return out; }

  // Windows-1252 mapping for bytes 0x80..0x9F
  const w1252Decode = {
    0x80:0x20AC, 0x82:0x201A, 0x83:0x0192, 0x84:0x201E, 0x85:0x2026, 0x86:0x2020, 0x87:0x2021,
    0x88:0x02C6, 0x89:0x2030, 0x8A:0x0160, 0x8B:0x2039, 0x8C:0x0152, 0x8E:0x017D,
    0x91:0x2018, 0x92:0x2019, 0x93:0x201C, 0x94:0x201D, 0x95:0x2022, 0x96:0x2013, 0x97:0x2014,
    0x98:0x02DC, 0x99:0x2122, 0x9A:0x0161, 0x9B:0x203A, 0x9C:0x0153, 0x9E:0x017E, 0x9F:0x0178
  };
  const w1252Encode = {}; (function(){ for(const k in w1252Decode){ w1252Encode[w1252Decode[k]] = parseInt(k); }})();

  function encodeToBytes(str, charset){
    charset = (charset||'utf-8').toLowerCase();
    if(charset === 'utf-8'){
      const enc = new TextEncoder();
      return enc.encode(str);
    }
    const bytes = new Uint8Array(str.length);
    for(let i=0;i<str.length;i++){
      const cp = str.charCodeAt(i);
      if(charset === 'iso-8859-1'){
        bytes[i] = (cp <= 0xFF) ? cp : 0x3F; // '?'
      } else if(charset === 'ascii'){
        bytes[i] = (cp <= 0x7F) ? cp : 0x3F; // 7-bit ASCII
      } else if(charset === 'windows-1252'){
        if(w1252Encode[cp] !== undefined) bytes[i] = w1252Encode[cp];
        else bytes[i] = (cp <= 0xFF) ? cp : 0x3F;
      } else {
        // fallback to utf-8
        const enc = new TextEncoder();
        return enc.encode(str);
      }
    }
    return bytes;
  }
  function decodeFromBytes(bytes, charset){
    charset = (charset||'utf-8').toLowerCase();
    if(charset === 'utf-8'){
      const dec = new TextDecoder();
      return dec.decode(bytes);
    }
    let out = '';
    for(let i=0;i<bytes.length;i++){
      const b = bytes[i];
      if(charset === 'iso-8859-1'){
        out += String.fromCharCode(b);
      } else if(charset === 'ascii'){
        out += String.fromCharCode(b & 0x7F);
      } else if(charset === 'windows-1252'){
        const cp = (b >= 0x80 && b <= 0x9F && w1252Decode[b] !== undefined) ? w1252Decode[b] : b;
        out += String.fromCharCode(cp);
      } else {
        const dec = new TextDecoder();
        return dec.decode(bytes);
      }
    }
    return out;
  }

  function convert(){
    const mode = document.getElementById('mode').value;
    const urlsafe = document.getElementById('urlsafe').checked;
    const nopad = document.getElementById('nopad').checked;
    const wrap = document.getElementById('wrap').value;
    const inputEl = document.getElementById('input');
    const outEl = document.getElementById('output');
    const err = document.getElementById('err');
    const img = document.getElementById('imgPrev');
    err.style.display='none'; err.textContent=''; img.style.display='none';
    try{
      let val = inputEl.value || '';
      // data URI support
      const m = val.match(/^data:([^;]+);base64,(.*)$/i);
      if(m && (mode==='dec-text' || mode==='dec-file')){ val = m[2]; if(/^image\//i.test(m[1])){ img.src=m[0]; img.style.display='inline-block'; } }
      const cs = document.getElementById('charset').value;
      const buildDataUri = document.getElementById('buildDataUri').checked;
      const mimeInput = (document.getElementById('mimeType').value||'').trim();
      if(mode==='enc-text'){
        let b64 = bytesToB64(encodeToBytes(val, cs));
        if(urlsafe) b64 = toUrlSafe(b64, nopad); else if(nopad) b64=b64.replace(/=+$/,'');
        if(buildDataUri){
          const mime = mimeInput || 'text/plain';
          outEl.value = `data:${mime};base64,${b64}`;
        } else {
          outEl.value = wrapLines(b64, wrap);
        }
      } else if(mode==='dec-text'){
        let b64 = val.replace(/\s+/g,'');
        if(urlsafe) b64 = fromUrlSafe(b64);
        // pad if necessary
        if(!nopad && b64.length%4!==0) b64 = b64 + '='.repeat((4 - (b64.length%4))%4);
        outEl.value = decodeFromBytes(b64ToBytes(b64), cs);
      } else if(mode==='enc-file'){
        err.style.display='block'; err.textContent='Drop a file onto the drop zone to encode.';
      } else if(mode==='dec-file'){
        let b64 = val.replace(/\s+/g,''); if(urlsafe) b64 = fromUrlSafe(b64);
        if(!nopad && b64.length%4!==0) b64 = b64 + '='.repeat((4 - (b64.length%4))%4);
        const bytes = b64ToBytes(b64);
        const blob = new Blob([bytes], {type:'application/octet-stream'});
        const a=document.createElement('a'); const url=URL.createObjectURL(blob);
        a.href=url; a.download='decoded.bin'; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url);
        outEl.value='[Downloaded decoded.bin]';
      }
    }catch(e){ err.style.display='block'; err.textContent=e.message; outEl.value=''; }
    generateCode();
  }

  // Drag & drop
  const dz = document.getElementById('drop');
  ;['dragenter','dragover'].forEach(ev=>dz.addEventListener(ev,(e)=>{e.preventDefault(); dz.classList.add('drag');}));
  ;['dragleave','drop'].forEach(ev=>dz.addEventListener(ev,(e)=>{e.preventDefault(); dz.classList.remove('drag');}));
  dz.addEventListener('drop', function(e){
    const file = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]; if(!file) return;
    const reader = new FileReader();
    reader.onload = function(){
      const bytes = new Uint8Array(reader.result);
      let b64 = bytesToB64(bytes);
      const urlsafe = document.getElementById('urlsafe').checked;
      const nopad = document.getElementById('nopad').checked;
      if(urlsafe) b64 = toUrlSafe(b64, nopad); else if(nopad) b64=b64.replace(/=+$/,'');
      const buildDataUri = document.getElementById('buildDataUri').checked;
      const mimeInput = (document.getElementById('mimeType').value||'').trim();
      const mime = mimeInput || file.type || 'application/octet-stream';
      document.getElementById('mode').value='enc-file';
      document.getElementById('input').value='';
      document.getElementById('output').value = buildDataUri ? (`data:${mime};base64,`+b64) : b64;
      generateCode();
    };
    reader.readAsArrayBuffer(file);
  });

  // Buttons and options
  document.getElementById('btnConvert').addEventListener('click', convert);
  document.getElementById('btnClear').addEventListener('click', ()=>{ document.getElementById('input').value=''; document.getElementById('output').value=''; document.getElementById('err').style.display='none'; document.getElementById('imgPrev').style.display='none'; });
  document.getElementById('btnCopy').addEventListener('click', ()=>{ const v=document.getElementById('output').value||''; if(navigator.clipboard) navigator.clipboard.writeText(v); });
  document.getElementById('btnDownload').addEventListener('click', ()=>{ const v=document.getElementById('output').value||''; if(!v) return; const blob=new Blob([v],{type:'text/plain'}); const url=URL.createObjectURL(blob); const a=document.createElement('a'); const mode=document.getElementById('mode').value; const ext=(mode.startsWith('enc')?'b64':'txt'); a.href=url; a.download=`output.${ext}.txt`; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); });
  document.getElementById('btnRound').addEventListener('click', ()=>{
    const mode=document.getElementById('mode').value;
    const input=document.getElementById('input').value||'';
    const err=document.getElementById('err');
    const cs=document.getElementById('charset').value;
    const urlsafe=document.getElementById('urlsafe').checked;
    const nopad=document.getElementById('nopad').checked;
    err.style.display='none';
    try{
      if(mode==='enc-text'){
        // text -> base64 (apply toggles) -> decode back -> compare
        let b64 = bytesToB64(encodeToBytes(input, cs));
        if(urlsafe) b64 = toUrlSafe(b64, nopad); else if(nopad) b64=b64.replace(/=+$/,'');
        // reverse toggles to standard b64 for decode
        let b64std = urlsafe ? fromUrlSafe(b64) : b64;
        if(!nopad && b64std.length%4!==0) b64std = b64std + '='.repeat((4 - (b64std.length%4))%4);
        const back = decodeFromBytes(b64ToBytes(b64std), cs);
        if(back !== input) throw new Error('Mismatch');
      } else {
        // base64 -> bytes -> base64, compare normalized
        let b = input.replace(/\s+/g,'');
        const origNorm = (urlsafe? b : toUrlSafe(b,false)).replace(/=+$/,'');
        // convert to standard for decode
        let bStd = urlsafe ? fromUrlSafe(b) : b;
        if(bStd.length%4!==0) bStd = bStd + '='.repeat((4 - (bStd.length%4))%4);
        const back = bytesToB64(b64ToBytes(bStd));
        const backNorm = toUrlSafe(back,false).replace(/=+$/,'');
        if(backNorm !== origNorm) throw new Error('Mismatch');
      }
      err.classList.remove('text-danger'); err.classList.add('text-success'); err.textContent='Round‑trip OK'; err.style.display='block';
      setTimeout(()=>{err.style.display='none'; err.classList.remove('text-success'); err.classList.add('text-danger');},1500);
    }catch(e){ err.classList.remove('text-success'); err.classList.add('text-danger'); err.textContent=e.message; err.style.display='block'; }
  });
  // On mode change, move Output -> Input for quick reverse conversion
  document.getElementById('mode').addEventListener('change', function(){
    const outEl = document.getElementById('output');
    const inEl = document.getElementById('input');
    const val = (outEl.value||'').trim();
    if(val.length){
      const newMode = this.value;
      if(newMode==='dec-text' || newMode==='dec-file'){
        if(isLikelyBase64(val)) { inEl.value = val; outEl.value=''; }
        // else keep as-is to avoid decode error
      } else {
        // encode modes can take plain text
        inEl.value = val; outEl.value = '';
      }
    }
    document.getElementById('imgPrev').style.display='none';
    convert();
  });
  ['urlsafe','nopad','wrap','charset','buildDataUri','mimeType'].forEach(id=>document.getElementById(id).addEventListener('change', convert));
  document.getElementById('input').addEventListener('input', convert);
  document.getElementById('btnPEM').addEventListener('click', ()=>{ document.getElementById('wrap').value='64'; convert(); });
  document.getElementById('btnMIME').addEventListener('click', ()=>{ document.getElementById('wrap').value='76'; convert(); });

  // Code generator
  function escDQ(s){ return (s||'').replace(/\\/g,'\\\\').replace(/\"/g,'\\\"'); }
  function escSQ(s){ return (s||'').replace(/\\/g,'\\\\').replace(/'/g,"\\'"); }
  function generateCode(){
    const lang=document.getElementById('codeLang').value; const mode=document.getElementById('mode').value; const raw=document.getElementById('input').value||''; const cs=document.getElementById('charset').value; let code='', cls='';
    const javaCs = (cs==='iso-8859-1'?'java.nio.charset.StandardCharsets.ISO_8859_1': cs==='windows-1252'? 'java.nio.charset.Charset.forName("windows-1252")' : 'java.nio.charset.StandardCharsets.UTF_8');
    const pyCs = (cs==='iso-8859-1'?'latin-1': cs==='windows-1252'? 'cp1252' : 'utf-8');
    const nodeCs = (cs==='iso-8859-1'?'latin1': cs==='windows-1252'? 'latin1' : 'utf8');
    if(lang==='java'){ cls='language-java'; if(mode.startsWith('enc')){ const v=escDQ(raw||'Hello'); code=`import java.util.Base64;\nimport java.nio.charset.*;\nvar b64 = Base64.getEncoder().encodeToString("${v}".getBytes(${javaCs}));\nSystem.out.println(b64);`; } else { const v=escDQ(raw||'SGVsbG8='); code=`import java.util.Base64;\nimport java.nio.charset.*;\nvar bytes = Base64.getDecoder().decode("${v}");\nvar s = new String(bytes, ${javaCs});\nSystem.out.println(s);`; } }
    else if(lang==='python'){ cls='language-python'; if(mode.startsWith('enc')){ const v=escSQ(raw||'Hello'); code=`import base64\ntext='${v}'.encode('${pyCs}')\nprint(base64.b64encode(text).decode())`; } else { const v=escSQ(raw||'SGVsbG8='); code=`import base64\nb64='${v}'\nprint(base64.b64decode(b64).decode('${pyCs}'))`; } }
    else if(lang==='js-browser'){ cls='language-javascript'; if(mode.startsWith('enc')){ const v=escSQ(raw||'Hello'); if(cs==='utf-8'){ code=`const enc=new TextEncoder();\nconst b64=btoa(String.fromCharCode(...enc.encode('${v}')));\nconsole.log(b64);`; } else { code=`// Browser TextEncoder is UTF‑8 only; encoding '${cs}' shown conceptually\nfunction toBytesLatin1(s){return Uint8Array.from([...s].map(ch=>ch.charCodeAt(0)&0xFF));}\nconst b64=btoa(String.fromCharCode(...toBytesLatin1('${v}')));\nconsole.log(b64);`; } } else { const v=escSQ(raw||'SGVsbG8='); if(cs==='utf-8'){ code=`const bin=atob('${v}');\nconst bytes=Uint8Array.from(bin, c=>c.charCodeAt(0));\nconst dec=new TextDecoder();\nconsole.log(dec.decode(bytes));`; } else { code=`const bin=atob('${v}');\nconst s=[...bin].map(c=>String.fromCharCode(c.charCodeAt(0))).join('');\nconsole.log(s); // interpret as '${cs}' bytes`; } } }
    else if(lang==='js-node'){ cls='language-javascript'; if(mode.startsWith('enc')){ const v=escSQ(raw||'Hello'); code=`const b64=Buffer.from('${v}','${nodeCs}').toString('base64');\nconsole.log(b64);`; } else { const v=escSQ(raw||'SGVsbG8='); code=`const s=Buffer.from('${v}','base64').toString('${nodeCs}');\nconsole.log(s);`; } }
    else if(lang==='go'){ cls='language-go'; if(mode.startsWith('enc')){ const v=escDQ(raw||'Hello'); code=`package main\nimport (\n  "encoding/base64"\n  "fmt"\n)\nfunc main(){\n  s := "${v}"\n  fmt.Println(base64.StdEncoding.EncodeToString([]byte(s)))\n}`; } else { const v=escDQ(raw||'SGVsbG8='); code=`package main\nimport (\n  "encoding/base64"\n  "fmt"\n)\nfunc main(){\n  b, _ := base64.StdEncoding.DecodeString("${v}")\n  fmt.Println(string(b))\n}`; } }
    else if(lang==='csharp'){ cls='language-csharp'; if(mode.startsWith('enc')){ const v=escDQ(raw||'Hello'); const csName=(cs==='iso-8859-1'? 'ISO-8859-1' : cs==='windows-1252'? 'Windows-1252' : 'UTF-8'); code=`using System;\nvar enc = System.Text.Encoding.GetEncoding("${csName}");\nvar b64 = Convert.ToBase64String(enc.GetBytes("${v}"));\nConsole.WriteLine(b64);`; } else { const v=escDQ(raw||'SGVsbG8='); const csName=(cs==='iso-8859-1'? 'ISO-8859-1' : cs==='windows-1252'? 'Windows-1252' : 'UTF-8'); code=`using System;\nvar enc = System.Text.Encoding.GetEncoding("${csName}");\nvar s = enc.GetString(Convert.FromBase64String("${v}"));\nConsole.WriteLine(s);`; } }
    else if(lang==='php'){ cls='language-php'; if(mode.startsWith('enc')){ const v=escSQ(raw||'Hello'); code=`<?php\n$s='${v}';\necho base64_encode($s);`; } else { const v=escSQ(raw||'SGVsbG8='); code=`<?php\n$b64='${v}';\necho base64_decode($b64);`; } }
    const block=document.getElementById('codeBlock'); block.className=cls; block.textContent=code; if(window.hljs){ if(hljs.highlightElement) hljs.highlightElement(block); else if(hljs.highlightBlock) hljs.highlightBlock(block); }
  }
  document.getElementById('codeLang').addEventListener('change', generateCode);
  document.getElementById('btnCopyCode').addEventListener('click', function(){ const code=document.getElementById('codeBlock').textContent||''; if(navigator.clipboard) navigator.clipboard.writeText(code); });

  // initial
  convert();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
