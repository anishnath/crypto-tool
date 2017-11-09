<!DOCTYPE html>
<html>
<head>
<title>Online Ping Ipv4/IpV6 Address Online</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Online IPv6 Ping Tool, check if a host or IP (IPv6) is reachable from the internet " />
<meta name="keywords" content="IP, IPv6, IPNG, online ping, ttl, test, check, packet, echo, lag, host, count, ttl, mtu,icmp,icmpv6,ping6" />
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
		<input type="hidden" name="methodName" id="methodName" value="NETWORKPINGCOMMAND">
		<input type="hidden" name="getClientIpAddr" id="methodName" value="true">
		<fieldset name="Ping v4/v6 Address Online ">
			<legend>
				<B>Online Ping IPv4/IPv6 Address </B>
			</legend>
			Give an Ipv4 or Ipv6 Address<input id="ipaddress" type="text" name="ipaddress" value="ipv6.google.com" size="60">
            <input type="button" id="executeMethod" name="ping"
				value="Click Ping" size="200"> <br>
            <div class="g-recaptcha" data-sitekey="6LcmQzcUAAAAAITMYW2Iavbh7Y70Z1PM33ClDUkI"></div>
		</fieldset>
		<div id="output"></div>
	</form>
                <br/>
                <br/>

                <br/>
                <br/>
                <p>Examples of IP addresses and their byte representations:</p>

                <%@ include file="footer.jsp"%>

                <ul>
                    <li>The IPv4 loopback address,&nbsp;<code>"127.0.0.1"</code>.<br /><code>7f 00 00 01</code></li>
                    <li>The IPv6 loopback address,&nbsp;<code>"::1"</code>.<br /><code>00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01</code></li>
                    <li>From the IPv6 reserved documentation prefix (<code>2001:db8::/32</code>),&nbsp;<code>"2001:db8::1"</code>.<br /><code>20 01 0d b8 00 00 00 00 00 00 00 00 00 00 00 01</code></li>
                    <li>An IPv6 "IPv4 compatible" (or "compat") address,&nbsp;<code>"::192.168.0.1"</code>.<br /><code>00 00 00 00 00 00 00 00 00 00 00 00 c0 a8 00 01</code></li>
                    <li>An IPv6 "IPv4 mapped" address,&nbsp;<code>"::ffff:192.168.0.1"</code>.<br /><code>00 00 00 00 00 00 00 00 00 00 ff ff c0 a8 00 01</code></li>
                    <li><code></code><code></code></li>
                </ul>
                <p>The related ping utility is implemented using the ICMP echo request and echo reply messages, other ICMP Message and Type for Refrences</p>
                <table id="table-icmp-parameters-types" class="sortable">
                    <thead>
                    <tr style="height: 18px;">
                        <th style="height: 18px;">Type&nbsp;</th>
                        <th style="height: 18px;">Name&nbsp;</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center"><strong>0</strong></td>
                        <td style="height: 18px;"><strong>Echo Reply</strong></td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">1</td>
                        <td style="height: 18px;">Unassigned</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">2</td>
                        <td style="height: 18px;">Unassigned</td>
                    </tr>
                    <tr style="height: 20.8438px;">
                        <td style="height: 20.8438px;" align="center">3</td>
                        <td style="height: 20.8438px;">Destination Unreachable</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">4</td>
                        <td style="height: 18px;">Source Quench (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">5</td>
                        <td style="height: 18px;">Redirect</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">6</td>
                        <td style="height: 18px;">Alternate Host Address (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">7</td>
                        <td style="height: 18px;">Unassigned</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">8</td>
                        <td style="height: 18px;">Echo</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">9</td>
                        <td style="height: 18px;">Router Advertisement</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">10</td>
                        <td style="height: 18px;">Router Solicitation</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">11</td>
                        <td style="height: 18px;">Time Exceeded</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">12</td>
                        <td style="height: 18px;">Parameter Problem</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">13</td>
                        <td style="height: 18px;">Timestamp</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">14</td>
                        <td style="height: 18px;">Timestamp Reply</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">15</td>
                        <td style="height: 18px;">Information Request (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">16</td>
                        <td style="height: 18px;">Information Reply (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">17</td>
                        <td style="height: 18px;">Address Mask Request (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">18</td>
                        <td style="height: 18px;">Address Mask Reply (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">19</td>
                        <td style="height: 18px;">Reserved (for Security)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">20-29</td>
                        <td style="height: 18px;">Reserved (for Robustness Experiment)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">30</td>
                        <td style="height: 18px;">Traceroute (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">31</td>
                        <td style="height: 18px;">Datagram Conversion Error (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">32</td>
                        <td style="height: 18px;">Mobile Host Redirect (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">33</td>
                        <td style="height: 18px;">IPv6 Where-Are-You (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">34</td>
                        <td style="height: 18px;">IPv6 I-Am-Here (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">35</td>
                        <td style="height: 18px;">Mobile Registration Request (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">36</td>
                        <td style="height: 18px;">Mobile Registration Reply (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">37</td>
                        <td style="height: 18px;">Domain Name Request (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">38</td>
                        <td style="height: 18px;">Domain Name Reply (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">39</td>
                        <td style="height: 18px;">SKIP (Deprecated)</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">40</td>
                        <td style="height: 18px;">Photuris</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">41</td>
                        <td style="height: 18px;">ICMP messages utilized by experimental mobility protocols such as Seamoby</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">42-252</td>
                        <td style="height: 18px;">Unassigned</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">253</td>
                        <td style="height: 18px;">RFC3692-style Experiment 1</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">254</td>
                        <td style="height: 18px;">RFC3692-style Experiment 2</td>
                    </tr>
                    <tr style="height: 18px;">
                        <td style="height: 18px;" align="center">255</td>
                        <td style="height: 18px;">Reserved</td>
                    </tr>
                    </tbody>
                </table>
		</section>
		</article>
		
	</div>
</body>
</html>