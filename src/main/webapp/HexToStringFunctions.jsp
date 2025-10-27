<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- SEO Meta Tags -->
    <title>Advanced String Converter - Hex, Binary, Base64, URL Encoder | 8gwifi.org</title>
    <meta name="description" content="Professional string conversion tool supporting Hex, Binary, Base64, URL encoding/decoding with multiple character encodings (ASCII, UTF-8, UTF-16, ISO). Real-time conversion with file upload support.">
    <meta name="keywords" content="string to hex, hex to string, binary converter, base64 encoder, url encoder, ascii converter, utf-8 converter, encoding converter">
    <meta name="author" content="Anish Nath">
    <meta name="robots" content="index,follow">

    <!-- Open Graph Meta Tags -->
    <meta property="og:title" content="Advanced String Converter - Hex, Binary, Base64, URL">
    <meta property="og:description" content="Professional string conversion tool with multiple formats and encodings">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://8gwifi.org/HexToStringFunctions.jsp">
    <meta property="og:image" content="https://8gwifi.org/images/site/hex.png">

    <!-- JSON-LD Structured Data -->
    <script type="application/ld+json">
    {
      "@context": "http://schema.org",
      "@type": "SoftwareApplication",
      "name": "Advanced String Converter",
      "description": "Convert between String, Hex, Binary, Base64, and URL formats",
      "url": "https://8gwifi.org/HexToStringFunctions.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Web Browser",
      "author": {
        "@type": "Person",
        "name": "Anish Nath"
      },
      "datePublished": "2018-12-06",
      "softwareVersion": "v2.0"
    }
    </script>

    <%@ include file="header-script.jsp"%>

    <style>
        :root {
            --primary: #667eea;
            --secondary: #764ba2;
            --success: #10b981;
            --danger: #ef4444;
        }

        .converter-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1rem;
        }

        .converter-header {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .converter-header h1 {
            margin: 0 0 0.5rem 0;
            font-size: 2rem;
        }

        .converter-layout {
            display: grid;
            grid-template-columns: 1fr 300px;
            gap: 1.5rem;
        }

        @media (max-width: 1024px) {
            .converter-layout {
                grid-template-columns: 1fr;
            }
        }

        .converter-panel {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
        }

        .converter-panel h3 {
            margin: 0 0 1rem 0;
            font-size: 1.1rem;
            color: #374151;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .format-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .format-btn {
            padding: 0.75rem;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
            text-align: center;
        }

        .format-btn:hover {
            border-color: var(--primary);
            background: #f9fafb;
        }

        .format-btn.active {
            border-color: var(--primary);
            background: var(--primary);
            color: white;
        }

        .io-section {
            margin-bottom: 1.5rem;
        }

        .io-section label {
            display: block;
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
        }

        .io-textarea {
            width: 100%;
            min-height: 200px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
            padding: 1rem;
            border: 2px solid #d1d5db;
            border-radius: 8px;
            resize: vertical;
        }

        .io-textarea:focus {
            outline: none;
            border-color: var(--primary);
        }

        .conversion-arrow {
            text-align: center;
            padding: 1rem 0;
            color: var(--primary);
            font-size: 1.5rem;
        }

        .encoding-selector {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            padding: 1rem;
            background: #f9fafb;
            border-radius: 8px;
        }

        .encoding-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .encoding-option input[type="radio"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
        }

        .encoding-option label {
            cursor: pointer;
            font-size: 0.9rem;
            margin: 0;
        }

        .delimiter-options {
            display: flex;
            gap: 1rem;
            padding: 1rem;
            background: #f9fafb;
            border-radius: 8px;
            flex-wrap: wrap;
        }

        .delimiter-option {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .action-buttons {
            display: flex;
            gap: 0.75rem;
            flex-wrap: wrap;
        }

        .btn-converter {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .stats-panel {
            background: #f9fafb;
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 0.75rem;
        }

        .stat-item {
            background: white;
            padding: 0.75rem;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
        }

        .stat-label {
            font-size: 0.85rem;
            color: #6b7280;
        }

        .stat-value {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary);
        }

        .quick-examples {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
        }

        .example-item {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 0.75rem;
            margin-bottom: 0.75rem;
            cursor: pointer;
            transition: all 0.2s;
        }

        .example-item:hover {
            border-color: var(--primary);
            background: white;
        }

        .example-title {
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.25rem;
        }

        .example-text {
            font-family: 'Courier New', monospace;
            font-size: 0.85rem;
            color: #6b7280;
        }

        .file-upload-zone {
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            margin-bottom: 1rem;
        }

        .file-upload-zone:hover,
        .file-upload-zone.dragover {
            border-color: var(--primary);
            background: #f9fafb;
        }

        .file-upload-zone input[type="file"] {
            display: none;
        }

        .batch-mode {
            margin-top: 1.5rem;
            padding: 1rem;
            background: #f9fafb;
            border-radius: 8px;
        }

        .batch-textarea {
            width: 100%;
            min-height: 150px;
            font-family: 'Courier New', monospace;
            font-size: 13px;
            padding: 1rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
        }

        .format-info {
            background: #dbeafe;
            border: 1px solid #93c5fd;
            color: #1e40af;
            padding: 0.75rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
    </style>
</head>

<div>
    <%@ include file="body-script.jsp"%>

    <div class="converter-container">
        <div class="converter-header">
            <h1><i class="fas fa-sync-alt"></i> Advanced String Converter</h1>
            <p>Convert between Hex, Binary, Base64, URL, and plain text with multiple encodings</p>
        </div>

        <div class="converter-layout">
            <!-- Main Converter -->
            <div>
                <div class="converter-panel">
                    <h3><i class="fas fa-exchange-alt"></i> Conversion Tool</h3>

                    <!-- Format Selector -->
                    <div class="format-selector">
                        <button class="format-btn active" onclick="setFormat('hex')" id="btn-hex">
                            <i class="fas fa-hashtag"></i> Hex
                        </button>
                        <button class="format-btn" onclick="setFormat('binary')" id="btn-binary">
                            <i class="fas fa-code"></i> Binary
                        </button>
                        <button class="format-btn" onclick="setFormat('base64')" id="btn-base64">
                            <i class="fas fa-file-code"></i> Base64
                        </button>
                        <button class="format-btn" onclick="setFormat('url')" id="btn-url">
                            <i class="fas fa-link"></i> URL
                        </button>
                        <button class="format-btn" onclick="setFormat('decimal')" id="btn-decimal">
                            <i class="fas fa-sort-numeric-up"></i> Decimal
                        </button>
                    </div>

                    <!-- Format Info -->
                    <div class="format-info" id="formatInfo">
                        <strong>Hex Format:</strong> Converts text to hexadecimal representation
                    </div>

                    <!-- File Upload -->
                    <div class="file-upload-zone" id="fileDropZone">
                        <input type="file" id="fileInput" />
                        <i class="fas fa-cloud-upload-alt fa-2x" style="color: var(--primary);"></i>
                        <p><strong>Click to upload</strong> or drag and drop a text file</p>
                        <p style="font-size: 0.9rem; color: #6b7280;">Max file size: 5MB</p>
                    </div>

                    <!-- Input Section -->
                    <div class="io-section">
                        <label for="inputText"><i class="fas fa-file-alt"></i> Input Text</label>
                        <textarea id="inputText" class="io-textarea" placeholder="Enter your text here...">Hello World!</textarea>
                    </div>

                    <!-- Conversion Arrow -->
                    <div class="conversion-arrow">
                        <i class="fas fa-arrow-down"></i>
                    </div>

                    <!-- Output Section -->
                    <div class="io-section">
                        <label for="outputText"><i class="fas fa-file-export"></i> Output (<span id="outputFormat">Hex</span>)</label>
                        <textarea id="outputText" class="io-textarea" readonly placeholder="Converted output will appear here..."></textarea>
                    </div>

                    <!-- Action Buttons -->
                    <div class="action-buttons">
                        <button class="btn-converter btn-primary" onclick="convert()">
                            <i class="fas fa-sync-alt"></i> Convert
                        </button>
                        <button class="btn-converter btn-secondary" onclick="swap()">
                            <i class="fas fa-exchange-alt"></i> Swap
                        </button>
                        <button class="btn-converter btn-secondary" onclick="copyOutput()">
                            <i class="fas fa-copy"></i> Copy
                        </button>
                        <button class="btn-converter btn-secondary" onclick="downloadOutput()">
                            <i class="fas fa-download"></i> Download
                        </button>
                        <button class="btn-converter btn-secondary" onclick="clearAll()">
                            <i class="fas fa-eraser"></i> Clear
                        </button>
                    </div>

                    <!-- Stats Panel -->
                    <div class="stats-panel">
                        <div class="stats-grid">
                            <div class="stat-item">
                                <div class="stat-label">Input Length</div>
                                <div class="stat-value" id="inputLength">0</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">Output Length</div>
                                <div class="stat-value" id="outputLength">0</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">Bytes</div>
                                <div class="stat-value" id="byteCount">0</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-label">Characters</div>
                                <div class="stat-value" id="charCount">0</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Options Panel -->
                <div class="converter-panel" style="margin-top: 1.5rem;">
                    <h3><i class="fas fa-cog"></i> Options</h3>

                    <!-- Encoding Selection -->
                    <label style="font-weight: 600; display: block; margin-bottom: 0.5rem;">Character Encoding</label>
                    <div class="encoding-selector">
                        <div class="encoding-option">
                            <input type="radio" id="enc-utf8" name="encoding" value="UTF-8" checked>
                            <label for="enc-utf8">UTF-8</label>
                        </div>
                        <div class="encoding-option">
                            <input type="radio" id="enc-ascii" name="encoding" value="ASCII">
                            <label for="enc-ascii">ASCII</label>
                        </div>
                        <div class="encoding-option">
                            <input type="radio" id="enc-utf16" name="encoding" value="UTF-16">
                            <label for="enc-utf16">UTF-16</label>
                        </div>
                        <div class="encoding-option">
                            <input type="radio" id="enc-iso1" name="encoding" value="ISO-8859-1">
                            <label for="enc-iso1">ISO-8859-1</label>
                        </div>
                        <div class="encoding-option">
                            <input type="radio" id="enc-win" name="encoding" value="Windows-1252">
                            <label for="enc-win">Windows-1252</label>
                        </div>
                    </div>

                    <!-- Delimiter Options (for Hex/Binary) -->
                    <div id="delimiterSection" style="margin-top: 1rem;">
                        <label style="font-weight: 600; display: block; margin-bottom: 0.5rem;">Output Delimiter</label>
                        <div class="delimiter-options">
                            <div class="delimiter-option">
                                <input type="radio" id="delim-none" name="delimiter" value="" checked>
                                <label for="delim-none">None</label>
                            </div>
                            <div class="delimiter-option">
                                <input type="radio" id="delim-space" name="delimiter" value=" ">
                                <label for="delim-space">Space</label>
                            </div>
                            <div class="delimiter-option">
                                <input type="radio" id="delim-colon" name="delimiter" value=":">
                                <label for="delim-colon">Colon (:)</label>
                            </div>
                            <div class="delimiter-option">
                                <input type="radio" id="delim-comma" name="delimiter" value=",">
                                <label for="delim-comma">Comma (,)</label>
                            </div>
                            <div class="delimiter-option">
                                <input type="radio" id="delim-0x" name="delimiter" value="0x">
                                <label for="delim-0x">0x Prefix</label>
                            </div>
                        </div>
                    </div>

                    <!-- Batch Mode -->
                    <div class="batch-mode">
                        <h4 style="margin: 0 0 0.75rem 0;">Batch Conversion</h4>
                        <p style="font-size: 0.9rem; color: #6b7280; margin-bottom: 0.5rem;">Enter multiple lines to convert them all at once:</p>
                        <textarea id="batchInput" class="batch-textarea" placeholder="Line 1&#10;Line 2&#10;Line 3"></textarea>
                        <button class="btn-converter btn-primary" onclick="batchConvert()" style="margin-top: 0.75rem;">
                            <i class="fas fa-list"></i> Batch Convert
                        </button>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div>
                <div class="quick-examples">
                    <h3><i class="fas fa-lightbulb"></i> Quick Examples</h3>

                    <div class="example-item" onclick="loadExample('Hello World!')">
                        <div class="example-title">Simple Text</div>
                        <div class="example-text">Hello World!</div>
                    </div>

                    <div class="example-item" onclick="loadExample('user@example.com')">
                        <div class="example-title">Email Address</div>
                        <div class="example-text">user@example.com</div>
                    </div>

                    <div class="example-item" onclick="loadExample('The quick brown fox jumps over the lazy dog')">
                        <div class="example-title">Pangram</div>
                        <div class="example-text">The quick brown fox...</div>
                    </div>

                    <div class="example-item" onclick="loadExample('{"key":"value","number":123}')">
                        <div class="example-title">JSON Data</div>
                        <div class="example-text">{"key":"value"...}</div>
                    </div>

                    <div class="example-item" onclick="loadExample('https://example.com/path?param=value&other=test')">
                        <div class="example-title">URL with Parameters</div>
                        <div class="example-text">https://example.com...</div>
                    </div>

                    <div class="example-item" onclick="loadExample('SELECT * FROM users WHERE id = 1')">
                        <div class="example-title">SQL Query</div>
                        <div class="example-text">SELECT * FROM...</div>
                    </div>
                </div>

                <div class="quick-examples" style="margin-top: 1rem;">
                    <h3><i class="fas fa-info-circle"></i> Format Guide</h3>
                    <div style="font-size: 0.9rem; color: #374151;">
                        <p><strong>Hex:</strong> Converts to hexadecimal (base-16). Example: "A" → "41"</p>
                        <p><strong>Binary:</strong> Converts to binary (base-2). Example: "A" → "01000001"</p>
                        <p><strong>Base64:</strong> Encodes using Base64. Example: "Hello" → "SGVsbG8="</p>
                        <p><strong>URL:</strong> Encodes for URLs. Example: "a b" → "a%20b"</p>
                        <p><strong>Decimal:</strong> Converts to decimal values. Example: "A" → "65"</p>
                    </div>
                </div>
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
                            <li><i class="fas fa-code text-muted"></i> <a href="Base64Functions.jsp">Base64 Encoder/Decoder</a></li>
                            <li><i class="fas fa-link text-muted"></i> <a href="UrlEncodeDecodeFunctions.jsp">URL Encoder/Decoder</a></li>
                            <li><i class="fas fa-file-code text-muted"></i> <a href="base64Hex.jsp">Base64 to Hex Converter</a></li>
                        </ul>
                    </div>
                    <div class="col-md-6">
                        <ul class="list-unstyled">
                            <li><i class="fas fa-text-height text-muted"></i> <a href="StringFunctions.jsp">String Functions</a></li>
                            <li><i class="fas fa-search text-muted"></i> <a href="regex.jsp">Regex Tester</a></li>
                            <li><i class="fas fa-exchange-alt text-muted"></i> <a href="diff.jsp">Text Diff Tool</a></li>
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

    <script>
        var currentFormat = 'hex';
        var isEncoding = true;

        var formatDescriptions = {
            'hex': '<strong>Hex Format:</strong> Converts text to hexadecimal representation (base-16)',
            'binary': '<strong>Binary Format:</strong> Converts text to binary representation (base-2)',
            'base64': '<strong>Base64 Format:</strong> Encodes text using Base64 encoding standard',
            'url': '<strong>URL Format:</strong> Encodes text for safe use in URLs (percent-encoding)',
            'decimal': '<strong>Decimal Format:</strong> Converts text to decimal ASCII/Unicode values'
        };

        function setFormat(format) {
            currentFormat = format;

            document.querySelectorAll('.format-btn').forEach(function(btn) {
                btn.classList.remove('active');
            });
            document.getElementById('btn-' + format).classList.add('active');

            document.getElementById('outputFormat').textContent = format.charAt(0).toUpperCase() + format.slice(1);
            document.getElementById('formatInfo').innerHTML = formatDescriptions[format];

            var delimSection = document.getElementById('delimiterSection');
            if (format === 'hex' || format === 'binary' || format === 'decimal') {
                delimSection.style.display = 'block';
            } else {
                delimSection.style.display = 'none';
            }

            if (document.getElementById('inputText').value) {
                convert();
            }
        }

        function getDelimiter() {
            var delim = document.querySelector('input[name="delimiter"]:checked').value;
            if (delim === '0x' && currentFormat === 'hex') {
                return '0x';
            }
            return delim;
        }

        function convert() {
            var input = document.getElementById('inputText').value;
            var output = '';

            try {
                if (currentFormat === 'hex') {
                    output = stringToHex(input);
                } else if (currentFormat === 'binary') {
                    output = stringToBinary(input);
                } else if (currentFormat === 'base64') {
                    output = btoa(unescape(encodeURIComponent(input)));
                } else if (currentFormat === 'url') {
                    output = encodeURIComponent(input);
                } else if (currentFormat === 'decimal') {
                    output = stringToDecimal(input);
                }

                document.getElementById('outputText').value = output;
                updateStats();
            } catch (e) {
                document.getElementById('outputText').value = 'Error: ' + e.message;
            }
        }

        function stringToHex(str) {
            var result = [];
            var delim = getDelimiter();
            var prefix = delim === '0x' ? '0x' : '';
            var separator = delim === '0x' ? ' ' : delim;

            for (var i = 0; i < str.length; i++) {
                var hex = str.charCodeAt(i).toString(16).toUpperCase();
                if (hex.length === 1) hex = '0' + hex;
                result.push(prefix + hex);
            }

            return result.join(separator);
        }

        function hexToString(hex) {
            hex = hex.replace(/0x/gi, '').replace(/[^0-9A-Fa-f]/g, '');
            var str = '';
            for (var i = 0; i < hex.length; i += 2) {
                str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
            }
            return str;
        }

        function stringToBinary(str) {
            var result = [];
            var delim = getDelimiter();

            for (var i = 0; i < str.length; i++) {
                var binary = str.charCodeAt(i).toString(2).padStart(8, '0');
                result.push(binary);
            }

            return result.join(delim);
        }

        function binaryToString(binary) {
            binary = binary.replace(/[^01]/g, '');
            var str = '';
            for (var i = 0; i < binary.length; i += 8) {
                str += String.fromCharCode(parseInt(binary.substr(i, 8), 2));
            }
            return str;
        }

        function stringToDecimal(str) {
            var result = [];
            var delim = getDelimiter();

            for (var i = 0; i < str.length; i++) {
                result.push(str.charCodeAt(i).toString());
            }

            return result.join(delim);
        }

        function decimalToString(decimal) {
            var numbers = decimal.split(/[^0-9]+/).filter(function(n) { return n; });
            var str = '';
            for (var i = 0; i < numbers.length; i++) {
                str += String.fromCharCode(parseInt(numbers[i]));
            }
            return str;
        }

        function swap() {
            var input = document.getElementById('inputText').value;
            var output = document.getElementById('outputText').value;

            document.getElementById('inputText').value = output;

            try {
                var decoded = '';
                if (currentFormat === 'hex') {
                    decoded = hexToString(output);
                } else if (currentFormat === 'binary') {
                    decoded = binaryToString(output);
                } else if (currentFormat === 'base64') {
                    decoded = decodeURIComponent(escape(atob(output)));
                } else if (currentFormat === 'url') {
                    decoded = decodeURIComponent(output);
                } else if (currentFormat === 'decimal') {
                    decoded = decimalToString(output);
                }

                document.getElementById('outputText').value = decoded;
                updateStats();
            } catch (e) {
                document.getElementById('outputText').value = 'Error decoding: ' + e.message;
            }
        }

        function copyOutput() {
            var output = document.getElementById('outputText');
            output.select();
            document.execCommand('copy');
            alert('Output copied to clipboard!');
        }

        function downloadOutput() {
            var output = document.getElementById('outputText').value;
            var filename = '8gwifi.org-converted-' + currentFormat + '-' + Date.now() + '.txt';

            var blob = new Blob([output], { type: 'text/plain' });
            var a = document.createElement('a');
            a.href = URL.createObjectURL(blob);
            a.download = filename;
            a.click();
            URL.revokeObjectURL(a.href);
        }

        function clearAll() {
            document.getElementById('inputText').value = '';
            document.getElementById('outputText').value = '';
            updateStats();
        }

        function updateStats() {
            var input = document.getElementById('inputText').value;
            var output = document.getElementById('outputText').value;

            document.getElementById('inputLength').textContent = input.length;
            document.getElementById('outputLength').textContent = output.length;

            var encoder = new TextEncoder();
            var bytes = encoder.encode(input);
            document.getElementById('byteCount').textContent = bytes.length;

            var charCount = Array.from(input).length;
            document.getElementById('charCount').textContent = charCount;
        }

        function loadExample(text) {
            document.getElementById('inputText').value = text;
            convert();
        }

        function batchConvert() {
            var input = document.getElementById('batchInput').value;
            var lines = input.split('\n').filter(function(line) { return line.trim(); });
            var results = [];

            lines.forEach(function(line) {
                var converted = '';
                if (currentFormat === 'hex') {
                    converted = stringToHex(line);
                } else if (currentFormat === 'binary') {
                    converted = stringToBinary(line);
                } else if (currentFormat === 'base64') {
                    converted = btoa(unescape(encodeURIComponent(line)));
                } else if (currentFormat === 'url') {
                    converted = encodeURIComponent(line);
                } else if (currentFormat === 'decimal') {
                    converted = stringToDecimal(line);
                }
                results.push(converted);
            });

            document.getElementById('outputText').value = results.join('\n');
            updateStats();
        }

        function setupFileUpload() {
            var dropZone = document.getElementById('fileDropZone');
            var fileInput = document.getElementById('fileInput');

            dropZone.addEventListener('click', function() {
                fileInput.click();
            });

            dropZone.addEventListener('dragover', function(e) {
                e.preventDefault();
                dropZone.classList.add('dragover');
            });

            dropZone.addEventListener('dragleave', function(e) {
                e.preventDefault();
                dropZone.classList.remove('dragover');
            });

            dropZone.addEventListener('drop', function(e) {
                e.preventDefault();
                dropZone.classList.remove('dragover');
                var file = e.dataTransfer.files[0];
                if (file) processFile(file);
            });

            fileInput.addEventListener('change', function(e) {
                var file = e.target.files[0];
                if (file) processFile(file);
            });

            function processFile(file) {
                if (file.size > 5 * 1024 * 1024) {
                    alert('File too large. Maximum size is 5MB');
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('inputText').value = e.target.result;
                    convert();
                };
                reader.readAsText(file);
            }
        }

        document.getElementById('inputText').addEventListener('input', function() {
            updateStats();
        });

        document.querySelectorAll('input[name="delimiter"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                if (document.getElementById('inputText').value) {
                    convert();
                }
            });
        });

        setupFileUpload();
        updateStats();
        convert();
    </script>
</div>
    <%@ include file="body-close.jsp"%>

</html>
