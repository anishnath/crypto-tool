(function() {
    'use strict';

    // ── Configuration (set by JSP before this script loads) ──
    var API_BASE = window.PASTEBIN_CONFIG.apiBase;
    var CTX_PATH = window.PASTEBIN_CONFIG.ctxPath;

    // ── DOM refs ──
    var $title      = document.getElementById('pb-title');
    var $content    = document.getElementById('pb-content');
    var $expiry     = document.getElementById('pb-expiry');
    var $visibility = document.getElementById('pb-visibility');
    var $syntax     = document.getElementById('pb-syntax');
    var $burn       = document.getElementById('pb-burn');
    var $passphrase = document.getElementById('pb-passphrase');
    var $passWrap   = document.getElementById('pb-passphrase-wrap');
    var $submitBtn  = document.getElementById('pb-submit');
    var $charCount  = document.getElementById('pb-char-count');
    var $error      = document.getElementById('pb-error');
    var $result     = document.getElementById('pb-result');
    var $view       = document.getElementById('pb-view');
    var $transforms = document.getElementById('pb-transforms');
    var $dropzone   = document.getElementById('pb-dropzone');
    var $fileInput  = document.getElementById('pb-file-input');
    var $fileSelected = document.getElementById('pb-file-selected');

    var currentMode = 'text';       // 'text' or 'file'
    var selectedFile = null;
    var myPastesOffset = 0;
    var myPastesLimit = 20;

    // ── Tabs ──
    document.querySelectorAll('.pb-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.pb-tab').forEach(function(t) { t.classList.remove('active'); t.setAttribute('aria-selected', 'false'); });
            document.querySelectorAll('.pb-panel').forEach(function(p) { p.classList.remove('active'); });
            tab.classList.add('active');
            tab.setAttribute('aria-selected', 'true');
            document.getElementById('panel-' + tab.dataset.tab).classList.add('active');
        });
    });

    // ── Mode toggle (text/file) ──
    document.querySelectorAll('.pb-mode-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.pb-mode-btn').forEach(function(b) { b.classList.remove('active'); });
            btn.classList.add('active');
            currentMode = btn.dataset.mode;
            if (currentMode === 'file') {
                $content.style.display = 'none';
                if ($transforms) $transforms.style.display = 'none';
                $dropzone.classList.add('active');
                $burn.closest('label').style.display = 'none';
                $syntax.closest('.pb-opt-group').style.display = 'none';
            } else {
                $content.style.display = '';
                if ($transforms) $transforms.style.display = '';
                $dropzone.classList.remove('active');
                $fileSelected.classList.remove('show');
                selectedFile = null;
                $burn.closest('label').style.display = '';
                $syntax.closest('.pb-opt-group').style.display = '';
            }
        });
    });

    // ── Visibility → passphrase ──
    $visibility.addEventListener('change', function() {
        $passWrap.classList.toggle('show', this.value === 'private');
    });

    // ── Character count + auto-detect syntax via highlight.js ──
    var syntaxManuallySet = false;
    var detectTimer = null;

    // Map hljs language names to our dropdown values
    var HLJS_TO_SYNTAX = {
        'javascript': 'javascript', 'js': 'javascript', 'typescript': 'javascript',
        'python': 'python', 'py': 'python',
        'java': 'java',
        'xml': 'xml', 'html': 'html',
        'css': 'css', 'scss': 'css', 'less': 'css',
        'json': 'json',
        'sql': 'sql',
        'bash': 'bash', 'shell': 'bash', 'sh': 'bash', 'zsh': 'bash',
        'go': 'go', 'golang': 'go',
        'rust': 'rust', 'rs': 'rust',
        'c': 'c',
        'cpp': 'cpp', 'c++': 'cpp',
        'yaml': 'yaml', 'yml': 'yaml',
        'markdown': 'markdown', 'md': 'markdown'
    };

    function detectSyntax(text) {
        if (!text || text.length < 10 || typeof hljs === 'undefined') return null;
        try {
            var result = hljs.highlightAuto(text);
            if (result.language && result.relevance > 5) {
                return HLJS_TO_SYNTAX[result.language] || null;
            }
        } catch(e) {}
        return null;
    }

    $syntax.addEventListener('change', function() {
        syntaxManuallySet = true;
    });

    $content.addEventListener('input', function() {
        var len = this.value.length;
        $charCount.textContent = len.toLocaleString() + ' character' + (len !== 1 ? 's' : '');

        if (!syntaxManuallySet) {
            clearTimeout(detectTimer);
            detectTimer = setTimeout(function() {
                var detected = detectSyntax($content.value);
                if (detected && $syntax.value !== detected) {
                    $syntax.value = detected;
                }
            }, 400);
        }
    });

    $content.addEventListener('paste', function() {
        if (!syntaxManuallySet) {
            setTimeout(function() {
                var detected = detectSyntax($content.value);
                if (detected) $syntax.value = detected;
            }, 100);
        }
    });

    // ── File drop zone ──
    $dropzone.addEventListener('click', function() { $fileInput.click(); });
    $dropzone.addEventListener('dragover', function(e) { e.preventDefault(); this.classList.add('dragover'); });
    $dropzone.addEventListener('dragleave', function() { this.classList.remove('dragover'); });
    $dropzone.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
        if (e.dataTransfer.files.length) handleFile(e.dataTransfer.files[0]);
    });
    $fileInput.addEventListener('change', function() {
        if (this.files.length) handleFile(this.files[0]);
    });

    document.getElementById('pb-file-remove').addEventListener('click', function() {
        selectedFile = null;
        $fileSelected.classList.remove('show');
        $fileInput.value = '';
    });

    function handleFile(file) {
        selectedFile = file;
        document.getElementById('pb-file-name').textContent = file.name;
        document.getElementById('pb-file-size').textContent = formatBytes(file.size);
        $fileSelected.classList.add('show');
    }

    // ── Create paste ──
    $submitBtn.addEventListener('click', function() {
        hideError();
        $result.classList.remove('show');

        if (currentMode === 'text') {
            var content = $content.value.trim();
            if (!content) { showError('Content is required.'); return; }
            createTextPaste(content);
        } else {
            if (!selectedFile) { showError('Please select a file.'); return; }
            createFilePaste(selectedFile);
        }
    });

    function createTextPaste(content) {
        setSubmitting(true);
        var body = {
            content: content,
            title: $title.value.trim() || undefined,
            syntax: $syntax.value,
            expiry: $expiry.value,
            visibility: $visibility.value,
            burnAfterRead: $burn.checked
        };
        if ($visibility.value === 'private' && $passphrase.value) {
            body.passphrase = $passphrase.value;
        }

        fetch(API_BASE, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify(body)
        })
        .then(handleResponse)
        .then(function(data) { showResult(data); })
        .catch(function(err) { showError(err.message || 'Failed to create paste.'); })
        .finally(function() { setSubmitting(false); });
    }

    function createFilePaste(file) {
        setSubmitting(true);
        var fd = new FormData();
        fd.append('file', file);
        if ($title.value.trim()) fd.append('title', $title.value.trim());
        fd.append('expiry', $expiry.value);
        fd.append('visibility', $visibility.value);
        if ($visibility.value === 'private' && $passphrase.value) {
            fd.append('passphrase', $passphrase.value);
        }

        fetch(API_BASE, {
            method: 'POST',
            credentials: 'include',
            body: fd
        })
        .then(handleResponse)
        .then(function(data) { showResult(data); })
        .catch(function(err) { showError(err.message || 'Failed to upload file.'); })
        .finally(function() { setSubmitting(false); });
    }

    function showResult(data) {
        // Build user-facing paste URL on this site (not the raw API URL)
        var siteBase = window.location.origin + CTX_PATH;
        var pastePageUrl = siteBase + '/pastebin.jsp?id=' + encodeURIComponent(data.id);
        var rawApiUrl = siteBase + '/api/pastebin/' + encodeURIComponent(data.id) + '/raw';

        document.getElementById('pb-res-url').textContent = pastePageUrl;
        document.getElementById('pb-res-url').href = pastePageUrl;
        document.getElementById('pb-res-raw').textContent = rawApiUrl;
        document.getElementById('pb-res-raw').href = rawApiUrl;
        document.getElementById('pb-res-token').textContent = data.deleteToken;
        document.getElementById('pb-res-burn-warn').style.display = data.burnAfterRead ? 'flex' : 'none';

        // Store delete token locally
        try {
            var tokens = JSON.parse(localStorage.getItem('pb_tokens') || '{}');
            tokens[data.id] = data.deleteToken;
            localStorage.setItem('pb_tokens', JSON.stringify(tokens));
        } catch(e) {}

        // Expiry countdown
        var $expire = document.getElementById('pb-res-expire');
        if (data.expiresAt) {
            updateExpiry(data.expiresAt);
        } else if ($expire) {
            $expire.textContent = 'Never expires';
        }

        $result.classList.add('show');
        $result.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    function updateExpiry(expiresAt) {
        var $expire = document.getElementById('pb-res-expire');
        function tick() {
            var remaining = new Date(expiresAt) - new Date();
            if (remaining <= 0) { $expire.textContent = 'Expired'; return; }
            var h = Math.floor(remaining / 3600000);
            var m = Math.floor((remaining % 3600000) / 60000);
            $expire.textContent = 'Expires in ' + h + 'h ' + m + 'm';
        }
        tick();
        setInterval(tick, 60000);
    }

    // ── View paste ──
    function viewPaste(id, passphrase) {
        var url = API_BASE + '/' + id;
        if (passphrase) url += '?passphrase=' + encodeURIComponent(passphrase);

        fetch(url, { credentials: 'include' })
        .then(function(res) {
            if (res.status === 403) {
                return res.json().then(function(err) {
                    if (err.code === 'PASSPHRASE_REQUIRED' || err.code === 'WRONG_PASSPHRASE') {
                        showPassphrasePrompt(id, err.code === 'WRONG_PASSPHRASE');
                    } else {
                        showError(err.error);
                    }
                    throw { handled: true };
                });
            }
            if (res.status === 410) {
                return res.json().then(function(err) {
                    if (err.code === 'BURNED') {
                        showError('This paste was burned after its first view and no longer exists.');
                    } else if (err.code === 'EXPIRED') {
                        showError('This paste has expired and is no longer available.');
                    } else {
                        showError(err.error || 'This paste is no longer available.');
                    }
                    throw { handled: true };
                });
            }
            return handleResponse2(res);
        })
        .then(function(data) {
            if (!data) return;
            showPasteView(data, id);
        })
        .catch(function(err) {
            if (err && err.handled) return;
            showError(err.message || 'Failed to load paste.');
        });
    }

    function showPasteView(data, id) {
        document.getElementById('pb-view-title').textContent = data.title || 'Untitled Paste';

        var metaHtml = '';
        if (data.type) metaHtml += '<span>Type: ' + escHtml(data.type) + '</span>';
        if (data.syntax) metaHtml += '<span>Syntax: ' + escHtml(data.syntax) + '</span>';
        if (data.size != null) metaHtml += '<span>Size: ' + formatBytes(data.size) + '</span>';
        if (data.viewCount != null) metaHtml += '<span>Views: ' + data.viewCount + '</span>';
        if (data.createdAt) metaHtml += '<span>Created: ' + new Date(data.createdAt).toLocaleString() + '</span>';
        if (data.expiresAt) metaHtml += '<span>Expires: ' + new Date(data.expiresAt).toLocaleString() + '</span>';
        document.getElementById('pb-view-meta').innerHTML = metaHtml;

        var codeEl = document.getElementById('pb-view-code');
        if (data.type === 'file') {
            codeEl.textContent = '(File paste — use Raw or Download to access the file)';
            codeEl.className = '';
        } else {
            codeEl.textContent = data.content || '';
            codeEl.className = '';
            // Apply syntax highlighting
            if (typeof hljs !== 'undefined' && data.content) {
                if (data.syntax && data.syntax !== 'plain') {
                    codeEl.className = 'language-' + data.syntax;
                }
                hljs.highlightElement(codeEl);
            }
        }

        document.getElementById('pb-view-raw').href = API_BASE + '/' + id + '/raw';

        // Copy button
        document.getElementById('pb-view-copy').onclick = function() {
            copyText(data.content || '');
            toast('Copied to clipboard');
        };

        // Download
        document.getElementById('pb-view-download').onclick = function() {
            var a = document.createElement('a');
            a.href = API_BASE + '/' + id + '/raw';
            a.download = data.filename || (data.title || 'paste') + '.txt';
            a.click();
        };

        // Hide burn gate / passphrase prompt, show content
        document.getElementById('pb-burn-gate').classList.remove('show');
        document.getElementById('pb-view-passphrase').classList.remove('show');
        document.getElementById('pb-view-container').style.display = 'block';
        $view.style.display = 'block';
        $view.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }

    function showPassphrasePrompt(id, isWrong) {
        document.getElementById('pb-view-container').style.display = 'none';
        document.getElementById('pb-burn-gate').classList.remove('show');
        var $prompt = document.getElementById('pb-view-passphrase');
        $prompt.classList.add('show');
        $view.style.display = 'block';

        if (isWrong) {
            document.querySelector('#pb-view-passphrase p').textContent = 'Wrong passphrase. Please try again.';
        }

        document.getElementById('pb-view-pass-submit').onclick = function() {
            var pass = document.getElementById('pb-view-pass-input').value;
            if (!pass) return;
            viewPaste(id, pass);
        };
    }

    // ── Back button ──
    document.getElementById('pb-view-back').addEventListener('click', function() {
        $view.style.display = 'none';
        document.getElementById('pb-view-container').style.display = 'none';
        document.getElementById('pb-view-passphrase').classList.remove('show');
        document.getElementById('pb-burn-gate').classList.remove('show');
        // Reset URL
        if (window.history.pushState) {
            window.history.pushState({}, '', window.location.pathname);
        }
    });

    // ── My Pastes ──
    document.getElementById('pb-load-pastes').addEventListener('click', function() { loadMyPastes(); });

    document.getElementById('pb-gen-key').addEventListener('click', function() {
        fetch(API_BASE + '/keys', { method: 'POST', credentials: 'include' })
        .then(handleResponse)
        .then(function(data) {
            document.getElementById('pb-api-key').value = data.apiKey;
            try { localStorage.setItem('pb_api_key', data.apiKey); } catch(e) {}
            toast('API key generated — save it, shown only once!');
        })
        .catch(function(err) { showError(err.message); });
    });

    function loadMyPastes() {
        var headers = {};
        var key = document.getElementById('pb-api-key').value.trim();
        if (key) headers['X-API-Key'] = key;

        fetch(API_BASE + '/mine?limit=' + myPastesLimit + '&offset=' + myPastesOffset, {
            credentials: 'include',
            headers: headers
        })
        .then(handleResponse)
        .then(function(data) {
            renderPastesTable(data.pastes || []);
        })
        .catch(function(err) { showError(err.message || 'Failed to load pastes.'); });
    }

    function renderPastesTable(pastes) {
        var $body = document.getElementById('pb-pastes-body');
        if (!pastes.length) {
            $body.innerHTML = '<tr><td colspan="6" class="pb-table-empty">No pastes found.</td></tr>';
            document.getElementById('pb-pagination').style.display = 'none';
            return;
        }

        $body.innerHTML = pastes.map(function(p) {
            return '<tr>' +
                '<td><a href="#" data-paste-id="' + escAttr(p.id) + '">' + escHtml(p.title || 'Untitled') + '</a></td>' +
                '<td>' + escHtml(p.type || 'text') + '</td>' +
                '<td>' + formatBytes(p.size || 0) + '</td>' +
                '<td>' + timeAgo(p.createdAt) + '</td>' +
                '<td>' + (p.expiresAt ? timeAgo(p.expiresAt) : '-') + '</td>' +
                '<td><button class="pb-copy-btn" data-delete-id="' + escAttr(p.id) + '" title="Delete">&#x2715;</button></td>' +
                '</tr>';
        }).join('');

        // Click to view
        $body.querySelectorAll('a[data-paste-id]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                e.preventDefault();
                viewPaste(a.dataset.pasteId);
            });
        });

        // Delete
        $body.querySelectorAll('button[data-delete-id]').forEach(function(btn) {
            btn.addEventListener('click', function() {
                deletePaste(btn.dataset.deleteId);
            });
        });

        // Pagination
        document.getElementById('pb-pagination').style.display = 'flex';
        document.getElementById('pb-page-info').textContent = 'Page ' + Math.floor(myPastesOffset / myPastesLimit + 1);
        document.getElementById('pb-prev-page').disabled = myPastesOffset === 0;
        document.getElementById('pb-next-page').disabled = pastes.length < myPastesLimit;
    }

    document.getElementById('pb-prev-page').addEventListener('click', function() {
        myPastesOffset = Math.max(0, myPastesOffset - myPastesLimit);
        loadMyPastes();
    });

    document.getElementById('pb-next-page').addEventListener('click', function() {
        myPastesOffset += myPastesLimit;
        loadMyPastes();
    });

    function deletePaste(id) {
        var tokens = {};
        try { tokens = JSON.parse(localStorage.getItem('pb_tokens') || '{}'); } catch(e) {}
        var token = tokens[id];

        if (!token) {
            token = prompt('Enter the delete token for this paste:');
            if (!token) return;
        }

        fetch(API_BASE + '/' + id, {
            method: 'DELETE',
            credentials: 'include',
            headers: { 'X-Delete-Token': token }
        })
        .then(function(res) {
            if (!res.ok) return res.json().then(function(e) { throw new Error(e.error); });
            toast('Paste deleted');
            loadMyPastes();
        })
        .catch(function(err) { showError(err.message); });
    }

    // ── Check URL for paste ID on load ──
    function checkUrlForPaste() {
        var match = window.location.hash.match(/^#paste\/(.+)$/);
        if (!match) {
            var params = new URLSearchParams(window.location.search);
            var id = params.get('id');
            if (id) match = [null, id];
        }
        if (match && match[1]) {
            viewPaste(match[1]);
        }

        // Restore API key
        try {
            var savedKey = localStorage.getItem('pb_api_key');
            if (savedKey) document.getElementById('pb-api-key').value = savedKey;
        } catch(e) {}
    }
    checkUrlForPaste();

    // ── Utility functions ──
    function handleResponse(res) {
        return res.json().then(function(data) {
            if (!res.ok) throw new Error(data.error || 'Request failed (' + res.status + ')');
            return data;
        });
    }

    function handleResponse2(res) {
        if (!res.ok) {
            return res.json().then(function(data) {
                throw new Error(data.error || 'Request failed (' + res.status + ')');
            });
        }
        return res.json();
    }

    function setSubmitting(loading) {
        $submitBtn.disabled = loading;
        if (loading) {
            $submitBtn.innerHTML = '<span class="pb-spinner"></span> Creating...';
        } else {
            $submitBtn.innerHTML = '<svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M15.854.146a.5.5 0 0 1 .11.54l-5.819 14.547a.75.75 0 0 1-1.329.124l-3.178-4.995L.643 7.184a.75.75 0 0 1 .124-1.33L15.314.037a.5.5 0 0 1 .54.11ZM6.636 10.07l2.761 4.338L14.13 2.576 6.636 10.07Zm6.787-8.201L1.591 6.602l4.339 2.76 7.494-7.493Z"/></svg> Create Paste';
        }
    }

    function showError(msg) {
        $error.textContent = msg;
        $error.classList.add('show');
        $error.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }

    function hideError() {
        $error.classList.remove('show');
    }

    function toast(msg) {
        var el = document.createElement('div');
        el.className = 'pb-toast';
        el.textContent = msg;
        document.body.appendChild(el);
        setTimeout(function() { el.remove(); }, 3000);
    }

    function copyText(text) {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(text);
        } else {
            var ta = document.createElement('textarea');
            ta.value = text;
            ta.style.position = 'fixed';
            ta.style.opacity = '0';
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            ta.remove();
        }
    }

    function formatBytes(bytes) {
        if (bytes === 0) return '0 B';
        var k = 1024;
        var sizes = ['B', 'KB', 'MB', 'GB'];
        var i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
    }

    function timeAgo(dateStr) {
        if (!dateStr) return '-';
        var diff = new Date(dateStr) - new Date();
        if (diff > 0) {
            // Future (expires)
            var h = Math.floor(diff / 3600000);
            var m = Math.floor((diff % 3600000) / 60000);
            if (h > 24) return Math.floor(h / 24) + 'd';
            return h + 'h ' + m + 'm';
        } else {
            // Past (created)
            diff = -diff;
            var h2 = Math.floor(diff / 3600000);
            if (h2 > 24) return Math.floor(h2 / 24) + 'd ago';
            if (h2 > 0) return h2 + 'h ago';
            return Math.floor(diff / 60000) + 'm ago';
        }
    }

    function escHtml(s) {
        var d = document.createElement('div');
        d.textContent = s;
        return d.innerHTML;
    }

    function escAttr(s) {
        return String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;');
    }

    // ── Copy buttons (result area) ──
    document.querySelectorAll('.pb-copy-btn[data-copy]').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var target = document.getElementById(btn.dataset.copy);
            var text = target.textContent || target.innerText;
            copyText(text);
            btn.textContent = 'Copied!';
            btn.classList.add('copied');
            setTimeout(function() {
                btn.textContent = 'Copy';
                btn.classList.remove('copied');
            }, 2000);
        });
    });

})();
