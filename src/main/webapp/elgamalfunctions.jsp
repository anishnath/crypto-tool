<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.Security.elgamlpojo" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<!DOCTYPE html>
<html>
<head>


	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "elgamal Encryption Decryption tool, Online elgamal key generator",
  "image" : "https://8gwifi.org/images/site/elg.png",
  "url" : "https://8gwifi.org/elgamalfunctions.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-04-02",
  "applicationCategory" : [ "elgamal encryption decryption online", "online elgamal key generator", "elgamal calculate private key online", "elgamal generate private key online", "elgamal decryption calculator online", "elgamal decrypt with public key", "elgamal encrypt decrypt elgamal/ECB/PKCS1Padding", "elgamal/ECB/PKCS1Padding", "elgamal/None/PKCS1Padding", "elgamal", "elgamal public and private key","elgamal pkey length"],
  "downloadUrl" : "https://8gwifi.org/elgamalfunctions.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : "elgamal algorithm encryption decryption online, generate elgamal key pairs and perform encryption and decryption using elgamal public and private keys elgamal encryption decryption online, online elgamal key generator,elgamal generate public private key online,elgamal decryption calculator online,elgamal decrypt with public key,elgamal encrypt elgamal/ECB/PKCS1Padding, elgamal encrypt decrypt elgamal/ECB/PKCS1Padding, elgamal public key decoder,elgamal private key decrypt online, elgamal key in pem format ",
  "softwareVersion" : "v1.0"
}
</script>

	<title>elgamal Encryption Decryption tool, Online elgamal key generator </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="elgamal encryption decryption , online elgamal key generator,elgamal generate public private key online,elgamal decryption calculator online,elgamal decrypt with public key,elgamal encrypt elgamal/ECB/PKCS1Padding, elgamal encrypt decrypt elgamal/ECB/PKCS1Padding, elgamal/ECB/PKCS1Padding,elgamal/None/PKCS1Padding, elgamal key legnth requirement" />
	<meta name="description" content="elgamal algorithm encryption decryption online, generate elgamal key pairs and perform encryption and decryption using elgamal public and private keys. elgamal encryption example key length requirement" />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<%
		String pubKey = "";
		String privKey = "";
		String checkedKey="160";
		boolean k1=false;
		boolean k2=false;
		boolean k3=false;
		boolean k4=false;


		if (request.getSession().getAttribute("pubkey")==null) {
//			KeyPair kp = RSAUtil.generateKey("ELGAMAL",160);
//			pubKey =RSAUtil.toPem(kp.getPublic());
//
//			String s = new Base64().encodeToString(kp.getPrivate().getEncoded());
//
//			StringBuilder builder = new StringBuilder();
//			builder.append("-----BEGIN PRIVATE KEY-----");
//			builder.append("\n");
//			builder.append(s);
//			builder.append("-----END PRIVATE KEY-----");
//
//			privKey = builder.toString();


			Gson gson = new Gson();
			DefaultHttpClient httpClient = new DefaultHttpClient();
			String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "elgamal/" + 160;

			//System.out.println(url1);

			HttpGet getRequest = new HttpGet(url1);
			getRequest.addHeader("accept", "application/json");

			HttpResponse response1 = httpClient.execute(getRequest);


			BufferedReader br = new BufferedReader(
					new InputStreamReader(
							(response1.getEntity().getContent())
					)
			);

			StringBuilder content = new StringBuilder();
			String line;
			while (null != (line = br.readLine())) {
				content.append(line);
			}
			elgamlpojo elgamlpojo = (elgamlpojo)gson.fromJson(content.toString(), elgamlpojo.class);
			pubKey = elgamlpojo.getPublicKey();
			privKey = elgamlpojo.getPrivateKey();
			k2=true;
		}
		else {
			pubKey = (String)request.getSession().getAttribute("pubkey");
			privKey = (String)request.getSession().getAttribute("privKey");
			checkedKey = (String)request.getSession().getAttribute("keysize");
		}

		if("160".equals(checkedKey))
		{
			k1=true;
		}
		if("320".equals(checkedKey))
		{
			k2=true;

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
					url : "ELGAMALFunctionality", //this is my servlet

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
<h1 class="mt-4">ELGAMAL Encryption/Decryption</h1>
<hr>
<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<p>






					<form id="form1" method="GET" name="form2" action="ELGAMALFunctionality?q=setNeKey">
						Generate ELGAML Keys<input <% if(k1) {  %> checked <% } %>

																		id="keysize1"  type="radio" name="keysize"
																		value="160">160 bit
						<input <% if(k2) {  %> checked <% } %> id="keysize2" type="radio" name="keysize"
											   value="320">320 bit
					</form>

<hr>



				<form id="form" method="POST">
					<input type="hidden" name="methodName" id="methodName"  value="CALCULATE_ELGAMAL">


					<div class="radio">
						<label>
							<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter" value="encrypt"><b>Encrypt Message</b>
						</label>
					</div>

					<div class="radio">
						<label>
							<input id="decryptparameter" type="radio" name="encryptdecryptparameter" value="decryprt"><b>Decrypt Message</b>
						</label>
					</div>


					<div class="form-group">
						<label for="publickeyparam" class="font-weight-bold">Public Key</label>
						<textarea class="form-control animated" rows="5" cols="10"  name="publickeyparam" id="publickeyparam"><%= pubKey %></textarea>
					</div>

					<div class="form-group">
						<label for="privatekeyparam" class="font-weight-bold">Private Key</label>
						<textarea class="form-control animated" rows="5" cols="10"  name="privatekeyparam" id="privatekeyparam"><%= privKey %></textarea>
					</div>

					<div class="form-group">
						<label for="message" class="font-weight-bold">ClearText Message</label>
						<textarea class="form-control animated" rows="5" cols="10" placeholder="Type Something Here..."  name="message" id="message"></textarea>
					</div>

					<div id="output"></div>


					<div class="form-check">
						<input class="form-check-input"  id="cipherparameter3" type="radio" name="cipherparameter" checked value="ELGAMAL">
						<label class="form-check-label" for="cipherparameter3">ELGAMAL</label>
					</div>

					<div class="form-check">
						<input class="form-check-input" id="cipherparameter1" type="radio" name="cipherparameter" value="ELGAMAL/ECB/PKCS1PADDING">
						<label class="form-check-label" for="cipherparameter1">ELGAMAL/ECB/PKCS1PADDING</label>

					</div>

					<div class="form-check">
						<input class="form-check-input" id="cipherparameter2" type="radio" name="cipherparameter" value="ELGAMAL/NONE/NOPADDING">
						<label class="form-check-label" for="cipherparameter2">ELGAMAL/ECB/PKCS1PADDING</label>
					</div>

					<div class="form-check">
						<input class="form-check-input" id="cipherparameter4" type="radio" name="cipherparameter" value="ELGAMAL/PKCS1"  >
						<label class="form-check-label" for="cipherparameter4">ELGAMAL/PKCS1</label>
					</div>

				</form>






<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="therelgamallgorithm">The ELGAML Algorithm</h2>
<p>The ElGamal cryptosystem is usually used in a hybrid cryptosystem. I.e., the message itself is encrypted using a symmetric cryptosystem and ElGamal is then used to encrypt the key used for the symmetric cryptosystem. This is because asymmetric cryptosystems like Elgamal are usually slower than symmetric ones for the same level of security, so it is faster to encrypt the symmetric key (which most of the time is quite small if compared to the size of the message) with Elgamal and the message (which can be arbitrarily large) with a symmetric cipher</p>
<p>Elliptic curve cryptography (ECC) is a public-key cryptography system which is based<br />on discrete logarithms structure of elliptic curves over finite fields. ECC is known for smaller key sizes, faster encryption, better security and more efficient implementations for the same security level as compared to other public cryptography systems (like RSA). ECC can be used for encryption (e.g Elgamal), secure key exchange (ECC Diffie-Hellman) and also for authentication and verification of digital signatures</p>
<p>1024 bit RSA vs 160 bit elliptic curves are the same security level)</p>
<p>ElGamal encryption produces a 2:1 expansion in size from plaintext to ciphertext.</p>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>
