<!DOCTYPE html>
<p>
<head>
	<title>BCCrypt Hash Generator, Hash Checker </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="description"
		  content="Bccrypt password hash generation online and hash checker bcrypt reverse,bcrypt hash online,bcrypt hash cracker,bcrypt decrypt laravel,bcrypt password encoder,bcrypt encryption "/>
	<meta name="keywords"
		  content="bccrypt online, bcrypt hash calculator,bccrypt hash checker,bccrypt tutorial,scrypt,OpenPGP,Good Password Hashing Functions,PBKDF2,pbkdf2,scrypt,OpenPGP"/>

	<meta name="author" content="CRYPO" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="header-script.jsp"%>

	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Online BCrypt Hash Generator, Hash Checker",
  "image" : "https://8gwifi.org/images/site//bcrypt.png",
  "url" : "https://8gwifi.org/bccrypt.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-01-18",
  "applicationCategory" : [ "bcrypt reverse", "bccrypt online", "bcrypt hash calculator","OpenPGP,Good Password Hashing Function","bcrypt hash online","decrypt laravel","Good Password Hashing Functions"],
  "downloadUrl" : "https://8gwifi.org/bccrypt.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu",
  "requirements" : "Bccrypt password hash generation online and hash checker bcrypt reverse,bcrypt hash online,bcrypt hash cracker,bcrypt decrypt laravel,Good Password Hashing Functions",
  "softwareVersion" : "v1.0"
}
</script>

	<script type="text/javascript">
		$(document).ready(function() {


			$('#password').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#workload1').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#workload2').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#workload3').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#workload4').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#workload5').click(function(event) {
				$('#form').delay(200).submit()
			});
			$('#hash').keyup(function(event) {
				$('#form').delay(200).submit()
			});



			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "BCCryptFunctionality", //this is my servlet

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

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">BCrypt Password hashing and Verification</h1>
<hr>



			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"
					   value="CALCULATE_BCCRYPT">


				<div class="form-group">
					<label for="password">Password</label>
					<input type="text" name="password" class="form-control" id="password" aria-describedby="emailHelp" placeholder="Enter password to generate bcrypt hash">
				</div>

				<hr>

				<div class="form-group">
					<label for="hash">Validate Hash</label>
					<input type="text" name="hash" class="form-control" id="hash" aria-describedby="emailHelp" placeholder="$2a$10$9WHIOHV8T1RNQQrx/omYz.yoCjpa5EL4D/hoy7acc9fFFF54v7hBC">
				</div>

				Workload (Cost Factor)
				<br/>


				<input checked="checked" id="workload1" type="radio"
					   name="workload" value="10">10<br>

				<input
						id="workload2" type="radio" name="workload"
						value="11">11<br>

				<input
						id="workload4" type="radio" name="workload"
						value="12">12<br>

				<input
						id="workload5" type="radio" name="workload"
						value="13">13<br>

				<input
						id="workload3" type="radio" name="workload"
						value="14">14<br>

				</form>
<hr>

<div id="output"></div>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="thersaalgorithm">Bcrypt</h2>
<p>Bcrypt is a password hashing function designed by Niels Provos and David Mazi&egrave;res, based on the Blowfish cipher. BCrypt was first published, in 1999, they listed their implementation's based default cost factor,This is the core password hashing mechanism in the OpenBSD operating system</p>
<p>The bcrypt workload is specified in the above static variable, a value from 10 to 31. A workload of 12 is a very reasonable safe default as of 2013.</p>
<p>A bcrypt cost of 6 means 64 rounds (2^6 = 64).</p>
<p>for example given bcrypt hash Value <pre>$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC</pre></p>
<p><pre>$06$</pre> specifies a <strong>cost parameter</strong> of 6, indicating 64 key expansion rounds</p>
<p><pre><code>.rCVZVOThsIa97pEDOxvGu</code></pre> 128 bit salt </p>
<p><pre><code>RRgzG64bvtJ0938xuqzv18d3ZpQhstC</code></pre> is the resultinh hash</p>
<p><strong>bcrypt Output size is fixed: 192 bits.</strong></p>
<p><strong>Good Password Hashing Functions<br /></strong>PBKDF2 <br />bcrypt (Digest Size 184 bit)<br />scrypt (Digest Size variable )<br />OpenPGP Iterated And Salted S2K<strong><br /></strong></p>

<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>