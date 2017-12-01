<!DOCTYPE html>
<html>
<head>
	<title>PBE Encryption Decryption tool Online</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="description"
		  content="PBE message encryption decryption Online, PBE file encryption decryption, jascrypt encyption "/>
	<meta name="keywords"
		  content="pbe,java,php,pbe encryption decryption online, pbe file encyption,pbe file decryption, pbe java online, jascrypt encryption online, pbe decyption online, pbewithmd5anddes,pbewithmd5andrc2,pbewithsha1andrc2,pbewithsha1anddes,pbewithsha1andrc2_128,pbewithsha1andrc2_40,pbewithsha1andrc4_128,pbewithsha1andrc4_40,pbewithsha1anddesede,pbewithshaandidea-cbc,pbewithshaand128bitrc4,pbewithmd5andtripledes,pbewithshaand40bitrc4,pbewithmd5and128bitaes-cbc-openssl,pbewithmd5and192bitaes-cbc-openssl,pbewithmd5and256bitaes-cbc-openssl,pbewithsha256and128bitaes-cbc-bc,pbewithsha256and192bitaes-cbc-bc,pbewithsha256and256bitaes-cbc-bc,pbewithshaand128bitaes-cbc-bc,pbewithshaand128bitrc2-cbc,pbewithshaand192bitaes-cbc-bc,pbewithshaand2-keytripledes-cbc,pbewithshaand256bitaes-cbc-bc,pbewithshaand3-keytripledes-cbc,pbewithshaand40bitrc2-cbc,pbewithshaandtwofish-cbc"/>

	<meta name="author" content="CRYPO" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="include_css.jsp"%>


	<script type="text/javascript">
		$(document).ready(function() {


			$('#plaintext').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#message').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#secretkey').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});


			$('#encrypt').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#cipherparameter').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#cipherparameter1').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#cipherparameter2').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#cipherparameter3').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter4').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter5').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter6').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter7').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter8').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter9').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter10').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter11').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter12').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter13').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter14').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#cipherparameter15').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter16').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter17').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter18').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter19').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter20').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter21').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter22').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter23').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter24').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter25').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#cipherparameter26').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#decrypt').click(function(event) {
				$('#form').delay(200).submit()
			});


			$('#encryptparameter').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#decryptparameter').click(function(event) {
				$('#form').delay(200).submit()
			});


			$('#salt').keyup(function(event) {
				$('#form').delay(200).submit()
			});

			$('#rounds').keyup(function(event) {
				$('#form').delay(200).submit()
			});

			$('#password').keyup(function(event) {
				$('#form').delay(200).submit()
			});



			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "PBEFunctionality", //this is my servlet

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

			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="PBEMESSAGE">

				<fieldset name="PBE">

					<legend>
						<b> PBE Encryption/Decryption </b>
					</legend>

					<table border="1" style="width:100pc">
						<tr>
							<th>Input </th>
							<th>Ciphers </th>
							<th>PBE Encryption/Decryption </th>
						</tr>

						<tr>
							<td width="10%">
								<textarea rows="10" cols="30" placeholder="Type Somethng here..." name="message" id="message"></textarea>
								<br/>
								Salt <input id="salt" type="text" name="salt"
											size="10" value="8bitMinm" placeholder="8bits">
								<br/>
								Rounds <input id="rounds" type="text" name="rounds"
											  size="10" placeholder="1000"
											  value="1000">
								<br/>
								Password <input id="password" type="text" name="password"
												size="30" value="UserSupplied" placeholder="8bits">
								<br/>
								Encrypt Message
								<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter"
									   value="encrypt">
								<br/>
								Decrypt Message
								<input id="decryptparameter" type="radio" name="encryptdecryptparameter"
									   value="decryprt">
								<br/>

								<br/>
							</td>
							<td width="10%">
								<!-- <textarea rows="10" cols="30" name="output" id="output"></textarea> -->

								Ciphers
								<br/>

								<input checked="checked" id="cipherparameter11" type="radio"
									   name="cipherparameter" value="PBEWITHMD5ANDDES">PBEWITHMD5ANDDES<br>

								<input
										id="cipherparameter12" type="radio" name="cipherparameter"
										value="PBEWITHMD5ANDRC2">PBEWITHMD5ANDRC2<br>

								<input id="cipherparameter13"
									   type="radio" name="cipherparameter" value="PBEWITHSHA1ANDRC2">PBEWITHSHA1ANDRC2<br>

								<input id="cipherparameter14" type="radio"
									   name="cipherparameter" value="PBEWITHSHA1ANDDES">PBEWITHSHA1ANDDES
								<br>

								<input id="cipherparameter15" type="radio"
									   name="cipherparameter" value="PBEWITHSHA1ANDRC2_128">PBEWITHSHA1ANDRC2_128
								<br>

								<input id="cipherparameter16" type="radio"
									   name="cipherparameter" value="PBEWITHSHA1ANDRC2_40">PBEWITHSHA1ANDRC2_40
								<br>

								<input id="cipherparameter17" type="radio"
									   name="cipherparameter" value="PBEWITHSHA1ANDRC4_128">PBEWITHSHA1ANDRC4_128
								<br>

								<input id="cipherparameter" type="radio" name="cipherparameter"
									   value="PBEWITHSHA1ANDRC4_40">PBEWITHSHA1ANDRC4_40<br>

								<input id="cipherparameter1" type="radio" name="cipherparameter"
									   value="PBEWITHSHA1ANDDESEDE">PBEWITHSHA1ANDDESEDE<br>

								<input id="cipherparameter2" type="radio" name="cipherparameter"
									   value="PBEWITHSHAANDIDEA-CBC">PBEWITHSHAANDIDEA-CBC<br>

								<input id="cipherparameter3" type="radio" name="cipherparameter"
									   value="PBEWITHSHAAND128BITRC4">PBEWITHSHAAND128BITRC4
								<br>
								<input
										id="cipherparameter4" type="radio" name="cipherparameter"
										value="PBEWITHMD5ANDTRIPLEDES">PBEWITHMD5ANDTRIPLEDES<br>

								<input id="cipherparameter5" type="radio" name="cipherparameter"
									   value="PBEWITHSHAAND40BITRC4">PBEWITHSHAAND40BITRC4<br>




							</td>

							<td width="80%">

								<p><strong>Password Based Encryption (PBE)</strong> is specified in e.g. RFC 2898 which specifies the "PKCS #5: Password-Based Cryptography Specification Version 2.0".</p>
								<p><strong>How PBE Works?</strong></p>

								<li>A user supplied password which is remembered by the user.</li>
								<li>A long with that password text, a random number which is called salt is added and hashed.</li>
								<li>Using this a AES or a DES encryption key is derived and encrypted.</li>
								<li>The password text is shared between the two parties exchanging the encrypted content in a secure manner.</li>
								<li>The receiver, uses the same password and salt and decrypts the content.</li>

							</td>

						</tr>

						<tr>

							<td width="20%">
								<b>Output</b>
								<div id="output"> </div>


							</td>
							<td width="30%">
								<input
										id="cipherparameter6" type="radio" name="cipherparameter"
										value="PBEWITHMD5AND128BITAES-CBC-OPENSSL">PBEWITHMD5AND128BITAES-CBC-OPENSSL<br>

								<input id="cipherparameter7" type="radio" name="cipherparameter"
									   value="PBEWITHMD5AND192BITAES-CBC-OPENSSL">PBEWITHMD5AND192BITAES-CBC-OPENSSL<br>

								<input id="cipherparameter8" type="radio" name="cipherparameter"
									   value="PBEWITHMD5AND256BITAES-CBC-OPENSSL">PBEWITHMD5AND256BITAES-CBC-OPENSSL
								<br>

								<input id="cipherparameter9" type="radio"
									   name="cipherparameter" value="PBEWITHSHA256AND128BITAES-CBC-BC">PBEWITHSHA256AND128BITAES-CBC-BC
								<br>

								<input id="cipherparameter10" type="radio"
									   name="cipherparameter" value="PBEWITHSHA256AND192BITAES-CBC-BC">PBEWITHSHA256AND192BITAES-CBC-BC
								<br>

								<input id="cipherparameter19" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND128BITAES-CBC-BC">PBEWITHSHAAND128BITAES-CBC-BC
								<br>

								<input id="cipherparameter20" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND128BITRC2-CBC">PBEWITHSHAAND128BITRC2-CBC
								<br>

								<input id="cipherparameter21" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND192BITAES-CBC-BC">PBEWITHSHAAND192BITAES-CBC-BC
								<br>

								<input id="cipherparameter22" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND2-KEYTRIPLEDES-CBC">PBEWITHSHAAND2-KEYTRIPLEDES-CBC
								<br>

								<input id="cipherparameter23" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND2-KEYTRIPLEDES-CBC">PBEWITHSHAAND2-KEYTRIPLEDES-CBC
								<br>

								<input id="cipherparameter24" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND256BITAES-CBC-BC">PBEWITHSHAAND256BITAES-CBC-BC
								<br>

								<input id="cipherparameter25" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND3-KEYTRIPLEDES-CBC">PBEWITHSHAAND3-KEYTRIPLEDES-CBC
								<br>

								<input id="cipherparameter26" type="radio"
									   name="cipherparameter" value="PBEWITHSHAAND40BITRC2-CBC">PBEWITHSHAAND40BITRC2-CBC
								<br>

							</td>
							<td>
								<p><strong>PBKDF1 PBKDF1</strong> applies a hash function, which shall be MD2,MD5,SHA-1 to derive keys. The length of the derived key is bounded by the length of the hash function output, which is 16 octets for MD2 and MD5 and 20 octets for SHA-1. PBKDF1 is compatible with the key derivation process in PKCS #5</p>
							</td>

						</tr>
						<tr>
							<td>
								<a href="redirect-pbefile.jsp">Click Here for PBE file based ecnryption </a>

							</td>
							<td>
								<p><strong>PBKDF2</strong> applies a pseudorandom function to derive keys. The length of the derived key is essentially unbounded.</p>


							</td>

							<td>

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