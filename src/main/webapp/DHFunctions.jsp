<!DOCTYPE html>
<html>
<head>

<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<title>Learn DH in Cryptography, Diffie-Hellman Key Exchange</title>
<meta name="description" content="Learn what is Diffie-Hellman Key Exchange In Cryptography." />
<meta name="keywords" content="DH Paramter example,Diffie-Hellman Key Exchange, dh online,diffie-hellman-merkle calculator,diffie hellman decryption,calculate shared key diffie hellman,diffie hellman decryption online,rsa public key calculator,diffie hellman decoder,diffie hellman example,explain diffie hellman algorithm with the help of an example " />

<meta name="robots" content="index,follow" />
<meta name="googlebot" content="index,follow" />
<meta name="resource-type" content="document" />
<meta name="classification" content="tools" />
<meta name="language" content="en" />

<%@ include file="include_css.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {


		$('#ctrTitles').change(function() {
			   pem = $(this).val();
			   $("#pem").val(pem);    
			});
		

		$('#submit').click(function(event) {
			$('#form').delay(200).submit()
		});

		$('#form').submit(function(event) {
			//	
			$('#output1').html('<img src="images/712.GIF"> loading...');
			event.preventDefault();
			$.ajax({
				type : "POST",
				url : "CipherFunctionality", //this is my servlet

				data : $("#form").serialize(),
				success : function(msg) {
					$('#output').empty();
					$('#output1').empty();
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
			value="METHOD_DH">
			<fieldset name="Group1">
                <legend>Diffie-Hellman Key Exchange</legend>
                
<table>
<tr>
<td colspan="5"> Diffie-Hellman Key Exchange, The protocol allows two users to exchange a 
secret key over an insecure medium without any prior secrets.
<ul>
<li> The Setup Suppose we have two people wishing to 
communicate: Alice and Bob
</li>
<li> They do not want Eve (eavesdropper) to know 
their message. 
</li>
<li>Alice and Bob agree upon and make public two numbers g and p, where p is a prime and g is a 
primitive root mod p</li>
</ul>
</td>
</tr>
<tr>

<th align="RIGHT" nowrap> &nbsp;DH Parameter G  : </th> 
<td><input type="text" name="dhparamp" placeholder="153d5d6172adb43045b68ae8e1de1070b6137005686d29d3d73a7"  size="70" maxlength="64" />any  BigInteger Value</td>
<tr>
<tr>
<th align="RIGHT" nowrap>&nbsp;DH Parameter P  : </th> 
<td><input type="text" name="dhparamq" placeholder="9494fec095f3b85ee286542b3836fc81a5dd0a0349b4c239dd387" size="70" maxlength="64" />any  BigInteger Value</td>

</tr>
<tr>
<td>
</td>
</tr>
<tr>


</tr>

<tr>
<td>
<input type="submit" id="submit" name="generate DH Paramter">
<div id="output1"></div>
</td>
</tr>
<tr>
<td>Output
			</td>
			<td>
			
			<textarea rows="20" cols="80" id="output"></textarea>
			</td>
			</tr>
			
</table>
            </fieldset>
	</form>

				<%@ include file="footer.jsp"%>
				<p>&nbsp;</p>
				<p>Source&nbsp;<a href="https://security.stackexchange.com/questions/45963/diffie-hellman-key-exchange-in-plain-english">https://security.stackexchange.com/questions/45963/diffie-hellman-key-exchange-in-plain-english</a></p>
				<p>Diffie-Hellman is an algorithm used to establish a shared secret between two parties. It is primarily used as a method of exchanging cryptography keys for use in symmetric encryption algorithms like AES.</p>
				<p>The algorithm in itself is very simple. Let's assume that Alice wants to establish a shared secret with Bob.</p>
				<ol>
					<li>Alice and Bob agree on a prime number,&nbsp;<code>p</code>, and a base,&nbsp;<code>g</code>, in advance. For our example, let's assume that&nbsp;<code>p=23</code>&nbsp;and&nbsp;<code>g=5</code>.</li>
					<li>Alice chooses a secret integer&nbsp;<code>a</code>&nbsp;whose value is 6 and computes&nbsp;<code>A = g^a mod p</code>. In this example, A has the value of 8.</li>
					<li>Bob chooses a secret integer b whose value is 15 and computes&nbsp;<code>B = g^b mod p</code>. In this example, B has the value of 19.</li>
					<li>Alice sends&nbsp;<code>A</code>&nbsp;to Bob and Bob sends&nbsp;<code>B</code>&nbsp;to Alice.</li>
					<li>To obtain the shared secret, Alice computes&nbsp;<code>s = B^a mod p</code>. In this example, Alice obtains the value of&nbsp;<code>s=2</code></li>
					<li>To obtain the shared secret, Bob computes&nbsp;<code>s = A^b mod p</code>. In this example, Bob obtains the value of&nbsp;<code>s=2</code>.</li>
				</ol>
				<p>The algorithm is secure because the values of&nbsp;<code>a</code>&nbsp;and&nbsp;<code>b</code>, which are required to derive&nbsp;<code>s</code>&nbsp;are not transmitted across the wire at all.</p>
				<p>&nbsp;</p>
				<p><img src="https://i.stack.imgur.com/n4jBE.png" alt="" width="427" height="641" /></p>
<%@ include file="include_security_links.jsp"%>

</section>
		</article>
		
	</div>
</body>
</html>