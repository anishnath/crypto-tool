<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Online Classical Cipher Decoder/Encoder – Caesar, ROT13, Vigenère, Enigma Simulator</title>
  <meta name="description" content="Type once and decode/encode Caesar, ROT13/18/47, Atbash, Affine, Vigenère, Enigma (rotors/plugboard), Scytale, Rail Fence, and keyboard mappings. Copy results. Free, in‑browser.">
  <meta name="keywords" content="caesar cipher, rot13, rot18, rot47, atbash, affine cipher, vigenere, enigma simulator, scytale, rail fence, keyboard cipher, classical ciphers online">
  <meta name="robots" content="index,follow">
  <link rel="canonical" href="https://8gwifi.org/ciph.jsp">
  <meta property="og:title" content="Online Classical Cipher Decoder/Encoder – Caesar, ROT13, Vigenère, Enigma Simulator">
  <meta property="og:description" content="Decode/encode Caesar, ROT, Atbash, Affine, Vigenère, Enigma, Scytale, Rail Fence. Copy results. All client‑side.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/ciph.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/hash.png">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Classical Cipher Decoder – Caesar, ROT13, Vigenère, Enigma">
  <meta name="twitter:description" content="Compact online classical ciphers tool. Free, no upload.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/hash.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"Classical Cipher Decoder/Encoder","url":"https://8gwifi.org/ciph.jsp","image":"https://8gwifi.org/images/site/hash.png","applicationCategory":"UtilitiesApplication","operatingSystem":"Web Browser","description":"Online decoder/encoder for Caesar, ROT13/18/47, Atbash, Affine, Vigenère, Enigma (rotors/plugboard), Scytale, Rail Fence, keyboard mappings. Client‑side, free.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"How do I decode a Caesar cipher online?","acceptedAnswer":{"@type":"Answer","text":"Enter the text, set Decode mode and adjust the shift until it looks right (or use ROT13 for shift 13)."}},
    {"@type":"Question","name":"Can I encode/decode Vigenère here?","acceptedAnswer":{"@type":"Answer","text":"Yes. Enter your text and a Vigenère key; toggle Decode to reverse with the same key."}},
    {"@type":"Question","name":"Is this an Enigma simulator?","acceptedAnswer":{"@type":"Answer","text":"A simplified M3 demo with rotors I–V, reflectors B/C/D, ring settings, and plugboard. Encode and decode with the same settings."}},
    {"@type":"Question","name":"Does this run in my browser?","acceptedAnswer":{"@type":"Answer","text":"Yes. Everything runs client‑side with no uploads."}}
  ]}
  </script>
  <style>
    .ciph .card-header{padding:.6rem .9rem;font-weight:600}
    .ciph .card-body{padding:.8rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Courier New", monospace}
    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:.6rem}
    .out{border:1px solid #e5e7eb;border-radius:6px;padding:.5rem;background:#fff}
    .out h6{margin:0 0 .3rem 0;font-size:.9rem;color:#374151}
    .smallmuted{font-size:.8rem;color:#6b7280}
    .row-compact{display:grid;grid-template-columns:1fr 1fr;gap:.5rem}
    @media(max-width: 992px){ .row-compact{grid-template-columns:1fr;} }
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 ciph">
  <h1 class="mb-2">Classical Cipher Studio</h1>
  <p class="text-muted mb-3">Type once – see many ciphers at a glance. Toggle Encode/Decode to switch direction.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Input & Mode</h5>
        <div class="card-body">
          <div class="form-group form-check mb-2">
            <input type="checkbox" class="form-check-input" id="decodeMode">
            <label class="form-check-label" for="decodeMode">Decode mode</label>
          </div>
          <textarea id="plain" rows="5" class="form-control mono" placeholder="Type your text..."></textarea>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Parameters</h5>
        <div class="card-body">
          <div class="row-compact">
            <div>
              <label class="smallmuted">Caesar Shift</label>
              <input type="number" id="caesarShift" class="form-control form-control-sm" value="13" min="0" max="25">
            </div>
            <div>
              <label class="smallmuted">Affine A</label>
              <select id="affineA" class="form-control form-control-sm">
                <option>1</option><option>3</option><option>5</option><option>7</option><option>9</option><option>11</option>
                <option>15</option><option>17</option><option>19</option><option>21</option><option>23</option><option>25</option>
              </select>
            </div>
          </div>
          <div class="row-compact mt-2">
            <div>
              <label class="smallmuted">Affine B</label>
              <input type="number" id="affineB" class="form-control form-control-sm" value="8" min="0" max="25">
            </div>
            <div>
              <label class="smallmuted">Vigenère Key</label>
              <input type="text" id="vigKey" class="form-control form-control-sm" placeholder="KEY" value="KEY">
            </div>
          </div>
          <div class="row-compact mt-2">
            <div>
              <label class="smallmuted">Scytale Columns</label>
              <input type="number" id="scytaleCols" class="form-control form-control-sm" value="5" min="2" max="200">
            </div>
            <div>
              <label class="smallmuted">Rail Fence Rails</label>
              <input type="number" id="rails" class="form-control form-control-sm" value="3" min="2" max="100">
            </div>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Enigma (M3)</h5>
        <div class="card-body">
          <div class="row-compact">
            <div>
              <label class="smallmuted">Rotors (L‑M‑R)</label>
              <select id="rotorL" class="form-control form-control-sm"><option>I</option><option>II</option><option selected>III</option></select>
              <select id="rotorM" class="form-control form-control-sm mt-1"><option>I</option><option selected>II</option><option>III</option></select>
              <select id="rotorR" class="form-control form-control-sm mt-1"><option selected>I</option><option>II</option><option>III</option></select>
            </div>
            <div>
              <label class="smallmuted">Positions</label>
              <div class="d-flex gap-1">
                <input type="text" id="posL" class="form-control form-control-sm" value="A" maxlength="1">
                <input type="text" id="posM" class="form-control form-control-sm" value="A" maxlength="1">
                <input type="text" id="posR" class="form-control form-control-sm" value="A" maxlength="1">
              </div>
              <label class="smallmuted mt-1">Rings</label>
              <div class="d-flex gap-1">
                <input type="number" id="ringL" class="form-control form-control-sm" value="1" min="1" max="26">
                <input type="number" id="ringM" class="form-control form-control-sm" value="1" min="1" max="26">
                <input type="number" id="ringR" class="form-control form-control-sm" value="1" min="1" max="26">
              </div>
            </div>
          </div>
          <div class="row-compact mt-2">
            <div>
              <label class="smallmuted">Reflector</label>
              <select id="reflector" class="form-control form-control-sm"><option>B</option><option>C</option></select>
            </div>
            <div>
              <label class="smallmuted">Plugboard (pairs)</label>
              <input type="text" id="plugboard" class="form-control form-control-sm" placeholder="AB CD EF">
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Outputs</h5>
        <div class="card-body">
          <div class="grid" id="outputs"></div>
        </div>
      </div>
      <div class="card mb-3">
        <h5 class="card-header">Keyboard Mapping</h5>
        <div class="card-body">
          <div class="row-compact mb-2">
            <div>
              <label class="smallmuted">Layout</label>
              <select id="kbLayout" class="form-control form-control-sm">
                <option value="none">None</option>
                <option value="jis" selected>JIS Right‑Neighbor</option>
                <option value="us">US QWERTY Right‑Neighbor</option>
              </select>
            </div>
          </div>
          <div class="out"><h6>Keyboard Map</h6><div id="jisOut" class="mono small"></div></div>
        </div>
      </div>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Notes</h5>
    <div class="card-body">
      <ul class="mb-0">
        <li>Encode/Decode toggles invert each cipher as applicable. ROT and Atbash are involutive.</li>
        <li>Affine requires A coprime with 26; otherwise decoding is undefined.</li>
        <li>Enigma here is a simplified M3 simulator (I/II/III, Reflector B/C, plugboard). Non‑letters pass through unchanged.</li>
      </ul>
    </div>
  </div>

  <div class="card mb-3">
    <h5 class="card-header">Cipher Overview</h5>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-sm table-bordered mb-0">
          <thead class="thead-light">
            <tr>
              <th style="white-space:nowrap;">Cipher</th>
              <th>Type</th>
              <th style="white-space:nowrap;">Parameters</th>
              <th>Properties</th>
              <th>Notes</th>
            </tr>
          </thead>
          <tbody class="small">
            <tr>
              <td>Caesar</td>
              <td>Shift substitution (monoalphabetic)</td>
              <td>Shift ∈ [0..25]</td>
              <td>Linear over Z/26Z; reversible</td>
              <td>ROT13 is Caesar with shift 13</td>
            </tr>
            <tr>
              <td>ROT5/13/18/47</td>
              <td>Involutive rotations</td>
              <td>Digits (5), Letters (13), Alnum (18), ASCII 33–126 (47)</td>
              <td>Self‑inverse (decode == encode)</td>
              <td>Convenience encodings; not secure</td>
            </tr>
            <tr>
              <td>Atbash</td>
              <td>Mirror substitution</td>
              <td>None</td>
              <td>Self‑inverse</td>
              <td>A↔Z, B↔Y, … preserves case</td>
            </tr>
            <tr>
              <td>Affine</td>
              <td>Linear substitution (monoalphabetic)</td>
              <td>a (coprime 26), b ∈ [0..25]</td>
              <td>Reversible iff gcd(a,26)=1</td>
              <td>Decoding uses modular inverse of a</td>
            </tr>
            <tr>
              <td>Vigenère</td>
              <td>Polyalphabetic substitution</td>
              <td>Key (letters)</td>
              <td>Repeating‑key shifts</td>
              <td>Classical; not secure vs. Kasiski/IC</td>
            </tr>
            <tr>
              <td>Enigma (M3)</td>
              <td>Rotor machine (polyalphabetic)</td>
              <td>Rotors, positions, rings, reflector, plugboard</td>
              <td>Encode==Decode with same settings</td>
              <td>Simplified stepping model for demo</td>
            </tr>
            <tr>
              <td>Scytale</td>
              <td>Transposition</td>
              <td>Columns</td>
              <td>Columnar read/write</td>
              <td>Ancient rod cipher; reversible</td>
            </tr>
            <tr>
              <td>Rail Fence</td>
              <td>Transposition (zig‑zag)</td>
              <td>Rails</td>
              <td>Zig‑zag patterning</td>
              <td>Symmetric with known rails</td>
            </tr>
            <tr>
              <td>Keyboard Map</td>
              <td>Layout mapping (non‑crypto)</td>
              <td>JIS/US right‑neighbor</td>
              <td>One‑to‑one char remap</td>
              <td>Illustrative only (no secrecy)</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  const AZ='ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  function mod(n,m){ return ((n%m)+m)%m; }
  function caesar(s,shift,dec){ const k=dec? -shift:shift; return s.replace(/[A-Za-z]/g,c=>{ const base=(c<="Z"?65:97); return String.fromCharCode(base+mod(c.charCodeAt(0)-base+k,26)); }); }
  function rot13(s){ return caesar(s,13,false); }
  function rot5(s){ return s.replace(/[0-9]/g,c=>String.fromCharCode(48+((c.charCodeAt(0)-48+5)%10))); }
  function rot18(s){ return s.replace(/[A-Za-z0-9]/g,c=>{ if(/[A-Za-z]/.test(c)) return caesar(c,13,false); const d=c.charCodeAt(0)-48; return String.fromCharCode(48+((d+5)%10)); }); }
  function rot47(s){ return s.replace(/[\x21-\x7E]/g,c=>String.fromCharCode(33+((c.charCodeAt(0)-33+47)%94))); }
  function atbash(s){ return s.replace(/[A-Za-z]/g,c=>{ const base=(c<='Z'?65:97); const off=c.charCodeAt(0)-base; return String.fromCharCode(base+(25-off)); }); }
  function invMod(a,m){ a=mod(a,m); for(let x=1;x<m;x++){ if((a*x)%m===1) return x; } return null; }
  function affine(s,a,b,dec){ const ainv=dec? invMod(a,26):a; if(dec && ainv==null) return '[A not invertible]'; return s.replace(/[A-Za-z]/g,c=>{ const base=(c<='Z'?65:97); const x=c.charCodeAt(0)-base; const y = dec ? mod(ainv*(x-b),26) : mod(a*x+b,26); return String.fromCharCode(base+y); }); }
  function vig(s,key,dec){ if(!key) return s; const K=key.replace(/[^A-Za-z]/g,'').toUpperCase(); if(!K) return s; let j=0; return s.replace(/[A-Za-z]/g,c=>{ const base=(c<='Z'?65:97); const k=K.charCodeAt(j++%K.length)-65; const sh=dec? -k:k; return String.fromCharCode(base+mod(c.charCodeAt(0)-base+sh,26)); }); }
  function scytale(s,cols,dec){ cols=Math.max(2,parseInt(cols||0,10)||2); const clean=s; if(!dec){ const out=[]; for(let i=0;i<cols;i++){ for(let j=i;j<clean.length;j+=cols){ out.push(clean[j]); } } return out.join(''); } else { const rows=Math.ceil(clean.length/cols); const out=new Array(clean.length); let idx=0; for(let i=0;i<cols;i++){ for(let j=i;j<clean.length;j+=cols){ out[j]=clean[idx++]||''; } } return out.join(''); } }
  function railFence(s,rails,dec){ rails=Math.max(2,parseInt(rails||0,10)||2); const text=s; const n=text.length; if(n===0) return ''; const pattern=[]; let r=0,dir=1; for(let i=0;i<n;i++){ pattern.push(r); r+=dir; if(r===rails-1||r===0) dir*=-1; }
    if(!dec){ const rows=Array.from({length:rails},()=>[]); for(let i=0;i<n;i++) rows[pattern[i]].push(text[i]); return rows.flat().join(''); }
    else{ const rowCounts=new Array(rails).fill(0); pattern.forEach(p=>rowCounts[p]++); const rows=[]; let idx=0; for(let r=0;r<rails;r++){ rows[r]=text.slice(idx,idx+rowCounts[r]).split(''); idx+=rowCounts[r]; }
      const out=[]; const rowIdx=new Array(rails).fill(0); for(let i=0;i<n;i++){ const pr=pattern[i]; out.push(rows[pr][rowIdx[pr]++]); } return out.join(''); }
  }
  // Enigma (simplified M3)
  const ROTORS={ I:{w:"EKMFLGDQVZNTOWYHXUSPAIBRCJ", notch:'Q'}, II:{w:"AJDKSIRUXBLHWTMCQGZNPYFVOE", notch:'E'}, III:{w:"BDFHJLCPRTXVZNYEIWGAKMUSQO", notch:'V'}, IV:{w:"ESOVPZJAYQUIRHXLNFTGKDCMWB", notch:'J'}, V:{w:"VZBRGITYUPSDNHLXAWMJQOFECK", notch:'Z'} };
  const REFLECTORS={ B:"YRUHQSLDPXNGOKMIEBFZCWVJAT", C:"FVPJIAOYEDRZXWGCTKUQSBNMHL", D:"ENKQAUYWJICOPBLMDXZVFTHRGS" };
  function encEnigma(s,conf,dec){ // dec same as enc for Enigma
    function step(){ // implement double-stepping
      const notchR = ROTORS[conf.rotorR].notch;
      const notchM = ROTORS[conf.rotorM].notch;
      const mAtNotch = conf.posM===notchM;
      const rAtNotch = conf.posR===notchR;
      // middle rotor steps if at notch or if right is at notch; left steps on middle notch
      if(mAtNotch){ conf.posM = AZ[(AZ.indexOf(conf.posM)+1)%26]; conf.posL = AZ[(AZ.indexOf(conf.posL)+1)%26]; }
      if(rAtNotch && !mAtNotch){ conf.posM = AZ[(AZ.indexOf(conf.posM)+1)%26]; }
      conf.posR = AZ[(AZ.indexOf(conf.posR)+1)%26];
    }
    function mapThrough(ch, wiring, ring, pos, inv){ const a=AZ.indexOf(ch); const ringAdj=(ring-1); const p=mod(a + AZ.indexOf(pos) - ringAdj,26); const w=inv? AZ.indexOf(AZ[p]) : AZ.indexOf(wiring[p]); const o=inv? AZ[mod(w - AZ.indexOf(pos) + ringAdj,26)] : AZ[mod(AZ.indexOf(wiring[p]) - AZ.indexOf(pos) + ringAdj,26)]; return o; }
    const WL=ROTORS[conf.rotorL].w, WM=ROTORS[conf.rotorM].w, WR=ROTORS[conf.rotorR].w; const RF=REFLECTORS[conf.reflector];
    conf.notchR=ROTORS[conf.rotorR].notch; conf.notchM=ROTORS[conf.rotorM].notch;
    const plug=parsePlug(conf.plugboard);
    let out=''; for(const ch of s){ if(/[A-Za-z]/.test(ch)){ step(); let c=ch.toUpperCase(); c=plugSub(plug,c);
        c=map(c,WR,conf.ringR,conf.posR,false); c=map(c,WM,conf.ringM,conf.posM,false); c=map(c,WL,conf.ringL,conf.posL,false);
        c=reflect(c,RF);
        c=map(c,WL,conf.ringL,conf.posL,true); c=map(c,WM,conf.ringM,conf.posM,true); c=map(c,WR,conf.ringR,conf.posR,true);
        c=plugSub(plug,c); out+= (ch===ch.toLowerCase()? c.toLowerCase():c);
      } else out+=ch; }
    return out;
    function map(ch,W,ring,pos,inv){ const a=AZ.indexOf(ch); const p=mod(a + AZ.indexOf(pos) - (ring-1),26); const c = inv ? AZ.indexOf(AZ[p]) : AZ.indexOf(W[p]); const o = inv? AZ[mod(c - AZ.indexOf(pos) + (ring-1),26)] : AZ[mod(AZ.indexOf(W[p]) - AZ.indexOf(pos) + (ring-1),26)]; return o; }
    function reflect(ch, R){ return AZ[R.indexOf(ch)]; }
    function parsePlug(pb){ const m={}; (pb||'').toUpperCase().trim().split(/\s+/).forEach(p=>{ if(p.length===2){ const a=p[0],b=p[1]; m[a]=b; m[b]=a; } }); return m; }
    function plugSub(m,c){ return m[c]||c; }
  }
  // JIS keyboard illustrative mapping (simple neighbor map)
  const KBMAPS=(function(){
    function rightNeighbor(rows){ const map={}; for(const r of rows){ for(let i=0;i<r.length;i++){ const c=r[i]; const n=r[(i+1)%r.length]; map[c]=n; map[c.toUpperCase? 'toUpperCase':'']?map[c.toUpperCase()]=n.toUpperCase():null; } } return map; }
    const jisRows=["1234567890-^","qwertyuiop@[","asdfghjkl;:]","zxcvbnm,./\\"]; // simple
    const usRows=["`1234567890-=",["qwertyuiop[]"].join(''),"asdfghjkl;'","zxcvbnm,./"]; 
    return {
      none: {},
      jis: rightNeighbor(jisRows),
      us: rightNeighbor(usRows)
    };
  })();
  function kbMap(s){ const sel=(document.getElementById('kbLayout').value)||'none'; const M=KBMAPS[sel]||{}; return s.replace(/./g,c=> M[c]|| (c.toUpperCase? (M[c.toUpperCase()]? (c===c.toUpperCase()? M[c.toUpperCase()]: M[c.toUpperCase()].toLowerCase()): c):c) ); }

  function compute(){
    const dec=document.getElementById('decodeMode').checked;
    const s=document.getElementById('plain').value||'';
    const caShift=parseInt(document.getElementById('caesarShift').value||'0',10);
    const a=parseInt(document.getElementById('affineA').value||'1',10); const b=parseInt(document.getElementById('affineB').value||'0',10);
    const key=document.getElementById('vigKey').value||'';
    const cols=document.getElementById('scytaleCols').value||5;
    const rails=document.getElementById('rails').value||3;
    const cfg={ rotorL:document.getElementById('rotorL').value, rotorM:document.getElementById('rotorM').value, rotorR:document.getElementById('rotorR').value,
      posL:(document.getElementById('posL').value||'A').toUpperCase(), posM:(document.getElementById('posM').value||'A').toUpperCase(), posR:(document.getElementById('posR').value||'A').toUpperCase(),
      ringL:parseInt(document.getElementById('ringL').value||'1',10), ringM:parseInt(document.getElementById('ringM').value||'1',10), ringR:parseInt(document.getElementById('ringR').value||'1',10),
      reflector:document.getElementById('reflector').value, plugboard:document.getElementById('plugboard').value||'' };

    const items=[
      {name:`Caesar (shift ${caShift})`, val: caesar(s,caShift,dec)},
      {name:'ROT5 (0–9)', val: rot5(s)},
      {name:'ROT13', val: rot13(s)},
      {name:'ROT18', val: rot18(s)},
      {name:'ROT47', val: rot47(s)},
      {name:'Atbash', val: atbash(s)},
      {name:`Affine (a=${a}, b=${b})`, val: affine(s,a,b,dec)},
      {name:`Vigenère (${key||'-'})`, val: vig(s,key,dec)},
      {name:'Enigma (M3)', val: encEnigma(s,cfg,dec)},
      {name:`Scytale (cols=${cols})`, val: scytale(s,cols,dec)},
      {name:`Rail Fence (rails=${rails})`, val: railFence(s,rails,dec)}
    ];
    const out=document.getElementById('outputs'); out.innerHTML='';
    items.forEach((it,idx)=>{ const d=document.createElement('div'); d.className='out'; const id=`copy_${idx}`; d.innerHTML=`<div class="d-flex justify-content-between align-items-center"><h6 class="mb-0">${it.name}</h6><button class="btn btn-sm btn-outline-secondary" data-copy="${id}">Copy</button></div><div id="${id}" class="mono small mt-1">${escapeHtml(it.val)}</div>`; out.appendChild(d); });
    out.querySelectorAll('[data-copy]').forEach(btn=>{ btn.addEventListener('click',()=>{ const id=btn.getAttribute('data-copy'); const text=document.getElementById(id).textContent||''; if(navigator.clipboard) navigator.clipboard.writeText(text); }); });
    document.getElementById('jisOut').textContent = kbMap(s);
  }
  function escapeHtml(s){ return (s||'').replace(/[&<>]/g, ch=>({"&":"&amp;","<":"&lt;",">":"&gt;"}[ch])); }

  // Wire
  ['decodeMode','caesarShift','affineA','affineB','vigKey','scytaleCols','rails','rotorL','rotorM','rotorR','posL','posM','posR','ringL','ringM','ringR','reflector','plugboard','kbLayout'].forEach(id=>{
    const el=document.getElementById(id); if(el) el.addEventListener('input', compute);
  });
  document.getElementById('plain').addEventListener('input', compute);
  compute();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
