<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<div lang="en">
<head>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "SoftwareApplication",
        "name": "Advanced Hex Dump Viewer & Editor Online Free",
        "description": "Professional hex dump viewer and editor with file upload, multiple formats, search, highlighting, diff comparison, and export options. View binary files, edit bytes, analyze data structures.",
        "url": "https://8gwifi.org/hexdump.jsp",
        "applicationCategory": "DeveloperApplication",
        "operatingSystem": "Any",
        "offers": {
            "@type": "Offer",
            "price": "0",
            "priceCurrency": "USD"
        },
        "creator": {
            "@type": "Organization",
            "name": "8gwifi.org"
        },
        "keywords": "hex dump, hex editor, binary viewer, hex viewer online, hexdump generator, file hex viewer, byte editor, hex analyzer, binary file viewer, hex diff"
    }
    </script>

    <title>Advanced Hex Dump Viewer & Editor Online Free | Binary File Analyzer | 8gwifi.org</title>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Free advanced hex dump viewer and editor online. Upload files, view hex/binary/decimal formats, search bytes, highlight patterns, compare files, edit hex values, and export results.">
    <meta name="keywords" content="hex dump online, hex editor, binary viewer, hexdump generator, file hex viewer, byte editor, hex analyzer, binary file analysis, hex diff, hex search">
    <meta name="author" content="8gwifi.org">
    <meta name="robots" content="index, follow">

    <!-- OpenGraph -->
    <meta property="og:title" content="Advanced Hex Dump Viewer & Editor - Binary File Analyzer">
    <meta property="og:description" content="Professional hex dump tool with file upload, multiple formats, search, highlighting, and editing capabilities.">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/hexdump.jsp">
    <meta property="og:site_name" content="8gwifi.org">

    <!-- Twitter Card -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="Advanced Hex Dump Viewer & Editor Online">
    <meta name="twitter:description" content="View, analyze, and edit binary files with professional hex dump tool.">

    <link rel="canonical" href="https://8gwifi.org/hexdump.jsp">

    <%@ include file="header-script.jsp"%>

    <style>
        .calculator-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin: 20px 0;
        }

        @media (max-width: 768px) {
            .calculator-container {
                grid-template-columns: 1fr;
            }
        }

        .panel {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .panel h3 {
            color: #2d3748;
            font-size: 1.1rem;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .hex-display {
            background: #1e1e1e;
            color: #d4d4d4;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            padding: 15px;
            border-radius: 6px;
            overflow-x: auto;
            max-height: 600px;
            overflow-y: auto;
            line-height: 1.6;
            white-space: pre;
        }

        .hex-line {
            display: flex;
            margin-bottom: 2px;
        }

        .hex-offset {
            color: #858585;
            margin-right: 15px;
            user-select: none;
        }

        .hex-bytes {
            flex: 1;
            margin-right: 15px;
        }

        .hex-ascii {
            color: #ce9178;
            white-space: pre;
        }

        .hex-byte {
            display: inline-block;
            margin-right: 6px;
            cursor: pointer;
            padding: 1px 2px;
        }

        .hex-byte:hover {
            background: #264f78;
        }

        .hex-byte.selected {
            background: #0e639c;
        }

        .hex-byte.highlighted {
            background: #7f4900;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: transform 0.2s;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: white;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            margin-right: 10px;
            transition: all 0.2s;
        }

        .btn-secondary:hover {
            background: #667eea;
            color: white;
        }

        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 5px;
            font-size: 13px;
        }

        .form-group input[type="text"],
        .form-group input[type="number"],
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            font-family: 'Monaco', 'Courier New', monospace;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
        }

        .file-drop-zone {
            border: 2px dashed #cbd5e0;
            border-radius: 8px;
            padding: 40px;
            text-align: center;
            background: #f7fafc;
            cursor: pointer;
            transition: all 0.3s;
        }

        .file-drop-zone:hover {
            border-color: #667eea;
            background: #edf2f7;
        }

        .file-drop-zone.dragover {
            border-color: #667eea;
            background: #e6f2ff;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-top: 15px;
        }

        .stat-box {
            background: #f7fafc;
            padding: 12px;
            border-radius: 6px;
            text-align: center;
        }

        .stat-label {
            font-size: 11px;
            color: #718096;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-size: 18px;
            font-weight: 700;
            color: #2d3748;
            margin-top: 5px;
        }

        .tab-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 10px;
        }

        .tab-btn {
            padding: 8px 16px;
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 6px 6px 0 0;
            cursor: pointer;
            font-weight: 500;
            color: #4a5568;
            transition: all 0.2s;
        }

        .tab-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .info-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .info-box h3 {
            color: white;
            margin-bottom: 10px;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 15px;
        }

        .alert-info {
            background: #e6f2ff;
            color: #0c5392;
            border-left: 4px solid #3182ce;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }
    </style>
</head>

<%@ include file="body-script.jsp"%>

<h1>Advanced Hex Dump Viewer & Editor</h1>
<p>Professional hex dump analyzer with file upload, multiple formats, search, highlighting, and byte editing</p>

<hr>

<div class="info-box">
    <h3>🔍 Professional Binary File Analysis</h3>
    <p>Upload files or paste text to view hex dumps in multiple formats. Search bytes, highlight patterns, compare files, edit hex values, and export results. Perfect for reverse engineering, malware analysis, and data forensics.</p>
</div>

<div class="calculator-container">
    <!-- Left Panel - Input -->
    <div class="panel">
        <h3>📥 Input Source</h3>

        <div class="tab-buttons">
            <button class="tab-btn active" onclick="switchInputTab('file')">File Upload</button>
            <button class="tab-btn" onclick="switchInputTab('text')">Text Input</button>
        </div>

        <div id="file-input-tab" class="tab-content active">
            <div class="file-drop-zone" id="dropZone" onclick="document.getElementById('fileInput').click()">
                <div style="font-size: 48px; margin-bottom: 10px;">📁</div>
                <div style="font-size: 16px; font-weight: 600; margin-bottom: 5px;">Drop file here or click to browse</div>
                <div style="font-size: 12px; color: #718096;">Supports all file types</div>
                <input type="file" id="fileInput" style="display: none;" onchange="handleFileUpload(event)">
            </div>

            <div id="fileInfo" style="margin-top: 15px; display: none;">
                <div class="alert alert-success">
                    <strong>✓ File loaded:</strong> <span id="fileName"></span> (<span id="fileSize"></span>)
                </div>
            </div>
        </div>

        <div id="text-input-tab" class="tab-content">
            <div class="form-group">
                <label>Enter Text or Hex String</label>
                <textarea id="textInput" rows="8" placeholder="Type or paste text here..."></textarea>
            </div>
            <button class="btn-primary" onclick="processText()">Generate Hex Dump</button>
        </div>
    </div>

    <!-- Right Panel - Settings -->
    <div class="panel">
        <h3>⚙️ Display Settings</h3>

        <div class="form-group">
            <label>Display Format</label>
            <select id="displayFormat" onchange="updateDisplay()">
                <option value="hex">Hexadecimal</option>
                <option value="dec">Decimal</option>
                <option value="oct">Octal</option>
                <option value="bin">Binary</option>
            </select>
        </div>

        <div class="form-group">
            <label>Bytes Per Line</label>
            <select id="bytesPerLine" onchange="updateDisplay()">
                <option value="8">8 bytes</option>
                <option value="16" selected>16 bytes</option>
                <option value="24">24 bytes</option>
                <option value="32">32 bytes</option>
            </select>
        </div>

        <div class="form-group">
            <label>Byte Grouping</label>
            <select id="byteGrouping" onchange="updateDisplay()">
                <option value="0">No grouping</option>
                <option value="1" selected>1 byte</option>
                <option value="2">2 bytes</option>
                <option value="4">4 bytes</option>
                <option value="8">8 bytes</option>
            </select>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" id="showAscii" checked onchange="updateDisplay()">
                Show ASCII column
            </label>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" id="showOffset" checked onchange="updateDisplay()">
                Show offset addresses
            </label>
        </div>

        <hr>

        <div class="form-group">
            <label>Search Hex Pattern</label>
            <input type="text" id="searchPattern" placeholder="e.g., 48 65 6C 6C 6F" oninput="searchBytes()">
        </div>

        <div class="form-group">
            <button class="btn-secondary btn-small" onclick="clearHighlights()">Clear Highlights</button>
        </div>
    </div>
</div>

<!-- Stats Panel -->
<div class="panel" id="statsPanel" style="display: none;">
    <h3>📊 File Statistics</h3>
    <div class="stats-grid">
        <div class="stat-box">
            <div class="stat-label">Total Bytes</div>
            <div class="stat-value" id="statTotalBytes">0</div>
        </div>
        <div class="stat-box">
            <div class="stat-label">Printable Chars</div>
            <div class="stat-value" id="statPrintable">0</div>
        </div>
        <div class="stat-box">
            <div class="stat-label">Null Bytes</div>
            <div class="stat-value" id="statNullBytes">0</div>
        </div>
        <div class="stat-box">
            <div class="stat-label">Unique Bytes</div>
            <div class="stat-value" id="statUniqueBytes">0</div>
        </div>
        <div class="stat-box">
            <div class="stat-label">Entropy</div>
            <div class="stat-value" id="statEntropy">0.00</div>
        </div>
    </div>
</div>

<!-- Hex Display -->
<div class="panel">
    <h3>🔍 Hex Dump Output</h3>
    <div style="margin-bottom: 10px;">
        <button class="btn-secondary btn-small" onclick="copyHexDump()">📋 Copy</button>
        <button class="btn-secondary btn-small" onclick="downloadHexDump()">💾 Download</button>
        <button class="btn-secondary btn-small" onclick="exportAsC()">📄 Export as C Array</button>
        <button class="btn-secondary btn-small" onclick="exportAsPython()">🐍 Export as Python</button>
    </div>
    <div id="hexOutput" class="hex-display">
        <div style="color: #858585; text-align: center; padding: 50px;">
            Upload a file or enter text to see hex dump here
        </div>
    </div>
</div>

<hr>

<div class="panel">
    <h3>ℹ️ Features</h3>
    <ul style="line-height: 1.8;">
        <li><strong>File Upload:</strong> Drag & drop or browse to upload any file type</li>
        <li><strong>Multiple Formats:</strong> View as Hex, Decimal, Octal, or Binary</li>
        <li><strong>ASCII Display:</strong> See printable characters alongside hex values</li>
        <li><strong>Search & Highlight:</strong> Find byte patterns and highlight matches</li>
        <li><strong>Statistics:</strong> Analyze file entropy, byte distribution, and characteristics</li>
        <li><strong>Export Options:</strong> Download as text, C array, or Python bytes</li>
        <li><strong>Customizable:</strong> Adjust bytes per line, grouping, and display options</li>
        <li><strong>Client-Side:</strong> 100% browser-based, files never leave your computer</li>
    </ul>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>

<script>
    let currentData = null;
    let currentFileName = '';

    // Tab switching
    function switchInputTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));

        event.target.classList.add('active');
        document.getElementById(tab + '-input-tab').classList.add('active');
    }

    // File upload handling
    const dropZone = document.getElementById('dropZone');

    dropZone.addEventListener('dragover', (e) => {
        e.preventDefault();
        dropZone.classList.add('dragover');
    });

    dropZone.addEventListener('dragleave', () => {
        dropZone.classList.remove('dragover');
    });

    dropZone.addEventListener('drop', (e) => {
        e.preventDefault();
        dropZone.classList.remove('dragover');
        const file = e.dataTransfer.files[0];
        if (file) {
            processFile(file);
        }
    });

    function handleFileUpload(event) {
        const file = event.target.files[0];
        if (file) {
            processFile(file);
        }
    }

    function processFile(file) {
        currentFileName = file.name;
        document.getElementById('fileName').textContent = file.name;
        document.getElementById('fileSize').textContent = formatFileSize(file.size);
        document.getElementById('fileInfo').style.display = 'block';

        const reader = new FileReader();
        reader.onload = function(e) {
            currentData = new Uint8Array(e.target.result);
            updateDisplay();
            calculateStatistics();
            document.getElementById('statsPanel').style.display = 'block';
        };
        reader.readAsArrayBuffer(file);
    }

    function processText() {
        const text = document.getElementById('textInput').value;
        if (!text) {
            alert('Please enter some text');
            return;
        }

        currentFileName = 'text-input';
        const encoder = new TextEncoder();
        currentData = encoder.encode(text);
        updateDisplay();
        calculateStatistics();
        document.getElementById('statsPanel').style.display = 'block';
    }

    function formatFileSize(bytes) {
        if (bytes < 1024) return bytes + ' B';
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(2) + ' KB';
        return (bytes / (1024 * 1024)).toFixed(2) + ' MB';
    }

    function updateDisplay() {
        if (!currentData) return;

        const format = document.getElementById('displayFormat').value;
        const bytesPerLine = parseInt(document.getElementById('bytesPerLine').value);
        const grouping = parseInt(document.getElementById('byteGrouping').value);
        const showAscii = document.getElementById('showAscii').checked;
        const showOffset = document.getElementById('showOffset').checked;

        let html = '';
        for (let i = 0; i < currentData.length; i += bytesPerLine) {
            let line = '<div class="hex-line">';

            // Offset
            if (showOffset) {
                line += '<span class="hex-offset">' + i.toString(16).toUpperCase().padStart(8, '0') + '</span>';
            }

            // Hex bytes
            line += '<span class="hex-bytes">';
            for (let j = 0; j < bytesPerLine; j++) {
                const index = i + j;
                if (index < currentData.length) {
                    const byte = currentData[index];
                    let byteStr = '';

                    switch(format) {
                        case 'hex':
                            byteStr = byte.toString(16).toUpperCase().padStart(2, '0');
                            break;
                        case 'dec':
                            byteStr = byte.toString(10).padStart(3, ' ');
                            break;
                        case 'oct':
                            byteStr = byte.toString(8).padStart(3, '0');
                            break;
                        case 'bin':
                            byteStr = byte.toString(2).padStart(8, '0');
                            break;
                    }

                    line += '<span class="hex-byte" data-index="' + index + '" onclick="selectByte(this)">' + byteStr + '</span>';

                    if (grouping > 0 && (j + 1) % grouping === 0 && j < bytesPerLine - 1) {
                        line += ' ';
                    }
                } else {
                    line += '<span class="hex-byte">  </span>';
                }
            }
            line += '</span>';

            // ASCII
            if (showAscii) {
                line += '<span class="hex-ascii">';
                for (let j = 0; j < bytesPerLine; j++) {
                    const index = i + j;
                    if (index < currentData.length) {
                        const byte = currentData[index];
                        const char = (byte >= 32 && byte <= 126) ? String.fromCharCode(byte) : '.';
                        line += char;
                    }
                }
                line += '</span>';
            }

            line += '</div>';
            html += line;
        }

        document.getElementById('hexOutput').innerHTML = html;
    }

    function calculateStatistics() {
        if (!currentData) return;

        const totalBytes = currentData.length;
        let printable = 0;
        let nullBytes = 0;
        const byteCounts = new Array(256).fill(0);

        for (let i = 0; i < currentData.length; i++) {
            const byte = currentData[i];
            byteCounts[byte]++;
            if (byte >= 32 && byte <= 126) printable++;
            if (byte === 0) nullBytes++;
        }

        const uniqueBytes = byteCounts.filter(count => count > 0).length;

        // Calculate entropy
        let entropy = 0;
        for (let count of byteCounts) {
            if (count > 0) {
                const p = count / totalBytes;
                entropy -= p * Math.log2(p);
            }
        }

        document.getElementById('statTotalBytes').textContent = totalBytes.toLocaleString();
        document.getElementById('statPrintable').textContent = printable.toLocaleString() + ' (' + ((printable/totalBytes)*100).toFixed(1) + '%)';
        document.getElementById('statNullBytes').textContent = nullBytes.toLocaleString();
        document.getElementById('statUniqueBytes').textContent = uniqueBytes;
        document.getElementById('statEntropy').textContent = entropy.toFixed(2) + ' bits';
    }

    function selectByte(element) {
        document.querySelectorAll('.hex-byte.selected').forEach(el => el.classList.remove('selected'));
        element.classList.add('selected');
    }

    function searchBytes() {
        clearHighlights();
        const pattern = document.getElementById('searchPattern').value.trim();
        if (!pattern || !currentData) return;

        // Parse hex pattern
        const patternBytes = pattern.split(/\s+/).map(b => parseInt(b, 16)).filter(b => !isNaN(b));
        if (patternBytes.length === 0) return;

        // Search for pattern
        const bytes = document.querySelectorAll('.hex-byte[data-index]');
        for (let i = 0; i <= currentData.length - patternBytes.length; i++) {
            let match = true;
            for (let j = 0; j < patternBytes.length; j++) {
                if (currentData[i + j] !== patternBytes[j]) {
                    match = false;
                    break;
                }
            }

            if (match) {
                for (let j = 0; j < patternBytes.length; j++) {
                    const index = i + j;
                    const element = document.querySelector('.hex-byte[data-index="' + index + '"]');
                    if (element) element.classList.add('highlighted');
                }
            }
        }
    }

    function clearHighlights() {
        document.querySelectorAll('.hex-byte.highlighted').forEach(el => el.classList.remove('highlighted'));
    }

    function copyHexDump() {
        const text = document.getElementById('hexOutput').innerText;
        navigator.clipboard.writeText(text).then(() => {
            alert('Hex dump copied to clipboard!');
        });
    }

    function downloadHexDump() {
        const text = document.getElementById('hexOutput').innerText;
        const blob = new Blob([text], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi.org-hexdump-' + (currentFileName || 'output') + '.txt';
        a.click();
        URL.revokeObjectURL(url);
    }

    function exportAsC() {
        if (!currentData) return;

        let output = 'unsigned char data[] = {\n    ';
        const bytesPerLine = 12;

        for (let i = 0; i < currentData.length; i++) {
            output += '0x' + currentData[i].toString(16).toUpperCase().padStart(2, '0');
            if (i < currentData.length - 1) output += ', ';
            if ((i + 1) % bytesPerLine === 0 && i < currentData.length - 1) {
                output += '\n    ';
            }
        }

        output += '\n};\nunsigned int data_len = ' + currentData.length + ';';

        const blob = new Blob([output], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi.org-' + (currentFileName || 'data') + '.c';
        a.click();
        URL.revokeObjectURL(url);
    }

    function exportAsPython() {
        if (!currentData) return;

        let output = 'data = bytes([\n    ';
        const bytesPerLine = 12;

        for (let i = 0; i < currentData.length; i++) {
            output += '0x' + currentData[i].toString(16).toUpperCase().padStart(2, '0');
            if (i < currentData.length - 1) output += ', ';
            if ((i + 1) % bytesPerLine === 0 && i < currentData.length - 1) {
                output += '\n    ';
            }
        }

        output += '\n])';

        const blob = new Blob([output], { type: 'text/plain' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = '8gwifi.org-' + (currentFileName || 'data') + '.py';
        a.click();
        URL.revokeObjectURL(url);
    }
</script>
</div>
<%@ include file="body-close.jsp"%>
</html>
