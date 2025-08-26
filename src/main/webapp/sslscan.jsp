<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*,java.util.*,com.google.gson.*"%>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality"%>
<!DOCTYPE html>
<html>
<head>
	<title>SSL Scanner Tool - SSL/TLS Security Scanner</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="ssl scanner, tls scanner, ssl checker, certificate scanner, security scanner, ssl test, tls test" />
	<meta name="description" content="Online SSL/TLS scanner tool to check SSL certificates, security protocols, cipher suites, and vulnerabilities for any domain." />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>
	
	<!-- jsPDF library for PDF generation -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.29/jspdf.plugin.autotable.min.js"></script>

	<script type="text/javascript">
		var eventSource = null;
		var scanInProgress = false;
		var currentScanData = null; // Store the current scan data for PDF generation

		$(document).ready(function() {
			$('#sslScanForm').submit(function(event) {
				event.preventDefault();
				
				var domain = $('#domain').val().trim();
				if (!domain) {
					alert('Please enter a domain name');
            return;
        }

				startScan(domain);
			});

			function startScan(domain) {
				$('#startBtn').hide();
				$('#stopBtn').show();
				$('#progress').show();
				$('#status').show();
				$('#output').empty();
				$('#error').hide();
				$('#resultsContainer').hide();
				$('#downloadBtn').hide();
				$('#resultsSummary').empty();
				$('#certDetails').empty();
				$('#securityDetails').empty();
				$('#testResultsBody').empty();
				$('#vulnList').empty();
				$('#rawOutput').empty();
				currentScanData = null; // Reset scan data

        scanInProgress = true;

				var scanType = $('#scanType').val();
				var url = window.location.origin + '<%=request.getContextPath()%>' + '/SSLScannerFunctionality?domain=' + encodeURIComponent(domain) + '&scanType=' + encodeURIComponent(scanType);

        eventSource = new EventSource(url);

        eventSource.onmessage = function(event) {
            handleSSEMessage(event.data);
        };

        eventSource.addEventListener('scan_started', function(event) {
            updateStatus('info', event.data);
            updateProgress(10);
        });

        eventSource.addEventListener('test_started', function(event) {
            addOutput('🧪 ' + event.data);
            updateProgress(20);
        });

        eventSource.addEventListener('test_completed', function(event) {
            addOutput('✅ ' + event.data);
            updateProgress(40);
        });

        eventSource.addEventListener('test_failed', function(event) {
            addOutput('❌ ' + event.data);
            updateProgress(60);
        });

        eventSource.addEventListener('progress', function(event) {
					var m = event.data.match(/(\d+)%/);
					if (m) {
						var p = parseInt(m[1]);
						updateProgress(40 + (p * 0.5));
					}
        });

        eventSource.addEventListener('fallback_started', function(event) {
            addOutput('🚀 ' + event.data);
            updateProgress(70);
        });

				eventSource.addEventListener('fallback_result', function(event) {
					// Attempt to parse JSON result and render structured view
					var obj = tryParseJSON(event.data);
					if (obj) {
						currentScanData = obj; // Store for PDF generation
						renderScanResult(obj);
					} else {
						addOutput(event.data);
					}
				});

        eventSource.addEventListener('fallback_completed', function(event) {
            addOutput('✅ ' + event.data);
            updateProgress(100);
        });

        eventSource.addEventListener('scan_completed', function(event) {
            addOutput('🎯 ' + event.data);
            updateStatus('success', 'Scan completed successfully!');
					$('#downloadBtn').show(); // Show download button when scan completes
            stopScan();
        });

        eventSource.addEventListener('scan_error', function(event) {
            addOutput('💥 ' + event.data);
            updateStatus('error', 'Scan failed with error');
            stopScan();
        });

        eventSource.onerror = function(event) {
            addOutput('💥 Connection error');
            updateStatus('error', 'Connection lost');
            stopScan();
        };
    }

			$('#stopBtn').click(function() {
				stopScan();
			});

			$('#downloadBtn').click(function() {
				if (currentScanData) {
					generatePDFReport();
				} else {
					alert('No scan data available for download');
				}
			});

    function stopScan() {
        if (eventSource) {
            eventSource.close();
            eventSource = null;
        }
        scanInProgress = false;
				$('#startBtn').show();
				$('#stopBtn').hide();
        updateProgress(0);
    }

			function handleSSEMessage(data) { addOutput(data); }

    function addOutput(message) {
				var output = $('#output');
				var timestamp = new Date().toLocaleTimeString();
				output.append('<div>[<strong>' + timestamp + '</strong>] ' + $('<div/>').text(message).html() + '</div>');
				output.scrollTop(output[0].scrollHeight);
    }

    function updateStatus(type, message) {
				var status = $('#status');
				status.removeClass().addClass('alert alert-' + (type === 'info' ? 'info' : type === 'success' ? 'success' : 'danger'));
				status.text(message);
			}

			function updateProgress(percent) { $('#progressBar').css('width', percent + '%'); }

			function tryParseJSON(s) {
				try { return JSON.parse(s); } catch(e) { return null; }
			}

			function renderScanResult(data) {
				// Summary
				var summaryHtml = '';
				summaryHtml += '<p><strong>Domain:</strong> ' + (data.domain || 'N/A') + '</p>';
				summaryHtml += '<p><strong>Port:</strong> ' + (data.port || 'N/A') + '</p>';
				summaryHtml += '<p><strong>Scan Type:</strong> ' + (data.scan_type || 'N/A') + '</p>';
				summaryHtml += '<p><strong>Status:</strong> ' + (data.status || 'N/A') + '</p>';
				summaryHtml += '<p><strong>Scan Time:</strong> ' + (data.scan_time_seconds || '0') + ' seconds</p>';
				$('#resultsSummary').html(summaryHtml);

				// Certificate
				if (data.certificate) {
					var c = data.certificate;
					var certHtml = '';
					certHtml += '<p><strong>Subject:</strong> ' + (c.subject || 'N/A') + '</p>';
					certHtml += '<p><strong>Issuer:</strong> ' + (c.issuer || 'N/A') + '</p>';
					certHtml += '<p><strong>Valid From:</strong> ' + (c.valid_from || 'N/A') + '</p>';
					certHtml += '<p><strong>Valid Until:</strong> ' + (c.valid_until || c.valid_to || 'N/A') + '</p>';
					certHtml += '<p><strong>Serial Number:</strong> ' + (c.serial_number || 'N/A') + '</p>';
					certHtml += '<p><strong>Signature Algorithm:</strong> ' + (c.signature_algorithm || 'N/A') + '</p>';
					certHtml += '<p><strong>Public Key:</strong> ' + (c.public_key_algorithm || 'N/A') + ' ' + (c.public_key_size ? '(' + c.public_key_size + ' bits)' : '') + '</p>';
					if (c.subject_alt_names && c.subject_alt_names.length) {
						certHtml += '<p><strong>SAN:</strong> ' + c.subject_alt_names.map(function(x){return '<span class="badge badge-info mr-1">'+x+'</span>';}).join(' ') + '</p>';
					}
					$('#certDetails').html(certHtml);
				}

				// Security
				if (data.security) {
					var s = data.security;
					var secHtml = '';
					if (s.tls_versions && s.tls_versions.length) {
						secHtml += '<p><strong>TLS Versions:</strong> ' + s.tls_versions.join(', ') + '</p>';
					}
					if (s.supported_ciphers) {
						secHtml += '<div class="mt-2"><strong>Supported Ciphers</strong><pre class="mb-0">' + (Array.isArray(s.supported_ciphers) ? s.supported_ciphers.join('\n') : s.supported_ciphers) + '</pre></div>';
					}
					if (s.weak_ciphers && s.weak_ciphers.length) {
						secHtml += '<div class="mt-2"><strong>Weak Ciphers</strong><pre class="mb-0">' + s.weak_ciphers.join('\n') + '</pre></div>';
					}
					secHtml += '<p class="mt-2"><strong>Heartbleed:</strong> ' + (s.heartbleed_vulnerable ? '<span class="badge badge-danger">Vulnerable</span>' : '<span class="badge badge-success">Not Vulnerable</span>') + '</p>';
					secHtml += '<p><strong>BEAST:</strong> ' + (s.beast_vulnerable ? '<span class="badge badge-danger">Vulnerable</span>' : '<span class="badge badge-success">Not Vulnerable</span>') + '</p>';
					secHtml += '<p><strong>POODLE:</strong> ' + (s.poodle_vulnerable ? '<span class="badge badge-danger">Vulnerable</span>' : '<span class="badge badge-success">Not Vulnerable</span>') + '</p>';
					secHtml += '<p><strong>Certificate Transparency:</strong> ' + (s.certificate_transparency ? 'Yes' : 'No') + '</p>';
					$('#securityDetails').html(secHtml);
				}

				// Full scan extras
				if (data.scan_type === 'full') {
					if (data.test_results && data.test_results.length) {
						var rows = '';
						for (var i=0;i<data.test_results.length;i++) {
							var t = data.test_results[i];
							rows += '<tr>'+
								'<td>'+ (t.test_name || '') +'</td>'+
								'<td>'+ (t.status || '') +'</td>'+
								'<td>'+ (t.result || t.error || '') +'</td>'+
								'<td>'+ (t.duration_seconds || '') +'</td>'+
							'</tr>';
						}
						$('#testResultsBody').html(rows);
						$('#testResultsCard').show();
					} else {
						$('#testResultsCard').hide();
					}

					if (data.vulnerabilities && data.vulnerabilities.length) {
						var vhtml = '';
						for (var j=0;j<data.vulnerabilities.length;j++) {
							var v = data.vulnerabilities[j];
							vhtml += '<li><strong>'+ (v.name || '') +'</strong> - '+ (v.severity || '') +' - '+ (v.description || '') +'</li>';
						}
						$('#vulnList').html(vhtml);
						$('#vulnCard').show();
					} else {
						$('#vulnCard').hide();
					}

					if (data.raw_output) {
						$('#rawOutput').text(data.raw_output);
						$('#rawOutputCard').show();
					} else {
						$('#rawOutputCard').hide();
					}
				}

				$('#resultsContainer').show();
			}

			function generatePDFReport() {
				if (!currentScanData) return;

				const { jsPDF } = window.jspdf;
				const doc = new jsPDF();
				const data = currentScanData;
				const toolUrl = window.location.origin + '<%=request.getContextPath()%>' + '/sslscan.jsp';
				
				// Set document properties
				doc.setProperties({
					title: 'SSL Security Scan Report - ' + data.domain,
					subject: 'SSL/TLS Security Assessment',
					author: 'SSL Scanner Tool',
					creator: 'SSL Scanner Tool'
				});

				let yPos = 20;
				const pageWidth = doc.internal.pageSize.width;
				const margin = 20;
				const contentWidth = pageWidth - (2 * margin);

				// Title
				doc.setFontSize(20);
				doc.setFont('helvetica', 'bold');
				doc.text('SSL Security Scan Report', pageWidth / 2, yPos, { align: 'center' });
				yPos += 8;
				// Tool link
				doc.setFontSize(9);
				doc.setFont('helvetica', 'italic');
				doc.text('Generated by: ' + toolUrl, pageWidth / 2, yPos, { align: 'center', maxWidth: contentWidth });
				yPos += 12;

				// Scan Information
				doc.setFontSize(14);
				doc.setFont('helvetica', 'bold');
				doc.text('Scan Information', margin, yPos);
				yPos += 10;

				doc.setFontSize(10);
				doc.setFont('helvetica', 'normal');
				doc.text('Domain: ' + (data.domain || 'N/A'), margin, yPos);
				yPos += 7;
				doc.text('Port: ' + (data.port || 'N/A'), margin, yPos);
				yPos += 7;
				doc.text('Scan Type: ' + (data.scan_type || 'N/A'), margin, yPos);
				yPos += 7;
				doc.text('Status: ' + (data.status || 'N/A'), margin, yPos);
				yPos += 7;
				doc.text('Scan Time: ' + (data.scan_time_seconds || '0') + ' seconds', margin, yPos);
				yPos += 15;

				// Certificate Information
				if (data.certificate) {
					doc.setFontSize(14);
					doc.setFont('helvetica', 'bold');
					doc.text('Certificate Information', margin, yPos);
					yPos += 10;

					doc.setFontSize(10);
					doc.setFont('helvetica', 'normal');
					const cert = data.certificate;
					
					doc.text('Subject: ' + (cert.subject || 'N/A'), margin, yPos);
					yPos += 7;
					doc.text('Issuer: ' + (cert.issuer || 'N/A'), margin, yPos);
					yPos += 7;
					doc.text('Valid From: ' + (cert.valid_from || 'N/A'), margin, yPos);
					yPos += 7;
					doc.text('Valid Until: ' + (cert.valid_until || cert.valid_to || 'N/A'), margin, yPos);
					yPos += 7;
					doc.text('Serial Number: ' + (cert.serial_number || 'N/A'), margin, yPos);
					yPos += 7;
					doc.text('Signature Algorithm: ' + (cert.signature_algorithm || 'N/A'), margin, yPos);
					yPos += 7;
					doc.text('Public Key: ' + (cert.public_key_algorithm || 'N/A') + ' ' + (cert.public_key_size ? '(' + cert.public_key_size + ' bits)' : ''), margin, yPos);
					yPos += 15;

					if (cert.subject_alt_names && cert.subject_alt_names.length) {
						doc.text('Subject Alternative Names:', margin, yPos);
						yPos += 7;
						cert.subject_alt_names.forEach(san => {
							doc.text('  • ' + san, margin + 5, yPos);
							yPos += 7;
						});
						yPos += 5;
					}
				}

				// Security Information
				if (data.security) {
					doc.setFontSize(14);
					doc.setFont('helvetica', 'bold');
					doc.text('Security Assessment', margin, yPos);
					yPos += 10;

					doc.setFontSize(10);
					doc.setFont('helvetica', 'normal');
					const sec = data.security;

					if (sec.tls_versions && sec.tls_versions.length) {
						doc.text('TLS Versions: ' + sec.tls_versions.join(', '), margin, yPos);
						yPos += 7;
					}

					// Vulnerability status
					doc.text('Heartbleed: ' + (sec.heartbleed_vulnerable ? 'VULNERABLE' : 'Not Vulnerable'), margin, yPos);
					yPos += 7;
					doc.text('BEAST: ' + (sec.beast_vulnerable ? 'VULNERABLE' : 'Not Vulnerable'), margin, yPos);
					yPos += 7;
					doc.text('POODLE: ' + (sec.poodle_vulnerable ? 'VULNERABLE' : 'Not Vulnerable'), margin, yPos);
					yPos += 7;
					doc.text('Certificate Transparency: ' + (sec.certificate_transparency ? 'Yes' : 'No'), margin, yPos);
					yPos += 15;

					// Ciphers
					if (sec.supported_ciphers) {
						doc.text('Supported Ciphers:', margin, yPos);
						yPos += 7;
						
						const ciphers = Array.isArray(sec.supported_ciphers) ? sec.supported_ciphers : [sec.supported_ciphers];
						ciphers.forEach(cipher => {
							if (yPos > 250) {
								doc.addPage();
								yPos = 20;
							}
							doc.text('  • ' + cipher, margin + 5, yPos);
							yPos += 7;
						});
						yPos += 5;
					}

					if (sec.weak_ciphers && sec.weak_ciphers.length) {
						doc.text('Weak Ciphers:', margin, yPos);
						yPos += 7;
						sec.weak_ciphers.forEach(cipher => {
							if (yPos > 250) {
								doc.addPage();
								yPos = 20;
							}
							doc.text('  • ' + cipher, margin + 5, yPos);
							yPos += 7;
						});
						yPos += 5;
					}
				}

				// Full scan test results
				if (data.scan_type === 'full' && data.test_results && data.test_results.length) {
					if (yPos > 200) {
						doc.addPage();
						yPos = 20;
					}

					doc.setFontSize(14);
					doc.setFont('helvetica', 'bold');
					doc.text('Test Results', margin, yPos);
					yPos += 15;

					// Create test results table
					const testData = data.test_results.map(test => [
						test.test_name || '',
						test.status || '',
						test.result || test.error || '',
						test.duration_seconds || ''
					]);

					doc.autoTable({
						startY: yPos,
						head: [['Test Name', 'Status', 'Result/Error', 'Duration (s)']],
						body: testData,
						margin: { left: margin },
						styles: { fontSize: 8 },
						headStyles: { fillColor: [66, 139, 202] }
					});

					yPos = doc.lastAutoTable.finalY + 10;
				}

				// Vulnerabilities
				if (data.vulnerabilities && data.vulnerabilities.length) {
					if (yPos > 200) {
						doc.addPage();
						yPos = 20;
					}

					doc.setFontSize(14);
					doc.setFont('helvetica', 'bold');
					doc.text('Vulnerabilities Found', margin, yPos);
					yPos += 10;

					doc.setFontSize(10);
					doc.setFont('helvetica', 'normal');
					data.vulnerabilities.forEach(vuln => {
						if (yPos > 250) {
							doc.addPage();
							yPos = 20;
						}
						doc.text('• ' + (vuln.name || '') + ' - ' + (vuln.severity || '') + ' - ' + (vuln.description || ''), margin, yPos);
						yPos += 7;
					});
				}

				// Footer
				const pageCount = doc.internal.getNumberOfPages();
				for (let i = 1; i <= pageCount; i++) {
					doc.setPage(i);
					doc.setFontSize(8);
					doc.setFont('helvetica', 'italic');
					doc.text('Generated on: ' + new Date().toLocaleString(), margin, doc.internal.pageSize.height - 10);
					doc.text('Tool: ' + toolUrl, margin, doc.internal.pageSize.height - 4, { maxWidth: contentWidth - 60 });
					doc.text('Page ' + i + ' of ' + pageCount, pageWidth - margin - 30, doc.internal.pageSize.height - 10);
				}

				// Save the PDF
				const filename = 'SSL_Scan_Report_' + (data.domain || 'unknown') + '_' + new Date().toISOString().slice(0, 10) + '.pdf';
				doc.save(filename);
			}
		});
</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">SSL Scanner Tool</h1>
<hr>

<form id="sslScanForm" class="form-horizontal" method="POST">
	<div class="form-group">
		<label for="domain"><strong>Domain Name:</strong></label>
		<div class="input-group">
			<input type="text" class="form-control" id="domain" name="domain" 
				   placeholder="e.g., example.com, google.com, github.com" required>
			<div class="input-group-append">
				<button type="submit" class="btn btn-primary" id="startBtn">Start SSL Scan</button>
				<button type="button" class="btn btn-danger" id="stopBtn" style="display:none;">Stop Scan</button>
			</div>
		</div>
		<small class="form-text text-muted">Enter a domain name without protocol (http/https)</small>
	</div>

	<div class="form-group">
		<label for="scanType"><strong>Scan Type:</strong></label>
		<select class="form-control" id="scanType" name="scanType">
			<option value="quick">Quick</option>
			<option value="basic" selected>Basic</option>
			<option value="full">Full</option>
		</select>
		<small class="form-text text-muted">Quick: fastest. Basic: detailed. Full: exhaustive tests.</small>
	</div>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display: none;"></div>

<div id="progress" style="display: none;">
	<div class="progress mb-3">
		<div class="progress-bar" id="progressBar" role="progressbar" style="width: 0%"></div>
	</div>
</div>

<div id="status" class="alert alert-info" style="display: none;"></div>

<div class="card mb-3">
	<div class="card-header"><h5 class="mb-0">Live Output</h5></div>
	<div class="card-body">
		<div id="output" style="max-height: 300px; overflow-y: auto; font-family: monospace; font-size: 0.9em;"></div>
	</div>
</div>

<div id="resultsContainer" style="display:none;">
	<div class="row mb-3">
		<div class="col-12">
			<button type="button" class="btn btn-success" id="downloadBtn" style="display:none;">
				📄 Download PDF Report
			</button>
		</div>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="card mb-3">
				<div class="card-header"><h6 class="mb-0">Summary</h6></div>
				<div class="card-body" id="resultsSummary"></div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="card mb-3">
				<div class="card-header"><h6 class="mb-0">Certificate</h6></div>
				<div class="card-body" id="certDetails"></div>
			</div>
		</div>
	</div>

	<div class="card mb-3">
		<div class="card-header"><h6 class="mb-0">Security</h6></div>
		<div class="card-body" id="securityDetails"></div>
	</div>

	<div class="card mb-3" id="testResultsCard" style="display:none;">
		<div class="card-header"><h6 class="mb-0">Full Scan - Test Results</h6></div>
		<div class="card-body">
			<div class="table-responsive">
				<table class="table table-bordered table-striped">
					<thead class="thead-dark">
						<tr>
							<th>Test Name</th>
							<th>Status</th>
							<th>Result / Error</th>
							<th>Duration (s)</th>
						</tr>
					</thead>
					<tbody id="testResultsBody"></tbody>
				</table>
			</div>
		</div>
	</div>

	<div class="card mb-3" id="vulnCard" style="display:none;">
		<div class="card-header"><h6 class="mb-0">Vulnerabilities</h6></div>
		<div class="card-body">
			<ul id="vulnList" class="mb-0"></ul>
		</div>
	</div>

	<div class="card mb-3" id="rawOutputCard" style="display:none;">
		<div class="card-header"><h6 class="mb-0">Raw Output</h6></div>
		<div class="card-body"><pre id="rawOutput" class="mb-0"></pre></div>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="sslscanning">SSL/TLS Scanning</h2>

<p><strong>SSL/TLS scanning</strong> provides certificate details, protocol support, cipher information, and vulnerability indicators. Full scan includes per-test results and raw tool output.</p>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>