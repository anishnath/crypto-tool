<!DOCTYPE html>
<html>
<head>
<title>Online Cipher Algorithms, Encrytion Decryption Online</title>
<meta content='text/html; charset=UTF-8' http-equiv='Content-Type'>
<meta name="description" content="Calculate Online Cipher  Algorithms">
<meta name="keywords"
	content="AES/CBC/NoPadding,AES/CBC/PKCS5Padding ,AES/ECB/NoPadding,AES/ECB/PKCS5Padding,DES/CBC/NoPadding 
	DES/CBC/PKCS5Padding,DES/ECB/NoPadding ,DES/ECB/PKCS5Padding,DESede/CBC/NoPadding,DESede/CBC/PKCS5Padding ">
<%@ include file="include_css.jsp" %> 
<script type="text/javascript">
        $(document).ready(function() {

        	 $('#plaintext').keyup(function (event)
        	            {
        	            //	
        	           // event.preventDefault();
        	 			$('#form').delay(200).submit()
        	            });
	            
            $('#encrypt').click(function (event)
            {
 			$('#form').delay(200).submit()
            });

            $('#decrypt').click(function (event)
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
                            url: "CipherFunctionality", //this is my servlet
                
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
	<div id="loading" style="display: none;">
		<img src="images/712.GIF" alt="" />Loading!
	</div>
	<form id="form" method="POST">
	<input type="hidden" name="methodName" id="methodName" value="CIPHERBLOCK">
		<fieldset name="Cipher Functionality">
			<legend>
				<B>Encrypt/Decrypt Message </B>
			</legend>
			Plain text Type Something
			<textarea rows="10" cols="30" name="plaintext" id="plaintext"></textarea>
		
				<br>
				SecretKey<input id="secretkey" type="text" name="secretkey"
				value="TheSecretKey" >
				<input checked="checked" id="encrypt" type="radio" name="encryptorDecrypt" value="encrypt">Encrypt
				<input id="decrypt" type="radio" name="encryptorDecrypt" value="decrypt">Decrypt
				<br>
				<fieldset>
				<label>Choose Standard Cipher transformations with the keysizes in parentheses:</label>
				<br>
				<!-- <input checked="checked" id="cipherparameter" type="radio" name="cipherparameter" value="AES/CBC/NoPadding">AES/CBC/NoPadding (128) -->
				<input checked="checked" id="cipherparameter" type="radio" name="cipherparameter" value="AES/CBC/PKCS5Padding">AES/CBC/PKCS5Padding (128)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="AES/ECB/NoPadding">AES/ECB/NoPadding (128)<br>
				<input id="cipherparameter" type="radio" name="cipherparameter" value="AES/ECB/PKCS5Padding">AES/ECB/PKCS5Padding (128)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DES/CBC/NoPadding">DES/CBC/NoPadding (56)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DES/CBC/PKCS5Padding">DES/CBC/PKCS5Padding (56)<br>
				
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DES/ECB/NoPadding">DES/ECB/NoPadding (56)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DES/ECB/PKCS5Padding">DES/ECB/PKCS5Padding (56)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DESede/CBC/NoPadding">DESede/CBC/NoPadding (168)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DESede/CBC/PKCS5Padding">DESede/CBC/PKCS5Padding (168)<br>
				
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DESede/ECB/NoPadding">DESede/ECB/NoPadding (168)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="DESede/ECB/PKCS5Padding">DESede/ECB/PKCS5Padding  (168)<br>
				<!-- <input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/PKCS1Padding">RSA/ECB/PKCS1Padding (1024, 2048)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-1AndMGF1Padding">RSA/ECB/OAEPWithSHA-1AndMGF1Padding (1024, 2048)<br>
				<input  id="cipherparameter" type="radio" name="cipherparameter" value="RSA/ECB/OAEPWithSHA-256AndMGF1Padding">RSA/ECB/OAEPWithSHA-256AndMGF1Padding (1024, 2048)<br> -->
				</fieldset>
		</fieldset>
		<div id="output"></div>
	</form>
	

</body>
</html>