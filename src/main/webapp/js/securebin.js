(function () {
    'use strict';

    var CFG = window.SECUREBIN_CONFIG || {};
    var API_BASE = CFG.apiBase || 'pastebin';
    var CTX = CFG.ctxPath || '';
    var SHORTCODE = CFG.shortcode || '';

    var $  = function (id) { return document.getElementById(id); };
    var $$ = function (sel, root) { return (root || document).querySelectorAll(sel); };

    var GONE_MSG = 'This link is no longer available.\n\n' +
        'It may have been viewed already, expired, or never existed.\n\n' +
        'If you still need the secret, ask the sender for a new link.';

    // ---------- AES-256-GCM helpers ----------
    function deriveKey(password) {
        return crypto.subtle.digest('SHA-256', new TextEncoder().encode(password))
            .then(function (keyBuffer) {
                return crypto.subtle.importKey('raw', keyBuffer, 'AES-GCM', false, ['encrypt', 'decrypt']);
            });
    }

    function encryptText(text, password) {
        var iv = crypto.getRandomValues(new Uint8Array(12));
        return deriveKey(password)
            .then(function (key) {
                return crypto.subtle.encrypt({ name: 'AES-GCM', iv: iv }, key, new TextEncoder().encode(text));
            })
            .then(function (ct) {
                var out = new Uint8Array(iv.length + ct.byteLength);
                out.set(iv, 0);
                out.set(new Uint8Array(ct), iv.length);
                return out;
            });
    }

    function decryptBytes(bytes, password) {
        return deriveKey(password)
            .then(function (key) {
                return crypto.subtle.decrypt(
                    { name: 'AES-GCM', iv: bytes.slice(0, 12) },
                    key,
                    bytes.slice(12)
                );
            })
            .then(function (buf) { return new TextDecoder().decode(buf); });
    }

    // ---------- Strong password (CSPRNG) ----------
    function generatePassword(length) {
        var charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+';
        var pwd = '';
        var rand = new Uint32Array(length);
        crypto.getRandomValues(rand);
        for (var i = 0; i < length; i++) pwd += charset.charAt(rand[i] % charset.length);
        return pwd;
    }

    // ---------- Copy / reveal helpers ----------
    function copyText(text) {
        if (navigator.clipboard && navigator.clipboard.writeText) {
            return navigator.clipboard.writeText(text);
        }
        return new Promise(function (resolve, reject) {
            try {
                var ta = document.createElement('textarea');
                ta.value = text;
                ta.style.position = 'fixed'; ta.style.opacity = '0';
                document.body.appendChild(ta);
                ta.focus(); ta.select();
                var ok = document.execCommand('copy');
                document.body.removeChild(ta);
                ok ? resolve() : reject(new Error('copy failed'));
            } catch (e) { reject(e); }
        });
    }

    function flashCopied(btn, ok) {
        if (!btn) return;
        var original = btn.innerHTML;
        var prevDisabled = btn.disabled;
        btn.disabled = true;
        btn.innerHTML = ok === false ? 'Failed' : 'Copied';
        setTimeout(function () {
            btn.disabled = prevDisabled;
            btn.innerHTML = original;
        }, 1500);
    }

    function copyFromInput(inputId, btn) {
        var el = $(inputId);
        if (!el) return;
        copyText(el.value).then(function () { flashCopied(btn, true); })
                         .catch(function () { flashCopied(btn, false); });
    }

    function togglePasswordVisible(inputId, btn) {
        var el = $(inputId);
        if (!el) return;
        if (el.type === 'password') {
            el.type = 'text';
            if (btn) btn.textContent = 'Hide';
        } else {
            el.type = 'password';
            if (btn) btn.textContent = 'Show';
        }
    }

    // ---------- POST/GET wrappers (urlencoded form for /pastebin) ----------
    function postForm(url, params) {
        var body = Object.keys(params)
            .map(function (k) { return encodeURIComponent(k) + '=' + encodeURIComponent(params[k]); })
            .join('&');
        return fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'Accept': 'application/json' },
            body: body
        }).then(function (r) {
            if (!r.ok) throw new Error('HTTP ' + r.status);
            return r.json();
        });
    }

    function getJson(url) {
        return fetch(url, { headers: { 'Accept': 'application/json' }, credentials: 'same-origin' })
            .then(function (r) {
                if (!r.ok) {
                    var err = new Error('HTTP ' + r.status);
                    err.status = r.status;
                    throw err;
                }
                return r.json();
            });
    }

    // ─────────────────────────────────────────────────────────────────────────
    // CREATE MODE
    // ─────────────────────────────────────────────────────────────────────────
    function initCreate() {
        var $email      = $('sb-email');
        var $text       = $('sb-text');
        var $expiry     = $('sb-expiry');
        var $maxViews   = $('sb-max-views');
        var $createBtn  = $('sb-create-btn');
        var $resetBtn   = $('sb-reset-btn');
        var $charCount  = $('sb-char-count');
        var $validError = $('sb-validation-error');
        var $progress   = $('sb-progress');
        var $progressBar= $('sb-progress-bar');
        var $result     = $('sb-result-container');

        if (!$text || !$createBtn) return;

        function syncBtn() {
            var v = ($text.value || '').trim();
            $createBtn.disabled = v.length === 0;
            if ($charCount) $charCount.textContent = ($text.value || '').length;
        }
        $text.addEventListener('input', function () {
            syncBtn();
            if ($validError) $validError.classList.remove('show');
            $text.style.borderColor = '';
        });
        syncBtn();

        if ($resetBtn) {
            $resetBtn.addEventListener('click', function () {
                $text.value = '';
                if ($email) $email.value = '';
                if ($expiry) $expiry.value = '86400';
                if ($maxViews) $maxViews.value = '1';
                syncBtn();
                renderEmpty();
                hideProgress();
            });
        }

        $createBtn.addEventListener('click', function () { doCreate(); });

        function renderEmpty() {
            if (!$result) return;
            $result.innerHTML =
                '<div class="sb-result-empty">' +
                '<svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M3 12h18M3 6h18M3 18h18"/></svg>' +
                '<div>Enter your secret and click <strong>Create Encrypted Secret</strong> to generate a secure link.</div>' +
                '</div>';
        }

        function hideProgress() {
            if (!$progress) return;
            $progress.classList.remove('show');
            if ($progressBar) {
                $progressBar.style.width = '0';
                $progressBar.setAttribute('aria-valuenow', '0');
            }
        }

        function setProgress(pct) {
            if (!$progress || !$progressBar) return;
            $progress.classList.add('show');
            $progressBar.style.width = pct + '%';
            $progressBar.setAttribute('aria-valuenow', String(pct));
            if (pct >= 100) setTimeout(hideProgress, 800);
        }

        function setBtnError(text) {
            $createBtn.disabled = false;
            $createBtn.innerHTML = text;
            $createBtn.classList.add('sb-btn-danger');
            setTimeout(function () {
                $createBtn.innerHTML = lockIcon() + ' Create Encrypted Secret';
                $createBtn.classList.remove('sb-btn-danger');
                syncBtn();
            }, 3500);
        }

        function lockIcon() {
            return '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>';
        }

        function doCreate() {
            var text = ($text.value || '').trim();
            if (!text) {
                if ($validError) $validError.classList.add('show');
                $text.classList.add('sb-shake');
                $text.style.borderColor = 'var(--sb-danger)';
                setTimeout(function () { $text.classList.remove('sb-shake'); }, 500);
                $text.focus();
                return;
            }
            if ($validError) $validError.classList.remove('show');

            $createBtn.disabled = true;
            $createBtn.innerHTML = '<span class="sb-spinner" style="width:14px;height:14px;border-width:2px;display:inline-block;vertical-align:-2px;margin-right:6px"></span>Encrypting...';

            var password = generatePassword(16);
            var expiry = $expiry ? $expiry.value : '86400';
            var maxViews = $maxViews ? $maxViews.value : '1';
            var email = $email ? $email.value : '';

            encryptText(text, password)
                .then(function (bytes) {
                    return postForm(API_BASE, {
                        email: email,
                        isEncrypted: 'true',
                        expirySeconds: expiry,
                        maxViews: maxViews
                    }).then(function (payload) {
                        return uploadToS3(payload.presignedUrl, bytes).then(function () { return payload; });
                    });
                })
                .then(function (payload) {
                    renderSuccess({
                        shortCode: payload.shortCode,
                        password: password,
                        expiry: expiry,
                        maxViews: maxViews
                    });
                    if (email && email.indexOf('@') > 0) {
                        // Fire-and-forget email notification.
                        postForm(API_BASE, { email: email, sendEmail: 'true', shortcode: payload.shortCode })
                            .catch(function () {});
                    }
                    $createBtn.disabled = false;
                    $createBtn.innerHTML = lockIcon() + ' Secret Created';
                    setTimeout(function () {
                        $createBtn.innerHTML = lockIcon() + ' Create Encrypted Secret';
                        syncBtn();
                    }, 2500);
                })
                .catch(function (err) {
                    if (window.console && console.error) console.error('Create failed:', err);
                    if ($result) {
                        $result.innerHTML =
                            '<div class="sb-banner sb-banner-danger">' +
                            '<strong>Upload failed.</strong> Unable to create the encrypted secret. Please try again.' +
                            '</div>';
                    }
                    setBtnError('Failed — Try Again');
                });
        }

        function uploadToS3(presignedUrl, bytes) {
            return new Promise(function (resolve, reject) {
                var xhr = new XMLHttpRequest();
                xhr.open('PUT', presignedUrl);
                xhr.upload.onprogress = function (e) {
                    if (e.lengthComputable) setProgress(Math.round((e.loaded / e.total) * 100));
                };
                xhr.onload = function () {
                    if (xhr.status >= 200 && xhr.status < 300) {
                        setProgress(100);
                        resolve();
                    } else {
                        reject(new Error('S3 PUT ' + xhr.status));
                    }
                };
                xhr.onerror = function () { reject(new Error('S3 PUT network error')); };
                xhr.setRequestHeader('Content-Type', 'application/octet-stream');
                xhr.send(new Blob([bytes], { type: 'application/octet-stream' }));
            });
        }

        function escapeHtml(s) {
            return String(s)
                .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
        }

        function renderSuccess(o) {
            var expiryLabel = ({
                '300': '5 minutes', '3600': '1 hour', '86400': '24 hours', '604800': '7 days'
            })[String(o.expiry)] || (o.expiry + ' seconds');
            var viewsLabel = ({
                '1': 'burns after the first view',
                '3': 'viewable up to 3 times',
                '5': 'viewable up to 5 times',
                '0': 'unlimited views until expiry'
            })[String(o.maxViews)] || (o.maxViews + ' views');

            var viewUrl = window.location.origin + (CTX || '') + '/securebin.jsp?q=' + encodeURIComponent(o.shortCode);

            var html =
                '<div class="sb-card">' +
                '  <div class="sb-card-header"><span>Secret Created</span></div>' +
                '  <div class="sb-card-body">' +
                '    <div class="sb-field">' +
                '      <label class="sb-label" for="sb-url-out">View URL</label>' +
                '      <div class="sb-input-group">' +
                '        <input id="sb-url-out" class="sb-input sb-mono" type="text" readonly value="' + escapeHtml(viewUrl) + '">' +
                '        <button type="button" class="sb-input-group-btn" data-sb-copy="sb-url-out">Copy</button>' +
                '        <a class="sb-input-group-btn is-primary" href="' + escapeHtml(viewUrl) + '" target="_blank" rel="noopener">Open</a>' +
                '      </div>' +
                '    </div>' +
                '    <div class="sb-field">' +
                '      <label class="sb-label" for="sb-pwd-out">Password</label>' +
                '      <div class="sb-input-group">' +
                '        <input id="sb-pwd-out" class="sb-input sb-mono" type="password" readonly value="' + escapeHtml(o.password) + '">' +
                '        <button type="button" class="sb-input-group-btn" data-sb-toggle="sb-pwd-out">Show</button>' +
                '        <button type="button" class="sb-input-group-btn" data-sb-copy="sb-pwd-out">Copy</button>' +
                '      </div>' +
                '      <div class="sb-meta-row"><span>Share the URL and password via different channels.</span></div>' +
                '    </div>' +
                '    <div class="sb-btn-row" style="margin-top:0.75rem">' +
                '      <button type="button" class="sb-btn" data-sb-copy-both>Copy Both</button>' +
                '      <button type="button" class="sb-btn sb-btn-secondary" data-sb-create-another>Create Another</button>' +
                '    </div>' +
                '    <div class="sb-banner sb-banner-info" style="margin-top:0.875rem;margin-bottom:0">' +
                '      Expires in <strong>' + expiryLabel + '</strong> and <strong>' + viewsLabel + '</strong>. Password required to decrypt.' +
                '    </div>' +
                '  </div>' +
                '</div>';

            $result.innerHTML = html;

            $$('[data-sb-copy]', $result).forEach(function (b) {
                b.addEventListener('click', function () { copyFromInput(b.getAttribute('data-sb-copy'), b); });
            });
            $$('[data-sb-toggle]', $result).forEach(function (b) {
                b.addEventListener('click', function () { togglePasswordVisible(b.getAttribute('data-sb-toggle'), b); });
            });
            var both = $result.querySelector('[data-sb-copy-both]');
            if (both) both.addEventListener('click', function () {
                var u = $('sb-url-out'); var p = $('sb-pwd-out');
                if (!u || !p) return;
                copyText('URL: ' + u.value + '\nPassword: ' + p.value).then(function () { flashCopied(both, true); })
                                                                      .catch(function () { flashCopied(both, false); });
            });
            var again = $result.querySelector('[data-sb-create-another]');
            if (again) again.addEventListener('click', function () {
                if ($resetBtn) $resetBtn.click();
                if ($text) $text.focus();
            });
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // VIEW MODE
    // ─────────────────────────────────────────────────────────────────────────
    function initView() {
        var $gate     = $('sb-reveal-gate');
        var $revealBtn= $('sb-reveal-btn');
        var $secretWrap= $('sb-secret-wrap');
        var $loading  = $('sb-loading');
        var $decrypted= $('sb-decrypted');
        var $success  = $('sb-success-banner');
        var $copyBtn  = $('sb-decrypt-copy');
        var $wrapBtn  = $('sb-decrypt-wrap');
        var $dlBtn    = $('sb-decrypt-download');
        var $charView = $('sb-char-view');
        var $dialog   = $('sb-password-dialog');
        var $pwdInput = $('sb-password-input');
        var $pwdErr   = $('sb-password-error');
        var $pwdShow  = $('sb-password-show');
        var $pwdSubmit= $('sb-password-submit');
        var $pwdCancel= $('sb-password-cancel');

        if (!$revealBtn) return;

        function showGoneError() {
            if ($loading) $loading.style.display = 'none';
            if ($decrypted) {
                $decrypted.style.display = '';
                $decrypted.value = GONE_MSG;
                $decrypted.classList.add('is-error');
                $decrypted.classList.remove('is-revealed');
                updateCharCount();
            }
        }

        function showDecryptError() {
            if ($loading) $loading.style.display = 'none';
            if ($decrypted) {
                $decrypted.style.display = '';
                $decrypted.value = 'Decryption failed.\n\nThe password is incorrect, or the link points at a corrupted secret.\n\nCheck the password from the sender (watch for trailing spaces) and try again.';
                $decrypted.classList.add('is-error');
                $decrypted.classList.remove('is-revealed');
                updateCharCount();
            }
        }

        function updateCharCount() {
            if ($charView && $decrypted) $charView.textContent = ($decrypted.value || '').length;
        }

        $revealBtn.addEventListener('click', function () {
            if ($gate) $gate.style.display = 'none';
            if ($secretWrap) $secretWrap.style.display = '';
            startResolve();
        });

        function startResolve() {
            if ($loading) $loading.style.display = '';
            if ($decrypted) $decrypted.style.display = 'none';

            getJson(API_BASE + '?shortcode=' + encodeURIComponent(SHORTCODE))
                .then(function (payload) {
                    // payload is parsed object (fetch always returns JSON when we call .json()).
                    if (!payload || !payload.presignedUrl) { showGoneError(); return; }
                    var fileName = (payload.presignedUrl.split('?')[0] || '').split('/').pop();
                    if (fileName && fileName.indexOf('ENC') !== -1) {
                        openPasswordDialog(payload.presignedUrl);
                    } else {
                        fetchPlaintext(payload.presignedUrl);
                    }
                })
                .catch(function (err) {
                    if (window.console && console.error) console.error('Resolve failed:', err && err.status);
                    showGoneError();
                });
        }

        function fetchPlaintext(presignedUrl) {
            fetch(presignedUrl)
                .then(function (r) {
                    if (!r.ok) throw new Error('S3 ' + r.status);
                    return r.arrayBuffer();
                })
                .then(function (buf) {
                    var raw = new TextDecoder().decode(buf);
                    var text;
                    try { text = atob(raw); } catch (e) { text = raw; }
                    revealText(text);
                })
                .catch(function () { showGoneError(); });
        }

        function openPasswordDialog(presignedUrl) {
            if ($loading) $loading.style.display = 'none';
            if (!$dialog || typeof $dialog.showModal !== 'function') {
                // Fallback: prompt()
                var p = window.prompt('Enter decryption password:');
                if (p == null) { showGoneError(); return; }
                doDecrypt(presignedUrl, p);
                return;
            }
            if ($pwdErr) $pwdErr.classList.remove('show');
            if ($pwdInput) { $pwdInput.value = ''; $pwdInput.type = 'password'; }
            if ($pwdShow) $pwdShow.textContent = 'Show';
            $dialog.showModal();
            setTimeout(function () { if ($pwdInput) $pwdInput.focus(); }, 50);

            function submit() {
                var pwd = ($pwdInput && $pwdInput.value) || '';
                if (!pwd) {
                    if ($pwdErr) {
                        $pwdErr.textContent = 'Password required.';
                        $pwdErr.classList.add('show');
                    }
                    return;
                }
                $dialog.close();
                if ($loading) {
                    $loading.style.display = '';
                    var msg = $('sb-loading-msg');
                    if (msg) msg.textContent = 'Decrypting with AES-256-GCM...';
                }
                doDecrypt(presignedUrl, pwd);
            }

            $pwdSubmit.onclick = submit;
            $pwdInput.onkeypress = function (e) { if (e.key === 'Enter') submit(); };
            $pwdCancel.onclick = function () { $dialog.close(); showGoneError(); };
            $pwdShow.onclick = function () { togglePasswordVisible('sb-password-input', $pwdShow); };
        }

        function doDecrypt(presignedUrl, password) {
            var fetchOk = false;
            fetch(presignedUrl)
                .then(function (r) {
                    if (!r.ok) throw new Error('S3 ' + r.status);
                    fetchOk = true;
                    return r.arrayBuffer();
                })
                .then(function (buf) { return decryptBytes(new Uint8Array(buf), password); })
                .then(function (text) { revealText(text); })
                .catch(function () {
                    if (fetchOk) showDecryptError(); else showGoneError();
                });
        }

        function revealText(text) {
            if ($loading) $loading.style.display = 'none';
            if ($decrypted) {
                $decrypted.style.display = '';
                $decrypted.value = text;
                $decrypted.classList.add('is-revealed');
                $decrypted.classList.remove('is-error');
                var lines = (text || '').split('\n').length;
                $decrypted.rows = Math.max(10, Math.min(lines + 2, 25));
                updateCharCount();
            }
            if ($success) $success.style.display = '';
        }

        if ($copyBtn) $copyBtn.addEventListener('click', function () {
            if (!$decrypted) return;
            copyText($decrypted.value || '').then(function () { flashCopied($copyBtn, true); })
                                            .catch(function () { flashCopied($copyBtn, false); });
        });
        if ($wrapBtn) $wrapBtn.addEventListener('click', function () {
            if (!$decrypted) return;
            var current = $decrypted.style.whiteSpace;
            if (current === 'pre' ) { $decrypted.style.whiteSpace = 'pre-wrap'; $wrapBtn.textContent = 'No Wrap'; }
            else { $decrypted.style.whiteSpace = 'pre'; $wrapBtn.textContent = 'Wrap'; }
        });
        if ($dlBtn) $dlBtn.addEventListener('click', function () {
            if (!$decrypted) return;
            var blob = new Blob([$decrypted.value || ''], { type: 'text/plain;charset=utf-8' });
            var url = URL.createObjectURL(blob);
            var a = document.createElement('a');
            a.href = url; a.download = 'secret.txt';
            document.body.appendChild(a); a.click();
            setTimeout(function () { document.body.removeChild(a); URL.revokeObjectURL(url); }, 0);
        });

        // Live char count
        setInterval(updateCharCount, 600);
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Boot
    // ─────────────────────────────────────────────────────────────────────────
    function boot() {
        if (SHORTCODE) initView();
        else initCreate();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', boot);
    } else {
        boot();
    }
})();
