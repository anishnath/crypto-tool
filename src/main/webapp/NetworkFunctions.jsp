<!DOCTYPE html>
<html>
<head>
<title>Online Network Utility functions</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Online network utility functions,">
<meta name="keywords"
	content="network utility, ipaddresses,loopback addresses">
	<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {
            $('#lengthOfString').keyup(function (event)
            {
            //	
           // event.preventDefault();
 			$('#form').delay(200).submit()
            });

            $('#buttonPingipaddress').click(function (event)
                    {
                
                $('#pingipaddressOutput').html('<img src="images/712.GIF"> loading...');
    			 event.preventDefault();
                   $.ajax({
                       type: "POST",
                       url: "NetworkFunctionality", //this is my servlet
                      // data: "lengthOfString=" +$('#lengthOfString').val()+"&trimignore="+$('#trimignore').val()+"&methodName="+$('#methodName').val(),
                      data: $("#pingipaddressform").serialize(),
                       success: function(msg){    
                       		    $('#pingipaddressOutput').empty();
                                $('#pingipaddressOutput').append(msg);
                                
                       }
                   }); 

                });

               

            $('#getClientIpAddr').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            

            $('#form').submit(function (event)
                    {
                    //	
                  $('#getClientIpAddrOutput').html('<img src="images/712.GIF"> loading...');
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "NetworkFunctionality", //this is my servlet
                           // data: "lengthOfString=" +$('#lengthOfString').val()+"&trimignore="+$('#trimignore').val()+"&methodName="+$('#methodName').val(),
                           data: $("#form").serialize(),
                            success: function(msg){    
                            		    $('#getClientIpAddrOutput').empty();
                                     $('#getClientIpAddrOutput').append(msg);
                                     
                            }
                        }); 
                    });
        });
   
    </script>
</head>
<body>
<div id="page">
<%@ include file="include.jsp" %> 

	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<article id="contentWrapper" role="main">
			<section id="content">
	<form id="form" method="POST">
	<input type="hidden" name="hiddengetClientIpAddr" id="hiddengetClientIpAddr" value="hiddengetClientIpAddr">
		<fieldset name="Network Functionality">
			<legend>
				<B>Get Network Information </B>
			</legend>
			<input id="getClientIpAddr" type="checkbox" name="getClientIpAddr"
				value="getClientIpAddr">getClientIpAddr
		</fieldset>
		<div id="getClientIpAddrOutput"></div>
	</form>
	<form id="pingipaddressform" method="POST">
	<input type="hidden" name="hiddenPingipaddress" id="hiddenPingipaddress" value="hiddenPingipaddress">
		<fieldset name="Network Functionality">
			<legend>
				<B>PING IP Address </B>
			</legend>
			Type IP Address<input id="pingipaddress" type="text" name="ipaddress"
				value="">
				<input type="button" id="buttonPingipaddress" name="buttonPingipaddress" value="Click"> 
				<div id="pingipaddressOutput"></div>
		</fieldset>
		
	</form>
<%@ include file="footer.jsp"%>
</section>
		</article>
		
	</div>
</body>
</html>