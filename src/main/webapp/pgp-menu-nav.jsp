<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- PGP & Cryptography Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light mb-3 border-bottom">
  <div class="container-fluid px-0">
    <span class="navbar-brand text-dark">
      <i class="fas fa-lock text-primary"></i> <span class="text-muted">Cryptography Tools</span>
    </span>

    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#pgpToolsNavbar">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="pgpToolsNavbar">
      <ul class="navbar-nav mr-auto">
        <!-- PGP Tools -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="pgpDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-key text-primary"></i> PGP/OpenPGP
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="pgpencdec.jsp">
              <i class="fas fa-lock text-primary"></i> PGP Encrypt/Decrypt Messages
            </a>
            <a class="dropdown-item" href="pgpkeyfunction.jsp">
              <i class="fas fa-key text-primary"></i> PGP Key Generation
            </a>
            <a class="dropdown-item" href="PGPFunctionality?invalidate=yes">
              <i class="fas fa-signature text-primary"></i> PGP Signature Verifier
            </a>
            <a class="dropdown-item" href="pgpdump.jsp">
              <i class="fas fa-info-circle text-primary"></i> PGP Key Dumper/Inspector
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">File Operations</h6>
            <a class="dropdown-item" href="pgp-upload.jsp">
              <i class="fas fa-file-upload text-primary"></i> PGP Send Encrypt Files
            </a>
            <a class="dropdown-item" href="pgp-file-decrypt.jsp">
              <i class="fas fa-file-download text-primary"></i> PGP Decrypt Files
            </a>
          </div>
        </li>

        <!-- Symmetric & Asymmetric Cryptography -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="cryptoDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-shield-alt text-success"></i> Encryption
          </a>
          <div class="dropdown-menu">
            <h6 class="dropdown-header">Symmetric Encryption</h6>
            <a class="dropdown-item" href="CipherFunctions.jsp">
              <i class="fas fa-shield-alt text-success"></i> Encryption/Decryption (AES, DES, 3DES)
            </a>
            <a class="dropdown-item" href="file-encrypt.jsp">
              <i class="fas fa-file-shield text-success"></i> File Encryption/Decryption
            </a>
            <a class="dropdown-item" href="fernet.jsp">
              <i class="fas fa-lock text-success"></i> Fernet Encryption/Decryption
            </a>
            <a class="dropdown-item" href="pbe.jsp">
              <i class="fas fa-key text-success"></i> PBE (Password-Based) Encryption
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">RSA & Asymmetric</h6>
            <a class="dropdown-item" href="rsafunctions.jsp">
              <i class="fas fa-key text-success"></i> RSA Encrypt/Decrypt
            </a>
            <a class="dropdown-item" href="rsasignverifyfunctions.jsp">
              <i class="fas fa-signature text-success"></i> RSA Sign/Verify
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Elliptic Curve</h6>
            <a class="dropdown-item" href="ecfunctions.jsp">
              <i class="fas fa-chart-line text-success"></i> EC Encrypt/Decrypt
            </a>
            <a class="dropdown-item" href="ecsignverify.jsp">
              <i class="fas fa-pen-fancy text-success"></i> EC Sign/Verify
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Other Algorithms</h6>
            <a class="dropdown-item" href="dsafunctions.jsp">
              <i class="fas fa-fingerprint text-success"></i> DSA Keygen/Sign/Verify
            </a>
            <a class="dropdown-item" href="elgamalfunctions.jsp">
              <i class="fas fa-lock text-success"></i> ElGamal Encrypt/Decrypt
            </a>
            <a class="dropdown-item" href="ntrufunctions.jsp">
              <i class="fas fa-cube text-success"></i> Lattice Cryptography (NTRU)
            </a>
            <a class="dropdown-item" href="DHFunctions.jsp">
              <i class="fas fa-exchange-alt text-success"></i> Diffie-Hellman Key Exchange
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">NaCl (Libsodium)</h6>
            <a class="dropdown-item" href="naclencdec.jsp">
              <i class="fas fa-shield text-success"></i> NaCl XSalsa20 Encryption
            </a>
            <a class="dropdown-item" href="naclaead.jsp">
              <i class="fas fa-shield-check text-success"></i> NaCl AEAD Encryption
            </a>
            <a class="dropdown-item" href="naclboxenc.jsp">
              <i class="fas fa-box text-success"></i> NaCl Box Encryption
            </a>
            <a class="dropdown-item" href="naclsealboxenc.jsp">
              <i class="fas fa-envelope text-success"></i> NaCl SealBox Encryption
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Classical Ciphers</h6>
            <a class="dropdown-item" href="ciph.jsp">
              <i class="fas fa-scroll text-success"></i> ROT, Caesar, Vigenère
            </a>
            <a class="dropdown-item" href="steganography-tool.jsp">
              <i class="fas fa-image text-success"></i> Steganography Tool
            </a>
          </div>
        </li>

        <!-- Hash Functions -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="hashDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-hashtag text-info"></i> Hashing
          </a>
          <div class="dropdown-menu">
            <h6 class="dropdown-header">Message Digest</h6>
            <a class="dropdown-item" href="MessageDigest.jsp">
              <i class="fas fa-hashtag text-info"></i> Message Digest (Text) - MD5, SHA
            </a>
            <a class="dropdown-item" href="mdfile.jsp">
              <i class="fas fa-file text-info"></i> Message Digest (File)
            </a>
            <a class="dropdown-item" href="hmacgen.jsp">
              <i class="fas fa-key text-info"></i> HMAC Generator
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Password Hashing</h6>
            <a class="dropdown-item" href="bccrypt.jsp">
              <i class="fas fa-shield-virus text-info"></i> BCrypt Password Hash
            </a>
            <a class="dropdown-item" href="scrypt.jsp">
              <i class="fas fa-user-shield text-info"></i> SCrypt Password Hash
            </a>
            <a class="dropdown-item" href="argon2.jsp">
              <i class="fas fa-lock text-info"></i> Argon2 Password Hash
            </a>
            <a class="dropdown-item" href="pbkdf.jsp">
              <i class="fas fa-key text-info"></i> PBKDF2 Derive Key
            </a>
            <a class="dropdown-item" href="htpasswd.jsp">
              <i class="fas fa-file-code text-info"></i> .htpasswd Generator
            </a>
          </div>
        </li>

        <!-- Certificates & SSL/TLS -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="certDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-certificate text-danger"></i> Certificates & SSL
          </a>
          <div class="dropdown-menu">
            <h6 class="dropdown-header">Certificate Management</h6>
            <a class="dropdown-item" href="certs.jsp">
              <i class="fas fa-certificate text-danger"></i> Extract Certs from URL
            </a>
            <a class="dropdown-item" href="certsverify.jsp">
              <i class="fas fa-check-circle text-danger"></i> Verify Private Key vs CSR/x509
            </a>
            <a class="dropdown-item" href="SelfSignCertificateFunctions.jsp">
              <i class="fas fa-award text-danger"></i> Self-Signed Certificate Generator
            </a>
            <a class="dropdown-item" href="cafunctions.jsp">
              <i class="fas fa-building text-danger"></i> CA/Certificate Generator
            </a>
            <a class="dropdown-item" href="signcsr.jsp">
              <i class="fas fa-file-signature text-danger"></i> Sign CSR
            </a>
            <a class="dropdown-item" href="ocsp.jsp">
              <i class="fas fa-search text-danger"></i> OCSP Query
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Keystore & PEM</h6>
            <a class="dropdown-item" href="JKSManagementFunctionality?invalidate=yes">
              <i class="fas fa-database text-danger"></i> Keystore Viewer (JKS)
            </a>
            <a class="dropdown-item" href="PemParserFunctions.jsp">
              <i class="fas fa-file-code text-danger"></i> PEM Parser/Decoder
            </a>
            <a class="dropdown-item" href="pemconvert.jsp">
              <i class="fas fa-exchange-alt text-danger"></i> PKCS#8/PKCS#1 Converter
            </a>
            <a class="dropdown-item" href="pempublic.jsp">
              <i class="fas fa-key text-danger"></i> Extract Public from Private Key
            </a>
            <a class="dropdown-item" href="pempasswordfinder.jsp">
              <i class="fas fa-unlock text-danger"></i> PEM Password Finder
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">SSL/TLS Tools</h6>
            <a class="dropdown-item" href="sslscan.jsp">
              <i class="fas fa-shield text-danger"></i> SSL/TLS Scanner
            </a>
            <a class="dropdown-item" href="asn1-decoder.jsp">
              <i class="fas fa-barcode text-danger"></i> ASN.1 Decoder
            </a>
          </div>
        </li>

        <!-- JWT & Tokens -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="jwtDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-id-badge text-warning"></i> JWT & Tokens
          </a>
          <div class="dropdown-menu">
            <h6 class="dropdown-header">JWT Tools</h6>
            <a class="dropdown-item" href="jwt-debugger.jsp">
              <i class="fas fa-bug text-warning"></i> JWT Debugger & Validator
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">JWS (JSON Web Signature)</h6>
            <a class="dropdown-item" href="jwsparse.jsp">
              <i class="fas fa-file-code text-warning"></i> JWS Parser
            </a>
            <a class="dropdown-item" href="jwsgen.jsp">
              <i class="fas fa-key text-warning"></i> JWS Generate Key & Sign
            </a>
            <a class="dropdown-item" href="jwssign.jsp">
              <i class="fas fa-signature text-warning"></i> JWS Sign with Custom Key
            </a>
            <a class="dropdown-item" href="jwsverify.jsp">
              <i class="fas fa-check-circle text-warning"></i> JWS Signature Verification
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">JWK (JSON Web Key)</h6>
            <a class="dropdown-item" href="jwkfunctions.jsp">
              <i class="fas fa-key text-warning"></i> JWK Generate
            </a>
            <a class="dropdown-item" href="jwkconvertfunctions.jsp">
              <i class="fas fa-exchange-alt text-warning"></i> JWK to PEM Convert
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">SAML</h6>
            <a class="dropdown-item" href="samlfunctions.jsp">
              <i class="fas fa-signature text-warning"></i> SAML Sign Message
            </a>
            <a class="dropdown-item" href="samlverifysign.jsp">
              <i class="fas fa-check-circle text-warning"></i> SAML Verify/Sign
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">2FA & OTP</h6>
            <a class="dropdown-item" href="totp-hotp.jsp">
              <i class="fas fa-mobile-alt text-warning"></i> TOTP/HOTP 2FA Generator
            </a>
          </div>
        </li>

        <!-- Encoders & Utilities -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="encoderDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-code text-secondary"></i> Encoders & Utils
          </a>
          <div class="dropdown-menu">
            <h6 class="dropdown-header">Base Encoding</h6>
            <a class="dropdown-item" href="Base64Functions.jsp">
              <i class="fas fa-file-code text-secondary"></i> Base64 Encode/Decode
            </a>
            <a class="dropdown-item" href="Base32Functions.jsp">
              <i class="fas fa-barcode text-secondary"></i> Base32 Encode/Decode
            </a>
            <a class="dropdown-item" href="Base58Functions.jsp">
              <i class="fas fa-bitcoin text-secondary"></i> Base58 Encode/Decode
            </a>
            <a class="dropdown-item" href="base64Hex.jsp">
              <i class="fas fa-exchange-alt text-secondary"></i> Base64 To Hex
            </a>
            <a class="dropdown-item" href="base64image.jsp">
              <i class="fas fa-image text-secondary"></i> Base64 Image Converter
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Other Encoders</h6>
            <a class="dropdown-item" href="UrlEncodeDecodeFunctions.jsp">
              <i class="fas fa-link text-secondary"></i> URL Encode/Decode
            </a>
            <a class="dropdown-item" href="HexToStringFunctions.jsp">
              <i class="fas fa-hashtag text-secondary"></i> Hex/String Conversion
            </a>
            <a class="dropdown-item" href="hexdump.jsp">
              <i class="fas fa-file-code text-secondary"></i> Hexdump Generator
            </a>
            <a class="dropdown-item" href="base-converter.jsp">
              <i class="fas fa-calculator text-secondary"></i> Base Converter (All Bases)
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Data Formats</h6>
            <a class="dropdown-item" href="jsonparser.jsp">
              <i class="fas fa-brackets-curly text-secondary"></i> JSON Beautifier
            </a>
            <a class="dropdown-item" href="yamlparser.jsp">
              <i class="fas fa-file-code text-secondary"></i> YAML-2-JSON/XML
            </a>
            <a class="dropdown-item" href="xml2json.jsp">
              <i class="fas fa-code text-secondary"></i> XML-2-JSON/YAML
            </a>
            <a class="dropdown-item" href="json-2-csv.jsp">
              <i class="fas fa-table text-secondary"></i> JSON-2-CSV
            </a>
            <a class="dropdown-item" href="csv-2-json.jsp">
              <i class="fas fa-file-csv text-secondary"></i> CSV-2-JSON
            </a>
            <div class="dropdown-divider"></div>
            <h6 class="dropdown-header">Generators</h6>
            <a class="dropdown-item" href="passwdgen.jsp">
              <i class="fas fa-key text-secondary"></i> Password Generator
            </a>
            <a class="dropdown-item" href="uuid.jsp">
              <i class="fas fa-fingerprint text-secondary"></i> UUID/GUID Generator
            </a>
            <a class="dropdown-item" href="random-string.jsp">
              <i class="fas fa-random text-secondary"></i> Random String Generator
            </a>
          </div>
        </li>

        <!-- Security Tools -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle text-dark" href="#" id="securityDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <i class="fas fa-shield text-purple"></i> Security Tools
          </a>
          <div class="dropdown-menu">
            <a class="dropdown-item" href="sshfunctions.jsp">
              <i class="fas fa-terminal text-purple"></i> SSH-Keygen
            </a>
            <a class="dropdown-item" href="security-headers-checker.jsp">
              <i class="fas fa-shield text-purple"></i> Security Headers Checker
            </a>
            <a class="dropdown-item" href="InspectJSFunctions.jsp">
              <i class="fas fa-search text-purple"></i> InspectJS Scanner
            </a>
            <a class="dropdown-item" href="subdomain.jsp">
              <i class="fas fa-sitemap text-purple"></i> Subdomain Finder
            </a>
          </div>
        </li>

      </ul>
    </div>
  </div>
  <script>
    // Mark active item within PGP cryptography bar
    (function(){
      try{
        var path = location.pathname.replace(/^\/+/, '');
        var links = document.querySelectorAll('#pgpToolsNavbar .dropdown-item');
        Array.prototype.forEach.call(links, function(a){
          var href = (a.getAttribute('href')||'').replace(/^\/+/, '');
          if(href && path.endsWith(href)){
            a.classList.add('active');
          }
        });
      }catch(e){}
    })();
  </script>
</nav>
