<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%
  response.setHeader("Cross-Origin-Opener-Policy", "same-origin");
  response.setHeader("Cross-Origin-Embedder-Policy", "require-corp");
  response.setHeader("Cross-Origin-Resource-Policy", "same-origin");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>GIF ↔ MP4 Converter – Online (Batch)</title>
  <meta name="description" content="Convert GIF to MP4 for smaller size, or MP4 to GIF with FPS and width controls. Optionally export frames as ZIP. Free and private.">
  <link rel="canonical" href="https://8gwifi.org/gif-mp4-converter.jsp">
  <meta property="og:title" content="GIF ↔ MP4 Converter – Online">
  <meta property="og:description" content="GIF→MP4, MP4→GIF, export frames ZIP. Client-side with ffmpeg.wasm.">
  <meta property="og:type" content="website"><meta property="og:url" content="https://8gwifi.org/gif-mp4-converter.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script src="js/ffmpeg/ffmpeg.min.js"></script>
  <style>
    .gm .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .gm .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .gm .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .gm .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .gm .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.gm .grid{grid-template-columns:1fr}}
    .gm .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .gm .btn.secondary{background:#64748b}
    .gm .btn:disabled{opacity:.6;cursor:not-allowed}
    .gm .muted{color:#6b7280}
    .gm .preview{margin-top:.75rem}
    .gm .preview video,.gm .preview img{max-width:100%;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,.08);background:#000}
    .gm .loading{display:none;align-items:center;gap:8px;color:#6b7280;margin-top:.5rem}
    .gm .spinner{width:16px;height:16px;border:2px solid #e5e7eb;border-top-color:#6366f1;border-radius:50%;animation:spin 1s linear infinite}
    @keyframes spin{to{transform:rotate(360deg)}}
  </style>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "GIF ↔ MP4 Converter",
    "url": "https://8gwifi.org/gif-mp4-converter.jsp",
    "applicationCategory": "MultimediaApplication",
    "operatingSystem": "Web",
    "description": "Convert GIF to MP4 for smaller size, or MP4 to GIF with FPS and width controls. Export video frames as ZIP. Runs entirely in your browser using FFmpeg.wasm.",
    "offers": {"@type":"Offer","price":"0","priceCurrency":"USD"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"BreadcrumbList",
    "itemListElement":[
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
      {"@type":"ListItem","position":3,"name":"GIF ↔ MP4 Converter","item":"https://8gwifi.org/gif-mp4-converter.jsp"}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"HowTo",
    "name":"How to Convert GIF and MP4 Online",
    "totalTime":"PT1M",
    "step":[
      {"@type":"HowToStep","name":"Upload","text":"Drop your GIF or MP4 or click to browse."},
      {"@type":"HowToStep","name":"Choose Mode","text":"The tool auto-detects file type and selects a mode (GIF→MP4 or MP4→GIF); adjust if needed."},
      {"@type":"HowToStep","name":"Set Options","text":"Pick FPS and width (optional)."},
      {"@type":"HowToStep","name":"Convert","text":"Click Convert and wait while processing completes in your browser."},
      {"@type":"HowToStep","name":"Download","text":"Save your MP4/GIF or download frames as a ZIP archive."}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"Is the conversion private?","acceptedAnswer":{"@type":"Answer","text":"Yes. All processing happens locally in your browser with WebAssembly (FFmpeg.wasm). Your files never leave your device."}},
      {"@type":"Question","name":"Which formats are supported?","acceptedAnswer":{"@type":"Answer","text":"You can convert GIF→MP4 and MP4→GIF. You can also export MP4 frames as PNG images in a ZIP."}},
      {"@type":"Question","name":"Why does it take longer the first time?","acceptedAnswer":{"@type":"Answer","text":"The tool downloads and initializes the video engine (FFmpeg.wasm) on first use. Subsequent conversions are faster."}},
      {"@type":"Question","name":"How can I reduce GIF file size?","acceptedAnswer":{"@type":"Answer","text":"Use a lower FPS and smaller width. Converting GIF to MP4 typically produces much smaller files."}}
    ]
  }
  </script>
</head>
<%@ include file="body-script.jsp"%>

<div class="gm"><div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">GIF ↔ MP4 Converter</h1>
    <div class="muted">Convert GIF to MP4 (smaller), or MP4 to GIF with FPS/width. Export frames ZIP. Processing happens in your browser (ffmpeg.wasm), larger files may be slower.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload</h5>
      <div id="drop" class="drop"><strong>Drop GIF/MP4</strong> or click to browse<input id="fileInput" type="file" accept="image/gif,video/mp4,.gif,.mp4" multiple style="display:none"></div>
      <div class="muted" id="queue" style="margin-top:.6rem"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label>Mode
        <select id="mode" class="form-control">
          <option value="gif2mp4" selected>GIF → MP4</option>
          <option value="mp42gif">MP4 → GIF</option>
          <option value="mp4frames">MP4 → Frames (ZIP)</option>
        </select>
      </label>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:.5rem;margin-top:.4rem">
        <label>FPS <input id="fps" type="number" class="form-control" min="1" max="60" value="12"></label>
        <label>Width (px) <input id="width" type="number" class="form-control" min="64" step="1" placeholder="auto"></label>
      </div>
      <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-top:.6rem">
        <button id="convert" class="btn">Convert</button>
      </div>
      <div id="status" class="muted" style="margin-top:.5rem"></div>
      <div id="engineLoading" class="loading"><span class="spinner"></span><span>Loading video engine…</span></div>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related Tools</h5>
    <div class="muted">
      <a href="video-resizer.jsp">Video Resizer & Cropper</a> ·
      <a href="png-jpg-converter.jsp">PNG ↔ JPG</a>
    </div>
  </div>
</div></div>

<script>
(function(){
  const { createFFmpeg } = (typeof FFmpeg !== 'undefined' ? FFmpeg : {});
  let ffmpeg = null;
  const loadFF = async ()=>{
    if(!createFFmpeg) throw new Error('ffmpeg.wasm not available');
    if(!ffmpeg){
      const el = document.getElementById('engineLoading');
      const btn = document.getElementById('convert');
      if(el) el.style.display='flex';
      if(btn) btn.disabled = true;
      ffmpeg = createFFmpeg({ log: false });
      await ffmpeg.load();
      if(el) el.style.display='none';
      if(btn) btn.disabled = false;
    }
  };

  const drop=document.getElementById('drop');
  const input=document.getElementById('fileInput');
  const queue=document.getElementById('queue');
  const status=document.getElementById('status');
  const modeSel=document.getElementById('mode');
  const fpsEl=document.getElementById('fps');
  const widthEl=document.getElementById('width');
  let files=[];

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs.length){ addFiles(fs); }});
  input.addEventListener('change', ()=>{ if(input.files && input.files.length) addFiles(input.files); });

  function isGifMp4(f){ if(!f) return false; const t=(f.type||'').toLowerCase(); const n=(f.name||'').toLowerCase(); return t==='image/gif'||t==='video/mp4'||n.endsWith('.gif')||n.endsWith('.mp4'); }
  
  function addFiles(list){
    const pick=[...list];
    const valid=pick.filter(isGifMp4);
    const skipped=pick.length-valid.length;
    if(skipped>0) setStatus(skipped+" file(s) skipped (not GIF/MP4)");
    files = valid; // reset to last selection for simplicity
    render();
    autoModeAndPreview();
  }

  
  function render(){ queue.textContent = files.map(f=>f.name).join(', '); }
  function clearPreview(){ const p=document.getElementById('preview'); if(p) p.innerHTML=''; }
  function autoModeAndPreview(){
    clearPreview(); if(!files.length) return;
    const f = files[0];
    const t=(f.type||'').toLowerCase(); const n=(f.name||'').toLowerCase();
    const isMp4 = t==='video/mp4' || n.endsWith('.mp4');
    const isGif = t==='image/gif' || n.endsWith('.gif');
    let p=document.getElementById('preview'); if(!p){ p=document.createElement('div'); p.id='preview'; p.className='preview'; (document.getElementById('queue')||document.body).after(p); }
    if(isMp4){ try{ modeSel.value='mp42gif'; }catch(e){} const url=URL.createObjectURL(f); const v=document.createElement('video'); v.controls=true; v.src=url; v.onended=()=>URL.revokeObjectURL(url); p.appendChild(v); setStatus('Detected MP4. Mode set to MP4 → GIF.'); }
    else if(isGif){ try{ modeSel.value='gif2mp4'; }catch(e){} const url=URL.createObjectURL(f); const img=document.createElement('img'); img.src=url; img.onload=()=>URL.revokeObjectURL(url); p.appendChild(img); setStatus('Detected GIF. Mode set to GIF → MP4.'); }
  }

  function setStatus(s){ status.textContent = s || ''; }

  async function convertOne(file){
    await loadFF();
    const u8 = new Uint8Array(await file.arrayBuffer());
    const inName = file.name.toLowerCase().endsWith('.gif')? 'input.gif' : 'input.mp4';
    ffmpeg.FS('writeFile', inName, u8);
    const mode = modeSel.value; const fps = parseInt(fpsEl.value||'12',10); const w = parseInt(widthEl.value||'0',10);
    let args=[]; let out='';
    if(mode==='gif2mp4' && inName==='input.gif'){
      out='out.mp4'; args=['-i','input.gif','-movflags','faststart','-pix_fmt','yuv420p']; if(fps>0) args.push('-r',String(fps)); if(w>0) args.push('-vf',`scale=${w}:-2`); args.push(out);
    } else if(mode==='mp42gif' && inName==='input.mp4'){
      out='out.gif'; args=['-i','input.mp4']; if(fps>0) args.push('-r',String(fps)); if(w>0) args.push('-vf',`scale=${w}:-2:flags=lanczos`); args.push(out);
    } else if(mode==='mp4frames' && inName==='input.mp4'){
      out='frames_%03d.png'; args=['-i','input.mp4']; if(fps>0) args.push('-r',String(fps)); if(w>0) args.push('-vf',`scale=${w}:-2`); args.push('frames_%03d.png');
    } else {
      throw new Error('Mode/file mismatch');
    }
    await ffmpeg.run(...args);
    if(mode==='mp4frames'){
      const zip=new JSZip(); let i=1; while(true){ const fname=`frames_${String(i).padStart(3,'0')}.png`; try{ const data=ffmpeg.FS('readFile', fname); zip.file(fname, data); ffmpeg.FS('unlink', fname); i++; } catch(e){ break; } }
      ffmpeg.FS('unlink', inName);
      const blob = await zip.generateAsync({type:'blob'}); downloadBlob(blob, (file.name||'video')+'_frames.zip');
    } else {
      const data = ffmpeg.FS('readFile', out); ffmpeg.FS('unlink', out); ffmpeg.FS('unlink', inName);
      const mime = out.endsWith('.gif')? 'image/gif' : 'video/mp4';
      const blob = new Blob([data.buffer], {type: mime});
      const base=(file.name||'output').replace(/\.(gif|mp4)$/i,''); const ext = out.endsWith('.gif')? '.gif' : '.mp4';
      downloadBlob(blob, base+ext);
    }
  }

  document.getElementById('convert').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add GIF/MP4 files first'); return; }
    setStatus('Loading engine...');
    try{ await loadFF(); }catch(e){ setStatus('ffmpeg.wasm failed to load: '+e.message); const el=document.getElementById('engineLoading'); if(el) el.style.display='none'; return; }
    setStatus('Converting '+files.length+' file(s)...');
    for(const f of files){ try{ await convertOne(f); }catch(e){ setStatus('Error: '+e.message); break; } }
    setStatus('Done');
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
