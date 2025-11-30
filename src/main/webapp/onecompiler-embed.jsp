<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Embed - 8gwifi.org</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/editor/editor.main.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg-dark: #1e1e1e;
            --bg-darker: #252526;
            --border: #3c3c3c;
            --text: #cccccc;
            --text-bright: #ffffff;
            --primary: #007acc;
            --success: #4ec9b0;
            --error: #f48771;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: var(--bg-dark);
            color: var(--text);
            overflow: hidden;
        }

        .embed-container {
            display: flex;
            flex-direction: column;
            height: 100vh;
            width: 100vw;
        }

        /* Header */
        .embed-header {
            height: 32px;
            background: var(--bg-darker);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            padding: 0 10px;
            justify-content: space-between;
        }

        .embed-header-left {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .embed-lang {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--text);
        }

        .embed-lang i {
            color: var(--primary);
        }

        .embed-title {
            font-size: 12px;
            color: var(--text);
            opacity: 0.7;
        }

        .embed-header-right {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .embed-btn {
            background: transparent;
            border: none;
            color: var(--text);
            padding: 4px 8px;
            font-size: 11px;
            cursor: pointer;
            border-radius: 3px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .embed-btn:hover {
            background: var(--border);
            color: var(--text-bright);
        }

        .embed-btn.run {
            background: var(--primary);
            color: white;
        }

        .embed-btn.run:hover {
            background: #005a9e;
        }

        .embed-btn.run:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        /* Editor */
        .embed-editor {
            flex: 1;
            overflow: hidden;
        }

        #editor {
            width: 100%;
            height: 100%;
        }

        /* Output */
        .embed-output {
            height: 100px;
            background: var(--bg-dark);
            border-top: 1px solid var(--border);
            display: flex;
            flex-direction: column;
        }

        .embed-output.hidden {
            display: none;
        }

        .embed-output-header {
            height: 24px;
            background: var(--bg-darker);
            display: flex;
            align-items: center;
            padding: 0 10px;
            font-size: 11px;
            justify-content: space-between;
        }

        .embed-output-title {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .embed-output-content {
            flex: 1;
            padding: 8px 10px;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 12px;
            overflow: auto;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .embed-output-content.success { color: var(--success); }
        .embed-output-content.error { color: var(--error); }
        .embed-output-content.system { color: var(--text); font-style: italic; }

        /* Footer */
        .embed-footer {
            height: 20px;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 10px;
            font-size: 10px;
            color: white;
        }

        .embed-footer a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .embed-footer a:hover {
            text-decoration: underline;
        }

        /* Readonly overlay */
        .readonly-badge {
            background: rgba(0,0,0,0.5);
            color: var(--text);
            font-size: 10px;
            padding: 2px 6px;
            border-radius: 3px;
        }

        /* Light theme */
        body.light {
            --bg-dark: #ffffff;
            --bg-darker: #f3f3f3;
            --border: #e0e0e0;
            --text: #333333;
            --text-bright: #000000;
        }
    </style>
</head>
<body>
    <div class="embed-container">
        <!-- Header -->
        <div class="embed-header">
            <div class="embed-header-left">
                <div class="embed-lang">
                    <i class="fas fa-code"></i>
                    <span id="langName">Python</span>
                </div>
                <span class="embed-title" id="snippetTitle"></span>
            </div>
            <div class="embed-header-right">
                <span class="readonly-badge" id="readonlyBadge" style="display:none;">Read-only</span>
                <button class="embed-btn run" id="runBtn" onclick="runCode()">
                    <i class="fas fa-play"></i> Run
                </button>
                <button class="embed-btn" onclick="openInFull()" title="Open in 8gwifi.org">
                    <i class="fas fa-external-link-alt"></i>
                </button>
            </div>
        </div>

        <!-- Editor -->
        <div class="embed-editor">
            <div id="editor"></div>
        </div>

        <!-- Output -->
        <div class="embed-output hidden" id="outputPanel">
            <div class="embed-output-header">
                <div class="embed-output-title">
                    <i class="fas fa-terminal"></i> Output
                </div>
                <button class="embed-btn" onclick="hideOutput()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="embed-output-content system" id="outputContent">
                Click Run to execute
            </div>
        </div>

        <!-- Footer -->
        <div class="embed-footer">
            <a href="https://8gwifi.org/onecompiler.jsp" target="_blank">
                <i class="fas fa-code"></i> Powered by 8gwifi.org
            </a>
            <span id="execTime"></span>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs/loader.min.js"></script>
    <script>
        var editor = null;
        var currentLang = 'python';
        var currentVersion = '';
        var snippetId = null;
        var isReadonly = false;
        var isRunning = false;

        var monacoLangMap = {
            'python': 'python', 'java': 'java', 'c': 'c', 'cpp': 'cpp',
            'csharp': 'csharp', 'javascript': 'javascript', 'typescript': 'typescript',
            'go': 'go', 'rust': 'rust', 'php': 'php', 'ruby': 'ruby',
            'swift': 'swift', 'kotlin': 'kotlin', 'scala': 'scala'
        };

        // Parse URL params
        var params = new URLSearchParams(window.location.search);
        snippetId = params.get('s');
        var codeParam = params.get('c');
        var langParam = params.get('lang');
        var themeParam = params.get('theme');
        isReadonly = params.get('readonly') === 'true';
        var hideOutput = params.get('hideOutput') === 'true';
        var autorun = params.get('autorun') === 'true';

        // Apply theme
        if (themeParam === 'light') {
            document.body.classList.add('light');
        }

        // Init Monaco
        require.config({ paths: { 'vs': 'https://cdnjs.cloudflare.com/ajax/libs/monaco-editor/0.45.0/min/vs' }});

        require(['vs/editor/editor.main'], function() {
            var initialCode = '# Loading...';
            var monacoTheme = themeParam === 'light' ? 'vs' : 'vs-dark';

            editor = monaco.editor.create(document.getElementById('editor'), {
                value: initialCode,
                language: 'python',
                theme: monacoTheme,
                fontSize: 13,
                minimap: { enabled: false },
                automaticLayout: true,
                scrollBeyondLastLine: false,
                lineNumbers: 'on',
                readOnly: isReadonly,
                padding: { top: 8 }
            });

            // Load content
            if (snippetId) {
                loadSnippet(snippetId);
            } else if (codeParam) {
                loadFromCodeParam(codeParam, langParam);
            } else if (langParam) {
                currentLang = langParam;
                updateLang(langParam);
                editor.setValue('// Write your code here');
            }

            // Keyboard shortcut
            editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.Enter, function() {
                runCode();
            });

            // Show readonly badge
            if (isReadonly) {
                document.getElementById('readonlyBadge').style.display = 'inline';
            }

            // Autorun
            if (autorun) {
                setTimeout(runCode, 500);
            }
        });

        function loadSnippet(id) {
            fetch('OneCompilerFunctionality?action=snippet_get&id=' + encodeURIComponent(id))
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.error) {
                        editor.setValue('// Snippet not found');
                        return;
                    }

                    currentLang = data.language || 'python';
                    currentVersion = data.version || '';
                    updateLang(currentLang);

                    var code = data.code || (data.files && data.files[0] ? data.files[0].content : '');
                    editor.setValue(code || '// No code');

                    if (data.title) {
                        document.getElementById('snippetTitle').textContent = '- ' + data.title;
                    }
                })
                .catch(function() {
                    editor.setValue('// Error loading snippet');
                });
        }

        function loadFromCodeParam(codeParam, lang) {
            try {
                var config = JSON.parse(decodeURIComponent(codeParam));
                if (config.lang) {
                    currentLang = config.lang;
                    updateLang(config.lang);
                }
                if (config.code) {
                    var code = decodeURIComponent(escape(atob(config.code)));
                    editor.setValue(code);
                }
            } catch (e) {
                // Try direct base64
                try {
                    var code = decodeURIComponent(escape(atob(codeParam)));
                    editor.setValue(code);
                    if (lang) {
                        currentLang = lang;
                        updateLang(lang);
                    }
                } catch (e2) {
                    editor.setValue('// Error decoding');
                }
            }
        }

        function updateLang(lang) {
            var monacoLang = monacoLangMap[lang] || 'plaintext';
            monaco.editor.setModelLanguage(editor.getModel(), monacoLang);
            document.getElementById('langName').textContent = lang.charAt(0).toUpperCase() + lang.slice(1);
        }

        function runCode() {
            if (isRunning) return;
            isRunning = true;

            var code = editor.getValue();
            var runBtn = document.getElementById('runBtn');
            var outputPanel = document.getElementById('outputPanel');
            var outputContent = document.getElementById('outputContent');

            runBtn.disabled = true;
            runBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Running';
            outputPanel.classList.remove('hidden');
            outputContent.textContent = 'Executing...';
            outputContent.className = 'embed-output-content system';

            var startTime = Date.now();

            fetch('OneCompilerFunctionality?action=execute', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    language: currentLang,
                    version: currentVersion || undefined,
                    code: code
                })
            })
            .then(function(r) { return r.json(); })
            .then(function(data) {
                var execTime = ((Date.now() - startTime) / 1000).toFixed(2);
                var stdout = data.Stdout || data.stdout || '';
                var stderr = data.Stderr || data.stderr || '';

                if (stdout) {
                    outputContent.textContent = stdout;
                    outputContent.className = 'embed-output-content success';
                } else if (stderr) {
                    outputContent.textContent = stderr;
                    outputContent.className = 'embed-output-content error';
                } else {
                    outputContent.textContent = '(No output)';
                    outputContent.className = 'embed-output-content system';
                }

                document.getElementById('execTime').textContent = execTime + 's';
            })
            .catch(function(err) {
                outputContent.textContent = 'Error: ' + err.message;
                outputContent.className = 'embed-output-content error';
            })
            .finally(function() {
                isRunning = false;
                runBtn.disabled = false;
                runBtn.innerHTML = '<i class="fas fa-play"></i> Run';
            });
        }

        function hideOutput() {
            document.getElementById('outputPanel').classList.add('hidden');
        }

        function openInFull() {
            var url = 'https://8gwifi.org/onecompiler.jsp';
            if (snippetId) {
                url += '?s=' + snippetId;
            } else {
                var code = editor.getValue();
                var config = { lang: currentLang, code: btoa(unescape(encodeURIComponent(code))) };
                url += '?c=' + encodeURIComponent(JSON.stringify(config));
            }
            window.open(url, '_blank');
        }
    </script>
</body>
</html>
