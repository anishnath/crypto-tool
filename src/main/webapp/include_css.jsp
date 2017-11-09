<meta name="google-translate-customization" content="539d0b0d48e9e59d-6c7b8210e0d6ef34-gcd16ab911e9af611-a"></meta>
<meta name=viewport content="width=device-width, initial-scale=1">
<link rel="stylesheet" type="text/css" href="css/sidebar.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
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
<script type="text/javascript" src="//platform-api.sharethis.com/js/sharethis.js#property=5a04129f05073300123e3782&product=inline-share-buttons"></script>