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

	<!-- Open Graph Meta Tags for Social Media -->
	<meta property="og:type" content="website" />
	<meta property="og:title" content="SSL Scanner Tool - SSL/TLS Security Scanner" />
	<meta property="og:description" content="Comprehensive online SSL/TLS scanner tool to check SSL certificates, security protocols, cipher suites, and vulnerabilities for any domain with real-time scanning and detailed reports." />
	<meta property="og:url" content="https://8gwifi.org/sslscan.jsp" />
	<meta property="og:site_name" content="8gwifi.org" />
	<meta property="og:image" content="https://8gwifi.org/images/site/ssl-scanner.png" />
	
	<!-- Twitter Card Meta Tags -->
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content="SSL Scanner Tool - SSL/TLS Security Scanner" />
	<meta name="twitter:description" content="Comprehensive online SSL/TLS scanner tool to check SSL certificates, security protocols, and vulnerabilities for any domain." />
	<meta name="twitter:image" content="https://8gwifi.org/images/site/ssl-scanner.png" />
	
	<!-- Additional SEO Meta Tags -->
	<meta name="author" content="8gwifi.org" />
	<meta name="copyright" content="8gwifi.org" />
	<meta name="coverage" content="Worldwide" />
	<meta name="distribution" content="Global" />
	<meta name="rating" content="General" />
	<meta name="revisit-after" content="7 days" />
	<meta name="target" content="all" />
	<meta name="HandheldFriendly" content="true" />
	<meta name="MobileOptimized" content="width" />
	<meta name="apple-mobile-web-app-capable" content="yes" />
	<meta name="apple-mobile-web-app-status-bar-style" content="black" />

	<%@ include file="header-script.jsp"%>
	
	<!-- JSON-LD Structured Data for SEO -->
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "WebApplication",
		"name": "SSL Scanner Tool",
		"description": "Comprehensive online SSL/TLS security scanner tool for checking SSL certificates, security protocols, cipher suites, and identifying vulnerabilities in domain security configurations with real-time scanning capabilities and detailed PDF reports.",
		"url": "https://8gwifi.org/sslscan.jsp",
		"applicationCategory": "SecurityTool",
		"operatingSystem": "Web Browser",
		"browserRequirements": "Requires JavaScript. Requires HTML5. Supports Server-Sent Events (SSE).",
		"featureList": [
			"Real-time SSL/TLS scanning with live progress updates",
			"Comprehensive certificate analysis and validation",
			"Security protocol testing (TLS 1.0, 1.1, 1.2, 1.3)",
			"Cipher suite strength assessment and recommendations",
			"Vulnerability detection and security risk analysis",
			"Certificate chain validation and trust verification",
			"OCSP stapling and certificate transparency checking",
			"Detailed security configuration analysis",
			"PDF report generation with comprehensive findings",
			"Multiple scan types (basic, comprehensive, full audit)",
			"Real-time status monitoring and error reporting",
			"Cross-platform compatibility and mobile optimization"
		],
		"offers": {
			"@type": "Offer",
			"price": "0",
			"priceCurrency": "USD"
		},
		"author": {
			"@type": "Organization",
			"name": "8gwifi.org",
			"url": "https://8gwifi.org"
		},
		"creator": {
			"@type": "Organization",
			"name": "8gwifi.org",
			"url": "https://8gwifi.org"
		},
		"keywords": "ssl scanner, tls scanner, ssl checker, certificate scanner, security scanner, ssl test, tls test, ssl vulnerability scanner, certificate validation, security audit tool, ssl configuration checker, tls security testing, ssl certificate analyzer, security protocol tester, cipher suite analyzer, ssl security assessment, tls compliance checker, ssl certificate chain validator, security configuration analyzer, ssl vulnerability detection, tls security scanner",
		"about": {
			"@type": "Thing",
			"name": "SSL/TLS Security Scanning",
			"description": "SSL Scanner Tool provides comprehensive security analysis for SSL/TLS configurations, enabling security professionals, developers, and administrators to identify vulnerabilities, validate certificates, and ensure compliance with security best practices."
		},
		"audience": {
			"@type": "Audience",
			"audienceType": "Security Professionals, DevOps Engineers, System Administrators, Web Developers, Network Administrators, Security Auditors, Compliance Officers, IT Security Teams, Penetration Testers, Security Consultants"
		},
		"softwareVersion": "v3.0",
		"applicationSubCategory": "SSL/TLS Security Scanner",
		"screenshot": "https://8gwifi.org/images/site/ssl-scanner.png",
		"downloadUrl": "https://8gwifi.org/sslscan.jsp",
		"installUrl": "https://8gwifi.org/sslscan.jsp",
		"softwareHelp": "https://8gwifi.org/sslscan.jsp#usage",
		"mainEntity": {
			"@type": "WebPage",
			"name": "SSL/TLS Security Scanning Guide",
			"description": "Complete guide to SSL/TLS security scanning, certificate validation, and vulnerability detection for enhanced domain security."
		},
		"potentialAction": {
			"@type": "UseAction",
			"target": "https://8gwifi.org/sslscan.jsp",
			"actionStatus": "PotentialActionStatus",
			"description": "Scan SSL/TLS security configuration for any domain"
		}
	}
	</script>
	
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

<h2 class="mt-4" id="sslscanner">SSL Scanner Tool Overview</h2>

<p><strong>SSL Scanner Tool</strong> is a comprehensive online security assessment tool designed to analyze SSL/TLS configurations, validate certificates, and identify potential security vulnerabilities in domain configurations. This enterprise-grade scanner provides real-time analysis with detailed reporting capabilities.</p>

<p>This tool is essential for:</p>
<ul>
    <li><strong><em>Security professionals</em></strong> conducting security audits and assessments</li>
    <li><strong><em>DevOps engineers</em></strong> ensuring secure deployment configurations</li>
    <li><strong><em>System administrators</em></strong> monitoring and maintaining security standards</li>
    <li><strong><em>Web developers</em></strong> validating SSL/TLS implementations</li>
    <li><strong><em>Compliance officers</em></strong> ensuring regulatory security requirements</li>
</ul>

<hr>

<h2 class="mt-4" id="features">Key Features & Capabilities</h2>

<div class="row">
    <div class="col-md-6">
        <h5>Certificate Analysis</h5>
        <ul>
            <li><strong>Certificate Validation:</strong> Complete certificate chain verification</li>
            <li><strong>Expiry Monitoring:</strong> Certificate validity period checking</li>
            <li><strong>Issuer Verification:</strong> Certificate authority (CA) validation</li>
            <li><strong>Subject Analysis:</strong> Domain and organization information</li>
            <li><strong>Trust Chain:</strong> Certificate trust path validation</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Security Protocol Testing</h5>
        <ul>
            <li><strong>TLS Version Support:</strong> TLS 1.0, 1.1, 1.2, 1.3 compatibility</li>
            <li><strong>Protocol Security:</strong> Weak protocol detection</li>
            <li><strong>Cipher Suite Analysis:</strong> Encryption strength assessment</li>
            <li><strong>Key Exchange:</strong> Key exchange mechanism validation</li>
            <li><strong>Forward Secrecy:</strong> Perfect forward secrecy checking</li>
        </ul>
    </div>
</div>

<div class="row mt-3">
    <div class="col-md-6">
        <h5>Vulnerability Detection</h5>
        <ul>
            <li><strong>Common Vulnerabilities:</strong> Heartbleed, BEAST, POODLE detection</li>
            <li><strong>Weak Ciphers:</strong> Identification of deprecated algorithms</li>
            <li><strong>Configuration Issues:</strong> Security misconfigurations</li>
            <li><strong>Compliance Checking:</strong> PCI DSS, HIPAA compliance validation</li>
            <li><strong>Security Headers:</strong> HSTS, CSP header analysis</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Advanced Features</h5>
        <ul>
            <li><strong>Real-time Scanning:</strong> Live progress monitoring with SSE</li>
            <li><strong>Multiple Scan Types:</strong> Quick, Basic, and Full audit modes</li>
            <li><strong>PDF Reports:</strong> Comprehensive downloadable security reports</li>
            <li><strong>Cross-platform:</strong> Works on all devices and browsers</li>
            <li><strong>No Installation:</strong> Web-based tool accessible anywhere</li>
        </ul>
    </div>
</div>

<hr>

<h2 class="mt-4" id="usage">How to Use SSL Scanner</h2>

<div class="row">
    <div class="col-md-6">
        <h5>1. Domain Input</h5>
        <ol>
            <li>Enter the domain name you want to scan (e.g., <code>example.com</code>)</li>
            <li>Do not include <code>http://</code> or <code>https://</code> protocols</li>
            <li>Ensure the domain is accessible and has SSL/TLS enabled</li>
            <li>Click "Start SSL Scan" to begin the security assessment</li>
        </ol>
    </div>
    <div class="col-md-6">
        <h5>2. Scan Type Selection</h5>
        <ol>
            <li><strong>Quick Scan:</strong> Fast basic certificate validation (30 seconds)</li>
            <li><strong>Basic Scan:</strong> Comprehensive security analysis (2-3 minutes)</li>
            <li><strong>Full Scan:</strong> Complete security audit with all tests (5-10 minutes)</li>
            <li>Monitor real-time progress and live output during scanning</li>
        </ol>
    </div>
</div>

<div class="row mt-3">
    <div class="col-md-6">
        <h5>3. Results Analysis</h5>
        <ol>
            <li>Review the scan summary and certificate details</li>
            <li>Analyze security configuration and protocol support</li>
            <li>Check for vulnerabilities and security recommendations</li>
            <li>Download the comprehensive PDF report for detailed analysis</li>
        </ol>
    </div>
    <div class="col-md-6">
        <h5>4. Action Items</h5>
        <ol>
            <li>Address any critical security vulnerabilities identified</li>
            <li>Update weak cipher suites and deprecated protocols</li>
            <li>Implement recommended security headers and configurations</li>
            <li>Schedule regular security scans for ongoing monitoring</li>
        </ol>
    </div>
</div>

<hr>

<h2 class="mt-4" id="scan-types">Scan Types Explained</h2>

<table class="table table-bordered table-striped">
    <thead class="thead-dark">
        <tr>
            <th>Scan Type</th>
            <th>Duration</th>
            <th>Tests Performed</th>
            <th>Use Case</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><strong>Quick Scan</strong></td>
            <td>30 seconds</td>
            <td>Basic certificate validation, protocol support</td>
            <td>Quick health checks, development testing</td>
        </tr>
        <tr>
            <td><strong>Basic Scan</strong></td>
            <td>2-3 minutes</td>
            <td>Certificate analysis, security protocols, cipher suites</td>
            <td>Regular security monitoring, compliance checks</td>
        </tr>
        <tr>
            <td><strong>Full Scan</strong></td>
            <td>5-10 minutes</td>
            <td>Complete security audit, vulnerability testing, detailed analysis</td>
            <td>Security audits, penetration testing, compliance validation</td>
        </tr>
    </tbody>
</table>

<hr>

<h2 class="mt-4" id="security-standards">Security Standards & Compliance</h2>

<div class="row">
    <div class="col-md-6">
        <h5>Industry Standards</h5>
        <ul>
            <li><strong>PCI DSS:</strong> Payment Card Industry Data Security Standard</li>
            <li><strong>HIPAA:</strong> Health Insurance Portability and Accountability Act</li>
            <li><strong>SOX:</strong> Sarbanes-Oxley Act compliance requirements</li>
            <li><strong>GDPR:</strong> General Data Protection Regulation security</li>
            <li><strong>ISO 27001:</strong> Information Security Management Systems</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Security Best Practices</h5>
        <ul>
            <li><strong>TLS 1.2+:</strong> Minimum recommended TLS version</li>
            <li><strong>Strong Ciphers:</strong> AES-256, ChaCha20 encryption</li>
            <li><strong>Forward Secrecy:</strong> Perfect forward secrecy implementation</li>
            <li><strong>Security Headers:</strong> HSTS, CSP, X-Frame-Options</li>
            <li><strong>Certificate Transparency:</strong> CT log monitoring</li>
        </ul>
    </div>
</div>

<hr>

<h2 class="mt-4" id="common-vulnerabilities">Common SSL/TLS Vulnerabilities</h2>

<div class="alert alert-warning">
    <h6><strong>Critical Security Issues to Watch For:</strong></h6>
    <ul class="mb-0">
        <li><strong>Weak Cipher Suites:</strong> RC4, DES, 3DES, MD5, SHA1 algorithms</li>
        <li><strong>Deprecated Protocols:</strong> SSL 2.0, SSL 3.0, TLS 1.0, TLS 1.1</li>
        <li><strong>Certificate Issues:</strong> Expired certificates, weak key sizes, improper validation</li>
        <li><strong>Configuration Problems:</strong> Missing security headers, weak key exchange</li>
        <li><strong>Known Vulnerabilities:</strong> Heartbleed, BEAST, POODLE, FREAK attacks</li>
    </ul>
</div>

<hr>

<h2 class="mt-4" id="best-practices">SSL/TLS Security Best Practices</h2>

<div class="row">
    <div class="col-md-6">
        <h5>Certificate Management</h5>
        <ul>
            <li><strong>Auto-renewal:</strong> Implement automatic certificate renewal</li>
            <li><strong>Key Rotation:</strong> Regular private key rotation</li>
            <li><strong>Monitoring:</strong> Certificate expiry monitoring and alerts</li>
            <li><strong>Validation:</strong> Proper certificate validation procedures</li>
            <li><strong>Backup:</strong> Secure certificate and key backup</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Configuration Security</h5>
        <ul>
            <li><strong>Protocol Support:</strong> Enable only TLS 1.2 and 1.3</li>
            <li><strong>Cipher Selection:</strong> Use strong, modern cipher suites</li>
            <li><strong>Security Headers:</strong> Implement comprehensive security headers</li>
            <li><strong>OCSP Stapling:</strong> Enable OCSP stapling for performance</li>
            <li><strong>HSTS:</strong> Implement HTTP Strict Transport Security</li>
        </ul>
    </div>
</div>

<hr>

<h2 class="mt-4" id="reporting">Comprehensive Reporting</h2>

<p>The SSL Scanner Tool generates detailed security reports that include:</p>

<div class="row">
    <div class="col-md-6">
        <h5>Executive Summary</h5>
        <ul>
            <li><strong>Overall Security Score:</strong> Numerical security rating</li>
            <li><strong>Risk Assessment:</strong> High, medium, low risk categorization</li>
            <li><strong>Compliance Status:</strong> Industry standard compliance</li>
            <li><strong>Recommendations:</strong> Priority-based action items</li>
            <li><strong>Scan Metadata:</strong> Timestamp, duration, scan type</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Technical Details</h5>
        <ul>
            <li><strong>Certificate Chain:</strong> Complete certificate validation</li>
            <li><strong>Protocol Analysis:</strong> TLS version support and security</li>
            <li><strong>Cipher Suite Details:</strong> Encryption algorithm analysis</li>
            <li><strong>Vulnerability Scan:</strong> Known security issue detection</li>
            <li><strong>Configuration Review:</strong> Security header and setting analysis</li>
        </ul>
    </div>
</div>

<hr>

<h2 class="mt-4" id="use-cases">Professional Use Cases</h2>

<div class="row">
    <div class="col-md-6">
        <h5>Security Auditing</h5>
        <ul>
            <li><strong>Penetration Testing:</strong> Pre and post-testing validation</li>
            <li><strong>Compliance Audits:</strong> Regulatory requirement validation</li>
            <li><strong>Security Assessments:</strong> Comprehensive security reviews</li>
            <li><strong>Vendor Evaluation:</strong> Third-party security assessment</li>
            <li><strong>Incident Response:</strong> Security incident investigation</li>
        </ul>
    </div>
    <div class="col-md-6">
        <h5>Operational Security</h5>
        <ul>
            <li><strong>Continuous Monitoring:</strong> Regular security health checks</li>
            <li><strong>Change Management:</strong> Post-deployment security validation</li>
            <li><strong>Performance Optimization:</strong> SSL/TLS performance analysis</li>
            <li><strong>Capacity Planning:</strong> Security infrastructure planning</li>
            <li><strong>Training & Education:</strong> Security awareness programs</li>
        </ul>
    </div>
</div>

<hr>

<h2 class="mt-4" id="technical-details">Technical Implementation Details</h2>

<p><strong>SSL Scanner Tool</strong> utilizes advanced security testing methodologies and industry-standard tools to provide comprehensive SSL/TLS analysis:</p>

<ul>
    <li><strong><em>Server-Sent Events (SSE):</em></strong> Real-time progress updates and live output streaming</li>
    <li><strong><em>Multiple Scan Engines:</em></strong> Integration with industry-leading security testing tools</li>
    <li><strong><em>Comprehensive Testing:</em></strong> Coverage of all major SSL/TLS security aspects</li>
    <li><strong><em>Real-time Analysis:</em></strong> Live security assessment with immediate feedback</li>
    <li><strong><em>PDF Generation:</strong> Professional-grade security reports for documentation</li>
</ul>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>