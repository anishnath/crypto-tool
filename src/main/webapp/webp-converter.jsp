<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>WebP to JPG/PNG – Convert Images Online (Batch)</title>
  <meta name="description" content="Convert WebP images to JPG or PNG online. Batch conversion, quality control, and ZIP download. Free and private.">
  <link rel="canonical" href="https://8gwifi.org/webp-converter.jsp">
  <meta property="og:title" content="WebP to JPG/PNG – Convert Images Online">
  <meta property="og:description" content="Convert multiple WebP images to JPG or PNG with quality controls and ZIP download.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/webp-converter.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <style>
    .webp .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .webp .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .webp .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .webp .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .webp .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.webp .grid{grid-template-columns:1fr}}
    .webp .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .webp .btn.secondary{background:#64748b}
    .webp .btn:disabled{opacity:.6;cursor:not-allowed}
    .webp .muted{color:#6b7280}
    .webp .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:.6rem;margin-top:.6rem}
    .webp .item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:.4rem;text-align:center}
    .webp .item img{width:100%;height:auto;border-radius:4px}
  </style>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"WebP to JPG/PNG Converter","url":"https://8gwifi.org/webp-converter.jsp","applicationCategory":"UtilitiesApplication","operatingSystem":"Web","description":"Convert WebP images to JPG or PNG with batch support and quality control.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
    {"@type":"ListItem","position":3,"name":"WebP Converter","item":"https://8gwifi.org/webp-converter.jsp"}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"HowTo","name":"How to Convert WebP to JPG/PNG","totalTime":"PT1M","step":[
    {"@type":"HowToStep","name":"Upload WebP","text":"Drop WebP files or browse to select."},
    {"@type":"HowToStep","name":"Choose format","text":"Select JPG or PNG and set JPEG quality if needed."},
    {"@type":"HowToStep","name":"Convert","text":"Click Convert or Convert & Download ZIP."},
    {"@type":"HowToStep","name":"Download","text":"Download converted images or a ZIP archive."}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"Does conversion happen in the browser?","acceptedAnswer":{"@type":"Answer","text":"Yes, all conversion runs locally for privacy."}},
    {"@type":"Question","name":"When should I use PNG vs JPG?","acceptedAnswer":{"@type":"Answer","text":"Use PNG for graphics/transparency; JPG for photos and smaller size."}},
    {"@type":"Question","name":"Can I convert many files at once?","acceptedAnswer":{"@type":"Answer","text":"Yes, add multiple WebP files and download everything as a ZIP."}}
  ]}
  </script>
</head>
<%@ include file="body-script.jsp"%>

<div class="webp">
<div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">WebP to JPG/PNG</h1>
    <div class="muted">Convert multiple WebP images to JPG or PNG. Download individually or as a ZIP.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload WebP</h5>
      <div id="drop" class="drop"><strong>Drop WebP files</strong> or click to browse<input id="fileInput" type="file" accept="image/webp,.webp" multiple style="display:none"></div>
      <div class="thumbs" id="thumbs"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label>Output format
        <select id="outFmt" class="form-control">
          <option value="image/jpeg" selected>JPG (JPEG)</option>
          <option value="image/png">PNG</option>
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
      <a href="heic-to-jpg.jsp">HEIC to JPG</a> ·
      <a href="png-jpg-converter.jsp?to=webp">Convert to WebP (PNG/JPG→WebP)</a> ·
      <a href="png-jpg-converter.jsp">PNG ↔ JPG</a> ·
      <a href="jpg-to-pdf.jsp">JPG to PDF</a>
    </div>
  </div>
</div>
</div>

<script>
(function(){
  const drop=document.getElementById('drop');
  const input=document.getElementById('fileInput');
  const thumbs=document.getElementById('thumbs');
  const outFmt=document.getElementById('outFmt');
  const qualityEl=document.getElementById('quality');
  const status=document.getElementById('status');
  let files=[];

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs.length){ addFiles(fs); }});
  input.addEventListener('change', ()=>{ if(input.files && input.files.length) addFiles(input.files); });

  function isWebp(f){ if(!f) return false; const t=(f.type||'').toLowerCase(); if(t==='image/webp') return true; const n=(f.name||'').toLowerCase(); return n.endsWith('.webp'); }
  function addFiles(list){ const pick=[...list]; const valid=pick.filter(isWebp); const skipped=pick.length-valid.length; if(skipped>0) setStatus(skipped+" file(s) skipped (not WebP)"); files = files.concat(valid); render(); }
  function render(){ thumbs.innerHTML=''; files.forEach(f=>{ const url=URL.createObjectURL(f); const img=document.createElement('img'); img.src=url; const item=document.createElement('div'); item.className='item'; item.appendChild(img); thumbs.appendChild(item); }); }
  function setStatus(s){ status.textContent = s || ''; }

  function loadImage(file){ return new Promise((resolve,reject)=>{ const url=URL.createObjectURL(file); const img=new Image(); img.onload=()=>resolve({img,url}); img.onerror=()=>reject(new Error('Failed to load image')); img.src=url; }); }
  function rasterToBlob(img, mime, q){ const c=document.createElement('canvas'); c.width=img.width; c.height=img.height; const g=c.getContext('2d'); g.drawImage(img,0,0); return new Promise(res=> c.toBlob(res, mime, q)); }

  document.getElementById('convert').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add WebP files first'); return; }
    setStatus('Converting '+files.length+' file(s)...');
    const toType=outFmt.value; const q=parseFloat(qualityEl.value||'0.9');
    for(const f of files){
      const {img,url} = await loadImage(f);
      const blob = await rasterToBlob(img, toType, toType==='image/jpeg'? q: undefined);
      URL.revokeObjectURL(url);
      const nameBase = (f.name||'image').replace(/\.webp$/i,'');
      const ext = toType==='image/png'? '.png': '.jpg';
      downloadBlob(blob, nameBase + ext);
    }
    setStatus('Done');
  });

  document.getElementById('convertZip').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add WebP files first'); return; }
    setStatus('Converting & zipping...');
    const toType=outFmt.value; const q=parseFloat(qualityEl.value||'0.9');
    const zip=new JSZip(); let idx=0;
    for(const f of files){
      const {img,url} = await loadImage(f);
      const blob = await rasterToBlob(img, toType, toType==='image/jpeg'? q: undefined);
      URL.revokeObjectURL(url);
      const nameBase = (f.name||('image_'+(++idx))).replace(/\.webp$/i,'');
      const ext = toType==='image/png'? '.png': '.jpg';
      zip.file(nameBase + ext, await blob.arrayBuffer());
    }
    const zipBlob = await zip.generateAsync({type:'blob'});
    downloadBlob(zipBlob, 'webp_converted.zip'); setStatus('ZIP downloaded');
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

