<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.io.*, java.nio.file.*, java.nio.charset.StandardCharsets" %>
        <%-- Server-Side Language Compiler Component For Python, Java, Go, C++, etc. - languages that need server
            execution Parameters: - initialCode: The initial code to display (inline) - codeFile: Path to external code
            file (relative to /tutorials/code/) - language: Programming language (python, java, go, cpp, c, ruby, rust,
            etc.) - editorId: Unique ID for this editor instance (default: 'compiler1' ) - filename: Display filename
            (default: based on language) - showStats: Show execution stats (default: true) - collapsible: Make output
            collapsible (default: false) Usage (inline code): <jsp:include page="../tutorial-compiler.jsp">
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

    if (initialCode == null) {
        initialCode = "print('Hello, World!')";
    }

    // Convert literal \n to actual newlines for textarea display
    // (only needed for inline code)
    String displayCode = (codeFile != null) ? initialCode : initialCode.replace("\\n", "\n").replace("\\t", "\t");

    String language = request.getParameter("language");
    if (language == null) {
        language = "python";
    }

    String editorId = request.getParameter("editorId");
    if (editorId == null) {
        editorId = "compiler1";
    }

    String filename = request.getParameter("filename");
    if (filename == null) {
        // Default filenames by language
        switch (language) {
            case "python":
                filename = "main.py";
                break;
            case "java":
                filename = "Main.java";
                break;
            case "go":
                filename = "main.go";
                break;
            case "cpp":
            case "c++":
                filename = "main.cpp";
                break;
            case "c":
                filename = "main.c";
                break;
            case "ruby":
                filename = "main.rb";
                break;
            case "rust":
                filename = "main.rs";
                break;
            case "javascript":
            case "nodejs":
                filename = "index.js";
                break;
            case "typescript":
                filename = "index.ts";
                break;
            case "php":
                filename = "index.php";
                break;
            case "kotlin":
                filename = "Main.kt";
                break;
            case "swift":
                filename = "main.swift";
                break;
            case "scala":
                filename = "Main.scala";
                break;
            case "bash":
            case "shell":
            case "sh":
                filename = "script.sh";
                break;
            case "lua":
                filename = "main.lua";
                break;
            default:
                filename = "main." + language;
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

<div class=" compiler-container" id="<%= editorId %>-container" data-language="<%= language %>">
                <!-- Editor Header -->
                <div class="compiler-header">
                    <div class="compiler-tabs">
                        <button class="compiler-tab active" data-tab="code"
                            onclick="switchCompilerTab('<%= editorId %>', 'code')">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <polyline points="16 18 22 12 16 6"></polyline>
                                <polyline points="8 6 2 12 8 18"></polyline>
                            </svg>
                            <%= filename %>
                        </button>
                        <button class="compiler-tab" data-tab="input"
                            onclick="switchCompilerTab('<%= editorId %>', 'input')">
                            <svg class="tab-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                stroke-width="2">
                                <path d="M4 17l6-6-6-6M12 19h8"></path>
                            </svg>
                            Input
                        </button>
                    </div>
                    <div class="compiler-actions">
                        <button class="compiler-btn compiler-btn-ghost" onclick="resetCompiler('<%= editorId %>')"
                            title="Reset Code">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"></path>
                                <path d="M3 3v5h5"></path>
                            </svg>
                        </button>
                        <button class="compiler-btn compiler-btn-primary" id="<%= editorId %>-run-btn"
                            onclick="runCompiler('<%= editorId %>')">
                            <svg class="play-icon" viewBox="0 0 24 24" fill="currentColor">
                                <path d="M8 5v14l11-7z" />
                            </svg>
                            <span>Run</span>
                        </button>
                    </div>
                </div>

                <!-- Code Editor Panes -->
                <div class="compiler-editor">
                    <div class="compiler-pane active" id="<%= editorId %>-code-pane">
                        <textarea id="<%= editorId %>-code" class="compiler-textarea" spellcheck="false"
                            autocomplete="off" autocorrect="off" autocapitalize="off"><%= displayCode %></textarea>
                    </div>
                    <div class="compiler-pane" id="<%= editorId %>-input-pane" style="display: none;">
                        <textarea id="<%= editorId %>-input" class="compiler-textarea compiler-input"
                            placeholder="Enter input for your program (stdin)..." spellcheck="false"></textarea>
                    </div>
                </div>

                <!-- Output Section -->
                <div class="compiler-output <%= isCollapsible ? " collapsible" : "" %>" id="<%= editorId %>
                        -output-container">
                        <div class="output-header" <% if(isCollapsible) { %>onclick="toggleOutput('<%= editorId %>')"<%
                                    } %>>
                                    <div class="output-title">
                                        <% if(isCollapsible) { %>
                                            <svg class="collapse-icon" viewBox="0 0 24 24" fill="none"
                                                stroke="currentColor" stroke-width="2">
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
                                                <button class="output-btn" onclick="copyOutput('<%= editorId %>')"
                                                    title="Copy Output">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                                                        <path
                                                            d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1">
                                                        </path>
                                                    </svg>
                                                </button>
                                                <button class="output-btn" onclick="clearOutput('<%= editorId %>')"
                                                    title="Clear Output">
                                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                                                        stroke-width="2">
                                                        <path
                                                            d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2">
                                                        </path>
                                                    </svg>
                                                </button>
                                    </div>
                        </div>
                        <div class="output-body" id="<%= editorId %>-output-body">
                            <pre id="<%= editorId %>-output" class="output-content">
<span class="output-placeholder">Click <strong>Run</strong> to execute your code</span></pre>
                        </div>

                        <!-- AI Toolbar -->
                        <div class="ai-toolbar" id="<%= editorId %>-ai-toolbar">
                            <div class="ai-toolbar-row">
                                <button class="ai-btn" id="<%= editorId %>-ai-explain-btn"
                                    onclick="askAI('<%= editorId %>', 'explain')" title="Explain what the code does or why it errored">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path><line x1="12" y1="17" x2="12.01" y2="17"></line></svg>
                                    <span>Explain</span>
                                </button>
                                <button class="ai-btn ai-btn-fix" id="<%= editorId %>-ai-fix-btn"
                                    onclick="askAI('<%= editorId %>', 'fix')" title="Fix the error" style="display:none;">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                                    <span>Fix it</span>
                                </button>
                                <button class="ai-btn" onclick="askAI('<%= editorId %>', 'explainCode')" title="Explain the current code">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="16 18 22 12 16 6"></polyline><polyline points="8 6 2 12 8 18"></polyline></svg>
                                    <span>Explain code</span>
                                </button>
                                <button class="ai-btn" onclick="askAI('<%= editorId %>', 'challenge')" title="Get a practice challenge">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M6 9l6 6 6-6"></path></svg>
                                    <span>Challenge me</span>
                                </button>
                                <div class="ai-modify-wrap">
                                    <input type="text" class="ai-modify-input" id="<%= editorId %>-ai-modify-input"
                                        placeholder="Modify code: e.g. add error handling, use a waitgroup..."
                                        onkeydown="if(event.key==='Enter'){askAI('<%= editorId %>', 'modify')}" />
                                    <button class="ai-btn ai-btn-modify" onclick="askAI('<%= editorId %>', 'modify')" title="Modify code">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                                    </button>
                                </div>
                            </div>
                            <div class="ai-panel" id="<%= editorId %>-ai-panel" style="display:none;">
                                <div class="ai-panel-header">
                                    <span class="ai-panel-title" id="<%= editorId %>-ai-panel-title">AI</span>
                                    <div class="ai-panel-actions">
                                        <button class="ai-cancel-btn" id="<%= editorId %>-ai-cancel-btn"
                                            onclick="cancelAI('<%= editorId %>')" title="Stop generating" style="display:none;">Stop</button>
                                        <button class="ai-panel-close" onclick="closeAIPanel('<%= editorId %>')" title="Close">&times;</button>
                                    </div>
                                </div>
                                <div class="ai-panel-body" id="<%= editorId %>-ai-panel-body"></div>
                            </div>
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
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
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
                        background: var(--bg-hover, rgba(0, 0, 0, 0.05));
                        color: var(--text-primary, #1e293b);
                    }

                    .compiler-tab.active {
                        background: var(--bg-primary, #fff);
                        color: var(--text-primary, #1e293b);
                        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
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
                        background: var(--bg-hover, rgba(0, 0, 0, 0.05));
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

                    .compiler-output.collapsible.collapsed .ai-toolbar {
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
                        background: rgba(255, 255, 255, 0.1);
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

                    /* AI Toolbar */
                    .ai-toolbar {
                        padding: 8px 12px;
                        background: #16162a;
                        border-top: 1px solid #2a2a4a;
                    }

                    .ai-toolbar-row {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 6px;
                        align-items: center;
                    }

                    .ai-btn {
                        display: inline-flex;
                        align-items: center;
                        gap: 5px;
                        padding: 5px 10px;
                        font-size: var(--text-xs, 0.75rem);
                        font-weight: 600;
                        color: #c4b5fd;
                        background: rgba(139, 92, 246, 0.12);
                        border: 1px solid rgba(139, 92, 246, 0.3);
                        border-radius: 6px;
                        cursor: pointer;
                        transition: all 0.15s ease;
                        white-space: nowrap;
                    }

                    .ai-btn:hover {
                        background: rgba(139, 92, 246, 0.25);
                        border-color: rgba(139, 92, 246, 0.5);
                        color: #ddd6fe;
                    }

                    .ai-btn:disabled {
                        opacity: 0.5;
                        cursor: not-allowed;
                    }

                    .ai-btn svg {
                        width: 13px;
                        height: 13px;
                    }

                    .ai-btn-fix {
                        color: #fca5a5;
                        background: rgba(239, 68, 68, 0.12);
                        border-color: rgba(239, 68, 68, 0.4);
                    }

                    .ai-btn-fix:hover {
                        background: rgba(239, 68, 68, 0.25);
                        color: #fecaca;
                        border-color: rgba(239, 68, 68, 0.6);
                    }

                    .ai-modify-wrap {
                        display: flex;
                        flex: 1;
                        min-width: 200px;
                        gap: 4px;
                    }

                    .ai-modify-input {
                        flex: 1;
                        padding: 5px 10px;
                        font-size: var(--text-xs, 0.75rem);
                        color: #d4d4d4;
                        background: rgba(255, 255, 255, 0.04);
                        border: 1px solid #2a2a4a;
                        border-radius: 6px;
                        outline: none;
                        transition: border-color 0.15s ease;
                    }

                    .ai-modify-input:focus {
                        border-color: rgba(139, 92, 246, 0.6);
                        background: rgba(255, 255, 255, 0.07);
                    }

                    .ai-modify-input::placeholder {
                        color: #6b7280;
                    }

                    .ai-btn-modify {
                        padding: 5px 8px;
                    }

                    .ai-panel {
                        margin-top: 8px;
                        background: rgba(139, 92, 246, 0.06);
                        border: 1px solid rgba(139, 92, 246, 0.25);
                        border-radius: 8px;
                        overflow: hidden;
                    }

                    .ai-panel-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 6px 10px;
                        background: rgba(139, 92, 246, 0.1);
                        border-bottom: 1px solid rgba(139, 92, 246, 0.2);
                    }

                    .ai-panel-title {
                        font-size: var(--text-xs, 0.75rem);
                        font-weight: 700;
                        text-transform: uppercase;
                        letter-spacing: 0.05em;
                        color: #c4b5fd;
                    }

                    .ai-panel-close {
                        background: transparent;
                        border: none;
                        color: #9ca3af;
                        font-size: 18px;
                        line-height: 1;
                        cursor: pointer;
                        padding: 0 4px;
                    }

                    .ai-panel-close:hover {
                        color: #fca5a5;
                    }

                    .ai-panel-actions {
                        display: flex;
                        align-items: center;
                        gap: 6px;
                    }

                    .ai-cancel-btn {
                        padding: 3px 10px;
                        font-size: 11px;
                        font-weight: 600;
                        color: #fca5a5;
                        background: rgba(239, 68, 68, 0.15);
                        border: 1px solid rgba(239, 68, 68, 0.4);
                        border-radius: 4px;
                        cursor: pointer;
                        transition: all 0.15s ease;
                    }

                    .ai-cancel-btn:hover {
                        background: rgba(239, 68, 68, 0.3);
                        color: #fecaca;
                    }

                    /* Busy state — disable all AI inputs during streaming */
                    .compiler-container[data-ai-busy="1"] .ai-btn,
                    .compiler-container[data-ai-busy="1"] .ai-modify-input,
                    .compiler-container[data-ai-busy="1"] .ai-apply-btn {
                        opacity: 0.5;
                        pointer-events: none;
                        cursor: not-allowed;
                    }

                    .compiler-container[data-ai-busy="1"] .ai-panel {
                        border-color: rgba(245, 158, 11, 0.4);
                    }

                    .compiler-container[data-ai-busy="1"] .ai-panel-title {
                        color: #fbbf24;
                    }

                    .ai-panel-body {
                        padding: 10px 12px;
                        font-size: var(--text-sm, 0.875rem);
                        line-height: 1.55;
                        color: #d4d4d4;
                        max-height: 320px;
                        overflow-y: auto;
                        white-space: pre-wrap;
                        word-break: break-word;
                    }

                    .ai-panel-body code {
                        background: rgba(255, 255, 255, 0.08);
                        padding: 1px 5px;
                        border-radius: 3px;
                        font-family: 'JetBrains Mono', 'Fira Code', monospace;
                        font-size: 0.85em;
                        color: #fbbf24;
                    }

                    .ai-panel-body .ai-codeblock {
                        display: block;
                        background: #0f0f1e;
                        border: 1px solid #2a2a4a;
                        border-radius: 6px;
                        padding: 10px;
                        margin: 8px 0;
                        overflow-x: auto;
                        color: #e5e7eb;
                        white-space: pre;
                    }

                    .ai-panel-body .ai-codeblock-wrap {
                        position: relative;
                    }

                    .ai-apply-btn {
                        position: absolute;
                        top: 6px;
                        right: 6px;
                        padding: 3px 8px;
                        font-size: 11px;
                        font-weight: 600;
                        color: #86efac;
                        background: rgba(16, 185, 129, 0.15);
                        border: 1px solid rgba(16, 185, 129, 0.4);
                        border-radius: 4px;
                        cursor: pointer;
                    }

                    .ai-apply-btn:hover {
                        background: rgba(16, 185, 129, 0.3);
                        color: #bbf7d0;
                    }

                    .ai-thinking {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        color: #9ca3af;
                        font-style: italic;
                    }

                    .ai-thinking-dot {
                        width: 4px;
                        height: 4px;
                        border-radius: 50%;
                        background: #c4b5fd;
                        animation: aiPulse 1.2s ease-in-out infinite;
                    }

                    .ai-thinking-dot:nth-child(2) { animation-delay: 0.2s; }
                    .ai-thinking-dot:nth-child(3) { animation-delay: 0.4s; }

                    @keyframes aiPulse {
                        0%, 80%, 100% { opacity: 0.3; transform: scale(0.8); }
                        40% { opacity: 1; transform: scale(1.2); }
                    }

                    .ai-error {
                        color: #fca5a5;
                    }

                    @media (max-width: 640px) {
                        .ai-modify-wrap { width: 100%; order: 99; }
                    }

                    /* Spinner Animation */
                    .spinner {
                        display: inline-block;
                        width: 14px;
                        height: 14px;
                        border: 2px solid rgba(255, 255, 255, 0.3);
                        border-top-color: white;
                        border-radius: 50%;
                        animation: spin 0.8s linear infinite;
                    }

                    @keyframes spin {
                        to {
                            transform: rotate(360deg);
                        }
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
                    (function () {
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

                            // Store original code from textarea BEFORE CodeMirror takes over (preserves escape sequences)
                            const originalCode = textarea.value;

                            // Store in container data attribute for reset function
                            const container = document.getElementById(editorId + '-container');
                            if (container) {
                                container.dataset.originalCode = originalCode;
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
                                'sh': 'shell',
                                'lua': 'text/x-lua'
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
                                    'Tab': function (cm) {
                                        // Use spaces for indentation
                                        if (cm.somethingSelected()) {
                                            cm.indentSelection('add');
                                        } else {
                                            cm.replaceSelection('    ', 'end');
                                        }
                                    },
                                    'Shift-Tab': function (cm) {
                                        cm.indentSelection('subtract');
                                    }
                                }
                            });

                            // Set initial code from textarea (preserves escape sequences like \n in strings)
                            codeEditor.setValue(originalCode);

                            // Store editor instance globally for reset/run functions
                            window.codeMirrorEditors = window.codeMirrorEditors || {};
                            window.codeMirrorEditors[editorId] = codeEditor;

                            // Watch for theme changes
                            const observer = new MutationObserver(function (mutations) {
                                mutations.forEach(function (mutation) {
                                    if (mutation.type === 'attributes' && mutation.attributeName === 'data-theme') {
                                        const isDarkNow = document.documentElement.getAttribute('data-theme') === 'dark';
                                        codeEditor.setOption('theme', isDarkNow ? 'monokai' : 'default');
                                    }
                                });
                            });
                            observer.observe(document.documentElement, { attributes: true });
                        }

                        // Initialize
                        document.addEventListener('DOMContentLoaded', function () {
                            initCodeMirrorEditor();
                        });

                        // Tab switching
                        window.switchCompilerTab = window.switchCompilerTab || function (id, tab) {
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
                                    setTimeout(function () {
                                        editor.refresh();
                                    }, 10);
                                }
                            }
                        };

                        // Run compiler
                        window.runCompiler = window.runCompiler || function (id) {
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

                                    // Stash last run for AI
                                    container.dataset.lastStdout = stdout;
                                    container.dataset.lastStderr = stderr;
                                    container.dataset.lastExitCode = String(exitCode !== undefined ? exitCode : '');
                                    container.dataset.lastError = error;
                                    container.dataset.lastIsError = isError ? '1' : '0';
                                    container.dataset.hasRun = '1';

                                    // Show "Fix it" button if errored
                                    const fixBtn = document.getElementById(id + '-ai-fix-btn');
                                    if (fixBtn) fixBtn.style.display = isError ? '' : 'none';

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
                        window.resetCompiler = window.resetCompiler || function (id) {
                            const container = document.getElementById(id + '-container');
                            const lang = container.dataset.language;

                            // Get original code from container data attribute (preserves escape sequences)
                            const originalCode = container && container.dataset.originalCode
                                ? container.dataset.originalCode
                                : initialCode;

                            // Reset CodeMirror editor if available
                            const editor = window.codeMirrorEditors && window.codeMirrorEditors[id];
                            if (editor) {
                                editor.setValue(originalCode);
                            } else {
                                document.getElementById(id + '-code').value = originalCode;
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
                        window.copyOutput = window.copyOutput || function (id) {
                            const output = document.getElementById(id + '-output').textContent;
                            navigator.clipboard.writeText(output).then(() => {
                                // Brief visual feedback could be added here
                            });
                        };

                        // Clear output
                        window.clearOutput = window.clearOutput || function (id) {
                            document.getElementById(id + '-output').innerHTML = '<span class="output-placeholder">Output cleared</span>';
                            document.getElementById(id + '-output').className = 'output-content';
                            document.getElementById(id + '-status').textContent = '';
                            document.getElementById(id + '-status').className = 'output-status';
                            const statsEl = document.getElementById(id + '-stats');
                            if (statsEl) statsEl.textContent = '';
                        };

                        // Toggle collapsible output
                        window.toggleOutput = window.toggleOutput || function (id) {
                            const container = document.getElementById(id + '-output-container');
                            if (container) {
                                container.classList.toggle('collapsed');
                            }
                        };

                        // ============================================
                        // AI ASSIST — explain errors, fix code, modify, challenge
                        // Shared across all language tutorials
                        // ============================================

                        // Language-specific hints baked into the system prompt
                        const AI_LANG_HINTS = {
                            python: 'Python. Watch for indentation, mutable default args, GIL, scope (LEGB), and common beginner confusions.',
                            java: 'Java. Watch for NullPointerException, generics erasure, checked exceptions, static vs instance, equals/hashCode.',
                            go: 'Go. Watch for goroutine leaks, nil channels, unbuffered channel deadlocks, loop variable capture, interface nil != nil.',
                            cpp: 'C++. Watch for undefined behavior, dangling pointers, rule of three/five, memory leaks, reference vs pointer.',
                            'c++': 'C++. Watch for undefined behavior, dangling pointers, rule of three/five, memory leaks, reference vs pointer.',
                            c: 'C. Watch for null dereference, buffer overflow, uninitialized memory, missing free, format-string mismatches.',
                            rust: 'Rust. Watch for borrow checker errors, lifetime issues, move vs copy, Option/Result handling.',
                            ruby: 'Ruby. Watch for nil, symbol vs string keys, block/proc/lambda differences, metaprogramming pitfalls.',
                            javascript: 'JavaScript. Watch for async/await, undefined vs null, this binding, type coercion (== vs ===), closures.',
                            nodejs: 'Node.js. Watch for async/await, undefined vs null, this binding, type coercion, event loop, callbacks.',
                            typescript: 'TypeScript. Watch for type errors, any vs unknown, null/undefined handling, generics.',
                            php: 'PHP. Watch for type juggling, == vs ===, undefined variables, array vs object.',
                            kotlin: 'Kotlin. Watch for null safety (?, !!), coroutines, data classes, extension functions.',
                            swift: 'Swift. Watch for optionals, force-unwrapping, value vs reference types, protocol conformance.',
                            scala: 'Scala. Watch for implicit conversions, Option vs null, immutability, pattern matching.',
                            bash: 'Bash. Watch for quoting, word splitting, [ vs [[, exit codes, subshells vs current shell.',
                            shell: 'Shell. Watch for quoting, word splitting, [ vs [[, exit codes, subshells vs current shell.',
                            sh: 'Shell. Watch for quoting, word splitting, [ vs [[, exit codes, subshells vs current shell.',
                            lua: 'Lua. Watch for 1-based indexing, nil vs false, metatables, local vs global.'
                        };

                        function aiSystemPrompt(lang, mode, lessonHint) {
                            const hint = AI_LANG_HINTS[lang] || (lang + ' programming.');
                            const langName = lang.charAt(0).toUpperCase() + lang.slice(1);
                            const common = 'You are a patient coding tutor for learners. Language: ' + langName + '. ' + hint
                                + ' Be concise and specific. Point to exact line numbers when possible.'
                                + ' Use inline `code` for identifiers. Wrap complete code examples in ```' + lang + ' fenced code blocks.'
                                + ' No filler, no meta-commentary.';
                            if (lessonHint) {
                                return common + ' The learner is on a lesson about: ' + lessonHint + '.';
                            }
                            return common;
                        }

                        function buildAIPrompt(mode, ctx) {
                            const code = ctx.code || '';
                            const stderr = ctx.stderr || '';
                            const stdout = ctx.stdout || '';
                            const exitCode = ctx.exitCode;
                            const isError = ctx.isError;

                            if (mode === 'explain') {
                                if (isError && stderr) {
                                    return 'The following ' + ctx.lang + ' code failed with this error:\n\n'
                                        + 'CODE:\n```' + ctx.lang + '\n' + code + '\n```\n\n'
                                        + 'ERROR:\n```\n' + stderr + '\n```\n\n'
                                        + 'Explain in 2-4 short paragraphs what went wrong, why, and show the corrected code in a fenced code block.';
                                }
                                return 'The following ' + ctx.lang + ' code was run:\n\n```' + ctx.lang + '\n' + code + '\n```\n\n'
                                    + 'OUTPUT:\n```\n' + (stdout || '(no output)') + '\n```\n\n'
                                    + 'Walk through what this program did and why it produced that output. Keep it tight (3-5 sentences).';
                            }
                            if (mode === 'fix') {
                                return 'Fix this ' + ctx.lang + ' code. It fails with the error below.\n\n'
                                    + 'CODE:\n```' + ctx.lang + '\n' + code + '\n```\n\n'
                                    + 'ERROR:\n```\n' + (stderr || ('exit ' + exitCode)) + '\n```\n\n'
                                    + 'First, one short sentence describing the fix. Then the complete corrected code in a single fenced ```' + ctx.lang + ' block — I will replace my editor with it.';
                            }
                            if (mode === 'explainCode') {
                                return 'Explain this ' + ctx.lang + ' code to a learner. Walk through what each major section does. Note any idiomatic patterns or potential pitfalls. Keep it tight.\n\n'
                                    + '```' + ctx.lang + '\n' + code + '\n```';
                            }
                            if (mode === 'modify') {
                                return 'Modify this ' + ctx.lang + ' code as requested.\n\n'
                                    + 'CURRENT CODE:\n```' + ctx.lang + '\n' + code + '\n```\n\n'
                                    + 'REQUEST: ' + ctx.request + '\n\n'
                                    + 'Return the complete modified code in a single fenced ```' + ctx.lang + ' block — it will replace the editor. One short sentence before the block describing the change.';
                            }
                            if (mode === 'challenge') {
                                return 'Give the learner one short practice exercise based on this ' + ctx.lang + ' code. '
                                    + 'Describe the challenge in 1-2 sentences, then provide starter code in a fenced ```' + ctx.lang + ' block (they can click "Apply" to load it). '
                                    + 'Then list 2-3 hints on separate lines starting with "Hint:". Do not include the full solution.\n\n'
                                    + 'CURRENT CODE:\n```' + ctx.lang + '\n' + code + '\n```';
                            }
                            return code;
                        }

                        // Render AI response: convert ```lang\ncode``` fences into code blocks with Apply button,
                        // and `code` inline spans into <code>
                        function renderAIMarkdown(id, text) {
                            // Escape HTML
                            function esc(s) {
                                return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
                            }
                            const parts = [];
                            const re = /```([a-zA-Z0-9_+-]*)\n?([\s\S]*?)```/g;
                            let last = 0;
                            let m;
                            let blockIdx = 0;
                            while ((m = re.exec(text)) !== null) {
                                if (m.index > last) {
                                    parts.push({ type: 'text', value: text.slice(last, m.index) });
                                }
                                parts.push({ type: 'code', lang: m[1], value: m[2], idx: blockIdx++ });
                                last = m.index + m[0].length;
                            }
                            if (last < text.length) {
                                parts.push({ type: 'text', value: text.slice(last) });
                            }
                            let html = '';
                            parts.forEach(function (p) {
                                if (p.type === 'text') {
                                    // Inline `code`
                                    let t = esc(p.value);
                                    t = t.replace(/`([^`\n]+)`/g, '<code>$1</code>');
                                    // Bold **text**
                                    t = t.replace(/\*\*([^*\n]+)\*\*/g, '<strong>$1</strong>');
                                    html += t;
                                } else {
                                    const codeId = id + '-ai-code-' + p.idx;
                                    html += '<div class="ai-codeblock-wrap">'
                                        + '<button class="ai-apply-btn" onclick="applyAICode(\'' + id + '\', \'' + codeId + '\')">Apply to editor</button>'
                                        + '<pre class="ai-codeblock" id="' + codeId + '">' + esc(p.value) + '</pre>'
                                        + '</div>';
                                }
                            });
                            return html;
                        }

                        function openAIPanel(id, title) {
                            const panel = document.getElementById(id + '-ai-panel');
                            const titleEl = document.getElementById(id + '-ai-panel-title');
                            const body = document.getElementById(id + '-ai-panel-body');
                            if (!panel || !body) return;
                            panel.style.display = '';
                            if (titleEl) titleEl.textContent = title || 'AI';
                            body.innerHTML = '<span class="ai-thinking">Thinking'
                                + '<span class="ai-thinking-dot"></span>'
                                + '<span class="ai-thinking-dot"></span>'
                                + '<span class="ai-thinking-dot"></span>'
                                + '</span>';
                        }

                        window.closeAIPanel = window.closeAIPanel || function (id) {
                            // If still streaming, abort first
                            const ctrl = aiControllers[id];
                            if (ctrl) {
                                try { ctrl.abort(); } catch (e) { /* ignore */ }
                            }
                            const panel = document.getElementById(id + '-ai-panel');
                            if (panel) panel.style.display = 'none';
                        };

                        window.applyAICode = window.applyAICode || function (id, codeId) {
                            const codeEl = document.getElementById(codeId);
                            if (!codeEl) return;
                            const newCode = codeEl.textContent;
                            const editor = window.codeMirrorEditors && window.codeMirrorEditors[id];
                            if (editor) {
                                editor.setValue(newCode);
                            } else {
                                const ta = document.getElementById(id + '-code');
                                if (ta) ta.value = newCode;
                            }
                        };

                        // Track in-flight AbortControllers per compiler instance
                        const aiControllers = {};

                        window.cancelAI = window.cancelAI || function (id) {
                            const ctrl = aiControllers[id];
                            if (ctrl) {
                                try { ctrl.abort(); } catch (e) { /* ignore */ }
                            }
                        };

                        function setAIBusy(id, busy) {
                            const container = document.getElementById(id + '-container');
                            if (!container) return;
                            if (busy) {
                                container.dataset.aiBusy = '1';
                            } else {
                                delete container.dataset.aiBusy;
                            }
                            const cancelBtn = document.getElementById(id + '-ai-cancel-btn');
                            if (cancelBtn) cancelBtn.style.display = busy ? '' : 'none';
                        }

                        window.askAI = window.askAI || function (id, mode) {
                            const container = document.getElementById(id + '-container');
                            if (!container) return;

                            // Block duplicate requests while streaming
                            if (container.dataset.aiBusy === '1') return;

                            const lang = container.dataset.language;
                            const editor = window.codeMirrorEditors && window.codeMirrorEditors[id];
                            const code = editor ? editor.getValue() : (document.getElementById(id + '-code') || {}).value || '';

                            const ctx = {
                                lang: lang,
                                code: code,
                                stdout: container.dataset.lastStdout || '',
                                stderr: container.dataset.lastStderr || '',
                                exitCode: container.dataset.lastExitCode || '',
                                isError: container.dataset.lastIsError === '1',
                                error: container.dataset.lastError || ''
                            };

                            if (mode === 'modify') {
                                const input = document.getElementById(id + '-ai-modify-input');
                                const req = input ? input.value.trim() : '';
                                if (!req) {
                                    if (input) input.focus();
                                    return;
                                }
                                ctx.request = req;
                            }

                            if ((mode === 'explain' || mode === 'fix') && !container.dataset.hasRun && !ctx.stderr) {
                                // Nothing to explain yet — fall back to explainCode
                                if (mode === 'fix') {
                                    openAIPanel(id, 'Nothing to fix');
                                    document.getElementById(id + '-ai-panel-body').innerHTML =
                                        '<span class="ai-error">Run the code first — I need an error message to fix.</span>';
                                    return;
                                }
                                mode = 'explainCode';
                            }

                            // Get lesson context if available
                            const body = document.body;
                            const lessonHint = body ? (body.getAttribute('data-lesson') || '') : '';

                            const titles = {
                                explain: 'Explanation',
                                fix: 'Suggested Fix',
                                explainCode: 'Code Walkthrough',
                                modify: 'Modified Code',
                                challenge: 'Practice Challenge'
                            };
                            openAIPanel(id, titles[mode] || 'AI');

                            const systemPrompt = aiSystemPrompt(lang, mode, lessonHint);
                            const userPrompt = buildAIPrompt(mode, ctx);

                            const ctxPath = '<%= request.getContextPath() %>';
                            streamAI(id, mode, systemPrompt, userPrompt, ctxPath);
                        };

                        // Streaming AI — reads NDJSON chunks from /ai, re-renders the panel as tokens arrive
                        async function streamAI(id, mode, systemPrompt, userPrompt, ctxPath) {
                            const bodyEl = document.getElementById(id + '-ai-panel-body');
                            const titleEl = document.getElementById(id + '-ai-panel-title');
                            if (!bodyEl) return;

                            // Mark busy + show Stop button + prep abort controller
                            const controller = new AbortController();
                            aiControllers[id] = controller;
                            setAIBusy(id, true);

                            let text = '';
                            let lastRenderTs = 0;
                            let tokenCount = 0;
                            const titles = {
                                explain: 'Explanation',
                                fix: 'Suggested Fix',
                                explainCode: 'Code Walkthrough',
                                modify: 'Modified Code',
                                challenge: 'Practice Challenge'
                            };
                            const baseTitle = titles[mode] || 'AI';

                            // Throttled incremental render — strips <think> tags while streaming
                            function incRender(force) {
                                const now = Date.now();
                                if (!force && now - lastRenderTs < 120) return;
                                lastRenderTs = now;
                                // Strip closed <think>…</think> blocks; if an unclosed <think> is still streaming, hide everything after it
                                let shown = text.replace(/<think>[\s\S]*?<\/think>/g, '');
                                const openThink = shown.indexOf('<think>');
                                if (openThink !== -1) shown = shown.slice(0, openThink);
                                shown = shown.trim();
                                if (shown) {
                                    bodyEl.innerHTML = renderAIMarkdown(id, shown);
                                } else {
                                    bodyEl.innerHTML = '<span class="ai-thinking">Thinking'
                                        + '<span class="ai-thinking-dot"></span>'
                                        + '<span class="ai-thinking-dot"></span>'
                                        + '<span class="ai-thinking-dot"></span>'
                                        + '</span>';
                                }
                            }

                            try {
                                const resp = await fetch(ctxPath + '/ai', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({
                                        messages: [
                                            { role: 'system', content: systemPrompt },
                                            { role: 'user', content: userPrompt }
                                        ],
                                        stream: true
                                    }),
                                    signal: controller.signal
                                });

                                if (resp.status === 429) throw new Error('Rate limit — try again in a minute.');
                                if (!resp.ok) throw new Error('AI is temporarily unavailable (' + resp.status + ').');

                                const reader = resp.body.getReader();
                                const decoder = new TextDecoder();
                                let buf = '';

                                while (true) {
                                    const { done, value } = await reader.read();
                                    if (done) break;
                                    buf += decoder.decode(value, { stream: true });

                                    // NDJSON — split on newlines, keep incomplete tail in buf
                                    const lines = buf.split('\n');
                                    buf = lines.pop() || '';

                                    for (const line of lines) {
                                        const s = line.trim();
                                        if (!s) continue;
                                        try {
                                            const obj = JSON.parse(s);
                                            // Ollama chat stream: {message:{content:"..."}, done:false}
                                            if (obj.message && obj.message.content) {
                                                text += obj.message.content;
                                                tokenCount++;
                                            }
                                            // Ollama generate stream: {response:"..."}
                                            if (obj.response) {
                                                text += obj.response;
                                                tokenCount++;
                                            }
                                        } catch (e) { /* skip non-JSON line */ }
                                    }

                                    incRender(false);
                                    if (titleEl && tokenCount > 0) {
                                        titleEl.textContent = baseTitle + ' · ' + tokenCount + ' chunks';
                                    }
                                }

                                // Flush trailing buf
                                if (buf.trim()) {
                                    try {
                                        const obj = JSON.parse(buf.trim());
                                        if (obj.message && obj.message.content) text += obj.message.content;
                                        if (obj.response) text += obj.response;
                                    } catch (e) { /* ignore */ }
                                }

                                if (!text.trim()) throw new Error('Empty response from AI.');

                                // Final render
                                text = text.replace(/<think>[\s\S]*?<\/think>/g, '').trim();
                                bodyEl.innerHTML = renderAIMarkdown(id, text);
                                if (titleEl) titleEl.textContent = baseTitle;

                                if (mode === 'modify') {
                                    const input = document.getElementById(id + '-ai-modify-input');
                                    if (input) input.value = '';
                                }
                            } catch (err) {
                                if (err && err.name === 'AbortError') {
                                    // User clicked Stop — preserve partial output, annotate panel
                                    let shown = text.replace(/<think>[\s\S]*?<\/think>/g, '');
                                    const openThink = shown.indexOf('<think>');
                                    if (openThink !== -1) shown = shown.slice(0, openThink);
                                    shown = shown.trim();
                                    if (shown) {
                                        bodyEl.innerHTML = renderAIMarkdown(id, shown)
                                            + '<div class="ai-error" style="margin-top:8px;">Stopped.</div>';
                                    } else {
                                        bodyEl.innerHTML = '<span class="ai-error">Stopped.</span>';
                                    }
                                    if (titleEl) titleEl.textContent = baseTitle + ' (stopped)';
                                } else {
                                    bodyEl.innerHTML = '<span class="ai-error">' + (err.message || 'Something went wrong.') + '</span>';
                                    if (titleEl) titleEl.textContent = baseTitle;
                                }
                            } finally {
                                delete aiControllers[id];
                                setAIBusy(id, false);
                            }
                        }
                    })();
                </script>