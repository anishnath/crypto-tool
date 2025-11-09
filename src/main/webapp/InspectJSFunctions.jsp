<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>inspectJS Scanner – Discover Secrets in JavaScript Assets</title>
  <meta name="description" content="Discover and analyse JavaScript files for exposed secrets, endpoints and HTTP requests. Server-side scan inspired by inspectJS.">
  <meta name="keywords" content="inspectJS, javascript secrets, api key scanner, javascript recon, web recon">
  <link rel="canonical" href="https://8gwifi.org/InspectJSFunctions.jsp">
  <%@ include file="header-script.jsp"%>
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebApplication",
    "name": "inspectJS Scanner",
    "url": "https://8gwifi.org/InspectJSFunctions.jsp",
    "applicationCategory": "SecurityApplication",
    "operatingSystem": "Web",
    "description": "Crawl, discover, and analyse public JavaScript assets to surface exposed secrets, critical endpoints, and risky HTTP requests without CORS limitations.",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "keywords": [
      "inspectJS online",
      "javascript secret scanner",
      "api key leak detector",
      "security reconnaissance tool",
      "client-side secret audit"
    ],
    "creator": {
      "@type": "Organization",
      "name": "8gwifi.org",
      "url": "https://8gwifi.org"
    }
  }
  </script>
  <style>
    .inspectjs .card-header{padding:.6rem .9rem;font-weight:600}
    .inspectjs .card-body{padding:.9rem}
    .mono{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
    .badge-pill{border-radius:999px;padding:.3rem .7rem;font-size:.75rem}
    .finding-table tr td{vertical-align:top;font-size:.88rem}
    .finding-table tr td:first-child{white-space:nowrap}
    .results-section h5{display:flex;align-items:center;justify-content:space-between;gap:.5rem}
    .results-section h5 span{font-weight:400;font-size:.85rem;color:#64748b}
    .status-ok{color:#16a34a}
    .status-error{color:#dc2626}
    .loading-spinner{display:inline-block;width:1rem;height:1rem;border:2px solid #e2e8f0;border-top-color:#3b82f6;border-radius:50%;animation:spin .8s linear infinite;margin-right:.4rem}
    @keyframes spin{to{transform:rotate(360deg)}}
    .table-responsive{max-height:340px;overflow:auto}
    .chip{display:inline-flex;align-items:center;background:#e2e8f0;color:#1e293b;border-radius:999px;padding:.15rem .5rem;font-size:.75rem;margin:.1rem}
  </style>
</head>
<%@ include file="body-script.jsp"%>

<div class="container mt-4 inspectjs">
  <h1 class="mb-2">InspectJS Scanner</h1>
  <p class="text-muted mb-3">Discover JavaScript assets, surface exposed secrets, and review HTTP requests from a safe server-side workflow.</p>

  <div class="row">
    <div class="col-lg-4">
      <div class="card mb-3">
        <h5 class="card-header">Target</h5>
        <div class="card-body">
          <div class="form-group">
            <label for="targetUrl">Site URL</label>
            <input type="url" id="targetUrl" class="form-control" placeholder="https://example.com" value="">
          </div>
          <div class="form-group">
            <label for="depth">Discovery Depth (1–3)</label>
            <input type="number" min="1" max="3" step="1" id="depth" class="form-control" value="1">
          </div>
<%--          <div class="form-group">--%>
<%--            <label for="threads">Threads (1–10)</label>--%>
<%--            <input type="number" min="1" max="10" step="1" id="threads" class="form-control" value="1" disabled>--%>
<%--            <small class="form-text text-muted">Runs in single-thread mode to protect the public endpoint.</small>--%>
<%--          </div>--%>
          <div class="form-group form-check">
            <input type="checkbox" class="form-check-input" id="verifySsl">
            <label class="form-check-label" for="verifySsl">Verify SSL certificates</label>
          </div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Actions</h5>
        <div class="card-body">
          <button class="btn btn-primary btn-sm" id="btnRun">Run Scan</button>
          <button class="btn btn-secondary btn-sm" id="btnReset">Reset</button>
          <button class="btn btn-outline-secondary btn-sm" id="btnExportJson" disabled>Export JSON</button>
          <button class="btn btn-outline-secondary btn-sm" id="btnExportCsv" disabled>Export CSV</button>
          <button class="btn btn-outline-info btn-sm" id="btnShare">Share URL</button>
          <button class="btn btn-outline-info btn-sm" id="btnSaveImage">Save Snapshot</button>
          <div id="status" class="mt-2 text-muted" style="display:none"></div>
        </div>
      </div>

      <div class="card mb-3">
        <h5 class="card-header">Tool Purpose</h5>
        <div class="card-body small">
          <p class="mb-2">inspectJS fetches public pages, collects linked JavaScript, and flags API keys, secrets, high-risk endpoints, and outbound requests from a safe server-side sandbox.</p>
          <p class="mb-2 text-muted">Use it for reconnaissance, security reviews, and client-side leak audits without running custom scripts.</p>
          <p class="mb-0"><a href="sitemap.xml" rel="nofollow">sitemap.xml</a></p>
        </div>
      </div>
    </div>

    <div class="col-lg-8">
      <div class="card mb-3">
        <h5 class="card-header">Summary</h5>
        <div class="card-body">
          <div id="summary" class="text-muted">No scans yet. Provide a target URL and press <strong>Run Scan</strong>.</div>
        </div>
      </div>

      <div class="card mb-3 results-section">
        <h5 class="card-header">Discovered JavaScript <span id="discoveredCount">—</span></h5>
        <div class="card-body table-responsive" id="discoveredList"></div>
      </div>

      <div class="card mb-3 results-section">
        <h5 class="card-header">Critical Findings <span id="criticalCount">—</span></h5>
        <div class="card-body table-responsive" id="criticalList"></div>
      </div>

      <div class="card mb-3 results-section">
        <h5 class="card-header">HTTP Requests <span id="requestCount">—</span></h5>
        <div class="card-body table-responsive" id="requestList"></div>
      </div>

      <div class="card mb-3 results-section">
        <h5 class="card-header">Other Indicators <span id="otherCount">—</span></h5>
        <div class="card-body table-responsive" id="otherList"></div>
      </div>
    </div>
  </div>
</div>

<script>
(function(){
  const el = id => document.getElementById(id);
  const summaryEl = el('summary');
  const statusEl = el('status');
  const discoveredEl = el('discoveredList');
  const criticalEl = el('criticalList');
  const requestEl = el('requestList');
  const otherEl = el('otherList');

  const exportButtons = [el('btnExportJson'), el('btnExportCsv')];
  const shareButton = el('btnShare');
  const saveImageButton = el('btnSaveImage');
  const criticalCategories = ['api_keys','jwt_tokens','passwords','aws_keys','database_urls','provider_keys','private_keys','hardcoded_credentials'];
  const otherCategories = ['endpoints','emails','ip_addresses','high_entropy'];

  const HTML2CANVAS_SRC = 'https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js';
  let html2CanvasLoader = null;
  let lastReport = null;

  function setExportEnabled(enabled){
    exportButtons.forEach(btn=>{
      if(btn){
        btn.disabled = !enabled;
      }
    });
  }

  function formatCategory(cat){
    if(!cat) return '';
    return cat.replace(/_/g,' ').replace(/\b\w/g, c => c.toUpperCase());
  }

  function severityBadge(level){
    if(!level) return '';
    const lvl = String(level).toUpperCase();
    let cls = 'badge-secondary';
    if(lvl === 'CRITICAL'){
      cls = 'badge-danger';
    } else if(lvl === 'HIGH'){
      cls = 'badge-warning text-dark';
    } else if(lvl === 'MEDIUM'){
      cls = 'badge-info text-dark';
    }
    return `<span class="badge badge-pill ${cls} ml-1">${lvl}</span>`;
  }

  function resetOutputs(){
    summaryEl.innerHTML = 'No scans yet. Provide a target URL and press <strong>Run Scan</strong>.';
    discoveredEl.innerHTML = '';
    criticalEl.innerHTML = '';
    requestEl.innerHTML = '';
    otherEl.innerHTML = '';
    el('discoveredCount').textContent = '—';
    el('criticalCount').textContent = '—';
    el('requestCount').textContent = '—';
    el('otherCount').textContent = '—';
    lastReport = null;
    setExportEnabled(false);
  }

  function setStatus(text, isError){
    statusEl.style.display = 'block';
    statusEl.classList.toggle('status-error', !!isError);
    statusEl.classList.toggle('status-ok', !isError);
    statusEl.innerHTML = text;
  }

  function hideStatus(delayMs){
    setTimeout(()=>{ statusEl.style.display = 'none'; }, delayMs || 2000);
  }

  function renderSummary(report){
    if(!report || report.status !== 'ok'){
      summaryEl.innerHTML = '<span class="text-danger">Scan failed.</span>';
      return;
    }
    const s = report.summary || {};
    const riskClass = s.risk === 'HIGH' ? 'badge-danger' : s.risk === 'MEDIUM' ? 'badge-warning text-dark' : 'badge-success';
    const metaJson = JSON.stringify({
      depth: report.depth,
      threads: report.threads,
      verifySsl: report.verifySsl,
      severityScore: s.severityScore || 0,
      highSeverity: s.highSeverityFindings || 0,
      mediumSeverity: s.mediumSeverityFindings || 0,
      lowSeverity: s.lowSeverityFindings || 0
    }, null, 2);
    summaryEl.innerHTML = [
      '<div class="d-flex flex-wrap mb-2">',
      badge(`Scan ID: ${report.scanId || 'N/A'}`, 'badge-dark'),
      badge(`Risk: ${s.risk || 'N/A'}`, riskClass),
      badge(`Severity Score: ${s.severityScore || 0}`, 'badge-info text-dark'),
      badge(`High: ${s.highSeverityFindings || 0}`, 'badge-danger'),
      badge(`Medium: ${s.mediumSeverityFindings || 0}`, 'badge-warning text-dark'),
      badge(`Low: ${s.lowSeverityFindings || 0}`, 'badge-secondary'),
      badge(`HTTP Requests: ${s.httpRequests || 0}`, 'badge-info'),
      badge(`Critical Requests: ${s.criticalRequests || 0}`, 'badge-danger'),
      badge(`JS Files: ${(report.analyzedJs || []).length}`, 'badge-secondary'),
      '</div>',
      `<div class="small text-muted mb-2">Target: <code>${escapeHtml(report.target || '')}</code> · Generated: ${escapeHtml(report.generatedAt || '')} · SSL: ${report.verifySsl ? 'Enabled' : 'Disabled'} · Depth: ${escapeHtml(String(report.depth || 0))} · Threads: ${escapeHtml(String(report.threads || 0))}</div>`,
      '<pre class="mono small mb-0 bg-light p-2 rounded">',
      escapeHtml(metaJson),
      '</pre>'
    ].join('');
  }

  function badge(text, cls){
    cls = cls || 'badge-secondary';
    return `<span class="badge badge-pill ${cls} mr-2 mb-2">${escapeHtml(text)}</span>`;
  }

  function renderDiscovered(list){
    if(!list || !list.length){
      discoveredEl.innerHTML = '<span class="text-muted">No JavaScript files found.</span>';
      el('discoveredCount').textContent = '0';
      return;
    }
    const items = list.map((url, idx)=> `<div class="small mb-1"><span class="text-muted">${idx+1}.</span> <code>${escapeHtml(url)}</code></div>`).join('');
    discoveredEl.innerHTML = items;
    el('discoveredCount').textContent = list.length;
  }

  function renderCritical(findings){
    const rows = [];
    criticalCategories.forEach(cat=>{
      const items = findings[cat] || [];
      if(!items.length) return;
      const label = formatCategory(cat);
      items.slice(0,30).forEach(item=>{
        const severity = severityBadge(item.severity);
        rows.push(`<tr>
          <td><span class="badge badge-pill badge-danger">${escapeHtml(label)}</span>${severity}</td>
          <td><code class="mono">${escapeHtml(item.value||'')}</code></td>
          <td>
            <div class="small text-muted">Source: ${link(item.sourceUrl)}</div>
            ${item.context ? `<details class="small mt-1"><summary>Context</summary><pre class="mono small bg-light p-2 rounded">${escapeHtml(item.context)}</pre></details>`:''}
          </td>
        </tr>`);
      });
    });
    if(!rows.length){
      criticalEl.innerHTML = '<span class="text-muted">No critical findings detected.</span>';
      el('criticalCount').textContent = '0';
      return;
    }
    criticalEl.innerHTML = `<table class="table table-sm finding-table"><tbody>${rows.join('')}</tbody></table>`;
    el('criticalCount').textContent = rows.length;
  }

  function renderRequests(requests){
    if(!requests || !requests.length){
      requestEl.innerHTML = '<span class="text-muted">No HTTP requests found inside scripts.</span>';
      el('requestCount').textContent = '0';
      return;
    }
    const rows = requests.slice(0,50).map(req=>{
      const chips = [];
      (req.queryParams||[]).forEach(p=> chips.push(`<span class="chip">?${escapeHtml(p)}</span>`));
      (req.pathParams||[]).forEach(p=> chips.push(`<span class="chip">:${escapeHtml(p)}</span>`));
      const severity = severityBadge(req.severity);
      return `<tr>
        <td><span class="badge badge-pill ${req.critical ? 'badge-danger' : 'badge-info'}">${escapeHtml(req.type||'')}</span>${severity}</td>
        <td><strong>${escapeHtml(req.method||'GET')}</strong> ${link(req.url)}</td>
        <td>
          <div class="small text-muted">Source: ${link(req.sourceUrl)}</div>
          ${chips.length ? `<div class="mt-1">${chips.join('')}</div>`:''}
          ${req.critical && req.criticalKeyword ? `<div class="mt-1 text-danger small">Critical keyword: ${escapeHtml(req.criticalKeyword)}</div>`:''}
        </td>
      </tr>`;
    }).join('');
    requestEl.innerHTML = `<table class="table table-sm finding-table"><tbody>${rows}</tbody></table>`;
    el('requestCount').textContent = requests.length;
  }

  function renderOther(findings){
    const rows = [];
    otherCategories.forEach(cat=>{
      const items = findings[cat] || [];
      if(!items.length) return;
      const label = formatCategory(cat);
      items.slice(0,50).forEach(item=>{
        const severity = severityBadge(item.severity);
        rows.push(`<tr>
          <td><span class="badge badge-pill badge-warning text-dark">${escapeHtml(label)}</span>${severity}</td>
          <td>${item.value ? `<code>${escapeHtml(item.value)}</code>`:''}</td>
          <td><div class="small text-muted">Source: ${link(item.sourceUrl)}</div></td>
        </tr>`);
      });
    });
    if(!rows.length){
      otherEl.innerHTML = '<span class="text-muted">No additional indicators found.</span>';
      el('otherCount').textContent = '0';
      return;
    }
    otherEl.innerHTML = `<table class="table table-sm finding-table"><tbody>${rows.join('')}</tbody></table>`;
    el('otherCount').textContent = rows.length;
  }

  function escapeHtml(str){
    if(str == null) return '';
    return String(str)
      .replace(/&/g,'&amp;')
      .replace(/</g,'&lt;')
      .replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;')
      .replace(/'/g,'&#39;');
  }

  function link(url){
    if(!url) return '<span class="text-muted">N/A</span>';
    const esc = escapeHtml(url);
    return `<a href="${esc}" target="_blank" rel="noopener">${esc}</a>`;
  }

  function sanitizeFilename(str){
    return (str || 'inspectjs-report').replace(/[^a-z0-9_-]+/gi,'-');
  }

  function buildFilename(ext){
    const base = sanitizeFilename((lastReport && lastReport.scanId) || 'inspectjs-report');
    return `${base}.${ext}`;
  }

  function downloadBlob(blob, filename){
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  function exportJson(){
    if(!lastReport){
      setStatus('Run a scan before exporting.', true);
      return;
    }
    const blob = new Blob([JSON.stringify(lastReport, null, 2)], {type:'application/json;charset=utf-8'});
    downloadBlob(blob, buildFilename('json'));
    setStatus('JSON exported.', false);
    hideStatus(1500);
  }

  function exportCsv(){
    if(!lastReport || !lastReport.csvBase64){
      setStatus('CSV data not available. Run a scan first.', true);
      return;
    }
    try{
      const binary = atob(lastReport.csvBase64);
      const bytes = new Uint8Array(binary.length);
      for(let i=0;i<binary.length;i++){
        bytes[i] = binary.charCodeAt(i);
      }
      const blob = new Blob([bytes], {type:'text/csv;charset=utf-8'});
      downloadBlob(blob, buildFilename('csv'));
      setStatus('CSV exported.', false);
      hideStatus(1500);
    }catch(err){
      console.error(err);
      setStatus('Unable to decode CSV export.', true);
    }
  }

  function ensureHtml2Canvas(){
    if(typeof html2canvas !== 'undefined'){
      return Promise.resolve();
    }
    if(html2CanvasLoader){
      return html2CanvasLoader;
    }
    html2CanvasLoader = new Promise((resolve, reject)=>{
      const script = document.createElement('script');
      script.src = HTML2CANVAS_SRC;
      script.async = true;
      script.crossOrigin = 'anonymous';
      script.referrerPolicy = 'no-referrer';
      script.onload = ()=>{
        if(typeof html2canvas !== 'undefined'){
          resolve();
        }else{
          reject(new Error('html2canvas unavailable after load'));
        }
      };
      script.onerror = ()=>reject(new Error('Failed to load html2canvas from CDN'));
      document.head.appendChild(script);
    }).catch(err=>{
      html2CanvasLoader = null;
      throw err;
    });
    return html2CanvasLoader;
  }

  function shareReport(){
    const shareUrl = 'https://8gwifi.org/InspectJSFunctions.jsp';
    const text = lastReport && lastReport.target
      ? `inspectJS scan for ${lastReport.target} generated by ${shareUrl}`
      : `Run inspectJS scanner at ${shareUrl}`;
    if(navigator.share){
      navigator.share({title:'inspectJS Scanner', text, url:shareUrl})
        .then(()=>{ setStatus('Share dialog opened.', false); hideStatus(1500); })
        .catch(err=>{
          if(err){
            console.warn('Share cancelled or failed', err);
          }
        });
    }else if(navigator.clipboard && navigator.clipboard.writeText){
      navigator.clipboard.writeText(`${text}\n${shareUrl}`)
        .then(()=>{ setStatus('Share link copied to clipboard.', false); hideStatus(1500); })
        .catch(()=>{ setStatus('Unable to copy share link.', true); });
    }else{
      setStatus(`Share this link: ${escapeHtml(shareUrl)}`, false);
    }
  }

  async function saveSnapshot(){
    const targetNode = document.querySelector('.inspectjs');
    if(!targetNode){
      setStatus('Nothing to capture.', true);
      return;
    }
    setStatus('<span class="loading-spinner"></span>Rendering snapshot...', false);
    try{
      await ensureHtml2Canvas();
      if(typeof html2canvas === 'undefined'){
        throw new Error('html2canvas is not available.');
      }
      const canvas = await html2canvas(targetNode, {backgroundColor:'#ffffff', useCORS:true, scale:1});
      const ctx = canvas.getContext('2d');
      const text = '@ https://8gwifi.org/InspectJSFunctions.jsp';
      ctx.fillStyle = 'rgba(0,0,0,0.6)';
      ctx.fillRect(0, canvas.height - 32, canvas.width, 32);
      ctx.fillStyle = '#ffffff';
      ctx.font = '16px sans-serif';
      ctx.fillText(text, 12, canvas.height - 10);
      canvas.toBlob(blob=>{
        if(blob){
          downloadBlob(blob, buildFilename('png'));
          setStatus('Snapshot saved.', false);
          hideStatus(1500);
        }else{
          setStatus('Unable to create snapshot image.', true);
        }
      }, 'image/png');
    }catch(err){
      console.error(err);
      setStatus(`Snapshot failed: ${escapeHtml(err && err.message ? err.message : err)}`, true);
    }
  }

  async function runScan(){
    const target = el('targetUrl').value.trim();
    if(!target){
      setStatus('Please provide a target URL.', true);
      return;
    }

    lastReport = null;
    setExportEnabled(false);
    setStatus('<span class="loading-spinner"></span>Scanning... please wait.', false);
    summaryEl.innerHTML = '<span class="loading-spinner"></span>Running server-side scan...';
    discoveredEl.innerHTML = '';
    criticalEl.innerHTML = '';
    requestEl.innerHTML = '';
    otherEl.innerHTML = '';

    try{
      const params = new URLSearchParams();
      params.append('url', target);
      params.append('depth', el('depth').value || '1');
      params.append('threads', el('threads').value || '1');
      if(el('verifySsl').checked) params.append('verifySsl', 'true');

      const resp = await fetch('InspectJSServlet', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'},
        body: params.toString()
      });
      const data = await resp.json();

      if(data.status !== 'ok'){
        setStatus(escapeHtml(data.message || 'Scan failed'), true);
        summaryEl.innerHTML = `<span class="text-danger">${escapeHtml(data.message||'Scan failed')}</span>`;
        setExportEnabled(false);
        return;
      }

      setStatus('Scan complete.', false);
      hideStatus(1500);

      lastReport = data;
      setExportEnabled(Boolean(data.csvBase64));

      renderSummary(data);
      renderDiscovered(data.analyzedJs || data.discoveredJs || []);
      renderCritical(data.findings || {});
      renderRequests((data.findings && data.findings.http_requests) || []);
      renderOther(data.findings || {});
    }catch(err){
      console.error(err);
      setStatus('Unexpected error: ' + escapeHtml(err.message || err), true);
      summaryEl.innerHTML = `<span class="text-danger">Unexpected error: ${escapeHtml(err.message||err)}</span>`;
      setExportEnabled(false);
    }
  }

  el('btnRun').addEventListener('click', runScan);
  el('btnReset').addEventListener('click', ()=>{
    el('targetUrl').value = '';
    el('depth').value = '1';
    el('threads').value = '1';
    el('verifySsl').checked = false;
    statusEl.style.display = 'none';
    resetOutputs();
  });
  el('btnExportJson').addEventListener('click', exportJson);
  el('btnExportCsv').addEventListener('click', exportCsv);
  if(shareButton){
    shareButton.addEventListener('click', shareReport);
  }
  if(saveImageButton){
    saveImageButton.addEventListener('click', saveSnapshot);
  }

  resetOutputs();
})();
</script>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>

