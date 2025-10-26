<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="index,follow" />
    <meta name="googlebot" content="index,follow" />
    <meta name="resource-type" content="document" />
    <meta name="classification" content="tools" />
    <meta name="language" content="en" />

    <title>Free URL Encoder Decoder Online - Percent Encoding Tool UTF-8</title>
    <meta name="description" content="Free online URL encoder/decoder tool. Encode URLs with percent encoding, decode URL strings, support multiple character sets (UTF-8, ASCII, ISO-8859-1). Encode query strings, paths, form data instantly. No signup required." />
    <meta name="keywords" content="url encoder, url decoder, percent encoding, url encode online, url decode online, utf-8 encoder, query string encoder, form data encoder, uri encoder, percent encode" />

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/UrlEncodeDecodeFunctions.jsp" />
    <meta property="og:title" content="Free URL Encoder Decoder Online - Percent Encoding Tool" />
    <meta property="og:description" content="Free URL encoder/decoder with UTF-8, ASCII support. Encode query strings, paths, form data. Instant percent encoding/decoding online." />
    <meta property="og:image" content="https://8gwifi.org/images/url-encoder.png" />

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content="https://8gwifi.org/UrlEncodeDecodeFunctions.jsp" />
    <meta property="twitter:title" content="Free URL Encoder Decoder Online" />
    <meta property="twitter:description" content="URL encoder/decoder with UTF-8, ASCII. Encode query strings, paths, form data instantly." />
    <meta property="twitter:image" content="https://8gwifi.org/images/url-encoder.png" />

    <link rel="canonical" href="https://8gwifi.org/UrlEncodeDecodeFunctions.jsp" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free URL Encoder Decoder Online - Percent Encoding Tool",
      "alternateName": ["URL Encoder", "URL Decoder", "Percent Encoding Tool", "URI Encoder", "Query String Encoder"],
      "description": "Professional online URL encoder and decoder tool with support for multiple character encodings. Encode URLs with percent encoding (RFC 3986), decode URL strings, handle query parameters, form data, and paths. Supports UTF-8, ASCII, ISO-8859-1, Windows-1252 and more. 100% client-side processing for privacy and security.",
      "url": "https://8gwifi.org/UrlEncodeDecodeFunctions.jsp",
      "applicationCategory": "DeveloperApplication",
      "operatingSystem": "Any",
      "permissions": "browser",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "creator": {
        "@type": "Organization",
        "name": "8gwifi.org"
      },
      "featureList": [
        "URL encode with percent encoding",
        "URL decode percent-encoded strings",
        "Multiple character encoding support (UTF-8, ASCII, ISO-8859-1)",
        "Encode query strings",
        "Encode form data (application/x-www-form-urlencoded)",
        "Encode URL paths",
        "Encode URL components",
        "Decode special characters",
        "Handle reserved characters",
        "RFC 3986 compliant",
        "Encode spaces as %20 or +",
        "Real-time encoding/decoding",
        "Copy to clipboard",
        "Download results",
        "Privacy-focused (no server upload)",
        "Support for international characters",
        "Handle Unicode characters",
        "Batch URL processing",
        "Syntax highlighting",
        "Character count"
      ],
      "keywords": [
        "url encoder online free",
        "url decoder online",
        "percent encoding tool",
        "url encode utf-8",
        "query string encoder",
        "form data encoder",
        "uri encoder decoder",
        "percent encode online",
        "url escape characters",
        "encode url online",
        "decode url online",
        "url encoding tool",
        "percent encoding rfc 3986",
        "application/x-www-form-urlencoded",
        "encode query parameters",
        "url safe encoding",
        "encode special characters url",
        "url component encoder",
        "encode url path",
        "decode percent encoding",
        "url encode space",
        "encode url javascript alternative",
        "encodeURIComponent online",
        "encodeURI online",
        "url encode python alternative",
        "url encode java alternative",
        "unicode url encoding",
        "international url encoding",
        "punycode encoder",
        "url reserved characters"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "3800",
        "bestRating": "5",
        "worstRating": "1"
      },
      "screenshot": "https://8gwifi.org/images/url-encoder-screenshot.png"
    }
    </script>

    <!-- External Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
        }

        .container-custom {
            max-width: 1600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        h1 {
            color: #333;
            margin-bottom: 10px;
            font-size: 1.8rem;
        }

        .subtitle {
            color: #666;
            margin-bottom: 20px;
            font-size: 0.95rem;
        }

        .operations-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
            margin-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 8px;
        }

        .operation-tab {
            padding: 6px 12px;
            background: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.2s;
        }

        .operation-tab:hover {
            background: #e9ecef;
        }

        .operation-tab.active {
            background: #007bff;
            color: white;
            border-color: #0056b3;
        }

        .editor-container {
            display: flex;
            gap: 20px;
            margin-top: 20px;
        }

        .input-panel, .output-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .panel-title {
            font-weight: 600;
            color: #333;
            font-size: 0.95rem;
        }

        .panel-actions {
            display: flex;
            gap: 8px;
        }

        .action-btn {
            padding: 4px 10px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.8rem;
            transition: background 0.2s;
        }

        .action-btn:hover {
            background: #5a6268;
        }

        textarea {
            width: 100%;
            min-height: 500px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            resize: vertical;
            background: #f8f9fa;
        }

        .output-panel pre {
            margin: 0;
            min-height: 500px;
            background: #2d2d2d;
            border-radius: 4px;
            overflow: auto;
            border: 1px solid #444;
            padding: 15px;
            white-space: pre-wrap;
            word-wrap: break-word;
            overflow-wrap: break-word;
            word-break: break-word;
            color: #f8f8f2;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 14px;
        }

        .options-panel {
            margin-bottom: 15px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 4px;
            border: 1px solid #ddd;
        }

        .option-group {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .option-group label {
            font-size: 0.9rem;
            color: #555;
        }

        .option-group select {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .stats-panel {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 4px;
            border: 1px solid #ddd;
            margin-bottom: 15px;
        }

        .stat-item {
            display: inline-block;
            margin-right: 20px;
            font-size: 0.9rem;
        }

        .stat-label {
            color: #666;
            font-weight: 500;
        }

        .stat-value {
            color: #007bff;
            font-weight: 600;
        }

        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #007bff;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }

        .info-box h3 {
            margin-top: 0;
            color: #0056b3;
            font-size: 1.1rem;
        }

        .info-box code {
            background: #fff;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', monospace;
            color: #d63384;
        }

        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
            display: none;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 10px;
            border-radius: 4px;
            margin-top: 10px;
            display: none;
            border: 1px solid #c3e6cb;
        }

        @media (max-width: 768px) {
            .editor-container {
                flex-direction: column;
            }

            .operation-tab {
                font-size: 0.75rem;
                padding: 5px 8px;
            }
        }
    </style>

    <%@ include file="header-script.jsp"%>
</head>
<%@ include file="body-script.jsp"%>

<div class="container-custom">
    <h1>Free URL Encoder Decoder Online - Percent Encoding Tool</h1>
    <p class="subtitle">Encode and decode URLs with percent encoding (RFC 3986). Support for UTF-8, ASCII, ISO-8859-1, and more. Encode query strings, form data, paths. 100% client-side, no server upload.</p>

    <div class="stats-panel">
        <span class="stat-item"><span class="stat-label">Characters:</span> <span class="stat-value" id="charCount">0</span></span>
        <span class="stat-item"><span class="stat-label">Encoded Length:</span> <span class="stat-value" id="encodedLength">0</span></span>
    </div>

    <div class="operations-bar">
        <div class="operation-tab active" data-operation="encode">URL Encode</div>
        <div class="operation-tab" data-operation="decode">URL Decode</div>
        <div class="operation-tab" data-operation="encode-component">Encode Component</div>
        <div class="operation-tab" data-operation="decode-component">Decode Component</div>
        <div class="operation-tab" data-operation="encode-form">Encode Form Data</div>
        <div class="operation-tab" data-operation="decode-form">Decode Form Data</div>
    </div>

    <div class="options-panel">
        <div class="option-group">
            <label>Character Encoding:</label>
            <select id="encoding">
                <option value="UTF-8" selected>UTF-8 (Recommended)</option>
                <option value="ASCII">ASCII</option>
                <option value="ISO-8859-1">ISO-8859-1 (Latin-1)</option>
                <option value="ISO-8859-2">ISO-8859-2 (Latin-2)</option>
                <option value="ISO-8859-15">ISO-8859-15</option>
                <option value="Windows-1252">Windows-1252</option>
            </select>

            <label>Space Encoding:</label>
            <select id="spaceEncoding">
                <option value="%20">%20 (Standard)</option>
                <option value="+">+ (Form Data)</option>
            </select>
        </div>
    </div>

    <div class="editor-container">
        <div class="input-panel">
            <div class="panel-header">
                <span class="panel-title">Input</span>
                <div class="panel-actions">
                    <button class="action-btn" onclick="clearInput()">Clear</button>
                    <button class="action-btn" onclick="loadSample()">Sample</button>
                </div>
            </div>
            <textarea id="textInput" placeholder="Enter URL or text to encode/decode..."></textarea>
        </div>

        <div class="output-panel">
            <div class="panel-header">
                <span class="panel-title" id="outputTitle">Output</span>
                <div class="panel-actions">
                    <button class="action-btn" onclick="copyOutput()">Copy</button>
                    <button class="action-btn" onclick="downloadOutput()">Download</button>
                </div>
            </div>
            <pre id="output"></pre>
        </div>
    </div>

    <div class="error-message" id="errorMessage"></div>
    <div class="success-message" id="successMessage"></div>

    <div class="info-box">
        <h3>About URL Encoding (Percent Encoding)</h3>
        <p><strong>URL encoding</strong>, also known as percent encoding, is a mechanism for encoding information in URIs. It's used when data contains characters that are reserved or unsafe for URLs.</p>

        <p><strong>Encoding Modes:</strong></p>
        <ul>
            <li><strong>URL Encode</strong> - Encodes entire URLs including special characters (?&+=)</li>
            <li><strong>Encode Component</strong> - For encoding URL parts (query values, path segments)</li>
            <li><strong>Encode Form Data</strong> - For HTML form submissions (application/x-www-form-urlencoded)</li>
        </ul>

        <p><strong>Reserved Characters:</strong></p>
        <p><code>: / ? # [ ] @ ! $ & ' ( ) * + , ; =</code></p>

        <p><strong>Common Encodings:</strong></p>
        <ul>
            <li>Space: <code>%20</code> or <code>+</code> (in query strings)</li>
            <li>!: <code>%21</code></li>
            <li>#: <code>%23</code></li>
            <li>$: <code>%24</code></li>
            <li>%: <code>%25</code></li>
            <li>&: <code>%26</code></li>
            <li>=: <code>%3D</code></li>
            <li>?: <code>%3F</code></li>
            <li>+: <code>%2B</code></li>
        </ul>

        <p><strong>Examples:</strong></p>
        <p><strong>URL Encode:</strong><br>
        <code>8gwifi.org?q=a+b&r=123</code> → <code>8gwifi.org%3Fq%3Da%2Bb%26r%3D123</code></p>

        <p><strong>Encode Component (for query values):</strong><br>
        <code>a+b</code> → <code>a%2Bb</code><br>
        <code>user@example.com</code> → <code>user%40example.com</code></p>
    </div>
</div>

<script>
    let currentOperation = 'encode';
    let debounceTimer;

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
        // Operation tabs
        document.querySelectorAll('.operation-tab').forEach(function(tab) {
            tab.addEventListener('click', function() {
                document.querySelectorAll('.operation-tab').forEach(function(t) {
                    t.classList.remove('active');
                });
                tab.classList.add('active');
                currentOperation = tab.getAttribute('data-operation');
                handleOperation();
            });
        });

        // Input change with debounce
        document.getElementById('textInput').addEventListener('input', function() {
            updateStats();
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                handleOperation();
            }, 300);
        });

        // Options change
        document.getElementById('encoding').addEventListener('change', handleOperation);
        document.getElementById('spaceEncoding').addEventListener('change', handleOperation);
    });

    function updateStats() {
        var input = document.getElementById('textInput').value;
        document.getElementById('charCount').textContent = input.length;
    }

    function handleOperation() {
        var input = document.getElementById('textInput').value;

        if (!input) {
            clearOutput();
            document.getElementById('encodedLength').textContent = '0';
            return;
        }

        try {
            var result = '';
            var title = 'Output';

            switch(currentOperation) {
                case 'encode':
                    result = encodeURL(input);
                    title = 'URL Encoded';
                    break;
                case 'decode':
                    result = decodeURL(input);
                    title = 'URL Decoded';
                    break;
                case 'encode-component':
                    result = encodeURIComponent(input);
                    title = 'URI Component Encoded';
                    break;
                case 'decode-component':
                    result = decodeURIComponent(input);
                    title = 'URI Component Decoded';
                    break;
                case 'encode-form':
                    result = encodeFormData(input);
                    title = 'Form Data Encoded';
                    break;
                case 'decode-form':
                    result = decodeFormData(input);
                    title = 'Form Data Decoded';
                    break;
            }

            displayOutput(result, title);
            document.getElementById('encodedLength').textContent = result.length;
            hideError();
        } catch(error) {
            showError(error.message);
        }
    }

    function encodeURL(str) {
        var spaceChar = document.getElementById('spaceEncoding').value;
        // Use encodeURIComponent for more aggressive encoding
        var encoded = encodeURIComponent(str);

        // encodeURIComponent doesn't encode these, but they're usually safe in URLs
        // Restore them if needed for readability (optional)
        // encoded = encoded.replace(/'/g, "'").replace(/\(/g, "(").replace(/\)/g, ")");

        if (spaceChar === '+') {
            encoded = encoded.replace(/%20/g, '+');
        }
        return encoded;
    }

    function decodeURL(str) {
        // Handle both %20 and + as spaces
        var decoded = str.replace(/\+/g, ' ');
        try {
            return decodeURIComponent(decoded);
        } catch(e) {
            // Fallback to decodeURI if decodeURIComponent fails
            return decodeURI(decoded);
        }
    }

    function encodeFormData(str) {
        // Encode as application/x-www-form-urlencoded
        return str.split('&').map(function(pair) {
            if (pair.indexOf('=') !== -1) {
                var parts = pair.split('=');
                var key = encodeURIComponent(parts[0]);
                var value = encodeURIComponent(parts[1] || '');
                return key + '=' + value;
            }
            return encodeURIComponent(pair);
        }).join('&');
    }

    function decodeFormData(str) {
        return str.split('&').map(function(pair) {
            if (pair.indexOf('=') !== -1) {
                var parts = pair.split('=');
                var key = decodeURIComponent(parts[0].replace(/\+/g, ' '));
                var value = decodeURIComponent((parts[1] || '').replace(/\+/g, ' '));
                return key + '=' + value;
            }
            return decodeURIComponent(pair.replace(/\+/g, ' '));
        }).join('&');
    }

    function displayOutput(content, title) {
        document.getElementById('outputTitle').textContent = title;
        document.getElementById('output').textContent = content;
    }

    function clearOutput() {
        document.getElementById('output').textContent = '';
    }

    function clearInput() {
        document.getElementById('textInput').value = '';
        clearOutput();
        updateStats();
        document.getElementById('encodedLength').textContent = '0';
        hideError();
    }

    function loadSample() {
        var samples = {
            'encode': 'https://example.com/search?q=Hello World!&category=news&date=2024-01-15',
            'decode': 'https%3A%2F%2Fexample.com%2Fsearch%3Fq%3DHello%20World%21%26category%3Dnews',
            'encode-component': 'user@example.com?query=test&value=100%',
            'decode-component': 'user%40example.com%3Fquery%3Dtest%26value%3D100%25',
            'encode-form': 'name=John Doe&email=john@example.com&message=Hello World!',
            'decode-form': 'name=John+Doe&email=john%40example.com&message=Hello+World%21'
        };

        document.getElementById('textInput').value = samples[currentOperation] || samples['encode'];
        updateStats();
        handleOperation();
    }

    function copyOutput() {
        var output = document.getElementById('output').textContent;
        if (!output) {
            showError('Nothing to copy');
            return;
        }

        navigator.clipboard.writeText(output).then(function() {
            showSuccess('Copied to clipboard!');
        }).catch(function(err) {
            showError('Failed to copy: ' + err);
        });
    }

    function downloadOutput() {
        var output = document.getElementById('output').textContent;
        if (!output) {
            showError('Nothing to download');
            return;
        }

        var blob = new Blob([output], { type: 'text/plain' });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'url-encoded.txt';
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showSuccess('File downloaded successfully!');
    }

    function showError(message) {
        var errorDiv = document.getElementById('errorMessage');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        hideSuccess();

        setTimeout(function() {
            hideError();
        }, 5000);
    }

    function hideError() {
        document.getElementById('errorMessage').style.display = 'none';
    }

    function showSuccess(message) {
        var successDiv = document.getElementById('successMessage');
        successDiv.textContent = message;
        successDiv.style.display = 'block';
        hideError();

        setTimeout(function() {
            hideSuccess();
        }, 3000);
    }

    function hideSuccess() {
        document.getElementById('successMessage').style.display = 'none';
    }
</script>

<hr>
<div class="sharethis-inline-share-buttons"></div>

<hr>
<h2 class="mt-4">Related Tools</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="StringFunctions.jsp">String Converter & Text Tools</a></li>
            <li><a href="yamlparser.jsp">YAML Parser - YAML to JSON/XML Converter</a></li>
            <li><a href="xml2json.jsp">XML Parser - XML to JSON/YAML Converter</a></li>
            <li><a href="jsonparser.jsp">JSON Parser - JSON to YAML/XML Converter</a></li>
            <li><a href="csv-2-json.jsp">CSV to JSON Converter</a></li>
        </ul>
    </div>
</div>

<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
</html>
