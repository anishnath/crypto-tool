<!DOCTYPE html>
<html>
<head>
	<title>Online Test rootCA/IntermediateCA,Certs Generation </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Online Test rootCA/IntermediateCA,Certs Generation, Generate Test ca certificate authority,Create your own certificate authority (for testing)">
	<meta name="keywords"
		  content="test ca certificate generate online, generate ca authority,create your own certificate authority,ssl certificate check,digicert ssl checker,openssl create ca and sign certificate,openssl create intermediate ca
 ">
	<%@ include file="include_css.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {

			$('#generateca').click(function (event)
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
					url: "GenCAFunctionality", //this is my servlet
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
			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="GENERATE_TEST_CA">
				<fieldset name="Generate Test CA Certificate">
					<legend>
						<B>Generate Test CA Certificate </B>
					</legend>
					Provide CN (Hostname)<input id="p_dns_name" type="text" name="p_dns_name"
												value="">
					<input type="button" id="generateca" name="generateca" value="Click">
					<div id="output"></div>
				</fieldset>

			</form>
			<%@ include file="include_security_links.jsp"%>
			<%@ include file="footer.jsp"%>

			<p><strong>Test CA</strong></p>
			<p>This application currenlty supports the following Test CA Hierarchy</p>
			<p><img src="images/rootCA.png" alt="TestCA Authority" /></p>
			<p><strong>Certificate filename extensions</strong><br />There are several commonly used filename extensions for X.509 certificates.</p>
			<ol>
				<li><strong>.pem</strong> &ndash; (Privacy-enhanced Electronic Mail) Base64 encoded DER certificate, enclosed between "-----BEGIN CERTIFICATE-----" and "-----END CERTIFICATE-----"</li>
				<li><strong>.cer, .crt, .der</strong> &ndash; usually in binary DER form</li>
				<li><strong>.p7b, .p7c</strong> &ndash; PKCS#7 SignedData structure without data, just certificate(s) or CRL(s)</li>
				<li><strong>.p12</strong> &ndash; PKCS#12, may contain certificate(s) (public) and private keys (password protected)</li>
				<li><strong>.pfx</strong> &ndash; PFX, predecessor of PKCS#12</li>
				<li><strong>PKCS#7</strong> is a standard for signing or encrypting</li>
				<li><strong>PKCS#12</strong> evolved from the personal information exchange (PFX) standard and is used to exchange public and private objects in a single file</li>
			</ol>

		</section>
	</article>
</div>
</body>
</html>