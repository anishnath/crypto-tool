<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
	<title>PBE File Encyption Decryption Online</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>


	<meta name="description"
		  content="PBE File encryption decryption Online, PBE file encryption decryption, jascrypt encyption "/>
	<meta name="keywords"
		  content="pbe encryption decryption online, pbe file encyption,pbe file decryption, pbe java online, jascrypt encryption online, pbe decyption online, pbewithmd5anddes,pbewithmd5andrc2,pbewithsha1andrc2,pbewithsha1anddes,pbewithsha1andrc2_128,pbewithsha1andrc2_40,pbewithsha1andrc4_128,pbewithsha1andrc4_40,pbewithsha1anddesede,pbewithshaandidea-cbc,pbewithshaand128bitrc4,pbewithmd5andtripledes,pbewithshaand40bitrc4,pbewithmd5and128bitaes-cbc-openssl,pbewithmd5and192bitaes-cbc-openssl,pbewithmd5and256bitaes-cbc-openssl,pbewithsha256and128bitaes-cbc-bc,pbewithsha256and192bitaes-cbc-bc,pbewithsha256and256bitaes-cbc-bc,pbewithshaand128bitaes-cbc-bc,pbewithshaand128bitrc2-cbc,pbewithshaand192bitaes-cbc-bc,pbewithshaand2-keytripledes-cbc,pbewithshaand256bitaes-cbc-bc,pbewithshaand3-keytripledes-cbc,pbewithshaand40bitrc2-cbc,pbewithshaandtwofish-cbc"/>

	<meta name="author" content="CRYPO" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="include_css.jsp"%>
	<script type="text/javascript">
		$(document).ready(function() {


			$('#form').submit(function(event) {
				//

				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				var formData = new FormData($(this)[0]);
				$.ajax({
					type : "POST",
					url : "PBEFunctionality", //this is my servlet
					processData: false, // Don't process the files
					contentType: false,
					data : formData,
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
			<form id="form1" action="PBEFunctionality"   name="form1" enctype="multipart/form-data" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="PBEBLOCK">
				<fieldset name="PBE Functionality">
					<legend>
						<B>PBE File Encryption/Decryption  </B>
					</legend>
					<table border="0" style="width:40pc">
						<tr>
							<th>Upload file and click on Submit <input type="file" name="upfile">
								<input type="submit" value="Submit">
							</th>
							<th>
							</th>

							<th>

							</th>
						</tr>
					</table>

					<table border="0" style="width:100pc">

						<div id="output">

							<%

								String value =(String)session.getAttribute("msg");
								if(null==value)
								{
									value="";
								}

							%>

							<%=value%>

							<%

								value =(String)session.getAttribute("downloadlink");
								if(value!=null && value.length()>0)
								{
									%>
							<a href="/PBEFunctionality?uid=<%=value%>">Click to Download file </a>
								<%
								}

							%>


						</div>
						<br/>
					</table>

					<fieldset>
						<legend>Choose Rounds</legend> <br>
						rounds<input id="rounds" type="text" name="rounds"
									 size="10" placeholder="1000"
									 value="1000">
						password<input id="secretkey" type="text" name="secretkey"
									   size="40" placeholder="2b7e151628aed2a6abf71589"
									   value="2b7e151628aed2a6abf71589">
					</fieldset>
					<fieldset>
						<legend>Encrypt/Decrypt</legend>
						<input checked="checked"
							   id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">Encrypt
						<input id="decrypt" type="radio" name="encryptorDecrypt"
							   value="decrypt">Decrypt <br>

					</fieldset>
					<table border="0" style="width:100pc">
						<fieldset>
							<label>Choose the PBE Algorithms  </label> <br>

							<tr>
								<td>
									<input checked="checked" id="cipherparameter11" type="radio"
										   name="cipherparameter" value="PBEWITHMD5ANDDES">PBEWITHMD5ANDDES<br>
								</td>
								<td>

								</td>
							</tr>
							<tr>
								<td>
									<input
											id="cipherparameter12" type="radio" name="cipherparameter"
											value="PBEWITHMD5ANDRC2">PBEWITHMD5ANDRC2<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter13"
										   type="radio" name="cipherparameter" value="PBEWITHSHA1ANDRC2">PBEWITHSHA1ANDRC2<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter14" type="radio"
										   name="cipherparameter" value="PBEWITHSHA1ANDDES">PBEWITHSHA1ANDDES
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter15" type="radio"
										   name="cipherparameter" value="PBEWITHSHA1ANDRC2_128">PBEWITHSHA1ANDRC2_128
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter16" type="radio"
										   name="cipherparameter" value="PBEWITHSHA1ANDRC2_40">PBEWITHSHA1ANDRC2_40
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter17" type="radio"
										   name="cipherparameter" value="PBEWITHSHA1ANDRC4_128">PBEWITHSHA1ANDRC4_128
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter" type="radio" name="cipherparameter"
										   value="PBEWITHSHA1ANDRC4_40">PBEWITHSHA1ANDRC4_40<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter1" type="radio" name="cipherparameter"
										   value="PBEWITHSHA1ANDDESEDE">PBEWITHSHA1ANDDESEDE<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter2" type="radio" name="cipherparameter"
										   value="PBEWITHSHAANDIDEA-CBC">PBEWITHSHAANDIDEA-CBC<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter3" type="radio" name="cipherparameter"
										   value="PBEWITHSHAAND128BITRC4">PBEWITHSHAAND128BITRC4
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>		 <input
										id="cipherparameter4" type="radio" name="cipherparameter"
										value="PBEWITHMD5ANDTRIPLEDES">PBEWITHMD5ANDTRIPLEDES<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter5" type="radio" name="cipherparameter"
										   value="PBEWITHSHAAND40BITRC4">PBEWITHSHAAND40BITRC4<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input
											id="cipherparameter6" type="radio" name="cipherparameter"
											value="PBEWITHMD5AND128BITAES-CBC-OPENSSL">PBEWITHMD5AND128BITAES-CBC-OPENSSL<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter7" type="radio" name="cipherparameter"
										   value="PBEWITHMD5AND192BITAES-CBC-OPENSSL">PBEWITHMD5AND192BITAES-CBC-OPENSSL<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter8" type="radio" name="cipherparameter"
										   value="PBEWITHMD5AND256BITAES-CBC-OPENSSL">PBEWITHMD5AND256BITAES-CBC-OPENSSL
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter9" type="radio"
										   name="cipherparameter" value="PBEWITHSHA256AND128BITAES-CBC-BC">PBEWITHSHA256AND128BITAES-CBC-BC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter10" type="radio"
										   name="cipherparameter" value="PBEWITHSHA256AND192BITAES-CBC-BC">PBEWITHSHA256AND192BITAES-CBC-BC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter19" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND128BITAES-CBC-BC">PBEWITHSHAAND128BITAES-CBC-BC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter20" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND128BITRC2-CBC">PBEWITHSHAAND128BITRC2-CBC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter21" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND192BITAES-CBC-BC">PBEWITHSHAAND192BITAES-CBC-BC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter22" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND2-KEYTRIPLEDES-CBC">PBEWITHSHAAND2-KEYTRIPLEDES-CBC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter23" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND2-KEYTRIPLEDES-CBC">PBEWITHSHAAND2-KEYTRIPLEDES-CBC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter24" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND256BITAES-CBC-BC">PBEWITHSHAAND256BITAES-CBC-BC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter25" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND3-KEYTRIPLEDES-CBC">PBEWITHSHAAND3-KEYTRIPLEDES-CBC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<tr>
								<td>
									<input id="cipherparameter26" type="radio"
										   name="cipherparameter" value="PBEWITHSHAAND40BITRC2-CBC">PBEWITHSHAAND40BITRC2-CBC
									<br>
								</td>
								<td>
								</td>
							</tr>
							<!-- <input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/PKCS1Padding">RSA/ECB/PKCS1Padding (1024, 2048)<br>
                            <input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">RSA/ECB/OAEPWithSHA-1AndMGF1Padding (1024, 2048)<br>
                            <input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-256AndMGF1Padding">RSA/ECB/OAEPWithSHA-256AndMGF1Padding (1024, 2048)<br> -->
						</fieldset>
					</table>
				</fieldset>

			</form>

			<br/>
			<%@ include file="include_security_links.jsp"%>
			<%@ include file="footer.jsp"%>

			<br/>
			<br/>
			<p><strong>Password Based Encryption (PBE)</strong> is specified in e.g. RFC 2898 which specifies the "PKCS #5: Password-Based Cryptography Specification Version 2.0".</p>
			<p><strong>PBKDF1 PBKDF1</strong> applies a hash function, which shall be MD2,MD5,SHA-1 to derive keys. The length of the derived key is bounded by the length of the hash function output, which is 16 octets for MD2 and MD5 and 20 octets for SHA-1. PBKDF1 is compatible with the key derivation process in PKCS #5</p>
			<p><strong>PBKDF2</strong> applies a pseudorandom function to derive keys. The length of the derived key is essentially unbounded.</p>
			<p><strong>How PBE Works?</strong></p>
			<ul>
				<li>A user supplied password which is remembered by the user.</li>
				<li>A long with that password text, a random number which is called salt is added and hashed.</li>
				<li>Using this a AES or a DES encryption key is derived and encrypted.</li>
				<li>The password text is shared between the two parties exchanging the encrypted content in a secure manner.</li>
				<li>The receiver, uses the same password and salt and decrypts the content.</li>
			</ul>



		</section>
	</article>

</div>
</body>
</html>