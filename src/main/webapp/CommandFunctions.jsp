<!DOCTYPE html>
<html>
<head>

<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {
            $('#executeMethod').click(function (event)
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
                            url: "CommandFunctionality", //this is my servlet
                
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
		<input type="hidden" name="methodName" id="methodName"
			value="EXECUTECOMMAND">
		<fieldset name="Execute Command Online">
			<legend>
				<B>Execute Command Online</B>
			</legend>
			Type Command<input id="inputtext" type="text" name="text" value="" size="50">
			<input type="button" id="executeMethod" name="executeMethod"
				value="Click"> <br>
		</fieldset>
		<div id="output"></div>
	</form>
	<%@ include file="footer.jsp"%>
		</section>
		</article>
		
	</div>
</body>
</html>