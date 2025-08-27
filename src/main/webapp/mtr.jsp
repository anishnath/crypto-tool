<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*,java.util.*,com.google.gson.*"%>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality"%>
<!DOCTYPE html>
<html>
<head>
	<title>MTR Traceroute Tool - Network Path Analysis</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="mtr traceroute, network path analysis, network diagnostics, traceroute tool, network latency, packet loss" />
	<meta name="description" content="Online MTR traceroute tool for network path analysis. Analyze network routes, latency, and packet loss between your location and target destinations." />
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
		"name": "MTR Traceroute Tool",
		"description": "Advanced MTR (My TraceRoute) tool for network path analysis. Continuous monitoring of network paths with packet loss and latency statistics.",
		"url": "https://8gwifi.org/mtr.jsp",
		"applicationCategory": "NetworkTool",
		"operatingSystem": "Web Browser",
		"browserRequirements": "Requires JavaScript. Requires HTML5.",
		"featureList": [
			"Network path tracing",
			"Packet loss analysis",
			"Latency statistics",
			"Continuous monitoring",
			"Hop-by-hop analysis",
			"JSON API support"
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
		"keywords": "mtr traceroute, network path analysis, packet loss, latency analysis, network diagnostics, traceroute tool, network tools",
		"about": {
			"@type": "Thing",
			"name": "Network Diagnostics",
			"description": "MTR combines the functionality of traceroute and ping to provide continuous monitoring of network paths with detailed statistics on packet loss and latency."
		},
		"audience": {
			"@type": "Audience",
			"audienceType": "Network Administrators, Network Engineers, System Administrators, IT Professionals"
		}
	}
	</script>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#mtrForm').submit(function(event) {
				event.preventDefault();
				
				var target = $('#target').val().trim();
				if (!target) {
					alert('Please enter a target hostname or IP address');
					return;
				}

				// Show loading
				$('#loading').show();
				$('#results').hide();
				$('#error').hide();

				// Build URL with parameters - ALWAYS pass all form fields
				var url = 'MTRFunctionality/' + encodeURIComponent(target);
				var params = [];
				
				// Always include all parameters to ensure servlet receives them
				params.push('target=' + encodeURIComponent(target));
				params.push('mode=' + $('#mode').val());
				params.push('packets=' + $('#packets').val());
				params.push('interval=' + $('#interval').val());
				params.push('timeout=' + $('#timeout').val());
				params.push('maxHops=' + $('#maxHops').val());
				
				url += '?' + params.join('&');

				// Make AJAX call to the servlet
				$.ajax({
					type: "GET",
					url: url,
					dataType: 'json',
					success: function(data) {
						$('#loading').hide();
						displayResults(data);
					},
					error: function(xhr, status, error) {
						$('#loading').hide();
						var errorMsg = 'An error occurred while performing MTR trace.';
						
						if (xhr.responseJSON && xhr.responseJSON.error) {
							errorMsg = xhr.responseJSON.error;
						} else if (xhr.status === 400) {
							errorMsg = 'Invalid target format. Please check your input.';
						} else if (xhr.status === 403) {
							errorMsg = 'Target not allowed. Private networks and localhost cannot be traced.';
						}
						
						$('#error').text(errorMsg).show();
					}
				});
			});

			function displayResults(data) {
				$('#targetHost').text(data.target);
				$('#sourceIP').text(data.source);
				$('#startTime').text(data.start_time);
				$('#endTime').text(data.end_time);
				$('#duration').text(data.duration_seconds.toFixed(2));
				$('#totalHops').text(data.total_hops);
				
				// Display summary
				if (data.summary) {
					$('#totalPackets').text(data.summary.total_packets);
					$('#lostPackets').text(data.summary.lost_packets);
					$('#overallLoss').text(data.summary.overall_loss_percent.toFixed(2));
					$('#minLatency').text(data.summary.min_latency_ms.toFixed(2));
					$('#maxLatency').text(data.summary.max_latency_ms.toFixed(2));
					$('#avgLatency').text(data.summary.avg_latency_ms.toFixed(2));
					$('#jitter').text(data.summary.jitter_ms.toFixed(2));
				}
				
				// Display hops
				var hopsHtml = '';
				if (data.hops && data.hops.length > 0) {
					for (var i = 0; i < data.hops.length; i++) {
						var hop = data.hops[i];
						var lossClass = hop.loss_percent === 100 ? 'text-danger' : 
									  hop.loss_percent > 10 ? 'text-warning' : 'text-success';
						
						hopsHtml += '<tr>';
						hopsHtml += '<td>' + hop.hop_number + '</td>';
						hopsHtml += '<td>' + (hop.ip || 'N/A') + '</td>';
						hopsHtml += '<td class="' + lossClass + '">' + hop.loss_percent.toFixed(1) + '%</td>';
						hopsHtml += '<td>' + (hop.last_latency_ms > 0 ? hop.last_latency_ms.toFixed(2) : 'N/A') + '</td>';
						hopsHtml += '<td>' + (hop.avg_latency_ms > 0 ? hop.avg_latency_ms.toFixed(2) : 'N/A') + '</td>';
						hopsHtml += '<td>' + (hop.best_latency_ms > 0 ? hop.best_latency_ms.toFixed(2) : 'N/A') + '</td>';
						hopsHtml += '<td>' + (hop.worst_latency_ms > 0 ? hop.worst_latency_ms.toFixed(2) : 'N/A') + '</td>';
						hopsHtml += '<td>' + (hop.std_dev_ms > 0 ? hop.std_dev_ms.toFixed(2) : 'N/A') + '</td>';
						hopsHtml += '</tr>';
					}
				} else {
					hopsHtml = '<tr><td colspan="8" class="text-center">No hop data available</td></tr>';
				}
				$('#hopsTableBody').html(hopsHtml);
				
				$('#results').show();
			}
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">MTR Traceroute Tool</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Performing MTR trace...
</div>

<form id="mtrForm" class="form-horizontal" method="POST">
	<div class="form-group">
		<label for="target"><strong>Target Host:</strong></label>
		<div class="input-group">
			<input type="text" class="form-control" id="target" name="target" 
				   placeholder="e.g., google.com or 8.8.8.8" required>
			<div class="input-group-append">
				<button type="submit" class="btn btn-primary">
					Start MTR Trace
				</button>
			</div>
		</div>
		<small class="form-text text-muted">
			Enter a domain name or public IP address (private networks not allowed)
		</small>
	</div>

	<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label for="mode"><strong>Mode:</strong></label>
				<select class="form-control" id="mode" name="mode">
					<option value="report">Report Mode</option>
					<option value="tui">TUI Mode</option>
				</select>
				<small class="form-text text-muted">Report mode for single output, TUI for continuous updates</small>
			</div>
		</div>
		<div class="col-md-6">
			<div class="form-group">
				<label for="packets"><strong>Packets per Hop:</strong></label>
				<input type="number" class="form-control" id="packets" name="packets" 
					   value="5" min="1" max="100">
				<small class="form-text text-muted">Number of packets to send to each hop</small>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-md-4">
			<div class="form-group">
				<label for="interval"><strong>Interval (seconds):</strong></label>
				<input type="number" class="form-control" id="interval" name="interval" 
					   value="1.0" min="0.1" max="10.0" step="0.1">
				<small class="form-text text-muted">Time between packets</small>
			</div>
		</div>
		<div class="col-md-4">
			<div class="form-group">
				<label for="timeout"><strong>Timeout (seconds):</strong></label>
				<input type="number" class="form-control" id="timeout" name="timeout" 
					   value="2.0" min="0.5" max="10.0" step="0.1">
				<small class="form-text text-muted">Packet timeout value</small>
			</div>
		</div>
		<div class="col-md-4">
			<div class="form-group">
				<label for="maxHops"><strong>Max Hops:</strong></label>
				<input type="number" class="form-control" id="maxHops" name="maxHops" 
					   value="30" min="1" max="64">
				<small class="form-text text-muted">Maximum number of hops to trace</small>
			</div>
		</div>
	</div>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display: none;"></div>

<div id="results" style="display: none;">
	<h4>MTR Results for: <span id="targetHost"></span></h4>
	
	<div class="row">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Trace Information</h6>
				</div>
				<div class="card-body">
					<p><strong>Source IP:</strong> <span id="sourceIP"></span></p>
					<p><strong>Start Time:</strong> <span id="startTime"></span></p>
					<p><strong>End Time:</strong> <span id="endTime"></span></p>
					<p><strong>Duration:</strong> <span id="duration"></span> seconds</p>
					<p><strong>Total Hops:</strong> <span id="totalHops"></span></p>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Summary Statistics</h6>
				</div>
				<div class="card-body">
					<p><strong>Total Packets:</strong> <span id="totalPackets">0</span></p>
					<p><strong>Lost Packets:</strong> <span id="lostPackets">0</span></p>
					<p><strong>Overall Loss:</strong> <span id="overallLoss">0</span>%</p>
					<p><strong>Min Latency:</strong> <span id="minLatency">0</span> ms</p>
					<p><strong>Max Latency:</strong> <span id="maxLatency">0</span> ms</p>
					<p><strong>Avg Latency:</strong> <span id="avgLatency">0</span> ms</p>
					<p><strong>Jitter:</strong> <span id="jitter">0</span> ms</p>
				</div>
			</div>
		</div>
	</div>
	
	<h5 class="mt-4">Hop Details:</h5>
	<div class="table-responsive">
		<table class="table table-striped table-bordered">
			<thead class="thead-dark">
				<tr>
					<th>Hop</th>
					<th>IP Address</th>
					<th>Loss %</th>
					<th>Last (ms)</th>
					<th>Avg (ms)</th>
					<th>Best (ms)</th>
					<th>Worst (ms)</th>
					<th>Std Dev (ms)</th>
				</tr>
			</thead>
			<tbody id="hopsTableBody">
			</tbody>
		</table>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="mtrtraceroute">MTR Traceroute Tool</h2>

<p><strong>MTR (My TraceRoute)</strong> is a powerful network diagnostic tool that combines the functionality of traceroute and ping. It provides continuous monitoring of network paths, helping identify network issues, latency problems, and packet loss between your location and target destinations.</p>

<p>MTR is particularly useful for:</p>
<ul>
	<li><strong><em>Network troubleshooting and diagnostics</em></strong></li>
	<li><strong><em>Identifying network bottlenecks and congestion</em></strong></li>
	<li><strong><em>Monitoring network performance over time</em></strong></li>
	<li><strong><em>ISP and network provider analysis</em></strong></li>
</ul>

<hr>

<h2 class="mt-4" id="howitworks">How It Works</h2>

<p>MTR works by sending packets with incrementally increasing TTL (Time To Live) values:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Step</th>
		<th>Description</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>Packet Generation</strong></td>
		<td>Sends multiple packets to each hop with configurable intervals</td>
	</tr>
	<tr>
		<td><strong>TTL Increment</strong></td>
		<td>Each hop decrements TTL, routers respond when TTL reaches 0</td>
	</tr>
	<tr>
		<td><strong>Response Analysis</strong></td>
		<td>Measures response times and calculates packet loss statistics</td>
	</tr>
	<tr>
		<td><strong>Continuous Monitoring</strong></td>
		<td>Repeats the process to provide real-time network analysis</td>
	</tr>
	</tbody>
</table>

<hr>

<h2 class="mt-4" id="parameters">MTR Parameters</h2>

<div class="row">
	<div class="col-md-6">
		<h5>Mode Options</h5>
		<ul>
			<li><strong>Report Mode:</strong> Single comprehensive report</li>
			<li><strong>TUI Mode:</strong> Text-based user interface with continuous updates</li>
		</ul>
	</div>
	<div class="col-md-6">
		<h5>Performance Tuning</h5>
		<ul>
			<li><strong>Packets:</strong> Number of packets per hop (1-100)</li>
			<li><strong>Interval:</strong> Time between packets (0.1-10 seconds)</li>
			<li><strong>Timeout:</strong> Packet timeout value (0.5-10 seconds)</li>
			<li><strong>Max Hops:</strong> Maximum hops to trace (1-64)</li>
		</ul>
	</div>
</div>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
