<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.Security.pgppojo" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<!DOCTYPE html>
<html>
<head>


	<!-- JSON-LD markup generated by Google Structured Data Markup Helper. -->
	<script type="application/ld+json">
{
  "@context" : "http://schema.org",
  "@type" : "SoftwareApplication",
  "name" : "Online DSA Kegenerator, Generate Signature file , DSA Signature Verifier",
  "image" : "https://8gwifi.org/images/site/dsa.png",
  "url" : "https://8gwifi.org/dsafunctions.jsp",
  "author" : {
    "@type" : "Person",
    "name" : "Anish Nath"
  },
  "datePublished" : "2018-03-04",
  "applicationCategory" : [ "dsa key generation", "dsa file verification", "openssl dsa keygen", "openssl sign file verification", "online dsa", "dsa create signature file", "dsa verify signature file", "SHA256withDSA", "NONEwithDSA", "SHA224withDSA", "SHA1withDSA"],
  "downloadUrl" : "https://8gwifi.org/dsafunctions.jsp",
  "operatingSystem" : "Linux,Unix,Windows,Redhat,RHEL,Fedora,Ubuntu,Android,iPhone",
  "requirements" : "dsa private key public key, dsa keygen, dsa generate signature file, dsa verify signature file",
  "softwareVersion" : "v1.0"
}
</script>

	<title>DSA Generate Keys, Generate Signature and Verify Signature file</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="online dsa key generation,dsa file verification,openssl dsa keygen,openssl sign file verification,online dsa,dsa create signature file,dsa verify signature file,SHA256withDSA,NONEwithDSA,SHA224withDSA,SHA1withDSA"/>
	<meta name="description" content="Online DSA Algorithm, generate dsa private keys and public keys,dsa file verification,openssl dsa keygen,openssl sign file verification,online dsa,dsa create signature file,dsa verify signature file,SHA256withDSA,NONEwithDSA,SHA224withDSA,SHA1withDSA, dsa tutorial, openssl dsa parama and key" />

	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />

	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<%@ include file="header-script.jsp"%>

	<%
		String pubKey = "";
		String privKey = "";
		String checkedKey="512";
		boolean k1=false;
		boolean k2=false;
		boolean k3=false;
		boolean k4=false;


		if (request.getSession().getAttribute("pubkey")==null) {

			Gson gson = new Gson();
			DefaultHttpClient httpClient = new DefaultHttpClient();
			String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "dsa/" + 1024;

			//System.out.println(url1);

			HttpGet getRequest = new HttpGet(url1);
			getRequest.addHeader("accept", "application/json");

			HttpResponse response1 = httpClient.execute(getRequest);


			BufferedReader br = new BufferedReader(
					new InputStreamReader(
							(response1.getEntity().getContent())
					)
			);

			StringBuilder content = new StringBuilder();
			String line;
			while (null != (line = br.readLine())) {
				content.append(line);
			}
			pgppojo pgppojo = (pgppojo) gson.fromJson(content.toString(), pgppojo.class);


			pubKey =pgppojo.getPubliceKey();
			privKey = pgppojo.getPrivateKey();
			k2=true;
		}
		else {
			pubKey = (String)request.getSession().getAttribute("pubkey");
			privKey = (String)request.getSession().getAttribute("privKey");
			checkedKey = (String)request.getSession().getAttribute("keysize");
		}

		if("512".equals(checkedKey))
		{
			k1=true;
		}
		if("1024".equals(checkedKey))
		{
			k2=true;

		}
		if("2048".equals(checkedKey))
		{
			k3=true;
		}
		if("4096".equals(checkedKey))
		{
			k4=true;
		}

		//System.out.println(k1);
		//System.out.println(k2);
		//System.out.println(k3);
		//System.out.println(k4);

	%>

	<script type="text/javascript">
		$(document).ready(function() {



			$('#descryptmsg').hide();

			$('#submit').click(function(event) {
				$('#form').delay(200).submit()
			});

			$('#publickeyparam').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#privatekeyparam').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});


			$('#message').keyup(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#keysize1').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#keysize2').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#keysize3').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#keysize4').click(function(event) {
				//
				// event.preventDefault();
				$('#form1').delay(200).submit()
			});

			$('#cipherparameter1').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#cipherparameter2').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#cipherparameter3').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#cipherparameter4').click(function(event) {
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#encryptparameter').click(function(event) {
				//
				$('#descryptmsg').hide();
			});

			$('#decryptparameter').click(function(event) {

				$('#descryptmsg').show();
			});


			$('#form').submit(function(event) {
				//
				$('#output').html('<img src="images/712.GIF"> loading...');
				event.preventDefault();
				$.ajax({
					type : "POST",
					url : "DSAFunctionality", //this is my servlet

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

<h1 class="mt-4">DSA Key generation, Sign file, Verify Signature</h1>

<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>

<hr>






					<form id="form1" method="GET" name="form1"  action="DSAFunctionality?q=setNeKey">
						Generate DSA Keys <input <% if(k1) {  %> checked <% } %>

																		id="keysize1"  type="radio" name="keysize"
																		value="512">512 bit
						<input <% if(k2) {  %> checked <% } %> id="keysize2" type="radio" name="keysize"
											   value="1024">1024 bit
						<input <% if(k3) {  %> checked <% } %> id="keysize3" type="radio" name="keysize"
											   value="2048">2048 bit
					</form>



				<form id="form2" name="form2" method="POST" action="DSAFunctionality" enctype="multipart/form-data">
					<input type="hidden" name="methodName" id="methodName"
						   value="CALCULATE_DSA">


					<hr>

					<div id="output">

					<%

						String value =(String)session.getAttribute("msg");
						if(null==value)
						{
							value="";
						}

					%>

					<%=value%>
					<hr>

				</div>


						<input  checked id="encryptparameter" type="radio" name="encryptdecryptparameter"
							   value="encrypt">Sign File

						<input  id="decryptparameter" type="radio" name="encryptdecryptparameter"
							   value="decryprt">Verify Signature Message


					<div class="form-group row">
						<label for="publickeyparam"  class="font-weight-bold col-sm-2 col-form-label">Public Key</label>
						<div class="col-sm-10">
							<textarea rows="5" class="form-control" cols="10"  name="publickeyparam" id="publickeyparam"><%= pubKey %></textarea>
						</div>
					</div>

					<div class="form-group row">
						<label for="publickeyparam"  class="font-weight-bold col-sm-2 col-form-label">Private Key</label>
						<div class="col-sm-10">
							<textarea rows="5" cols="10" class="form-control"  name="privatekeyparam" id="privatekeyparam"><%= privKey %></textarea>
						</div>
					</div>

					<div class="form-group row">
						<label for="upfile"  class="font-weight-bold col-sm-2 col-form-label">file to be Signed </label>
						<div class="col-sm-10">
							<input type="file" id="upfile" name="upfile">
						</div>
					</div>
					<p><small> <font color="green">Signature genetaion required private key and file to be signed. Signature file will get downloaded Automatically</font></small></p>

					<div class="form-group row">
						<label for="sigfile"  class="font-weight-bold col-sm-2 col-form-label">Signature Verification</label>
						<div class="col-sm-10">
							<input type="file" id="sigfile" name="sigfile">
						</div>
					</div>
					<p><small> <font color="green">Signature Verification requires original file,signature file and public key </font></small></p>

					<div id="descryptmsg">


					</div>



					<div class="form-check">
						<input class="form-check-input" type="radio" name="cipherparameter" id="cipherparameter3" value="SHA256withDSA" checked>
						<label class="form-check-label" for="cipherparameter3">
							SHA256withDSA
						</label>
					</div>


					<div class="form-check">
						<input class="form-check-input" type="radio" name="cipherparameter" id="cipherparameter2" value="SHA224withDSA">
						<label class="form-check-label" for="cipherparameter2">
							SHA224withDSA
						</label>
					</div>

					<div class="form-check">
						<input class="form-check-input" type="radio" name="cipherparameter" id="cipherparameter4" value="SHA1withDSA">
						<label class="form-check-label" for="cipherparameter4">
							SHA1withDSA
						</label>
					</div>

					<div class="form-check">
						<input class="form-check-input" type="radio" name="cipherparameter" id="cipherparameter1" value="NONEwithDSA">
						<label class="form-check-label" for="cipherparameter1">
							NONEwithDSA
						</label>
					</div>



					<input class="btn btn-primary" type="submit" value="Submit">

				</form>

<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h2 class="mt-4" id="dsa">DSA</h2>
<p><strong>DSA</strong> stands for “Digital Signature Algorithm” - and is specifically designed to produce digital signatures, not perform encryption.</p>
<p><strong>DSA</strong> stands for “Digital Signature Algorithm” - and is specifically designed to produce digital signatures, not perform encryption.</p>
<ul>
	<li>The requirement for public/private keys in this system is for a slightly different purpose - whereas in RSA, a key is needed so anyone can encrypt, in DSA a key is needed so anyone can verify. In RSA, the private key allows decryption; in DSA, the private key allows signature creation.</li>
	<li>DSA <strong>Private</strong> Key is used for generating <strong>Signature</strong> file</li>
	<li>DSA <strong>public</strong> Key is used for <strong>Verifying</strong> the Signature.</li>
	<li>DSA is a variant on the ElGamal and Schnorr algorithms creates a 320 bit signature, but with 512-1024 bit security security again rests on difficulty of computing discrete logarithms has been quite widely accepted</li>
</ul>
<p><strong>OpenSSL Commands for generating DSA Param, Singing File &amp; verify File</strong></p>
<pre><code> openssl dsaparam 2048 &lt; /dev/random &gt; dsa_param.pem
 openssl gendsa dsa_param.pem -out dsa_priv.pem
 openssl dsa -in dsa_priv.pem -pubout -out dsa_pub.pem

 # DSA system now made up of: dsa_param.pem, dsa_pub.pem, dsa_priv.pem

 echo &quot;foobar&quot; &gt; foo.txt
 openssl sha1 &lt; foo.txt &gt; foo.txt.sha1
 openssl dgst -dss1 -sign dsa_priv.pem foo.txt.sha1 &gt; foo.txt.sig
 openssl dgst -dss1 -verify dsa_pub.pem -signature foo.txt.sig foo.txt.sha1
</code></pre>
<h2><a id="DSA_Key_Generation_22"></a>DSA Key Generation</h2>
<ol>
	<li>firstly shared global public key values <strong>(p,q,g)</strong> are chosen:</li>
	<li>choose a large prime p = 2 power L  where L= 512 to 1024 bits and is a multiple of 64</li>
	<li>choose q, a 160 bit prime factor of p-1</li>
	<li>choose g = h power (p-1)/q  for any h1  then each user chooses a private key and computes their public key:</li>
	<li>choose x compute y = g power x(mod p)</li>
</ol>
<p>DSA key generation is related to, but somewhat more complex than El Gamal. Mostly because of the use of the secondary 160-bit modulus q used to help speed up calculations and reduce the size of the resulting signature.</p>
<h2><a id="DSA_Signature_Creation_and_Verification_32"></a>DSA Signature Creation and Verification</h2>
<p><strong>To sign a message M</strong></p>
<ol>
	<li>generate random signature key k, k compute</li>
</ol>
<pre><code>    r = (g power k(mod p))(mod q)
    s = k-1.SHA(M)+ x.r (mod q)
</code></pre>
<ol start="2">
	<li>send signature (r,s) with message</li>
</ol>
<p><strong>to verify a signature, compute:</strong></p>
<ol>
	<li>w = s-1(mod q)</li>
	<li>u1= (SHA(M).w)(mod q)</li>
	<li>u2= r.w(mod q)</li>
	<li>v = (g power u1.y power u2(mod p))(mod q)<br>
		if v=r then the signature is verified</li>
</ol>
<%@ include file="addcomments.jsp"%>

</div>

<%@ include file="body-close.jsp"%>