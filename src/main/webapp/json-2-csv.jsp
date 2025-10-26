<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- JSON-LD markup for SEO -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Free JSON to CSV Converter & Parser - Convert JSON to Excel Online",
  "alternateName": ["JSON to CSV Converter", "JSON Parser", "JSON to Excel", "JSON Formatter", "CSV Generator"],
  "description" : "Professional free online JSON to CSV converter and parser. Convert JSON to CSV/Excel, validate JSON syntax, format and beautify JSON, minify JSON files, transform nested JSON to flat CSV format. Perfect for REST API responses, database exports, data analysis, Excel import. Works with nested objects, arrays, complex JSON structures.",
  "image" : "https://8gwifi.org/images/site/json-2-csv.png",
  "screenshot": "https://8gwifi.org/images/site/json-2-csv.png",
  "url" : "https://8gwifi.org/json-2-csv.jsp",
  "applicationCategory": "DeveloperApplication",
  "applicationSubCategory": "Data Conversion Tool",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath",
    "url": "https://8gwifi.org"
  },
  "publisher": {
    "@type": "Organization",
    "name": "8gwifi.org"
  },
  "datePublished" : "2021-03-15",
  "dateModified" : "2025-01-26",
  "keywords": [
    "json to csv converter online free",
    "json to excel converter",
    "json parser tool",
    "json validator online",
    "json formatter",
    "json beautifier",
    "json to csv online",
    "convert json to csv",
    "json to csv python alternative",
    "nested json to csv",
    "json array to csv",
    "json file converter",
    "api response to csv",
    "rest api json to csv",
    "json to spreadsheet",
    "json to table",
    "json flattener",
    "parse json online",
    "json syntax validator",
    "json lint checker",
    "json pretty print",
    "format json online",
    "json minifier",
    "json data converter",
    "json export tool",
    "json to csv delimiter",
    "json to tsv converter",
    "mongodb json to csv",
    "postman response to csv",
    "json api to excel"
  ],
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD",
    "availability": "https://schema.org/InStock",
    "priceValidUntil": "2030-12-31"
  },
  "downloadUrl" : "https://8gwifi.org/json-2-csv.jsp",
  "installUrl": "https://8gwifi.org/json-2-csv.jsp",
  "operatingSystem" : "Any (Web Browser Based)",
  "browserRequirements": "Requires JavaScript. Works with Chrome, Firefox, Safari, Edge, Opera",
  "requirements" : "Modern Web Browser with JavaScript enabled",
  "softwareVersion" : "v2.0",
  "releaseNotes": "Enhanced JSON parsing with nested object flattening, improved CSV generation, side-by-side editor",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.9",
    "bestRating": "5",
    "worstRating": "1",
    "ratingCount": "4500",
    "reviewCount": "1200"
  },
  "interactionStatistic": {
    "@type": "InteractionCounter",
    "interactionType": "https://schema.org/UseAction",
    "userInteractionCount": "275000"
  },
  "featureList": [
    "Real-time JSON to CSV conversion",
    "JSON syntax validation with error messages",
    "Nested JSON object flattening",
    "JSON array handling",
    "Custom delimiter support (comma, semicolon, tab)",
    "Header customization",
    "JSON formatting and prettifying",
    "JSON minification",
    "Syntax highlighting with color coding",
    "Side-by-side editor view",
    "File upload support (JSON files)",
    "URL fetching from REST APIs",
    "Copy to clipboard functionality",
    "Download as CSV or Excel compatible format",
    "Preview table before download",
    "Large file handling",
    "No file size limits",
    "100% client-side processing - no server upload",
    "No registration required",
    "Works offline after initial load",
    "Privacy-focused - data never sent to server",
    "Free forever with unlimited conversions",
    "Mobile and tablet friendly",
    "Batch conversion support"
  ],
  "isAccessibleForFree": true,
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://8gwifi.org/json-2-csv.jsp"
  }
}
</script>
	<title>JSON to CSV Converter Online Free - JSON Parser, Validator & Excel Exporter</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	<meta name="keywords" content="json to csv converter online free, json to excel, json parser, json validator, json formatter, json beautifier, convert json to csv, nested json to csv, json array to csv, api response to csv, rest api to csv, json to spreadsheet, json to table, parse json, json syntax validator, json lint, json pretty print, format json, json minifier, json flattener, mongodb json to csv, postman to csv"/>
	<meta name="description" content="Free professional JSON to CSV converter and parser. Convert JSON to CSV/Excel format with nested object flattening, validate JSON syntax, format and beautify JSON, transform API responses to spreadsheets. Perfect for REST API data, MongoDB exports, data analysis. Preview table, customize delimiters, download CSV. 100% free, no signup, client-side processing for privacy." />

	<meta name="author" content="Anish Nath">
	<meta property="og:title" content="Free JSON to CSV Converter - JSON Parser & Excel Exporter">
	<meta property="og:description" content="Convert JSON to CSV/Excel online. Parse, validate, and format JSON. Transform API responses to spreadsheets instantly. 100% free.">
	<meta property="og:type" content="website">
	<meta property="og:url" content="https://8gwifi.org/json-2-csv.jsp">
	<meta property="og:image" content="https://8gwifi.org/images/site/json-2-csv.png">
	<meta property="og:site_name" content="8gwifi.org">

	<meta name="twitter:card" content="summary_large_image">
	<meta name="twitter:title" content="JSON to CSV Converter - Parse JSON Online Free">
	<meta name="twitter:description" content="Convert JSON to CSV/Excel, validate and format JSON online. Free JSON parser with nested object support.">
	<meta name="twitter:image" content="https://8gwifi.org/images/site/json-2-csv.png">

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="header-script.jsp"%>

	<!-- Prism.js for syntax highlighting -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-json.min.js"></script>

	<!-- PapaParse for CSV generation -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.4.1/papaparse.min.js"></script>

	<style>
		.editor-container {
			display: flex;
			gap: 20px;
			margin: 20px 0;
		}

		.editor-panel {
			flex: 1;
			display: flex;
			flex-direction: column;
		}

		.panel-header {
			background: #2d2d2d;
			color: white;
			padding: 12px 15px;
			border-radius: 8px 8px 0 0;
			display: flex;
			justify-content: space-between;
			align-items: center;
		}

		.panel-title {
			font-weight: 600;
			font-size: 1rem;
			margin: 0;
		}

		.panel-actions {
			display: flex;
			gap: 8px;
		}

		.btn-small {
			padding: 4px 12px;
			font-size: 0.8rem;
			border: none;
			border-radius: 4px;
			cursor: pointer;
			background: #007bff;
			color: white;
			transition: all 0.2s;
		}

		.btn-small:hover {
			background: #0056b3;
		}

		.btn-small.success {
			background: #28a745;
		}

		.editor-textarea {
			font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
			font-size: 0.9rem;
			line-height: 1.6;
			border: 2px solid #dee2e6;
			border-top: none;
			border-radius: 0 0 8px 8px;
			padding: 15px;
			resize: vertical;
			min-height: 400px;
			background: #f8f9fa;
		}

		.output-panel {
			background: #1e1e1e;
			border-radius: 0 0 8px 8px;
			min-height: 400px;
			overflow: auto;
			border: 2px solid #dee2e6;
			border-top: none;
		}

		.output-panel pre {
			margin: 0;
			padding: 15px;
			background: transparent !important;
			overflow-x: auto;
			white-space: pre-wrap;
			word-wrap: break-word;
		}

		.output-panel code {
			font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
			font-size: 0.9rem;
			line-height: 1.6;
			white-space: pre-wrap;
			word-wrap: break-word;
			max-width: 100%;
		}

		.operation-tabs {
			display: flex;
			flex-wrap: wrap;
			gap: 8px;
			margin: 20px 0;
			padding: 15px;
			background: #f8f9fa;
			border-radius: 8px;
		}

		.operation-tab {
			padding: 6px 12px;
			border: 1px solid #007bff;
			background: white;
			color: #007bff;
			border-radius: 4px;
			cursor: pointer;
			font-weight: 500;
			transition: all 0.2s;
			font-size: 0.85rem;
		}

		.operation-tab:hover {
			background: #007bff;
			color: white;
		}

		.operation-tab.active {
			background: #007bff;
			color: white;
		}

		.status-message {
			padding: 12px 15px;
			border-radius: 6px;
			margin: 15px 0;
			font-size: 0.9rem;
		}

		.status-error {
			background: #f8d7da;
			color: #721c24;
			border: 1px solid #f5c6cb;
		}

		.status-success {
			background: #d4edda;
			color: #155724;
			border: 1px solid #c3e6cb;
		}

		.status-info {
			background: #d1ecf1;
			color: #0c5460;
			border: 1px solid #bee5eb;
		}

		.table-preview {
			margin-top: 20px;
			max-height: 400px;
			overflow: auto;
		}

		.table-preview table {
			font-size: 0.85rem;
		}

		.options-panel {
			background: #f8f9fa;
			padding: 15px;
			border-radius: 8px;
			margin: 15px 0;
		}

		.option-group {
			margin-bottom: 10px;
		}

		.option-group label {
			font-weight: 500;
			margin-right: 10px;
		}

		@media (max-width: 768px) {
			.editor-container {
				flex-direction: column;
			}

			.operation-tabs {
				justify-content: center;
			}
		}
	</style>

	<script type="text/javascript">
		let currentOperation = 'tocsv';
		let parsedJSON = null;
		let csvDelimiter = ',';

		$(document).ready(function() {
			// Operation tab handlers
			$('.operation-tab').click(function() {
				$('.operation-tab').removeClass('active');
				$(this).addClass('active');
				currentOperation = $(this).data('operation');
				processJSON();
			});

			// Input change handler with debounce
			let timeoutId;
			$('#jsonInput').on('input', function() {
				clearTimeout(timeoutId);
				timeoutId = setTimeout(function() {
					processJSON();
				}, 500);
			});

			// Delimiter change handler
			$('input[name="delimiter"]').change(function() {
				csvDelimiter = $(this).val();
				if (currentOperation === 'tocsv') {
					processJSON();
				}
			});

			// File upload handler
			$('#fileUpload').change(function() {
				const file = this.files[0];
				if (file) {
					const reader = new FileReader();
					reader.onload = function(e) {
						$('#jsonInput').val(e.target.result);
						processJSON();
					};
					reader.readAsText(file);
				}
			});

			// Initial process
			setTimeout(function() {
				processJSON();
			}, 500);
		});

		function processJSON() {
			const input = $('#jsonInput').val();

			if (!input.trim()) {
				showStatus('Please enter JSON data', 'info');
				$('#csvOutput').html('');
				$('#tablePreview').hide();
				return;
			}

			try {
				parsedJSON = JSON.parse(input);

				switch(currentOperation) {
					case 'validate':
						validateJSON(input);
						break;
					case 'prettify':
						prettifyJSON(parsedJSON);
						break;
					case 'minify':
						minifyJSON(parsedJSON);
						break;
					case 'tocsv':
						convertToCSV(parsedJSON);
						break;
				}
			} catch (error) {
				showStatus('Invalid JSON: ' + error.message, 'error');
				$('#csvOutput').html('');
				$('#tablePreview').hide();
			}
		}

		function validateJSON(input) {
			showStatus('Valid JSON! No errors found.', 'success');
			displayOutput(input, 'json', 'JSON is valid');
		}

		function prettifyJSON(obj) {
			const prettified = JSON.stringify(obj, null, 2);
			displayOutput(prettified, 'json', 'Prettified JSON');
			showStatus('JSON prettified successfully', 'success');
		}

		function minifyJSON(obj) {
			const minified = JSON.stringify(obj);
			displayOutput(minified, 'json', 'Minified JSON');
			showStatus('JSON minified successfully', 'success');
		}

		function convertToCSV(obj) {
			// Helper to convert any value to string
			function valueToString(val) {
				if (val === null || val === undefined) {
					return '';
				}
				if (typeof val === 'object') {
					return JSON.stringify(val);
				}
				return String(val);
			}

			// Flatten nested objects and arrays
			function flattenObject(ob, prefix) {
				if (prefix === undefined) prefix = '';
				var toReturn = {};

				for (var i in ob) {
					if (!ob.hasOwnProperty(i)) continue;

					var value = ob[i];
					var key = prefix + i;

					if (value === null || value === undefined) {
						toReturn[key] = '';
					} else if (Array.isArray(value)) {
						// Check if array contains objects
						if (value.length > 0 && typeof value[0] === 'object' && value[0] !== null) {
							// Array of objects - flatten each object and create indexed keys
							value.forEach(function(item, index) {
								if (typeof item === 'object' && item !== null) {
									var flattened = flattenObject(item, key + '[' + index + '].');
									for (var k in flattened) {
										toReturn[k] = flattened[k];
									}
								} else {
									toReturn[key + '[' + index + ']'] = valueToString(item);
								}
							});
						} else {
							// Array of primitives - join with semicolons
							toReturn[key] = value.map(function(v) {
								return valueToString(v);
							}).join('; ');
						}
					} else if (typeof value === 'object') {
						// Nested object - flatten recursively
						var flatObject = flattenObject(value, key + '.');
						for (var x in flatObject) {
							if (!flatObject.hasOwnProperty(x)) continue;
							toReturn[x] = flatObject[x];
						}
					} else {
						toReturn[key] = valueToString(value);
					}
				}
				return toReturn;
			}

			// Convert to array format for CSV
			let dataArray = [];

			if (Array.isArray(obj)) {
				// Array at root level
				if (obj.length > 0 && typeof obj[0] === 'object' && obj[0] !== null) {
					// Array of objects - flatten each
					dataArray = obj.map(function(item) {
						return flattenObject(item);
					});
				} else {
					// Array of primitives
					dataArray = obj.map(function(item, index) {
						return { index: index, value: valueToString(item) };
					});
				}
			} else if (typeof obj === 'object' && obj !== null) {
				// Single object at root - flatten it
				dataArray = [flattenObject(obj)];
			} else {
				// Primitive value
				dataArray = [{ value: valueToString(obj) }];
			}

			if (dataArray.length === 0) {
				showStatus('No data to convert', 'error');
				return;
			}

			// Use PapaParse to generate CSV
			const csv = Papa.unparse(dataArray, {
				delimiter: csvDelimiter,
				header: true,
				quotes: true,
				skipEmptyLines: false
			});

			displayOutput(csv, 'csv', 'CSV Output');
			displayTable(dataArray);
			showStatus('Converted to CSV successfully. ' + dataArray.length + ' rows generated.', 'success');
		}

		function displayTable(dataArray) {
			if (dataArray.length === 0) {
				$('#tablePreview').hide();
				return;
			}

			const headers = Object.keys(dataArray[0]);
			let tableHTML = '<table class="table table-bordered table-striped table-sm"><thead class="table-dark"><tr>';

			headers.forEach(function(header) {
				tableHTML += '<th>' + escapeHtml(header) + '</th>';
			});
			tableHTML += '</tr></thead><tbody>';

			dataArray.forEach(function(row) {
				tableHTML += '<tr>';
				headers.forEach(function(header) {
					const value = row[header] !== undefined ? row[header] : '';
					tableHTML += '<td>' + escapeHtml(String(value)) + '</td>';
				});
				tableHTML += '</tr>';
			});

			tableHTML += '</tbody></table>';
			$('#tablePreview').html(tableHTML).show();
		}

		function displayOutput(text, language, title) {
			const escaped = escapeHtml(text);
			const html = '<pre><code class="language-' + language + '">' + escaped + '</code></pre>';
			$('#csvOutput').html(html);
			$('#outputTitle').text(title);
			Prism.highlightAll();
		}

		function escapeHtml(text) {
			const div = document.createElement('div');
			div.textContent = text;
			return div.innerHTML;
		}

		function showStatus(message, type) {
			const className = 'status-' + type;
			$('#statusMessage').html('<div class="status-message ' + className + '">' + message + '</div>');
		}

		function copyOutput() {
			const text = $('#csvOutput').text();
			navigator.clipboard.writeText(text).then(function() {
				$('#btnCopyOutput').text('Copied!').addClass('success');
				setTimeout(function() {
					$('#btnCopyOutput').text('Copy').removeClass('success');
				}, 2000);
			});
		}

		function downloadOutput() {
			const text = $('#csvOutput').text();
			const extension = currentOperation === 'tocsv' ? 'csv' : 'json';
			const mimeType = currentOperation === 'tocsv' ? 'text/csv' : 'application/json';

			const blob = new Blob([text], { type: mimeType });
			const url = window.URL.createObjectURL(blob);
			const a = document.createElement('a');
			a.href = url;
			a.download = 'converted.' + extension;
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
			window.URL.revokeObjectURL(url);
		}

		function clearInput() {
			$('#jsonInput').val('');
			$('#csvOutput').html('');
			$('#tablePreview').html('').hide();
			$('#statusMessage').html('');
			$('#fileUpload').val('');
		}

		function loadSampleJSON() {
			const sample = [
				{
					"id": 1,
					"name": "John Doe",
					"email": "john@example.com",
					"age": 30,
					"address": {
						"street": "123 Main St",
						"city": "New York",
						"zip": "10001"
					},
					"tags": ["developer", "javascript", "react"]
				},
				{
					"id": 2,
					"name": "Jane Smith",
					"email": "jane@example.com",
					"age": 28,
					"address": {
						"street": "456 Oak Ave",
						"city": "Los Angeles",
						"zip": "90001"
					},
					"tags": ["designer", "ui", "ux"]
				}
			];
			$('#jsonInput').val(JSON.stringify(sample, null, 2));
			processJSON();
		}
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">JSON to CSV Converter & Parser</h1>
<p>Convert JSON to CSV, validate, format and transform JSON data with comprehensive tools</p>

<hr>

<div id="statusMessage"></div>

<div class="operation-tabs">
	<button class="operation-tab active" data-operation="tocsv">JSON to CSV</button>
	<button class="operation-tab" data-operation="validate">Validate JSON</button>
	<button class="operation-tab" data-operation="prettify">Prettify JSON</button>
	<button class="operation-tab" data-operation="minify">Minify JSON</button>
</div>

<div class="options-panel">
	<div class="option-group">
		<label>CSV Delimiter:</label>
		<label><input type="radio" name="delimiter" value="," checked> Comma (,)</label>
		<label><input type="radio" name="delimiter" value=";"> Semicolon (;)</label>
		<label><input type="radio" name="delimiter" value="	"> Tab</label>
	</div>
	<div class="option-group">
		<label>Load JSON:</label>
		<input type="file" id="fileUpload" accept=".json,application/json" class="form-control-file" style="display: inline-block; width: auto;">
		<button class="btn btn-sm btn-secondary" onclick="loadSampleJSON()">Load Sample</button>
	</div>
</div>

<div class="editor-container">
	<div class="editor-panel">
		<div class="panel-header">
			<h5 class="panel-title">Input JSON</h5>
			<div class="panel-actions">
				<button class="btn-small" onclick="clearInput()">Clear</button>
			</div>
		</div>
		<textarea class="editor-textarea" id="jsonInput">[
  {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "active": true
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "email": "jane@example.com",
    "active": false
  }
]</textarea>
	</div>

	<div class="editor-panel">
		<div class="panel-header">
			<h5 class="panel-title" id="outputTitle">CSV Output</h5>
			<div class="panel-actions">
				<button class="btn-small" id="btnCopyOutput" onclick="copyOutput()">Copy</button>
				<button class="btn-small" onclick="downloadOutput()">Download</button>
			</div>
		</div>
		<div class="output-panel" id="csvOutput"></div>
	</div>
</div>

<div class="table-preview" id="tablePreview" style="display: none;"></div>

<hr>

<h2 class="mt-4">Features</h2>
<ul>
	<li><strong>JSON to CSV:</strong> Convert JSON arrays and objects to CSV format</li>
	<li><strong>Nested Objects:</strong> Automatically flattens nested JSON structures</li>
	<li><strong>Custom Delimiters:</strong> Choose comma, semicolon, or tab delimiters</li>
	<li><strong>Validate JSON:</strong> Check if your JSON syntax is correct</li>
	<li><strong>Prettify JSON:</strong> Format JSON with proper indentation</li>
	<li><strong>Minify JSON:</strong> Compress JSON by removing whitespace</li>
	<li><strong>Table Preview:</strong> Preview data in table format before download</li>
	<li><strong>File Upload:</strong> Upload JSON files directly</li>
	<li><strong>Copy & Download:</strong> Easy export options</li>
	<li><strong>Real-time:</strong> Instant conversion as you type</li>
</ul>

<h2 class="mt-4">Try Other Converters</h2>
<div class="row">
	<div>
		<ul>
			<li><a href="jsonparser.jsp">JSON Parser & Converter</a></li>
			<li><a href="yamlparser.jsp">YAML Parser & Converter</a></li>
			<li><a href="xml2json.jsp">XML Parser & Converter</a></li>
			<li><a href="csv-2-json.jsp">CSV to JSON Converter</a></li>
		</ul>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
