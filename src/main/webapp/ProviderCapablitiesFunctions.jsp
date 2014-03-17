<!DOCTYPE html>
<html>
<head>
<title>List the available capabilities for ciphers, key agreement, macs, message
  digests, signatures and other objects in the BC provider, </title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>


<meta name="description"
	content="Encode or Decode string, Strong Encryption and Powerful Decryption online, Block Ciphers, ECB,CCB,OTR Padding Scheme PKCS5Padding, NoPadding "/>
<meta name="keywords"
	content="SUN ,Apple ,SunRsaSign ,SunJSSE ,SunJCE ,SunJGSS ,SunSASL ,XMLDSig ,SunPCSC ,BC ,OID.1.2.840.113549.1.12.1.6,Rijndael,AES SupportedModes,ARCFOUR,PBEWithSHA1AndRC2_40,RC2,RC4,OID.1.2.840.113549.1.12.1.3,AES,DES,1.2.840.113549.1.5.3,DESede SupportedModes,AESWrap ,DESedeWrap,PBEWithSHA1AndDESede,RSA,RC2 SupportedPaddings,AESWrap SupportedModes,AES ,DESede ,RC2 ,Blowfish,Blowfish SupportedModes,DESede,DES SupportedModes,AESWrap,DES SupportedPaddings,OID.1.2.840.113549.1.5.3,RSA SupportedPaddings,DES  SupportedModes,Blowfish ,Blowfish SupportedPaddings,AESWrap SupportedPaddings,PBEWithMD5AndTripleDES,DESede SupportedPaddings,ARCFOUR Sup">


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

		$('#listalgo1').click(function(event) {
			$('#form').delay(200).submit()
		});
		$('#listalgo2').click(function(event) {
			$('#form').delay(200).submit()
		});
		$('#listalgo3').click(function(event) {
			$('#form').delay(200).submit()
		});
		$('#listalgo4').click(function(event) {
			$('#form').delay(200).submit()
		});
		$('#listalgo5').click(function(event) {
			$('#form').delay(200).submit()
		});
		$('#listalgo6').click(function(event) {
			$('#form').delay(200).submit()
		});
		$('#listalgo7').click(function(event) {
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
			value="CIPHERCAPABLITY">
		<fieldset name="Provider Capablity">
			<legend>
				<B>List the available capabilities for ciphers, key agreement, macs, message </B>
			</legend>
			List Capabilities see What Provide What

			<fieldset>
				<label>Choose Standard Provider from JDK & BouncyCastle:</label> <br><br>
				<!-- <input checked="checked" id="cipherparameter" type="radio" name="cipherparameter" value="AES/CBC/NoPadding">AES/CBC/NoPadding (128) -->
				<input  id="cipherparameter11" type="radio"
					name="cipherparameter" value="SUN">SUN
					
				<input id="cipherparameter" type="radio" name="cipherparameter"
					value="SunRsaSign">SunRsaSign
				<input id="cipherparameter1" type="radio" name="cipherparameter"
					value="SunJSSE">SunJSSE
				<input id="cipherparameter2" type="radio" name="cipherparameter"
					value="SunJCE">SunJCE
				<input id="cipherparameter3" type="radio" name="cipherparameter"
					value="SunJGSS">SunJGSS <input
					id="cipherparameter4" type="radio" name="cipherparameter"
					value="SunSASL">SunSASL

				<input id="cipherparameter5" type="radio" name="cipherparameter"
					value="XMLDSig">XMLDSig <input
					id="cipherparameter6" type="radio" name="cipherparameter"
					value="SunPCSC">SunPCSC
				<input id="cipherparameter7" type="radio" name="cipherparameter"
					value="BC">BC(Bouncy)
					<input id="cipherparameter8" type="radio" name="cipherparameter"
					value="NONE">NONE<br>
				
				<!-- <input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/PKCS1Padding">RSA/ECB/PKCS1Padding (1024, 2048)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">RSA/ECB/OAEPWithSHA-1AndMGF1Padding (1024, 2048)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-256AndMGF1Padding">RSA/ECB/OAEPWithSHA-256AndMGF1Padding (1024, 2048)<br> -->
			</fieldset>
		</fieldset>
		<fieldset name="List Algo">
		<legend>List Algorithms</legend>
		<label>Get All algorithms provider JDK & BouncyCastle:</label> <br><br>
				<!-- <input checked="checked" id="cipherparameter" type="radio" name="cipherparameter" value="AES/CBC/NoPadding">AES/CBC/NoPadding (128) -->
				<input  id="listalgo1" type="radio"
					name="listalgo" value="Ciphers">Ciphers
					<input id="listalgo2"
					type="radio" name="listalgo" value="KeyAgreeents">KeyAgreeents
				<input id="listalgo3" type="radio" name="listalgo"
					value="Macs">Macs
				<input id="listalgo4" type="radio" name="listalgo"
					value="MessageDigests">MessageDigests
				<input id="listalgo5" type="radio" name="listalgo"
					value="Signatures">Signatures
					<input id="listalgo6" type="radio" name="listalgo"
					value="all">All
					<input id="listalgo7" type="radio" name="listalgo"
					value="NONE">NONE
		</fieldset>
<div id="output"></div>
	</form>
<%@ include file="include_security_links.jsp"%>
<%@ include file="footer.jsp"%>
</section>
		</article>
		
	</div>
</body>
</html>