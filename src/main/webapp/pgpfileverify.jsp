<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html>
<head>
	<title>pgp verifies an encrypted file signtaure </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>


	<meta name="description"
		  content="pgp verifies an encrypted file  online "/>
	<meta name="keywords"
		  content="pgp file verification online, pgp verify signature,pgp verify online,verify pgp signed message online,pgp verify online "/>

	<meta name="author" content="ANISH" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="include_css.jsp"%>
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
<body>
<div id="page">
	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>

	<article id="contentWrapper" role="main">
		<section id="content">
			<form id="form1" action="PGPFunctionality"   name="form1" enctype="multipart/form-data" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="VERIFY_PGP_FILE">
				<fieldset name="PGP Verify File Signature">
					<legend>
						<B>PGP Verify File Signature</B>
					</legend>
					<table border="0" style="width:40pc">
						<tr>
							<th width="30%">Upload to Verify PGP file Signature Against Public Key <input type="file" name="file">
							</th>
							<th>
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
								Input pgp public Key Here <textarea cols="50" name="pKey" id="pKey" rows="20"><%=pKey%></textarea>
							</th>

							<th>
								Example PGP Message file <textarea cols="50" name="samplePGPFile" id="samplePGPFile" rows="20">-----BEGIN PGP MESSAGE-----
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



							</th>
						</tr>
						<tr>
							<td>
								<input type="submit" value="Submit" size="30">

							</td>
							<td>


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
								<br/>

							</td>
							<td>
								PGP signatures provide file integrity verification in addition to file identity verification
							</td>
						</tr>
					</table>




				</fieldset>

			</form>

			<br/>
			<%@ include file="include_security_links.jsp"%>
			<%@ include file="footer.jsp"%>



		</section>
	</article>

</div>
</body>
</html>