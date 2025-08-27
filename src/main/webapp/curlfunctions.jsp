<!DOCTYPE html>
<html>
<head>

<title>Online Website IPv6 accessibility Test and DNS Query</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Online check if a host or IP (Ipv4/IPv6) is reachable from the internet  Tests for DNS AAAA records, IPv6-addressable nameservers, glue, IPv6 connectivity (port 80), and several other elements. Trace the IP address Location, curl online" />
<meta name="keywords" content="curl online, curl ipv6 online, dns Query Online,IP, IPv6, website ipv6 test,DNS,AAAA record, ipv6 web test,DNS Testing, ICMP,ICMPv6,dns query online,ip address, location, geolocation,IP Address Lookup, IP Locator, IP Address Locator, IP Location, IP Lookup, online curl " />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="header-script.jsp"%>

<!-- JSON-LD Structured Data for SEO -->
<script type="application/ld+json">
{
	"@context": "https://schema.org",
	"@type": "WebApplication",
	"name": "Curl IPv4/IPv6 Tool",
	"description": "Online curl tool to test website accessibility over IPv4 and IPv6. Check DNS AAAA records, IPv6 connectivity, and website reachability.",
	"url": "https://8gwifi.org/curlfunctions.jsp",
    "image" : "https://github.com/anishnath/crypto-tool/blob/master/curl.png",
	"applicationCategory": "NetworkTool",
	"operatingSystem": "Web Browser",
	"browserRequirements": "Requires JavaScript. Requires HTML5.",
	"featureList": [
		"IPv4/IPv6 connectivity test",
		"Website accessibility testing",
		"DNS AAAA record checking",
		"Port testing",
		"Protocol testing (HTTP/HTTPS)"
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
	"keywords": "curl tool, ipv6 test, website accessibility, dns aaaa, ipv6 connectivity, network tools, curl online",
	"about": {
		"@type": "Thing",
		"name": "Website Accessibility",
		"description": "Curl tools test website accessibility by simulating HTTP requests and checking connectivity over different IP protocols and ports."
	},
	"audience": {
		"@type": "Audience",
		"audienceType": "Web Developers, Network Administrators, System Administrators, IT Professionals"
	}
}
</script>
<script src='https://www.google.com/recaptcha/api.js'></script>
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

<%@ include file="footer_adsense.jsp"%>

<h1 class="mt-4">Website IPv6/Ipv4 accessibility</h1>
<hr>

	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>

	<form id="form" method="POST">

		<input type="hidden" name="methodName" id="methodName" value="NETWORKCURLCOMMAND">
		<input type="hidden" name="getClientIpAddr" id="methodName" value="true">
		
		<div class="form-group row">
    <label for="colFormLabelSm" class="col-sm-2 col-form-label col-form-label-lg">Scheme</label>
    <div class="col-sm-2">
      <select class="custom-select" name="scheme" id="scheme">
            <option value="https">https</option>
            <option value="http">http</option>
            </select>
    </div>
  </div>
  <div class="form-group row">
    <label for="colFormLabel" class="col-sm-2 col-form-label-lg">URL</label>
    <div class="col-sm-10">
     <input id="ipaddress" class="form-control"  type="text" name="ipaddress" value="ipv6.google.com" size="60">
    </div>
  </div>
  <div class="form-group row">
    <label for="colFormLabelLg" class="col-sm-2 col-form-label col-form-label-lg">PORT</label>
    <div class="col-sm-10">
      <input id="port" oninput="this.value=this.value.replace(/[^0-9]/g,'');" class="form-control" type="text" name="port" value="443" size="10">
    </div>
  </div>
		
<!-- <div class="g-recaptcha" data-sitekey="6LcmQzcUAAAAAITMYW2Iavbh7Y70Z1PM33ClDUkI"></div> -->
<input type="button"  class="btn btn-primary" id="executeMethod" name="ping" value="Submit" size="200"> <br>
</form>
	
<div id="output"></div>
<hr>
<%@ include file="footer_adsense.jsp"%>

<div id="output"></div>

<hr>



<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>