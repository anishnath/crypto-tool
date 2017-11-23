<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<!DOCTYPE html>
<html>
<head>
	<title>RSA Encryption Decryption tool, Online RSA key generator </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="rsa encryption decryption online, online rsa key generator,rsa calculate private key online,rsa decryption calculator online,rsa decrypt with public key,rsa encrypt RSA/ECB/PKCS1Padding, rsa decrypt RSA/ECB/PKCS1Padding, RSA/ECB/PKCS1Padding,RSA/None/PKCS1Padding,RSA,RSA/NONE/OAEPWithSHA1AndMGF1Padding,RSA/ECB/OAEPWithSHA-256AndMGF1Padding,RSA/NONE/OAEPWithSHA1AndMGF1Padding,rsa public key decoder,rsa private key decrypt online" />
	<meta name="description" content="rsa alogorith encryption decryption online " />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="include_css.jsp"%>

	<%
		String pubKey = "";
		String privKey = "";
		String checkedKey="512";
		boolean k1=false;
		boolean k2=false;
		boolean k3=false;
		boolean k4=false;


		if (request.getSession().getAttribute("pubkey")==null) {
			KeyPair kp = RSAUtil.generateKey(1024);
			pubKey = RSAUtil.encodeBASE64(kp.getPublic().getEncoded());
			privKey = RSAUtil.encodeBASE64(kp.getPrivate().getEncoded());
			k2=true;
		}
		else {
			pubKey = (String)request.getSession().getAttribute("pubkey");
			privKey = (String)request.getSession().getAttribute("privKey");
			checkedKey = (String)request.getSession().getAttribute("keysize");
		}

		if("512".equals(checkedKey))
		{
			k1=true;
		}
		if("1024".equals(checkedKey))
		{
			k2=true;

		}
		if("2048".equals(checkedKey))
		{
			k3=true;
		}
		if("4096".equals(checkedKey))
		{
			k4=true;
		}

		//System.out.println(k1);
		//System.out.println(k2);
		//System.out.println(k3);
		//System.out.println(k4);

	%>

	<script type="text/javascript">
		$(document).ready(function() {




			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#publickeyparam').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#privatekeyparam').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});


			$('#message').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#keysize1').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#keysize2').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#keysize3').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#keysize4').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#cipherparameter1').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#cipherparameter2').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#cipherparameter3').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#cipherparameter4').click(function(event) {
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
					url : "RSAFunctionality", //this is my servlet

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
<div id="page">
	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>

	<article id="contentWrapper" role="main">
		<section id="content">
			<fieldset name="RSA"   >
				<legend>
					<b> Key Size </b>
				</legend>
				Generate Key Size
				<form id="form1" method="GET" name="form2" action="RSAFunctionality?q=setNeKey">
					<input <% if(k1) {  %> checked <% } %>

										   id="keysize1"  type="radio" name="keysize"
										   value="512">512 bit
					<input <% if(k2) {  %> checked <% } %> id="keysize2" type="radio" name="keysize"
										   value="1024">1024 bit
					<input <% if(k3) {  %> checked <% } %> id="keysize3" type="radio" name="keysize"
										   value="2048">2048 bit
					<input <% if(k4) {  %> checked <% } %> id="keysize4" type="radio" name="keysize"
										   value="4096">4096 bit
				</form>
			</fieldset>

			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="CALCULATE_RSA">

				<fieldset name="RSA2"   >

					<legend>
						<b> RSA Encryption/Decryption Functionality </b>
					</legend>

					<table border="1" style="width:100pc">
						<tr>
							<th>Public Key </th>
							<th>Private Key </th>
							<th>RSA Encryption/Decryption </th>
						</tr>

						<tr>
							<td>
								<textarea rows="10" cols="50"  name="publickeyparam" id="publickeyparam"><%= pubKey %></textarea>
							</td>
							<td>
								<textarea rows="10" cols="50"  name="privatekeyparam" id="privatekeyparam"><%= privKey %></textarea>
							</td>


							<td width="70%">
								<p><strong>The RSA Algorithm</strong></p>
								<p>The Rivest-Shamir-Adleman (RSA) algorithm is one of the most popular and secure public-key encryption methods. The algorithm capitalizes on the fact that there is no efficient way to factor very large (100-200 digit) numbers/>
							</td>

						</tr>

						<tr>

							<td>
								<b>ClearText Message</b><textarea rows="10" cols="40"   name="message" id="message">anish</textarea>
							</td>
							<td width="50%">
							<br>
								Ciphers
								<br/>
								<input id="cipherparameter1" type="radio" name="cipherparameter"
									   value="RSA/ECB/PKCS1Padding"  >RSA/ECB/PKCS1Padding
								<br/>
								<input id="cipherparameter2" type="radio" name="cipherparameter"
									   value="RSA/None/PKCS1Padding"  >RSA/None/PKCS1Padding
								<br/>
								<input id="cipherparameter3" type="radio" name="cipherparameter"
									   value="RSA"  >RSA
								<br/>
							<input id="cipherparameter4" type="radio" name="cipherparameter"
								   value="RSA/NONE/OAEPWithSHA1AndMGF1Padding"  >RSA/NONE/OAEPWithSHA1AndMGF1Padding
							<br/>
							<input id="cipherparameter5" type="radio" name="cipherparameter"
								   value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">RSA/ECB/OAEPWithSHA-1AndMGF1Padding
							<br/>

							</td>
							<td>
								Encrypt the message by raising it to the eth power modulo n. The result is a ciphertext message C.<br />To decrypt ciphertext message C, raise it to another power d modulo n<br />The encryption key (e,n) is made public. The decryption key (d,n) is kept private by the user.</p>
							</td>

						</tr>
						<tr>
							<td>
								Encrypt Message
								<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter"
									   value="encrypt">
								<br/>
								Decrypt Message
								<input id="decryptparameter" type="radio" name="encryptdecryptparameter"
									   value="decryprt">
							</td>
							<td>
								Output <textarea rows="20" cols="40" name="output1" id="output"></textarea>
							</td>

							<td width="70%">
								<p>RSA encryption usually is only used for messages that fit into one block<br />A 1024-bit RSA key invocation can encrypt a message up to 117 bytes, and results in a 128-byte value</p>
								<br/>
								<p>RSA, as defined by PKCS#1, encrypts "messages" of limited size,the maximum size of data which can be encrypted with RSA is 245 bytes. No more</p>
							</td>

						</tr>

						<tr>

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
		</section>
	</article>

</div>
</body>
</html>