<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*,java.util.*,com.google.gson.*"%>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality"%>
<!DOCTYPE html>
<html>
<head>
	<title>HTTP Status Analysis Tool - Network Performance Testing</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="http status, network performance, http timing, dns lookup, tcp connect, tls handshake, network diagnostics" />
	<meta name="description" content="Online HTTP Status Analysis tool for comprehensive network performance testing. Analyze DNS lookup, TCP connection, TLS handshake, and response timing." />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>
	
	<!-- JSON-LD Structured Data for SEO -->
	<script type="application/ld+json">
	{
		"@context": "https://schema.org",
		"@type": "WebApplication",
		"name": "HTTP Status Analysis Tool",
		"description": "Comprehensive HTTP status analysis tool for network performance testing. Detailed timing analysis including DNS lookup, TCP connection, TLS handshake, and response timing.",
		"url": "https://8gwifi.org/httpstat.jsp",
		"applicationCategory": "NetworkTool",
		"operatingSystem": "Web Browser",
		"browserRequirements": "Requires JavaScript. Requires HTML5.",
		"featureList": [
			"HTTP status analysis",
			"DNS lookup timing",
			"TCP connection timing",
			"TLS handshake timing",
			"Response timing analysis",
			"Header analysis",
			"TLS certificate details"
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
		"keywords": "http status, network performance, http timing, dns lookup, tcp connect, tls handshake, network diagnostics, performance testing",
		"about": {
			"@type": "Thing",
			"name": "Network Performance Testing",
			"description": "HTTP Status Analysis provides comprehensive timing breakdown for HTTP requests including DNS resolution, TCP connection establishment, TLS handshake, and response processing."
		},
		"audience": {
			"@type": "Audience",
			"audienceType": "Network Administrators, Web Developers, DevOps Engineers, System Administrators, IT Professionals"
		}
	}
	</script>

	<style>
		.timeline-container {
			font-family: 'Courier New', monospace;
			background: #f8f9fa;
			border: 2px solid #dee2e6;
			border-radius: 8px;
			padding: 20px;
			margin: 20px 0;
		}
		.timeline-header {
			font-weight: bold;
			color: #495057;
			margin-bottom: 15px;
		}
		.timeline-bar {
			background: #e9ecef;
			border: 1px solid #ced4da;
			border-radius: 4px;
			height: 40px;
			position: relative;
			margin: 10px 0;
		}
		.timeline-segment {
			position: absolute;
			height: 100%;
			border-radius: 3px;
			display: flex;
			align-items: center;
			justify-content: center;
			color: white;
			font-weight: bold;
			font-size: 12px;
			text-shadow: 1px 1px 1px rgba(0,0,0,0.5);
		}
		.timeline-labels {
			display: flex;
			justify-content: space-between;
			margin-top: 10px;
			font-size: 12px;
			color: #6c757d;
		}
		.timeline-metrics {
			background: #ffffff;
			border: 1px solid #dee2e6;
			border-radius: 4px;
			padding: 15px;
			margin-top: 15px;
		}
		.metric-row {
			display: flex;
			justify-content: space-between;
			margin: 5px 0;
			padding: 5px 0;
			border-bottom: 1px solid #f1f3f4;
		}
		.metric-label {
			font-weight: bold;
			color: #495057;
		}
		.metric-value {
			color: #007bff;
			font-weight: bold;
		}
	</style>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#httpstatForm').submit(function(event) {
				event.preventDefault();
				
				var url = $('#url').val().trim();
				if (!url) {
					alert('Please enter a URL to analyze');
					return;
				}

				// Build request data with all options
				var requestData = {
					url: url,
					method: $('#method').val(),
					timeout_seconds: parseInt($('#timeout').val()),
					follow_redirects: $('#followRedirects').val() === 'true',
					read_body: $('#readBody').val() === 'true',
					body_preview_bytes: parseInt($('#bodyPreviewBytes').val()),
					insecure_tls: $('#insecureTls').val() === 'true'
				};

				// Add IP version
				var ipVersion = $('input[name="ipVersion"]:checked').val();
				if (ipVersion === 'ipv4') {
					requestData.ipv4_only = true;
				} else if (ipVersion === 'ipv6') {
					requestData.ipv6_only = true;
				}

				// Add custom headers if provided
				var customHeaders = $('#customHeaders').val().trim();
				if (customHeaders) {
					try {
						requestData.headers = JSON.parse(customHeaders);
					} catch (e) {
						alert('Invalid JSON format in custom headers');
						return;
					}
				}

				// Show loading
				$('#loading').show();
				$('#results').hide();
				$('#error').hide();

				// Make AJAX call to the servlet
				$.ajax({
					type: "POST",
					url: 'HTTPStatFunctionality',
					data: JSON.stringify(requestData),
					contentType: 'application/json',
					dataType: 'json',
					success: function(data) {
						$('#loading').hide();
						displayResults(data);
					},
					error: function(xhr, status, error) {
						$('#loading').hide();
						var errorMsg = 'An error occurred while analyzing the URL.';
						
						if (xhr.responseJSON && xhr.responseJSON.error) {
							errorMsg = xhr.responseJSON.error;
						} else if (xhr.status === 400) {
							errorMsg = 'Invalid URL format. Please check your input.';
						}
						
						$('#error').text(errorMsg).show();
					}
				});
			});

			function displayResults(data) {
				// Basic Information
				$('#targetUrl').text(data.target);
				$('#testLocation').text(data.test_location || 'N/A');
				
				// HTTP Information
				if (data.http) {
					$('#httpStatus').text(data.http.status);
					$('#httpProtocol').text(data.http.protocol);
					$('#httpContentType').text(data.http.content_type);
					$('#httpContentLength').text(data.http.content_length > 0 ? data.http.content_length : 'N/A');
				}
				
				// TLS Information
				if (data.tls) {
					$('#tlsVersion').text(data.tls.version);
					$('#tlsCipherSuite').text(data.tls.cipher_suite);
				}
				
				// Timing Information
				if (data.timings_ms) {
					$('#dnsLookup').text(data.timings_ms.dns_lookup + ' ms');
					$('#tcpConnect').text(data.timings_ms.tcp_connect + ' ms');
					$('#tlsHandshake').text(data.timings_ms.tls_handshake + ' ms');
					$('#serverProcessing').text(data.timings_ms.server_processing + ' ms');
					$('#contentTransfer').text(data.timings_ms.content_transfer + ' ms');
					$('#totalTime').text(data.timings_ms.total + ' ms');
					
					// Generate visual timeline
					generateTimeline(data.timings_ms, data.tls);
				}
				
				// Headers
				if (data.headers) {
					var headersHtml = '';
					for (var header in data.headers) {
						if (data.headers.hasOwnProperty(header)) {
							var value = Array.isArray(data.headers[header]) ? data.headers[header].join(', ') : data.headers[header];
							headersHtml += '<tr><td><strong>' + header + '</strong></td><td>' + value + '</td></tr>';
						}
					}
					$('#headersTableBody').html(headersHtml);
				}
				
				// Redirect Information
				$('#redirected').text(data.redirected ? 'Yes' : 'No');
				
				$('#results').show();
			}

			function generateTimeline(timings, tls) {
				var total = timings.total;
				var hasTls = tls && tls.version;
				
				var timelineHtml = '<div class="timeline-container">';
				
				// Header
				if (hasTls) {
					timelineHtml += '<div class="timeline-header">DNS Lookup   TCP Connection   TLS Handshake   Server Processing   Content Transfer</div>';
				} else {
					timelineHtml += '<div class="timeline-header">DNS Lookup   TCP Connection   Server Processing   Content Transfer</div>';
				}
				
				// Timeline bar
				timelineHtml += '<div class="timeline-bar">';
				
				var currentPos = 0;
				var colors = ['#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1'];
				
				// DNS Lookup
				var dnsWidth = (timings.dns_lookup / total) * 100;
				timelineHtml += '<div class="timeline-segment" style="left: ' + currentPos + '%; width: ' + dnsWidth + '%; background-color: ' + colors[0] + ';">' + 
							   Math.round(timings.dns_lookup) + 'ms</div>';
				currentPos += dnsWidth;
				
				// TCP Connect
				var tcpWidth = (timings.tcp_connect / total) * 100;
				timelineHtml += '<div class="timeline-segment" style="left: ' + currentPos + '%; width: ' + tcpWidth + '%; background-color: ' + colors[1] + ';">' + 
							   Math.round(timings.tcp_connect) + 'ms</div>';
				currentPos += tcpWidth;
				
				// TLS Handshake (if applicable)
				if (hasTls) {
					var tlsWidth = (timings.tls_handshake / total) * 100;
					timelineHtml += '<div class="timeline-segment" style="left: ' + currentPos + '%; width: ' + tlsWidth + '%; background-color: ' + colors[2] + ';">' + 
								   Math.round(timings.tls_handshake) + 'ms</div>';
					currentPos += tlsWidth;
				}
				
				// Server Processing
				var serverWidth = (timings.server_processing / total) * 100;
				timelineHtml += '<div class="timeline-segment" style="left: ' + currentPos + '%; width: ' + serverWidth + '%; background-color: ' + colors[hasTls ? 3 : 2] + ';">' + 
							   Math.round(timings.server_processing) + 'ms</div>';
				currentPos += serverWidth;
				
				// Content Transfer
				var contentWidth = (timings.content_transfer / total) * 100;
				timelineHtml += '<div class="timeline-segment" style="left: ' + currentPos + '%; width: ' + contentWidth + '%; background-color: ' + colors[hasTls ? 4 : 3] + ';">' + 
							   Math.round(timings.content_transfer) + 'ms</div>';
				
				timelineHtml += '</div>';
				
				// Labels
				timelineHtml += '<div class="timeline-labels">';
				if (hasTls) {
					timelineHtml += '<span>namelookup</span><span>connect</span><span>pretransfer</span><span>starttransfer</span><span>total</span>';
				} else {
					timelineHtml += '<span>namelookup</span><span>connect</span><span>starttransfer</span><span>total</span>';
				}
				timelineHtml += '</div>';
				
				// Metrics
				timelineHtml += '<div class="timeline-metrics">';
				timelineHtml += '<div class="metric-row"><span class="metric-label">namelookup:</span><span class="metric-value">' + timings.dns_lookup + ' ms</span></div>';
				timelineHtml += '<div class="metric-row"><span class="metric-label">connect:</span><span class="metric-value">' + (timings.dns_lookup + timings.tcp_connect) + ' ms</span></div>';
				if (hasTls) {
					timelineHtml += '<div class="metric-row"><span class="metric-label">pretransfer:</span><span class="metric-value">' + (timings.dns_lookup + timings.tcp_connect + timings.tls_handshake) + ' ms</span></div>';
					timelineHtml += '<div class="metric-row"><span class="metric-label">starttransfer:</span><span class="metric-value">' + (timings.dns_lookup + timings.tcp_connect + timings.tls_handshake + timings.server_processing) + ' ms</span></div>';
				} else {
					timelineHtml += '<div class="metric-row"><span class="metric-label">starttransfer:</span><span class="metric-value">' + (timings.dns_lookup + timings.tcp_connect + timings.server_processing) + ' ms</span></div>';
				}
				timelineHtml += '<div class="metric-row"><span class="metric-label">total:</span><span class="metric-value">' + timings.total + ' ms</span></div>';
				timelineHtml += '</div>';
				
				timelineHtml += '</div>';
				
				$('#timelineChart').html(timelineHtml);
			}
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">HTTP Status Analysis Tool</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Analyzing HTTP status...
</div>

<form id="httpstatForm" class="form-horizontal" method="POST">
	<div class="form-group">
		<label for="url"><strong>Target URL:</strong></label>
		<div class="input-group">
			<input type="url" class="form-control" id="url" name="url" 
				   placeholder="e.g., https://example.com" required>
			<div class="input-group-append">
				<button type="submit" class="btn btn-primary">
					Analyze HTTP Status
				</button>
			</div>
		</div>
		<small class="form-text text-muted">
			Enter a complete URL including protocol (http:// or https://)
		</small>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label for="method"><strong>HTTP Method:</strong></label>
				<select class="form-control" id="method" name="method">
					<option value="GET">GET</option>
					<option value="POST">POST</option>
					<option value="PUT">PUT</option>
					<option value="DELETE">DELETE</option>
					<option value="HEAD">HEAD</option>
					<option value="OPTIONS">OPTIONS</option>
					<option value="PATCH">PATCH</option>
				</select>
				<small class="form-text text-muted">HTTP method to use for the request</small>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<label for="timeout"><strong>Timeout (seconds):</strong></label>
				<input type="number" class="form-control" id="timeout" name="timeout" 
					   value="30" min="1" max="300">
				<small class="form-text text-muted">Total request timeout in seconds</small>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label for="followRedirects"><strong>Follow Redirects:</strong></label>
				<select class="form-control" id="followRedirects" name="followRedirects">
					<option value="true">Yes</option>
					<option value="false">No</option>
				</select>
				<small class="form-text text-muted">Whether to follow HTTP redirects</small>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<label for="readBody"><strong>Read Response Body:</strong></label>
				<select class="form-control" id="readBody" name="readBody">
					<option value="false">No</option>
					<option value="true">Yes</option>
				</select>
				<small class="form-text text-muted">Read response body to measure transfer time</small>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label for="bodyPreviewBytes"><strong>Body Preview (bytes):</strong></label>
				<input type="number" class="form-control" id="bodyPreviewBytes" name="bodyPreviewBytes" 
					   value="0" min="0" max="10000">
				<small class="form-text text-muted">Read up to N bytes and return as base64 (0 = no preview)</small>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<label for="insecureTls"><strong>TLS Verification:</strong></label>
				<select class="form-control" id="insecureTls" name="insecureTls">
					<option value="false">Verify TLS (Secure)</option>
					<option value="true">Skip TLS Verification (Insecure)</option>
				</select>
				<small class="form-text text-muted">Skip TLS certificate verification (use with caution)</small>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label><strong>IP Version:</strong></label>
				<div class="form-check">
					<input class="form-check-input" type="radio" name="ipVersion" id="ipv4Only" value="ipv4">
					<label class="form-check-label" for="ipv4Only">Force IPv4</label>
				</div>
				<div class="form-check">
					<input class="form-check-input" type="radio" name="ipVersion" id="ipv6Only" value="ipv6">
					<label class="form-check-label" for="ipv6Only">Force IPv6</label>
				</div>
				<div class="form-check">
					<input class="form-check-input" type="radio" name="ipVersion" id="ipAuto" value="auto" checked>
					<label class="form-check-label" for="ipAuto">Auto-detect (Default)</label>
				</div>
				<small class="form-text text-muted">Force specific IP version or let system choose</small>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<label for="customHeaders"><strong>Custom Headers (JSON):</strong></label>
				<textarea class="form-control" id="customHeaders" name="customHeaders" rows="3" 
						  placeholder='{"User-Agent": "MyApp/1.0", "Accept": "application/json"}'></textarea>
				<small class="form-text text-muted">Optional custom headers as JSON object</small>
			</div>
		</div>
	</div>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display: none;"></div>

<div id="results" style="display: none;">
	<h4>HTTP Status Results for: <span id="targetUrl"></span></h4>
	
	<!-- Visual Timeline Representation -->
	<div class="row mb-4">
		<div class="col-12">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">
						<i class="fas fa-chart-line me-2"></i>Visual Timeline Analysis
					</h6>
				</div>
				<div class="card-body">
					<div id="timelineChart" class="text-center">
						<!-- Timeline will be populated here -->
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<div class="row">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Basic Information</h6>
				</div>
				<div class="card-body">
					<p><strong>Target URL:</strong> <span id="targetUrl2"></span></p>
					<p><strong>Test Location:</strong> <span id="testLocation"></span></p>
					<p><strong>Redirected:</strong> <span id="redirected"></span></p>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">HTTP Information</h6>
				</div>
				<div class="card-body">
					<p><strong>Status Code:</strong> <span id="httpStatus"></span></p>
					<p><strong>Protocol:</strong> <span id="httpProtocol"></span></p>
					<p><strong>Content Type:</strong> <span id="httpContentType"></span></p>
					<p><strong>Content Length:</strong> <span id="httpContentLength"></span></p>
				</div>
			</div>
		</div>
	</div>
	
	<div class="row mt-4">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">TLS Information</h6>
				</div>
				<div class="card-body">
					<p><strong>TLS Version:</strong> <span id="tlsVersion"></span></p>
					<p><strong>Cipher Suite:</strong> <span id="tlsCipherSuite"></span></p>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Timing Breakdown</h6>
				</div>
				<div class="card-body">
					<p><strong>DNS Lookup:</strong> <span id="dnsLookup"></span></p>
					<p><strong>TCP Connect:</strong> <span id="tcpConnect"></span></p>
					<p><strong>TLS Handshake:</strong> <span id="tlsHandshake"></span></p>
					<p><strong>Server Processing:</strong> <span id="serverProcessing"></span></p>
					<p><strong>Content Transfer:</strong> <span id="contentTransfer"></span></p>
					<p><strong>Total Time:</strong> <span id="totalTime"></span></p>
				</div>
			</div>
		</div>
	</div>
	
	<h5 class="mt-4">HTTP Headers:</h5>
	<div class="table-responsive">
		<table class="table table-striped table-bordered">
			<thead class="thead-dark">
				<tr>
					<th>Header Name</th>
					<th>Value</th>
				</tr>
			</thead>
			<tbody id="headersTableBody">
			</tbody>
		</table>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="httpstatustool">HTTP Status Analysis Tool</h2>

<p><strong>HTTP Status Analysis</strong> is a comprehensive network performance testing tool that provides detailed timing breakdown for HTTP requests. It analyzes every stage of the HTTP request lifecycle, from DNS resolution to response completion, helping identify network bottlenecks and performance issues.</p>

<p>This tool is particularly useful for:</p>
<ul>
	<li><strong><em>Web performance optimization and monitoring</em></strong></li>
	<li><strong><em>Network troubleshooting and diagnostics</em></strong></li>
	<li><strong><em>CDN and hosting provider analysis</em></strong></li>
	<li><strong><em>SSL/TLS performance evaluation</em></strong></li>
</ul>

<hr>

<h2 class="mt-4" id="howitworks">How It Works</h2>

<p>HTTP Status Analysis performs a comprehensive HTTP request and measures timing at each stage:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Stage</th>
		<th>Description</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>DNS Lookup</strong></td>
		<td>Resolves domain name to IP address</td>
	</tr>
	<tr>
		<td><strong>TCP Connect</strong></td>
		<td>Establishes TCP connection to server</td>
	</tr>
	<tr>
		<td><strong>TLS Handshake</strong></td>
		<td>Negotiates SSL/TLS encryption (HTTPS only)</td>
	</tr>
	<tr>
		<td><strong>Server Processing</strong></td>
		<td>Time server takes to process request</td>
	</tr>
	<tr>
		<td><strong>Content Transfer</strong></td>
		<td>Time to download response content</td>
	</tr>
	</tbody>
</table>

<hr>

<h2 class="mt-4" id="interpretation">Understanding Results</h2>

<div class="row">
	<div class="col-md-6">
		<h5>Timing Analysis</h5>
		<ul>
			<li><strong>DNS Lookup:</strong> Should be under 100ms for good performance</li>
			<li><strong>TCP Connect:</strong> Should be under 200ms for local regions</li>
			<li><strong>TLS Handshake:</strong> Should be under 300ms for modern servers</li>
			<li><strong>Total Time:</strong> Should be under 1000ms for good performance</li>
		</ul>
	</div>
	<div class="col-md-6">
		<h5>Performance Indicators</h5>
		<ul>
			<li><strong>Status Codes:</strong> 2xx indicates success, 4xx/5xx indicate issues</li>
			<li><strong>Protocol:</strong> HTTP/2.0 generally faster than HTTP/1.1</li>
			<li><strong>Content Type:</strong> Affects browser processing and caching</li>
			<li><strong>Headers:</strong> Cache control and compression settings</li>
		</ul>
	</div>
</div>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
