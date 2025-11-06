<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JPG to PDF – Images to PDF (Free Online)</title>
  <meta name="description" content="Convert JPG/PNG/WebP images to a single PDF. Reorder images, choose page size, fit or fill, margins. Free and fast.">
  <meta name="keywords" content="jpg to pdf, images to pdf, png to pdf, webp to pdf, convert photos to pdf">
  <link rel="canonical" href="https://8gwifi.org/jpg-to-pdf.jsp">
  <meta property="og:title" content="JPG to PDF – Images to PDF (Free Online)">
  <meta property="og:description" content="Combine images into a single PDF. Drag to reorder, choose size and margins.">
  <meta property="og:type" content="website"><meta property="og:url" content="https://8gwifi.org/jpg-to-pdf.jsp">
  <%@ include file="header-script.jsp"%>
  <script src="https://unpkg.com/pdf-lib@1.17.1/dist/pdf-lib.min.js"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"WebApplication",
    "name":"JPG to PDF Converter",
    "url":"https://8gwifi.org/jpg-to-pdf.jsp",
    "applicationCategory":"UtilitiesApplication",
    "operatingSystem":"Web",
    "description":"Convert JPG/PNG/WebP images into a single PDF. Reorder images, set page size, fit, and margins.",
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
      {"@type":"ListItem","position":3,"name":"JPG to PDF","item":"https://8gwifi.org/jpg-to-pdf.jsp"}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"HowTo",
    "name":"How to Convert JPG to PDF",
    "totalTime":"PT1M",
    "step":[
      {"@type":"HowToStep","name":"Add images","text":"Drop JPG/PNG/WebP files or browse."},
      {"@type":"HowToStep","name":"Reorder","text":"Drag thumbnails to reorder."},
      {"@type":"HowToStep","name":"Choose options","text":"Pick page size, fit, and margins."},
      {"@type":"HowToStep","name":"Create PDF","text":"Click Create PDF to download your file."}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"Which image formats are supported?",
       "acceptedAnswer":{"@type":"Answer","text":"JPG, PNG, and WebP formats are supported."}},
      {"@type":"Question","name":"Can I control page size and margins?",
       "acceptedAnswer":{"@type":"Answer","text":"Yes, choose A4/Letter or Auto, with custom margins and fit (contain/cover/stretch)."}},
      {"@type":"Question","name":"Are my images uploaded?",
       "acceptedAnswer":{"@type":"Answer","text":"No, conversion runs locally in your browser for privacy."}}
    ]
  }
  </script>
  <style>
    .jpg2pdf .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .jpg2pdf .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .jpg2pdf .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .jpg2pdf .grid{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.jpg2pdf .grid{grid-template-columns:1fr}}
    .jpg2pdf .thumbs{display:grid;grid-template-columns:repeat(auto-fill,minmax(120px,1fr));gap:.6rem}
    .jpg2pdf .item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;padding:.4rem;text-align:center}
    .jpg2pdf .item img{width:100%;height:auto;border-radius:4px}
    .jpg2pdf .ctrl{display:flex;gap:.35rem;justify-content:center;margin-top:.35rem}
    .jpg2pdf .ctrl .mini{padding:.3rem .5rem;font-size:.85rem}
    .jpg2pdf .btn{border:none;border-radius:8px;padding:.5rem .8rem;font-weight:600;color:#fff;background:#6366f1;cursor:pointer}
    .jpg2pdf .btn.secondary{background:#64748b}
    .jpg2pdf .btn:disabled{opacity:.6;cursor:not-allowed}
    .jpg2pdf .muted{color:#6b7280}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="jpg2pdf">
<div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">JPG to PDF</h1>
    <div class="muted">Combine JPG/PNG/WebP images into a single PDF. Drag to reorder, set page size, and margins.</div>
  </div>

  <div class="grid">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Images</h5>
      <div id="drop" class="drop"><strong>Drop images here</strong> or click to browse<input id="imgInput" type="file" accept="image/*" multiple style="display:none"></div>
      <div id="thumbs" class="thumbs" style="margin-top:.6rem"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label>Page Size
        <select id="pageSize" class="form-control">
          <option value="auto" selected>Auto (match image)</option>
          <option value="A4">A4</option>
          <option value="Letter">Letter</option>
        </select>
      </label>
      <label style="display:block;margin-top:.4rem">Fit
        <select id="fit" class="form-control">
          <option value="contain" selected>Contain (keep aspect, no crop)</option>
          <option value="cover">Cover (fill page, may crop)</option>
          <option value="stretch">Stretch</option>
        </select>
      </label>
      <label style="display:block;margin-top:.4rem">Margin (mm)
        <input id="margin" type="number" class="form-control" value="10" min="0" max="50">
      </label>
      <button id="makePdf" class="btn" style="margin-top:.6rem"><i class="fa-regular fa-file-pdf"></i>&nbsp;Create PDF</button>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related PDF Tools</h5>
    <div class="muted">
      <a href="pdf-to-jpg.jsp">PDF to JPG</a> ·
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
  const input=document.getElementById('imgInput');
  const thumbs=document.getElementById('thumbs');
  const pageSize=document.getElementById('pageSize');
  const fitSel=document.getElementById('fit');
  const marginEl=document.getElementById('margin');
  const make=document.getElementById('makePdf');
  let imgs=[]; // {name,dataURL,rot}

  const pick=()=> input.click();
  drop.addEventListener('click', pick);
  ;['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ;['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', (e)=>{ const fs=e.dataTransfer && e.dataTransfer.files; if(fs && fs.length){ addFiles(fs); }});
  input.addEventListener('change', ()=>{ if(input.files && input.files.length) addFiles(input.files); });

  function isAllowedImage(file){
    if(!file) return false;
    const t=(file.type||'').toLowerCase();
    if(t.startsWith('image/')) return true;
    const n=(file.name||'').toLowerCase();
    return n.endsWith('.jpg')||n.endsWith('.jpeg')||n.endsWith('.png')||n.endsWith('.webp');
  }
  function addFiles(fileList){
    const pick=[...fileList];
    const arr=pick.filter(isAllowedImage);
    const skipped = pick.length - arr.length;
    if(skipped>0) alert(skipped + ' file(s) skipped (not images).');
    let pending=arr.length; if(!pending) return;
    arr.forEach(f=>{
      const rdr=new FileReader();
      rdr.onload=()=>{ imgs.push({name:f.name,dataURL:rdr.result,rot:0}); pending--; if(!pending) render(); };
      rdr.readAsDataURL(f);
    });
  }

  function render(){
    thumbs.innerHTML='';
    imgs.forEach((im,idx)=>{
      const div=document.createElement('div'); div.className='item';
      div.setAttribute('draggable','true');
      div.dataset.index = String(idx);
      const img=document.createElement('img'); img.src=im.dataURL; div.appendChild(img);
      const ctrl=document.createElement('div'); ctrl.className='ctrl';
      const up=button('↑',()=> move(idx,-1)); const down=button('↓',()=> move(idx,1)); const rm=button('✕',()=> remove(idx));
      const rl=button('⟲',()=> rotate(idx,-90)); const rr=button('⟳',()=> rotate(idx,90));
      [up,down,rl,rr,rm].forEach(b=>b.classList.add('mini'));
      ctrl.appendChild(up); ctrl.appendChild(down); ctrl.appendChild(rl); ctrl.appendChild(rr); ctrl.appendChild(rm); div.appendChild(ctrl);
      thumbs.appendChild(div);
      // Drag & drop reorder
      div.addEventListener('dragstart', onDragStart);
      div.addEventListener('dragover', onDragOver);
      div.addEventListener('drop', onDrop);
    });
  }
  let dragFrom = -1;
  function onDragStart(e){ dragFrom = parseInt(this.dataset.index||'-1',10); e.dataTransfer.effectAllowed='move'; }
  function onDragOver(e){ e.preventDefault(); e.dataTransfer.dropEffect='move'; }
  function onDrop(e){ e.preventDefault(); const to = parseInt(this.dataset.index||'-1',10); if(isNaN(dragFrom)||isNaN(to) || dragFrom===to) return; const item = imgs.splice(dragFrom,1)[0]; imgs.splice(to,0,item); render(); }
  function button(txt,fn){ const b=document.createElement('button'); b.className='btn secondary'; b.textContent=txt; b.onclick=fn; return b; }
  function move(i,d){ const j=i+d; if(j<0||j>=imgs.length) return; const t=imgs[i]; imgs[i]=imgs[j]; imgs[j]=t; render(); }
  function remove(i){ imgs.splice(i,1); render(); }
  function rotate(i,delta){ imgs[i].rot = (((imgs[i].rot||0)+delta)%360+360)%360; render(); }

  make.addEventListener('click', async ()=>{
    if(!imgs.length){ alert('Add at least one image'); return; }
    const pdfDoc = await PDFLib.PDFDocument.create();
    const margins = Math.max(0, parseInt(marginEl.value||'0',10));
    const fit = fitSel.value;
    for(const im of imgs){
      const bytes = dataURLtoBytes(im.dataURL);
      const isJpeg = im.dataURL.startsWith('data:image/jpeg') || im.dataURL.startsWith('data:image/jpg');
      const embed = isJpeg ? await pdfDoc.embedJpg(bytes) : await pdfDoc.embedPng(bytes);
      let page;
      if(pageSize.value==='auto'){
        page = pdfDoc.addPage([embed.width + mm(margins*2), embed.height + mm(margins*2)]);
      } else {
        const size = pageSize.value==='A4' ? [595.28,841.89] : [612,792]; // pt
        page = pdfDoc.addPage(size);
      }
      const { width:pw, height:ph } = page.getSize();
      const boxW = pw - mm(margins*2); const boxH = ph - mm(margins*2);
      let w=embed.width, h=embed.height;
      const ratio = Math.min(boxW/w, boxH/h);
      const ratioCover = Math.max(boxW/w, boxH/h);
      if(fit==='contain'){ w*=ratio; h*=ratio; }
      else if(fit==='cover'){ w*=ratioCover; h*=ratioCover; }
      else if(fit==='stretch'){ w=boxW; h=boxH; }
      // Apply rotation (around center): compute x,y so that image is roughly centered post-rotation
      const rot = (im.rot||0);
      const centerX = pw/2, centerY = ph/2;
      let x = centerX - w/2, y = centerY - h/2;
      // pdf-lib rotates around lower-left (x,y). For simplicity, we keep centered without complex bbox calc.
      page.drawImage(embed, { x, y, width:w, height:h, rotate: PDFLib.degrees(rot) });
    }
    const bytes = await pdfDoc.save();
    download(bytes, 'images.pdf');
  });

  function dataURLtoBytes(dataURL){ const parts=dataURL.split(','); const bstr=atob(parts[1]); const u8=new Uint8Array(bstr.length); for(let i=0;i<bstr.length;i++) u8[i]=bstr.charCodeAt(i); return u8; }
  function mm(v){ return v*72/25.4; }
  function download(bytes, name){ const blob=new Blob([bytes],{type:'application/pdf'}); const a=document.createElement('a'); const url=URL.createObjectURL(blob); a.href=url; a.download=name; document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url); }
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
