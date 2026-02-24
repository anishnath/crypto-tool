/* ===== JKS Core Module ===== */
(function () {
    'use strict';

    var R = window.JksRender;
    var API_URL = 'JKSManagementFunctionality';

    /* ---------- State ---------- */
    var state = {
        keystoreData: null,
        fileName: null,
        keystoreType: null,
        password: null,
        selectedAlias: null,
        aliases: [],
        allAliases: [],
        currentMode: 'upload',
        detectedType: null
    };

    /* ---------- API Helper ---------- */
    function apiCall(action, params, callback) {
        var fd = new FormData();
        fd.append('action', action);
        if (state.keystoreData) fd.append('keystoreData', state.keystoreData);
        if (state.password) fd.append('storepassword', state.password);
        if (params) {
            Object.keys(params).forEach(function (k) {
                fd.append(k, params[k]);
            });
        }

        fetch(API_URL, { method: 'POST', body: fd })
            .then(function (r) { return r.json(); })
            .then(function (d) { callback(null, d); })
            .catch(function (e) { callback(e, null); });
    }

    /* ---------- State Update Helper ---------- */
    function updateStateFromResponse(d) {
        if (d.keystoreData) state.keystoreData = d.keystoreData;
        if (d.aliases) { state.aliases = d.aliases; state.allAliases = d.aliases; }
        if (d.aliasCount !== undefined) {
            R.renderKeystoreInfo(state.fileName, state.keystoreType, d.aliasCount);
            R.renderAliasList(d.aliases, state.selectedAlias);
        }
    }

    /* ---------- UI State Management ---------- */
    function showKeystoreLoadedUI(isNewlyCreated) {
        /* Hide onboarding */
        var onboarding = document.getElementById('jksOnboarding');
        if (onboarding) onboarding.style.display = 'none';

        /* Collapse the input form + mode tabs */
        collapseInputForm();

        /* Show download bar */
        var dlBar = document.getElementById('jksDownloadBar');
        if (dlBar) dlBar.classList.add('visible');

        /* Show guidance panel */
        var guidance = document.getElementById('jksGuidance');
        if (guidance) {
            guidance.style.display = '';
            var title = document.getElementById('jksGuidanceTitle');
            var text = document.getElementById('jksGuidanceText');
            if (isNewlyCreated) {
                title.textContent = 'Keystore Created';
                text.textContent = 'Your empty keystore is ready. Generate a key pair, import a certificate, or fetch SSL certs from a website.';
            } else if (state.aliases.length > 0) {
                title.textContent = 'Keystore Loaded — ' + state.aliases.length + ' entries';
                text.textContent = 'Select an alias from the left panel to view certificate details, security analysis, and management options.';
            } else {
                title.textContent = 'Keystore Loaded — Empty';
                text.textContent = 'This keystore has no entries. Generate a key pair, import certificates, or fetch SSL certs to populate it.';
            }
        }

        /* Show detail empty state pointing to alias list */
        var detailEmpty = document.getElementById('jksDetailEmpty');
        if (detailEmpty && state.aliases.length > 0) {
            detailEmpty.style.display = '';
        }
    }

    function collapseInputForm() {
        document.getElementById('modeUpload').classList.add('collapsed');
        document.getElementById('modeFetch').classList.add('collapsed');
        document.getElementById('modeCreate').classList.add('collapsed');
        document.getElementById('jksModeToggle').classList.add('collapsed');
    }

    function expandInputForm() {
        document.getElementById('jksModeToggle').classList.remove('collapsed');
        switchMode(state.currentMode);
    }

    function resetToLandingUI() {
        var onboarding = document.getElementById('jksOnboarding');
        if (onboarding) onboarding.style.display = '';

        var guidance = document.getElementById('jksGuidance');
        if (guidance) guidance.style.display = 'none';

        var dlBar = document.getElementById('jksDownloadBar');
        if (dlBar) dlBar.classList.remove('visible');

        var detailEmpty = document.getElementById('jksDetailEmpty');
        if (detailEmpty) detailEmpty.style.display = 'none';

        expandInputForm();
    }

    /* ---------- Mode Toggle ---------- */
    function switchMode(mode) {
        state.currentMode = mode;
        document.querySelectorAll('#jksModeToggle .jks-mode-btn').forEach(function (b) {
            b.classList.toggle('active', b.getAttribute('data-mode') === mode);
        });
        /* If toggle is collapsed (keystore loaded), just track the mode — don't show panels */
        var toggle = document.getElementById('jksModeToggle');
        if (toggle.classList.contains('collapsed')) return;
        /* Remove collapsed from all, then show only the active one */
        document.getElementById('modeUpload').classList.remove('collapsed');
        document.getElementById('modeFetch').classList.remove('collapsed');
        document.getElementById('modeCreate').classList.remove('collapsed');
        document.getElementById('modeUpload').style.display = mode === 'upload' ? '' : 'none';
        document.getElementById('modeFetch').style.display = mode === 'fetch' ? '' : 'none';
        document.getElementById('modeCreate').style.display = mode === 'create' ? '' : 'none';
    }

    /* ---------- Upload Keystore ---------- */
    function uploadKeystore() {
        var pwd = document.getElementById('jksPassword').value;
        var file = getSelectedFile();
        if (!file) {
            R.showToast('Select a keystore file', 'error');
            return;
        }
        state.password = pwd;
        R.showLoading(document.getElementById('jksAliasList'));

        var reader = new FileReader();
        reader.onload = function (e) {
            var base64Data = e.target.result.split(',')[1];
            state.keystoreData = base64Data;
            state.fileName = file.name;

            apiCall('upload', {
                keystoreData: base64Data,
                fileName: file.name,
                storepassword: pwd
            }, function (err, d) {
                R.hideLoading(document.getElementById('jksAliasList'));
                if (err) { R.showToast('Error: ' + err.message, 'error'); return; }
                if (!d.success) { R.showToast(d.error, 'error'); state.keystoreData = null; return; }

                state.keystoreType = d.keystoreType;
                state.aliases = d.aliases;
                state.allAliases = d.aliases;

                R.renderKeystoreInfo(file.name, d.keystoreType, d.aliasCount);
                R.renderAliasList(d.aliases, null);
                bindAliasClicks();
                loadHealthDashboard();
                showKeystoreLoadedUI(false);
                R.showToast('Loaded ' + d.aliasCount + ' entries', 'success');

                if (d.aliases.length > 0) selectAlias(d.aliases[0].name);
            });
        };
        reader.onerror = function () {
            R.hideLoading(document.getElementById('jksAliasList'));
            R.showToast('Error reading file', 'error');
        };
        reader.readAsDataURL(file);
    }

    /* ---------- Detect Type (auto on file select) ---------- */
    function detectType() {
        var fileInput = document.getElementById('jksFileInput');
        if (!fileInput.files || !fileInput.files.length) return;
        var file = fileInput.files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
            var base64Data = e.target.result.split(',')[1];
            var fd = new FormData();
            fd.append('action', 'detectType');
            fd.append('keystoreData', base64Data);

            fetch(API_URL, { method: 'POST', body: fd })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (d.success) {
                        state.detectedType = d;
                        R.renderDetectedType(d);
                    }
                })
                .catch(function () { /* ignore detection errors */ });
        };
        reader.readAsDataURL(file);
    }

    /* ---------- Select Alias ---------- */
    function selectAlias(name) {
        state.selectedAlias = name;
        document.querySelectorAll('.jks-alias-item').forEach(function (el) {
            el.classList.toggle('selected', el.getAttribute('data-alias') === name);
        });
        loadAliasDetails(name);
    }

    /* ---------- Load Alias Details ---------- */
    function loadAliasDetails(name) {
        var card = document.getElementById('jksDetailCard');
        R.showLoading(card);
        document.getElementById('jksDetailEmpty').style.display = 'none';
        /* Hide guidance when viewing a cert */
        var guidance = document.getElementById('jksGuidance');
        if (guidance) guidance.style.display = 'none';
        card.classList.add('visible');

        apiCall('getDetails', { alias: name }, function (err, d) {
            R.hideLoading(card);
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }
            loadSecurityAnalysis(name, d.details);
        });
    }

    /* ---------- Load Security Analysis ---------- */
    function loadSecurityAnalysis(alias, details) {
        apiCall('getSecurityAnalysis', { alias: alias }, function (err, d) {
            var analysis = (d && d.success) ? d.analysis : { warnings: [] };
            R.renderCertDetail(alias, details, analysis);
            bindDetailActions();
        });
    }

    /* ---------- Health Dashboard ---------- */
    function loadHealthDashboard() {
        apiCall('getHealth', {}, function (err, d) {
            if (err || !d || !d.success) return;
            R.renderHealthDashboard(d.health);
            loadTimeline();
        });
    }

    function loadTimeline() {
        apiCall('getTimeline', {}, function (err, d) {
            if (err || !d || !d.success) return;
            R.renderTimeline(d.timeline);
            bindTimelineClicks();
        });
    }

    /* ---------- Export Operations ---------- */
    function exportViaForm(action, params) {
        var form = document.createElement('form');
        form.method = 'POST';
        form.action = API_URL;
        form.style.display = 'none';

        var fields = { action: action, keystoreData: state.keystoreData, storepassword: state.password || '' };
        if (params) Object.keys(params).forEach(function (k) { fields[k] = params[k]; });

        Object.keys(fields).forEach(function (k) {
            var inp = document.createElement('input');
            inp.type = 'hidden';
            inp.name = k;
            inp.value = fields[k];
            form.appendChild(inp);
        });

        document.body.appendChild(form);
        form.submit();
        document.body.removeChild(form);
    }

    function exportPEM(alias) { exportViaForm('exportPEM', { alias: alias }); }
    function exportDER(alias) { exportViaForm('exportDER', { alias: alias }); }
    function exportKeyStore() {
        if (!state.password) { R.showToast('Password required', 'error'); return; }
        exportViaForm('exportKeyStore', {});
    }

    /* ---------- Delete Alias ---------- */
    function deleteAlias(alias) {
        if (!confirm('Delete "' + alias + '"?')) return;
        if (!state.password) { R.showToast('Password required', 'error'); return; }

        apiCall('deleteAlias', { alias: alias }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast('Deleted "' + alias + '"', 'success');
            updateStateFromResponse(d);
            loadHealthDashboard();
            R.renderEmptyState();
            if (d.aliases && d.aliases.length) selectAlias(d.aliases[0].name);
        });
    }

    /* ---------- Rename Alias ---------- */
    function renameAlias(alias) {
        var newName = prompt('New name for "' + alias + '":', alias);
        if (!newName || newName === alias) return;

        apiCall('renameAlias', { alias: alias, newAlias: newName }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast('Renamed to "' + newName + '"', 'success');
            updateStateFromResponse(d);
            selectAlias(newName);
        });
    }

    /* ---------- Duplicate Alias ---------- */
    function duplicateAlias(alias) {
        var newName = prompt('New alias name for duplicate:', alias + '-copy');
        if (!newName) return;

        apiCall('duplicateAlias', { alias: alias, newAlias: newName }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast('Duplicated as "' + newName + '"', 'success');
            updateStateFromResponse(d);
            selectAlias(newName);
        });
    }

    /* ---------- Import Certificate ---------- */
    function importCertificate(alias, pem) {
        if (!alias || !pem) { R.showToast('Enter alias and PEM', 'error'); return; }
        if (!state.keystoreData) { R.showToast('Upload a keystore first', 'error'); return; }

        apiCall('importCert', { alias: alias, pemCert: pem }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast(d.message || 'Imported', 'success');
            updateStateFromResponse(d);
            loadHealthDashboard();
            selectAlias(alias);
        });
    }

    /* ---------- Filter Aliases ---------- */
    function filterAliases(q) {
        q = q.toLowerCase();
        var filtered = state.allAliases.filter(function (a) {
            return a.name.toLowerCase().indexOf(q) !== -1 ||
                (a.subject && a.subject.toLowerCase().indexOf(q) !== -1);
        });
        state.aliases = filtered;
        R.renderAliasList(filtered, state.selectedAlias);
        bindAliasClicks();
    }

    /* ---------- Clear Keystore ---------- */
    function clearKeystore() {
        state = {
            keystoreData: null, fileName: null, keystoreType: null, password: null,
            selectedAlias: null, aliases: [], allAliases: [], currentMode: 'upload',
            detectedType: null
        };
        R.clearAll();
        resetToLandingUI();
    }

    /* ---------- Fetch Remote Cert ---------- */
    function fetchRemoteCert() {
        var url = document.getElementById('jksRemoteUrl').value;
        if (!url) { R.showToast('Enter a URL', 'error'); return; }

        var body = document.getElementById('jksRemoteResultsBody');
        var container = document.getElementById('jksRemoteResults');
        container.classList.add('visible');
        body.innerHTML = '<div style="text-align:center;padding:1.5rem;"><div class="jks-spinner" style="margin:0 auto"></div><p style="margin-top:0.5rem;font-size:0.875rem;color:var(--text-muted)">Fetching certificates...</p></div>';

        var fd = new FormData();
        fd.append('action', 'fetchRemote');
        fd.append('url', url);

        fetch(API_URL, { method: 'POST', body: fd })
            .then(function (r) { return r.json(); })
            .then(function (d) {
                R.renderRemoteCertResults(d);
                bindRemoteCertActions();
            })
            .catch(function (e) {
                body.innerHTML = '<div class="jks-status-banner expired">Error: ' + e.message + '</div>';
            });
    }

    /* ---------- Add Remote Cert to Keystore ---------- */
    function addRemoteCertToKeystore(index) {
        var pemEl = document.querySelector('.jks-remote-pem[data-index="' + index + '"]');
        var subjectEl = document.querySelector('.jks-remote-subject[data-index="' + index + '"]');
        if (!pemEl) return;

        var pem = pemEl.value;
        var subject = subjectEl ? subjectEl.value : '';

        if (!state.keystoreData) {
            /* Offer to auto-create a PKCS12 keystore */
            var pwd = prompt('No keystore loaded. Enter a password to create a new PKCS12 keystore:');
            if (!pwd) return;

            var fd = new FormData();
            fd.append('action', 'createKeystore');
            fd.append('keystoreType', 'PKCS12');
            fd.append('storepassword', pwd);

            fetch(API_URL, { method: 'POST', body: fd })
                .then(function (r) { return r.json(); })
                .then(function (d) {
                    if (!d.success) { R.showToast(d.error, 'error'); return; }
                    state.keystoreData = d.keystoreData;
                    state.keystoreType = d.keystoreType;
                    state.password = pwd;
                    state.fileName = 'new-keystore.p12';
                    state.aliases = [];
                    state.allAliases = [];
                    R.renderKeystoreInfo(state.fileName, d.keystoreType, 0);
                    showKeystoreLoadedUI(true);
                    R.showToast('Created new PKCS12 keystore', 'success');
                    /* Now import the cert into it */
                    doAddRemoteCert(index, pem, subject);
                })
                .catch(function (e) { R.showToast('Error: ' + e.message, 'error'); });
            return;
        }
        if (!state.password) {
            R.showToast('Password required', 'error');
            return;
        }

        doAddRemoteCert(index, pem, subject);
    }

    function doAddRemoteCert(index, pem, subject) {
        var defaultAlias = 'remote-cert-' + index;
        var cnMatch = subject.match(/CN=([^,]+)/i);
        if (cnMatch) defaultAlias = cnMatch[1].trim().toLowerCase().replace(/[^a-z0-9.\-]/g, '-');

        var alias = prompt('Enter alias name:', defaultAlias);
        if (!alias) return;

        apiCall('importCert', { alias: alias, pemCert: pem }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast('Added "' + alias + '" to keystore', 'success');
            updateStateFromResponse(d);
            loadHealthDashboard();
            bindAliasClicks();
        });
    }

    /* ---------- Create New Keystore ---------- */
    function createKeystore() {
        var typeBtn = document.querySelector('#jksCreateTypeToggle .jks-alg-btn.active');
        var ksType = typeBtn ? typeBtn.getAttribute('data-type') : 'JKS';
        var pwd = document.getElementById('jksCreatePassword').value;

        if (!pwd) { R.showToast('Password is required', 'error'); return; }

        var fd = new FormData();
        fd.append('action', 'createKeystore');
        fd.append('keystoreType', ksType);
        fd.append('storepassword', pwd);

        fetch(API_URL, { method: 'POST', body: fd })
            .then(function (r) { return r.json(); })
            .then(function (d) {
                if (!d.success) { R.showToast(d.error, 'error'); return; }

                state.keystoreData = d.keystoreData;
                state.keystoreType = d.keystoreType;
                state.password = pwd;
                state.fileName = 'new-keystore.' + (ksType === 'PKCS12' ? 'p12' : ksType.toLowerCase());
                state.aliases = [];
                state.allAliases = [];

                R.renderKeystoreInfo(state.fileName, d.keystoreType, 0);
                R.renderAliasList([], null);
                bindAliasClicks();
                showKeystoreLoadedUI(true);
                R.showToast(d.message, 'success');
            })
            .catch(function (e) { R.showToast('Error: ' + e.message, 'error'); });
    }

    /* ---------- Generate Key Pair ---------- */
    function generateKeyPair() {
        var alias = document.getElementById('genAlias').value;
        if (!alias) { R.showToast('Alias name is required', 'error'); return; }
        if (!state.keystoreData) { R.showToast('Load or create a keystore first', 'error'); return; }

        var algBtn = document.querySelector('#genAlgToggle .jks-alg-btn.active');
        var keyAlg = algBtn ? algBtn.getAttribute('data-alg') : 'RSA';
        var keySize = document.getElementById('genKeySize').value;
        var cn = document.getElementById('genCN').value;
        var validity = document.getElementById('genValidity').value;
        var keyPassword = document.getElementById('genKeyPassword').value;

        apiCall('generateKeyPair', {
            alias: alias,
            keyAlg: keyAlg,
            keySize: keySize,
            cn: cn || alias,
            validityDays: validity || '365',
            keyPassword: keyPassword || ''
        }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.hideGenKeyPairModal();
            R.showToast(d.message, 'success');
            updateStateFromResponse(d);
            loadHealthDashboard();
            bindAliasClicks();
            showKeystoreLoadedUI(false);
            selectAlias(alias);
        });
    }

    /* ---------- Validate Key Pair ---------- */
    function validateKeyPair(alias) {
        apiCall('validateKeyPair', { alias: alias }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }
            R.renderValidationResult(d.validation);
        });
    }

    /* ---------- Order Chain ---------- */
    function orderChain(alias) {
        apiCall('orderChain', { alias: alias }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast(d.message, 'success');
            updateStateFromResponse(d);
            loadHealthDashboard();
            bindAliasClicks();
            selectAlias(alias);
        });
    }

    /* ---------- Chain Management ---------- */
    function appendToChain(alias) {
        var pem = prompt('Paste PEM certificate to append to chain:');
        if (!pem) return;

        apiCall('appendToChain', { alias: alias, pemCert: pem }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }

            R.showToast(d.message || 'Certificate appended', 'success');
            updateStateFromResponse(d);
            selectAlias(alias);
        });
    }

    function verifyChain(alias) {
        apiCall('verifyChain', { alias: alias }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error || 'Chain verification failed', 'error'); return; }
            R.showToast(d.message || 'Chain is valid', 'success');
        });
    }

    /* ---------- Import Certificate (modal) ---------- */
    function showImportCertModal() {
        if (!state.keystoreData) { R.showToast('Load or create a keystore first', 'error'); return; }
        document.getElementById('importAlias').value = '';
        document.getElementById('importPem').value = '';
        document.getElementById('jksImportModal').classList.add('show');
    }

    function hideImportCertModal() {
        document.getElementById('jksImportModal').classList.remove('show');
    }

    function submitImportCert() {
        var alias = document.getElementById('importAlias').value.trim();
        var pem = document.getElementById('importPem').value.trim();
        if (!alias) { R.showToast('Alias name is required', 'error'); return; }
        if (!pem) { R.showToast('PEM certificate is required', 'error'); return; }

        apiCall('importCert', { alias: alias, pemCert: pem }, function (err, d) {
            if (err) { R.showToast(err.message, 'error'); return; }
            if (!d.success) { R.showToast(d.error, 'error'); return; }
            hideImportCertModal();
            R.showToast(d.message || 'Imported', 'success');
            updateStateFromResponse(d);
            loadHealthDashboard();
            bindAliasClicks();
            showKeystoreLoadedUI(false);
            selectAlias(alias);
        });
    }

    /* ---------- Download Keystore ---------- */
    function downloadKeystore() {
        if (!state.keystoreData) { R.showToast('No keystore to download', 'error'); return; }
        if (!state.password) { R.showToast('Password required', 'error'); return; }
        exportKeyStore();
    }

    /* ---------- Copy ---------- */
    function copyText(b64) {
        try {
            navigator.clipboard.writeText(atob(b64)).then(function () {
                R.showToast('Copied!', 'success');
            });
        } catch (e) {
            R.showToast('Copy failed', 'error');
        }
    }

    function parsePemCert(b64) {
        var pem = atob(b64);
        localStorage.setItem('jks_pem_to_parse', pem);
        window.open('PemParserFunctions.jsp?fromJks=1', '_blank');
    }

    /* ---------- Drag & Drop ---------- */
    var _droppedFiles = null;

    function setupDragDrop() {
        var dz = document.getElementById('jksDropzone');
        if (!dz) return;

        ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(function (e) {
            dz.addEventListener(e, function (ev) { ev.preventDefault(); ev.stopPropagation(); });
        });
        ['dragenter', 'dragover'].forEach(function (e) {
            dz.addEventListener(e, function () { dz.classList.add('dragover'); });
        });
        ['dragleave', 'drop'].forEach(function (e) {
            dz.addEventListener(e, function () { dz.classList.remove('dragover'); });
        });
        dz.addEventListener('drop', function (e) {
            _droppedFiles = e.dataTransfer.files;
            uploadKeystore();
        });
        dz.addEventListener('click', function () {
            document.getElementById('jksFileInput').click();
        });
    }

    function getSelectedFile() {
        if (_droppedFiles && _droppedFiles.length) {
            var f = _droppedFiles;
            _droppedFiles = null;
            return f[0];
        }
        var fi = document.getElementById('jksFileInput');
        return (fi.files && fi.files.length) ? fi.files[0] : null;
    }

    /* ---------- Action Dispatcher ---------- */
    function handleAction(action, alias, el) {
        switch (action) {
            case 'exportPEM': exportPEM(alias); break;
            case 'exportDER': exportDER(alias); break;
            case 'deleteAlias': deleteAlias(alias); break;
            case 'renameAlias': renameAlias(alias); break;
            case 'duplicateAlias': duplicateAlias(alias); break;
            case 'validateKeyPair': validateKeyPair(alias); break;
            case 'orderChain': orderChain(alias); break;
            case 'appendToChain': appendToChain(alias); break;
            case 'verifyChain': verifyChain(alias); break;
            case 'importCert': showImportCertModal(); break;
            case 'parsePem': parsePemCert(el.getAttribute('data-pem')); break;
            case 'copyRemotePem':
                var idx = el.getAttribute('data-index');
                var pemEl = document.querySelector('.jks-remote-pem[data-index="' + idx + '"]');
                if (pemEl) {
                    navigator.clipboard.writeText(pemEl.value).then(function () {
                        R.showToast('PEM copied!', 'success');
                    });
                }
                break;
            case 'addRemoteCert':
                addRemoteCertToKeystore(parseInt(el.getAttribute('data-index')));
                break;
        }
    }

    /* ---------- Event Binding ---------- */
    function bindAliasClicks() {
        document.querySelectorAll('.jks-alias-item').forEach(function (el) {
            el.addEventListener('click', function (e) {
                if (e.target.closest('.jks-alias-action-btn')) return;
                selectAlias(el.getAttribute('data-alias'));
            });
        });
        document.querySelectorAll('.jks-alias-action-btn').forEach(function (btn) {
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                handleAction(btn.getAttribute('data-action'), btn.getAttribute('data-alias'), btn);
            });
        });
        /* CTA buttons inside empty alias list */
        document.querySelectorAll('#jksAliasList [data-action]').forEach(function (btn) {
            if (btn._jksBound) return;
            btn._jksBound = true;
            btn.addEventListener('click', function () {
                handleAction(btn.getAttribute('data-action'), null, btn);
            });
        });
    }

    function bindDetailActions() {
        var detailCard = document.getElementById('jksDetailCard');
        if (!detailCard) return;
        detailCard.querySelectorAll('[data-action]').forEach(function (btn) {
            if (btn._jksBound) return;
            btn._jksBound = true;
            btn.addEventListener('click', function (e) {
                var action = btn.getAttribute('data-action');
                var alias = btn.getAttribute('data-alias');
                if (action) handleAction(action, alias, btn);
            });
        });
        detailCard.querySelectorAll('[data-copy]').forEach(function (btn) {
            if (btn._jksBound) return;
            btn._jksBound = true;
            btn.addEventListener('click', function () {
                copyText(btn.getAttribute('data-copy'));
            });
        });
    }

    function bindTimelineClicks() {
        document.querySelectorAll('.jks-timeline-segment').forEach(function (el) {
            el.addEventListener('click', function () {
                selectAlias(el.getAttribute('data-alias'));
            });
        });
    }

    function bindRemoteCertActions() {
        document.querySelectorAll('#jksRemoteResultsBody [data-action]').forEach(function (btn) {
            if (btn._jksBound) return;
            btn._jksBound = true;
            btn.addEventListener('click', function () {
                handleAction(btn.getAttribute('data-action'), null, btn);
            });
        });
    }

    /* ---------- Init ---------- */
    function init() {
        /* Mode toggle */
        document.querySelectorAll('#jksModeToggle .jks-mode-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                switchMode(btn.getAttribute('data-mode'));
            });
        });

        /* Upload */
        document.getElementById('jksUploadBtn').addEventListener('click', function () {
            uploadKeystore();
        });

        /* File select - auto detect */
        document.getElementById('jksFileInput').addEventListener('change', function () {
            detectType();
        });

        /* Fetch */
        document.getElementById('jksFetchBtn').addEventListener('click', function () {
            fetchRemoteCert();
        });

        /* Create keystore type toggle */
        document.querySelectorAll('#jksCreateTypeToggle .jks-alg-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('#jksCreateTypeToggle .jks-alg-btn').forEach(function (b) {
                    b.classList.remove('active');
                });
                btn.classList.add('active');
            });
        });

        /* Create */
        document.getElementById('jksCreateBtn').addEventListener('click', function () {
            createKeystore();
        });

        /* Clear */
        document.getElementById('jksClearBtn').addEventListener('click', function () {
            clearKeystore();
        });

        /* Download Keystore (prominent bar) */
        var dlBtn = document.getElementById('jksDownloadBtn');
        if (dlBtn) dlBtn.addEventListener('click', function () { downloadKeystore(); });

        /* Import Cert button in alias header */
        var importBtn = document.getElementById('jksImportCertBtn');
        if (importBtn) importBtn.addEventListener('click', function () { showImportCertModal(); });

        /* Change button (re-expand input form) */
        var changeBtn = document.getElementById('jksChangeInputBtn');
        if (changeBtn) changeBtn.addEventListener('click', function () { expandInputForm(); });

        /* Onboarding cards (click to switch mode) */
        document.querySelectorAll('[data-switch-mode]').forEach(function (card) {
            card.addEventListener('click', function () {
                switchMode(card.getAttribute('data-switch-mode'));
                /* Scroll to input on mobile */
                var input = document.querySelector('.tool-input-column');
                if (input && window.innerWidth < 900) input.scrollIntoView({ behavior: 'smooth' });
            });
        });

        /* Guidance panel buttons */
        var guideGenBtn = document.getElementById('jksGuideGenBtn');
        if (guideGenBtn) guideGenBtn.addEventListener('click', function () {
            document.getElementById('jksGenKeyPairBtn').click();
        });
        var guideImportBtn = document.getElementById('jksGuideImportBtn');
        if (guideImportBtn) guideImportBtn.addEventListener('click', function () {
            showImportCertModal();
        });
        var guideFetchBtn = document.getElementById('jksGuideFetchBtn');
        if (guideFetchBtn) guideFetchBtn.addEventListener('click', function () {
            expandInputForm();
            switchMode('fetch');
            document.getElementById('jksRemoteUrl').focus();
        });
        var guideDownloadBtn = document.getElementById('jksGuideDownloadBtn');
        if (guideDownloadBtn) guideDownloadBtn.addEventListener('click', function () {
            downloadKeystore();
        });

        /* Import PEM modal */
        document.getElementById('jksImportModalClose').addEventListener('click', function () {
            hideImportCertModal();
        });
        document.getElementById('jksImportCancelBtn').addEventListener('click', function () {
            hideImportCertModal();
        });
        document.getElementById('jksImportSubmitBtn').addEventListener('click', function () {
            submitImportCert();
        });
        document.getElementById('jksImportModal').addEventListener('click', function (e) {
            if (e.target === this) hideImportCertModal();
        });

        /* Alias search */
        document.getElementById('jksAliasSearch').addEventListener('input', function () {
            filterAliases(this.value);
        });

        /* Export keystore */
        document.getElementById('jksExportKsBtn').addEventListener('click', function () {
            exportKeyStore();
        });

        /* Generate key pair modal */
        document.getElementById('jksGenKeyPairBtn').addEventListener('click', function () {
            if (!state.keystoreData) { R.showToast('Load or create a keystore first', 'error'); return; }
            R.showGenKeyPairModal();
        });
        document.getElementById('jksGenModalClose').addEventListener('click', function () {
            R.hideGenKeyPairModal();
        });
        document.getElementById('jksGenCancelBtn').addEventListener('click', function () {
            R.hideGenKeyPairModal();
        });
        document.getElementById('jksGenSubmitBtn').addEventListener('click', function () {
            generateKeyPair();
        });
        document.getElementById('jksGenModal').addEventListener('click', function (e) {
            if (e.target === this) R.hideGenKeyPairModal();
        });

        /* Algorithm toggle in modal */
        document.querySelectorAll('#genAlgToggle .jks-alg-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('#genAlgToggle .jks-alg-btn').forEach(function (b) {
                    b.classList.remove('active');
                });
                btn.classList.add('active');
                R.updateKeySizeOptions(btn.getAttribute('data-alg'));
                R.updateGenKeyPairPreview();
            });
        });

        /* Preview updates */
        ['genAlias', 'genCN', 'genValidity', 'genKeySize'].forEach(function (id) {
            var el = document.getElementById(id);
            if (el) el.addEventListener('input', function () { R.updateGenKeyPairPreview(); });
            if (el) el.addEventListener('change', function () { R.updateGenKeyPairPreview(); });
        });

        /* Drag & Drop */
        setupDragDrop();

        /* Enter key on password */
        document.getElementById('jksPassword').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); uploadKeystore(); }
        });
        document.getElementById('jksRemoteUrl').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); fetchRemoteCert(); }
        });
        document.getElementById('jksCreatePassword').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); createKeystore(); }
        });
    }

    /* ---------- Boot ---------- */
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }

    /* ---------- Exports ---------- */
    window.JksCore = {
        selectAlias: selectAlias,
        getState: function () { return state; }
    };

})();
