<!DOCTYPE html>
<html>
<head>
   <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <title> Codecs | URLEncode |  simple URL Encoder</title>
  <meta name="description" content="Encode your URL string with this best easy to use online tool." />
  <meta name="keywords" content="keyboard, html, codes, html, codes, hash, functions, url, tld, encode, decode, what, is, a, url, ascii, code, html, character, sets, input, type, submit, hidden, reference, reset, select, text, file, upload, enctype, action, form, div, span, script, head, body, structure, web, server, client, style, css, title, tag, tags, img, class, id" /> 
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {


   
        	  $('#inputtext').click(function (event)
                      {
           			$('#form').delay(200).submit()
                      });

         	  $('#encode').click(function (event)
                      {
           			$('#form').delay(200).submit()
                      });

         	  $('#decode').click(function (event)
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

<small><a href="http://en.wikipedia.org/wiki/Percent-encoding">From Wiki</a> </small>
<br>
<b>Percent-encoding, also known as URL encoding,</b> is a mechanism for encoding information in a Uniform Resource Identifier (URI) under certain circumstances. Although it is known as URL encoding it is, in fact, used more generally within the main Uniform Resource Identifier (URI) set, which includes both Uniform Resource Locator (URL) and Uniform Resource Name (URN). As such, it is also used in the preparation of data of the application/x-www-form-urlencoded media type, as is often used in the submission of HTML form data in HTTP requests.
<br>
<br>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<form id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CALCULATE_URLENCODEDECODE">
	<br>
		<fieldset name="Online Hex String Functionality">
			<legend>
				<B><font color="blue">URL Encode/Decode </font></B>
			</legend>
			<p>Type Something and Click startConverting </p>
			<textarea name="inputtext" id="inputtext" cols="50" rows="20" placeholder="Type Soemthing The Hello+there%21"></textarea>
			<input type="submit" name="convert" id="convert" value="Start Converting"> 
			<textarea name="outputtext" id="outputtext" cols="50" rows="20" placeholder="outputtext"> </textarea>
		</fieldset>
		<div id="output1"> 
		<fieldset>
		<legend>Encode/Decode Options</legend>
		<input checked="checked" type="radio" id="encode" name="enCodeDecode" value="encode">enCodeURL
		<input type="radio" id="decode" name="enCodeDecode" value="decode">deCodeURL
		</fieldset>
		
		</div>
		<div id="output1"> 

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
	

</body>
</html>