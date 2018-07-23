<!DOCTYPE html>
<html>
<head>
	<title>Online Cipher Algorithms, Encryption Decryption using aes,aes/cbc/nopadding,aes/cbc/pkcs5padding,aes/ecb/nopadding,aes/ecb/pkcs5padding,aes_128/cbc/nopadding,aes_128/cfb/nopadding,aes_128/ecb/nopadding,aes_128/gcm/nopadding,aes_128/ofb/nopadding,aes_192/cbc/nopadding,aes_192/cfb/nopadding,aes_192/ecb/nopadding,aes_192/gcm/nopadding,aes_192/ofb/nopadding,aes_256/cbc/nopadding,aes_256/cfb/nopadding,aes_256/ecb/nopadding,aes_256/gcm/nopadding,aes_256/ofb/nopadding,aria,blowfish,blowfish,camellia,cast5,cast6,chacha,des,des/cbc/nopadding,des/cbc/pkcs5padding,des/ecb/nopadding,des/ecb/pkcs5padding,desede,desede,desede/cbc/nopadding,desede/cbc/pkcs5padding,desede/ecb/nopadding,desede/ecb/pkcs5padding,gcm,gost28147,grain128,grainv1,hc128,hc256,idea,noekeon,pbe,rc2,rc5,rc6,rijndael,salsa20,seed,shacal-2,skipjack,sm4,serpent,shacal2,tea,threefish-1024,threefish-256,threefish-512,tnepres,twofish,vmpc,vmpc-ksa3,xtea</title>


	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>


	<%@ include file="include_css.jsp"%>
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
					   value="CIPHERBLOCK_NEW">
				<fieldset name="Cipher Functionality">
					<legend>
						<B>Encrypt/Decrypt Message </B>
					</legend>
					<table>
						<tr>
							<td>
								<b>Choose Cipher</b><select name="cipherparameternew" id="cipherparameternew">
								<option selected value="<%="AES/CBC/PKCS5PADDING"%>">AES/CBC/PKCS5PADDING</option>
								<%
									String[] validList = { "AES","AES/CBC/NOPADDING","AES/ECB/NOPADDING","AES/ECB/PKCS5PADDING","AES_128/CBC/NOPADDING","AES_128/CFB/NOPADDING","AES_128/ECB/NOPADDING","AES_128/GCM/NOPADDING","AES_128/OFB/NOPADDING","AES_192/CBC/NOPADDING","AES_192/CFB/NOPADDING","AES_192/ECB/NOPADDING","AES_192/GCM/NOPADDING","AES_192/OFB/NOPADDING","AES_256/CBC/NOPADDING","AES_256/CFB/NOPADDING","AES_256/ECB/NOPADDING","AES_256/GCM/NOPADDING","AES_256/OFB/NOPADDING","ARIA","BLOWFISH","CAMELLIA","CAST5","CAST6","CHACHA","DES","DES/CBC/NOPADDING","DES/CBC/PKCS5PADDING","DES/ECB/NOPADDING","DES/ECB/PKCS5PADDING","DESEDE","DESEDE/CBC/NOPADDING","DESEDE/CBC/PKCS5PADDING","DESEDE/ECB/NOPADDING","DESEDE/ECB/PKCS5PADDING","GCM","GOST28147","GRAIN128","GRAINV1","HC128","HC256","IDEA","NOEKEON","PBEWITHMD2ANDDES","PBEWITHMD5AND128BITAES-CBC-OPENSSL","PBEWITHMD5AND192BITAES-CBC-OPENSSL","PBEWITHMD5AND256BITAES-CBC-OPENSSL","PBEWITHMD5ANDDES","PBEWITHMD5ANDRC2","PBEWITHSHA1ANDDES","PBEWITHSHA1ANDRC2","PBEWITHSHA256AND128BITAES-CBC-BC","PBEWITHSHA256AND192BITAES-CBC-BC","PBEWITHSHA256AND256BITAES-CBC-BC","PBEWITHSHAAND128BITAES-CBC-BC","PBEWITHSHAAND128BITRC2-CBC","PBEWITHSHAAND128BITRC4","PBEWITHSHAAND192BITAES-CBC-BC","PBEWITHSHAAND2-KEYTRIPLEDES-CBC","PBEWITHSHAAND256BITAES-CBC-BC","PBEWITHSHAAND3-KEYTRIPLEDES-CBC","PBEWITHSHAAND40BITRC2-CBC","PBEWITHSHAAND40BITRC4","PBEWITHSHAANDIDEA-CBC","PBEWITHSHAANDTWOFISH-CBC","PBEWITHHMACSHA1ANDAES_128","PBEWITHHMACSHA1ANDAES_256","PBEWITHHMACSHA224ANDAES_128","PBEWITHHMACSHA224ANDAES_256","PBEWITHHMACSHA256ANDAES_128","PBEWITHHMACSHA256ANDAES_256","PBEWITHHMACSHA384ANDAES_128","PBEWITHHMACSHA384ANDAES_256","PBEWITHHMACSHA512ANDAES_128","PBEWITHHMACSHA512ANDAES_256","PBEWITHMD5ANDDES","PBEWITHMD5ANDTRIPLEDES","PBEWITHSHA1ANDDESEDE","PBEWITHSHA1ANDRC2_128","PBEWITHSHA1ANDRC2_40","PBEWITHSHA1ANDRC4_128","PBEWITHSHA1ANDRC4_40","RC2","RC5","RC6","RIJNDAEL","SALSA20","SEED","SHACAL-2","SKIPJACK","SM4","SERPENT","SHACAL2","TEA","THREEFISH-1024","THREEFISH-256","THREEFISH-512","TNEPRES","TWOFISH","VMPC","VMPC-KSA3","XTEA" };
									for (int i = 0; i < validList.length; i++) {
										String param = validList[i];
								%>
								<option value="<%=param%>"><%=param%></option>
								<%	} %>
							</select>
							</td>
							<td colspan="4">
								<%@ include file="footer_adsense.jsp"%>
							</td>
						</tr>
						<tr>
							<td>
								<b>Type Something</b>
								<textarea rows="5" cols="30" name="plaintext" placeholder="Type Something here..." id="plaintext"></textarea>
							</td>
						</tr>
						<tr>
							<td>
								<b>SecretKey</b><input id="secretkey" type="text" name="secretkey"
													   size="40" placeholder="2b7e151628aed2a6abf71589"
													   value="2b7e151628aed2a6abf71589">
							</td>
						</tr>
						<tr>
							<td>
								<input checked="checked"
									   id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">Encrypt
								<input id="decrypt" type="radio" name="encryptorDecrypt"
									   value="decrypt">Decrypt
							</td>
						</tr>
					</table>
					<div id="output"></div>
				</fieldset>

			</form>
			<%@ include file="include_security_links.jsp"%>
			<%@ include file="footer.jsp"%>


		</section>
	</article>

</div>
</body>
</html>