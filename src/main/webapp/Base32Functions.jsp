<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Base32 Encode/Decode Online – Text & File (RFC 4648)</title>
  <meta name="description" content="Free online Base32 encoder/decoder (RFC 4648). Encode or decode text and files, control padding, lowercase output, and line wrap. Works entirely in your browser.">
  <meta name="keywords" content="base32 encode online, base32 decode online, base32 file decoder, base32 padding, rfc 4648 base32, base32 converter, base32 to text, text to base32, lowercase base32">
  <link rel="canonical" href="https://8gwifi.org/Base32Functions.jsp">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Base32 Encode/Decode","url":"https://8gwifi.org/Base32Functions.jsp","applicationCategory":"UtilitiesApplication","description":"RFC 4648 Base32 encoder/decoder with padding and lowercase options.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I Base32 encode text online?","acceptedAnswer":{"@type":"Answer","text":"Select Encode → Text, paste your text, optionally toggle lowercase and remove padding, then click Convert."}},
    {"@type":"Question","name":"How can I decode Base32 back to text?","acceptedAnswer":{"@type":"Answer","text":"Select Decode → Text, paste the Base32 input (whitespace allowed), and Convert. Enable Strict to fail on invalid characters."}},
    {"@type":"Question","name":"Can I Base32 encode or decode files?","acceptedAnswer":{"@type":"Answer","text":"Yes. Choose Encode → File and drop a file to get Base32, or choose Decode → File and paste Base32 to download the decoded bytes."}},
    {"@type":"Question","name":"Does this use RFC 4648 Base32?","acceptedAnswer":{"@type":"Answer","text":"Yes. It uses the standard RFC 4648 Base32 alphabet (A–Z, 2–7) with optional '=' padding."}}
  ]}
  </script>
  <style>
    .b32 .card-header{padding:.6rem .9rem;font-weight:600}
    .b32 .card-body{padding:.9rem}
    .b32 .form-group{margin-bottom:.6rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .drop{border:2px dashed #cbd5e1;border-radius:8px;padding:.5rem;text-align:center;color:#64748b}
    .drop.drag{background:#f1f5f9}
  </style>
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Base32 Encode/Decode Online – RFC 4648">
  <meta property="og:description" content="Encode/decode Base32 for text and files. Control padding, lowercase, and wrapping. Runs in the browser.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/Base32Functions.jsp">
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 b32">
  <h1 class="mb-2">Base32 Encode/Decode</h1>
  <p class="text-muted mb-3">RFC 4648 Base32 conversion for text with optional padding, lowercase output, and line wrapping. All processing runs in your browser.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Options</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="mode">Mode</label>
            <select id="mode" class="form-control">
              <option value="enc-text" selected>Encode → Base32 (Text)</option>
              <option value="dec-text">Decode Base32 → Text</option>
              <option value="enc-file">Encode → Base32 (File)</option>
              <option value="dec-file">Decode Base32 → File</option>
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
            <input type="checkbox" class="form-check-input" id="lowercase">
            <label class="form-check-label" for="lowercase">Lowercase output (a‑z)</label>
          </div>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="nopad">
            <label class="form-check-label" for="nopad">Remove padding (=)</label>
          </div>
          <div class="form-group">
            <label for="wrap">Wrap lines (0 = no wrap)</label>
            <input type="number" min="0" step="1" id="wrap" class="form-control" value="0">
          </div>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="strict">
            <label class="form-check-label" for="strict">Strict decode (error on invalid chars)</label>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Actions</h5>
        <div class="card-body">
          <button class="btn btn-primary btn-sm" id="btnConvert">Convert</button>
          <button class="btn btn-secondary btn-sm" id="btnClear">Clear</button>
          <button class="btn btn-outline-info btn-sm" id="btnRound">Round‑trip Test</button>
          <button class="btn btn-outline-secondary btn-sm" id="btnCopy">Copy Output</button>
          <button class="btn btn-outline-secondary btn-sm" id="btnDownload">Download Output</button>
          <div id="err" class="text-danger mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Related Tools</h5>
        <div class="card-body">
          <ul class="mb-0">
            <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
            <li><a href="base64Hex.jsp">Base64 ↔ Hex</a></li>
            <li><a href="HexToStringFunctions.jsp">Hex ↔ String</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Input</h5>
        <div class="card-body">
          <div class="drop mb-2" id="drop">Drop a file here to encode as Base32</div>
          <textarea id="input" class="form-control mono" rows="10" placeholder="Enter text to encode or Base32 to decode..."></textarea>
          <div id="err" class="text-danger mt-2" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header d-flex justify-content-between align-items-center">Output
          <span>
            <button class="btn btn-sm btn-outline-secondary" id="btnWrap64">Wrap 64</button>
            <button class="btn btn-sm btn-outline-secondary" id="btnWrap76">Wrap 76</button>
            <button class="btn btn-sm btn-outline-secondary" id="btnNoWrap">No Wrap</button>
          </span>
        </h5>
        <div class="card-body">
          <textarea id="output" class="form-control mono" rows="12" readonly></textarea>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Notes</h5>
    <div class="card-body">
      <ul class="mb-0">
        <li>Uses the RFC 4648 alphabet: A‑Z, 2‑7. Padding with '=' is optional.</li>
        <li>Decoding ignores whitespace and separators. Enable Strict to error on invalid characters.</li>
        <li>All conversions execute locally in your browser. No data is uploaded.</li>
      </ul>
    </div>
  </div>
</div>

<script>
(function(){
  // Charset helpers (reused approach from Base64 page)
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
        bytes[i] = (cp <= 0xFF) ? cp : 0x3F;
      } else if(charset === 'ascii'){
        bytes[i] = (cp <= 0x7F) ? cp : 0x3F;
      } else if(charset === 'windows-1252'){
        if(w1252Encode[cp] !== undefined) bytes[i] = w1252Encode[cp];
        else bytes[i] = (cp <= 0xFF) ? cp : 0x3F;
      } else {
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

  // Base32 (RFC 4648) implementation
  const ALPHA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
  const ALPHA_L = 'abcdefghijklmnopqrstuvwxyz234567';

  function base32Encode(bytes, lowercase, withPad){
    const alphabet = lowercase ? ALPHA_L : ALPHA;
    let bits = 0, value = 0, out = '';
    for(let i=0;i<bytes.length;i++){
      value = (value << 8) | bytes[i];
      bits += 8;
      while(bits >= 5){
        out += alphabet[(value >>> (bits - 5)) & 31];
        bits -= 5;
      }
    }
    if(bits > 0){
      out += alphabet[(value << (5 - bits)) & 31];
    }
    if(withPad){
      while(out.length % 8 !== 0) out += '=';
    }
    return out;
  }

  function base32Decode(str, strict){
    if(!str) return new Uint8Array();
    // remove whitespace and separators; keep '=' for position if present
    let s = str.replace(/\s+/g,'');
    const map = new Int16Array(256); for(let i=0;i<256;i++) map[i] = -1;
    for(let i=0;i<ALPHA.length;i++){ map[ALPHA.charCodeAt(i)] = i; map[ALPHA_L.charCodeAt(i)] = i; }
    let bits = 0, value = 0; const out = [];
    for(let i=0;i<s.length;i++){
      const ch = s.charCodeAt(i);
      if(ch === 61 /* '=' */){ // padding; just reduce effective length
        // ignore padding symbols; decoder naturally stops on next chars
        continue;
      }
      const v = (ch < 256) ? map[ch] : -1;
      if(v === -1){
        if(strict) throw new Error('Invalid Base32 character: ' + s[i]);
        else continue;
      }
      value = (value << 5) | v;
      bits += 5;
      if(bits >= 8){
        out.push((value >>> (bits - 8)) & 0xFF);
        bits -= 8;
      }
    }
    return new Uint8Array(out);
  }

  function wrapLines(s, n){ n = parseInt(n,10)||0; if(!n) return s; const out=[]; for(let i=0;i<s.length;i+=n){ out.push(s.substr(i,n)); } return out.join('\n'); }
  function isLikelyBase32(s){
    if(!s) return false;
    const trimmed = s.trim();
    if(!trimmed) return false;
    const body = trimmed.replace(/\s+/g,'').replace(/=+$/,'');
    if(!/^[A-Za-z2-7]+$/.test(body)) return false;
    try { base32Decode(trimmed, true); return true; } catch(e){ return false; }
  }

  function convert(){
    const mode = document.getElementById('mode').value;
    const cs = document.getElementById('charset').value;
    const lowercase = document.getElementById('lowercase').checked;
    const nopad = document.getElementById('nopad').checked;
    const wrap = document.getElementById('wrap').value;
    const strict = document.getElementById('strict').checked;
    const inputEl = document.getElementById('input');
    const outEl = document.getElementById('output');
    const err = document.getElementById('err');
    err.style.display='none'; err.textContent='';
    try{
      const val = inputEl.value || '';
      if(mode === 'enc-text'){
        const bytes = encodeToBytes(val, cs);
        const b32 = base32Encode(bytes, lowercase, !nopad);
        outEl.value = wrapLines(b32, wrap);
      } else if(mode === 'dec-text'){
        const bytes = base32Decode(val, strict);
        outEl.value = decodeFromBytes(bytes, cs);
      } else if(mode === 'enc-file'){
        err.style.display='block'; err.textContent='Drop a file onto the drop zone to encode.';
      } else if(mode === 'dec-file'){
        const bytes = base32Decode(val, strict);
        const blob = new Blob([bytes], {type:'application/octet-stream'});
        const a=document.createElement('a'); const url=URL.createObjectURL(blob);
        a.href=url; a.download='decoded.bin'; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url);
        outEl.value='[Downloaded decoded.bin]';
      }
    }catch(e){ err.style.display='block'; err.textContent=e.message; outEl.value=''; }
  }

  // Buttons
  document.getElementById('btnConvert').addEventListener('click', convert);
  document.getElementById('btnClear').addEventListener('click', ()=>{ document.getElementById('input').value=''; document.getElementById('output').value=''; document.getElementById('err').style.display='none'; });
  document.getElementById('btnCopy').addEventListener('click', ()=>{ const v=document.getElementById('output').value||''; if(navigator.clipboard) navigator.clipboard.writeText(v); });
  document.getElementById('btnDownload').addEventListener('click', ()=>{ const v=document.getElementById('output').value||''; const blob=new Blob([v],{type:'text/plain'}); const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download='base32.txt'; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); });
  document.getElementById('btnRound').addEventListener('click', function(){
    const mode=document.getElementById('mode').value;
    const input=document.getElementById('input').value||'';
    const err=document.getElementById('err');
    const cs=document.getElementById('charset').value;
    const lowercase=document.getElementById('lowercase').checked;
    const nopad=document.getElementById('nopad').checked;
    err.style.display='none';
    try{
      if(mode==='enc-text' || mode==='enc-file'){
        const b32 = base32Encode(encodeToBytes(input, cs), lowercase, !nopad);
        const back = decodeFromBytes(base32Decode(b32, true), cs);
        if(back !== input) throw new Error('Mismatch');
      } else {
        const cleaned = input.replace(/\s+/g,'');
        const bytes = base32Decode(cleaned, true);
        const reenc = base32Encode(bytes, lowercase, !nopad);
        const norm = (s)=> (s||'').replace(/\s+/g,'').replace(/=+$/,'').toUpperCase();
        if(norm(reenc) !== norm(cleaned)) throw new Error('Mismatch');
      }
      err.classList.remove('text-danger'); err.classList.add('text-success'); err.textContent='Round‑trip OK'; err.style.display='block';
      setTimeout(()=>{err.style.display='none'; err.classList.remove('text-success'); err.classList.add('text-danger');},1500);
    }catch(e){ err.classList.remove('text-success'); err.classList.add('text-danger'); err.textContent=e.message; err.style.display='block'; }
  });
  document.getElementById('btnWrap64').addEventListener('click', ()=>{ document.getElementById('wrap').value='64'; convert(); });
  document.getElementById('btnWrap76').addEventListener('click', ()=>{ document.getElementById('wrap').value='76'; convert(); });
  document.getElementById('btnNoWrap').addEventListener('click', ()=>{ document.getElementById('wrap').value='0'; convert(); });
  // On mode change, move Output -> Input for quick reverse conversion
  document.getElementById('mode').addEventListener('change', function(){
    const outEl = document.getElementById('output');
    const inEl = document.getElementById('input');
    const val = (outEl.value||'').trim();
    if(val.length){
      const newMode = this.value;
      if(newMode==='dec-text' || newMode==='dec-file'){
        if(isLikelyBase32(val)) { inEl.value = val; outEl.value=''; }
      } else {
        inEl.value = val; outEl.value = '';
      }
    }
    convert();
  });
  ['lowercase','nopad','wrap','charset','strict'].forEach(id=>document.getElementById(id).addEventListener('change', convert));
  document.getElementById('input').addEventListener('input', convert);

  // Drag & drop
  const dz = document.getElementById('drop');
  if(dz){
    ['dragenter','dragover'].forEach(ev=>dz.addEventListener(ev,(e)=>{e.preventDefault(); dz.classList.add('drag');}));
    ['dragleave','drop'].forEach(ev=>dz.addEventListener(ev,(e)=>{e.preventDefault(); dz.classList.remove('drag');}));
    dz.addEventListener('drop', function(e){
      const file = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]; if(!file) return;
      const reader = new FileReader();
      reader.onload = function(){
        const bytes = new Uint8Array(reader.result);
        const lowercase = document.getElementById('lowercase').checked;
        const nopad = document.getElementById('nopad').checked;
        const wrap = document.getElementById('wrap').value;
        let b32 = base32Encode(bytes, lowercase, !nopad);
        document.getElementById('mode').value='enc-file';
        document.getElementById('input').value='';
        document.getElementById('output').value = wrapLines(b32, wrap);
      };
      reader.readAsArrayBuffer(file);
    });
  }

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
