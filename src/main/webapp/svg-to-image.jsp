<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SVG to PNG/JPG – Convert SVG with Size, Background, DPI</title>
  <meta name="description" content="Convert SVG to PNG or JPG online. Control width/height, background color, scale/DPI, and download individually or as ZIP. Free and private.">
  <link rel="canonical" href="https://8gwifi.org/svg-to-image.jsp">
  <meta property="og:title" content="SVG to PNG/JPG – Online Converter">
  <meta property="og:description" content="Convert SVG to PNG/JPG with custom size, background, and DPI. Batch download as ZIP.">
  <meta property="og:type" content="website"><meta property="og:url" content="https://8gwifi.org/svg-to-image.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <style>
    .svgc .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .svgc .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .svgc .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .svgc .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .svgc .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.svgc .grid{grid-template-columns:1fr}}
    .svgc .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .svgc .btn.secondary{background:#64748b}
    .svgc .btn:disabled{opacity:.6;cursor:not-allowed}
    .svgc .muted{color:#6b7280}
    .svgc .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:.6rem;margin-top:.6rem}
    .svgc .item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:.4rem}
    .svgc .item .name{font-size:.85rem;color:#6b7280;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
  </style>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"SVG to PNG/JPG Converter","url":"https://8gwifi.org/svg-to-image.jsp","applicationCategory":"UtilitiesApplication","operatingSystem":"Web","description":"Convert SVG to PNG or JPG with size, background, and DPI controls. Batch ZIP download.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
    {"@type":"ListItem","position":3,"name":"SVG to PNG/JPG","item":"https://8gwifi.org/svg-to-image.jsp"}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"HowTo","name":"How to Convert SVG to PNG/JPG","totalTime":"PT1M","step":[
    {"@type":"HowToStep","name":"Upload SVG","text":"Drop SVG files or click to browse."},
    {"@type":"HowToStep","name":"Choose options","text":"Set output format, width/height, background, and scale/DPI."},
    {"@type":"HowToStep","name":"Convert","text":"Click Convert or Convert & Download ZIP."},
    {"@type":"HowToStep","name":"Download","text":"Save converted images individually or as a ZIP archive."}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"Does this run in the browser?","acceptedAnswer":{"@type":"Answer","text":"Yes. Conversion runs locally via Canvas; no upload required."}},
    {"@type":"Question","name":"How do I keep transparency?","acceptedAnswer":{"@type":"Answer","text":"Use PNG output and enable Transparent background."}},
    {"@type":"Question","name":"What size should I use?","acceptedAnswer":{"@type":"Answer","text":"Set width/height or use Scale/DPI to increase resolution; leaving one dimension blank auto‑scales by aspect ratio."}}
  ]}
  </script>

</head>
<%@ include file="body-script.jsp"%>
<div class="svgc"><div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">SVG to PNG/JPG</h1>
    <div class="muted">Upload SVGs, set size/background/DPI, and convert to PNG or JPG.
    </div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload SVG</h5>
      <div id="drop" class="drop"><strong>Drop SVG files</strong> or click to browse<input id="fileInput" type="file" accept="image/svg+xml,.svg" multiple style="display:none"></div>
      <div class="thumbs" id="thumbs"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label>Output format
        <select id="outFmt" class="form-control">
          <option value="image/png" selected>PNG</option>
          <option value="image/jpeg">JPG (JPEG)</option>
        </select>
      </label>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:.5rem;margin-top:.4rem">
        <label>Width (px)<input id="w" type="number" class="form-control" min="1" placeholder="e.g. 1024"></label>
        <label>Height (px)<input id="h" type="number" class="form-control" min="1" placeholder="auto"></label>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:.5rem;margin-top:.4rem">
        <label>Scale<input id="scale" type="number" class="form-control" min="0.1" step="0.1" value="1"></label>
        <label>DPI<label><input id="dpi" type="number" class="form-control" min="72" step="1" value="96"></label></label>
      </div>
      <div style="display:flex;gap:.5rem;align-items:center;margin-top:.4rem">
        <label style="margin:0">Background <input id="bg" type="color" value="#ffffff"></label>
        <label style="margin:0"><input id="bgTransparent" type="checkbox" checked> Transparent</label>
        <label style="margin:0">JPEG Quality <input id="q" type="number" min="0.1" max="1" step="0.1" value="0.9" class="form-control" style="width:6rem"></label>
      </div>
      <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-top:.6rem">
        <button id="convert" class="btn">Convert</button>
        <button id="convertZip" class="btn secondary">Convert & Download ZIP</button>
      </div>
      <div id="status" class="muted" style="margin-top:.5rem"></div>
      <div class="muted" style="margin-top:.5rem">Tip: If only one dimension is set, the other is auto‑scaled based on the SVG viewBox.</div>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related Tools</h5>
    <div class="muted">
      <a href="png-jpg-converter.jsp">PNG ↔ JPG</a> ·
      <a href="webp-converter.jsp">WebP Converter</a>
    </div>
  </div>
</div></div>

<script>
(function(){
  const drop=document.getElementById('drop');
  const input=document.getElementById('fileInput');
  const thumbs=document.getElementById('thumbs');
  const outFmt=document.getElementById('outFmt');
  const wEl=document.getElementById('w');
  const hEl=document.getElementById('h');
  const scaleEl=document.getElementById('scale');
  const dpiEl=document.getElementById('dpi');
  const bgEl=document.getElementById('bg');
  const bgT=document.getElementById('bgTransparent');
  const qEl=document.getElementById('q');
  const status=document.getElementById('status');
  let files=[];

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs.length){ addFiles(fs); }});
  input.addEventListener('change', ()=>{ if(input.files && input.files.length) addFiles(input.files); });

  function isSvg(f){ if(!f) return false; const t=(f.type||'').toLowerCase(); if(t==='image/svg+xml') return true; const n=(f.name||'').toLowerCase(); return n.endsWith('.svg'); }
  function addFiles(list){ const pick=[...list]; const valid=pick.filter(isSvg); const skipped=pick.length-valid.length; if(skipped>0) setStatus(skipped+" file(s) skipped (not SVG)"); files = files.concat(valid); render(); }
  function render(){ thumbs.innerHTML=''; files.forEach(f=>{ const item=document.createElement('div'); item.className='item'; const name=document.createElement('div'); name.className='name'; name.textContent=f.name; item.appendChild(name); thumbs.appendChild(item); }); }
  function setStatus(s){ status.textContent = s || ''; }

  async function svgToImageBlob(svgFile, mime){
    const text = await svgFile.text();
    // inject DPI hint via width/height if absent and dpi provided
    let w=parseInt(wEl.value||0,10), h=parseInt(hEl.value||0,10), scale=parseFloat(scaleEl.value||'1');
    if(!(scale>0)) scale=1;
    // Parse viewBox for aspect
    let viewBoxMatch = text.match(/viewBox\s*=\s*"([^"]+)"/i);
    let vb=null; if(viewBoxMatch){ vb = viewBoxMatch[1].trim().split(/\s+/).map(parseFloat); }
    if((!w||!h) && vb && vb.length===4){ const vbw=vb[2], vbh=vb[3]; if(!w && !h){ w=Math.round(vbw*scale); h=Math.round(vbh*scale);} else if(!w){ w=Math.round((vbw/vbh)*h); } else if(!h){ h=Math.round((vbh/vbw)*w); } }
    if(!w) w=1024; if(!h) h=Math.round(w*0.75);
    const can=document.createElement('canvas'); can.width=w; can.height=h; const ctx=can.getContext('2d');
    if(!bgT.checked){ ctx.fillStyle=bgEl.value||'#ffffff'; ctx.fillRect(0,0,w,h); }
    const b64 = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(text);
    const img = new Image();
    img.crossOrigin='anonymous';
    await new Promise((res,rej)=>{ img.onload=res; img.onerror=()=>rej(new Error('Failed to render SVG')); img.src=b64; });
    ctx.drawImage(img,0,0,w,h);
    const quality = parseFloat(qEl.value||'0.9');
    return new Promise((resolve)=> can.toBlob(resolve, mime, quality));
  }

  document.getElementById('convert').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add SVG files first'); return; }
    setStatus('Converting '+files.length+' file(s)...');
    const mime = outFmt.value;
    for(const f of files){ const blob = await svgToImageBlob(f, mime); const base=(f.name||'image').replace(/\.svg$/i,''); const ext = mime==='image/png'?'.png':'.jpg'; downloadBlob(blob, base+ext); }
    setStatus('Done');
  });
  document.getElementById('convertZip').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add SVG files first'); return; }
    setStatus('Converting & zipping...');
    const mime = outFmt.value; const zip=new JSZip(); let idx=0;
    for(const f of files){ const blob = await svgToImageBlob(f, mime); const base=(f.name||('image_'+(++idx))).replace(/\.svg$/i,''); const ext = mime==='image/png'?'.png':'.jpg'; zip.file(base+ext, await blob.arrayBuffer()); }
    const z=await zip.generateAsync({type:'blob'}); downloadBlob(z,'svg_images.zip'); setStatus('ZIP downloaded');
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
