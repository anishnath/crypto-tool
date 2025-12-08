<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.nio.file.*, java.nio.charset.StandardCharsets" %>
<%--
    Server-Side Language Compiler Component

    For Python, Java, Go, C++, etc. - languages that need server execution

    Parameters:
    - initialCode: The initial code to display (inline)
    - codeFile: Path to external code file (relative to /tutorials/code/)
    - language: Programming language (python, java, go, cpp, c, ruby, rust, etc.)
    - editorId: Unique ID for this editor instance (default: 'compiler1')
    - filename: Display filename (default: based on language)
    - showStats: Show execution stats (default: true)
    - collapsible: Make output collapsible (default: false)

    Usage (inline code):
    <jsp:include page="../tutorial-compiler.jsp">
        <jsp:param name="initialCode" value="print('Hello')" />
        <jsp:param name="language" value="python" />
        <jsp:param name="editorId" value="compiler-intro" />
    </jsp:include>

    Usage (external file - RECOMMENDED):
    <jsp:include page="../tutorial-compiler.jsp">
        <jsp:param name="codeFile" value="python/variables-ex1.py" />
        <jsp:param name="language" value="python" />
        <jsp:param name="editorId" value="compiler-intro" />
    </jsp:include>
--%>
<%
    String initialCode = request.getParameter("initialCode");
    String codeFile = request.getParameter("codeFile");

    // If codeFile is provided, load code from external file
    if (codeFile != null && !codeFile.isEmpty()) {
        try {
            String basePath = application.getRealPath("/tutorials/code/");
            File file = new File(basePath, codeFile);
            if (file.exists() && file.isFile()) {
                initialCode = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
                // Remove trailing newline if present
                if (initialCode.endsWith("\n")) {
                    initialCode = initialCode.substring(0, initialCode.length() - 1);
                }
            } else {
                initialCode = "# Error: Code file not found: " + codeFile;
            }
        } catch (Exception e) {
            initialCode = "# Error loading code file: " + e.getMessage();
        }
    }

    if (initialCode == null) initialCode = "print('Hello, World!')";

    // Convert literal \n to actual newlines for textarea display (only needed for inline code)
    String displayCode = (codeFile != null) ? initialCode : initialCode.replace("\\n", "\n").replace("\\t", "\t");

    String language = request.getParameter("language");
    if (language == null) language = "python";

    String editorId = request.getParameter("editorId");
    if (editorId == null) editorId = "compiler1";

    String filename = request.getParameter("filename");
    if (filename == null) {
        // Default filenames by language
        switch(language) {
            case "python": filename = "main.py"; break;
            case "java": filename = "Main.java"; break;
            case "go": filename = "main.go"; break;
            case "cpp": case "c++": filename = "main.cpp"; break;
            case "c": filename = "main.c"; break;
            case "ruby": filename = "main.rb"; break;
            case "rust": filename = "main.rs"; break;
            case "javascript": case "nodejs": filename = "index.js"; break;
            case "typescript": filename = "index.ts"; break;
            case "php": filename = "index.php"; break;
            case "kotlin": filename = "Main.kt"; break;
            case "swift": filename = "main.swift"; break;
            case "scala": filename = "Main.scala"; break;
            case "bash": case "shell": case "sh": filename = "script.sh"; break;
            default: filename = "main." + language;
        }
    }

    String showStats = request.getParameter("showStats");
    boolean displayStats = (showStats == null || showStats.equals("true"));

    String collapsible = request.getParameter("collapsible");
    boolean isCollapsible = (collapsible != null && collapsible.equals("true"));

    // Escape the initial code for JavaScript (used in reset function)
    String escapedCode = displayCode
        .replace("\\", "\\\\")
        .replace("'", "\\'")
        .replace("\n", "\\n")
        .replace("\r", "")
        .replace("\"", "\\\"");
%>

<div class="compiler-container" id="<%= editorId %>-container" data-language="<%= language %>">
    <!-- Editor Header -->
    <div class="compiler-header">
        <div class="compiler-tabs">
            <button class="compiler-tab active" data-tab="code" onclick="switchCompilerTab('<%= editorId %>', 'code')">
                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="16 18 22 12 16 6"></polyline>
                    <polyline points="8 6 2 12 8 18"></polyline>
                </svg>
                <%= filename %>
            </button>
            <button class="compiler-tab" data-tab="input" onclick="switchCompilerTab('<%= editorId %>', 'input')">
                <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M4 17l6-6-6-6M12 19h8"></path>
                </svg>
                Input
            </button>
        </div>
        <div class="compiler-actions">
            <button class="compiler-btn compiler-btn-ghost" onclick="resetCompiler('<%= editorId %>')" title="Reset Code">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                    <path d="M3 3v5h5"></path>
                </svg>
            </button>
            <button class="compiler-btn compiler-btn-primary" id="<%= editorId %>-run-btn" onclick="runCompiler('<%= editorId %>')">
                <svg class="play-icon" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M8 5v14l11-7z"/>
                </svg>
                <span>Run</span>
            </button>
        </div>
    </div>

    <!-- Code Editor Panes -->
    <div class="compiler-editor">
        <div class="compiler-pane active" id="<%= editorId %>-code-pane">
            <textarea id="<%= editorId %>-code"
                      class="compiler-textarea"
                      spellcheck="false"
                      autocomplete="off"
                      autocorrect="off"
                      autocapitalize="off"><%= displayCode %></textarea>
        </div>
        <div class="compiler-pane" id="<%= editorId %>-input-pane" style="display: none;">
            <textarea id="<%= editorId %>-input"
                      class="compiler-textarea compiler-input"
                      placeholder="Enter input for your program (stdin)..."
                      spellcheck="false"></textarea>
        </div>
    </div>

    <!-- Output Section -->
    <div class="compiler-output <%= isCollapsible ? "collapsible" : "" %>" id="<%= editorId %>-output-container">
        <div class="output-header" <% if(isCollapsible) { %>onclick="toggleOutput('<%= editorId %>')"<% } %>>
            <div class="output-title">
                <% if(isCollapsible) { %>
                <svg class="collapse-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="6 9 12 15 18 9"></polyline>
                </svg>
                <% } %>
                <span class="output-label">Output</span>
                <span class="output-status" id="<%= editorId %>-status"></span>
            </div>
            <div class="output-actions">
                <% if(displayStats) { %>
                <span class="output-stats" id="<%= editorId %>-stats"></span>
                <% } %>
                <button class="output-btn" onclick="copyOutput('<%= editorId %>')" title="Copy Output">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                    </svg>
                </button>
                <button class="output-btn" onclick="clearOutput('<%= editorId %>')" title="Clear Output">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                    </svg>
                </button>
            </div>
        </div>
        <div class="output-body" id="<%= editorId %>-output-body">
            <pre id="<%= editorId %>-output" class="output-content">
<span class="output-placeholder">Click <strong>Run</strong> to execute your code</span></pre>
        </div>
    </div>
</div>

<style>
/* Compiler Container */
.compiler-container {
    border: 1px solid var(--border-color, #e2e8f0);
    border-radius: var(--radius-lg, 12px);
    overflow: hidden;
    margin: var(--space-6, 1.5rem) 0;
    background: var(--bg-secondary, #f8fafc);
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

[data-theme="dark"] .compiler-container {
    background: #1e1e1e;
    border-color: #333;
}

/* Header */
.compiler-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--space-2, 0.5rem) var(--space-3, 0.75rem);
    background: var(--bg-tertiary, #f1f5f9);
    border-bottom: 1px solid var(--border-color, #e2e8f0);
}

[data-theme="dark"] .compiler-header {
    background: #252526;
    border-color: #333;
}

/* Tabs */
.compiler-tabs {
    display: flex;
    gap: var(--space-1, 0.25rem);
}

.compiler-tab {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    font-size: var(--text-sm, 0.875rem);
    font-weight: 500;
    color: var(--text-secondary, #64748b);
    background: transparent;
    border: none;
    border-radius: var(--radius-md, 8px);
    cursor: pointer;
    transition: all 0.15s ease;
}

.compiler-tab:hover {
    background: var(--bg-hover, rgba(0,0,0,0.05));
    color: var(--text-primary, #1e293b);
}

.compiler-tab.active {
    background: var(--bg-primary, #fff);
    color: var(--text-primary, #1e293b);
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
}

[data-theme="dark"] .compiler-tab.active {
    background: #1e1e1e;
    color: #fff;
}

.tab-icon {
    width: 14px;
    height: 14px;
}

/* Action Buttons */
.compiler-actions {
    display: flex;
    align-items: center;
    gap: var(--space-2, 0.5rem);
}

.compiler-btn {
    display: flex;
    align-items: center;
    gap: 6px;
    padding: 6px 12px;
    font-size: var(--text-sm, 0.875rem);
    font-weight: 600;
    border: none;
    border-radius: var(--radius-md, 8px);
    cursor: pointer;
    transition: all 0.15s ease;
}

.compiler-btn svg {
    width: 16px;
    height: 16px;
}

.compiler-btn-ghost {
    background: transparent;
    color: var(--text-secondary, #64748b);
}

.compiler-btn-ghost:hover {
    background: var(--bg-hover, rgba(0,0,0,0.05));
    color: var(--text-primary, #1e293b);
}

.compiler-btn-primary {
    background: var(--accent-primary, #2563eb);
    color: white;
}

.compiler-btn-primary:hover {
    background: var(--accent-hover, #1d4ed8);
}

.compiler-btn-primary:disabled {
    opacity: 0.7;
    cursor: not-allowed;
}

.compiler-btn-primary.running {
    background: var(--warning, #f59e0b);
}

/* Editor Area */
.compiler-editor {
    position: relative;
    min-height: 150px;
    max-height: 400px;
    overflow: hidden;
    display: flex;
    flex-direction: column;
}

.compiler-pane {
    display: none;
    flex: 1;
    min-height: 150px;
    max-height: 400px;
    overflow: hidden;
    position: relative;
}

.compiler-pane.active {
    display: block;
}

.compiler-textarea {
    flex: 1;
    min-height: 150px;
    max-height: 400px;
}

/* CodeMirror styles override for compiler container */
.compiler-container .CodeMirror {
    height: auto;
    min-height: 150px;
    max-height: 400px;
    font-family: 'JetBrains Mono', 'Fira Code', monospace;
    font-size: var(--text-sm, 0.875rem);
    line-height: 1.6;
}

.compiler-container .CodeMirror-scroll {
    min-height: 150px;
    max-height: 400px;
}

.compiler-container .CodeMirror-gutters {
    border-right: 1px solid var(--border-color, #e2e8f0);
    background-color: var(--bg-tertiary, #f1f5f9);
}

[data-theme="dark"] .compiler-container .CodeMirror-gutters {
    background-color: #1e1e1e;
    border-color: #333;
}

.compiler-input {
    background: var(--bg-secondary, #f8fafc);
}

[data-theme="dark"] .compiler-input {
    background: #252526;
}

/* Output Section */
.compiler-output {
    border-top: 1px solid var(--border-color, #e2e8f0);
    background: #1a1a2e;
}

[data-theme="dark"] .compiler-output {
    border-color: #333;
}

.compiler-output.collapsible .output-header {
    cursor: pointer;
}

.compiler-output.collapsible.collapsed .output-body {
    display: none;
}

.compiler-output.collapsible.collapsed .collapse-icon {
    transform: rotate(-90deg);
}

.output-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 8px 12px;
    background: #16162a;
    border-bottom: 1px solid #2a2a4a;
}

.output-title {
    display: flex;
    align-items: center;
    gap: 8px;
}

.collapse-icon {
    width: 16px;
    height: 16px;
    color: #858585;
    transition: transform 0.2s ease;
}

.output-label {
    font-size: var(--text-xs, 0.75rem);
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: #858585;
}

.output-status {
    font-size: var(--text-xs, 0.75rem);
    padding: 2px 8px;
    border-radius: 4px;
}

.output-status.success {
    background: rgba(16, 185, 129, 0.2);
    color: #10b981;
}

.output-status.error {
    background: rgba(239, 68, 68, 0.2);
    color: #ef4444;
}

.output-status.running {
    background: rgba(245, 158, 11, 0.2);
    color: #f59e0b;
}

.output-actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.output-stats {
    font-size: var(--text-xs, 0.75rem);
    color: #6b7280;
    font-family: monospace;
}

.output-btn {
    padding: 4px;
    background: transparent;
    border: none;
    color: #6b7280;
    cursor: pointer;
    border-radius: 4px;
    transition: all 0.15s ease;
}

.output-btn:hover {
    background: rgba(255,255,255,0.1);
    color: #a1a1aa;
}

.output-btn svg {
    width: 14px;
    height: 14px;
}

.output-body {
    max-height: 250px;
    overflow-y: auto;
}

.output-content {
    margin: 0;
    padding: 12px;
    font-family: 'JetBrains Mono', 'Fira Code', monospace;
    font-size: var(--text-sm, 0.875rem);
    line-height: 1.6;
    color: #d4d4d4;
    white-space: pre-wrap;
    word-break: break-word;
}

.output-placeholder {
    color: #6b7280;
}

.output-content.error {
    color: #f87171;
}

.output-content.success {
    color: #4ade80;
}

/* Spinner Animation */
.spinner {
    display: inline-block;
    width: 14px;
    height: 14px;
    border: 2px solid rgba(255,255,255,0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.8s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* Responsive */
@media (max-width: 640px) {
    .compiler-header {
        flex-direction: column;
        gap: var(--space-2, 0.5rem);
        align-items: stretch;
    }

    .compiler-tabs {
        justify-content: center;
    }

    .compiler-actions {
        justify-content: center;
    }

    .output-stats {
        display: none;
    }
}
</style>

<script>
(function() {
    const editorId = '<%= editorId %>';
    const language = '<%= language %>';
    const initialCode = '<%= escapedCode %>';
    let codeEditor = null; // CodeMirror editor instance

    // Initialize CodeMirror editor
    function initCodeMirrorEditor() {
        const textarea = document.getElementById(editorId + '-code');
        if (!textarea || typeof CodeMirror === 'undefined') {
            console.warn('CodeMirror not available for editor:', editorId);
            return;
        }

        // Map language to CodeMirror mode
        const modeMap = {
            'python': 'python',
            'java': 'text/x-java',
            'go': 'go',
            'cpp': 'text/x-c++src',
            'c++': 'text/x-c++src',
            'c': 'text/x-csrc',
            'ruby': 'ruby',
            'rust': 'rust',
            'javascript': 'javascript',
            'nodejs': 'javascript',
            'typescript': 'text/typescript',
            'php': 'text/x-php',
            'kotlin': 'text/x-kotlin',
            'swift': 'swift',
            'scala': 'text/x-scala',
            'bash': 'shell',
            'shell': 'shell',
            'sh': 'shell'
        };

        const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        const mode = modeMap[language] || 'python';

        codeEditor = CodeMirror.fromTextArea(textarea, {
            mode: mode,
            theme: isDark ? 'monokai' : 'default',
            lineNumbers: true,
            lineWrapping: true,
            indentUnit: 4,
            tabSize: 4,
            indentWithTabs: false,
            matchBrackets: true,
            autoCloseBrackets: true,
            extraKeys: {
                'Tab': function(cm) {
                    // Use spaces for indentation
                    if (cm.somethingSelected()) {
                        cm.indentSelection('add');
                    } else {
                        cm.replaceSelection('    ', 'end');
                    }
                },
                'Shift-Tab': function(cm) {
                    cm.indentSelection('subtract');
                }
            }
        });

        // Set initial code
        codeEditor.setValue(initialCode.replace(/\\n/g, '\n'));

        // Store editor instance globally for reset/run functions
        window.codeMirrorEditors = window.codeMirrorEditors || {};
        window.codeMirrorEditors[editorId] = codeEditor;

        // Watch for theme changes
        const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
                if (mutation.type === 'attributes' && mutation.attributeName === 'data-theme') {
                    const isDarkNow = document.documentElement.getAttribute('data-theme') === 'dark';
                    codeEditor.setOption('theme', isDarkNow ? 'monokai' : 'default');
                }
            });
        });
        observer.observe(document.documentElement, { attributes: true });
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        initCodeMirrorEditor();
    });

    // Tab switching
    window.switchCompilerTab = window.switchCompilerTab || function(id, tab) {
        const container = document.getElementById(id + '-container');
        if (!container) return;

        const tabs = container.querySelectorAll('.compiler-tab');
        const codePaneEl = document.getElementById(id + '-code-pane');
        const inputPaneEl = document.getElementById(id + '-input-pane');

        tabs.forEach(t => t.classList.remove('active'));

        if (tab === 'input') {
            tabs[1].classList.add('active');
            codePaneEl.classList.remove('active');
            codePaneEl.style.display = 'none';
            inputPaneEl.classList.add('active');
            inputPaneEl.style.display = 'block';
        } else {
            tabs[0].classList.add('active');
            inputPaneEl.classList.remove('active');
            inputPaneEl.style.display = 'none';
            codePaneEl.classList.add('active');
            codePaneEl.style.display = 'block';
            
            // Refresh CodeMirror editor size when switching back to code tab
            const editor = window.codeMirrorEditors && window.codeMirrorEditors[id];
            if (editor) {
                setTimeout(function() {
                    editor.refresh();
                }, 10);
            }
        }
    };

    // Run compiler
    window.runCompiler = window.runCompiler || function(id) {
        const container = document.getElementById(id + '-container');
        const lang = container.dataset.language;
        
        // Get code from CodeMirror editor if available, otherwise from textarea
        const editor = window.codeMirrorEditors && window.codeMirrorEditors[id];
        const code = editor ? editor.getValue() : document.getElementById(id + '-code').value;
        const input = document.getElementById(id + '-input').value;
        const outputEl = document.getElementById(id + '-output');
        const statusEl = document.getElementById(id + '-status');
        const statsEl = document.getElementById(id + '-stats');
        const runBtn = document.getElementById(id + '-run-btn');

        // Loading state
        outputEl.innerHTML = '<span class="output-placeholder">Running...</span>';
        outputEl.className = 'output-content';
        statusEl.textContent = 'Running';
        statusEl.className = 'output-status running';
        if (statsEl) statsEl.textContent = '';
        runBtn.disabled = true;
        runBtn.classList.add('running');
        runBtn.innerHTML = '<span class="spinner"></span><span>Running</span>';

        const startTime = performance.now();

        // API call
        fetch('<%= request.getContextPath() %>/OneCompilerFunctionality?action=execute', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ language: lang, code: code, input: input })
        })
        .then(response => response.json())
        .then(data => {
            const endTime = performance.now();
            const execTime = ((endTime - startTime) / 1000).toFixed(2);

            let output = '';
            let isError = false;

            // Handle both capitalized (Stdout/Stderr) and lowercase (stdout/stderr) response formats
            const stdout = data.Stdout || data.stdout || '';
            const stderr = data.Stderr || data.stderr || '';
            const exitCode = data.ExitCode !== undefined ? data.ExitCode : data.exitCode;
            const error = data.Error || data.error || '';

            if (stdout) output += stdout;
            if (stderr) {
                if (output) output += '\n';
                output += stderr;
                isError = true;
            }
            if (error) {
                if (output) output += '\n';
                output += 'Error: ' + error;
                isError = true;
            }
            // Check exit code for errors even if no stderr
            if (exitCode !== undefined && exitCode !== 0 && !isError) {
                isError = true;
            }
            if (!output && !isError) {
                output = 'Program completed with no output.';
            }

            outputEl.textContent = output;
            outputEl.className = 'output-content ' + (isError ? 'error' : 'success');
            statusEl.textContent = isError ? 'Error' : 'Success';
            statusEl.className = 'output-status ' + (isError ? 'error' : 'success');

            if (statsEl) {
                statsEl.textContent = execTime + 's';
                const cpuTime = data.CpuTime || data.cpuTime;
                const memory = data.Memory || data.memory;
                if (cpuTime) statsEl.textContent += ' | CPU: ' + cpuTime + 'ms';
                if (memory) statsEl.textContent += ' | Mem: ' + memory;
            }
        })
        .catch(err => {
            outputEl.textContent = 'Execution failed: ' + err.message;
            outputEl.className = 'output-content error';
            statusEl.textContent = 'Failed';
            statusEl.className = 'output-status error';
        })
        .finally(() => {
            runBtn.disabled = false;
            runBtn.classList.remove('running');
            runBtn.innerHTML = '<svg class="play-icon" viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"/></svg><span>Run</span>';
        });
    };

    // Reset
    window.resetCompiler = window.resetCompiler || function(id) {
        const container = document.getElementById(id + '-container');
        const lang = container.dataset.language;
        
        // Reset CodeMirror editor if available
        const editor = window.codeMirrorEditors && window.codeMirrorEditors[id];
        if (editor) {
            editor.setValue(initialCode.replace(/\\n/g, '\n'));
        } else {
            document.getElementById(id + '-code').value = initialCode.replace(/\\n/g, '\n');
        }
        
        document.getElementById(id + '-input').value = '';
        document.getElementById(id + '-output').innerHTML = '<span class="output-placeholder">Click <strong>Run</strong> to execute your code</span>';
        document.getElementById(id + '-output').className = 'output-content';
        document.getElementById(id + '-status').textContent = '';
        document.getElementById(id + '-status').className = 'output-status';
        const statsEl = document.getElementById(id + '-stats');
        if (statsEl) statsEl.textContent = '';
    };

    // Copy output
    window.copyOutput = window.copyOutput || function(id) {
        const output = document.getElementById(id + '-output').textContent;
        navigator.clipboard.writeText(output).then(() => {
            // Brief visual feedback could be added here
        });
    };

    // Clear output
    window.clearOutput = window.clearOutput || function(id) {
        document.getElementById(id + '-output').innerHTML = '<span class="output-placeholder">Output cleared</span>';
        document.getElementById(id + '-output').className = 'output-content';
        document.getElementById(id + '-status').textContent = '';
        document.getElementById(id + '-status').className = 'output-status';
        const statsEl = document.getElementById(id + '-stats');
        if (statsEl) statsEl.textContent = '';
    };

    // Toggle collapsible output
    window.toggleOutput = window.toggleOutput || function(id) {
        const container = document.getElementById(id + '-output-container');
        if (container) {
            container.classList.toggle('collapsed');
        }
    };
})();
</script>
