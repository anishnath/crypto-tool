<meta name="google-translate-customization" content="539d0b0d48e9e59d-6c7b8210e0d6ef34-gcd16ab911e9af611-a"></meta>
<meta name=viewport content="width=device-width, initial-scale=1">

<%

	String userAgent = request.getHeader("User-Agent");
	if(userAgent!=null && ( userAgent.contains("Android") || userAgent.contains("iPhone") ) )
	{

%>
<link rel="stylesheet" type="text/css" href="css/sidebar_mobile.css">

<% }  else {  %>
<link rel="stylesheet" type="text/css" href="css/sidebar.css">
<%}%>
<script src="js/jquery.min.js"></script>
	<script>
	$(document).ready(function() {
		
		//GET BROWSER WINDOW HEIGHT
		var currHeight = $(window).height();
		$('#sidebar, #content').css('height', currHeight);
		
		//ON RESIZE OF WINDOW
		$(window).resize(function() {
			
			//GET NEW HEIGHT
			var currHeight = $(window).height();	
			//RESIZE BOTH ELEMENTS TO NEW HEIGHT
			$('#sidebar, #content').css('height', currHeight);
			
		});
		
	});
	</script>
<script type="text/javascript" src="/js/sharethis.js#property=5a04129f05073300123e3782&product=inline-share-buttons"></script>
For Coffee/beer/Amazon Bills further development of the project, Grab <a href="http://leanpub.com/crypto/c/NPsT3TZmqrNS" target="_blank" rel="noopener"> The Modern Cryptography CookBook for Just $9 </a>,  <a href="/crypto/rest/application.wadl">Use REST API </a>   ,  <a href="https://8gwifi.org/docs/" >Tech Blog </a> , <a href="contactus.jsp">ContactUs</a>