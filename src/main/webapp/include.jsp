<%

    String uAgent = request.getHeader("User-Agent");
    if(uAgent!=null && ( !uAgent.contains("Android") && ( !uAgent.contains("iPhone") ) ))
    {

%>

<header id="sidebar">
    <h1>The Online Tool for <br>Online</br> People</h1>
    <div id="google_translate_element"></div>


    <script src='https://www.google.com/recaptcha/api.js'></script>


    <nav role="navigation">
        <ul>Cryptography</ul>
        <li><a href="MessageDigest.jsp"><font size="2.5px">Generate Message Digest</font></a></li>
        <li><a href="hmacgen.jsp"><font size="2.5px">Generate HMAC</font></a></li>
        <li><a href="CipherFunctions.jsp"><font size="2.5px">Encryption/Decryption</font> </a></li>
        <li><a href="rsafunctions.jsp"><font size="2.5px">RSA Encryption/Decryption</font> </a></li>
        <li><a href="ntrufunctions.jsp"><font size="2.5px">Lattice Cryptography Encryption</font> </a></li>
        <li><a href="dsafunctions.jsp"><font size="2.5px">DSA Keygen,Sign File,Verify Sig</font> </a></li>
        <li><a href="ecfunctions.jsp"><font size="2.5px">Elliptic Curve Encryption/Decryption </font> </a></li>
        <li><a href="elgamalfunctions.jsp"><font size="2.5px">ELGAMAL Encryption/Decryption</font> </a></li>
        <li><a href="pbe.jsp"><font size="2.5px">PBE (PBKDF) Encryption/Decryption </font> </a></li>
        <li><a href="pgpencdec.jsp"><font size="2.5px">PGP Encryption/Decryption </font> </a></li>
        <li><a href="pgpkeyfunction.jsp"><font size="2.5px">PGP Key Generation </font> </a></li>
        <li><a href="PGPFunctionality?invalidate=yes"><font size="2.5px">PGP Signature Verifier </font> </a></li>
        <li><a href="bccrypt.jsp"><font size="2.5px">BCrypt Password Hash </font> </a></li>
        <li><a href="scrypt.jsp"><font size="2.5px">SCrypt Password Hash </font> </a></li>
        <li><a href="DHFunctions.jsp"><font size="2.5px">Diffie-Hellman Key Exchange</font> </a></li>
        <li><a href="PemParserFunctions.jsp"><font size="2.5px">PEMReader Decode Certificate </font></a></li>
        <li><a href="pempasswordfinder.jsp"><font size="2.5px">Encrypted PEM password finder</font></a></li>
        <li><a href="passwdgen.jsp"><font size="2.5px">Strong Random Passwd Generator</font> </a></li>
        <li><a href="SelfSignCertificateFunctions.jsp"><font size="2.5px">Generate Self Sign Certificate </font> </a></li>
        <li><a href="cafunctions.jsp"><font size="2.5px">Generate rootCA/InterCA/Certs</font> </a></li>
        <li><a href="certsverify.jsp"><font size="2.5px">Verify private key against csr,x509</font> </a></li>
        <li><a href="ocsp.jsp"><font size="2.5px">Online OCSP query</font> </a></li>
        <li><a href="signcsr.jsp"><font size="2.5px">Sign CSR</font> </a></li>
        <li><a href="sshfunctions.jsp"><font size="2.5px">SSH-Keygen</font> </a></li>
        <li><a href="JKSManagementFunctionality?invalidate=yes"><font size="2.5px">Easy Keystore/trustore viewer</font> </a></li>
        <li><a href="samlfunctions.jsp"><font size="2.5px">SAML Sign Message</font> </a></li>
        <li><a href="samlverifysign.jsp"><font size="2.5px">SAML Verify Sign / Others</font> </a></li>
        <li><a href="jwkfunctions.jsp"><font size="2.5px">JSON Web Key (JWK) Generate</font> </a></li>
        <li><a href="jwkconvertfunctions.jsp"><font size="2.5px">JWK to PEM Convert</font> </a></li>
        <ul>Network Functions</ul>
        <li><a href="SubnetFunctions.jsp"><font size="2.5px">IP Subnet CIDR Calculator</font></a></li>
        <li><a href="pingfunctions.jsp"><font size="2.5px">Ping/Locate IPv4/Iv6  </font></a></li>
        <li><a href="curlfunctions.jsp"><font size="2.5px">Curl/DNS Query IPv4/IPv6</font></a></li>
        <ul>Encoders/Decoders</ul>
        <li><a href="UrlEncodeDecodeFunctions.jsp"><font size="2.5px">URL Encoders/Decoders</font></a></li>
        <li><a href="HexToStringFunctions.jsp"><font size="2.5px">HexToString Conversion</font></a></li>
        <li><a href="HexToStringFunctions.jsp"><font size="2.5px">StringToHex Conversion</font></a></li>
        <li><a href="Base64Functions.jsp"><font size="2.5px">Base64 Encode/Decode</font></a></li>
        <li><a href="StringFunctions.jsp"><font size="2.5px">Various String Functions</font></a></li>


        <ul> Feature Request Coming Soon!!! </ul>
            <li><a href="contactus.jsp">Send Feature Request here</a></li>
            <li><font size="2.5px">Blockchain keygen signature gen & verify  </font></li>
            <li><font size="2.5px">OPenssl Key Managenet UI</font></li>
            <li><font size="2.5px">TLS Checker</font></li>
            <li><font size="2.5px">iptables rule to firewalld geneator</font></li>
            <li><font size="2.5px">htpassword generator</font></li>
            <li><font size="2.5px">File Encryption & decryption</font></li>
            <li><a href="CipherFunctions.jsp"><font size="2.5px">UI Improvement (currently only two UI is improved)</font></a></li>



    </nav>
    <% }

    else {  %>

    <%}  %>

</header>

<%@ include file="addStatsCounter.jsp" %>
