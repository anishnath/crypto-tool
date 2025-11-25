<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true" %>
<%@page import="z.y.x.Security.fernetpojo"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="org.apache.http.impl.client.DefaultHttpClient" %>
<%@ page import="org.apache.http.client.methods.HttpGet" %>
<%@ page import="org.apache.http.HttpResponse" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="z.y.x.r.LoadPropertyFileFunctionality" %>
<!DOCTYPE html>
<div lang="en">
<head>


	<!-- Enhanced JSON-LD for rich results / high-intent queries -->
	<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "WebApplication",
  "name": "Fernet Encryption/Decryption Online",
  "description": "Generate Fernet keys, encrypt plaintext to Fernet tokens, and decrypt tokens back to text. AES-128-CBC with HMAC-SHA256.",
  "url": "https://8gwifi.org/fernet.jsp",
  "image": "https://8gwifi.org/images/site/fernet.png",
  "applicationCategory": "SecurityApplication",
  "operatingSystem": "All",
  "softwareVersion": "v1.0",
  "datePublished": "2020-12-11",
  "downloadUrl": "https://8gwifi.org/fernet.jsp",
  "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
  "featureList": [
    "Generate Fernet key (base64url)",
    "Encrypt plaintext to Fernet token (AES-128-CBC + HMAC-SHA256)",
    "Decrypt Fernet token to plaintext",
    "Browser-based tool; no server storage"
  ],
  "author": {"@type": "Person", "name": "Anish Nath"}
}
</script>

<!-- FAQ schema to target common Fernet queries -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is a Fernet key and how is it formatted?",
      "acceptedAnswer": {"@type": "Answer", "text": "A Fernet key is 32 bytes, base64url (URL-safe) encoded. It contains a 128-bit signing key and a 128-bit encryption key."}
    },
    {
      "@type": "Question",
      "name": "Does this tool store my messages or keys?",
      "acceptedAnswer": {"@type": "Answer", "text": "No. Encryption and decryption happen in your browser. The page does not store or upload your messages or keys."}
    },
    {
      "@type": "Question",
      "name": "Which algorithms does Fernet use?",
      "acceptedAnswer": {"@type": "Answer", "text": "Fernet uses AES-128 in CBC mode for encryption and HMAC-SHA256 for authentication."}
    },
    {
      "@type": "Question",
      "name": "How do I decrypt a Fernet token?",
      "acceptedAnswer": {"@type": "Answer", "text": "Select Decrypt, paste the Fernet token into the message field, and submit with the correct base64url-encoded key to recover the original plaintext."}
    }
  ]
}
</script>

	<title>Fernet Encryption/Decryption Online – Free | 8gwifi.org</title>
	<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>

	<meta name="keywords" content="fernet encryption online, generate fernet key, fernet decrypt online, base64url key, AES128 CBC HMAC, cryptography fernet token" />
	<meta name="description" content="Free Fernet encryption/decryption online. Generate Fernet keys, encrypt messages, and decrypt tokens. Uses AES‑128‑CBC with HMAC‑SHA256. No server storage." />

	<link rel="canonical" href="https://8gwifi.org/fernet.jsp"/>
	<meta name="robots" content="index,follow" />
	<meta name="googlebot" content="index,follow" />
	<meta name="resource-type" content="document" />
	<meta name="classification" content="tools" />
	<meta name="language" content="en" />
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

	<meta property="og:title" content="Fernet Encryption/Decryption Online – Generate Key, Encrypt & Decrypt" />
	<meta property="og:description" content="Generate Fernet keys and encrypt/decrypt messages in your browser. AES‑128‑CBC + HMAC‑SHA256. No server storage." />
	<meta property="og:type" content="website" />
	<meta property="og:url" content="https://8gwifi.org/fernet.jsp" />
	<meta property="og:image" content="https://8gwifi.org/images/site/fernet.png" />
	<meta name="twitter:card" content="summary_large_image" />
	<meta name="twitter:title" content="Fernet Encryption/Decryption Online – Generate Key, Encrypt & Decrypt" />
	<meta name="twitter:description" content="Encrypt/decrypt Fernet tokens and generate keys. AES‑128‑CBC + HMAC‑SHA256." />
	<meta name="twitter:image" content="https://8gwifi.org/images/site/fernet.png" />

	<%@ include file="header-script.jsp"%>

	<style>
	  /* Scoped layout and readability improvements */
	  .fer .card-header{padding:.6rem .9rem;font-weight:600}
	  .fer .card-body{padding:.9rem}
	  .fer .form-group{margin-bottom:.7rem}
	  .fer .help{color:#6c757d}
	</style>

	<%
		String key = "";
		

		if (request.getSession().getAttribute("key")==null) {
//			KeyPair kp = RSAUtil.generateKey(1024);
//			pubKey =RSAUtil.toPem(kp.getPublic());
//			privKey = RSAUtil.toPem(kp);

			Gson gson = new Gson();
			DefaultHttpClient httpClient = new DefaultHttpClient();
			String url1 = LoadPropertyFileFunctionality.getConfigProperty().get("ep") + "fernet/genkey";

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
			fernetpojo fernetpojo = (fernetpojo) gson.fromJson(content.toString(), fernetpojo.class);

			key = fernetpojo.getKey();
		}
		else {
			key = (String)request.getSession().getAttribute("key");
		}


	%>

	<script type="text/javascript">
		$(document).ready(function() {


			



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



			$('#genfkey').click(function(event) {
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
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			$('#decryptparameter').click(function(event) {

				var text = $('#output').find('textarea[name="encrypedmessagetextarea"]').val();
				if ( text != null ) {
					$("#message").val(text);
				}
				//
				// event.preventDefault();
				$('#form').delay(200).submit()
			});

			// Ensure toggle works when clicking on Bootstrap labels
			$('input[name="encryptdecryptparameter"]').on('change', function(){
				try{
					// Keep Bootstrap label state in sync when toggled via label
					$('input[name="encryptdecryptparameter"]').each(function(){
						var $lbl = $(this).closest('label');
						if(this.checked){ $lbl.addClass('active'); } else { $lbl.removeClass('active'); }
					});
					if(this.value === 'decrypt' || this.id === 'decryptparameter'){
						var text = $('#output').find('textarea[name="encrypedmessagetextarea"]').val();
						if ( text != null ) { $("#message").val(text); }
					}
					$('#form').delay(200).submit();
				}catch(e){}
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
						console.log(msg);
						$("#privatekeyparam").resizable();

					}
				});
			});

		});
	</script>

<!-- Small helpers for copy tooltip; does not affect existing logic -->
<script>
  function copyFernetField(id, btn){
    try{
      var el = document.getElementById(id);
      var val = (el && el.value) || '';
      if(navigator.clipboard && navigator.clipboard.writeText){
        navigator.clipboard.writeText(val).then(function(){ showFernetCopied(btn); });
      } else {
        var ta=document.createElement('textarea'); ta.value=val; document.body.appendChild(ta); ta.select();
        try{ document.execCommand('copy'); }catch(e){}
        document.body.removeChild(ta);
        showFernetCopied(btn);
      }
    }catch(e){}
  }
  function showFernetCopied(btn){
    try{
      if(window.jQuery && $(btn).tooltip){
        $(btn).tooltip({title:'Copied!', trigger:'manual', placement:'top'});
        $(btn).tooltip('show'); setTimeout(function(){ try{$(btn).tooltip('hide').tooltip('dispose');}catch(e){} },900);
      } else if(btn) {
        var orig=btn.getAttribute('data-orig-html')||btn.innerHTML; btn.setAttribute('data-orig-html',orig);
        btn.innerHTML='Copied!'; setTimeout(function(){ btn.innerHTML=btn.getAttribute('data-orig-html'); },900);
      }
    }catch(e){}
  }
</script>
</head>


<%@ include file="body-script.jsp"%>

<div class="container mt-4 fer">
  <h1 class="mb-2">Fernet Encryption/Decryption</h1>
  <p class="text-muted">Generate a Fernet key, encrypt text into a Fernet token, or decrypt a token back to plaintext.</p>

  <div class="card mb-3">
    <h5 class="card-header">Encrypt / Decrypt</h5>
    <div class="card-body">


<div id="loading" style="display: none;">
	<img src="images/712.GIF" alt="" />Loading!
</div>









<form id="form" class="form-horizontal" method="POST">
    <input type="hidden" name="methodName" id="FERNET_ENCRYPT_DECRYPT_MESSAGEE"
           value="FERNET_ENCRYPT_DECRYPT_MESSAGEE">

    <div class="btn-group btn-group-toggle mb-3" data-toggle="buttons">
      <label class="btn btn-outline-primary active">
        <input type="radio" id="encryptparameter" name="encryptdecryptparameter" value="encrypt" autocomplete="off" checked> Encrypt
      </label>
      <label class="btn btn-outline-primary">
        <input type="radio" id="decryptparameter" name="encryptdecryptparameter" value="decrypt" autocomplete="off"> Decrypt
      </label>
    </div>
	
	<div class="form-group">
    <label for="privatekeyparam">Fernet Key</label>
    <div class="input-group input-group-sm">
      <input type="text" class="form-control" id="privatekeyparam" name="privatekeyparam" value="<%= key %>"  placeholder="Base64‑URL (urlsafe) key">
      <div class="input-group-append">
        <button class="btn btn-outline-secondary" type="button" title="Generate new Fernet key" onclick="try{ document.getElementById('genfkey').click(); }catch(e){}">Generate</button>
        <button class="btn btn-outline-secondary" type="button" title="Copy" onclick="copyFernetField('privatekeyparam', this);">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg"><path d="M16 1H4C2.9 1 2 1.9 2 3V15H4V3H16V1ZM19 5H8C6.9 5 6 5.9 6 7V19C6 20.1 6.9 21 8 21H19C20.1 21 21 20.1 21 19V7C21 5.9 20.1 5 19 5ZM19 19H8V7H19V19Z"/></svg>
        </button>
      </div>
    </div>
    <small class="help">Key must be base64‑url encoded (urlsafe) as per Fernet spec.</small>
  </div>
  
  <div class="form-group">
    <label for="message">Input Message</label>
    <textarea class="form-control" id="message" name="message" rows="3" placeholder="Plaintext to encrypt OR Fernet token to decrypt"></textarea>
  </div>
  
  <div class="form-group">
    <label for="output">Output</label>
    <div id="output"></div>
  </div>
	<input type="submit" class="btn btn-primary" name="Generate EC" value="submit">
</form>

    </div>
  </div>

<br>


<div style="display:none" aria-hidden="true">
  <form id="form1" action="CipherFunctionality" method="POST">
    <input type="hidden" name="methodName" id="methodName" value="FERNET_GENERATE_KEYPAIR">
    <input type="button" id="genfkey" name="Generate Fernet Keys" value="Generate New Fernet Keys">
  </form>
</div>


<hr>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>

<hr>

<%@ include file="footer_adsense.jsp"%>

<h1 class="code-line" data-line-start=0 data-line-end=1><a id="Fernet_0"></a>Fernet</h1>
<p class="has-line-data" data-line-start="1" data-line-end="2">Fernet guarantees that a message encrypted using it cannot be manipulated or read without the key. All encryption in this version is done with <strong>AES 128</strong> in <strong>CBC</strong> mode.</p>
<h3 class="code-line" data-line-start=3 data-line-end=4><a id="Key_format_3"></a>Key format</h3>
<p class="has-line-data" data-line-start="4" data-line-end="5">A fernet <em>key</em> is the base64url encoding of the following fields:</p>
<pre><code class="has-line-data" data-line-start="7" data-line-end="9">Signing-key || Encryption-key
</code></pre>
<ul>
<li class="has-line-data" data-line-start="10" data-line-end="11"><em>Signing-key</em>, 128 bits</li>
<li class="has-line-data" data-line-start="11" data-line-end="13"><em>Encryption-key</em>, 128 bits</li>
</ul>
<h3 class="code-line" data-line-start=13 data-line-end=14><a id="Token_format_13"></a>Token format</h3>
<p class="has-line-data" data-line-start="15" data-line-end="16">A fernet <em>token</em> is the base64url encoding of the concatenation of the following fields:</p>
<pre><code class="has-line-data" data-line-start="18" data-line-end="20">Version || Timestamp || IV || Ciphertext || HMAC
</code></pre>
<ul>
<li class="has-line-data" data-line-start="21" data-line-end="22"><strong><em>Version</em></strong>, 8 bits : with the value 128 (0x80)</li>
<li class="has-line-data" data-line-start="22" data-line-end="23"><strong><em>Timestamp</em></strong>, 64 bits : It records the number of seconds elapsed between January 1, 1970 UTC and the time the token was created</li>
<li class="has-line-data" data-line-start="23" data-line-end="24"><strong><em>IV</em></strong>, 128 bits</li>
<li class="has-line-data" data-line-start="24" data-line-end="25"><strong><em>Ciphertext</em></strong>, variable length, multiple of 128 bits</li>
<li class="has-line-data" data-line-start="25" data-line-end="27"><strong><em>HMAC</em></strong>, 256 bits : This field is the 256-bit SHA256 HMAC <code>Version || Timestamp || IV || Ciphertext</code></li>
</ul>
<h3 class="code-line" data-line-start=27 data-line-end=28><a id="Examples_27"></a>Examples</h3>
<p class="has-line-data" data-line-start="29" data-line-end="30"><strong>fernet python example</strong></p>
<pre><code class="has-line-data" data-line-start="31" data-line-end="43">&gt;&gt;&gt; from cryptography.fernet import Fernet
&gt;&gt;&gt; key = Fernet.generate_key()
&gt;&gt;&gt; key
'Qk_GF82vx2qPBiF91n238Mp5HeAlgYpC90NB9PGEB_0='
&gt;&gt;&gt; f = Fernet(key)
&gt;&gt;&gt; token = f.encrypt(b&quot;Hello 8gwifi.org&quot;)
&gt;&gt;&gt; token
'gAAAAABf1ecawfmsxp0S80m5LxV4md9Vf4lO7N-P9jQ08de_oLb5382Aqf7aGEof23E6N0WYPyhJkvhT1dDJJU4tdAFAhqnK-uiOoSu1T5P6XZLPcU90Rn0='
&gt;&gt;&gt; f.decrypt(token)
'Hello 8gwifi.org'
&gt;&gt;&gt;
</code></pre>
<p class="has-line-data" data-line-start="44" data-line-end="45"><strong>Using password with Fernet</strong></p>
<pre><code class="has-line-data" data-line-start="47" data-line-end="72">&gt;&gt;&gt; import base64
&gt;&gt;&gt; import os
&gt;&gt;&gt; from cryptography.fernet import Fernet
&gt;&gt;&gt; from cryptography.hazmat.primitives import hashes
&gt;&gt;&gt; from cryptography.hazmat.backends import default_backend
&gt;&gt;&gt; from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
&gt;&gt;&gt; password = b&quot;password&quot;
&gt;&gt;&gt; salt = os.urandom(16)
&gt;&gt;&gt; kdf = PBKDF2HMAC(
... algorithm=hashes.SHA256(),
... length=32,
... salt=salt,
... iterations=100000,
... backend=default_backend()
... )
&gt;&gt;&gt; key = base64.urlsafe_b64encode(kdf.derive(password))
&gt;&gt;&gt; key
'XuRrdEYerPl07JKzRuVhkcx7zuUTtaS0L12-Bs89gbY='
&gt;&gt;&gt; f = Fernet(key)
&gt;&gt;&gt; token = f.encrypt(b&quot;Hello 8gwifi.org&quot;)
&gt;&gt;&gt; token
'gAAAAABf1ekGtfc1S8_LgphBOmTs5YHt14vCEv2Q7XUoRHxHmsQeCSDE6bfQgyv7dk4YZQGvB5VRwCAO5CT6gm_r8PtYFdIaEjsBNAFovx7L_W2SrguCYdY='
&gt;&gt;&gt; f.decrypt(token)
'Hello 8gwifi.org'
</code></pre>
<h3 class="code-line" data-line-start=74 data-line-end=75><a id="Limitation_74"></a>Limitation</h3>
<p class="has-line-data" data-line-start="75" data-line-end="76">Fernet is ideal for encrypting data that easily fits in memory. As a design feature it does not expose unauthenticated bytes. This means that the complete message contents must be available in memory, making Fernet generally unsuitable for very large files at this time</p>

<%@ include file="addcomments.jsp"%>

</div>
</div>
<%@ include file="body-close.jsp"%>
