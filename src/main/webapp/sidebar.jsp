<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!-- Sidebar with Collapsible Sections -->
    <!-- Font Awesome (for icons in sidebar) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Scoped sidebar usability improvements */
        .sidebar-ux .card {
            margin-bottom: 0.75rem;
        }

        .sidebar-ux .card-header {
            padding: .5rem .75rem;
        }

        .sidebar-ux .card-header .btn {
            font-size: 1rem;
            font-weight: 600;
            color: #333;
        }

        .sidebar-ux .card-header .btn.btn-link {
            text-decoration: none;
        }

        .sidebar-ux .card-header .btn i {
            margin-right: .5rem;
        }

        /* Clear visual indicator for expand/collapse */
        .sidebar-ux .card-header .btn[aria-expanded="true"]::after {
            content: "▾";
            float: right;
            color: #6c757d;
        }

        .sidebar-ux .card-header .btn[aria-expanded="false"]::after {
            content: "▸";
            float: right;
            color: #6c757d;
        }

        /* Make list items more readable and tappable */
        .sidebar-ux .card-body {
            padding: .25rem .5rem;
        }

        .sidebar-ux ul {
            margin: 0;
        }

        .sidebar-ux ul li {
            margin: 0;
        }

        .sidebar-ux ul li a {
            display: block;
            padding: .35rem .5rem;
            border-radius: 4px;
            font-size: .95rem;
            /* bump from .875rem used by .small */
            color: #212529;
        }

        .sidebar-ux ul li a:hover {
            background: #f1f3f5;
            text-decoration: none;
        }

        /* Override Bootstrap .small in this sidebar only */
        .sidebar-ux .small {
            font-size: .95rem;
        }
    </style>
    <div class="col-lg-3 col-md-4 sidebar-ux">

        <!-- Ad Widget -->
        <%@ include file="footer_adsense.jsp" %>

            <!-- Quick Links -->
            <div class="card my-4">
                <h5 class="card-header">Quick Access</h5>
                <div class="card-body">
                    <div class="accordion" id="sidebarAccordion">

                        <!-- PGP Tools -->
                        <div class="card">
                            <div class="card-header" id="headingPGP">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapsePGP" aria-expanded="false"
                                        aria-controls="collapsePGP">
                                        <i class="fas fa-key"></i> PGP Tools
                                    </button>
                                </h6>
                            </div>
                            <div id="collapsePGP" class="collapse" aria-labelledby="headingPGP"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="pgpencdec.jsp">PGP Encryption/Decryption</a></li>
                                        <li><a href="pgpkeyfunction.jsp">PGP Key Generation</a></li>
                                        <li><a href="PGPFunctionality?invalidate=yes">PGP Signature Verifier</a></li>
                                        <li><a href="pgp-suite.jsp">PGP Suite: Sign/Verify/Keys</a></li>
                                        <li><a href="pgpdump.jsp">PGP KeyDumper</a></li>
                                        <li><a href="pgp-upload.jsp">PGP Encrypted File Transfer</a></li>
                                        <li><a href="pgp-file-decrypt.jsp">PGP Decrypt files</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Sharing Services -->
                        <div class="card">
                            <div class="card-header" id="headingSharing">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left" type="button"
                                        data-toggle="collapse" data-target="#collapseSharing" aria-expanded="true"
                                        aria-controls="collapseSharing">
                                        <i class="fas fa-share-alt"></i> Sharing Services
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseSharing" class="collapse" aria-labelledby="headingSharing"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="pgp-upload.jsp">PGP Encrypted File Transfer</a></li>
                                        <li><a href="securebin.jsp"
                                                title="Share a one‑time secret with end‑to‑end encryption">Encrypted
                                                Pastebin (E2EE, 24h)</a></li>
                                        <li><a href="pastebin.jsp"
                                                title="Pastebin: share text publicly or encrypt with a password">Pastebin
                                                (Public or Encrypted)</a></li>
                                        <li><a href="share-file.jsp">Secure File Transfer (Password Protected)</a></li>
                                        <li><a href="temp-email.jsp">Temporary Email (Disposable)</a></li>
                                        <li><a href="short.jsp">URL Shortener & Analytics (QR)</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Security Tools -->
                        <div class="card">
                            <div class="card-header" id="headingSecurity">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseSecurity" aria-expanded="false"
                                        aria-controls="collapseSecurity">
                                        <i class="fas fa-shield"></i> Security Tools
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseSecurity" class="collapse" aria-labelledby="headingSecurity"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="sshfunctions.jsp">SSH-Keygen</a></li>
                                        <li><a href="security-headers-checker.jsp">Security Headers Checker</a></li>
                                        <li><a href="InspectJSFunctions.jsp">InspectJS JavaScript Scanner</a></li>
                                        <li><a href="subdomain.jsp">Subdomain Finder</a></li>
                                        <li><a href="ssl-tls-handshake-demo.jsp">SSL/TLS Handshake Demo</a></li>
                                        <li><a href="sslscan.jsp">SSL/TLS Scanner</a></li>
                                        <li><a href="jwt-debugger.jsp">JWT Debugger & Validator</a></li>
                                        <li><a href="jwsparse.jsp">JWS Parser</a></li>
                                        <li><a href="jwsgen.jsp">JWS Generate Key Sign Data</a></li>
                                        <li><a href="jwssign.jsp">JWS Sign with Custom Key</a></li>
                                        <li><a href="jwsverify.jsp">JWS Signature Verification</a></li>
                                        <li><a href="jwkfunctions.jsp">JWK Generate</a></li>
                                        <li><a href="jwkconvertfunctions.jsp">JWK to PEM Convert</a></li>
                                        <li><a href="samlfunctions.jsp">SAML Sign Message</a></li>
                                        <li><a href="samlverifysign.jsp">SAML Verify/Sign</a></li>
                                        <li><a href="certs.jsp">Extract Certs from URL</a></li>
                                        <li><a href="certsverify.jsp">Verify Private Key vs CSR/x509</a></li>
                                        <li><a href="SelfSignCertificateFunctions.jsp">Self Sign Certificate</a></li>
                                        <li><a href="cafunctions.jsp">CA/Certificate Generator</a></li>
                                        <li><a href="signcsr.jsp">Sign CSR</a></li>
                                        <li><a href="ocsp.jsp">OCSP Query</a></li>
                                        <li><a href="JKSManagementFunctionality?invalidate=yes">Keystore Viewer</a></li>
                                        <li><a href="PemParserFunctions.jsp">PEM Parser/Decoder</a></li>
                                        <li><a href="pemconvert.jsp">PKCS#8/PKCS#1 Converter</a></li>
                                        <li><a href="pempublic.jsp">Extract Public from Private Key</a></li>
                                        <li><a href="pempasswordfinder.jsp">PEM Password Finder</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Cryptography -->
                        <div class="card">
                            <div class="card-header" id="headingCrypto">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseCrypto" aria-expanded="false"
                                        aria-controls="collapseCrypto">
                                        <i class="fas fa-lock"></i> Cryptography
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseCrypto" class="collapse" aria-labelledby="headingCrypto"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="MessageDigest.jsp">Message Digest (Text)</a></li>
                                        <li><a href="mdfile.jsp">Message Digest (File)</a></li>
                                        <li><a href="hmacgen.jsp">HMAC Generator</a></li>
                                        <li><a href="CipherFunctions.jsp">Symmetric Encryption/Decryption</a></li>
                                        <li><a href="ciph.jsp">Classical Ciphers (ROT, Caesar, Vigenère)</a></li>
                                        <li><a href="file-encrypt.jsp">File Encryption/Decryption</a></li>
                                        <li><a href="fernet.jsp">Fernet Encryption/Decryption</a></li>
                                        <li><a href="steganography-tool.jsp">Steganography Tool</a></li>
                                        <li><a href="rsafunctions.jsp">RSA Encryption/Decryption</a></li>
                                        <li><a href="rsasignverifyfunctions.jsp">RSA Signature/Verification</a></li>
                                        <li><a href="ntrufunctions.jsp">NTRU Encryption/Decryption</a></li>
                                        <li><a href="dsafunctions.jsp">DSA Keygen, Sign, Verify</a></li>
                                        <li><a href="ecfunctions.jsp">EC Encryption/Decryption</a></li>
                                        <li><a href="ecsignverify.jsp">EC Sign/Verify Message</a></li>
                                        <li><a href="elgamalfunctions.jsp">ElGamal Encryption/Decryption</a></li>
                                        <li><a href="pbkdf.jsp">PBKDF2 Derive Key</a></li>
                                        <li><a href="pbe.jsp">PBE (PBKDF) Encryption/Decryption</a></li>
                                        <li><a href="bccrypt.jsp">BCrypt Password Hash</a></li>
                                        <li><a href="scrypt.jsp">scrypt Password Hash</a></li>
                                        <li><a href="argon2.jsp">Argon2 Password Hash</a></li>
                                        <li><a href="totp-hotp.jsp">TOTP/HOTP 2FA Generator</a></li>
                                        <li><a href="htpasswd.jsp">.htpasswd Generator</a></li>
                                        <li><a href="DHFunctions.jsp">Diffie-Hellman Key Exchange</a></li>
                                        <li><a href="asn1-decoder.jsp">ASN.1 Decoder</a></li>
                                        <li><a href="passwdgen.jsp">Password Generator</a></li>
                                        <li><a href="uuid.jsp">UUID/GUID Generator</a></li>
                                        <li><a href="naclencdec.jsp">NaCl XSalsa20 Encryption</a></li>
                                        <li><a href="naclaead.jsp">NaCl AEAD Encryption</a></li>
                                        <li><a href="naclboxenc.jsp">NaCl Box Encryption</a></li>
                                        <li><a href="naclsealboxenc.jsp">NaCl Sealed Box Encryption</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Network Tools -->
                        <div class="card">
                            <div class="card-header" id="headingNetwork">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseNetwork" aria-expanded="false"
                                        aria-controls="collapseNetwork">
                                        <i class="fas fa-network-wired"></i> Network Tools
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseNetwork" class="collapse" aria-labelledby="headingNetwork"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="vpc-calculator.jsp">VPC Calculator & Subnet Planner</a></li>
                                        <li><a href="SubnetFunctions.jsp">IP Subnet Calculator (CIDR)</a></li>
                                        <li><a href="mac-address-generator.jsp">MAC Address Generator & Validator</a>
                                        </li>
                                        <li><a href="pingfunctions.jsp">Online Ping Tool (IPv4/IPv6)</a></li>
                                        <li><a href="curlfunctions.jsp">Online Curl Tool (HTTP/HTTPS)</a></li>
                                        <li><a href="ipv6-tool.jsp">IPv6 Compressor & Expander</a></li>
                                        <li><a href="dns.jsp">DNS Lookup (All Records)</a></li>
                                        <li><a href="dmarc.jsp">DMARC Record Lookup & Validator</a></li>
                                        <li><a href="subdomain.jsp">Subdomain Finder</a></li>
                                        <li><a href="portscan.jsp">Port Scanner</a></li>
                                        <li><a href="whois.jsp">WHOIS Lookup</a></li>
                                        <li><a href="revdns.jsp">Reverse DNS (PTR)</a></li>
                                        <li><a href="dnsresolver.jsp">DNS Propagation Checker</a></li>
                                        <li><a href="mtr.jsp">MTR Traceroute</a></li>
                                        <li><a href="socket-io-client.jsp">Socket.IO Client</a></li>
                                        <li><a href="websocket-client.jsp">WebSocket Client</a></li>
                                        <li><a href="httpstat.jsp">HTTP Status Analysis</a></li>
                                        <li><a href="screenshot.jsp">Website Screenshot</a></li>
                                        <li><a href="sslscan.jsp">SSL Scanner</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Legal & Compliance -->
                        <div class="card">
                            <div class="card-header" id="headingLegal">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseLegal" aria-expanded="false"
                                        aria-controls="collapseLegal">
                                        <i class="fas fa-balance-scale"></i> Legal & Compliance
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseLegal" class="collapse" aria-labelledby="headingLegal"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="app-privacy-policy-generator.jsp">App Privacy Policy Generator</a>
                                        </li>
                                        <li><a href="aup-generator.jsp">Acceptable Use Policy Generator</a></li>
                                        <li><a href="terms-of-use-generator.jsp">Terms of Use Generator</a></li>
                                        <li><a href="eula-generator.jsp">EULA Generator</a></li>
                                        <li><a href="cookie-policy-generator.jsp">Cookie Policy Generator</a></li>
                                        <li><a href="disclaimer-generator.jsp">Disclaimer Generator</a></li>
                                        <li><a href="dmca-policy-generator.jsp">DMCA Policy Generator</a></li>
                                        <li><a href="shipping-policy-generator.jsp">Shipping Policy Generator</a></li>
                                        <li><a href="return-refund-policy-generator.jsp">Return & Refund Policy
                                                Generator</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- DevOps/Container -->
                        <div class="card">
                            <div class="card-header" id="headingDevOps">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseDevOps" aria-expanded="false"
                                        aria-controls="collapseDevOps">
                                        <i class="fas fa-docker"></i> DevOps/Container
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseDevOps" class="collapse" aria-labelledby="headingDevOps"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="nginx-config-generator.jsp">Nginx Config Generator</a></li>
                                        <li><a href="load-test-generator.jsp">Load Testing Generator (K6, Locust,
                                                JMeter, Gatling)</a></li>
                                        <li><a href="chmod-calculator.jsp">Chmod Calculator (Permissions)</a></li>
                                        <li><a href="systemd-generator.jsp">Systemd Service Generator</a></li>
                                        <li><a href="dockerfile-generator.jsp">Dockerfile Generator</a></li>
                                        <li><a href="firewall-generator.jsp">Firewall Rules Generator</a></li>
                                        <li><a href="apache-virtualhost-generator.jsp">Apache VirtualHost Generator</a>
                                        </li>
                                        <li><a href="github-actions-generator.jsp">GitHub Actions Generator</a></li>
                                        <li><a href="gitlab-ci-generator.jsp">GitLab CI/CD Generator</a></li>
                                        <li><a href="websocket-client.jsp">WebSocket Client</a></li>
                                        <li><a href="prometheus-query-builder.jsp">Prometheus Query Builder</a></li>
                                        <li><a href="curl-builder.jsp">cURL Builder & HTTP Client</a></li>
                                        <li><a href="cron-generator.jsp">Cron Expression Generator</a></li>
                                        <li><a href="helm-chart-generator.jsp">Helm Chart Generator</a></li>
                                        <li><a href="kube.jsp">Kubernetes YAML Generator</a></li>
                                        <li><a href="kube1.jsp">Docker Compose to Kubernetes</a></li>
                                        <li><a href="kube2.jsp">Kubernetes to Docker Compose</a></li>
                                        <li><a href="dc.jsp">Docker Compose Generator</a></li>
                                        <li><a href="rbac-policy-generator.jsp">Kubernetes RBAC Policy Generator</a>
                                        </li>
                                        <li><a href="service-mesh-generator.jsp">Istio Service Mesh Generator</a></li>
                                        <li><a href="k8s-resource-calculator.jsp">Kubernetes Resource Calculator</a>
                                        </li>
                                        <li><a href="rate-limiter-generator.jsp">API Rate Limiter Generator</a></li>
                                        <li><a href="dc1.jsp">Docker Run to Compose</a></li>
                                        <li><a href="dc2.jsp">Compose to Docker Run</a></li>
                                        <li><a href="aws.jsp">Ansible Generator (AWS)</a></li>
                                        <li><a href="aws-smtp.jsp">AWS SMTP Password Generator</a></li>
                                        <li><a href="inframap.jsp">InfraMap - Terraform State Visualizer</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Blockchain -->
                        <div class="card">
                            <div class="card-header" id="headingBlockchain">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseBlockchain" aria-expanded="false"
                                        aria-controls="collapseBlockchain">
                                        <i class="fas fa-link"></i> Blockchain
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseBlockchain" class="collapse" aria-labelledby="headingBlockchain"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="eth-keygen.jsp">libp2p/devp2p Key Gen</a></li>
                                        <li><a href="hdwallet.jsp">HD Wallet Generator</a></li>
                                        <li><a href="bip39-mnemonic.jsp">BIP39 Mnemonic Generator</a></li>
                                        <li><a href="crypto-profit-calculator.jsp">Crypto Profit Calculator</a></li>
                                        <li><a href="bitcoin-mining-profit-calculator.jsp">Bitcoin Mining Profit
                                                Calculator</a></li>
                                        <li><a href="ethereum-gas-fee-estimator.jsp">Ethereum Gas Fee Estimator</a></li>
                                        <li><a href="crypto-tax-estimator.jsp">Crypto Tax Estimator</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Encoders/Converters -->
                        <div class="card">
                            <div class="card-header" id="headingEncoders">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseEncoders" aria-expanded="false"
                                        aria-controls="collapseEncoders">
                                        <i class="fas fa-exchange-alt"></i> Encoders/Converters
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseEncoders" class="collapse" aria-labelledby="headingEncoders"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
                                        <li><a href="Base32Functions.jsp">Base32 Encode/Decode</a></li>
                                        <li><a href="Base58Functions.jsp">Base58 Encode/Decode</a></li>
                                        <li><a href="base64Hex.jsp">Base64 To Hex</a></li>
                                        <li><a href="base64image.jsp">Base64 Image Converter</a></li>
                                        <li><a href="UrlEncodeDecodeFunctions.jsp">URL Encoders/Decoders</a></li>
                                        <li><a href="HexToStringFunctions.jsp">Hex/String Conversion</a></li>
                                        <li><a href="base-converter.jsp">Base Converter (All Bases)</a></li>
                                        <li><a href="hexdump.jsp">Hexdump Generator</a></li>
                                        <li><a href="jsonparser.jsp">JSON BeautifierL</a></li>
                                        <li><a href="yamlparser.jsp">YAML-2-JSON/XML</a></li>
                                        <li><a href="xml2json.jsp">XML-2-JSON/YAML</a></li>
                                        <li><a href="json-2-csv.jsp">JSON-2-CSV</a></li>
                                        <li><a href="csv-2-json.jsp">CSV-2-JSON</a></li>
                                        <li><a href="StringFunctions.jsp">String Functions</a></li>
                                        <li><a href="iban-validator.jsp">IBAN Validator & Generator</a></li>
                                        <li><a href="isbn-validator.jsp">ISBN Validator & Converter</a></li>
                                        <li><a href="html-to-markdown.jsp"><strong>HTML to Markdown</strong> <span
                                                    class="badge badge-success">New</span></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Developer Tools -->
                        <div class="card">
                            <div class="card-header" id="headingDev">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseDev" aria-expanded="false"
                                        aria-controls="collapseDev">
                                        <i class="fas fa-code"></i> Developer Tools
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseDev" class="collapse" aria-labelledby="headingDev"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="onecompiler.jsp"><strong>Online Compiler (60+
                                                    Languages)</strong></a></li>
                                        <li><a href="html-code-editor.jsp"><strong>HTML/CSS/JS Playground</strong> <span
                                                    class="badge badge-success">New</span></a></li>
                                        <li><a href="resume-builder.jsp"><strong>Resume Builder</strong> <span
                                                    class="badge badge-success">New</span></a></li>
                                        <li><a href="typing-speed-test.jsp"><strong>Typing Speed Test</strong> <span
                                                    class="badge badge-success">New</span></a></li>
                                        <li><a href="regex.jsp">Regex Tester</a></li>
                                        <li><a href="diff.jsp">Compare Text Diff</a></li>
                                        <li><a href="random-string.jsp">Random String Generator</a></li>
                                        <li><a href="word-character-counter.jsp">Word & Character Counter</a></li>
                                        <li><a href="base-converter.jsp">Base Converter (All Bases)</a></li>
                                        <li><a href="graph-easy.jsp">Graph-Easy ASCII Diagram Generator</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Machine Learning Visualizers -->
                        <div class="card">
                            <div class="card-header" id="headingML">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseML" aria-expanded="false"
                                        aria-controls="collapseML">
                                        <i class="fas fa-robot"></i> Machine Learning Visualizers
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseML" class="collapse" aria-labelledby="headingML"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="activation_function_explorer.jsp">Activation Function Explorer</a>
                                        </li>
                                        <li><a href="bias_variance_explorer.jsp">Bias-Variance Explorer</a></li>
                                        <li><a href="bias_variance_tradeoff.jsp">Bias-Variance Trade-off</a></li>
                                        <li><a href="clustering_studio.jsp">Clustering Studio</a></li>
                                        <li><a href="decision_boundary_playground.jsp">Decision Boundary Playground</a>
                                        </li>
                                        <li><a href="decision_tree_model_selection.jsp">Decision Tree Model
                                                Selection</a></li>
                                        <li><a href="decision_trees_random_forest.jsp">Decision Trees & Random
                                                Forest</a></li>
                                        <li><a href="diffusion_process_visualizer.jsp">Diffusion Process Visualizer</a>
                                        </li>
                                        <li><a href="gradient_descent_visualizer.jsp">Gradient Descent Visualizer</a>
                                        </li>
                                        <li><a href="imbalanced_learning_workshop.jsp">Imbalanced Learning Workshop</a>
                                        </li>
                                        <li><a href="Logistic_Regression.jsp">Logistic Regression</a></li>
                                        <li><a href="ML_Pipeline.jsp">ML Pipeline</a></li>
                                        <li><a href="neural_network_playground.jsp">Neural Network Playground</a></li>
                                        <li><a href="probability_calibration_lab.jsp">Probability Calibration Lab</a>
                                        </li>
                                        <li><a href="ROC_AUC.jsp">ROC AUC</a></li>
                                        <li><a href="shap_explorer.jsp">SHAP Explorer</a></li>
                                        <li><a href="cyclical_encoding_visualizer.jsp">Cyclical Encoding Visualizer</a>
                                        </li>
                                        <li><a href="feature_hashing_collision_explorer.jsp">Feature Hashing Collision
                                                Explorer</a></li>
                                        <li><a href="categorical_encoding_lab.jsp">Categorical Encoding Lab</a></li>
                                        <li><a href="predicted_probability_explorer.jsp">Predicted Probability
                                                Explorer</a></li>
                                        <li><a href="model_validation_lab.jsp">Model Validation Lab</a></li>
                                        <li><a href="transformers_attention_visualizer.jsp">Transformers Attention
                                                Visualizer</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Media Tools -->
                        <div class="card">
                            <div class="card-header" id="headingMedia">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseMedia" aria-expanded="false"
                                        aria-controls="collapseMedia">
                                        <i class="fas fa-photo-film"></i> Media Tools
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseMedia" class="collapse" aria-labelledby="headingMedia"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="video-trim.jsp">Video Trimmer & Cutter</a></li>
                                        <li><a href="video-resizer.jsp">Video Resizer & Cropper</a></li>
                                        <li><a href="image-resizer.jsp">Image Resizer</a></li>
                                        <li><a href="svg-to-image.jsp">SVG to PNG/JPG</a></li>
                                        <li><a href="gif-mp4-converter.jsp">GIF ↔ MP4 Converter</a></li>
                                        <li><a href="heic-to-jpg.jsp">HEIC to JPG/PNG</a></li>
                                        <li><a href="webp-converter.jsp">WebP to JPG/PNG</a></li>
                                        <li><a href="png-jpg-converter.jsp">PNG ↔ JPG</a></li>
                                        <li><a href="exif-remover.jsp">EXIF Remover</a></li>
                                        <li><a href="exif-editor.jsp">EXIF Editor</a></li>
                                        <li><a href="heic-to-jpg.jsp">HEIC to JPG/PNG</a></li>
                                        <li><a href="webp-converter.jsp">WebP to JPG/PNG</a></li>
                                        <li><a href="png-jpg-converter.jsp">PNG ↔ JPG</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>

                        <!-- Sharing Services -->
                        <!-- Documents/PDF -->
                        <div class="card">
                            <div class="card-header" id="headingDocs">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseDocs" aria-expanded="false"
                                        aria-controls="collapseDocs">
                                        <i class="fas fa-file-pdf"></i> Documents & PDF
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseDocs" class="collapse" aria-labelledby="headingDocs"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="invoice-generator.jsp">Invoice Generator</a></li>
                                        <li><a href="pdf-to-word.jsp">PDF to Word (DOCX)</a></li>
                                        <li><a href="merge-pdf.jsp">Merge PDF Files</a></li>
                                        <li><a href="split-pdf.jsp">Split PDF</a></li>
                                        <li><a href="compress-pdf.jsp">Compress PDF</a></li>
                                        <li><a href="pdf-to-jpg.jsp">PDF to JPG</a></li>
                                        <li><a href="jpg-to-pdf.jsp">JPG to PDF</a></li>
                                        <li><a href="pdf-to-images.jsp">PDF to Images</a></li>
                                        <li><a href="pdf-password.jsp">PDF Password: Remove / Add / Change</a></li>
                                        <li><a href="crack-pdf-password.jsp">Crack PDF Password</a></li>
                                        <li><a href="watermark-pdf.jsp">Add Watermark to PDF</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>


                        <!-- Miscellaneous removed: links moved to Sharing and Developer sections -->

                        <!-- Finance Tools -->
                        <div class="card">
                            <div class="card-header" id="headingFinance">
                                <h6 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button"
                                        data-toggle="collapse" data-target="#collapseFinance" aria-expanded="false"
                                        aria-controls="collapseFinance">
                                        <i class="fas fa-dollar-sign"></i> Finance
                                    </button>
                                </h6>
                            </div>
                            <div id="collapseFinance" class="collapse" aria-labelledby="headingFinance"
                                data-parent="#sidebarAccordion">
                                <div class="card-body p-2">
                                    <ul class="list-unstyled mb-0 small">
                                        <li><a href="sip-calculator.jsp">SIP Calculator</a></li>
                                        <li><a href="sip-vs-lumpsum-calculator.jsp">SIP vs Lumpsum Calculator</a></li>
                                        <li><a href="retirement-calculator.jsp">Retirement Planning Calculator</a></li>
                                        <li><a href="fire-calculator.jsp">FIRE Calculator</a></li>
                                        <li><a href="net-worth-calculator.jsp">Net Worth Calculator & Tracker</a></li>
                                        <li><a href="tax-calculator.jsp">Income Tax Calculator</a></li>
                                        <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
                                        <li><a href="mortgage-affordability-calculator.jsp">Mortgage Affordability
                                                Calculator</a></li>
                                        <li><a href="prepay-vs-invest-calculator.jsp">Prepay vs Invest Calculator</a>
                                        </li>
                                        <li><a href="debt-payoff-calculator.jsp">Debt Payoff Calculator</a></li>
                                        <li><a href="lease-vs-buy-calculator.jsp">Lease vs Buy Calculator</a></li>
                                        <li><a href="college-cost-roi-calculator.jsp">College Cost & ROI Calculator</a>
                                        </li>
                                        <li><a href="rent-vs-buy-calculator.jsp">Rent vs Buy Calculator</a></li>
                                        <li><a href="capital-gains-tax-calculator.jsp">Capital Gains Tax Calculator</a>
                                        </li>
                                        <li><a href="cost-of-living-comparison.jsp">Cost of Living Comparison</a></li>
                                        <li><a href="cinterest2.jsp">Compound Interest (Compare)</a></li>
                                        <li><a href="cinterest.jsp">Compound Interest (Simple)</a></li>
                                        <li><a href="drip-calculator.jsp">Dividend Reinvestment (DRIP) Calculator</a>
                                        </li>
                                        <li><a href="annuity-calculator.jsp">Annuity Payout & Present Value</a></li>
                                        <li><a href="savings-goal-calculator.jsp">Savings Goal Calculator</a></li>
                                        <li><a href="stock-calc.jsp">Stock Profit Calculator</a></li>
                                    </ul>
                                </div>
                            </div>

                            <!-- Health Tools -->
                            <div class="card">
                                <div class="card-header" id="headingHealth">
                                    <h6 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapseHealth" aria-expanded="false"
                                            aria-controls="collapseHealth">
                                            <i class="fas fa-heartbeat"></i> Health
                                        </button>
                                    </h6>
                                </div>
                                <div id="collapseHealth" class="collapse" aria-labelledby="headingHealth"
                                    data-parent="#sidebarAccordion">
                                    <div class="card-body p-2">
                                        <ul class="list-unstyled mb-0 small">
                                            <li><a href="bmi-ideal-weight-calculator.jsp">BMI & Ideal Weight
                                                    Calculator</a></li>
                                            <li><a href="calorie-macro-calculator.jsp">Daily Calorie & Macro
                                                    Calculator</a></li>
                                            <li><a href="ovulation-calculator.jsp">Ovulation & Fertility Window</a></li>
                                            <li><a href="pregnancy-due-date-calculator.jsp">Pregnancy Due Date
                                                    Planner</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Lifestyle & Productivity -->
                            <div class="card">
                                <div class="card-header" id="headingLifeProd">
                                    <h6 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapseLifeProd" aria-expanded="false"
                                            aria-controls="collapseLifeProd">
                                            <i class="fas fa-utensils"></i> Lifestyle & Productivity
                                        </button>
                                    </h6>
                                </div>
                                <div id="collapseLifeProd" class="collapse" aria-labelledby="headingLifeProd"
                                    data-parent="#sidebarAccordion">
                                    <div class="card-body p-2">
                                        <ul class="list-unstyled mb-0 small">
                                            <li><a href="resume-builder.jsp"><strong>Resume Builder (50+
                                                        Templates)</strong> <span
                                                        class="badge badge-warning">Hot</span></a></li>
                                            <li><a href="typing-speed-test.jsp"><strong>Typing Speed Test</strong> <span
                                                        class="badge badge-success">New</span></a></li>
                                            <li><a href="mind-map-maker.jsp">Mind Map Maker (Online)</a></li>
                                            <li><a href="tip-calculator.jsp">Tip Calculator & Split Bill</a></li>
                                            <li><a href="timezone-converter.jsp">Time Zone Converter & Scheduler</a>
                                            </li>
                                            <li><a href="unix-timestamp-converter.jsp">Unix Timestamp Converter</a></li>
                                            <li><a href="age-calculator.jsp">Age Calculator & Milestone Tracker</a></li>
                                            <li><a href="qr-code-generator.jsp">QR Code Generator</a></li>
                                            <li><a href="ean-upc-barcode-generator.jsp">EAN/UPC Barcode Generator</a>
                                            </li>
                                            <li><a href="date-difference-calculator.jsp">Date Difference Calculator</a>
                                            </li>
                                            <li><a href="random-number-generator.jsp">Random Number Generator</a></li>
                                            <li><a href="morse-code-translator.jsp">Morse Code Translator</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Chemistry -->
                            <div class="card">
                                <div class="card-header" id="headingChem">
                                    <h6 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapseChem" aria-expanded="false"
                                            aria-controls="collapseChem">
                                            <i class="fas fa-flask"></i> Chemistry
                                        </button>
                                    </h6>
                                </div>
                                <div id="collapseChem" class="collapse" aria-labelledby="headingChem"
                                    data-parent="#sidebarAccordion">
                                    <div class="card-body p-2">
                                        <ul class="list-unstyled mb-0 small">
                                            <li><a href="periodic-table.jsp"><i class="fas fa-th"></i> <strong>Periodic
                                                        Table (Interactive)</strong></a></li>
                                            <li><a href="molar-mass-calculator.jsp">Molar Mass Calculator</a></li>
                                            <li><a href="percent-composition-calculator.jsp">Percent Composition
                                                    Calculator</a></li>
                                            <li><a href="significant-figures-calculator.jsp">Significant Figures
                                                    Calculator</a></li>
                                            <li><a href="chemical-equation-balancer.jsp">Chemical Equation Balancer</a>
                                            </li>
                                            <li><a href="molarity-dilution-calculator.jsp">Molarity + Dilution
                                                    (C1V1=C2V2)</a></li>
                                            <li><a href="unit-converter-chemistry.jsp">Unit Converter (Mass, Volume,
                                                    Pressure, Temp, Energy)</a></li>
                                            <li><a href="density-calculator.jsp">Density Calculator (d=m/v)</a></li>
                                            <li><a href="ph-calculator.jsp">pH Calculator (Strong/Weak Acids & Bases +
                                                    Buffers)</a></li>
                                            <li><a href="buffer-solution-calculator.jsp">Buffer Solution Calculator
                                                    (Henderson-Hasselbalch)</a></li>
                                            <li><a href="electron-configuration-calculator.jsp">Electron Configuration
                                                    Calculator</a></li>
                                            <li><a href="ideal-gas-law-calculator.jsp">Ideal Gas Law Calculator
                                                    (PV=nRT)</a></li>
                                            <li><a href="stoichiometry-calculator.jsp">Stoichiometry Calculator</a></li>
                                            <li><a href="percent-yield-calculator.jsp">Percent Yield Calculator</a></li>
                                            <li><a href="limiting-reagent-calculator.jsp">Limiting Reagent
                                                    Calculator</a></li>
                                            <li><a href="empirical-formula-calculator.jsp">Empirical & Molecular Formula
                                                    Calculator</a></li>
                                            <li><a href="titration-calculator.jsp">Titration Calculator (Acid-Base &
                                                    pH)</a></li>
                                            <li><a href="redox-balancer.jsp">Redox Reaction Balancer (Half-Reaction
                                                    Method)</a></li>
                                            <li><a href="electrochemistry-calculator.jsp">Electrochemistry Calculator
                                                    (Nernst & Faraday)</a></li>
                                            <li><a href="thermochemistry-calculator.jsp">Thermochemistry Calculator
                                                    (Calorimetry & Enthalpy)</a></li>
                                            <li><a href="lewis-structure-generator.jsp">Lewis Structure & VSEPR
                                                    Calculator</a></li>
                                            <li><a href="molecular-geometry-calculator.jsp">Molecular Geometry
                                                    Calculator</a></li>
                                            <li><a href="half-life-calculator.jsp">Half-Life Calculator</a></li>
                                            <li><a href="equilibrium-constant-calculator.jsp">Equilibrium Constant
                                                    Calculator (Kc, Kp, Ka, Kb)</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>

                            <!-- Math & Education -->
                            <div class="card">
                                <div class="card-header" id="headingMath">
                                    <h6 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapseMath" aria-expanded="false"
                                            aria-controls="collapseMath">
                                            <i class="fas fa-percentage"></i> Math & Education
                                        </button>
                                    </h6>
                                </div>
                                <div id="collapseMath" class="collapse" aria-labelledby="headingMath"
                                    data-parent="#sidebarAccordion">
                                    <div class="card-body p-2">
                                        <ul class="list-unstyled mb-0 small">
                                            <li><a href="scientific-calculator.jsp">Scientific Calculator</a></li>
                                            <li><a href="graphing-calculator.jsp">Graphing Calculator</a></li>
                                            <li><a href="area-volume-calculator.jsp">Area & Volume Calculator</a></li>
                                            <li><a href="distance-formula-calculator.jsp">Distance Formula
                                                    Calculator</a></li>
                                            <li><a href="math-art-gallery.jsp">Math Art Gallery - Fractal Generator &
                                                    Parametric Plotter</a></li>

                                            <li><a href="latex-equation-editor.jsp">Math Equation Editor</a></li>
                                            <li><a href="latex-document-editor.jsp">LaTeX Document Editor</a></li>
                                            <li><a href="tikz-viewer.jsp">TikZ Viewer & Editor</a></li>
                                            <li><a href="algebraic-simplifier.jsp">Algebraic Expression Simplifier</a>
                                            </li>
                                            <li><a href="factoring-calculator.jsp">Factoring Calculator</a></li>
                                            <li><a href="linear-equations-solver.jsp">Equation Solver (Ax=b, AX=B,
                                                    Polynomial)</a></li>
                                            <li><a href="quadratic-solver.jsp">Quadratic Equation Solver
                                                    (ax²+bx+c=0)</a></li>
                                            <li><a href="system-equations-solver.jsp">System of Equations Solver (2x2,
                                                    3x3)</a></li>
                                            <li><a href="logarithm-calculator.jsp">Logarithm Calculator</a></li>
                                            <li><a href="exponent-calculator.jsp">Exponent Calculator (Laws of
                                                    Exponents)</a></li>
                                            <li><a href="radical-simplifier.jsp">Radical Simplifier (√, ∛,
                                                    Rationalize)</a></li>
                                            <li><a href="inequality-solver.jsp">Inequality Solver (Linear, Quadratic,
                                                    Polynomial)</a></li>
                                            <li><a href="matrix-determinant-calculator.jsp">Matrix Determinant
                                                    Calculator</a></li>
                                            <li><a href="matrix-inverse-calculator.jsp">Matrix Inverse Calculator</a>
                                            </li>
                                            <li><a href="matrix-eigenvalue-calculator.jsp">Eigenvalue & Eigenvector
                                                    Calculator</a></li>
                                            <li><a href="matrix-rank-calculator.jsp">Matrix Rank Calculator</a></li>
                                            <li><a href="matrix-power-calculator.jsp">Matrix Power Calculator (A^n)</a>
                                            </li>
                                            <li><a href="matrix-multiplication-calculator.jsp">Matrix Multiplication
                                                    Calculator</a></li>
                                            <li><a href="matrix-addition-calculator.jsp">Matrix Addition Calculator</a>
                                            </li>
                                            <li><a href="matrix-transpose-calculator.jsp">Matrix Transpose
                                                    Calculator</a></li>
                                            <li><a href="matrix-type-classifier.jsp">Matrix Type Classifier</a></li>
                                            <li><a href="derivative-calculator.jsp">Derivative Calculator</a></li>
                                            <li><a href="integral-calculator.jsp">Integral Calculator (Definite &
                                                    Indefinite)</a></li>
                                            <li><a href="limit-calculator.jsp">Limit Calculator</a></li>
                                            <li><a href="series-calculator.jsp">Taylor/Maclaurin Series Calculator</a>
                                            </li>
                                            <li><a href="guitar-chord-finder.jsp">Guitar Chord Finder</a></li>
                                            <li><a href="mind-reading-trick.jsp">Mind Reading Number Trick</a></li>
                                            <li><a href="magic-square-generator.jsp">Magic Square Generator</a></li>
                                            <li><a href="pascals-triangle-explorer.jsp">Pascal's Triangle Explorer</a>
                                            </li>
                                            <li><a href="collatz-conjecture.jsp">Collatz Conjecture (3n+1 Problem)</a>
                                            </li>
                                            <li><a href="kaprekar.jsp">Kaprekar's Constant (6174)</a></li>
                                            <li><a href="addition-methods.jsp">Addition Methods Visualizer</a></li>
                                            <li><a href="magic-1089.jsp">Magic 1089 Trick</a></li>
                                            <li><a href="21-card-trick.jsp">21 Card Trick</a></li>
                                            <li><a href="24-game-solver.jsp">24 Game Solver</a></li>
                                            <li><a href="spirograph-simulator.jsp">Spirograph Simulator</a></li>
                                            <li><a href="tower-of-hanoi.jsp">Tower of Hanoi</a></li>
                                            <li><a href="monty-hall-simulator.jsp">Monty Hall Simulator</a></li>
                                            <li><a href="prime-spiral.jsp">Prime Spiral (Ulam)</a></li>
                                            <li><a href="fibonacci-spiral.jsp">Fibonacci Spiral</a></li>
                                            <li><a href="binary-card-trick.jsp">Binary Card Trick</a></li>
                                            <li><a href="recaman-sequence.jsp">Recamán's Sequence</a></li>
                                            <li><a href="pythagorean-triples.jsp">Pythagorean Triples</a></li>
                                            <li><a href="sudoku-solver.jsp">Sudoku Solver</a></li>
                                            <li><a href="summary-statistics-calculator.jsp">Summary Statistics
                                                    Calculator (All-in-One)</a></li>
                                            <li><a href="mean-median-mode.jsp">Mean, Median, Mode Finder</a></li>
                                            <li><a href="standard-deviation.jsp">Standard Deviation Calculator</a></li>
                                            <li><a href="variance-calculator.jsp">Variance Calculator</a></li>
                                            <li><a href="outlier-detection-calculator.jsp">Outlier Detection
                                                    Calculator</a></li>
                                            <li><a href="confidence-interval-calculator.jsp">Confidence Interval
                                                    Calculator</a></li>
                                            <li><a href="p-value-calculator.jsp">P-Value Calculator</a></li>
                                            <li><a href="sample-size-calculator.jsp">Sample Size Calculator</a></li>
                                            <li><a href="correlation-calculator.jsp">Correlation Calculator</a></li>
                                            <li><a href="z-score-calculator.jsp">Z-Score Calculator</a></li>
                                            <li><a href="linear-regression-calculator.jsp">Linear Regression
                                                    Calculator</a></li>
                                            <li><a href="t-test-calculator.jsp">T-Test Calculator</a></li>
                                            <li><a href="chi-square-calculator.jsp">Chi-Square Calculator</a></li>
                                            <li><a href="anova-calculator.jsp">ANOVA Calculator</a></li>
                                            <li><a href="normal-distribution-calculator.jsp">Normal Distribution
                                                    Calculator</a></li>
                                            <li><a href="binomial-distribution-calculator.jsp">Binomial Distribution
                                                    Calculator</a></li>
                                            <li><a href="hypothesis-test-calculator.jsp">Hypothesis Test Calculator</a>
                                            </li>
                                            <li><a href="standard-error-calculator.jsp">Standard Error Calculator</a>
                                            </li>
                                            <li><a href="probability-calculator.jsp">Probability Calculator</a></li>
                                            <li><a href="percentile-calculator.jsp">Percentile Calculator</a></li>
                                            <li><a href="effect-size-calculator.jsp">Effect Size Calculator</a></li>
                                            <li><a href="pythagorean.jsp">Pythagorean Theorem Solver</a></li>
                                            <li><a href="triangle-solver.jsp">Triangle Solver (SSS/SAS/ASA)</a></li>
                                            <li><a href="right-triangle-trig.jsp">Right-Triangle Trig (SOHCAHTOA)</a>
                                            </li>
                                            <li><a href="distance-midpoint.jsp">Distance & Midpoint</a></li>
                                            <li><a href="circle-sector.jsp">Circle & Sector</a></li>
                                            <li><a href="heron-area.jsp">Heron’s Formula Area</a></li>
                                            <li><a href="degree-radian.jsp">Degrees ↔ Radians</a></li>
                                            <li><a href="polar-cartesian.jsp">Polar ↔ Cartesian</a></li>
                                            <li><a href="distance-3d.jsp">3D Distance</a></li>
                                            <li><a href="factorial-permutation.jsp">Factorial & Permutation</a></li>
                                            <li><a href="prime-number.jsp">Prime Number Checker & Generator</a></li>
                                            <li><a href="lcm-gcd.jsp">LCM/GCD Finder</a></li>
                                            <li><a href="fibonacci.jsp">Fibonacci Sequence Generator</a></li>
                                            <li><a href="percentage-calculator.jsp">Percentage Calculator</a></li>
                                            <li><a href="roman-numeral-converter.jsp">Roman Numeral Converter</a></li>
                                            <li><a href="unit-converter.jsp">Unit Converter</a></li>
                                            <li><a href="binary-code-translator.jsp">Binary Code Translator</a></li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <!-- Physics & Astronomy -->
                            <div class="card">
                                <div class="card-header" id="headingPhysics">
                                    <h6 class="mb-0">
                                        <button class="btn btn-link btn-block text-left collapsed" type="button"
                                            data-toggle="collapse" data-target="#collapsePhysics" aria-expanded="false"
                                            aria-controls="collapsePhysics">
                                            <i class="fas fa-atom"></i> Physics Tools
                                        </button>
                                    </h6>
                                </div>
                                <div id="collapsePhysics" class="collapse" aria-labelledby="headingPhysics"
                                    data-parent="#sidebarAccordion">
                                    <div class="card-body p-2">
                                        <ul class="list-unstyled mb-0 small">
                                            <li><a href="projectile-motion-simulator.jsp">Projectile Motion
                                                    Simulator</a></li>
                                            <li><a href="ohms-law-calculator.jsp">Ohm's Law & Circuit Calculator</a>
                                            </li>
                                            <li><a href="kinematics-calculator.jsp">Kinematics Equation Solver
                                                    (SUVAT)</a></li>
                                            <li><a href="momentum-collision-calculator.jsp">Momentum & Collision
                                                    Calculator</a></li>
                                            <li><a href="inclined-plane-calculator.jsp">Inclined Plane Calculator</a>
                                            </li>
                                            <li><a href="torque-rotation-calculator.jsp">Torque & Rotational
                                                    Dynamics</a></li>
                                            <li><a href="centripetal-force-calculator.jsp">Centripetal Force
                                                    Calculator</a></li>
                                            <li><a href="friction-force-calculator.jsp">Friction Force Calculator</a>
                                            </li>
                                            <li><a href="doppler-effect-calculator.jsp">Doppler Effect Calculator</a>
                                            </li>
                                            <li><a href="free-fall-calculator.jsp">Free Fall & Gravity Drop</a></li>
                                            <li><a href="wave-speed-frequency.jsp">Wave Speed & Frequency Tool</a></li>
                                            <li><a href="energy-conservation-tracker.jsp">Energy Conservation
                                                    Tracker</a></li>
                                            <li><a href="lens-mirror-ray-tracer.jsp">Lens/Mirror Ray Tracer</a></li>
                                            <li><a href="lens-mirror-calculator.jsp">Lens Equation & Mirror Formula
                                                    Calculator</a></li>
                                            <li><a href="snells-law-prism.jsp">Snell's Law & Prism Refraction</a></li>
                                            <li><a href="shm-oscillator.jsp">SHM Oscillator (Spring/Pendulum)</a></li>
                                            <li><a href="rc-rlc-filter.jsp">RC/RLC Filter Calculator</a></li>
                                            <li><a href="led-resistor-calculator.jsp">LED Resistor Calculator</a></li>
                                        </ul>
                                    </div>
                                </div>

                                <!-- Internationalization -->
                                <div class="card">
                                    <div class="card-header" id="headingI18n">
                                        <h6 class="mb-0">
                                            <button class="btn btn-link btn-block text-left collapsed" type="button"
                                                data-toggle="collapse" data-target="#collapseI18n" aria-expanded="false"
                                                aria-controls="collapseI18n">
                                                <i class="fas fa-globe"></i> Internationalization
                                            </button>
                                        </h6>
                                    </div>
                                    <div id="collapseI18n" class="collapse" aria-labelledby="headingI18n"
                                        data-parent="#sidebarAccordion">
                                        <div class="card-body p-2">
                                            <ul class="list-unstyled mb-0 small">
                                                <li><a href="punycode-converter.jsp">Punycode Converter</a></li>
                                                <li><a href="unicode-inspector.jsp">Unicode Character Inspector</a></li>
                                                <li><a href="language-detector.jsp">Language Detector</a></li>
                                                <li><a href="transliteration-tool.jsp">Transliteration Tool</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Physics Tools (New Section) -->


            <%@ include file="related-upcoming.jsp" %>

    </div>

    <script>
        (function () {
            function addIcons(containerSelector, iconClass) {
                var container = document.querySelector(containerSelector);
                if (!container) return;
                var links = container.querySelectorAll('ul li a');
                for (var i = 0; i < links.length; i++) {
                    var a = links[i];
                    if (a.querySelector('i')) continue; // skip if icon already present
                    var icon = document.createElement('i');
                    icon.className = iconClass + ' nav-icon';
                    a.insertBefore(icon, a.firstChild);
                }
            }

            // Minimal icon styling
            var style = document.createElement('style');
            style.textContent = '.sidebar-ux .nav-icon{width:1.25em;display:inline-block;margin-right:.35rem;color:#6c757d;font-size:.95em;}';
            document.head.appendChild(style);

            var map = {
                '#collapseML': 'fas fa-brain',
                '#collapseMedia': 'fas fa-photo-film',
                '#collapseSecurity': 'fas fa-shield',
                '#collapseDocs': 'fas fa-file-pdf',
                '#collapseSharing': 'fas fa-share-nodes',
                '#collapsePGP': 'fas fa-key',
                '#collapseCrypto': 'fas fa-shield-halved',
                '#collapseNetwork': 'fas fa-network-wired',
                '#collapseDevOps': 'fab fa-docker',
                '#collapseBlockchain': 'fas fa-cubes',
                '#collapseEncoders': 'fas fa-code',
                '#collapseDev': 'fas fa-code',
                '#collapseMisc': 'fas fa-toolbox',
                '#collapseFinance': 'fas fa-coins',
                '#collapseHealth': 'fas fa-heart-pulse',
                '#collapseLifeProd': 'fas fa-list-check',
                '#collapseMath': 'fas fa-calculator'
            };

            try { for (var sel in map) { addIcons(sel, map[sel]); } } catch (e) { /* no-op */ }
        })();
    </script>