<!DOCTYPE html>
<html>
<head>

<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<title>Learn DH in Cryptography, Diffie-Hellman Key Exchange</title>


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
<td><input type="text" name="dhparamp" value="153d5d6172adb43045b68ae8e1de1070b6137005686d29d3d73a7" placeholder="153d5d6172adb43045b68ae8e1de1070b6137005686d29d3d73a7"  size="70" maxlength="64" />any  BigInteger Value</td>
<tr>
<tr>
<th align="RIGHT" nowrap>&nbsp;DH Parameter P  : </th> 
<td><input type="text" name="dhparamq" value="9494fec095f3b85ee286542b3836fc81a5dd0a0349b4c239dd387" placeholder="9494fec095f3b85ee286542b3836fc81a5dd0a0349b4c239dd387" size="70" maxlength="64" />any  BigInteger Value</td>

</tr>
<tr>
<td>
</td>
</tr>
<tr>


</tr>

<tr>
<td>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" id="submit" name="generate DH Paramter">
<div id="output1"></div>
</td>
</tr>
<tr>
<td><b>Output</b>
			</td>
			<td>
			
			<div id="output"></div>
			</td>
			</tr>
			
</table>
            </fieldset>
	</form>
				<%@ include file="include_security_links.jsp"%>
				<%@ include file="footer.jsp"%>

</section>
		</article>
		
	</div>
</body>
</html>