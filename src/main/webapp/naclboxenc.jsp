<%@ page import="z.y.x.Security.Utils" %>
<!DOCTYPE html>
<html>
<head>


	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Nacl Box Public Key Cryptography",
  "image" : "https://8gwifi.org/images/site/nacl3.png",
  "url" : "https://8gwifi.org/naclboxenc.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-12-19",
  "applicationCategory" : [ "nacl box", "nacl crypto_box", "nacl", "nacl box encryption decryption", "libsodium", "cryptography", "eccrypt", "crypto_stream_aes128ctr", "crypto_stream_salsa208", "nacl online", "libsodium online", "Cryptography in NaCl", "aesgcm" ],
  "downloadUrl" : "https://8gwifi.org/naclboxenc.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Nacl Box Public Key Cryptography, nacl box tutorial, nacl online, nacl box encryption decryptio, nacl generate keys, nacl tutorial crypto_box,curve25519,xsalsa20,poly130",
  "softwareVersion" : "v1.0"
}
</script>

	<title>Nacl Box Public Key Cryptography </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="Nacl Box Public Key Cryptography, nacl box tutorial, nacl online, nacl box encryption decryptio, nacl generate keys, nacl tutorial crypto_box,curve25519,xsalsa20,poly1305" />
	<meta name="description" content="Nacl Box Public Key Cryptography, nacl box tutorial, nacl online, nacl box encryption decryptio, nacl generate keys, nacl tutorial crypto_box,curve25519,xsalsa20,poly130" />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<%


		String pubKey = Utils.toHexEncoded(Utils.getIV(32));
		String privKey = Utils.toHexEncoded(Utils.getIV(32));

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

				var text = $('#output').find('textarea[name="encrypedmessagetextarea"]').val();
				if ( text != null ) {
					$("#message").val(text);
				}
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
					url : "NaclFunctionality", //this is my servlet

					data : $("#form").serialize(),
					success : function(msg) {
						$('#output').empty();
						$('#output').append(msg);
						$("#publickeyparam").resizable();
						$("#privatekeyparam").resizable();

					}
				});
			});

		});
	</script>
</head>


<%@ include file="body-script.jsp"%>

<h1 class="mt-4">Nacl Box Public Key Cryptography</h1>

<p>A cryptoplaygroud for NACL Public-key authenticated encryption: crypto_box</p>
<p>crypto_box is curve25519xsalsa20poly1305, a particular combination of Curve25519, Salsa20, and Poly1305 </p>
<hr>


<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>







<form id="form" class="form-horizontal" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="NACL_BOX_ENCRYPT">


	<div class="radio">
		<label>
			<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter" value="encrypt">
			Nacl Box Encrypt
		</label>
	</div>
	<div class="radio">
		<label>
			<input id="decryptparameter" type="radio" name="encryptdecryptparameter" value="decrypt">
			Nacl Box Decrypt
		</label>
	</div>

	<%

		String hex = Utils.toHexEncoded(Utils.getIV(24));
	%>

	<div class="form-group">
		<label for="nonce">Public Nonce (24 bit) in Hex(48)</label>
		<input type="text" class="form-control"  name="nonce" id="nonce" placeholder="a23c6e1a4aa987e766ecad497f2f4166fb4117b64adfb8bc" value="<%=hex%>">
	</div>

	<table class="table">
		<tr>
			<th>Public Key (Alice) 32 bit Hex </th>
			<th>Private Key (Bob) 32 bit Hex</th>
		</tr>

		<tr>
			<td>
				<textarea class="form-control animated" rows="5"   name="publickeyparam" id="publickeyparam"><%= pubKey %></textarea>
			</td>
			<td>
				<textarea class="form-control animated" rows="5"   name="privatekeyparam" id="privatekeyparam"><%= privKey %></textarea>
			</td>


		</tr>


		<tr>

			<td>
				<b>ClearText Message</b><textarea class="form-control" rows="5"  placeholder="Type Something Here..."  name="message" id="message"></textarea>
			</td>
			<td width="50%">
				<b>output</b><div id="output"></div>
			</td>
		</tr>
	</table>


</form>

<ul>
	<li><a href="naclencdec.jsp"><font size="2.5px">Nacl xsalsa20 Encryption & Decryption</font></a></li>
	<li><a href="naclaead.jsp"><font size="2.5px">Nacl AEAD Encryption & Decryption</font></a></li>
	<li><a href="naclboxenc.jsp"><font size="2.5px">Nacl Box Encryption & Decryption</font></a></li>
	<li><a href="naclsealboxenc.jsp"><font size="2.5px">Nacl SealBox Encryption & Decryption</font></a></li>
</ul>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="naclbox1">Public-key authenticated encryption: crypto_box</h2>

<p>The crypto_box_keypair function randomly generates a secret key and a corresponding public key. It puts the secret key into sk and returns the public key</p>
<p>The crypto_box function encrypts and authenticates a message m using the sender's secret key sk, the receiver's public key pk, and a nonce n. The crypto_box function returns the resulting ciphertext c</p>
<p>The crypto_box_open function verifies and decrypts a ciphertext c using the receiver's secret key sk, the sender's public key pk, and a nonce n. The crypto_box_open function returns the resulting plaintext m.</p>
<hr>

<h2 class="mt-4" id="naclbox12">How to perform NAcl Cryptography </h2>

<table id="tablePreview" class="table table-bordered">
	<!--Table head-->
	<thead>
	<tr>
		<th><a href="/docs/go-nacl.jsp">Go Lang</a> </th>
		</tr>
	</tr>
	</thead>
	<tbody>
	</tbody>
	</table>


<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
