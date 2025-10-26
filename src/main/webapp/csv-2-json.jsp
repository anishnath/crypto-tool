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

    <title>Free CSV to JSON Converter Online - CSV Parser, Validator & Format Tool</title>
    <meta name="description" content="Convert CSV to JSON, YAML, XML online for free. Professional CSV parser with validation, formatting, and syntax highlighting. No upload required - 100% client-side processing. Perfect alternative to Python pandas and Excel conversions." />
    <meta name="keywords" content="csv to json converter, csv parser online, csv validator, csv to json python alternative, excel to json, spreadsheet to json, csv formatter, csv to yaml, csv to xml, tsv to json, delimiter separated values" />

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website" />
    <meta property="og:url" content="https://8gwifi.org/csv-2-json.jsp" />
    <meta property="og:title" content="Free CSV to JSON Converter Online - CSV Parser & Validator Tool" />
    <meta property="og:description" content="Convert CSV to JSON, YAML, XML instantly. Professional CSV parser with validation, formatting, and syntax highlighting. 100% client-side, no server upload." />
    <meta property="og:image" content="https://8gwifi.org/images/csv-parser.png" />

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content="https://8gwifi.org/csv-2-json.jsp" />
    <meta property="twitter:title" content="Free CSV to JSON Converter Online - CSV Parser Tool" />
    <meta property="twitter:description" content="Convert CSV to JSON, YAML, XML with professional parser. Validate, format, and transform CSV data instantly." />
    <meta property="twitter:image" content="https://8gwifi.org/images/csv-parser.png" />

    <link rel="canonical" href="https://8gwifi.org/csv-2-json.jsp" />

    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "Free CSV to JSON Converter Online - Professional CSV Parser & Validator",
      "alternateName": ["CSV to JSON Converter", "CSV Parser Online", "CSV Validator", "CSV Formatter", "Excel to JSON Converter"],
      "description": "Professional online CSV to JSON converter with advanced parsing, validation, and formatting capabilities. Convert CSV to JSON, YAML, XML formats instantly. 100% client-side processing with no server upload required. Perfect for data transformation, spreadsheet conversion, and API data preparation.",
      "url": "https://8gwifi.org/csv-2-json.jsp",
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
        "Convert CSV to JSON with proper parsing",
        "Convert CSV to YAML format",
        "Convert CSV to XML structure",
        "Validate CSV syntax and structure",
        "Format and prettify CSV",
        "Minify CSV output",
        "Support multiple delimiters (comma, semicolon, tab, pipe)",
        "Handle quoted fields and escaped characters",
        "Auto-detect headers",
        "Copy to clipboard",
        "Download converted files",
        "File upload support",
        "Syntax highlighting for all formats",
        "Real-time conversion",
        "Privacy-focused (no server upload)",
        "Diff two CSV files",
        "Generate sample CSV data",
        "Base64 encode/decode CSV",
        "Handle large CSV files",
        "Support TSV (Tab-Separated Values)"
      ],
      "keywords": [
        "csv to json converter online free",
        "csv parser",
        "csv validator tool",
        "csv formatter online",
        "excel to json converter",
        "spreadsheet to json",
        "csv to json python alternative",
        "csv to yaml converter",
        "csv to xml converter",
        "tsv to json",
        "delimiter separated values parser",
        "csv file parser",
        "parse csv online",
        "csv beautifier",
        "csv minifier",
        "csv syntax validator",
        "csv to json array",
        "csv header parser",
        "csv quote handler",
        "csv escape character",
        "comma separated values parser",
        "csv data converter",
        "csv api tool",
        "csv rest api converter",
        "json from csv",
        "convert csv file to json",
        "csv json transformer",
        "online csv processor",
        "csv data validator",
        "csv syntax checker",
        "semicolon delimited to json",
        "pipe delimited to json",
        "tab delimited to json",
        "csv format checker",
        "csv to json nodejs alternative",
        "csv to json java alternative",
        "pandas to_json alternative"
      ],
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.9",
        "ratingCount": "4100",
        "bestRating": "5",
        "worstRating": "1"
      },
      "screenshot": "https://8gwifi.org/images/csv-parser-screenshot.png"
    }
    </script>

    <!-- External Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-json.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-yaml.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-markup.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-csv.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/js-yaml/4.1.0/js-yaml.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.4.1/papaparse.min.js"></script>
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
            white-space: pre-wrap;
            word-wrap: break-word;
            overflow-wrap: break-word;
            word-break: break-word;
        }

        .output-panel code {
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 14px;
            white-space: pre-wrap;
            word-wrap: break-word;
            overflow-wrap: break-word;
            word-break: break-all;
            max-width: 100%;
            display: block;
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
            min-width: 100px;
        }

        .option-group select,
        .option-group input[type="text"] {
            padding: 5px 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.9rem;
        }

        .option-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
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

        .file-upload {
            margin-bottom: 15px;
        }

        .file-upload input[type="file"] {
            display: none;
        }

        .file-upload-label {
            display: inline-block;
            padding: 8px 16px;
            background: #007bff;
            color: white;
            border-radius: 4px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: background 0.2s;
        }

        .file-upload-label:hover {
            background: #0056b3;
        }

        .diff-container {
            display: flex;
            gap: 20px;
        }

        .diff-panel {
            flex: 1;
        }

        .diff-output {
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 13px;
            background: #2d2d2d;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 4px;
            min-height: 300px;
            overflow: auto;
            white-space: pre-wrap;
        }

        .diff-added {
            background: #1e4620;
            color: #a8e6a3;
        }

        .diff-removed {
            background: #5c1f1f;
            color: #f8a8a8;
        }

        @media (max-width: 768px) {
            .editor-container {
                flex-direction: column;
            }

            .diff-container {
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
    <h1>CSV to JSON Converter - Professional CSV Parser & Validator</h1>
    <p class="subtitle">Convert CSV to JSON, YAML, XML instantly. Validate CSV syntax, format data, and transform delimited files with advanced parsing. 100% client-side, privacy-focused - no server upload required.</p>

    <div class="operations-bar">
        <div class="operation-tab active" data-operation="csv-to-json">CSV to JSON</div>
        <div class="operation-tab" data-operation="csv-to-yaml">CSV to YAML</div>
        <div class="operation-tab" data-operation="csv-to-xml">CSV to XML</div>
        <div class="operation-tab" data-operation="validate-csv">Validate CSV</div>
        <div class="operation-tab" data-operation="format-csv">Format CSV</div>
        <div class="operation-tab" data-operation="minify-csv">Minify CSV</div>
        <div class="operation-tab" data-operation="diff-csv">Diff Two CSV</div>
        <div class="operation-tab" data-operation="sample-csv">Sample Data</div>
        <div class="operation-tab" data-operation="base64-encode">Base64 Encode</div>
        <div class="operation-tab" data-operation="base64-decode">Base64 Decode</div>
    </div>

    <div class="options-panel">
        <div class="option-group">
            <label>Delimiter:</label>
            <select id="delimiter">
                <option value=",">Comma (,)</option>
                <option value=";">Semicolon (;)</option>
                <option value="\t">Tab (\t)</option>
                <option value="|">Pipe (|)</option>
            </select>

            <label>Quote Character:</label>
            <select id="quoteChar">
                <option value='"'>Double Quote (")</option>
                <option value="'">Single Quote (')</option>
            </select>

            <label style="display: flex; align-items: center; gap: 5px;">
                <input type="checkbox" id="hasHeaders" checked>
                Has Headers
            </label>

            <label style="display: flex; align-items: center; gap: 5px;">
                <input type="checkbox" id="skipEmptyLines" checked>
                Skip Empty Lines
            </label>

            <label style="display: flex; align-items: center; gap: 5px;">
                <input type="checkbox" id="relaxedParsing" checked>
                Relaxed Parsing
            </label>
        </div>

        <div class="file-upload">
            <input type="file" id="fileInput" accept=".csv,.txt,.tsv" />
            <label for="fileInput" class="file-upload-label">Upload CSV File</label>
            <span id="fileName" style="margin-left: 10px; font-size: 0.9rem; color: #666;"></span>
        </div>
    </div>

    <div class="editor-container" id="mainEditor">
        <div class="input-panel">
            <div class="panel-header">
                <span class="panel-title">CSV Input</span>
                <div class="panel-actions">
                    <button class="action-btn" onclick="clearInput()">Clear</button>
                    <button class="action-btn" onclick="loadSample()">Load Sample</button>
                </div>
            </div>
            <textarea id="csvInput" placeholder="Paste your CSV data here or upload a file..."></textarea>
        </div>

        <div class="output-panel">
            <div class="panel-header">
                <span class="panel-title" id="outputTitle">JSON Output</span>
                <div class="panel-actions">
                    <button class="action-btn" onclick="copyOutput()">Copy</button>
                    <button class="action-btn" onclick="downloadOutput()">Download</button>
                </div>
            </div>
            <pre id="output"><code id="outputCode" class="language-json"></code></pre>
        </div>
    </div>

    <div class="diff-container" id="diffEditor" style="display: none;">
        <div class="diff-panel">
            <div class="panel-header">
                <span class="panel-title">CSV 1</span>
            </div>
            <textarea id="csv1" placeholder="Paste first CSV here..." style="min-height: 300px;"></textarea>
        </div>

        <div class="diff-panel">
            <div class="panel-header">
                <span class="panel-title">CSV 2</span>
            </div>
            <textarea id="csv2" placeholder="Paste second CSV here..." style="min-height: 300px;"></textarea>
        </div>
    </div>

    <div id="diffOutput" style="display: none; margin-top: 20px;">
        <div class="panel-header">
            <span class="panel-title">Differences</span>
            <div class="panel-actions">
                <button class="action-btn" onclick="copyDiff()">Copy</button>
            </div>
        </div>
        <div class="diff-output" id="diffResult"></div>
    </div>

    <div class="error-message" id="errorMessage"></div>
    <div class="success-message" id="successMessage"></div>
</div>

<script>
    let currentOperation = 'csv-to-json';
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
        document.getElementById('csvInput').addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                handleOperation();
            }, 500);
        });

        // CSV diff inputs
        document.getElementById('csv1').addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                performDiff();
            }, 500);
        });

        document.getElementById('csv2').addEventListener('input', function() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(function() {
                performDiff();
            }, 500);
        });

        // Options change
        document.getElementById('delimiter').addEventListener('change', handleOperation);
        document.getElementById('quoteChar').addEventListener('change', handleOperation);
        document.getElementById('hasHeaders').addEventListener('change', handleOperation);
        document.getElementById('skipEmptyLines').addEventListener('change', handleOperation);
        document.getElementById('relaxedParsing').addEventListener('change', handleOperation);

        // File upload
        document.getElementById('fileInput').addEventListener('change', handleFileUpload);
    });

    function handleFileUpload(e) {
        var file = e.target.files[0];
        if (!file) return;

        document.getElementById('fileName').textContent = file.name;

        var reader = new FileReader();
        reader.onload = function(event) {
            document.getElementById('csvInput').value = event.target.result;
            handleOperation();
        };
        reader.readAsText(file);
    }

    function handleOperation() {
        var mainEditor = document.getElementById('mainEditor');
        var diffEditor = document.getElementById('diffEditor');
        var diffOutput = document.getElementById('diffOutput');

        if (currentOperation === 'diff-csv') {
            mainEditor.style.display = 'none';
            diffEditor.style.display = 'flex';
            diffOutput.style.display = 'block';
            performDiff();
            return;
        } else {
            mainEditor.style.display = 'flex';
            diffEditor.style.display = 'none';
            diffOutput.style.display = 'none';
        }

        if (currentOperation === 'sample-csv') {
            var sample = 'name,age,city,country,email\n' +
                         'John Doe,30,New York,USA,john@example.com\n' +
                         'Jane Smith,25,London,UK,jane@example.com\n' +
                         'Bob Johnson,35,Toronto,Canada,bob@example.com\n' +
                         'Alice Williams,28,Sydney,Australia,alice@example.com\n' +
                         'Charlie Brown,32,Berlin,Germany,charlie@example.com';

            document.getElementById('csvInput').value = sample;

            currentOperation = 'csv-to-json';
            document.querySelectorAll('.operation-tab').forEach(function(t) {
                t.classList.remove('active');
            });
            document.querySelector('[data-operation="csv-to-json"]').classList.add('active');

            // Continue to process the sample data
            convertToJSON();
            return;
        }

        var input = document.getElementById('csvInput').value.trim();
        if (!input) {
            clearOutput();
            return;
        }

        try {
            switch(currentOperation) {
                case 'csv-to-json':
                    convertToJSON();
                    break;
                case 'csv-to-yaml':
                    convertToYAML();
                    break;
                case 'csv-to-xml':
                    convertToXML();
                    break;
                case 'validate-csv':
                    validateCSV();
                    break;
                case 'format-csv':
                    formatCSV();
                    break;
                case 'minify-csv':
                    minifyCSV();
                    break;
                case 'base64-encode':
                    base64Encode();
                    break;
                case 'base64-decode':
                    base64Decode();
                    break;
            }
        } catch(error) {
            showError(error.message);
        }
    }

    function parseCSV() {
        var input = document.getElementById('csvInput').value;
        var delimiter = document.getElementById('delimiter').value;
        if (delimiter === '\\t') delimiter = '\t';
        var quoteChar = document.getElementById('quoteChar').value;
        var hasHeaders = document.getElementById('hasHeaders').checked;
        var skipEmptyLines = document.getElementById('skipEmptyLines').checked;
        var relaxedParsing = document.getElementById('relaxedParsing').checked;

        // Auto-detect delimiter if needed
        var autoDelimiter = delimiter;
        var firstLine = input.split('\n')[0];
        if (firstLine) {
            var tabCount = (firstLine.match(/\t/g) || []).length;
            var commaCount = (firstLine.match(/,/g) || []).length;
            var semicolonCount = (firstLine.match(/;/g) || []).length;
            var pipeCount = (firstLine.match(/\|/g) || []).length;

            // If tabs are dominant, use tab delimiter
            if (tabCount > commaCount && tabCount > semicolonCount && tabCount > pipeCount) {
                autoDelimiter = '\t';
                document.getElementById('delimiter').value = '\\t';
            }
        }

        var config = {
            delimiter: autoDelimiter,
            quoteChar: quoteChar,
            header: hasHeaders,
            skipEmptyLines: skipEmptyLines,
            dynamicTyping: true,
            escapeChar: quoteChar,
            newline: '',
            delimitersToGuess: ['\t', ',', '|', ';', Papa.RECORD_SEP, Papa.UNIT_SEP],
            transformHeader: function(header) {
                if (!header) return '';
                // Remove quotes from headers
                var cleaned = header.trim().replace(/^["']|["']$/g, '');
                return cleaned;
            },
            transform: function(value) {
                if (!value) return '';
                // Remove quotes from values
                var cleaned = value.trim().replace(/^["']|["']$/g, '');
                return cleaned;
            }
        };

        // Add relaxed parsing options to handle malformed CSV
        if (relaxedParsing) {
            config.skipEmptyLines = 'greedy';
            config.comments = false;
            config.fastMode = false;
        }

        var result = Papa.parse(input, config);

        if (result.errors.length > 0 && !relaxedParsing) {
            var criticalErrors = result.errors.filter(function(err) {
                return err.type === 'Quotes' || err.type === 'Delimiter';
            });

            if (criticalErrors.length > 0) {
                var errorMsg = 'CSV parsing error: ' + criticalErrors[0].message;
                if (criticalErrors[0].row !== undefined) {
                    errorMsg += ' (at row ' + (criticalErrors[0].row + 1) + ')';
                }
                errorMsg += '\n\nTip: Try enabling "Relaxed Parsing" to handle malformed CSV files.';
                throw new Error(errorMsg);
            }
        }

        // Filter out empty rows
        if (result.data && Array.isArray(result.data)) {
            result.data = result.data.filter(function(row) {
                if (typeof row === 'object' && row !== null) {
                    return Object.values(row).some(function(val) {
                        return val !== null && val !== undefined && val !== '';
                    });
                }
                return true;
            });
        }

        return result.data;
    }

    function convertToJSON() {
        var data = parseCSV();
        var jsonStr = JSON.stringify(data, null, 4);
        displayOutput(jsonStr, 'JSON Output', 'json');
        hideError();
    }

    function convertToYAML() {
        var data = parseCSV();
        var yamlStr = jsyaml.dump(data, {
            indent: 4,
            lineWidth: -1,
            noRefs: true,
            sortKeys: false
        });
        displayOutput(yamlStr, 'YAML Output', 'yaml');
        hideError();
    }

    function convertToXML() {
        var data = parseCSV();
        var xml = '<?xml version="1.0" encoding="UTF-8"?>\n<root>\n';

        data.forEach(function(row, index) {
            xml += '    <row index="' + index + '">\n';
            for (var key in row) {
                if (row.hasOwnProperty(key)) {
                    var value = row[key];
                    if (value === null || value === undefined) value = '';
                    xml += '        <' + escapeXmlTag(key) + '>' + escapeXml(String(value)) + '</' + escapeXmlTag(key) + '>\n';
                }
            }
            xml += '    </row>\n';
        });

        xml += '</root>';
        displayOutput(xml, 'XML Output', 'markup');
        hideError();
    }

    function validateCSV() {
        try {
            var data = parseCSV();
            var message = 'CSV is valid!\n\n';
            message += 'Total rows: ' + data.length + '\n';

            if (data.length > 0) {
                var keys = Object.keys(data[0]);
                message += 'Columns: ' + keys.length + '\n';
                message += 'Column names: ' + keys.join(', ') + '\n';
            }

            displayOutput(message, 'Validation Result', 'json');
            showSuccess('CSV validation successful!');
        } catch(error) {
            showError('Validation failed: ' + error.message);
        }
    }

    function formatCSV() {
        var data = parseCSV();
        var delimiter = document.getElementById('delimiter').value;
        if (delimiter === '\\t') delimiter = '\t';
        var quoteChar = document.getElementById('quoteChar').value;

        var formatted = Papa.unparse(data, {
            delimiter: delimiter,
            quotes: true,
            quoteChar: quoteChar,
            header: true
        });

        displayOutput(formatted, 'Formatted CSV', 'csv');
        hideError();
    }

    function minifyCSV() {
        var data = parseCSV();
        var delimiter = document.getElementById('delimiter').value;
        if (delimiter === '\\t') delimiter = '\t';

        var minified = Papa.unparse(data, {
            delimiter: delimiter,
            quotes: false,
            header: true,
            newline: '\n'
        });

        displayOutput(minified, 'Minified CSV', 'csv');
        hideError();
    }

    function base64Encode() {
        var input = document.getElementById('csvInput').value;
        var encoded = btoa(unescape(encodeURIComponent(input)));
        displayOutput(encoded, 'Base64 Encoded', 'json');
        hideError();
    }

    function base64Decode() {
        try {
            var input = document.getElementById('csvInput').value.trim();
            var decoded = decodeURIComponent(escape(atob(input)));
            displayOutput(decoded, 'Base64 Decoded', 'csv');
            hideError();
        } catch(error) {
            showError('Invalid Base64 input');
        }
    }

    function performDiff() {
        var csv1 = document.getElementById('csv1').value.trim();
        var csv2 = document.getElementById('csv2').value.trim();

        if (!csv1 || !csv2) {
            document.getElementById('diffResult').textContent = 'Enter CSV data in both panels to see differences.';
            return;
        }

        var diff = Diff.diffLines(csv1, csv2);
        var diffHtml = '';

        diff.forEach(function(part) {
            var color = part.added ? 'diff-added' : part.removed ? 'diff-removed' : '';
            var prefix = part.added ? '+ ' : part.removed ? '- ' : '  ';
            var lines = part.value.split('\n');
            lines.forEach(function(line) {
                if (line) {
                    diffHtml += '<div class="' + color + '">' + escapeHtml(prefix + line) + '</div>';
                }
            });
        });

        document.getElementById('diffResult').innerHTML = diffHtml;
    }

    function loadSample() {
        var sample = 'name,age,city,country,email\n' +
                     'John Doe,30,New York,USA,john@example.com\n' +
                     'Jane Smith,25,London,UK,jane@example.com\n' +
                     'Bob Johnson,35,Toronto,Canada,bob@example.com\n' +
                     'Alice Williams,28,Sydney,Australia,alice@example.com\n' +
                     'Charlie Brown,32,Berlin,Germany,charlie@example.com';

        document.getElementById('csvInput').value = sample;

        // Only trigger conversion if we're not already in sample mode
        if (currentOperation !== 'sample-csv') {
            convertToJSON();
        }
    }

    function displayOutput(content, title, language) {
        var outputTitle = document.getElementById('outputTitle');
        var outputCode = document.getElementById('outputCode');

        outputTitle.textContent = title;
        outputCode.textContent = content;
        outputCode.className = 'language-' + language;

        if (typeof Prism !== 'undefined') {
            Prism.highlightElement(outputCode);
        }
    }

    function clearOutput() {
        document.getElementById('outputCode').textContent = '';
    }

    function clearInput() {
        document.getElementById('csvInput').value = '';
        clearOutput();
        hideError();
    }

    function copyOutput() {
        var output = document.getElementById('outputCode').textContent;
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

    function copyDiff() {
        var output = document.getElementById('diffResult').textContent;
        if (!output) {
            showError('Nothing to copy');
            return;
        }

        navigator.clipboard.writeText(output).then(function() {
            showSuccess('Diff copied to clipboard!');
        }).catch(function(err) {
            showError('Failed to copy: ' + err);
        });
    }

    function downloadOutput() {
        var output = document.getElementById('outputCode').textContent;
        if (!output) {
            showError('Nothing to download');
            return;
        }

        var extension = 'txt';
        var mimeType = 'text/plain';

        switch(currentOperation) {
            case 'csv-to-json':
                extension = 'json';
                mimeType = 'application/json';
                break;
            case 'csv-to-yaml':
                extension = 'yaml';
                mimeType = 'text/yaml';
                break;
            case 'csv-to-xml':
                extension = 'xml';
                mimeType = 'application/xml';
                break;
            case 'format-csv':
            case 'minify-csv':
                extension = 'csv';
                mimeType = 'text/csv';
                break;
        }

        var blob = new Blob([output], { type: mimeType });
        var url = URL.createObjectURL(blob);
        var a = document.createElement('a');
        a.href = url;
        a.download = 'converted.' + extension;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        showSuccess('File downloaded successfully!');
    }

    function escapeXml(unsafe) {
        return String(unsafe).replace(/[<>&'"]/g, function(c) {
            switch (c) {
                case '<': return '&lt;';
                case '>': return '&gt;';
                case '&': return '&amp;';
                case '\'': return '&apos;';
                case '"': return '&quot;';
            }
        });
    }

    function escapeXmlTag(tag) {
        return tag.replace(/[^a-zA-Z0-9_-]/g, '_');
    }

    function escapeHtml(text) {
        var div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
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
<h2 class="mt-4">Try Other Converters</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="yamlparser.jsp">YAML Parser - YAML to JSON/XML Converter</a></li>
            <li><a href="xml2json.jsp">XML Parser - XML to JSON/YAML Converter</a></li>
            <li><a href="jsonparser.jsp">JSON Parser - JSON to YAML/XML Converter</a></li>
            <li><a href="json-2-csv.jsp">JSON to CSV Converter</a></li>
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
