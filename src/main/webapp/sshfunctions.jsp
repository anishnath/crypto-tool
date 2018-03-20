<!DOCTYPE html>
<html>
<head>

	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Online Generate SSH keys algorithm RSA,DSA,ECDSA",
  "image" : "https://github.com/anishnath/crypto-tool/blob/master/ssh.png",
  "url" : "https://8gwifi.org/sshfunctions.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-03-11",
  "applicationCategory" : [ "sshkeygen online", "ssh  keygen rsa,dsa,ecdsa", ""],
  "downloadUrl" : "https://8gwifi.org/sshfunctions.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Generate SSH keys algorithm RSA,DSA,ECDSA ssh-keygen online, generate rsa ssh keys, generate ecdsa keys, generate dsa keys, ssh dsa key size 512,576,640,704,768,832,896,960,1024,2048, ssh ecdsa keysize 256,384,521, ssh rsa key size 1024,2046,4096,ssh-rsa key generator,generate ssh2 key online,generate ssh key ubuntu,ssh-keygen options,ssh-keygen filename,putty key generator,ssh-keygen windows
 ",
  "softwareVersion" : "v1.0"
}
</script>
	<title>Online Generate SSH keys algorithm RSA,DSA,ECDSA </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
	<meta name="description" content="Generate SSH keys RSA,DSA,ECDSA ssh-keygen online, generate rsa ssh keys, generate ecdsa keys, generate dsa keys, ssh sa key size 512,576,640,704,768,832,896,960,1024,2048, ssh ecdsa keysize 256,384,521, ssh rsa key size 1024,2046,4096,ssh-keygen example, openssl ssh keypair example, generate ssh keypair using openssl,ssh-rsa key generator,generate ssh2 key online,generate ssh key ubuntu,ssh-keygen options,ssh-keygen filename,putty key generator,ssh-keygen windows">
	<meta name="keywords"
		  content="Generate SSH keys RSA,DSA,ECDSA ssh-keygen online, generate rsa ssh keys, generate ecdsa keys, generate dsa keys, ssh sa key size 512,576,640,704,768,832,896,960,1024,2048, ssh ecdsa keysize 256,384,521, ssh rsa key size 1024,2046,4096,ssh-keygen example, openssl ssh keypair example, generate ssh keypair using openssl,ssh-rsa key generator,generate ssh2 key online,generate ssh key ubuntu,ssh-keygen options,ssh-keygen filename,putty key generator,ssh-keygen windows
 ">
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

			<p><strong>Generate an RSA SSH keypair with a 4096 bit private key</strong><br /><span style="color: #008000;">ssh-keygen -t rsa -b 4096 -C "RSA 4096 bit Keys"</span></p>
			<p><strong>Generate an DSA SSH keypair with a 2048 bit private key</strong><br /><span style="color: #339966;">ssh-keygen -t dsa -b 1024 -C "DSA 1024 bit Keys"</span><br /><strong>Generate an ECDSA SSH keypair with a 521 bit private key</strong><br /><span style="color: #339966;">ssh-keygen -t ecdsa -b 521 -C "ECDSA 521 bit Keys"</span></p>
			<p><strong>Generate an ed25519 SSH keypair- this is a new algorithm added in OpenSSH.</strong> <br /><span style="color: #339966;">ssh-keygen -t ed25519</span></p>
			<p><strong>Extracting the public key from an RSA keypair</strong><br /><span style="color: #339966;">openssl rsa -pubout -in private_key.pem -out public_key.pem</span><br /><strong>Extracting the public key from an DSA keypair</strong><br /><span style="color: #339966;">openssl dsa -pubout -in private_key.pem -out public_key.pem</span></p>
			<p><strong>Copy the public key to the server</strong><br /><strong><em>The ssh-copy-id command</em> </strong><br /><strong>ssh-copy-id</strong> user@hostname copies the public key of your default identity (use -i identity_file for other identities) to the remote host</p>
			<p>SSH Running on different port</p>
			<p><span style="color: #339966;">ssh-copy-id -i "user@hostname -p2222"</span></p>
			<p>-i switch defaults to ~/.ssh/id_rsa.pub, if you want another key, <span style="text-decoration: underline;">put the path of the key after</span></p>
			<p><span style="color: #0000ff;"><strong>Converting keys between openssl and openssh</strong><br /><strong>Extract Public key from the certificate</strong> <br /><span style="color: #339966;">openssl x509 -in cert.pem -noout -pubkey &gt;pubkey.pem</span><br /><span style="color: #339966;">cat pubkey.pem</span> <br /><span style="color: #000000; background-color: #cc99ff;">-----BEGIN PUBLIC KEY-----</span><br /><span style="color: #000000; background-color: #cc99ff;">MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA0TqlveKKlc2MFvEmuXJi</span><br /><span style="color: #000000; background-color: #cc99ff;">LGBsY1t4ML4uiRADGSZlnc+7Ugv3h+MCjkkwOKiOdsNo8k4KSBIG5GcQfKYOOd17</span><br /><span style="color: #000000; background-color: #cc99ff;">AJvqCL6cGQbaLuqv0a64jeDm8oO8/xN/IM0oKw7rMr/2oAJOgIsfeXPkRxWWic9A</span><br /><span style="color: #000000; background-color: #cc99ff;">VIS++H5Qi2r7bUFX+cqFsyUCAwEAAQ==</span><br /><span style="color: #000000; background-color: #cc99ff;">-----END PUBLIC KEY-----</span><br />Use the following command to convert it to authorized_keys entry<br /><span style="color: #339966;">$ ssh-keygen -i -m PKCS8 -f pubkey.pem</span><br /><span style="color: #000000; background-color: #ccffcc;">ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDROqW94oqVzYwW8Sa5cmIsYGxjW3gwvi6JEAMZJmWdz7tSC/eH4wKOSTA4qI52w2jyTgpIEgbkZxB8pg453XvbngfjPMhhAV0XSy3s1wUFGPWlumctOvaowxXf60y7h5zsDTSTHzO5d2agAk6Aix95c+RHFZaJz0BUhL74flCLavttQVf5yoWzJQ==</span><span style="text-decoration: underline;"><br /></span></span></p>


		</section>
	</article>
</div>
</body>
</html>