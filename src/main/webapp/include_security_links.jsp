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

<p> Thanks for using this software coming from <a href="8gwifi.org">8gwifi.org  <mark>for Cofee/Beer/Amazon bill and further development of this project please suppor</mark> </p>
<p> <mark>Asking for donation sound bad to me, so i'm raising fund from my 3 crypto Book </mark> for Just  <a href="https://leanpub.com/b/crypto" target="_blank" rel="noopener"> $24</a>. No hurry read the sample chapters <a href="https://8gwifi.org/docs/pki.jsp">here</a> then decide.</p>
<p> Grab Three Cryptography book Just <a href="https://leanpub.com/b/crypto">$24 </a> </p>
<img class="img-fluid rounded" src="images/site/3book.png" height="400" width="500" alt="Referefce ">