<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EXIF Editor – View & Edit Image Metadata (JPEG)</title>
  <meta name="description" content="View and edit EXIF metadata in JPEG images. Change title, artist, date, camera, GPS, and more. Remove metadata or download updated JPEG.">
  <link rel="canonical" href="https://8gwifi.org/exif-editor.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://unpkg.com/exifr/dist/full.umd.js"></script>
  <script src="https://unpkg.com/piexifjs"></script>
  <style>
    .exifedit .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .exifedit .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .exifedit .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .exifedit .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .exifedit .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.exifedit .grid{grid-template-columns:1fr}}
    .exifedit .btn{border:none;border-radius:8px;padding:.55rem 1rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .exifedit .btn.secondary{background:#64748b}
    .exifedit .btn:disabled{opacity:.6;cursor:not-allowed}
    .exifedit .muted{color:#6b7280}
    .exifedit .thumb{max-width:100%;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,.08)}
    .exifedit label{font-weight:600;margin:.35rem 0 .15rem;display:block}
    .exifedit input,.exifedit select,.exifedit textarea{width:100%;padding:.45rem;border:1px solid #e5e7eb;border-radius:6px}
    .exifedit .tag-row{display:grid;grid-template-columns:0.7fr 1fr 1.2fr auto;gap:.5rem;align-items:center;margin:.4rem 0}
    .exifedit .tag-row button{margin:0}
  </style>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"WebApplication","name":"EXIF Editor","url":"https://8gwifi.org/exif-editor.jsp","applicationCategory":"UtilitiesApplication","operatingSystem":"Web","description":"View and edit EXIF metadata in JPEG images. Change title, artist, date, camera, GPS; remove metadata; download updated JPEG.","offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}}
  </script>
  <script type="application/ld+json">
  {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
    {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
    {"@type":"ListItem","position":2,"name":"Media Tools","item":"https://8gwifi.org/image-resizer.jsp"},
    {"@type":"ListItem","position":3,"name":"EXIF Editor","item":"https://8gwifi.org/exif-editor.jsp"}
  ]}
  </script>
</head>
<%@ include file="body-script.jsp"%>
<div class="exifedit"><div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">EXIF Editor (JPEG)</h1>
    <div class="muted">Upload a JPEG image to view and edit EXIF metadata. For PNG/WebP, convert to JPEG first to embed EXIF, or use EXIF Remover to strip metadata.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload</h5>
      <div id="drop" class="drop"><strong>Drop JPEG</strong> or click to browse<input id="fileInput" type="file" accept="image/jpeg,.jpg,.jpeg,image/png,image/webp" style="display:none"></div>
      <div id="preview" style="margin-top:.6rem"></div>
      <div id="status" class="muted" style="margin-top:.5rem"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Edit EXIF Fields</h5>
      <div class="muted" style="margin-bottom:.5rem">Fields apply to JPEG. If you upload PNG/WebP it will be converted to JPEG to embed EXIF.</div>
      <label>Image Description <input id="desc"></label>
      <label>Artist <input id="artist"></label>
      <label>Copyright <input id="copyright"></label>
      <label>Date/Time Original <input id="dto" type="datetime-local" step="1" placeholder="YYYY-MM-DDTHH:MM:SS"></label>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:.5rem">
        <label>Camera Make <input id="make"></label>
        <label>Camera Model <input id="model"></label>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:.5rem">
        <label>GPS Latitude (decimal) <input id="lat" placeholder="e.g. 37.4219983"></label>
        <label>GPS Longitude (decimal) <input id="lng" placeholder="e.g. -122.084"></label>
      </div>
      <div style="display:flex;gap:.5rem;flex-wrap:wrap;margin-top:.6rem">
        <button id="read" class="btn secondary">Read Metadata</button>
        <button id="apply" class="btn">Apply & Download JPEG</button>
        <button id="strip" class="btn secondary">Remove All Metadata</button>
      </div>

      <hr style="margin:1rem 0;border:none;border-top:1px solid #e5e7eb">
      <h6 style="margin:.2rem 0 .3rem 0">Custom EXIF Tags (Advanced)</h6>
      <div id="customTags"></div>
      <div style="display:flex;gap:.5rem;align-items:center;margin-top:.4rem">
        <button id="addTag" type="button" class="btn secondary">Add Tag</button>
        <div class="muted">Choose section, pick a tag name (or enter numeric tag id), then set a value. Some tags require special formats and may not apply.</div>
      </div>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related Tools</h5>
    <div class="muted">
      <a href="exif-remover.jsp">EXIF Remover</a> ·
      <a href="png-jpg-converter.jsp">PNG ↔ JPG</a> ·
      <a href="webp-converter.jsp">WebP Converter</a>
    </div>
  </div>
</div></div>

<script>
(function(){
  const drop=document.getElementById('drop');
  const input=document.getElementById('fileInput');
  const preview=document.getElementById('preview');
  const status=document.getElementById('status');
  const fields = {
    desc: document.getElementById('desc'),
    artist: document.getElementById('artist'),
    copyright: document.getElementById('copyright'),
    dto: document.getElementById('dto'),
    make: document.getElementById('make'),
    model: document.getElementById('model'),
    lat: document.getElementById('lat'),
    lng: document.getElementById('lng')
  };
  let file=null;

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs[0]) handleFile(fs[0]); });
  input.addEventListener('change', ()=>{ if(input.files && input.files[0]) handleFile(input.files[0]); });

  function setStatus(s){ status.textContent=s||''; }
  function showPreview(f){ preview.innerHTML=''; const url=URL.createObjectURL(f); const img=document.createElement('img'); img.className='thumb'; img.src=url; img.onload=()=>URL.revokeObjectURL(url); preview.appendChild(img); }
  function isJpeg(f){ const t=(f.type||'').toLowerCase(); const n=(f.name||'').toLowerCase(); return t==='image/jpeg'||n.endsWith('.jpg')||n.endsWith('.jpeg'); }

  async function handleFile(f){
    file=f; showPreview(f); setStatus('');
    try{ await readMeta(); }catch(e){ /* ignore */ }
  }

  async function readMeta(){
    if(!file) return; setStatus('Reading metadata...');
    try{ const data = await exifr.parse(file,{userComment:true});
      fields.desc.value = data?.ImageDescription || '';
      fields.artist.value = data?.Artist || '';
      fields.copyright.value = data?.Copyright || '';
      fields.dto.value = exifDateToLocalInput(data?.DateTimeOriginal) || '';
      fields.make.value = data?.Make || '';
      fields.model.value = data?.Model || '';
      if(data?.gps){
        fields.lat.value = data.gps.latitude||'';
        fields.lng.value = data.gps.longitude||'';
      }
      setStatus('Metadata loaded.');
    }catch(e){ setStatus('No EXIF or could not parse.'); }
  }

  function degToRational(d){
    d = parseFloat(d);
    if(!isFinite(d)) return null;
    const deg = Math.floor(Math.abs(d));
    const minFloat = (Math.abs(d) - deg) * 60;
    const min = Math.floor(minFloat);
    const sec = Math.round((minFloat - min) * 60 * 100);
    return [ [deg,1], [min,1], [sec,100] ];
  }

  
  async function toJpegDataURL(f){
    // Normalize any input by canvas re-encode to ensure clean JPEG for EXIF insertion
    const url=URL.createObjectURL(f); const img=new Image();
    await new Promise((res,rej)=>{ img.onload=res; img.onerror=()=>rej(new Error('Load failed')); img.src=url; });
    const c=document.createElement('canvas'); c.width=img.width; c.height=img.height; const g=c.getContext('2d'); g.drawImage(img,0,0);
    URL.revokeObjectURL(url);
    return c.toDataURL('image/jpeg', 0.92);
  }
  function fileToDataURL(f){ return new Promise((res,rej)=>{ const r=new FileReader(); r.onload=()=>res(r.result); r.onerror=rej; r.readAsDataURL(f); }); }

  // Date helpers: convert between EXIF and input[type=datetime-local]
  function pad2(n){ return String(n).padStart(2,'0'); }
  function dateToLocalInput(d){
    if(!(d instanceof Date) || isNaN(d)) return '';
    const y=d.getFullYear(), m=pad2(d.getMonth()+1), da=pad2(d.getDate());
    const hh=pad2(d.getHours()), mm=pad2(d.getMinutes()), ss=pad2(d.getSeconds());
    return `${y}-${m}-${da}T${hh}:${mm}:${ss}`;
  }
  function exifDateToLocalInput(v){
    if(!v) return '';
    if(v instanceof Date) return dateToLocalInput(v);
    if(typeof v==='string'){
      // EXIF format: YYYY:MM:DD HH:MM:SS
      const m=v.match(/^(\d{4}):(\d{2}):(\d{2}) (\d{2}):(\d{2}):(\d{2})$/);
      if(m) return `${m[1]}-${m[2]}-${m[3]}T${m[4]}:${m[5]}:${m[6]}`;
      // ISO-like already
      const m2=v.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?$/);
      if(m2) return `${m2[1]}-${m2[2]}-${m2[3]}T${m2[4]}:${m2[5]}:${m2[6]||'00'}`;
      const d=new Date(v); if(!isNaN(d)) return dateToLocalInput(d);
    }
    return '';
  }
  function localInputToExif(v){
    if(!v) return '';
    const m=v.match(/^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})(?::(\d{2}))?$/);
    if(m){ const ss=m[6]||'00'; return `${m[1]}:${m[2]}:${m[3]} ${m[4]}:${m[5]}:${ss}`; }
    const d=new Date(v); if(!isNaN(d)) return `${d.getFullYear()}:${pad2(d.getMonth()+1)}:${pad2(d.getDate())} ${pad2(d.getHours())}:${pad2(d.getMinutes())}:${pad2(d.getSeconds())}`;
    return '';
  }

  document.getElementById('read').addEventListener('click', readMeta);

  // ---- Custom tags UI ----
  const customTagsRoot = document.getElementById('customTags');
  const addTagBtn = document.getElementById('addTag');

  // Build a datalist with all known EXIF tag names to help discovery.
  const ALL_TAG_NAMES = Array.from(new Set([
    ...Object.keys(piexif.ImageIFD||{}),
    ...Object.keys(piexif.ExifIFD||{}),
    ...Object.keys(piexif.GPSIFD||{})
  ])).sort();

  const datalist = document.createElement('datalist');
  datalist.id = 'all-exif-tags';
  ALL_TAG_NAMES.forEach(n=>{ const o=document.createElement('option'); o.value=n; datalist.appendChild(o); });
  document.body.appendChild(datalist);

  function addTagRow(section='0th', tagName='', value=''){
    const row = document.createElement('div');
    row.className = 'tag-row';
    row.innerHTML = `
      <select class="tag-ifd">
        <option value="0th" ${section==='0th'?'selected':''}>0th</option>
        <option value="Exif" ${section==='Exif'?'selected':''}>Exif</option>
        <option value="GPS" ${section==='GPS'?'selected':''}>GPS</option>
      </select>
      <input class="tag-name" list="all-exif-tags" placeholder="Tag name or numeric id" value="${tagName.replace(/&/g,'&amp;').replace(/"/g,'&quot;')}">
      <input class="tag-value" placeholder="Value" value="${value.replace(/&/g,'&amp;').replace(/"/g,'&quot;')}">
      <button type="button" class="btn secondary tag-remove">Remove</button>
    `;
    row.querySelector('.tag-remove').addEventListener('click', ()=> row.remove());
    customTagsRoot.appendChild(row);
  }

  addTagBtn?.addEventListener('click', ()=> addTagRow());

  document.getElementById('apply').addEventListener('click', async ()=>{
    if(!file){ setStatus('Upload a file first'); return; }
    try{
      setStatus('Applying EXIF and generating JPEG...');
      const zeroth={}, exif={}, gps={};
      if(fields.desc.value) zeroth[piexif.ImageIFD.ImageDescription] = fields.desc.value;
      if(fields.artist.value) zeroth[piexif.ImageIFD.Artist] = fields.artist.value;
      if(fields.copyright.value) zeroth[piexif.ImageIFD.Copyright] = fields.copyright.value;
      if(fields.make.value) zeroth[piexif.ImageIFD.Make] = fields.make.value;
      if(fields.model.value) zeroth[piexif.ImageIFD.Model] = fields.model.value;
      if(fields.dto.value){
        const dto = localInputToExif(fields.dto.value);
        if(dto) exif[piexif.ExifIFD.DateTimeOriginal] = dto;
      }
      const lat = degToRational(fields.lat.value); const lng = degToRational(fields.lng.value);
      if(lat && lng){
        gps[piexif.GPSIFD.GPSLatitudeRef] = (parseFloat(fields.lat.value)>=0)? 'N':'S';
        gps[piexif.GPSIFD.GPSLatitude] = lat;
        gps[piexif.GPSIFD.GPSLongitudeRef] = (parseFloat(fields.lng.value)>=0)? 'E':'W';
        gps[piexif.GPSIFD.GPSLongitude] = lng;
      }

      // Apply custom tags
      const rows = Array.from(document.querySelectorAll('.tag-row'));
      const failed = [];
      for(const r of rows){
        const ifd = r.querySelector('.tag-ifd')?.value || '0th';
        const nameRaw = (r.querySelector('.tag-name')?.value||'').trim();
        const val = (r.querySelector('.tag-value')?.value||'');
        if(!nameRaw || val === '') continue;
        const dict = (ifd==='0th')? zeroth : (ifd==='Exif')? exif : gps;
        const map = (ifd==='0th')? (piexif.ImageIFD||{}) : (ifd==='Exif')? (piexif.ExifIFD||{}) : (piexif.GPSIFD||{});
        let tagId = null;
        if(nameRaw in map){ tagId = map[nameRaw]; }
        else if(/^\d+$/.test(nameRaw)){ tagId = parseInt(nameRaw,10); }
        if(tagId==null){ failed.push(nameRaw+" (unknown)"); continue; }
        try{
          dict[tagId] = val;
        }catch(e){ failed.push(nameRaw+" ("+e.message+")"); }
      }

      const exifObj={ '0th': zeroth, Exif: exif, GPS: gps };
      const exifBytes = piexif.dump(exifObj);
      const dataURL = await toJpegDataURL(file);
      
      let newDataURL;
      try { newDataURL = piexif.insert(exifBytes, dataURL); }
      catch(e){
        // Fallback: ensure DataURL prefix is image/jpeg
        const fixed = dataURL.replace(/^data:[^;]+;base64,/, 'data:image/jpeg;base64,');
        newDataURL = piexif.insert(exifBytes, fixed);
      }
      const a=document.createElement('a'); a.href=newDataURL; const base=(file.name||'image').replace(/\.(png|jpg|jpeg|webp)$/i,''); a.download=base+'_edited.jpg'; document.body.appendChild(a); a.click(); document.body.removeChild(a);
      setStatus('EXIF applied. Downloaded JPEG.' + (rows.length && failed.length? ' Some tags were skipped: '+failed.join(', ') : ''));
    }catch(e){ setStatus('Failed: '+e.message); }
  });

  document.getElementById('strip').addEventListener('click', async ()=>{
    if(!file){ setStatus('Upload a file first'); return; }
    try{
      setStatus('Removing metadata...');
      const url=URL.createObjectURL(file); const img=new Image(); await new Promise((res,rej)=>{ img.onload=res; img.onerror=()=>rej(new Error('Load failed')); img.src=url; });
      const c=document.createElement('canvas'); c.width=img.width; c.height=img.height; const g=c.getContext('2d'); g.drawImage(img,0,0); URL.revokeObjectURL(url);
      const out=c.toDataURL('image/jpeg', 0.92);
      const a=document.createElement('a'); a.href=out; const base=(file.name||'image').replace(/\.(png|jpg|jpeg|webp)$/i,''); a.download=base+'_stripped.jpg'; document.body.appendChild(a); a.click(); document.body.removeChild(a);
      setStatus('Metadata stripped and downloaded.');
    }catch(e){ setStatus('Failed: '+e.message); }
  });
})();
</script>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
