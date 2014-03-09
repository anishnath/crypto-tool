<!DOCTYPE html>
<html>
<head>
<title>Online Cipher Algorithms, Encrytion Decryption Online using AES,DES,DESede</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>


<meta name="description"
	content="Encode or Decode string, Strong Encryption and Powerful Decryption online, Block Ciphers, ECB,CCB,OTR Padding Scheme PKCS5Padding, NoPadding "/>
<meta name="keywords"
	content="encode, encrypt, encryption, online encrypt, decode, decript, decryption,AES/CBC/NoPadding,AES/CBC/PKCS5Padding ,AES/ECB/NoPadding,AES/ECB/PKCS5Padding,DES/CBC/NoPadding 
	DES/CBC/PKCS5Padding,DES/ECB/NoPadding ,DES/ECB/PKCS5Padding,DESede/CBC/NoPadding,DESede/CBC/PKCS5Padding">


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

		$('#decrypt').click(function(event) {
			$('#form').delay(200).submit()
		});

		$('#form').submit(function(event) {
			//	
			$('#output').html('<img src="images/712.GIF"> loading...');
			event.preventDefault();
			$.ajax({
				type : "POST",
				url : "CipherFunctionality", //this is my servlet

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
	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<form id="form" method="POST">
		<input type="hidden" name="methodName" id="methodName"
			value="CIPHERBLOCK">
		<fieldset name="Cipher Functionality">
			<legend>
				<B>Encrypt/Decrypt Message </B>
			</legend>
			Plain text Type Something
			<textarea rows="10" cols="30" name="plaintext" id="plaintext"></textarea>
			<div id="output"></div>

			<br> SecretKey<input id="secretkey" type="text" name="secretkey"
				size="40" placeholder="2b7e151628aed2a6abf71589"
				value="2b7e151628aed2a6abf71589"> <input checked="checked"
				id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">Encrypt
			<input id="decrypt" type="radio" name="encryptorDecrypt"
				value="decrypt">Decrypt <br>
			<fieldset>
				<label>Choose Standard Cipher transformations with the
					keysizes in parentheses:</label> <br>
				<!-- <input checked="checked" id="cipherparameter" type="radio" name="cipherparameter" value="AES/CBC/NoPadding">AES/CBC/NoPadding (128) -->
				<input checked="checked" id="cipherparameter11" type="radio"
					name="cipherparameter" value="AES">AES<br> <input
					id="cipherparameter12" type="radio" name="cipherparameter"
					value="DES">DES<br> <input id="cipherparameter13"
					type="radio" name="cipherparameter" value="DESede">DESede<br>
				<input id="cipherparameter" type="radio" name="cipherparameter"
					value="AES/CBC/PKCS5Padding">AES/CBC/PKCS5Padding (128)<br>
				<input id="cipherparameter1" type="radio" name="cipherparameter"
					value="AES/ECB/NoPadding">AES/ECB/NoPadding (128)<br>
				<input id="cipherparameter2" type="radio" name="cipherparameter"
					value="AES/ECB/PKCS5Padding">AES/ECB/PKCS5Padding (128)<br>
				<input id="cipherparameter3" type="radio" name="cipherparameter"
					value="DES/CBC/NoPadding">DES/CBC/NoPadding (56)<br> <input
					id="cipherparameter4" type="radio" name="cipherparameter"
					value="DES/CBC/PKCS5Padding">DES/CBC/PKCS5Padding (56)<br>

				<input id="cipherparameter5" type="radio" name="cipherparameter"
					value="DES/ECB/NoPadding">DES/ECB/NoPadding (56)<br> <input
					id="cipherparameter6" type="radio" name="cipherparameter"
					value="DES/ECB/PKCS5Padding">DES/ECB/PKCS5Padding (56)<br>
				<input id="cipherparameter7" type="radio" name="cipherparameter"
					value="DESede/CBC/NoPadding">DESede/CBC/NoPadding (168)<br>
				<input id="cipherparameter8" type="radio" name="cipherparameter"
					value="DESede/CBC/PKCS5Padding">DESede/CBC/PKCS5Padding
				(168)<br> <input id="cipherparameter9" type="radio"
					name="cipherparameter" value="DESede/ECB/NoPadding">DESede/ECB/NoPadding
				(168)<br> <input id="cipherparameter10" type="radio"
					name="cipherparameter" value="DESede/ECB/PKCS5Padding">DESede/ECB/PKCS5Padding
				(168)<br>
				<!-- <input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/PKCS1Padding">RSA/ECB/PKCS1Padding (1024, 2048)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">RSA/ECB/OAEPWithSHA-1AndMGF1Padding (1024, 2048)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-256AndMGF1Padding">RSA/ECB/OAEPWithSHA-256AndMGF1Padding (1024, 2048)<br> -->
			</fieldset>
		</fieldset>

	</form>


</body>
</html>