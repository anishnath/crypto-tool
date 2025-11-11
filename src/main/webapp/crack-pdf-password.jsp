<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<div lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Crack PDF Password – Upload Encrypted PDFs & Share Hints</title>
  <meta name="description" content="Submit an encrypted PDF for password recovery. Upload securely via pre-signed S3 URL, share detailed hints, and get notified once the cracking attempt begins.">
  <meta name="keywords" content="crack pdf password, recover pdf password, crack protected pdf, unlock secured pdf, pdf password removal service, pdf password recovery queue">
  <meta name="robots" content="index,follow,max-image-preview:large">
  <link rel="canonical" href="https://8gwifi.org/crack-pdf-password.jsp">
  <meta property="og:title" content="Crack PDF Password – Secure Submission Queue">
  <meta property="og:description" content="Send us your encrypted PDF, provide all the password clues you remember, and we will attempt to crack it.">
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://8gwifi.org/crack-pdf-password.jsp">
  <meta property="og:image" content="https://8gwifi.org/images/site/pdf-password-crack.png">
  <meta property="og:image:alt" content="Submit encrypted PDF for password recovery">
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Crack PDF Password – Secure Submission Queue">
  <meta name="twitter:description" content="Upload a locked PDF, share your password hints, and let 8gwifi attempt recovery while you wait for updates.">
  <meta name="twitter:image" content="https://8gwifi.org/images/site/pdf-password-crack.png">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"WebApplication",
    "name":"Crack PDF Password",
    "url":"https://8gwifi.org/crack-pdf-password.jsp",
    "operatingSystem":"Web",
    "applicationCategory":"SecurityApplication",
    "description":"Queue your encrypted PDF for password recovery by uploading securely and sharing detailed hints.",
    "offers":{"@type":"Offer","price":"0","priceCurrency":"USD"}
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"Service",
    "name":"PDF Password Recovery Service",
    "serviceType":"Document Decryption",
    "provider":{
      "@type":"Organization",
      "name":"8gwifi.org",
      "url":"https://8gwifi.org"
    },
    "areaServed":{
      "@type":"Country",
      "name":"Worldwide"
    },
    "audience":{"@type":"Audience","audienceType":"Individuals and Businesses"},
    "description":"Queue encrypted PDFs for password cracking. Provide hints, receive status updates, and get notified when the password is recovered.",
    "offers":{"@type":"Offer","priceCurrency":"USD","price":"0"},
    "termsOfService":"https://8gwifi.org/terms.jsp"
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"BreadcrumbList",
    "itemListElement":[
      {"@type":"ListItem","position":1,"name":"Home","item":"https://8gwifi.org/"},
      {"@type":"ListItem","position":2,"name":"PDF Tools","item":"https://8gwifi.org/merge-pdf.jsp"},
      {"@type":"ListItem","position":3,"name":"Crack PDF Password","item":"https://8gwifi.org/crack-pdf-password.jsp"}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"HowTo",
    "name":"How to Submit a PDF for Password Cracking",
    "totalTime":"PT2M",
    "step":[
      {"@type":"HowToStep","name":"Upload PDF","text":"Choose the encrypted PDF you want us to unlock."},
      {"@type":"HowToStep","name":"Share Password Hints","text":"Tell us everything you remember about the password (keywords, numbers, patterns)."},
      {"@type":"HowToStep","name":"Confirm Submission","text":"Provide a valid email and submit to join the cracking queue."},
      {"@type":"HowToStep","name":"Wait for Updates","text":"We email you confirmation and reach back once we have results."}
    ]
  }
  </script>
  <script type="application/ld+json">
  {
    "@context":"https://schema.org",
    "@type":"FAQPage",
    "mainEntity":[
      {"@type":"Question","name":"How do you handle my encrypted PDF?",
       "acceptedAnswer":{"@type":"Answer","text":"We store your encrypted PDF in a private S3 bucket using a short-lived pre-signed upload URL and only use it for cracking attempts."}},
      {"@type":"Question","name":"Do you guarantee the password will be found?",
       "acceptedAnswer":{"@type":"Answer","text":"Unfortunately not. We do our best effort using the hints you provide. If we succeed, we notify you immediately."}},
      {"@type":"Question","name":"What hints should I add?",
       "acceptedAnswer":{"@type":"Answer","text":"Include possible words, numbers, special characters, patterns, or personal info that might be part of the password. The more details, the better."}}
    ]
  }
  </script>
  <style>
    .pdf-crack .wrap{max-width:1100px;margin:1rem auto;padding:0 1rem}
    .pdf-crack .panel{background:#fff;border-radius:12px;box-shadow:0 6px 18px rgba(15,23,42,.08);padding:1.25rem;margin-bottom:1rem}
    .pdf-crack .hero h1{margin:0 0 .4rem;font-size:2rem}
    .pdf-crack .hero .muted{color:#475569}
    .pdf-crack .grid{display:grid;grid-template-columns:1.15fr .85fr;gap:1.25rem}
    @media(max-width:992px){.pdf-crack .grid{grid-template-columns:1fr}}
    .pdf-crack .drop{border:2px dashed #93c5fd;border-radius:12px;text-align:center;color:#1d4ed8;padding:1.5rem;cursor:pointer;background:#eff6ff;transition:all .2s ease}
    .pdf-crack .drop strong{display:block;font-size:1.1rem;margin-bottom:.35rem}
    .pdf-crack .drop.drag{background:#dbeafe;border-color:#2563eb;color:#1e3a8a}
    .pdf-crack .summary{color:#475569;font-size:.95rem;margin-top:.75rem;line-height:1.5}
    .pdf-crack .summary strong{display:block;font-size:1.05rem;color:#0f172a}
    .pdf-crack .summary .flag{display:inline-flex;align-items:center;gap:.35rem;background:#1d4ed8;color:#fff;font-weight:600;border-radius:999px;padding:.15rem .65rem;font-size:.8rem;margin-top:.45rem}
    .pdf-crack .summary .flag:before{content:"🔒";font-size:.95rem;line-height:1}
    .pdf-crack .summary .muted-note{display:block;margin-top:.5rem;color:#64748b;font-size:.9rem}
    .pdf-crack label{font-weight:600;color:#1e293b;margin-bottom:.35rem;display:block}
    .pdf-crack .form-control{width:100%;border-radius:8px;border:1px solid #cbd5f5;padding:.55rem .6rem}
    .pdf-crack .form-control:focus{outline:none;border-color:#3b82f6;box-shadow:0 0 0 3px rgba(59,130,246,.15)}
    .pdf-crack .btn{display:inline-flex;align-items:center;justify-content:center;border:none;border-radius:10px;padding:.65rem 1.2rem;font-weight:600;cursor:pointer}
    .pdf-crack .btn.primary{background:#1d4ed8;color:#fff}
    .pdf-crack .btn.secondary{background:#e2e8f0;color:#1f2937}
    .pdf-crack .hint-item{margin-bottom:.75rem}
    .pdf-crack .hint-item textarea{min-height:70px;resize:vertical}
    .pdf-crack .hint-title{display:flex;align-items:center;justify-content:space-between;margin-bottom:.35rem}
    .pdf-crack .hint-title span{font-weight:600;color:#1f2937}
    .pdf-crack .hint-title button{background:none;border:none;color:#ef4444;font-weight:600;cursor:pointer}
    .pdf-crack .progress{height:16px;background:#e2e8f0;border-radius:999px;overflow:hidden;margin-top:.75rem;display:none}
    .pdf-crack .progress span{display:block;height:100%;width:0;background:linear-gradient(90deg,#2563eb,#60a5fa);transition:width .2s}
    .pdf-crack .status{margin-top:.9rem;padding:.75rem;border-radius:10px;font-weight:500;display:none}
    .pdf-crack .status.error{background:#fee2e2;color:#991b1b}
    .pdf-crack .status.success{background:#dcfce7;color:#166534}
    .pdf-crack .faq-list{margin:0;padding-left:1.1rem}
    .pdf-crack .faq-list li{margin-bottom:.4rem;color:#475569}
    .pdf-crack .badge{background:#1d4ed8;color:#fff;border-radius:999px;padding:.1rem .5rem;font-size:.75rem;margin-left:.5rem}
    .pdf-crack .panel.confirmation{background:linear-gradient(135deg,#ecfdf5,#e0f2fe);border:1px solid rgba(37,99,235,.08);text-align:center;padding:2rem 1.5rem}
    .pdf-crack .panel.confirmation h2{margin:.5rem 0;font-size:1.75rem;color:#0f172a}
    .pdf-crack .panel.confirmation .confirmation-lead{color:#1f2937;font-size:1rem;margin-bottom:1.25rem}
    .pdf-crack .confirmation-icon{width:72px;height:72px;margin:0 auto;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:2rem;background:#1d4ed8;color:#fff;box-shadow:0 10px 30px rgba(29,78,216,.25)}
    .pdf-crack .confirmation-card{border-radius:12px;background:#fff;padding:1rem 1.25rem;box-shadow:0 4px 18px rgba(15,23,42,.12);display:inline-block;margin-bottom:1.5rem;text-align:left;min-width:260px}
    .pdf-crack .confirmation-label{font-size:.8rem;text-transform:uppercase;letter-spacing:.08em;color:#64748b;margin-bottom:.4rem;font-weight:600}
    .pdf-crack .confirmation-value{font-size:1.25rem;font-weight:700;color:#0f172a}
    .pdf-crack .confirmation-next{text-align:left;max-width:540px;margin:0 auto 1.5rem}
    .pdf-crack .confirmation-next h3{margin:0 0 .5rem;color:#0f172a;font-size:1.1rem}
    .pdf-crack .confirmation-next ul{margin:0;padding-left:1.2rem;color:#1f2937}
    .pdf-crack .btn.secondary.outline{background:transparent;border:2px solid #1d4ed8;color:#1d4ed8;padding:.55rem 1.4rem}
    .pdf-crack .btn.secondary.outline:hover{background:rgba(29,78,216,.08)}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="pdf-crack">
  <div class="wrap">
    <div class="panel hero">
      <h1>Crack PDF Password</h1>
      <div class="muted">Upload your encrypted PDF safely, share every password clue you recall, and we’ll queue it for a dedicated cracking attempt.</div>
    </div>

    <div id="confirmationPanel" class="panel confirmation" style="display:none">
      <div class="confirmation-icon" aria-hidden="true">✔</div>
      <h2>Submission Received</h2>
      <p class="confirmation-lead">Your encrypted PDF is now in the cracking queue. Sit tight—we will contact you as soon as we have findings.</p>
      <div class="confirmation-card">
        <div class="confirmation-label">Reference ID</div>
        <div class="confirmation-value" id="confirmationReference"></div>
      </div>
      <div class="confirmation-next">
        <h3>What happens next?</h3>
        <ul>
          <li>You will receive a confirmation email within a few minutes. Reply to it anytime with extra clues.</li>
          <li>Our analysts prioritise jobs using the hints you supplied; richer hints mean faster results.</li>
          <li>We notify you immediately when we break through—or if we need more information.</li>
        </ul>
      </div>
      <button type="button" class="btn secondary outline" id="submitAnother">Submit Another PDF</button>
    </div>

    <div class="grid" id="uploadGrid">
      <div class="panel">
        <label for="pdfFile">Encrypted PDF</label>
        <div id="drop" class="drop">
          <strong>Drop PDF here</strong>
          <span>or click to browse from your device</span>
          <input id="pdfFile" type="file" accept="application/pdf" style="display:none">
        </div>
        <div id="fileSummary" class="summary" style="display:none"></div>
        <div class="progress" id="uploadProgress"><span id="uploadProgressBar"></span></div>
      </div>
      <div class="panel">
        <form id="crackForm" novalidate>
          <div class="form-group">
            <label for="email">Contact Email <span class="badge">Required</span></label>
            <input id="email" type="email" class="form-control" placeholder="name@example.com" autocomplete="email" required>
            <small style="color:#64748b">We only email you updates about this request.</small>
          </div>
          <hr style="margin:1rem 0;border-color:#f1f5f9">
          <div class="form-group">
            <div class="hint-title">
              <span>Password Hints</span>
              <button type="button" id="addHint">+ Add Hint</button>
            </div>
            <div id="hintsContainer"></div>
            <small style="color:#64748b;display:block;margin-top:.35rem">Examples: known words, numbers, years, special characters, length, casing, patterns, reused passwords, anything personal it might contain.</small>
          </div>
          <button type="submit" class="btn primary" id="submitButton">
            <span id="submitLabel">Submit &amp; Join Queue</span>
            <span id="submitSpinner" style="display:none;margin-left:.5rem">...</span>
          </button>
          <div id="statusMessage" class="status"></div>
        </form>
      </div>
    </div>

    <div class="panel">
      <h2 style="margin-top:0">What Happens Next?</h2>
      <ul class="faq-list">
        <li><strong>Secure Upload:</strong> Your PDF travels directly to an isolated S3 bucket using an expiring pre-signed URL.</li>
        <li><strong>Manual Review:</strong> We evaluate your hints and prioritize cracking strategies accordingly.</li>
        <li><strong>Stay in Loop:</strong> We confirm the queue entry instantly and contact you when we have results.</li>
        <li><strong>No Guaranteed Success:</strong> PDF password cracking is best-effort, but every hint increases the odds.</li>
      </ul>
    </div>

    <div class="panel">
      <h2 style="margin-top:0">Why Trust 8gwifi.org for PDF Password Recovery?</h2>
      <p>8gwifi.org has handled millions of secure crypto operations online. Our PDF password cracking queue is purpose-built for high-volume, real-world use cases—whether you need to unlock archived invoices, legal documents, encrypted ebooks, or corporate handbooks.</p>
      <ul>
        <li><strong>Security-first uploads:</strong> Files travel directly from your browser to Amazon S3 through expiring pre-signed URLs—no middle services.</li>
        <li><strong>Context-rich hints:</strong> We transform your clues into targeted password attack plans to minimise brute-force time.</li>
        <li><strong>Global availability:</strong> Submit jobs from any region, receive confirmations instantly, and monitor updates via email.</li>
        <li><strong>Transparent workflow:</strong> No hidden charges, no surprise downloads—just a clear queue and honest updates.</li>
      </ul>
      <p>Need a PDF-related utility after recovery? Explore our <a href="pdf-to-jpg.jsp">PDF to JPG</a>, <a href="pdf-password.jsp">PDF password manager</a>, or <a href="merge-pdf.jsp">merge PDF</a> tools to keep your documents portable and secure.</p>
    </div>

    <div class="panel">
      <h2 style="margin-top:0">Popular PDF Unlock Scenarios We See Daily</h2>
      <p>Incoming submissions often revolve around forgotten administrator passwords, inherited business files, or compliance audits. Here are some of the most common requests:</p>
      <ul>
        <li>Employees departing with locked HR policies or payroll reports.</li>
        <li>Archived tax filings that must be unencrypted for audits within a strict deadline.</li>
        <li>PDF ebooks and course materials protected with outdated credentials.</li>
        <li>Design agencies recovering customer agreements to support renewals.</li>
      </ul>
      <p>Whatever your scenario, submit as many relevant hints as possible—favourite phrases, years, product names, special symbols. Strong context increases our chances of cracking the PDF swiftly.</p>
    </div>
  </div>
</div>

<script>
(function(){
  const drop = document.getElementById('drop');
  const fileInput = document.getElementById('pdfFile');
  const fileSummary = document.getElementById('fileSummary');
  const form = document.getElementById('crackForm');
  const emailInput = document.getElementById('email');
  const hintsContainer = document.getElementById('hintsContainer');
  const addHintButton = document.getElementById('addHint');
  const statusMessage = document.getElementById('statusMessage');
  const submitButton = document.getElementById('submitButton');
  const submitSpinner = document.getElementById('submitSpinner');
  const submitLabel = document.getElementById('submitLabel');
  const uploadProgress = document.getElementById('uploadProgress');
  const uploadProgressBar = document.getElementById('uploadProgressBar');
  const uploadGrid = document.getElementById('uploadGrid');
  const confirmationPanel = document.getElementById('confirmationPanel');
  const confirmationReference = document.getElementById('confirmationReference');
  const submitAnother = document.getElementById('submitAnother');
  const MAX_FILE_SIZE = 100 * 1024 * 1024; // 100 MB
  let selectedFile = null;
  let objectKey = null;
  let encryptionStatus = 'unknown';

  function escapeHtml(text){
    if (!text) return '';
    return text.replace(/&/g,'&amp;')
               .replace(/</g,'&lt;')
               .replace(/>/g,'&gt;')
               .replace(/"/g,'&quot;')
               .replace(/'/g,'&#39;');
  }

  function formatFileSize(bytes){
    return (bytes/1024/1024).toFixed(2);
  }

  function renderEncryptedSummary(file, previewAvailable){
    if (!fileSummary) return;
    const name = escapeHtml(file.name || 'encrypted.pdf');
    const size = formatFileSize(file.size || 0);
    let html = '<strong>' + name + '</strong> • ' + size + ' MB';
    html += '<span class="flag">Password protection detected</span>';
    if (previewAvailable) {
      html += '<span class="muted-note">Preview generated from metadata only. The original content remains locked.</span>';
    } else {
      html += '<span class="muted-note">Preview unavailable because this PDF is encrypted. That is expected.</span>';
    }
    fileSummary.innerHTML = html;
    fileSummary.style.display = 'block';
  }

  function clearSummary(){
    if (!fileSummary) return;
    fileSummary.style.display = 'none';
    fileSummary.textContent = '';
  }

  function createHintField(value){
    const wrapper = document.createElement('div');
    wrapper.className = 'hint-item';
    const textarea = document.createElement('textarea');
    textarea.className = 'form-control';
    textarea.placeholder = 'Add a password clue (e.g. "Includes my daughter\'s birth year 2014")';
    textarea.value = value || '';
    wrapper.appendChild(textarea);
    return wrapper;
  }

  function ensureInitialHints(){
    if (hintsContainer.children.length === 0) {
      ['Possible keywords or phrases','Numbers or patterns (dates, lucky numbers)','Symbols, casing, length expectations'].forEach(function(placeholder){
        const item = createHintField('');
        item.querySelector('textarea').placeholder = placeholder;
        hintsContainer.appendChild(item);
      });
    }
  }

  ensureInitialHints();

  function resetStatus(){
    statusMessage.style.display = 'none';
    statusMessage.textContent = '';
    statusMessage.classList.remove('error','success');
  }

  function setStatus(type, message){
    statusMessage.textContent = message;
    statusMessage.classList.remove('error','success');
    statusMessage.classList.add(type === 'error' ? 'error' : 'success');
    statusMessage.style.display = 'block';
  }

  function disableForm(disabled){
    submitButton.disabled = disabled;
    submitSpinner.style.display = disabled ? 'inline-block' : 'none';
    submitLabel.textContent = disabled ? 'Submitting...' : 'Submit & Join Queue';
  }

  async function readHeader(file){
    return new Promise(function(resolve){
      try {
        const slice = file.slice(0,5);
        const reader = new FileReader();
        reader.onload = function(){
          const buffer = new Uint8Array(reader.result || new ArrayBuffer(0));
          const isPdf = buffer.length >= 4 && buffer[0] === 0x25 && buffer[1] === 0x50 && buffer[2] === 0x44 && buffer[3] === 0x46;
          resolve(isPdf);
        };
        reader.onerror = function(){ resolve(false); };
        reader.readAsArrayBuffer(slice);
      } catch(e){
        resolve(false);
      }
    });
  }

  function isValidEmail(email){
    if (!email) { return false; }
    var normalized = email.trim();
    if (emailInput && emailInput.value !== normalized) {
      emailInput.value = normalized;
    }
    if (emailInput && typeof emailInput.checkValidity === 'function' && emailInput.checkValidity()) {
      return true;
    }
    var pattern = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return pattern.test(normalized);
  }

  function detectPdfEncryption(arrayBuffer){
    try {
      const bytes = new Uint8Array(arrayBuffer || []);
      if (!bytes.length) {
        return false;
      }
      const decoder = new TextDecoder('latin1');
      const CHUNK = Math.min(bytes.length, 1024 * 1024);
      const segments = [];
      segments.push(decoder.decode(bytes.subarray(0, CHUNK)));
      if (bytes.length > CHUNK) {
        const tailStart = bytes.length - CHUNK;
        segments.push(decoder.decode(bytes.subarray(tailStart)));
      }
      return segments.some(function(segment){
        if (!segment) return false;
        const hasEncrypt = /\/Encrypt\b/i.test(segment);
        const hasStandardFilter = /\/Filter\s*\/(Standard|Adobe\.PPKLite)/i.test(segment);
        return hasEncrypt && hasStandardFilter;
      });
    } catch (e) {
      return false;
    }
  }

  async function handleFile(file){
    if (!file) return;
    resetStatus();
    encryptionStatus = 'unknown';
    objectKey = null;
    clearSummary();

    if ((file.type || '').toLowerCase() !== 'application/pdf' && !file.name.toLowerCase().endsWith('.pdf')){
      setStatus('error','Please choose a PDF file.');
      return;
    }

    if (!(await readHeader(file))){
      setStatus('error','The file does not appear to be a valid PDF.');
      return;
    }

    if (file.size > MAX_FILE_SIZE){
      setStatus('error','File exceeds 100 MB limit.');
      return;
    }

    let arrayBuffer;
    try {
      arrayBuffer = await file.arrayBuffer();
    } catch (e) {
      setStatus('error','Unable to read the file in your browser.');
      return;
    }

    const encrypted = detectPdfEncryption(arrayBuffer);

    if (!encrypted){
      selectedFile = null;
      encryptionStatus = 'not_encrypted';
      setStatus('error','This PDF is not password protected. Please upload an encrypted PDF that requires a password.');
      return;
    }

    encryptionStatus = 'encrypted';
    selectedFile = file;
    renderEncryptedSummary(file, false);
    setStatus('success','Password protection detected. Share as many password hints as possible before submitting.');
  }

  drop.addEventListener('click', function(){ fileInput.click(); });
  ['dragenter','dragover'].forEach(function(evt){
    drop.addEventListener(evt, function(e){
      e.preventDefault();
      drop.classList.add('drag');
    });
  });
  ['dragleave','drop'].forEach(function(evt){
    drop.addEventListener(evt, function(e){
      e.preventDefault();
      drop.classList.remove('drag');
    });
  });
  drop.addEventListener('drop', function(e){
    const files = e.dataTransfer && e.dataTransfer.files;
    if (files && files[0]) { handleFile(files[0]); }
  });
  fileInput.addEventListener('change', function(){
    if (fileInput.files && fileInput.files[0]) { handleFile(fileInput.files[0]); }
  });

  addHintButton.addEventListener('click', function(){
    if (hintsContainer.children.length >= 10){
      setStatus('error','You can add up to 10 hints. Please consolidate the details.');
      return;
    }
    hintsContainer.appendChild(createHintField(''));
  });

  if (submitAnother) {
    submitAnother.addEventListener('click', function(){
      if (confirmationPanel) confirmationPanel.style.display = 'none';
      if (uploadGrid) uploadGrid.style.display = 'grid';
      resetStatus();
      form.reset();
      selectedFile = null;
      objectKey = null;
      encryptionStatus = 'unknown';
      if (fileSummary) {
        fileSummary.style.display = 'none';
        fileSummary.textContent = '';
      }
      uploadProgress.style.display = 'none';
      uploadProgressBar.style.width = '0%';
      hintsContainer.innerHTML = '';
      ensureInitialHints();
    });
  }

  function collectHints(){
    const hints = [];
    const inputs = hintsContainer.querySelectorAll('textarea');
    inputs.forEach(function(textarea){
      if (textarea.value && textarea.value.trim().length > 0){
        hints.push(textarea.value.trim());
      }
    });
    return hints;
  }

  async function requestPresignedUrl(file){
    const params = new URLSearchParams();
    params.append('action','presign');
    params.append('fileName', file.name);
    params.append('contentType', file.type || 'application/pdf');
    params.append('fileSize', String(file.size));

    const response = await fetch('pdf-password-crack', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: params.toString()
    });

    const result = await response.json();
    if (!response.ok){
      throw new Error(result.error || 'Failed to reserve upload slot.');
    }
    return result;
  }

  function uploadFileToS3(url, file){
    return new Promise(function(resolve, reject){
      const xhr = new XMLHttpRequest();
      xhr.open('PUT', url);
      xhr.setRequestHeader('Content-Type', file.type || 'application/pdf');
      if (file && file.name) {
        const truncated = file.name.length > 200 ? file.name.substring(0,200) : file.name;
        xhr.setRequestHeader('x-amz-meta-original-filename', truncated);
      }
      uploadProgress.style.display = 'block';
      uploadProgressBar.style.width = '0%';

      xhr.upload.onprogress = function(event){
        if (event.lengthComputable){
          const percent = Math.round((event.loaded / event.total) * 100);
          uploadProgressBar.style.width = percent + '%';
        }
      };

      xhr.onload = function(){
        if (xhr.status >= 200 && xhr.status < 300){
          uploadProgressBar.style.width = '100%';
          resolve();
        } else {
          reject(new Error('Upload failed with status ' + xhr.status));
        }
      };

      xhr.onerror = function(){
        reject(new Error('Upload failed due to a network error.'));
      };

      xhr.send(file);
    });
  }

  async function submitMetadata(email, hints, objectKey, originalFileName, fileSize){
    const params = new URLSearchParams();
    params.append('action','submit');
    params.append('email', email);
    params.append('hints', hints.join('\\n'));
    params.append('objectKey', objectKey);
    params.append('originalFileName', originalFileName);
    params.append('fileSize', String(fileSize || 0));

    const response = await fetch('pdf-password-crack', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: params.toString()
    });
    const result = await response.json();
    if (!response.ok){
      throw new Error(result.error || 'Unable to save your submission.');
    }
    return result;
  }

  form.addEventListener('submit', async function(event){
    event.preventDefault();
    resetStatus();

    if (!selectedFile){
      setStatus('error','Please upload the encrypted PDF you want us to crack.');
      return;
    }

    if (encryptionStatus !== 'encrypted'){
      setStatus('error','We could not verify password protection on this PDF. Upload a locked PDF before submitting.');
      return;
    }

    const email = emailInput.value.trim();
    if (!isValidEmail(email)){
      setStatus('error','Enter a valid email so we can contact you.');
      emailInput.focus();
      return;
    }

    const hints = collectHints();
    if (hints.length === 0){
      setStatus('error','Share at least one hint about the password – every clue helps!');
      return;
    }

    disableForm(true);

    try {
      const presignData = await requestPresignedUrl(selectedFile);
      objectKey = presignData.objectKey;
      await uploadFileToS3(presignData.presignedUrl, selectedFile);
      const submission = await submitMetadata(email, hints, objectKey, selectedFile.name, selectedFile.size);
      const reference = submission && submission.reference ? submission.reference : 'PDFQ';
      resetStatus();
      statusMessage.style.display = 'none';
      selectedFile = null;
      objectKey = null;
      if (fileSummary) {
        fileSummary.style.display = 'none';
        fileSummary.textContent = '';
      }
      uploadProgress.style.display = 'none';
      uploadProgressBar.style.width = '0%';
      hintsContainer.innerHTML = '';
      ensureInitialHints();
      form.reset();
      if (uploadGrid) uploadGrid.style.display = 'none';
      if (confirmationPanel) {
        if (confirmationReference) confirmationReference.textContent = reference;
        confirmationPanel.style.display = 'block';
        try {
          confirmationPanel.scrollIntoView({behavior:'smooth',block:'start'});
        } catch(e) {
          /* no-op */
        }
      }
    } catch (error){
      console.error(error);
      setStatus('error', error.message || 'Something went wrong. Please try again.');
    } finally {
      disableForm(false);
    }
  });
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>

