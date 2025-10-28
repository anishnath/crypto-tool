<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Sidebar with Collapsible Sections -->
<!-- Font Awesome (for icons in sidebar) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
  /* Scoped sidebar usability improvements */
  .sidebar-ux .card { margin-bottom: 0.75rem; }
  .sidebar-ux .card-header { padding: .5rem .75rem; }
  .sidebar-ux .card-header .btn { font-size: 1rem; font-weight: 600; color: #333; }
  .sidebar-ux .card-header .btn.btn-link { text-decoration: none; }
  .sidebar-ux .card-header .btn i { margin-right: .5rem; }
  /* Clear visual indicator for expand/collapse */
  .sidebar-ux .card-header .btn[aria-expanded="true"]::after { content: "▾"; float: right; color: #6c757d; }
  .sidebar-ux .card-header .btn[aria-expanded="false"]::after { content: "▸"; float: right; color: #6c757d; }
  /* Make list items more readable and tappable */
  .sidebar-ux .card-body { padding: .25rem .5rem; }
  .sidebar-ux ul { margin: 0; }
  .sidebar-ux ul li { margin: 0; }
  .sidebar-ux ul li a {
    display: block;
    padding: .35rem .5rem;
    border-radius: 4px;
    font-size: .95rem; /* bump from .875rem used by .small */
    color: #212529;
  }
  .sidebar-ux ul li a:hover { background: #f1f3f5; text-decoration: none; }
  /* Override Bootstrap .small in this sidebar only */
  .sidebar-ux .small { font-size: .95rem; }
</style>
<div class="col-lg-3 col-md-4 sidebar-ux">

    <!-- Ad Widget -->
    <%@ include file="footer_adsense.jsp"%>

    <!-- Quick Links -->
    <div class="card my-4">
        <h5 class="card-header">Quick Access</h5>
        <div class="card-body">
            <div class="accordion" id="sidebarAccordion">

                <!-- Machine Learning Visualizers -->
                <div class="card">
                    <div class="card-header" id="headingML">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseML" aria-expanded="false" aria-controls="collapseML">
                                <i class="fas fa-robot"></i> Machine Learning Visualizers
                            </button>
                        </h6>
                    </div>
                    <div id="collapseML" class="collapse" aria-labelledby="headingML" data-parent="#sidebarAccordion">
                        <div class="card-body p-2">
                            <ul class="list-unstyled mb-0 small">
                                <li><a href="activation_function_explorer.jsp">Activation Function Explorer</a></li>
                                <li><a href="bias_variance_explorer.jsp">Bias-Variance Explorer</a></li>
                                <li><a href="bias_variance_tradeoff.jsp">Bias-Variance Trade-off</a></li>
                                <li><a href="clustering_studio.jsp">Clustering Studio</a></li>
                                <li><a href="decision_boundary_playground.jsp">Decision Boundary Playground</a></li>
                                <li><a href="decision_tree_model_selection.jsp">Decision Tree Model Selection</a></li>
                                <li><a href="decision_trees_random_forest.jsp">Decision Trees & Random Forest</a></li>
                                <li><a href="diffusion_process_visualizer.jsp">Diffusion Process Visualizer</a></li>
                                <li><a href="gradient_descent_visualizer.jsp">Gradient Descent Visualizer</a></li>
                                <li><a href="imbalanced_learning_workshop.jsp">Imbalanced Learning Workshop</a></li>
                                <li><a href="Logistic_Regression.jsp">Logistic Regression</a></li>
                                <li><a href="ML_Pipeline.jsp">ML Pipeline</a></li>
                                <li><a href="neural_network_playground.jsp">Neural Network Playground</a></li>
                                <li><a href="probability_calibration_lab.jsp">Probability Calibration Lab</a></li>
                                <li><a href="ROC_AUC.jsp">ROC AUC</a></li>
                                <li><a href="shap_explorer.jsp">SHAP Explorer</a></li>
                                <li><a href="cyclical_encoding_visualizer.jsp">Cyclical Encoding Visualizer</a></li>
                                <li><a href="feature_hashing_collision_explorer.jsp">Feature Hashing Collision Explorer</a></li>
                                <li><a href="categorical_encoding_lab.jsp">Categorical Encoding Lab</a></li>
                                <li><a href="predicted_probability_explorer.jsp">Predicted Probability Explorer</a></li>
                                <li><a href="model_validation_lab.jsp">Model Validation Lab</a></li>
                                <li><a href="transformers_attention_visualizer.jsp">Transformers Attention Visualizer</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

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
                                <li><a href="steganography-tool.jsp">Steganography Tool</a></li>
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
                                <li><a href="argon2.jsp">Argon2 Password Hash</a></li>
                                <li><a href="totp-hotp.jsp">TOTP/HOTP 2FA Generator</a></li>
                                <li><a href="htpasswd.jsp">.htpasswd Generator</a></li>
                                <li><a href="DHFunctions.jsp">Diffie-Hellman Key Exchange</a></li>
                                <li><a href="PemParserFunctions.jsp">PEM Parser/Decoder</a></li>
                                <li><a href="asn1-decoder.jsp">ASN.1 Decoder</a></li>
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
                                <li><a href="jwt-debugger.jsp">JWT Debugger & Validator</a></li>
                                <li><a href="security-headers-checker.jsp">Security Headers Checker</a></li>
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
                                <li><a href="vpc-calculator.jsp">VPC Network Calculator</a></li>
                                <li><a href="SubnetFunctions.jsp">IP Subnet Calculator</a></li>
                                <li><a href="pingfunctions.jsp">Ping/Locate IPv4/IPv6</a></li>
                                <li><a href="curlfunctions.jsp">Curl IPv4/IPv6</a></li>
                                <li><a href="ipv6-tool.jsp">IPv6 Compressor & Expander</a></li>
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
                                <li><a href="prometheus-query-builder.jsp">Prometheus Query Builder</a></li>
                                <li><a href="curl-builder.jsp">cURL Builder & HTTP Client</a></li>
                                <li><a href="cron-generator.jsp">Cron Expression Generator</a></li>
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
                                <li><a href="bip39-mnemonic.jsp">BIP39 Mnemonic Generator</a></li>
                                <li><a href="crypto-profit-calculator.jsp">Crypto Profit Calculator</a></li>
                                <li><a href="bitcoin-mining-profit-calculator.jsp">Bitcoin Mining Profit Calculator</a></li>
                                <li><a href="ethereum-gas-fee-estimator.jsp">Ethereum Gas Fee Estimator</a></li>
                                <li><a href="crypto-tax-estimator.jsp">Crypto Tax Estimator</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Internationalization -->
                <div class="card">
                    <div class="card-header" id="headingI18n">
                        <h6 class="mb-0">
                            <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseI18n" aria-expanded="false" aria-controls="collapseI18n">
                                <i class="fas fa-globe"></i> Internationalization
                            </button>
                        </h6>
                    </div>
                    <div id="collapseI18n" class="collapse" aria-labelledby="headingI18n" data-parent="#sidebarAccordion">
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
                                <li><a href="image-resizer.jsp">Image Resizer</a></li>
                                <li><a href="video-resizer.jsp">Video Resizer & Cropper</a></li>
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
                                <li><a href="invoice-generator.jsp">Invoice Generator</a></li>
                                <li><a href="merge-pdf.jsp">Merge PDF Files</a></li>
                                <li><a href="split-pdf.jsp">Split PDF</a></li>
                                <li><a href="compress-pdf.jsp">Compress PDF</a></li>
                                <li><a href="pdf-to-images.jsp">PDF to Images</a></li>
                                <li><a href="watermark-pdf.jsp">Add WaterMark PDF</a></li>
                                <li><a href="short.jsp">URL Shortener & Analytics</a></li>
                                <li><a href="qrcodegen.jsp">QR Code Generate</a></li>
                                <li><a href="hexdump.jsp">Hexdump Generate</a></li>
                                <li><a href="diff.jsp">Compare Text Diff</a></li>
                                <li><a href="regex.jsp">Regex Tester</a></li>
                                <li><a href="random-string.jsp">Random Number Gen</a></li>
                                <li><a href="contactus.jsp">Feature Request</a></li>
                                <li><a href="binary-code-translator.jsp">Binary Code Translator</a></li>
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
                                <li><a href="sip-calculator.jsp">SIP Calculator</a></li>
                                <li><a href="sip-vs-lumpsum-calculator.jsp">SIP vs Lumpsum Calculator</a></li>
                                <li><a href="retirement-calculator.jsp">Retirement Planning Calculator</a></li>
                                <li><a href="fire-calculator.jsp">FIRE Calculator</a></li>
                                <li><a href="net-worth-calculator.jsp">Net Worth Calculator & Tracker</a></li>
                                <li><a href="tax-calculator.jsp">Income Tax Calculator</a></li>
                                <li><a href="emi.jsp">Home Loan EMI Calculator</a></li>
                                <li><a href="mortgage-affordability-calculator.jsp">Mortgage Affordability Calculator</a></li>
                                <li><a href="prepay-vs-invest-calculator.jsp">Prepay vs Invest Calculator</a></li>
                                <li><a href="debt-payoff-calculator.jsp">Debt Payoff Calculator</a></li>
                                <li><a href="lease-vs-buy-calculator.jsp">Lease vs Buy Calculator</a></li>
                                <li><a href="college-cost-roi-calculator.jsp">College Cost & ROI Calculator</a></li>
                                <li><a href="rent-vs-buy-calculator.jsp">Rent vs Buy Calculator</a></li>
                                <li><a href="capital-gains-tax-calculator.jsp">Capital Gains Tax Calculator</a></li>
                                <li><a href="cost-of-living-comparison.jsp">Cost of Living Comparison</a></li>
                                <li><a href="cinterest2.jsp">Compound Interest (Compare)</a></li>
                                <li><a href="cinterest.jsp">Compound Interest (Simple)</a></li>
                                <li><a href="drip-calculator.jsp">Dividend Reinvestment (DRIP) Calculator</a></li>
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
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseHealth" aria-expanded="false" aria-controls="collapseHealth">
                                    <i class="fas fa-heartbeat"></i> Health
                                </button>
                            </h6>
                        </div>
                        <div id="collapseHealth" class="collapse" aria-labelledby="headingHealth" data-parent="#sidebarAccordion">
                            <div class="card-body p-2">
                                <ul class="list-unstyled mb-0 small">
                                    <li><a href="bmi-ideal-weight-calculator.jsp">BMI & Ideal Weight Calculator</a></li>
                                    <li><a href="calorie-macro-calculator.jsp">Daily Calorie & Macro Calculator</a></li>
                                    <li><a href="ovulation-calculator.jsp">Ovulation & Fertility Window</a></li>
                                    <li><a href="pregnancy-due-date-calculator.jsp">Pregnancy Due Date Planner</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Lifestyle & Productivity -->
                    <div class="card">
                        <div class="card-header" id="headingLifeProd">
                            <h6 class="mb-0">
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseLifeProd" aria-expanded="false" aria-controls="collapseLifeProd">
                                    <i class="fas fa-utensils"></i> Lifestyle & Productivity
                                </button>
                            </h6>
                        </div>
                        <div id="collapseLifeProd" class="collapse" aria-labelledby="headingLifeProd" data-parent="#sidebarAccordion">
                            <div class="card-body p-2">
                                <ul class="list-unstyled mb-0 small">
                                    <li><a href="mind-map-maker.jsp">Mind Map Maker (Online)</a></li>
                                    <li><a href="tip-calculator.jsp">Tip Calculator & Split Bill</a></li>
                                    <li><a href="timezone-converter.jsp">Time Zone Converter & Scheduler</a></li>
                                    <li><a href="unix-timestamp-converter.jsp">Unix Timestamp Converter</a></li>
                                    <li><a href="age-calculator.jsp">Age Calculator & Milestone Tracker</a></li>
                                    <li><a href="qr-code-generator.jsp">QR Code Generator</a></li>
                                    <li><a href="date-difference-calculator.jsp">Date Difference Calculator</a></li>
                                    <li><a href="random-number-generator.jsp">Random Number Generator</a></li>
                                    <li><a href="morse-code-translator.jsp">Morse Code Translator</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <!-- Math & Education -->
                    <div class="card">
                        <div class="card-header" id="headingMath">
                            <h6 class="mb-0">
                                <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseMath" aria-expanded="false" aria-controls="collapseMath">
                                    <i class="fas fa-percentage"></i> Math & Education
                                </button>
                            </h6>
                        </div>
                        <div id="collapseMath" class="collapse" aria-labelledby="headingMath" data-parent="#sidebarAccordion">
                            <div class="card-body p-2">
                                <ul class="list-unstyled mb-0 small">
                                    <li><a href="graphing-calculator.jsp">Graphing Calculator</a></li>
                                    <li><a href="latex-equation-editor.jsp">LaTeX Equation Editor </a></li>
                                    <li><a href="tikz-viewer.jsp">TikZ Viewer & Editor</a></li>
                                    <li><a href="image-resizer.jsp">Image Resizer</a></li>
                                    <li><a href="guitar-chord-finder.jsp">Guitar Chord Finder</a></li>
                                    <li><a href="kaprekar.jsp">Kaprekar's Constant (6174)</a></li>
                                    <li><a href="addition-methods.jsp">Addition Methods Visualizer</a></li>
                                    <li><a href="magic-1089.jsp">Magic 1089 Trick</a></li>
                                    <li><a href="21-card-trick.jsp">21 Card Trick</a></li>
                                    <li><a href="mean-median-mode.jsp">Mean, Median, Mode Finder</a></li>
                                    <li><a href="standard-deviation.jsp">Standard Deviation Calculator</a></li>
                                    <li><a href="pythagorean.jsp">Pythagorean Theorem Solver</a></li>
                                    <li><a href="triangle-solver.jsp">Triangle Solver (SSS/SAS/ASA)</a></li>
                                    <li><a href="right-triangle-trig.jsp">Right-Triangle Trig (SOHCAHTOA)</a></li>
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
                </div>


            </div>
        </div>
    </div>

    <%@ include file="related-upcoming.jsp"%>

</div>

<script>
  (function() {
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
      '#collapseSharing': 'fas fa-share-nodes',
      '#collapsePGP': 'fas fa-key',
      '#collapseCrypto': 'fas fa-shield-halved',
      '#collapseNetwork': 'fas fa-network-wired',
      '#collapseDevOps': 'fab fa-docker',
      '#collapseBlockchain': 'fas fa-cubes',
      '#collapseEncoders': 'fas fa-code',
      '#collapseMisc': 'fas fa-toolbox',
      '#collapseFinance': 'fas fa-coins',
      '#collapseHealth': 'fas fa-heart-pulse',
      '#collapseLifeProd': 'fas fa-list-check',
      '#collapseMath': 'fas fa-calculator'
    };

    try {
      for (var sel in map) { addIcons(sel, map[sel]); }
    } catch (e) { /* no-op */ }
  })();
</script>
