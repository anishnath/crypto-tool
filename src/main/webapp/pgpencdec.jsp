<!DOCTYPE html>
<html>
<head>
	<title>Online PGP Encryption Decryption tool using pgp public private keys </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="pgp, encryption, decryption, tool, online, free, simple PGP Online Encrypt and Decrypt. Tool for PGP Encryption and Decryption. PGP Key Generator Tool.">
	<meta name="keywords"  content="pgp, encryption, decryption, tool, online, free encrypt decrypt pgp messages using pgp private key">
	<%@ include file="include_css.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {

			$('#encryptmsg').show();
			$('#descryptmsg').hide();

			$('#encrypt').click(function (event)
			{
				//
				$('#encryptmsg').show();
				$('#descryptmsg').hide();

			});

			$('#decrypt').click(function (event)
			{
				//
				$('#encryptmsg').hide();
				$('#descryptmsg').show();

			});

			$('#decryptbutton').click(function(event) {
				$('#form').delay(200).submit()
			});


			$('#p_cmsg').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#p_publicKey').keyup(function(event) {
				//
				// event.preventDefault();
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
					   value="PGP_ENCRYPTION_DECRYPTION">
				<fieldset name="PGP Encrytion Decryption ">
					<legend>
						<B>PGP Encrytion Decryption  </B>
					</legend>
					<b>Encrypt/Decrypt</b>

					<input checked="checked" id="encrypt" type="radio"
						   name="encryptdecrypt" value="encrypt">encrypt message

					<input id="decrypt" type="radio"
						   name="encryptdecrypt" value="decrypt">decrypt pgp message

					<br><b>
					<div id="descryptmsg">

						PGP Message <textarea rows="10" cols="50" id="p_pgpmessage" name="p_pgpmessage" placeholder="-----BEGIN PGP MESSAGE-----
Version: BCPG v1.58

hIwDmCS94uDDx9kBA/9hH8V38pyzUOvcBPa5Rcv38doT3zJ/tvhxI/5h+1tF5sPg
nmeQDs7D829eR9x6nMos395hbJZezx+iGn1tfdhBoy0FpH3KHTNY+0qLNu37qVwU
ogXF+tQ3umq/CUqQgpETHS/awvuNhvRfo240u+tmrXUZl18fDdAVg6BKpgMmH9Ju
AVPnVI+0DoCls0IKZSegwO5T0Cj/D/fJuT7VSxCHCtJ6aAS1F8TAfn98oiik3CzS
9oBh+KHqawk3supbiXPmpJdyV45oOfV4fsVPnP8zbtLtQNv6EBO+mEwday9Hq2xo
+sxxQx0poYZDI7sq4i8=
=v0g9
-----END PGP MESSAGE-----"></textarea>
						PGP Private Key <textarea rows="10" cols="50" id="p_privateKey" name="p_privateKey" placeholder="-----BEGIN PGP PRIVATE KEY BLOCK-----
Version: BCPG v1.58

lQH+BFojjHkBBACJghEFJ0kOeHnvpp5ADbI8r2ZtkLAtbBiARKZsiW4dsVrpbify
lUyFEqm5CzhKuAjiJcxtH4bq7lFgTNvgDWs6uY5MS62Jh1+AMANkOo73d8RPAdbl
Y6k9ExCsmbZgcHrBLMFMW/rzsFS3Vil6XMkl7SEIaClgFFcxu3ubhGsMlwARAQAB
/gQDApBPMSbTsvQjYNgi3vBAHHkJ5YurFXAPWeZ87jXJ/DdruVoK5cXqdgg4g5Sz
9ZBE2rkcJ7qL54I2zMEZaXmQeqANqfhRuJH2E8DlRW6wbt2jU5WorD/a/5iTcjGu
/AfBRIktji4LW/BcsKnXirDZK12IjxYjyCHv4AY3P/v6Osf91zdmg9C1S7vuwz5I
2hXqJBj7jhyZ2y/C6CP84Rnr7XyvqQxNV1BDIJH21z4er15axuY23pywA6I8Qqwm
I5vaSmJlBHwpQ22Fh5EkltMIHNqcpQ50HoNL/XKwXy1PvgyEA79462RvTY6Bj6JE
WPEHCFa9mvuubeXOO7D1S9pM3ygpuwQiR9F4EFCWU5m5xR1Wr2QlftiJI7Fhyg7M
ttkyjEW0AX6RbGgbhKnCOaiDO7CJpSULwwkMfOGAWYwrsxcJh8LqZVEUVrH//Ajo
kNPN+u9X0U/g4Vt5aKuEygFkF0QcLruOW/BUgpH4KFUWtAVhbmlzaIicBBABAgAG
BQJaI4x5AAoJEJgkveLgw8fZR3sD/1LbEpN5co+Rpx8qEx2TM/rFBaRZWp+2oKh3
+qVdj4HW/TjAlWrjMJfW4z2PR0h0IP2t4E0OajavbcYiNuBbKNkNwEel3FZNsEMU
uqayfYpj4tZ6V2qwsGZBIFi11i7kCx6MUVh3/aJVKnluz5MEJSdSvSG/OaQk78de
gze0MEL/
=5jHf
-----END PGP PRIVATE KEY BLOCK-----"></textarea>
						<br/>
						Passphrase<input id="p_passpharse" type="text" name="p_passpharse"
										 value="" placeholder="anish">
						<br/>
						<input type="button" id="decryptbutton" name="decryptbutton" value="Decrypt PGP Message.....">
					</div>

					<div id="encryptmsg">
						Clear Text Message <textarea rows="10" cols="50" placeholder="Type Something Here..."  name="p_cmsg" id="p_cmsg"></textarea>
						PGP Public Key <textarea rows="10" cols="50" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----"  name="p_publicKey" id="p_publicKey">-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----</textarea>
						<br/>
					</div>
					<div id="output"></div>
				</b>
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