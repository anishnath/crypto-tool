<!DOCTYPE html>
<html>
<head>

	<title>Online Generate SSH keys algorithm RSA,DSA,ECDSA </title>

	<%@ include file="include_css.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {

			$('#ecdsakeysize').hide();
			$('#rsakeysize').show();
			$('#dsakeysize').hide();


			$('#rsa').click(function (event)
			{
				$('#ecdsakeysize').hide();
				$('#rsakeysize').show();
				$('#dsakeysize').hide();
				$('#form').delay(200).submit()

			});

			$('#dsa').click(function (event)
			{
				$('#ecdsakeysize').hide();
				$('#rsakeysize').hide();
				$('#dsakeysize').show();
				$('#form').delay(200).submit()

			});

			$('#ecdsa').click(function (event)
			{
				$('#ecdsakeysize').show();
				$('#rsakeysize').hide();
				$('#dsakeysize').hide();
				$('#form').delay(200).submit()

			});

			$('#rsa1024').click(function (event)
			{
				$('#form').delay(200).submit()

			});

			$('#rsa2048').click(function (event)
			{
				$('#form').delay(200).submit()

			});

			$('#rsa4096').click(function (event)
			{

				$('#form').delay(200).submit()

			});

			$('#ecdsa256').click(function (event)
			{

				$('#form').delay(200).submit()

			});

			$('#ecdsa384').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#ecdsa512').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa512').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa576').click(function (event)
			{
				$('#form').delay(200).submit()
			});


			$('#dsa640').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa704').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa768').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa832').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa896').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa960').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa1024').click(function (event)
			{
				$('#form').delay(200).submit()
			});

			$('#dsa2048').click(function (event)
			{
				$('#form').delay(200).submit()
			});












			$('#passphrase').keyup(function (event)
			{
				//
				$('#form').delay(200).submit()

			});

			$('#generatessh-keys').click(function (event)
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
					url: "SSHFunctionality", //this is my servlet
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
					   value="GENERATE_SSHKEYGEN">
				<fieldset name="Generate SSH Keygenerate">
					<legend>
						<B>SSH-Keygen Online </B>
					</legend>
					Algorithm

					<input checked="checked" id="rsa" type="radio"
						   name="sshalgo" value="RSA">RSA
					<input id="dsa" type="radio"
						   name="sshalgo" value="DSA">DSA
					<input  id="ecdsa" type="radio"
						   name="sshalgo" value="ECDSA">ECDSA

					<div id="rsakeysize">
						 <b>RSA Key Size</b>
						<input  id="rsa1024" type="radio"
							   name="sshkeysize" value="1024">1024
						<input id="rsa2048" type="radio"
							   name="sshkeysize" value="2048">2048
						<input checked id="rsa4096" type="radio"
							   name="sshkeysize" value="4096">4096
					</div>

					<div id="ecdsakeysize">
						<b>ECDSA Key Size </b>
						<input  id="ecdsa256" type="radio"
							   name="sshkeysize" value="256">256
						<input id="ecdsa384" type="radio"
							   name="sshkeysize" value="384">384
						<input checked="checked" id="ecdsa512" type="radio"
							   name="sshkeysize" value="521">521

					</div>

					<div id="dsakeysize">
						<b>DSA Key Size</b>
						<input id="dsa512" type="radio"
							   name="sshkeysize" value="512">512
						<input id="dsa576" type="radio"
							   name="sshkeysize" value="576">576
						<input id="dsa640" type="radio"
							   name="sshkeysize" value="640">640
						<input id="dsa704" type="radio"
							   name="sshkeysize" value="704">704
						<input id="dsa768" type="radio"
							   name="sshkeysize" value="768">768
						<input id="dsa832" type="radio"
							   name="sshkeysize" value="832">832
						<input id="dsa896" type="radio"
							   name="sshkeysize" value="896">896
						<input id="dsa960" type="radio"
							   name="sshkeysize" value="960">960
						<input id="dsa1024" type="radio"
							   name="sshkeysize" value="1024">1024
						<input checked id="dsa2048" type="radio"
							   name="sshkeysize" value="2048" >2048

					</div>

					Passphrase <input id="passphrase" type="text" name="passphrase" placeholder="for encrypted keys" size="30"
												value="">
					<input type="button" id="generatessh-keys" name="generatessh-keys" value="Generate-SSH-Keys">

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