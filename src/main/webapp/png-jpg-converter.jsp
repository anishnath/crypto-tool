<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PNG ↔ JPG Converter – Batch Convert Online</title>
  <meta name="description" content="Convert PNG to JPG or JPG to PNG online. Batch conversion, JPEG quality control, ZIP download. Free and private.">
  <link rel="canonical" href="https://8gwifi.org/png-jpg-converter.jsp">
  <meta property="og:title" content="PNG ↔ JPG Converter – Batch Convert Online">
  <meta property="og:description" content="Convert multiple PNG/JPG images with quality control; download as ZIP.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/png-jpg-converter.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <style>
    .pj .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .pj .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .pj .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .pj .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .pj .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.pj .grid{grid-template-columns:1fr}}
    .pj .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .pj .btn.secondary{background:#64748b}
    .pj .btn:disabled{opacity:.6;cursor:not-allowed}
    .pj .muted{color:#6b7280}
    .pj .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:.6rem;margin-top:.6rem}
    .pj .item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:.4rem;text-align:center}
    .pj .item img{width:100%;height:auto;border-radius:4px}
  </style>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"PNG ↔ JPG Converter","url":"https://8gwifi.org/png-jpg-converter.jsp","applicationCategory":"UtilitiesApplication","operatingSystem":"Web","description":"Convert PNG to JPG or JPG to PNG with batch support, JPEG quality control, and ZIP download.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
    {"@type":"ListItem","position":3,"name":"PNG ↔ JPG Converter","item":"https://8gwifi.org/png-jpg-converter.jsp"}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"HowTo","name":"How to Convert PNG/JPG","totalTime":"PT1M","step":[
    {"@type":"HowToStep","name":"Upload images","text":"Drop PNG/JPG or browse to select."},
    {"@type":"HowToStep","name":"Choose direction","text":"Auto or Force PNG/JPG/WebP."},
    {"@type":"HowToStep","name":"Convert","text":"Click Convert or Convert & Download ZIP."},
    {"@type":"HowToStep","name":"Download","text":"Download converted images or ZIP."}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"Is conversion private?","acceptedAnswer":{"@type":"Answer","text":"Yes, runs in your browser."}},
    {"@type":"Question","name":"When to use JPG vs PNG vs WebP?","acceptedAnswer":{"@type":"Answer","text":"JPG for photos, PNG for graphics/transparency, WebP for modern compression."}},
    {"@type":"Question","name":"Batch conversion?","acceptedAnswer":{"@type":"Answer","text":"Yes, convert many files and download as ZIP."}}
  ]}
  </script>

</head>
<%@ include file="body-script.jsp"%>

<div class="pj">
<div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">PNG ↔ JPG Converter</h1>
    <div class="muted">Convert PNG to JPG or JPG to PNG. Batch convert; download as ZIP.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload PNG/JPG</h5>
      <div id="drop" class="drop"><strong>Drop PNG/JPG</strong> or click to browse<input id="fileInput" type="file" accept="image/png,image/jpeg,.png,.jpg,.jpeg" multiple style="display:none"></div>
      <div class="thumbs" id="thumbs"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label>Direction
        <select id="direction" class="form-control">
          <option value="auto" selected>Auto (PNG→JPG, JPG→PNG)</option>
          <option value="toJpg">Force JPG</option>
          <option value="toPng">Force PNG</option>
          <option value="toWebp">Force WebP</option>
        </select>
      </label>
      <label style="display:block;margin-top:.4rem">JPEG Quality (0.1–1.0)
        <input id="quality" type="number" class="form-control" step="0.1" min="0.1" max="1.0" value="0.9">
      </label>
      <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-top:.6rem">
        <button id="convert" class="btn">Convert</button>
        <button id="convertZip" class="btn secondary">Convert & Download ZIP</button>
      </div>
      <div id="status" class="muted" style="margin-top:.5rem"></div>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related Tools</h5>
    <div class="muted">
      <a href="webp-converter.jsp">WebP Converter</a> ·
      <a href="heic-to-jpg.jsp">HEIC to JPG</a> ·
      <a href="jpg-to-pdf.jsp">JPG to PDF</a>
    </div>
  </div>
</div>
</div>

<script>
(function(){
  const params=new URLSearchParams(location.search);
  const pre= (params.get('to')||'').toLowerCase();
  setTimeout(()=>{ try{ const sel=document.getElementById('direction'); if(pre==='webp'){ sel.value='toWebp'; } }catch(e){} },0);
  const drop=document.getElementById('drop');
  const input=document.getElementById('fileInput');
  const thumbs=document.getElementById('thumbs');
  const dirSel=document.getElementById('direction');
  const qualityEl=document.getElementById('quality');
  const status=document.getElementById('status');
  let files=[];

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs.length){ addFiles(fs); }});
  input.addEventListener('change', ()=>{ if(input.files && input.files.length) addFiles(input.files); });

  function isPngJpg(f){ if(!f) return false; const t=(f.type||'').toLowerCase(); if(t==='image/png'||t==='image/jpeg') return true; const n=(f.name||'').toLowerCase(); return n.endsWith('.png')||n.endsWith('.jpg')||n.endsWith('.jpeg'); }
  function addFiles(list){ const pick=[...list]; const valid=pick.filter(isPngJpg); const skipped=pick.length-valid.length; if(skipped>0) setStatus(skipped+" file(s) skipped (not PNG/JPG)"); files = files.concat(valid); render(); }
  function render(){ thumbs.innerHTML=''; files.forEach(f=>{ const url=URL.createObjectURL(f); const img=document.createElement('img'); img.src=url; const item=document.createElement('div'); item.className='item'; item.appendChild(img); thumbs.appendChild(item); }); }
  function setStatus(s){ status.textContent = s || ''; }

  function loadImage(file){ return new Promise((resolve,reject)=>{ const url=URL.createObjectURL(file); const img=new Image(); img.onload=()=>resolve({img,url}); img.onerror=()=>reject(new Error('Failed to load image')); img.src=url; }); }
  function rasterToBlob(img, mime, q){ const c=document.createElement('canvas'); c.width=img.width; c.height=img.height; const g=c.getContext('2d'); g.drawImage(img,0,0); return new Promise(res=> c.toBlob(res, mime, q)); }

  function decideTarget(f){ const dir=dirSel.value; if(dir==='toJpg') return 'image/jpeg'; if(dir==='toPng') return 'image/png'; if(dir==='toWebp') return 'image/webp'; const n=(f.name||'').toLowerCase(); const t=(f.type||'').toLowerCase(); if(t==='image/png'||n.endsWith('.png')) return 'image/jpeg'; return 'image/png'; }

  document.getElementById('convert').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add PNG/JPG files first'); return; }
    setStatus('Converting '+files.length+' file(s)...');
    for(const f of files){
      const {img,url} = await loadImage(f); const target=decideTarget(f);
      const blob = await rasterToBlob(img, target, (target==='image/jpeg'||target==='image/webp')? parseFloat(qualityEl.value||'0.9'): undefined);
      URL.revokeObjectURL(url);
      const nameBase = (f.name||'image').replace(/\.(png|jpg|jpeg)$/i,'');
      const ext = target==='image/png'? '.png': (target==='image/webp'? '.webp': '.jpg');
      downloadBlob(blob, nameBase + ext);
    }
    setStatus('Done');
  });

  document.getElementById('convertZip').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add PNG/JPG files first'); return; }
    setStatus('Converting & zipping...');
    const zip=new JSZip(); let idx=0;
    for(const f of files){
      const {img,url} = await loadImage(f); const target=decideTarget(f);
      const blob = await rasterToBlob(img, target, (target==='image/jpeg'||target==='image/webp')? parseFloat(qualityEl.value||'0.9'): undefined);
      URL.revokeObjectURL(url);
      const nameBase = (f.name||('image_'+(++idx))).replace(/\.(png|jpg|jpeg)$/i,'');
      const ext = target==='image/png'? '.png': (target==='image/webp'? '.webp': '.jpg');
      zip.file(nameBase + ext, await blob.arrayBuffer());
    }
    const zipBlob = await zip.generateAsync({type:'blob'});
    downloadBlob(zipBlob, 'converted_images.zip'); setStatus('ZIP downloaded');
  });

  function downloadBlob(blob, name){ const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download=name; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

