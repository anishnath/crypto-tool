<!-- Sidebar with Collapsible Sections -->
<div class="col-lg-3 col-md-4">

    <!-- Ad Widget -->
    <%@ include file="footer_adsense.jsp"%>

    <!-- Quick Links -->
    <div class="card my-4">
        <h5 class="card-header">Quick Access</h5>
        <div class="card-body">
            <div class="accordion" id="sidebarAccordion">

                <!-- Sharing Services -->
                <div class="card">
                    <div class="card-header" id="headingSharing">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left" type="button" data-toggle="collapse" data-target="#collapseSharing" aria-expanded="true" aria-controls="collapseSharing">
                                <i class="fas fa-share-alt"></i> Sharing Services
                            </button>
                        </h6>
                    </div>
                    <div id="collapseSharing" class="collapse" aria-labelledby="headingSharing" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="pgp-upload.jsp">PGP Send Encrypt files</a></li>
                                <li><a href="securebin.jsp">Share Secret Content</a></li>
                                <li><a href="pastebin.jsp">TextBin Share Content</a></li>
                                <li><a href="share-file.jsp">Transfer files securely</a></li>
                                <li><a href="temp-email.jsp">Temporary Email</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- PGP Tools -->
                <div class="card">
                    <div class="card-header" id="headingPGP">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapsePGP" aria-expanded="false" aria-controls="collapsePGP">
                                <i class="fas fa-key"></i> PGP Tools
                            </button>
                        </h6>
                    </div>
                    <div id="collapsePGP" class="collapse" aria-labelledby="headingPGP" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="pgpencdec.jsp">PGP Encryption/Decryption</a></li>
                                <li><a href="pgpkeyfunction.jsp">PGP Key Generation</a></li>
                                <li><a href="PGPFunctionality?invalidate=yes">PGP Signature Verifier</a></li>
                                <li><a href="pgpdump.jsp">PGP KeyDumper</a></li>
                                <li><a href="pgp-upload.jsp">PGP Send Encrypt files</a></li>
                                <li><a href="pgp-file-decrypt.jsp">PGP Decrypt files</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Cryptography -->
                <div class="card">
                    <div class="card-header" id="headingCrypto">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseCrypto" aria-expanded="false" aria-controls="collapseCrypto">
                                <i class="fas fa-lock"></i> Cryptography
                            </button>
                        </h6>
                    </div>
                    <div id="collapseCrypto" class="collapse" aria-labelledby="headingCrypto" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="MessageDigest.jsp">Message Digest (Text)</a></li>
                                <li><a href="mdfile.jsp">Message Digest (File)</a></li>
                                <li><a href="hmacgen.jsp">HMAC Generator</a></li>
                                <li><a href="sslscan.jsp">SSL Scanner</a></li>
                                <li><a href="CipherFunctions.jsp">Encryption/Decryption</a></li>
                                <li><a href="file-encrypt.jsp">File Encryption/Decryption</a></li>
                                <li><a href="fernet.jsp">Fernet Encryption/Decryption</a></li>
                                <li><a href="rsafunctions.jsp">RSA Encryption/Decryption</a></li>
                                <li><a href="rsasignverifyfunctions.jsp">RSA Signature/Verification</a></li>
                                <li><a href="ntrufunctions.jsp">Lattice Cryptography</a></li>
                                <li><a href="dsafunctions.jsp">DSA Keygen, Sign, Verify</a></li>
                                <li><a href="ecfunctions.jsp">EC Encryption/Decryption</a></li>
                                <li><a href="ecsignverify.jsp">EC Sign/Verify Message</a></li>
                                <li><a href="elgamalfunctions.jsp">ELGAMAL Encryption/Decryption</a></li>
                                <li><a href="pbkdf.jsp">PBKDF2 Derive Key</a></li>
                                <li><a href="pbe.jsp">PBE (PBKDF) Encryption/Decryption</a></li>
                                <li><a href="bccrypt.jsp">BCrypt Password Hash</a></li>
                                <li><a href="scrypt.jsp">SCrypt Password Hash</a></li>
                                <li><a href="htpasswd.jsp">.htpasswd Generator</a></li>
                                <li><a href="DHFunctions.jsp">Diffie-Hellman Key Exchange</a></li>
                                <li><a href="PemParserFunctions.jsp">PEM Parser/Decoder</a></li>
                                <li><a href="pempublic.jsp">Extract Public from Private Key</a></li>
                                <li><a href="certs.jsp">Extract Certs from URL</a></li>
                                <li><a href="pemconvert.jsp">PKCS#8/PKCS#1 Converter</a></li>
                                <li><a href="pempasswordfinder.jsp">PEM Password Finder</a></li>
                                <li><a href="passwdgen.jsp">Password Generator</a></li>
                                <li><a href="uuid.jsp">UUID/GUID Generator</a></li>
                                <li><a href="SelfSignCertificateFunctions.jsp">Self Sign Certificate</a></li>
                                <li><a href="cafunctions.jsp">CA/Certificate Generator</a></li>
                                <li><a href="certsverify.jsp">Verify Private Key vs CSR/x509</a></li>
                                <li><a href="ocsp.jsp">OCSP Query</a></li>
                                <li><a href="signcsr.jsp">Sign CSR</a></li>
                                <li><a href="sshfunctions.jsp">SSH-Keygen</a></li>
                                <li><a href="JKSManagementFunctionality?invalidate=yes">Keystore Viewer</a></li>
                                <li><a href="samlfunctions.jsp">SAML Sign Message</a></li>
                                <li><a href="samlverifysign.jsp">SAML Verify/Sign</a></li>
                                <li><a href="jwkfunctions.jsp">JWK Generate</a></li>
                                <li><a href="jwkconvertfunctions.jsp">JWK to PEM Convert</a></li>
                                <li><a href="jwsparse.jsp">JWS Parser</a></li>
                                <li><a href="jwsgen.jsp">JWS Generate Key Sign Data</a></li>
                                <li><a href="jwssign.jsp">JWS Sign with Custom Key</a></li>
                                <li><a href="jwsverify.jsp">JWS Signature Verification</a></li>
                                <li><a href="naclencdec.jsp">Nacl xsalsa20 Encryption</a></li>
                                <li><a href="naclaead.jsp">Nacl AEAD Encryption</a></li>
                                <li><a href="naclboxenc.jsp">Nacl Box Encryption</a></li>
                                <li><a href="naclsealboxenc.jsp">Nacl SealBox Encryption</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Network Tools -->
                <div class="card">
                    <div class="card-header" id="headingNetwork">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseNetwork" aria-expanded="false" aria-controls="collapseNetwork">
                                <i class="fas fa-network-wired"></i> Network Tools
                            </button>
                        </h6>
                    </div>
                    <div id="collapseNetwork" class="collapse" aria-labelledby="headingNetwork" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="SubnetFunctions.jsp">IP Subnet Calculator</a></li>
                                <li><a href="pingfunctions.jsp">Ping/Locate IPv4/IPv6</a></li>
                                <li><a href="curlfunctions.jsp">Curl IPv4/IPv6</a></li>
                                <li><a href="dns.jsp">DNS Lookup</a></li>
                                <li><a href="dmarc.jsp">DMARC Record Lookup</a></li>
                                <li><a href="subdomain.jsp">Subdomain Finder</a></li>
                                <li><a href="portscan.jsp">Port Scanner</a></li>
                                <li><a href="whois.jsp">Whois Lookup</a></li>
                                <li><a href="revdns.jsp">Reverse DNS</a></li>
                                <li><a href="dnsresolver.jsp">DNS Resolver Tool</a></li>
                                <li><a href="mtr.jsp">Traceroute Mtr Tool</a></li>
                                <li><a href="socket-io-client.jsp">Socket.IO Client</a></li>
                                <li><a href="websocket-client.jsp">WebSocket Client</a></li>
                                <li><a href="httpstat.jsp">HTTP Status Analysis</a></li>
                                <li><a href="screenshot.jsp">Website Screenshot</a></li>
                                <li><a href="sslscan.jsp">SSL Scanner</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- DevOps/Container -->
                <div class="card">
                    <div class="card-header" id="headingDevOps">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseDevOps" aria-expanded="false" aria-controls="collapseDevOps">
                                <i class="fas fa-docker"></i> DevOps/Container
                            </button>
                        </h6>
                    </div>
                    <div id="collapseDevOps" class="collapse" aria-labelledby="headingDevOps" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="websocket-client.jsp">WebSocket Client</a></li>
                                <li><a href="kube.jsp">Kubernetes Spec Generate</a></li>
                                <li><a href="kube1.jsp">Docker to Kubernetes</a></li>
                                <li><a href="kube2.jsp">Kubernetes to Docker Compose</a></li>
                                <li><a href="dc.jsp">Docker Compose Generator</a></li>
                                <li><a href="dc1.jsp">Docker run to Compose</a></li>
                                <li><a href="dc2.jsp">Compose to Docker run</a></li>
                                <li><a href="aws.jsp">Ansible Generator (AWS)</a></li>
                                <li><a href="aws-smtp.jsp">AWS SMTP Password Generator</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Blockchain -->
                <div class="card">
                    <div class="card-header" id="headingBlockchain">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseBlockchain" aria-expanded="false" aria-controls="collapseBlockchain">
                                <i class="fas fa-link"></i> Blockchain
                            </button>
                        </h6>
                    </div>
                    <div id="collapseBlockchain" class="collapse" aria-labelledby="headingBlockchain" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="eth-keygen.jsp">libp2p/devp2p Key Gen</a></li>
                                <li><a href="hdwallet.jsp">HD Wallet Generator</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Encoders/Converters -->
                <div class="card">
                    <div class="card-header" id="headingEncoders">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseEncoders" aria-expanded="false" aria-controls="collapseEncoders">
                                <i class="fas fa-exchange-alt"></i> Encoders/Converters
                            </button>
                        </h6>
                    </div>
                    <div id="collapseEncoders" class="collapse" aria-labelledby="headingEncoders" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
                                <li><a href="UrlEncodeDecodeFunctions.jsp">URL Encoders/Decoders</a></li>
                                <li><a href="HexToStringFunctions.jsp">Hex/String Conversion</a></li>
                                <li><a href="base64Hex.jsp">Base64 To Hex</a></li>
                                <li><a href="base64image.jsp">Base64 Image Converter</a></li>
                                <li><a href="jsonparser.jsp">JSON-2-YAML/XML</a></li>
                                <li><a href="yamlparser.jsp">YAML-2-JSON/XML</a></li>
                                <li><a href="xml2json.jsp">XML-2-JSON/YAML</a></li>
                                <li><a href="json-2-csv.jsp">JSON-2-CSV</a></li>
                                <li><a href="csv-2-json.jsp">CSV-2-JSON</a></li>
                                <li><a href="StringFunctions.jsp">String Functions</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Miscellaneous Tools -->
                <div class="card">
                    <div class="card-header" id="headingMisc">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseMisc" aria-expanded="false" aria-controls="collapseMisc">
                                <i class="fas fa-tools"></i> Miscellaneous
                            </button>
                        </h6>
                    </div>
                    <div id="collapseMisc" class="collapse" aria-labelledby="headingMisc" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="merge-pdf.jsp">Merge PDF Files</a></li>
                                <li><a href="watermark-pdf.jsp">Add WaterMark PDF</a></li>
                                <li><a href="short.jsp">URL Shortner</a></li>
                                <li><a href="qrcodegen.jsp">QR Code Generate</a></li>
                                <li><a href="hexdump.jsp">Hexdump Generate</a></li>
                                <li><a href="hexeditor.jsp">Hex Editor</a></li>
                                <li><a href="diff.jsp">Compare Text Diff</a></li>
                                <li><a href="random-string.jsp">Random Number Gen</a></li>
                                <li><a href="contactus.jsp">Feature Request</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Finance Tools -->
                <div class="card">
                    <div class="card-header" id="headingFinance">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseFinance" aria-expanded="false" aria-controls="collapseFinance">
                                <i class="fas fa-dollar-sign"></i> Finance
                            </button>
                        </h6>
                    </div>
                    <div id="collapseFinance" class="collapse" aria-labelledby="headingFinance" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
                                <li><a href="cinterest2.jsp">Compound Interest (Compare)</a></li>
                                <li><a href="cinterest.jsp">Compound Interest (Simple)</a></li>
                                <li><a href="stock-calc.jsp">Stock Profit Calculator</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <%@ include file="related-upcoming.jsp"%>

</div>