<%@ page import="z.y.x.Security.RSAUtil" %>
<%@ page import="java.security.KeyPair" %>
<!DOCTYPE html>
<html>
<head>



	<title>DSA Generate Keys,DSA Sign file Gneerate, Verify Signature file</title>


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
			KeyPair kp = RSAUtil.generateKey("DSA",1024);
			pubKey =RSAUtil.toPem(kp.getPublic());
			privKey = RSAUtil.toPem(kp);
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



			$('#descryptmsg').hide();

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
				$('#descryptmsg').hide();
			});

			$('#decryptparameter').click(function(event) {

				$('#descryptmsg').show();
			});


			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "DSAFunctionality", //this is my servlet

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
			<fieldset name="RSA">
				<legend>
					<b> DSA Key generation, Sign file, Verify Signature </b>
				</legend>
				<fieldset name="RSA Key Size">
					<legend>
						<b> Key Size </b>
					</legend>

					<form id="form1" method="GET" name="form1"  action="DSAFunctionality?q=setNeKey">
						Generate DSA Keys <input <% if(k1) {  %> checked <% } %>

																		id="keysize1"  type="radio" name="keysize"
																		value="512">512 bit
						<input <% if(k2) {  %> checked <% } %> id="keysize2" type="radio" name="keysize"
											   value="1024">1024 bit
						<input <% if(k3) {  %> checked <% } %> id="keysize3" type="radio" name="keysize"
											   value="2048">2048 bit
					</form>
				</fieldset>


				<form id="form2" name="form2" method="POST" action="DSAFunctionality" enctype="multipart/form-data">
					<input type="hidden" name="methodName" id="methodName"
						   value="CALCULATE_DSA">




					<fieldset name="RSA2"   >

						<legend>
							<b> DSA Signer/Verifier</b>
						</legend>

						<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter"
							   value="encrypt">Sign File

						<input id="decryptparameter" type="radio" name="encryptdecryptparameter"
							   value="decryprt">Verify Signature Message
						<br>

						<table border="1" style="width:80pc">
							<tr>
								<th>DSA Public Key </th>
								<th>DSA Private Key </th>
								<th>DSA  </th>
							</tr>

							<tr>
								<td>
									<textarea rows="20" cols="50"  name="publickeyparam" id="publickeyparam"><%= pubKey %></textarea>
								</td>
								<td>
									<textarea rows="20" cols="50"  name="privatekeyparam" id="privatekeyparam"><%= privKey %></textarea>
								</td>


								<td rowspan="3" width="80%">
									<%@ include file="footer_adsense.jsp"%>
									<p><strong>The DSA Algorithm</strong></p>

									<p>DSA stands for "Digital Signature Algorithm" - and is specifically designed to produce digital signatures, not perform encryption.</p>
									<p>The requirement for public/private keys in this system is for a slightly different purpose - whereas in RSA, a key is needed so anyone can encrypt, in DSA a key is needed so anyone can verify. In RSA, the private key allows decryption; in DSA, the private key allows signature creation.</p>

									<p> DSA Private Key is used for generating Signature file  </p>
									<p> DSA public Key is used for Verifying the Signature.  </p>
								</td>

							</tr>

							<tr>

								<td>
									Input file to be Signed (Signature file will get downloaded)
									<input type="file" id="upfile" name="upfile">

									<div id="descryptmsg">
										Upload Signature file <input type="file" id="sigfile" name="sigfile">
										</div>

								</td>
								<td width="50%">
									<b>output</b><div id="output">

									<%

										String value =(String)session.getAttribute("msg");
										if(null==value)
										{
											value="";
										}

									%>

									<%=value%>


									<input type="submit" value="Submit">
								</div>
								</td>




							</tr>
							<tr>
								<td colspan="2" width="20%">
									Ciphers
									<br/>
									<input id="cipherparameter3" type="radio" name="cipherparameter"
										   checked value="SHA256withDSA"  >SHA256withDSA
									<br/>
									<input id="cipherparameter1" type="radio" name="cipherparameter"
										   value="NONEwithDSA">NONEwithDSA
									<br/>
									<input id="cipherparameter2" type="radio" name="cipherparameter"
										   value="SHA224withDSA">SHA224withDSA
									<br/>
									<input id="cipherparameter4" type="radio" name="cipherparameter"
										   value="SHA1withDSA">SHA1withDSA
									<br/>
								</td>

							</tr>



						</table>


					</fieldset>
			</fieldset>

			</form>

			<table border="0" style="width:500px">
				<tr>
					<td><%@ include file="footer.jsp"%></td>
				</tr>
			</table>
			<%@ include file="include_security_links.jsp"%>
<br/>
			<br/>



	</article>

</div>
</body>
</html>