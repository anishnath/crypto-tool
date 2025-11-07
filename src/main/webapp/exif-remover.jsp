<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EXIF Remover – Strip Image Metadata (Batch)</title>
  <meta name="description" content="Remove EXIF/metadata from images (JPG/PNG/WebP). Preview metadata, strip it, and download images or ZIP. Free and private.">
  <link rel="canonical" href="https://8gwifi.org/exif-remover.jsp">
  <meta property="og:title" content="EXIF Remover – Strip Image Metadata">
  <meta property="og:description" content="Preview and remove EXIF metadata from images in your browser.">
  <%@ include file="header-script.jsp"%>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
  <script src="https://unpkg.com/exifr/dist/full.umd.js"></script>
  <script src="https://unpkg.com/piexifjs"></script>
  <script src="https://cdn.jsdelivr.net/npm/heic2any@0.0.4/dist/heic2any.min.js"></script>
  <style>
    .exif .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .exif .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .exif .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .exif .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .exif .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.exif .grid{grid-template-columns:1fr}}
    .exif .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .exif .btn.secondary{background:#64748b}
    .exif .btn:disabled{opacity:.6;cursor:not-allowed}
    .exif .muted{color:#6b7280}
    .exif pre{background:#f8f9fa;border:1px solid #e5e7eb;border-radius:8px;padding:.6rem;max-height:260px;overflow:auto}
    .exif table{width:100%;border-collapse:collapse;font-size:.95rem}
    .exif th,.exif td{border:1px solid #e5e7eb;padding:.35rem .5rem;text-align:left;vertical-align:top}
    .exif th{background:#f8fafc}
    .exif .item.active{outline:2px solid #6366f1}
    .exif .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:.6rem;margin-top:.6rem}
    .exif .item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:.4rem;text-align:center}
    .exif .item img{width:100%;height:auto;border-radius:4px}
  </style>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"EXIF Remover","url":"https://8gwifi.org/exif-remover.jsp","applicationCategory":"UtilitiesApplication","operatingSystem":"Web","description":"Remove EXIF/metadata from images (JPG/PNG/WebP). Preview metadata, strip it, and download images or ZIP. All processing runs locally in your browser.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
    {"@type":"ListItem","position":3,"name":"EXIF Remover","item":"https://8gwifi.org/exif-remover.jsp"}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"HowTo","name":"How to Remove EXIF Metadata","totalTime":"PT1M","step":[
    {"@type":"HowToStep","name":"Upload images","text":"Drop JPG/PNG/WebP files or click to browse."},
    {"@type":"HowToStep","name":"Preview metadata","text":"View EXIF fields (camera, location, etc.)."},
    {"@type":"HowToStep","name":"Strip metadata","text":"Click Remove Metadata to re‑encode without EXIF."},
    {"@type":"HowToStep","name":"Download","text":"Download images individually or as a ZIP archive."}
  ]}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
    {"@type":"Question","name":"Is it safe and private?","acceptedAnswer":{"@type":"Answer","text":"Yes. Everything runs locally in your browser; images are not uploaded."}},
    {"@type":"Question","name":"Which formats are supported?","acceptedAnswer":{"@type":"Answer","text":"JPG, PNG, and WebP. Output format matches input (JPG stripped to JPG, PNG to PNG, etc.)."}},
    {"@type":"Question","name":"What metadata is removed?","acceptedAnswer":{"@type":"Answer","text":"EXIF and other embedded metadata blocks are removed by re‑encoding the pixels to a fresh image."}}
  ]}
  </script>

</head>
<%@ include file="body-script.jsp"%>
<div class="exif"><div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">EXIF Remover</h1>
    <div class="muted">Preview and remove EXIF/metadata from images (JPG/PNG/WebP). Processing runs in your browser.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload Images</h5>
      <div id="drop" class="drop"><strong>Drop images</strong> or click to browse<input id="fileInput" type="file" accept="image/*" multiple style="display:none"></div>
      <div class="thumbs" id="thumbs"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Metadata</h5>
      <div style="display:flex;gap:.6rem;align-items:center;margin:.3rem 0 .5rem 0">
        <label style="display:flex;gap:.4rem;align-items:center"><input type="checkbox" id="convertHeic"> Convert HEIC to JPEG for editing</label>
        <span class="muted">For HEIC/HEIF images, convert to JPEG to enable per-tag removal.</span>
      </div>
      <div id="metaTableWrap" style="max-height:260px;overflow:auto;border:1px solid #e5e7eb;border-radius:8px;padding:.2rem">
        <table id="metaTable">
          <thead>
            <tr>
              <th style="width:90px">Section</th>
              <th style="width:220px">Tag</th>
              <th>Value</th>
              <th style="width:110px"><label style="display:flex;gap:.4rem;align-items:center"><input type="checkbox" id="selectAll"> Select All</label></th>
            </tr>
          </thead>
          <tbody id="metaBody">
            <tr><td colspan="4" class="muted">Drop an image to view its metadata.</td></tr>
          </tbody>
        </table>
      </div>
      <pre id="meta" style="display:none">Drop an image to view its metadata.</pre>
      <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-top:.6rem">
        <button id="stripSelected" class="btn">Remove Selected (Current)</button>
        <button id="strip" class="btn secondary">Remove All</button>
        <button id="stripZip" class="btn secondary">Remove All & ZIP</button>
      </div>
      <div id="status" class="muted" style="margin-top:.5rem"></div>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related Tools</h5>
    <div class="muted">
      <a href="png-jpg-converter.jsp">PNG ↔ JPG</a> ·
      <a href="webp-converter.jsp">WebP Converter</a>
      <a href="exif-editor.jsp">EXIF Editor</a> ·
    </div>
  </div>
</div></div>

<script>
(function(){
  const drop=document.getElementById('drop');
  const input=document.getElementById('fileInput');
  const thumbs=document.getElementById('thumbs');
  const metaPre=document.getElementById('meta');
  const metaBody=document.getElementById('metaBody');
  const selectAll=document.getElementById('selectAll');
  const convertHeic=document.getElementById('convertHeic');
  const status=document.getElementById('status');
  let files=[];
  let selectedIndex=null;
  const convCache=new Map();

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs.length){ addFiles(fs); }});
  input.addEventListener('change', ()=>{ if(input.files && input.files.length) addFiles(input.files); });

  function isImg(f){ if(!f) return false; const t=(f.type||'').toLowerCase(); return t.startsWith('image/'); }
  function addFiles(list){
    const pick=[...list]; const valid=pick.filter(isImg); const skipped=pick.length-valid.length; if(skipped>0) setStatus(skipped+" file(s) skipped (not image)");
    const baseLen = files.length; files = files.concat(valid); render();
    if(valid.length){ selectIndex(baseLen); }
  }
  function render(){ thumbs.innerHTML=''; files.forEach((f,i)=>{ const url=URL.createObjectURL(f); const img=document.createElement('img'); img.src=url; const item=document.createElement('div'); item.className='item'+(i===selectedIndex?' active':''); item.appendChild(img); item.addEventListener('click',()=>selectIndex(i)); thumbs.appendChild(item); }); }
  function setStatus(s){ status.textContent = s || ''; }

  function fileToDataURL(f){ return new Promise((res,rej)=>{ const r=new FileReader(); r.onload=()=>res(r.result); r.onerror=rej; r.readAsDataURL(f); }); }
  function isHeic(f){ const n=(f?.name||'').toLowerCase(); const t=(f?.type||'').toLowerCase(); return /\.(heic|heif)$/.test(n) || t.includes('heic') || t.includes('heif'); }
  async function convertHeicToJpegFile(f){
    if(!(window.heic2any)) throw new Error('HEIC converter not available');
    const res = await window.heic2any({ blob: f, toType: 'image/jpeg', quality: 0.92 });
    const blob = (res instanceof Blob)? res : (Array.isArray(res)? res[0] : null);
    if(!blob) throw new Error('Conversion failed');
    const nameBase = (f.name||'image').replace(/\.(heic|heif)$/i,'');
    return new File([blob], nameBase + '_converted.jpg', { type: 'image/jpeg' });
  }
  async function getWorkingFile(i){
    const f = files[i];
    if(convertHeic?.checked && isHeic(f)){
      if(convCache.has(i)) return convCache.get(i);
      try{ const out = await convertHeicToJpegFile(f); convCache.set(i,out); return out; }
      catch(e){ setStatus('HEIC conversion failed: '+e.message); return f; }
    }
    return f;
  }
  function invert(obj){ const m={}; for(const k in obj){ m[obj[k]] = k; } return m; }
  const NAME_BY_ID = { '0th': invert(piexif.ImageIFD||{}), Exif: invert(piexif.ExifIFD||{}), GPS: invert(piexif.GPSIFD||{}) };
  function tagName(ifd, id){ return NAME_BY_ID[ifd]?.[id] || ('Tag '+id); }
  function short(v){ try{ if(Array.isArray(v)) return JSON.stringify(v).slice(0,120); if(typeof v==='object') return JSON.stringify(v).slice(0,120); return String(v).slice(0,120); }catch(_){ return String(v).slice(0,120);} }

  async function selectIndex(i){ selectedIndex=i; render(); if(files[i]){ const wf = await getWorkingFile(i); await showMeta(wf); } }

  async function showMeta(file){
    try{ const data = await exifr.parse(file,{userComment:true}); metaPre.textContent = JSON.stringify(data, null, 2) || 'No metadata found.'; }catch(e){ metaPre.textContent='Could not read EXIF: '+e.message; }
    metaBody.innerHTML='';
    const isJpeg = (file.type||'').toLowerCase().includes('jpeg') || (file.name||'').toLowerCase().match(/\.(jpe?g)$/);
    if(!isJpeg){
      // Render read-only table for non-JPEG (e.g., HEIC/HEIF, PNG, WebP)
      selectAll.disabled = true;
      try{
        const data = await exifr.parse(file,{userComment:true});
        let count=0;
        const addRow=(section,key,value)=>{ const tr=document.createElement('tr'); const tdSec=document.createElement('td'); tdSec.textContent=section; tr.appendChild(tdSec); const tdName=document.createElement('td'); tdName.textContent=key; tr.appendChild(tdName); const tdVal=document.createElement('td'); tdVal.textContent=short(value); tr.appendChild(tdVal); const tdChk=document.createElement('td'); const cb=document.createElement('input'); cb.type='checkbox'; cb.disabled=true; tdChk.appendChild(cb); tr.appendChild(tdChk); metaBody.appendChild(tr); count++; };
        if(data && typeof data==='object'){
          // GPS
          if(data.gps && (data.gps.latitude!=null || data.gps.longitude!=null)){
            if(data.gps.latitude!=null) addRow('GPS','latitude', data.gps.latitude);
            if(data.gps.longitude!=null) addRow('GPS','longitude', data.gps.longitude);
          }
          // Other top-level fields
          Object.keys(data).forEach(k=>{
            if(k==='gps') return;
            const v=data[k];
            if(v==null) return;
            if(v instanceof Date) addRow('EXIF', k, v.toISOString());
            else if(['string','number','boolean'].includes(typeof v)) addRow('EXIF', k, v);
          });
        }
        if(count===0){ const tr=document.createElement('tr'); const td=document.createElement('td'); td.colSpan=4; td.className='muted'; td.textContent='No readable metadata found for this format.'; tr.appendChild(td); metaBody.appendChild(tr); }
      }catch(e){ const tr=document.createElement('tr'); const td=document.createElement('td'); td.colSpan=4; td.className='muted'; td.textContent='Could not read metadata: '+e.message; tr.appendChild(td); metaBody.appendChild(tr); }
      return;
    }
    selectAll.disabled = false;
    try{
      const dataURL = await fileToDataURL(file);
      const exifObj = piexif.load(dataURL);
      const sections=['0th','Exif','GPS']; let count=0;
      sections.forEach(sec=>{ const dict=exifObj[sec]||{}; Object.keys(dict).forEach(idStr=>{ const id=parseInt(idStr,10); const tr=document.createElement('tr'); tr.className='exif-row'; tr.dataset.ifd=sec; tr.dataset.tagid=String(id); const tdSec=document.createElement('td'); tdSec.textContent=sec; tr.appendChild(tdSec); const tdName=document.createElement('td'); tdName.textContent=tagName(sec,id)+` (${id})`; tr.appendChild(tdName); const tdVal=document.createElement('td'); tdVal.textContent=short(dict[idStr]); tr.appendChild(tdVal); const tdChk=document.createElement('td'); const cb=document.createElement('input'); cb.type='checkbox'; cb.className='rm'; tdChk.appendChild(cb); tr.appendChild(tdChk); metaBody.appendChild(tr); count++; }); });
      if(count===0){ const tr=document.createElement('tr'); const td=document.createElement('td'); td.colSpan=4; td.className='muted'; td.textContent='No EXIF tags found.'; tr.appendChild(td); metaBody.appendChild(tr); }
    }catch(e){ const tr=document.createElement('tr'); const td=document.createElement('td'); td.colSpan=4; td.className='muted'; td.textContent='Could not read EXIF for selective removal: '+e.message; tr.appendChild(td); metaBody.appendChild(tr); }
  }

  async function stripOne(file){
    const url=URL.createObjectURL(file); const img=new Image(); await new Promise((res,rej)=>{ img.onload=res; img.onerror=()=>rej(new Error('Load failed')); img.src=url; }); const c=document.createElement('canvas'); c.width=img.width; c.height=img.height; const g=c.getContext('2d'); g.drawImage(img,0,0); URL.revokeObjectURL(url); const mime = (file.type||'image/jpeg').toLowerCase().includes('png')? 'image/png' : (file.type||'image/jpeg'); const blob = await new Promise(res=> c.toBlob(res, mime==='image/jpeg'? 0.92 : undefined, mime)); return blob;
  }

  async function stripSelectedFromCurrent(){
    if(selectedIndex==null || !files[selectedIndex]){ setStatus('Select an image first'); return; }
    const f = await getWorkingFile(selectedIndex);
    const isJpeg = (f.type||'').toLowerCase().includes('jpeg') || (f.name||'').toLowerCase().match(/\.(jpe?g)$/);
    if(!isJpeg){ setStatus('Selective removal only works for JPEG. Use Remove All.'); return; }
    try{
      setStatus('Removing selected tags...');
      const dataURL = await fileToDataURL(f);
      const exifObj = piexif.load(dataURL);
      const rows = Array.from(document.querySelectorAll('#metaBody tr.exif-row'));
      const toRemove = rows.filter(r=> r.querySelector('input.rm')?.checked).map(r=>({ifd:r.dataset.ifd, tag: parseInt(r.dataset.tagid,10)}));
      if(!toRemove.length){ setStatus('No tags selected'); return; }
      toRemove.forEach(({ifd,tag})=>{ try{ delete exifObj[ifd][tag]; }catch(_){ } });
      const exifBytes = piexif.dump(exifObj);
      let newURL; try{ newURL = piexif.insert(exifBytes, dataURL); } catch(e){ const fixed = dataURL.replace(/^data:[^;]+;base64,/, 'data:image/jpeg;base64,'); newURL = piexif.insert(exifBytes, fixed); }
      const a=document.createElement('a'); a.href=newURL; const base=(f.name||'image').replace(/\.(png|jpg|jpeg|webp)$/i,''); a.download=base+'_cleaned.jpg'; document.body.appendChild(a); a.click(); document.body.removeChild(a);
      setStatus('Selected tags removed and downloaded.');
    }catch(e){ setStatus('Failed: '+e.message); }
  }

  document.getElementById('stripSelected').addEventListener('click', stripSelectedFromCurrent);
  document.getElementById('strip').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add images first'); return; }
    setStatus('Stripping '+files.length+' image(s)...');
    for(let i=0;i<files.length;i++){ const wf= await getWorkingFile(i); const b=await stripOne(wf); const base=(files[i].name||'image').replace(/\.(png|jpg|jpeg|webp|heic|heif)$/i,''); const ext = (wf.type||'image/jpeg').toLowerCase().includes('png')? '.png' : (wf.type.toLowerCase().includes('webp')? '.webp': '.jpg'); downloadBlob(b, base+'_stripped'+ext); }
    setStatus('Done');
  });
  document.getElementById('stripZip').addEventListener('click', async ()=>{
    if(!files.length){ setStatus('Add images first'); return; }
    setStatus('Stripping & zipping...'); const zip=new JSZip(); let j=0;
    for(let i=0;i<files.length;i++){ const wf= await getWorkingFile(i); const b=await stripOne(wf); const base=(files[i].name||('image_'+(++j))).replace(/\.(png|jpg|jpeg|webp|heic|heif)$/i,''); const ext = (wf.type||'image/jpeg').toLowerCase().includes('png')? '.png' : (wf.type.toLowerCase().includes('webp')? '.webp': '.jpg'); zip.file(base+'_stripped'+ext, await b.arrayBuffer()); }
    const z=await zip.generateAsync({type:'blob'}); downloadBlob(z,'images_stripped.zip'); setStatus('ZIP downloaded');
  });

  function downloadBlob(blob, name){ const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download=name; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); }

  selectAll.addEventListener('change', ()=>{ const cbs = document.querySelectorAll('#metaBody input.rm'); cbs.forEach(cb=> cb.checked = selectAll.checked); });
  convertHeic.addEventListener('change', async ()=>{ convCache.clear(); if(selectedIndex!=null) await selectIndex(selectedIndex); });
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
