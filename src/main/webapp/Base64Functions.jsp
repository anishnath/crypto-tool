<!DOCTYPE html>
<html>
<head>
<title>Online Base64  encode and decode a string</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
  <meta name="description" content="Decode from Base64 or Encode to Base64 - Here, with our simple online tool." />
  <meta name="keywords" content="base64, decode, encode, online, tool" />
  <meta name="robots" content="index, follow" />
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {

            $('#inputtext').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });


           
            
            $('#form').submit(function (event)
                    {
                    //	
                  $('#outputtext').html('<img src="images/712.GIF"> loading...');
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "StringFunctionality", //this is my servlet
                
                           data: $("#form").serialize(),
                            success: function(msg){    
                            		    $('#outputtext').empty();
                                     $('#outputtext').append(msg);
                                     
                            }
                        }); 
                    });
        });
   
    </script>
</head>
<body>
<%@ include file="include.jsp" %> 
<small><a href="http://en.wikipedia.org/wiki/Base-64">From Wiki</a> </small>
<br>
Base64 is a group of similar binary-to-text encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation. The term Base64 originates from a specific MIME content transfer encoding.
Base64 encoding schemes are commonly used when there is a need to encode binary data that needs to be stored and transferred over media that is designed to deal with textual data. This is to ensure that the data remains intact without modification during transport. Base64 is commonly used in a number of applications including email via MIME, and storing complex data in XML.
<br>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<form id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CALCULATE_BASE64">
	<br>
		<fieldset name="Online Base64 Functionality">
			<legend>
				<B><font color="blue">Online Base64  encode and decode a string </font></B>
			</legend>
			<p>Type Something</p>
			<textarea name="inputtext" id="inputtext" cols="50" rows="20" placeholder="Type Soemthing The inputetext"></textarea>
			<input type="submit" name="convert" id="convert"> 
			<textarea name="outputtext" id="outputtext" cols="50" rows="20" placeholder="outputtext"> </textarea>
		</fieldset>
		<div id="output1"> 
		<fieldset>
		<legend>Encode/Decode</legend>
		<input checked="checked" type="radio" id="encode" name="enCodeDecode" value="encode">EnCode
		<input type="radio" id="decode" name="enCodeDecode" value="decode">DeCode
		</fieldset>
		<fieldset>
		<legend>Encoding/Decoding Scheme</legend>
		<input checked="checked" type="radio" id="encoding" name="encoding" value="ASCII">ASCII
		<input type="radio" id="encoding1" name="encoding" value="UTF-8">UTF-8
		<input type="radio" id="encoding2" name="encoding" value="UTF-16">UTF-16
		<input type="radio" id="encoding4" name="encoding" value="ISO-8859-1">ISO-8859-1
		<input type="radio" id="encoding5" name="encoding" value="ISO-8859-2">ISO-8859-2
		<input type="radio" id="encoding6" name="encoding" value="ISO-8859-6">ISO-8859-6
		<input type="radio" id="encoding7" name="encoding" value="ISO-8859-15">ISO-8859-15
		<input type="radio" id="encoding8" name="encoding" value="Windows-1252">Windows-1252
		</fieldset>
		</div>
	</form>
	
   <%@ include file="footer.jsp"%>
</body>
</html>