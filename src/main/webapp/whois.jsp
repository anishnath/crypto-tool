<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.net.*,java.util.*,com.google.gson.*"%>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality"%>
<!DOCTYPE html>
<html>
<head>
	<title>WHOIS Lookup Tool - Domain Information Lookup</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="whois lookup, domain lookup, domain information, registrar lookup, domain registration, domain expiry, name servers" />
	<meta name="description" content="Online WHOIS lookup tool to find domain registration information, registrar details, creation dates, expiry dates, and name servers for any domain." />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#whoisForm').submit(function(event) {
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
					url: "WhoisFunctionality",
					data: { domain: domain },
					dataType: 'json',
					success: function(data) {
						$('#loading').hide();
						displayResults(data);
					},
					error: function(xhr, status, error) {
						$('#loading').hide();
						var errorMsg = 'An error occurred while looking up domain information.';
						
						if (xhr.responseJSON && xhr.responseJSON.error) {
							errorMsg = xhr.responseJSON.error;
						} else if (xhr.status === 400) {
							errorMsg = 'Invalid domain format. Please check your input.';
						} else if (xhr.status === 404) {
							errorMsg = 'Domain not found or lookup failed.';
						}
						
						$('#error').text(errorMsg).show();
					}
				});
			});

			function displayResults(data) {
				$('#lookedUpDomain').text(data.domain || 'Unknown');
				$('#registrar').text(data.registrar || 'N/A');
				$('#createdDate').text(formatDate(data.created) || 'N/A');
				$('#updatedDate').text(formatDate(data.updated) || 'N/A');
				$('#expiryDate').text(formatDate(data.expires) || 'N/A');
				$('#domainStatus').text(data.domain_status || 'N/A');
				$('#lookupTime').text(data.lookup_time_seconds || '0');
				$('#lookupStatus').text(data.status || 'Unknown');
				
				// Display name servers
				var nsHtml = '';
				if (data.name_servers && data.name_servers.length > 0) {
					for (var i = 0; i < data.name_servers.length; i++) {
						nsHtml += '<span class="badge badge-info mr-2 mb-2">' + data.name_servers[i] + '</span>';
					}
				} else {
					nsHtml = 'No name servers found';
				}
				$('#nameServers').html(nsHtml);
				
				// Display raw data
				var rawDataHtml = '';
				if (data.raw_data && data.raw_data.length > 0) {
					rawDataHtml = '<table class="table table-sm table-bordered">';
					rawDataHtml += '<thead><tr><th>Field</th><th>Value</th></tr></thead><tbody>';
					for (var i = 0; i < data.raw_data.length; i++) {
						var item = data.raw_data[i];
						rawDataHtml += '<tr><td><strong>' + (item.field || 'Unknown') + '</strong></td>';
						rawDataHtml += '<td>' + (item.value || 'N/A') + '</td></tr>';
					}
					rawDataHtml += '</tbody></table>';
				} else {
					rawDataHtml = 'No raw data available';
				}
				$('#rawData').html(rawDataHtml);
				
				$('#results').show();
			}

			function formatDate(dateString) {
				if (!dateString) return 'N/A';
				try {
					var date = new Date(dateString);
					return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
				} catch (e) {
					return dateString;
				}
			}
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">WHOIS Lookup Tool</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<form id="whoisForm" class="form-horizontal" method="POST">
	<div class="form-group">
		<label for="domain"><strong>Domain Name:</strong></label>
		<div class="input-group">
			<input type="text" class="form-control" id="domain" name="domain" 
				   placeholder="e.g., example.com, google.com, github.com" required>
			<div class="input-group-append">
				<button type="submit" class="btn btn-primary">
					Lookup Domain
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
	<h4>WHOIS Results for: <span id="lookedUpDomain"></span></h4>
	
	<div class="row">
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Domain Information</h6>
				</div>
				<div class="card-body">
					<p><strong>Registrar:</strong> <span id="registrar">N/A</span></p>
					<p><strong>Created:</strong> <span id="createdDate">N/A</span></p>
					<p><strong>Last Updated:</strong> <span id="updatedDate">N/A</span></p>
					<p><strong>Expires:</strong> <span id="expiryDate">N/A</span></p>
					<p><strong>Status:</strong> <span id="domainStatus">N/A</span></p>
				</div>
			</div>
		</div>
		<div class="col-md-6">
			<div class="card">
				<div class="card-header">
					<h6 class="mb-0">Lookup Details</h6>
				</div>
				<div class="card-body">
					<p><strong>Lookup Status:</strong> <span id="lookupStatus">Unknown</span></p>
					<p><strong>Lookup Time:</strong> <span id="lookupTime">0</span> seconds</p>
					<p><strong>Name Servers:</strong></p>
					<div id="nameServers"></div>
				</div>
			</div>
		</div>
	</div>
	
	<h5 class="mt-4">Raw WHOIS Data:</h5>
	<div id="rawData"></div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="whoislookup">WHOIS Lookup</h2>

<p><strong>WHOIS</strong> is a protocol used to query databases that store information about registered domain names, IP addresses, and autonomous systems. This tool provides comprehensive domain information including registration details, registrar information, and technical data.</p>

<p>WHOIS information can reveal:</p>
<ul>
	<li><strong><em>Domain registration and expiry dates</em></strong></li>
	<li><strong><em>Registrar and administrative contact details</em></strong></li>
	<li><strong><em>Name servers and DNS configuration</em></strong></li>
	<li><strong><em>Domain status and transfer restrictions</em></strong></li>
</ul>

<hr>

<h2 class="mt-4" id="domaininformation">Domain Information Fields</h2>

<p>This tool displays the following key information:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Field</th>
		<th>Description</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>Registrar</strong></td>
		<td>The organization that registered the domain</td>
	</tr>
	<tr>
		<td><strong>Created</strong></td>
		<td>Date when the domain was first registered</td>
	</tr>
	<tr>
		<td><strong>Updated</strong></td>
		<td>Date when domain information was last modified</td>
	</tr>
	<tr>
		<td><strong>Expires</strong></td>
		<td>Date when the domain registration expires</td>
	</tr>
	<tr>
		<td><strong>Status</strong></td>
		<td>Current domain status (e.g., active, suspended)</td>
	</tr>
	<tr>
		<td><strong>Name Servers</strong></td>
		<td>DNS servers responsible for the domain</td>
	</tr>
	</tbody>
</table>

<hr>

<h2 class="mt-4" id="commonstatuses">Common Domain Statuses</h2>

<p>Domain status codes indicate the current state of a domain:</p>

<table id="tablePreview" class="table table-bordered">
	<thead>
	<tr>
		<th>Status</th>
		<th>Meaning</th>
	</tr>
	</thead>
	<tbody>
	<tr>
		<td><strong>clientTransferProhibited</strong></td>
		<td>Domain transfer is blocked by the registrant</td>
	</tr>
	<tr>
		<td><strong>clientUpdateProhibited</strong></td>
		<td>Domain information updates are blocked</td>
	</tr>
	<tr>
		<td><strong>clientDeleteProhibited</strong></td>
		<td>Domain deletion is blocked</td>
	</tr>
	<tr>
		<td><strong>serverTransferProhibited</strong></td>
		<td>Domain transfer is blocked by the registrar</td>
	</tr>
	<tr>
		<td><strong>pendingDelete</strong></td>
		<td>Domain is scheduled for deletion</td>
	</tr>
	<tr>
		<td><strong>redemptionPeriod</strong></td>
		<td>Domain is in grace period after expiry</td>
	</tr>
	</tbody>
</table>

<hr>

<h2 class="mt-4" id="privacy">Privacy and WHOIS</h2>

<p>Many domain registrars offer WHOIS privacy services that hide personal contact information from public WHOIS queries. This is common for personal domains and businesses that want to protect their privacy.</p>

<p>When WHOIS privacy is enabled, you may see:</p>
<ul>
	<li><strong><em>Generic registrar contact information</em></strong></li>
	<li><strong><em>Privacy protection service details</em></strong></li>
	<li><strong><em>Masked email addresses and phone numbers</em></strong></li>
</ul>

<hr>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
