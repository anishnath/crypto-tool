<!-- 
<b> click for </b> <br>
<a href="SelfSignCertificateFunctions.jsp">Create X509 Certificate</a>&nbsp;&nbsp;
<a href="PemParserFunctions.jsp">Decode Certificates</a>&nbsp;&nbsp;
<a href="Base64Functions.jsp">Base64</a>&nbsp;&nbsp;
<a href="CipherFunctions.jsp">Encryptions/Decryptions</a>&nbsp;&nbsp;
<a href="ProviderCapablitiesFunctions.jsp">Providers Capability</a>&nbsp;&nbsp;
<a href="MessageDigest.jsp">Message Digest</a>&nbsp;&nbsp;
<a href="DHFunctions.jsp">DH</a>&nbsp;&nbsp;

 -->

<%

 String pAgent = request.getHeader("User-Agent");
 if(pAgent!=null && ( pAgent.contains("Android") || ( pAgent.contains("iPhone") ) ))
 {

%>

Back to Main Page <a href="mobilelinks.jsp"> Crypto Links </a>
<%}%>
<br>
<b>Any private key value that you enter or we generate is not stored on this site, this tool is provided via an HTTPS URL to ensure that private keys cannot be stolen, for extra security <a href="https://goo.gl/forms/y6xGIfC3kxPTFims2" target="_blank" rel="noopener" >run </a> this software on your network, no cloud dependency</b>
