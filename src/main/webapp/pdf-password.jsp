<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Remove PDF Password (Unlock), Add/Change Password – Free Online</title>
  <meta name="description" content="Remove password from PDF (unlock), or add/change a PDF password online. Fast preview, secure server‑side encryption (AES‑128, PDFBox), no signup, free.">
  <meta name="keywords" content="remove pdf password, unlock pdf, decrypt pdf, add pdf password, protect pdf, change pdf password, encrypt pdf, pdf password remover, pdf unlock online, pdf protection">
  <link rel="canonical" href="https://8gwifi.org/pdf-password.jsp">
  <meta name="robots" content="index,follow">
  <meta property="og:title" content="Remove PDF Password (Unlock) or Add/Change – Free Online">
  <meta property="og:description" content="Unlock protected PDFs or add/change passwords. Secure, fast, free.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/pdf-password.jsp">
  <%@ include file="header-script.jsp"%>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "Remove PDF Password / Protect PDF",
    "url": "https://8gwifi.org/pdf-password.jsp",
    "applicationCategory": "UtilitiesApplication",
    "operatingSystem": "Web",
    "description": "Remove password (unlock) from PDFs or add/change protection with standard PDF encryption. Fast preview, secure processing.",
    "offers": {"@type":"Offer","price":"0","priceCurrency":"USD"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "FAQPage",
    "mainEntity": [
      {"@type":"Question","name":"How do I remove a password from a PDF?",
       "acceptedAnswer":{"@type":"Answer","text":"Upload the PDF, choose Remove, enter the current password, then click Download to get the unlocked file."}},
      {"@type":"Question","name":"Can I change the PDF password?",
       "acceptedAnswer":{"@type":"Answer","text":"Yes. Choose Change, enter the current password and a new password, then process to download the re‑encrypted PDF."}},
      {"@type":"Question","name":"Is this tool safe and private?",
       "acceptedAnswer":{"@type":"Answer","text":"Processing occurs on the server using Apache PDFBox with standard encryption. No registration required; files are returned directly for download."}},
      {"@type":"Question","name":"What encryption is used when adding a password?",
       "acceptedAnswer":{"@type":"Answer","text":"AES‑128 standard PDF encryption with owner/user password support for broad reader compatibility."}}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "HowTo",
    "name": "How to Remove a PDF Password",
    "totalTime": "PT1M",
    "step": [
      {"@type":"HowToStep","name":"Upload PDF","text":"Drag & drop or choose your protected PDF."},
      {"@type":"HowToStep","name":"Select Remove","text":"Click Remove mode."},
      {"@type":"HowToStep","name":"Enter Password","text":"Type the current PDF password; preview confirms access."},
      {"@type":"HowToStep","name":"Download","text":"Click Download to get the unlocked PDF."}
    ]
  }
  </script>
  <style>
    :root { --radius: 10px; --shadow: 0 6px 18px rgba(0,0,0,.08); --primary:#6366f1; }
    .tool .card-header{padding:.6rem .9rem;font-weight:600}
    .tool .card-body{padding:.9rem}
    .tool .form-group{margin-bottom:.7rem}
    .tool .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .tool .panel{background:#fff;border-radius:var(--radius);box-shadow:var(--shadow);padding:1rem;margin-bottom:1rem}
    .tool .drop{border:2px dashed #cbd5e1;border-radius:var(--radius);padding:1rem;text-align:center;color:#64748b;cursor:pointer;background:#f8fafc}
    .tool .drop.drag{background:#eef2ff;border-color:#818cf8;color:#4f46e5}
    .tool .muted{color:#6b7280}
    .tool .btn{display:inline-block;border:none;border-radius:8px;background:var(--primary);color:#fff;padding:.55rem 1rem;font-weight:600;cursor:pointer}
    .tool .btn:disabled{opacity:.6;cursor:not-allowed}
    .tool .btn.secondary{background:#64748b}
    /* Emphasis buttons */
    #genBtn{background:linear-gradient(135deg,#8b5cf6,#6366f1)}
    #submitBtn{background:linear-gradient(135deg,#22c55e,#16a34a); width:100%; font-size:1rem}
    /* Mode buttons with distinct colors */
    .tool .mode-group .btn{opacity:.7}
    .tool .mode-group .btn.active{opacity:1}
    #btnAdd{background:#10b981}     /* green */
    #btnRemove{background:#ef4444}  /* red */
    #btnChange{background:#3b82f6}  /* blue */
    .tool .row-2{display:grid;grid-template-columns:1fr 1fr;gap:1rem}
    @media(max-width:992px){.tool .row-2{grid-template-columns:1fr}}
    .tool .file-info{background:#eef2ff;border:1px solid #c7d2fe;border-radius:8px;padding:.6rem;margin-top:.6rem;font-size:.9rem}
    .tool .grid-2{display:grid;grid-template-columns:1fr 1fr;gap:.5rem}
    .tool .switch{display:flex;align-items:center;gap:.4rem}
    .tool .strength{height:8px;border-radius:6px;background:#e5e7eb;overflow:hidden}
    .tool .strength>span{display:block;height:100%;width:0;background:#22c55e;transition:width .25s ease}
    .tool .hint{font-size:.8rem}
    .tool .badge{display:inline-block;background:#e5e7eb;color:#374151;border-radius:999px;padding:.15rem .5rem;font-size:.75rem;font-weight:600}
    /* Preview */
    .tool .preview-wrap{display:none}
    .tool .preview-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:.6rem}
    .tool .preview-item{background:#fff;border:1px solid #e5e7eb;border-radius:8px;box-shadow:var(--shadow);padding:.4rem;text-align:center}
    .tool .preview-item canvas{width:100%;height:auto;border-radius:4px;background:#f8fafc}
    .tool .preview-label{font-size:.8rem;color:#6b7280;margin-top:.3rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 tool">
  <h1 class="mb-2">PDF Password – Add/Remove</h1>
  <p class="text-muted mb-3">Encrypt or decrypt PDFs with a friendly, guided UI. Strong password generator and inline validation included.</p>

  <div class="row-2">
    <!-- Left: File -->
    <div>
      <div class="panel">
        <h5 style="margin:0 0 .6rem 0;">1) Choose PDF</h5>
        <div id="drop" class="drop">
          <div><strong>Drop PDF here</strong> or click to browse</div>
          <div class="muted" style="font-size:.9rem;">Only .pdf files are accepted</div>
          <input type="file" id="pdfFile" name="pdfFile" accept="application/pdf" style="display:none">
        </div>
        <div id="fileInfo" class="file-info" style="display:none"></div>
        <div id="previewWrap" class="preview-wrap" style="margin-top:.7rem">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:.4rem">
            <strong>Preview</strong>
            <span class="badge" id="pageBadge"></span>
          </div>
          <div id="previewGrid" class="preview-grid"></div>
        </div>
      </div>

    </div>

    <!-- Right: Action + Passwords + Submit -->
    <div>
      <div class="panel">
        <h5 style="margin:0 0 .6rem 0;">2) Action</h5>
        <div class="grid-2" style="align-items:center">
          <div>
            <div class="muted" style="margin-bottom:.25rem">Mode</div>
            <div class="btn-group mode-group" role="group" aria-label="Mode" id="modeGroup">
              <button type="button" class="btn" id="btnAdd" aria-pressed="true">Add</button>
              <button type="button" class="btn" id="btnRemove">Remove</button>
              <button type="button" class="btn" id="btnChange">Change</button>
            </div>
            <!-- Hidden select to keep existing logic -->
            <select id="action" name="action" class="form-control" style="display:none">
              <option value="add" selected>Add password (encrypt)</option>
              <option value="remove">Remove password (decrypt)</option>
              <option value="change">Change password (re-encrypt)</option>
            </select>
          </div>
          <span class="badge" id="fileBadge" style="align-self:end;display:none">Ready</span>
        </div>
        <div class="muted hint" style="margin-top:.35rem">Protected PDFs require the current password. Choose Remove or Change to update it.</div>
        <div id="encHint" class="muted hint" style="margin-top:.4rem;display:none;color:#ef4444">Protected PDF detected — please enter the current password.</div>
      </div>

      <div class="panel">
        <h5 style="margin:0 0 .6rem 0;">3) Password</h5>
        <div class="grid-2" id="currentRow" style="display:none">
          <label>Current Password
            <div style="display:flex;gap:.4rem;align-items:center">
              <input type="password" class="form-control" id="current" placeholder="Password to open PDF">
              <button type="button" class="btn secondary" id="copyCurrent" title="Copy"><i class="fas fa-copy"></i></button>
            </div>
          </label>
          <div class="hint muted" style="align-self:end">Needed for protected PDFs</div>
        </div>
        <div class="grid-2" id="newRow">
          <label>Password
            <div style="display:flex;gap:.4rem;align-items:center">
              <input type="password" class="form-control" id="password" name="password" placeholder="Enter new password" required>
              <button type="button" class="btn secondary" id="copyPass" title="Copy"><i class="fas fa-copy"></i></button>
            </div>
          </label>
          <label class="switch" style="margin-top:1.7rem">
            <input type="checkbox" id="showPass"> Show
          </label>
        </div>

        <div class="grid-2" id="confirmRow">
          <label>Confirm Password
            <input type="password" class="form-control" id="confirm" placeholder="Re-enter password">
          </label>
          <div>
            <label>Strength</label>
            <div class="strength"><span id="meter"></span></div>
            <div class="muted hint" id="meterHint">Type a strong password or generate one.</div>
          </div>
        </div>

        <div id="genPanel" class="panel" style="padding:.6rem;margin:.7rem 0;background:#f8fafc">
          <div style="display:flex;gap:.6rem;align-items:center;flex-wrap:wrap">
            <button type="button" class="btn" id="genBtn"><i class="fa-solid fa-wand-magic-sparkles"></i>&nbsp;Generate Password</button>
            <label style="margin:0">Length <input type="number" id="len" min="8" max="64" value="16" style="width:5rem;margin-left:.35rem" class="form-control"></label>
            <label class="switch"><input type="checkbox" id="incUpper" checked> Uppercase</label>
            <label class="switch"><input type="checkbox" id="incLower" checked> Lowercase</label>
            <label class="switch"><input type="checkbox" id="incDigits" checked> Digits</label>
            <label class="switch"><input type="checkbox" id="incSymbols" checked> Symbols</label>
          </div>
        </div>

        <div id="ownerRow" class="grid-2">
          <label>Owner Password (optional)
            <input type="password" class="form-control" id="ownerPassword" name="ownerPassword" placeholder="Defaults to same as password">
          </label>
          <label class="switch" style="margin-top:1.7rem"><input type="checkbox" id="ownerSame" checked> Same as password</label>
        </div>

        <div id="err" class="text-danger" style="display:none;margin:.5rem 0 0 0"></div>

        <form id="pdfForm" method="post" action="PDFPasswordFunctionality" enctype="multipart/form-data" target="hiddenFrame" style="margin-top:.6rem">
          <input type="hidden" name="action" id="actionField" value="add">
          <input type="hidden" name="password" id="passwordField">
          <input type="hidden" name="currentPassword" id="currentPasswordField">
          <input type="hidden" name="ownerPassword" id="ownerPasswordField">
          <input type="file" id="hiddenPdf" name="pdfFile" accept="application/pdf" style="display:none">
          <button type="submit" class="btn" id="submitBtn" disabled>Protect & Download</button>
          <button type="button" class="btn secondary" id="resetBtn" style="margin-left:.4rem">Reset</button>
        </form>
        <iframe name="hiddenFrame" style="display:none"></iframe>
      </div>

      <div class="panel">
        <h5 style="margin:0 0 .6rem 0;">Notes</h5>
        <ul class="mb-0">
          <li>Encryption uses 128‑bit AES (PDF standard).</li>
          <li>Owner password can restrict actions; leave blank to reuse user password.</li>
          <li>Download starts automatically after processing.</li>
        </ul>
      </div>
    </div>
  </div>

  <div class="panel">
    <strong>Related:</strong>
    <a href="merge-pdf.jsp">Merge</a> ·
    <a href="split-pdf.jsp">Split</a> ·
    <a href="compress-pdf.jsp">Compress</a> ·
    <a href="watermark-pdf.jsp">Watermark</a>
  </div>
</div>

<!-- PDF.js for client-side preview -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
<script>try{ pdfjsLib.GlobalWorkerOptions.workerSrc='https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js'; }catch(e){ console.warn('pdf.js init warn',e); }</script>

<script>
  (function(){
    const drop = document.getElementById('drop');
    const fileInput = document.getElementById('pdfFile');
    const fileInfo = document.getElementById('fileInfo');
    const fileBadge = document.getElementById('fileBadge');
    const actionSel = document.getElementById('action');
    const btnAdd = document.getElementById('btnAdd');
    const btnRemove = document.getElementById('btnRemove');
    const btnChange = document.getElementById('btnChange');
    const actionField = document.getElementById('actionField');
    const pass = document.getElementById('password');
    const current = document.getElementById('current');
    const confirm = document.getElementById('confirm');
    const showPass = document.getElementById('showPass');
    const ownerRow = document.getElementById('ownerRow');
    const ownerSame = document.getElementById('ownerSame');
    const ownerPassword = document.getElementById('ownerPassword');
    const err = document.getElementById('err');
    const form = document.getElementById('pdfForm');
    const submitBtn = document.getElementById('submitBtn');
    const resetBtn = document.getElementById('resetBtn');
    const hiddenPdf = document.getElementById('hiddenPdf');
    const passwordField = document.getElementById('passwordField');
    const ownerPasswordField = document.getElementById('ownerPasswordField');
    const meter = document.getElementById('meter');
    const meterHint = document.getElementById('meterHint');
    const currentRow = document.getElementById('currentRow');
    const encHint = document.getElementById('encHint');

    // Generator controls
    const genBtn = document.getElementById('genBtn');
    const len = document.getElementById('len');
    const incUpper = document.getElementById('incUpper');
    const incLower = document.getElementById('incLower');
    const incDigits = document.getElementById('incDigits');
    const incSymbols = document.getElementById('incSymbols');

    // Drag & drop
    const openPicker = ()=> fileInput.click();
    drop.addEventListener('click', openPicker);
    ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.add('drag');}));
    ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,(e)=>{e.preventDefault(); drop.classList.remove('drag');}));
    drop.addEventListener('drop', (e)=>{ const f=e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0]; if(f) handleFile(f); });
    fileInput.addEventListener('change', ()=>{ if(fileInput.files && fileInput.files[0]) handleFile(fileInput.files[0]); });

    let pdfJsDoc = null;
    let encryptedDetected = false;
    let selectedFile = null;
    async function handleFile(f){
      if(f.type !== 'application/pdf' && !f.name.toLowerCase().endsWith('.pdf')){ showErr('Please choose a valid PDF'); return; }
      fileInfo.style.display='block';
      fileInfo.innerHTML = '<strong>'+escapeHtml(f.name)+'</strong><br><span class="muted">'+formatSize(f.size)+' • Modified '+new Date(f.lastModified||Date.now()).toLocaleString()+'</span>';
      hiddenPdf.files = fileInput.files; // mirror into form
      fileBadge.style.display='inline-block';
      fileBadge.textContent='Ready';
      selectedFile = f;
      // Render preview
      await renderPreview(f);
      validate();
    }

    // Preview renderer
    async function renderPreview(file){
      const wrap = document.getElementById('previewWrap');
      const grid = document.getElementById('previewGrid');
      const pageBadge = document.getElementById('pageBadge');
      grid.innerHTML = '<div class="muted">Loading preview...</div>';
      wrap.style.display='block';
      try{
        const ab = await file.arrayBuffer();
        // Try open without password first
        pdfJsDoc = await pdfjsLib.getDocument({ data: ab }).promise;
        encryptedDetected = false; encHint.style.display='none'; currentRow.style.display='none';
      }catch(err){
        // If encrypted, try use provided password if removing
        if(err && err.name === 'PasswordException'){
          encryptedDetected = true;
          encHint.style.display='block';
          currentRow.style.display='grid';
          // If the user intends to remove or change and provided current password, try again
          const curr = current.value || pass.value;
          if((actionSel.value === 'remove' || actionSel.value === 'change') && curr){
            try{
              const ab = await file.arrayBuffer();
              pdfJsDoc = await pdfjsLib.getDocument({ data: ab, password: curr }).promise;
            }catch(err2){
              // Prompt user via dialog to enter password to open
              const ok = await askPasswordAndPreview(file);
              if(!ok){
                grid.innerHTML = '<div class="muted">Cannot preview: encrypted PDF (enter correct password).</div>';
                pageBadge.textContent='Encrypted';
                return;
              }
            }
          } else {
            const ok = await askPasswordAndPreview(file);
            if(!ok){
              grid.innerHTML = '<div class="muted">Cannot preview: encrypted PDF.</div>';
              pageBadge.textContent='Encrypted';
              return;
            }
          }
        } else {
          grid.innerHTML = '<div class="muted">Preview unavailable.</div>';
          pageBadge.textContent='';
          return;
        }
      }
      await drawPreview(grid, pageBadge);
    }

    async function drawPreview(grid, pageBadge){
      const total = pdfJsDoc.numPages;
      pageBadge.textContent = total + ' page' + (total>1?'s':'');
      grid.innerHTML = '';
      const maxThumb = 6;
      const count = Math.min(total, maxThumb);
      for(let i=1;i<=count;i++){
        const page = await pdfJsDoc.getPage(i);
        const viewport = page.getViewport({ scale: 0.2 });
        const targetWidth = 140;
        const scale = targetWidth / viewport.width;
        const vp = page.getViewport({ scale });
        const canvas = document.createElement('canvas');
        canvas.width = Math.floor(vp.width);
        canvas.height = Math.floor(vp.height);
        const ctx = canvas.getContext('2d');
        await page.render({ canvasContext: ctx, viewport: vp }).promise;
        const item = document.createElement('div');
        item.className = 'preview-item';
        const label = document.createElement('div');
        label.className = 'preview-label';
        label.textContent = 'Page ' + i;
        item.appendChild(canvas);
        item.appendChild(label);
        grid.appendChild(item);
      }
      if(total > maxThumb){
        const more = document.createElement('div');
        more.className = 'muted';
        more.textContent = '+ ' + (total - maxThumb) + ' more pages';
        grid.appendChild(more);
      }
    }

    function showModal(){
      if(window.jQuery && typeof jQuery.fn.modal === 'function'){
        jQuery('#pwdModal').modal({backdrop:'static', keyboard:false, show:true});
      } else {
        document.getElementById('pwdModal').style.display='block';
      }
    }
    function hideModal(){
      if(window.jQuery && typeof jQuery.fn.modal === 'function'){
        jQuery('#pwdModal').modal('hide');
      } else {
        document.getElementById('pwdModal').style.display='none';
      }
    }

    async function askPasswordAndPreview(file){
      return new Promise((resolve)=>{
        const input = document.getElementById('modalPassword');
        const error = document.getElementById('modalError');
        input.value = '';
        error.textContent = '';
        showModal();

        const tryOpen = async ()=>{
          const pwd = input.value.trim();
          if(!pwd){ error.textContent='Please enter a password.'; return; }
          try{
            const ab = await file.arrayBuffer();
            pdfJsDoc = await pdfjsLib.getDocument({ data: ab, password: pwd }).promise;
            current.value = pwd; // reflect into current field
            hideModal();
            resolve(true);
          }catch(e){
            error.textContent='Incorrect password. Please try again.';
            input.select();
            resolve(false);
          }
        };

        document.getElementById('modalOpen').onclick = tryOpen;
        document.getElementById('modalCancel').onclick = ()=>{ hideModal(); resolve(false); };
        input.onkeydown = (ev)=>{ if(ev.key==='Enter'){ ev.preventDefault(); tryOpen(); } };
        setTimeout(()=> input.focus(), 50);
      });
    }

    // Action toggle
    function setModeButtons(mode){
      const map = { add: btnAdd, remove: btnRemove, change: btnChange };
      [btnAdd, btnRemove, btnChange].forEach(b=>{ if(!b) return; b.classList.remove('active'); b.setAttribute('aria-pressed','false'); });
      if(map[mode]){ map[mode].classList.add('active'); map[mode].setAttribute('aria-pressed','true'); }
    }
    function updateSubmitStyleAndLabel(mode){
      const labels = { add: 'Protect & Download', remove: 'Unlock & Download', change: 'Update Password & Download' };
      submitBtn.textContent = labels[mode] || 'Download';
      if(mode === 'add'){ submitBtn.style.background = 'linear-gradient(135deg,#22c55e,#16a34a)'; }
      else if(mode === 'remove'){ submitBtn.style.background = 'linear-gradient(135deg,#ef4444,#dc2626)'; }
      else if(mode === 'change'){ submitBtn.style.background = 'linear-gradient(135deg,#3b82f6,#2563eb)'; }
    }

    // Button clicks update hidden select and trigger UI changes
    if(btnAdd) btnAdd.addEventListener('click', ()=>{ actionSel.value='add'; actionSel.dispatchEvent(new Event('change')); });
    if(btnRemove) btnRemove.addEventListener('click', ()=>{ actionSel.value='remove'; actionSel.dispatchEvent(new Event('change')); });
    if(btnChange) btnChange.addEventListener('click', ()=>{ actionSel.value='change'; actionSel.dispatchEvent(new Event('change')); });

    actionSel.addEventListener('change', ()=>{
      actionField.value = actionSel.value;
      const isAdd = actionSel.value === 'add';
      const isRemove = actionSel.value === 'remove';
      const isChange = actionSel.value === 'change';
      setModeButtons(actionSel.value);
      updateSubmitStyleAndLabel(actionSel.value);
      document.getElementById('confirmRow').style.display = isAdd ? 'grid' : 'none';
      ownerRow.style.display = isAdd ? 'grid' : 'none';
      // Show/hide new password block
      const newRow = document.getElementById('newRow');
      if(newRow){ newRow.style.display = (!isRemove) ? 'grid' : 'none'; }
      // Show generator for add/change; hide for remove
      const showGen = actionSel.value !== 'remove';
      const genPanel = document.getElementById('genPanel');
      if(genPanel){ genPanel.style.display = showGen ? 'block' : 'none'; }
      // Current password row: show for remove/change or when encrypted detected
      if(currentRow){ currentRow.style.display = (isRemove || isChange || encryptedDetected) ? 'grid' : 'none'; }
      validate();
    });
    actionField.value = actionSel.value;
    // initialize generator visibility on load
    (function(){
      const genPanel = document.getElementById('genPanel');
      if(genPanel){ genPanel.style.display = (actionSel.value !== 'remove') ? 'block' : 'none'; }
      const newRow = document.getElementById('newRow');
      if(newRow){ newRow.style.display = (actionSel.value !== 'remove') ? 'grid' : 'none'; }
      if(currentRow){ const mode = actionSel.value; currentRow.style.display = (mode === 'remove' || mode === 'change' || encryptedDetected) ? 'grid' : 'none'; }
      setModeButtons(actionSel.value);
      updateSubmitStyleAndLabel(actionSel.value);
    })();

    // Show password
    showPass.addEventListener('change', ()=>{
      const type = showPass.checked ? 'text' : 'password';
      pass.type = type; confirm.type = type; ownerPassword.type = type; current.type = type;
    });

    // Owner same toggle
    ownerSame.addEventListener('change', ()=>{
      if(ownerSame.checked){ ownerPassword.value = ''; ownerPassword.disabled = true; }
      else { ownerPassword.disabled = false; }
    });
    ownerSame.dispatchEvent(new Event('change'));

    // Strength meter
    function passwordScore(s){
      let score = 0; if(!s) return 0;
      const sets = [/[a-z]/, /[A-Z]/, /\d/, /[^A-Za-z0-9]/];
      let variety = sets.reduce((a,re)=> a + (re.test(s)?1:0), 0);
      score += Math.min(4, Math.floor(s.length/4))*10; // length up to 40
      score += variety*15; // up to 60
      return Math.min(100, score);
    }
    function updateMeter(){
      const sc = passwordScore(pass.value);
      meter.style.width = sc+'%';
      meter.style.background = sc<35 ? '#ef4444' : sc<65 ? '#f59e0b' : '#22c55e';
      meterHint.textContent = sc<35? 'Weak password' : sc<65 ? 'Fair password' : 'Strong password';
    }
    pass.addEventListener('input', ()=>{ updateMeter(); validate(); });
    current.addEventListener('input', async ()=>{
      validate();
      if(encryptedDetected && selectedFile){ await renderPreview(selectedFile); }
    });
    confirm.addEventListener('input', validate);
    ownerPassword.addEventListener('input', validate);

    // Generator
    genBtn.addEventListener('click', ()=>{
      const L = clamp(parseInt(len.value,10)||16, 8, 64);
      const pools = [];
      if(incLower.checked) pools.push('abcdefghijklmnopqrstuvwxyz');
      if(incUpper.checked) pools.push('ABCDEFGHIJKLMNOPQRSTUVWXYZ');
      if(incDigits.checked) pools.push('0123456789');
      if(incSymbols.checked) pools.push('!@#$%^&*()-_=+[]{};:,.<>/?');
      if(pools.length===0){ showErr('Select at least one character set'); return; }
      const pwd = genPassword(L, pools);
      pass.value = pwd; confirm.value = pwd; updateMeter(); validate();
      showErr('Generated a strong password.', true);
    });
    function genPassword(L, pools){
      const all = pools.join('');
      const bytes = new Uint8Array(L);
      if(window.crypto && window.crypto.getRandomValues) window.crypto.getRandomValues(bytes);
      else for(let i=0;i<L;i++) bytes[i] = Math.floor(Math.random()*256);
      let out = '';
      for(let i=0;i<L;i++) out += all.charAt(bytes[i] % all.length);
      // ensure at least one from each chosen set
      for(let i=0;i<pools.length;i++){
        const idx = i % L; const set = pools[i];
        out = replaceAt(out, idx, set.charAt(bytes[i] % set.length));
      }
      return out;
    }

    // Submit handling: mirror visible fields into hidden form and submit to iframe
    form.addEventListener('submit', (e)=>{
      err.style.display='none'; err.textContent='';
      if(!validate()) { e.preventDefault(); return false; }
      const mode = actionSel.value;
      if(mode === 'remove'){
        passwordField.value = current.value || pass.value; // server expects 'password' for remove
        currentPasswordField.value = current.value || pass.value;
      } else if(mode === 'add'){
        passwordField.value = pass.value;
        currentPasswordField.value = '';
      } else { // change
        passwordField.value = pass.value; // new
        currentPasswordField.value = current.value || pass.value; // current
      }
      ownerPasswordField.value = ownerSame.checked ? '' : (ownerPassword.value||'');
    });

    resetBtn.addEventListener('click', ()=>{
      fileInput.value=''; hiddenPdf.value=''; fileInfo.style.display='none'; fileBadge.style.display='none';
      pass.value=''; confirm.value=''; ownerPassword.value=''; updateMeter();
      err.style.display='none'; err.textContent='';
      validate();
    });

    function validate(){
      const hasFile = (hiddenPdf.files && hiddenPdf.files.length>0) || (fileInput.files && fileInput.files.length>0);
      const mode = actionSel.value;
      let ok = true; let msg = '';
      if(!hasFile){ ok=false; msg='Please choose a PDF file.'; }
      else if(mode === 'remove'){
        if(!current.value.trim()){ ok=false; msg='Current password is required to remove protection.'; }
      } else if(mode === 'add'){
        if(!pass.value.trim()){ ok=false; msg='New password is required.'; }
        else if(pass.value.length < 4){ ok=false; msg='Password must be at least 4 characters.'; }
        else if(pass.value !== (confirm.value||'')){ ok=false; msg='Passwords do not match.'; }
      } else { // change
        if(!current.value.trim()){ ok=false; msg='Current password is required.'; }
        else if(!pass.value.trim()){ ok=false; msg='New password is required.'; }
        else if(pass.value.length < 4){ ok=false; msg='New password must be at least 4 characters.'; }
        else if(pass.value !== (confirm.value||'')){ ok=false; msg='New passwords do not match.'; }
      }
      if(!ok){ showErr(msg); } else { hideErr(); }
      submitBtn.disabled = !ok; return ok;
    }

    function showErr(m, success){ err.textContent=m; err.style.display='block'; err.classList.toggle('text-danger', !success); err.classList.toggle('text-success', !!success); }
    function hideErr(){ err.style.display='none'; err.textContent=''; err.classList.remove('text-success'); err.classList.add('text-danger'); }
    function clamp(v, lo, hi){ return Math.max(lo, Math.min(hi, v)); }
    function replaceAt(s, i, ch){ return s.substring(0,i)+ch+s.substring(i+1); }
    function formatSize(n){ if(n<1024) return n+' B'; if(n<1024*1024) return (n/1024).toFixed(1)+' KB'; return (n/1024/1024).toFixed(2)+' MB'; }
    function escapeHtml(s){ return (s||'').replace(/[&<>"']/g, c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[c])); }

    // Copy buttons
    function copyText(val){ if(navigator.clipboard){ navigator.clipboard.writeText(val||''); } }
    document.getElementById('copyPass').addEventListener('click', ()=> copyText(pass.value||''));
    document.getElementById('copyCurrent').addEventListener('click', ()=> copyText(current.value||''));

    // init
    updateMeter(); validate();
  })();
</script>

<!-- Password Modal -->
<div class="modal fade" id="pwdModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Enter Password to Open PDF</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="form-group">
          <label for="modalPassword">PDF Password</label>
          <input type="password" id="modalPassword" class="form-control" placeholder="Password to open the PDF">
          <div id="modalError" class="text-danger" style="margin-top:.4rem"></div>
        </div>
        <small class="text-muted">Use the correct password to preview and optionally remove/change it.</small>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn secondary" id="modalCancel" data-dismiss="modal">Cancel</button>
        <button type="button" class="btn" id="modalOpen">Open</button>
      </div>
    </div>
  </div>
  </div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
