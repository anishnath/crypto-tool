<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>DNS Resolver Tool</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="dns resolver, dns lookup, mx records, ns records, txt records, a records, aaaa records" />
	<meta name="description" content="DNS resolver tool. Lookup A, AAAA, MX, NS, TXT, and CNAME records using multiple DNS resolvers." />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#dnsForm').submit(function(event) {
				event.preventDefault();
				
				var name = $('#name').val().trim();
				if (!name) {
					alert('Please enter a domain name');
					return;
				}

				$('#error').hide();
				$('#resultsCard').hide();
				$('#resultsBody').empty();
				$('#loading').show();

				var data = {
					name: name,
					type: $('#type').val(),
					resolvers: $('#resolvers').val().trim()
				};

				$.ajax({
					type: 'GET',
					url: 'DnsResolverFunctionality',
					data: data,
					dataType: 'json',
					success: function(response) {
						$('#loading').hide();
						renderResults(response);
					},
					error: function(xhr) {
						$('#loading').hide();
						var msg = 'DNS lookup failed. Please try again.';
						if (xhr.responseJSON && xhr.responseJSON.error) {
							msg = xhr.responseJSON.error;
						}
						$('#error').text(msg).show();
					}
				});
			});

			function renderResults(data) {
				if (!data || !data.results) {
					$('#error').text('Empty response received.').show();
					return;
				}

				// Display summary info
				$('#queryName').text(data.name || '');
				$('#recordType').text(data.record_type || '');
				$('#queriedAt').text(data.queried_at || '');
				$('#consensus').text(data.consensus ? 'Yes' : 'No');
				$('#uniqueAnswers').text(data.unique_answer_sets || 0);

				// Render results table
				var rows = '';
				for (var i = 0; i < data.results.length; i++) {
					var r = data.results[i];
					var answers = (r.answers && r.answers.length) ? r.answers.join(', ') : '';
					var duration = (typeof r.duration_seconds !== 'undefined') ? r.duration_seconds.toFixed(3) : '';
					
					rows += '<tr>'+
						'<td>'+ (r.resolver_ip || '') +'</td>'+
						'<td>'+ (r.provider || '') +'</td>'+
						'<td>'+ (r.record_type || '') +'</td>'+
						'<td>'+ answers +'</td>'+
						'<td>'+ duration +'</td>'+
					'</tr>';
				}
				$('#resultsBody').html(rows);
				$('#resultsCard').show();
			}

			// Predefined resolver options
			$('#resolverPresets').change(function() {
				var preset = $(this).val();
				switch(preset) {
					case 'cloudflare':
						$('#resolvers').val('1.1.1.1,1.0.0.1');
						break;
					case 'google':
						$('#resolvers').val('8.8.8.8,8.8.4.4');
						break;
					case 'quad9':
						$('#resolvers').val('9.9.9.9,149.112.112.112');
						break;
					case 'opendns':
						$('#resolvers').val('208.67.222.222,208.67.220.220');
						break;
					case 'adguard':
						$('#resolvers').val('94.140.14.14');
						break;
					case 'controld':
						$('#resolvers').val('76.76.2.0');
						break;
					case 'all':
						$('#resolvers').val('1.1.1.1,8.8.8.8,9.9.9.9,208.67.222.222,94.140.14.14,76.76.2.0');
						break;
					case 'custom':
						$('#resolvers').val('').focus();
						break;
				}
			});
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">DNS Resolver Tool</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<form id="dnsForm" class="form-horizontal" method="GET">
	<div class="form-group">
		<label for="name"><strong>Domain Name:</strong></label>
		<input type="text" class="form-control" id="name" name="name" placeholder="Enter domain name, e.g. example.com" required>
	</div>
	
	<div class="form-group">
		<label for="type"><strong>Record Type:</strong></label>
		<select class="form-control" id="type" name="type">
			<option value="A">A (IPv4 Address)</option>
			<option value="AAAA">AAAA (IPv6 Address)</option>
			<option value="MX">MX (Mail Exchange)</option>
			<option value="NS">NS (Name Server)</option>
			<option value="TXT">TXT (Text Record)</option>
			<option value="CNAME">CNAME (Canonical Name)</option>
		</select>
	</div>
	
	<div class="form-group">
		<label for="resolverPresets"><strong>Resolver Presets:</strong></label>
		<select class="form-control" id="resolverPresets">
			<option value="all">All Resolvers (Default)</option>
			<option value="cloudflare">Cloudflare (1.1.1.1, 1.0.0.1)</option>
			<option value="google">Google (8.8.8.8, 8.8.4.4)</option>
			<option value="quad9">Quad9 (9.9.9.9, 149.112.112.112)</option>
			<option value="opendns">OpenDNS (208.67.222.222, 208.67.220.220)</option>
			<option value="adguard">AdGuard (94.140.14.14)</option>
			<option value="controld">ControlD (76.76.2.0)</option>
			<option value="custom">Custom IPs</option>
		</select>
	</div>
	
	<div class="form-group">
		<label for="resolvers"><strong>Custom Resolvers (Optional):</strong></label>
		<input type="text" class="form-control" id="resolvers" name="resolvers" placeholder="Comma-separated IPs, e.g. 1.1.1.1,8.8.8.8">
		<small class="form-text text-muted">Leave empty to use default resolver pool. Use presets above for quick selection.</small>
	</div>
	
	<button type="submit" class="btn btn-primary">Resolve DNS</button>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display:none;"></div>

<div class="card" id="resultsCard" style="display:none;">
	<div class="card-header">
		<h6 class="mb-0">DNS Resolution Results</h6>
	</div>
	<div class="card-body">
		<div class="row mb-3">
			<div class="col-md-3">
				<strong>Domain:</strong> <span id="queryName"></span>
			</div>
			<div class="col-md-3">
				<strong>Record Type:</strong> <span id="recordType"></span>
			</div>
			<div class="col-md-3">
				<strong>Queried At:</strong> <span id="queriedAt"></span>
			</div>
			<div class="col-md-3">
				<strong>Consensus:</strong> <span id="consensus"></span>
			</div>
		</div>
		<div class="row mb-3">
			<div class="col-md-3">
				<strong>Unique Answer Sets:</strong> <span id="uniqueAnswers"></span>
			</div>
		</div>
		
		<h6>Resolver Results:</h6>
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead class="thead-dark">
				<tr>
					<th>Resolver IP</th>
					<th>Provider</th>
					<th>Record Type</th>
					<th>Answers</th>
					<th>Duration (s)</th>
				</tr>
				</thead>
				<tbody id="resultsBody"></tbody>
			</table>
		</div>
	</div>
</div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4">About DNS Resolution</h2>
<p>DNS resolution converts domain names to IP addresses and other record types. This tool queries multiple DNS resolvers to provide redundancy and compare results across different providers.</p>

<h3>Record Types:</h3>
<ul>
	<li><strong>A:</strong> IPv4 address records</li>
	<li><strong>AAAA:</strong> IPv6 address records</li>
	<li><strong>MX:</strong> Mail exchange server records</li>
	<li><strong>NS:</strong> Name server records</li>
	<li><strong>TXT:</strong> Text records (often used for SPF, DKIM)</li>
	<li><strong>CNAME:</strong> Canonical name (alias) records</li>
</ul>

<h3>Default Resolvers:</h3>
<ul>
	<li><strong>Cloudflare:</strong> 1.1.1.1, 1.0.0.1</li>
	<li><strong>Google:</strong> 8.8.8.8, 8.8.4.4</li>
	<li><strong>Quad9:</strong> 9.9.9.9, 149.112.112.112</li>
	<li><strong>OpenDNS:</strong> 208.67.222.222, 208.67.220.220</li>
	<li><strong>AdGuard:</strong> 94.140.14.14</li>
	<li><strong>ControlD:</strong> 76.76.2.0</li>
</ul>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
