<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HEIC to JPG/PNG – Batch Convert iPhone Photos Online</title>
  <meta name="description" content="Convert HEIC/HEIF to JPG or PNG online. Batch convert multiple HEIC photos, set JPEG quality, and download as ZIP. Free, fast, and private.">
  <meta name="keywords" content="heic to jpg, heic converter, heif to jpg, convert heic to png, iphone heic to jpg, batch heic converter">
  <link rel="canonical" href="https://8gwifi.org/heic-to-jpg.jsp">
  <meta property="og:title" content="HEIC to JPG/PNG – Batch Convert Online">
  <meta property="og:description" content="Convert multiple HEIC/HEIF photos to JPG or PNG with quality control. Download everything as a ZIP.">
  <meta property="og:type" content="website"><meta property="og:url" content="https://8gwifi.org/heic-to-jpg.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script src="https://unpkg.com/heic2any/dist/heic2any.min.js"></script>
  <style>
    .heic .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .heic .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .heic .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .heic .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .heic .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.heic .grid{grid-template-columns:1fr}}
    .heic .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .heic .btn.secondary{background:#64748b}
    .heic .btn:disabled{opacity:.6;cursor:not-allowed}
    .heic .muted{color:#6b7280}
    .heic .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:.6rem;margin-top:.6rem}
    .heic .item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:.4rem;text-align:center}
    .heic .item img{width:100%;height:auto;border-radius:4px}
  </style>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"HEIC to JPG Converter","url":"https://8gwifi.org/heic-to-jpg.jsp","applicationCategory":"UtilitiesApplication","operatingSystem":"Web","description":"Convert HEIC/HEIF images to JPG or PNG online with batch support and quality control.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
    {"@type":"ListItem","position":3,"name":"HEIC to JPG","item":"https://8gwifi.org/heic-to-jpg.jsp"}
  ]}
  </script>
</head>
<%@ include file="body-script.jsp"%>

<div class="heic">
<div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">HEIC to JPG/PNG</h1>
    <div class="muted">Batch convert iPhone HEIC/HEIF photos to JPG or PNG. Download as a ZIP.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload HEIC/HEIF</h5>
      <div id="drop" class="drop"><strong>Drop HEIC files</strong> or click to browse<input id="fileInput" type="file" accept=".heic,.heif,image/heic,image/heif" multiple style="display:none"></div>
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
      <a href="webp-converter.jsp">WebP to JPG/PNG</a> ·
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

  function isHeic(f){ if(!f) return false; const t=(f.type||'').toLowerCase(); if(t==='image/heic'||t==='image/heif') return true; const n=(f.name||'').toLowerCase(); return n.endsWith('.heic')||n.endsWith('.heif'); }
  function addFiles(list){ const pick=[...list]; const valid=pick.filter(isHeic); const skipped=pick.length-valid.length; if(skipped>0) setStatus(skipped+" file(s) skipped (not HEIC/HEIF)"); files = files.concat(valid); render(); }
  function render(){ thumbs.innerHTML=''; files.forEach(f=>{ const url=URL.createObjectURL(f); const img=document.createElement('img'); img.src=url; const item=document.createElement('div'); item.className='item'; item.appendChild(img); thumbs.appendChild(item); }); }
  function setStatus(s){ status.textContent = s || ''; }

  async function convertOne(f, toType, q){
    const opt = { toType: toType };
    if(toType==='image/jpeg'){ opt.quality = Math.max(0.1, Math.min(1.0, q||0.9)); }
    try{ const out = await heic2any(Object.assign({ blob: f }, opt)); return out; } catch(e){ throw new Error('Failed converting '+ (f.name||'HEIC') +': '+ e.message); }
  }

  document.getElementById('convert').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add HEIC files first'); return; }
    setStatus('Converting '+files.length+' file(s)...');
    const toType=outFmt.value; const q=parseFloat(qualityEl.value||'0.9');
    for(const f of files){
      const blob = await convertOne(f, toType, q);
      const nameBase = (f.name||'image').replace(/\.(heic|heif)$/i,'');
      const ext = toType==='image/png' ? '.png' : '.jpg';
      downloadBlob(blob, nameBase + ext);
    }
    setStatus('Done');
  });

  document.getElementById('convertZip').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add HEIC files first'); return; }
    setStatus('Converting & zipping...');
    const toType=outFmt.value; const q=parseFloat(qualityEl.value||'0.9');
    const zip=new JSZip(); let idx=0;
    for(const f of files){
      const blob = await convertOne(f, toType, q);
      const nameBase = (f.name||('image_'+(++idx))).replace(/\.(heic|heif)$/i,'');
      const ext = toType==='image/png' ? '.png' : '.jpg';
      zip.file(nameBase + ext, await blob.arrayBuffer());
    }
    const zipBlob = await zip.generateAsync({type:'blob'});
    downloadBlob(zipBlob, 'heic_converted.zip'); setStatus('ZIP downloaded');
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

