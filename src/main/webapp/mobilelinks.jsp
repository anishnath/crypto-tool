<%

    String mAgent = request.getHeader("User-Agent");
    if(mAgent!=null && ( mAgent.contains("Android") || ( mAgent.contains("iPhone") ) ))
    {

%>
        <ul>Cryptography</ul>
        <li><a href="MessageDigest.jsp"><font size="3px">Generate Message Digest</font></a></li>
        <li><a href="hmacgen.jsp"><font size="2.5px">Generate HMAC</font></a></li>
        <li><a href="CipherFunctions.jsp"><font size="3px">Encryption/Decryption </font> </a></li>
        <li><a href="bccrypt.jsp"><font size="3px">BCrypt Calculator/Tester </font> </a></li>
        <li><a href="pbe.jsp"><font size="3px">PBE Encryption/Decryption </font> </a></li>
        <li><a href="pgpencdec.jsp"><font size="2.5px">PGP Encryption/Decryption </font> </a></li>
        <li><a href="pgpkeyfunction.jsp"><font size="3px">PGP Key Generation </font> </a></li>
        <li><a href="PGPFunctionality?invalidate=yes"><font size="3px">PGP Signature Verifier </font> </a></li>
        <li><a href="rsafunctions.jsp"><font size="3px">RSA Encryption/Decryption </font> </a></li>
        <li><a href="ecfunctions.jsp"><font size="2.5px">Elliptic Curve Encryption/Decryption </font> </a></li>
        <li><a href="DHFunctions.jsp"><font size="3px">Diffie-Hellman Key Exchange</font> </a></li>
        <li><a href="PemParserFunctions.jsp"><font size="3px">PEMReader Decode Certificate </font></a></li>
        <li><a href="SelfSignCertificateFunctions.jsp"><font size="3px">Generate Self Sign Certificate </font> </a></li>
        <li><a href="cafunctions.jsp"><font size="3px">Generate rootCA/InterCA/Certs</font> </a></li>
        <li><a href="JKSManagementFunctionality?invalidate=yes"><font size="3px">Easy Keystore/trustore viewer</font> </a></li>
        <li><a href="ProviderCapablitiesFunctions.jsp"><font size="3px">Get Algorithm Capabilities </font></a></li>
        <ul>Network Functions</ul>
        <li><a href="SubnetFunctions.jsp"><font size="3px">IP Subnet CIDR Calculator</font></a></li>
        <li><a href="pingfunctions.jsp"><font size="3px">Ping/Locate IPv4/Iv6  </font></a></li>
        <li><a href="curlfunctions.jsp"><font size="3px">Site Reachablity IPv4/IPv6 DNS Query </font></a></li>
        <ul>Encoders/Decoders</ul>
        <li><a href="UrlEncodeDecodeFunctions.jsp"><font size="3px">URL Encoders/Decoders</font></a></li>
        <li><a href="HexToStringFunctions.jsp"><font size="3px">HexToString Conversion</font></a></li>
        <li><a href="HexToStringFunctions.jsp"><font size="3px">StringToHex Conversion</font></a></li>
        <li><a href="Base64Functions.jsp"><font size="3px">Base64 Encode/Decode</font></a></li>
        <li><a href="StringFunctions.jsp"><font size="3px">Various String Functions</font></a></li></span>
        <ul>Donate </ul>
        <li>
            <%@ include file="payme.jsp" %>
        </li>
        <li><a href="contactus.jsp">Feature Request</a></li>
    <% }

    %>
