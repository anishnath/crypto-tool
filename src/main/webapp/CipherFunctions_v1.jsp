<!DOCTYPE html>
<html>
<head>
<title>Online Cipher Algorithms, Encryption Decryption using AES,DES,DESede,Blowfish,Twofish,CAST5,IDEA,Rijndael</title>



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
<div id="page">
	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	
		<article id="contentWrapper" role="main">
			<section id="content">
	<form id="form" method="POST">
		<input type="hidden" name="methodName" id="methodName"
			value="CIPHERBLOCK">
		<fieldset name="Cipher Functionality">
			<legend>
				<B>Encrypt/Decrypt Message </B>
			</legend>
			Plain text Type Something
			<textarea rows="10" cols="30" name="plaintext" placeholder="Type Something here..." id="plaintext"></textarea>
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
				<input id="cipherparameter14" type="radio"
					   name="cipherparameter" value="Blowfish">Blowfish(64)
				<br>
				<input id="cipherparameter15" type="radio"
					   name="cipherparameter" value="Twofish">Twofish(128)
				<br>
				<input id="cipherparameter16" type="radio"
					   name="cipherparameter" value="IDEA">IDEA (64)
				<br>
				<input id="cipherparameter17" type="radio"
					   name="cipherparameter" value="CAST5">CAST5 (64 Bits Block Siize)
				<br>
				<input id="cipherparameter" type="radio" name="cipherparameter"
					value="AES/CBC/PKCS5Padding">AES/CBC/PKCS5Padding (128)<br>
				<input id="cipherparameter18" type="radio" name="cipherparameter"
					   value="AES/CBC/NoPadding">AES/CBC/NoPadding(128)<br>
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
				<%@ include file="include_security_links.jsp"%>
				<%@ include file="footer.jsp"%>
			</section>
		</article>
		
	</div>
</body>
</html>