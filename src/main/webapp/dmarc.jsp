<!DOCTYPE html>
<html>
<head>

    <title> DMARC record Checker, validate your DMARC record with the DMARC record </title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="online DMARC record Checker, validate your DMARC record with the DMARC record Checker,how to check your DMARC record, DMARC record lookup,DMARC record tester" />
<meta name="keywords" content="DMARC lookup, online dmarc " />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data for SEO -->
<script type="application/ld+json">
{
	"@context": "https://schema.org",
	"@type": "WebApplication",
	"name": "DMARC Record Lookup Tool",
	"description": "Online DMARC record lookup tool to find and analyze DMARC policies for domains. Check email authentication policies and DMARC configuration.",
	"url": "https://8gwifi.org/dmarc.jsp",
	"applicationCategory": "NetworkTool",
	"operatingSystem": "Web Browser",
	"browserRequirements": "Requires JavaScript. Requires HTML5.",
	"featureList": [
		"DMARC record lookup",
		"Email authentication policy",
		"Policy analysis",
		"Reporting configuration",
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
	"keywords": "dmarc lookup, dmarc record, email authentication, dmarc policy, email security, domain authentication, network tools",
	"about": {
		"@type": "Thing",
		"name": "Email Security",
		"description": "DMARC (Domain-based Message Authentication, Reporting & Conformance) is an email authentication protocol that helps prevent email spoofing and phishing."
	},
	"audience": {
		"@type": "Audience",
		"audienceType": "Email Administrators, Security Professionals, Domain Owners, IT Professionals"
	}
}
</script>
<script type="text/javascript">
        $(document).ready(function() {
            $('#executeMethod').click(function (event)
            {
 			$('#form').delay(200).submit()
            });
                    
            $('#form').submit(function (event)
                    {
                    //	
                  $('#output').html('<img src="images/712.GIF"> loading...');
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "NetworkFunctionality", //this is my servlet
                
                           data: $("#form").serialize(),
                            success: function(msg){    
                            		    $('#output').empty();
                                     $('#output').append(msg);
                                     
                            }
                        }); 
                    });
        });
   
    </script>
</head>
<%@ include file="body-script.jsp"%>

<!-- Compact Network Tools Navigation Bar -->
<%@ include file="network-tools-navbar.jsp"%>

<h1 class="mt-4">DMARC Lookup</h1>
<p>DMARC Lookup will list DMARC records for a domain, DMARC, which stands for Domain-based Message Authentication, Reporting & Conformance, is an email authentication, policy, and reporting protocol</p>
<hr>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>

	<form id="form" method="POST">
		<input type="hidden" name="methodName" id="methodName" value="NETWORKDNSCOMMANDDMARC">
		<input type="hidden" name="getClientIpAddr" id="methodName" value="true">
		 <div class="form-group">
			<input id="ipaddress" class="form-control" type="text" name="ipaddress" value="google.com" size="60">
			</div>
            <input type="button" id="executeMethod" name="DMARC Lookup"
				value="DMARC Lookup" class="btn btn-primary" size="200"> <br>
		<div id="output"></div>
	</form>
<div id="output"></div>

<hr>
<h2 class="mt-4">Try Other Convertor</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="dns.jsp">DNS Lookup</a></li>
        </ul>
    </div>
</div>

<hr>
<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="addcomments.jsp"%>
<hr>
<%@ include file="footer_adsense.jsp"%>

<h3 class="code-line" data-line-start=0 data-line-end=1><a id="About_DMARC_0"></a>About DMARC</h3>
<p class="has-line-data" data-line-start="2" data-line-end="3">DMARC has the following high-level goals:</p>
<ul>
<li class="has-line-data" data-line-start="4" data-line-end="5">Allow Domain Owners to assert the preferred handling of authentication failures, for messages purporting to have authorship within the domain</li>
<li class="has-line-data" data-line-start="5" data-line-end="6">Allow Domain Owners to verify their authentication deployment.</li>
<li class="has-line-data" data-line-start="6" data-line-end="8">Reduce the amount of successfully delivered spoofed email.</li>
</ul>
<p class="has-line-data" data-line-start="8" data-line-end="9">DMARC policies are published by the Domain Owner, and retrieved by the Mail Receiver during the SMTP session, via the DNS. DMARC does not attempt to solve all problems with spoofed or otherwise fraudulent email.</p>
<p class="has-line-data" data-line-start="10" data-line-end="11">A DMARC record is the record where the DMARC rulesets are defined. DMARC records follow the extensible <code>tag-value</code> syntax for DNS-based key records defined in DKIM. The DMARC record contains the policy. The DMARC record should be placed in your DNS. The <code>TXT</code> record name should be "<code>_dmarc.yourdomain.com.</code>" where <code>yourdomain.com</code> is replaced with your actual domain name (or subdomain)</p>
<p class="has-line-data" data-line-start="12" data-line-end="13"><strong>Common tags used in DMARC TXT records:</strong></p>
<table class="table table-striped table-bordered">
<thead>
<tr>
<th>Tag</th>
<th>Purpose</th>
<th>Sample</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>v</strong></td>
<td>Protocol version (<strong>Mandatory</strong>)</td>
<td><code>v=DMARC1</code></td>
</tr>
<tr>
<td><strong>p</strong></td>
<td>Policy for Domain (<strong>Mandatory</strong>)</td>
<td><code>p=quarantine</code></td>
</tr>
<tr>
<td><strong>pct</strong></td>
<td>% of messages subjected to filtering (Optional)</td>
<td><code>pct=20</code></td>
</tr>
<tr>
<td><strong>rua</strong></td>
<td>Reporting URI of aggregate reports (Optional)</td>
<td><code>rua=mailto:[email&#160;protected]</code></td>
</tr>
<tr>
<td><strong>ruf</strong></td>
<td>Reporting URI of forensic Information (Optional)</td>
<td><code>ruf=mailto:[email&#160;protected]</code></td>
</tr>
<tr>
<td><strong>rf</strong></td>
<td>Format to be used for message-specific forensic information reports (optional)</td>
<td><code>rf=afrf</code></td>
</tr>
<tr>
<td><strong>aspf</strong></td>
<td>Alignment mode for SPF (optional)</td>
<td><code>aspf=r</code></td>
</tr>
<tr>
<td><strong>adkim</strong></td>
<td>Alignment mode for DKIM (Optional)</td>
<td><code>adkim=r</code></td>
</tr>
</tbody>
</table>

</div>

<%@ include file="body-close.jsp"%>	