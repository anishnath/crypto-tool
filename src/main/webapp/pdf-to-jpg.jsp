<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PDF to JPG – Convert PDF Pages to JPEG (Online)</title>
  <meta name="description" content="Convert PDF to JPG images online. Choose quality and resolution, preview pages, and download JPEGs. Free and fast.">
  <meta name="keywords" content="pdf to jpg, convert pdf to jpg, pdf pages to jpg, pdf to jpeg">
  <link rel="canonical" href="https://8gwifi.org/pdf-to-jpg.jsp">
  <meta property="og:title" content="PDF to JPG – Convert PDF Pages to JPEG">
  <meta property="og:description" content="Convert PDF pages to high‑quality JPG images online.">
  <meta property="og:type" content="website"><meta property="og:url" content="https://8gwifi.org/pdf-to-jpg.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <script>pdfjsLib.GlobalWorkerOptions.workerSrc='https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';</script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"WebApplication",
    "name":"PDF to JPG Converter",
    "url":"https://8gwifi.org/pdf-to-jpg.jsp",
    "applicationCategory":"UtilitiesApplication",
    "operatingSystem":"Web",
    "description":"Convert PDF pages to JPEG images online. Control quality and resolution with instant preview.",
    "offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"BreadcrumbList",
    "itemListElement":[
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"PDF Tools","item":"https://8gwifi.org/merge-pdf.jsp"},
      {"@type":"ListItem","position":3,"name":"PDF to JPG","item":"https://8gwifi.org/pdf-to-jpg.jsp"}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"HowTo",
    "name":"How to Convert PDF to JPG",
    "totalTime":"PT1M",
    "step":[
      {"@type":"HowToStep","name":"Upload PDF","text":"Drop your PDF or click to browse."},
      {"@type":"HowToStep","name":"Choose settings","text":"Select scale (DPI) and JPEG quality."},
      {"@type":"HowToStep","name":"Convert","text":"Click Convert Pages to generate JPGs."},
      {"@type":"HowToStep","name":"Download","text":"Images download per page; use a ZIP tool to bundle if needed."}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"What resolution should I use?",
       "acceptedAnswer":{"@type":"Answer","text":"200–300 DPI yields high‑quality images; lower DPI for smaller files."}},
      {"@type":"Question","name":"Can I convert specific pages?",
       "acceptedAnswer":{"@type":"Answer","text":"This tool converts all pages; future updates will add page selection."}},
      {"@type":"Question","name":"Do you upload my files?",
       "acceptedAnswer":{"@type":"Answer","text":"No, conversion happens in your browser for privacy."}}
    ]
  }
  </script>
  <style>
    .pdf2jpg .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .pdf2jpg .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .pdf2jpg .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .pdf2jpg .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.pdf2jpg .grid{grid-template-columns:1fr}}
    .pdf2jpg .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:.6rem}
    .pdf2jpg .item{text-align:center}
    .pdf2jpg .item canvas{width:100%;height:auto;border:1px solid #e5e7eb;border-radius:6px}
    .pdf2jpg .btn{border:none;border-radius:8px;padding:.5rem .8rem;font-weight:600;color:#fff;background:#3b82f6;cursor:pointer}
    .pdf2jpg .btn.secondary{background:#64748b}
    .pdf2jpg .btn:disabled{opacity:.6;cursor:not-allowed}
    .pdf2jpg .muted{color:#6b7280}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="pdf2jpg">
<div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">PDF to JPG</h1>
    <div class="muted">Convert PDF pages to JPEG images. Choose quality and resolution.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload PDF</h5>
      <div id="drop" class="drop"><strong>Drop PDF here</strong> or click to browse<input id="pdfFile" type="file" accept="application/pdf" style="display:none"></div>
      <div id="previewControls" style="display:none; margin-top:.6rem; display:flex; align-items:center; gap:.5rem">
        <button id="prevPreview" class="btn secondary" style="padding:.35rem .6rem">◀</button>
        <div class="muted" id="previewLabel">Preview (Page 1)</div>
        <button id="nextPreview" class="btn secondary" style="padding:.35rem .6rem">▶</button>
      </div>
      <div id="thumbs" class="thumbs" style="margin-top:.6rem"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label>Scale (DPI approx)
        <select id="scale" class="form-control">
          <option value="1">~100 DPI</option>
          <option value="1.5">~150 DPI</option>
          <option value="2" selected>~200 DPI</option>
          <option value="3">~300 DPI</option>
        </select>
      </label>
      <label style="display:block;margin-top:.4rem">JPEG Quality (0.1–1.0)
        <input id="quality" type="number" class="form-control" step="0.1" min="0.1" max="1.0" value="0.9">
      </label>
      <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-top:.6rem">
        <button id="convert" class="btn">Convert Pages</button>
        <button id="convertZip" class="btn secondary">Convert & Download ZIP</button>
      </div>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related PDF Tools</h5>
    <div class="muted">
      <a href="jpg-to-pdf.jsp">JPG to PDF</a> ·
      <a href="pdf-to-word.jsp">PDF to Word</a> ·
      <a href="merge-pdf.jsp">Merge PDF</a> ·
      <a href="split-pdf.jsp">Split PDF</a> ·
      <a href="compress-pdf.jsp">Compress PDF</a> ·
      <a href="watermark-pdf.jsp">Watermark PDF</a> ·
      <a href="pdf-password.jsp">Remove/Add/Change Password</a>
    </div>
  </div>
</div>

</div>

<script>
(function(){
  const drop=document.getElementById('drop');
  const input=document.getElementById('pdfFile');
  const thumbs=document.getElementById('thumbs');
  const convert=document.getElementById('convert');
  const convertZip=document.getElementById('convertZip');
  const scaleEl=document.getElementById('scale');
  const qualityEl=document.getElementById('quality');
  let pdf=null; let fileName='document.pdf'; let totalPages=0; let currentPreview=1;

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ;['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ;['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', async (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs[0]) await handle(fs[0]); });
  input.addEventListener('change', async ()=>{ if(input.files && input.files[0]) await handle(input.files[0]); });

  function isPdfByTypeOrExt(file){
    if(!file) return false; const t=(file.type||'').toLowerCase();
    if(t==='application/pdf' || t==='application/x-pdf') return true;
    const n=(file.name||'').toLowerCase(); return n.endsWith('.pdf');
  }
  function readHeader(file){
    return new Promise(function(resolve){
      try{ const sl=file.slice(0,5); const fr=new FileReader();
        fr.onload=function(){ const u8=new Uint8Array(fr.result||new ArrayBuffer(0));
          const ok=u8.length>=4 && u8[0]===0x25 && u8[1]===0x50 && u8[2]===0x44 && u8[3]===0x46; resolve(ok);
        }; fr.onerror=function(){ resolve(false); }; fr.readAsArrayBuffer(sl);
      }catch(e){ resolve(false); }
    });
  }
  async function handle(f){
    if(!isPdfByTypeOrExt(f) || !(await readHeader(f))){ alert('Please choose a valid PDF'); return; }
    fileName=f.name; thumbs.innerHTML='';
    const ab = await f.arrayBuffer();
    try{ pdf = await pdfjsLib.getDocument({data:ab}).promise; }catch(e){ alert('Unable to open PDF: '+e.message); return; }
    totalPages = pdf.numPages; currentPreview = 1;
    document.getElementById('previewControls').style.display='flex';
    await renderPreview(currentPreview);
  }

  async function renderPreview(pageNo){
    const page = await pdf.getPage(pageNo);
    const vp = page.getViewport({scale:1});
    const canvas=document.createElement('canvas');
    canvas.width=vp.width; canvas.height=vp.height; const ctx=canvas.getContext('2d');
    await page.render({canvasContext:ctx, viewport:vp}).promise;
    thumbs.innerHTML='';
    const item=document.createElement('div'); item.className='item';
    item.appendChild(canvas);
    const cap=document.createElement('div'); cap.className='muted'; cap.textContent='Preview (Page '+pageNo+' of '+ totalPages +')'; item.appendChild(cap);
    thumbs.appendChild(item);
    document.getElementById('previewLabel').textContent = 'Preview (Page '+pageNo+' of '+ totalPages +')';
  }

  convert.addEventListener('click', async ()=>{
    if(!pdf){ alert('Upload a PDF first'); return; }
    const scale=parseFloat(scaleEl.value||'2');
    const quality=Math.max(0.1, Math.min(1.0, parseFloat(qualityEl.value||'0.9')));
    const total=pdf.numPages;
    for(let i=1;i<=total;i++){
      const page = await pdf.getPage(i);
      const vp = page.getViewport({scale});
      const canvas=document.createElement('canvas'); canvas.width=vp.width; canvas.height=vp.height; const ctx=canvas.getContext('2d');
      await page.render({canvasContext:ctx, viewport:vp}).promise;
      const dataUrl=canvas.toDataURL('image/jpeg', quality);
      const baseName = fileName.replace(/\.pdf$/i,'');
      downloadDataUrl(dataUrl, baseName + '_page_' + i + '.jpg');
    }
  });

  document.getElementById('prevPreview').addEventListener('click', async ()=>{
    if(!pdf) return; currentPreview = Math.max(1, currentPreview - 1); await renderPreview(currentPreview);
  });
  document.getElementById('nextPreview').addEventListener('click', async ()=>{
    if(!pdf) return; currentPreview = Math.min(totalPages, currentPreview + 1); await renderPreview(currentPreview);
  });

  convertZip.addEventListener('click', async ()=>{
    if(!pdf){ alert('Upload a PDF first'); return; }
    const scale=parseFloat(scaleEl.value||'2');
    const quality=Math.max(0.1, Math.min(1.0, parseFloat(qualityEl.value||'0.9')));
    const total=pdf.numPages;
    const zip = new JSZip();
    for(let i=1;i<=total;i++){
      const page = await pdf.getPage(i);
      const vp = page.getViewport({scale});
      const canvas=document.createElement('canvas'); canvas.width=vp.width; canvas.height=vp.height; const ctx=canvas.getContext('2d');
      await page.render({canvasContext:ctx, viewport:vp}).promise;
      const blob = await canvasToBlob(canvas, 'image/jpeg', quality);
      const arrayBuffer = await blob.arrayBuffer();
      const baseName = fileName.replace(/\.pdf$/i,'');
      zip.file(baseName + '_page_' + i + '.jpg', arrayBuffer);
    }
    const zipBlob = await zip.generateAsync({type:'blob'});
    downloadBlob(zipBlob, (fileName.replace(/\.pdf$/i,'') || 'images') + '.zip');
  });

  function canvasToBlob(canvas, type, quality){
    return new Promise((resolve)=> canvas.toBlob(resolve, type, quality));
  }
  function downloadBlob(blob, name){ const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download=name; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); }

  function downloadDataUrl(dataUrl, name){ const a=document.createElement('a'); a.href=dataUrl; a.download=name; document.body.appendChild(a); a.click(); document.body.removeChild(a); }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
