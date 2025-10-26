<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <!-- Primary SEO -->
    <title>NTRU Encryption/Decryption – Online NTRU Key Generator (Lattice‑based Cryptography)</title>
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <meta name="description" content="Generate NTRU key pairs and encrypt/decrypt messages online. Lattice‑based, post‑quantum cryptography with APR2011/EES parameter sets and optional password+salt key derivation." />
    <link rel="canonical" href="https://8gwifi.org/ntrufunctions.jsp" />

    <!-- Legacy keywords (optional) -->
    <meta name="keywords" content="NTRU encryption,decrypt,lattice-based cryptography,post-quantum,online NTRU key generator,APR2011_743_FAST,APR2011_439,EES1087EP2,public key crypto" />

    <!-- Open Graph -->
    <meta property="og:type" content="website">
    <meta property="og:title" content="NTRU Encryption/Decryption – Online NTRU Key Generator">
    <meta property="og:description" content="Generate NTRU key pairs and encrypt/decrypt messages online. Lattice‑based, post‑quantum cryptography with APR2011/EES parameter sets.">
    <meta property="og:url" content="https://8gwifi.org/ntrufunctions.jsp">
    <meta property="og:image" content="https://github.com/anishnath/crypto-tool/raw/master/ntru.png">

    <!-- Twitter -->
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="NTRU Encryption/Decryption – Online NTRU Key Generator">
    <meta name="twitter:description" content="Generate NTRU key pairs and encrypt/decrypt messages online. Lattice‑based, post‑quantum cryptography with APR2011/EES parameter sets.">
    <meta name="twitter:image" content="https://github.com/anishnath/crypto-tool/raw/master/ntru.png">

    <!-- JSON‑LD: WebApplication -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "WebApplication",
      "name": "NTRU Encryption/Decryption",
      "url": "https://8gwifi.org/ntrufunctions.jsp",
      "description": "Generate NTRU key pairs and encrypt/decrypt messages online. Lattice‑based, post‑quantum cryptography with APR2011/EES parameter sets and optional password+salt key derivation.",
      "applicationCategory": "SecurityApplication",
      "operatingSystem": "Any",
      "browserRequirements": "Requires a modern browser with JavaScript enabled.",
      "image": "https://github.com/anishnath/crypto-tool/raw/master/ntru.png",
      "featureList": [
        "Online NTRU key generation",
        "Encrypt/Decrypt messages",
        "APR2011 and EES parameter sets",
        "Password + Salt deterministic key derivation"
      ],
      "offers": {"@type": "Offer", "price": "0", "priceCurrency": "USD"},
      "creator": {"@type": "Organization", "name": "8gwifi.org", "url": "https://8gwifi.org"},
      "keywords": "NTRU, lattice-based cryptography, post-quantum, online key generator, APR2011, EES"
    }
    </script>

    <!-- JSON‑LD: FAQ -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "FAQPage",
      "mainEntity": [
        {
          "@type": "Question",
          "name": "Is NTRU considered post‑quantum secure?",
          "acceptedAnswer": {"@type": "Answer", "text": "NTRU is a lattice‑based cryptosystem and is believed to be resistant to known quantum attacks such as Shor’s algorithm."}
        },
        {
          "@type": "Question",
          "name": "Which NTRU parameter sets are supported?",
          "acceptedAnswer": {"@type": "Answer", "text": "This tool supports APR2011 (e.g., 439, 743, FAST variants) and EES families (e.g., EES1087, EES1171, EES1499)."}
        },
        {
          "@type": "Question",
          "name": "Are generated keys deterministic?",
          "acceptedAnswer": {"@type": "Answer", "text": "If you use the same Password + Salt combination, the tool derives the same key pair deterministically."}
        }
      ]
    }
    </script>
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
        String errorMsg = "";
        String ntru = "APR2011_743_FAST";
        if (request.getSession().getAttribute("pubkey") != null) {
            pubKey = (String) request.getSession().getAttribute("pubkey");
            privKey = (String) request.getSession().getAttribute("privKey");
            ntru = (String) request.getSession().getAttribute("ntru");
            errorMsg = (String) request.getSession().getAttribute("errorMsg");
        }
    %>

    <script type="text/javascript">
      $(document).ready(function() {
        $('#submit').click(function(event) { $('#form').delay(200).submit() });
        $('#publickeyparam').keyup(function() { $('#form').delay(200).submit() });
        $('#privatekeyparam').keyup(function() { $('#form').delay(200).submit() });
        $('#message').keyup(function() { $('#form').delay(200).submit() });
        $('#keysize1, #keysize2, #keysize3, #keysize4').click(function(){ $('#form1').delay(200).submit() });
        $('#cipherparameter1, #cipherparameter2, #cipherparameter3, #cipherparameter4').click(function(){ $('#form').delay(200).submit() });
        $('#encryptparameter').click(function(){ $('#form').delay(200).submit() });
        $('#decryptparameter').click(function(){
          var text = $('#output').find('textarea[name="encrypedmessagetextarea"]').val();
          if (text != null) { $("#message").val(text); }
          $('#form').delay(200).submit();
        });

        $('#form').submit(function(event) {
          $('#output').html('<img src="images/712.GIF"> loading...');
          event.preventDefault();
          $.ajax({
            type: 'POST',
            url: 'NTRUFunctionality',
            data: $("#form").serialize(),
            success: function(msg) {
              $('#output').empty();
              $('#output').append(msg);
            }
          });
        });
      });
    </script>
</head>

<%@ include file="body-script.jsp"%>

<h1 class="mt-4">NTRU Encryption/Decryption</h1>
<hr>

<div id="loading" style="display:none;">
  <img src="images/712.GIF" alt="" />Loading!
</div>

<% if (errorMsg != null && !"".equals(errorMsg)) { %>
  <div class="alert alert-danger"><%=errorMsg%></div>
<% } %>

<div class="card mb-4">
  <h5 class="card-header">Generate NTRU Keys</h5>
  <div class="card-body">
    <form id="form1" method="POST" name="form1" action="NTRUFunctionality">
      <input type="hidden" name="methodName" id="methodName" value="GENERATE_KEYS">
      <div class="form-row align-items-end">
        <div class="form-group col-md-4">
          <label for="ntruparam">Parameter Set</label>
          <select class="form-control" name="ntruparam" id="ntruparam">
            <option selected value="APR2011_743_FAST">APR2011_743_FAST</option>
            <%
              String[] validList = { "EES1087EP2", "EES1087EP2_FAST", "EES1171EP1", "EES1171EP1_FAST", "EES1499EP1",
                  "EES1499EP1_FAST", "APR2011_439", "APR2011_439_FAST", "APR2011_743" };
              for (int i = 0; i < validList.length; i++) { String param = validList[i];
            %>
            <option value="<%=param%>"><%=param%></option>
            <% } %>
          </select>
        </div>
        <div class="form-group col-md-4">
          <label for="password">Password</label>
          <input type="text" class="form-control" id="password" name="password" placeholder="For encrypted keys">
        </div>
        <div class="form-group col-md-3">
          <label for="salt">Salt</label>
          <input type="text" class="form-control" id="salt" name="salt" placeholder="For encrypted keys">
        </div>
        <div class="form-group col-md-1">
          <button type="submit" class="btn btn-primary btn-block">Generate</button>
        </div>
      </div>
    </form>
  </div>
  <div class="card-footer text-muted small">Password + Salt combination deterministically derives the same key pair.</div>
</div>

<div class="card mb-4">
  <h5 class="card-header">Encrypt / Decrypt</h5>
  <div class="card-body">
    <form id="form" method="POST">
      <input type="hidden" name="methodName" id="methodName" value="CALCULATE_NTRU">
      <input type="hidden" name="p_ntru" id="p_ntru" value="<%=ntru%>">

      <div class="form-group">
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="encryptdecryptparameter" id="encryptparameter" value="encrypt" checked>
          <label class="form-check-label" for="encryptparameter">Encrypt</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="encryptdecryptparameter" id="decryptparameter" value="decryprt">
          <label class="form-check-label" for="decryptparameter">Decrypt</label>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label for="publickeyparam">NTRU Public Key</label>
          <textarea rows="12" class="form-control" name="publickeyparam" id="publickeyparam"><%= pubKey %></textarea>
        </div>
        <div class="col-md-6 mb-3">
          <label for="privatekeyparam">NTRU Private Key</label>
          <textarea rows="12" class="form-control" name="privatekeyparam" id="privatekeyparam"><%= privKey %></textarea>
        </div>
      </div>

      <div class="row">
        <div class="col-md-6 mb-3">
          <label for="message">Cleartext Message</label>
          <textarea rows="8" class="form-control" name="message" id="message" placeholder="Type something here..."></textarea>
        </div>
        <div class="col-md-6 mb-3">
          <label>Output</label>
          <div id="output" class="border rounded p-2" style="min-height: 180px;"></div>
        </div>
      </div>

      <button type="submit" id="submit" class="btn btn-primary">Run</button>
    </form>
  </div>
</div>

<div class="card mb-4">
  <div class="card-body">
    <p><strong>NTRU</strong> is a lattice-based public-key cryptosystem. NTRUEncrypt is used for encryption and is believed to be resistant to quantum attacks such as Shor’s algorithm. NTRUSign has known weaknesses and is of historical interest.</p>
    <p class="mb-0">Reference: <a href="https://github.com/tbuktu/ntru" target="_blank" rel="noopener">https://github.com/tbuktu/ntru</a></p>
  </div>
</div>

<div class="sharethis-inline-share-buttons"></div>
<%@ include file="thanks.jsp"%>
<%@ include file="footer_adsense.jsp"%>
</div>
<%@ include file="body-close.jsp"%>
