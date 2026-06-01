/**
 * RSA tool page UI — native DOM (no jQuery).
 * Init via window.__rsaPage = { defaultKeySize, ctxPath } before this script loads.
 */
(function () {
  'use strict';

  function $(sel, root) {
    return (root || document).querySelector(sel);
  }

  function $$(sel, root) {
    return Array.from((root || document).querySelectorAll(sel));
  }

  function byId(id) {
    return document.getElementById(id);
  }

  function showEl(el) {
    if (el) el.hidden = false;
  }

  function hideEl(el) {
    if (el) el.hidden = true;
  }

  function showBtn(el) {
    if (el) el.style.display = '';
  }

  function hideBtn(el) {
    if (el) el.style.display = 'none';
  }

  function init(cfg) {
    var defaultKeySize = String(cfg.defaultKeySize || '2048');
    var ctxPath = String(cfg.ctxPath || '');
    var lastResponse = null;
    var currentMode = 'encrypt';
    var rsaCompilerLoaded = false;

    var encryptAlgorithms = [
      { value: 'RSA', label: 'RSA' },
      { value: 'RSA/ECB/PKCS1Padding', label: 'RSA/ECB/PKCS1Padding' },
      { value: 'RSA/None/PKCS1Padding', label: 'RSA/None/PKCS1Padding' },
      { value: 'RSA/NONE/OAEPWithSHA1AndMGF1Padding', label: 'OAEP SHA-1' },
      { value: 'RSA/ECB/OAEPWithSHA-1AndMGF1Padding', label: 'ECB/OAEP SHA-1' },
      { value: 'RSA/ECB/OAEPWithSHA-256AndMGF1Padding', label: 'ECB/OAEP SHA-256' },
    ];
    var signAlgorithms = [
      { value: 'SHA256withRSA', label: 'SHA256withRSA (Recommended)' },
      { value: 'SHA512withRSA', label: 'SHA512withRSA' },
      { value: 'SHA384withRSA', label: 'SHA384withRSA' },
      { value: 'SHA1withRSA', label: 'SHA1withRSA' },
      { value: 'SHA1WithRSA/PSS', label: 'SHA1WithRSA/PSS' },
      { value: 'SHA224WithRSA/PSS', label: 'SHA224WithRSA/PSS' },
      { value: 'SHA384WithRSA/PSS', label: 'SHA384WithRSA/PSS' },
      { value: 'MD5withRSA', label: 'MD5withRSA (Deprecated)' },
    ];
    var paddingOverhead = {
      RSA: 11,
      'RSA/ECB/PKCS1Padding': 11,
      'RSA/None/PKCS1Padding': 11,
      'RSA/NONE/OAEPWithSHA1AndMGF1Padding': 42,
      'RSA/ECB/OAEPWithSHA-1AndMGF1Padding': 42,
      'RSA/ECB/OAEPWithSHA-256AndMGF1Padding': 66,
    };

    function getKeySize() {
      var checked = $('input[name="keysize_ui"]:checked');
      return parseInt(checked ? checked.value : defaultKeySize, 10);
    }

    function getMaxBytes() {
      var select = byId('cipherSelect');
      var algo = select ? select.value : '';
      var overhead = paddingOverhead[algo];
      if (overhead === undefined) return -1;
      return (getKeySize() / 8) - overhead;
    }

    function syncOperationUI() {
      var checked = $('input[name="op_mode"]:checked');
      currentMode = checked ? checked.value : 'encrypt';
      var btn = byId('processBtn');
      var msg = byId('message');
      var isSignVerify = currentMode === 'sign' || currentMode === 'verify';
      var select = byId('cipherSelect');
      var algos = isSignVerify ? signAlgorithms : encryptAlgorithms;

      if (select) {
        select.innerHTML = '';
        algos.forEach(function (a) {
          var opt = document.createElement('option');
          opt.value = a.value;
          opt.textContent = a.label;
          select.appendChild(opt);
        });
        var label = select.closest('.rsa-form-group');
        if (label) {
          var toolLabel = label.querySelector('.tool-label');
          if (toolLabel) toolLabel.textContent = isSignVerify ? 'Signature Algorithm' : 'Cipher Mode';
        }
      }

      var sigGroup = byId('signatureGroup');
      if (sigGroup) sigGroup.hidden = currentMode !== 'verify';

      var byteCounter = byId('byteCounter');
      if (isSignVerify) {
        hideEl(byteCounter);
      } else {
        showEl(byteCounter);
        updateByteCounter();
      }

      if (!btn || !msg) return;

      switch (currentMode) {
        case 'encrypt':
          btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg> Encrypt';
          btn.style.background = '#059669';
          msg.placeholder = 'Enter plaintext message to encrypt...';
          break;
        case 'decrypt':
          btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 019.9-1"/></svg> Decrypt';
          btn.style.background = '#d97706';
          msg.placeholder = 'Enter Base64-encoded ciphertext to decrypt...';
          break;
        case 'sign':
          btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><path d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"/></svg> Sign';
          btn.style.background = '#2563eb';
          msg.placeholder = 'Enter message to sign with private key...';
          break;
        case 'verify':
          btn.innerHTML = '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" style="vertical-align:-2px"><path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg> Verify';
          btn.style.background = '#7c3aed';
          msg.placeholder = 'Enter original message to verify signature...';
          break;
        default:
          break;
      }
    }

    function updateByteCounter() {
      if (currentMode === 'sign' || currentMode === 'verify') return;
      var msg = byId('message');
      var text = msg ? msg.value : '';
      var byteLen = new Blob([text]).size;
      var max = getMaxBytes();
      var byteCount = byId('byteCount');
      var byteMax = byId('byteMax');
      var counter = byId('byteCounter');
      if (byteCount) byteCount.textContent = String(byteLen);
      if (byteMax) byteMax.textContent = max > 0 ? String(max) : '?';
      if (counter) {
        counter.classList.remove('warn', 'over');
        if (max > 0) {
          var pct = byteLen / max;
          if (pct > 0.9) counter.classList.add('over');
          else if (pct > 0.7) counter.classList.add('warn');
        }
      }
    }

    function escapeHtml(str) {
      if (!str) return '';
      return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    }

    function doCopy(text, msg) {
      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.copyToClipboard(text, { showToast: true, toastMessage: msg });
      } else {
        navigator.clipboard.writeText(text);
      }
    }

    function showFieldError(selector, message) {
      var el = $(selector);
      if (el) {
        el.classList.add('rsa-field-invalid');
        el.focus();
      }
      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.showError('Input Required', '#output', [message]);
      }
    }

    function setResultActionsVisible(visible) {
      var actions = byId('resultActions');
      if (actions) actions.classList.toggle('visible', visible);
    }

    function renderEncryptDecryptOutput(response) {
      var isEncrypt = response.operation === 'encrypt';
      var result = isEncrypt ? response.base64Encoded : response.message;
      var html = '<div class="rsa-result-success">';
      html += '<div class="rsa-result-success-header">&#9989; ' + (isEncrypt ? 'Encryption' : 'Decryption') + ' Successful</div>';
      html += '<div class="rsa-result-body">';
      html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> ' + response.operation.toUpperCase() + '</div><div><strong>Algorithm:</strong> ' + escapeHtml(response.algorithm) + '</div></div>';
      if (response.originalMessage) {
        html += '<div style="margin-bottom:0.75rem;"><label class="tool-label">Original</label>';
        html += '<div style="padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;word-break:break-all;">' + escapeHtml(response.originalMessage) + '</div></div>';
      }
      html += '<label class="tool-label">Result</label>';
      html += '<textarea id="resultText" readonly style="width:100%;min-height:100px;padding:0.625rem;border:2px solid var(--border);border-radius:0.5rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;background:var(--bg-secondary);color:var(--text-primary);resize:vertical;">' + escapeHtml(result) + '</textarea>';
      html += '</div></div>';
      var output = byId('output');
      if (output) output.innerHTML = html;
      setResultActionsVisible(true);
      var useForVerify = byId('useForVerify');
      var swapResult = byId('swapResult');
      if (useForVerify) hideBtn(useForVerify);
      if (swapResult) showBtn(swapResult);
      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.showToast(isEncrypt ? 'Encrypted!' : 'Decrypted!', 2000, 'success');
      }
    }

    function renderSignOutput(response) {
      var signature = response.base64Encoded || response.message || '';
      var cipherSelect = byId('cipherSelect');
      var html = '<div class="rsa-result-success">';
      html += '<div class="rsa-result-success-header">&#9989; Signed Successfully</div>';
      html += '<div class="rsa-result-body">';
      html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> SIGN</div><div><strong>Algorithm:</strong> ' + escapeHtml(response.algorithm || (cipherSelect ? cipherSelect.value : '')) + '</div></div>';
      if (response.originalMessage) {
        html += '<div style="margin-bottom:0.75rem;"><label class="tool-label">Original Message</label>';
        html += '<div style="padding:0.5rem;background:var(--bg-secondary);border-radius:0.375rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;word-break:break-all;">' + escapeHtml(response.originalMessage) + '</div></div>';
      }
      html += '<label class="tool-label">Signature (Base64)</label>';
      html += '<textarea id="resultText" readonly style="width:100%;min-height:100px;padding:0.625rem;border:2px solid var(--border);border-radius:0.5rem;font-family:JetBrains Mono,monospace;font-size:0.75rem;background:var(--bg-secondary);color:var(--text-primary);resize:vertical;">' + escapeHtml(signature) + '</textarea>';
      html += '</div></div>';
      var output = byId('output');
      if (output) output.innerHTML = html;
      setResultActionsVisible(true);
      var useForVerify = byId('useForVerify');
      var swapResult = byId('swapResult');
      if (useForVerify) showBtn(useForVerify);
      if (swapResult) hideBtn(swapResult);
      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.showToast('Message signed!', 2000, 'success');
      }
    }

    function renderVerifyOutput(response) {
      var isValid = response.message === 'VALID';
      var resultText = response.base64Encoded || response.message || '';
      var cipherSelect = byId('cipherSelect');
      var html;
      if (isValid) {
        html = '<div class="rsa-result-valid">';
        html += '<div class="rsa-result-valid-header">&#9989; Signature Valid</div>';
      } else {
        html = '<div class="rsa-result-invalid">';
        html += '<div class="rsa-result-invalid-header">&#10060; Signature Invalid</div>';
      }
      html += '<div class="rsa-result-body">';
      html += '<div class="rsa-result-meta"><div><strong>Operation:</strong> VERIFY</div><div><strong>Algorithm:</strong> ' + escapeHtml(response.algorithm || (cipherSelect ? cipherSelect.value : '')) + '</div></div>';
      html += '<div style="margin-top:0.5rem;font-size:0.8125rem;color:var(--text-secondary);">' + escapeHtml(resultText) + '</div>';
      html += '</div></div>';
      var output = byId('output');
      if (output) output.innerHTML = html;
      setResultActionsVisible(true);
      var useForVerify = byId('useForVerify');
      var swapResult = byId('swapResult');
      if (useForVerify) hideBtn(useForVerify);
      if (swapResult) hideBtn(swapResult);
      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.showToast(isValid ? 'Signature verified!' : 'Signature invalid!', 2000, isValid ? 'success' : 'error');
      }
    }

    function renderErrorOutput(response, mode) {
      var errMsg = response.errorMessage || 'Unknown error';
      var shortMsg = errMsg.length > 120 ? errMsg.substring(0, 120) + '...' : errMsg;
      var modeLabels = { encrypt: 'Encryption', decrypt: 'Decryption', sign: 'Signing', verify: 'Verification' };
      var opLabel = modeLabels[mode] || (response.operation
        ? response.operation.charAt(0).toUpperCase() + response.operation.slice(1)
        : '');
      var errHtml = '<div class="tool-alert tool-alert-error" style="margin:0;">';
      errHtml += '<strong>' + (opLabel ? opLabel + ' Failed' : 'Failed') + '</strong>';
      if (response.algorithm) errHtml += ' <span style="opacity:0.7;font-size:0.75rem;">(' + escapeHtml(response.algorithm) + ')</span>';
      errHtml += '<div style="margin-top:0.375rem;">' + escapeHtml(shortMsg) + '</div>';
      if (errMsg.length > 120) {
        errHtml += '<details style="margin-top:0.375rem;"><summary style="cursor:pointer;font-size:0.75rem;opacity:0.8;">Show full error</summary>';
        errHtml += '<div style="margin-top:0.25rem;font-size:0.6875rem;font-family:JetBrains Mono,monospace;white-space:pre-wrap;word-break:break-all;max-height:120px;overflow-y:auto;padding:0.375rem;background:rgba(0,0,0,0.05);border-radius:0.25rem;">' + escapeHtml(errMsg) + '</div></details>';
      }
      errHtml += '</div>';
      var output = byId('output');
      if (output) output.innerHTML = errHtml;
      setResultActionsVisible(false);
    }

    function renderOutput(response) {
      var mode = response._mode || (response.operation === 'encrypt' ? 'encrypt' : 'decrypt');
      if (response.success) {
        if (mode === 'sign') renderSignOutput(response);
        else if (mode === 'verify') renderVerifyOutput(response);
        else renderEncryptDecryptOutput(response);
      } else {
        renderErrorOutput(response, mode);
      }
    }

    function submitRsaForm(e) {
      e.preventDefault();
      var msgEl = byId('message');
      var sigEl = byId('signatureInput');
      var msg = msgEl ? msgEl.value.trim() : '';
      if (msgEl) msgEl.classList.remove('rsa-field-invalid');
      if (sigEl) sigEl.classList.remove('rsa-field-invalid');

      var loadingMsg;
      var methodName;
      var encryptdecryptVal;
      var extraData = {};

      switch (currentMode) {
        case 'encrypt':
          loadingMsg = 'Encrypting with RSA...';
          methodName = 'CALCULATE_RSA';
          encryptdecryptVal = 'encrypt';
          if (!msg) { showFieldError('#message', 'Enter a message to encrypt'); return; }
          break;
        case 'decrypt':
          loadingMsg = 'Decrypting with RSA...';
          methodName = 'CALCULATE_RSA';
          encryptdecryptVal = 'decryprt';
          if (!msg) { showFieldError('#message', 'Enter ciphertext to decrypt'); return; }
          break;
        case 'sign':
          loadingMsg = 'Signing with RSA...';
          methodName = 'RSA_SIGN_VERIFY_MESSAGEE';
          encryptdecryptVal = 'decryprt';
          if (!msg) { showFieldError('#message', 'Enter a message to sign'); return; }
          if (!byId('privatekeyparam').value.trim()) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showError('Private Key Required', '#output', ['A private key is needed for signing']);
            return;
          }
          break;
        case 'verify':
          loadingMsg = 'Verifying RSA signature...';
          methodName = 'RSA_SIGN_VERIFY_MESSAGEE';
          encryptdecryptVal = 'encrypt';
          if (!msg) { showFieldError('#message', 'Enter the original message'); return; }
          var sig = sigEl ? sigEl.value.trim() : '';
          if (!sig) { showFieldError('#signatureInput', 'Paste the Base64 signature to verify'); return; }
          extraData.signature = sig;
          if (!byId('publickeyparam').value.trim()) {
            if (typeof ToolUtils !== 'undefined') ToolUtils.showError('Public Key Required', '#output', ['A public key is needed for verification']);
            return;
          }
          break;
        default:
          return;
      }

      if (typeof ToolUtils !== 'undefined') {
        ToolUtils.showLoading(loadingMsg, '#output');
      } else {
        var output = byId('output');
        if (output) output.innerHTML = '<div style="text-align:center;padding:2rem;">' + loadingMsg + '</div>';
      }
      setResultActionsVisible(false);

      var postData = Object.assign({
        methodName: methodName,
        encryptdecryptparameter: encryptdecryptVal,
        message: msg,
        cipherparameter: byId('cipherSelect').value,
        publickeyparam: byId('publickeyparam').value,
        privatekeyparam: byId('privatekeyparam').value,
      }, extraData);

      var body = new URLSearchParams();
      Object.keys(postData).forEach(function (k) {
        body.append(k, postData[k]);
      });

      fetch('RSAFunctionality', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body.toString(),
      })
        .then(function (r) { return r.json(); })
        .then(function (response) {
          lastResponse = response;
          lastResponse._mode = currentMode;
          renderOutput(response);
        })
        .catch(function (err) {
          if (typeof ToolUtils !== 'undefined') {
            ToolUtils.showError(err.message || 'Request failed', '#output', ['Check your connection', 'Verify input format']);
          } else {
            var out = byId('output');
            if (out) out.innerHTML = '<div class="tool-alert tool-alert-error">Error: ' + escapeHtml(err.message || 'Request failed') + '</div>';
          }
          setResultActionsVisible(false);
        });
    }

    var keygenStatusTimer = null;

    function showKeygenStatus(type, msg) {
      var el = byId('keygenStatus');
      if (!el) return;
      el.className = 'rsa-keygen-status ' + type;
      el.innerHTML = msg;
      clearTimeout(keygenStatusTimer);
      if (type === 'success' || type === 'error') {
        keygenStatusTimer = setTimeout(function () {
          el.className = 'rsa-keygen-status hidden';
        }, 4000);
      }
    }

    function generateNewKeys(size) {
      var newKeysBtn = byId('newKeysBtn');
      var keysPanel = byId('keysPanel');
      var pubTextarea = byId('publickeyparam');
      var privTextarea = byId('privatekeyparam');

      $$('#keySizeChips .rsa-chip').forEach(function (c) { c.classList.remove('selected'); });
      var target = $('#keySizeChips .rsa-chip[data-size="' + size + '"]');
      if (target) target.classList.add('selected');
      var radio = $('input[name="keysize_ui"][value="' + size + '"]');
      if (radio) radio.checked = true;

      if (newKeysBtn) {
        newKeysBtn.disabled = true;
        newKeysBtn.innerHTML = '<span class="rsa-spinner"></span> Generating\u2026';
      }
      if (keysPanel) keysPanel.classList.add('rsa-keys-generating');
      showKeygenStatus('loading', '<span class="rsa-spinner" style="border-color:rgba(102,126,234,0.3);border-top-color:var(--primary);width:12px;height:12px;"></span> Generating ' + size + '-bit RSA key pair\u2026');

      var keysToggle = byId('keysToggle');
      if (keysToggle && !keysToggle.classList.contains('open')) {
        keysToggle.classList.add('open');
        if (keysPanel) keysPanel.classList.add('open');
      }

      var params = new URLSearchParams({ methodName: 'GENERATE_RSA_KEYS', keysize: size });
      fetch('RSAFunctionality', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString(),
      })
        .then(function (r) { return r.json(); })
        .then(function (resp) {
          if (resp.success) {
            pubTextarea.value = resp.publicKey;
            privTextarea.value = resp.privateKey;
            pubTextarea.classList.remove('rsa-key-fresh');
            privTextarea.classList.remove('rsa-key-fresh');
            void pubTextarea.offsetWidth;
            pubTextarea.classList.add('rsa-key-fresh');
            privTextarea.classList.add('rsa-key-fresh');
            var sectionLabel = $('.rsa-section-label');
            if (sectionLabel) sectionLabel.innerHTML = '&#128207; RSA Key Size (' + resp.keySize + '-bit active)';
            updateByteCounter();
            showKeygenStatus('success', '&#9989; ' + resp.keySize + '-bit keys generated successfully');
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast(resp.keySize + '-bit keys generated!', 2000, 'success');
          } else {
            showKeygenStatus('error', '&#10060; ' + (resp.errorMessage || 'Key generation failed'));
            if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Key generation failed: ' + (resp.errorMessage || 'Unknown error'), 3000, 'error');
          }
        })
        .catch(function () {
          showKeygenStatus('error', '&#10060; Connection error - please try again');
          if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Key generation failed - check connection', 3000, 'error');
        })
        .finally(function () {
          if (newKeysBtn) {
            newKeysBtn.disabled = false;
            newKeysBtn.innerHTML = '&#128260; New Keys';
          }
          if (keysPanel) keysPanel.classList.remove('rsa-keys-generating');
        });
    }

    function setOpMode(mode) {
      $$('.rsa-op-btn').forEach(function (b) { b.classList.remove('active'); });
      var radio = $('input[name="op_mode"][value="' + mode + '"]');
      if (radio) radio.checked = true;
      var btn = $('.rsa-op-btn[data-op="' + mode + '"]');
      if (btn) btn.classList.add('active');
      syncOperationUI();
    }

    function closeShareModal() {
      var modal = byId('shareModal');
      if (modal) modal.classList.remove('active');
    }

    function buildRsaCode(template) {
      switch (template) {
        case 'encrypt':
          return 'from Crypto.PublicKey import RSA\nfrom Crypto.Cipher import PKCS1_OAEP\nimport base64\n\n'
            + '# Generate RSA key pair\nkey = RSA.generate(2048)\npub_key = key.publickey()\n\n'
            + '# Encrypt\ncipher = PKCS1_OAEP.new(pub_key)\nmessage = b"Hello, RSA encryption!"\n'
            + 'encrypted = cipher.encrypt(message)\nprint("Encrypted (base64):", base64.b64encode(encrypted).decode())\n\n'
            + '# Decrypt\ndecipher = PKCS1_OAEP.new(key)\ndecrypted = decipher.decrypt(encrypted)\nprint("Decrypted:", decrypted.decode())';
        case 'keygen':
          return 'from Crypto.PublicKey import RSA\n\n# Generate 2048-bit RSA key pair\nkey = RSA.generate(2048)\n\n'
            + '# Export keys in PEM format\npub_pem = key.publickey().export_key().decode()\npriv_pem = key.export_key().decode()\n\n'
            + 'print("=== PUBLIC KEY ===")\nprint(pub_pem[:200] + "...")\nprint("\\n=== KEY INFO ===")\n'
            + 'print("Key size:", key.size_in_bits(), "bits")\nprint("Public exponent:", key.e)\nprint("Modulus (first 40 hex):", hex(key.n)[:42] + "...")';
        case 'oaep':
          return 'from Crypto.PublicKey import RSA\nfrom Crypto.Cipher import PKCS1_OAEP\nfrom Crypto.Hash import SHA256\nimport base64\n\n'
            + '# Generate key\nkey = RSA.generate(2048)\n\n'
            + '# OAEP with SHA-256 (recommended)\ncipher = PKCS1_OAEP.new(key.publickey(), hashAlgo=SHA256)\nmessage = b"Secure message with OAEP SHA-256"\n'
            + 'encrypted = cipher.encrypt(message)\nprint("OAEP SHA-256 encrypted:", base64.b64encode(encrypted).decode()[:60] + "...")\n\n'
            + '# Decrypt\ndecipher = PKCS1_OAEP.new(key, hashAlgo=SHA256)\ndecrypted = decipher.decrypt(encrypted)\nprint("Decrypted:", decrypted.decode())\nprint("\\nMax message size (2048-bit OAEP SHA-256):", (2048//8) - 2*32 - 2, "bytes")';
        case 'sign':
          return 'from Crypto.PublicKey import RSA\nfrom Crypto.Signature import pkcs1_15\nfrom Crypto.Hash import SHA256\n\n'
            + '# Generate key\nkey = RSA.generate(2048)\n\n# Sign\nmessage = b"Message to sign"\n'
            + 'h = SHA256.new(message)\nsignature = pkcs1_15.new(key).sign(h)\nprint("Signature (hex):", signature.hex()[:80] + "...")\n\n'
            + '# Verify\ntry:\n    pkcs1_15.new(key.publickey()).verify(SHA256.new(message), signature)\n    print("Signature valid!")\n'
            + 'except ValueError:\n    print("Signature invalid!")';
        default:
          return '';
      }
    }

    function loadRsaCompiler() {
      var templateEl = byId('rsaCompilerTemplate');
      var iframe = byId('rsaCompilerIframe');
      if (!templateEl || !iframe) return;
      var code = buildRsaCode(templateEl.value);
      var b64Code = btoa(unescape(encodeURIComponent(code)));
      var config = JSON.stringify({ lang: 'python', code: b64Code });
      iframe.src = ctxPath + '/onecompiler-embed.jsp?c=' + encodeURIComponent(config);
    }

    // --- Event wiring ---

    var messageEl = byId('message');
    if (messageEl) {
      messageEl.addEventListener('input', function () {
        messageEl.classList.remove('rsa-field-invalid');
        updateByteCounter();
      });
    }

    var cipherSelect = byId('cipherSelect');
    if (cipherSelect) cipherSelect.addEventListener('change', updateByteCounter);

    $$('.rsa-op-btn').forEach(function (btn) {
      btn.addEventListener('click', function () {
        $$('.rsa-op-btn').forEach(function (b) { b.classList.remove('active'); });
        btn.classList.add('active');
        var input = btn.querySelector('input');
        if (input) input.checked = true;
        syncOperationUI();
      });
    });

    syncOperationUI();

    $$('#keySizeChips .rsa-chip').forEach(function (chip) {
      chip.addEventListener('click', function () {
        generateNewKeys(chip.dataset.size);
      });
    });

    var newKeysBtn = byId('newKeysBtn');
    if (newKeysBtn) {
      newKeysBtn.addEventListener('click', function () {
        var checked = $('input[name="keysize_ui"]:checked');
        generateNewKeys(checked ? checked.value : defaultKeySize);
      });
    }

    var keysToggle = byId('keysToggle');
    var keysPanel = byId('keysPanel');
    if (keysToggle && keysPanel) {
      keysToggle.addEventListener('click', function () {
        keysToggle.classList.toggle('open');
        keysPanel.classList.toggle('open');
      });
    }

    var copyPublic = byId('copyPublic');
    if (copyPublic) copyPublic.addEventListener('click', function () { doCopy(byId('publickeyparam').value, 'Public key copied!'); });
    var copyPrivate = byId('copyPrivate');
    if (copyPrivate) copyPrivate.addEventListener('click', function () { doCopy(byId('privatekeyparam').value, 'Private key copied!'); });
    var copyBothKeys = byId('copyBothKeys');
    if (copyBothKeys) {
      copyBothKeys.addEventListener('click', function () {
        var both = '=== PUBLIC KEY ===\n' + byId('publickeyparam').value + '\n\n=== PRIVATE KEY ===\n' + byId('privatekeyparam').value;
        doCopy(both, 'Both keys copied!');
      });
    }

    var rsaForm = byId('rsaForm');
    if (rsaForm) rsaForm.addEventListener('submit', submitRsaForm);

    var copyResult = byId('copyResult');
    if (copyResult) {
      copyResult.addEventListener('click', function () {
        var resultText = byId('resultText');
        if (resultText && resultText.value) doCopy(resultText.value, 'Result copied!');
      });
    }

    var swapResult = byId('swapResult');
    if (swapResult) {
      swapResult.addEventListener('click', function () {
        var resultText = byId('resultText');
        if (!resultText || !resultText.value) return;
        byId('message').value = resultText.value;
        if (lastResponse && lastResponse.operation === 'encrypt') setOpMode('decrypt');
        else setOpMode('encrypt');
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Result swapped to input!', 2000, 'info');
      });
    }

    var useForVerify = byId('useForVerify');
    if (useForVerify) {
      useForVerify.addEventListener('click', function () {
        var resultText = byId('resultText');
        if (!resultText || !resultText.value) return;
        setOpMode('verify');
        byId('signatureInput').value = resultText.value;
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Switched to Verify mode - signature populated!', 3000, 'info');
      });
    }

    var shareUrlBtn = byId('shareUrl');
    if (shareUrlBtn) {
      shareUrlBtn.addEventListener('click', function () {
        var resultText = byId('resultText');
        if (!resultText || !resultText.value) return;
        var publicKey = byId('publickeyparam').value;
        var privateKey = byId('privatekeyparam').value;
        var includesPrivateKey = privateKey && privateKey.trim().length > 0;
        var params = new URLSearchParams({
          msg: resultText.value,
          op: lastResponse && lastResponse.operation === 'encrypt' ? 'decrypt' : 'encrypt',
          algo: lastResponse ? lastResponse.algorithm : '',
        });
        if (publicKey && publicKey.trim()) params.append('pubkey', publicKey);
        if (privateKey && privateKey.trim()) params.append('privkey', privateKey);
        var shareUrl = window.location.origin + window.location.pathname + '?' + params.toString();
        var warning;
        if (includesPrivateKey) {
          warning = '<div class="tool-alert tool-alert-error" style="margin-bottom:0.75rem;font-size:0.8125rem;"><strong>&#9888; DANGER: Private Key Included!</strong><br>Anyone with this URL can decrypt ALL messages encrypted with your public key. Only share in trusted, secure channels.</div>';
        } else {
          warning = '<div class="tool-alert tool-alert-info" style="margin-bottom:0.75rem;font-size:0.8125rem;"><strong>&#128274; Public key and encrypted content included.</strong> Private key is NOT shared. URL will be long (RSA keys are 1000+ chars).</div>';
        }
        var shareWarningContent = byId('shareWarningContent');
        var shareUrlText = byId('shareUrlText');
        var shareModal = byId('shareModal');
        if (shareWarningContent) shareWarningContent.innerHTML = warning;
        if (shareUrlText) shareUrlText.value = shareUrl;
        if (shareModal) shareModal.classList.add('active');
      });
    }

    var shareModal = byId('shareModal');
    if (shareModal) {
      shareModal.addEventListener('click', function (e) {
        if (e.target === shareModal) closeShareModal();
      });
    }

    var shareModalCancel = $('.rsa-modal-cancel');
    if (shareModalCancel) shareModalCancel.addEventListener('click', closeShareModal);

    var copyShareUrl = byId('copyShareUrl');
    if (copyShareUrl) {
      copyShareUrl.addEventListener('click', function () {
        doCopy(byId('shareUrlText').value, 'Share URL copied!');
      });
    }

    var urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('msg')) {
      byId('message').value = urlParams.get('msg');
      if (urlParams.get('op') === 'decrypt') setOpMode('decrypt');
      if (urlParams.has('algo')) byId('cipherSelect').value = urlParams.get('algo');
      if (urlParams.has('pubkey')) byId('publickeyparam').value = urlParams.get('pubkey');
      if (urlParams.has('privkey')) {
        byId('privatekeyparam').value = urlParams.get('privkey');
        if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Private key loaded from URL - handle with care!', 5000, 'error');
      }
      if (typeof ToolUtils !== 'undefined') ToolUtils.showToast('Shared RSA data loaded!', 3000, 'success');
    }

    $$('.rsa-output-tab').forEach(function (tab) {
      tab.addEventListener('click', function () {
        var panel = tab.dataset.panel;
        $$('.rsa-output-tab').forEach(function (t) { t.classList.remove('active'); });
        tab.classList.add('active');
        $$('.rsa-panel').forEach(function (p) { p.classList.remove('active'); });
        var panelEl = byId('rsa-panel-' + panel);
        if (panelEl) panelEl.classList.add('active');
        if (panel === 'python' && !rsaCompilerLoaded) {
          loadRsaCompiler();
          rsaCompilerLoaded = true;
        }
      });
    });

    var rsaCompilerTemplate = byId('rsaCompilerTemplate');
    if (rsaCompilerTemplate) {
      rsaCompilerTemplate.addEventListener('change', function () {
        rsaCompilerLoaded = false;
        loadRsaCompiler();
        rsaCompilerLoaded = true;
      });
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    if (window.__rsaPage) init(window.__rsaPage);
  });
}());
