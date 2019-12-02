<%@ page import="z.y.x.Security.Utils" %>
<!DOCTYPE html>
<html>
<head>
	<title>Nacl Authenticated Encryption and Decryption (xsalsa20poly1305)</title>

	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Nacl Authenticated Encryption and Decryption (xsalsa20poly1305)",
  "image" : "https://8gwifi.org/images/site/nacl2.png",
  "url" : "https://8gwifi.org/naclencdec.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-12-19",
  "applicationCategory" : [ "nacl", "libsodium", "cryptography", "eccrypt", "crypto_stream_aes128ctr", "crypto_stream_salsa208", "nacl online", "libsodium online", "Cryptography in NaCl", "aesgcm" ],
  "downloadUrl" : "https://8gwifi.org/naclencdec.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : ""Nacl xsalsa20 Encryption & Decryption online, nacl encryption decryption online, eccrypt online, libsodium encryption online, secret box encryption secret box crypto_stream",
  "softwareVersion" : "v1.0"
}
</script>

	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Nacl Authenticated Encryption and Decryption (xsalsa20poly1305), Nacl authenticated Encryption & Decryption online, nacl encryption decryption online, eccrypt online, Cryptography in NaCl">
	<meta name="keywords" content="Nacl Authenticated Encryption and Decryption (xsalsa20poly1305),Nacl authenticated Encryption & Decryption online, nacl encryption decryption online, eccrypt online, libsodium encryption online, secret box encryption secret box crypto_stream, Cryptography in NaCl, nacl tutorial"/>
	<meta name="author" content="CRYPTO" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<script type="text/javascript">
		$(document).ready(function() {

			$('#cipherparameternew').change(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#plaintext').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#secretkey').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#nacl').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#aead').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});


			$('#encrypt').click(function(event) {
				$('#form').delay(200).submit()
			});


			$('#decrypt').click(function(event) {

				var text = $('#output').find('textarea[name="encrypedmessagetextarea"]').val();
				if ( text != null ) {
					$("#plaintext").val(text);
				}

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

					}
				});
			});
		});
	</script>
</head>

<%@ include file="body-script.jsp"%>
<h1 class="mt-4">Nacl Authenticated Encryption and Decryption (xsalsa20poly1305)</h1>

<p>An Nacl Crypto playgroud for nacl AEAD Encrytion and Decryption </p>
<p>crypto_secretbox is crypto_secretbox_xsalsa20poly1305, a particular combination of Salsa20 and Poly1305 specified. This function is conjectured to meet the standard notions of privacy and authenticity</p>

			<div id="loading" style="display: none;">
				<img src="images/712.GIF" alt="" />Loading!
			</div>

			<form class="form-horizontal" id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName" value="AEAD_MESSAGE">


				<div class="radio">
					<label>
						<input checked="checked" id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">Encrypt
					</label>
				</div>
				<div class="radio">
					<label>
						<input id="decrypt" type="radio" name="encryptorDecrypt" value="decrypt">Decrypt
					</label>
				</div>


				<div class="form-group">
					<label for="plaintext" class="col-sm-2 control-label"></label>
					<div class="col-sm-10">
						<textarea class="form-control" rows="3" name="plaintext" placeholder="Type Something here..." id="plaintext"></textarea>
					</div>
				</div>

				<%

					String hex = Utils.toHexEncoded(Utils.getIV(8));
				%>

				<div class="form-group">
					<label for="secretkey">Public Nonce (8 bit) in Hex</label>
					<input type="text" class="form-control"  name="nonce" id="nonce" placeholder="a23c6e1a4aa987e766ecad497f2f4166fb4117b64adfb8bc" value="<%=hex%>">
				</div>

				<div class="form-group">
					<label for="secretkey">AEAD</label>
					<input type="text" class="form-control"  name="aead" id="aead" placeholder="" value="Non Encrypted data">
				</div>

				<div class="form-group">
					<label for="secretkey">Key (32 bit) in Hex</label>
					<input type="password" class="form-control"  name="secretkey" id="secretkey" placeholder="thisismystrongpasswordof32bitkey" value="thisismystrongpasswordof32bitkey">
				</div>



				<div id="output"></div>
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

			<h2 class="mt-4" id="thepbealgo">Secret-key authenticated encryption: crypto_secretbox</h2>
			<p>The crypto_secretbox function encrypts and authenticates a message m using a secret key k and a nonce n. The crypto_secretbox function returns the resulting ciphertext c. The function raises an exception if k.size() is not crypto_secretbox_KEYBYTES. The function also raises an exception if n.size() is not crypto_secretbox_NONCEBYTES</p>
			<p>NaCl does not make any promises regarding the resistance of crypto_stream to "related-key attacks." It is the caller's responsibility to use proper key-derivation functions.</p>

		    <p>The crypto_secretbox function is designed to meet the standard notions of privacy and authenticity for a secret-key authenticated-encryption scheme using nonces</p>

<h2 class="mt-4" id="thepbealgo"> <a href="https://8gwifi.org/docs/go-nacl.jsp">Learn more about Nacl cryptography</a> </h2>
			<%@ include file="addcomments.jsp"%>

		</div>

<%@ include file="body-close.jsp"%>
