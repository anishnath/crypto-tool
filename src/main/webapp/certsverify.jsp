<%@ page import="z.y.x.Security.ecpojo" %>
<!DOCTYPE html>
<html>
<head>



	<title>Online check whether a private key matches a certificate or whether a certificate matches a certificate signing request (CSR), check csr matches private key</title>


	<%@ include file="include_css.jsp"%>


	<script type="text/javascript">
		$(document).ready(function() {




			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#message').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#encryptparameter').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#decryptparameter').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#validateCSR').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});


			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "CipherFunctionality", //this is my servlet

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
			<form id="form" action="CipherFunctionality" method="POST">
				<input type="hidden" name="methodName" id="methodName"   value="METHOD_VERIFY_CERTSCSR">
				<fieldset name="CERTS">
					<legend>
						<b> Certificate/CSR/Private Key Matcher</b>
					</legend>
				</fieldset>
				<fieldset name="CERT1">
					<table border="1" style="width:50pc">
						<tr>
							<th>Input x509 or CSR or PrivateKey </th>
							<th>validate against x509/CSR/PrivateKey </th>
						</tr>

						<tr>
							<td>
							<textarea rows="10" placeholder="-----BEGIN CERTIFICATE-----
MIIDBzCCAe+gAwIBAgIJAILTZkHwO2S3MA0GCSqGSIb3DQEBBQUAMBoxGDAWBgNV
BAMMD3d3dy5leGFtcGxlLmNvbTAeFw0xNzEyMjUwNjQ3MTFaFw0yNzEyMjMwNjQ3
MTFaMBoxGDAWBgNVBAMMD3d3dy5leGFtcGxlLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBALe7QyO8GrdSCUUyFyjjbsOwjachxP/8TXEFRQNf2fh9
AjtFfO78+vImDEMR8YsFbcxUl0SYU9NljjtxF6FwIiH8254pg4zJUr3mQRMBq7bb
SgQUHpwPEymlU46zk122QUPjdlK2Mf2JYt42qg7RD7UyoEMlGP99Tx5IAocBthzF
S5mpXK9/2FgPmfWcXhJz++2Dhr6noFeYpIuhBfUtR0JzfqYnw32KuMZ9vOCX5X6B
eeLuanEltJpqTdlQlRrTWYNhfkOAyIkD7O/9Kl0oigLZPUEoC0wUbbhfEnAbq9q7
1L/S5Tk8/30VNE6yAtoeCGP3i4UwxUUFjdkUulmOQesCAwEAAaNQME4wHQYDVR0O
BBYEFFuHlY+qBqre7BBnFbMQdMM3QKB3MB8GA1UdIwQYMBaAFFuHlY+qBqre7BBn
FbMQdMM3QKB3MAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAIt9n1Xa
GslLKkfXLdzACieqNMKNLNliOKVoilUH5SmlppOy9bf1GnxcYGehKTc6T1suyE6w
yrApVLMqTy9fZXBRsKzbmRftr23cA4GoZdduYqyaZFjzUIBWk4lcF7If0igg154h
za5OeIzJiA/qe5MoBRbRcS9jGZ6N6gxCl05W61N+8sckYgPaE3CQ4tbb7CIqFApX
KyPzz8x9saTpKOiWxfZT5hyai8bPnfil9mDhE2MEfiOX95Y9h1RjpK0J/K0hgqri
evOXHUpyeIyjj7JVdZIK/nMRk8dpWpIPcPAbiJgmglXNQBFDPsfEKEsfWC2Kh/zG
LFoUN8IPLXu1h7M=
-----END CERTIFICATE-----" cols="50"  name="publickeyparama" id="publickeyparama"></textarea>
							</td>
							<td>
							<textarea rows="10" cols="50" placeholder="-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA2jwacNcHGEtVc2JdO2kM/Re7ya/l1lYgF/9uP6OQz0EAuQ8K
BFMdvMScCUuXfTfgoz1UZmmUnjg1ReprvUa/ruutdXGLGgej4Btpk56Iv9TZHtwz
DRtGMseVQYpRKnEuis1i4I7aMA/J7tGH01EB840TPubSf6UaVnOyADbOsbpq+PVT
vwp/cgt//Ncvw7+zOObrVBdlaydNY5a9r3W1ldyFAx1M/vEYCDLP1Tmdlxl5djRU
/kVnkBkk7d3vlpu73WUo7Aa7y7uEP8Uxgi3MtvaxSyNXVGLrex366G3TgbW4L3qZ
kitWwOq5KlSJE4nFTOo1gAIpzl44xQxP6d/pGQIDAQABAoIBAAntM/KwBTWYr6FY
9w6tv5Z/jt4krxqpvjn5N2WTphGXTlYclgMOWMruUn6lvpVGhmRGdOFXqhfsTJgK
iq4IWs21EKXH7WDYuh6GgK3jRysanmml8HiHJhFHPMXHadu5XDmaEAZQ2SHYhgHj
6/6zr5gJcbepvidqNiF6j70swQgaciNKExOag6QvS1rif2CifKDQy/1Y9YDOgreo
AatzDHlf9TVKiC0VglAopQGV7+gJ+U5SjLF9yvaofaZTpk37kIgiUlBBZMgaBKAo
m51UBdiIefxhBFIDAZSJvtNeqQi1Ausr4eJ+abycj2MDGBVlXZyl7fB0fq+RFvKD
0SQ/khECgYEA8VzcdSOlnkVvrdtjL36cTHnnDMKR+n1XDOIMEjPZYviQ3EfF7rNq
ZMvypq311o+C2SRfkI05I8PnHzKTekS4IPoEsA7e88URplNbvIvFTGJlBkuInPR1
eiWJRzfDHtu/iVzf9AeO69KU7eDtXOukHswa1dYur0u5SJwLs1lLCZ0CgYEA53gu
pqSIPW6nXi5Y7V2f/JNsWVxIHTruF503xTT1NlMPfrdpyrR+w+yPaUitBUrtKS64
QTe53ph1Ut1xvF82Fr/AGdWJl6J2RzGb4uQPxnG9Vbway/oijMStkzf3s+4CPOQN
45kvP3maPQZgozm4kG54wk2kfdqwDtov9Z0k8q0CgYAunhLuhQ4N/bdOSxtjJv8l
Pj5EFqh/SwovMNHICj+of/3qreoq6nhYM5QQYXUkFd/d9MqIbt5kbAgN3ITjjrZJ
mECjiJvDVYLNLzh+uDhJQo/koV4ngofWKb3UBY8oPKVH8KpIxdTy819Ueqcd1V2D
nURpnM6ziNqmjY0s/MgjeQKBgQCK4m7DaHeivLFJ7m9HRWUIbQCXAar3dvODUb8z
4dm8Fcx3UN/2U6S4NEm8d3HxegqhKjo+T4yEBmBnLx3eVBalQbqnBZyAUme7wgVx
9zuL65UaSzqc52IxqpUnf25uFMJc/M1kofZalME6GoiDh8+5Qb/Nfj7TkRMQZlRe
gEK6JQKBgFLOf5cemrtT7DKzYhS2tKIXPVTUihJOM7IWWrFYU/TtBDwPf+Wf8GH2
9sBFaliDDzKLsVMJkI6j8eIHgMGurRWWaGdnMdSA5hA35BfRXpo/cpP7rNToDjjT
8S9OuuR1RVhNWfpnz2S/WIdpUXl/QL/PJx3B2B9wq7cEFQS12HpP
-----END RSA PRIVATE KEY-----" name="privatekeyparama" id="privatekeyparama"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2"><%@ include file="footer_adsense.jsp"%></td>
						</tr>

						<tr>
							<td colspan="2"><input type="button" value="validate keys" id="validateCSR" name="validateCSR"></td>
						</tr>
					</table>
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