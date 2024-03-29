<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
	<title>pgp verify signature online. </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="pgp verify message signature "/>
	<meta name="keywords" content="pgp signatuare verification, how to verify pgp signature file, pgp tutorial, openpgp,gpg verify signatyre "/>
	<meta name="author" content="ANISH" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "PGP Signature Verification",
  "image" : "https://8gwifi.org/images/site/pgpv.png",
  "url" : "https://8gwifi.org/pgpfileverify.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-12-02",
  "applicationCategory" : [ "pgp signature verification", "pgp message verification" , "Verify pgp message with pgp public key file" ],
  "downloadUrl" : "https://8gwifi.org/pgpfileverify.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : ""pgp signature verification, pgp message verification , Verify pgp message with pgp public key file, pgp tutorial , how pgp works",
  "softwareVersion" : "v1.0"
}
</script>

	<script type="text/javascript">
		$(document).ready(function() {


			$('#form').submit(function(event) {
				//

				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				var formData = new FormData($(this)[0]);
				$.ajax({
					type : "POST",
					url : "PGPFunctionality", //this is my servlet
					processData: false, // Don't process the files
					contentType: false,
					data : formData,
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
<h1 class="mt-4">PGP Verify File Signature</h1>
<hr>
<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<p>

			<form id="form1" action="PGPFunctionality"   name="form1" enctype="multipart/form-data" method="POST">
				<input type="hidden" name="methodName" id="methodName" value="VERIFY_PGP_FILE">

	<div class="form-group">
		<label for="file"><strong>Upload to Verify PGP file Signature Against Public Key</strong> </label>
		<input type="file" class="form-control-file" id="file" name="file">
	</div>


								<%

									String pKey =(String)session.getAttribute("pKey");
									if(null==pKey || pKey.trim().length()==0)
									{
										pKey="-----BEGIN PGP PUBLIC KEY BLOCK-----\n" +
												"Version: BCPG v1.58\n" +
												"\n" +
												"mI0EWiDkcQEEANhVhYz3NAbRhpQST2vqsV3nIg9Zx6lWY6viB/wBkbs14KLGPX8D\n" +
												"DLBkfGonRtknGIU+0cUEnyNvxE5K5VvRMrqeGzusz+iG3jX9zRomeQtOKL9xQJEJ\n" +
												"fqJ/Y09KbiZy37x85FAlmmfh7xsxHHLN4zZqbDArLBOTKDDk9C2vQ0Y/ABEBAAG0\n" +
												"BWFuaXNoiJwEEAECAAYFAlog5HEACgkQlN3e89Fl/7YDuQQA0TTw0iYX9kBmMXGF\n" +
												"CCWEZyJAhqueYDFhJ29+fvcKLN37Agn595oC8/h3mjylyEeaIsdkVL8rVUzexji6\n" +
												"esiHZyWoDvzti8cqq5kp146gkYOSEoBiTkGN9Lds1qvDrOZDWvD1HtAWBhDNc/kH\n" +
												"d/4//xH/VMk12zxr/8WLJ9lU6rs=\n" +
												"=c9OB\n" +
												"-----END PGP PUBLIC KEY BLOCK-----";
									}

								%>


	<div class="form-group">
		<label for="pKey" class=bold><strong>Input pgp public Key Here</strong></label>
		<textarea class="form-control"  cols="20" name="pKey" id="pKey" rows="10"><%=pKey%></textarea>
	</div>

	<hr>

	<div class="form-group">
		<label for="pKey"><strong>Example Signature file  PGP Message file (Armored) save and upload it </strong></label>
		<textarea class="form-control" readonly="true"  cols="10" name="samplePGPFile" id="samplePGPFile" rows="5">-----BEGIN PGP MESSAGE-----
Version: BCPG v1.58

owJ4nNWWS2gTQRjH09YqLdSKF7UUjcGDgjubpC3UuE2pUKHQ1qJipVrKZDPZTrqZ
WXc2jyKoaBXxUAtt0auKICLUg+hBVLwJFh948qCCCOJFlB70Vmc3r9lm+7goeElm
vu8/M7/vv7MzO9VQ46uumvnwceEtWnxY9fLFQGyDQVMgl9KHmqWcYpg0iVTLz/uE
dQRGLcuIyHIKZhAB0IDqKALU1OSBQ31yKwiCYCCvjOQYLqmz2SzItji6cDAYko/3
9R7hA1NQwoRZkKgoUO/38xER5oR7qQotTMkalvMvp3ACUqZ1JDgSBDkWD0T5EkqK
xpF+DJmMzx51JlBkV8wWaSZNGz3xKJ8GtGtZnMCKXIzZeWhaOAFVi3dVc9ywqCIL
IVvBMcaghokWzUJTkctdO5kpLBWyl5cO9vR39SpyRlifwBQqzOzvs8vwD6IYNAxF
djK2JG3q0WUqV2Q7aYviyEAkjoiKEbMDYmg8HxCqTaYJtlyFOmmhsoLCXasjKtK3
gHYQchXjpJlKDRS1EOOj8+08jbwUx4NvCaXKtyZLE5DkS6DxClwPaEcoMWRyKi/4
JSUc7u7t7jrSXVGEF+7fR9aRp+F/nTkJMzAHsgyYbC3AzGwJhSRo4P/KYFXHiPwT
f11HSoymeUKFzNLRElgRMqYampSMj4XaKKlkFE6RtnYBzBuo1Kirc7HV8b6IVjhF
7JOFm2pQwv0RN4CtF0gcnYeJtixTOmTbQFgA5KmVEUXAcngNDgpit41jOOdppDDA
282ywPvfVUkxKP4qOyXJuaGYfVBniIkMyrBFzXHA/S2xyEkah5KFU6jc8ktSacpV
LCmNWc0LQbiyDWGwD7RW+uDx5CoB3Rvefjc1SjUd8YrjCGjMfgjLbvp8etnNHub3
S3iF3V7vYixce0osjfXiTAlMoN5fvmAVuRxxRhfE/NLOf/hE6y/fWuerqvY11FYP
+b9uWd8MCWajvvq6TcWPpppAzeKJo+t3nH2yfX5+4JPv5c+Tz87Pbkw0m4+a3kvb
Lr85MDn1ZDo5d/NiYqT29+3grcbgA7z//bvZ6Q8z1+cu3hsKDN+/23jp9Ozzc8NX
L3TunXx8I7Lr4Z5tY98fjW6NvRocrHkNMxPXgNk5EZH7P29u+Xaq48fCzS+/TtTe
vXJn8EzT7t9P/wBbfxTc
=MQ43
-----END PGP MESSAGE-----
</textarea>
	</div>

	<input class="btn btn-primary" type="submit" value="Submit" size="30">


			</form>

<div id="output">

	<%

		String value =(String)session.getAttribute("msg");
		if(null==value)
		{
			value="";
		}

	%>

	<%=value%>




</div>

<hr>

 <div class="card my-4">
     <h5 class="card-header">Other PGP Tools</h5>
     <ul>
         <li><a href="pgpencdec.jsp">PGP Encryption/Decryption  </a></li>
         <li><a href="pgpkeyfunction.jsp">PGP Key Generation  </a></li>
         <li><a href="PGPFunctionality?invalidate=yes">PGP Signature Verifier  </a></li>
         <li><a href="pgpdump.jsp">PGP KeyDumper</a></li>
         <li><a href="pgp-upload.jsp">PGP Send Encrypt files</a></li>
         <li><a href="pgp-file-decrypt.jsp">PGP Decrypt files</a></li>
     </ul>
 </div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<hr>

<h2 class="mt-4" id="thersaalgorithm"><a href="docs/gpg.jsp">Pretty Good Privacy</a></h2>
<p><strong>PGP signatures provide file integrity verification in addition to file identity verification</strong></p>
<p><strong>Pretty Good Privacy or PGP</strong> is a popular program used to encrypt and decrypt email over the Internet, as well as authenticate messages with digital signatures and encrypted stored files.</p>
<p><strong>PGP</strong> and similar software follow the <strong>OpenPGP</strong> standard (RFC 4880) for encrypting and decrypting data.</p>
<p>When we generate a public-private keypair in P<strong>GP, it gives us the option of selecting DSA or RSA</strong>, This tool generate RSA keys. RSA is an algorithm.PGP is originally a piece of software, now a standard protocol, usually known as OpenPGP.</p>
<p><strong>PGP Vs OpenPGP</strong><br />PGP is a proprietary encryption solution, and the rights to its software are owned by Symantec</p>

<p> <a href="/docs/gpg.jsp"> Learn More about GPG here</a>

	<%@ include file="addcomments.jsp"%>

	</div>

<%@ include file="body-close.jsp"%>