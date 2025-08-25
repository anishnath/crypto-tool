<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*,java.util.*,com.google.gson.*"%>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality"%>
<!DOCTYPE html>
<html>
<head>
	<title>Port Scanner Tool - Online Port Scanning</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="port scanner, port scanning, online port scanner, network scanner, port checker, open ports" />
	<meta name="description" content="Online port scanner tool to check open ports on any host or IP address. Quick scan, top ports, custom ports, and full port scanning capabilities." />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#scanType').change(function() {
				var scanType = $(this).val();
				if (scanType === 'custom') {
					$('#customPortsGroup').show();
				} else {
					$('#customPortsGroup').hide();
				}
			});

			// Client-side validation for private networks
			function isValidTarget(target) {
				// Check for localhost patterns
				var localhostPatterns = /^(localhost|127\.0\.0\.1|::1|0\.0\.0\.0|0\.0\.0\.0:.*)$/i;
				if (localhostPatterns.test(target)) {
					return false;
				}

				// Check for private network patterns
				var privateNetworks = /^(10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.|127\.|169\.254\.|224\.|240\.|0\.|255\.255\.255\.255$)/;
				if (privateNetworks.test(target)) {
					return false;
				}

				return true;
			}

			$('#portScanForm').submit(function(event) {
				event.preventDefault();
				
				var target = $('#target').val().trim();
				if (!target) {
					alert('Please enter a target host or IP address');
					return;
				}

				// Client-side validation
				if (!isValidTarget(target)) {
					$('#error').text('Scanning of private networks, localhost, or reserved IP addresses is not allowed for security reasons. Please use public IP addresses or domain names only.').show();
					return;
				}

				// Show loading
				$('#loading').show();
				$('#results').hide();
				$('#error').hide();

				// Build query parameters
				var params = { target: target };
				var scanType = $('#scanType').val();
				if (scanType && scanType !== 'quick') {
					params.scan_type = scanType;
					if (scanType === 'custom') {
						var ports = $('#customPorts').val().trim();
						if (ports) {
							params.ports = ports;
						}
					}
				}

				// Make AJAX call to the servlet
				$.ajax({
					type: "GET",
					url: "PortScanFunctionality",
					data: params,
					dataType: 'json',
					success: function(data) {
						$('#loading').hide();
						displayResults(data);
					},
					error: function(xhr, status, error) {
						$('#loading').hide();
						var errorMsg = 'An error occurred while scanning ports.';
						
						if (xhr.responseJSON && xhr.responseJSON.error) {
							errorMsg = xhr.responseJSON.error;
						} else if (xhr.status === 400) {
							errorMsg = 'Invalid target format. Please check your input.';
						} else if (xhr.status === 403) {
							errorMsg = 'Access denied: ' + (xhr.responseJSON ? xhr.responseJSON.error : 'Target not allowed for security reasons');
						} else if (xhr.status === 404) {
							errorMsg = 'Target not found or unreachable.';
						}
						
						$('#error').text(errorMsg).show();
					}
				});
			});

			function displayResults(data) {
				$('#scannedTarget').text(data.target || 'Unknown');
				$('#scanTypeUsed').text(data.scan_type || 'Quick');
				$('#totalPorts').text(data.total_ports || '0');
				$('#openPorts').text(data.open_ports || '0');
				$('#scanDuration').text(data.duration || '0');
				
				// Display port results
				var portsHtml = '';
				if (data.ports && data.ports.length > 0) {
					for (var i = 0; i < data.ports.length; i++) {
						var port = data.ports[i];
						var statusClass = port.status === 'open' ? 'success' : 'secondary';
						var statusText = port.status === 'open' ? 'Open' : 'Closed';
						
						portsHtml += '<tr>';
						portsHtml += '<td>' + port.port + '</td>';
						portsHtml += '<td><span class="badge badge-' + statusClass + '">' + statusText + '</span></td>';
						portsHtml += '<td>' + (port.service || 'Unknown') + '</td>';
						portsHtml += '<td>' + (port.version || 'N/A') + '</td>';
						portsHtml += '</tr>';
					}
				} else {
					portsHtml = '<tr><td colspan="4" class="text-center">No port information available</td></tr>';
				}
				$('#portsList').html(portsHtml);
				
				$('#results').show();
			}
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Port Scanner Tool</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

	<div class="alert alert-warning">
		<strong><i class="fas fa-shield-alt"></i> Security Notice:</strong> 
		For security reasons, scanning of private networks (10.x.x.x, 172.16-31.x.x, 192.168.x.x), 
		localhost, and reserved IP addresses is not allowed. Please use public IP addresses or domain names only.
	</div>

	<form id="portScanForm" class="form-horizontal" method="POST">
		<div class="form-group">
			<label for="target"><strong>Target Host/IP:</strong></label>
			<div class="input-group">
				<input type="text" class="form-control" id="target" name="target" 
					   placeholder="e.g., example.com, 8.8.8.8, google.com" required>
				<div class="input-group-append">
					<button type="submit" class="btn btn-primary">
						Start Port Scan
					</button>
				</div>
			</div>
			<small class="form-text text-muted">
				Enter a public hostname, IP address, or domain name (private networks not allowed)
			</small>
		</div>

	<div class="form-group">
		<label for="scanType"><strong>Scan Type:</strong></label>
		<select class="form-control" id="scanType" name="scanType">
			<option value="quick">Quick Scan (Default)</option>
			<option value="top">Top Ports (with version detection)</option>
			<option value="custom">Custom Ports</option>
			<option value="full">Full Scan (may take longer)</option>
		</select>
	</div>

	<div class="form-group" id="customPortsGroup" style="display: none;">
		<label for="customPorts"><strong>Custom Ports:</strong></label>
		<input type="text" class="form-control" id="customPorts" name="customPorts" 
			   placeholder="e.g., 22,80,443,8080">
		<small class="form-text text-muted">
			Enter comma-separated port numbers (1-65535)
		</small>
	</div>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display: none;"></div>

<div id="results" style="display: none;">
	<h4>Scan Results for: <span id="scannedTarget"></span></h4>
	
	<div class="row">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Scan Summary</h6>
				</div>
				<div class="card-body">
					<p><strong>Scan Type:</strong> <span id="scanTypeUsed">Quick</span></p>
					<p><strong>Total Ports Scanned:</strong> <span id="totalPorts">0</span></p>
					<p><strong>Open Ports Found:</strong> <span id="openPorts">0</span></p>
					<p><strong>Scan Duration:</strong> <span id="scanDuration">0</span> seconds</p>
				</div>
			</div>
		</div>
	</div>
	
	<h5 class="mt-4">Port Details:</h5>
	<div class="table-responsive">
		<table class="table table-bordered table-striped">
			<thead class="thead-dark">
				<tr>
					<th>Port</th>
					<th>Status</th>
					<th>Service</th>
					<th>Version</th>
				</tr>
			</thead>
			<tbody id="portsList">
			</tbody>
		</table>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="portscanning">Port Scanning</h2>

<p><strong>Port scanning</strong> is a network reconnaissance technique used to identify open ports and services on a target host. This tool helps network administrators, security professionals, and penetration testers assess network security and identify potential vulnerabilities.</p>

<p>Port scanning can reveal:</p>
<ul>
	<li><strong><em>Open network services and applications</em></strong></li>
	<li><strong><em>Running web servers, databases, and mail servers</em></strong></li>
	<li><strong><em>Potential security vulnerabilities and misconfigurations</em></strong></li>
	<li><strong><em>Network topology and service mapping</em></strong></li>
</ul>

<hr>

<h2 class="mt-4" id="scantypes">Scan Types</h2>

<p>This tool offers different scanning options:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Scan Type</th>
		<th>Description</th>
		<th>Speed</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>Quick Scan</strong></td>
		<td>Scans most common ports (22, 80, 443, 8080, etc.)</td>
		<td>Fast</td>
	</tr>
	<tr>
		<td><strong>Top Ports</strong></td>
		<td>Scans top 1000 ports with service version detection</td>
		<td>Medium</td>
	</tr>
	<tr>
		<td><strong>Custom Ports</strong></td>
		<td>Scans user-specified port ranges</td>
		<td>Variable</td>
	</tr>
	<tr>
		<td><strong>Full Scan</strong></td>
		<td>Scans all 65535 ports (may take significant time)</td>
		<td>Slow</td>
	</tr>
	</tbody>
</table>

<hr>

<h2 class="mt-4" id="commonports">Common Ports</h2>

<p>Some commonly scanned ports and their typical services:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Port</th>
		<th>Service</th>
		<th>Description</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>21</strong></td>
		<td>FTP</td>
		<td>File Transfer Protocol</td>
	</tr>
	<tr>
		<td><strong>22</strong></td>
		<td>SSH</td>
		<td>Secure Shell</td>
	</tr>
	<tr>
		<td><strong>23</strong></td>
		<td>Telnet</td>
		<td>Remote terminal access</td>
	</tr>
	<tr>
		<td><strong>25</strong></td>
		<td>SMTP</td>
		<td>Simple Mail Transfer Protocol</td>
	</tr>
	<tr>
		<td><strong>53</strong></td>
		<td>DNS</td>
		<td>Domain Name System</td>
	</tr>
	<tr>
		<td><strong>80</strong></td>
		<td>HTTP</td>
		<td>Hypertext Transfer Protocol</td>
	</tr>
	<tr>
		<td><strong>443</strong></td>
		<td>HTTPS</td>
		<td>HTTP over SSL/TLS</td>
	</tr>
	<tr>
		<td><strong>3306</strong></td>
		<td>MySQL</td>
		<td>MySQL database</td>
	</tr>
	<tr>
		<td><strong>5432</strong></td>
		<td>PostgreSQL</td>
		<td>PostgreSQL database</td>
	</tr>
	<tr>
		<td><strong>8080</strong></td>
		<td>HTTP-Alt</td>
		<td>Alternative HTTP port</td>
	</tr>
	</tbody>
</table>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
