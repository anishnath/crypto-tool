<%@ page import="z.y.x.Security.ecpojo" %>
<!DOCTYPE html>
<html>
<head>


	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Elliptic Curve Encryption Decryption tool Online ecparam key generator",
  "image" : "https://github.com/anishnath/crypto-tool/blob/master/Elliptic_Curve_Encryption_Decryption.png",
  "url" : "https://8gwifi.org/ecfunctions.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2017-09-25",
  "applicationCategory" : [ "elliptic curve encryption and decryption online", "online ec  generator", "elliptic curve calculate private key online", "elliptic curve  generate private key online", "elliptic curve  decryption calculator online", "elliptic curve  decrypt with public key", "sect233r1","prime192v2","prime192v1","sect409r1" ],
  "downloadUrl" : "https://8gwifi.org/rsafunctions.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : "elliptic curve algorithm encryption decryption online, generate elliptic curve key pairs and perform encryption and decryption using elliptic curve public and private keys elliptic curve encryption decryption online, online elliptic curve key generator,elliptic curve generate public private key online,elliptic curve decryption calculator online,elliptic curve decrypt with public key",
  "softwareVersion" : "v1.0"
}
</script>

	<title>Elliptic Curve Encryption Decryption tool Online ecparam key generator </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="elliptic curve encryption and decryption online, elliptic curve, elliptic curve encryption shared secret, ec encryption ,elliptic curve calculator, encryption, cryptography, elliptic curve pem format, openssl commands elliptic curve c2pnb272w1,c2tnb359v1,prime256v1,c2pnb304w1,c2pnb368w1,c2tnb431r1,
sect283r1,sect283k1,secp256k1,secp256r1,sect571r1,sect571k1,sect409r1,sect409k1,
secp521r1,secp384r1,P-521,P-256,P-384,B-409,B-283,B-571,K-409,K-283,
K-571,brainpoolp512r1,brainpoolp384t1,brainpoolp256r1,brainpoolp512t1,brainpoolp256t1,brainpoolp320r1,brainpoolp384r1,brainpoolp320t1,FRP256v1,sm2p256v1"/>
	<meta name="description" content="Online elliptic curve encryption and decryption, key generator, ec paramater, elliptic curve pem formats  " />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="include_css.jsp"%>


	<script type="text/javascript">
		$(document).ready(function() {




			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#message').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#encryptparameter').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#decryptparameter').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});


			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "ECFunctionality", //this is my servlet

					data : $("#form").serialize(),
					success : function(msg) {
						$('#output').empty();
						$('#output').append(msg);

					}
				});
			});
		});
	</script>
</head>
<body>

<%

	String ecPrivateKeyA="";
	String ecPrivateKeyB= "";
	String ecPublicKeyB= "";
	String ecPublicKeyA= "";
	String sharedSecret= "";
	ecpojo ecpo = (ecpojo) request.getSession().getAttribute("ecpojo");
	if(ecpo!=null)
	{
		ecPrivateKeyA= ecpo.getEcprivateKeyA();
		ecPrivateKeyB= ecpo.getEcprivateKeyB();
		ecPublicKeyB= ecpo.getEcpubliceKeyB();
		ecPublicKeyA= ecpo.getEcpubliceKeyA();
		sharedSecret= ecpo.getShareSecretA();
	}
%>

<div id="page">
	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>

	<article id="contentWrapper" role="main">
		<section id="content">
			<form id="form1" action="ECFunctionality" method="POST">
				<input type="hidden" name="methodName" id="methodName"  value="EC_GENERATE_KEYPAIR">
				<fieldset name="Generate Key Pair">
					<legend>
						<b> Elliptic Curve Encryption/Decryption</b>
					</legend>

					Choose ECParam<select name="ecparam" id="ecparam">
					<%
						String[] validList = { "c2pnb272w1", "c2tnb359v1", "prime256v1", "c2pnb304w1", "c2pnb368w1", "c2tnb431r1",
								"sect283r1", "sect283k1", "secp256k1", "secp256r1", "sect571r1", "sect571k1", "sect409r1", "sect409k1",
								"secp521r1", "secp384r1", "P-521", "P-256", "P-384", "B-409", "B-283", "B-571", "K-409", "K-283",
								"K-571", "brainpoolp512r1", "brainpoolp384t1", "brainpoolp256r1", "brainpoolp512t1", "brainpoolp256t1",
								"brainpoolp320r1", "brainpoolp384r1", "brainpoolp320t1", "FRP256v1", "sm2p256v1" };
						for (int i = 0; i < validList.length; i++) {
							String param = validList[i];
					%>
					<option value="<%=param%>"> <%=param%></option>
					<%	} %>
				</select> <input type="submit" name="Generate EC" value="submit"> Generate EC
					<br>
			</form>
			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"  value="EC_FUNCTION">
				<fieldset name="EC">
					<legend>
						<b> Encrypt/Decrypt</b>
					</legend>
					<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter"
						   value="encrypt">Encrypt Message

					<input id="decryptparameter" type="radio" name="encryptdecryptparameter"
						   value="decrypt"> Decrypt Message
					<br/>
					<b>Initial vector </b><input type="text" size="32" name="iv" value="73dec0c947c318bf0ee938e89ee4f414">
					<br/>
					<%
						if(sharedSecret!=null && sharedSecret.length()>1)
						{
					%>
					Alice & Bob Shared Secret Formed &nbsp;&nbsp;<b><font color="green"><%=sharedSecret%></font></b>
					<%}%>
				</fieldset>
				<table border="1" style="width:80pc">
					<tr>
						<th>Public Key Alice </th>
						<th>EC-Private Key Alice </th>
						<th>Public Key Bob</th>
						<th>EC-Private Key Bob </th>
						<th></th>
					</tr>




					<tr>
						<td>
							<textarea rows="10" cols="40"  name="publickeyparama" id="publickeyparama"><%=ecPublicKeyA%></textarea>
						</td>
						<td>
							<textarea rows="10" cols="40"  name="privatekeyparama" id="privatekeyparama"><%=ecPrivateKeyA%></textarea>
						</td>

						<td>
							<textarea rows="10" cols="40"  name="publickeyparamb" id="publickeyparamb"><%=ecPublicKeyB%></textarea>
						</td>
						<td>
							<textarea rows="10" cols="40"  name="privatekeyparamb" id="privatekeyparamb"><%=ecPrivateKeyB%></textarea>
						</td>
						<td>
							<%@ include file="footer_adsense.jsp"%>
						</td>

					</tr>
				</table>
				<table>
					<tr>
						<th>Input Message</th>
						<th></th>
					</tr>
					<tr>
						<td>
							<textarea rows="10" cols="20" placeholder="Type Something Here..."  name="message" id="message"></textarea>
						</td>
						<td><div id="output"></div>
						</td>
					</tr>
				</table>


				</fieldset>

			</form>

			<table border="0" style="width:500px">
				<tr>
					<td><%@ include file="footer.jsp"%></td>
				</tr>
			</table>
			<%@ include file="include_security_links.jsp"%>
			<br/>
			<p><strong><span id="Generating_EC_Keys_and_Parameters">Generating EC Keys and Parameters</span></strong></p>
			<blockquote>
				<p>[bash]$ openssl ecparam -list_curves</p>
				<p>&nbsp; secp256k1 : SECG curve over a 256 bit prime field</p>
				<p>&nbsp; secp384r1 : NIST/SECG curve over a 384 bit prime field</p>
				<p>&nbsp; secp521r1 : NIST/SECG curve over a 521 bit prime field</p>
				<p>&nbsp; prime256v1: X9.62/SECG curve over a 256 bit prime field</p>
			</blockquote>
			<p><strong>An EC parameters file can then be generated for any of the built-in named curves as follows:</strong></p>
			<blockquote>
				<p>[bash]$ openssl ecparam -name secp256k1 -out secp256k1.pem</p>
				<p>[bash]$ cat secp256k1.pem</p>
				<p>-----BEGIN EC PARAMETERS-----</p>
				<p>BgUrgQQACg==</p>
				<p>-----END EC PARAMETERS-----</p>
				<p><strong>&nbsp;To generate a private/public key pair from a pre-eixsting parameters file use the following:</strong><br />[bash]$ openssl ecparam -in secp256k1.pem -genkey -noout -out secp256k1-key.pem<br />[bash]$ cat secp256k1-key.pem<br />-----BEGIN EC PRIVATE KEY-----<br />MHQCAQEEIKRPdj7XMkxO8nehl7iYF9WAnr2Jdvo4OFqceqoBjc8/oAcGBSuBBAAK<br />oUQDQgAE7qXaOiK9jgWezLxemv+lxQ/9/Q68pYCox/y1vD1fhvosggCxIkiNOZrD<br />kHqms0N+huh92A/vfI5FyDZx0+cHww==<br />-----END EC PRIVATE KEY-----</p>
				<p><strong>Examine the specific details of the parameters associated with a particular named curve</strong><br />[bash]$ openssl ecparam -in secp256k1.pem -text -param_enc explicit -noout<br />Field Type: prime-field<br />Prime:<br /> 00:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:<br /> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:fe:ff:<br /> ff:fc:2f<br />A: 0<br />B: 7 (0x7)<br />Generator (uncompressed):<br /> 04:79:be:66:7e:f9:dc:bb:ac:55:a0:62:95:ce:87:<br /> 0b:07:02:9b:fc:db:2d:ce:28:d9:59:f2:81:5b:16:<br /> f8:17:98:48:3a:da:77:26:a3:c4:65:5d:a4:fb:fc:<br /> 0e:11:08:a8:fd:17:b4:48:a6:85:54:19:9c:47:d0:<br /> 8f:fb:10:d4:b8<br />Order: <br /> 00:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:<br /> ff:fe:ba:ae:dc:e6:af:48:a0:3b:bf:d2:5e:8c:d0:<br /> 36:41:41<br />Cofactor: 1 (0x1)</p>
			</blockquote>
		</section>
	</article>

</div>
</body>
</html>