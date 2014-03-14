<ul class="slimmenu">
    <li>
        <a href="#">Online Cryptography</a>
        <ul>

            <li><a href="MessageDigest.jsp">Calculate MD5 </a></li>
            <li><a href="Base64Functions.jsp">Base64 Encode/Decode</a></li>
            <li><a href="CipherFunctions.jsp">Encryption/Decryption </a></li>
            <li><a href="ProviderCapablitiesFunctions.jsp">Get Algorithm Capabilities </a></li>
            <li><a href="PemParserFunctions.jsp">PEMReader Decode Certificate Type (crl,crt,csr,pem,privatekey,publickey,rsa,dsa,rsa publickey) </a></li>
            <li><a href="SelfSignCertificateFunctions.jsp">Create a Self Sign Certificate </a></li>
        </ul>
    </li>
         <li><a href="UrlEncodeDecodeFunctions.jsp">Online Codecs</a>
             <ul>
            <li>
                <a href="UrlEncodeDecodeFunctions.jsp">URL Encoders/Decoders</a>

            </li>
            <li>
                <a href="HexToStringFunctions.jsp">HexToString/StringToHex Conversion</a>
            </li>
             <li>
                <a href="Base64Functions.jsp">Base64 Encode/Decode</a>
            </li>
        </ul></li>
            <li>
        <a href="#">Online String Functions</a>
        <ul>
            <li>
                <a href="StringFunctions.jsp">String Functions</a>

            </li>
            <li>
                <a href="HexToStringFunctions.jsp">HexToString/StringToHex Conversion</a>

            </li>
        </ul>
    </li>
    <li><a href="NetworkFunctions.jsp">Online NetworkTool</a></li>

    <li><a href="CommandFunctions.jsp">Online Command Line tool</a></li>

</ul>

<script src="js/jquery.slimmenu.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-easing/1.3/jquery.easing.min.js"></script>
<script>
$('ul.slimmenu').slimmenu(
{
    resizeWidth: '800',
    collapserTitle: 'Main Menu',
    easingEffect:'easeInOutQuint',
    animSpeed:'medium',
    indentChildren: true,
    childrenIndenter: '&raquo;'
});
</script>
<br>
<div><h1>The Online Tool for Online People</h1></div>
<br>
<%@ include file="addStatsCounter.jsp" %> 
<div id="google_translate_element"></div><script type="text/javascript">
function googleTranslateElementInit() {
  new google.translate.TranslateElement({pageLanguage: 'en', layout: google.translate.TranslateElement.InlineLayout.SIMPLE}, 'google_translate_element');
}
</script><script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>