<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<!-- JSON-LD markup for SEO -->
	<script type="application/ld+json">
{
  "@context" : "https://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Free Online YAML Parser, Validator & Converter Tool",
  "description" : "Free online YAML parser and converter. Validate YAML syntax, convert YAML to JSON, XML, CSV, TOML. Format, minify, prettify YAML files. Compare YAML documents with diff tool. Base64 encode/decode YAML online.",
  "image" : "https://8gwifi.org/images/site/yamlparser.png",
  "url" : "https://8gwifi.org/yamlparser.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-12-12",
  "dateModified" : "2025-01-26",
  "applicationCategory" : [
    "yaml parser",
    "yaml validator",
    "yaml to json converter",
    "yaml to xml converter",
    "yaml formatter",
    "yaml beautifier",
    "yaml minifier",
    "yaml editor online",
    "yaml lint",
    "yaml checker",
    "yaml to csv converter",
    "yaml to toml converter",
    "yaml syntax validator",
    "yaml file converter",
    "kubernetes yaml validator",
    "docker compose yaml validator",
    "ansible yaml validator",
    "yaml comparison tool",
    "yaml diff tool"
  ],
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "downloadUrl" : "https://8gwifi.org/yamlparser.jsp",
  "operatingSystem" : "Windows, macOS, Linux, Unix, Android, iOS, Web Browser",
  "requirements" : "Web Browser with JavaScript enabled",
  "softwareVersion" : "v2.0",
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "2500"
  },
  "featureList": [
    "YAML syntax validation",
    "YAML to JSON conversion",
    "YAML to XML conversion",
    "YAML to CSV conversion",
    "YAML to TOML conversion",
    "YAML formatting and prettifying",
    "YAML minification",
    "YAML syntax highlighting",
    "Base64 encoding and decoding",
    "YAML diff and comparison",
    "Random YAML generation",
    "Kubernetes YAML validation",
    "Docker Compose validation",
    "No installation required",
    "100% client-side processing",
    "Free and secure"
  ]
}
</script>
	<title>Free YAML Parser, Validator & Converter Online | YAML to JSON, XML, CSV, TOML</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="yaml parser, yaml validator, yaml to json, yaml to xml, yaml to csv, yaml formatter, yaml beautifier, yaml minifier, online yaml editor, yaml lint, yaml checker, yaml syntax validator, kubernetes yaml validator, docker compose yaml, ansible yaml, yaml diff, yaml comparison, yaml converter online, prettify yaml, format yaml, yaml to toml, validate yaml online, yaml file converter, free yaml tool"/>
	<meta name="description" content="Free online YAML parser and converter tool. Validate YAML syntax, convert YAML to JSON/XML/CSV/TOML, format and beautify YAML, minify YAML files, compare YAML documents, and Base64 encode/decode. Perfect for Kubernetes, Docker Compose, and Ansible configurations. No installation required, 100% client-side processing." />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<!-- Prism.js for syntax highlighting -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-yaml.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-json.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-markup.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-toml.min.js"></script>

	<!-- js-yaml for YAML parsing -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/js-yaml/4.1.0/js-yaml.min.js"></script>

	<!-- PapaParse for CSV conversion -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.4.1/papaparse.min.js"></script>

	<!-- diff library -->
	<script src="https://cdn.jsdelivr.net/npm/diff@5.1.0/dist/diff.min.js"></script>

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
			overflow-wrap: break-word;
			word-break: break-word;
		}

		.output-panel code {
			font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
			font-size: 0.9rem;
			line-height: 1.6;
			white-space: pre-wrap;
			word-wrap: break-word;
			overflow-wrap: break-word;
			word-break: break-all;
			max-width: 100%;
			display: block;
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

		.diff-panel {
			display: none;
		}

		.diff-panel.active {
			display: block;
		}

		.diff-output {
			background: #f8f9fa;
			padding: 15px;
			border-radius: 8px;
			font-family: monospace;
			white-space: pre-wrap;
			max-height: 500px;
			overflow: auto;
		}

		.diff-added {
			background: #d4edda;
			color: #155724;
		}

		.diff-removed {
			background: #f8d7da;
			color: #721c24;
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
		let currentOperation = 'validate';
		let parsedYAML = null;

		$(document).ready(function() {
			// Check if required libraries are loaded
			setTimeout(function() {
				if (typeof jsyaml === 'undefined') {
					showStatus('Warning: YAML library not loaded. Please refresh the page.', 'error');
				}
			}, 1000);

			// Operation tab handlers
			$('.operation-tab').click(function() {
				$('.operation-tab').removeClass('active');
				$(this).addClass('active');
				currentOperation = $(this).data('operation');

				// Show/hide diff panel
				if (currentOperation === 'diff') {
					$('.diff-panel').addClass('active');
					$('.editor-panel.output').hide();
				} else {
					$('.diff-panel').removeClass('active');
					$('.editor-panel.output').show();
				}

				// Process based on operation
				processYAML();
			});

			// Input change handler
			$('#yamlInput').on('input', function() {
				if (currentOperation !== 'diff') {
					debounce(processYAML, 500)();
				}
			});

			// Initial process
			setTimeout(function() {
				processYAML();
			}, 500);
		});

		let debounceTimer;
		function debounce(func, delay) {
			return function() {
				clearTimeout(debounceTimer);
				debounceTimer = setTimeout(func, delay);
			};
		}

		function processYAML() {
			const input = $('#yamlInput').val();

			if (!input.trim() && currentOperation !== 'generate') {
				showStatus('Please enter YAML data', 'info');
				$('#yamlOutput').html('');
				return;
			}

			try {
				switch(currentOperation) {
					case 'validate':
						validateYAML(input);
						break;
					case 'prettify':
						prettifyYAML(input);
						break;
					case 'minify':
						minifyYAML(input);
						break;
					case 'highlight':
						highlightYAML(input);
						break;
					case 'json':
						convertToJSON(input);
						break;
					case 'xml':
						convertToXML(input);
						break;
					case 'csv':
						convertToCSV(input);
						break;
					case 'toml':
						convertToTOML(input);
						break;
					case 'base64encode':
						base64EncodeYAML(input);
						break;
					case 'base64decode':
						base64DecodeYAML(input);
						break;
					case 'generate':
						generateRandomYAML();
						break;
					case 'diff':
						// Handled by button click
						break;
				}
			} catch (error) {
				showStatus('Error: ' + error.message, 'error');
				$('#yamlOutput').html('');
			}
		}

		function validateYAML(input) {
			try {
				parsedYAML = jsyaml.load(input);
				showStatus('Valid YAML! No errors found.', 'success');
				displayOutput(input, 'yaml', 'YAML is valid');
			} catch (error) {
				showStatus('Invalid YAML: ' + error.message, 'error');
				$('#yamlOutput').html('');
			}
		}

		function prettifyYAML(input) {
			const obj = jsyaml.load(input);
			const prettified = jsyaml.dump(obj, {
				indent: 2,
				lineWidth: 120,
				noRefs: true
			});
			displayOutput(prettified, 'yaml', 'Prettified YAML');
			showStatus('YAML prettified successfully', 'success');
		}

		function minifyYAML(input) {
			const obj = jsyaml.load(input);
			const minified = jsyaml.dump(obj, {
				indent: 0,
				lineWidth: -1,
				flowLevel: 0
			});
			displayOutput(minified, 'yaml', 'Minified YAML');
			showStatus('YAML minified successfully', 'success');
		}

		function highlightYAML(input) {
			displayOutput(input, 'yaml', 'Highlighted YAML');
			showStatus('YAML highlighted', 'success');
		}

		function convertToJSON(input) {
			const obj = jsyaml.load(input);
			const json = JSON.stringify(obj, null, 2);
			displayOutput(json, 'json', 'JSON Output');
			showStatus('Converted to JSON successfully', 'success');
		}

		function convertToXML(input) {
			const obj = jsyaml.load(input);

			// Simple XML converter without external library
			function objectToXML(obj, indent) {
				if (indent === undefined) indent = 0;
				const spaces = '  '.repeat(indent);
				let xml = '';

				if (typeof obj !== 'object' || obj === null) {
					return escapeXml(String(obj));
				}

				if (Array.isArray(obj)) {
					obj.forEach(function(item) {
						xml += spaces + '<item>\n';
						xml += objectToXML(item, indent + 1);
						xml += '\n' + spaces + '</item>\n';
					});
				} else {
					for (const key in obj) {
						if (obj.hasOwnProperty(key)) {
							const sanitizedKey = sanitizeXmlTag(key);
							const value = obj[key];

							if (typeof value === 'object' && value !== null) {
								xml += spaces + '<' + sanitizedKey + '>\n';
								xml += objectToXML(value, indent + 1);
								xml += '\n' + spaces + '</' + sanitizedKey + '>\n';
							} else {
								xml += spaces + '<' + sanitizedKey + '>' + escapeXml(String(value)) + '</' + sanitizedKey + '>\n';
							}
						}
					}
				}

				return xml;
			}

			function escapeXml(text) {
				return text.replace(/&/g, '&amp;')
					.replace(/</g, '&lt;')
					.replace(/>/g, '&gt;')
					.replace(/"/g, '&quot;')
					.replace(/'/g, '&apos;');
			}

			const xmlContent = objectToXML(obj, 1);
			const xml = '<?xml version="1.0" encoding="UTF-8"?>\n<root>\n' + xmlContent + '</root>';
			displayOutput(xml, 'markup', 'XML Output');
			showStatus('Converted to XML successfully', 'success');
		}

		function convertToCSV(input) {
			const obj = jsyaml.load(input);

			// Flatten nested objects
			function flattenObject(ob, prefix) {
				if (prefix === undefined) prefix = '';
				var toReturn = {};

				for (var i in ob) {
					if (!ob.hasOwnProperty(i)) continue;

					if ((typeof ob[i]) == 'object' && ob[i] !== null && !Array.isArray(ob[i])) {
						var flatObject = flattenObject(ob[i], prefix + i + '.');
						for (var x in flatObject) {
							if (!flatObject.hasOwnProperty(x)) continue;
							toReturn[prefix + x] = flatObject[x];
						}
					} else if (Array.isArray(ob[i])) {
						toReturn[prefix + i] = ob[i].join('; ');
					} else {
						toReturn[prefix + i] = ob[i];
					}
				}
				return toReturn;
			}

			// Convert to array format for CSV
			let dataArray = [];
			if (Array.isArray(obj)) {
				dataArray = obj.map(function(item) {
					return flattenObject(item);
				});
			} else if (typeof obj === 'object') {
				dataArray = [flattenObject(obj)];
			} else {
				throw new Error('YAML must be an object or array for CSV conversion');
			}

			const csv = Papa.unparse(dataArray);
			displayOutput(csv, 'csv', 'CSV Output');
			showStatus('Converted to CSV successfully', 'success');
		}

		function convertToTOML(input) {
			const obj = jsyaml.load(input);
			const toml = objectToTOML(obj);
			displayOutput(toml, 'toml', 'TOML Output');
			showStatus('Converted to TOML successfully', 'success');
		}

		function objectToTOML(obj, prefix) {
			if (prefix === undefined) prefix = '';
			let toml = '';
			const simple = {};
			const complex = {};

			// Separate simple and complex values
			for (const key in obj) {
				if (obj[key] !== null && typeof obj[key] === 'object' && !Array.isArray(obj[key])) {
					complex[key] = obj[key];
				} else {
					simple[key] = obj[key];
				}
			}

			// Write simple values
			for (const key in simple) {
				const value = simple[key];
				if (Array.isArray(value)) {
					const arrayStr = '[' + value.map(function(v) { return JSON.stringify(v); }).join(', ') + ']';
					toml += key + ' = ' + arrayStr + '\n';
				} else if (typeof value === 'string') {
					toml += key + ' = "' + value + '"\n';
				} else {
					toml += key + ' = ' + value + '\n';
				}
			}

			// Write complex values as sections
			for (const key in complex) {
				const section = prefix ? prefix + '.' + key : key;
				toml += '\n[' + section + ']\n';
				toml += objectToTOML(complex[key], section);
			}

			return toml;
		}

		function base64EncodeYAML(input) {
			const encoded = btoa(unescape(encodeURIComponent(input)));
			displayOutput(encoded, 'text', 'Base64 Encoded');
			showStatus('YAML encoded to Base64', 'success');
		}

		function base64DecodeYAML(input) {
			try {
				const decoded = decodeURIComponent(escape(atob(input.trim())));
				displayOutput(decoded, 'yaml', 'Base64 Decoded YAML');
				showStatus('Base64 decoded successfully', 'success');
			} catch (error) {
				showStatus('Invalid Base64 input', 'error');
			}
		}

		function generateRandomYAML() {
			const randomData = {
				name: 'Sample User ' + Math.floor(Math.random() * 1000),
				age: Math.floor(Math.random() * 50) + 20,
				email: 'user' + Math.floor(Math.random() * 10000) + '@example.com',
				active: Math.random() > 0.5,
				roles: ['user', 'viewer'],
				metadata: {
					created: new Date().toISOString(),
					id: Math.random().toString(36).substr(2, 9),
					version: '1.0.' + Math.floor(Math.random() * 100)
				},
				tags: ['tag1', 'tag2', 'tag3']
			};

			const yaml = jsyaml.dump(randomData);
			$('#yamlInput').val(yaml);
			displayOutput(yaml, 'yaml', 'Generated Random YAML');
			showStatus('Random YAML generated', 'success');
		}

		function performDiff() {
			const yaml1 = $('#yamlInput').val();
			const yaml2 = $('#yamlInput2').val();

			if (!yaml1.trim() || !yaml2.trim()) {
				showStatus('Please enter YAML in both inputs', 'error');
				return;
			}

			const diff = Diff.diffLines(yaml1, yaml2);
			let diffHtml = '';

			diff.forEach(function(part) {
				const className = part.added ? 'diff-added' : part.removed ? 'diff-removed' : '';
				const prefix = part.added ? '+ ' : part.removed ? '- ' : '  ';
				const lines = part.value.split('\n');
				lines.forEach(function(line, idx) {
					if (idx < lines.length - 1 || line) {
						diffHtml += '<div class="' + className + '">' + prefix + escapeHtml(line) + '</div>';
					}
				});
			});

			$('#diffOutput').html(diffHtml);
			showStatus('Diff completed', 'success');
		}

		function sanitizeXmlTag(tag) {
			return String(tag).replace(/[^a-zA-Z0-9_-]/g, '_');
		}

		function displayOutput(text, language, title) {
			const escaped = escapeHtml(text);
			const html = '<pre><code class="language-' + language + '">' + escaped + '</code></pre>';
			$('#yamlOutput').html(html);
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

		function copyInput() {
			const text = $('#yamlInput').val();
			navigator.clipboard.writeText(text).then(function() {
				$('#btnCopyInput').text('Copied!').addClass('success');
				setTimeout(function() {
					$('#btnCopyInput').text('Copy').removeClass('success');
				}, 2000);
			});
		}

		function copyOutput() {
			const text = $('#yamlOutput').text();
			navigator.clipboard.writeText(text).then(function() {
				$('#btnCopyOutput').text('Copied!').addClass('success');
				setTimeout(function() {
					$('#btnCopyOutput').text('Copy').removeClass('success');
				}, 2000);
			});
		}

		function downloadOutput() {
			const text = $('#yamlOutput').text();
			const extensions = {
				'json': 'json',
				'xml': 'xml',
				'csv': 'csv',
				'toml': 'toml',
				'yaml': 'yaml',
				'text': 'txt'
			};

			let ext = 'txt';
			const outputTitle = $('#outputTitle').text().toLowerCase();
			for (const key in extensions) {
				if (outputTitle.includes(key)) {
					ext = extensions[key];
					break;
				}
			}

			const blob = new Blob([text], { type: 'text/plain' });
			const url = window.URL.createObjectURL(blob);
			const a = document.createElement('a');
			a.href = url;
			a.download = 'output.' + ext;
			document.body.appendChild(a);
			a.click();
			document.body.removeChild(a);
			window.URL.revokeObjectURL(url);
		}

		function clearInput() {
			$('#yamlInput').val('');
			$('#yamlOutput').html('');
			$('#statusMessage').html('');
		}
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">YAML Parser & Converter</h1>
<p>Validate, format, transform and compare YAML with comprehensive tools</p>

<hr>

<div id="statusMessage"></div>

<div class="operation-tabs">
	<button class="operation-tab active" data-operation="validate">Validate YAML</button>
	<button class="operation-tab" data-operation="prettify">Prettify YAML</button>
	<button class="operation-tab" data-operation="minify">Minify YAML</button>
	<button class="operation-tab" data-operation="highlight">Highlight YAML</button>
	<button class="operation-tab" data-operation="json">YAML to JSON</button>
	<button class="operation-tab" data-operation="xml">YAML to XML</button>
	<button class="operation-tab" data-operation="csv">YAML to CSV</button>
	<button class="operation-tab" data-operation="toml">YAML to TOML</button>
	<button class="operation-tab" data-operation="base64encode">Base64 Encode</button>
	<button class="operation-tab" data-operation="base64decode">Base64 Decode</button>
	<button class="operation-tab" data-operation="generate">Generate Random YAML</button>
	<button class="operation-tab" data-operation="diff">Diff Two YAML</button>
</div>

<div class="editor-container">
	<div class="editor-panel">
		<div class="panel-header">
			<h5 class="panel-title">Input YAML</h5>
			<div class="panel-actions">
				<button class="btn-small" id="btnCopyInput" onclick="copyInput()">Copy</button>
				<button class="btn-small" onclick="clearInput()">Clear</button>
			</div>
		</div>
		<textarea class="editor-textarea" id="yamlInput">apiVersion: apps/v1beta1
kind: Deployment
metadata:
  annotations:
    ABC: '123'
    XYZ: '761'
  labels: &id001
    TRT: '113'
    OIU: '981'
  name: random
  namespace: default</textarea>
	</div>

	<div class="editor-panel output">
		<div class="panel-header">
			<h5 class="panel-title" id="outputTitle">Output</h5>
			<div class="panel-actions">
				<button class="btn-small" id="btnCopyOutput" onclick="copyOutput()">Copy</button>
				<button class="btn-small" onclick="downloadOutput()">Download</button>
			</div>
		</div>
		<div class="output-panel" id="yamlOutput"></div>
	</div>
</div>

<div class="diff-panel">
	<div class="editor-container">
		<div class="editor-panel">
			<div class="panel-header">
				<h5 class="panel-title">YAML 1</h5>
			</div>
			<textarea class="editor-textarea" id="yamlInput">apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: app-v1</textarea>
		</div>

		<div class="editor-panel">
			<div class="panel-header">
				<h5 class="panel-title">YAML 2</h5>
			</div>
			<textarea class="editor-textarea" id="yamlInput2">apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-v2
  namespace: production</textarea>
		</div>
	</div>

	<div style="text-align: center; margin: 20px 0;">
		<button class="btn btn-primary btn-lg" onclick="performDiff()">Compare YAML Files</button>
	</div>

	<div class="panel-header" style="border-radius: 8px 8px 0 0;">
		<h5 class="panel-title">Diff Output</h5>
	</div>
	<div class="diff-output" id="diffOutput">Click "Compare YAML Files" to see differences</div>
</div>

<hr>

<h2 class="mt-4">Features</h2>
<ul>
	<li><strong>Validate YAML:</strong> Check if your YAML syntax is correct</li>
	<li><strong>Prettify YAML:</strong> Format YAML with proper indentation</li>
	<li><strong>Minify YAML:</strong> Compress YAML to minimal size</li>
	<li><strong>Highlight YAML:</strong> Syntax highlighting for better readability</li>
	<li><strong>YAML to JSON:</strong> Convert YAML to JSON format</li>
	<li><strong>YAML to XML:</strong> Convert YAML to XML format</li>
	<li><strong>YAML to CSV:</strong> Convert YAML arrays/objects to CSV</li>
	<li><strong>YAML to TOML:</strong> Convert YAML to TOML configuration format</li>
	<li><strong>Base64 Encode/Decode:</strong> Encode or decode YAML in Base64</li>
	<li><strong>Generate Random YAML:</strong> Create sample YAML data</li>
	<li><strong>Diff Two YAML:</strong> Compare two YAML files side-by-side</li>
</ul>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>
<%@ include file="addcomments.jsp"%>
</div>

<%@ include file="body-close.jsp"%>
