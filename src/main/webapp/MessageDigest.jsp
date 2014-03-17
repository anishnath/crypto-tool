<!DOCTYPE html>
<html>
<head>
<title>Online Message Digest Algorithms</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Calculate Online Message Digest Algorithms">
<meta name="keywords"
	content="MD2,MD5,SHA-1,SHA-256, SHA-384, and SHA-512">
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {
            $('#SHA').click(function (event)
            {
 			$('#form').delay(200).submit()
            });

            $('#MD2').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });
            $('#MD5').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#SHA-1').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#SHA-256').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });
            $('#SHA-384').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#SHA-512').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });
            
            $('#form').submit(function (event)
                    {
                    //	
                  $('#output').html('<img src="images/712.GIF"> loading...');
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "MDFunctionality", //this is my servlet
                
                           data: $("#form").serialize(),
                            success: function(msg){    
                            		    $('#output').empty();
                                     $('#output').append(msg);
                                     
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
	<input type="hidden" name="methodName" id="methodName" value="CALCULATE_MD">
		<fieldset name="Message Digest Functionality">
			<legend>
				<B>Get Message Digest Information </B>
			</legend>
			Type Something<input id="inputtext" type="text" name="text"
				value="" >
				<br>
				<input type="checkbox" id="MD2" value="MD2" name="MD2">MD2
				<input type="checkbox" id="MD5" value="MD5" name="MD5">MD5
				<input type="checkbox" id="SHA" value="SHA" name="SHA">SHA
				<input type="checkbox" id="SHA-1" value="SHA-1" name="SHA-1">SHA-1
				<input type="checkbox" id="SHA-256" value="SHA-256" name="SHA-256">SHA-256
				<input type="checkbox" id="SHA-384" value="SHA-384" name="SHA-384">SHA-384
				<input type="checkbox" id="SHA-512" value="SHA-512" name="SHA-512">SHA-512
		</fieldset>
		<div id="output"></div>
	</form>
	<%@ include file="include_security_links.jsp"%>	
	<%@ include file="footer.jsp"%>
		</section>
		</article>

</div>
</body>
</html>