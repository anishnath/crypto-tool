<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*,java.util.*,com.google.gson.*"%>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality"%>
<!DOCTYPE html>
<html>
<head>
	<title>Subdomain Enumeration Tool - Online Subdomain Finder</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="subdomain enumeration, subdomain finder, online subdomain tool, domain enumeration, subdomain discovery" />
	<meta name="description" content="Online subdomain enumeration tool to discover subdomains for any domain. Find all subdomains using various sources like certificate transparency logs." />
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
		"name": "Subdomain Enumeration Tool",
		"description": "Online subdomain enumeration tool to discover subdomains for any domain. Find all subdomains using various sources like certificate transparency logs.",
		"url": "https://8gwifi.org/subdomain.jsp",
		"applicationCategory": "NetworkTool",
		"operatingSystem": "Web Browser",
		"browserRequirements": "Requires JavaScript. Requires HTML5.",
		"featureList": [
			"Subdomain discovery",
			"Certificate transparency log scanning",
			"Multiple source enumeration",
			"Real-time results",
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
		"keywords": "subdomain enumeration, subdomain finder, online subdomain tool, domain enumeration, subdomain discovery, certificate transparency, network reconnaissance",
		"about": {
			"@type": "Thing",
			"name": "Network Security",
			"description": "Subdomain enumeration is a technique used to discover subdomains of a target domain for security research and network administration."
		},
		"audience": {
			"@type": "Audience",
			"audienceType": "Security Researchers, Network Administrators, Penetration Testers"
		}
	}
	</script>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#subdomainForm').submit(function(event) {
				event.preventDefault();
				
				var domain = $('#domain').val().trim();
				if (!domain) {
					alert('Please enter a domain name');
					return;
				}

				// Show loading
				$('#loading').show();
				$('#results').hide();
				$('#error').hide();

				// Make AJAX call to the servlet
				$.ajax({
					type: "GET",
					url: "SubdomainFunctionality",
					data: { domain: domain },
					dataType: 'json',
					success: function(data) {
						$('#loading').hide();
						displayResults(data);
					},
					error: function(xhr, status, error) {
						$('#loading').hide();
						var errorMsg = 'An error occurred while fetching subdomains.';
						
						if (xhr.responseJSON && xhr.responseJSON.error) {
							errorMsg = xhr.responseJSON.error;
						} else if (xhr.status === 400) {
							errorMsg = 'Invalid domain format. Please check your input.';
						} else if (xhr.status === 404) {
							errorMsg = 'No subdomains found for this domain.';
						}
						
						$('#error').text(errorMsg).show();
					}
				});
			});

			function displayResults(data) {
				$('#searchedDomain').text(data.domain);
				$('#totalCount').text(data.count);
				$('#searchTime').text(data.time_seconds);
				
				// Display sources
				var sources = [];
				for (var i = 0; i < data.subdomains.length; i++) {
					if (sources.indexOf(data.subdomains[i].source) === -1) {
						sources.push(data.subdomains[i].source);
					}
				}
				var sourcesHtml = '';
				for (var i = 0; i < sources.length; i++) {
					sourcesHtml += '<span class="badge badge-info mr-2">' + sources[i] + '</span>';
				}
				$('#sourcesList').html(sourcesHtml);
				
				// Display subdomains
				var subdomainsHtml = '';
				for (var i = 0; i < data.subdomains.length; i++) {
					var subdomain = data.subdomains[i];
					subdomainsHtml += '<div class="subdomain-item">';
					subdomainsHtml += '<div class="d-flex justify-content-between align-items-center">';
					subdomainsHtml += '<span class="subdomain-host">' + subdomain.host + '</span>';
					subdomainsHtml += '<span class="subdomain-source">' + subdomain.source + '</span>';
					subdomainsHtml += '</div>';
					subdomainsHtml += '</div>';
				}
				$('#subdomainsList').html(subdomainsHtml);
				
				$('#results').show();
			}
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">Subdomain Enumeration Tool</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<form id="subdomainForm" class="form-horizontal" method="POST">
	<div class="form-group">
		<label for="domain"><strong>Domain Name:</strong></label>
		<div class="input-group">
			<input type="text" class="form-control" id="domain" name="domain" 
				   placeholder="e.g., pipedream.in" required>
			<div class="input-group-append">
				<button type="submit" class="btn btn-primary">
					Find Subdomains
				</button>
			</div>
		</div>
		<small class="form-text text-muted">
			Enter a domain name without protocol (http/https)
		</small>
	</div>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display: none;"></div>

<div id="results" style="display: none;">
	<h4>Results for: <span id="searchedDomain"></span></h4>
	
	<div class="row">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Summary</h6>
				</div>
				<div class="card-body">
					<p><strong>Total Subdomains:</strong> <span id="totalCount">0</span></p>
					<p><strong>Search Time:</strong> <span id="searchTime">0</span> seconds</p>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Sources</h6>
				</div>
				<div class="card-body">
					<div id="sourcesList"></div>
				</div>
			</div>
		</div>
	</div>
	
	<h5 class="mt-4">Subdomains Found:</h5>
	<div id="subdomainsList"></div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="subdomainenumeration">Subdomain Enumeration</h2>

<p><strong>Subdomain enumeration</strong> is a technique used to discover subdomains of a target domain. This tool helps security researchers, penetration testers, and network administrators identify potential entry points and attack surfaces.</p>

<p>Subdomains can reveal:</p>
<ul>
	<li><strong><em>Development and staging environments</em></strong></li>
	<li><strong><em>Internal services and applications</em></strong></li>
	<li><strong><em>Third-party integrations and APIs</em></strong></li>
	<li><strong><em>Forgotten or abandoned services</em></strong></li>
</ul>

<hr>

<h2 class="mt-4" id="howitworks">How It Works</h2>

<p>This tool queries various sources to discover subdomains:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Source</th>
		<th>Description</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>Certificate Transparency Logs</strong></td>
		<td>SSL/TLS certificates often contain subdomain information</td>
	</tr>
	<tr>
		<td><strong>DNS Records</strong></td>
		<td>Active DNS records and zone transfers</td>
	</tr>
	<tr>
		<td><strong>Search Engines</strong></td>
		<td>Indexed subdomains from web crawlers</td>
	</tr>
	</tbody>
</table>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
