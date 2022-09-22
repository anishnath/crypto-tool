<!DOCTYPE html>
<html>
<head>
	<title>Online PGPDump, decode pgp publi/private keys  </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="pgpdump, pgpdump of private keys, parse pgp packet, parse pgp private keys, parse pgp public keys,pgpdump online, find keyid of pgp message">
	<meta name="keywords"  content="pgpdump, pgpdump of private keys, parse pgp packet, parse pgp private keys, parse pgp public keys">
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<head>

		<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
		<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Online PGP Encryption Decryption tool using pgp public private keys",
  "image" : "https://8gwifi.org/images/site/pgpdump.png",
  "url" : "https://8gwifi.org/pgpdump.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2021-06-04",
  "applicationCategory" : [ "dump pgp packet", "pgpdump online", "pgp dump public keys", "pgpdump private keys"]
  "downloadUrl" : "https://8gwifi.org/pgpdump.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : "pgpdump, pgpdump of private keys, parse pgp packet, parse pgp private keys, parse pgp public keys,pgpdump online, find keyid of pgp message",
  "softwareVersion" : "v1.0"
}
</script>

<script type="text/javascript">
		$(document).ready(function() {

			$('#encryptmsg').show();
			
			$('#pgpdump').click(function (event)
			{
				//
				$('#form').delay(200).submit()

			});

			$('#p_dump').keyup(function(event) {
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

<%@ include file="body-script.jsp"%>
<h1 class="mt-4">PGP Dump Packet</h1>
<p>This Tool will displays the packet format of OpenPGP (RFC 4880) and PGP version 2 (RFC 1991).we don't currently decode every packet type, but on being able to do what people actually have to 95% of the time. Currently supported things include</p>
<hr>


<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>


<form id="form" class="form-horizontal" method="POST" enctype="application/x-www-form-urlencoded">
	<input type="hidden" name="methodName" id="methodName"
		   value="PGP_DUMP">
    <input type="hidden" name="j_csrf" value="<%=request.getSession().getId() %>" >
	<div id="encryptmsg">
		<textarea rows="10" cols="50" placeholder="-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: BCPG v1.58

mI0EWiOMeQEEAImCEQUnSQ54ee+mnkANsjyvZm2QsC1sGIBEpmyJbh2xWuluJ/KV
TIUSqbkLOEq4COIlzG0fhuruUWBM2+ANazq5jkxLrYmHX4AwA2Q6jvd3xE8B1uVj
qT0TEKyZtmBwesEswUxb+vOwVLdWKXpcySXtIQhoKWAUVzG7e5uEawyXABEBAAG0
BWFuaXNoiJwEEAECAAYFAlojjHkACgkQmCS94uDDx9lHewP/UtsSk3lyj5GnHyoT
HZMz+sUFpFlan7agqHf6pV2Pgdb9OMCVauMwl9bjPY9HSHQg/a3gTQ5qNq9txiI2
4Fso2Q3AR6XcVk2wQxS6prJ9imPi1npXarCwZkEgWLXWLuQLHoxRWHf9olUqeW7P
kwQlJ1K9Ib85pCTvx16DN7QwQv8=
=Qteg
-----END PGP PUBLIC KEY BLOCK-----"  name="p_dump" id="p_dump">-----BEGIN PGP PUBLIC KEY BLOCK-----
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
		<hr>
	</div>
<input type="button" class="btn btn-primary"  id="pgpdump" name="pgpdump" value="Dump PGP">
	<div id="output"></div>
	</b>
</form>
<hr>

<hr>
<h2 class="mt-4">Related Links</h2>
<div class="row">
    <div>
        <ul>
            <li><a href="pgpencdec.jsp">PGP encryption & decryption</a></li>
            <li><a href="pgpkeyfunction.jsp">PGP Key Generation</a></li>
            <li><a href="PGPFunctionality?invalidate=yes">PGP Singature Verifier</a></li>
        </ul>
    </div>
</div>


<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>

	<h2 class="mt-4" id="thersaalgorithm"><a href="docs/gpg.jsp">Pretty Good Privacy</a></h2>

<p><strong>Pretty Good Privacy or PGP</strong> is a popular program used to encrypt and decrypt email over the Internet, as well as authenticate messages with digital signatures and encrypted stored files.</p>
<p><strong>PGP</strong> and similar software follow the <strong>OpenPGP</strong> standard (RFC 4880) for encrypting and decrypting data.</p>
<p>When we generate a public-private keypair in P<strong>GP, it gives us the option of selecting DSA or RSA</strong>, This tool generate RSA keys. RSA is an algorithm.PGP is originally a piece of software, now a standard protocol, usually known as OpenPGP.</p>
<p><strong>PGP Vs OpenPGP</strong><br />PGP is a proprietary encryption solution, and the rights to its software are owned by Symantec</p>
<p><strong>PGPDump results </strong></p>
<p>Currently supported things include: <p>
<li>Signature packets</li>
<li>Public key packets</li>
<li>Secret key packets</li>
<li>Trust, user ID, and user attribute packets</li>
<li>ASCII-armor decoding and CRC check</li>





	<p> <a href="/docs/gpg.jsp"> Learn More about GPG here</a>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>