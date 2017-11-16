<!DOCTYPE html>
<html>
<head>
	<title>BCCrypt Hash Generator, Hash Checker </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="description"
		  content="Bccrypt password hash generation online and hash checker  "/>
	<meta name="keywords"
		  content="bccrypt online, bcrypt hash calculator,bccrypt hash checker,bccrypt tutorial,scrypt,OpenPGP,Good Password Hashing Functions,PBKDF2,pbkdf2,scrypt,OpenPGP"/>

	<meta name="author" content="CRYPO" />
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<%@ include file="include_css.jsp"%>


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
					   value="CALCULATE_BCCRYPT">

				<fieldset name="BCCrypt"   >

					<legend>
						<b> BCrypt Calculation</b>
					</legend>

					<table border="1" style="width:100pc">
						<tr>
							<th>Input </th>
							<th>Output </th>
							<th>BCcrypt Password Hashing </th>
						</tr>

						<tr>
							<td>
								<br/>
								Password <input id="password" type="text" name="password"
												size="30" placeholder="Type the password">
								<br/>

								Validate Hash <input id="hash" type="text" name="hash"
													 size="50"  placeholder=" BCrypt hash to check against the password.">

							</td>
							<td>
								<div id="output"> </div>

							</td>

							<td width="80%">
								<p>Bcrypt is a password hashing function designed by Niels Provos and David Mazi&egrave;res, based on the Blowfish cipher. BCrypt was first published, in 1999, they listed their implementation's based default cost factor,This is the core password hashing mechanism in the OpenBSD operating system</p>
							</td>

						</tr>

						<tr>

							<td width="25%">

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

							</td>
							<td width="40%">
								The bcrypt workload is specified in the above static variable, a value from 10 to 31. A workload of 12 is a very reasonable safe default as of 2013.
								<p>A bcrypt cost of 6 means 64 rounds (2^6 = 64).</p>
								<p>for example given bcrypt hash Value <br /><strong>$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC</strong> <br /><strong>$06$</strong> specifies a <strong>cost parameter</strong> of 6, indicating 64 key expansion rounds<br /><span style="text-decoration: underline;">.rCVZVOThsIa97pEDOxvGu</span> a 1<strong>28-bit salt</strong><br /><span style="text-decoration: underline;">RRgzG64bvtJ0938xuqzv18d3ZpQhstC</span> is the resultinh hash</p>
								<p><strong>bcrypt Output size is fixed: 192 bits.</strong></p>



							</td>
							<td>
								<p><strong>Good Password Hashing Functions<br /></strong>PBKDF2 <br />bcrypt (Digest Size 184 bit)<br />scrypt (Digest Size variable )<br />OpenPGP Iterated And Salted S2K<strong><br /></strong></p>
							</td>

						</tr>


						<tr>

						</tr>

					</table>


				</fieldset>

			</form>

			<table border="0" style="width:500px">
				<tr>
					<td><%@ include file="footer.jsp"%></td>
				</tr>
			</table>
			<%@ include file="include_security_links.jsp"%>
		</section>
	</article>

</div>
</body>
</html>