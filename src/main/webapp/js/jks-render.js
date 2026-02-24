/* ===== JKS Render Module ===== */
(function () {
    'use strict';

    /* ---------- helpers ---------- */
    function esc(s) {
        if (!s) return '';
        var d = document.createElement('div');
        d.textContent = s;
        return d.innerHTML;
    }

    function statusClass(status) {
        if (status === 'expired') return 'expired';
        if (status === 'expiring') return 'expiring';
        return 'valid';
    }

    function statusIcon(status) {
        if (status === 'expired') return '\u274C';
        if (status === 'expiring') return '\u26A0\uFE0F';
        return '\u2705';
    }

    function typeIcon(isKeyEntry) {
        return isKeyEntry ? '\uD83D\uDD10' : '\uD83D\uDCDC';
    }

    /* Accent colors shared between alias list and timeline */
    var ACCENT_COLORS = ['#2563eb', '#7c3aed', '#0891b2', '#059669', '#d97706', '#dc2626', '#be185d', '#4f46e5'];

    function daysText(days) {
        if (days === undefined || days === null) return '';
        if (days < 0) return Math.abs(days) + 'd ago';
        return days + 'd';
    }

    /* ---------- Toast ---------- */
    function showToast(msg, type) {
        var c = document.getElementById('jksToastContainer');
        if (!c) return;
        var t = document.createElement('div');
        t.className = 'jks-toast ' + (type || 'info');
        t.textContent = msg;
        c.appendChild(t);
        setTimeout(function () { if (t.parentNode) t.remove(); }, 3500);
    }

    /* ---------- Loading ---------- */
    function showLoading(el) {
        if (!el) return;
        if (el.querySelector('.jks-loading')) return;
        el.style.position = 'relative';
        var ov = document.createElement('div');
        ov.className = 'jks-loading';
        ov.innerHTML = '<div class="jks-spinner"></div>';
        el.appendChild(ov);
    }

    function hideLoading(el) {
        if (!el) return;
        var ov = el.querySelector('.jks-loading');
        if (ov) ov.remove();
    }

    /* ---------- Empty State (alias detail) ---------- */
    function renderEmptyState() {
        var detailEmpty = document.getElementById('jksDetailEmpty');
        detailEmpty.style.display = '';
        document.getElementById('jksDetailCard').classList.remove('visible');
    }

    /* ---------- Keystore Info Bar ---------- */
    function renderKeystoreInfo(name, type, count) {
        var info = document.getElementById('jksKeystoreInfo');
        document.getElementById('jksInfoName').textContent = name || '-';
        document.getElementById('jksInfoType').textContent = type || 'JKS';
        document.getElementById('jksInfoCount').textContent = count || 0;
        info.classList.add('visible');
    }

    function hideKeystoreInfo() {
        document.getElementById('jksKeystoreInfo').classList.remove('visible');
    }

    /* ---------- Detected Type Badge ---------- */
    function renderDetectedType(detection) {
        var el = document.getElementById('jksDetectedType');
        if (!detection || !detection.detectedType) {
            el.innerHTML = '';
            return;
        }
        el.innerHTML = '<span class="jks-detected-type">\uD83D\uDD0D Detected: <strong>' +
            esc(detection.detectedType) + '</strong>' +
            (detection.fileSize ? ' (' + Math.round(detection.fileSize / 1024) + ' KB)' : '') +
            '</span>';
    }

    /* ---------- Alias List ---------- */
    function renderAliasList(aliases, selectedAlias) {
        var c = document.getElementById('jksAliasList');
        var card = document.getElementById('jksAliasCard');
        var countEl = document.getElementById('jksAliasCount');

        card.classList.add('visible');
        countEl.textContent = aliases ? aliases.length : 0;

        if (!aliases || !aliases.length) {
            c.innerHTML = '<div class="jks-alias-empty">' +
                '<div style="font-size:1.5rem;opacity:0.4;margin-bottom:0.5rem">&#128274;</div>' +
                '<div style="font-weight:500;color:var(--text-secondary,#475569);margin-bottom:0.25rem">No entries yet</div>' +
                '<div style="font-size:0.8125rem;color:var(--text-muted,#94a3b8);margin-bottom:0.75rem">Generate a key pair or import a certificate</div>' +
                '<div style="display:flex;gap:0.5rem;justify-content:center">' +
                '<button class="jks-gen-btn" onclick="document.getElementById(\'jksGenKeyPairBtn\').click()">+ Generate Key Pair</button>' +
                '<button class="jks-gen-btn" data-action="importCert">Import PEM</button>' +
                '</div></div>';
            return;
        }

        var html = '';
        aliases.forEach(function (a, i) {
            var sc = statusClass(a.status);
            var sel = selectedAlias === a.name;
            var typeClass = a.isKeyEntry ? 'key-entry' : 'cert-entry';
            var accent = ACCENT_COLORS[i % ACCENT_COLORS.length];
            html += '<div class="jks-alias-item ' + typeClass + (sel ? ' selected' : '') + '" data-alias="' + esc(a.name) + '" style="--alias-accent:' + accent + '">' +
                '<div class="jks-alias-item-header">' +
                '<span class="jks-alias-name">' + typeIcon(a.isKeyEntry) + ' ' + esc(a.name) + '</span>' +
                '<span class="jks-alias-status ' + sc + '">' + statusIcon(a.status) + ' ' + daysText(a.daysUntilExpiry) + '</span>' +
                '</div>' +
                (a.subject ? '<div class="jks-alias-subject">' + esc(a.subject) + '</div>' : '') +
                '<div class="jks-alias-actions">' +
                '<button class="jks-alias-action-btn act-export-pem" data-action="exportPEM" data-alias="' + esc(a.name) + '"><span class="act-icon">&#8599;</span>PEM</button>' +
                '<button class="jks-alias-action-btn act-export-der" data-action="exportDER" data-alias="' + esc(a.name) + '"><span class="act-icon">&#8615;</span>DER</button>' +
                '<button class="jks-alias-action-btn act-rename" data-action="renameAlias" data-alias="' + esc(a.name) + '"><span class="act-icon">&#9998;</span>Rename</button>' +
                '<button class="jks-alias-action-btn act-duplicate" data-action="duplicateAlias" data-alias="' + esc(a.name) + '"><span class="act-icon">&#10697;</span>Dup</button>' +
                '<button class="jks-alias-action-btn act-delete" data-action="deleteAlias" data-alias="' + esc(a.name) + '"><span class="act-icon">&#128465;</span>Del</button>' +
                '</div></div>';
        });
        c.innerHTML = html;
    }

    function hideAliasList() {
        document.getElementById('jksAliasCard').classList.remove('visible');
    }

    /* Show CTA in alias list when keystore is empty */
    function renderEmptyAliasListCTA() {
        var card = document.getElementById('jksAliasCard');
        card.classList.add('visible');
        renderAliasList([], null);
    }

    /* ---------- Health Dashboard ---------- */
    function renderHealthDashboard(health) {
        var el = document.getElementById('jksHealth');
        el.classList.add('visible');
        document.getElementById('jksHealthValid').textContent = health.valid || 0;
        document.getElementById('jksHealthExpiring').textContent = health.expiring || 0;
        document.getElementById('jksHealthExpired').textContent = health.expired || 0;
        document.getElementById('jksHealthWeak').textContent = health.weak || 0;
    }

    function hideHealthDashboard() {
        document.getElementById('jksHealth').classList.remove('visible');
    }

    /* ---------- Timeline ---------- */
    function renderTimeline(timeline) {
        var bar = document.getElementById('jksTimelineBar');
        if (!timeline || !timeline.length) {
            bar.innerHTML = '<div style="text-align:center;line-height:28px;color:var(--text-muted,#94a3b8);font-size:0.75rem">No certificates</div>';
            return;
        }

        /* Build alias→index map from the alias list to match colors */
        var aliasIndexMap = {};
        var aliasItems = document.querySelectorAll('.jks-alias-item');
        aliasItems.forEach(function (el, idx) {
            aliasIndexMap[el.getAttribute('data-alias')] = idx;
        });

        var width = 100 / timeline.length;
        var html = '';
        timeline.forEach(function (t, i) {
            var days = t.daysUntilExpiry;
            /* Use the alias accent color, falling back to expiry-based color */
            var aliasIdx = aliasIndexMap[t.alias];
            var accentColor = (aliasIdx !== undefined) ? ACCENT_COLORS[aliasIdx % ACCENT_COLORS.length] : null;

            /* Expiry status indicator: border style */
            var statusBorder = '';
            if (days < 0) {
                statusBorder = 'border-bottom:3px solid #ef4444;';
            } else if (days < 30) {
                statusBorder = 'border-bottom:3px solid #f59e0b;';
            }

            var bgColor = accentColor || (days < 0 ? '#ef4444' : (days < 30 ? '#f59e0b' : '#10b981'));

            html += '<div class="jks-timeline-segment" style="left:' + (i * width) + '%;width:' + width +
                '%;background:' + bgColor + ';' + statusBorder + '" data-alias="' + esc(t.alias) +
                '" title="' + esc(t.alias) + ': ' + (days < 0 ? 'Expired ' + Math.abs(days) + 'd ago' : days + ' days remaining') + '">' +
                esc(t.alias.length > 10 ? t.alias.substring(0, 9) + '\u2026' : t.alias) + '</div>';
        });
        bar.innerHTML = html;
    }

    /* ---------- Certificate Detail ---------- */
    function renderCertDetail(alias, details, analysis) {
        var card = document.getElementById('jksDetailCard');
        document.getElementById('jksDetailEmpty').style.display = 'none';
        card.classList.add('visible');

        var now = Date.now();
        var days = details.notAfterTimestamp ? Math.floor((details.notAfterTimestamp - now) / 86400000) : null;

        var hc = '', sc = 'valid', st = 'Valid';
        if (days !== null) {
            if (days < 0) { hc = ' expired'; sc = 'expired'; st = 'Expired ' + Math.abs(days) + ' days ago'; }
            else if (days < 30) { hc = ' expiring'; sc = 'expiring'; st = 'Expires in ' + days + ' days'; }
            else { st = days + ' days remaining'; }
        }

        var isKey = details.isKeyEntry;
        var chainLen = details.chainLength || 0;

        var html = '';

        /* Header */
        html += '<div class="jks-detail-header' + hc + '">';
        html += '<h4>' + esc(alias) + '</h4>';
        html += '<div class="jks-detail-header-actions">';
        html += '<button class="jks-detail-header-btn dh-export-pem" data-action="exportPEM" data-alias="' + esc(alias) + '"><span class="dh-icon">&#8599;</span> Export PEM</button>';
        html += '<button class="jks-detail-header-btn dh-export-der" data-action="exportDER" data-alias="' + esc(alias) + '"><span class="dh-icon">&#8615;</span> Export DER</button>';
        html += '<button class="jks-detail-header-btn dh-rename" data-action="renameAlias" data-alias="' + esc(alias) + '"><span class="dh-icon">&#9998;</span> Rename</button>';
        html += '<button class="jks-detail-header-btn dh-duplicate" data-action="duplicateAlias" data-alias="' + esc(alias) + '"><span class="dh-icon">&#10697;</span> Duplicate</button>';
        if (isKey) {
            html += '<button class="jks-detail-header-btn dh-validate" data-action="validateKeyPair" data-alias="' + esc(alias) + '"><span class="dh-icon">&#9989;</span> Validate Key Pair</button>';
        }
        if (isKey && chainLen > 1) {
            html += '<button class="jks-detail-header-btn dh-order" data-action="orderChain" data-alias="' + esc(alias) + '"><span class="dh-icon">&#128279;</span> Order Chain</button>';
        }
        html += '<button class="jks-detail-header-btn dh-delete" data-action="deleteAlias" data-alias="' + esc(alias) + '"><span class="dh-icon">&#128465;</span> Delete</button>';
        html += '</div></div>';

        /* Body */
        html += '<div class="jks-detail-body">';

        /* Status */
        html += '<div class="jks-status-banner ' + sc + '"><strong>Status:</strong> ' + esc(st) + '</div>';

        /* Validation result placeholder */
        html += '<div id="jksValidationResult"></div>';

        /* Security */
        if (analysis && analysis.warnings && analysis.warnings.length > 0) {
            html += '<div class="jks-security"><h5>\u26A0\uFE0F Security Warnings</h5><ul>';
            analysis.warnings.forEach(function (w) { html += '<li>' + esc(w) + '</li>'; });
            html += '</ul></div>';
        } else {
            html += '<div class="jks-security ok"><h5>\u2705 Security Check Passed</h5><ul><li>No security issues detected</li></ul></div>';
        }

        /* Key strength */
        if (analysis && analysis.keySize) {
            var ks = analysis.keyStrength === 'strong' ? '\u2705' : '\u26A0\uFE0F';
            html += '<div style="margin-bottom:0.75rem;font-size:0.8125rem;"><strong>Key:</strong> ' +
                esc(analysis.keyAlgorithm) + ' ' + analysis.keySize + '-bit ' + ks + '</div>';
        }

        /* Detail Table */
        html += '<table class="jks-detail-table">';
        html += '<tr><td class="dt-label">Subject</td><td class="dt-value">' + esc(details.subject) + '</td></tr>';
        html += '<tr><td class="dt-label">Issuer</td><td class="dt-value">' + esc(details.issuer) + '</td></tr>';
        html += '<tr><td class="dt-label">Serial</td><td class="dt-value">' + esc(details.serialNumber) + '</td></tr>';
        html += '<tr><td class="dt-label">Algorithm</td><td class="dt-value">' + esc(details.signatureAlgorithm) + '</td></tr>';
        html += '<tr><td class="dt-label">Valid From</td><td class="dt-value">' + esc(details.notBefore) + '</td></tr>';
        html += '<tr><td class="dt-label">Valid Until</td><td class="dt-value" style="color:var(--jks-' + sc + ')">' + esc(details.notAfter) + '</td></tr>';
        html += '<tr><td class="dt-label">Self-Signed</td><td class="dt-value">' + (details.selfSigned ? 'Yes' : 'No') + '</td></tr>';
        var keyAlg = details.keyAlgorithm || details.publicKeyAlgorithm;
        if (keyAlg) {
            html += '<tr><td class="dt-label">Key Algorithm</td><td class="dt-value">' + esc(keyAlg) + '</td></tr>';
        }
        if (details.keySizeLabel) {
            html += '<tr><td class="dt-label">Key Size</td><td class="dt-value">' + esc(details.keySizeLabel) + '</td></tr>';
        } else if (details.keySize) {
            html += '<tr><td class="dt-label">Key Size</td><td class="dt-value">' + details.keySize + ' bits</td></tr>';
        }
        if (details.curveName) {
            html += '<tr><td class="dt-label">Curve</td><td class="dt-value">' + esc(details.curveName) + '</td></tr>';
        }
        html += '</table>';

        /* PEM Collapsible */
        if (details.pemExport) {
            html += renderCollapsible('PEM Certificate', function () {
                return '<button class="jks-copy-btn cb-copy" data-copy="' + btoa(details.pemExport) + '"><span class="cb-icon">&#128203;</span> Copy PEM</button> ' +
                    '<button class="jks-copy-btn cb-parse" data-action="parsePem" data-pem="' + btoa(details.pemExport) + '"><span class="cb-icon">&#128270;</span> Parse Full Details</button>' +
                    '<div class="jks-pem-display">' + esc(details.pemExport) + '</div>';
            });
        }

        /* Chain Collapsible */
        if (details.chain && details.chain.length > 0) {
            html += renderCollapsible('Certificate Chain (' + details.chain.length + ')', function () {
                var ch = '';
                details.chain.forEach(function (cert, i) {
                    ch += '<div class="jks-chain-item">' +
                        '<span class="chain-index">' + (i + 1) + '</span>' +
                        '<span class="chain-subject">' + esc(cert.subject || cert) + '</span>' +
                        '</div>';
                });
                ch += '<div class="jks-chain-actions">';
                ch += '<button class="jks-copy-btn cb-append" data-action="appendToChain" data-alias="' + esc(alias) + '"><span class="cb-icon">&#10133;</span> Append Cert</button>';
                ch += '<button class="jks-copy-btn cb-verify" data-action="verifyChain" data-alias="' + esc(alias) + '"><span class="cb-icon">&#9989;</span> Verify Chain</button>';
                ch += '</div>';
                return ch;
            });
        }

        /* Extensions Collapsible */
        var exts = details.extensions || details.extensionDetails;
        if (exts && exts.length > 0) {
            html += renderCollapsible('Extensions (' + exts.length + ')', function () {
                var ext = '<table class="jks-detail-table">';
                exts.forEach(function (e) {
                    ext += '<tr><td class="dt-label">' + esc(e.name || e.oid) + '</td><td class="dt-value">' + esc(e.value) + '</td></tr>';
                });
                ext += '</table>';
                return ext;
            });
        }

        /* Fingerprints Collapsible */
        if (details.fingerprints && Object.keys(details.fingerprints).length > 0) {
            html += renderCollapsible('Fingerprints', function () {
                var fp = '<table class="jks-detail-table">';
                /* Support both API key formats: "SHA-256" or "sha256" */
                var sha256 = details.fingerprints['SHA-256'] || details.fingerprints.sha256;
                var sha1 = details.fingerprints['SHA-1'] || details.fingerprints.sha1;
                var md5 = details.fingerprints['MD5'] || details.fingerprints.md5;
                if (sha256) fp += '<tr><td class="dt-label">SHA-256</td><td class="dt-value fp-value">' + esc(sha256) + '</td></tr>';
                if (sha1) fp += '<tr><td class="dt-label">SHA-1</td><td class="dt-value fp-value">' + esc(sha1) + '</td></tr>';
                if (md5) fp += '<tr><td class="dt-label">MD5</td><td class="dt-value fp-value">' + esc(md5) + '</td></tr>';
                /* Fallback: render any other fingerprint keys the API might return */
                Object.keys(details.fingerprints).forEach(function (k) {
                    var kLower = k.toLowerCase().replace(/-/g, '');
                    if (kLower !== 'sha256' && kLower !== 'sha1' && kLower !== 'md5') {
                        fp += '<tr><td class="dt-label">' + esc(k) + '</td><td class="dt-value fp-value">' + esc(details.fingerprints[k]) + '</td></tr>';
                    }
                });
                fp += '</table>';
                return fp;
            });
        }

        html += '</div>'; /* end detail-body */

        card.innerHTML = html;
    }

    /* ---------- Collapsible Helper ---------- */
    function renderCollapsible(title, contentFn) {
        return '<div class="jks-collapsible">' +
            '<div class="jks-collapsible-header" onclick="this.classList.toggle(\'open\');this.nextElementSibling.classList.toggle(\'open\')">' +
            esc(title) + '<span class="jks-collapsible-chevron">&#9660;</span></div>' +
            '<div class="jks-collapsible-body">' + contentFn() + '</div></div>';
    }

    /* ---------- Validation Result ---------- */
    function renderValidationResult(validation) {
        var el = document.getElementById('jksValidationResult');
        if (!el) return;
        if (!validation) { el.innerHTML = ''; return; }

        var valid = validation.valid;
        var cls = valid ? 'valid' : 'invalid';
        var icon = valid ? '\u2705' : '\u274C';
        var msg = validation.message || (valid ? 'Key pair is valid' : 'Key pair validation failed');

        el.innerHTML = '<div class="jks-validation-result ' + cls + '">' + icon + ' ' + esc(msg) + '</div>';
    }

    /* ---------- Remote Cert Results ---------- */
    function renderRemoteCertResults(data) {
        var container = document.getElementById('jksRemoteResults');
        var body = document.getElementById('jksRemoteResultsBody');
        container.classList.add('visible');

        if (!data.success) {
            body.innerHTML = '<div class="jks-status-banner expired">' + esc(data.error) + '</div>';
            return;
        }

        var html = '<div class="jks-status-banner valid">Found ' + data.count + ' certificate(s) from ' +
            esc(data.host) + ':' + data.port + '</div>';

        data.certificates.forEach(function (cert, i) {
            var sc = statusClass(cert.status);
            html += '<div class="jks-remote-cert">' +
                '<div class="jks-remote-cert-header">' +
                '<strong>' + (i + 1) + '. ' + esc((cert.subject || '').substring(0, 50)) + '</strong>' +
                '<span class="jks-remote-cert-type">' + esc(cert.type) + '</span>' +
                '</div>' +
                '<div style="font-size:0.75rem;color:var(--text-muted)">Issuer: ' + esc((cert.issuer || '').substring(0, 50)) + '</div>' +
                '<div style="font-size:0.75rem;color:var(--jks-' + sc + ')">Expires: ' + esc(cert.notAfter) + ' (' + cert.daysUntilExpiry + ' days)</div>' +
                '<div class="jks-remote-cert-actions">' +
                '<button class="jks-copy-btn cb-copy" data-action="copyRemotePem" data-index="' + i + '"><span class="cb-icon">&#128203;</span> Copy PEM</button>' +
                '<button class="jks-copy-btn cb-add-ks" data-action="addRemoteCert" data-index="' + i + '"><span class="cb-icon">&#10133;</span> Add to KeyStore</button>' +
                '</div>' +
                '<textarea style="display:none" class="jks-remote-pem" data-index="' + i + '">' + esc(cert.pem) + '</textarea>' +
                '<input type="hidden" class="jks-remote-subject" data-index="' + i + '" value="' + esc(cert.subject || '') + '">' +
                '</div>';
        });

        body.innerHTML = html;
    }

    function hideRemoteCertResults() {
        document.getElementById('jksRemoteResults').classList.remove('visible');
    }

    /* ---------- Generate Key Pair Modal ---------- */
    function showGenKeyPairModal() {
        document.getElementById('jksGenModal').classList.add('show');
        document.getElementById('genAlias').value = '';
        document.getElementById('genCN').value = '';
        document.getElementById('genValidity').value = '365';
        document.getElementById('genKeyPassword').value = '';
        updateGenKeyPairPreview();
    }

    function hideGenKeyPairModal() {
        document.getElementById('jksGenModal').classList.remove('show');
    }

    function updateGenKeyPairPreview() {
        var alg = document.querySelector('#genAlgToggle .jks-alg-btn.active');
        var algName = alg ? alg.getAttribute('data-alg') : 'RSA';
        var keySize = document.getElementById('genKeySize').value;
        var cn = document.getElementById('genCN').value || '(no CN)';
        var validity = document.getElementById('genValidity').value || '365';

        var unit = algName === 'EC' ? 'curve P-' : '-bit';
        var preview = 'Will generate: ' + algName + ' ' + keySize + unit + ' key pair\n' +
            'Subject: CN=' + cn + '\n' +
            'Valid for ' + validity + ' days with self-signed certificate';

        document.getElementById('genPreview').textContent = preview;
    }

    function updateKeySizeOptions(alg) {
        var sel = document.getElementById('genKeySize');
        var opts = {
            'RSA': [['2048', '2048 bits'], ['3072', '3072 bits'], ['4096', '4096 bits']],
            'EC': [['256', 'P-256 (256 bits)'], ['384', 'P-384 (384 bits)'], ['521', 'P-521 (521 bits)']],
            'DSA': [['1024', '1024 bits'], ['2048', '2048 bits'], ['3072', '3072 bits']]
        };

        var options = opts[alg] || opts['RSA'];
        sel.innerHTML = '';
        options.forEach(function (o) {
            var opt = document.createElement('option');
            opt.value = o[0];
            opt.textContent = o[1];
            sel.appendChild(opt);
        });
    }

    /* ---------- Clear All UI ---------- */
    function clearAll() {
        hideKeystoreInfo();
        hideAliasList();
        hideHealthDashboard();
        hideRemoteCertResults();
        document.getElementById('jksDetailEmpty').style.display = 'none';
        document.getElementById('jksDetailCard').classList.remove('visible');
        document.getElementById('jksDetectedType').innerHTML = '';
        document.getElementById('jksFileInput').value = '';
        /* Hide download bar */
        var dlBar = document.getElementById('jksDownloadBar');
        if (dlBar) dlBar.classList.remove('visible');
    }

    /* ---------- Exports ---------- */
    window.JksRender = {
        showToast: showToast,
        showLoading: showLoading,
        hideLoading: hideLoading,
        renderEmptyState: renderEmptyState,
        renderKeystoreInfo: renderKeystoreInfo,
        hideKeystoreInfo: hideKeystoreInfo,
        renderDetectedType: renderDetectedType,
        renderAliasList: renderAliasList,
        hideAliasList: hideAliasList,
        renderEmptyAliasListCTA: renderEmptyAliasListCTA,
        renderHealthDashboard: renderHealthDashboard,
        hideHealthDashboard: hideHealthDashboard,
        renderTimeline: renderTimeline,
        renderCertDetail: renderCertDetail,
        renderValidationResult: renderValidationResult,
        renderRemoteCertResults: renderRemoteCertResults,
        hideRemoteCertResults: hideRemoteCertResults,
        showGenKeyPairModal: showGenKeyPairModal,
        hideGenKeyPairModal: hideGenKeyPairModal,
        updateGenKeyPairPreview: updateGenKeyPairPreview,
        updateKeySizeOptions: updateKeySizeOptions,
        clearAll: clearAll
    };

})();
