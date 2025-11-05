<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>File Hash Generator (SHA‑256, SHA‑1, SHA‑512, SHA3, CRC32) – No Upload</title>
  <meta name="description" content="Compute and verify SHA‑256, SHA‑1, SHA‑384, SHA‑512, SHA3‑224/256/384/512, MD5, RIPEMD‑160, CRC32/CRC32C, and Adler‑32 file hashes entirely in your browser. Drag‑and‑drop. No uploads.">
  <meta name="keywords" content="sha256 file hash online, sha512 checksum, sha3 hash, md5 checksum, ripemd160, crc32, crc32c, adler32, verify file hash, compute checksum online, webcrypto">
  
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="File Hash Generator (SHA‑256, SHA‑1, SHA‑512, SHA3, CRC32) – No Upload">
  <meta property="og:description" content="Compute SHA‑2, SHA‑3, MD5, RIPEMD‑160, CRC32/CRC32C, Adler‑32 checksums in your browser. Drag‑and‑drop. No uploads.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/mdfile.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/hash.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="File Hash Generator – No Upload (SHA‑256, SHA‑512, SHA3, CRC32)">
  <meta name="twitter:description" content="Fast, private, client‑side checksum calculator for SHA‑2, SHA‑3, MD5, RIPEMD‑160, CRC32/CRC32C, Adler‑32.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/hash.png">
<%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"File Hash Generator","url":"https://8gwifi.org/mdfile.jsp","applicationCategory":"UtilitiesApplication","description":"Compute/verify SHA‑1, SHA‑256, SHA‑384, SHA‑512 file hashes in the browser (no upload).","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I calculate a file's SHA‑256?","acceptedAnswer":{"@type":"Answer","text":"Click Choose File or drop a file, select SHA‑256, and the checksum is computed locally in your browser."}},
    {"@type":"Question","name":"How do I verify a hash?","acceptedAnswer":{"@type":"Answer","text":"Paste the expected hash in the Verify box; the tool compares it to the computed value (hex or Base64) and shows match/mismatch."}},
    {"@type":"Question","name":"Is my file uploaded?","acceptedAnswer":{"@type":"Answer","text":"No. All hashing uses WebCrypto and runs entirely client‑side in your browser."}}
  ]}
  </script>
  <style>
    .md .card-header{padding:.6rem .9rem;font-weight:600}
    .md .card-body{padding:.9rem}
    .md .form-group{margin-bottom:.6rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .drop{border:2px dashed #cbd5e1;border-radius:8px;padding:.7rem;text-align:center;color:#64748b}
    .drop.drag{background:#f1f5f9}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 md">
  <h1 class="mb-2">File Hash Generator</h1>
  <p class="text-muted mb-3">Compute and verify SHA‑1, SHA‑256, SHA‑384, and SHA‑512 checksums for files in your browser. Drag‑and‑drop supported. No uploads.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Options</h5>
        <div class="card-body">
          
          <div class="form-group">
            <label>Compute Multiple</label>
            <div class="small text-muted mb-1">Select one or more and click Compute Selected. Uses the same loaded file without re-reading.</div>
            <div class="row">
              <div class="col-6">
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA-256" value="SHA-256" checked><label class="form-check-label" for="m_SHA-256">SHA‑256</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA-512" value="SHA-512"><label class="form-check-label" for="m_SHA-512">SHA‑512</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA-384" value="SHA-384"><label class="form-check-label" for="m_SHA-384">SHA‑384</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA-1" value="SHA-1"><label class="form-check-label" for="m_SHA-1">SHA‑1</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA-224" value="SHA-224"><label class="form-check-label" for="m_SHA-224">SHA‑224</label></div>
              </div>
              <div class="col-6">
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA3-256" value="SHA3-256"><label class="form-check-label" for="m_SHA3-256">SHA3‑256</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA3-224" value="SHA3-224"><label class="form-check-label" for="m_SHA3-224">SHA3‑224</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA3-384" value="SHA3-384"><label class="form-check-label" for="m_SHA3-384">SHA3‑384</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA3-512" value="SHA3-512"><label class="form-check-label" for="m_SHA3-512">SHA3‑512</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_MD5" value="MD5"><label class="form-check-label" for="m_MD5">MD5</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_RIPEMD-160" value="RIPEMD-160"><label class="form-check-label" for="m_RIPEMD-160">RIPEMD‑160</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_CRC32" value="CRC32"><label class="form-check-label" for="m_CRC32">CRC32</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_CRC32C" value="CRC32C"><label class="form-check-label" for="m_CRC32C">CRC32C</label></div>
                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_ADLER32" value="ADLER32"><label class="form-check-label" for="m_ADLER32">Adler‑32</label></div>
<%--                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA512_224" value="SHA-512/224"><label class="form-check-label" for="m_SHA512_224">SHA‑512/224</label></div>--%>
<%--                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_SHA512_256" value="SHA-512/256"><label class="form-check-label" for="m_SHA512_256">SHA‑512/256</label></div>--%>
<%--                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_BLAKE2b" value="BLAKE2b"><label class="form-check-label" for="m_BLAKE2b">BLAKE2b (JS)</label></div>--%>
<%--                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_BLAKE2s" value="BLAKE2s"><label class="form-check-label" for="m_BLAKE2s">BLAKE2s (JS)</label></div>--%>
<%--                <div class="form-check"><input class="form-check-input multi-algo" type="checkbox" id="m_BLAKE3" value="BLAKE3"><label class="form-check-label" for="m_BLAKE3">BLAKE3 (WASM)</label></div>--%>
              </div>
            </div>
            <button class="btn btn-sm btn-outline-primary mt-2" id="btnComputeMulti">Compute Selected</button>
          </div>
        </div>
      </div>

      
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Drop a File</h5>
        <div class="card-body">
          <div class="drop mb-2" id="drop">Drop a file here to hash</div>
          <div id="info" class="small text-muted"></div>
        </div>
      </div>

        <div class="card mb-3">
            <h5 class="card-header">All Selected Hashes</h5>
            <div class="card-body">
                <div id="multiResults" class="mono small"></div>
            </div>
        </div>

      <div class="card mb-3">
        <h5 class="card-header">Display Options</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="outFmt">Output</label>
            <select id="outFmt" class="form-control" style="max-width:220px;">
              <option value="hex" selected>Hex</option>
              <option value="base64">Base64</option>
            </select>
          </div>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="upperHex">
            <label class="form-check-label" for="upperHex">Uppercase hex</label>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Verify</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="expected">Expected hash (hex or Base64)</label>
            <textarea id="expected" class="form-control mono" rows="3" placeholder="Paste expected hash to compare..."></textarea>
          </div>
          <button class="btn btn-sm btn-outline-primary" id="btnVerify">Compare</button>
          <div id="cmp" class="mt-2 small" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Actions</h5>
        <div class="card-body">
          <input type="file" id="fileInput" class="d-none">
          <button class="btn btn-primary btn-sm" id="btnPick">Choose File</button>
          <button class="btn btn-secondary btn-sm" id="btnClear">Clear</button>
          <div id="err" class="text-danger mt-2" style="display:none"></div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Notes</h5>
    <div class="card-body">
      <ul class="mb-0">
        <li>Runs fully client‑side using WebCrypto. Your file never leaves your device.</li>
        <li>Outputs Hex or Base64; wrap/uppercase options affect display only.</li>
        <li>Large files may take longer to process since browsers hash in memory.</li>
      </ul>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Hash Algorithms Info</h5>
    <div class="card-body">
      <ul>
        <li><b>SHA‑2 (SHA‑1/224/256/384/512)</b>: Cryptographic hashes standardized by NIST. SHA‑256 (32 bytes) is widely used for file checksums and integrity. SHA‑1 (20 bytes) is deprecated for collision resistance.</li>
        <li><b>SHA‑3 (SHA3‑224/256/384/512)</b>: Keccak sponge construction. Alternative to SHA‑2, with different internal design; similar output sizes.</li>
        <li><b>MD5 (16 bytes)</b>: Legacy checksum only. Fast but broken for collisions; do not use for security. Still useful for deduping and legacy tooling.</li>
        <li><b>RIPEMD‑160 (20 bytes)</b>: Legacy cryptographic hash (used in some blockchain address pipelines). Stronger than MD5/SHA‑1, but generally replaced by SHA‑2/3.</li>
        <li><b>CRC32 / CRC32C (4 bytes)</b>: Non‑cryptographic checksums for error detection (archives, storage). CRC32C uses the Castagnoli polynomial and is common in storage systems.</li>
        <li><b>Adler‑32 (4 bytes)</b>: Very fast checksum (zlib). Good for accidental error detection, not for security.</li>
        <li><b>SHA‑512/224, SHA‑512/256</b>: Truncated variants of SHA‑512 with different IVs. Provide SHA‑256‑class outputs with SHA‑512 performance on 64‑bit platforms.</li>
        <li><b>BLAKE2s/BLAKE2b</b>: Modern fast hashes (successors to SHA‑2 in many apps). BLAKE2b targets 64‑bit, BLAKE2s targets 32‑bit platforms.</li>
        <li><b>BLAKE3</b>: Very fast, parallel hash with tree mode; great for large files. Typically provided via WASM for performance.</li>
      </ul>
    </div>
  </div>
</div>

<script>
(function(){
  function bytesToHex(bytes, upper){ const hex=[...bytes].map(b=>('0'+b.toString(16)).slice(-2)).join(''); return upper?hex.toUpperCase():hex; }
  function bytesToB64(bytes){ let bin=''; for(let i=0;i<bytes.length;i++) bin+=String.fromCharCode(bytes[i]); return btoa(bin); }
  function wrapLines(s, n){ n=parseInt(n,10)||0; if(!n) return s; const out=[]; for(let i=0;i<s.length;i+=n) out.push(s.substr(i,n)); return out.join('\n'); }
  function fmtSize(n){ if(!n&&n!==0) return ''; const k=1024, u=['B','KB','MB','GB']; let i=0; let v=n; while(v>=k && i<u.length-1){ v/=k; i++; } return (Math.round(v*100)/100)+' '+u[i]; }

  let currentFile=null; let currentHash=null; let currentBuf=null; let multiMap=null; // {algo: Uint8Array}

  async function compute(buf){
    // Primary output is fixed to SHA-256
    currentHash = await computeFor('SHA-256', buf);
    renderOutput();
  }
  function computeFor(algo, buf){
    const bytes = new Uint8Array(buf);
    if(algo==='SHA-1' || algo==='SHA-256' || algo==='SHA-384' || algo==='SHA-512'){
      return crypto.subtle.digest(algo, buf).then(d=> new Uint8Array(d));
    } else if(algo==='SHA-224'){
      return Promise.resolve(sha2_224(bytes));
    } else if(algo==='SHA3-256'){
      return Promise.resolve(sha3_256(bytes));
    } else if(algo==='SHA3-224'){
      return Promise.resolve(sha3_224(bytes));
    } else if(algo==='SHA3-384'){
      return Promise.resolve(sha3_384(bytes));
    } else if(algo==='SHA3-512'){
      return Promise.resolve(sha3_512(bytes));
    } else if(algo==='MD5'){
      return Promise.resolve(md5(bytes));
    } else if(algo==='RIPEMD-160'){
      return Promise.resolve(ripemd160(bytes));
    } else if(algo==='CRC32'){
      return Promise.resolve(crc32(bytes));
    } else if(algo==='CRC32C'){
      return Promise.resolve(crc32c(bytes));
    } else if(algo==='ADLER32'){
      return Promise.resolve(adler32(bytes));
    } else if(algo==='SHA-512/224' || algo==='SHA-512/256'){
      return Promise.reject(new Error(algo+' not supported in this build'));
    } else if(algo==='BLAKE2b' || algo==='BLAKE2s'){
      return Promise.reject(new Error(algo+' JS implementation not yet bundled'));
    } else if(algo==='BLAKE3'){
      return Promise.reject(new Error('BLAKE3 (WASM) not bundled'));    
    }
    return Promise.reject(new Error('Unsupported algorithm'));
  }
  function renderOutput(){ return; }

  function setInfo(file){
    const info=document.getElementById('info');
    if(!file){ info.textContent=''; return; }
    info.innerHTML = `<strong>File:</strong> ${file.name} &nbsp; <strong>Size:</strong> ${fmtSize(file.size)}`;
  }

  function handleFile(file){
    const err=document.getElementById('err'); err.style.display='none'; err.textContent='';
    try{
      const reader=new FileReader();
      reader.onload = async function(){ currentFile=file; setInfo(file); currentBuf = reader.result; await compute(currentBuf); await computeSelectedMulti(); };
      reader.readAsArrayBuffer(file);
    }catch(e){ err.style.display='block'; err.textContent=e.message; }
  }

  // Actions
  document.getElementById('btnPick').addEventListener('click', ()=> document.getElementById('fileInput').click());
  document.getElementById('fileInput').addEventListener('change', function(){ const f=this.files&&this.files[0]; if(f) handleFile(f); });
  document.getElementById('btnClear').addEventListener('click', ()=>{ currentFile=null; currentHash=null; const out=document.getElementById('output'); if(out) out.value=''; setInfo(null); document.getElementById('expected').value=''; document.getElementById('cmp').style.display='none'; document.getElementById('err').style.display='none'; document.getElementById('multiResults').innerHTML=''; });
  // Optional legacy buttons if present
  if(document.getElementById('btnCopy')){
    document.getElementById('btnCopy').addEventListener('click', ()=>{ const v=(document.getElementById('output')||{}).value||''; if(navigator.clipboard) navigator.clipboard.writeText(v); });
  }
  if(document.getElementById('btnDownload')){
    document.getElementById('btnDownload').addEventListener('click', ()=>{ const v=(document.getElementById('output')||{}).value||''; const blob=new Blob([v],{type:'text/plain'}); const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download='hash.txt'; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); });
  }
  // Re-render on format options for both single and multi outputs
  ;['outFmt','upperHex'].forEach(id=>document.getElementById(id).addEventListener('change', ()=>{ renderOutput(); renderMulti(); }));
  // Recompute multi when selection changes
  document.querySelectorAll('.multi-algo').forEach(cb=> cb.addEventListener('change', ()=>{ if(currentBuf) computeSelectedMulti(); }));
  async function computeSelectedMulti(){
    const err=document.getElementById('err'); err.style.display='none'; err.textContent='';
    if(!currentBuf){ err.style.display='block'; err.textContent='Choose or drop a file first.'; return; }
    const boxes=[...document.querySelectorAll('.multi-algo:checked')]; if(!boxes.length){ err.style.display='block'; err.textContent='Select at least one algorithm.'; return; }
    const algos=boxes.map(b=>b.value);
    try{
      const results = await Promise.all(algos.map(a=>computeFor(a, currentBuf)));
      multiMap={}; algos.forEach((a,i)=> multiMap[a]=results[i]);
      renderMulti();
    }catch(e){ err.style.display='block'; err.textContent=e.message; }
  }
  document.getElementById('btnComputeMulti').addEventListener('click', computeSelectedMulti);

  // Verify
  document.getElementById('btnVerify').addEventListener('click', function(){
    const cmp=document.getElementById('cmp'); cmp.style.display='none'; cmp.textContent=''; cmp.classList.remove('text-success','text-danger');
    const expected=(document.getElementById('expected').value||'').replace(/\s+/g,''); if(!expected){ return; }
    if(!currentHash){ cmp.textContent='Compute a hash first.'; cmp.classList.add('text-danger'); cmp.style.display='block'; return; }
    const isHex = /^[0-9a-fA-F]+$/.test(expected);
    const curHex = bytesToHex(currentHash,false);
    const curB64 = bytesToB64(currentHash);
    const ok = isHex ? (expected.toLowerCase()===curHex) : (expected===curB64);
    if(ok){ cmp.textContent='Match ✓'; cmp.classList.add('text-success'); }
    else { cmp.textContent='No match ✗'; cmp.classList.add('text-danger'); }
    cmp.style.display='block';
  });

  // Drag & drop
  const dz=document.getElementById('drop');
  ['dragenter','dragover'].forEach(ev=>dz.addEventListener(ev, e=>{ e.preventDefault(); dz.classList.add('drag'); }));
  ['dragleave','drop'].forEach(ev=>dz.addEventListener(ev, e=>{ e.preventDefault(); dz.classList.remove('drag'); }));
  dz.addEventListener('drop', e=>{ const f=e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]; if(f) handleFile(f); });

  function renderMulti(){
    const el=document.getElementById('multiResults'); if(!el) return;
    if(!multiMap){ el.innerHTML=''; return; }
    const fmt=document.getElementById('outFmt').value; const upper=document.getElementById('upperHex').checked;
    const rows=Object.keys(multiMap).map(a=>{
      const bytes=multiMap[a]; const text = (fmt==='hex')? bytesToHex(bytes, upper) : bytesToB64(bytes);
      const id='copy_'+a.replace(/[^A-Za-z0-9]/g,'_');
      return `<div class="d-flex align-items-center mb-2"><div style="min-width:120px;font-weight:600;">${a}</div><div class="flex-fill"><input type="text" class="form-control form-control-sm mono" value="${text}" readonly></div><button class="btn btn-sm btn-outline-secondary ml-2" data-copy="${a}">Copy</button></div>`;
    });
    el.innerHTML = rows.join('');
    el.querySelectorAll('[data-copy]').forEach(btn=>{
      btn.addEventListener('click', function(){
        const parent=this.closest('div'); const input=parent.querySelector('input'); if(navigator.clipboard) navigator.clipboard.writeText(input.value);
      });
    });
  }

  // ---- Hash implementations (pure JS) ----
  function rotr(x,n){ return (x>>>n) | (x<<(32-n)); }
  function toWords(bytes){ const len=((bytes.length+9+63)>>>6)<<4; const w=new Uint32Array(len); let i=0; for(; i+3<bytes.length; i+=4){ w[i>>2]=(bytes[i]<<24)|(bytes[i+1]<<16)|(bytes[i+2]<<8)|bytes[i+3]; } let tmp=0; let rem=bytes.length&3; if(rem){ tmp = bytes[i]<<24; if(rem>1) tmp|=bytes[i+1]<<16; if(rem>2) tmp|=bytes[i+2]<<8; w[i>>2]=tmp; } else { w[i>>2]=0; }
    const bitLen=bytes.length*8; w[((bytes.length>>2))] |= (0x80<<24)>>>((bytes.length&3)*8);
    w[w.length-2] = (bitLen/Math.pow(2,32))>>>0; w[w.length-1] = bitLen>>>0; return w; }

  // SHA-256/SHA-224
  const K256=new Uint32Array([1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298]);
  function sha2_224(bytes){ return sha2(bytes,true); }
  function sha2(bytes,is224){
    const w=toWords(bytes); const W=new Uint32Array(64);
    let a,b,c,d,e,f,g,h;
    let H=is224? new Uint32Array([0xc1059ed8,0x367cd507,0x3070dd17,0xf70e5939,0xffc00b31,0x68581511,0x64f98fa7,0xbefa4fa4])
               : new Uint32Array([0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]);
    for(let i=0;i<w.length;i+=16){
      for(let t=0;t<16;t++) W[t]=w[i+t]>>>0;
      for(let t=16;t<64;t++){
        const s0=rotr(W[t-15],7)^rotr(W[t-15],18)^(W[t-15]>>>3);
        const s1=rotr(W[t-2],17)^rotr(W[t-2],19)^(W[t-2]>>>10);
        W[t]=(W[t-16]+s0+W[t-7]+s1)>>>0;
      }
      a=H[0];b=H[1];c=H[2];d=H[3];e=H[4];f=H[5];g=H[6];h=H[7];
      for(let t=0;t<64;t++){
        const S1=rotr(e,6)^rotr(e,11)^rotr(e,25);
        const ch=(e&f)^(~e&g);
        const temp1=(h+S1+ch+K256[t]+W[t])>>>0;
        const S0=rotr(a,2)^rotr(a,13)^rotr(a,22);
        const maj=(a&b)^(a&c)^(b&c);
        const temp2=(S0+maj)>>>0;
        h=g;g=f;f=e;e=(d+temp1)>>>0;d=c;c=b;b=a;a=(temp1+temp2)>>>0;
      }
      H[0]=(H[0]+a)>>>0; H[1]=(H[1]+b)>>>0; H[2]=(H[2]+c)>>>0; H[3]=(H[3]+d)>>>0;
      H[4]=(H[4]+e)>>>0; H[5]=(H[5]+f)>>>0; H[6]=(H[6]+g)>>>0; H[7]=(H[7]+h)>>>0;
    }
    const out=is224? new Uint8Array(28) : new Uint8Array(32);
    const words=is224? H.subarray(0,7):H;
    let p=0; for(let i=0;i<words.length;i++){ out[p++]=(words[i]>>>24)&255; out[p++]=(words[i]>>>16)&255; out[p++]=(words[i]>>>8)&255; out[p++]=words[i]&255; }
    return out;
  }

  // MD5
  function md5(bytes){
    function ff(a,b,c,d,x,s,t){return add(rol(add(add(a, (b&c)|((~b)&d)), add(x,t)),s),b);} 
    function gg(a,b,c,d,x,s,t){return add(rol(add(add(a, (b&d)|(c&(~d))), add(x,t)),s),b);} 
    function hh(a,b,c,d,x,s,t){return add(rol(add(add(a, b^c^d), add(x,t)),s),b);} 
    function ii(a,b,c,d,x,s,t){return add(rol(add(add(a, c^(b|(~d))), add(x,t)),s),b);} 
    function add(x,y){return (x+y)>>>0;} function rol(x,c){return (x<<c)|(x>>>(32-c));}
    // pad
    const n=bytes.length; const l=(n+8>>>6<<4)+16; const w=new Uint32Array(l);
    for(let i=0;i<n;i++) w[i>>2] |= bytes[i]<<((i%4)<<3);
    w[n>>2] |= 0x80<<((n%4)<<3);
    const bitLen=n*8; w[l-2]=bitLen&0xffffffff; w[l-1]=(bitLen/4294967296)>>>0;
    let a=0x67452301, b=0xefcdab89, c=0x98badcfe, d=0x10325476;
    for(let i=0;i<l;i+=16){
      let aa=a,bb=b,cc=c,dd=d;
      a=ff(a,b,c,d,w[i+0],7,0xd76aa478); d=ff(d,a,b,c,w[i+1],12,0xe8c7b756); c=ff(c,d,a,b,w[i+2],17,0x242070db); b=ff(b,c,d,a,w[i+3],22,0xc1bdceee);
      a=ff(a,b,c,d,w[i+4],7,0xf57c0faf); d=ff(d,a,b,c,w[i+5],12,0x4787c62a); c=ff(c,d,a,b,w[i+6],17,0xa8304613); b=ff(b,c,d,a,w[i+7],22,0xfd469501);
      a=ff(a,b,c,d,w[i+8],7,0x698098d8); d=ff(d,a,b,c,w[i+9],12,0x8b44f7af); c=ff(c,d,a,b,w[i+10],17,0xffff5bb1); b=ff(b,c,d,a,w[i+11],22,0x895cd7be);
      a=ff(a,b,c,d,w[i+12],7,0x6b901122); d=ff(d,a,b,c,w[i+13],12,0xfd987193); c=ff(c,d,a,b,w[i+14],17,0xa679438e); b=ff(b,c,d,a,w[i+15],22,0x49b40821);
      a=gg(a,b,c,d,w[i+1],5,0xf61e2562); d=gg(d,a,b,c,w[i+6],9,0xc040b340); c=gg(c,d,a,b,w[i+11],14,0x265e5a51); b=gg(b,c,d,a,w[i+0],20,0xe9b6c7aa);
      a=gg(a,b,c,d,w[i+5],5,0xd62f105d); d=gg(d,a,b,c,w[i+10],9,0x02441453); c=gg(c,d,a,b,w[i+15],14,0xd8a1e681); b=gg(b,c,d,a,w[i+4],20,0xe7d3fbc8);
      a=gg(a,b,c,d,w[i+9],5,0x21e1cde6); d=gg(d,a,b,c,w[i+14],9,0xc33707d6); c=gg(c,d,a,b,w[i+3],14,0xf4d50d87); b=gg(b,c,d,a,w[i+8],20,0x455a14ed);
      a=gg(a,b,c,d,w[i+13],5,0xa9e3e905); d=gg(d,a,b,c,w[i+2],9,0xfcefa3f8); c=gg(c,d,a,b,w[i+7],14,0x676f02d9); b=gg(b,c,d,a,w[i+12],20,0x8d2a4c8a);
      a=hh(a,b,c,d,w[i+5],4,0xfffa3942); d=hh(d,a,b,c,w[i+8],11,0x8771f681); c=hh(c,d,a,b,w[i+11],16,0x6d9d6122); b=hh(b,c,d,a,w[i+14],23,0xfde5380c);
      a=hh(a,b,c,d,w[i+1],4,0xa4beea44); d=hh(d,a,b,c,w[i+4],11,0x4bdecfa9); c=hh(c,d,a,b,w[i+7],16,0xf6bb4b60); b=hh(b,c,d,a,w[i+10],23,0xbebfbc70);
      a=hh(a,b,c,d,w[i+13],4,0x289b7ec6); d=hh(d,a,b,c,w[i+0],11,0xeaa127fa); c=hh(c,d,a,b,w[i+3],16,0xd4ef3085); b=hh(b,c,d,a,w[i+6],23,0x04881d05);
      a=hh(a,b,c,d,w[i+9],4,0xd9d4d039); d=hh(d,a,b,c,w[i+12],11,0xe6db99e5); c=hh(c,d,a,b,w[i+15],16,0x1fa27cf8); b=hh(b,c,d,a,w[i+2],23,0xc4ac5665);
      a=ii(a,b,c,d,w[i+0],6,0xf4292244); d=ii(d,a,b,c,w[i+7],10,0x432aff97); c=ii(c,d,a,b,w[i+14],15,0xab9423a7); b=ii(b,c,d,a,w[i+5],21,0xfc93a039);
      a=ii(a,b,c,d,w[i+12],6,0x655b59c3); d=ii(d,a,b,c,w[i+3],10,0x8f0ccc92); c=ii(c,d,a,b,w[i+10],15,0xffeff47d); b=ii(b,c,d,a,w[i+1],21,0x85845dd1);
      a=ii(a,b,c,d,w[i+8],6,0x6fa87e4f); d=ii(d,a,b,c,w[i+15],10,0xfe2ce6e0); c=ii(c,d,a,b,w[i+6],15,0xa3014314); b=ii(b,c,d,a,w[i+13],21,0x4e0811a1);
      a=ii(a,b,c,d,w[i+4],6,0xf7537e82); d=ii(d,a,b,c,w[i+11],10,0xbd3af235); c=ii(c,d,a,b,w[i+2],15,0x2ad7d2bb); b=ii(b,c,d,a,w[i+9],21,0xeb86d391);
      a=add(a,aa); b=add(b,bb); c=add(c,cc); d=add(d,dd);
    }
    const out=new Uint8Array(16);
    const arr=[a,b,c,d]; let p=0; for(let i=0;i<4;i++){ out[p++]=arr[i]&255; out[p++]=(arr[i]>>>8)&255; out[p++]=(arr[i]>>>16)&255; out[p++]=(arr[i]>>>24)&255; }
    return out;
  }

  // CRC32
  let _crcTab=null; function makeCrc(){ if(_crcTab) return _crcTab; const t=new Uint32Array(256); for(let n=0;n<256;n++){ let c=n; for(let k=0;k<8;k++){ c = (c&1)? (0xedb88320^(c>>>1)) : (c>>>1);} t[n]=c>>>0;} _crcTab=t; return t; }
  function crc32(bytes){ const tab=makeCrc(); let c=0^(-1); for(let i=0;i<bytes.length;i++){ c=(c>>>8)^tab[(c^bytes[i])&0xFF]; } c=(c^(-1))>>>0; return new Uint8Array([(c>>>24)&255,(c>>>16)&255,(c>>>8)&255,c&255]); }
  // CRC32C (Castagnoli)
  let _crcTabC=null; function makeCrcC(){ if(_crcTabC) return _crcTabC; const t=new Uint32Array(256); for(let n=0;n<256;n++){ let c=n; for(let k=0;k<8;k++){ c = (c&1)? (0x82f63b78^(c>>>1)) : (c>>>1);} t[n]=c>>>0;} _crcTabC=t; return t; }
  function crc32c(bytes){ const tab=makeCrcC(); let c=0^(-1); for(let i=0;i<bytes.length;i++){ c=(c>>>8)^tab[(c^bytes[i])&0xFF]; } c=(c^(-1))>>>0; return new Uint8Array([(c>>>24)&255,(c>>>16)&255,(c>>>8)&255,c&255]); }
  // Adler-32
  function adler32(bytes){ let a=1,b=0; const MOD=65521; for(let i=0;i<bytes.length;i++){ a=(a+bytes[i])%MOD; b=(b+a)%MOD; } const val=((b<<16)>>>0)|(a>>>0); return new Uint8Array([(val>>>24)&255,(val>>>16)&255,(val>>>8)&255,val&255]); }

  // SHA3-256 (Keccak-f[1600]) using BigInt
  function sha3_256(msg){ const RC=[1n,32898n,9223372039002292224n,9223372039002292353n,32907n,9223372039002292354n,9223372039002292237n,9223372039002292355n,32909n,138n,136n,2147483658n,2147483649n,9223372036854808714n,9223372036854808705n,138n,136n,2147483658n,2147483649n,9223372036854808714n,9223372036854808705n,0n,0n,0n];
    const r=136; const q=32; // rate=1088 bits, output 256 bits
    // pad
    let bytes = new Uint8Array(msg);
    let blocks = Math.ceil((bytes.length+1)/r);
    const buf=new Uint8Array(blocks*r); buf.set(bytes); buf[bytes.length]=0x06; buf[blocks*r-1]^=0x80;
    // state 5x5 lanes
    const S=new Array(25).fill(0n);
    for(let b=0;b<blocks;b++){
      for(let i=0;i<r;i+=8){
        let v=0n; for(let k=0;k<8;k++){ v|= BigInt(buf[b*r+i+k]) << (8n*BigInt(k)); }
        S[i/8] ^= v;
      }
      // keccak-f rounds
      keccakF(S, RC);
    }
    // squeeze
    const out=new Uint8Array(q);
    for(let i=0;i<q;i+=8){ let v=S[i/8]; for(let k=0;k<8;k++){ out[i+k] = Number((v>>(8n*BigInt(k))) & 0xffn); } }
    return out;
  }
  function sha3_224(msg){ return sha3_generic(msg, 144, 28); }
  function sha3_384(msg){ return sha3_generic(msg, 104, 48); }
  function sha3_512(msg){ return sha3_generic(msg, 72, 64); }
  function sha3_generic(msg, r, outLen){ const RC=[1n,32898n,9223372039002292224n,9223372039002292353n,32907n,9223372039002292354n,9223372039002292237n,9223372039002292355n,32909n,138n,136n,2147483658n,2147483649n,9223372036854808714n,9223372036854808705n,138n,136n,2147483658n,2147483649n,9223372036854808714n,9223372036854808705n,0n,0n,0n];
    let bytes = new Uint8Array(msg);
    let blocks = Math.ceil((bytes.length+1)/r);
    const buf=new Uint8Array(blocks*r); buf.set(bytes); buf[bytes.length]=0x06; buf[blocks*r-1]^=0x80;
    const S=new Array(25).fill(0n);
    for(let b=0;b<blocks;b++){
      for(let i=0;i<r;i+=8){ let v=0n; for(let k=0;k<8;k++){ v|= BigInt(buf[b*r+i+k]) << (8n*BigInt(k)); } S[i/8] ^= v; }
      keccakF(S, RC);
    }
    const out=new Uint8Array(outLen);
    for(let i=0;i<outLen;i+=8){ let v=S[i/8]; for(let k=0;k<8 && i+k<outLen;k++){ out[i+k]= Number((v>>(8n*BigInt(k))) & 0xffn); } }
    return out;
  }
  function rotl64(x,n){ return ((x<<BigInt(n)) | (x>>(64n-BigInt(n)))) & 0xffffffffffffffffn; }
  function keccakF(s, RC){
    const r=[0,1,62,28,27,36,44,6,55,20,3,10,43,25,39,41,45,15,21,8,18,2,61,56,14];
    for(let round=0; round<24; round++){
      // theta
      const C=new Array(5).fill(0n); for(let x=0;x<5;x++){ C[x]=s[x]^s[x+5]^s[x+10]^s[x+15]^s[x+20]; }
      const D=new Array(5); for(let x=0;x<5;x++){ D[x]= C[(x+4)%5] ^ rotl64(C[(x+1)%5],1); }
      for(let x=0;x<5;x++){ for(let y=0;y<5;y++){ s[x+5*y] = s[x+5*y] ^ D[x]; } }
      // rho and pi
      let B=new Array(25).fill(0n);
      for(let x=0;x<5;x++) for(let y=0;y<5;y++){ const idx=x+5*y; const X=y; const Y=(2*x+3*y)%5; B[X+5*Y] = rotl64(s[idx], r[idx]); }
      // chi
      for(let x=0;x<5;x++) for(let y=0;y<5;y++){ s[x+5*y] = B[x+5*y] ^ ((~B[(x+1)%5+5*y]) & B[(x+2)%5+5*y]); }
      // iota
      s[0] = s[0] ^ RC[round];
    }
  }

  // RIPEMD-160
  function ripemd160(bytes){
    function rol(x,n){return (x<<n)|(x>>>(32-n));}
    function f(j,x,y,z){ if(j<=15) return x^y^z; if(j<=31) return (x&y)|((~x)&z); if(j<=47) return (x|(~y))^z; if(j<=63) return (x&z)|(y&(~z)); return x^(y|(~z)); }
    function K(j){ return j<=15?0x00000000: j<=31?0x5a827999: j<=47?0x6ed9eba1: j<=63?0x8f1bbcdc:0xa953fd4e; }
    function KK(j){ return j<=15?0x50a28be6: j<=31?0x5c4dd124: j<=47?0x6d703ef3: j<=63?0x7a6d76e9:0x00000000; }
    const r=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,7,4,13,1,10,6,15,3,12,0,9,5,2,14,11,8,3,10,14,4,9,15,8,1,2,7,0,6,13,11,5,12,1,9,11,10,0,8,12,4,13,3,7,15,14,5,6,2,4,0,5,9,7,12,2,10,14,1,3,8,11,6,15,13];
    const rr=[5,14,7,0,9,2,11,4,13,6,15,8,1,10,3,12,6,11,3,7,0,13,5,10,14,15,8,12,4,9,1,2,15,5,1,3,7,14,6,9,11,8,12,2,10,0,4,13,8,6,4,1,3,11,15,0,5,12,2,13,9,7,10,14,12,15,10,4,1,5,8,7,6,2,13,14,0,3,9,11];
    const s=[11,14,15,12,5,8,7,9,11,13,14,15,6,7,9,8,7,6,8,13,11,9,7,15,7,12,15,9,11,7,13,12,11,13,6,7,14,9,13,15,14,8,13,6,5,12,7,5,11,12,14,15,14,15,9,8,9,14,5,6,8,6,5,12,9,15,5,11,6,8,13,12,5,12,13,14,11,8,5,6];
    const ss=[8,9,9,11,13,15,15,5,7,7,8,11,14,14,12,6,9,13,15,7,12,8,9,11,7,7,12,7,6,15,13,11,9,7,15,11,8,6,6,14,12,13,5,14,13,13,7,5,15,5,8,11,14,14,6,14,6,9,12,9,12,5,15,8,8,5,12,9,12,5,14,6,8,13,6,5,15,13,11,11];
    // pad
    const n=bytes.length; const l=((n+9+63)>>>6)<<6; const m=new Uint8Array(l); m.set(bytes); m[n]=0x80; const bit=n*8; for(let i=0;i<8;i++) m[l-8+i]=(bit>>> (8*i)) & 255;
    let h0=0x67452301,h1=0xefcdab89,h2=0x98badcfe,h3=0x10325476,h4=0xc3d2e1f0;
    for(let i=0;i<l;i+=64){
      const X=new Uint32Array(16); for(let j=0;j<16;j++){ const k=i+j*4; X[j]=m[k]|(m[k+1]<<8)|(m[k+2]<<16)|(m[k+3]<<24); }
      let A=h0,B=h1,C=h2,D=h3,E=h4; let AA=h0,BB=h1,CC=h2,DD=h3,EE=h4;
      for(let j=0;j<80;j++){
        const T= (rol((A + f(j,B,C,D) + X[r[j]] + K(j))>>>0, s[j]) + E)>>>0; A=E;E=D;D=rol(C,10);C=B;B=T;
        const TT=(rol((AA+ f(79-j,BB,CC,DD) + X[rr[j]] + KK(j))>>>0, ss[j]) + EE)>>>0; AA=EE;EE=DD;DD=rol(CC,10);CC=BB;BB=TT;
      }
      const t=(h1 + C + DD)>>>0; h1=(h2 + D + EE)>>>0; h2=(h3 + E + AA)>>>0; h3=(h4 + A + BB)>>>0; h4=(h0 + B + CC)>>>0; h0=t;
    }
    const out=new Uint8Array(20);
    const H=[h0,h1,h2,h3,h4]; for(let i=0,p=0;i<5;i++){ out[p++]=H[i]&255; out[p++]=(H[i]>>>8)&255; out[p++]=(H[i]>>>16)&255; out[p++]=(H[i]>>>24)&255; }
    return out;
  }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
