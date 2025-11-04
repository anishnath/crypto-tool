<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Base58 Encode/Decode Online – Bitcoin/Ripple/Flickr Alphabets</title>
  <meta name="description" content="Free online Base58 encoder/decoder supporting Bitcoin, Ripple, and Flickr alphabets. Encode/decode text and files, strict mode, and line wrapping — all client‑side.">
  <meta name="keywords" content="base58 encode online, base58 decode online, bitcoin base58 encoder, bitcoin base58 decoder, ripple base58, flickr base58, base58 converter, base58 file decoder, text to base58">
  <link rel="canonical" href="https://8gwifi.org/Base58Functions.jsp">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Base58 Encode/Decode","url":"https://8gwifi.org/Base58Functions.jsp","applicationCategory":"UtilitiesApplication","description":"Encode/decode Base58 with Bitcoin, Ripple, and Flickr alphabets. Text and file support.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I Base58 encode text online?","acceptedAnswer":{"@type":"Answer","text":"Select Encode → Text, choose an alphabet (Bitcoin/Ripple/Flickr), paste your text, and click Convert. Use Wrap to format output."}},
    {"@type":"Question","name":"How can I decode Base58 back to text?","acceptedAnswer":{"@type":"Answer","text":"Select Decode → Text, pick the correct alphabet, paste the Base58 string, and Convert. Enable Strict to fail on invalid characters."}},
    {"@type":"Question","name":"Which Base58 alphabet does Bitcoin use?","acceptedAnswer":{"@type":"Answer","text":"Bitcoin uses the alphabet 123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz (no 0, O, I, l). This is the default selection here."}},
    {"@type":"Question","name":"Can I encode or decode files with Base58?","acceptedAnswer":{"@type":"Answer","text":"Yes. Choose Encode → File and drop a file to get Base58, or choose Decode → File and paste Base58 to download the decoded bytes."}}
  ]}
  </script>
  <style>
    .b58 .card-header{padding:.6rem .9rem;font-weight:600}
    .b58 .card-body{padding:.9rem}
    .b58 .form-group{margin-bottom:.6rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .drop{border:2px dashed #cbd5e1;border-radius:8px;padding:.5rem;text-align:center;color:#64748b}
    .drop.drag{background:#f1f5f9}
  </style>
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Base58 Encode/Decode Online – Bitcoin/Ripple/Flickr">
  <meta property="og:description" content="Encode/decode Base58 for text and files with Bitcoin/Ripple/Flickr alphabets. Runs entirely in your browser.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/Base58Functions.jsp">
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 b58">
  <h1 class="mb-2">Base58 Encode/Decode</h1>
  <p class="text-muted mb-3">Base58 conversion with Bitcoin, Ripple, and Flickr alphabets. Supports text charsets, strict decode, line wrapping, drag‑and‑drop file encode, and file decode. All processing runs locally in your browser.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Options</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="mode">Mode</label>
            <select id="mode" class="form-control">
              <option value="enc-text" selected>Encode → Base58 (Text)</option>
              <option value="dec-text">Decode Base58 → Text</option>
              <option value="enc-file">Encode → Base58 (File)</option>
              <option value="dec-file">Decode Base58 → File</option>
            </select>
          </div>
          <div class="form-group">
            <label for="alphabet">Alphabet</label>
            <select id="alphabet" class="form-control">
              <option value="btc" selected>Bitcoin (123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz)</option>
              <option value="xrp">Ripple</option>
              <option value="flickr">Flickr</option>
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
            <li><a href="Base32Functions.jsp">Base32 Encode/Decode</a></li>
            <li><a href="HexToStringFunctions.jsp">Hex ↔ String</a></li>
          </ul>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Input</h5>
        <div class="card-body">
          <div class="drop mb-2" id="drop">Drop a file here to encode as Base58</div>
          <textarea id="input" class="form-control mono" rows="10" placeholder="Enter text to encode or Base58 to decode..."></textarea>
          <div id="err2" class="text-danger mt-2" style="display:none"></div>
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
        <li>Base58 omits 0, O, I, l to avoid visual ambiguity (depending on alphabet variant).</li>
        <li>Decoding ignores whitespace; enable Strict to error on any non‑alphabet characters.</li>
        <li>All conversions execute locally in your browser. No data is uploaded.</li>
      </ul>
    </div>
  </div>
</div>

<script>
(function(){
  // Alphabets
  const ALPHABET_BTC = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
  const ALPHABET_XRP = 'rpshnaf39wBUDNEGHJKLM4PQRST7VWXYZ2bcdefgijkm8oFqi1tuvAxyz';
  const ALPHABET_FLICKR = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
  function getAlphabet(){
    const v = document.getElementById('alphabet').value;
    if(v==='xrp') return ALPHABET_XRP;
    if(v==='flickr') return ALPHABET_FLICKR;
    return ALPHABET_BTC;
  }

  // Charset helpers (same approach as other pages)
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

  // Base58 implementation (base-x style)
  function base58Encode(bytes, alphabet){
    if(!bytes || bytes.length===0) return '';
    const BASE = alphabet.length;
    const LEADER = alphabet[0];
    let zeros = 0;
    while(zeros < bytes.length && bytes[zeros] === 0) zeros++;
    const size = ((bytes.length - zeros) * Math.log(256) / Math.log(BASE) + 1) >>> 0;
    const b58 = new Uint8Array(size);
    let length = 0;
    for(let i=zeros; i<bytes.length; i++){
      let carry = bytes[i];
      let j = 0;
      for(let k=size-1; (carry !== 0 || j < length) && k >= 0; k--, j++){
        carry += 256 * b58[k];
        b58[k] = carry % BASE;
        carry = (carry / BASE) | 0;
      }
      length = j;
    }
    let it = size - length;
    while(it < size && b58[it] === 0) it++;
    let out = '';
    for(let q=0;q<zeros;q++) out += LEADER;
    for(; it < size; it++) out += alphabet[b58[it]];
    return out;
  }
  function base58Decode(str, alphabet, strict){
    if(!str) return new Uint8Array();
    const BASE = alphabet.length;
    const LEADER = alphabet[0];
    const s = (str||'').replace(/\s+/g,'');
    let zeros = 0; while(zeros < s.length && s[zeros] === LEADER) zeros++;
    const size = ((s.length - zeros) * Math.log(BASE) / Math.log(256) + 1) >>> 0;
    const b256 = new Uint8Array(size);
    let length = 0;
    for(let i=zeros; i<s.length; i++){
      const ch = s[i];
      const val = alphabet.indexOf(ch);
      if(val === -1){ if(strict) throw new Error('Invalid Base58 character: ' + ch); else continue; }
      let carry = val;
      let j = 0;
      for(let k=size-1; (carry !== 0 || j < length) && k >= 0; k--, j++){
        carry += BASE * b256[k];
        b256[k] = carry % 256;
        carry = (carry / 256) | 0;
      }
      length = j;
    }
    let it = size - length;
    while(it < size && b256[it] === 0) it++;
    const out = new Uint8Array(zeros + (size - it));
    let p=0; for(; p<zeros; p++) out[p] = 0; for(; it<size; it++, p++) out[p] = b256[it];
    return out;
  }

  function wrapLines(s, n){ n = parseInt(n,10)||0; if(!n) return s; const out=[]; for(let i=0;i<s.length;i+=n){ out.push(s.substr(i,n)); } return out.join('\n'); }
  function isLikelyBase58(s, alphabet){
    if(!s) return false; const body = (s||'').replace(/\s+/g,''); if(!body) return false;
    for(let i=0;i<body.length;i++){ if(alphabet.indexOf(body[i])===-1) return false; }
    try { base58Decode(body, alphabet, true); return true; } catch(e){ return false; }
  }

  function convert(){
    const mode = document.getElementById('mode').value;
    const cs = document.getElementById('charset').value;
    const wrap = document.getElementById('wrap').value;
    const strict = document.getElementById('strict').checked;
    const alpha = getAlphabet();
    const inputEl = document.getElementById('input');
    const outEl = document.getElementById('output');
    const err = document.getElementById('err');
    err.style.display='none'; err.textContent='';
    try{
      const val = inputEl.value || '';
      if(mode === 'enc-text'){
        const bytes = encodeToBytes(val, cs);
        const b58 = base58Encode(bytes, alpha);
        outEl.value = wrapLines(b58, wrap);
      } else if(mode === 'dec-text'){
        const bytes = base58Decode(val, alpha, strict);
        outEl.value = decodeFromBytes(bytes, cs);
      } else if(mode === 'enc-file'){
        err.style.display='block'; err.textContent='Drop a file onto the drop zone to encode.';
      } else if(mode === 'dec-file'){
        const bytes = base58Decode(val, alpha, strict);
        const blob = new Blob([bytes], {type:'application/octet-stream'});
        const a=document.createElement('a'); const url=URL.createObjectURL(blob);
        a.href=url; a.download='decoded.bin'; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url);
        outEl.value='[Downloaded decoded.bin]';
      }
    }catch(e){ err.style.display='block'; err.textContent=e.message; outEl.value=''; }
  }

  // Buttons
  document.getElementById('btnConvert').addEventListener('click', convert);
  document.getElementById('btnClear').addEventListener('click', ()=>{ document.getElementById('input').value=''; document.getElementById('output').value=''; document.getElementById('err').style.display='none'; document.getElementById('err2').style.display='none'; });
  document.getElementById('btnCopy').addEventListener('click', ()=>{ const v=document.getElementById('output').value||''; if(navigator.clipboard) navigator.clipboard.writeText(v); });
  document.getElementById('btnDownload').addEventListener('click', ()=>{ const v=document.getElementById('output').value||''; const blob=new Blob([v],{type:'text/plain'}); const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download='base58.txt'; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); });
  document.getElementById('btnWrap64').addEventListener('click', ()=>{ document.getElementById('wrap').value='64'; convert(); });
  document.getElementById('btnWrap76').addEventListener('click', ()=>{ document.getElementById('wrap').value='76'; convert(); });
  document.getElementById('btnNoWrap').addEventListener('click', ()=>{ document.getElementById('wrap').value='0'; convert(); });
  document.getElementById('btnRound').addEventListener('click', function(){
    const mode=document.getElementById('mode').value;
    const input=document.getElementById('input').value||'';
    const err=document.getElementById('err');
    const cs=document.getElementById('charset').value;
    const alpha = getAlphabet();
    err.style.display='none';
    try{
      if(mode==='enc-text' || mode==='enc-file'){
        const b58 = base58Encode(encodeToBytes(input, cs), alpha);
        const back = decodeFromBytes(base58Decode(b58, alpha, true), cs);
        if(back !== input) throw new Error('Mismatch');
      } else {
        const cleaned = (input||'').replace(/\s+/g,'');
        const bytes = base58Decode(cleaned, alpha, true);
        const reenc = base58Encode(bytes, alpha);
        const norm = (s)=> (s||'').replace(/\s+/g,'');
        if(norm(reenc) !== norm(cleaned)) throw new Error('Mismatch');
      }
      err.classList.remove('text-danger'); err.classList.add('text-success'); err.textContent='Round‑trip OK'; err.style.display='block';
      setTimeout(()=>{err.style.display='none'; err.classList.remove('text-success'); err.classList.add('text-danger');},1500);
    }catch(e){ err.classList.remove('text-success'); err.classList.add('text-danger'); err.textContent=e.message; err.style.display='block'; }
  });

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
        const alpha = getAlphabet();
        const wrap = document.getElementById('wrap').value;
        let b58 = base58Encode(bytes, alpha);
        document.getElementById('mode').value='enc-file';
        document.getElementById('input').value='';
        document.getElementById('output').value = wrapLines(b58, wrap);
      };
      reader.readAsArrayBuffer(file);
    });
  }

  // Mode toggle: move output -> input for quick reverse
  document.getElementById('mode').addEventListener('change', function(){
    const outEl = document.getElementById('output');
    const inEl = document.getElementById('input');
    const val = (outEl.value||'').trim();
    const alpha = getAlphabet();
    if(val.length){
      const newMode = this.value;
      if(newMode==='dec-text' || newMode==='dec-file'){
        if(isLikelyBase58(val, alpha)) { inEl.value = val; outEl.value=''; }
      } else {
        inEl.value = val; outEl.value = '';
      }
    }
    convert();
  });
  ['alphabet','wrap','charset','strict'].forEach(id=>document.getElementById(id).addEventListener('change', convert));
  document.getElementById('input').addEventListener('input', convert);

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
