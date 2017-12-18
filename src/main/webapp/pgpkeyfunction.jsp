<!DOCTYPE html>
<html>
<head>
	<title>Online PGP key generation tool pretty good privacy generation online </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Online PGP key generation tool pretty good privacy generation pgp, encryption, decryption, tool, online, free, simple PGP Online Encrypt and Decrypt. Tool for PGP Encryption and Decryption. PGP Key Generator Tool.">
	<meta name="keywords"  content="pgp, encryption, decryption, tool, online, free, simple PGP Online Encrypt and Decrypt pgp encryption with blowfish,twofish,aes,cast5,desede">
	<%@ include file="include_css.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {

			$('#genkeypair').click(function (event)
			{
				//
				$('#form').delay(200).submit()

			});

			$('#form').submit(function (event)
			{
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type: "POST",
					url: "PGPFunctionality", //this is my servlet
					// data: "lengthOfString=" +$('#lengthOfString').val()+"&trimignore="+$('#trimignore').val()+"&methodName="+$('#methodName').val(),
					data: $("#form").serialize(),
					success: function(msg){
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
	<%@ include file="include.jsp" %>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<article id="contentWrapper" role="main">
		<section id="content">
			<form id="form" method="POST" enctype="application/x-www-form-urlencoded">
				<input type="hidden" name="methodName" id="methodName"
					   value="GENERATE_PGEP_KEY">
				<fieldset name="Generate PGP Keys">
					<legend>
						<B>Generate PGP Keys  </B>
					</legend>
					Identity<input id="p_identity" type="text" name="p_identity"
												value="" placeholder="Type The Identity...">
					Passphrase<input id="p_passpharse" type="text" name="p_passpharse"
						   value="" placeholder="Type The passphrase...">
					<br/>
					<b>Algo</b>

					<input checked="checked" id="cipherparameter11" type="radio"
						   name="cipherparameter" value="BLOWFISH">BLOWFISH
					<input id="cipherparameter16" type="radio"
						   name="cipherparameter" value="TWOFISH">TWOFISH

					<input
							id="cipherparameter12" type="radio" name="cipherparameter"
							value="AES_256">AES_256

					<input id="cipherparameter13"
						   type="radio" name="cipherparameter" value="AES_192">AES_192

					<input id="cipherparameter14" type="radio"
						   name="cipherparameter" value="AES_128">AES_128


					<input id="cipherparameter15" type="radio"
						   name="cipherparameter" value="CAST5">CAST5


					<input id="cipherparameter17" type="radio"
						   name="cipherparameter" value="TRIPLE_DES">TRIPLE_DES

					<br><b>
					Key Size</b>
					<input id="keysize1" checked type="radio"
						   name="p_keysize" value="1024">1024
					<input id="keysize2" type="radio"
						   name="p_keysize" value="2048">2048
					<input id="keysize3" type="radio"
						   name="p_keysize" value="4096">4096 (Performance Suffer )
					<br>
					<input type="button" id="genkeypair" name="genkeypair" value="Generate Keypair">

					<div id="output"></div>
				</fieldset>

			</form>
			<%@ include file="include_security_links.jsp"%>
			<%@ include file="footer.jsp"%>

			<br>
			<br>
			<br>
			<br>
			<p><strong>Pretty Good Privacy or PGP</strong> is a popular program used to encrypt and decrypt email over the Internet, as well as authenticate messages with digital signatures and encrypted stored files.</p>
			<p><strong>PGP</strong> and similar software follow the <strong>OpenPGP</strong> standard (RFC 4880) for encrypting and decrypting data.</p>
			<p>When we generate a public-private keypair in P<strong>GP, it gives us the option of selecting DSA or RSA</strong>, This tool generate RSA keys. RSA is an algorithm.PGP is originally a piece of software, now a standard protocol, usually known as OpenPGP.</p>
			<p><strong>PGP Vs OpenPGP</strong><br />PGP is a proprietary encryption solution, and the rights to its software are owned by Symantec</p>

		</section>
	</article>
</div>
</body>
</html>