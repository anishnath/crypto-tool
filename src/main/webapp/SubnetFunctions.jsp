<!DOCTYPE html>
<html>
<head>

<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<title>Online Subnet Calculator</title>
<meta name="description" content="Online Subnet calculator generate IP range from the given subnet mask, cidr calculator of the rfc defined networks " />
<meta name="keywords" content="Online IP Subnet Calculator, IP Subnet Calculator, Subnet Calculator, subnet mask, free, IP, Subnet, Calculator, supernet, cidr, subnetting, supernetting, network" />

<meta name="robots" content="index,follow" />
<meta name="googlebot" content="index,follow" />
<meta name="resource-type" content="document" />
<meta name="classification" content="tools" />
<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<%@ include file="include_css.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {


		$('#ctrTitles').change(function() {
			   pem = $(this).val();
			   $("#pem").val(pem);    
			});
		

		$('#submit').click(function(event) {
			$('#form').delay(200).submit()
		});

		$('#form').submit(function(event) {
			//	
			$('#output1').html('<img src="images/712.GIF"> loading...');
			event.preventDefault();
			$.ajax({
				type : "POST",
				url : "SubnetFunctionality", //this is my servlet

				data : $("#form").serialize(),
				success : function(msg) {
					$('#output').empty();
					$('#output1').empty();
					$('#output').append(msg);

				}
			});
		});
	});
</script>
</head>
<body>

	<div id="page">
	<%@ include file="include.jsp"%>
<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	
<article id="contentWrapper" role="main">
			<section id="content">
	<form id="form" method="POST">
		<input type="hidden" name="methodName" id="methodName"
			value="SUBNETCOMMAND">
			<fieldset name="Group1">
                <legend>Subnet Calculator</legend>
                
<table>
<tr>
<td colspan="5">
	<pre class="newpage">The number of available network and host addresses are derived from the number of bits used for subnet masking<br /><br /><strong>A broadcast address</strong> is a logical address at which all devices connected to a multiple-access communications network are enabled to receive datagrams. <br />A message sent to a broadcast address is typically received by all network-attached hosts, rather than by a specific host<br /><br /><strong>CIDR notation</strong> is a compact representation of an IP address and its associated routing prefix.<br /><br />
		</pre>

</td>
</tr>
<tr>

<th align="RIGHT" nowrap> &nbsp;Give Subnet (CIDR) </th>
<td><input type="text" name="subnet" placeholder="192.168.1.23/34"  size="70" maxlength="64" />Example : 192.168.2.10/28</td>
<tr>
<tr>
<th align="RIGHT" nowrap>&nbsp;Return Number of IP Address  : </th>
<td>
	<input  type="radio" id="encoding" name="encoding" value="Y">Include IP Address
	<input checked="checked" type="radio" id="encoding1" name="encoding" value="N">Exclude IP Address
</td>

</tr>
<tr>
<td>
</td>
</tr>
<tr>


</tr>

<tr>
<td align="right">
<input type="submit" id="submit" name="Get Subnet Information">
<div id="output1"></div>
</td>
</tr>
<tr>
<td>Output
			</td>
			<td>
			
			<textarea rows="20" cols="80" id="output"></textarea>
			</td>
			</tr>
			
</table>
            </fieldset>
	</form>

				<%@ include file="footer.jsp"%>

				<p>For example A /24 network may be divided into the following subnets by increasing the subnet mask successively by one bit. This affects the total number of hosts that can be addressed in the /24 network</p>
				<table class="8gwifi" border="1">
					<tbody>
					<tr>
						<th>Prefix size</th>
						<th>Subnet mask</th>
						<th>Available<br />subnets</th>
						<th>Usable hosts<br />per subnet</th>
						<th>Total<br />usable hosts</th>
					</tr>
					<tr>
						<td>/24</td>
						<td><code>255.255.255.0</code></td>
						<td>1</td>
						<td>254</td>
						<td>254</td>
					</tr>
					<tr>
						<td>/25</td>
						<td><code>255.255.255.128</code></td>
						<td>2</td>
						<td>126</td>
						<td>252</td>
					</tr>
					<tr>
						<td>/26</td>
						<td><code>255.255.255.192</code></td>
						<td>4</td>
						<td>62</td>
						<td>248</td>
					</tr>
					<tr>
						<td>/27</td>
						<td><code>255.255.255.224</code></td>
						<td>8</td>
						<td>30</td>
						<td>240</td>
					</tr>
					<tr>
						<td>/28</td>
						<td><code>255.255.255.240</code></td>
						<td>16</td>
						<td>14</td>
						<td>224</td>
					</tr>
					<tr>
						<td>/29</td>
						<td><code>255.255.255.248</code></td>
						<td>32</td>
						<td>6</td>
						<td>192</td>
					</tr>
					<tr>
						<td>/30</td>
						<td><code>255.255.255.252</code></td>
						<td>64</td>
						<td>2</td>
						<td>128</td>
					</tr>
					<tr>
						<td>/31</td>
						<td><code>255.255.255.254</code></td>
						<td>128</td>
						<td>2&nbsp;<sup>*</sup></td>
					</tr>
					</tbody>
				</table>
				<p>&nbsp;</p>

				<p>The following special addresses and networks exist in IPv4:</p>
				<table border="1" frame="1">
					<tbody>
					<tr>
						<td>0.0.0.0</td>
						<td>the "ANY" address that is used by programs to speak to all network interfaces, it is never used directly. The whole network 0.*.*.* is reserved for special purposes (like DHCP).</td>
					</tr>
					<tr>
						<td>10.*.*.*<br />172.16.*.*&nbsp;-&nbsp;172.31.*.*<br />192.168.*.*</td>
						<td>RFC Definend private address</td>
					</tr>
					<tr>
						<td>127.0.0.1</td>
						<td>is the localhost address The entire 127.*.*.* network is reserved for (host-)local networking.</td>
					</tr>
					<tr>
						<td>169.254.*.*</td>
						<td>Link-Local addresses. These are automatically generated by some operating systems and (e.g. MacOS and Linux with Avahi installed) and are only usable for local communication in the LAN segment.</td>
					</tr>
					<tr>
						<td>198.18.*.*&nbsp;-&nbsp;198.19.*.*</td>
						<td>Network benchmark tests, this should never be used in production networks.</td>
					</tr>
					<tr>
						<td>198.51.100.*<br />203.0.113.*</td>
						<td>TEST-NET-2, Documentation and examples<br />TEST-NET-3, Documentation and examples</td>
					</tr>
					<tr>
						<td>224.*.*.*</td>
						<td>Multicasts (former Class D network) - e.g. there is no default gateway or broadcast for multicasting</td>
					</tr>
					<tr>
						<td>240.0.0.0/4</td>
						<td>Reserved (former Class E network)</td>
					</tr>
					<tr>
						<td>255.255.255.255</td>
						<td>Link Broadcast - this is sent to all hosts on the same network link, but does not cross routers</td>
					</tr>
					</tbody>
				</table>

<%@ include file="include_security_links.jsp"%>

</section>
		</article>
		
	</div>
</body>
</html>