<!DOCTYPE html>
<html>
<head>
<title>Online String to hex or Hex To String Conversion</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Online String to Hex, Hex To String Conversion">
<meta name="keywords"
	content="String to Hex Conversion,expression hex bytes in string ">
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {


        	  $('#delimiter1').click(function (event)
                      {
           			$('#form').delay(200).submit()
                      });

        	  $('#delimiter2').click(function (event)
                      {
           			$('#form').delay(200).submit()
                      });

         	  $('#delimiter').click(function (event)
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

Convert String to Hex with Different Options,<br>
Convert Hex to String
<br>
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<form id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CALCULATE_HEXSTRING">
	<br>
		<fieldset name="Online Hex String Functionality">
			<legend>
				<B><font color="blue">Convert StringToHex or HexToString </font></B>
			</legend>
			<p>Type Something and Click</p>
			<textarea name="inputtext" id="inputtext" cols="50" rows="20" placeholder="Type Soemthing The inputetext"></textarea>
			<input type="submit" name="convert" id="convert" value="Start Converting"> 
			<textarea name="outputtext" id="outputtext" cols="50" rows="20" placeholder="outputtext"> </textarea>
		</fieldset>
		<div id="output1"> 
		<fieldset>
		<legend>Encode/Decode Options</legend>
		<input checked="checked" type="radio" id="encode" name="enCodeDecode" value="encode">StringToHex
		<input type="radio" id="decode" name="enCodeDecode" value="decode">HexToString
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
		<fieldset>
		<legend>Add(StringToHex) Delimiter to Output</legend>
		<input checked="checked" type="radio" id="delimiter" name="delimiter" value="">Nothing
		<input type="radio" id="delimiter1" name="delimiter" value=" ">SPACE
		<input type="radio" id="delimite2" name="delimiter" value=":">:(Colon)
		</fieldset>
		</div>
	</form>
	

</body>
</html>