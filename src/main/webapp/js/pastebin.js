(function() {
    'use strict';

    // ── Configuration (set by JSP before this script loads) ──
    var API_BASE = window.PASTEBIN_CONFIG.apiBase;
    var CTX_PATH = window.PASTEBIN_CONFIG.ctxPath;
    var COMPILER_EXECUTE_URL = window.PASTEBIN_CONFIG.compilerExecuteUrl;

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
    var $runDraft = document.getElementById('pb-run-draft');
    var $draftRunOutputWrap = document.getElementById('pb-draft-run-output-wrap');
    var $draftRunOutput = document.getElementById('pb-draft-run-output');
    var $draftRunMeta = document.getElementById('pb-draft-run-meta');
    var $runPanel   = document.getElementById('pb-run-panel');
    var $runLanguage = document.getElementById('pb-run-language');
    var $runInput = document.getElementById('pb-run-input');
    var $runExecute = document.getElementById('pb-run-execute');
    var $runClear = document.getElementById('pb-run-clear');
    var $runStatus = document.getElementById('pb-run-status');
    var $runNote = document.getElementById('pb-run-note');
    var $runOutput = document.getElementById('pb-run-output');
    var $runOutputMeta = document.getElementById('pb-run-output-meta');

    var currentMode = 'text';       // 'text' or 'file'
    var selectedFile = null;
    var myPastesOffset = 0;
    var myPastesLimit = 20;
    var recentOffset = 0;
    var recentLimit = 20;
    var recentLoaded = false;
    var currentRunnablePaste = null;
    var transformsLoaded = false;
    var transformsLoadingPromise = null;
    var MAX_RUNNABLE_CHARS = 200000;
    var RUNNABLE_LANGUAGES = [
        { value: 'javascript', label: 'JavaScript (Node.js)', syntaxes: ['javascript'] },
        { value: 'python', label: 'Python', syntaxes: ['python'] },
        { value: 'java', label: 'Java', syntaxes: ['java'] },
        { value: 'go', label: 'Go', syntaxes: ['go'] },
        { value: 'rust', label: 'Rust', syntaxes: ['rust'] },
        { value: 'c', label: 'C', syntaxes: ['c'] },
        { value: 'cpp', label: 'C++', syntaxes: ['cpp'] },
        { value: 'bash', label: 'Bash', syntaxes: ['bash'] },
        { value: 'php', label: 'PHP', syntaxes: ['php'] },
        { value: 'ruby', label: 'Ruby', syntaxes: ['ruby'] },
        { value: 'kotlin', label: 'Kotlin', syntaxes: ['kotlin'] },
        { value: 'swift', label: 'Swift', syntaxes: ['swift'] },
        { value: 'scala', label: 'Scala', syntaxes: ['scala'] },
        { value: 'typescript', label: 'TypeScript', syntaxes: ['typescript'] },
        { value: 'csharp', label: 'C#', syntaxes: ['csharp', 'cs'] },
        { value: 'dart', label: 'Dart', syntaxes: ['dart'] },
        { value: 'lua', label: 'Lua', syntaxes: ['lua'] },
        { value: 'r', label: 'R', syntaxes: ['r'] }
    ];
    var RUNNABLE_SYNTAX_MAP = {};
    RUNNABLE_LANGUAGES.forEach(function(entry) {
        entry.syntaxes.forEach(function(syntax) {
            RUNNABLE_SYNTAX_MAP[syntax] = entry.value;
        });
    });

    renderRunnableLanguageOptions();

    // ── Tabs ──
    document.querySelectorAll('.pb-tab').forEach(function(tab) {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.pb-tab').forEach(function(t) { t.classList.remove('active'); t.setAttribute('aria-selected', 'false'); });
            document.querySelectorAll('.pb-panel').forEach(function(p) { p.classList.remove('active'); });
            tab.classList.add('active');
            tab.setAttribute('aria-selected', 'true');
            document.getElementById('panel-' + tab.dataset.tab).classList.add('active');
            // Auto-load recent pastes on first tab visit
            if (tab.dataset.tab === 'recent' && !recentLoaded) {
                loadRecentPastes();
            }
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
                $runDraft.style.display = 'none';
                hideDraftRunOutput();
            } else {
                $content.style.display = '';
                if ($transforms) $transforms.style.display = '';
                $dropzone.classList.remove('active');
                $fileSelected.classList.remove('show');
                selectedFile = null;
                $burn.closest('label').style.display = '';
                $syntax.closest('.pb-opt-group').style.display = '';
                syncDraftRunAvailability();
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
        'javascript': 'javascript', 'js': 'javascript',
        'typescript': 'typescript', 'ts': 'typescript',
        'python': 'python', 'py': 'python',
        'java': 'java',
        'php': 'php',
        'ruby': 'ruby', 'rb': 'ruby',
        'kotlin': 'kotlin', 'kt': 'kotlin',
        'swift': 'swift',
        'scala': 'scala',
        'dart': 'dart',
        'lua': 'lua',
        'cs': 'csharp', 'csharp': 'csharp',
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
        if (!text || text.length < 10) return null;

        var heuristic = detectSyntaxHeuristic(text);
        if (heuristic) return heuristic;

        if (typeof hljs === 'undefined') return null;
        try {
            var result = hljs.highlightAuto(text, Object.keys(HLJS_TO_SYNTAX));
            if (result.language) {
                return HLJS_TO_SYNTAX[result.language] || null;
            }
        } catch(e) {}
        return null;
    }

    function detectSyntaxFast(text) {
        if (!text || text.length < 10) return null;
        return detectSyntaxHeuristic(text);
    }

    function detectSyntaxHeuristic(text) {
        var sample = text.trim();
        var lower = sample.toLowerCase();

        if (/^\s*<\?php\b/i.test(sample) || /\becho\s+['"]/.test(sample) && /\$\w+/.test(sample)) return 'php';
        if (/^#!.*\b(?:bash|sh|zsh)\b/m.test(sample) || /^\s*(?:echo|if\b|then\b|fi\b|for\b|done\b|grep\b|sed\b|awk\b|curl\b|export\s+\w+=)/m.test(sample)) return 'bash';
        if (looksLikeJson(sample)) return 'json';
        if (/^\s*<!doctype html\b/i.test(sample) || /^\s*<html\b/i.test(sample) || /<\/?(?:html|head|body|div|span|script|style|section|article|main|form|input|button)\b/i.test(sample)) return 'html';
        if (/^\s*<\?xml\b/i.test(sample) || /^<[\w:-]+(?:\s+[\w:-]+="[^"]*")*\s*>[\s\S]*<\/[\w:-]+>\s*$/.test(sample)) return 'xml';
        if (looksLikeYaml(sample)) return 'yaml';
        if (looksLikeMarkdown(sample)) return 'markdown';
        if (looksLikeSql(lower)) return 'sql';
        if (/^\s*(?:[.#][\w-]+|\w[\w-]*)\s*\{[\s\S]*:[^;]+;/.test(sample)) return 'css';
        if (/\binterface\s+\w+\s*\{/.test(sample) || /\btype\s+\w+\s*=/.test(sample) || /\b(?:const|let|var)\s+\w+\s*:\s*[\w<>{}\[\]|&]+/.test(sample)) return 'typescript';
        if (/\blocal\s+\w+/.test(sample) || /\bfunction\s+\w+\s*\(/.test(sample) && /\bend\b/.test(sample) || /\bipairs\s*\(/.test(sample)) return 'lua';
        if (/\bdef\s+\w+\s*\(/.test(sample) || /\bimport\s+\w+/.test(sample) && /:\s*$/.test(sample) || /\bprint\s*\(/.test(sample)) return 'python';
        if (/\busing\s+System\b/.test(sample) || /\bConsole\.Write(Line)?\s*\(/.test(sample) || /\bnamespace\s+\w+/.test(sample)) return 'csharp';
        if (/\bpackage\s+main\b/.test(sample) || /\bfunc\s+main\s*\(/.test(sample) || /\bfmt\.Print/.test(sample)) return 'go';
        if (/\bfn\s+main\s*\(/.test(sample) || /\bprintln!\s*\(/.test(sample) || /\blet\s+mut\b/.test(sample)) return 'rust';
        if (/\bfun\s+main\s*\(/.test(sample) || /\bval\s+\w+\s*:/.test(sample) || /\bprintln\s*\(/.test(sample) && /\bfun\b/.test(sample)) return 'kotlin';
        if (/\bimport\s+Foundation\b/.test(sample) || /\blet\s+\w+\s*:\s*\w+/.test(sample) && /\bprint\s*\(/.test(sample)) return 'swift';
        if (/\bobject\s+\w+\s+extends\s+App\b/.test(sample) || /\bprintln\s*\(/.test(sample) && /\bobject\b/.test(sample)) return 'scala';
        if (/\bvoid\s+main\s*\(/.test(sample) && /\bprint\s*\(/.test(sample) || /\bimport\s+'dart:/.test(sample)) return 'dart';
        if (/^\s*#include\s*<iostream>/.test(sample) || /\bstd::/.test(sample) || /\bcout\s*<</.test(sample)) return 'cpp';
        if (/^\s*#include\s*<stdio\.h>/.test(sample) || /\bprintf\s*\(/.test(sample)) return 'c';
        if (/\bpublic\s+class\s+\w+/.test(sample) || /\bSystem\.out\.println\s*\(/.test(sample)) return 'java';
        if (/\bputs\s+['"]/.test(sample) || /\bdef\s+\w+[!?=]?\b/.test(sample) && /^\s*end\s*$/m.test(sample)) return 'ruby';
        if (/\b(?:const|let|var)\s+\w+\s*=/.test(sample) || /\bconsole\.log\s*\(/.test(sample) || /=>/.test(sample)) return 'javascript';
        return null;
    }

    function looksLikeJson(sample) {
        if (!/^\s*[\[{]/.test(sample)) return false;
        try {
            JSON.parse(sample);
            return true;
        } catch (e) {
            return false;
        }
    }

    function looksLikeYaml(sample) {
        if (/[{};<>]/.test(sample) || /^\s*\/\//m.test(sample)) return false;
        return /^[A-Za-z0-9_-]+:\s*.*(?:\n(?:[A-Za-z0-9_-]+:\s*.*|\s{2,}.*))*$/m.test(sample);
    }

    function looksLikeSql(lower) {
        return /\b(select|insert|update|delete|create|alter|drop|with)\b/.test(lower) &&
            /\b(from|into|table|where|values|join|set)\b/.test(lower);
    }

    function looksLikeMarkdown(sample) {
        return /^\s{0,3}(?:#{1,6}\s.+|[-*+]\s.+|\d+\.\s.+|```[\s\S]*```)/m.test(sample) ||
            /\[[^\]]+\]\([^)]+\)/.test(sample);
    }

    $syntax.addEventListener('change', function() {
        syntaxManuallySet = true;
        syncDraftRunAvailability();
    });

    $content.addEventListener('input', function() {
        var len = this.value.length;
        $charCount.textContent = len.toLocaleString() + ' character' + (len !== 1 ? 's' : '');

        if (!syntaxManuallySet) {
            clearTimeout(detectTimer);
            detectTimer = setTimeout(function() {
                var detected = detectSyntaxFast($content.value);
                if (detected && $syntax.value !== detected) {
                    $syntax.value = detected;
                    syncDraftRunAvailability();
                }
            }, 250);
        }
    });

    $content.addEventListener('paste', function() {
        if (!syntaxManuallySet) {
            setTimeout(function() {
                var detected = detectSyntax($content.value);
                if (detected) {
                    $syntax.value = detected;
                    syncDraftRunAvailability();
                }
            }, 120);
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

    $runLanguage.addEventListener('change', function() {
        syncRunPanelState();
    });

    $runDraft.addEventListener('click', function() {
        runDraftPaste();
    });

    $runExecute.addEventListener('click', function() {
        runCurrentPaste();
    });

    $runClear.addEventListener('click', function() {
        resetRunOutput();
    });

    primeTransformsLoader();

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

        configureRunPanel(data, id);

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
        hideRunPanel();
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

    // ── Recent Pastes ──
    function loadRecentPastes() {
        fetch(API_BASE + '/recent?limit=' + recentLimit + '&offset=' + recentOffset)
        .then(handleResponse)
        .then(function(data) {
            recentLoaded = true;
            renderRecentTable(data.pastes || []);
        })
        .catch(function(err) {
            document.getElementById('pb-recent-body').innerHTML =
                '<tr><td colspan="5" class="pb-table-empty">Failed to load recent pastes.</td></tr>';
        });
    }

    function renderRecentTable(pastes) {
        var $body = document.getElementById('pb-recent-body');
        if (!pastes.length) {
            $body.innerHTML = '<tr><td colspan="5" class="pb-table-empty">No public pastes yet.</td></tr>';
            document.getElementById('pb-recent-pagination').style.display = 'none';
            return;
        }

        $body.innerHTML = pastes.map(function(p) {
            return '<tr>' +
                '<td><a href="#" data-paste-id="' + escAttr(p.id) + '">' + escHtml(p.title || 'Untitled') + '</a></td>' +
                '<td>' + escHtml(p.syntax || 'plain') + '</td>' +
                '<td>' + formatBytes(p.size || 0) + '</td>' +
                '<td>' + (p.viewCount || 0) + '</td>' +
                '<td>' + timeAgo(p.createdAt) + '</td>' +
                '</tr>';
        }).join('');

        $body.querySelectorAll('a[data-paste-id]').forEach(function(a) {
            a.addEventListener('click', function(e) {
                e.preventDefault();
                viewPaste(a.dataset.pasteId);
            });
        });

        document.getElementById('pb-recent-pagination').style.display = 'flex';
        document.getElementById('pb-recent-page-info').textContent = 'Page ' + Math.floor(recentOffset / recentLimit + 1);
        document.getElementById('pb-recent-prev').disabled = recentOffset === 0;
        document.getElementById('pb-recent-next').disabled = pastes.length < recentLimit;
    }

    document.getElementById('pb-recent-prev').addEventListener('click', function() {
        recentOffset = Math.max(0, recentOffset - recentLimit);
        loadRecentPastes();
    });

    document.getElementById('pb-recent-next').addEventListener('click', function() {
        recentOffset += recentLimit;
        loadRecentPastes();
    });

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

    function renderRunnableLanguageOptions() {
        var options = ['<option value="">Select a runnable language</option>'];
        RUNNABLE_LANGUAGES.forEach(function(entry) {
            options.push('<option value="' + escAttr(entry.value) + '">' + escHtml(entry.label) + '</option>');
        });
        $runLanguage.innerHTML = options.join('');
    }

    function loadTransformsScript() {
        if (transformsLoaded) return Promise.resolve();
        if (transformsLoadingPromise) return transformsLoadingPromise;

        transformsLoadingPromise = new Promise(function(resolve, reject) {
            var script = document.createElement('script');
            script.src = CTX_PATH + '/js/pastebin-transforms.js';
            script.async = true;
            script.onload = function() {
                transformsLoaded = true;
                resolve();
            };
            script.onerror = function() {
                transformsLoadingPromise = null;
                reject(new Error('Failed to load pastebin tools.'));
            };
            document.body.appendChild(script);
        });

        return transformsLoadingPromise;
    }

    function primeTransformsLoader() {
        if (!$transforms) return;

        var requested = false;
        function requestLoad() {
            if (requested) return;
            requested = true;
            loadTransformsScript().catch(function() {});
        }

        $transforms.addEventListener('pointerenter', requestLoad, { once: true });
        $transforms.addEventListener('focusin', requestLoad, { once: true });
        $transforms.addEventListener('click', requestLoad, { once: true });

        var idleLoad = function() { loadTransformsScript().catch(function() {}); };
        if (window.requestIdleCallback) {
            window.requestIdleCallback(idleLoad, { timeout: 2500 });
        } else {
            setTimeout(idleLoad, 2500);
        }
    }

    function getDraftRunnableLanguage() {
        if (currentMode !== 'text') return '';
        return RUNNABLE_SYNTAX_MAP[($syntax.value || '').toLowerCase()] || '';
    }

    function syncDraftRunAvailability() {
        var language = getDraftRunnableLanguage();
        $runDraft.style.display = language ? 'inline-flex' : 'none';
        if (!language) {
            hideDraftRunOutput();
        }
    }

    function hideDraftRunOutput() {
        $draftRunOutputWrap.classList.remove('show');
        $draftRunOutput.textContent = 'Select a runnable syntax to test your code before creating the paste.';
        $draftRunOutput.className = 'is-empty';
        $draftRunMeta.textContent = 'No draft run yet';
    }

    function setDraftRunOutput(text, tone, metaText) {
        $draftRunOutputWrap.classList.add('show');
        $draftRunOutput.textContent = text;
        $draftRunOutput.className = tone || '';
        $draftRunMeta.textContent = metaText || '';
    }

    function runDraftPaste() {
        var language = getDraftRunnableLanguage();
        var code = $content.value || '';

        if (!language) {
            showError('Select a runnable syntax before running the draft.');
            return;
        }
        if (!code.trim()) {
            showError('Add some code before running the draft.');
            return;
        }
        if (code.length > MAX_RUNNABLE_CHARS) {
            showError('This draft is too large to execute inline.');
            return;
        }

        var startTime = performance.now();
        $runDraft.disabled = true;
        $runDraft.innerHTML = '<span class="pb-spinner"></span> Running...';
        setDraftRunOutput('Running draft...', 'is-empty', 'Waiting for compiler response');

        fetch(COMPILER_EXECUTE_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                language: language,
                code: code,
                input: ''
            })
        })
        .then(function(res) {
            return res.json().then(function(data) {
                if (!res.ok) {
                    throw new Error(data.error || data.message || 'Execution failed.');
                }
                return data;
            });
        })
        .then(function(data) {
            var parsed = parseExecutionResult(data);
            var meta = getRunnableLanguageLabel(language) + ' · ' + ((performance.now() - startTime) / 1000).toFixed(2) + 's';
            if (parsed.exitCode !== undefined && parsed.exitCode !== null) {
                meta += ' · exit ' + parsed.exitCode;
            }
            setDraftRunOutput(parsed.output, parsed.isError ? 'is-error' : 'is-success', meta);
        })
        .catch(function(err) {
            setDraftRunOutput(err.message || 'Execution failed.', 'is-error', 'Request failed');
        })
        .finally(function() {
            $runDraft.disabled = false;
            $runDraft.innerHTML = '<svg width="14" height="14" fill="currentColor" viewBox="0 0 16 16"><path d="M6.271 3.055a.5.5 0 0 1 .52.03l5.5 4a.5.5 0 0 1 0 .81l-5.5 4A.5.5 0 0 1 6 11.5v-8a.5.5 0 0 1 .271-.445z"/></svg> Run Code';
            syncDraftRunAvailability();
        });
    }

    function configureRunPanel(data, id) {
        if (data.type === 'file') {
            hideRunPanel();
            return;
        }

        currentRunnablePaste = {
            id: id,
            title: data.title || 'Untitled Paste',
            content: data.content || '',
            syntax: (data.syntax || '').toLowerCase()
        };

        $runPanel.classList.add('show');
        $runInput.value = '';
        resetRunOutput();

        var suggestedLanguage = RUNNABLE_SYNTAX_MAP[currentRunnablePaste.syntax] || '';
        $runLanguage.value = suggestedLanguage;
        syncRunPanelState();
    }

    function hideRunPanel() {
        currentRunnablePaste = null;
        $runPanel.classList.remove('show');
        $runLanguage.value = '';
        $runInput.value = '';
        setRunStatus('idle', 'Idle');
        resetRunOutput();
    }

    function syncRunPanelState() {
        if (!currentRunnablePaste) {
            $runExecute.disabled = true;
            return;
        }

        var selectedLanguage = $runLanguage.value;
        var contentLength = (currentRunnablePaste.content || '').length;

        if (contentLength > MAX_RUNNABLE_CHARS) {
            $runExecute.disabled = true;
            $runNote.textContent = 'This paste is too large to run inline. Keep runnable pastes under ' + MAX_RUNNABLE_CHARS.toLocaleString() + ' characters.';
            setRunStatus('error', 'Too Large');
            return;
        }

        if (selectedLanguage) {
            $runExecute.disabled = false;
            $runNote.textContent = 'Code will run in the OneCompiler sandbox as ' + getRunnableLanguageLabel(selectedLanguage) + '.';
            if ($runStatus.textContent === 'Idle' || $runStatus.textContent === 'Too Large') {
                setRunStatus('idle', 'Ready');
            }
        } else {
            $runExecute.disabled = true;
            $runNote.textContent = 'Choose a language to execute this paste.';
            if ($runStatus.textContent !== 'Running') {
                setRunStatus('idle', 'Idle');
            }
        }
    }

    function getRunnableLanguageLabel(language) {
        for (var i = 0; i < RUNNABLE_LANGUAGES.length; i++) {
            if (RUNNABLE_LANGUAGES[i].value === language) {
                return RUNNABLE_LANGUAGES[i].label;
            }
        }
        return language;
    }

    function setRunStatus(kind, text) {
        $runStatus.textContent = text;
        $runStatus.className = 'pb-run-status';
        if (kind && kind !== 'idle') {
            $runStatus.classList.add(kind);
        }
    }

    function resetRunOutput() {
        $runOutput.textContent = 'Run output will appear here.';
        $runOutput.className = 'is-empty';
        $runOutputMeta.textContent = 'No run yet';
    }

    function setRunOutput(text, tone, metaText) {
        $runOutput.textContent = text;
        $runOutput.className = tone || '';
        $runOutputMeta.textContent = metaText || '';
    }

    function runCurrentPaste() {
        if (!currentRunnablePaste) return;

        var language = $runLanguage.value;
        if (!language) {
            showError('Select a language before running the paste.');
            return;
        }

        var code = currentRunnablePaste.content || '';
        if (!code.trim()) {
            showError('This paste is empty and cannot be executed.');
            return;
        }

        if (code.length > MAX_RUNNABLE_CHARS) {
            showError('This paste is too large to execute inline.');
            syncRunPanelState();
            return;
        }

        var startTime = performance.now();
        $runExecute.disabled = true;
        setRunStatus('running', 'Running');
        setRunOutput('Running program...', 'is-empty', 'Waiting for compiler response');

        fetch(COMPILER_EXECUTE_URL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                language: language,
                code: code,
                input: $runInput.value || ''
            })
        })
        .then(function(res) {
            return res.json().then(function(data) {
                if (!res.ok) {
                    throw new Error(data.error || data.message || 'Execution failed.');
                }
                return data;
            });
        })
        .then(function(data) {
            var parsed = parseExecutionResult(data);
            var meta = ((performance.now() - startTime) / 1000).toFixed(2) + 's';
            if (parsed.exitCode !== undefined && parsed.exitCode !== null) {
                meta += ' · exit ' + parsed.exitCode;
            }
            if (parsed.cpuTime) {
                meta += ' · CPU ' + parsed.cpuTime;
            }
            if (parsed.memory) {
                meta += ' · ' + parsed.memory;
            }
            setRunOutput(parsed.output, parsed.isError ? 'is-error' : 'is-success', meta);
            setRunStatus(parsed.isError ? 'error' : 'success', parsed.isError ? 'Error' : 'Success');
        })
        .catch(function(err) {
            setRunOutput(err.message || 'Execution failed.', 'is-error', 'Request failed');
            setRunStatus('error', 'Error');
        })
        .finally(function() {
            syncRunPanelState();
        });
    }

    function parseExecutionResult(data) {
        var stdout = data.Stdout || data.stdout || '';
        var stderr = data.Stderr || data.stderr || '';
        var error = data.Error || data.error || '';
        var exitCode = data.ExitCode !== undefined ? data.ExitCode : data.exitCode;
        var cpuTime = data.CpuTime || data.cpuTime || '';
        var memory = data.Memory || data.memory || '';
        var output = '';
        var isError = false;

        if (stdout) output += stdout;
        if (stderr) {
            output += (output ? '\n' : '') + stderr;
            isError = true;
        }
        if (error) {
            output += (output ? '\n' : '') + 'Error: ' + error;
            isError = true;
        }
        if (!output) {
            output = 'Program completed with no output.';
        }
        if (exitCode !== undefined && exitCode !== null && Number(exitCode) !== 0) {
            isError = true;
        }

        return {
            output: output,
            isError: isError,
            exitCode: exitCode,
            cpuTime: cpuTime,
            memory: memory
        };
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
