<!DOCTYPE html>
<html>
<head>
<title>Online HMAC Generator Hash based Message Authentication</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="free online tool compute a HMAC using your desired algorithm PBEWithHmacSHA1,PBEWithHmacSHA384,PBEWithHmacSHA256,PBEWithHmacSHA512,HmacSHA1,HmacSHA384,HmacSHA224,HmacSHA256,HmacMD5,HmacPBESHA1,HMACRIPEMD128,IDEAMAC,RC2MAC,HMACRIPEMD160,DES,DESEDEMAC,SKIPJACKMAC,HMACTIGER,tiger "/>
<meta name="keywords"
	content="online hmac generate, hmac online, hmac PBEWithHmacSHA1,PBEWithHmacSHA384,PBEWithHmacSHA256,PBEWithHmacSHA512,HmacSHA1,HmacSHA384,HmacSHA224,HmacSHA256,HmacMD5,HmacPBESHA1,HMACRIPEMD128,IDEAMAC,RC2MAC,HMACRIPEMD160,DES,DESEDEMAC,SKIPJACKMAC,HMACTIGER,tiger, ripemd128 ripemd160 ripemd256 ripemd320 sha sha-1 sha-224 sha-256 sha-384 sha-512 tiger whirlpool, digest algorithm online">
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {
            $('#PBEWithHmacSHA1').click(function (event)
            {
 			$('#form').delay(200).submit()
            });

            $('#inputtext').keyup(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#passphrase').keyup(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#PBEWithHmacSHA384').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });
            $('#PBEWithHmacSHA256').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#PBEWithHmacSHA512').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#HmacSHA1').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });
            $('#HmacSHA384').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#HmacSHA224').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#HmacSHA256').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#HmacMD5').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#HmacPBESHA1').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#HMACRIPEMD128').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#RC2MAC').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#IDEAMAC').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#HMACRIPEMD160').click(function (event)
            {
                $('#form').delay(200).submit()
            });

            $('#SKIPJACKMAC').click(function (event)
                    {
         			$('#form').delay(200).submit()
                    });

            $('#HMACTIGER').click(function (event)
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
	<input type="hidden" name="methodName" id="methodName" value="GENERATE_HMAC">
		<fieldset name="Calculate HMAC...">
			<legend>
				<B>HMAC Generator </B>
			</legend>
			Msg<input id="inputtext" type="text" name="text" placeholder="Type Mesage Here..." value="" size="100" >
				<br>
            Key<input id="passphrase" type="text" name="passphrase" value="" placeholder="Type secret key Here..." size="100" >
        </fieldset>
        <fieldset><legend>Choose Algo</legend>
            <input type="checkbox" checked="checked" id="HMACTIGER" value="HMACTIGER" name="HMACTIGER">TIGER
            <input type="checkbox" id="HmacSHA1" value="HmacSHA1" name="HmacSHA1">SHA-1
            <input type="checkbox" id="HmacSHA224" value="HmacSHA224" name="HmacSHA224">SHA-224
            <input type="checkbox" id="HmacSHA256" value="HmacSHA256" name="HmacSHA256">SHA-256
            <input type="checkbox" id="RC2MAC" value="RC2MAC" name="RC2MAC">RC2
            <input type="checkbox" id="IDEAMAC" value="IDEAMAC" name="IDEAMAC">IDEA
            <input type="checkbox"  id="PBEWithHmacSHA1" value="PBEWithHmacSHA1" name="MD2">PBEWithHmacSHA1
            <input type="checkbox" id="PBEWithHmacSHA384" value="PBEWithHmacSHA384" name="PBEWithHmacSHA384">PBE-SHA384
            <input type="checkbox" id="PBEWithHmacSHA256" value="PBEWithHmacSHA256" name="PBEWithHmacSHA256">PBE-SHA256
            <input type="checkbox" id="PBEWithHmacSHA512" value="PBEWithHmacSHA512" name="PBEWithHmacSHA512">PBE-SHA512
            <input type="checkbox" id="HMACRIPEMD128" value="HMACRIPEMD128" name="HMACRIPEMD128">RIPEMD128
            <input type="checkbox" id="HMACRIPEMD160" value="HMACRIPEMD160" name="HMACRIPEMD160">RIPEMD160
            <input type="checkbox" id="SKIPJACKMAC" value="SKIPJACKMAC" name="SKIPJACKMAC">SKIPJACK
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