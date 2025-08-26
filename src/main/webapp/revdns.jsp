<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Reverse DNS (PTR) Lookup Tool</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="keywords" content="reverse dns, ptr lookup, dns tools, rDNS, hostname lookup" />
	<meta name="description" content="Reverse DNS (PTR) lookup tool. Enter one or more IP addresses to find their hostnames." />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {
			$('#revdnsForm').submit(function(event) {
				event.preventDefault();
				
				var ips = $('#ips').val().trim();
				if (!ips) {
					alert('Please enter one or more IP addresses');
					return;
				}

				$('#error').hide();
				$('#resultsCard').hide();
				$('#resultsBody').empty();
				$('#loading').show();

				$.ajax({
					type: 'GET',
					url: 'RevDnsFunctionality',
					data: { ip: ips },
					dataType: 'json',
					success: function(data) {
						$('#loading').hide();
						renderResults(data);
					},
					error: function(xhr) {
						$('#loading').hide();
						var msg = 'Lookup failed. Please try again.';
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
				var rows = '';
				for (var i = 0; i < data.results.length; i++) {
					var r = data.results[i];
					var hostnames = (r.hostnames && r.hostnames.length) ? r.hostnames.join(', ') : (r.error ? '-' : '');
					var error = r.error ? r.error : '';
					var duration = (typeof r.duration_seconds !== 'undefined') ? r.duration_seconds : '';
					rows += '<tr>'+
						'<td>'+ (r.ip || '') +'</td>'+
						'<td>'+ hostnames +'</td>'+
						'<td>'+ error +'</td>'+
						'<td>'+ duration +'</td>'+
					'</tr>';
				}
				$('#resultsBody').html(rows);
				$('#queryCount').text(data.query_count || data.results.length || 0);
				$('#resultsCard').show();
			}
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Reverse DNS (PTR) Lookup</h1>
<hr>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<form id="revdnsForm" class="form-horizontal" method="GET">
	<div class="form-group">
		<label for="ips"><strong>IP Address(es):</strong></label>
		<textarea class="form-control" id="ips" name="ips" rows="3" placeholder="Enter single IP or comma-separated IPs, e.g. 1.1.1.1 or 1.1.1.1,8.8.8.8" required></textarea>
		<small class="form-text text-muted">Supports IPv4 and comma-separated multiple IPs.</small>
	</div>
	<button type="submit" class="btn btn-primary">Lookup PTR Records</button>
</form>

<hr>

<div id="error" class="alert alert-danger" style="display:none;"></div>

<div class="card" id="resultsCard" style="display:none;">
	<div class="card-header">
		<h6 class="mb-0">Results (<span id="queryCount">0</span> queries)</h6>
	</div>
	<div class="card-body">
		<div class="table-responsive">
			<table class="table table-bordered table-striped">
				<thead class="thead-dark">
				<tr>
					<th>IP</th>
					<th>Hostnames</th>
					<th>Error</th>
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

<h2 class="mt-4">About Reverse DNS</h2>
<p>Reverse DNS (PTR) lookups resolve an IP address to its domain name(s). This is commonly used for logging, diagnostics, and email server validation.</p>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
