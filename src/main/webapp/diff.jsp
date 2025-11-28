<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Advanced Text Diff Tool - Compare Files & Text Online | 8gwifi.org</title>

    <!-- JSON-LD markup -->
    <script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Advanced Text Diff Tool - Compare Files & Text Online",
  "image" : "https://8gwifi.org/images/diff.png",
  "url" : "https://8gwifi.org/diff.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2019-12-11",
  "applicationCategory" : [ "Text comparison", "diff tool", "file comparison" ],
  "downloadUrl" : "https://8gwifi.org/diff.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Web Browser",
  "softwareVersion" : "v2.0"
}
    </script>

    <meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
    <meta name="description" content="Advanced online text and file comparison tool with side-by-side view, syntax highlighting, line numbers, statistics, and multiple diff algorithms.">
    <meta name="keywords" content="diff tool, text comparison, file compare, side by side diff, unified diff, merge tool, code comparison">
    <meta name="author" content="Anish Nath" />
    <meta name="robots" content="index,follow" />
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <%@ include file="header-script.jsp"%>
    <script src="js/diff_match_patch.js"></script>

    <style>
        :root {
            --diff-add-bg: #d1f4d1;
            --diff-add-text: #0a5c0a;
            --diff-del-bg: #ffd7d5;
            --diff-del-text: #c41a16;
            --diff-mod-bg: #fff3cd;
            --diff-mod-text: #856404;
            --diff-line-num: #6c757d;
            --diff-gutter: #f8f9fa;
        }

        .diff-container {
            margin: 2rem 0;
        }

        .diff-controls {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .diff-control-group {
            display: flex;
            gap: 1rem;
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .diff-control-group label {
            font-weight: 600;
            margin-right: 0.5rem;
            color: #495057;
        }

        .diff-btn {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.2s;
        }

        .diff-btn:hover {
            transform: translateY(-2px);
        }

        .diff-btn.secondary {
            background: #6c757d;
        }

        .input-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 768px) {
            .input-section {
                grid-template-columns: 1fr;
            }
        }

        .input-panel {
            border: 2px solid #dee2e6;
            border-radius: 12px;
            padding: 1rem;
            background: white;
        }

        .input-panel h3 {
            margin: 0 0 1rem 0;
            font-size: 1rem;
            color: #495057;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .input-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
            border-bottom: 2px solid #dee2e6;
        }

        .input-tab {
            padding: 0.5rem 1rem;
            background: transparent;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            font-weight: 500;
            color: #6c757d;
        }

        .input-tab.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .file-upload-zone {
            border: 2px dashed #ced4da;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .file-upload-zone:hover,
        .file-upload-zone.dragover {
            border-color: #667eea;
            background: #f8f9ff;
        }

        .file-upload-zone input[type="file"] {
            display: none;
        }

        .file-info {
            margin-top: 0.5rem;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .diff-textarea {
            width: 100%;
            min-height: 300px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 1rem;
            resize: vertical;
        }

        .view-mode-selector {
            display: inline-flex;
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 8px;
            overflow: hidden;
        }

        .view-mode-btn {
            padding: 0.5rem 1rem;
            background: white;
            border: none;
            cursor: pointer;
            font-weight: 500;
            color: #495057;
            transition: all 0.2s;
        }

        .view-mode-btn.active {
            background: #667eea;
            color: white;
        }

        .diff-output {
            background: white;
            border: 2px solid #dee2e6;
            border-radius: 12px;
            padding: 1.5rem;
            margin-top: 1.5rem;
            overflow: auto;
        }

        .diff-stats {
            display: flex;
            gap: 2rem;
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 1rem;
            flex-wrap: wrap;
        }

        .diff-stat {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .diff-stat-value {
            font-size: 1.5rem;
            font-weight: 700;
        }

        .diff-stat-label {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .stat-additions {
            color: #28a745;
        }

        .stat-deletions {
            color: #dc3545;
        }

        .stat-modifications {
            color: #ffc107;
        }

        /* Side-by-side view */
        .diff-sidebyside {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            font-family: 'Courier New', monospace;
            font-size: 13px;
        }

        @media (max-width: 768px) {
            .diff-sidebyside {
                grid-template-columns: 1fr;
            }
        }

        .diff-pane {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            overflow: hidden;
        }

        .diff-pane-header {
            background: #343a40;
            color: white;
            padding: 0.5rem 1rem;
            font-weight: 600;
        }

        .diff-pane-content {
            max-height: 600px;
            overflow: auto;
        }

        .diff-line {
            display: grid;
            grid-template-columns: 40px 40px 1fr;
            padding: 0;
            line-height: 1.5;
        }

        .diff-line-num {
            padding: 0.25rem 0.5rem;
            background: var(--diff-gutter);
            color: var(--diff-line-num);
            text-align: right;
            user-select: none;
            border-right: 1px solid #dee2e6;
        }

        .diff-line-content {
            padding: 0.25rem 0.5rem;
            white-space: pre-wrap;
            word-break: break-all;
        }

        .diff-line-add {
            background: var(--diff-add-bg);
        }

        .diff-line-add .diff-line-content {
            color: var(--diff-add-text);
        }

        .diff-line-del {
            background: var(--diff-del-bg);
        }

        .diff-line-del .diff-line-content {
            color: var(--diff-del-text);
        }

        .diff-line-mod {
            background: var(--diff-mod-bg);
        }

        .diff-line-mod .diff-line-content {
            color: var(--diff-mod-text);
        }

        /* Unified view */
        .diff-unified {
            font-family: 'Courier New', monospace;
            font-size: 13px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            overflow: hidden;
        }

        .diff-unified-header {
            background: #343a40;
            color: white;
            padding: 0.5rem 1rem;
            font-weight: 600;
        }

        .diff-unified-content {
            max-height: 600px;
            overflow: auto;
        }

        /* Inline view (original) */
        .diff-inline {
            font-family: 'Courier New', monospace;
            font-size: 14px;
            line-height: 1.6;
            padding: 1rem;
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 8px;
        }

        .diff-inline ins {
            background: var(--diff-add-bg);
            color: var(--diff-add-text);
            text-decoration: none;
            padding: 0.1rem 0.2rem;
            border-radius: 3px;
        }

        .diff-inline del {
            background: var(--diff-del-bg);
            color: var(--diff-del-text);
            text-decoration: line-through;
            padding: 0.1rem 0.2rem;
            border-radius: 3px;
        }

        .export-options {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        .performance-info {
            color: #6c757d;
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }

        .char-highlight {
            background: rgba(255, 0, 0, 0.3);
            font-weight: 700;
        }

        .loading-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9999;
            align-items: center;
            justify-content: center;
        }

        .loading-overlay.active {
            display: flex;
        }

        .loading-spinner {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            text-align: center;
        }
    </style>
</head>

<div>
    <%@ include file="body-script.jsp"%>

    <div class="page-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 2rem 0; margin-bottom: 2rem;">
        <div class="container">
            <h1 class="display-4"><i class="fas fa-exchange-alt"></i> Advanced Text Diff Tool</h1>
            <p class="lead">Professional file and text comparison with multiple view modes</p>
        </div>
    </div>

    <div class="container">
        <div class="tool-description" style="background: #f8f9fa; border-left: 4px solid #667eea; padding: 1rem; margin-bottom: 2rem;">
            <h4><i class="fas fa-info-circle"></i> About This Tool</h4>
            <p>Compare text and files with advanced features including side-by-side view, unified diff, inline comparison, syntax highlighting, and detailed statistics. Perfect for code review, document comparison, and merge conflict resolution.</p>
        </div>

        <div class="diff-container">
            <!-- Input Section -->
            <div class="input-section">
                <!-- Left Input -->
                <div class="input-panel">
                    <h3><i class="fas fa-file"></i> Original Version</h3>
                    <div class="input-tabs">
                        <button class="input-tab active" onclick="switchTab('left', 'text')">Text Input</button>
                        <button class="input-tab" onclick="switchTab('left', 'file')">File Upload</button>
                    </div>
                    <div id="left-text-tab" class="tab-content active">
                        <textarea class="diff-textarea" id="text1" placeholder="Enter or paste original text here...">function calculateSum(a, b) {
    return a + b;
}

var result = calculateSum(5, 3);
console.log(result);</textarea>
                    </div>
                    <div id="left-file-tab" class="tab-content">
                        <div class="file-upload-zone" id="left-dropzone">
                            <input type="file" id="left-file" accept="text/*,application/*" />
                            <i class="fas fa-cloud-upload-alt fa-3x" style="color: #667eea;"></i>
                            <p><strong>Click to browse</strong> or drag and drop</p>
                            <p style="font-size: 0.9rem; color: #6c757d;">Text files, code files, JSON, XML, etc.</p>
                            <div class="file-info" id="left-file-info"></div>
                        </div>
                    </div>
                </div>

                <!-- Right Input -->
                <div class="input-panel">
                    <h3><i class="fas fa-file"></i> Modified Version</h3>
                    <div class="input-tabs">
                        <button class="input-tab active" onclick="switchTab('right', 'text')">Text Input</button>
                        <button class="input-tab" onclick="switchTab('right', 'file')">File Upload</button>
                    </div>
                    <div id="right-text-tab" class="tab-content active">
                        <textarea class="diff-textarea" id="text2" placeholder="Enter or paste modified text here...">function calculateSum(a, b, c = 0) {
    // Added optional third parameter
    return a + b + c;
}

const result = calculateSum(5, 3, 2);
console.log("Result:", result);</textarea>
                    </div>
                    <div id="right-file-tab" class="tab-content">
                        <div class="file-upload-zone" id="right-dropzone">
                            <input type="file" id="right-file" accept="text/*,application/*" />
                            <i class="fas fa-cloud-upload-alt fa-3x" style="color: #764ba2;"></i>
                            <p><strong>Click to browse</strong> or drag and drop</p>
                            <p style="font-size: 0.9rem; color: #6c757d;">Text files, code files, JSON, XML, etc.</p>
                            <div class="file-info" id="right-file-info"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Controls -->
            <div class="diff-controls">
                <div class="diff-control-group">
                    <label>View Mode:</label>
                    <div class="view-mode-selector">
                        <button class="view-mode-btn active" onclick="setViewMode('sidebyside')">
                            <i class="fas fa-columns"></i> Side by Side
                        </button>
                        <button class="view-mode-btn" onclick="setViewMode('unified')">
                            <i class="fas fa-align-left"></i> Unified
                        </button>
                        <button class="view-mode-btn" onclick="setViewMode('inline')">
                            <i class="fas fa-paragraph"></i> Inline
                        </button>
                    </div>
                </div>

                <div class="diff-control-group">
                    <label>Options:</label>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="ignoreWhitespace">
                        <label class="form-check-label" for="ignoreWhitespace">Ignore whitespace</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="ignoreCase">
                        <label class="form-check-label" for="ignoreCase">Ignore case</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="semantic" checked>
                        <label class="form-check-label" for="semantic">Semantic cleanup</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="showLineNumbers" checked>
                        <label class="form-check-label" for="showLineNumbers">Line numbers</label>
                    </div>
                </div>

                <div class="diff-control-group">
                    <button type="button" onclick="computeDiff()" class="diff-btn">
                        <i class="fas fa-play"></i> Compare
                    </button>
                    <button type="button" onclick="clearAll()" class="diff-btn secondary">
                        <i class="fas fa-eraser"></i> Clear All
                    </button>
                    <button type="button" onclick="swapInputs()" class="diff-btn secondary">
                        <i class="fas fa-exchange-alt"></i> Swap
                    </button>
                </div>
            </div>

            <!-- Output Section -->
            <div id="outputSection" class="diff-output" style="display: none;">
                <div class="diff-stats" id="statsDiv"></div>
                <div id="diffResult"></div>
                <div class="export-options">
                    <button class="btn btn-sm btn-outline-primary" onclick="exportDiff('html')">
                        <i class="fas fa-download"></i> Export HTML
                    </button>
                    <button class="btn btn-sm btn-outline-primary" onclick="exportDiff('txt')">
                        <i class="fas fa-download"></i> Export TXT
                    </button>
                    <button class="btn btn-sm btn-outline-primary" onclick="copyToClipboard()">
                        <i class="fas fa-copy"></i> Copy to Clipboard
                    </button>
                </div>
                <div class="performance-info" id="perfInfo"></div>
            </div>
        </div>

        <!-- Related Tools -->
        <div class="card mt-4">
            <div class="card-header">
                <h4><i class="fas fa-link"></i> Related Tools</h4>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <ul class="list-unstyled">
                            <li><i class="fas fa-file-alt text-muted"></i> <a href="MessageDigest.jsp">File Hash Calculator</a></li>
                            <li><i class="fas fa-exchange-alt text-muted"></i> <a href="HexToStringFunctions.jsp">Text Converters</a></li>
                            <li><i class="fas fa-search text-muted"></i> <a href="regex.jsp">Regex Tester</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <hr>
        <div class="sharethis-inline-share-buttons"></div>
        <%@ include file="thanks.jsp"%>
        <hr>
        <%@ include file="footer_adsense.jsp"%>
        <%@ include file="addcomments.jsp"%>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status"></div>
            <p style="margin-top: 1rem;">Computing differences...</p>
        </div>
    </div>

    <script>
        var dmp = new diff_match_patch();
        var currentViewMode = 'sidebyside';
        var leftFileName = '';
        var rightFileName = '';
        var lastDiff = null;

        // Tab switching
        function switchTab(side, type) {
            var textTab = document.getElementById(side + '-text-tab');
            var fileTab = document.getElementById(side + '-file-tab');
            var tabs = document.querySelectorAll('#' + side + '-dropzone').length > 0
                ? document.querySelectorAll('#' + side + '-dropzone').item(0).parentElement.parentElement.querySelectorAll('.input-tab')
                : [];

            if (type === 'text') {
                textTab.classList.add('active');
                fileTab.classList.remove('active');
                if (tabs.length > 0) {
                    tabs[0].classList.add('active');
                    tabs[1].classList.remove('active');
                }
            } else {
                textTab.classList.remove('active');
                fileTab.classList.add('active');
                if (tabs.length > 0) {
                    tabs[0].classList.remove('active');
                    tabs[1].classList.add('active');
                }
            }
        }

        // File upload handlers
        function setupFileUpload(side) {
            var dropzone = document.getElementById(side + '-dropzone');
            var fileInput = document.getElementById(side + '-file');
            var fileInfo = document.getElementById(side + '-file-info');
            var textarea = document.getElementById(side === 'left' ? 'text1' : 'text2');

            dropzone.addEventListener('click', function() {
                fileInput.click();
            });

            dropzone.addEventListener('dragover', function(e) {
                e.preventDefault();
                dropzone.classList.add('dragover');
            });

            dropzone.addEventListener('dragleave', function(e) {
                e.preventDefault();
                dropzone.classList.remove('dragover');
            });

            dropzone.addEventListener('drop', function(e) {
                e.preventDefault();
                dropzone.classList.remove('dragover');
                var file = e.dataTransfer.files[0];
                if (file) processFile(file, side);
            });

            fileInput.addEventListener('change', function(e) {
                var file = e.target.files[0];
                if (file) processFile(file, side);
            });

            function processFile(file, side) {
                if (side === 'left') leftFileName = file.name;
                else rightFileName = file.name;

                var info = document.getElementById(side + '-file-info');
                info.textContent = 'Loading ' + file.name + ' (' + formatBytes(file.size) + ')...';

                var reader = new FileReader();
                reader.onload = function(e) {
                    var text = e.target.result;
                    var textarea = document.getElementById(side === 'left' ? 'text1' : 'text2');
                    textarea.value = text;
                    info.innerHTML = '<i class="fas fa-check-circle" style="color: #28a745;"></i> ' + file.name + ' (' + formatBytes(file.size) + ')';
                };
                reader.onerror = function() {
                    info.innerHTML = '<i class="fas fa-times-circle" style="color: #dc3545;"></i> Failed to read file';
                };
                reader.readAsText(file);
            }

            function formatBytes(bytes) {
                if (bytes === 0) return '0 Bytes';
                var k = 1024;
                var sizes = ['Bytes', 'KB', 'MB', 'GB'];
                var i = Math.floor(Math.log(bytes) / Math.log(k));
                return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
            }
        }

        setupFileUpload('left');
        setupFileUpload('right');

        // View mode
        function setViewMode(mode) {
            currentViewMode = mode;
            var buttons = document.querySelectorAll('.view-mode-btn');
            buttons.forEach(function(btn) {
                btn.classList.remove('active');
            });
            event.target.closest('.view-mode-btn').classList.add('active');

            if (lastDiff) {
                renderDiff(lastDiff);
            }
        }

        // Compute diff
        function computeDiff() {
            var text1 = document.getElementById('text1').value;
            var text2 = document.getElementById('text2').value;

            if (!text1 && !text2) {
                alert('Please enter text or upload files to compare');
                return;
            }

            document.getElementById('loadingOverlay').classList.add('active');

            setTimeout(function() {
                var startTime = performance.now();

                // Apply preprocessing options
                if (document.getElementById('ignoreWhitespace').checked) {
                    text1 = text1.replace(/\s+/g, ' ');
                    text2 = text2.replace(/\s+/g, ' ');
                }
                if (document.getElementById('ignoreCase').checked) {
                    text1 = text1.toLowerCase();
                    text2 = text2.toLowerCase();
                }

                // Compute diff
                var d = dmp.diff_main(text1, text2);

                if (document.getElementById('semantic').checked) {
                    dmp.diff_cleanupSemantic(d);
                }

                var endTime = performance.now();
                var timeMs = endTime - startTime;

                lastDiff = d;
                renderDiff(d);
                renderStats(d, text1, text2);

                document.getElementById('perfInfo').textContent = 'Computed in ' + timeMs.toFixed(2) + ' ms';
                document.getElementById('outputSection').style.display = 'block';
                document.getElementById('loadingOverlay').classList.remove('active');
            }, 100);
        }

        // Render statistics
        function renderStats(diff, text1, text2) {
            var additions = 0;
            var deletions = 0;
            var modifications = 0;
            var unchanged = 0;

            diff.forEach(function(change) {
                var text = change[1];
                var lines = text.split('\n').length - 1 || 1;

                if (change[0] === 1) additions += lines;
                else if (change[0] === -1) deletions += lines;
                else unchanged += lines;
            });

            modifications = Math.min(additions, deletions);
            additions -= modifications;
            deletions -= modifications;

            var lines1 = text1.split('\n').length;
            var lines2 = text2.split('\n').length;

            var html = '<div class="diff-stat">' +
                '<span class="diff-stat-value stat-additions">+' + additions + '</span>' +
                '<span class="diff-stat-label">Additions</span>' +
            '</div>' +
            '<div class="diff-stat">' +
                '<span class="diff-stat-value stat-deletions">-' + deletions + '</span>' +
                '<span class="diff-stat-label">Deletions</span>' +
            '</div>' +
            '<div class="diff-stat">' +
                '<span class="diff-stat-value stat-modifications">~' + modifications + '</span>' +
                '<span class="diff-stat-label">Modifications</span>' +
            '</div>' +
            '<div class="diff-stat">' +
                '<span class="diff-stat-value">' + unchanged + '</span>' +
                '<span class="diff-stat-label">Unchanged</span>' +
            '</div>' +
            '<div class="diff-stat">' +
                '<span class="diff-stat-value">' + lines1 + ' → ' + lines2 + '</span>' +
                '<span class="diff-stat-label">Total Lines</span>' +
            '</div>';

            document.getElementById('statsDiv').innerHTML = html;
        }

        // Render diff based on view mode
        function renderDiff(diff) {
            var resultDiv = document.getElementById('diffResult');

            if (currentViewMode === 'inline') {
                resultDiv.innerHTML = '<div class="diff-inline">' + dmp.diff_prettyHtml(diff) + '</div>';
            } else if (currentViewMode === 'unified') {
                resultDiv.innerHTML = renderUnifiedDiff(diff);
            } else {
                resultDiv.innerHTML = renderSideBySideDiff(diff);
            }
        }

        // Side-by-side view
        function renderSideBySideDiff(diff) {
            var showLineNums = document.getElementById('showLineNumbers').checked;
            var leftLines = [];
            var rightLines = [];
            var leftNum = 1;
            var rightNum = 1;

            diff.forEach(function(change) {
                var op = change[0];
                var text = change[1];
                var lines = text.split('\n');

                lines.forEach(function(line, idx) {
                    if (idx === lines.length - 1 && line === '') return;

                    if (op === 0) {
                        leftLines.push({ num: leftNum++, content: line, type: 'normal' });
                        rightLines.push({ num: rightNum++, content: line, type: 'normal' });
                    } else if (op === -1) {
                        leftLines.push({ num: leftNum++, content: line, type: 'del' });
                        rightLines.push({ num: '', content: '', type: 'empty' });
                    } else {
                        leftLines.push({ num: '', content: '', type: 'empty' });
                        rightLines.push({ num: rightNum++, content: line, type: 'add' });
                    }
                });
            });

            var leftHtml = '<div class="diff-pane"><div class="diff-pane-header">' +
                (leftFileName || 'Original') + '</div><div class="diff-pane-content">';
            var rightHtml = '<div class="diff-pane"><div class="diff-pane-header">' +
                (rightFileName || 'Modified') + '</div><div class="diff-pane-content">';

            for (var i = 0; i < Math.max(leftLines.length, rightLines.length); i++) {
                var leftLine = leftLines[i] || { num: '', content: '', type: 'empty' };
                var rightLine = rightLines[i] || { num: '', content: '', type: 'empty' };

                var leftClass = 'diff-line';
                var rightClass = 'diff-line';
                if (leftLine.type === 'del') leftClass += ' diff-line-del';
                if (rightLine.type === 'add') rightClass += ' diff-line-add';

                if (showLineNums) {
                    leftHtml += '<div class="' + leftClass + '">' +
                        '<div class="diff-line-num">' + (leftLine.num || '') + '</div>' +
                        '<div class="diff-line-num"></div>' +
                        '<div class="diff-line-content">' + escapeHtml(leftLine.content || ' ') + '</div>' +
                    '</div>';

                    rightHtml += '<div class="' + rightClass + '">' +
                        '<div class="diff-line-num">' + (rightLine.num || '') + '</div>' +
                        '<div class="diff-line-num"></div>' +
                        '<div class="diff-line-content">' + escapeHtml(rightLine.content || ' ') + '</div>' +
                    '</div>';
                } else {
                    leftHtml += '<div class="' + leftClass + '" style="grid-template-columns: 1fr;">' +
                        '<div class="diff-line-content">' + escapeHtml(leftLine.content || ' ') + '</div>' +
                    '</div>';

                    rightHtml += '<div class="' + rightClass + '" style="grid-template-columns: 1fr;">' +
                        '<div class="diff-line-content">' + escapeHtml(rightLine.content || ' ') + '</div>' +
                    '</div>';
                }
            }

            leftHtml += '</div></div>';
            rightHtml += '</div></div>';

            return '<div class="diff-sidebyside">' + leftHtml + rightHtml + '</div>';
        }

        // Unified view
        function renderUnifiedDiff(diff) {
            var showLineNums = document.getElementById('showLineNumbers').checked;
            var html = '<div class="diff-unified">' +
                '<div class="diff-unified-header">Unified Diff</div>' +
                '<div class="diff-unified-content">';

            var leftNum = 1;
            var rightNum = 1;

            diff.forEach(function(change) {
                var op = change[0];
                var text = change[1];
                var lines = text.split('\n');

                lines.forEach(function(line, idx) {
                    if (idx === lines.length - 1 && line === '') return;

                    var lineClass = 'diff-line';
                    var leftN = '', rightN = '';

                    if (op === 0) {
                        leftN = leftNum++;
                        rightN = rightNum++;
                    } else if (op === -1) {
                        lineClass += ' diff-line-del';
                        leftN = leftNum++;
                    } else {
                        lineClass += ' diff-line-add';
                        rightN = rightNum++;
                    }

                    if (showLineNums) {
                        html += '<div class="' + lineClass + '">' +
                            '<div class="diff-line-num">' + leftN + '</div>' +
                            '<div class="diff-line-num">' + rightN + '</div>' +
                            '<div class="diff-line-content">' + escapeHtml(line) + '</div>' +
                        '</div>';
                    } else {
                        html += '<div class="' + lineClass + '" style="grid-template-columns: 1fr;">' +
                            '<div class="diff-line-content">' + escapeHtml(line) + '</div>' +
                        '</div>';
                    }
                });
            });

            html += '</div></div>';
            return html;
        }

        // Helper functions
        function escapeHtml(text) {
            var map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        }

        function clearAll() {
            document.getElementById('text1').value = '';
            document.getElementById('text2').value = '';
            document.getElementById('left-file-info').textContent = '';
            document.getElementById('right-file-info').textContent = '';
            document.getElementById('outputSection').style.display = 'none';
            leftFileName = '';
            rightFileName = '';
            lastDiff = null;
        }

        function swapInputs() {
            var text1 = document.getElementById('text1').value;
            var text2 = document.getElementById('text2').value;
            document.getElementById('text1').value = text2;
            document.getElementById('text2').value = text1;

            var temp = leftFileName;
            leftFileName = rightFileName;
            rightFileName = temp;
        }

        function exportDiff(format) {
            if (!lastDiff) return;

            var content = '';
            var filename = '8gwifi.org-diff-' + Date.now();

            if (format === 'html') {
                content = '<!DOCTYPE html><html><head><title>Diff Result</title><style>' +
                    'ins { background: #d1f4d1; text-decoration: none; } ' +
                    'del { background: #ffd7d5; text-decoration: line-through; }' +
                    '</style></head><body>' +
                    '<h1>Diff Result from 8gwifi.org</h1>' +
                    dmp.diff_prettyHtml(lastDiff) +
                    '</body></html>';
                filename += '.html';
            } else {
                lastDiff.forEach(function(change) {
                    var prefix = change[0] === 1 ? '+ ' : (change[0] === -1 ? '- ' : '  ');
                    var lines = change[1].split('\n');
                    lines.forEach(function(line) {
                        if (line) content += prefix + line + '\n';
                    });
                });
                filename += '.txt';
            }

            var blob = new Blob([content], { type: format === 'html' ? 'text/html' : 'text/plain' });
            var a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = filename;
            a.click();
            URL.revokeObjectURL(a.href);
        }

        function copyToClipboard() {
            if (!lastDiff) return;

            var text = '';
            lastDiff.forEach(function(change) {
                var prefix = change[0] === 1 ? '+ ' : (change[0] === -1 ? '- ' : '  ');
                var lines = change[1].split('\n');
                lines.forEach(function(line) {
                    if (line) text += prefix + line + '\n';
                });
            });

            navigator.clipboard.writeText(text).then(function() {
                alert('Diff copied to clipboard!');
            }).catch(function() {
                alert('Failed to copy to clipboard');
            });
        }
    </script>
</div>
<%@ include file="body-close.jsp"%>

