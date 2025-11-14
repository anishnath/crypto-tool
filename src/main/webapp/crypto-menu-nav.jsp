<!-- Compact Cryptography Tools Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-light bg-light mb-3 border-bottom">
    <div class="container-fluid px-0">
        <span class="navbar-brand text-dark">
            <i class="fas fa-shield-alt text-primary"></i> <span class="text-muted">Cryptography Tools</span>
        </span>
        
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#cryptoToolsNavbar">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="cryptoToolsNavbar">
            <ul class="navbar-nav mr-auto">
                <!-- Encryption Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="encryptionDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-lock text-primary"></i> Encryption
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="rsafunctions.jsp">
                            <i class="fas fa-key text-primary"></i> RSA Encryption/Decryption
                        </a>
                        <a class="dropdown-item" href="ecfunctions.jsp">
                            <i class="fas fa-ellipsis-h text-primary"></i> Elliptic Curve Encryption
                        </a>
                        <a class="dropdown-item" href="CipherFunctions.jsp">
                            <i class="fas fa-cog text-primary"></i> Symmetric Encryption
                        </a>
                        <a class="dropdown-item" href="fernet.jsp">
                            <i class="fas fa-shield text-primary"></i> Fernet Encryption
                        </a>
                        <a class="dropdown-item" href="file-encrypt.jsp">
                            <i class="fas fa-file-alt text-primary"></i> File Encryption
                        </a>
                        <a class="dropdown-item" href="ntrufunctions.jsp">
                            <i class="fas fa-cube text-primary"></i> Lattice Cryptography (NTRU)
                        </a>
                        <a class="dropdown-item" href="elgamalfunctions.jsp">
                            <i class="fas fa-random text-primary"></i> ElGamal Encryption
                        </a>
                    </div>
                </li>
                
                <!-- Digital Signatures -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="signaturesDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-signature text-success"></i> Signatures
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="rsasignverifyfunctions.jsp">
                            <i class="fas fa-stamp text-success"></i> RSA Sign/Verify
                        </a>
                        <a class="dropdown-item" href="ecsignverify.jsp">
                            <i class="fas fa-check-circle text-success"></i> EC Sign/Verify
                        </a>
                        <a class="dropdown-item" href="dsafunctions.jsp">
                            <i class="fas fa-certificate text-success"></i> DSA Sign/Verify
                        </a>
                        <a class="dropdown-item" href="jwsgen.jsp">
                            <i class="fas fa-json text-success"></i> JWS Generate & Sign
                        </a>
                        <a class="dropdown-item" href="jwssign.jsp">
                            <i class="fas fa-edit text-success"></i> JWS Custom Key Sign
                        </a>
                        <a class="dropdown-item" href="jwsverify.jsp">
                            <i class="fas fa-search text-success"></i> JWS Signature Verification
                        </a>
                        <a class="dropdown-item" href="samlfunctions.jsp">
                            <i class="fas fa-exchange-alt text-success"></i> SAML Message Signing
                        </a>
                    </div>
                </li>
                
                <!-- Hash Functions -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="hashDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-hashtag text-warning"></i> Hash Functions
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="MessageDigest.jsp">
                            <i class="fas fa-text-height text-warning"></i> Text Hash Generation
                        </a>
                        <a class="dropdown-item" href="mdfile.jsp">
                            <i class="fas fa-file text-warning"></i> File Hash Generation
                        </a>
                        <a class="dropdown-item" href="hmacgen.jsp">
                            <i class="fas fa-link text-warning"></i> HMAC Generation
                        </a>
                        <a class="dropdown-item" href="bccrypt.jsp">
                            <i class="fas fa-user-shield text-warning"></i> BCrypt Password Hash
                        </a>
                        <a class="dropdown-item" href="scrypt.jsp">
                            <i class="fas fa-user-lock text-warning"></i> SCrypt Password Hash
                        </a>
                        <a class="dropdown-item" href="pbkdf.jsp">
                            <i class="fas fa-key text-warning"></i> PBKDF2 Key Derivation
                        </a>
                        <a class="dropdown-item" href="htpasswd.jsp">
                            <i class="fas fa-server text-warning"></i> .htpasswd Generator
                        </a>
                    </div>
                </li>
                
                <!-- Key Management -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="keyManagementDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-key text-info"></i> Key Management
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="pgpkeyfunction.jsp">
                            <i class="fas fa-pgp text-info"></i> PGP Key Generation
                        </a>
                        <a class="dropdown-item" href="sshfunctions.jsp">
                            <i class="fas fa-terminal text-info"></i> SSH Key Generation
                        </a>
                        <a class="dropdown-item" href="jwkfunctions.jsp">
                            <i class="fas fa-json text-info"></i> JWK Generation
                        </a>
                        <a class="dropdown-item" href="jwkconvertfunctions.jsp">
                            <i class="fas fa-exchange-alt text-info"></i> JWK to PEM Converter
                        </a>
                        <a class="dropdown-item" href="pempublic.jsp">
                            <i class="fas fa-unlock text-info"></i> Extract Public Key
                        </a>
                        <a class="dropdown-item" href="pemconvert.jsp">
                            <i class="fas fa-sync text-info"></i> PKCS#8/PKCS#1 Converter
                        </a>
                        <a class="dropdown-item" href="pempasswordfinder.jsp">
                            <i class="fas fa-search text-info"></i> Encrypted PEM Password Finder
                        </a>
                    </div>
                </li>
                
                <!-- Certificates -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="certificatesDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-certificate text-secondary"></i> Certificates
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="cafunctions.jsp">
                            <i class="fas fa-building text-secondary"></i> Root CA Generation
                        </a>
                        <a class="dropdown-item" href="SelfSignCertificateFunctions.jsp">
                            <i class="fas fa-user-check text-secondary"></i> Self-Signed Certificate
                        </a>
                        <a class="dropdown-item" href="signcsr.jsp">
                            <i class="fas fa-pen text-secondary"></i> CSR Signing
                        </a>
                        <a class="dropdown-item" href="certs.jsp">
                            <i class="fas fa-globe text-secondary"></i> Extract Certs from URL
                        </a>
                        <a class="dropdown-item" href="certsverify.jsp">
                            <i class="fas fa-check-double text-secondary"></i> Certificate Verification
                        </a>
                        <a class="dropdown-item" href="ocsp.jsp">
                            <i class="fas fa-question-circle text-secondary"></i> OCSP Query
                        </a>
                        <a class="dropdown-item" href="JKSManagementFunctionality?invalidate=yes">
                            <i class="fas fa-database text-secondary"></i> Keystore/Truststore Viewer
                        </a>
                    </div>
                </li>
                
                <!-- Security Tools -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="securityDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-shield-alt text-danger"></i> Security
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="sslscan.jsp">
                            <i class="fas fa-search text-danger"></i> SSL/TLS Scanner
                        </a>
                        <a class="dropdown-item" href="PemParserFunctions.jsp">
                            <i class="fas fa-file-code text-danger"></i> PEM Parser
                        </a>
                        <a class="dropdown-item" href="passwdgen.jsp">
                            <i class="fas fa-random text-danger"></i> Strong Password Generator
                        </a>
                        <a class="dropdown-item" href="uuid.jsp">
                            <i class="fas fa-fingerprint text-danger"></i> UUID/GUID Generator
                        </a>
                        <a class="dropdown-item" href="DHFunctions.jsp">
                            <i class="fas fa-exchange-alt text-danger"></i> Diffie-Hellman Key Exchange
                        </a>
                    </div>
                </li>
                
                <!-- File Sharing -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-dark" href="#" id="sharingDropdown" role="button" data-toggle="dropdown">
                        <i class="fas fa-share-alt text-success"></i> File Sharing
                    </a>
                    <div class="dropdown-menu">
                        <a class="dropdown-item" href="share-file.jsp">
                            <i class="fas fa-file-upload text-success"></i> Secure File Transfer
                        </a>
                        <a class="dropdown-item" href="pgp-upload.jsp">
                            <i class="fas fa-pgp text-success"></i> PGP Send & Encrypt Files
                        </a>
                        <a class="dropdown-item" href="pgp-file-decrypt.jsp">
                            <i class="fas fa-pgp text-success"></i> PGP File Decryption
                        </a>
                        <a class="dropdown-item" href="securebin.jsp">
                            <i class="fas fa-lock text-success"></i> Secure Content Sharing
                        </a>
                        <a class="dropdown-item" href="pastebin.jsp">
                            <i class="fas fa-clipboard text-success"></i> Text Content Sharing
                        </a>
                        <a class="dropdown-item" href="temp-email.jsp">
                            <i class="fas fa-envelope text-success"></i> Temporary Email
                        </a>
                    </div>
                </li>
            </ul>
            
            <!-- Quick Actions -->
<%--            <ul class="navbar-nav">--%>
<%--                <li class="nav-item">--%>
<%--                    <a class="nav-link text-muted" href="related-cryptography.jsp">--%>
<%--                        <i class="fas fa-th"></i> All Tools--%>
<%--                    </a>--%>
<%--                </li>--%>
<%--            </ul>--%>
        </div>
    </div>
</nav>
