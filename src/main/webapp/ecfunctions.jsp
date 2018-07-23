<%@ page import="z.y.x.Security.ecpojo" %>
<!DOCTYPE html>
<html>
<head>



	<title>Elliptic Curve Encryption Decryption tool Online ecparam key generator </title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>


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


			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "ECFunctionality", //this is my servlet

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

<%

	String ecPrivateKeyA="";
	String ecPrivateKeyB= "";
	String ecPublicKeyB= "";
	String ecPublicKeyA= "";
	String sharedSecret= "";
	ecpojo ecpo = (ecpojo) request.getSession().getAttribute("ecpojo");
	if(ecpo!=null)
	{
		ecPrivateKeyA= ecpo.getEcprivateKeyA();
		ecPrivateKeyB= ecpo.getEcprivateKeyB();
		ecPublicKeyB= ecpo.getEcpubliceKeyB();
		ecPublicKeyA= ecpo.getEcpubliceKeyA();
		sharedSecret= ecpo.getShareSecretA();
	}
%>

<div id="page">
	<%@ include file="include.jsp"%>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>

	<article id="contentWrapper" role="main">
		<section id="content">
			<form id="form1" action="ECFunctionality" method="POST">
				<input type="hidden" name="methodName" id="methodName"  value="EC_GENERATE_KEYPAIR">
				<fieldset name="Generate Key Pair">
					<legend>
						<b> Elliptic Curve Encryption/Decryption</b>
					</legend>

					Choose ECParam<select name="ecparam" id="ecparam">
					<%
						String[] validList = { "c2pnb272w1", "c2tnb359v1", "prime256v1", "c2pnb304w1", "c2pnb368w1", "c2tnb431r1",
								"sect283r1", "sect283k1", "secp256k1", "secp256r1", "sect571r1", "sect571k1", "sect409r1", "sect409k1",
								"secp521r1", "secp384r1", "P-521", "P-256", "P-384", "B-409", "B-283", "B-571", "K-409", "K-283",
								"K-571", "brainpoolp512r1", "brainpoolp384t1", "brainpoolp256r1", "brainpoolp512t1", "brainpoolp256t1",
								"brainpoolp320r1", "brainpoolp384r1", "brainpoolp320t1", "FRP256v1", "sm2p256v1" };
						for (int i = 0; i < validList.length; i++) {
							String param = validList[i];
					%>
					<option value="<%=param%>"> <%=param%></option>
					<%	} %>
				</select> <input type="submit" name="Generate EC" value="submit"> Generate EC
					<br>
			</form>
			<form id="form" method="POST">
				<input type="hidden" name="methodName" id="methodName"  value="EC_FUNCTION">
				<fieldset name="EC">
					<legend>
						<b> Encrypt/Decrypt</b>
					</legend>
					<input checked id="encryptparameter" type="radio" name="encryptdecryptparameter"
						   value="encrypt">Encrypt Message

					<input id="decryptparameter" type="radio" name="encryptdecryptparameter"
						   value="decrypt"> Decrypt Message
					<br/>
					<%
						if(sharedSecret!=null && sharedSecret.length()>1)
						{
					%>
					Alice & Bob Shared Secret Formed &nbsp;&nbsp;<b><font color="#b22222"><%=sharedSecret%></font></b>
					<%}%>
				</fieldset>
				<table border="1" style="width:80pc">
					<tr>
						<th>Public Key Alice </th>
						<th>EC-Private Key Alice </th>
						<th>Public Key Bob</th>
						<th>EC-Private Key Bob </th>
						<th></th>
					</tr>




					<tr>
						<td>
							<textarea rows="10" cols="40"  name="publickeyparama" id="publickeyparama"><%=ecPublicKeyA%></textarea>
						</td>
						<td>
							<textarea rows="10" cols="40"  name="privatekeyparama" id="privatekeyparama"><%=ecPrivateKeyA%></textarea>
						</td>

						<td>
							<textarea rows="10" cols="40"  name="publickeyparamb" id="publickeyparamb"><%=ecPublicKeyB%></textarea>
						</td>
						<td>
							<textarea rows="10" cols="40"  name="privatekeyparamb" id="privatekeyparamb"><%=ecPrivateKeyB%></textarea>
						</td>
						<td>
							<%@ include file="footer_adsense.jsp"%>
						</td>

					</tr>
				</table>
				<table>
					<tr>
						<th>Input Message</th>
						<th></th>
					</tr>
					<tr>
						<td>
							<textarea rows="10" cols="20" placeholder="Type Something Here..."  name="message" id="message"></textarea>
						</td>
						<td><div id="output"></div>
						</td>
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