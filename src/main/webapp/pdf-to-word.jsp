<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PDF to Word (DOCX) – Free Online Converter</title>
  <meta name="description" content="Convert PDF to Word (DOCX) online. Fast, free, and private. Extracts text per page and keeps page breaks. No signup.">
  <meta name="keywords" content="pdf to word, pdf to docx, convert pdf to word, pdf text to word, free pdf to word">
  <link rel="canonical" href="https://8gwifi.org/pdf-to-word.jsp">
  <meta property="og:title" content="PDF to Word (DOCX) – Free Online Converter">
  <meta property="og:description" content="Convert PDFs to editable Word documents online. Fast and private.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/pdf-to-word.jsp">
  <%@ include file="header-script.jsp"%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <script>pdfjsLib.GlobalWorkerOptions.workerSrc='https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';</script>
  <script src="https://unpkg.com/docx@7.1.0/build/index.js"></script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "PDF to Word (DOCX) Converter",
    "url": "https://8gwifi.org/pdf-to-word.jsp",
    "applicationCategory": "UtilitiesApplication",
    "operatingSystem": "Web",
    "description": "Convert PDF to Word (DOCX) online. Fast, free, private conversion ideal for text-based PDFs.",
    "offers": {"@type":"Offer","price":"0","priceCurrency":"USD"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "BreadcrumbList",
    "itemListElement": [
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"PDF Tools","item":"https://8gwifi.org/merge-pdf.jsp"},
      {"@type":"ListItem","position":3,"name":"PDF to Word","item":"https://8gwifi.org/pdf-to-word.jsp"}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"HowTo",
    "name":"How to Convert PDF to Word",
    "totalTime":"PT1M",
    "step":[
      {"@type":"HowToStep","name":"Upload PDF","text":"Drop your PDF or browse to select."},
      {"@type":"HowToStep","name":"Choose options","text":"Keep page breaks or add page numbers as needed."},
      {"@type":"HowToStep","name":"Convert","text":"Click Convert to DOCX to start conversion."},
      {"@type":"HowToStep","name":"Download","text":"Save the generated Word document."}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"Does it preserve formatting?",
       "acceptedAnswer":{"@type":"Answer","text":"It extracts text with page breaks. Complex layouts and tables may need manual touch‑ups."}},
      {"@type":"Question","name":"Can it convert scanned PDFs?",
       "acceptedAnswer":{"@type":"Answer","text":"Use OCR first to make text selectable, then convert to Word."}},
      {"@type":"Question","name":"Is it safe?",
       "acceptedAnswer":{"@type":"Answer","text":"Conversion runs in your browser; files are not uploaded for processing."}}
    ]
  }
  </script>
  <style>
    .pdf2word .wrap{max-width:1000px;margin:1rem auto;padding:0 1rem}
    .pdf2word .panel{background:#fff;border-radius:10px;box-shadow:0 6px 18px rgba(0,0,0,.08);padding:1rem;margin-bottom:1rem}
    .pdf2word .drop{border:2px dashed #cbd5e1;border-radius:10px;text-align:center;color:#64748b;padding:1rem;cursor:pointer;background:#f8fafc}
    .pdf2word .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .pdf2word .btn{border:none;border-radius:8px;padding:.6rem 1rem;font-weight:600;color:#fff;background:#3b82f6;cursor:pointer}
    .pdf2word .btn:disabled{opacity:.6;cursor:not-allowed}
    .pdf2word .row{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:960px){.pdf2word .row{grid-template-columns:1fr}}
    .pdf2word .muted{color:#6b7280}
    .pdf2word .badge{display:inline-block;background:#eef2ff;border:1px solid #c7d2fe;border-radius:999px;padding:.2rem .6rem;font-size:.8rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="pdf2word">
<div class="wrap">
  <div class="panel">
    <h1 style="margin:0 0 .4rem 0">PDF to Word (DOCX)</h1>
    <div class="muted">Converts PDF text into a Word document with page breaks. Best for text‑based PDFs.</div>
  </div>

  <div class="row">
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Upload PDF</h5>
      <div id="drop" class="drop">
        <div><strong>Drop PDF here</strong> or click to browse</div>
        <input type="file" id="pdfFile" accept="application/pdf" style="display:none">
      </div>
      <div id="info" class="muted" style="margin-top:.5rem;display:none"></div>
    </div>
    <div class="panel">
      <h5 style="margin:0 0 .5rem 0">Options</h5>
      <label class="muted" style="display:block;margin-bottom:.4rem"><input type="checkbox" id="keepBreaks" checked> Keep page breaks</label>
      <label class="muted" style="display:block;margin-bottom:.4rem"><input type="checkbox" id="addPageNumbers"> Add page numbers</label>
      <button id="convertBtn" class="btn" disabled><i class="fa-solid fa-file-word"></i>&nbsp;Convert to DOCX</button>
    </div>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Notes</h5>
    <ul class="muted" style="margin:0 0 0 1rem">
      <li>Works best for text‑based PDFs. Complex layouts, tables, or scans may require manual edits.</li>
      <li>For scanned PDFs, use OCR first to get selectable text.</li>
    </ul>
  </div>

  <div class="panel">
    <h5 style="margin:0 0 .5rem 0">Related PDF Tools</h5>
    <div class="muted">
      <a href="jpg-to-pdf.jsp">JPG to PDF</a> ·
      <a href="pdf-to-jpg.jsp">PDF to JPG</a> ·
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
  const fileInput=document.getElementById('pdfFile');
  const drop=document.getElementById('drop');
  const info=document.getElementById('info');
  const btn=document.getElementById('convertBtn');
  let arrayBuffer=null; let fileName='document.pdf';

  const pick=()=>fileInput.click();
  drop.addEventListener('click', pick);
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
  drop.addEventListener('drop', async (e)=>{ const f=e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]; if(f){ await handle(f);} });
  fileInput.addEventListener('change', async ()=>{ if(fileInput.files && fileInput.files[0]) await handle(fileInput.files[0]); });

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
    if(!isPdfByTypeOrExt(f) || !(await readHeader(f))){ alert('Please choose a valid PDF file'); return; }
    fileName=f.name; arrayBuffer=await f.arrayBuffer();
    info.style.display='block'; info.textContent = f.name + ' • ' + (f.size/1024/1024).toFixed(2) + ' MB';
    btn.disabled=false;
  }

  btn.addEventListener('click', async ()=>{
    if(!arrayBuffer) return;
    btn.disabled=true; btn.textContent='Converting…';
    try{
      const pdf = await pdfjsLib.getDocument({data: arrayBuffer}).promise;
      const keepBreaks = document.getElementById('keepBreaks').checked;
      const addPageNumbers = document.getElementById('addPageNumbers').checked;

      const paragraphs=[]; const total=pdf.numPages;
      for(let i=1;i<=total;i++){
        const page = await pdf.getPage(i);
        const textContent = await page.getTextContent();
        const str = textContent.items.map(it=>it.str).join(' ');
        if(addPageNumbers) paragraphs.push({type:'number', text:`Page ${i}/${total}`});
        paragraphs.push({type:'text', text: str.trim()});
        if(keepBreaks && i<total) paragraphs.push({type:'break'});
      }

      const DOCX = (window && (window.docx || window.DOCX || window.docxjs)) || null;
      if(!DOCX){ throw new Error('DOCX library not loaded. Please check your network and try again.'); }
      const { Document, Packer, Paragraph, TextRun, HeadingLevel, PageBreak } = DOCX;
      const docParas=[];
      for(const p of paragraphs){
        if(p.type==='break'){ docParas.push(new Paragraph({ children:[new PageBreak()] })); continue; }
        if(p.type==='number'){
          docParas.push(new Paragraph({ heading: HeadingLevel.HEADING_3, children:[ new TextRun({text:p.text, bold:true}) ] }));
          continue;
        }
        docParas.push(new Paragraph({ children:[ new TextRun({text:p.text}) ] }));
      }
      const doc = new Document({ sections:[{ properties:{}, children: docParas }] });
      const blob = await Packer.toBlob(doc);
      const a=document.createElement('a'); const url=URL.createObjectURL(blob);
      a.href=url; a.download = (fileName.replace(/\.pdf$/i,'') || 'document') + '.docx';
      document.body.appendChild(a); a.click(); document.body.removeChild(a); URL.revokeObjectURL(url);
    }catch(e){ alert('Conversion failed: '+ e.message); }
    btn.textContent='Convert to DOCX'; btn.disabled=false;
  });
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
