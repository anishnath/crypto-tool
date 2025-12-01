<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java KeyStore (JKS) Viewer Online – Free | 8gwifi.org</title>
    <meta name="description" content="Free online Java KeyStore (JKS), PKCS12, and JCEKS viewer. View certificates, export to PEM, import certificates, fetch remote SSL certs, security audit with expiry timeline. No installation required.">
    <meta name="keywords" content="jks viewer online, keystore viewer, java keystore, pkcs12 viewer, keytool online, certificate viewer, truststore viewer, export jks to pem, keystore manager, jks file viewer, p12 viewer, pfx viewer, jceks viewer, ssl certificate viewer, certificate expiry checker">
    <meta name="robots" content="index,follow">
    <link rel="canonical" href="https://8gwifi.org/jks.jsp">

    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebApplication",
        "name": "Java KeyStore (JKS) Viewer Online",
        "alternateName": "JKS Viewer, PKCS12 Viewer, Keystore Manager, Certificate Viewer",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "description": "Free online tool to view and manage Java KeyStore (JKS), PKCS12, and JCEKS files. View certificates, export to PEM, import certificates, fetch remote SSL certificates, security audit, and expiry timeline visualization.",
        "url": "https://8gwifi.org/jks.jsp",
        "author": {
            "@type": "Person",
            "name": "Anish Nath",
            "url": "https://8gwifi.org",
            "sameAs": [
                "https://twitter.com/anish2good",
                "https://x.com/anish2good"
            ],
            "jobTitle": "Security Engineer",
            "description": "Security engineer with expertise in cryptography, PKI, and Java security"
        },
        "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
        "featureList": [
            "View JKS, PKCS12, JCEKS keystores",
            "Export certificates to PEM format",
            "Import PEM certificates to keystore",
            "Delete aliases from keystore",
            "Download modified keystore",
            "Fetch remote SSL certificates from any URL",
            "Certificate health dashboard",
            "Security audit (weak keys, SHA-1, self-signed detection)",
            "Certificate expiry timeline visualization",
            "Auto-detect keystore type",
            "View certificate chain",
            "Parse full certificate details"
        ]
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        /* Sticky Header */
        .sticky-upload { position: sticky; top: 0; z-index: 100; background: #fff; border-bottom: 1px solid #dee2e6; padding: 15px; margin: -15px -15px 20px -15px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .upload-row { display: flex; align-items: center; gap: 15px; flex-wrap: wrap; }
        .upload-row .file-input-wrapper { flex: 1; min-width: 200px; }
        .upload-row .password-wrapper { width: 200px; }
        .keystore-badge { display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 8px 15px; border-radius: 20px; font-size: 0.9rem; }
        .keystore-badge .badge { background: rgba(255,255,255,0.2); }

        /* Health Dashboard */
        .health-dashboard { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 20px; }
        .health-card { text-align: center; padding: 20px 15px; border-radius: 12px; color: white; }
        .health-card .count { font-size: 2.5rem; font-weight: 700; line-height: 1; }
        .health-card .label { font-size: 0.85rem; opacity: 0.9; margin-top: 5px; }
        .health-valid { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); }
        .health-expiring { background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%); }
        .health-expired { background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%); }
        .health-weak { background: linear-gradient(135deg, #6c757d 0%, #495057 100%); }

        /* Timeline */
        .timeline-container { background: #f8f9fa; border-radius: 8px; padding: 15px; margin-bottom: 20px; }
        .timeline-bar { height: 30px; background: #e9ecef; border-radius: 15px; position: relative; overflow: hidden; margin: 10px 0; }
        .timeline-segment { position: absolute; height: 100%; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: white; font-weight: 500; cursor: pointer; transition: opacity 0.2s; }
        .timeline-segment:hover { opacity: 0.8; }
        .timeline-legend { display: flex; gap: 20px; font-size: 0.8rem; margin-top: 10px; }
        .timeline-legend span { display: flex; align-items: center; gap: 5px; }
        .timeline-legend .dot { width: 12px; height: 12px; border-radius: 50%; }

        /* Master-Detail Layout */
        .master-detail { display: flex; gap: 20px; min-height: 500px; }
        .master-panel { width: 350px; flex-shrink: 0; display: flex; flex-direction: column; }
        .detail-panel { flex: 1; min-width: 0; }

        /* Alias List */
        .alias-search { margin-bottom: 10px; }
        .alias-search input { border-radius: 20px; padding-left: 35px; background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236c757d' viewBox='0 0 16 16'%3E%3Cpath d='M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z'/%3E%3C/svg%3E") 12px center no-repeat; }
        .alias-list { flex: 1; overflow-y: auto; max-height: 350px; }
        .alias-item { padding: 12px; border: 1px solid #e9ecef; border-radius: 8px; margin-bottom: 8px; cursor: pointer; transition: all 0.2s; background: #fff; }
        .alias-item:hover { border-color: #007bff; box-shadow: 0 2px 8px rgba(0,123,255,0.15); }
        .alias-item.selected { border-color: #007bff; background: #f0f7ff; }
        .alias-item .alias-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px; }
        .alias-item .alias-name { font-weight: 600; display: flex; align-items: center; gap: 6px; }
        .alias-item .alias-subject { font-size: 0.8rem; color: #6c757d; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .alias-item .alias-actions { display: none; gap: 5px; margin-top: 8px; }
        .alias-item:hover .alias-actions, .alias-item.selected .alias-actions { display: flex; }
        .alias-item .btn-sm { padding: 2px 8px; font-size: 0.75rem; }

        /* Status */
        .status-valid { color: #28a745; }
        .status-expiring { color: #856404; }
        .status-expired { color: #dc3545; }
        .badge-valid { background: #d4edda; color: #155724; }
        .badge-expiring { background: #fff3cd; color: #856404; }
        .badge-expired { background: #f8d7da; color: #721c24; }

        /* Detail Panel */
        .detail-placeholder { display: flex; flex-direction: column; align-items: center; justify-content: center; height: 100%; color: #6c757d; text-align: center; padding: 40px; background: #f8f9fa; border-radius: 8px; border: 2px dashed #dee2e6; }
        .detail-content { background: #fff; border-radius: 8px; border: 1px solid #dee2e6; }
        .detail-header { padding: 15px 20px; background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; border-radius: 8px 8px 0 0; display: flex; justify-content: space-between; align-items: center; }
        .detail-header.expired { background: linear-gradient(135deg, #dc3545 0%, #e83e8c 100%); }
        .detail-header.expiring { background: linear-gradient(135deg, #ffc107 0%, #fd7e14 100%); color: #212529; }
        .detail-header h5 { margin: 0; }
        .detail-body { padding: 20px; }
        .status-banner { padding: 10px 15px; border-radius: 6px; margin-bottom: 15px; }
        .status-banner.valid { background: #d4edda; color: #155724; }
        .status-banner.expiring { background: #fff3cd; color: #856404; }
        .status-banner.expired { background: #f8d7da; color: #721c24; }

        /* Security Warnings */
        .security-warnings { background: #fff3cd; border: 1px solid #ffc107; border-radius: 6px; padding: 12px; margin-bottom: 15px; }
        .security-warnings h6 { color: #856404; margin-bottom: 8px; }
        .security-warnings ul { margin: 0; padding-left: 20px; }
        .security-warnings li { color: #856404; font-size: 0.9rem; }
        .security-ok { background: #d4edda; border-color: #28a745; }
        .security-ok h6, .security-ok li { color: #155724; }

        /* Detail Table */
        .detail-table { width: 100%; margin-bottom: 15px; }
        .detail-table td { padding: 8px 0; border-bottom: 1px solid #f0f0f0; }
        .detail-table .label { width: 130px; font-weight: 600; color: #495057; }
        .detail-table .value { word-break: break-all; }

        /* Collapsible */
        .collapsible-section { border: 1px solid #e9ecef; border-radius: 6px; margin-bottom: 10px; }
        .collapsible-header { padding: 10px 15px; background: #f8f9fa; cursor: pointer; display: flex; justify-content: space-between; font-weight: 500; }
        .collapsible-header:hover { background: #e9ecef; }
        .collapsible-body { padding: 15px; display: none; border-top: 1px solid #e9ecef; }
        .collapsible-body.open { display: block; }
        .hex-display, .pem-display { font-family: monospace; font-size: 0.75rem; background: #f8f9fa; padding: 10px; border-radius: 4px; max-height: 120px; overflow-y: auto; white-space: pre-wrap; word-break: break-all; }

        /* Modal */
        .modal-backdrop { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 1000; display: none; }
        .modal-backdrop.show { display: flex; align-items: center; justify-content: center; }
        .modal-content { background: white; border-radius: 12px; width: 90%; max-width: 600px; max-height: 90vh; overflow-y: auto; }
        .modal-header { padding: 15px 20px; border-bottom: 1px solid #dee2e6; display: flex; justify-content: space-between; align-items: center; }
        .modal-header h5 { margin: 0; }
        .modal-body { padding: 20px; }
        .modal-footer { padding: 15px 20px; border-top: 1px solid #dee2e6; display: flex; gap: 10px; justify-content: flex-end; }

        /* Remote Cert List */
        .remote-cert-item { border: 1px solid #dee2e6; border-radius: 8px; padding: 12px; margin-bottom: 10px; }
        .remote-cert-item .cert-type { font-size: 0.75rem; background: #e9ecef; padding: 2px 8px; border-radius: 10px; }

        /* Loading & Toast */
        .loading-overlay { position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgba(255,255,255,0.9); display: flex; align-items: center; justify-content: center; z-index: 10; border-radius: 8px; }
        .spinner { width: 40px; height: 40px; border: 4px solid #f3f3f3; border-top: 4px solid #007bff; border-radius: 50%; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .toast-container { position: fixed; top: 20px; right: 20px; z-index: 1050; }
        .toast { padding: 12px 20px; border-radius: 6px; margin-bottom: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); animation: slideIn 0.3s ease; }
        .toast.success { background: #28a745; color: white; }
        .toast.error { background: #dc3545; color: white; }
        @keyframes slideIn { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }

        /* Tabs */
        .feature-tabs { display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; }
        .feature-tabs .tab-btn { padding: 8px 16px; border: 1px solid #dee2e6; border-radius: 20px; background: white; cursor: pointer; font-size: 0.9rem; transition: all 0.2s; }
        .feature-tabs .tab-btn:hover { border-color: #007bff; }
        .feature-tabs .tab-btn.active { background: #007bff; color: white; border-color: #007bff; }

        @media (max-width: 768px) {
            .master-detail { flex-direction: column; }
            .master-panel { width: 100%; }
            .health-dashboard { grid-template-columns: repeat(2, 1fr); }
            .upload-row { flex-direction: column; align-items: stretch; }
            .upload-row .password-wrapper { width: 100%; }
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mb-2">Java KeyStore (JKS) Viewer Online</h1>
<p class="text-muted mb-3">View, analyze, and manage Java KeyStore files with security audit and remote certificate fetching.</p>

<noscript><div class="alert alert-danger">JavaScript is required.</div></noscript>
<div class="toast-container" id="toastContainer"></div>

<!-- Feature Tabs -->
<div class="feature-tabs">
    <button class="tab-btn active" onclick="showTab('upload', this)">Upload KeyStore</button>
    <button class="tab-btn" onclick="showTab('fetch', this)">Fetch Remote Cert</button>
    <button class="tab-btn" onclick="showTab('import', this)" id="tabImport" disabled>Import Certificate</button>
</div>

<!-- Tab: Upload -->
<div id="tabUpload" class="tab-content">
    <div class="sticky-upload" id="stickyUpload">
        <form id="uploadForm" onsubmit="return handleFormSubmit(event)">
            <div class="upload-row">
                <div class="file-input-wrapper">
                    <input type="file" class="form-control" id="upfile" name="upfile" accept=".jks,.p12,.pfx,.keystore,.jceks">
                </div>
                <div class="password-wrapper">
                    <input type="password" class="form-control" id="storepassword" name="storepassword" placeholder="Password">
                </div>
                <button type="submit" class="btn btn-primary">Upload &amp; Analyze</button>
                <div id="keystoreInfo" class="d-none">
                    <span class="keystore-badge">
                        <span id="infoFileName">-</span>
                        <span class="badge" id="infoType">JKS</span>
                        <span class="badge" id="infoCount">0</span>
                        <button type="button" class="btn btn-sm btn-light" onclick="clearKeystore()">&times;</button>
                    </span>
                </div>
            </div>
        </form>
    </div>
</div>

<!-- Tab: Fetch Remote -->
<div id="tabFetch" class="tab-content d-none">
    <div class="card mb-4">
        <div class="card-header">Fetch SSL Certificate from URL</div>
        <div class="card-body">
            <div class="form-group">
                <label>Enter URL or hostname</label>
                <div class="input-group">
                    <input type="text" class="form-control" id="remoteUrl" placeholder="https://example.com or example.com:443">
                    <div class="input-group-append">
                        <button class="btn btn-primary" onclick="fetchRemoteCert()">Fetch Certificates</button>
                    </div>
                </div>
            </div>
            <div id="remoteCertResults"></div>
        </div>
    </div>
</div>

<!-- Tab: Import -->
<div id="tabImportContent" class="tab-content d-none">
    <div class="card mb-4">
        <div class="card-header">Import Certificate to KeyStore</div>
        <div class="card-body">
            <div class="form-group">
                <label>Alias Name</label>
                <input type="text" class="form-control" id="importAlias" placeholder="my-certificate">
            </div>
            <div class="form-group">
                <label>PEM Certificate</label>
                <textarea class="form-control" id="importPem" rows="8" placeholder="-----BEGIN CERTIFICATE-----&#10;...&#10;-----END CERTIFICATE-----"></textarea>
            </div>
            <button class="btn btn-primary" onclick="importCertificate()">Import to KeyStore</button>
        </div>
    </div>
</div>

<!-- Health Dashboard (shown after upload) -->
<div id="healthDashboard" class="d-none">
    <div class="health-dashboard">
        <div class="health-card health-valid">
            <div class="count" id="healthValid">0</div>
            <div class="label">Valid</div>
        </div>
        <div class="health-card health-expiring">
            <div class="count" id="healthExpiring">0</div>
            <div class="label">Expiring Soon</div>
        </div>
        <div class="health-card health-expired">
            <div class="count" id="healthExpired">0</div>
            <div class="label">Expired</div>
        </div>
        <div class="health-card health-weak">
            <div class="count" id="healthWeak">0</div>
            <div class="label">Security Issues</div>
        </div>
    </div>

    <!-- Expiry Timeline -->
    <div class="timeline-container">
        <strong>Certificate Expiry Timeline</strong>
        <div class="timeline-bar" id="timelineBar"></div>
        <div class="timeline-legend">
            <span><span class="dot" style="background:#28a745"></span> Valid</span>
            <span><span class="dot" style="background:#ffc107"></span> Expiring (&lt;30d)</span>
            <span><span class="dot" style="background:#dc3545"></span> Expired</span>
        </div>
    </div>
</div>

<!-- Master-Detail Layout -->
<div class="master-detail" id="mainContent">
    <div class="master-panel">
        <div class="card h-100">
            <div class="card-header d-flex justify-content-between align-items-center">
                <span>Aliases <span class="badge badge-secondary" id="aliasCountBadge">0</span></span>
                <button class="btn btn-sm btn-outline-secondary" onclick="exportKeyStore()" id="btnExportJks" disabled>Export JKS</button>
            </div>
            <div class="card-body p-2">
                <div class="alias-search">
                    <input type="text" class="form-control form-control-sm" id="aliasSearch" placeholder="Search aliases..." onkeyup="filterAliases(this.value)">
                </div>
                <div class="alias-list" id="aliasList">
                    <div class="text-center text-muted py-4">
                        <div style="font-size: 2rem; opacity: 0.3;">📁</div>
                        <p class="mb-0">Upload a keystore to view aliases</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="detail-panel">
        <div id="detailPlaceholder" class="detail-placeholder">
            <div style="font-size: 3rem; opacity: 0.5;">🔐</div>
            <h5>No Certificate Selected</h5>
            <p>Upload a keystore and click on an alias to view details</p>
        </div>
        <div id="detailContent" class="detail-content d-none" style="position: relative;"></div>
    </div>
</div>

<script>
var state = { keystoreData: null, fileName: null, selectedAlias: null, aliases: [], allAliases: [] };
var API_URL = 'JKSManagementFunctionality';

function handleFormSubmit(e) { e.preventDefault(); uploadKeystore(); return false; }

function showTab(tab, clickedBtn) {
    document.querySelectorAll('.tab-content').forEach(function(el) { el.classList.add('d-none'); });
    document.querySelectorAll('.tab-btn').forEach(function(el) { el.classList.remove('active'); });
    if (tab === 'upload') { document.getElementById('tabUpload').classList.remove('d-none'); }
    else if (tab === 'fetch') { document.getElementById('tabFetch').classList.remove('d-none'); }
    else if (tab === 'import') { document.getElementById('tabImportContent').classList.remove('d-none'); }

    // Handle active class - either use passed button or find by tab name
    if (clickedBtn) {
        clickedBtn.classList.add('active');
    } else {
        var btns = document.querySelectorAll('.tab-btn');
        var idx = tab === 'upload' ? 0 : (tab === 'fetch' ? 1 : 2);
        if (btns[idx]) btns[idx].classList.add('active');
    }
}

function showToast(msg, type) {
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    toast.textContent = msg;
    document.getElementById('toastContainer').appendChild(toast);
    setTimeout(function() { toast.remove(); }, 3000);
}

function showLoading(id) {
    var el = document.getElementById(id);
    if (!el) return;
    var ov = document.createElement('div');
    ov.className = 'loading-overlay';
    ov.id = id + 'Loading';
    ov.innerHTML = '<div class="spinner"></div>';
    el.style.position = 'relative';
    el.appendChild(ov);
}
function hideLoading(id) { var ov = document.getElementById(id + 'Loading'); if (ov) ov.remove(); }

function uploadKeystore() {
    var fileInput = document.getElementById('upfile');
    var pwd = document.getElementById('storepassword').value;
    if (!fileInput.files || !fileInput.files.length) { showToast('Select a keystore file', 'error'); return; }

    var file = fileInput.files[0];
    showLoading('aliasList');

    // Read file as base64 on client side
    var reader = new FileReader();
    reader.onload = function(e) {
        var base64Data = e.target.result.split(',')[1]; // Remove data:...;base64, prefix

        // Store in client-side state
        state.keystoreData = base64Data;
        state.fileName = file.name;

        // Send to server for parsing
        var fd = new FormData();
        fd.append('keystoreData', base64Data);
        fd.append('fileName', file.name);
        fd.append('storepassword', pwd);
        fd.append('action', 'upload');

        fetch(API_URL, { method: 'POST', body: fd })
        .then(function(r) { return r.json(); })
        .then(function(d) {
            hideLoading('aliasList');
            if (!d.success) { showToast(d.error, 'error'); state.keystoreData = null; return; }

            state.aliases = d.aliases;
            state.allAliases = d.aliases;

            document.getElementById('infoFileName').textContent = file.name;
            document.getElementById('infoType').textContent = d.keystoreType;
            document.getElementById('infoCount').textContent = d.aliasCount;
            document.getElementById('keystoreInfo').classList.remove('d-none');
            document.getElementById('aliasCountBadge').textContent = d.aliasCount;
            document.getElementById('btnExportJks').disabled = false;
            document.getElementById('tabImport').disabled = false;

            renderAliasesList(d.aliases);
            loadHealthDashboard();
            showToast('Loaded ' + d.aliasCount + ' entries', 'success');

            if (d.aliases.length > 0) selectAlias(d.aliases[0].name);
        })
        .catch(function(e) { hideLoading('aliasList'); showToast('Error: ' + e.message, 'error'); });
    };
    reader.onerror = function() {
        hideLoading('aliasList');
        showToast('Error reading file', 'error');
    };
    reader.readAsDataURL(file);
}

function loadHealthDashboard() {
    var fd = new FormData();
    fd.append('action', 'getHealth');
    fd.append('keystoreData', state.keystoreData);
    fd.append('storepassword', document.getElementById('storepassword').value);

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        if (!d.success) return;
        var h = d.health;
        document.getElementById('healthValid').textContent = h.valid;
        document.getElementById('healthExpiring').textContent = h.expiring;
        document.getElementById('healthExpired').textContent = h.expired;
        document.getElementById('healthWeak').textContent = h.weak;
        document.getElementById('healthDashboard').classList.remove('d-none');
        loadTimeline();
    });
}

function loadTimeline() {
    var fd = new FormData();
    fd.append('action', 'getTimeline');
    fd.append('keystoreData', state.keystoreData);
    fd.append('storepassword', document.getElementById('storepassword').value);

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        if (!d.success) return;
        renderTimeline(d.timeline);
    });
}

function renderTimeline(timeline) {
    var bar = document.getElementById('timelineBar');
    if (!timeline || !timeline.length) { bar.innerHTML = '<div style="text-align:center;line-height:30px;color:#666">No certificates</div>'; return; }

    var now = Date.now();
    var maxDays = 365;
    var html = '';
    var width = 100 / timeline.length;

    timeline.forEach(function(t, i) {
        var days = t.daysUntilExpiry;
        var color = days < 0 ? '#dc3545' : (days < 30 ? '#ffc107' : '#28a745');
        var left = i * width;
        html += '<div class="timeline-segment" style="left:' + left + '%;width:' + width + '%;background:' + color + '" title="' + t.alias + ': ' + days + ' days" onclick="selectAlias(\'' + t.alias + '\')">' + t.alias.substring(0, 8) + '</div>';
    });
    bar.innerHTML = html;
}

function renderAliasesList(aliases) {
    var c = document.getElementById('aliasList');
    if (!aliases || !aliases.length) { c.innerHTML = '<div class="text-center text-muted py-4">No aliases</div>'; return; }

    var html = '';
    aliases.forEach(function(a) {
        var sc = a.status === 'expired' ? 'status-expired' : (a.status === 'expiring' ? 'status-expiring' : 'status-valid');
        var bc = a.status === 'expired' ? 'badge-expired' : (a.status === 'expiring' ? 'badge-expiring' : 'badge-valid');
        var icon = a.status === 'expired' ? '❌' : (a.status === 'expiring' ? '⚠️' : '✅');
        var ti = a.isKeyEntry ? '🔐' : '📜';
        var sel = state.selectedAlias === a.name;
        var days = a.daysUntilExpiry !== undefined ? (a.daysUntilExpiry < 0 ? Math.abs(a.daysUntilExpiry) + 'd ago' : a.daysUntilExpiry + 'd') : '';

        html += '<div class="alias-item ' + (sel ? 'selected' : '') + '" onclick="selectAlias(\'' + a.name + '\')" data-alias="' + a.name + '">' +
            '<div class="alias-header"><span class="alias-name">' + ti + ' ' + a.name + '</span><span class="badge ' + bc + '">' + icon + ' ' + days + '</span></div>' +
            '<div class="alias-subject">' + (a.subject || '') + '</div>' +
            '<div class="alias-actions">' +
            '<button class="btn btn-sm btn-outline-primary" onclick="event.stopPropagation();exportPEM(\'' + a.name + '\')">PEM</button>' +
            '<button class="btn btn-sm btn-outline-danger" onclick="event.stopPropagation();deleteAlias(\'' + a.name + '\')">Del</button></div></div>';
    });
    c.innerHTML = html;
}

function filterAliases(q) {
    q = q.toLowerCase();
    var f = state.allAliases.filter(function(a) { return a.name.toLowerCase().indexOf(q) !== -1 || (a.subject && a.subject.toLowerCase().indexOf(q) !== -1); });
    state.aliases = f;
    renderAliasesList(f);
}

function selectAlias(name) {
    state.selectedAlias = name;
    document.querySelectorAll('.alias-item').forEach(function(el) {
        el.classList.toggle('selected', el.getAttribute('data-alias') === name);
    });
    loadAliasDetails(name);
}

function loadAliasDetails(name) {
    var fd = new FormData();
    fd.append('action', 'getDetails');
    fd.append('keystoreData', state.keystoreData);
    fd.append('alias', name);
    fd.append('storepassword', document.getElementById('storepassword').value);

    showLoading('detailContent');
    document.getElementById('detailPlaceholder').classList.add('d-none');
    document.getElementById('detailContent').classList.remove('d-none');

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        hideLoading('detailContent');
        if (!d.success) { showToast(d.error, 'error'); return; }
        loadSecurityAnalysis(name, d.details);
    })
    .catch(function(e) { hideLoading('detailContent'); showToast(e.message, 'error'); });
}

function loadSecurityAnalysis(alias, details) {
    var fd = new FormData();
    fd.append('action', 'getSecurityAnalysis');
    fd.append('keystoreData', state.keystoreData);
    fd.append('alias', alias);
    fd.append('storepassword', document.getElementById('storepassword').value);

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        var analysis = d.success ? d.analysis : { warnings: [] };
        renderCertDetails(alias, details, analysis);
    })
    .catch(function() { renderCertDetails(alias, details, { warnings: [] }); });
}

function renderCertDetails(alias, d, analysis) {
    var c = document.getElementById('detailContent');
    var now = Date.now();
    var days = d.notAfterTimestamp ? Math.floor((d.notAfterTimestamp - now) / 86400000) : null;

    var hc = '', sc = 'valid', st = 'Valid';
    if (days !== null) {
        if (days < 0) { hc = 'expired'; sc = 'expired'; st = 'Expired ' + Math.abs(days) + 'd ago'; }
        else if (days < 30) { hc = 'expiring'; sc = 'expiring'; st = 'Expires in ' + days + 'd'; }
        else { st = days + ' days remaining'; }
    }

    var html = '<div class="detail-header ' + hc + '"><h5>' + alias + '</h5><div>' +
        '<button class="btn btn-sm btn-light mr-1" onclick="exportPEM(\'' + alias + '\')">Export</button>' +
        '<button class="btn btn-sm btn-light" onclick="deleteAlias(\'' + alias + '\')">Delete</button></div></div>';

    html += '<div class="detail-body">';
    html += '<div class="status-banner ' + sc + '"><strong>Status:</strong> ' + st + '</div>';

    // Security Warnings
    if (analysis.warnings && analysis.warnings.length > 0) {
        html += '<div class="security-warnings"><h6>⚠️ Security Warnings</h6><ul>';
        analysis.warnings.forEach(function(w) { html += '<li>' + w + '</li>'; });
        html += '</ul></div>';
    } else {
        html += '<div class="security-warnings security-ok"><h6>✅ Security Check Passed</h6><ul><li>No security issues detected</li></ul></div>';
    }

    // Key strength
    if (analysis.keySize) {
        var ks = analysis.keyStrength === 'strong' ? '✅' : '⚠️';
        html += '<div class="mb-2"><strong>Key:</strong> ' + analysis.keyAlgorithm + ' ' + analysis.keySize + '-bit ' + ks + '</div>';
    }

    html += '<table class="detail-table">' +
        '<tr><td class="label">Subject</td><td class="value">' + d.subject + '</td></tr>' +
        '<tr><td class="label">Issuer</td><td class="value">' + d.issuer + '</td></tr>' +
        '<tr><td class="label">Serial</td><td class="value">' + d.serialNumber + '</td></tr>' +
        '<tr><td class="label">Algorithm</td><td class="value">' + d.signatureAlgorithm + '</td></tr>' +
        '<tr><td class="label">Valid From</td><td class="value">' + d.notBefore + '</td></tr>' +
        '<tr><td class="label">Valid Until</td><td class="value ' + sc + '">' + d.notAfter + '</td></tr>' +
        '<tr><td class="label">Self-Signed</td><td class="value">' + (d.selfSigned ? 'Yes' : 'No') + '</td></tr>' +
        '</table>';

    if (d.pemExport) {
        html += '<div class="collapsible-section"><div class="collapsible-header" onclick="this.nextElementSibling.classList.toggle(\'open\')">PEM Certificate</div>' +
            '<div class="collapsible-body">' +
            '<button class="btn btn-sm btn-outline-primary mb-2" onclick="copyText(\'' + btoa(d.pemExport) + '\')">Copy</button> ' +
            '<button class="btn btn-sm btn-outline-info mb-2" onclick="parsePemCert(\'' + btoa(d.pemExport) + '\')">🔍 Parse Full Details</button>' +
            '<div class="pem-display">' + d.pemExport + '</div></div></div>';
    }
    html += '</div>';
    c.innerHTML = html;
}

function copyText(b64) {
    navigator.clipboard.writeText(atob(b64)).then(function() { showToast('Copied!', 'success'); });
}

function parsePemCert(b64) {
    var pem = atob(b64);
    // Store PEM in localStorage and open parser page
    localStorage.setItem('jks_pem_to_parse', pem);
    window.open('PemParserFunctions.jsp?fromJks=1', '_blank');
}

function deleteAlias(name) {
    if (!confirm('Delete "' + name + '"?')) return;
    var pwd = document.getElementById('storepassword').value;
    if (!pwd) { showToast('Password required', 'error'); return; }

    var fd = new FormData();
    fd.append('action', 'deleteAlias');
    fd.append('keystoreData', state.keystoreData);
    fd.append('alias', name);
    fd.append('storepassword', pwd);

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        if (!d.success) { showToast(d.error, 'error'); return; }
        showToast('Deleted', 'success');
        // Update client-side keystore data
        if (d.keystoreData) state.keystoreData = d.keystoreData;
        state.aliases = d.aliases;
        state.allAliases = d.aliases;
        document.getElementById('infoCount').textContent = d.aliasCount;
        document.getElementById('aliasCountBadge').textContent = d.aliasCount;
        renderAliasesList(d.aliases);
        loadHealthDashboard();
        document.getElementById('detailPlaceholder').classList.remove('d-none');
        document.getElementById('detailContent').classList.add('d-none');
        if (d.aliases.length) selectAlias(d.aliases[0].name);
    });
}

function exportPEM(name) {
    var form = document.createElement('form');
    form.method = 'POST'; form.action = API_URL;
    form.innerHTML = '<input type="hidden" name="action" value="exportPEM"><input type="hidden" name="keystoreData" value="' + state.keystoreData + '"><input type="hidden" name="alias" value="' + name + '"><input type="hidden" name="storepassword" value="' + document.getElementById('storepassword').value + '">';
    document.body.appendChild(form); form.submit(); document.body.removeChild(form);
}

function exportKeyStore() {
    var pwd = document.getElementById('storepassword').value;
    if (!pwd) { showToast('Password required', 'error'); return; }
    var form = document.createElement('form');
    form.method = 'POST'; form.action = API_URL;
    form.innerHTML = '<input type="hidden" name="action" value="exportKeyStore"><input type="hidden" name="keystoreData" value="' + state.keystoreData + '"><input type="hidden" name="storepassword" value="' + pwd + '">';
    document.body.appendChild(form); form.submit(); document.body.removeChild(form);
}

function fetchRemoteCert() {
    var url = document.getElementById('remoteUrl').value;
    if (!url) { showToast('Enter a URL', 'error'); return; }

    var results = document.getElementById('remoteCertResults');
    results.innerHTML = '<div class="text-center py-3"><div class="spinner" style="margin:auto"></div><p>Fetching certificates...</p></div>';

    var fd = new FormData();
    fd.append('action', 'fetchRemote');
    fd.append('url', url);

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        if (!d.success) { results.innerHTML = '<div class="alert alert-danger">' + d.error + '</div>'; return; }

        var html = '<div class="alert alert-success">Found ' + d.count + ' certificate(s) from ' + d.host + ':' + d.port + '</div>';
        d.certificates.forEach(function(cert, i) {
            var sc = cert.status === 'expired' ? 'status-expired' : (cert.status === 'expiring' ? 'status-expiring' : 'status-valid');
            html += '<div class="remote-cert-item">' +
                '<div class="d-flex justify-content-between align-items-center mb-2">' +
                '<strong>' + (i + 1) + '. ' + cert.subject.substring(0, 50) + '</strong>' +
                '<span class="cert-type">' + cert.type + '</span></div>' +
                '<div class="small text-muted">Issuer: ' + cert.issuer.substring(0, 50) + '</div>' +
                '<div class="small ' + sc + '">Expires: ' + cert.notAfter + ' (' + cert.daysUntilExpiry + ' days)</div>' +
                '<div class="mt-2">' +
                '<button class="btn btn-sm btn-outline-primary" onclick="copyRemotePem(' + i + ')">Copy PEM</button> ' +
                '<button class="btn btn-sm btn-outline-success" onclick="addRemoteCertToKeystore(' + i + ', this)">Add to KeyStore</button>' +
                '</div>' +
                '<textarea class="d-none" id="remotePem' + i + '">' + cert.pem + '</textarea>' +
                '<input type="hidden" id="remoteSubject' + i + '" value="' + cert.subject.replace(/"/g, '&quot;') + '">' +
                '</div>';
        });
        results.innerHTML = html;
    })
    .catch(function(e) { results.innerHTML = '<div class="alert alert-danger">Error: ' + e.message + '</div>'; });
}

function copyRemotePem(i) {
    var pem = document.getElementById('remotePem' + i).value;
    navigator.clipboard.writeText(pem).then(function() { showToast('PEM copied!', 'success'); });
}

function importRemoteCert(i) {
    var pem = document.getElementById('remotePem' + i).value;
    var alias = prompt('Enter alias name for this certificate:');
    if (!alias) return;
    document.getElementById('importAlias').value = alias;
    document.getElementById('importPem').value = pem;
    showTab('import'); // showTab now handles the active class automatically
}

function addRemoteCertToKeystore(i, btn) {
    var pem = document.getElementById('remotePem' + i).value;
    var pwd = document.getElementById('storepassword').value;
    var subjectEl = document.getElementById('remoteSubject' + i);
    var subject = subjectEl ? subjectEl.value : '';

    if (!state.keystoreData) {
        showToast('Please upload a keystore first (Upload KeyStore tab)', 'error');
        showTab('upload');
        return;
    }
    if (!pwd) {
        showToast('Password required - enter it in the Upload KeyStore tab', 'error');
        showTab('upload');
        return;
    }

    // Extract CN from subject for default alias (e.g., "CN=example.com, O=..." -> "example.com")
    var defaultAlias = 'remote-cert-' + i;
    var cnMatch = subject.match(/CN=([^,]+)/i);
    if (cnMatch) {
        defaultAlias = cnMatch[1].trim().toLowerCase().replace(/[^a-z0-9.-]/g, '-');
    }

    var alias = prompt('Enter alias name for this certificate:', defaultAlias);
    if (!alias) return;

    var fd = new FormData();
    fd.append('action', 'importCert');
    fd.append('keystoreData', state.keystoreData);
    fd.append('alias', alias);
    fd.append('pemCert', pem);
    fd.append('storepassword', pwd);

    // Show loading on the button
    var origText = btn.textContent;
    btn.textContent = 'Adding...';
    btn.disabled = true;

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        btn.textContent = origText;
        btn.disabled = false;

        if (!d.success) { showToast(d.error, 'error'); return; }

        showToast('Certificate "' + alias + '" added to keystore!', 'success');
        // Update client-side keystore data
        if (d.keystoreData) state.keystoreData = d.keystoreData;
        state.aliases = d.aliases;
        state.allAliases = d.aliases;
        document.getElementById('infoCount').textContent = d.aliasCount;
        document.getElementById('aliasCountBadge').textContent = d.aliasCount;
        renderAliasesList(d.aliases);
        loadHealthDashboard();

        // Mark this cert as added
        btn.textContent = '✓ Added';
        btn.classList.remove('btn-outline-success');
        btn.classList.add('btn-success');
        btn.disabled = true;
    })
    .catch(function(e) {
        btn.textContent = origText;
        btn.disabled = false;
        showToast('Error: ' + e.message, 'error');
    });
}

function importCertificate() {
    var alias = document.getElementById('importAlias').value;
    var pem = document.getElementById('importPem').value;
    var pwd = document.getElementById('storepassword').value;

    if (!alias || !pem) { showToast('Enter alias and PEM', 'error'); return; }
    if (!pwd) { showToast('Password required', 'error'); return; }
    if (!state.keystoreData) {
        showToast('Please upload a keystore first', 'error');
        showTab('upload');
        return;
    }

    var fd = new FormData();
    fd.append('action', 'importCert');
    fd.append('keystoreData', state.keystoreData);
    fd.append('alias', alias);
    fd.append('pemCert', pem);
    fd.append('storepassword', pwd);

    fetch(API_URL, { method: 'POST', body: fd })
    .then(function(r) { return r.json(); })
    .then(function(d) {
        if (!d.success) { showToast(d.error, 'error'); return; }
        showToast(d.message, 'success');
        // Update client-side keystore data
        if (d.keystoreData) state.keystoreData = d.keystoreData;
        state.aliases = d.aliases;
        state.allAliases = d.aliases;
        document.getElementById('infoCount').textContent = d.aliasCount;
        document.getElementById('aliasCountBadge').textContent = d.aliasCount;
        renderAliasesList(d.aliases);
        loadHealthDashboard();
        document.getElementById('importAlias').value = '';
        document.getElementById('importPem').value = '';
        showTab('upload');
        selectAlias(alias);
    });
}

function clearKeystore() {
    state = { keystoreData: null, fileName: null, selectedAlias: null, aliases: [], allAliases: [] };
    document.getElementById('upfile').value = '';
    document.getElementById('keystoreInfo').classList.add('d-none');
    document.getElementById('healthDashboard').classList.add('d-none');
    document.getElementById('aliasCountBadge').textContent = '0';
    document.getElementById('btnExportJks').disabled = true;
    document.getElementById('tabImport').disabled = true;
    document.getElementById('aliasList').innerHTML = '<div class="text-center text-muted py-4"><div style="font-size:2rem;opacity:0.3">📁</div><p class="mb-0">Upload a keystore</p></div>';
    document.getElementById('detailPlaceholder').classList.remove('d-none');
    document.getElementById('detailContent').classList.add('d-none');
}

// Drag & drop
var uz = document.getElementById('stickyUpload');
['dragenter','dragover','dragleave','drop'].forEach(function(e){uz.addEventListener(e,function(ev){ev.preventDefault();ev.stopPropagation();});});
['dragenter','dragover'].forEach(function(e){uz.addEventListener(e,function(){uz.style.background='#e8f4ff';});});
['dragleave','drop'].forEach(function(e){uz.addEventListener(e,function(){uz.style.background='#fff';});});
uz.addEventListener('drop',function(e){document.getElementById('upfile').files=e.dataTransfer.files;uploadKeystore();});
</script>

<hr class="mt-5">
<%@ include file="thanks.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>

<!-- Features Section -->
<section class="mt-5">
    <h2>Features</h2>
    <div class="row">
        <div class="col-md-4 mb-3">
            <div class="card h-100">
                <div class="card-body">
                    <h5>View & Manage</h5>
                    <ul class="mb-0">
                        <li>View JKS, PKCS12, JCEKS files</li>
                        <li>Auto-detect keystore type</li>
                        <li>View certificate details</li>
                        <li>Delete aliases</li>
                        <li>Export modified keystore</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card h-100">
                <div class="card-body">
                    <h5>Import & Export</h5>
                    <ul class="mb-0">
                        <li>Export certificates to PEM</li>
                        <li>Import PEM certificates</li>
                        <li>Fetch remote SSL certificates</li>
                        <li>Add fetched certs to keystore</li>
                        <li>Parse full certificate details</li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card h-100">
                <div class="card-body">
                    <h5>Security & Monitoring</h5>
                    <ul class="mb-0">
                        <li>Certificate health dashboard</li>
                        <li>Expiry timeline visualization</li>
                        <li>Weak key detection (&lt;2048 bit)</li>
                        <li>SHA-1 signature warnings</li>
                        <li>Self-signed certificate detection</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Java Keytool Commands -->
<section class="mt-5">
    <h2>Java Keytool Commands Reference</h2>
    <div class="row">
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header"><strong>Generate Keys & Certificates</strong></div>
                <div class="card-body">
                    <pre><code># Generate a new key pair and self-signed certificate
keytool -genkeypair -alias mydomain -keyalg RSA -keysize 2048 \
  -validity 365 -keystore keystore.jks

# Generate with specific DN
keytool -genkeypair -alias server -keyalg RSA -keysize 2048 \
  -dname "CN=example.com,O=MyOrg,L=City,ST=State,C=US" \
  -keystore keystore.jks

# Generate EC key pair
keytool -genkeypair -alias eckey -keyalg EC -keysize 256 \
  -keystore keystore.jks</code></pre>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header"><strong>Import Certificates</strong></div>
                <div class="card-body">
                    <pre><code># Import a trusted CA certificate
keytool -importcert -trustcacerts -alias rootca \
  -file ca-cert.pem -keystore keystore.jks

# Import a certificate chain
keytool -importcert -alias myserver -file server.crt \
  -keystore keystore.jks

# Import PKCS12 into JKS
keytool -importkeystore -srckeystore cert.p12 \
  -srcstoretype PKCS12 -destkeystore keystore.jks</code></pre>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header"><strong>Generate CSR</strong></div>
                <div class="card-body">
                    <pre><code># Generate Certificate Signing Request
keytool -certreq -alias mydomain -keystore keystore.jks \
  -file mydomain.csr

# Generate CSR with SAN (Subject Alternative Names)
keytool -certreq -alias mydomain -keystore keystore.jks \
  -ext san=dns:www.example.com,dns:example.com \
  -file mydomain.csr</code></pre>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header"><strong>View & List</strong></div>
                <div class="card-body">
                    <pre><code># List all entries in keystore
keytool -list -keystore keystore.jks

# List with verbose details
keytool -list -v -keystore keystore.jks

# List specific alias
keytool -list -v -alias mydomain -keystore keystore.jks

# Print certificate in RFC format
keytool -list -rfc -alias mydomain -keystore keystore.jks</code></pre>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header"><strong>Export Certificates</strong></div>
                <div class="card-body">
                    <pre><code># Export certificate to file (DER format)
keytool -exportcert -alias mydomain -keystore keystore.jks \
  -file cert.der

# Export certificate in PEM format
keytool -exportcert -alias mydomain -keystore keystore.jks \
  -rfc -file cert.pem

# Convert JKS to PKCS12
keytool -importkeystore -srckeystore keystore.jks \
  -destkeystore keystore.p12 -deststoretype PKCS12</code></pre>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header"><strong>Delete & Modify</strong></div>
                <div class="card-body">
                    <pre><code># Delete an alias
keytool -delete -alias oldcert -keystore keystore.jks

# Change alias name
keytool -changealias -alias oldname -destalias newname \
  -keystore keystore.jks

# Change keystore password
keytool -storepasswd -keystore keystore.jks

# Change key password
keytool -keypasswd -alias mydomain -keystore keystore.jks</code></pre>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- OpenSSL Commands -->
<section class="mt-5">
    <h2>OpenSSL Commands for Keystore Operations</h2>
    <div class="row">
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header"><strong>View & Convert</strong></div>
                <div class="card-body">
                    <pre><code># View PKCS12 contents
openssl pkcs12 -info -in keystore.p12

# Extract certificate from PKCS12
openssl pkcs12 -in keystore.p12 -clcerts -nokeys \
  -out cert.pem

# Extract private key from PKCS12
openssl pkcs12 -in keystore.p12 -nocerts -nodes \
  -out key.pem

# Extract CA certificates
openssl pkcs12 -in keystore.p12 -cacerts -nokeys \
  -out ca-certs.pem</code></pre>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header"><strong>Create PKCS12</strong></div>
                <div class="card-body">
                    <pre><code># Create PKCS12 from cert and key
openssl pkcs12 -export -in cert.pem -inkey key.pem \
  -out keystore.p12 -name "myalias"

# Include CA chain
openssl pkcs12 -export -in cert.pem -inkey key.pem \
  -certfile ca-chain.pem -out keystore.p12

# Create with legacy encryption (Java compatibility)
openssl pkcs12 -export -in cert.pem -inkey key.pem \
  -out keystore.p12 -legacy</code></pre>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card mb-3">
                <div class="card-header"><strong>Certificate Operations</strong></div>
                <div class="card-body">
                    <pre><code># View certificate details
openssl x509 -in cert.pem -text -noout

# Check certificate expiry
openssl x509 -in cert.pem -noout -dates

# Verify certificate chain
openssl verify -CAfile ca-chain.pem cert.pem

# Get certificate from server
openssl s_client -connect example.com:443 \
  -showcerts </dev/null 2>/dev/null | \
  openssl x509 -outform PEM > server.pem</code></pre>
                </div>
            </div>
            <div class="card mb-3">
                <div class="card-header"><strong>Convert Formats</strong></div>
                <div class="card-body">
                    <pre><code># DER to PEM
openssl x509 -inform DER -in cert.der \
  -outform PEM -out cert.pem

# PEM to DER
openssl x509 -inform PEM -in cert.pem \
  -outform DER -out cert.der

# Convert PKCS7 to PEM
openssl pkcs7 -print_certs -in cert.p7b \
  -out cert.pem

# Extract public key from certificate
openssl x509 -in cert.pem -pubkey -noout > pubkey.pem</code></pre>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- FAQ Section -->
<section class="mt-5">
    <h2>Frequently Asked Questions</h2>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq1">What is a Java KeyStore (JKS)?</button></div>
        <div id="faq1" class="collapse"><div class="card-body">
            A Java KeyStore (JKS) is a repository for cryptographic keys and certificates. It's commonly used to store:
            <ul>
                <li><strong>Private keys</strong> - Used for SSL/TLS server authentication</li>
                <li><strong>Public key certificates</strong> - X.509 certificates</li>
                <li><strong>Trusted CA certificates</strong> - For certificate chain validation</li>
            </ul>
            JKS files are protected by a password and use proprietary Java format. The default keystore type changed to PKCS12 in Java 9.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq2">What's the difference between JKS, PKCS12, and JCEKS?</button></div>
        <div id="faq2" class="collapse"><div class="card-body">
            <table class="table table-sm">
                <thead><tr><th>Format</th><th>Extension</th><th>Description</th></tr></thead>
                <tbody>
                    <tr><td><strong>JKS</strong></td><td>.jks, .keystore</td><td>Java-proprietary format. Uses weak encryption (SHA1). Not recommended for new projects.</td></tr>
                    <tr><td><strong>PKCS12</strong></td><td>.p12, .pfx</td><td>Industry standard, cross-platform. Supports stronger encryption. Default since Java 9.</td></tr>
                    <tr><td><strong>JCEKS</strong></td><td>.jceks</td><td>Java Cryptography Extension KeyStore. Stronger encryption than JKS, but still Java-proprietary.</td></tr>
                </tbody>
            </table>
            <strong>Recommendation:</strong> Use PKCS12 for new projects for better compatibility and security.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq3">How do I convert JKS to PKCS12?</button></div>
        <div id="faq3" class="collapse"><div class="card-body">
            Use the keytool command to convert:
            <pre><code>keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.p12 -deststoretype PKCS12</code></pre>
            You'll be prompted for both the source and destination keystore passwords.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq4">How do I view the contents of a keystore?</button></div>
        <div id="faq4" class="collapse"><div class="card-body">
            <strong>Using keytool:</strong>
            <pre><code>keytool -list -v -keystore keystore.jks</code></pre>
            <strong>Using this online tool:</strong> Simply upload your keystore file and enter the password. The tool will display all aliases, certificates, and their details including expiry dates and security information.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq5">What is a truststore vs keystore?</button></div>
        <div id="faq5" class="collapse"><div class="card-body">
            Both are technically the same file format, but they serve different purposes:
            <ul>
                <li><strong>Keystore:</strong> Contains your private keys and certificates. Used for server authentication (proving your identity).</li>
                <li><strong>Truststore:</strong> Contains trusted CA certificates. Used to verify certificates from others (validating their identity).</li>
            </ul>
            In Java, the default truststore is <code>$JAVA_HOME/lib/security/cacerts</code> with default password "changeit".
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq6">How do I add a certificate to Java's truststore?</button></div>
        <div id="faq6" class="collapse"><div class="card-body">
            <pre><code>keytool -importcert -trustcacerts -alias myca \
  -file ca-cert.pem \
  -keystore $JAVA_HOME/lib/security/cacerts \
  -storepass changeit</code></pre>
            <strong>Note:</strong> You may need administrator/root privileges to modify the system cacerts file.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq7">How do I check certificate expiry dates?</button></div>
        <div id="faq7" class="collapse"><div class="card-body">
            <strong>Using keytool:</strong>
            <pre><code>keytool -list -v -keystore keystore.jks | grep -A2 "Valid from"</code></pre>
            <strong>Using OpenSSL:</strong>
            <pre><code>openssl x509 -in cert.pem -noout -dates</code></pre>
            <strong>Using this tool:</strong> Upload your keystore to see the health dashboard with expiring/expired certificate counts and a visual expiry timeline.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq8">What key size should I use?</button></div>
        <div id="faq8" class="collapse"><div class="card-body">
            <strong>Recommended minimum key sizes (2024):</strong>
            <ul>
                <li><strong>RSA:</strong> 2048 bits minimum, 4096 bits for high security</li>
                <li><strong>ECDSA:</strong> 256 bits (P-256 curve) or 384 bits (P-384)</li>
                <li><strong>DSA:</strong> 2048 bits (deprecated, prefer RSA or ECDSA)</li>
            </ul>
            This tool's security audit will warn you about keys smaller than 2048 bits.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq9">Is it safe to upload my keystore to this tool?</button></div>
        <div id="faq9" class="collapse"><div class="card-body">
            <strong>Privacy considerations:</strong>
            <ul>
                <li>Your keystore is processed client-side in your browser</li>
                <li>The keystore data is stored in browser memory, not on our servers</li>
                <li>All operations happen locally with AJAX calls</li>
                <li>No keystore data is persisted after you close the page</li>
            </ul>
            <strong>Best practice:</strong> For production keystores containing private keys, consider using offline tools like keytool or OpenSSL.
        </div></div>
    </div>

    <div class="card mb-2">
        <div class="card-header"><button class="btn btn-link" data-toggle="collapse" data-target="#faq10">How do I fetch SSL certificates from a website?</button></div>
        <div id="faq10" class="collapse"><div class="card-body">
            <strong>Using this tool:</strong> Go to "Fetch Remote Cert" tab, enter the URL (e.g., google.com), and click "Fetch Certificates". You can then copy the PEM or add it directly to your keystore.
            <br><br>
            <strong>Using OpenSSL:</strong>
            <pre><code>openssl s_client -connect example.com:443 -showcerts </dev/null 2>/dev/null | \
  openssl x509 -outform PEM > cert.pem</code></pre>
        </div></div>
    </div>
</section>

<!-- Author / EEAT Section -->
<section class="mt-5">
    <div class="card">
        <div class="card-body">
            <div class="d-flex align-items-center">
                <div class="mr-3">
                    <div style="width:60px;height:60px;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);border-radius:50%;display:flex;align-items:center;justify-content:center;color:white;font-size:1.5rem;font-weight:bold;">AN</div>
                </div>
                <div>
                    <h5 class="mb-1">Created by Anish Nath</h5>
                    <p class="text-muted mb-2">Security Engineer | Cryptography & PKI Expert</p>
                    <p class="small mb-2">Building security tools for developers since 2015. Expertise in Java KeyStore management, SSL/TLS certificates, and public key infrastructure.</p>
                    <a href="https://twitter.com/anish2good" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16" style="vertical-align:-2px">
                            <path d="M12.6.75h2.454l-5.36 6.142L16 15.25h-4.937l-3.867-5.07-4.425 5.07H.316l5.733-6.57L0 .75h5.063l3.495 4.633L12.601.75Zm-.86 13.028h1.36L4.323 2.145H2.865z"/>
                        </svg>
                        @anish2good
                    </a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="addcomments.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
