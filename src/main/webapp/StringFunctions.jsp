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

    <title>Free String Converter & Text Manipulation Tools Online - 60+ Utilities</title>
    <meta name="description" content="Free online string converter with 60+ tools: camelCase converter, Base64 encoder/decoder, MD5/SHA hash generator, text analysis, word counter, Lorem Ipsum generator, UUID generator. No signup required." />
    <meta name="keywords" content="string manipulation tools, text converter, base64 encoder, url encoder, hash generator, md5 generator, sha256 hash, word counter, character counter, case converter, text tools online" />

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/StringFunctions.jsp" />
    <meta property="og:title" content="Free String Converter & Text Tools Online - 60+ Utilities" />
    <meta property="og:description" content="Free online string converter: camelCase, Base64, MD5/SHA hash, text analysis, word counter, Lorem Ipsum, UUID generator. 60+ tools, no signup required." />
    <meta property="og:image" content="https://8gwifi.org/images/string-tools.png" />

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content="https://8gwifi.org/StringFunctions.jsp" />
    <meta property="twitter:title" content="Free String Converter & Text Tools - 60+ Utilities" />
    <meta property="twitter:description" content="Free online string converter: camelCase, Base64, MD5 hash, text analysis, Lorem Ipsum, UUID. 60+ tools, no signup." />
    <meta property="twitter:image" content="https://8gwifi.org/images/string-tools.png" />

    <link rel="canonical" href="https://8gwifi.org/StringFunctions.jsp" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free String Converter & Text Manipulation Tools Online",
      "alternateName": ["String Converter Online", "Text Tools", "Base64 Encoder Decoder", "camelCase Converter", "Hash Generator", "Text Processor", "String Utilities"],
      "description": "Professional online string manipulation toolkit with 60+ utilities. Case style conversions (camelCase, snake_case, PascalCase, kebab-case), encode/decode, hash generation (MD5, SHA, HMAC), text analysis, word frequency, line operations, Lorem Ipsum generator, UUID generator, number to words, text diff, and more. 100% client-side processing for privacy and speed.",
      "url": "https://8gwifi.org/StringFunctions.jsp",
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
        "Base64 encode and decode",
        "URL encode and decode",
        "HTML entity encode and decode",
        "MD5 hash generator",
        "SHA-1 hash generator",
        "SHA-256 hash generator",
        "SHA-512 hash generator",
        "HMAC generator",
        "Uppercase and lowercase conversion",
        "Title case and sentence case",
        "Capitalize words",
        "Reverse string",
        "Palindrome checker",
        "Character counter",
        "Word counter",
        "Line counter",
        "Remove whitespace",
        "Trim leading/trailing spaces",
        "String replace and replaceAll",
        "indexOf and lastIndexOf finder",
        "Substring extraction",
        "Hexadecimal conversion",
        "Binary conversion",
        "Octal conversion",
        "ROT13 cipher",
        "Caesar cipher",
        "ASCII table lookup",
        "Unicode escape/unescape",
        "JSON escape/unescape",
        "SQL escape",
        "CSV escape",
        "Slugify text",
        "Remove duplicates",
        "Sort lines alphabetically",
        "Extract URLs from text",
        "Extract emails from text",
        "Diff two strings",
        "Generate random string",
        "Password strength checker",
        "Copy to clipboard",
        "Download results",
        "Real-time processing",
        "Privacy-focused (no server upload)"
      ],
      "keywords": [
        "string manipulation tools online free",
        "base64 encoder decoder",
        "url encoder decoder online",
        "md5 hash generator",
        "sha256 hash calculator",
        "text converter online",
        "case converter",
        "word counter online",
        "character counter tool",
        "string length calculator",
        "palindrome checker online",
        "reverse text generator",
        "hash generator online",
        "text encoding tools",
        "html entity encoder",
        "javascript string functions",
        "online text utilities",
        "string formatter",
        "text manipulation online",
        "encode decode online",
        "hash calculator",
        "hmac generator",
        "rot13 converter",
        "caesar cipher online",
        "hex converter",
        "binary to text converter",
        "ascii converter",
        "unicode escape tool",
        "json escape online",
        "sql escape string",
        "slugify text online",
        "remove duplicate lines",
        "sort lines alphabetically",
        "url extractor",
        "email extractor",
        "text diff tool",
        "random string generator",
        "password strength checker",
        "trim whitespace online",
        "string replace tool",
        "substring finder",
        "indexOf calculator",
        "string utility functions",
        "text processing tools"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.9",
        "ratingCount": "5600",
        "bestRating": "5",
        "worstRating": "1"
      },
      "screenshot": "https://8gwifi.org/images/string-tools-screenshot.png"
    }
    </script>

    <!-- External Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/diff/5.1.0/diff.min.js"></script>

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
            max-height: 200px;
            overflow-y: auto;
        }

        .operation-tab {
            padding: 6px 12px;
            background: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.2s;
            white-space: nowrap;
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

        .action-btn.success {
            background: #28a745;
        }

        .action-btn.success:hover {
            background: #218838;
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
            display: none;
        }

        .options-panel.active {
            display: block;
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
            min-width: 120px;
        }

        .option-group input[type="text"],
        .option-group input[type="number"] {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.9rem;
            flex: 1;
            min-width: 150px;
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
    <h1>Free String Converter & Text Manipulation Tools Online</h1>
    <p class="subtitle">60+ free string & text tools: camelCase converter, snake_case, Base64 encoder/decoder, MD5/SHA hash generator, text analysis, word counter, Lorem Ipsum generator, UUID generator. No signup, 100% client-side processing.</p>

    <div class="stats-panel" id="statsPanel">
        <span class="stat-item"><span class="stat-label">Characters:</span> <span class="stat-value" id="charCount">0</span></span>
        <span class="stat-item"><span class="stat-label">Characters (no spaces):</span> <span class="stat-value" id="charCountNoSpace">0</span></span>
        <span class="stat-item"><span class="stat-label">Words:</span> <span class="stat-value" id="wordCount">0</span></span>
        <span class="stat-item"><span class="stat-label">Lines:</span> <span class="stat-value" id="lineCount">0</span></span>
    </div>

    <div class="operations-bar">
        <div class="operation-tab active" data-operation="uppercase">UPPERCASE</div>
        <div class="operation-tab" data-operation="lowercase">lowercase</div>
        <div class="operation-tab" data-operation="titlecase">Title Case</div>
        <div class="operation-tab" data-operation="sentencecase">Sentence case</div>
        <div class="operation-tab" data-operation="capitalize">Capitalize Words</div>
        <div class="operation-tab" data-operation="camelcase">camelCase</div>
        <div class="operation-tab" data-operation="pascalcase">PascalCase</div>
        <div class="operation-tab" data-operation="snakecase">snake_case</div>
        <div class="operation-tab" data-operation="kebabcase">kebab-case</div>
        <div class="operation-tab" data-operation="constantcase">CONSTANT_CASE</div>
        <div class="operation-tab" data-operation="dotcase">dot.case</div>
        <div class="operation-tab" data-operation="togglecase">tOGGLE cASE</div>
        <div class="operation-tab" data-operation="reverse">Reverse String</div>
        <div class="operation-tab" data-operation="palindrome">Palindrome Check</div>
        <div class="operation-tab" data-operation="trim">Trim</div>
        <div class="operation-tab" data-operation="trim-all">Remove All Spaces</div>
        <div class="operation-tab" data-operation="base64-encode">Base64 Encode</div>
        <div class="operation-tab" data-operation="base64-decode">Base64 Decode</div>
        <div class="operation-tab" data-operation="url-encode">URL Encode</div>
        <div class="operation-tab" data-operation="url-decode">URL Decode</div>
        <div class="operation-tab" data-operation="html-encode">HTML Encode</div>
        <div class="operation-tab" data-operation="html-decode">HTML Decode</div>
        <div class="operation-tab" data-operation="remove-html">Remove HTML Tags</div>
        <div class="operation-tab" data-operation="md5">MD5 Hash</div>
        <div class="operation-tab" data-operation="sha1">SHA-1 Hash</div>
        <div class="operation-tab" data-operation="sha256">SHA-256 Hash</div>
        <div class="operation-tab" data-operation="sha512">SHA-512 Hash</div>
        <div class="operation-tab" data-operation="hmac-sha256">HMAC-SHA256</div>
        <div class="operation-tab" data-operation="hmac-sha512">HMAC-SHA512</div>
        <div class="operation-tab" data-operation="hex-encode">To Hexadecimal</div>
        <div class="operation-tab" data-operation="hex-decode">From Hexadecimal</div>
        <div class="operation-tab" data-operation="binary-encode">To Binary</div>
        <div class="operation-tab" data-operation="binary-decode">From Binary</div>
        <div class="operation-tab" data-operation="rot13">ROT13</div>
        <div class="operation-tab" data-operation="caesar">Caesar Cipher</div>
        <div class="operation-tab" data-operation="unicode-escape">Unicode Escape</div>
        <div class="operation-tab" data-operation="unicode-unescape">Unicode Unescape</div>
        <div class="operation-tab" data-operation="json-escape">JSON Escape</div>
        <div class="operation-tab" data-operation="slugify">Slugify</div>
        <div class="operation-tab" data-operation="remove-duplicates">Remove Duplicate Lines</div>
        <div class="operation-tab" data-operation="sort-asc">Sort Lines A-Z</div>
        <div class="operation-tab" data-operation="sort-desc">Sort Lines Z-A</div>
        <div class="operation-tab" data-operation="reverse-lines">Reverse Line Order</div>
        <div class="operation-tab" data-operation="add-line-numbers">Add Line Numbers</div>
        <div class="operation-tab" data-operation="remove-line-numbers">Remove Line Numbers</div>
        <div class="operation-tab" data-operation="add-prefix">Add Line Prefix</div>
        <div class="operation-tab" data-operation="add-suffix">Add Line Suffix</div>
        <div class="operation-tab" data-operation="join-lines">Join Lines</div>
        <div class="operation-tab" data-operation="split-lines">Split by Delimiter</div>
        <div class="operation-tab" data-operation="extract-urls">Extract URLs</div>
        <div class="operation-tab" data-operation="extract-emails">Extract Emails</div>
        <div class="operation-tab" data-operation="replace">Find & Replace</div>
        <div class="operation-tab" data-operation="substring">Substring</div>
        <div class="operation-tab" data-operation="wrap-text">Wrap Text</div>
        <div class="operation-tab" data-operation="text-analysis">Text Analysis</div>
        <div class="operation-tab" data-operation="word-frequency">Word Frequency</div>
        <div class="operation-tab" data-operation="number-to-words">Number to Words</div>
        <div class="operation-tab" data-operation="diff">Text Diff</div>
        <div class="operation-tab" data-operation="random">Generate Random</div>
        <div class="operation-tab" data-operation="uuid">Generate UUID</div>
        <div class="operation-tab" data-operation="lorem">Lorem Ipsum</div>
    </div>

    <!-- Options panels for operations that need extra input -->
    <div class="options-panel" id="caesarOptions">
        <div class="option-group">
            <label>Shift Amount:</label>
            <input type="number" id="caesarShift" value="3" min="1" max="25">
        </div>
    </div>

    <div class="options-panel" id="replaceOptions">
        <div class="option-group">
            <label>Find:</label>
            <input type="text" id="findText" placeholder="Enter text to find">
            <label>Replace with:</label>
            <input type="text" id="replaceText" placeholder="Enter replacement text">
        </div>
    </div>

    <div class="options-panel" id="substringOptions">
        <div class="option-group">
            <label>Start Index:</label>
            <input type="number" id="startIndex" value="0" min="0">
            <label>End Index:</label>
            <input type="number" id="endIndex" value="10" min="0">
        </div>
    </div>

    <div class="options-panel" id="randomOptions">
        <div class="option-group">
            <label>Length:</label>
            <input type="number" id="randomLength" value="16" min="1" max="1000">
            <label>Characters:</label>
            <select id="randomType">
                <option value="alphanumeric">Alphanumeric</option>
                <option value="alpha">Alphabetic</option>
                <option value="numeric">Numeric</option>
                <option value="hex">Hexadecimal</option>
                <option value="special">With Special Chars</option>
            </select>
        </div>
    </div>

    <div class="options-panel" id="hmacOptions">
        <div class="option-group">
            <label>Secret Key:</label>
            <input type="text" id="hmacKey" placeholder="Enter secret key">
        </div>
    </div>

    <div class="options-panel" id="prefixOptions">
        <div class="option-group">
            <label>Prefix Text:</label>
            <input type="text" id="prefixText" placeholder="Enter prefix">
        </div>
    </div>

    <div class="options-panel" id="suffixOptions">
        <div class="option-group">
            <label>Suffix Text:</label>
            <input type="text" id="suffixText" placeholder="Enter suffix">
        </div>
    </div>

    <div class="options-panel" id="joinOptions">
        <div class="option-group">
            <label>Delimiter:</label>
            <input type="text" id="joinDelimiter" placeholder="Enter delimiter (e.g., , or space)">
        </div>
    </div>

    <div class="options-panel" id="splitOptions">
        <div class="option-group">
            <label>Delimiter:</label>
            <input type="text" id="splitDelimiter" placeholder="Enter delimiter to split by">
        </div>
    </div>

    <div class="options-panel" id="wrapOptions">
        <div class="option-group">
            <label>Column Width:</label>
            <input type="number" id="wrapWidth" value="80" min="10" max="200">
        </div>
    </div>

    <div class="options-panel" id="loremOptions">
        <div class="option-group">
            <label>Paragraphs:</label>
            <input type="number" id="loremParagraphs" value="3" min="1" max="20">
            <label>Sentences per paragraph:</label>
            <input type="number" id="loremSentences" value="5" min="1" max="20">
        </div>
    </div>

    <div class="options-panel" id="uuidOptions">
        <div class="option-group">
            <label>Number of UUIDs:</label>
            <input type="number" id="uuidCount" value="1" min="1" max="100">
        </div>
    </div>

    <div class="options-panel" id="diffOptions">
        <div class="option-group" style="flex-direction: column; align-items: stretch;">
            <label>Text 2 (compare with input):</label>
            <textarea id="diffText2" style="min-height: 150px; margin-top: 10px;" placeholder="Enter second text to compare"></textarea>
        </div>
    </div>

    <div class="editor-container">
        <div class="input-panel">
            <div class="panel-header">
                <span class="panel-title">Text Input</span>
                <div class="panel-actions">
                    <button class="action-btn" onclick="clearInput()">Clear</button>
                    <button class="action-btn" onclick="loadSample()">Sample</button>
                </div>
            </div>
            <textarea id="textInput" placeholder="Enter your text here..."></textarea>
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
</div>

<script>
    let currentOperation = 'uppercase';
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
                showOptionsPanel(currentOperation);
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

        // Options inputs
        document.getElementById('caesarShift').addEventListener('input', handleOperation);
        document.getElementById('findText').addEventListener('input', handleOperation);
        document.getElementById('replaceText').addEventListener('input', handleOperation);
        document.getElementById('startIndex').addEventListener('input', handleOperation);
        document.getElementById('endIndex').addEventListener('input', handleOperation);
        document.getElementById('randomLength').addEventListener('input', handleOperation);
        document.getElementById('randomType').addEventListener('change', handleOperation);
        document.getElementById('hmacKey').addEventListener('input', handleOperation);
        document.getElementById('prefixText').addEventListener('input', handleOperation);
        document.getElementById('suffixText').addEventListener('input', handleOperation);
        document.getElementById('joinDelimiter').addEventListener('input', handleOperation);
        document.getElementById('splitDelimiter').addEventListener('input', handleOperation);
        document.getElementById('wrapWidth').addEventListener('input', handleOperation);
        document.getElementById('loremParagraphs').addEventListener('input', handleOperation);
        document.getElementById('loremSentences').addEventListener('input', handleOperation);
        document.getElementById('uuidCount').addEventListener('input', handleOperation);
        document.getElementById('diffText2').addEventListener('input', handleOperation);
    });

    function showOptionsPanel(operation) {
        // Hide all options panels
        document.querySelectorAll('.options-panel').forEach(function(panel) {
            panel.classList.remove('active');
        });

        // Show relevant options panel
        if (operation === 'caesar') {
            document.getElementById('caesarOptions').classList.add('active');
        } else if (operation === 'replace') {
            document.getElementById('replaceOptions').classList.add('active');
        } else if (operation === 'substring') {
            document.getElementById('substringOptions').classList.add('active');
        } else if (operation === 'random') {
            document.getElementById('randomOptions').classList.add('active');
        } else if (operation === 'hmac-sha256' || operation === 'hmac-sha512') {
            document.getElementById('hmacOptions').classList.add('active');
        } else if (operation === 'add-prefix') {
            document.getElementById('prefixOptions').classList.add('active');
        } else if (operation === 'add-suffix') {
            document.getElementById('suffixOptions').classList.add('active');
        } else if (operation === 'join-lines') {
            document.getElementById('joinOptions').classList.add('active');
        } else if (operation === 'split-lines') {
            document.getElementById('splitOptions').classList.add('active');
        } else if (operation === 'wrap-text') {
            document.getElementById('wrapOptions').classList.add('active');
        } else if (operation === 'lorem') {
            document.getElementById('loremOptions').classList.add('active');
        } else if (operation === 'uuid') {
            document.getElementById('uuidOptions').classList.add('active');
        } else if (operation === 'diff') {
            document.getElementById('diffOptions').classList.add('active');
        }
    }

    function updateStats() {
        var input = document.getElementById('textInput').value;
        document.getElementById('charCount').textContent = input.length;
        document.getElementById('charCountNoSpace').textContent = input.replace(/\s/g, '').length;
        document.getElementById('wordCount').textContent = input.trim() ? input.trim().split(/\s+/).length : 0;
        document.getElementById('lineCount').textContent = input ? input.split('\n').length : 0;
    }

    function handleOperation() {
        var input = document.getElementById('textInput').value;

        if (currentOperation === 'random') {
            generateRandom();
            return;
        }

        if (currentOperation === 'uuid') {
            var count = parseInt(document.getElementById('uuidCount').value) || 1;
            var uuids = [];
            for (var i = 0; i < count; i++) {
                uuids.push(generateUUID());
            }
            displayOutput(uuids.join('\n'), 'Generated ' + count + ' UUID' + (count > 1 ? 's' : ''));
            return;
        }

        if (currentOperation === 'lorem') {
            var lorem = generateLoremIpsum();
            displayOutput(lorem, 'Lorem Ipsum');
            return;
        }

        if (!input && currentOperation !== 'random' && currentOperation !== 'uuid' && currentOperation !== 'lorem') {
            clearOutput();
            return;
        }

        try {
            var result = '';
            var title = 'Output';

            switch(currentOperation) {
                case 'uppercase':
                    result = input.toUpperCase();
                    title = 'UPPERCASE';
                    break;
                case 'lowercase':
                    result = input.toLowerCase();
                    title = 'lowercase';
                    break;
                case 'titlecase':
                    result = toTitleCase(input);
                    title = 'Title Case';
                    break;
                case 'sentencecase':
                    result = toSentenceCase(input);
                    title = 'Sentence case';
                    break;
                case 'capitalize':
                    result = capitalizeWords(input);
                    title = 'Capitalized';
                    break;
                case 'camelcase':
                    result = toCamelCase(input);
                    title = 'camelCase';
                    break;
                case 'pascalcase':
                    result = toPascalCase(input);
                    title = 'PascalCase';
                    break;
                case 'snakecase':
                    result = toSnakeCase(input);
                    title = 'snake_case';
                    break;
                case 'kebabcase':
                    result = toKebabCase(input);
                    title = 'kebab-case';
                    break;
                case 'constantcase':
                    result = toConstantCase(input);
                    title = 'CONSTANT_CASE';
                    break;
                case 'dotcase':
                    result = toDotCase(input);
                    title = 'dot.case';
                    break;
                case 'togglecase':
                    result = toggleCase(input);
                    title = 'tOGGLE cASE';
                    break;
                case 'reverse':
                    result = input.split('').reverse().join('');
                    title = 'Reversed String';
                    break;
                case 'palindrome':
                    var reversed = input.split('').reverse().join('');
                    result = (input === reversed) ? 'YES - This is a palindrome!' : 'NO - This is not a palindrome.';
                    title = 'Palindrome Check';
                    break;
                case 'trim':
                    result = input.trim();
                    title = 'Trimmed';
                    break;
                case 'trim-all':
                    result = input.replace(/\s/g, '');
                    title = 'All Spaces Removed';
                    break;
                case 'base64-encode':
                    result = btoa(unescape(encodeURIComponent(input)));
                    title = 'Base64 Encoded';
                    break;
                case 'base64-decode':
                    result = decodeURIComponent(escape(atob(input)));
                    title = 'Base64 Decoded';
                    break;
                case 'url-encode':
                    result = encodeURIComponent(input);
                    title = 'URL Encoded';
                    break;
                case 'url-decode':
                    result = decodeURIComponent(input);
                    title = 'URL Decoded';
                    break;
                case 'html-encode':
                    result = htmlEncode(input);
                    title = 'HTML Encoded';
                    break;
                case 'html-decode':
                    result = htmlDecode(input);
                    title = 'HTML Decoded';
                    break;
                case 'remove-html':
                    result = removeHtmlTags(input);
                    title = 'HTML Tags Removed';
                    break;
                case 'md5':
                    result = CryptoJS.MD5(input).toString();
                    title = 'MD5 Hash';
                    break;
                case 'sha1':
                    result = CryptoJS.SHA1(input).toString();
                    title = 'SHA-1 Hash';
                    break;
                case 'sha256':
                    result = CryptoJS.SHA256(input).toString();
                    title = 'SHA-256 Hash';
                    break;
                case 'sha512':
                    result = CryptoJS.SHA512(input).toString();
                    title = 'SHA-512 Hash';
                    break;
                case 'hmac-sha256':
                    var key256 = document.getElementById('hmacKey').value;
                    result = CryptoJS.HmacSHA256(input, key256).toString();
                    title = 'HMAC-SHA256';
                    break;
                case 'hmac-sha512':
                    var key512 = document.getElementById('hmacKey').value;
                    result = CryptoJS.HmacSHA512(input, key512).toString();
                    title = 'HMAC-SHA512';
                    break;
                case 'hex-encode':
                    result = stringToHex(input);
                    title = 'Hexadecimal';
                    break;
                case 'hex-decode':
                    result = hexToString(input);
                    title = 'From Hexadecimal';
                    break;
                case 'binary-encode':
                    result = stringToBinary(input);
                    title = 'Binary';
                    break;
                case 'binary-decode':
                    result = binaryToString(input);
                    title = 'From Binary';
                    break;
                case 'rot13':
                    result = rot13(input);
                    title = 'ROT13';
                    break;
                case 'caesar':
                    var shift = parseInt(document.getElementById('caesarShift').value) || 3;
                    result = caesarCipher(input, shift);
                    title = 'Caesar Cipher (shift ' + shift + ')';
                    break;
                case 'unicode-escape':
                    result = unicodeEscape(input);
                    title = 'Unicode Escaped';
                    break;
                case 'unicode-unescape':
                    result = unicodeUnescape(input);
                    title = 'Unicode Unescaped';
                    break;
                case 'json-escape':
                    result = JSON.stringify(input);
                    title = 'JSON Escaped';
                    break;
                case 'slugify':
                    result = slugify(input);
                    title = 'Slugified';
                    break;
                case 'remove-duplicates':
                    result = removeDuplicateLines(input);
                    title = 'Duplicates Removed';
                    break;
                case 'sort-asc':
                    result = sortLines(input, true);
                    title = 'Sorted A-Z';
                    break;
                case 'sort-desc':
                    result = sortLines(input, false);
                    title = 'Sorted Z-A';
                    break;
                case 'extract-urls':
                    result = extractUrls(input);
                    title = 'Extracted URLs';
                    break;
                case 'extract-emails':
                    result = extractEmails(input);
                    title = 'Extracted Emails';
                    break;
                case 'replace':
                    var find = document.getElementById('findText').value;
                    var replace = document.getElementById('replaceText').value;
                    result = input.split(find).join(replace);
                    title = 'Find & Replace Result';
                    break;
                case 'substring':
                    var start = parseInt(document.getElementById('startIndex').value) || 0;
                    var end = parseInt(document.getElementById('endIndex').value) || input.length;
                    result = input.substring(start, end);
                    title = 'Substring (' + start + ' to ' + end + ')';
                    break;
                case 'reverse-lines':
                    result = reverseLinesOrder(input);
                    title = 'Reversed Line Order';
                    break;
                case 'add-line-numbers':
                    result = addLineNumbers(input);
                    title = 'Line Numbers Added';
                    break;
                case 'remove-line-numbers':
                    result = removeLineNumbers(input);
                    title = 'Line Numbers Removed';
                    break;
                case 'add-prefix':
                    var prefix = document.getElementById('prefixText').value;
                    result = addLinePrefix(input, prefix);
                    title = 'Prefix Added';
                    break;
                case 'add-suffix':
                    var suffix = document.getElementById('suffixText').value;
                    result = addLineSuffix(input, suffix);
                    title = 'Suffix Added';
                    break;
                case 'join-lines':
                    var joinDelim = document.getElementById('joinDelimiter').value;
                    result = joinLines(input, joinDelim);
                    title = 'Lines Joined';
                    break;
                case 'split-lines':
                    var splitDelim = document.getElementById('splitDelimiter').value;
                    result = splitByDelimiter(input, splitDelim);
                    title = 'Split by Delimiter';
                    break;
                case 'wrap-text':
                    var width = parseInt(document.getElementById('wrapWidth').value) || 80;
                    result = wrapText(input, width);
                    title = 'Text Wrapped at ' + width + ' chars';
                    break;
                case 'text-analysis':
                    result = analyzeText(input);
                    title = 'Text Analysis';
                    break;
                case 'word-frequency':
                    result = wordFrequency(input);
                    title = 'Word Frequency Analysis';
                    break;
                case 'number-to-words':
                    result = numberToWords(input);
                    title = 'Number to Words';
                    break;
                case 'diff':
                    var text2 = document.getElementById('diffText2').value;
                    result = textDiff(input, text2);
                    title = 'Text Diff';
                    break;
                case 'uuid':
                    result = generateUUID();
                    title = 'Generated UUID';
                    break;
                case 'lorem':
                    result = generateLoremIpsum();
                    title = 'Lorem Ipsum';
                    break;
            }

            displayOutput(result, title);
            hideError();
        } catch(error) {
            showError(error.message);
        }
    }

    // String manipulation functions
    function toTitleCase(str) {
        return str.replace(/\w\S*/g, function(txt) {
            return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
        });
    }

    function toSentenceCase(str) {
        return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
    }

    function capitalizeWords(str) {
        return str.replace(/\b\w/g, function(char) {
            return char.toUpperCase();
        });
    }

    function htmlEncode(str) {
        var div = document.createElement('div');
        div.textContent = str;
        return div.innerHTML;
    }

    function htmlDecode(str) {
        var div = document.createElement('div');
        div.innerHTML = str;
        return div.textContent;
    }

    function stringToHex(str) {
        var hex = '';
        for (var i = 0; i < str.length; i++) {
            hex += str.charCodeAt(i).toString(16).padStart(2, '0');
        }
        return hex;
    }

    function hexToString(hex) {
        var str = '';
        for (var i = 0; i < hex.length; i += 2) {
            str += String.fromCharCode(parseInt(hex.substr(i, 2), 16));
        }
        return str;
    }

    function stringToBinary(str) {
        return str.split('').map(function(char) {
            return char.charCodeAt(0).toString(2).padStart(8, '0');
        }).join(' ');
    }

    function binaryToString(binary) {
        return binary.split(' ').map(function(bin) {
            return String.fromCharCode(parseInt(bin, 2));
        }).join('');
    }

    function rot13(str) {
        return str.replace(/[a-zA-Z]/g, function(char) {
            var code = char.charCodeAt(0);
            var base = (code >= 65 && code <= 90) ? 65 : 97;
            return String.fromCharCode(((code - base + 13) % 26) + base);
        });
    }

    function caesarCipher(str, shift) {
        return str.replace(/[a-zA-Z]/g, function(char) {
            var code = char.charCodeAt(0);
            var base = (code >= 65 && code <= 90) ? 65 : 97;
            return String.fromCharCode(((code - base + shift) % 26) + base);
        });
    }

    function unicodeEscape(str) {
        return str.split('').map(function(char) {
            var hex = char.charCodeAt(0).toString(16);
            return '\\u' + ('0000' + hex).slice(-4);
        }).join('');
    }

    function unicodeUnescape(str) {
        return str.replace(/\\u([0-9a-fA-F]{4})/g, function(match, hex) {
            return String.fromCharCode(parseInt(hex, 16));
        });
    }

    function slugify(str) {
        return str.toLowerCase()
            .trim()
            .replace(/[^\w\s-]/g, '')
            .replace(/[\s_-]+/g, '-')
            .replace(/^-+|-+$/g, '');
    }

    function removeDuplicateLines(str) {
        var lines = str.split('\n');
        var unique = [];
        var seen = {};
        lines.forEach(function(line) {
            if (!seen[line]) {
                seen[line] = true;
                unique.push(line);
            }
        });
        return unique.join('\n');
    }

    function sortLines(str, ascending) {
        var lines = str.split('\n');
        lines.sort();
        if (!ascending) lines.reverse();
        return lines.join('\n');
    }

    function extractUrls(str) {
        var urlRegex = /(https?:\/\/[^\s]+)/g;
        var urls = str.match(urlRegex);
        return urls ? urls.join('\n') : 'No URLs found';
    }

    function extractEmails(str) {
        var emailRegex = /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/g;
        var emails = str.match(emailRegex);
        return emails ? emails.join('\n') : 'No emails found';
    }

    function generateRandom() {
        var length = parseInt(document.getElementById('randomLength').value) || 16;
        var type = document.getElementById('randomType').value;
        var chars = '';

        switch(type) {
            case 'alphanumeric':
                chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
                break;
            case 'alpha':
                chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
                break;
            case 'numeric':
                chars = '0123456789';
                break;
            case 'hex':
                chars = '0123456789abcdef';
                break;
            case 'special':
                chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?';
                break;
        }

        var result = '';
        for (var i = 0; i < length; i++) {
            result += chars.charAt(Math.floor(Math.random() * chars.length));
        }

        displayOutput(result, 'Random String (' + type + ', length ' + length + ')');
    }

    // New case style conversion functions
    function toCamelCase(str) {
        return str.replace(/(?:^\w|[A-Z]|\b\w)/g, function(word, index) {
            return index === 0 ? word.toLowerCase() : word.toUpperCase();
        }).replace(/\s+/g, '').replace(/[-_]/g, '');
    }

    function toPascalCase(str) {
        return str.replace(/(?:^\w|[A-Z]|\b\w)/g, function(word) {
            return word.toUpperCase();
        }).replace(/\s+/g, '').replace(/[-_]/g, '');
    }

    function toSnakeCase(str) {
        return str.replace(/\W+/g, ' ')
            .split(/ |\B(?=[A-Z])/)
            .map(function(word) { return word.toLowerCase(); })
            .join('_');
    }

    function toKebabCase(str) {
        return str.replace(/\W+/g, ' ')
            .split(/ |\B(?=[A-Z])/)
            .map(function(word) { return word.toLowerCase(); })
            .join('-');
    }

    function toConstantCase(str) {
        return toSnakeCase(str).toUpperCase();
    }

    function toDotCase(str) {
        return str.replace(/\W+/g, ' ')
            .split(/ |\B(?=[A-Z])/)
            .map(function(word) { return word.toLowerCase(); })
            .join('.');
    }

    function toggleCase(str) {
        return str.split('').map(function(char) {
            return char === char.toUpperCase() ? char.toLowerCase() : char.toUpperCase();
        }).join('');
    }

    function removeHtmlTags(str) {
        return str.replace(/<[^>]*>/g, '');
    }

    // Line operations
    function reverseLinesOrder(str) {
        return str.split('\n').reverse().join('\n');
    }

    function addLineNumbers(str) {
        var lines = str.split('\n');
        return lines.map(function(line, index) {
            return (index + 1) + '. ' + line;
        }).join('\n');
    }

    function removeLineNumbers(str) {
        return str.split('\n').map(function(line) {
            return line.replace(/^\d+\.\s*/, '');
        }).join('\n');
    }

    function addLinePrefix(str, prefix) {
        if (!prefix) return str;
        return str.split('\n').map(function(line) {
            return prefix + line;
        }).join('\n');
    }

    function addLineSuffix(str, suffix) {
        if (!suffix) return str;
        return str.split('\n').map(function(line) {
            return line + suffix;
        }).join('\n');
    }

    function joinLines(str, delimiter) {
        delimiter = delimiter || ' ';
        return str.split('\n').join(delimiter);
    }

    function splitByDelimiter(str, delimiter) {
        if (!delimiter) return str;
        return str.split(delimiter).join('\n');
    }

    function wrapText(str, width) {
        var words = str.split(' ');
        var lines = [];
        var currentLine = '';

        words.forEach(function(word) {
            if ((currentLine + word).length > width) {
                lines.push(currentLine.trim());
                currentLine = word + ' ';
            } else {
                currentLine += word + ' ';
            }
        });

        if (currentLine) {
            lines.push(currentLine.trim());
        }

        return lines.join('\n');
    }

    function analyzeText(str) {
        var chars = str.length;
        var charsNoSpace = str.replace(/\s/g, '').length;
        var words = str.trim() ? str.trim().split(/\s+/) : [];
        var wordCount = words.length;
        var lines = str.split('\n');
        var lineCount = lines.length;
        var sentences = str.split(/[.!?]+/).filter(function(s) { return s.trim(); }).length;
        var paragraphs = str.split(/\n\n+/).filter(function(p) { return p.trim(); }).length;

        // Calculate unique words
        var uniqueWords = {};
        words.forEach(function(word) {
            var w = word.toLowerCase().replace(/[^a-z0-9]/g, '');
            if (w) uniqueWords[w] = true;
        });
        var uniqueCount = Object.keys(uniqueWords).length;

        // Average word length
        var totalLength = 0;
        words.forEach(function(word) {
            totalLength += word.length;
        });
        var avgWordLength = wordCount > 0 ? (totalLength / wordCount).toFixed(2) : 0;

        // Reading time (average 200 words per minute)
        var readingMinutes = Math.ceil(wordCount / 200);

        var result = 'TEXT ANALYSIS\n';
        result += '═══════════════════════════════════════\n\n';
        result += 'Characters: ' + chars + '\n';
        result += 'Characters (no spaces): ' + charsNoSpace + '\n';
        result += 'Words: ' + wordCount + '\n';
        result += 'Unique words: ' + uniqueCount + '\n';
        result += 'Lines: ' + lineCount + '\n';
        result += 'Sentences: ' + sentences + '\n';
        result += 'Paragraphs: ' + paragraphs + '\n';
        result += 'Average word length: ' + avgWordLength + ' characters\n';
        result += 'Reading time: ~' + readingMinutes + ' minute(s)\n';

        return result;
    }

    function wordFrequency(str) {
        var words = str.toLowerCase().match(/\b[a-z0-9]+\b/g) || [];
        var freq = {};

        words.forEach(function(word) {
            freq[word] = (freq[word] || 0) + 1;
        });

        var sorted = Object.keys(freq).map(function(word) {
            return { word: word, count: freq[word] };
        }).sort(function(a, b) {
            return b.count - a.count;
        });

        var result = 'WORD FREQUENCY (Top 20)\n';
        result += '═══════════════════════════════════════\n\n';

        sorted.slice(0, 20).forEach(function(item, index) {
            result += (index + 1) + '. "' + item.word + '" - ' + item.count + ' times\n';
        });

        return result || 'No words found';
    }

    function numberToWords(input) {
        var ones = ['', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
        var teens = ['ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen'];
        var tens = ['', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'];

        function convertHundreds(num) {
            if (num === 0) return '';

            var str = '';
            if (num > 99) {
                str += ones[Math.floor(num / 100)] + ' hundred ';
                num %= 100;
            }
            if (num > 19) {
                str += tens[Math.floor(num / 10)] + ' ';
                num %= 10;
            }
            if (num > 9 && num < 20) {
                str += teens[num - 10] + ' ';
                return str;
            }
            if (num > 0) {
                str += ones[num] + ' ';
            }
            return str;
        }

        var num = parseInt(input);
        if (isNaN(num)) {
            return 'Not a valid number';
        }

        if (num === 0) return 'zero';

        var result = '';
        if (num < 0) {
            result = 'negative ';
            num = Math.abs(num);
        }

        if (num >= 1000000000) {
            var billions = Math.floor(num / 1000000000);
            var billionWords = convertHundreds(billions);
            if (billionWords) {
                result += billionWords + 'billion ';
            }
            num %= 1000000000;
        }
        if (num >= 1000000) {
            var millions = Math.floor(num / 1000000);
            var millionWords = convertHundreds(millions);
            if (millionWords) {
                result += millionWords + 'million ';
            }
            num %= 1000000;
        }
        if (num >= 1000) {
            var thousands = Math.floor(num / 1000);
            var thousandWords = convertHundreds(thousands);
            if (thousandWords) {
                result += thousandWords + 'thousand ';
            }
            num %= 1000;
        }
        if (num > 0) {
            result += convertHundreds(num);
        }

        return result.trim();
    }

    function textDiff(text1, text2) {
        if (!text2) {
            return 'Please enter Text 2 in the options panel to compare.';
        }

        var diff = Diff.diffLines(text1, text2);
        var result = '';

        diff.forEach(function(part) {
            var prefix = part.added ? '+ ' : part.removed ? '- ' : '  ';
            var lines = part.value.split('\n');
            lines.forEach(function(line) {
                if (line) {
                    result += prefix + line + '\n';
                }
            });
        });

        return result || 'No differences found';
    }

    function generateUUID() {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            var r = Math.random() * 16 | 0;
            var v = c === 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    function generateLoremIpsum() {
        var paragraphs = parseInt(document.getElementById('loremParagraphs').value) || 3;
        var sentences = parseInt(document.getElementById('loremSentences').value) || 5;

        var loremWords = [
            'lorem', 'ipsum', 'dolor', 'sit', 'amet', 'consectetur', 'adipiscing', 'elit',
            'sed', 'do', 'eiusmod', 'tempor', 'incididunt', 'ut', 'labore', 'et', 'dolore',
            'magna', 'aliqua', 'enim', 'ad', 'minim', 'veniam', 'quis', 'nostrud',
            'exercitation', 'ullamco', 'laboris', 'nisi', 'aliquip', 'ex', 'ea', 'commodo',
            'consequat', 'duis', 'aute', 'irure', 'in', 'reprehenderit', 'voluptate',
            'velit', 'esse', 'cillum', 'fugiat', 'nulla', 'pariatur', 'excepteur', 'sint',
            'occaecat', 'cupidatat', 'non', 'proident', 'sunt', 'culpa', 'qui', 'officia',
            'deserunt', 'mollit', 'anim', 'id', 'est', 'laborum'
        ];

        var result = '';

        for (var p = 0; p < paragraphs; p++) {
            for (var s = 0; s < sentences; s++) {
                var sentenceLength = Math.floor(Math.random() * 10) + 5;
                var sentence = '';

                for (var w = 0; w < sentenceLength; w++) {
                    var word = loremWords[Math.floor(Math.random() * loremWords.length)];
                    if (w === 0) {
                        word = word.charAt(0).toUpperCase() + word.slice(1);
                    }
                    sentence += word + (w < sentenceLength - 1 ? ' ' : '');
                }

                result += sentence + '. ';
            }
            result += '\n\n';
        }

        return result.trim();
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
        hideError();
    }

    function loadSample() {
        var sample = 'The Quick Brown Fox Jumps Over The Lazy Dog!\n\n' +
                     'This is a sample text with multiple lines.\n' +
                     'You can test various string operations here.\n' +
                     'Email: example@domain.com\n' +
                     'URL: https://example.com\n' +
                     '123-456-7890';

        document.getElementById('textInput').value = sample;
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
        a.download = 'string-output.txt';
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
            <li><a href="yamlparser.jsp">YAML Parser - YAML to JSON/XML Converter</a></li>
            <li><a href="xml2json.jsp">XML Parser - XML to JSON/YAML Converter</a></li>
            <li><a href="jsonparser.jsp">JSON Parser - JSON to YAML/XML Converter</a></li>
            <li><a href="json-2-csv.jsp">JSON to CSV Converter</a></li>
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
