<!DOCTYPE html>
<html>
<head>
<title>Online Website IPv6 accessibility Test and DNS Query</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Online check if a host or IP (Ipv4/IPv6) is reachable from the internet  Tests for DNS AAAA records, IPv6-addressable nameservers, glue, IPv6 connectivity (port 80), and several other elements. Trace the IP address Location" />
<meta name="keywords" content="IP, IPv6, website ipv6 test,DNS,AAAA record, ipv6 web test,DNS Testing, ICMP,ICMPv6,dns query online,ip address, location, geolocation,IP Address Lookup, IP Locator, IP Address Locator, IP Location, IP Lookup " />
<%@ include file="include_css.jsp" %>

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
<body>
<div id="page">
<%@ include file="include.jsp" %> 
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<article id="contentWrapper" role="main">
			<section id="content">
	<form id="form" method="POST">

		<input type="hidden" name="methodName" id="methodName" value="NETWORKCURLCOMMAND">
		<input type="hidden" name="getClientIpAddr" id="methodName" value="true">
		<fieldset name="Ping v4/v6 Address Online ">
			<legend>
				<B>Website IPv6 accessibility</B>
			</legend>
			WebSite Test(Ipv6/Ipv4)
            Scheme<select name="scheme" id="scheme">
            <option value="https">https</option>
            <option value="http">http</option>
            </select>
            <input id="ipaddress" type="text" name="ipaddress" value="ipv6.google.com" size="60">
            <input id="port" type="text" name="port" value="443" size="10">
            <input type="button" id="executeMethod" name="ping"
				value="Submit" size="200"> <br>
            <div class="g-recaptcha" data-sitekey="6LcmQzcUAAAAAITMYW2Iavbh7Y70Z1PM33ClDUkI"></div>
		</fieldset>
		<div id="output"></div>
	</form>
                <br/>
                <br/>
	<%@ include file="footer.jsp"%>
                <br/>
                <br/>

		</section>
		</article>
		
	</div>
</body>
</html>