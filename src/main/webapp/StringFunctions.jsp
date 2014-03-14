<!DOCTYPE html>
<html>
<head>
<title>Online String functions </title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description"
	content="Online String functions, String to UpperCase,Lowercase,trim,replace white characters, substring,indexOf,lastIndexOff,Miscellaneous String utility meth">
<meta name="keywords"
	content="online string functions,trim,lastIndexOf,indexOf,substring,ignore white space,Miscellaneous String utility methods,Uncapitalize a String, changing the first letter to lower case ,Trim trailing whitespace from the given String,Trim all whitespace from the given String: leading, trailing, and in between characters,Tokenize the given String into a String array via a StringTokenizer,Capitalize a String, changing the first letter to upper case,Delete all occurrences of the given substring.">
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {
            $('#lengthOfString').keyup(function (event)
            {
            //	
           // event.preventDefault();
 			$('#form').delay(200).submit()
            });

            $('#trimTrailingWhitespace').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#trimLeadingWhitespace').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#trimWhitespace').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            
            $('#beginIndex').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#endIndex').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#indexOf').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#lastindexOf').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#lastindexOffromIndex').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#indexOffromIndex').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#toLowerCase').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#toUpperCase').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });
            
            $('#checkbox').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit()

                    });

            $('#checkbox1').click(function (event)
                    {
                    //	
         			$('#form').delay(200).submit();

                    });

            $('#oldChar').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit();

                    });

            $('#newChar').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit();

                    });

            //ReplaceAll
                        $('#regex').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit();

                    });

            $('#replacement').keyup(function (event)
                    {
                    //	
         			$('#form').delay(200).submit();

                    });

            $('#form').submit(function (event)
                    {
                    //	
         			 event.preventDefault();
                        $.ajax({
                            type: "POST",
                            url: "StringFunctionality", //this is my servlet
                           // data: "lengthOfString=" +$('#lengthOfString').val()+"&trimignore="+$('#trimignore').val()+"&methodName="+$('#methodName').val(),
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
<%@ include file="include.jsp" %> 
	<form id="form" method="POST">
		<fieldset name="String Functionality">
			<legend>
				<B>String Functionality </B>
			</legend>
			<label for="lengthOfString">Type Something:</label> <input
				id="lengthOfString" name="lengthOfString" type="text" value="">
			<input id="checkbox1" type="checkbox" name="trim" value="trim"
				checked="checked">TRIM <input id="checkbox" type="checkbox"
				name="ignore" value="ignore">trimAllWhiteSpace <input
				type="hidden" id="methodName" name="methodName"
				value="calculateLength"> &nbsp; <input id="toLowerCase"
				type="checkbox" name="toLowerCase" value="toLowerCase">toLowerCase<br>
			&nbsp;
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input id="toUpperCase" type="checkbox" name="toUpperCase"
				value="toUpperCase">toUpperCase 
			
			<input id="trimWhitespace"
				type="checkbox" name="trimWhitespace" value="trimWhitespace">trimWhitespace

			<input id="trimLeadingWhitespace" type="checkbox"
				name="trimLeadingWhitespace" value="trimLeadingWhitespace">trimLeadingWhitespace

			<input id="trimTrailingWhitespace" type="checkbox"
				name="trimTrailingWhitespace" value="trimTrailingWhitespace">trimTrailingWhitespace

			<br> <br>
			<fieldset name="String IndexOf">
				<legend>
					<B>String IndexOf </B>
				</legend>
				<label for="indexOf">indexOfString:</label><input type="text"
					id="indexOf" name="indexOf" value=""> &nbsp; <label
					for="indexOf">fromIndex:</label><input type="text"
					id="indexOffromIndex" name="indexOffromIndex" value=""> <br>
			</fieldset>
			<fieldset name="String LastIndexOf">
				<legend>
					<B>String LastIndexOf </B>
				</legend>
				<label for="lastindexOf">lastIndexOf:</label> <input type="text"
					id="lastindexOf" name="lastindexOf" value="">
				&nbsp;&nbsp;&nbsp;&nbsp;<label for="lastindexOf">fromIndex:</label>
				<input type="text" id="lastindexOffromIndex"
					name="lastindexOffromIndex" value=""> <br>
			</fieldset>
			<fieldset name="String Replace Functionality">
				<legend>
					<B>String Replace </B> <br>
				</legend>
				<label for="replace">oldChar:</label> <input type="text"
					id="oldChar" name="oldChar" value="" size="50"> &nbsp; <label
					for="lastindexOf">newChar:</label>&nbsp; <input type="text"
					id="newChar" name="newChar" value="" size="50">

			</fieldset>

			<fieldset name="String ReplaceAll Functionality">
				<legend>
					<B>String ReplaceAll </B> <br>
				</legend>
				<label for="replaceAll">regex:</label> <input type="text" id="regex"
					name="regex" value="" size="50"> &nbsp; <label for="regex">replacement:</label>&nbsp;
				<input type="text" id="replacement" name="replacement" value=""
					size="50">

			</fieldset>

			<fieldset name="Substring">
				<legend>
					<B>Substring </B>
				</legend>
				<label for="beginIndex">beginIndex:</label> <input type="text"
					id="beginIndex" name="beginIndex" value=""><small>int</small>
				&nbsp;&nbsp;&nbsp;&nbsp;<label for="endIndex">endIndex:</label> <input
					type="text" id="endIndex" name="endIndex" value=""><small>int</small>
				<br>
			</fieldset>
			<div id="output"></div>
		</fieldset>
	</form>
<%@ include file="footer.jsp"%>
</body>
</html>